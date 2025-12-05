let
  lib = (import <nixpkgs> {}).lib;

  # String helpers
  strings = {
    splitString = sep: s: let
      isPresent = s: (lib.stringLength s) > 0;
      list = lib.splitString sep s;
    in
      lib.filter isPresent list;
  };

  # Math helpers
  maths = {
    mod = a: b: a - (a / b) * b;
  };

  # Grid helpers
  grids = {
    genGrid = generator: width: height: let
      len = width * height;
      gen = index: let
        x = maths.mod index height;
        y = index / height;
      in
        generator x y;
    in {
      inherit width height;
      list = lib.genList gen len;
    };

    xs = grid: lib.range 0 (grid.width - 1);
    ys = grid: lib.range 0 (grid.height - 1);

    elemAt = grid: x: y: let
      index = grid.height * y + x;
    in
      lib.elemAt grid.list index;

    map = f: grid: {
      inherit (grid) width height;
      list = lib.map f grid.list;
    };

    imap0 = f: grid: let
      imap0' = i: v: let
        x = maths.mod i grid.height;
        y = i / grid.height;
        elem = grids.elemAt grid x y;
      in
        f elem x y;
    in {
      inherit (grid) width height;
      list = lib.imap0 imap0' grid.list;
    };

    count = pred: grid: lib.count pred grid.list;
  };

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
