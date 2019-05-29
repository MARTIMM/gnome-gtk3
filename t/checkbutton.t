use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Widget;
use Gnome::Gtk3::CheckButton;

diag "\n";


#-------------------------------------------------------------------------------
subtest 'CheckButton create', {

  my Gnome::Gtk3::CheckButton $cb .= new(:label('abc'));
  isa-ok $cb, Gnome::Gtk3::CheckButton;
}

#-------------------------------------------------------------------------------
done-testing;
