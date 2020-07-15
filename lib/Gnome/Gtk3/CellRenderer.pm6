#TL:1:Gnome::Gtk3::CellRenderer:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellRenderer

An object for rendering a single cell

=head1 Description

The B<Gnome::Gtk3::CellRenderer> is a base class of a set of objects used for rendering a cell to a B<cairo_t>.  These objects are used primarily by the B<Gnome::Gtk3::TreeView> widget, though they aren’t tied to them in any specific way.  It is worth noting that B<Gnome::Gtk3::CellRenderer> is not a B<Gnome::Gtk3::Widget> and cannot be treated as such.

The primary use of a B<Gnome::Gtk3::CellRenderer> is for drawing certain graphical elements on a B<cairo_t>. Typically, one cell renderer is used to draw many cells on the screen.  To this extent, it isn’t expected that a CellRenderer keeps any permanent state around.  Instead, any state is set just prior to use using B<GObjects> property system.  Then, the cell is measured using C<gtk_cell_renderer_get_size()>. Finally, the cell is rendered in the correct location using C<gtk_cell_renderer_render()>.

=begin comment
There are a number of rules that must be followed when writing a new B<Gnome::Gtk3::CellRenderer>.  First and foremost, it’s important that a certain set of properties will always yield a cell renderer of the same size, barring a B<Gnome::Gtk3::Style> change.  The B<Gnome::Gtk3::CellRenderer> also has a number of generic properties that are expected to be honored by all children.

Beyond merely rendering a cell, cell renderers can optionally provide active user interface elements. A cell renderer can be “activatable” like B<Gnome::Gtk3::CellRendererToggle>, which toggles when it gets activated by a mouse click, or it can be “editable” like B<Gnome::Gtk3::CellRendererText>, which allows the user to edit the text using a B<Gnome::Gtk3::Entry>. To make a cell renderer activatable or editable, you have to implement the C<.activate()> or C<.start_editing()> virtual functions, respectively.
=end comment

Many properties of B<Gnome::Gtk3::CellRenderer> and its subclasses have a corresponding “set” property, e.g. “cell-background-set” corresponds to “cell-background”. These “set” properties reflect whether a property has been set or not. You should not set them independently.

=head2 See Also

B<Gnome::Gtk3::CellRendererText>, B<Gnome::Gtk3::CellRendererPixbuf>, B<Gnome::Gtk3::CellRendererToggle>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRenderer;
  also is Gnome::GObject::InitiallyUnowned;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::InitiallyUnowned;
use Gnome::Gdk3::Events;
use Gnome::Gdk3::Types;
use Gnome::Gtk3::Widget;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::CellRenderer:auth<github:MARTIMM>;
also is Gnome::GObject::InitiallyUnowned;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkCellRendererState

Tells how a cell is to be rendered.

=item GTK_CELL_RENDERER_SELECTED: The cell is currently selected, and probably has a selection colored background to render to.
=item GTK_CELL_RENDERER_PRELIT: The mouse is hovering over the cell.
=item GTK_CELL_RENDERER_INSENSITIVE: The cell is drawn in an insensitive manner
=item GTK_CELL_RENDERER_SORTED: The cell is in a sorted row
=item GTK_CELL_RENDERER_FOCUSED: The cell is in the focus row.
=item GTK_CELL_RENDERER_EXPANDABLE: The cell is in a row that can be expanded. Since 3.4
=item GTK_CELL_RENDERER_EXPANDED: The cell is in a row that is expanded. Since 3.4


=end pod

