#TL:1:Gnome::Gtk3::Image:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Image

A widget displaying an image

![](images/image.png)

=head1 Description

The B<Gnome::Gtk3::Image> widget displays an image. Various kinds of object can be displayed as an image; most typically, you would load a B<Gnome::Gdk3::Pixbuf> ("pixel buffer") from a file, and then display that. There’s a convenience function to do this, C<gtk_image_set_from_file()>, used as follows:

  my Gnome::Gtk3::Image $image .= new;
  $image.set-from-file("myfile.png");

To make it shorter;

  my Gnome::Gtk3::Image $image .= new(:filename<myfile.png>);

If the file isn’t loaded successfully, the image will contain a “broken image” icon similar to that used in many web browsers. If you want to handle errors in loading the file yourself, for example by displaying an error message, then load the image with C<gdk_pixbuf_new_from_file()>, then create the B<Gnome::Gtk3::Image> with C<gtk_image_new_from_pixbuf()>.

The image file may contain an animation, if so the B<Gnome::Gtk3::Image> will display an animation (B<Gnome::Gdk3::PixbufAnimation>) instead of a static image.

B<Gnome::Gtk3::Image> is a “no window” widget (has no B<Gnome::Gdk3::Window> of its own), so by default does not receive events. If you want to receive events on the image, such as button clicks, place the image inside a B<Gnome::Gtk3::EventBox>, then connect to the event signals on the event box.

When handling events on the event box, keep in mind that coordinates in the image may be different from event box coordinates due to the alignment and padding settings on the image (see B<Gnome::Gtk3::Misc>). The simplest way to solve this is to set the alignment to 0.0 (left/top), and set the padding to zero. Then the origin of the image will be the same as the origin of the event box.

A note: B<Gnome::Gtk3::Misc> is almost completely deprecated. It exists only to support the inheritance tree below the Misc class. For alignment and padding look for the methods in B<Gnome::Gtk3::Widget>.

=begin comment
Sometimes an application will want to avoid depending on external data files, such as image files. GTK+ comes with a program to avoid this, called “gdk-pixbuf-csource”. This library allows you to convert an image into a C variable declaration, which can then be loaded into a B<Gnome::Gdk3::Pixbuf> using C<gdk_pixbuf_new_from_inline()>.
=end comment


=head2 Css Nodes

B<Gnome::Gtk3::Image> has a single CSS node with the name image.

=comment head2 See Also
=comment B<Gnome::Gdk3::Pixbuf>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Image;
  also is Gnome::Gtk3::Misc;


=head2 Uml Diagram

