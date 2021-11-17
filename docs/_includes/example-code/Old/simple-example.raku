use v6;

use Gnome::Gtk3::Main;                                          # ①
use Gnome::Gtk3::Window;

my Gnome::Gtk3::Main $m .= new;                                 # ②

class AppSignalHandlers {                                       # ③
  method exit-program ( ) { $m.quit; }
}

my Gnome::Gtk3::Window $top-window .= new;                      # ④
$top-window.set-title('Example');

my AppSignalHandlers $ash .= new;                               # ⑤
$top-window.register-signal( $ash, 'exit-program', 'destroy');

$top-window.show-all;                                           # ⑥

$m.main;                                                        # ⑦
