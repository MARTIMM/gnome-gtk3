use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;

my Gnome::Gtk3::Main $m .= new;


class AppSignalHandlers { ... }
my AppSignalHandlers $ash .= new;


with my Gnome::Gtk3::Button $lower-button .= new(:label('Goodbye')) {   # 1
  .set-sensitive(False);                                                # 2
  .register-signal( $ash, 'lower-button-click', 'clicked');
}

with my Gnome::Gtk3::Button $upper-button .= new(:label('Hello World')) {
  .register-signal(
    $ash, 'upper-button-click', 'clicked', :$lower-button               # 3
  );
}

with my Gnome::Gtk3::Grid $grid .= new {                                # 4
  .attach( $upper-button, 0, 0, 1, 1);
  .attach( $lower-button, 0, 1, 1, 1);
}

with my Gnome::Gtk3::Window $top-window .= new {
  .set-title('Hello GTK!');
  .set-border-width(20);                                                # 5
  .add($grid);
  .register-signal( $ash, 'exit-program', 'destroy');
  .show-all;
}

$m.main;


class AppSignalHandlers {
  method upper-button-click ( :_widget($b1), :lower-button($b2) ) {     # 6
    $b1.set-sensitive(False);
    $b2.set-sensitive(True);
  }

  method lower-button-click ( ) {                                       # 7
    $m.quit;
  }

  method exit-program ( ) {
    $m.quit;
  }
}
