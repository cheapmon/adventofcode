let
  lib = import <nixpkgs/lib>;
  strings = import ../../lib/strings.nix;
  lists = import ../../lib/lists.nix;
  maths = import ../../lib/maths.nix;

  # Helpers
  mkPosition = x: y: z: {inherit x y z;};
  distance = pos1: pos2: let
    x = maths.pow (pos1.x - pos2.x) 2;
    y = maths.pow (pos1.y - pos2.y) 2;
    z = maths.pow (pos1.z - pos2.z) 2;
  in
    maths.sqrt (x + y + z);

  # Data
  input = lib.readFile ./input.txt;
  positions = let
    lines = strings.splitString "\n" input;
    genPosition = s: let
      list = strings.splitString "," s;
      x = lib.toInt (lib.elemAt list 0);
      y = lib.toInt (lib.elemAt list 1);
      z = lib.toInt (lib.elemAt list 2);
    in
      mkPosition x y z;
  in
    lib.map genPosition lines;

  # Results
  one = {};
  two = {};
in {
  inherit one two;
}
