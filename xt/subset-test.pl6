use v6;

class ABC {
  method s ( Int $i ) { say $i + 10; }
}

subset DEF of ABC;

my ABC $a .= new;
$a.s(10);

my DEF $d1 = $a;
$d1.s(11);

my DEF $d2 .= new;
$d2.s(12);
