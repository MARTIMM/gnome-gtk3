use v6;
use NativeCall;
use Test;

use Gnome::Glib::List;
use Gnome::Gtk3::ListBox;
use Gnome::Gtk3::ListBoxRow;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::CheckButton;
use Gnome::Gtk3::Label;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::ListBox $lb .= new(:empty);
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $lb, Gnome::Gtk3::ListBox;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  # Create an entry in a ListBox. This is a grid containing a CheckButton
  # and a Label
  my Gnome::Gtk3::Grid $grid .= new(:empty);
#  $grid.set-visible(True);

  my Gnome::Gtk3::CheckButton $check .= new(:label('abc'));
#  $check.set-visible(True);
  $grid.gtk-grid-attach( $check(), 0, 0, 1, 1);

  my Gnome::Gtk3::Label $label .= new(:label('first entry'));
#  $label.set-visible(True);
  $grid.gtk-grid-attach( $label(), 1, 0, 1, 1);

  # Add the grid to the ListBox
  $lb.gtk-container-add($grid);

  # Get a list of widgets. There is only one row and is a ListBoxRow. This
  # widget is automatically inserted when the grid was added to the ListBox.
  my Gnome::Glib::List $gl .= new(:glist($lb.get-children));
  is $gl.g-list-length, 1, 'one listbox row in listbox';

  # Get the row and create the ListBoxRow from the native object
  my Gnome::Gtk3::ListBoxRow $lb-row .= new(
    :widget($lb.get-row-at-index(0))
  );

  is $lb-row.is-selected, 0, 'row is not selected';

  # Get the native grid object from a child and create the Grid again.
  my Gnome::Gtk3::Grid $lb-grid .= new(:widget($lb-row.get_child()));
  $gl .= new(:glist($lb-grid.get-children));
  is $gl.g-list-length, 2, 'two entries in grid';

  my Gnome::Gtk3::CheckButton $lb-cb .= new(
    :widget($lb-grid.get-child-at( 0, 0))
  );
  is $lb-cb.get-label, 'abc', 'checkbox label found';
}

#-------------------------------------------------------------------------------
done-testing;