#TE:0:GtkCellRendererState:t/CellRendererText.t
enum GtkCellRendererState is export (
  'GTK_CELL_RENDERER_SELECTED'    => 1 +< 0,
  'GTK_CELL_RENDERER_PRELIT'      => 1 +< 1,
  'GTK_CELL_RENDERER_INSENSITIVE' => 1 +< 2,
  'GTK_CELL_RENDERER_SORTED'      => 1 +< 3,
  'GTK_CELL_RENDERER_FOCUSED'     => 1 +< 4,
  'GTK_CELL_RENDERER_EXPANDABLE'  => 1 +< 5,
  'GTK_CELL_RENDERER_EXPANDED'    => 1 +< 6
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkCellRendererMode

Identifies how the user can interact with a particular cell.

=item GTK_CELL_RENDERER_MODE_INERT: The cell is just for display and cannot be interacted with.  Note that this doesn’t mean that eg. the row being drawn can’t be selected -- just that a particular element of it cannot be individually modified.
=item GTK_CELL_RENDERER_MODE_ACTIVATABLE: The cell can be clicked.
=item GTK_CELL_RENDERER_MODE_EDITABLE: The cell can be edited or otherwise modified.


=end pod

#TE:0:GtkCellRendererMode:
enum GtkCellRendererMode is export (
  'GTK_CELL_RENDERER_MODE_INERT',
  'GTK_CELL_RENDERER_MODE_ACTIVATABLE',
  'GTK_CELL_RENDERER_MODE_EDITABLE'
);

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 N-GtkRequisition

A N-GtkRequisition represents the desired size of a widget. See GtkWidget’s geometry management section for more information.

=item Int width; the widget’s desired width
=item Int height; the widget’s desired height

=end pod

#TE:0:N-GtkRequisition:
class N-GtkRequisition is repr('CStruct') is export {
  has int32 $.width;
  has int32 $.height;
}
}}
#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<editing-canceled>, :w2<editing-started>,
  ) unless $signals-added;


  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::CellRenderer';

#`{{
  # process all named arguments
  if ? %options<empty> {
    # self.set-native-object(gtk_cell_renderer_new());
  }

  elsif ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}}

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkCellRenderer');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_cell_renderer_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkCellRenderer');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_get_request_mode:t/CellRendererText.t
=begin pod
=head2 [[gtk_] cell_renderer_] get_request_mode

Gets whether the cell renderer prefers a height-for-width layout
or a width-for-height layout.

Returns: The B<GtkSizeRequestMode> enum preferred by this renderer.

Since: 3.0

  method gtk_cell_renderer_get_request_mode ( --> GtkSizeRequestMode  )

=end pod

sub gtk_cell_renderer_get_request_mode ( N-GObject $cell )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_get_preferred_width:t/CellRendererText.t - visual
=begin pod
=head2 [[gtk_] cell_renderer_] get_preferred_width

Retreives a renderer’s natural size when rendered to I<$widget>.

Since: 3.0

  method gtk_cell_renderer_get_preferred_width ( N-GObject $widget --> List )

=item N-GObject $widget; the widget this cell will be rendering to

The method returns a list with
=item Int $minimum_size; the minimum size
=item Int $natural_size; the natural size

=end pod

sub gtk_cell_renderer_get_preferred_width (
  N-GObject $cell, N-GObject $widget
  --> List
) {
  my int32 $minimum_size;
  my int32 $natural_size;
  _gtk_cell_renderer_get_preferred_width(
    $cell, $widget, $minimum_size, $natural_size
  );

  ( $minimum_size, $natural_size)
}

sub _gtk_cell_renderer_get_preferred_width (
  N-GObject $cell, N-GObject $widget,
  int32 $minimum_size is rw, int32 $natural_size is rw
) is native(&gtk-lib)
  is symbol('gtk_cell_renderer_get_preferred_width')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_get_preferred_height_for_width:t/CellRendererText.t - visual
=begin pod
=head2 [[gtk_] cell_renderer_] get_preferred_height_for_width

Retreives a cell renderers’s minimum and natural height if it were rendered to
I<$widget> with the specified I<$width>.

Since: 3.0

  method gtk_cell_renderer_get_preferred_height_for_width (
    N-GObject $widget, Int $width
    --> List
  )
=item N-GObject $widget; the widget this cell will be rendering to
=item Int $width; the size which is available for allocation

Returns a list with
=item Int $minimum_height; the minimum size
=item Int $natural_height; the preferred size

=end pod

sub gtk_cell_renderer_get_preferred_height_for_width (
  N-GObject $cell, N-GObject $widget, Int $width
  --> List
) {
  my int32 $minimum_height;
  my int32 $natural_height;
  _gtk_cell_renderer_get_preferred_height_for_width(
    $cell, $widget, $width, $minimum_height, $natural_height
  );

  ( $minimum_height, $natural_height)
}