![](plantuml/Image.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Image;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Image;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Image class process the options
    self.bless( :GtkImage, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=head2 Example
=head3 Handling button press events on a Gnome::Gtk3::Image.

  # Define a button press event handler
  method button-press-handler (
    N-GdkEventButton $event, Gnome::Gtk3::EventBox :widget($event-box)
    --> Int
  ) {
    say "Event box clicked at coordinates $event.x(), $event.y()");

    # Returning TRUE means we handled the event, so the signal
    # emission should be stopped (don’t call any further callbacks
    # that may be connected). Return FALSE to continue invoking callbacks.
    1;
  }

  # Create an image and setup a button click event on the image.
  # Return the result image object
  method create-image ( Str $image-file --> Gnome::Gtk3::Image ) {

    my Gnome::Gtk3::Image $image .= new(:filename($image-file));
    my Gnome::Gtk3::EventBox $eb .= new;
    $eb.add($image);
    $eb.register-signal( self, button-press-handler, 'button_press_event');

    $image;
  }

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Misc;

use Gnome::Cairo::Types;
use Gnome::Cairo::Surface;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkimage.h
# https://developer.gnome.org/gtk3/stable/GtkImage.html
unit class Gnome::Gtk3::Image:auth<github:MARTIMM>;
also is Gnome::Gtk3::Misc;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkImageType

Describes the image data representation used by a B<Gnome::Gtk3::Image>. If you want to get the image from the widget, you can only get the currently-stored representation. e.g.  if the C<gtk_image_get_storage_type()> returns B<GTK_IMAGE_PIXBUF>, then you can call C<gtk_image_get_pixbuf()> but not C<gtk_image_get_stock()>.  For empty images, you can request any storage type (call any of the "get" functions), but they will all return C<Any> values.

=item GTK_IMAGE_EMPTY: there is no image displayed by the widget
=item GTK_IMAGE_PIXBUF: the widget contains a B<Gnome::Gdk3::Pixbuf>
=item GTK_IMAGE_STOCK: the widget contains a [stock item name][gtkstock]
=item GTK_IMAGE_ICON_SET: the widget contains a B<Gnome::Gtk3::IconSet>
=item GTK_IMAGE_ANIMATION: the widget contains a B<Gnome::Gdk3::PixbufAnimation>
=item GTK_IMAGE_ICON_NAME: the widget contains a named icon. This image type was added in GTK+ 2.6
=item GTK_IMAGE_GICON: the widget contains a B<GIcon>. This image type was added in GTK+ 2.14
=item GTK_IMAGE_SURFACE: the widget contains a B<cairo_surface_t>. This image type was added in GTK+ 3.10


=end pod

#TE:1:GtkImageType:
enum GtkImageType is export <
  GTK_IMAGE_EMPTY
  GTK_IMAGE_PIXBUF
  GTK_IMAGE_STOCK
  GTK_IMAGE_ICON_SET
  GTK_IMAGE_ANIMATION
  GTK_IMAGE_ICON_NAME
  GTK_IMAGE_GICON
  GTK_IMAGE_SURFACE
>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 new()
Create a new plain object without an image.

  multi method new ( )


Creates a new B<Gnome::Gtk3::Image> displaying the file I<filename>. If the file isn’t found or can’t be loaded, the resulting B<Gnome::Gtk3::Image> will display a “broken image” icon.

If the file contains an animation, the image will contain an animation.

If you need to detect failures to load the file, use C<gdk_pixbuf_new_from_file()> to load the file yourself, then create the B<Gnome::Gtk3::Image> from the pixbuf.
=comment (Or for animations, use C<.new(:animation)>).

The storage type (C<gtk_image_get_storage_type()>) of the returned image is not defined, it will be whatever is appropriate for displaying the file. Create a new object and load an image from file.

  multi method new ( Str :$filename! )


=head3 new(:resource-path)

Creates a new B<Gnome::Gtk3::Image> displaying the resource file I<$resource-path>. If the file isn’t found or can’t be loaded, the resulting B<Gnome::Gtk3::Image> will display a “broken image” icon. This function never returns C<Any>, it always returns a valid B<Gnome::Gtk3::Image> widget.

If the file contains an animation, the image will contain an animation.

If you need to detect failures to load the file, use C<gdk_pixbuf_new_from_file()> to load the file yourself, then create the B<Gnome::Gtk3::Image> from the pixbuf. (Or for animations, use C<gdk_pixbuf_animation_new_from_file()>).

The storage type (C<gtk_image_get_storage_type()>) of the returned image is not defined, it will be whatever is appropriate for displaying the file.

  multi method new ( Str :$resource-path! )


=head3 new(:pixbuf)

Creates a new B<Gnome::Gtk3::Image> displaying I<$pixbuf>. The B<Gnome::Gtk3::Image> does not assume a reference to the pixbuf; you still need to unref it if you own references. B<Gnome::Gtk3::Image> will add its own reference rather than adopting yours.

Note that this function just creates an B<Gnome::Gtk3::Image> from the pixbuf. The B<Gnome::Gtk3::Image> created will not react to state changes. Should you want that, you should use C<gtk_image_new_from_icon_name()>.

  multi method new ( N-GObject :$pixbuf! )


=begin comment
=head3 new(:animation)

Creates a B<Gnome::Gtk3::Image> displaying the given animation. The B<Gnome::Gtk3::Image> does not assume a reference to the animation; you still need to unref it if you own references. B<Gnome::Gtk3::Image> will add its own reference rather than adopting yours.

Note that the animation frames are shown using a timeout with B<G_PRIORITY_DEFAULT>. When using animations to indicate busyness, keep in mind that the animation will only be shown if the main loop is not busy with something that has a higher priority.

  multi method new ( Str :$animation! )
=end comment


=head3 new( :icon-name, :size)

Creates a B<Gnome::Gtk3::Image> displaying an icon from the current icon theme. If the icon name isn’t known, a “broken image” icon will be displayed instead.  If the current icon theme is changed, the icon will be updated appropriately. You can use the program `gtk3-icon-browser` to get the available names in the current selected theme.

  multi method new (
    Str:D :$icon-name!, GtkIconSize :$size = GTK_ICON_SIZE_BUTTON
  )

=item Str $icon_name; an icon name
=item GtkIconSize $size; a stock icon size (an enum B<GtkIconSize>)


=begin comment
=head3 new( :gicon, :size)

Creates a B<Gnome::Gtk3::Image> displaying an icon from the current icon theme. If the icon name isn’t known, a “broken image” icon will be displayed instead.  If the current icon theme is changed, the icon will be updated appropriately.

  multi method new (
    N-GObject:D :$gicon!, GtkIconSize :$size = GTK_ICON_SIZE_BUTTON
  )

=item N-GObject $gicon; an icon from Gnome::Gio::GIcon
=item GtkIconSize $size; a stock icon size (an enum B<GtkIconSize>)

=end comment


=begin comment
=head3 new(:surface)

Creates a new B<Gnome::Gtk3::Image> displaying I<surface>. The B<Gnome::Gtk3::Image> does not assume a reference to the surface; you still need to unref it if you own references. B<Gnome::Gtk3::Image> will add its own reference rather than adopting yours.

  multi method new ( cairo_surface_t:D :$surface! )

=end comment



=begin comment
Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )


Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )
=end comment

