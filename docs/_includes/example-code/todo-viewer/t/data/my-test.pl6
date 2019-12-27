use v6;

class A {
  # TODO save the argument in an attribute for later use
  method m1 ( Int $a --> Int ) { $a }
}

#TODO we must use a MAIN program here

#CHANGED yesterday because solution was too simple
my Int $i = 10;
my A $a .= new;
$i += $a.m1(2);

# TODO make program useful

#`{{ HACK we need better software!

}}

=finish