sub _gtk_cell_renderer_get_preferred_height_for_width (
  N-GObject $cell, N-GObject $widget, int32 $width,
  int32 $minimum_height is rw, int32 $natural_height is rw
) is native(&gtk-lib)
  is symbol('gtk_cell_renderer_get_preferred_height_for_width')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_get_preferred_height:t/CellRendererText.t - visual
=begin pod
=head2 [[gtk_] cell_renderer_] get_preferred_height

Retreives a renderer’s natural size when rendered to I<$widget>.

Since: 3.0

  method gtk_cell_renderer_get_preferred_height ( N-GObject $widget --> List )

=item N-GObject $widget; the widget this cell will be rendering to

Returns a list with
=item Int $minimum_size; the minimum size
=item Int $natural_size; the natural size

=end pod

sub gtk_cell_renderer_get_preferred_height (
  N-GObject $cell, N-GObject $widget
  --> List
) {
  my int32 $minimum_size;
  my int32 $natural_size;
  _gtk_cell_renderer_get_preferred_height(
    $cell, $widget, $minimum_size, $natural_size
  );

  ( $minimum_size, $natural_size)
}

sub _gtk_cell_renderer_get_preferred_height (
  N-GObject $cell, N-GObject $widget, int32 $minimum_size is rw,
  int32 $natural_size is rw
) is native(&gtk-lib)
  is symbol('gtk_cell_renderer_get_preferred_height')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_get_preferred_width_for_height:t/CellRendererText.t - visual
=begin pod
=head2 [[gtk_] cell_renderer_] get_preferred_width_for_height

Retreives a cell renderers’s minimum and natural width if it were rendered to
I<$widget> with the specified I<$height>.

Since: 3.0

  method gtk_cell_renderer_get_preferred_width_for_height (
    N-GObject $widget, Int $height
    --> List
  )

=item N-GObject $widget; the widget this cell will be rendering to
=item Int $height; the size which is available for allocation

Returns a list with
=item Int $minimum_width; the minimum size
=item Int $natural_width; the preferred size

=end pod

sub gtk_cell_renderer_get_preferred_width_for_height (
  N-GObject $cell, N-GObject $widget, Int $height
  --> List
) {
  my int32 $minimum_width;
  my int32 $natural_width;
  _gtk_cell_renderer_get_preferred_width_for_height(
    $cell, $widget, $height, $minimum_width, $natural_width
  );

  ( $minimum_width, $natural_width)
}

sub _gtk_cell_renderer_get_preferred_width_for_height (
  N-GObject $cell, N-GObject $widget, int32 $height,
  int32 $minimum_width is rw, int32 $natural_width is rw
) is native(&gtk-lib)
  is symbol('gtk_cell_renderer_get_preferred_width_for_height')
  { * }


#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_get_preferred_size:t/CellRendererText.t - visual
=begin pod
=head2 [[gtk_] cell_renderer_] get_preferred_size

Retrieves the minimum and natural size of a cell taking into account the widget’s preference for height-for-width management.

Since: 3.0

  method gtk_cell_renderer_get_preferred_size ( N-GObject $widget --> List )

=item N-GObject $widget; the widget this cell will be rendering to

Returns a list with
=item N-GtkRequisition $minimum_size; the minimum size
=item N-GtkRequisition $natural_size; the natural size

=end pod
sub gtk_cell_renderer_get_preferred_size (
  N-GObject $cell, N-GObject $widget
  --> List
) {
  my N-GtkRequisition $minimum_size .= new;
  my N-GtkRequisition $natural_size .= new;
  _gtk_cell_renderer_get_preferred_size(
    $cell, $widget, $minimum_size, $natural_size
  );
  ( $minimum_size, $natural_size)
}

sub _gtk_cell_renderer_get_preferred_size (
  N-GObject $cell, N-GObject $widget,
  N-GtkRequisition $minimum_size, N-GtkRequisition $natural_size
) is native(&gtk-lib)
  is symbol('gtk_cell_renderer_get_preferred_size')
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_cell_renderer_get_aligned_area:
=begin pod
=head2 [[gtk_] cell_renderer_] get_aligned_area

Gets the aligned area used by I<$cell> inside I<$cell_area>. Used for finding the appropriate edit and focus rectangle.

