use v6;
use Test;

use Gnome::N::N-GObject;
use Gnome::GObject::Object;
use Gnome::Gdk3::Display;
use Gnome::Gdk3::Screen;

#TODO auto init
use Gnome::Gtk3::Main;
my Gnome::Gtk3::Main $m .= new;

#-------------------------------------------------------------------------------
subtest 'Manage display', {
  my Gnome::Gdk3::Screen $screen;
  throws-like
    { $screen .= new; },
    X::Gnome, "No options used",
    :message('No options used to create or set the native widget');

  throws-like
    { $screen .= new( :find, :search); },
    X::Gnome, "Wrong options used",
    :message(
      /:s Unsupported options for
          'Gnome::Gdk3::Screen:'
          [(find||search) ',']+/
    );

  $screen .= new(:default);
  isa-ok $screen, Gnome::Gdk3::Screen;
  isa-ok $screen(), N-GObject;

  my Gnome::Gdk3::Display $display .= new(:widget($screen.get-display));
  my Str $display-name = $display.get-name();
  like $display-name, /\: \d+/, 'name has proper format: ' ~ $display-name;
#note "DN: $display-name";
}

#-------------------------------------------------------------------------------
done-testing;
