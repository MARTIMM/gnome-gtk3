use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::ToolButton;
use Gnome::Gtk3::Image;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::ToolButton $tb;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $tb .= new;
  isa-ok $tb, Gnome::Gtk3::ToolButton, '.new()';

  $tb .= new(:label<+>);
  isa-ok $tb, Gnome::Gtk3::ToolButton, '.new(:label)';

  my Gnome::Gtk3::Image $image .= new(:filename('t/data/Add.png'));
  $tb .= new(:icon($image));
  isa-ok $tb, Gnome::Gtk3::ToolButton, '.new(:icon)';
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
