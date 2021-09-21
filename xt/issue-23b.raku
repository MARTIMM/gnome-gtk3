use v6.d;
#use lib '../gnome-native/lib';#, '../gnome-gobject/lib';

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Notebook;
use Gnome::Gtk3::Main;

use Gnome::N::N-GObject;


class ExtendedLabel is Gnome::Gtk3::Label {
	has Str $.custom-data;
	method new ( |c ) {
		self.bless( :GtkLabel, |c );
	}

  submethod BUILD ( Str :$!custom-data, :$native-object? ) {
    # when imported, get data
    if $native-object {
      $!custom-data = self.get-data( 'custom-data', Str);
#note "got $!custom-data";
    }

    # otherwise, set data
    else {
#note "set $!custom-data";
      self.set-data( 'custom-data', $!custom-data);
    }
  }
}


my ExtendedLabel $elabel .= new(
  :custom-data('some data contents'), :text('words')
);


class Handlers {
	method on-close {
		Gnome::Gtk3::Main.new.quit;
	}

	method show-data ( :$notebook ) {
    my Gnome::Gtk3::Grid $grid = $notebook.get-nth-page-rk(0);
    my ExtendedLabel $elabel = $grid.get-child-at-rk(
      0, 0, :child-type(ExtendedLabel)
    );
    say $elabel.custom-data;
	}
}
my Handlers $handler .= new;


my Gnome::Gtk3::Grid $grid .= new;
$grid.set-border-width(10);

my Gnome::Gtk3::Notebook $notebook .= new;
$notebook.append-page(
  $grid, Gnome::Gtk3::Label.new(:text('title of this page'))
);

my Gnome::Gtk3::Button $button .= new(:label<Show>);
$button.register-signal( $handler, 'show-data', 'clicked', :$notebook);

$grid.attach( $elabel, 0, 0, 1, 1);
$grid.attach( $button, 0, 1, 1, 1);


my Gnome::Gtk3::Window $window .= new;
$window.add($notebook);
$window.show-all;
$window.register-signal( $handler, 'on-close', 'destroy');
Gnome::Gtk3::Main.new.main;
