use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Button;                                                # 1

my Gnome::Gtk3::Main $m .= new;

class AppSignalHandlers {
  method button-exit ( ) { $m.quit; }                                   # 2
  method exit-program ( ) { $m.quit; }
}

my Gnome::Gtk3::Window $top-window .= new;
$top-window.set-title('With Button');                                   # 3

my Gnome::Gtk3::Button $button .= new(                                  # 4
  :label('Exit Our Very Lovely Program')
);
$top-window.add($button);                                               # 5

$button.register-signal( $ash, 'button-exit', 'clicked');               # 6
$top-window.register-signal( $ash, 'exit-program', 'destroy');

$top-window.show-all;

$m.main;
