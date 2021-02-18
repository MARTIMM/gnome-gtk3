#!/usr/bin/env raku

use v6.d;
use lib '/home/marcel/Languages/Raku/Projects/gnome-gtk3/lib';

use NativeCall;

use Gnome::Gtk3::Application;
use Gnome::Gtk3::ApplicationWindow;

#-------------------------------------------------------------------------------
class AppSignalHandlers is Gnome::Gtk3::Application {

  has Gnome::Gtk3::ApplicationWindow $!app-window;

  #-----------------------------------------------------------------------------
  submethod new ( |c ) {
    self.bless( :GtkApplication, |c);
  }

  #-----------------------------------------------------------------------------
  submethod BUILD ( ) {

    # startup signal fired after registration
    self.register-signal( self, 'app-startup', 'startup');

    # fired after self.quit()
    self.register-signal( self, 'app-shutdown', 'shutdown');

    # fired after self.run()
    self.register-signal( self, 'app-activate', 'activate');

    # now we can register the application.
    my Gnome::Glib::Error $e = self.register;
    die $e.message if $e.is-valid;
  }

  #-----------------------------------------------------------------------------
  method app-startup ( Gnome::Gtk3::Application :widget($app) ) {
note 'app registered';
    self.run;
  }

  #-----------------------------------------------------------------------------
  method app-shutdown ( Gnome::Gtk3::Application :widget($app) ) {
note 'app shutdown';
  }

  #-----------------------------------------------------------------------------
  method app-activate ( Gnome::Gtk3::Application :widget($app) ) {
note 'app activated';

    $!app-window .= new(:application(self));
#    $!app-window.set-size-request( 400, 400);
    $!app-window.set-title('Application Window Test');
    $!app-window.set-border-width(20);
    $!app-window.register-signal( self, 'exit-program', 'destroy');
    $!app-window.show-all;

    note "\nInfo:\n  Registered: ", self.get-is-registered;
    note '  resource base path: ', self.get-resource-base-path;
    note '  app id: ', self.get-application-id;
  }

  #-----------------------------------------------------------------------------
  method exit-program ( --> Int ) {
    self.quit;

    1
  }
}

#-------------------------------------------------------------------------------
my AppSignalHandlers $ah .= new(
  :app-id('io.github.martimm.test.application'),
  :!initialize
);
