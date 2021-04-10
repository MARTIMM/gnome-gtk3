use v6;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Scale;

use Semaphore::ReadersWriters;

#-------------------------------------------------------------------------------
class X {
  has Bool $!running-update = False;
  has Semaphore::ReadersWriters $!rw-sem;
  has Promise $!promise;
  has Num $!step;
  has Gnome::Gtk3::Main $!main;
  has Gnome::Gtk3::Scale $!scale;

  submethod BUILD ( Gnome::Gtk3::Scale :$!scale, Num :$!step = 1e-1 ) {
    $!rw-sem .= new;
    $!rw-sem.add-mutex-names(
      <running-sem promise>, :RWPatternType(C-RW-WRITERPRIO)
    );

    $!main .= new;
  }

  method exit-app ( ) {
    $!main.gtk-main-quit;
  }

  method update-scale ( ) {
    while $!rw-sem.reader( 'running-sem', { $!running-update; }) {
      my Num $v = $!scale.get-value + $!step;
      note "value; $v";

      if $v >= 1e0 or $v <= 0e0 {
        $!step = -$!step;
      }

      $!scale.set-value($v);
      sleep(1.1);
    }

    # return result of promise
    'stopped running'
  }

  method start-update ( Gnome::Gtk3::Button :_widget($button) ) {
    return if $!rw-sem.reader( 'promise', { $!promise.defined });

    $!rw-sem.writer( 'running-sem', { $!running-update = True; });
    $!rw-sem.writer( 'promise', {
        $!promise = $button.start-thread(
          self, 'update-scale', :start-time(now + 1.1),
          :new-context
        );
      }
    );
  }

  method stop-update ( Gnome::Gtk3::Button :_widget($button) ) {
    $!rw-sem.writer( 'running-sem', { $!running-update = False; });

    $!rw-sem.writer( 'promise', {
        await $!promise if $!promise.defined;
        $!promise = Promise;
      }
    );
  }
}

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Window $window .= new;
$window.set-title('window');

my Gnome::Gtk3::Grid $grid .= new;
$window.add($grid);

my Gnome::Gtk3::Scale $scale .= new;
my X $x .= new( :$scale, :step(103e-3));
$grid.grid-attach( $scale, 0, 0, 1, 1);
given $scale {
  .set-hexpand(True);
  .set-vexpand(True);
  .set-halign(GTK_ALIGN_FILL);
  .set-margin-top(5);
  .set-margin-start(10);
  .set-margin-end(10);
  .set-margin-bottom(5);
  .set-range( 0.0, 1.0);
  .set-value-pos(GTK_POS_BOTTOM);
  .set-digits(2);
  .set_size_request( 300, 50);
}

my Gnome::Gtk3::Button $button-start .= new(:label('Start Update'));
$grid.grid-attach( $button-start, 0, 1, 1, 1);
$button-start.register-signal( $x, 'start-update', 'clicked');

my Gnome::Gtk3::Button $button-stop .= new(:label('Stop Update'));
$grid.grid-attach( $button-stop, 0, 2, 1, 1);
$button-stop.register-signal( $x, 'stop-update', 'clicked');

$window.register-signal( $x, 'exit-app', 'destroy');
$window.show-all;
Gnome::Gtk3::Main.new.gtk-main;
