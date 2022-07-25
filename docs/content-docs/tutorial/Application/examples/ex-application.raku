#!/usr/bin/env raku

use v6.d;
use lib '/home/marcel/Languages/Raku/Projects/gnome-gtk3/lib';
#use lib '/home/marcel/Languages/Raku/Projects/gnome-gobject/lib';
#use lib '../gnome-native/lib';
#use lib '../gnome-glib/lib';
#use lib '/home/marcel/Languages/Raku/Projects/gnome-gio/lib';
#use lib 'lib';

use NativeCall;
use Getopt::Long;

use Gnome::N::N-GObject;
#use Gnome::N::GlibToRakuTypes;

use Gnome::Glib::Variant;
use Gnome::Glib::VariantType;
#use Gnome::Glib::VariantDict;

#use Gnome::GObject::Value;
#use Gnome::GObject::Type;

use Gnome::Gio::Enums;
use Gnome::Gio::Resource;
use Gnome::Gio::ApplicationCommandLine;
use Gnome::Gio::MenuModel;
#use Gnome::Gio::SimpleAction;
use Gnome::Gio::Notification;

#use Gnome::Gtk3::MenuBar;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Application;
use Gnome::Gtk3::ApplicationWindow;
use Gnome::Gtk3::Builder;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
class AppSignalHandlers:ver<0.4.3> is Gnome::Gtk3::Application {

  constant APP-ID = 'io.github.martimm.tutorial';

  has Str $!app-rbpath;
#  has Gnome::Gtk3::Application $!app;
  has Gnome::Gtk3::Grid $!grid;
  has Gnome::Gio::MenuModel $!menubar;
#  has Gnome::Gtk3::MenuBar $!menubar;
  has Gnome::Gtk3::ApplicationWindow $!app-window;
  has Str $!resource-section = '-';

  #-----------------------------------------------------------------------------
  submethod new ( |c ) {
    self.bless( :GtkApplication, :app-id(APP-ID), |c);
  }

  #-----------------------------------------------------------------------------
  submethod BUILD ( Str :$!resource-section ) {
#CONTROL { when CX::Warn {  note .gist; .resume; } }

    my Gnome::Gio::Resource $r .= new(:load<GResources/Application.gresource>);
    $r.register;

    # startup signal fired after registration; only primary
    #self.register-signal( self, 'app-startup', 'startup');

    # fired after g_application_quit
    #self.register-signal( self, 'app-shutdown', 'shutdown');

    # fired after g_application_run
    self.register-signal( self, 'app-activate', 'activate');

    self.register-signal( self, 'local-options', 'handle-local-options');
    self.register-signal( self, 'remote-options', 'command-line');

    # set register session property
    #my Gnome::GObject::Value $gv .= new(:init(G_TYPE_BOOLEAN));
    #$gv.set-boolean(True);
    #self.set-property( 'register-session', $gv);
    #self.register-signal( self, 'app-end-session', 'query-end');

    #self.set-default;
#`{{
    self.add-main-option(
      'version', 'v', G_OPTION_FLAG_IN_MAIN,
      G_OPTION_ARG_NONE, 'display version of app'
    );

    self.add-main-option(
      'xyz', 'x', G_OPTION_FLAG_IN_MAIN,
      G_OPTION_ARG_NONE, 'show xyz'
    );
}}

    note 'before registering: ', self.get-is-registered;

    # now we can register the application.
    my Gnome::Glib::Error $e = self.register;
    die $e.message if $e.is-valid;

    note 'after registering: ', self.get-dbus-object-path;
  }

  #-----------------------------------------------------------------------------
  # NOTE: Do not use this: 'AppSignalHandlers() :_native-object($app)' because
  # the coercion process will create a new object, this object!
  method app-startup ( ) {
note 'app registered';
  }

  #-----------------------------------------------------------------------------
  method app-activate ( ) {
note 'app activated';
#CONTROL { when CX::Warn {  note .gist; .resume; } }

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
    $!app-window.register-signal( self, 'exit-program', 'destroy', :win-man);

    # prepare widgets which are directly below window
    $!grid .= new;
    $!grid.set-border-width(20);
    my Gnome::Gtk3::Button $b1 .= new(:label<Stop>);
    $!grid.grid-attach( $b1, 0, 0, 1, 1);
    $b1.register-signal( self, 'exit-program', 'clicked');

    $!app-window.add($!grid);
    $!app-window.show-all;

    note "\nInfo:\n  Registered: ", self.get-is-registered;
    note '  resource base path: ', $!app-rbpath;
    note '  app id: ', self.get-application-id;

    my Gnome::Gio::Notification $notification .= new(:title<donnit-beenthere>);
    $notification.set-body(Q:to/EOBODY/);
      een verhaaltje dat niet veel zegt
      maar alleen wil opmerken dat de
      applicatie helemaal voor je klaar
      staat, dus …
      EOBODY

    $notification.set-priority(G_NOTIFICATION_PRIORITY_URGENT);

    my Str $title = 'ex-app-note';
    self.send-notification( $title, $notification);
    self.start-thread(
      self, 'remove-notification', :start-time(now+5), :$title
    );
  }

  #-----------------------------------------------------------------------------
  method remove-notification ( :$title ) {
    note 'remove message';
    self.withdraw-notification($title);
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
  method local-options ( N-GObject $n-vd, --> Int ) {
#note 'local options: ', @*ARGS.gist;

#`{{ works combined with self.add-main-option(…)
    my Gnome::Glib::VariantDict $vd .= new(:native-object($n-vd));
    if $vd.contains('version') or $vd.contains('v') {
      note 'Version: ', self.^ver;
    }
}}

    # default continue app
    my Int $exit-code = -1;

    CATCH { default { .message.note; $exit-code = 1; return $exit-code; } }
    my Capture $o = get-options( 'version', 'show:s');
    if $o<version> {
      note "Version of $?CLASS.gist(); {self.^ver}";
      $exit-code = 0;
    }

