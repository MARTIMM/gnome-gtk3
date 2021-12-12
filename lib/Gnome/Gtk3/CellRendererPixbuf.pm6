#TL:1:Gnome::Gtk3::CellRendererPixbuf:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellRendererPixbuf

Renders a pixbuf in a cell

=comment ![](images/X.png)

=head1 Description


A B<Gnome::Gtk3::CellRendererPixbuf> can be used to render an image in a cell. It allows to render either a given B<Gnome::Gdk3::Pixbuf> (set via the I<pixbuf> property) or a named icon (set via the I<icon-name> property).

To support the tree view, B<Gnome::Gtk3::CellRendererPixbuf> also supports rendering two alternative pixbufs, when the  I<is-expander> property is C<1>. If the  I<is-expanded> property is C<1> and the  I<pixbuf-expander-open> property is set to a pixbuf, it renders that pixbuf, if the  I<is-expanded> property is C<0> and the  I<pixbuf-expander-closed> property is set to a pixbuf, it renders that one.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRendererPixbuf;
  also is Gnome::Gtk3::CellRenderer;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::CellRenderer;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::CellRendererPixbuf:auth<github:MARTIMM>;
also is Gnome::Gtk3::CellRenderer;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::CellRendererPixbuf';

  # process all named arguments
  if ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  else { #if ? %options<empty> {
    self.set-native-object(gtk_cell_renderer_pixbuf_new());
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkCellRendererPixbuf');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_cell_renderer_pixbuf_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkCellRendererPixbuf');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_pixbuf_new:new()
=begin pod
=head2 gtk_cell_renderer_pixbuf_new

Creates a new B<Gnome::Gtk3::CellRendererPixbuf>. Adjust rendering parameters using object properties. Object properties can be set globally (with C<g_object_set()>). Also, with B<Gnome::Gtk3::TreeViewColumn>, you can bind a property to a value in a B<Gnome::Gtk3::TreeModel>. For example, you can bind the “pixbuf” property on the cell renderer to a pixbuf value in the model, thus rendering a different image in each row of the B<Gnome::Gtk3::TreeView>.

Returns: the new cell renderer

  method gtk_cell_renderer_pixbuf_new ( --> N-GObject  )

=end pod

sub gtk_cell_renderer_pixbuf_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:pixbuf:
=head3 Pixbuf Object

The pixbuf to render

Widget type: GDK_TYPE_PIXBUF

The B<Gnome::GObject::Value> type of property I<pixbuf> is C<G_TYPE_OBJECT>.

=comment #TP:0:pixbuf-expander-open:
=head3 Pixbuf Expander Open

Pixbuf for open expander. Used when a Pixbuf is shown in a Gnome::Gtk3::TreeStore

Widget type: GDK_TYPE_PIXBUF

The B<Gnome::GObject::Value> type of property I<pixbuf-expander-open> is C<G_TYPE_OBJECT>.

=comment #TP:0:pixbuf-expander-closed:
=head3 Pixbuf Expander Closed

Pixbuf for closed expander. Used when a Pixbuf is shown in a Gnome::Gtk3::TreeStore

Widget type: GDK_TYPE_PIXBUF


The B<Gnome::GObject::Value> type of property I<pixbuf-expander-closed> is C<G_TYPE_OBJECT>.

=comment #TP:0:surface:
=head3 surface

The surface to render

Since: 3.10

The B<Gnome::GObject::Value> type of property I<surface> is C<G_TYPE_BOXED>.

=comment #TP:0:stock-size:
=head3 Size

The GtkIconSize value that specifies the size of the rendered icon.

The B<Gnome::GObject::Value> type of property I<stock-size> is C<G_TYPE_UINT>.

=comment #TP:0:stock-detail:
=head3 Detail

Render detail to pass to the theme engine

Default value: Any


The B<Gnome::GObject::Value> type of property I<stock-detail> is C<G_TYPE_STRING>.

=comment #TP:0:icon-name:
=head3 Icon Name

The name of the themed icon to display. This property only has an effect if not overridden by "stock_id" or "pixbuf" properties.

Since: 2.8

The B<Gnome::GObject::Value> type of property I<icon-name> is C<G_TYPE_STRING>.

=comment #TP:0:gicon:
=head3 Icon

The GIcon representing the icon to display. If the icon theme is changed, the image will be updated automatically.

Since: 2.14
Widget type: G_TYPE_ICON

The B<Gnome::GObject::Value> type of property I<gicon> is C<G_TYPE_OBJECT>.
=end pod
