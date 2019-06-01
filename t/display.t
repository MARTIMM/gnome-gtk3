use v6;
#use lib '../perl6-gnome-native/lib', '../perl6-gnome-gobject/lib';
use Test;

use Gnome::N::N-GObject;
use Gnome::Gdk3::Display;

#TODO auto init
#use Gnome::Gtk3::Main;
#my Gnome::Gtk3::Main $m .= new;

#-------------------------------------------------------------------------------
subtest 'Manage display', {
#  X::Gnome.debug(:on);

  my Gnome::Gdk3::Display $display;
  throws-like
    { $display .= new; },
    X::Gnome, "No options used",
    :message('No options used to create or set the native widget');

  throws-like
    { $display .= new( :find, :search); },
    X::Gnome, "Wrong options used",
    :message(
      /:s Unsupported options for
          'Gnome::Gdk3::Display:'
          [(find||search) ',']+ /
    );

  $display .= new(:default);
  isa-ok $display, Gnome::Gdk3::Display;
  isa-ok $display(), N-GObject;

  my Str $display-name = $display.get-name();
  like $display-name, /\: \d+/, 'name has proper format: ' ~ $display-name;
}

#-------------------------------------------------------------------------------
done-testing;