#note $o.gist;

    note "return with $exit-code\n";
    $exit-code
  }

  #-----------------------------------------------------------------------------
  method remote-options ( Gnome::Gio::ApplicationCommandLine() $cl --> Int ) {

    my Int $exit-code = 0;
    my Array $args = $cl.get-arguments;
#note "remote args: $args.gist()";
    my Capture $o = get-options-from( $args[1..*-1], 'version', 'show:s');
#note $o.gist;
    my Str $file-to-show = $o.<show> if ($o.<show> // '') and $o.<show>.IO.r;


#for @$o -> $a {
#  note "arg : $a";
#}

    self.activate unless $cl.get-is-remote;

    if ?$file-to-show {
      $cl.print("Show text from $file-to-show\n");
      #… show file in window …
    }

    # if not cleared, remote keeps running!
    $cl.clear-object;

    $exit-code
  }

#`{{
  #-----------------------------------------------------------------------------
  method app-end-session ( ) {
note 'session end';
  }

  #-----------------------------------------------------------------------------
  method app-shutdown ( ) {
note 'app shutdown';
  }
}}

  #-- [button] -----------------------------------------------------------------
  # when triggered by window manager, $win-man is True. Otherwise widget
  # is a button and a label can be retrieved
  method exit-program (
    :$_native-object, Bool :$win-man = False
  ) {
    note $_native-object.().get-label unless $win-man;
    self.quit;
  }

  #-- [menu] -------------------------------------------------------------------
  # File > New
  method file-new ( Gnome::Glib::Variant() $parameter ) {
    note $parameter.print() if $parameter.is-valid;
    note "Select 'New' from 'File' menu";
  }

  # File > Quit
  method file-quit ( Gnome::Glib::Variant() $parameter ) {
    note "Select 'Quit' from 'File' menu";
    note $parameter.print() if $parameter.is-valid;

    self.quit;
  }

  # File > Compressed
  method select-compression (
    Gnome::Glib::Variant() $value,
    Gnome::Gio::SimpleAction() :_native-object($file-compress-action)
  ) {
    note 'valid action: ', $file-compress-action.is-valid;
    note "Select 'Compressed' from 'File' menu";
#    note $file-compress-action.get-name;
    note "Set to $value.print()" if $value.is-valid;

    $file-compress-action.set-state(
      Gnome::Glib::Variant.new(:parse("$value.print()"))
    );
  }

  # Help > Index
  method show-index ( N-GObject $parameter ) {
    note "Select 'Index' from 'Help' menu";
  }

  # Help > About
  method show-about ( N-GObject $parameter ) {
    note "Select 'About' from 'Help' menu";
  }
}

#-------------------------------------------------------------------------------
my Int $flags = 0;
#$flags +|= G_APPLICATION_HANDLES_OPEN;          # if $*open;
$flags +|= G_APPLICATION_HANDLES_COMMAND_LINE;  # if $*cmd;
#$flags +|= G_APPLICATION_SEND_ENVIRONMENT;
#$flags +|= G_APPLICATION_IS_SERVICE;
# +| G_APPLICATION_NON_UNIQUE),



my AppSignalHandlers $ah .= new(
#  :app-id('io.github.martimm.test.application'),
  :$flags, :resource-section<sceleton>
);

my Int $ec = $ah.run // 1;
note 'exit code: ', $ec;
$ah.clear-object;
exit($ec);