Since: 3.0

  method gtk_cell_renderer_get_aligned_area (
    N-GObject $widget, GtkCellRendererState $flags, N-GObject $cell_area,
    N-GObject $aligned_area
  )

=item N-GObject $widget; the widget this cell will be rendering to
=item GtkCellRendererState $flags; render flags
=item N-GObject $cell_area; cell area which would be passed to C<gtk_cell_renderer_render()>
=item N-GObject $aligned_area; (out): the return location for the space inside I<cell_area> that would acually be used to render.

=end pod

sub gtk_cell_renderer_get_aligned_area ( N-GObject $cell, N-GObject $widget, int32 $flags, N-GObject $cell_area, N-GObject $aligned_area )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_cell_renderer_render:
=begin pod
=head2 [gtk_] cell_renderer_render

Invokes the virtual render function of the B<Gnome::Gtk3::CellRenderer>. The three
passed-in rectangles are areas in I<cr>. Most renderers will draw within
I<cell_area>; the xalign, yalign, xpad, and ypad fields of the B<Gnome::Gtk3::CellRenderer>
should be honored with respect to I<cell_area>. I<background_area> includes the
blank space around the cell, and also the area containing the tree expander;
so the I<background_area> rectangles for all cells tile to cover the entire
I<window>.

  method gtk_cell_renderer_render ( cairo_t $cr, N-GObject $widget, N-GObject $background_area, N-GObject $cell_area, GtkCellRendererState $flags )

=item cairo_t $cr; a cairo context to draw to
=item N-GObject $widget; the widget owning I<window>
=item N-GObject $background_area; entire cell area (including tree expanders and maybe  padding on the sides)
=item N-GObject $cell_area; area normally rendered by a cell renderer
=item GtkCellRendererState $flags; flags that affect rendering

=end pod

sub gtk_cell_renderer_render ( N-GObject $cell, cairo_t $cr, N-GObject $widget, N-GObject $background_area, N-GObject $cell_area, int32 $flags )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_cell_renderer_activate:
=begin pod
=head2 [gtk_] cell_renderer_activate

Passes an activate event to the cell renderer for possible processing.
Some cell renderers may use events; for example, B<Gnome::Gtk3::CellRendererToggle>
toggles when it gets a mouse click.

Returns: C<1> if the event was consumed/handled

  method gtk_cell_renderer_activate ( GdkEvent $event, N-GObject $widget, Str $path, N-GObject $background_area, N-GObject $cell_area, GtkCellRendererState $flags --> Int  )

=item GdkEvent $event; a B<Gnome::Gdk3::Event>
=item N-GObject $widget; widget that received the event
=item Str $path; widget-dependent string representation of the event location;  e.g. for B<Gnome::Gtk3::TreeView>, a string representation of B<Gnome::Gtk3::TreePath>
=item N-GObject $background_area; background area as passed to C<gtk_cell_renderer_render()>
=item N-GObject $cell_area; cell area as passed to C<gtk_cell_renderer_render()>
=item GtkCellRendererState $flags; render flags

=end pod

sub gtk_cell_renderer_activate ( N-GObject $cell, GdkEvent $event, N-GObject $widget, Str $path, N-GObject $background_area, N-GObject $cell_area, int32 $flags )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_cell_renderer_start_editing:
=begin pod
=head2 [[gtk_] cell_renderer_] start_editing

Passes an activate event to the cell renderer for possible processing.

Returns: (nullable) (transfer none): A new B<Gnome::Gtk3::CellEditable>, or C<Any>

  method gtk_cell_renderer_start_editing ( GdkEvent $event, N-GObject $widget, Str $path, N-GObject $background_area, N-GObject $cell_area, GtkCellRendererState $flags --> N-GObject  )

=item GdkEvent $event; a B<Gnome::Gdk3::Event>
=item N-GObject $widget; widget that received the event
=item Str $path; widget-dependent string representation of the event location; e.g. for B<Gnome::Gtk3::TreeView>, a string representation of B<Gnome::Gtk3::TreePath>
=item N-GObject $background_area; background area as passed to C<gtk_cell_renderer_render()>
=item N-GObject $cell_area; cell area as passed to C<gtk_cell_renderer_render()>
=item GtkCellRendererState $flags; render flags

=end pod

