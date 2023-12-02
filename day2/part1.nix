let 
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
in with lib; with builtins; let
  input = readFile ./input;
  sample = readFile ./sample1;
  lines = x: let xs = splitString "\n" x; in if last xs == "" then init xs else xs;
  _takeUntil = p: xs: acc: if p (head xs) then acc else _takeUntil p (tail xs) (acc ++ [(head xs)]);
  takeUntil = p: xs: concatStrings ( _takeUntil p (stringToCharacters xs) []);
  _skipUntil = p: xs: if p (head xs) then drop 2 xs else _skipUntil p (tail xs);
  skipUntil = p: xs: concatStrings (_skipUntil p (stringToCharacters xs));
  rounds = s: splitString "; " (skipUntil (x: x == ":") s);
  cubes = s: map (splitString ", ") (rounds s);
  cubeArrToMap = xs: listToAttrs (map (y: let x = splitString " " y; in { name = elemAt x 1; value = toIntBase10 (head x); }) xs);
  valid = xs: if length xs == 0 then true else let hd = head xs; in if (hd.blue or 0) > 14 || (hd.green or 0) > 13 || (hd.red or 0) > 12 then false else valid (tail xs);
	# foldr (x: acc: { blue = acc.blue + (x.blue or 0); red = acc.red + (x.red or 0); green = acc.green + (x.green or 0); }) { red = 0; green = 0; blue = 0; } (map cubeArrToMap xs);
  gameId = s: toIntBase10 (elemAt (splitString " " (takeUntil (x: x == ":") (s))) 1);
  game = s: { id = gameId s; possible = valid (map cubeArrToMap (cubes s)); };
  sum = xs: foldr (a: b: a + b) 0 xs;
  solve = s: sum (map (x: x.id) (filter (x: x.possible) (map game (lines (s)))));
in
  solve input
