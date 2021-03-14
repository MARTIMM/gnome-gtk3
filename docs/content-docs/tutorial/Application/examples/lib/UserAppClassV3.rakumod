#!/usr/bin/env raku

use v6;
use Getopt::Long;

use Gnome::Glib::N-GVariantDict;

use Gnome::N::N-GObject;                                                # ①

use Gnome::Gio::Enums;
use Gnome::Gio::ApplicationCommandLine;

use Gnome::Gtk3::Application;
use Gnome::Gtk3::ApplicationWindow;

#-------------------------------------------------------------------------------
unit class UserAppClassV3 is Gnome::Gtk3::Application;

constant APP-ID = 'io.github.martimm.tutorial.sceleton';
has Gnome::Gtk3::ApplicationWindow $!app-window;

#-------------------------------------------------------------------------------
submethod new ( |c ) {
  self.bless(
    :GtkApplication, :app-id(APP-ID),
    :flags(G_APPLICATION_HANDLES_COMMAND_LINE),
    |c
  );
}

#-------------------------------------------------------------------------------
submethod BUILD ( ) {

  self.register-signal( self, 'app-activate', 'activate');
  self.register-signal( self, 'local-options', 'handle-local-options');
  self.register-signal( self, 'remote-options', 'command-line');        # ③

  # now we can register the application.
  my Gnome::Glib::Error $e = self.register;
  die $e.message if $e.is-valid;
}

#-------------------------------------------------------------------------------
method app-activate ( UserAppClassV3 :_widget($app) ) {
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
  N-GVariantDict $n-vd, UserAppClassV3 :_widget($app) --> Int
) {
  my Int $exit-code = -1;

  CATCH { default { .message.note; $exit-code = 1; return $exit-code; } }
  my $o = get-options( 'version', 'show:s');
  if $o<version> {
    say "Version of UserAppClassV3 is 0.2.0";
    $exit-code = 0;
  }

  $exit-code
}

#-------------------------------------------------------------------------------
method remote-options (                                                 # ④
  N-GObject $n-cl, UserAppClassV3 :_widget($app) --> Int
) {
  my Int $exit-code = 0;

  my Gnome::Gio::ApplicationCommandLine $cl .= new(                     # ⑤
    :native-object($n-cl)
  );

  my Array $args = $cl.get-arguments;                                   # ⑥
  my Capture $o = get-options-from( $args[1..*-1], 'version', 'show:s');# ⑦
  my Str $file-to-show = $o.<show> if ($o.<show> // '') and $o.<show>.IO.r;

  self.activate unless $cl.get-is-remote;                               # ⑧

  if ?$file-to-show {
    $cl.print("Show text from $file-to-show\n");
    $exit-code = 0;
  }

#  $cl.set-exit-status($exit-code) if $cl.get-is-remote;
  $cl.clear-object;                                                     # ⑨

  $exit-code
}

#-------------------------------------------------------------------------------
method exit-program ( ) {
  self.quit;
}
