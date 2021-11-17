use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;

my Gnome::Gtk3::Main $m .= new;


class AppSignalHandlers {

  method first-button-click ( :_widget($b1), :other-button($b2) ) {     # 6
    $b1.set-sensitive(False);
    $b2.set-sensitive(True);
  }

  method second-button-click ( ) {                                      # 7
    $m.quit;
  }

  method exit-program ( ) {
    $m.quit;
  }
}

my AppSignalHandlers $ash .= new;


with my Gnome::Gtk3::Button $button .= new(:label('Hello World')) {     # 1
  .register-signal(
    $ash, 'first-button-click', 'clicked', :other-button($second)       # 2
  );
}

with my Gnome::Gtk3::Button $second .= new(:label('Goodbye')) {
  .set-sensitive(False);                                                # 3
  .register-signal( $ash, 'second-button-click', 'clicked');
}


with my Gnome::Gtk3::Grid $grid .= new {                                # 4
  .attach( $button, 0, 0, 1, 1);
  .attach( $second, 0, 1, 1, 1);
}


with my Gnome::Gtk3::Window $top-window .= new {
  .set-title('Hello GTK!');
  .set-border-width(20);                                                # 5
  .add($grid);
  .register-signal( $ash, 'exit-program', 'destroy');
  .show-all;
}


$m.main;
