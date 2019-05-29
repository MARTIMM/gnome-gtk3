use v6;

use Test;

use Gnome::N::N-GObject;
use Gnome::GObject::Object;
#use Gnome::Gdk::Display;
use Gnome::Gdk::Window;

#TODO auto init
use Gnome::Gtk3::Main;
my Gnome::Gtk3::Main $m .= new;

#-------------------------------------------------------------------------------
subtest 'Manage window', {
  my Gnome::Gdk::Window $window;
  throws-like
    { $window .= new; },
    X::Gnome, "No options used",
    :message('No options used to create or set the native widget');

  throws-like
    { $window .= new( :find, :search); },
    X::Gnome, "Wrong options used",
    :message(
      /:s Unsupported options for
          'Gnome::Gdk::Window:'
          [(find||search) ',']+/
    );

  $window .= new(:default);
  isa-ok $window, Gnome::Gdk::Window;
  isa-ok $window(), N-GObject;

  my Int $wtype = $window.get-window-type;
  is GdkWindowType($wtype), GDK_WINDOW_ROOT, 'root window type';
}

#-------------------------------------------------------------------------------
done-testing;
