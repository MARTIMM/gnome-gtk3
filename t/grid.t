use v6;
use NativeCall;
use Test;

use Gnome::Glib::List;
use Gnome::Gtk3::Container;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Label;

diag "\n";

#-------------------------------------------------------------------------------
subtest 'Grid create', {

  my Gnome::Gtk3::Button $button .= new(:label('press here'));
  my Gnome::Gtk3::Label $label .= new(:label('note'));

  my Gnome::Gtk3::Grid $grid .= new(:empty);
  $grid.gtk-grid-attach( $button, 0, 0, 1, 1);
  $grid.gtk-grid-attach( $label, 0, 1, 1, 1);

  my Gnome::Gtk3::Label $label-widget .= new(
    :widget($grid.get-child-at( 0, 1))
  );
  is $label-widget.get-text, 'note', 'text from label';

  my Gnome::Glib::List $gl .= new(:glist($grid.get-children));
  is $gl.g-list-length, 2, 'two list items';

#note $gl.nth-data(1);
  $label-widget($gl.nth-data-gobject(0));
  is $label-widget.get-text, 'note', 'text from label';

  $gl.g-list-free;
  $gl = Gnome::Glib::List;

#  $grid(@widgets[0]);
#  $label-widget($grid.get-child-at( 0, 1));
#  is $label-widget.get-text, 'note', 'text from label';
}

#-------------------------------------------------------------------------------
done-testing;
