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

B<Gnome::Gtk3::CellRendererText>, B<Gnome::Gtk3::CellRendererPixbuf>, B<Gnome::Gtk3::CellRendererToggle>, B<Gnome::Gtk3::CellRendererProgress>, B<Gnome::Gtk3::CellRendererSpinner>

=comment TODO, B<Gnome::Gtk3::CellEditable>,

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRenderer;
  also is Gnome::GObject::InitiallyUnowned;


=head2 Uml Diagram

![](plantuml/CellRenderer-ea.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::CellRenderer;

  unit class MyGuiClass;
  also is Gnome::Gtk3::CellRenderer;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::CellRenderer class process the options
    self.bless( :GtkCellRenderer, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::GObject::InitiallyUnowned;

use Gnome::Gdk3::Events;
use Gnome::Gdk3::Types;

#use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Enums;

use Gnome::Cairo::Types;

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

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkCellRendererState

Tells how a cell is to be rendered.

=item GTK_CELL_RENDERER_SELECTED: The cell is currently selected, and probably has a selection colored background to render to.
=item GTK_CELL_RENDERER_PRELIT: The mouse is hovering over the cell.
=item GTK_CELL_RENDERER_INSENSITIVE: The cell is drawn in an insensitive manner
=item GTK_CELL_RENDERER_SORTED: The cell is in a sorted row
=item GTK_CELL_RENDERER_FOCUSED: The cell is in the focus row.
=item GTK_CELL_RENDERER_EXPANDABLE: The cell is in a row that can be expanded.
=item GTK_CELL_RENDERER_EXPANDED: The cell is in a row that is expanded.
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

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :native-object

Create a CellRenderer object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=end pod

# TM:1:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<editing-canceled>, :w2<editing-started>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::CellRenderer' #`{{ or %options<GtkCellRenderer> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        $no = %options<___x___>;
        $no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_cell_renderer_new___x___($no);
      }

      ##`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      #}}

      ##`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      #}}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_cell_renderer_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkCellRenderer');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_cell_renderer_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_cell_renderer_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('cell_renderern-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-cell_renderer-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

  self._set-class-name-of-sub('GtkCellRenderer');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:activate:
=begin pod
=head2 activate

Passes an activate event to the cell renderer for possible processing. Some cell renderers may use events; for example, B<Gnome::Gtk3::CellRendererToggle> toggles when it gets a mouse click.

Returns: C<True> if the event was consumed/handled

  method activate ( N-GdkEvent $event, N-GObject() $widget, Str $path, N-GObject() $background_area, N-GObject() $cell_area, GtkCellRendererState $flags --> Bool )

=item $event; a B<Gnome::Gtk3::Event>
=item $widget; widget that received the event
=item $path; widget-dependent string representation of the event location;  e.g. for B<Gnome::Gtk3::TreeView>, a string representation of B<Gnome::Gtk3::TreePath>
=item $background_area; background area as passed to C<render()>
=item $cell_area; cell area as passed to C<render()>
=item $flags; render flags
=end pod

method activate ( N-GdkEvent $event, N-GObject() $widget, Str $path, N-GObject() $background_area, N-GObject() $cell_area, GtkCellRendererState $flags --> Bool ) {

  gtk_cell_renderer_activate(
    self._f('GtkCellRenderer'), $event, $widget, $path, $background_area, $cell_area, $flags
  ).Bool
}

sub gtk_cell_renderer_activate (
  N-GObject $cell, N-GdkEvent $event, N-GObject $widget, gchar-ptr $path, N-GObject $background_area, N-GObject $cell_area, GEnum $flags --> gboolean
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:class-set-accessible-type:
=begin pod
=head2 class-set-accessible-type

Sets the type to be used for creating accessibles for cells rendered by cell renderers of I<renderer_class>. Note that multiple accessibles will be created.

This function should only be called from class init functions of cell renderers.

=comment TODO GtkCellRendererClass ~~ N-GObject from this class?
  method class-set-accessible-type ( GtkCellRendererClass $renderer_class, N-GObject() $type )

=item $renderer_class; class to set the accessible type for
=item $type; The object type that implements the accessible for I<widget_class>. The type must be a subtype of B<Gnome::Gtk3::RendererCellAccessible>
=end pod

method class-set-accessible-type ( GtkCellRendererClass $renderer_class, N-GObject() $type ) {

  gtk_cell_renderer_class_set_accessible_type(
    self._f('GtkCellRenderer'), $renderer_class, $type
  );
}

sub gtk_cell_renderer_class_set_accessible_type (
  GtkCellRendererClass $renderer_class, N-GObject $type
) is native(&gtk-lib)
  { * }
}}
#-------------------------------------------------------------------------------
#TM:0:get-aligned-area:
=begin pod
=head2 get-aligned-area

