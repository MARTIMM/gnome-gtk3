use v6;
use lib '../gnome-gobject/lib';

use Gnome::N::X;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::ScrolledWindow;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Entry;
use Gnome::Gtk3::Button;

#-------------------------------------------------------------------------------
class X {
  method test-quit ( --> Int ) {
    my Gnome::Gtk3::Main $m0 .= new;
    $m0.gtk-main-quit;
    1
  }

  # in separate thread, keep $m local
  method stop-test ( :$button --> Str ) {

    # get my own main
    my Gnome::Gtk3::Main $m1 .= new;
    while $m1.gtk-events-pending() { $m1.iteration-do(False); }
    $button.emit-by-name('clicked');
    while $m1.gtk-events-pending() { $m1.iteration-do(False); }

    'done'
  }
}

#-------------------------------------------------------------------------------
#Gnome::N::debug(:on);
my Duration $tt;
my Int $count = 5;
my Int $widgets = 100;

for ^$count {
  my Instant $t0 = now;

  my Gnome::Gtk3::Window $win .= new(:title('Stress Test'));
  my Gnome::Gtk3::ScrolledWindow $sw .= new;
  my Gnome::Gtk3::Entry $entry;
  my Gnome::Gtk3::Button $button;

  $win.container-add($sw);
#  $win.register-signal( X.new, 'window-quit', 'destroy');
  $win.set-size-request( 190, 250);

  my Gnome::Gtk3::Grid $grid .= new;
  $sw.container-add($grid);

  for ^$widgets -> $row {
    $grid.grid-attach( $entry .= new, 0, $row, 1, 1);
    $entry.set-text("test entry $row");
  }

  # register a signal on separate button. do not use destroy on window for exit,
  # it will also cleanup a bit halfway. so objects are not to be trusted.
  $grid.grid-attach( $button .= new(:label("Quit Button")), 1, 0, 1, 1);
  $button.register-signal( X.new, 'test-quit', 'clicked');

  my Promise $p = $win.start-thread(
    X.new, 'stop-test', :new-context, :start-time-at(now + 1.5), :$button
  );

  $win.show-all;
  my Duration $t1 = now - $t0;

  Gnome::Gtk3::Main.gtk-main;
  note "result: $p.result() $_";

  $win.widget-destroy;

  $tt += $t1;
}

note "Gui build time: $tt.fmt('%.3f') / $count = {($tt / $count).fmt('%.3f')} per build";
