use v6;
#use lib '../gnome-gobject/lib';
#use NativeCall;

#use Gnome::N::NativeLib;
#use Gnome::N::N-GObject;
#use Gnome::Glib::Main;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Scale;

#use Gnome::GObject::Signal;

use Semaphore::ReadersWriters;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
class X {
  has Bool $!running-update = False;
  has Semaphore::ReadersWriters $!rw-sem;
  has Promise $!promise;
  has Num $!step;
  has Gnome::Gtk3::Main $!main;

  submethod BUILD ( ) {
    $!rw-sem .= new;
    #$!rw-sem.debug = True;
    $!rw-sem.add-mutex-names(
      <running-sem promise>, :RWPatternType(C-RW-WRITERPRIO));

    $!main .= new;
    $!step = 1e-1;
  }

  method exit-app ( ) {
    $!main.gtk-main-quit;
  }

  method update-scale (
    Gnome::Gtk3::Button :_widget($button), Gnome::Gtk3::Scale :$scale
  ) {
    while $!rw-sem.reader( 'running-sem', { $!running-update; }) {
      my Num $v = $scale.get-value + $!step;
      note "begin; $v";

      if $v >= 1e0 {
        $!step = -1e-1;
        $v = 1e0;
      }

      elsif $v <= 0e0 {
        $!step = 1e-1;
        $v = 0e0;
      }

      $scale.set-value($v);
      sleep(1.1);
    }

    # return result of promise
    'stopped running'
  }

  method start-update (
    Gnome::Gtk3::Button :_widget($button),
    Gnome::Gtk3::Scale :$scale
  ) {
    return if $!rw-sem.reader( 'promise', { $!promise.defined });

    $!rw-sem.writer( 'running-sem', { $!running-update = True; });
    $!rw-sem.writer( 'promise', {
        $!promise = $button.start-thread(
          self, 'update-scale', :start-time(now + 1.1),
          :new-context, :$scale
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
my X $x .= new;

my Gnome::Gtk3::Window $window .= new;
$window.set-title('window');

my Gnome::Gtk3::Grid $grid .= new;
$window.container-add($grid);

my Gnome::Gtk3::Scale $scale .= new;
$scale.set-range( 0.0, 1.0);
$scale.set-value-pos(GTK_POS_BOTTOM);
$scale.set-digits(2);
$scale.set_size_request( 300, 50);
$grid.grid-attach( $scale, 0, 0, 1, 1);

my Gnome::Gtk3::Button $button-start .= new(:label('Start Update'));
$grid.grid-attach( $button-start, 0, 1, 1, 1);
$button-start.register-signal( $x, 'start-update', 'clicked', :$scale);

my Gnome::Gtk3::Button $button-stop .= new(:label('Stop Update'));
$grid.grid-attach( $button-stop, 0, 2, 1, 1);
$button-stop.register-signal( $x, 'stop-update', 'clicked');

$window.register-signal( $x, 'exit-app', 'destroy');
$window.show-all;
Gnome::Gtk3::Main.new.gtk-main;