sub gtk_cell_renderer_start_editing ( N-GObject $cell, GdkEvent $event, N-GObject $widget, Str $path, N-GObject $background_area, N-GObject $cell_area, int32 $flags )
  returns N-GObject
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_set_fixed_size:t/CellRendererText.t
=begin pod
=head2 [[gtk_] cell_renderer_] set_fixed_size

Sets the renderer size to be explicit, independent of the properties set.

  method gtk_cell_renderer_set_fixed_size ( Int $width, Int $height )

=item Int $width; the width of the cell renderer, or -1
=item Int $height; the height of the cell renderer, or -1

=end pod

sub gtk_cell_renderer_set_fixed_size ( N-GObject $cell, int32 $width, int32 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_get_fixed_size:t/CellRendererText.t
=begin pod
=head2 [[gtk_] cell_renderer_] get_fixed_size

Fills in I<width> and I<height> with the appropriate size of I<cell>.

  method gtk_cell_renderer_get_fixed_size ( --> List )

Returns a list with
=item Int $width; the fixed width of the cell
=item Int $height; the fixed height of the cell

=end pod

sub gtk_cell_renderer_get_fixed_size ( N-GObject $cell --> List ) {
  _gtk_cell_renderer_get_fixed_size( $cell, my int32 $w, my int32 $h);

  ( $w, $h)
}

sub _gtk_cell_renderer_get_fixed_size (
  N-GObject $cell, int32 $width is rw, int32 $height is rw
) is native(&gtk-lib)
  is symbol('gtk_cell_renderer_get_fixed_size')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_set_alignment:t/CellRendererText.t
=begin pod
=head2 [[gtk_] cell_renderer_] set_alignment

Sets the renderer’s alignment within its available space.

Since: 2.18

  method gtk_cell_renderer_set_alignment ( Num $xalign, Num $yalign )

=item Num $xalign; the x alignment of the cell renderer
=item Num $yalign; the y alignment of the cell renderer

=end pod

sub gtk_cell_renderer_set_alignment ( N-GObject $cell, num32 $xalign, num32 $yalign )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_get_alignment:t/CellRendererText.t
=begin pod
=head2 [[gtk_] cell_renderer_] get_alignment

Returns xalign and yalign with the appropriate values of this cell.

Since: 2.18

  method gtk_cell_renderer_get_alignment ( --> List )

Returns a list with
=item Num $xalign; x alignment of the cell
=item Num $yalign; y alignment of the cell

=end pod

sub gtk_cell_renderer_get_alignment ( N-GObject $cell --> List ) {
  _gtk_cell_renderer_get_alignment( $cell, my num32 $xa, my num32 $ya);

  ( $xa, $ya)
}

sub _gtk_cell_renderer_get_alignment (
  N-GObject $cell, num32 $xalign is rw, num32 $yalign is rw
) is native(&gtk-lib)
  is symbol('gtk_cell_renderer_get_alignment')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_set_padding:t/CellRendererText.t
=begin pod
=head2 [[gtk_] cell_renderer_] set_padding

Sets the renderer’s padding.

Since: 2.18

  method gtk_cell_renderer_set_padding ( Int $xpad, Int $ypad )

=item Int $xpad; the x padding of the cell renderer
=item Int $ypad; the y padding of the cell renderer

=end pod

sub gtk_cell_renderer_set_padding ( N-GObject $cell, int32 $xpad, int32 $ypad )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_get_padding:t/CellRendererText.t
=begin pod
=head2 [[gtk_] cell_renderer_] get_padding

Returns xpad and ypad with the appropriate values of this cell.

Since: 2.18

  method gtk_cell_renderer_get_padding ( --> List )

Returns list with
=item Int $xpad; x padding of the cell
=item Int $ypad; y padding of the cell

=end pod
sub gtk_cell_renderer_get_padding ( N-GObject $cell --> List ) {
  _gtk_cell_renderer_get_padding( $cell, my int32 $xp, my int32 $yp);

  ( $xp, $yp)
}

sub _gtk_cell_renderer_get_padding (
  N-GObject $cell, int32 $xpad is rw, int32 $ypad is rw
) is native(&gtk-lib)
  is symbol('gtk_cell_renderer_get_padding')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_set_visible:t/CellRendererText.t
=begin pod
=head2 [[gtk_] cell_renderer_] set_visible

Sets the cell renderer’s visibility.

Since: 2.18

  method gtk_cell_renderer_set_visible ( Int $visible )

=item Int $visible; the visibility of the cell

=end pod

sub gtk_cell_renderer_set_visible ( N-GObject $cell, int32 $visible )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_get_visible:t/CellRendererText.t
=begin pod
=head2 [[gtk_] cell_renderer_] get_visible

Returns the cell renderer’s visibility.

Returns: C<1> if the cell renderer is visible

Since: 2.18

  method gtk_cell_renderer_get_visible ( --> Int  )


=end pod

sub gtk_cell_renderer_get_visible ( N-GObject $cell )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_set_sensitive:t/CellRendererText.t
=begin pod
=head2 [[gtk_] cell_renderer_] set_sensitive

Sets the cell renderer’s sensitivity.

Since: 2.18

  method gtk_cell_renderer_set_sensitive ( Int $sensitive )

=item Int $sensitive; the sensitivity of the cell

=end pod

sub gtk_cell_renderer_set_sensitive ( N-GObject $cell, int32 $sensitive )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_get_sensitive:t/CellRendererText.t
=begin pod
=head2 [[gtk_] cell_renderer_] get_sensitive

Returns the cell renderer’s sensitivity.

Returns: C<1> if the cell renderer is sensitive

Since: 2.18

  method gtk_cell_renderer_get_sensitive ( --> Int  )


=end pod

sub gtk_cell_renderer_get_sensitive ( N-GObject $cell )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_cell_renderer_is_activatable:
=begin pod
=head2 [[gtk_] cell_renderer_] is_activatable

Checks whether the cell renderer can do something when activated.

Returns: C<1> if the cell renderer can do anything when activated

Since: 3.0

  method gtk_cell_renderer_is_activatable ( --> Int  )


=end pod

sub gtk_cell_renderer_is_activatable ( N-GObject $cell )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_cell_renderer_stop_editing:
=begin pod
=head2 [[gtk_] cell_renderer_] stop_editing

Informs the cell renderer that the editing is stopped.
If I<canceled> is C<1>, the cell renderer will emit the
 I<editing-canceled> signal.

This function should be called by cell renderer implementations
in response to the  I<editing-done> signal of
B<Gnome::Gtk3::CellEditable>.

Since: 2.6

  method gtk_cell_renderer_stop_editing ( Int $canceled )

=item Int $canceled; C<1> if the editing has been canceled

=end pod

sub gtk_cell_renderer_stop_editing ( N-GObject $cell, int32 $canceled )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_cell_renderer_get_state:
=begin pod
=head2 [[gtk_] cell_renderer_] get_state

Translates the cell renderer state to B<GtkStateFlags>,
based on the cell renderer and widget sensitivity, and
the given B<GtkCellRendererState>.

Returns: the widget state flags applying to this cell

Since: 3.0

  method gtk_cell_renderer_get_state ( N-GObject $widget, GtkCellRendererState $cell_state --> GtkStateFlags  )

=item N-GObject $widget; a widget
=item GtkCellRendererState $cell_state; cell renderer state

=end pod

sub gtk_cell_renderer_get_state ( N-GObject $cell, N-GObject $widget, int32 $cell_state )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_cell_renderer_class_set_accessible_type:
=begin pod
=head2 [[gtk_] cell_renderer_] class_set_accessible_type

Sets the type to be used for creating accessibles for cells rendered by
cell renderers of I<renderer_class>. Note that multiple accessibles will
be created.

This function should only be called from class init functions of cell
renderers.

  method gtk_cell_renderer_class_set_accessible_type ( GtkCellRendererClass $renderer_class, uInt $type )

=item GtkCellRendererClass $renderer_class; class to set the accessible type for
=item uInt $type; The object type that implements the accessible for I<widget_class>. The type must be a subtype of B<Gnome::Gtk3::RendererCellAccessible>

=end pod

sub gtk_cell_renderer_class_set_accessible_type ( GtkCellRendererClass $renderer_class, uint64 $type )
  is native(&gtk-lib)
  { * }
}}
#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<g_signal_connect_object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<g_signal_connect_object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment #TS:0:editing-canceled:
=head3 editing-canceled

