let
  lib = (import <nixpkgs> {}).lib;

  # Import utility modules
  strings = import ../../lib/strings.nix;
  maths = import ../../lib/maths.nix;
  grids = import ../../lib/grids.nix;

  # Part 1
  isRoll = s: s == "@";
  neighbors = grid: x: y: let
    deltas = [(-1) 0 1];
    mapXY = dx: dy:
      if dx == 0 && dy == 0
      then [(-1) (-1)]
      else [(x + dx) (y + dy)];
    indices = lib.concatMap (dx: lib.map (dy: mapXY dx dy) deltas) deltas;
    isValidIndex = c: lib.elem (lib.elemAt c 0) (grids.xs grid) && lib.elem (lib.elemAt c 1) (grids.ys grid);
    validIndices = lib.filter isValidIndex indices;
    elemAt = c: grids.elemAt grid (lib.elemAt c 0) (lib.elemAt c 1);
  in
    lib.map elemAt validIndices;
  count = elem: x: y:
    if isRoll elem
    then lib.count isRoll (neighbors grid x y)
    else 9;

  # Part 2
  keepRemoving = grid: result: let
    count = elem: x: y:
      if isRoll elem
      then lib.count isRoll (neighbors grid x y)
      else 9;
    counts = grids.imap0 count grid;
    num = grids.count (c: c < 4) counts;
    newChar = c:
      if c == 9 || c < 4
      then "."
      else "@";
    newGrid = grids.map newChar counts;
    newResult =
      if num > 0
      then keepRemoving newGrid (result + num)
      else result;
  in
    newResult;

  # Data
  input = lib.readFile ./input.txt;
  grid = let
    lines = strings.splitString "\n" input;
    list = lib.concatMap (line: strings.splitString "" line) lines;
    width = lib.stringLength (lib.elemAt lines 0);
    height = lib.length lines;
    gen = x: y: lib.elemAt list (height * y + x);
  in
    grids.genGrid gen width height;

  # Results
  one = grids.count (c: c < 4) (grids.imap0 count grid);
  two = keepRemoving grid 0;
in {
  inherit one two;
}
