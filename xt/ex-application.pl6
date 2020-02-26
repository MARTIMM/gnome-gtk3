#!/usr/bin/env raku

use v6.d;
#use lib '../gnome-gobject/lib';
use lib '../gnome-gio/lib';
#use lib 'lib';

use Gnome::Gio::Enums;
use Gnome::Gio::MenuModel;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Application;
use Gnome::Gtk3::ApplicationWindow;
use Gnome::Gtk3::Builder;

use Gnome::N::X;
#Gnome::N::debug(:on);


my Gnome::Gtk3::Main $m .= new;

class AppSignalHandlers {
  method exit-program ( --> Int ) {
    $m.gtk-main-quit;

    1
  }

  method app-registered (
    Gnome::Gtk3::Application :widget($app), :$grid, :$menubar
    --> Int
  ) {
    note 'registered';

    $app.set-menubar($menubar);

    my Gnome::Gtk3::ApplicationWindow $app-window .= new(:application($app));

    $app-window.set-title('Application Window Test');
    $app-window.set-border-width(20);
    $app-window.register-signal( self, 'exit-program', 'destroy');

    $app-window.container-add($grid);

    $app-window.show-all;

    1
  }
}


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

my AppSignalHandlers $ah .= new;

my Gnome::Gtk3::Builder $builder .= new(:string($gui-interface));
my Gnome::Gio::MenuModel $menubar .= new(:build-id<menubar>);

# prepare widgets which are directly below window
my Gnome::Gtk3::Grid $grid .= new;
my Gnome::Gtk3::Button $b1 .= new(:label<Start>);
$b1.register-signal( $ah, 'exit-program', 'clicked');
my Gnome::Gtk3::Button $b2 .= new(:label<Stop>);
$b2.register-signal( $ah, 'exit-program', 'clicked');
$grid.grid-attach( $b1, 0, 0, 1, 1);
$grid.grid-attach( $b2, 1, 0, 1, 1);

my Gnome::Gtk3::Application $app .= new(
  :app-id<appTest.io.github.martimm>, :flags(G_APPLICATION_NON_UNIQUE)
);
$app.register-signal(
  $ah, 'app-registered', 'startup', :$grid, :$menubar
);

my Gnome::Glib::Error $e = $app.application-register;
die $e.message if $e.is-valid;
#note 'Reg\'ged: ', $app.get-is-registered;

$m.gtk-main;
