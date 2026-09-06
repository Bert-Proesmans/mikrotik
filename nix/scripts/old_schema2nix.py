def _generate_args(builder, target_cmd):
	"""Generates the attributes mapping for a specific ROS command."""
	for arg_name, arg_data in target_cmd.items():
		if arg_name in ["_type", "numbers"]:
			continue # Skip metadata and ROS internal references

		# Handle Nix syntax conflicts (e.g., using 'enable' instead of 'disabled')
		if arg_name == "disabled":
			builder.line(
					'enable = lib.mkOption { '
					'type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); '
					'default = "_UNSPECIFIED_"; '
					'description = "Inverts ROS disabled flag. Null translates to explicit removal."; '
					'};'
			)

		base_type = ros_to_nix_type(arg_name, arg_data)
		nix_type = f'lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr {base_type})'
		desc = arg_data.get("desc", "").replace('"', '\\"')

		builder.line(
			f'"{arg_name}" = lib.mkOption {{ '
			f'type = {nix_type}; '
			f'default = "_UNSPECIFIED_"; '
			f'description = "{desc}"; '
			f'}};'
		)

def generate_nix_options(builder, schema, path_prefix=""):
	"""Recursively parses the JSON schema to generate Nix options."""
	for key, node in schema.items():
			if not isinstance(node, dict):
					continue

			node_type = node.get("_type")
			if node_type not in ["dir", "path"]:
					continue

			# Determine if this is a collection (has 'add') or singleton (has 'set' but no 'add')
			has_add = "add" in node and node["add"].get("_type") == "cmd"
			has_set = "set" in node and node["set"].get("_type") == "cmd"

			target_cmd = None
			is_collection = False

			if has_add:
					target_cmd = node["add"]
					is_collection = True
			elif has_set:
					target_cmd = node["set"]

			if target_cmd:
					full_path = f"{path_prefix}.{key}" if path_prefix else key
					with builder.block(f"{key} = lib.mkOption {{"):
							if is_collection:
									with builder.block("type = lib.types.attrsOf (lib.types.submodule {", "});"):
											with builder.block("options = {"):
													builder.line(
															'stub = lib.mkOption { '
															'type = lib.types.either (lib.types.enum [ "_UNSPECIFIED_" ]) (lib.types.nullOr lib.types.bool); '
															'default = "_UNSPECIFIED_"; '
															'description = "If true, use \'set\' instead of \'add\' to modify an existing item."; '
															'};'
													)
													_generate_args(builder, target_cmd)
							else:
									with builder.block("type = lib.types.submodule {"):
											with builder.block("options = {"):
													_generate_args(builder, target_cmd)

							builder.line("default = {};")
							builder.line(f'description = "Configuration for /{full_path.replace(".", "/")}";')
					builder.line()

			# Recurse into subdirectories
			next_prefix = f"{path_prefix}.{key}" if path_prefix else key
			generate_nix_options(builder, node, path_prefix=next_prefix)

def _generate_nix_module(schema):
    """Wraps the generated options and script builder in a standard Nix module."""
    b = NixBuilder()

    b.line("{ config, lib, pkgs, ... }:")
    b.line()
    with b.block("let", ""):
        b.line('unspecified = "_UNSPECIFIED_";')
        b.line()
        b.line("# Helper to convert Nix values to RouterOS parameter strings")
        with b.block("toRosVal = val:", ""):
            b.line('if builtins.isBool val then (if val then "yes" else "no")')
            b.line('else if builtins.isString val then "\\\"${val}\\\""')
            b.line('else builtins.toString val;')
        b.line()
        b.line("# Build a sequence of property strings: key=\"value\"")
        with b.block("buildProps = attrs:", ""):
            with b.block("let", "in"):
                b.line("# Map our custom 'enable' backwards to ROS 'disabled'")
                b.line("mappedAttrs = ")
                b.line("  if attrs ? enable && attrs.enable != unspecified ")
                b.line("  then (builtins.removeAttrs attrs [\"enable\"]) // { disabled = if attrs.enable == null then null else !attrs.enable; } ")
                b.line("  else attrs;")
                b.line()
                b.line("# Drop defaults/sentinels entirely")
                b.line('filtered = lib.filterAttrs (k: v: v != unspecified && k != "stub" && k != "name") mappedAttrs;')
            b.line("lib.concatStringsSep \" \" (lib.mapAttrsToList (k: v: ")
            b.line("  if v == null then \"!${k}\" # Explicit null maps to RouterOS unset syntax")
            b.line("  else \"${k}=${toRosVal v}\"")
            b.line(") filtered);")
        b.line()
        b.line("# Core script generator")
        with b.block("buildScript = cfg: path:", ""):
            with b.block("if builtins.isAttrs cfg then", "else \"\";"):
                with b.block('lib.concatStringsSep "\\n" (lib.mapAttrsToList (name: item:', ") cfg)"):
                    with b.block("let", "in"):
                        b.line("isStub = item ? stub && item.stub != unspecified && item.stub != null && item.stub;")
                    with b.block("if isStub", ""):
                        b.line("then \"/${path} set [find name=\\\"${name}\\\"] ${buildProps item}\"")
                        b.line("else \"/${path} add name=\\\"${name}\\\" ${buildProps item}\"")

    with b.block("in {"):
        with b.block("options = {"):
            generate_nix_options(b, schema)

        with b.block("config = {"):
            b.line("# Expose the final generated RouterOS script")
            with b.block("build.rscScript = ''", "'';"):
                b.line("# Generated by NixOS-to-RouterOS Compiler")
                b.line("# Warning: Do not edit manually!")
                b.line()
                b.line("# Interfaces")
                b.line("${buildScript config.interface \"interface\"}")
                b.line("${buildScript config.interface.bridge \"interface bridge\"}")
                b.line("${buildScript config.interface.pppoe-client \"interface pppoe-client\"}")
                b.line()
                b.line("# IP Configuration")
                b.line("${buildScript config.ip.pool \"ip pool\"}")
                b.line("${buildScript config.ip.dhcp-server \"ip dhcp-server\"}")
                b.line("${buildScript config.ip.address \"ip address\"}")
                b.line("${buildScript config.ip.dhcp-client \"ip dhcp-client\"}")
                b.line()
                b.line("# TODO: Register additional parsed dynamic module paths here...")

    return b.build()

