use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::TreeSelection;
ok 1, 'loads ok';
done-testing;
=finish

#use Gnome::N::X;
#Gnome::N::debug(:on);

#`{{
#-------------------------------------------------------------------------------
class MyGuiClass is Gnome::Gtk3::TreeSelection {
  submethod new ( |c ) {
    self.bless( :GtkTreeSelection, |c);
  }
}

subtest 'User class test', {
  my MyGuiClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::TreeSelection, '.new()';
}

}}
#-------------------------------------------------------------------------------
my Gnome::Gtk3::TreeSelection $ts;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $ts .= new;
  isa-ok $ts, Gnome::Gtk3::TreeSelection, '.new()';
}

#`{{

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
