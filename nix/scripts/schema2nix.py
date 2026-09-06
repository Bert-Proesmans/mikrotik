#! /usr/bin/env nix
#! nix shell --impure --expr ``
#! nix with (import <nixpkgs> {});
#! nix python3.withPackages (ps: with ps; [ ])
#! nix ``
#! nix --command python3

from contextlib import contextmanager
import json
import re
import sys

lines: list[str] = []
indent: int = 0
step_indent: int = 2

def eprint(*args, **kwargs):
		print(*args, file=sys.stderr, **kwargs)

def indent_increase():
	global indent, step_indent
	indent += step_indent

def indent_decrease():
	global indent, step_indent
	indent -= step_indent

def line(text):
	global lines, indent
	lines.append(" " * indent + (text or ""))

def sanitize_nix_key(name):
	"""Sanitize keys for Nix so that reserved words or dashes are quoted."""
	if not re.match(r'^[a-zA-Z_][a-zA-Z0-9_]*$', name) or name in ('let', 'list', 'import', 'in', 'if', 'then', 'else'):
		return f'"{name}"'
	return name

def ros_to_nix_type(arg_name, arg_data):
	"""Maps RouterOS argument schema to a base Nix type."""
	desc = arg_data.get("desc", "")
	if arg_name == "disabled":
		return "lib.types.bool"
	if "time interval" in desc:
		return "lib.types.str"
	if "IP address" in desc:
		return "lib.types.str"
	if "MAC address" in desc:
		return "lib.types.str"
	return "lib.types.str"

@contextmanager
def block(open = None, close = None):
	"""Context manager for automatically indenting/dedenting blocks."""
	if open:
		line(open)
	indent_increase()
	yield
	indent_decrease()
	if close:
		line(close)

def generate_nix_module(node):
	line("{ config, lib, pkgs, ... }:")

	with block("let", "in"):
		line("inherit (lib) mkOption;")
		line("inherit (lib.types) submodule attrsOf str;")
		line("inherit (lib.ros.builders) buildScript;")

	# NOTE; Toplevel commands are skipped because they are imperative commands, not useful for declarative configuration.
	sub_options = {k:v for k,v in node.items() if v.get("_type") != "cmd"}
	with block("{", "}"), block("options = {", "};"):
		for name, contents in sub_options.items():
			transform_options(name, contents)

def transform_options(name, node):
	name = sanitize_nix_key(name)
	description = node.get("desc", "")

	sub_options = {k:v for k,v in node.items() if isinstance(v, dict) and v.get("_type") in ("dir", "path")}
	attributes = get_node_concept_attributes(node)
	has_add = "add" in node and node["add"].get("_type") == "cmd"
	has_set = "set" in node and node["set"].get("_type") == "cmd"
	is_collection = has_add
	is_modifiable = has_add or has_set

	with block(name + ' = mkOption {', '};'):
		line(f'description = {json.dumps(description)};')
		line('default = {};')
		if attributes:
			line_open = 'type = submodule ({config, ...}: {'
			if is_collection:
				line_open = 'type = attrsOf submodule ({config, ...}: {'
			with block(line_open, '});'), block('options = {', '};'):
				for attribute_name, attribute_info in attributes.items():
					if attribute_name == "disabled":
						attribute_name = "enable"
						attribute_info["desc"] = "Inverted ROS disabled flag. Setting to false explicitly removes this value from the device config"
					attribute_name = sanitize_nix_key(attribute_name)
					with block(attribute_name + ' = mkOption {', '};'):
						description = attribute_info.get("desc", "")
						line(f'description = {json.dumps(description)};')
						line('default = null;')
						attribute_type = ros_to_nix_type(attribute_name, attribute_info)
						line(f'type = {attribute_type};')
				if is_modifiable:
					with block('_create = mkOption {', '};'):
						line('description = "Creation script";')
						line('internal = true;')
						line('readOnly = true;')
						line('type = lib.types.str;')
						# line(f'default = "# " + {json.dumps(name)};')
						line('default = buildScript config')

		else:
			with block('type = submodule {', '};'), block('options = {', '};'):
				for name, contents in sub_options.items():
					transform_options(name, contents)

def get_node_concept_attributes(node):
	attributes = {}
	if node.get("_type") != 'dir':
		return attributes

	add_attributes = node.get("add", {})
	if add_attributes.get("_type") == 'cmd':
		attributes |= add_attributes

	set_attributes = node.get("set", {})
	if set_attributes.get("_type") == 'cmd':
		attributes |= set_attributes

	attributes.pop("_type", None)
	return attributes

if __name__ == "__main__":
	if len(sys.argv) < 2:
			eprint("Usage: python schema2nix.py <schema.json> > mikrotik-modules.nix")
			sys.exit(1)

	with open(sys.argv[1], 'r') as f:
			schema = json.load(f)

	try:
		generate_nix_module(schema)
		print("\n".join(lines))
	except:
		raise

