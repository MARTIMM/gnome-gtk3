use v6;
use NativeCall;
use Test;

use Gnome::Glib::List;
use Gnome::Gtk3::ListBox;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::CheckButton;
use Gnome::Gtk3::Label;

#-------------------------------------------------------------------------------
subtest 'Listbox create', {

  my Gnome::Gtk3::ListBox $list-box .= new(:empty);
  isa-ok $list-box, Gnome::Gtk3::ListBox;

  my Gnome::Gtk3::Grid $grid .= new(:empty);
  $grid.set-visible(True);

  my Gnome::Gtk3::CheckButton $check .= new(:label('abc'));
  $check.set-visible(True);
  $grid.gtk-grid-attach( $check(), 0, 0, 1, 1);

  my Gnome::Gtk3::Label $label .= new(:label('first entry'));
  $label.set-visible(True);
  $grid.gtk-grid-attach( $label(), 1, 0, 1, 1);

  $list-box.gtk-container-add($grid);

  my Gnome::Glib::List $gl .= new(:glist($list-box.get-children));
  is $gl.g-list-length, 1, 'One listbox row in listbox';
  my Gnome::Gtk3::Bin $lb-row .= new(
    :widget($list-box.get-row-at-index(0))
  );
  my Gnome::Gtk3::Grid $lb-grid .= new(:widget($lb-row.get_child()));
  $gl .= new(:glist($lb-grid.get-children));
  is $gl.g-list-length, 2, 'Two entries in grid';

  my Gnome::Gtk3::CheckButton $lb-cb .= new(
    :widget($lb-grid.get-child-at( 0, 0))
  );
  is $lb-cb.get-label, 'abc', 'checkbox label found';
}

#-------------------------------------------------------------------------------
done-testing;
