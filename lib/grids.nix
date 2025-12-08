let
  lib = (import <nixpkgs> {}).lib;
  maths = import ./maths.nix;
in rec {
  genGrid = generator: width: height: let
    len = width * height;
    gen = index: let
      x = maths.mod index width;
      y = index / width;
    in
      generator x y;
  in {
    inherit width height;
    list = lib.genList gen len;
  };

  xs = grid: lib.range 0 (grid.width - 1);
  ys = grid: lib.range 0 (grid.height - 1);

  elemAt = grid: x: y: let
    index = grid.width * y + x;
  in
    lib.elemAt grid.list index;

  map = f: grid: {
    inherit (grid) width height;
    list = lib.map f grid.list;
  };

  imap0 = f: grid: let
    imap0' = i: v: let
      x = maths.mod i grid.width;
      y = i / grid.width;
      elem = elemAt grid x y;
    in
      f elem x y;
  in {
    inherit (grid) width height;
    list = lib.imap0 imap0' grid.list;
  };

  count = pred: grid: lib.count pred grid.list;

  put = elem: x: y: grid:
    imap0 (e: i: j:
      if i == x && j == y
      then elem
      else e)
    grid;
}
