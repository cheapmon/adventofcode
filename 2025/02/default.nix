let
  lib = (import <nixpkgs> {}).lib;

  # Ranges
  genRange = lo: hi: builtins.genList (i: i + lo) (hi - lo + 1);

  # Math
  mod = a: b: a - (a / b) * b;
  dividers = num: let
    half = num / 2;
    divides = i: (mod num i) == 0;
    list = builtins.genList (x: x + 1) half;
  in
    builtins.filter divides list;

  # Split strings into segments of equal length
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

  # All elements equal
  allEqual = list: builtins.all (x: x == builtins.elemAt list 0) list;

  # Part 1
  isInvalid1 = num: let
    str = builtins.toJSON num;
    len = builtins.stringLength str;
    mid = len / 2;
    left = builtins.substring 0 mid str;
    right = builtins.substring mid mid str;
  in
    len > 1 && left == right;

  # Part 2
  isInvalid2 = num: let
    str = builtins.toJSON num;
    strLen = builtins.stringLength str;
    d = dividers strLen;
    segmented = builtins.map (i: splitIntoEqualSegments str i) d;
  in
    builtins.any (x: x) (builtins.map allEqual segmented);

  # Data
  input = builtins.readFile ./input.txt;
  nums = let
    segments = lib.strings.splitString "," input;
    ranges = builtins.map (segment: builtins.map lib.strings.toInt (lib.strings.splitString "-" segment)) segments;
    nums = builtins.map (r: genRange (builtins.elemAt r 0) (builtins.elemAt r 1)) ranges;
  in
    builtins.foldl' (acc: item: acc ++ item) [] nums;

  # Results
  one = builtins.foldl' builtins.add 0 (builtins.filter isInvalid1 nums);
  two = builtins.foldl' builtins.add 0 (builtins.filter isInvalid2 nums);
in {
  inherit one two;
}
