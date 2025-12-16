let
  lib = (import <nixpkgs> {}).lib;

  mod = a: b: a - (a / b) * b;
  abs = a:
    if a < 0
    then a * (-1)
    else a;

  start = rec {
    n = 50;
    zeros = 0;
    list = [n];
  };
  input = builtins.readFile ./input.txt;
  lines = lib.strings.splitString "\n" input;

  # "L99" -> 99
  num = n: builtins.fromJSON (builtins.substring 1 5 n);
  # "L99" -> -99, "R2" -> 2
  mapRotation = r:
    if (builtins.substring 0 1 r) == "L"
    then (num r) * (-1)
    else (num r);

  updateN = n:
    if n < 0
    then (n + 100)
    else n;
  updateZeros = n: zeros:
    if n == 0
    then (zeros + 1)
    else zeros;
  updateList = n: list: list ++ [(updateN n)];

  countZeros = acc: num: rec {
    n = mod (acc.n + num) 100;
    zeros = updateZeros n acc.zeros;
    list = updateList n acc.list;
  };
  countMoreZeros = acc: num:
    if num > (-100) && num < 0
    then rec {
      n = updateN (mod (acc.n + num) 100);
      zeros =
        if (acc.n + num) <= 0 && acc.n > 0
        then (acc.zeros + 1)
        else acc.zeros;
      list = updateList n acc.list;
    }
    else if num > 0 && num < 100
    then rec {
      n = updateN (mod (acc.n + num) 100);
      zeros =
        if (acc.n + num) >= 100
        then (acc.zeros + 1)
        else acc.zeros;
      list = updateList n acc.list;
    }
    else
      (countMoreZeros {
        n = acc.n;
        zeros = acc.zeros + abs (num / 100);
        list = acc.list;
      } (mod num 100));

  rotations = builtins.filter (line: builtins.stringLength line > 0) lines;
  nums = builtins.map mapRotation rotations;

  one = builtins.foldl' countZeros start nums;
  two = builtins.foldl' countMoreZeros start nums;
in {
  one = one;
  two = two;
}
