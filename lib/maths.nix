rec {
  mod = a: b: a - (a / b) * b;

  abs = a:
    if a < 0
    then a * (-1)
    else a;

  pow = base: power:
    if power != 0
    then base * (pow base (power - 1))
    else 1;

  sqrt = n: let
    sqrt' = guess: let
      nextGuess = (guess + n / guess) / 2.0;
      diff =
        if nextGuess > guess
        then nextGuess - guess
        else guess - nextGuess;
    in
      if diff < 0.0001
      then nextGuess
      else sqrt' nextGuess;
  in
    if n < 0
    then throw "sqrt: negative number"
    else if n == 0
    then 0
    else sqrt' (n / 2.0);
}
