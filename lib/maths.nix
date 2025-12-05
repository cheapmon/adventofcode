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
}
