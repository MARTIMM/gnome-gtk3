
use v6;


class A {
  method a ( --> Any ) {
    note '-' x 80;
    self.calling-frame;
  }

  method calling-frame ( ) {
    for 1..* -> $level {
      given callframe($level) -> $frame {
note $?LINE, ', ', '$frame: ', $frame.code ~~ Callable;
#note $frame.annotations<line>;
#note $frame.my.gist;
        when $frame.line == 1 {
          note $?LINE;
          last;
        }

        when $frame.code ~~ Callable {
          note $?LINE, ', ', $frame.code.Str, ', ', $frame.code.signature;
        }

#        when $frame ~~ Mu {
#          last;
#        }

#        when $frame ~~ CallFrame {
#note $frame.^methods;
#          note $frame.annotations.gist;
#          next unless $frame.code ~~ Routine;
#          say $frame.code.package;
#          last;
#        }

        default {
          say "no calling routine or method found";
          last;
        }
      }
    }
  }

  method b ( --> Any ) {
    note '-' x 80;
    note callframe(1).code.signature;
    note callframe(2).line;
  }

  multi method m1 ( 'old', Int $i --> Int ) {
    $i * 10
  }

  multi method m1 ( Int $i --> Str ) {
    "new way: {$i * 10}"
  }
}

my A $a .= new;

my Str $x1 = $a.a;
my Int $x2 = $a.a;

my Int $x3 = $a.b;


note '-' x 80;
note $a.m1( 'old', 10);
note $a.m1(10);
