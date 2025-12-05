let
  lib = (import <nixpkgs> {}).lib;
in {
  splitString = sep: s: let
    isPresent = s: (lib.stringLength s) > 0;
    list = lib.splitString sep s;
  in
    lib.filter isPresent list;
}
