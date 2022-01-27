use v6;
use System::Stats::MEMUsage;

use Gnome::Gtk3::Window;

use Gnome::Glib::MainLoop;


class Timeout {
  has Gnome::Gtk3::Window $!window;

  method run-test ( :$loop --> Int ) {
    my %mem = MEM_Usage();

    state Int $count = 0;
    $!window .= new;
    $!window.set-title('test-window');
    $!window.show-all;

#say "Free (bytes) | Used (bytes) | Usage (%)";
say "%mem<free>.fmt('%12d') %mem<used>.fmt('%12d') %mem<usage-percent>.fmt('%2d')";

    if $count++ >= 5 {
      $loop.quit;       # quit loop
      $count = 2;       # prepare for next test
      G_SOURCE_REMOVE   # destroy timeout struct
    }

    else {
      G_SOURCE_CONTINUE
    }
  }
}


my Gnome::Glib::MainLoop $loop .= new;

my Timeout $to .= new;
my Int $esid = $loop.timeout-add(
  10, $to, 'run-test', :task<jump>, :$loop
);
$loop.run;
