use v6;
#use lib '../gnome-gobject/lib';
use NativeCall;
use Test;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Box;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Box $b;

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $b .= new(:empty);
  isa-ok $b, Gnome::Gtk3::Box;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations ...', {

  # set name is from Buildable, not from Widget
  $b.set-name('buildable');

  $b.set-orientation(GTK_ORIENTATION_VERTICAL);
}

#`{{
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
