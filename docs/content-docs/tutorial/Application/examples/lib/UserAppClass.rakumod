#!/usr/bin/env raku

use v6.d;

use NativeCall;

use Gnome::N::N-GObject;

#use Gnome::Glib::N-GVariantDict;
#use Gnome::Glib::VariantDict;

use Gnome::Gio::Enums;

use Gnome::Gtk3::Application;
use Gnome::Gtk3::ApplicationWindow;

#-------------------------------------------------------------------------------
unit class UserAppClass is Gnome::Gtk3::Application;

constant APP-ID = 'io.github.martimm.tutorial.sceleton';
has Gnome::Gtk3::ApplicationWindow $!app-window;

#-------------------------------------------------------------------------------
submethod new ( |c ) {
  self.bless(
    :GtkApplication, :app-id(APP-ID), :_may-not-initialize-gui,
#    :flags(
      #[+|] G_APPLICATION_HANDLES_OPEN,
      # G_APPLICATION_HANDLES_COMMAND_LINE,
      # G_APPLICATION_NON_UNIQUE,
#    ),
    |c
  );
}

#-------------------------------------------------------------------------------
submethod BUILD ( ) {

note 'app build';

  # startup signal fired after registration
  self.register-signal( self, 'app-startup', 'startup');

  # fired after self.quit()
  self.register-signal( self, 'app-shutdown', 'shutdown');

  # fired after self.run()
  self.register-signal( self, 'app-activate', 'activate');

#  self.register-signal( self, 'app-cmd-line', 'command-line');
#  self.register-signal( self, 'app-open', 'open');
#  self.register-signal( self, 'app-options', 'handle-local-options');

  # now we can register the application.
  my Gnome::Glib::Error $e = self.register;
  die $e.message if $e.is-valid;

#note 'run app';
#  self.run;

note 'build done';
}

#-------------------------------------------------------------------------------
method app-startup ( Gnome::Gtk3::Application :_widget($app) ) {
note 'app registered';
}

#-------------------------------------------------------------------------------
method app-shutdown ( Gnome::Gtk3::Application :_widget($app) ) {
note 'app shutdown';
}

#-------------------------------------------------------------------------------
method app-activate ( Gnome::Gtk3::Application :_widget($app) ) {
note 'app activated';

  given $!app-window .= new(:application(self)) {
    .set-size-request( 400, 200);
    .set-title('Application Window Test');
    .set-border-width(20);
    .register-signal( self, 'exit-program', 'destroy');
    .show-all;
  }

  note "\nInfo:\n  Registered: ", self.get-is-registered;
  note '  resource base path: ', self.get-resource-base-path;
  note '  app id: ', self.get-application-id;
}

#`{{
#-------------------------------------------------------------------------------
method app-cmd-line (
  N-GObject $no-cmd-line, Gnome::Gtk3::Application :_widget($app)
) {
note 'command line request';
}
}}

#`{{
#-------------------------------------------------------------------------------
method app-options (
  N-GVariantDict $no-cmd-options, Gnome::Gtk3::Application :_widget($app)
) {
  my Gnome::Glib::Variant $options .= new(:native-object($no-cmd-options));

note 'command options:', $options.print(False);
}
}}

#`{{
#-------------------------------------------------------------------------------
method app-open (
  Pointer $f, Int $nf, Str $hint,
  Gnome::Gtk3::Application :_widget($app)
) {
note "open $nf, $hint";
}
}}

#-------------------------------------------------------------------------------
method exit-program ( --> Int ) {
  self.quit;

  1
}
