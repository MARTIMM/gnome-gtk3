#!/usr/bin/env raku

use v6;

use Gnome::Gtk3::Application;
use Gnome::Gtk3::ApplicationWindow;

#-------------------------------------------------------------------------------
class UserAppClass is Gnome::Gtk3::Application {

  constant APP-ID = 'io.github.martimm.tutorial.simple-app';
  has Gnome::Gtk3::ApplicationWindow $!app-window;

  #-----------------------------------------------------------------------------
  submethod new ( |c ) {
    self.bless( :GtkApplication, :app-id(APP-ID), |c);
  }

  #-----------------------------------------------------------------------------
  submethod BUILD ( ) {

    self.register-signal( self, 'app-activate', 'activate');

    my Gnome::Glib::Error $e = self.register;
    die $e.message if $e.is-valid;
  }

  #-----------------------------------------------------------------------------
  method app-activate ( Gnome::Gtk3::Application :_widget($app) ) {

    given $!app-window .= new(:application(self)) {
      .set-size-request( 400, 200);
      .set-title('Application Sceleton');
      .register-signal( self, 'exit-program', 'destroy');
      .show-all;
    }

    say "\nInfo:\n  Registered: ", self.get-is-registered;
    say '  app id: ', self.get-application-id;
  }

  #-----------------------------------------------------------------------------
  method exit-program ( ) {
    self.quit;
  }
}

#-------------------------------------------------------------------------------
my UserAppClass $user-app .= new;
my Int $exit-code = $user-app.run;
note 'exit code: ', $exit-code;
exit($exit-code);
