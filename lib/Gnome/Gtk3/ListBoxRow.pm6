use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::ListBoxRow

=SUBTITLE A list container

=head1 Description

A row in a Gnome::Gtk3::ListBox>.

=head2 See Also

C<Gnome::Gtk3::ListBox>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ListBoxRow;
  also is Gnome::Gtk3::Bin;

=head2 Example

  # Get the listbox from a Glade generated gui. Id is choosen
  # to be 'listboxFromGui'.
  my Gnome::Gtk3::ListBox $lb .= new(:build-id<listboxFromGui>);


  my Gnome::Glib::List $gl .= new(:glist($lb.get-children));
  for ^$gl.g-list-length -> $entry-index {
    my Gnome::Gtk3::ListBoxRow $lb-row .=
      new(:widget($lb.get-row-at-index($entry-index)));

    next unless $lb-row.is-selected;

    # This row is selected and has a Grid (for example, can be anything
    # you've created!!)
    my Gnome::Gtk3::Grid $lb-grid .= new(:widget($lb-row.get_child()));
    ...
  }

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ListBoxRow:auth<github:MARTIMM>;
also is Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
#my Bool $signals-added = False;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new
=head3 multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

=head3 multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

=begin comment
=head3 multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.
=end comment
=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  #$signals-added = self.add-signal-types( $?CLASS.^name,
  #  # ... :type<signame>
  #) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::ListBoxRow';

  # process all named arguments
  if ? %options<empty> {
    self.native-gobject(gtk_list_box_row_new());
  }

  elsif ? %options<widget> { # || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('ListBoxRow');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_list_box_row_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  self.set-class-name-of-sub('ListBoxRow');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_list_box_row_new

Creates a new C<Gnome::Gtk3::ListBoxRow>, to be used as a child of a C<Gnome::Gtk3::ListBox>.

Returns: a new C<Gnome::Gtk3::ListBoxRow>

Since: 3.10

  method gtk_list_box_row_new ( --> N-GObject  )


=end pod

sub gtk_list_box_row_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_row_] get_header

Returns the current header of the I<row>. This can be used
in a C<Gnome::Gtk3::ListBoxUpdateHeaderFunc> to see if there is a header
set already, and if so to update the state of it.

Returns: (transfer none) (nullable): the current header, or C<Any> if none

Since: 3.10

  method gtk_list_box_row_get_header ( --> N-GObject  )

=end pod

sub gtk_list_box_row_get_header ( N-GObject $row )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_row_] set_header

Sets the current header of the I<row>. This is only allowed to be called
from a C<Gnome::Gtk3::ListBoxUpdateHeaderFunc>. It will replace any existing
header in the row, and be shown in front of the row in the listbox.

Since: 3.10

  method gtk_list_box_row_set_header ( N-GObject $header )

=item N-GObject $header; (allow-none): the header, or C<Any>

=end pod

sub gtk_list_box_row_set_header ( N-GObject $row, N-GObject $header )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_row_] get_index

Gets the current index of the I<row> in its C<Gnome::Gtk3::ListBox> container.

Returns: the index of the I<row>, or -1 if the I<row> is not in a listbox

Since: 3.10

  method gtk_list_box_row_get_index ( --> Int  )

=end pod

sub gtk_list_box_row_get_index ( N-GObject $row )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_row_] changed

Marks I<row> as changed, causing any state that depends on this
to be updated. This affects sorting, filtering and headers.

Note that calls to this method must be in sync with the data
used for the row functions. For instance, if the list is
mirroring some external data set, and *two* rows changed in the
external data set then when you call C<gtk_list_box_row_changed()>
on the first row the sort function must only read the new data
for the first of the two changed rows, otherwise the resorting
of the rows will be wrong.

This generally means that if you don’t fully control the data
model you have to duplicate the data that affects the listbox
row functions into the row widgets themselves. Another alternative
is to call C<gtk_list_box_invalidate_sort()> on any model change,
but that is more expensive.

Since: 3.10

  method gtk_list_box_row_changed ( )

=end pod

sub gtk_list_box_row_changed ( N-GObject $row )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_row_] is_selected

Returns whether the child is currently selected in its
C<Gnome::Gtk3::ListBox> container.

Returns: C<1> if I<row> is selected

Since: 3.14

  method gtk_list_box_row_is_selected ( --> Int  )

=end pod

sub gtk_list_box_row_is_selected ( N-GObject $row )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_row_] set_selectable

Set the prop C<selectable> property for this row.

Since: 3.14

  method gtk_list_box_row_set_selectable ( Int $selectable )

=item Int $selectable; C<1> to mark the row as selectable

=end pod

sub gtk_list_box_row_set_selectable ( N-GObject $row, int32 $selectable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_row_] get_selectable

Gets the value of the prop C<selectable> property
for this row.

Returns: C<1> if the row is selectable

Since: 3.14

  method gtk_list_box_row_get_selectable ( --> Int  )

=end pod

sub gtk_list_box_row_get_selectable ( N-GObject $row )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_row_] set_activatable

Set the prop C<activatable> property for this row.

Since: 3.14

  method gtk_list_box_row_set_activatable ( Int $activatable )

=item Int $activatable; C<1> to mark the row as activatable

=end pod

sub gtk_list_box_row_set_activatable ( N-GObject $row, int32 $activatable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_list_box_row_] get_activatable

Gets the value of the prop C<activatable> property
for this row.

Returns: C<1> if the row is activatable

Since: 3.14

  method gtk_list_box_row_get_activatable ( --> Int  )

=end pod

sub gtk_list_box_row_get_activatable ( N-GObject $row )
  returns int32
  is native(&gtk-lib)
  { * }
