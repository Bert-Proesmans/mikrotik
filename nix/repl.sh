nix repl \
	--file "./modules/default.nix" \
	--argstr configuration "$(realpath ./example-RB750Gr3.nix)" \
	--arg pkgs "import <nixpkgs> {}" \
	"$@"
