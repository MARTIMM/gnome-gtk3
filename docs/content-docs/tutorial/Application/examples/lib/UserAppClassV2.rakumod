#!/usr/bin/env raku

use v6;
use Getopt::Long;

use Gnome::N::N-GObject:api<1>;

use Gnome::Gtk3::Application:api<1>;
use Gnome::Gtk3::ApplicationWindow:api<1>;

#-------------------------------------------------------------------------------
unit class UserAppClassV2 is Gnome::Gtk3::Application;

constant APP-ID = 'io.github.martimm.tutorial.sceleton';
has Gnome::Gtk3::ApplicationWindow $!app-window;

#-------------------------------------------------------------------------------
submethod new ( |c ) {
  self.bless( :GtkApplication, :app-id(APP-ID), |c);
}

#-------------------------------------------------------------------------------
submethod BUILD ( ) {

  self.register-signal( self, 'app-activate', 'activate');
  self.register-signal( self, 'local-options', 'handle-local-options');

  my Gnome::Glib::Error $e = self.register;
  die $e.message if $e.is-valid;
}

#-------------------------------------------------------------------------------
method app-activate ( UserAppClassV2 :_widget($app) ) {
note 'app activated';

  given $!app-window .= new(:application(self)) {
    .set-size-request( 400, 200);
    .set-title('Application Window Test');
    .register-signal( self, 'exit-program', 'destroy');
    .show-all;
  }

  note "\nInfo:\n  Registered: ", self.get-is-registered;
  note '  app id: ', self.get-application-id;
}

#-------------------------------------------------------------------------------
method local-options (
  N-GObject $n-vd, UserAppClassV2 :_widget($app) --> Int
) {
  my Int $exit-code = -1;

  CATCH { default { .message.note; $exit-code = 1; return $exit-code; } }
  my Capture $o = get-options('version');
  if $o<version> {
    say "Version of UserAppClassV2 is 0.2.0";
    $exit-code = 0;
  }

  $exit-code
}

#-------------------------------------------------------------------------------
method exit-program ( ) {
  self.quit;
}