def get_cmd_args(cmd_node):
    """Extract argument properties from a command node."""
    if not isinstance(cmd_node, dict):
        return {}
    return {k: v for k, v in cmd_node.items() if isinstance(v, dict) and v.get("_type") == "arg"}

def generate_nix_options(node_name, node, level=2):
    """Recursively generate Nix options for a given JSON node."""
    indent = "  " * level

    # Filter sub-directories and commands
    sub_dirs = {k: v for k, v in node.items() if isinstance(v, dict) and v.get("_type") in ("dir", "path")}
    cmds = {k: v for k, v in node.items() if isinstance(v, dict) and v.get("_type") == "cmd"}

    add_args = get_cmd_args(cmds.get("add", {}))
    safe_name = sanitize_nix_key(node_name)

    res = []

    # Check if this node is meant to be a list of unnamed elements
    # Heuristic: it has an 'add' command but lacks a 'name' property.
    is_list = bool(add_args) and "name" not in add_args and node_name != "interface"

    if is_list:
        res.append(f"{indent}{safe_name} = lib.mkOption {{")
        res.append(f"{indent}  description = \"Configuration for {node_name}\";")
        res.append(f"{indent}  default = [];")
        res.append(f"{indent}  type = lib.types.listOf (lib.types.submodule {{")
        res.append(f"{indent}    options = {{")

        for arg_name, arg_data in add_args.items():
            desc = arg_data.get("desc", "").replace('"', '\\"').replace('\n', ' ')
            desc_str = f'\n{indent}      description = "{desc}";' if desc else ""
            res.append(f"{indent}      {sanitize_nix_key(arg_name)} = lib.mkOption {{ type = lib.types.nullOr lib.types.anything; default = null;{desc_str} }};")

        res.append(f"{indent}    }};")
        res.append(f"{indent}  }});")
        res.append(f"{indent}}};")
        return "\n".join(res)

    # Otherwise, it's a path/directory that might contain submodules and/or named attributes
    res.append(f"{indent}{safe_name} = lib.mkOption {{")
    res.append(f"{indent}  description = \"Configuration for {node_name}\";")
    res.append(f"{indent}  default = {{}};")
    res.append(f"{indent}  type = lib.types.submodule {{")

    if add_args:
        res.append(f"{indent}    # Allows defining named instances like: {safe_name}.\"name\" = {{ ... }}")
        res.append(f"{indent}    freeformType = lib.types.attrsOf (lib.types.submodule {{")
        res.append(f"{indent}      options = {{")

        for arg_name, arg_data in add_args.items():
            if arg_name == "name":
                continue # 'name' becomes the attribute set key implicitly
            desc = arg_data.get("desc", "").replace('"', '\\"').replace('\n', ' ')
            desc_str = f'\n{indent}        description = "{desc}";' if desc else ""
            res.append(f"{indent}        {sanitize_nix_key(arg_name)} = lib.mkOption {{ type = lib.types.nullOr lib.types.anything; default = null;{desc_str} }};")

        # For virtual properties like "default-stub" or "bridge-port" mentioned in the example
        res.append(f"{indent}        \"default-stub\" = lib.mkOption {{ type = lib.types.nullOr lib.types.bool; default = null; }};")
        res.append(f"{indent}        \"bridge-port\" = lib.mkOption {{ type = lib.types.nullOr lib.types.str; default = null; }};")

        res.append(f"{indent}      }};")
        res.append(f"{indent}    }});")

    # Generate nested paths/directories
    res.append(f"{indent}    options = {{")
    for sub_name, sub_node in sub_dirs.items():
        res.append(generate_nix_options(sub_name, sub_node, level + 3))
    res.append(f"{indent}    }};")

    res.append(f"{indent}  }};")
    res.append(f"{indent}}};")

    return "\n".join(res)
