use v6;

use Gnome::Gtk3::Main;                                                # 1
use Gnome::Gtk3::Window;

my Gnome::Gtk3::Main $m .= new;                                       # 2

class AppSignalHandlers {                                             # 3
  method exit-program ( ) { $m.quit; }
}

my Gnome::Gtk3::Window $top-window .= new;                            # 4
$top-window.set-title('Example');

my AppSignalHandlers $ash .= new;                                     # 5
$top-window.register-signal( $ash, 'exit-program', 'destroy');

$top-window.show-all;                                                 # 6

$m.main;                                                              # 7