=end pod

#TM:1:new():
#TM:1:new(:filename):
#TM:0:new(:resource-path):
#TM:0:new(:pixbuf):
#TM:0:new(:animation):
#TM:1:new(:icon-name,:size):
#TM:0:new(:gicon,:size):
#TM:1:new(:surface):
#TM:4:new(:native-object):TopLevelClassSupport
#TM:4:new(:build-id):Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Image' or %options<GtkImage> {

    if self.is-valid { }

    # process all named arguments
    elsif %options<native-object>:exists or %options<widget>:exists or
      %options<build-id>:exists { }

    else {
      my $no;

      if ?%options<filename> {
        $no = _gtk_image_new_from_file(%options<filename>);
      }

      elsif ?%options<resource-path> {
        $no = _gtk_image_new_from_resource(%options<resource-path>);
      }

      elsif ?%options<icon-name> {
        my GtkIconSize $size = %options<size> // GTK_ICON_SIZE_BUTTON;
        $no = _gtk_image_new_from_icon_name( %options<icon-name>, $size);
      }

      elsif ?%options<surface> {
        $no = %options<surface>;
        $no .= get-native-object-no-reffing
          if $no.^can('get-native-object-no-reffing');
        $no = _gtk_image_new_from_surface($no);
      }

#`{{
      elsif ?%options<gicon> {
        $no = %options<gicon>;
        $no .= get-native-object-no-reffing
          if $no.^can('get-native-object-no-reffing');

        my GtkIconSize $size = %options<size> // GTK_ICON_SIZE_BUTTON;
        $no = _gtk_image_new_from_icon_name( $no, $size);
      }
}}
      elsif ?%options<pixbuf> {
        $no = %options<pixbuf>;
        $no .= get-native-object-no-reffing
          if $no.^can('get-native-object-no-reffing');
        $no = _gtk_image_new_from_pixbuf($no);
      }

#`{{
      elsif ?%options<animation> {
        $no = _gtk_image_new_from_animation(%options<animation>);
      }
}}

      else {
        $no = _gtk_image_new();
      }

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkImage');
  }
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_image_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkImage');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:_gtk_image_new:new()
#`{{
=begin pod
=head2 [gtk_] image_new

Creates a new empty B<Gnome::Gtk3::Image> widget.

Returns: a newly created B<Gnome::Gtk3::Image> widget.

  method gtk_image_new ( --> N-GObject  )


=end pod
}}

sub _gtk_image_new (  )
  returns N-GObject
  is native(&gtk-lib)
  is symbol('gtk_image_new')
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gtk_image_new_from_file:new(:filename)
#`{{
=begin pod
=head2 [[gtk_] image_] new_from_file

Creates a new B<Gnome::Gtk3::Image> displaying the file I<filename>. If the file
isn’t found or can’t be loaded, the resulting B<Gnome::Gtk3::Image> will
display a “broken image” icon. This function never returns C<Any>,
it always returns a valid B<Gnome::Gtk3::Image> widget.

If the file contains an animation, the image will contain an
animation.

If you need to detect failures to load the file, use
C<gdk_pixbuf_new_from_file()> to load the file yourself, then create
the B<Gnome::Gtk3::Image> from the pixbuf. (Or for animations, use
C<gdk_pixbuf_animation_new_from_file()>).

