use v6;

sub r ( Int $r --> Int ) is export {
  $r + 2;
}

class C {
  method c ( Int $c ) {
    note "$c -> ", r($c + 10);
  }
}

note r(11);

my C $cc .= new;
$cc.c(11);




# Here is shown that methods from role are done before inherited class
role R1 {
  method r ( ) {
    note "R1::r";
    callsame;
  }
}

class C1 {
  method r ( ) {
    note "C1::r";
  }
}

class C2 does R1 is C1 { }
my C2 $c2 .= new;
$c2.r;

# R1::r
# C1::r



# require test
#use Gnome::Gtk3::Buildable;
my Callable $s;
try {
  require ::('Gnome::Gtk3::Buildable');
  note ::.keys;
#  $s = &gtk_buildable_get_name;
  #$s = &::('Gtk3::Buildable::gtk_buildable_get_name');
  #$s = &::('Buildable::gtk_buildable_get_name');
  #$s = &::('gtk_buildable_get_name');
  note "Sub s: ", ::('&gtk_buildable_get_name').perl;

  CATCH {
    .note;
  }
}