This signal gets emitted when the user cancels the process of editing a cell.  For example, an editable cell renderer could be written to cancel editing when the user presses Escape.

See also: C<gtk_cell_renderer_stop_editing()>.

Since: 2.4

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($renderer),
    *%user-options
  );

=item $renderer; the object which received the signal


=comment #TS:0:editing-started:
=head3 editing-started

This signal gets emitted when a cell starts to be edited. The intended use of this signal is to do special setup on I<editable>, e.g. adding a B<Gnome::Gtk3::EntryCompletion> or setting up additional columns in a B<Gnome::Gtk3::ComboBox>.

Note that GTK+ doesn't guarantee that cell renderers will continue to use the same kind of widget for editing in future releases, therefore you should check the type of I<editable> before doing any specific setup, as in the following example:
=begin comment
|[<!-- language="C" -->
static void
text_editing_started (B<Gnome::Gtk3::CellRenderer> *cell,
B<Gnome::Gtk3::CellEditable> *editable,
const gchar     *path,
gpointer         data)
{
if (GTK_IS_ENTRY (editable))
{
B<Gnome::Gtk3::Entry> *entry = GTK_ENTRY (editable);

// ... create a B<Gnome::Gtk3::EntryCompletion>

gtk_entry_set_completion (entry, completion);
}
}
]|
=end comment

