let
  lib = (import <nixpkgs> {}).lib;
  strings = import ../../lib/strings.nix;
  lists = import ../../lib/lists.nix;

  # Helpers
  parseID = lib.toInt;
  parseRange = s: let
    list = strings.splitString "-" s;
    a = parseID (lib.elemAt list 0);
    b = parseID (lib.elemAt list 1);
  in {inherit a b;};

  # Part 1
  between = x: range: (x >= range.a) && (x <= range.b);
  isInRange = db: id: lib.any (range: between id range) db.ranges;
  freshIngredients = db: lib.filter (id: isInRange db id) db.ids;

  # Data
  input = lib.readFile ./input.txt;
  db = let
    blocks = strings.splitString "\n\n" input;
    ranges = lib.map parseRange (strings.splitString "\n" (lib.elemAt blocks 0));
    ids = lib.map parseID (strings.splitString "\n" (lib.elemAt blocks 1));
  in {inherit ranges ids;};

  # Results
  one = lib.length (freshIngredients db);
in {
  inherit one;
}
