#!/usr/bin/env raku

use v6.d;
#use lib '/home/marcel/Languages/Raku/Projects/gnome-gobject/lib';
#use lib '../gnome-native/lib';
#use lib '../gnome-glib/lib';
#use lib '../gnome-gio/lib';
#use lib 'lib';

use NativeCall;

use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Glib::N-GVariant;
use Gnome::Glib::N-GVariantDict;
use Gnome::Glib::N-GVariantType;
use Gnome::Glib::Variant;
use Gnome::Glib::VariantType;
use Gnome::Glib::VariantDict;

use Gnome::Gio::Enums;
#use Gnome::Gio::MenuModel;
use Gnome::Gio::Resource;
#use Gnome::Gio::SimpleAction;

use Gnome::Gtk3::MenuBar;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Application;
use Gnome::Gtk3::ApplicationWindow;
use Gnome::Gtk3::Builder;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
class AppSignalHandlers:ver<0.4.3> is Gnome::Gtk3::Application {

  constant APP-ID = 'io.github.martimm.tutorial';

  has Str $!app-rbpath;
#  has Gnome::Gtk3::Application $!app;
  has Gnome::Gtk3::Grid $!grid;
#  has Gnome::Gio::MenuModel $!menubar;
  has Gnome::Gtk3::MenuBar $!menubar;
  has Gnome::Gtk3::ApplicationWindow $!app-window;
  has Str $!resource-section = '-';

  #-----------------------------------------------------------------------------
  submethod new ( |c ) {
    self.bless( :GtkApplication, :app-id(APP-ID), |c);
  }

  #-----------------------------------------------------------------------------
  submethod BUILD ( :$!resource-section ) {

    my Gnome::Gio::Resource $r .= new(:load<GResources/Application.gresource>);
    $r.register;

    # startup signal fired after registration
    self.register-signal( self, 'app-startup', 'startup');

    # fired after g_application_quit
    self.register-signal( self, 'app-shutdown', 'shutdown');

    # fired after g_application_run
    self.register-signal( self, 'app-activate', 'activate');

    #
    self.register-signal( self, 'app-open', 'open');
    self.register-signal( self, 'options', 'handle-local-options');
    self.register-signal( self, 'app-end-session', 'query-end');
    self.register-signal( self, 'win-open', 'window-added');

    # now we can register the application.
    my Gnome::Glib::Error $e = self.register;
    die $e.message if $e.is-valid;
  }

  #-----------------------------------------------------------------------------
  method app-startup ( Gnome::Gtk3::Application :widget($app) ) {
note 'app registered';
#    self.run;
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
      "$!app-rbpath/$!resource-section/ApplicationMenu.ui"
    );
    die $e.message if $e.is-valid;

#!!! get/set-app-menu removed from version 4. https://gitlab.gnome.org/GNOME/Initiatives/-/wikis/App-Menu-Retirement
    $!menubar .= new(:build-id<menubar>);
    self.set-menubar($!menubar);

    self!link-menu-action(:action<file-new>);
    self!link-menu-action(:action<file-quit>);
    self!link-menu-action(:action<show-index>);
    self!link-menu-action(:action<show-about>);
    self!link-menu-action(:action<select-compression>, :state<uncompressed>);

    $!app-window .= new(:application(self));
    $!app-window.set-size-request( 600, 400);
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
  method !link-menu-action ( Str :$action, Str :$method is copy, Str :$state ) {

    $method //= $action;

    my Gnome::Gio::SimpleAction $menu-entry;
    if ?$state {
      $menu-entry .= new(
        :name($action),
        :parameter-type(Gnome::Glib::VariantType.new(:type-string<s>)),
        :state(Gnome::Glib::Variant.new(:parse("'$state'")))
      );
      $menu-entry.register-signal( self, $method, 'change-state');

    }

    else {
      $menu-entry .= new(
        :name($action),
#        :parameter-type(Gnome::Glib::VariantType.new(:type-string<s>))
      );
      $menu-entry.register-signal( self, $method, 'activate');
    }

    self.add-action($menu-entry);

    #cannot clear -> need to use it in handler!
    $menu-entry.clear-object;
  }

  #-----------------------------------------------------------------------------
  method app-open (
    Pointer $f, Int $nf, Str $hint,
    Gnome::Gtk3::Application :_widget($app)
  ) {
note 'app open: ', $nf;
  }

  #-----------------------------------------------------------------------------
  method options (
    N-GVariantDict $nvd,
    Gnome::Gtk3::Application :_widget($app)
    --> Int
  ) {
    my Gnome::Glib::VariantDict $vd .= new(:native-object($nvd));
    if $vd.contains('version') or $vd.contains('v') {
      note 'Version: ', self.ver;
    }
note 'app options: ';

    -1
  }

  #-----------------------------------------------------------------------------
  method app-end-session ( Gnome::Gtk3::Application :widget($app) ) {
note 'session end';
  }

  #-----------------------------------------------------------------------------
  method win-open ( Gnome::Gtk3::Application :widget($app) ) {
note 'window opened';
  }

  #-- [button] -----------------------------------------------------------------
  method exit-program (
    :_widget($button), gulong :$_handler-id
  ) {
    note $button.get-label;
    self.quit;
  }

  #-- [menu] -------------------------------------------------------------------
  # File > New
  method file-new ( N-GVariant $parameter ) {
    my Gnome::Glib::Variant $v .= new(:native-object($parameter));
    note $v.print() if $v.is-valid;
    note "Select 'New' from 'File' menu";
  }

  # File > Quit
  method file-quit ( N-GVariant $parameter ) {
    note "Select 'Quit' from 'File' menu";
    my Gnome::Glib::Variant $v .= new(:native-object($parameter));
    note $v.print() if $v.is-valid;

    self.quit;
  }

  # File > Compressed
  method select-compression (
    N-GVariant $value,
    Gnome::Gio::SimpleAction :_widget($file-compress-action) is copy,
    N-GObject :_native-object($no)
  ) {
    note 'valid action: ', $file-compress-action.is-valid;
    note 'valid no: ', $no.gist;

    $file-compress-action .= new(:native-object($no))
      unless $file-compress-action.is-valid;

    note "Select 'Compressed' from 'File' menu";
#    note $file-compress-action.get-name;
    my Gnome::Glib::Variant $v .= new(:native-object($value));
    note "Set to $v.print()" if $v.is-valid;

    $file-compress-action.set-state(
      Gnome::Glib::Variant.new(:parse("$v.print()"))
    );
  }

  # Help > Index
  method show-index ( N-GVariant $parameter ) {
    note "Select 'Index' from 'Help' menu";
  }

  # Help > About
  method show-about ( N-GVariant $parameter ) {
    note "Select 'About' from 'Help' menu";
  }
}



#-------------------------------------------------------------------------------
my AppSignalHandlers $ah .= new(
#  :app-id('io.github.martimm.test.application'),
  :flags(G_APPLICATION_HANDLES_OPEN), # +| G_APPLICATION_NON_UNIQUE),
  :resource-section<sceleton>
);

exit($ah.run);