The storage type (C<gtk_image_get_storage_type()>) of the returned
image is not defined, it will be whatever is appropriate for
displaying the file.

Returns: a new B<Gnome::Gtk3::Image>

  method gtk_image_new_from_file ( Str $filename --> N-GObject  )

=item Str $filename; (type filename): a filename

=end pod
}}

sub _gtk_image_new_from_file ( Str $filename )
  returns N-GObject
  is native(&gtk-lib)
  is symbol('gtk_image_new_from_file')
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gtk_image_new_from_resource:
#`{{
=begin pod
=head2 [[gtk_] image_] new_from_resource

Creates a new B<Gnome::Gtk3::Image> displaying the resource file I<resource_path>. If the file
isn’t found or can’t be loaded, the resulting B<Gnome::Gtk3::Image> will
display a “broken image” icon. This function never returns C<Any>,
it always returns a valid B<Gnome::Gtk3::Image> widget.

If the file contains an animation, the image will contain an
animation.

If you need to detect failures to load the file, use
C<gdk_pixbuf_new_from_file()> to load the file yourself, then create
the B<Gnome::Gtk3::Image> from the pixbuf. (Or for animations, use
C<gdk_pixbuf_animation_new_from_file()>).

The storage type (C<gtk_image_get_storage_type()>) of the returned
image is not defined, it will be whatever is appropriate for
displaying the file.

Returns: a new B<Gnome::Gtk3::Image>
  method gtk_image_new_from_resource ( Str $resource_path --> N-GObject  )

=item Str $resource_path; a resource path

=end pod
}}
sub _gtk_image_new_from_resource ( Str $resource_path )
  returns N-GObject
  is native(&gtk-lib)
  is symbol('gtk_image_new_from_resource')
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gtk_image_new_from_pixbuf:
#`{{
=begin pod
=head2 [[gtk_] image_] new_from_pixbuf

Creates a new B<Gnome::Gtk3::Image> displaying I<pixbuf>.
The B<Gnome::Gtk3::Image> does not assume a reference to the
pixbuf; you still need to unref it if you own references.
B<Gnome::Gtk3::Image> will add its own reference rather than adopting yours.

Note that this function just creates an B<Gnome::Gtk3::Image> from the pixbuf. The
B<Gnome::Gtk3::Image> created will not react to state changes. Should you want that,
you should use C<gtk_image_new_from_icon_name()>.

Returns: a new B<Gnome::Gtk3::Image>

  method gtk_image_new_from_pixbuf ( N-GObject $pixbuf --> N-GObject  )

=item N-GObject $pixbuf; (allow-none): a B<Gnome::Gdk3::Pixbuf>, or C<Any>

=end pod
}}
sub _gtk_image_new_from_pixbuf ( N-GObject $pixbuf --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_image_new_from_pixbuf')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_image_new_from_animation:
#`{{
=begin pod
=head2 [[gtk_] image_] new_from_animation

Creates a B<Gnome::Gtk3::Image> displaying the given animation.
The B<Gnome::Gtk3::Image> does not assume a reference to the
animation; you still need to unref it if you own references.
B<Gnome::Gtk3::Image> will add its own reference rather than adopting yours.

Note that the animation frames are shown using a timeout with
B<G_PRIORITY_DEFAULT>. When using animations to indicate busyness,
keep in mind that the animation will only be shown if the main loop
is not busy with something that has a higher priority.

Returns: a new B<Gnome::Gtk3::Image> widget

  method gtk_image_new_from_animation ( GdkPixbufAnimation $animation --> N-GObject  )

=item GdkPixbufAnimation $animation; an animation

=end pod
}}

#`{{
sub _gtk_image_new_from_animation ( GdkPixbufAnimation $animation )
  returns N-GObject
  is native(&gtk-lib)
  is symbol('gtk_image_new_from_animation')
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_image_new_from_icon_name:
#`{{
=begin pod
=head2 [[gtk_] image_] new_from_icon_name

Creates a B<Gnome::Gtk3::Image> displaying an icon from the current icon theme. If the icon name isn’t known, a “broken image” icon will be displayed instead.  If the current icon theme is changed, the icon will be updated appropriately. You can use the program `gtk3-icon-browser` to get the available names in the current selected theme.

Returns: a new B<Gnome::Gtk3::Image> displaying the themed icon
  method gtk_image_new_from_icon_name ( Str $icon_name, GtkIconSize $size --> N-GObject  )

