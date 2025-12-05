let
  lib = (import <nixpkgs> {}).lib;
in {
  splitString = sep: s: let
    isPresent = s: (lib.stringLength s) > 0;
    list = lib.splitString sep s;
  in
    lib.filter isPresent list;

  splitIntoEqualSegments = str: len: let
    strLen = builtins.stringLength str;
    index = 0;
    list = [];
    inner = str: len: index: list: let
      nextIndex = index + len;
      nextList = list ++ [(builtins.substring index len str)];
    in
      if index == strLen
      then list
      else (inner str len nextIndex nextList);
  in
    inner str len index list;
}
