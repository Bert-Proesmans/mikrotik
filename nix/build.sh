# USE: ./build.sh --attr build.init-script

nix-build \
	"./modules/default.nix" \
	--argstr configuration "$(realpath ./example-RB750Gr3.nix)" \
	--arg pkgs "import <nixpkgs> {}" \
	"$@"
