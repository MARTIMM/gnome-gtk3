
use v6;

class A {
  multi method a ( --> Int ) { 10 }
  multi method a ( --> Str ) { 'abc' }
}

my A $a .= new;

note my Str $x1 = $a.a;
note my Int $x2 = $a.a;
