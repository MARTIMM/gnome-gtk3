use v6;
use NativeCall;
use Test;

#use Gnome::Gtk3::Window;
use Gnome::Gtk3::Popover;
ok 1, 'loads ok';

done-testing;
=finish

#use Gnome::N::X;
#Gnome::N::debug(:on);

#`{{
#-------------------------------------------------------------------------------
class MyGuiClass is Gnome::Gtk3::Popover {
  submethod new ( |c ) {
    self.bless( :GtkPopover, |c);
  }
}

subtest 'User class test', {
  my MyGuiClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Popover, '.new()';
}

}}
#-------------------------------------------------------------------------------
my Gnome::Gtk3::Window $w .= new;
$w.set-title('Test Popup');
my Gnome::Gtk3::Popover $p;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  #$w.container-add($p);
  $p .= new(:relative-to($w));
  isa-ok $p, Gnome::Gtk3::Popover, '.new(:relative-to)';
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
