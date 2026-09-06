# MIT License

# Copyright (c) 2017-2026 Home Manager contributors

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# A generalization of Nixpkgs's `strings-with-deps.nix`.
#
# The main differences from the Nixpkgs version are
#
#  - not specific to strings, i.e., any payload is OK,
#
#  - the addition of the function `entryBefore` indicating a "wanted
#    by" relationship.

{ lib }:
let
  inherit (lib)
    all
    attrNames
    attrValues
    elem
    filter
    head
    isAttrs
    mapAttrs
    mkOrder
    length
    tail
    types
    toposort
    mkIf
    mkOption
    ;
  inherit (lib.types)
    submodule
    mkOptionType
    defaultFunctor
    attrsOf
    listOf
    str
    ;

  empty = { };

  isEntry = e: e ? data && e ? after && e ? before;
  isDag = dag: isAttrs dag && all isEntry (attrValues dag);

  # Takes an attribute set containing entries built by entryAnywhere,
  # entryAfter, and entryBefore to a topologically sorted list of
  # entries.
  #
  # Internally this function uses the `toposort` function in
  # `<nixpkgs/lib/lists.nix>` and its value is accordingly.
  #
  # Specifically, the result on success is
  #
  #    { result = [ { name = ?; data = ?; } … ] }
  #
  # For example
  #
  #    nix-repl> topoSort {
  #                a = entryAnywhere "1";
  #                b = entryAfter [ "a" "c" ] "2";
  #                c = entryBefore [ "d" ] "3";
  #                d = entryBefore [ "e" ] "4";
  #                e = entryAnywhere "5";
  #              } == {
  #                result = [
  #                  { data = "1"; name = "a"; }
  #                  { data = "3"; name = "c"; }
  #                  { data = "2"; name = "b"; }
  #                  { data = "4"; name = "d"; }
  #                  { data = "5"; name = "e"; }
  #                ];
  #              }
  #    true
  #
  # And the result on error is
  #
  #    {
  #      cycle = [ { after = ?; name = ?; data = ? } … ];
  #      loops = [ { after = ?; name = ?; data = ? } … ];
  #    }
  #
  # For example
  #
  #    nix-repl> topoSort {
  #                a = entryAnywhere "1";
  #                b = entryAfter [ "a" "c" ] "2";
  #                c = entryAfter [ "d" ] "3";
  #                d = entryAfter [ "b" ] "4";
  #                e = entryAnywhere "5";
  #              } == {
  #                cycle = [
  #                  { after = [ "a" "c" ]; data = "2"; name = "b"; }
  #                  { after = [ "d" ]; data = "3"; name = "c"; }
  #                  { after = [ "b" ]; data = "4"; name = "d"; }
  #                ];
  #                loops = [
  #                  { after = [ "a" "c" ]; data = "2"; name = "b"; }
  #                ];
  #              }
  #    true
  topoSort =
    let
      before = a: b: elem a.name b.after;
    in
    dag:
    let
      names = attrNames dag;
      dagBefore = name: filter (n: elem name dag.${n}.before) names;
      normalizedDag = mapAttrs (n: v: {
        name = n;
        inherit (v) data;
        after = v.after ++ dagBefore n;
      }) dag;
      sorted = toposort before (attrValues normalizedDag);
    in
    if sorted ? result then
      {
        result = map (v: { inherit (v) name data; }) sorted.result;
      }
    else
      sorted;

  # Applies a function to each element of the given DAG.
  mapDag = f: mapAttrs (n: v: v // { data = f n v.data; });

  entryBetween = before: after: data: { inherit data before after; };

  # Create a DAG entry with no particular dependency information.
  entryAnywhere = entryBetween [ ] [ ];

  entryAfter = entryBetween [ ];
  entryBefore = before: entryBetween before [ ];

  # Given a list of entries, this function places them in order within the DAG.
  # Each entry is labeled "${tag}-${entry index}" and other DAG entries can be
  # added with 'before' or 'after' referring these indexed entries.
  #
  # The entries as a whole can be given a relation to other DAG nodes. All
  # generated nodes are then placed before or after those dependencies.
  entriesBetween =
    tag:
    let
      go =
        i: before: after: entries:
        if entries == [ ] then
          empty
        else
          let
            name = "${tag}-${toString i}";
          in
          if length entries == 1 then
            {
              "${name}" = entryBetween before after (head entries);
            }
          else
            {
              "${name}" = entryAfter after (head entries);
            }
            // go (i + 1) before [ name ] (tail entries);
    in
    go 0;

  entriesAnywhere = tag: entriesBetween tag [ ] [ ];
  entriesAfter = tag: entriesBetween tag [ ];
  entriesBefore = tag: before: entriesBetween tag before [ ];

  dagEntryOf =
    elemType:
    let
      submoduleType = submodule (
        { name, ... }:
        {
          options = {
            data = mkOption { type = elemType; };
            after = mkOption { type = listOf str; };
            before = mkOption { type = listOf str; };
          };
          config = mkIf (elemType.name == "submodule") {
            data._module.args.dagName = name;
          };
        }
      );
      maybeConvert =
        def:
        if isEntry def.value then
          def.value
        else
          entryAnywhere (if def ? priority then mkOrder def.priority def.value else def.value);
    in
    mkOptionType {
      name = "dagEntryOf";
      description = "DAG entry of ${elemType.description}";
      # leave the checking to the submodule type
      merge =
        loc: defs:
        submoduleType.merge loc (
          map (def: {
            inherit (def) file;
            value = maybeConvert def;
          }) defs
        );
    };

  # A directed acyclic graph of some inner type.
  #
  # Note, if the element type is a submodule then the `name` argument
  # will always be set to the string "data" since it picks up the
  # internal structure of the DAG values. To give access to the
  # "actual" attribute name a new submodule argument is provided with
  # the name `dagName`.
  dagOf =
    elemType:
    let
      name = "dagOf";
      attrEquivalent = attrsOf (dagEntryOf elemType);
    in
    mkOptionType {
      inherit name;
      description = "DAG of ${elemType.description}";
      inherit (attrEquivalent) check merge emptyValue;
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ [ "<name>" ]);
      inherit (elemType) getSubModules;
      substSubModules = m: dagOf (elemType.substSubModules m);
      functor = (defaultFunctor name) // {
        wrapped = elemType;
      };
      nestedTypes.elemType = elemType;
    };
in
{
  inherit
    topoSort
    dagOf
    entryAnywhere
    entryAfter
    entryBefore
    ;
}
