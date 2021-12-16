#TL:1:Gnome::Gtk3::CellLayout:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellLayout

An interface for packing cells

=comment ![](images/X.png)

=head1 Description

B<Gnome::Gtk3::CellLayout> is an interface to be implemented by all objects which want to provide a B<Gnome::Gtk3::TreeViewColumn> like API for packing cells, setting attributes and data funcs.

One of the notable features provided by implementations of GtkCellLayout are attributes. Attributes let you set the properties in flexible ways. They can just be set to constant values like regular properties. But they can also be mapped to a column of the underlying tree model with C<set-attributes()>, which means that the value of the attribute can change from cell to cell as they are rendered by the cell renderer. Finally, it is possible to specify a function with C<gtk-cell-layout-set-cell-data-func()> that is called to determine the value of the attribute for each cell that is rendered.


=head2 GtkCellLayouts as GtkBuildable

Implementations of GtkCellLayout which also implement the GtkBuildable  interface (B<Gnome::Gtk3::CellView>, B<Gnome::Gtk3::IconView>, B<Gnome::Gtk3::ComboBox>, B<Gnome::Gtk3::EntryCompletion>, B<Gnome::Gtk3::TreeViewColumn>) accept GtkCellRenderer objects as <child> elements in UI definitions. They support a custom <attributes> element for their children, which can contain multiple <attribute> elements. Each <attribute> element has a name attribute which specifies a property of the cell renderer; the content of the element is the attribute value.

This is an example of a UI definition fragment specifying attributes:

  <object class="GtkCellView">
    <child>
      <object class="GtkCellRendererText"/>
      <attributes>
        <attribute name="text">0</attribute>
      </attributes>
    </child>"
  </object>


Furthermore for implementations of GtkCellLayout that use a B<Gnome::Gtk3::CellArea> to lay out cells (all GtkCellLayouts in GTK+ use a GtkCellArea) [cell properties][cell-properties] can also be defined in the format by specifying the custom <cell-packing> attribute which can contain multiple <property> elements defined in the normal way.

Here is a UI definition fragment specifying cell properties:

  <object class="GtkTreeViewColumn">
    <child>
      <object class="GtkCellRendererText"/>
      <cell-packing>
        <property name="align">True</property>
        <property name="expand">False</property>
      </cell-packing>
    </child>"
  </object>


=begin comment
=head2 Subclassing GtkCellLayout implementations

When subclassing a widget that implements B<Gnome::Gtk3::CellLayout> like
B<Gnome::Gtk3::IconView> or B<Gnome::Gtk3::ComboBox>, there are some considerations related
to the fact that these widgets internally use a B<Gnome::Gtk3::CellArea>.
The cell area is exposed as a construct-only property by these
widgets. This means that it is possible to e.g. do

|[<!-- language="C" -->
combo = g-object-new (GTK-TYPE-COMBO-BOX, "cell-area", my-cell-area, NULL);
]|

to use a custom cell area with a combo box. But construct properties
are only initialized after instance C<init()>
functions have run, which means that using functions which rely on
the existence of the cell area in your subclass’ C<init()> function will
cause the default cell area to be instantiated. In this case, a provided
construct property value will be ignored (with a warning, to alert
you to the problem).

|[<!-- language="C" -->
static void
my-combo-box-init (MyComboBox *b)
{
  GtkCellRenderer *cell;

  cell = C<gtk-cell-renderer-pixbuf-new()>;
  // The following call causes the default cell area for combo boxes,
  // a GtkCellAreaBox, to be instantiated
  gtk-cell-layout-pack-start (GTK-CELL-LAYOUT (b), cell, FALSE);
  ...
}

GtkWidget *
my-combo-box-new (GtkCellArea *area)
{
  // This call is going to cause a warning about area being ignored
  return g-object-new (MY-TYPE-COMBO-BOX, "cell-area", area, NULL);
}
]|

If supporting alternative cell areas with your derived widget is
not important, then this does not have to concern you. If you want
to support alternative cell areas, you can do so by moving the
problematic calls out of C<init()> and into a C<constructor()>
for your class.
=end comment


=head1 Synopsis
=head2 Declaration

  unit role Gnome::Gtk3::CellLayout;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Glib::List;

#-------------------------------------------------------------------------------
unit role Gnome::Gtk3::CellLayout:auth<github:MARTIMM>:ver<0.1.0>;

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkCellLayoutIface




=item ---pack-start: Packs the cell into the beginning of cell-layout.
=item ---pack-end: Adds the cell to the end of cell-layout.
=item ---clear: Unsets all the mappings on all renderers on cell-layout and removes all renderers from cell-layout.
=item ---add-attribute: Adds an attribute mapping to the list in cell-layout.
=item ---set-cell-data-func: Sets the B<Gnome::Gtk3::CellLayoutDataFunc> to use for cell-layout.
=item ---clear-attributes: Clears all existing attributes previously set with C<set-attributes()>.
=item ---reorder: Re-inserts cell at position.
=item ---get-cells: Get the cell renderers which have been added to cell-layout.
=item ---get-area: Get the underlying B<Gnome::Gtk3::CellArea> which might be cell-layout if called on a B<Gnome::Gtk3::CellArea> or might be NULL if no B<Gnome::Gtk3::CellArea> is used by cell-layout.


