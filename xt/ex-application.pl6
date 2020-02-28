#!/usr/bin/env raku

use v6.d;
#use lib '../gnome-gobject/lib';
use lib '../gnome-native/lib';
use lib '../gnome-gio/lib';
#use lib 'lib';

use Gnome::Gio::Enums;
use Gnome::Gio::MenuModel;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Application;
use Gnome::Gtk3::ApplicationWindow;
use Gnome::Gtk3::Builder;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Str $gui-interface = Q:to/EOMENU/;
  <interface>
    <menu id="menubar">
      <section>
        <item>
          <attribute name="label" translatable="yes">Incendio</attribute>
          <attribute name="action">app.incendio</attribute>
        </item>
      </section>
      <section>
        <attribute name="label" translatable="yes">Defensive Charms</attribute>
        <item>
          <attribute name="label" translatable="yes">Expelliarmus</attribute>
          <attribute name="action">app.expelliarmus</attribute>
          <!--attribute name="icon">/usr/share/my-app/poof!.png</attribute-->
        </item>
      </section>
    </menu>
  </interface>
  EOMENU


#-------------------------------------------------------------------------------
class AppSignalHandlers {

  has Gnome::Gtk3::Application $!app;
  has Gnome::Gtk3::Grid $!grid;
  has Gnome::Gio::MenuModel $!menubar;
  has Gnome::Gtk3::ApplicationWindow $!app-window;

  #-----------------------------------------------------------------------------
  submethod BUILD ( ) {

    $!app .= new(
      :app-id<io.github.martimm.test.application>,
      :flags(G_APPLICATION_NON_UNIQUE),
      :!initialize
    );

    # startup signal fired after registration
    $!app.register-signal( self, 'app-startup', 'startup');

    # fired after g_application_quit
    $!app.register-signal( self, 'app-shutdown', 'shutdown');

    # fired after g_application_run
    $!app.register-signal( self, 'app-activate', 'activate');

    #
    $!app.register-signal( self, 'app-open', 'open');

    # now we can register the application.
    my Gnome::Glib::Error $e = $!app.register;
    die $e.message if $e.is-valid;
  }

  #-----------------------------------------------------------------------------
  method app-startup ( Gnome::Gtk3::Application :widget($!app) ) {
note 'app registered';
    $!app.run;
  }

  #-----------------------------------------------------------------------------
  method app-shutdown ( Gnome::Gtk3::Application :widget($!app) ) {
note 'app shutdown';
  }

  #-----------------------------------------------------------------------------
  method app-activate ( Gnome::Gtk3::Application :widget($!app) ) {
note 'app activated';

    my Gnome::Gtk3::Builder $builder .= new(:string($gui-interface));
    $!menubar .= new(:build-id<menubar>);
    $!app.set-menubar($!menubar);

    $!app-window .= new(:application($!app));
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


    note "\nInfo:\n  Registered: ", $!app.get-is-registered;
    note '  resource base path: ', $!app.get-resource-base-path;
    note '  app id: ', $!app.get-application-id;
  }

  #-----------------------------------------------------------------------------
  method app-open ( Gnome::Gtk3::Application :widget($!app) ) {
note 'app open';
  }

  #-----------------------------------------------------------------------------
  method exit-program ( --> Int ) {
    $!app.quit;

    1
  }
}



#-------------------------------------------------------------------------------
my AppSignalHandlers $ah .= new;
