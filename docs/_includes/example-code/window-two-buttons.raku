use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Button;

my Gnome::Gtk3::Main $m .= new;

class AppSignalHandlers {

  method button-exit ( ) {
    $m.quit;
  }

  method exit-program ( ) {
    $m.quit;
  }
}

my AppSignalHandlers $ash .= new;

with my Gnome::Gtk3::Button $button1 .= new(
  :label('Exit Our Very Lovely Program')
) {
  .register-signal( $ash, 'button-exit', 'clicked');
}

with my Gnome::Gtk3::Button $button2 .= new(
  :label('Exit too with button two')
) {
  .register-signal( $ash, 'button-exit', 'clicked');
}

with my Gnome::Gtk3::Window $top-window .= new {
  .set-title('With 2 Buttons');
  .add($button1);
  .add($button2);
  .register-signal( $ash, 'exit-program', 'destroy');
  .show-all;
}

$m.main;