=end pod

#TT:0:N-GtkCellLayoutIface:
class N-GtkCellLayoutIface is export is repr('CStruct') {
  has GTypeInterface $.g_iface;
  has gboolean $.expand);
  has gboolean $.expand);
  has voi $.d (* clear)              (GtkCellLayout         *cell_layout);
  has gint $.column);
  has GDestroyNotify $.destroy);
  has N-GObject $.cell);
  has gint $.position);
  has GLis $.t* (* get_cells)        (GtkCellLayout         *cell_layout);
  has GtkCellAre $.a *(* get_area)   (GtkCellLayout         *cell_layout);
}
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

# interfaces are not instantiated
#submethod BUILD ( *%options ) { }

#`{{
# All interface calls should become methods
#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _cell_layout_interface ( $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &:("gtk_cell_layout_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &:("gtk_$native-sub"); } unless ?$s;
  try { $s = &:($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s;
}
}}


#-------------------------------------------------------------------------------
# setup signals from interface
#method _add_cell_layout_interface_signal_types ( Str $class-name ) {
#}


#-------------------------------------------------------------------------------
#TM:2:add-attribute:
=begin pod
=head2 add-attribute

Adds an attribute mapping to the list in I<cell-layout>.

The I<column> is the column of the model to get a value from, and the I<attribute> is the parameter on I<cell> to be set from the value. So for example if column 2 of the model contains strings, you could have the “text” attribute of a B<Gnome::Gtk3::CellRendererText> get its values from column 2.

  method add-attribute ( N-GObject $cell, Str $attribute, Int $column )

=item N-GObject $cell; a B<Gnome::Gtk3::CellRenderer>
=item Str $attribute; an attribute on the renderer
=item Int $column; the column position on the model to get the attribute from
=end pod

method add-attribute ( $cell is copy, Str $attribute, Int $column ) {
  $cell .= _get-native-object-no-reffing unless $cell ~~ N-GObject;

  gtk_cell_layout_add_attribute(
    self._f('GtkCellLayout'), $cell, $attribute, $column
  );
}

