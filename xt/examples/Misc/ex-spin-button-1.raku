use v6;

use Gnome::Gtk3::Adjustment:api<1>;
use Gnome::Gtk3::Window:api<1>;
use Gnome::Gtk3::Grid:api<1>;
use Gnome::Gtk3::Label:api<1>;
use Gnome::Gtk3::SpinButton:api<1>;
use Gnome::Gtk3::Main:api<1>;

class X {

  method quit ( ) {
    Gnome::Gtk3::Main.new.gtk-main-quit;
  }

  method show-value (
    Gnome::Gtk3::SpinButton :_widget($button), Gnome::Gtk3::Label :$label
  ) {
    $label.set-text($button.get-value.Str);
  }

  method create-floating-spin-button ( ) {

    my Gnome::Gtk3::Adjustment $adjustment .= new(
      :value(2.500), :lower(0.0), :upper(5.0),
      :step-increment(0.001), :page-increment(0.1),
      :page-size(0.0)
    );

    my Gnome::Gtk3::Label $label .= new(:text(''));

    # creates the spinbutton, with three decimal places
    my Gnome::Gtk3::SpinButton $button .= new(
      :$adjustment, :climb_rate(0.001), :digits(3)
    );
    $button.register-signal( self, 'show-value', 'value-changed', :$label);

    given my Gnome::Gtk3::Grid $grid .= new {
      .grid-attach( $button, 0, 0, 1, 1);
      .grid-attach( $label, 0, 1, 1, 1);
    }

    given my Gnome::Gtk3::Window $window .= new {
      .set-title('my 2nd spin button demo');
      .set-border-width(5);
      .container_add($grid);
      .register-signal( self, 'quit', 'destroy');
      .show_all;
    }
  }
}

my X $x .= new;
$x.create-floating-spin-button;
Gnome::Gtk3::Main.new.gtk-main;
