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


=head2 Uml Diagram

![](plantuml/CellRenderer-ea.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::CellRendererPixbuf;

  unit class MyGuiClass;
  also is Gnome::Gtk3::CellRendererPixbuf;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::CellRendererPixbuf class process the options
    self.bless( :GtkCellRendererPixbuf, |c);
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

=head3 default, no options

Create a new CellRendererPixbuf object.

  multi method new ( )


=head3 :native-object

Create a CellRendererPixbuf object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a CellRendererPixbuf object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {
  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::CellRendererPixbuf' #`{{ or %options<GtkCellRendererPixbuf> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_cell_renderer_pixbuf_new___x___($no);
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

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_cell_renderer_pixbuf_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkCellRendererPixbuf');
  }
}


#-------------------------------------------------------------------------------
#TM:1:_gtk_cell_renderer_pixbuf_new:
#`{{
=begin pod
=head2 _gtk_cell_renderer_pixbuf_new

Creates a new B<Gnome::Gtk3::CellRendererPixbuf>. Adjust rendering parameters using object properties. Object properties can be set globally (with C<g_object_set()>). Also, with B<Gnome::Gtk3::TreeViewColumn>, you can bind a property to a value in a B<Gnome::Gtk3::TreeModel>. For example, you can bind the “pixbuf” property on the cell renderer to a pixbuf value in the model, thus rendering a different image in each row of the B<Gnome::Gtk3::TreeView>.

Returns: the new cell renderer

  method _gtk_cell_renderer_pixbuf_new ( --> N-GObject )

=end pod
}}

sub _gtk_cell_renderer_pixbuf_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_cell_renderer_pixbuf_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:0:gicon:
=head2 gicon

The GIcon being displayed

The B<Gnome::GObject::Value> type of property I<gicon> is C<G_TYPE_OBJECT>.

=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:icon-name:
=head2 icon-name

The name of the icon from the icon theme

The B<Gnome::GObject::Value> type of property I<icon-name> is C<G_TYPE_STRING>.

=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:pixbuf:
=head2 pixbuf

The pixbuf to render

The B<Gnome::GObject::Value> type of property I<pixbuf> is C<G_TYPE_OBJECT>.

=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:pixbuf-expander-closed:
=head2 pixbuf-expander-closed

Pixbuf for closed expander

The B<Gnome::GObject::Value> type of property I<pixbuf-expander-closed> is C<G_TYPE_OBJECT>.

=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:pixbuf-expander-open:
=head2 pixbuf-expander-open

Pixbuf for open expander

The B<Gnome::GObject::Value> type of property I<pixbuf-expander-open> is C<G_TYPE_OBJECT>.

=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:stock-detail:
=head2 stock-detail

Render detail to pass to the theme engine

The B<Gnome::GObject::Value> type of property I<stock-detail> is C<G_TYPE_STRING>.

=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:stock-size:
=head2 stock-size

The GtkIconSize value that specifies the size of the rendered icon

The B<Gnome::GObject::Value> type of property I<stock-size> is C<G_TYPE_UINT>.

=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is G_MAXUINT.
=item Default value is GTK_ICON_SIZE_MENU.


=comment -----------------------------------------------------------------------
=comment #TP:0:surface:
=head2 surface

The surface to render

The B<Gnome::GObject::Value> type of property I<surface> is C<G_TYPE_BOXED>.


=end pod
