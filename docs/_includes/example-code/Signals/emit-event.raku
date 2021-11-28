use v6;

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::CheckButton;

#--------------------------------------------------------------------------
class X {
  has Array[Gnome::Gtk3::CheckButton] $!cba;

  submethod BUILD ( :$grid ) {
    $!cba .= new;
    for ^20 -> $i {                                                     # 1
      my Gnome::Gtk3::CheckButton $cb .= new;
      given $cb {
        .set-name("$i");
        .set-hexpand(True);
        .set-vexpand(True);
      }

      $grid.attach( $cb, $i, 0, 1, 1);

      $cb.register-signal( self, 'check-box-toggle', 'toggled');        # 2
      $!cba.push: $cb;
    }
  }

  method exit-app ( ) {
    Gnome::Gtk3::Main.new.gtk-main-quit;
  }

  method check-box-toggle ( Gnome::Gtk3::CheckButton :_widget($cb) ) {
    note "Picked box $cb.get-name()";
  }

  method pick-a-box ( ) {
    $!cba.pick.emit-by-name('clicked');
  }
}

#--------------------------------------------------------------------------
my Gnome::Gtk3::Grid $grid .= new;
my X $x .= new(:$grid);

my Gnome::Gtk3::Button $button .= new(:label('Pick a Box'));            # 3
$button.register-signal( $x, 'pick-a-box', 'clicked');
$grid.attach( $button, 0, 1, 20, 1);                                    # 4

with my Gnome::Gtk3::Window $window .= new  {
  .add($grid);
  .set-title('event');
  .set-border-width(2);
  .set_size_request( 200, 70);
  .register-signal( $x, 'exit-app', 'destroy');
  .show-all;
}

Gnome::Gtk3::Main.new.main;