=item Str $icon_name; an icon name
=item GtkIconSize $size; (type int): a stock icon size (B<Gnome::Gtk3::IconSize>)

=end pod
}}

sub _gtk_image_new_from_icon_name (
  Str $icon_name, int32 $size --> N-GObject
) is native(&gtk-lib)
  is symbol('gtk_image_new_from_icon_name')
  { * }

#`{{ Gnome::Gio::Icon not yet supported
#-------------------------------------------------------------------------------
#TM:0:_gtk_image_new_from_gicon:
#`{{
=begin pod
=head2 [[gtk_] image_] new_from_gicon

Creates a B<Gnome::Gtk3::Image> displaying an icon from the current icon theme.
If the icon name isn’t known, a “broken image” icon will be
displayed instead.  If the current icon theme is changed, the icon
will be updated appropriately.

Returns: a new B<Gnome::Gtk3::Image> displaying the themed icon
  method gtk_image_new_from_gicon ( N-GObject $icon, GtkIconSize $size --> N-GObject  )

=item N-GObject $icon; an icon
=item GtkIconSize $size; (type int): a stock icon size (B<Gnome::Gtk3::IconSize>)

=end pod
}}

sub _gtk_image_new_from_gicon ( N-GObject $icon, int32 $size --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_image_new_from_gicon')
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_image_new_from_surface:
#`{{
=begin pod
=head2 [[gtk_] image_] new_from_surface

Creates a new B<Gnome::Gtk3::Image> displaying I<surface>.
The B<Gnome::Gtk3::Image> does not assume a reference to the
surface; you still need to unref it if you own references.
B<Gnome::Gtk3::Image> will add its own reference rather than adopting yours.

Returns: a new B<Gnome::Gtk3::Image>

  method gtk_image_new_from_surface ( cairo_surface_t $surface --> N-GObject )

=item cairo_surface_t $surface; (allow-none): a B<cairo_surface_t>, or C<Any>

=end pod
}}

