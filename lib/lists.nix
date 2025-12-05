let
  lib = (import <nixpkgs> {}).lib;
in {
  max = list: builtins.foldl' (a: b: lib.trivial.max a b) 0 list;

  sum = list: builtins.foldl' builtins.add 0 list;

  allEqual = list: builtins.all (x: x == builtins.elemAt list 0) list;
}
