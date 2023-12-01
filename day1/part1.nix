let 
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
in with lib; with builtins; let
  input = readFile ./input;
  sample = readFile ./sample1;
  lines = x: let xs = splitString "\n" x; in if last xs == "" then init xs else xs;
  isNumber = s: (tryEval (toIntBase10 s)).success;
  firstDigit = xs: let hd = head xs; in if isNumber hd then hd else firstDigit (tail xs);
  lastDigit = xs: let ls = last xs; in if isNumber ls then ls else lastDigit (init xs);
in
  fold (b: a: a + b) 0 (map (line: toIntBase10 ((firstDigit (stringToCharacters line)) + (lastDigit (stringToCharacters line)))) (lines input))