sub _gtk_image_new_from_surface ( cairo_surface_t $surface --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_image_new_from_surface')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_image_clear:
=begin pod
=head2 [gtk_] image_clear

Resets the image to be empty.

  method gtk_image_clear ( )


=end pod

sub gtk_image_clear ( N-GObject $image )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_image_set_from_file:
=begin pod
=head2 [[gtk_] image_] set_from_file

See C<gtk_image_new_from_file()> for details.

  method gtk_image_set_from_file ( Str $filename )

=item Str $filename; (type filename) (allow-none): a filename or C<Any>

=end pod

sub gtk_image_set_from_file ( N-GObject $image, Str $filename )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_image_set_from_resource:
=begin pod
=head2 [[gtk_] image_] set_from_resource

See C<gtk_image_new_from_resource()> for details.

  method gtk_image_set_from_resource ( Str $resource_path )

=item Str $resource_path; (allow-none): a resource path or C<Any>

=end pod

sub gtk_image_set_from_resource ( N-GObject $image, Str $resource_path )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_image_set_from_pixbuf:
=begin pod
=head2 [[gtk_] image_] set_from_pixbuf

See C<gtk_image_new_from_pixbuf()> for details.

  method gtk_image_set_from_pixbuf ( N-GObject $pixbuf )

=item N-GObject $pixbuf; (allow-none): a B<Gnome::Gdk3::Pixbuf> or C<Any>

=end pod

sub gtk_image_set_from_pixbuf ( N-GObject $image, N-GObject $pixbuf )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_image_set_from_animation:
=begin pod
=head2 [[gtk_] image_] set_from_animation

Causes the B<Gnome::Gtk3::Image> to display the given animation (or display
nothing, if you set the animation to C<Any>).

  method gtk_image_set_from_animation ( GdkPixbufAnimation $animation )

=item GdkPixbufAnimation $animation; the B<Gnome::Gdk3::PixbufAnimation>

=end pod

sub gtk_image_set_from_animation ( N-GObject $image, GdkPixbufAnimation $animation )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_image_set_from_icon_name:
=begin pod
=head2 [[gtk_] image_] set_from_icon_name

See C<gtk_image_new_from_icon_name()> for details.
  method gtk_image_set_from_icon_name ( Str $icon_name, GtkIconSize $size )

=item Str $icon_name; an icon name
=item GtkIconSize $size; (type int): an icon size (B<Gnome::Gtk3::IconSize>)

=end pod

sub gtk_image_set_from_icon_name ( N-GObject $image, Str $icon_name, int32 $size )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_image_set_from_gicon:
=begin pod
=head2 [[gtk_] image_] set_from_gicon

See C<gtk_image_new_from_gicon()> for details.
  method gtk_image_set_from_gicon ( N-GObject $icon, GtkIconSize $size )

=item N-GObject $icon; an icon
=item GtkIconSize $size; (type int): an icon size (B<Gnome::Gtk3::IconSize>)

=end pod

sub gtk_image_set_from_gicon ( N-GObject $image, N-GObject $icon, int32 $size )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_image_set_from_surface:
=begin pod
=head2 [[gtk_] image_] set_from_surface

See C<gtk_image_new_from_surface()> for details.
  method gtk_image_set_from_surface ( cairo_surface_t $surface )

=item cairo_surface_t $surface; a cairo_surface_t

=end pod

sub gtk_image_set_from_surface ( N-GObject $image, cairo_surface_t $surface )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_image_set_pixel_size:
=begin pod
=head2 [[gtk_] image_] set_pixel_size

Sets the pixel size to use for named icons. If the pixel size is set
to a value != -1, it is used instead of the icon size set by
C<gtk_image_set_from_icon_name()>.
  method gtk_image_set_pixel_size ( Int $pixel_size )

=item Int $pixel_size; the new pixel size

=end pod

sub gtk_image_set_pixel_size ( N-GObject $image, int32 $pixel_size )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_image_get_storage_type:
=begin pod
=head2 [[gtk_] image_] get_storage_type

Gets the type of representation being used by the B<Gnome::Gtk3::Image>
to store image data. If the B<Gnome::Gtk3::Image> has no image data,
the return value will be C<GTK_IMAGE_EMPTY>.

Returns: image representation being used

  method gtk_image_get_storage_type ( --> GtkImageType )

=end pod

sub gtk_image_get_storage_type ( N-GObject $image  --> GtkImageType ) {
  GtkImageType(_gtk_image_get_storage_type($image))
}

sub _gtk_image_get_storage_type ( N-GObject $image --> int32 )
  is native(&gtk-lib)
  is symbol('gtk_image_get_storage_type')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_image_get_pixbuf:
=begin pod
=head2 [[gtk_] image_] get_pixbuf

Gets the B<Gnome::Gdk3::Pixbuf> being displayed by the B<Gnome::Gtk3::Image>. The storage type of the image must be C<GTK_IMAGE_EMPTY> or C<GTK_IMAGE_PIXBUF> (see C<gtk_image_get_storage_type()>). The caller of this function does not own a reference to the returned pixbuf.

Returns: the displayed pixbuf, or C<Any> if the image is empty

  method gtk_image_get_pixbuf ( --> N-GObject  )


=end pod

sub gtk_image_get_pixbuf ( N-GObject $image )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_image_get_animation:
=begin pod
=head2 [[gtk_] image_] get_animation

Gets the B<Gnome::Gdk3::PixbufAnimation> being displayed by the B<Gnome::Gtk3::Image>.
The storage type of the image must be C<GTK_IMAGE_EMPTY> or
C<GTK_IMAGE_ANIMATION> (see C<gtk_image_get_storage_type()>).
The caller of this function does not own a reference to the
returned animation.

Returns: (nullable) (transfer none): the displayed animation, or C<Any> if
the image is empty

  method gtk_image_get_animation ( --> GdkPixbufAnimation  )

=end pod

sub gtk_image_get_animation ( N-GObject $image )
  returns GdkPixbufAnimation
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_image_get_icon_name:
=begin pod
=head2 [[gtk_] image_] get_icon_name

Gets the icon name and size being displayed by the B<Gnome::Gtk3::Image>. The storage type of the image must be C<GTK_IMAGE_EMPTY> or C<GTK_IMAGE_ICON_NAME> (see C<gtk_image_get_storage_type()>). The returned string is owned by the B<Gnome::Gtk3::Image> and should not be freed.

  method gtk_image_get_icon_name ( --> List )

The returned List holds
=item Str $icon_name; the icon name, or C<Any>
=item GtkIconSize $size; the icon size of type (B<GtkIconSize>), or C<Any>

=end pod

sub gtk_image_get_icon_name ( N-GObject $image --> List ) {
  my $in = CArray[Str].new('');
  my int32 $size .= new;
  _gtk_image_get_icon_name( $image, $in, $size);

  ( $in[0], GtkIconSize($size))
}

sub _gtk_image_get_icon_name (
  N-GObject $image, CArray[Str] $icon_name, int32 $size is rw
) is native(&gtk-lib)
  is symbol("gtk_image_get_icon_name")
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_image_get_gicon:
=begin pod
=head2 [[gtk_] image_] get_gicon

Gets the B<GIcon> and size being displayed by the B<Gnome::Gtk3::Image>. The storage type of the image must be C<GTK_IMAGE_EMPTY> or C<GTK_IMAGE_GICON> (see C<gtk_image_get_storage_type()>). The caller of this function does not own a reference to the returned B<GIcon>.

  method gtk_image_get_gicon ( N-GObject $gicon, GtkIconSize $size )

=item N-GObject $gicon; (out) (transfer none) (allow-none): place to store a B<GIcon>, or C<Any>
=item GtkIconSize $size; (out) (allow-none) (type int): place to store an icon size (B<Gnome::Gtk3::IconSize>), or C<Any>

=end pod

sub gtk_image_get_gicon ( N-GObject $image, N-GObject $gicon, int32 $size )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_image_get_pixel_size:
=begin pod
=head2 [[gtk_] image_] get_pixel_size

Gets the pixel size used for named icons.

  method gtk_image_get_pixel_size ( --> Int  )


=end pod

sub gtk_image_get_pixel_size ( N-GObject $image --> int32 )
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
=head3 Pixbuf

A B<Gnome::Gdk3::Pixbuf> to display
Widget type: GDK_TYPE_PIXBUF

The B<Gnome::GObject::Value> type of property I<pixbuf> is C<G_TYPE_OBJECT>.


=comment #TP:0:surface:
=head3 Surface

The B<Gnome::GObject::Value> type of property I<surface> is C<G_TYPE_BOXED>.


=comment #TP:0:file:
=head3 Filename

Filename to load and display
Default value: Any

The B<Gnome::GObject::Value> type of property I<file> is C<G_TYPE_STRING>.


=comment #TP:0:pixbuf-animation:
=head3 Animation

B<Gnome::Gdk3::PixbufAnimation> to display
Widget type: GDK_TYPE_PIXBUF_ANIMATION

The B<Gnome::GObject::Value> type of property I<pixbuf-animation> is C<G_TYPE_OBJECT>.


=comment #TP:0:icon-name:
=head3 Icon Name

The name of the icon in the icon theme. If the icon theme is
changed, the image will be updated automatically.

The B<Gnome::GObject::Value> type of property I<icon-name> is C<G_TYPE_STRING>.


=comment #TP:0:gicon:
=head3 Icon

The GIcon displayed in the B<Gnome::Gtk3::Image>. For themed icons,
If the icon theme is changed, the image will be updated
automatically.
Widget type: G_TYPE_ICON

The B<Gnome::GObject::Value> type of property I<gicon> is C<G_TYPE_OBJECT>.


=comment #TP:0:resource:
=head3 Resource

A path to a resource file to display.

The B<Gnome::GObject::Value> type of property I<resource> is C<G_TYPE_STRING>.


=comment #TP:0:storage-type:
=head3 Storage type

The representation being used for image data
Default value: False

The B<Gnome::GObject::Value> type of property I<storage-type> is C<G_TYPE_ENUM>.


=comment #TP:0:use-fallback:
=head3 Use Fallback

Whether the icon displayed in the B<Gnome::Gtk3::Image> will use
standard icon names fallback. The value of this property
is only relevant for images of type C<GTK_IMAGE_ICON_NAME>
and C<GTK_IMAGE_GICON>.

The B<Gnome::GObject::Value> type of property I<use-fallback> is C<G_TYPE_BOOLEAN>.
=end pod



























=finish
#-------------------------------------------------------------------------------
sub gtk_image_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_image_new_from_file ( Str $filename )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# image is a GtkImage
sub gtk_image_set_from_file ( N-GObject $image, Str $filename)
  is native(&gtk-lib)
  { * }

sub gtk_image_clear ( N-GObject $image )
  is native(&gtk-lib)
  { * }

# GtkImageType is an enum -> uint32
sub gtk_image_get_storage_type ( N-GObject $image )
  returns uint32
  is native(&gtk-lib)
  { * }

sub gtk_image_get_pixbuf ( N-GObject $image )
  returns OpaquePointer
  is native(&gtk-lib)
  { * }
