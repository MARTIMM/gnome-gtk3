use v6;

role R0 {
  submethod interface ( ) {
    say 'Interface role R0';
    callsame;
  }
}

role R1 {
  submethod interface ( ) {
    say 'Interface role R1';
    callsame;
  }
}

class A does R0 does R1 {

  method do-interface ( ) {
    say 'Do interfaces';
  }
}



my A $a .= new;
