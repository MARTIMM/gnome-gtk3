use v6;

use Gnome::Gtk3::Main:api<1>;                                          # ①
use Gnome::Gtk3::Window:api<1>;

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
