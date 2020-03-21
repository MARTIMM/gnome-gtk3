#!/usr/bin/env raku

use v6.d;
#use lib '../gnome-gobject/lib';
#use lib '../gnome-native/lib';
#use lib '../gnome-glib/lib';
#use lib '../gnome-gio/lib';
#use lib 'lib';

use NativeCall;

use Gnome::N::N-GVariant;
use Gnome::Gio::Enums;
use Gnome::Gio::MenuModel;
use Gnome::Gio::Resource;
use Gnome::Gio::SimpleAction;
use Gnome::Glib::Variant;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Application;
use Gnome::Gtk3::ApplicationWindow;
use Gnome::Gtk3::Builder;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
class AppSignalHandlers is Gnome::Gtk3::Application {

  has Str $!app-rbpath;
#  has Gnome::Gtk3::Application $!app;
  has Gnome::Gtk3::Grid $!grid;
  has Gnome::Gio::MenuModel $!menubar;
  has Gnome::Gtk3::ApplicationWindow $!app-window;

  #-----------------------------------------------------------------------------
  submethod new ( |c ) {
    self.bless( :Application, |c);
  }

  #-----------------------------------------------------------------------------
  submethod BUILD ( ) {

    my Gnome::Gio::Resource $r .= new(
      :load<xt/data/g-resources/ex-application.gresource>
    );
    $r.register;

#`{{
    $!app .= new(
      :app-id('io.github.martimm.test.application'),
      :flags(G_APPLICATION_HANDLES_OPEN), # +| G_APPLICATION_NON_UNIQUE),
      :!initialize
    );
}}

    # startup signal fired after registration
    self.register-signal( self, 'app-startup', 'startup');

    # fired after g_application_quit
    self.register-signal( self, 'app-shutdown', 'shutdown');

    # fired after g_application_run
    self.register-signal( self, 'app-activate', 'activate');

    #
    self.register-signal( self, 'app-open', 'open');

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

    $!app-rbpath = self.get-resource-base-path;

    my Gnome::Gtk3::Builder $builder .= new;
    my Gnome::Glib::Error $e = $builder.add-from-resource(
      $!app-rbpath ~ '/xt/data/g-resources/ex-application-menu.ui'
    );
    die $e.message if $e.is-valid;

    $!menubar .= new(:build-id<menubar>);
    self.set-menubar($!menubar);

    # in xml: <attribute name='action'>app.file-new</attribute>
    my Gnome::Gio::SimpleAction $menu-entry .= new(:name<file-new>);
    $menu-entry.register-signal( self, 'file-new', 'activate');
    self.add-action($menu-entry);

    # in xml: <attribute name='action'>app.file-quit</attribute>
    $menu-entry .= new(:name<file-quit>);
    $menu-entry.register-signal( self, 'file-quit', 'activate');
    self.add-action($menu-entry);

    $!app-window .= new(:application(self));
    $!app-window.set-title('Application Window Test');
    $!app-window.set-border-width(20);
    $!app-window.register-signal( self, 'exit-program', 'destroy');

    # prepare widgets which are directly below window
    $!grid .= new;
    my Gnome::Gtk3::Button $b1 .= new(:label<Stop>);
    $!grid.grid-attach( $b1, 0, 0, 1, 1);
    $b1.register-signal( self, 'exit-program', 'clicked');

    $!app-window.container-add($!grid);
    $!app-window.show-all;

    note "\nInfo:\n  Registered: ", self.get-is-registered;
    note '  resource base path: ', $!app-rbpath;
    note '  app id: ', self.get-application-id;
  }

  #-----------------------------------------------------------------------------
  method app-open (
    Pointer $f, Int $nf, Str $hint,
    Gnome::Gtk3::Application :widget($app)
  ) {
note 'app open: ', $nf;
  }

  #-----------------------------------------------------------------------------
  method exit-program ( --> Int ) {
    self.quit;

    1
  }

  #-- [menu] -------------------------------------------------------------------
  # File > New
  method file-new (
    N-GVariant $parameter, Gnome::GObject::Object :widget($file-new-action)
  ) {
    note "Select 'New' from 'File' menu";
    note "p: ", $parameter.perl;
    my Gnome::Glib::Variant $v .= new(:native-object($parameter));
    note "tsv: ", $v.is-valid;
    note "ts: ", $v.get-type-string if $v.is-valid;
  }

  # File > Quit
  method file-quit (
    N-GVariant $parameter, Gnome::GObject::Object :widget($file-quit-action)
    --> Int
  ) {
    note "Select 'Quit' from 'File' menu";

    self.quit;

    1
  }
}



#-------------------------------------------------------------------------------
my AppSignalHandlers $ah .= new(
  :app-id('io.github.martimm.test.application'),
  :flags(G_APPLICATION_HANDLES_OPEN), # +| G_APPLICATION_NON_UNIQUE),
  :!initialize
);
