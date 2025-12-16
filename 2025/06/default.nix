let
  lib = import <nixpkgs/lib>;
  strings = import ../../lib/strings.nix;
  lists = import ../../lib/lists.nix;

  # Helpers
  tryToInt = str: let
    trimmed = lib.strings.trim str;
    e = builtins.tryEval (lib.strings.toInt trimmed);
    result =
      if e.success
      then e.value
      else trimmed;
  in
    result;
  transpose = data: let
    indices = lib.range 0 ((lib.length (lib.elemAt data 0)) - 1);
  in
    lib.map (i: lib.map (list: lib.elemAt list i) data) indices;

  # Part 1
  solve1 = list: let
    nums = lib.init list;
    op = lib.last list;
    f =
      if op == "+"
      then builtins.add
      else if op == "*"
      then builtins.mul
      else null;
    nul =
      if op == "+"
      then 0
      else if op == "*"
      then 1
      else null;
  in
    lib.foldl f nul nums;
  problems = let
    data = lib.map (line: lib.map tryToInt (strings.splitString " " line)) lines;
  in
    transpose data;

  # Part 2
  solve2 = list: let
    strs = lib.init list;
    op = lib.trim (lib.last list);
    nul =
      if op == "+"
      then 0
      else if op == "*"
      then 1
      else null;
    maxLen = lists.max (lib.map lib.stringLength strs);
    indices = lib.reverseList (lib.range 0 (maxLen - 1));
    toString = list: let
      s = lib.trim (lib.join "" list);
      i = builtins.tryEval (lib.toInt s);
      r =
        if i.success
        then i.value
        else nul;
    in
      r;
    problem = (lib.map (i: toString (lib.map (str: lib.substring i 1 str) strs)) indices) ++ [op];
  in
    solve1 problem;
  moreProblems = let
    len = lib.stringLength (lib.elemAt lines 0);
    indices = lib.range 0 (len - 1);
    delims = lib.filter (i: lib.all (line: (lib.substring i 1 line) == " ") lines) indices;
    delims2 = [0] ++ delims ++ [len];
    indexPairs = lib.map (i: (lib.sublist i 2 delims2)) (lib.range 0 ((lib.length delims2) - 2));
    substr = p: s: let
      i = lib.elemAt p 0;
      j = lib.elemAt p 1;
      len = j - i;
    in
      lib.substring i len s;
    str = line: lib.map (p: substr p line) indexPairs;
    data = lib.map str lines;
  in
    transpose data;

  # Data
  input = lib.readFile ./input.txt;
  lines = strings.splitString "\n" input;

  # Results
  one = lists.sum (lib.map solve1 problems);
  two = lists.sum (lib.map solve2 moreProblems);
in {
  inherit one two;
}
