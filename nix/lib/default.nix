{ lib }: {
  builders = import ./builders.nix { inherit lib; };
  units = import ./units.nix { inherit lib; };
  # Directed asyclic graph
  dag = import ./dag.nix { inherit lib; };
  options = import ./options.nix { inherit lib; };
}