sub gtk_cell_layout_add_attribute (
  N-GObject $cell_layout, N-GObject $cell, gchar-ptr $attribute, gint $column
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:clear:
=begin pod
=head2 clear

Unsets all the mappings on all renderers on I<cell-layout> and removes all renderers from I<cell-layout>.

  method clear ( )

=end pod

method clear ( ) {
  gtk_cell_layout_clear(self._f('GtkCellLayout'));
}

sub gtk_cell_layout_clear (
  N-GObject $cell_layout
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:clear-attributes:
=begin pod
=head2 clear-attributes

Clears all existing attributes previously set with C<set-attributes()>.

  method clear-attributes ( N-GObject $cell )

=item N-GObject $cell; a B<Gnome::Gtk3::CellRenderer> to clear the attribute mapping on
=end pod

method clear-attributes ( $cell is copy ) {
  $cell .= _get-native-object-no-reffing unless $cell ~~ N-GObject;
  gtk_cell_layout_clear_attributes( self._f('GtkCellLayout'), $cell);
}

sub gtk_cell_layout_clear_attributes (
  N-GObject $cell_layout, N-GObject $cell
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-area:
=begin pod
=head2 get-area

Returns the underlying B<Gnome::Gtk3::CellArea> which might be I<cell-layout> if called on a B<Gnome::Gtk3::CellArea> or might be C<undefined> if no B<Gnome::Gtk3::CellArea> is used by I<cell-layout>.

Returns: the cell area used by I<cell-layout>, or C<undefined> in case no cell area is used.

  method get-area ( --> N-GObject )

=end pod

method get-area ( --> N-GObject ) {
  gtk_cell_layout_get_area(self._f('GtkCellLayout'))
}

sub gtk_cell_layout_get_area (
  N-GObject $cell_layout --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-cells:
=begin pod
=head2 get-cells

Returns the cell renderers which have been added to I<cell-layout>.

Returns: a list of cell renderers. The list, but not the renderers has been newly allocated and should be freed with C<g-list-free()> when no longer needed.

  method get-cells ( --> Gnome::Glib::List )

=end pod

method get-cells ( --> Gnome::Glib::List ) {
  Gnome::Glib::List.new(
    :native-object(gtk_cell_layout_get_cells(self._f('GtkCellLayout')))
  )
}

sub gtk_cell_layout_get_cells (
  N-GObject $cell_layout --> N-GList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:pack-end:
=begin pod
=head2 pack-end

Adds the I<cell> to the end of I<cell-layout>. If I<expand> is C<False>, then the I<cell> is allocated no more space than it needs. Any unused space is divided evenly between cells for which I<expand> is C<True>.

Note that reusing the same cell renderer is not supported.

  method pack-end ( N-GObject $cell, Bool $expand )

=item N-GObject $cell; a B<Gnome::Gtk3::CellRenderer>
=item Bool $expand; C<True> if I<cell> is to be given extra space allocated to I<cell-layout>
=end pod

method pack-end ( $cell is copy, Bool $expand ) {
  $cell .= _get-native-object-no-reffing unless $cell ~~ N-GObject;

  gtk_cell_layout_pack_end(
    self._f('GtkCellLayout'), $cell, $expand
  );
}

sub gtk_cell_layout_pack_end (
  N-GObject $cell_layout, N-GObject $cell, gboolean $expand
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:pack-start:
=begin pod
=head2 pack-start

Packs the I<cell> into the beginning of I<cell-layout>. If I<expand> is C<False>, then the I<cell> is allocated no more space than it needs. Any unused space is divided evenly between cells for which I<expand> is C<True>.

Note that reusing the same cell renderer is not supported.

  method pack-start ( N-GObject $cell, Bool $expand )

=item N-GObject $cell; a B<Gnome::Gtk3::CellRenderer>
=item Bool $expand; C<True> if I<cell> is to be given extra space allocated to I<cell-layout>
=end pod

method pack-start ( $cell is copy, Bool $expand ) {
  $cell .= _get-native-object-no-reffing unless $cell ~~ N-GObject;

  gtk_cell_layout_pack_start(
    self._f('GtkCellLayout'), $cell, $expand
  );
}

sub gtk_cell_layout_pack_start (
  N-GObject $cell_layout, N-GObject $cell, gboolean $expand
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:reorder:
=begin pod
=head2 reorder

Re-inserts I<cell> at I<position>.

Note that I<cell> has already to be packed into I<cell-layout> for this to function properly.

  method reorder ( N-GObject $cell, Int $position )

=item N-GObject $cell; a B<Gnome::Gtk3::CellRenderer> to reorder
=item Int $position; new position to insert I<cell> at
=end pod

method reorder ( $cell is copy, Int $position ) {
  $cell .= _get-native-object-no-reffing unless $cell ~~ N-GObject;

  gtk_cell_layout_reorder(
    self._f('GtkCellLayout'), $cell, $position
  );
}

sub gtk_cell_layout_reorder (
  N-GObject $cell_layout, N-GObject $cell, gint $position
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-attributes:
=begin pod
=head2 set-attributes

Sets the attributes in list as the attributes of I<cell-layout>.

The attributes should be in attribute/column order, as in C<add-attribute()>. All existing attributes are removed, and replaced with the new attributes.

  method set-attributes ( N-GObject $cell )

=item N-GObject $cell; a B<Gnome::Gtk3::CellRenderer> @...: a C<undefined>-terminated list of attributes
=end pod

method set-attributes ( $cell is copy ) {
  $cell .= _get-native-object-no-reffing unless $cell ~~ N-GObject;

  gtk_cell_layout_set_attributes(
    self._f('GtkCellLayout'), $cell
  );
}

sub gtk_cell_layout_set_attributes (
  N-GObject $cell_layout, N-GObject $cell, Any $any = Any
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-cell-data-func:
=begin pod
=head2 set-cell-data-func

Sets the B<Gnome::Gtk3::CellLayoutDataFunc> to use for I<cell-layout>.

This function is used instead of the standard attributes mapping for setting the column value, and should set the value of I<cell-layout>’s cell renderer(s) as appropriate.

I<func> may be C<undefined> to remove a previously set function.

  method set-cell-data-func ( N-GObject $cell, GtkCellLayoutDataFunc $func, Pointer $func_data, GDestroyNotify $destroy )

=item N-GObject $cell; a B<Gnome::Gtk3::CellRenderer>
=item GtkCellLayoutDataFunc $func; the B<Gnome::Gtk3::CellLayoutDataFunc> to use, or C<undefined>
=item Pointer $func_data; (closure): user data for I<func>
=item GDestroyNotify $destroy; destroy notify for I<func-data>
=end pod

method set-cell-data-func ( $cell is copy, GtkCellLayoutDataFunc $func, Pointer $func_data, GDestroyNotify $destroy ) {
  $cell .= _get-native-object-no-reffing unless $cell ~~ N-GObject;

  gtk_cell_layout_set_cell_data_func(
    self._f('GtkCellLayout'), $cell, $func, $func_data, $destroy
  );
}

sub gtk_cell_layout_set_cell_data_func (
  N-GObject $cell_layout, N-GObject $cell, GtkCellLayoutDataFunc $func, gpointer $func_data, GDestroyNotify $destroy
) is native(&gtk-lib)
  { * }
}}