Since: 2.6

  method handler (
    Unknown type GTK_TYPE_CELL_EDITABLE $editable,
    Str $path,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($renderer),
    *%user-options
  );

=item $renderer; the object which received the signal

=item $editable; the B<Gnome::Gtk3::CellEditable>

=item $path; the path identifying the edited cell


=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:2:mode:t/CellRendererText.t
=head3 mode

Editable mode of the CellRenderer. Its an enumeration value of GtkCellRendererMode. To retrieve value use G_TYPE_INT.

Default value: GTK_CELL_RENDERER_MODE_INERT

The B<Gnome::GObject::Value> type of property I<mode> is C<G_TYPE_INT>.

=comment #TP:0:visible:
=head3 visible

Display the cell
Default value: C<1>


The B<Gnome::GObject::Value> type of property I<visible> is C<G_TYPE_BOOLEAN>.

=comment #TP:2:sensitive:t/CellRendererText.t
=head3 Sensitive

Display the cell sensitive
Default value: True


The B<Gnome::GObject::Value> type of property I<sensitive> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:xalign:
=head3 xalign



The B<Gnome::GObject::Value> type of property I<xalign> is C<G_TYPE_FLOAT>.

=comment #TP:0:yalign:
=head3 yalign



The B<Gnome::GObject::Value> type of property I<yalign> is C<G_TYPE_FLOAT>.

=comment #TP:0:xpad:
=head3 xpad



The B<Gnome::GObject::Value> type of property I<xpad> is C<G_TYPE_UINT>.

=comment #TP:0:ypad:
=head3 ypad



The B<Gnome::GObject::Value> type of property I<ypad> is C<G_TYPE_UINT>.

=comment #TP:0:width:
=head3 width



The B<Gnome::GObject::Value> type of property I<width> is C<G_TYPE_INT>.

=comment #TP:0:height:
=head3 height



The B<Gnome::GObject::Value> type of property I<height> is C<G_TYPE_INT>.

=comment #TP:0:is-expander:
=head3 Is Expander

Row has children
Default value: False


The B<Gnome::GObject::Value> type of property I<is-expander> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:is-expanded:
=head3 Is Expanded

Row is an expander row, and is expanded
Default value: False


The B<Gnome::GObject::Value> type of property I<is-expanded> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:cell-background:
=head3 Cell background color name

Cell background color as a string
Default value: Any


The B<Gnome::GObject::Value> type of property I<cell-background> is C<G_TYPE_STRING>.

=comment #TP:0:editing:
=head3 Editing

Whether the cell renderer is currently in editing mode
Default value: False


The B<Gnome::GObject::Value> type of property I<editing> is C<G_TYPE_BOOLEAN>.

=comment #TP:0: g_object_class_install_property (object_class:
=head3 propval



The B<Gnome::GObject::Value> type of property I< g_object_class_install_property (object_class> is C<G_TYPE_>.
=end pod
