#TL:1:Gnome::Gtk3::OffscreenWindow:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::OffscreenWindow

A toplevel to manage offscreen rendering of child widgets

=comment ![](images/X.png)

=head1 Description

GtkOffscreenWindow is strictly intended to be used for obtaining snapshots of widgets that are not part of a normal widget hierarchy. Since B<Gnome::Gtk3::OffscreenWindow> is a toplevel widget you cannot obtain snapshots of a full window with it since you cannot pack a toplevel widget in another toplevel.

The idea is to take a widget and manually set the state of it, add it to a GtkOffscreenWindow and then retrieve the snapshot as a B<cairo-surface-t> or B<Gnome::Gtk3::Pixbuf>.

GtkOffscreenWindow derives from B<Gnome::Gtk3::Window> only as an implementation detail.  Applications should not use any API specific to B<Gnome::Gtk3::Window> to operate on this object.  It should be treated as a B<Gnome::Gtk3::Bin> that has no parent widget.

When contained offscreen widgets are redrawn, GtkOffscreenWindow will emit a  I<damage-event> signal.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::OffscreenWindow;
  also is Gnome::Gtk3::Window;


=head2 Uml Diagram

![](plantuml/OffscreenWindow.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::OffscreenWindow;

  unit class MyGuiClass;
  also is Gnome::Gtk3::OffscreenWindow;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::OffscreenWindow class process the options
    self.bless( :GtkOffscreenWindow, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=head2 Example

An example where a grid with two buttons are rendered and saved in a png and a jpg image file.

  # Setup something to show in an image.
  my Gnome::Gtk3::Button $b1 .= new(:label<Stop>);
  my Gnome::Gtk3::Button $b2 .= new(:label<Start>);
  my Gnome::Gtk3::Grid $g  .= new;
  $g.attach( $b1, 0, 0, 1, 1);
  $g.attach( $b2, 1, 0, 1, 1);
  $ow.add($g);
  $ow.show-all;

  # Must process pending events, otherwise nothing is shown! Note,
  # that this is written outside the main event loop in the test program!
  # Otherwise, this is not necessary.
  my Gnome::Gtk3::Main $main .= new;
  while $main.gtk-events-pending() { $main.iteration-do(False); }

  # Now we can try to get the contents of the widget. First using
  # a cairo_surface
  my Gnome::Cairo::ImageSurface $image-surface .= new(
    :native-object($ow.get-surface)
  );
  $image-surface.write_to_png("xt/data/OffscreenWindow-surface.png");
  $image-surface.clear-object;

  # Then using a pixbuf
  my Gnome::Gdk3::Pixbuf $pb = $ow.get-pixbuf-rk;
  my Gnome::Glib::Error $e = $pb.savev(
    "xt/data/OffscreenWindow-pixbuf.jpg", 'jpeg', ['quality'], ['100']
  );

The result of the png and jpg file;

![](images/OffscreenWindow.png)

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::Window;

use Gnome::Gdk3::Pixbuf;

use Gnome::Cairo::Types;
use Gnome::Cairo::ImageSurface;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::OffscreenWindow:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::Gtk3::Window;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

This widget can only be created by calling C<new()> without any options. Importing from other widgets using C<:native-object> is not very useful. The glade GUI designer program has the offscreen window widget which can be placed in your design so the C<:build-id> is still possible.

=head3 default, no options

Creates a toplevel container widget that is used to retrieve snapshots of widgets without showing them on the screen.

  multi method new ( )


=begin comment
=head3 :native-object

Create a OffscreenWindow object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )
=end comment


=head3 :build-id

Create a OffscreenWindow object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:1:new():
# TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::OffscreenWindow' #`{{ or %options<GtkOffscreenWindow> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    #elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        $no = %options<___x___>;
        $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_offscreen_window_new___x___($no);
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
        $no = _gtk_offscreen_window_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkOffscreenWindow');
  }
}


#-------------------------------------------------------------------------------
#TM:1:get-pixbuf:
#TM:1:get-pixbuf-rk:
=begin pod
=head2 get-pixbuf, get-pixbuf-rk

Retrieves a snapshot of the contained widget in the form of a B<Gnome::Gdk3::Pixbuf>. This is a new pixbuf with a reference count of 1, and the application should unreference it once it is no longer needed.

  method get-pixbuf ( --> N-GObject )
  method get-pixbuf-rk ( --> Gnome::Gdk3::Pixbuf )

=end pod

method get-pixbuf ( --> N-GObject ) {
  gtk_offscreen_window_get_pixbuf( self._f('GtkOffscreenWindow'))
}

method get-pixbuf-rk ( --> Gnome::Gdk3::Pixbuf ) {
  Gnome::Gdk3::Pixbuf.new(
    :native-object(
      gtk_offscreen_window_get_pixbuf( self._f('GtkOffscreenWindow'))
    )
  )
}

sub gtk_offscreen_window_get_pixbuf (
  N-GObject $offscreen --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-surface:
#TM:1:get-surface-rk:
=begin pod
=head2 get-surface, get-surface-rk

Retrieves a snapshot of the contained widget in the form of a B<cairo-surface-t>. If you need to keep this around over window resizes then you should add a reference to it.

Returns: A B<cairo-surface-t> pointer to the offscreen surface, or C<undefined>.

  method get-surface ( --> cairo_surface_t )
  method get-surface-rk ( --> Gnome::Cairo::Surface )

=end pod

method get-surface ( --> cairo_surface_t ) {
  gtk_offscreen_window_get_surface(self._f('GtkOffscreenWindow'))
}

method get-surface-rk ( --> Gnome::Cairo::Surface ) {
  Gnome::Cairo::Surface.new(
    :native-object(
      gtk_offscreen_window_get_surface(self._f('GtkOffscreenWindow'))
    )
  )
}

sub gtk_offscreen_window_get_surface (
  N-GObject $offscreen --> cairo_surface_t
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_offscreen_window_new:
#`{{
=begin pod
=head2 _gtk_offscreen_window_new

Creates a toplevel container widget that is used to retrieve snapshots of widgets without showing them on the screen.

Returns: A pointer to a B<Gnome::Gtk3::Widget>

  method _gtk_offscreen_window_new ( --> N-GObject )

=end pod
}}

sub _gtk_offscreen_window_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_offscreen_window_new')
  { * }
