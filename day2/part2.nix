let 
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
in with lib; with builtins; let
  input = readFile ./input;
  sample = readFile ./sample2;
  lines = x: let xs = splitString "\n" x; in if last xs == "" then init xs else xs;
  _takeUntil = p: xs: acc: if p (head xs) then acc else _takeUntil p (tail xs) (acc ++ [(head xs)]);
  takeUntil = p: xs: concatStrings ( _takeUntil p (stringToCharacters xs) []);
  _skipUntil = p: xs: if p (head xs) then drop 2 xs else _skipUntil p (tail xs);
  skipUntil = p: xs: concatStrings (_skipUntil p (stringToCharacters xs));
  rounds = s: splitString "; " (skipUntil (x: x == ":") s);
  cubes = s: map (splitString ", ") (rounds s);
  cubeArrToMap = xs: listToAttrs (map (y: let x = splitString " " y; in { name = elemAt x 1; value = toIntBase10 (head x); }) xs);
  maxCubes = xs: foldr (x: acc: { blue = max acc.blue (x.blue or 0); red = max acc.red (x.red or 0); green = max acc.green (x.green or 0); }) { red = 0; green = 0; blue = 0; } xs;
  sum = xs: foldr (a: b: a + b) 0 xs;
  prod = xs: foldr (a: b: a * b) 1 xs;
  solve = s: sum (map (l: prod (attrValues (maxCubes (map cubeArrToMap (cubes l))))) (lines (s)));
in
  solve input
