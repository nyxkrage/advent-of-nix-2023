let 
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
in with lib; with builtins; let
  input = readFile ./input;
  sample = readFile ./sample2;
  lines = x: let xs = splitString "\n" x; in if last xs == "" then init xs else xs;
  lastNum = xs: let lst = last xs; l = n: (length xs) - 1 - n; num = tryEval (toIntBase10 lst); el = elemAt xs; in
    if num.success then num.value else
    if lst == "e" && el (l 1) == "n" && el (l 2) == "o"                                       then 1 else
    if lst == "o" && el (l 1) == "w" && el (l 2) == "t"                                       then 2 else
    if lst == "e" && el (l 1) == "e" && el (l 2) == "r" && el (l 3) == "h" && el (l 4) == "t" then 3 else
    if lst == "r" && el (l 1) == "u" && el (l 2) == "o" && el (l 3) == "f"                    then 4 else
    if lst == "e" && el (l 1) == "v" && el (l 2) == "i" && el (l 3) == "f"                    then 5 else
    if lst == "x" && el (l 1) == "i" && el (l 2) == "s"                                       then 6 else
    if lst == "n" && el (l 1) == "e" && el (l 2) == "v" && el (l 3) == "e" && el (l 4) == "s" then 7 else
    if lst == "t" && el (l 1) == "h" && el (l 2) == "g" && el (l 3) == "i" && el (l 4) == "e" then 8 else
    if lst == "e" && el (l 1) == "n" && el (l 2) == "i" && el (l 3) == "n"                    then 9 else
    lastNum (init xs);
  firstNum = xs: let hd = head xs; num = tryEval (toIntBase10 hd); el = elemAt xs; in
    if num.success then num.value else
    if hd == "o" && el 1 == "n" && el 2 == "e"                               then 1 else
    if hd == "t" && el 1 == "w" && el 2 == "o"                               then 2 else
    if hd == "t" && el 1 == "h" && el 2 == "r" && el 3 == "e" && el 4 == "e" then 3 else
    if hd == "f" && el 1 == "o" && el 2 == "u" && el 3 == "r"                then 4 else
    if hd == "f" && el 1 == "i" && el 2 == "v" && el 3 == "e"                then 5 else
    if hd == "s" && el 1 == "i" && el 2 == "x"                               then 6 else
    if hd == "s" && el 1 == "e" && el 2 == "v" && el 3 == "e" && el 4 == "n" then 7 else
    if hd == "e" && el 1 == "i" && el 2 == "g" && el 3 == "h" && el 4 == "t" then 8 else
    if hd == "n" && el 1 == "i" && el 2 == "n" && el 3 == "e"                then 9 else
    firstNum (tail xs);
in
  fold (b: a: a + b) 0 (map (line: toIntBase10 ((toString (firstNum (stringToCharacters line))) + (toString (lastNum (stringToCharacters line))))) (lines input))