Gets the aligned area used by I<cell> inside I<cell_area>. Used for finding the appropriate edit and focus rectangle.

  method get-aligned-area ( N-GObject() $widget, UInt $flags, N-GObject() $cell_area, N-GObject() $aligned_area )

=item $widget; the B<Gnome::Gtk3::Widget> this cell will be rendering to
=item $flags; render flags. Mask of bits from GtkCellRendererState
=item $cell_area; cell area which would be passed to C<render()>
=item $aligned_area; the return location for the space inside I<cell_area> that would acually be used to render.
=end pod

method get-aligned-area ( N-GObject() $widget, UInt $flags, N-GObject() $cell_area, N-GObject() $aligned_area ) {

  gtk_cell_renderer_get_aligned_area(
    self._f('GtkCellRenderer'), $widget, $flags, $cell_area, $aligned_area
  );
}

sub gtk_cell_renderer_get_aligned_area (
  N-GObject $cell, N-GObject $widget, GFlag $flags, N-GObject $cell_area, N-GObject $aligned_area
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-alignment:
=begin pod
=head2 get-alignment

Fills in I<xalign> and I<yalign> with the appropriate values of I<cell>.

  method get-alignment ( --> List )

List returns
=item Num; the x alignment of the cell, or C<undefined>
=item Num; the y alignment of the cell, or C<undefined>
=end pod

method get-alignment ( --> List ) {
  gtk_cell_renderer_get_alignment(
    self._f('GtkCellRenderer'), my gfloat $xalign, my gfloat $yalign
  );

  ( $xalign.Num, $yalign.Num)
}

sub gtk_cell_renderer_get_alignment (
  N-GObject $cell, gfloat $xalign, gfloat $yalign
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-fixed-size:
=begin pod
=head2 get-fixed-size

Fills in I<width> and I<height> with the appropriate size of I<cell>.

  method get-fixed-size ( --> List )

List returns
=item Int; the fixed width of the cell, or C<undefined>
=item Int; the fixed height of the cell, or C<undefined>
=end pod

method get-fixed-size ( --> List ) {
  gtk_cell_renderer_get_fixed_size(
    self._f('GtkCellRenderer'), my gint $width, my gint $height
  );

  ( $width, $height)
}

sub gtk_cell_renderer_get_fixed_size (
  N-GObject $cell, gint $width is rw, gint $height is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-padding:
=begin pod
=head2 get-padding

Fills in I<xpad> and I<ypad> with the appropriate values of I<cell>.

  method get-padding ( --> List )

List returns
=item Int; the x padding of the cell, or C<undefined>
=item Int; the y padding of the cell, or C<undefined>
=end pod

method get-padding ( --> List ) {
  gtk_cell_renderer_get_padding(
    self._f('GtkCellRenderer'), my gint $xpad, my gint $ypad
  );

  ( $xpad, $ypad)
}

sub gtk_cell_renderer_get_padding (
  N-GObject $cell, gint $xpad is rw, gint $ypad is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-preferred-height:
=begin pod
=head2 get-preferred-height

Retreives a renderer’s natural size when rendered to I<widget>.

  method get-preferred-height ( N-GObject() $widget --> List )

=item $widget; the B<Gnome::Gtk3::Widget> this cell will be rendering to

List returns
=item Int; the minimum size, or C<undefined>
=item Int; the natural size, or C<undefined>
=end pod

method get-preferred-height ( N-GObject() $widget --> List ) {
  gtk_cell_renderer_get_preferred_height(
    self._f('GtkCellRenderer'), $widget,
    my gint $minimum_size, my gint $natural_size
  );
  ( $minimum_size, $natural_size)
}

sub gtk_cell_renderer_get_preferred_height (
  N-GObject $cell, N-GObject $widget, gint $minimum_size is rw, gint $natural_size is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-preferred-height-for-width:
=begin pod
=head2 get-preferred-height-for-width

Retreives a cell renderers’s minimum and natural height if it were rendered to I<widget> with the specified I<width>.

  method get-preferred-height-for-width (
    N-GObject() $widget, Int() $width --> List
  )

=item $widget; the B<Gnome::Gtk3::Widget> this cell will be rendering to
=item $width; the size which is available for allocation

List returns
=item Int; the minimum size, or C<undefined>
=item Int; the preferred size, or C<undefined>
=end pod

method get-preferred-height-for-width (
  N-GObject() $widget, Int() $width --> List
) {
  gtk_cell_renderer_get_preferred_height_for_width(
    self._f('GtkCellRenderer'), $widget, $width,
    my gint $minimum_height, my gint $natural_height
  );

  ( $minimum_height, $natural_height)
}

sub gtk_cell_renderer_get_preferred_height_for_width (
  N-GObject $cell, N-GObject $widget, gint $width, gint $minimum_height is rw, gint $natural_height is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-preferred-size:
=begin pod
=head2 get-preferred-size

Retrieves the minimum and natural size of a cell taking into account the widget’s preference for height-for-width management.

  method get-preferred-size ( N-GObject() $widget --> List )

=item $widget; the B<Gnome::Gtk3::Widget> this cell will be rendering to

List returns
=item N-GtkRequisition; the minimum size, or C<undefined>
=item N-GtkRequisition; the natural size, or C<undefined>
=end pod

method get-preferred-size ( N-GObject() $widget --> List ) {
  my N-GtkRequisition $minimum_size .= new;
  my N-GtkRequisition $natural_size .= new;
  gtk_cell_renderer_get_preferred_size(
    self._f('GtkCellRenderer'), $widget, $minimum_size, $natural_size
  );

  ( $minimum_size, $natural_size)
}

sub gtk_cell_renderer_get_preferred_size (
  N-GObject $cell, N-GObject $widget, N-GtkRequisition $minimum_size, N-GtkRequisition $natural_size
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-preferred-width:
=begin pod
=head2 get-preferred-width

Retreives a renderer’s natural size when rendered to I<widget>.

  method get-preferred-width ( N-GObject() $widget --> List )

=item $widget; the B<Gnome::Gtk3::Widget> this cell will be rendering to

List returns
=item Int; the minimum size, or C<undefined>
=item Int; the natural size, or C<undefined>
=end pod

method get-preferred-width ( N-GObject() $widget --> List ) {
  gtk_cell_renderer_get_preferred_width(
    self._f('GtkCellRenderer'), $widget, my gint $minimum_size, my gint $natural_size
  );

  ( $minimum_size, $natural_size)
}

sub gtk_cell_renderer_get_preferred_width (
  N-GObject $cell, N-GObject $widget, gint $minimum_size is rw, gint $natural_size is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-preferred-width-for-height:
=begin pod
=head2 get-preferred-width-for-height

Retreives a cell renderers’s minimum and natural width if it were rendered to I<widget> with the specified I<height>.

  method get-preferred-width-for-height (
    N-GObject() $widget, Int() $height --> List
  )

=item $widget; the B<Gnome::Gtk3::Widget> this cell will be rendering to
=item $height; the size which is available for allocation

List returns
=item $minimum_width; location for storing the minimum size, or C<undefined>
=item $natural_width; location for storing the preferred size, or C<undefined>
=end pod

method get-preferred-width-for-height (
  N-GObject() $widget, Int() $height --> List
) {
  gtk_cell_renderer_get_preferred_width_for_height(
    self._f('GtkCellRenderer'), $widget, $height,
    my gint $minimum_width, my gint $natural_width
  );

  ( $minimum_width, $natural_width)
}

sub gtk_cell_renderer_get_preferred_width_for_height (
  N-GObject $cell, N-GObject $widget, gint $height, gint $minimum_width is rw, gint $natural_width is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-request-mode:
=begin pod
=head2 get-request-mode

Gets whether the cell renderer prefers a height-for-width layout or a width-for-height layout.

Returns: The enum C<GtkSizeRequestMode> preferred by this renderer.

  method get-request-mode ( --> GtkSizeRequestMode )

=end pod

method get-request-mode ( --> GtkSizeRequestMode ) {
  GtkSizeRequestMode(
    gtk_cell_renderer_get_request_mode(self._f('GtkCellRenderer'))
  )
}

sub gtk_cell_renderer_get_request_mode (
  N-GObject $cell --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-sensitive:
=begin pod
=head2 get-sensitive

Returns the cell renderer’s sensitivity.

Returns: C<True> if the cell renderer is sensitive

  method get-sensitive ( --> Bool )

=end pod

method get-sensitive ( --> Bool ) {
  gtk_cell_renderer_get_sensitive(self._f('GtkCellRenderer')).Bool
}

sub gtk_cell_renderer_get_sensitive (
  N-GObject $cell --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-state:
=begin pod
=head2 get-state

Translates the cell renderer state to a mask of C<GtkStateFlags>, based on the cell renderer and widget sensitivity, and the given B<Gnome::Gtk3::CellRendererState>.

Returns: the widget state flags applying to I<cell>

  method get-state (
    N-GObject() $widget, GtkCellRendererState $cell_state
    --> UInt
  )

=item $widget; a B<Gnome::Gtk3::Widget>, or C<undefined>
=item $cell_state; cell renderer state
=end pod

method get-state (
  N-GObject() $widget, GtkCellRendererState $cell_state --> UInt
) {
  gtk_cell_renderer_get_state(
    self._f('GtkCellRenderer'), $widget, $cell_state
  )
}

sub gtk_cell_renderer_get_state (
  N-GObject $cell, N-GObject $widget, GEnum $cell_state --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-visible:
=begin pod
=head2 get-visible

Returns the cell renderer’s visibility.

Returns: C<True> if the cell renderer is visible

  method get-visible ( --> Bool )

=end pod

method get-visible ( --> Bool ) {
  gtk_cell_renderer_get_visible(self._f('GtkCellRenderer')).Bool
}

sub gtk_cell_renderer_get_visible (
  N-GObject $cell --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:is-activatable:
=begin pod
=head2 is-activatable

Checks whether the cell renderer can do something when activated.

Returns: C<True> if the cell renderer can do anything when activated

  method is-activatable ( --> Bool )

=end pod

method is-activatable ( --> Bool ) {
  gtk_cell_renderer_is_activatable(self._f('GtkCellRenderer')).Bool
}

sub gtk_cell_renderer_is_activatable (
  N-GObject $cell --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:render:
=begin pod
=head2 render

Invokes the virtual render function of the B<Gnome::Gtk3::CellRenderer>. The three passed-in rectangles are areas in I<cr>. Most renderers will draw within I<cell_area>; the xalign, yalign, xpad, and ypad fields of the B<Gnome::Gtk3::CellRenderer> should be honored with respect to I<cell_area>. I<background_area> includes the blank space around the cell, and also the area containing the tree expander; so the I<background_area> rectangles for all cells tile to cover the entire I<window>.

  method render (
    cairo_t $cr, N-GObject() $widget, N-GObject() $background_area,
    N-GObject() $cell_area, GtkCellRendererState $flags
  )

=item $cr; a cairo context to draw to
=item $widget; the widget owning I<window>
=item $background_area; entire cell area (including tree expanders and maybe  padding on the sides)
=item $cell_area; area normally rendered by a cell renderer
=item $flags; flags that affect rendering
=end pod

method render ( cairo_t $cr, N-GObject() $widget, N-GObject() $background_area, N-GObject() $cell_area, GtkCellRendererState $flags ) {

  gtk_cell_renderer_render(
    self._f('GtkCellRenderer'), $cr, $widget, $background_area,
    $cell_area, $flags
  );
}

sub gtk_cell_renderer_render (
  N-GObject $cell, cairo_t $cr, N-GObject $widget, N-GObject $background_area, N-GObject $cell_area, GEnum $flags
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-alignment:
=begin pod
=head2 set-alignment

Sets the renderer’s alignment within its available space.

  method set-alignment ( Num() $xalign, Num() $yalign )

=item $xalign; the x alignment of the cell renderer
=item $yalign; the y alignment of the cell renderer
=end pod

method set-alignment ( Num() $xalign, Num() $yalign ) {
  gtk_cell_renderer_set_alignment(
    self._f('GtkCellRenderer'), $xalign, $yalign
  );
}

sub gtk_cell_renderer_set_alignment (
  N-GObject $cell, gfloat $xalign, gfloat $yalign
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-fixed-size:
=begin pod
=head2 set-fixed-size

Sets the renderer size to be explicit, independent of the properties set.

  method set-fixed-size ( Int() $width, Int() $height )

=item $width; the width of the cell renderer, or -1
=item $height; the height of the cell renderer, or -1
=end pod

method set-fixed-size ( Int() $width, Int() $height ) {
  gtk_cell_renderer_set_fixed_size(
    self._f('GtkCellRenderer'), $width, $height
  );
}

sub gtk_cell_renderer_set_fixed_size (
  N-GObject $cell, gint $width, gint $height
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-padding:
=begin pod
=head2 set-padding

Sets the renderer’s padding.

  method set-padding ( Int() $xpad, Int() $ypad )

=item $xpad; the x padding of the cell renderer
=item $ypad; the y padding of the cell renderer
=end pod

method set-padding ( Int() $xpad, Int() $ypad ) {
  gtk_cell_renderer_set_padding(
    self._f('GtkCellRenderer'), $xpad, $ypad
  );
}

sub gtk_cell_renderer_set_padding (
  N-GObject $cell, gint $xpad, gint $ypad
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-sensitive:
=begin pod
=head2 set-sensitive

Sets the cell renderer’s sensitivity.

  method set-sensitive ( Bool $sensitive )

=item $sensitive; the sensitivity of the cell
=end pod

method set-sensitive ( Bool $sensitive ) {
  gtk_cell_renderer_set_sensitive(
    self._f('GtkCellRenderer'), $sensitive
  );
}

sub gtk_cell_renderer_set_sensitive (
  N-GObject $cell, gboolean $sensitive
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-visible:
=begin pod
=head2 set-visible

Sets the cell renderer’s visibility.

  method set-visible ( Bool $visible )

=item $visible; the visibility of the cell
=end pod

method set-visible ( Bool $visible ) {
  gtk_cell_renderer_set_visible(
    self._f('GtkCellRenderer'), $visible
  );
}

sub gtk_cell_renderer_set_visible (
  N-GObject $cell, gboolean $visible
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:start-editing:
=begin pod
=head2 start-editing

Starts editing the contents of this I<cell>, through a new B<Gnome::Gtk3::CellEditable> widget created by the B<Gnome::Gtk3::CellRendererClass>.start_editing virtual function.

Returns: A new B<Gnome::Gtk3::CellEditable> for editing this I<cell>, or C<undefined> if editing is not possible

  method start-editing (
    N-GdkEvent $event, N-GObject() $widget, Str $path,
    N-GObject() $background_area, N-GObject() $cell_area,
    GtkCellRendererState $flags
    --> N-GObject
  )

=item $event; a B<Gnome::Gtk3::Event>
=item $widget; widget that received the event
=item $path; widget-dependent string representation of the event location; e.g. for B<Gnome::Gtk3::TreeView>, a string representation of B<Gnome::Gtk3::TreePath>
=item $background_area; background area as passed to C<render()>
=item $cell_area; cell area as passed to C<render()>
=item $flags; render flags
=end pod

#TODO make a role for Gnome::Gtk3::CellEditable
method start-editing (
  N-GdkEvent $event, N-GObject() $widget, Str $path,
  N-GObject() $background_area, N-GObject() $cell_area,
  GtkCellRendererState $flags
  --> N-GObject
) {
  gtk_cell_renderer_start_editing(
    self._f('GtkCellRenderer'), $event, $widget, $path,
    $background_area, $cell_area, $flags
  )
}

sub gtk_cell_renderer_start_editing (
  N-GObject $cell, N-GdkEvent $event, N-GObject $widget, gchar-ptr $path, N-GObject $background_area, N-GObject $cell_area, GEnum $flags --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:stop-editing:
=begin pod
=head2 stop-editing

Informs the cell renderer that the editing is stopped. If I<canceled> is C<True>, the cell renderer will emit the  I<editing-canceled> signal.

This function should be called by cell renderer implementations in response to the  I<editing-done> signal of B<Gnome::Gtk3::CellEditable>.

  method stop-editing ( Bool $canceled )

=item $canceled; C<True> if the editing has been canceled
=end pod

method stop-editing ( Bool $canceled ) {
  gtk_cell_renderer_stop_editing( self._f('GtkCellRenderer'), $canceled);
}

sub gtk_cell_renderer_stop_editing (
  N-GObject $cell, gboolean $canceled
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

=comment -----------------------------------------------------------------------
=comment #TS:0:editing-canceled:
=head2 editing-canceled

This signal gets emitted when the user cancels the process of editing a cell.  For example, an editable cell renderer could be written to cancel editing when the user presses Escape.

See also: C<stop_editing()>.

  method handler (
    Gnome::Gtk3::CellRenderer :_widget($renderer),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $renderer; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:editing-started:
=head2 editing-started

This signal gets emitted when a cell starts to be edited. The intended use of this signal is to do special setup on I<editable>, e.g. adding a B<Gnome::Gtk3::EntryCompletion> or setting up additional columns in a B<Gnome::Gtk3::ComboBox>.

See C<gtk_cell_editable_start_editing()> for information on the lifecycle of the I<editable> and a way to do setup that doesn’t depend on the I<renderer>.

=begin comment
Note that GTK+ doesn't guarantee that cell renderers will continue to use the same kind of widget for editing in future releases, therefore you should check the type of I<editable> before doing any specific setup, as in the following example:

|[<!-- language="C" -->
static void
text_editing_started (GtkCellRenderer *cell,
GtkCellEditable *editable,
const gchar     *path,
gpointer         data)
{
if (GTK_IS_ENTRY (editable))
{
GtkEntry *entry = GTK_ENTRY (editable);

// ... create a GtkEntryCompletion

gtk_entry_set_completion (entry, completion);
}
}
]|
=end comment

  method handler (
    N-GObject $editable,
    Str $path,
    Gnome::Gtk3::CellRenderer :_widget($renderer),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $editable; the B<Gnome::Gtk3::CellEditable>
=item $path; the path identifying the edited cell
=item $renderer; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:0:cell-background:
=head2 cell-background

Cell background color as a string

The B<Gnome::GObject::Value> type of property I<cell-background> is C<G_TYPE_STRING>.

=item Parameter is writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:cell-background-rgba:
=head2 cell-background-rgba

Cell background color as a GdkRGBA

The B<Gnome::GObject::Value> type of property I<cell-background-rgba> is C<G_TYPE_BOXED>.



=comment -----------------------------------------------------------------------
=comment #TP:1:editing:
=head2 editing

Whether the cell renderer is currently in editing mode

The B<Gnome::GObject::Value> type of property I<editing> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:height:
=head2 height

The fixed height

The B<Gnome::GObject::Value> type of property I<height> is C<G_TYPE_INT>.

=item Parameter is readable and writable.
=item Minimum value is -1.
=item Maximum value is G_MAXINT.
=item Default value is -1.


=comment -----------------------------------------------------------------------
=comment #TP:1:is-expanded:
=head2 is-expanded

Row is an expander row, and is expanded

The B<Gnome::GObject::Value> type of property I<is-expanded> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:is-expander:
=head2 is-expander

Row has children

The B<Gnome::GObject::Value> type of property I<is-expander> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:mode:
=head2 mode

Editable mode of the CellRenderer

The B<Gnome::GObject::Value> type of property I<mode> is C<G_TYPE_ENUM>.

=item Parameter is readable and writable.
=item Default value is GTK_CELL_RENDERER_MODE_INERT.

=comment -----------------------------------------------------------------------
=comment #TP:1:sensitive:
=head2 sensitive

Display the cell sensitive

The B<Gnome::GObject::Value> type of property I<sensitive> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:1:visible:
=head2 visible

Display the cell

The B<Gnome::GObject::Value> type of property I<visible> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:1:width:
=head2 width

The fixed width

The B<Gnome::GObject::Value> type of property I<width> is C<G_TYPE_INT>.

=item Parameter is readable and writable.
=item Minimum value is -1.
=item Maximum value is G_MAXINT.
=item Default value is -1.


=comment -----------------------------------------------------------------------
=comment #TP:1:xalign:
=head2 xalign

The x-align

The B<Gnome::GObject::Value> type of property I<xalign> is C<G_TYPE_FLOAT>.

=item Parameter is readable and writable.
=item Minimum value is 0.0.
=item Maximum value is 1.0.
=item Default value is 0.5.


=comment -----------------------------------------------------------------------
=comment #TP:1:xpad:
=head2 xpad

The xpad

The B<Gnome::GObject::Value> type of property I<xpad> is C<G_TYPE_UINT>.

=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is G_MAXUINT.
=item Default value is 0.


=comment -----------------------------------------------------------------------
=comment #TP:1:yalign:
=head2 yalign

The y-align

The B<Gnome::GObject::Value> type of property I<yalign> is C<G_TYPE_FLOAT>.

=item Parameter is readable and writable.
=item Minimum value is 0.0.
=item Maximum value is 1.0.
=item Default value is 0.5.


=comment -----------------------------------------------------------------------
=comment #TP:1:ypad:
=head2 ypad

The ypad

The B<Gnome::GObject::Value> type of property I<ypad> is C<G_TYPE_UINT>.

=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is G_MAXUINT.
=item Default value is 0.

=end pod
