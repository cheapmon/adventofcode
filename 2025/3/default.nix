let
  lib = (import <nixpkgs> {}).lib;

  # Helpers
  splitString = sep: s: let
    isPresent = s: (builtins.stringLength s) > 0;
    list = lib.strings.splitString sep s;
  in
    builtins.filter isPresent list;
  max = list: builtins.foldl' (a: b: lib.trivial.max a b) 0 list;
  sum = list: builtins.foldl' builtins.add 0 list;
  pow = base: power:
    if power != 0
    then base * (pow base (power - 1))
    else 1;

  # Part 1 + 2
  maximumJoltage = bank: len:
    if len == 1
    then (max bank)
    else let
      totalLen = builtins.length bank;
      sublistLeft = lib.lists.sublist 0 (totalLen - len + 1) bank;
      maxFromLeft = max sublistLeft;
      pivot = lib.lists.findFirstIndex (a: a == maxFromLeft) null bank;
      sublistRight = lib.lists.sublist (pivot + 1) totalLen bank;
      maxFromRight = maximumJoltage sublistRight (len - 1);
      n = (pow 10 (len - 1)) * maxFromLeft;
    in
      n + maxFromRight;

  # Data
  input = builtins.readFile ./input.txt;
  banks = let
    lines = splitString "\n" input;
    digits = builtins.map (line: splitString "" line) lines;
    banks = builtins.map (bank: builtins.map lib.strings.toInt bank) digits;
  in
    banks;

  # Results
  one = sum (builtins.map (bank: maximumJoltage bank 2) banks);
  two = sum (builtins.map (bank: maximumJoltage bank 12) banks);
in {
  inherit one two;
}
