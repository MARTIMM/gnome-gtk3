#TL:1:Gnome::Gtk3::Image:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Image

A widget displaying an image

![](images/image.png)

=head1 Description

The B<Gnome::Gtk3::Image> widget displays an image. Various kinds of object can be displayed as an image; most typically, you would load a B<Gnome::Gdk3::Pixbuf> ("pixel buffer") from a file, and then display that. There’s a convenience function to do this, C<set_from_file()>, used as follows:

  my Gnome::Gtk3::Image $image .= new;
  $image.set-from-file("myfile.png");

To make it shorter;

  my Gnome::Gtk3::Image $image .= new(:file<myfile.png>);

If the file isn’t loaded successfully, the image will contain a “broken image” icon similar to that used in many web browsers. If you want to handle errors in loading the file yourself, for example by displaying an error message, then load the image like next example

  my Gnome::Gdk3::Pixbuf $pixbuf .= new(:$file);
  die $e.message if $pixbuf.last-error.is-valid;
  my Gnome::Gtk3::Image $image .= new(:$pixbuf);

The image file may contain an animation, if so the B<Gnome::Gtk3::Image> will display an animation
=comment (B<Gnome::Gdk3::PixbufAnimation>)
instead of a static image.

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
    --> Bool
  ) {
    say "Event box clicked at coordinates $event.x(), $event.y()");

    # Returning True means we handled the event, so the signal
    # emission should be stopped (don’t call any further callbacks
    # that may be connected). Return False to continue invoking callbacks.
    True
  }

  # Create an image and setup a button click event on the image.
  # Return the result image object
  method create-image ( Str $image-file --> Gnome::Gtk3::Image ) {
    my Gnome::Gtk3::Image $image .= new(:filename($image-file));
    my Gnome::Gtk3::EventBox $eb .= new;
    $eb.add($image);
    $eb.register-signal( self, button-press-handler, 'button_press_event');

    $image
  }

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::N::GlibToRakuTypes;

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

=head3 default, no options

Create a new plain object without an image.

  multi method new ( )

=begin comment
=head3 :animation

Creates a B<Gnome::Gtk3::Image> displaying the given animation. The B<Gnome::Gtk3::Image> does not assume a reference to the animation; you still need to unref it if you own references. B<Gnome::Gtk3::Image> will add its own reference rather than adopting yours.

Note that the animation frames are shown using a timeout with B<G_PRIORITY_DEFAULT>. When using animations to indicate busyness, keep in mind that the animation will only be shown if the main loop is not busy with something that has a higher priority.

  multi method new ( Str :$animation! )
=end comment


=head3 :file

Creates a new B<Gnome::Gtk3::Image> displaying the file I<filename>. If the file isn’t found or can’t be loaded, the resulting B<Gnome::Gtk3::Image> will display a “broken image” icon.

If the file contains an animation, the image will contain an animation.

If you need to detect failures to load the file, use C<gdk_pixbuf_new_from_file()> to load the file yourself, then create the B<Gnome::Gtk3::Image> from the pixbuf.
=comment (Or for animations, use C<.new(:animation)>).

The storage type (C<gtk_image_get_storage_type()>) of the returned image is not defined, it will be whatever is appropriate for displaying the file. Create a new object and load an image from file.

  multi method new ( Str :$file! )


=begin comment
=head3 :gicon, :size

Creates a B<Gnome::Gtk3::Image> displaying an icon from the current icon theme. If the icon name isn’t known, a “broken image” icon will be displayed instead.  If the current icon theme is changed, the icon will be updated appropriately.

  multi method new (
    N-GObject:D :$gicon!, GtkIconSize :$size = GTK_ICON_SIZE_BUTTON
  )

=item N-GObject $gicon; an icon from Gnome::Gio::GIcon
=item GtkIconSize $size; a stock icon size (an enum B<GtkIconSize>)
=end comment


=head3 :icon-name, :size

Creates a B<Gnome::Gtk3::Image> displaying an icon from the current icon theme. If the icon name isn’t known, a “broken image” icon will be displayed instead.  If the current icon theme is changed, the icon will be updated appropriately. You can use the program `gtk3-icon-browser` to get the available names in the current selected theme.

  multi method new (
    Str:D :$icon-name!, GtkIconSize :$size = GTK_ICON_SIZE_BUTTON
  )

=item Str $icon_name; an icon name
=item GtkIconSize $size; a stock icon size (an enum B<GtkIconSize>)


=head3 :pixbuf

Creates a new B<Gnome::Gtk3::Image> displaying I<$pixbuf>. The B<Gnome::Gtk3::Image> does not assume a reference to the pixbuf; you still need to unref it if you own references. B<Gnome::Gtk3::Image> will add its own reference rather than adopting yours.

Note that this function just creates an B<Gnome::Gtk3::Image> from the pixbuf. The B<Gnome::Gtk3::Image> created will not react to state changes. Should you want that, you should use C<gtk_image_new_from_icon_name()>.

  multi method new ( N-GObject :$pixbuf! )


=head3 :resource-path

Creates a new B<Gnome::Gtk3::Image> displaying the resource file I<$resource-path>. If the file isn’t found or can’t be loaded, the resulting B<Gnome::Gtk3::Image> will display a “broken image” icon. This function never returns C<Any>, it always returns a valid B<Gnome::Gtk3::Image> widget.

If the file contains an animation, the image will contain an animation.

If you need to detect failures to load the file, use C<gdk_pixbuf_new_from_file()> to load the file yourself, then create the B<Gnome::Gtk3::Image> from the pixbuf. (Or for animations, use C<gdk_pixbuf_animation_new_from_file()>).

The storage type (C<gtk_image_get_storage_type()>) of the returned image is not defined, it will be whatever is appropriate for displaying the file.

  multi method new ( Str :$resource-path! )


=head3 :surface

Creates a new B<Gnome::Gtk3::Image> displaying I<surface>. The B<Gnome::Gtk3::Image> does not assume a reference to the surface; you still need to unref it if you own references. B<Gnome::Gtk3::Image> will add its own reference rather than adopting yours.

  multi method new ( cairo_surface_t:D :$surface! )


=head3 :native-object

Create a Image object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a Image object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )


=end pod

#TM:1:new():
#TM:0:new(:animation):
#TM:1:new(:file):
#TM:0:new(:gicon,:size):
#TM:1:new(:icon-name,:size):
#TM:1:new(:pixbuf):
#TM:0:new(:resource-path):
#TM:1:new(:surface):

#TM:4:new(:native-object):TopLevelClassSupport
#TM:4:new(:build-id):Object
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Image' or %options<GtkImage> {

    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;

      if ?%options<filename> or ?%options<file> {
        my $f = %options<file> // %options<filename>;
        $no = _gtk_image_new_from_file($f);

        Gnome::N::deprecate(
          'new(:$filename)', 'new(:$file)', '0.41.0', '0.45.0'
        ) if %options<filename>:exists;
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
        $no .= _get-native-object(:!ref) unless $no ~~ cairo_surface_t;
        $no = _gtk_image_new_from_surface($no);
      }

#`{{
      elsif ?%options<gicon> {
        $no = %options<gicon>;
        $no .= _get-native-object(:!ref) ~~ N-GObject;
        my GtkIconSize $size = %options<size> // GTK_ICON_SIZE_BUTTON;
        $no = _gtk_image_new_from_icon_name( $no, $size);
      }
}}
      elsif ?%options<pixbuf> {
        $no = %options<pixbuf>;
        $no .= _get-native-object(:!ref) ~~ N-GObject;
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

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkImage');
  }
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_image_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkImage');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:clear:
=begin pod
=head2 clear

Resets the image to be empty.

  method clear ( )

=end pod

method clear ( ) {

  gtk_image_clear(
    self._get-native-object(:!ref),
  );
}

sub gtk_image_clear (
  N-GObject $image
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-animation:
=begin pod
=head2 get-animation

Gets the B<Gnome::Gtk3::PixbufAnimation> being displayed by the B<Gnome::Gtk3::Image>. The storage type of the image must be C<GTK-IMAGE-EMPTY> or C<GTK-IMAGE-ANIMATION> (see C<get-storage-type()>). The caller of this function does not own a reference to the returned animation.

Returns: the displayed animation, or C<undefined> if the image is empty

  method get-animation ( --> GdkPixbufAnimation )

=end pod

method get-animation ( --> GdkPixbufAnimation ) {

  gtk_image_get_animation(
    self._get-native-object(:!ref),
  )
}

sub gtk_image_get_animation (
  N-GObject $image --> GdkPixbufAnimation
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-gicon:
=begin pod
=head2 get-gicon

Gets the B<Gnome::Gtk3::Icon> and size being displayed by the B<Gnome::Gtk3::Image>. The storage type of the image must be C<GTK-IMAGE-EMPTY> or C<GTK-IMAGE-GICON> (see C<get-storage-type()>). The caller of this function does not own a reference to the returned B<Gnome::Gtk3::Icon>.

  method get-gicon ( GIcon $gicon, GtkIconSize $size )

=item GIcon $gicon; place to store a B<Gnome::Gtk3::Icon>, or C<undefined>
=item GtkIconSize $size;   (type int): place to store an icon size (B<Gnome::Gtk3::IconSize>), or C<undefined>
=end pod

method get-gicon ( GIcon $gicon, GtkIconSize $size ) {

  gtk_image_get_gicon(
    self._get-native-object(:!ref), $gicon, $size
  );
}

sub gtk_image_get_gicon (
  N-GObject $image, GIcon $gicon, GEnum $size
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:get-icon-name:
=begin pod
=head2 get-icon-name

Gets the icon name and size being displayed by the B<Gnome::Gtk3::Image>. The storage type of the image must be C<GTK-IMAGE-EMPTY> or C<GTK-IMAGE-ICON-NAME> (see C<get-storage-type()>). The returned string is owned by the B<Gnome::Gtk3::Image> and should not be freed.

  method get-icon-name ( --> List )

=item CArray[Str] $icon_name; place to store an icon name, or C<undefined>
=item GtkIconSize $size;   (type int): place to store an icon size (B<Gnome::Gtk3::IconSize>), or C<undefined>
=end pod

method get-icon-name ( --> List ) {
  my $in = CArray[Str].new('');
  my int32 $size .= new;
  gtk_image_get_icon_name( self._get-native-object(:!ref), $in, $size);

  ( $in[0], GtkIconSize($size))
}

sub gtk_image_get_icon_name (
  N-GObject $image, gchar-pptr $icon_name, GEnum $size
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-pixbuf:
=begin pod
=head2 get-pixbuf

Gets the B<Gnome::Gtk3::Pixbuf> being displayed by the B<Gnome::Gtk3::Image>. The storage type of the image must be C<GTK-IMAGE-EMPTY> or C<GTK-IMAGE-PIXBUF> (see C<get-storage-type()>). The caller of this function does not own a reference to the returned pixbuf.

Returns: the displayed pixbuf, or C<undefined> if the image is empty

  method get-pixbuf ( --> N-GObject )

=end pod

method get-pixbuf ( --> N-GObject ) {
  gtk_image_get_pixbuf(self._get-native-object(:!ref))
}

sub gtk_image_get_pixbuf (
  N-GObject $image --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-pixel-size:
=begin pod
=head2 get-pixel-size

Gets the pixel size used for named icons.

Returns: the pixel size used for named icons.

  method get-pixel-size ( --> Int )

=end pod

method get-pixel-size ( --> Int ) {
  gtk_image_get_pixel_size(self._get-native-object(:!ref))
}

sub gtk_image_get_pixel_size (
  N-GObject $image --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-storage-type:
=begin pod
=head2 get-storage-type

Gets the type of representation being used by the B<Gnome::Gtk3::Image> to store image data. If the B<Gnome::Gtk3::Image> has no image data, the return value will be C<GTK-IMAGE-EMPTY>.

Returns: image representation being used

  method get-storage-type ( --> GtkImageType )

=end pod

method get-storage-type ( --> GtkImageType ) {
  GtkImageType(gtk_image_get_storage_type(self._get-native-object(:!ref)))
}

sub gtk_image_get_storage_type (
  N-GObject $image --> GEnum
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-from-animation:
=begin pod
=head2 set-from-animation

Causes the B<Gnome::Gtk3::Image> to display the given animation (or display nothing, if you set the animation to C<undefined>).

  method set-from-animation ( GdkPixbufAnimation $animation )

=item GdkPixbufAnimation $animation; the B<Gnome::Gtk3::PixbufAnimation>
=end pod

method set-from-animation ( GdkPixbufAnimation $animation ) {

  gtk_image_set_from_animation(
    self._get-native-object(:!ref), $animation
  );
}

sub gtk_image_set_from_animation (
  N-GObject $image, GdkPixbufAnimation $animation
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:set-from-file:
=begin pod
=head2 set-from-file

See C<new-from-file()> for details.

  method set-from-file ( Str $filename )

=item Str $filename; a filename or C<undefined>
=end pod

method set-from-file ( Str $filename ) {

  gtk_image_set_from_file(
    self._get-native-object(:!ref), $filename
  );
}

sub gtk_image_set_from_file (
  N-GObject $image, gchar-ptr $filename
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-from-gicon:
=begin pod
=head2 set-from-gicon

See C<new-from-gicon()> for details.

  method set-from-gicon ( GIcon $icon, GtkIconSize $size )

=item GIcon $icon; an icon
=item GtkIconSize $size; (type int): an icon size (B<Gnome::Gtk3::IconSize>)
=end pod

method set-from-gicon ( GIcon $icon, GtkIconSize $size ) {

  gtk_image_set_from_gicon(
    self._get-native-object(:!ref), $icon, $size
  );
}

sub gtk_image_set_from_gicon (
  N-GObject $image, GIcon $icon, GEnum $size
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:set-from-icon-name:
=begin pod
=head2 set-from-icon-name

See C<new-from-icon-name()> for details.

  method set-from-icon-name ( Str $icon_name, GtkIconSize $size )

=item Str $icon_name; an icon name or C<undefined>
=item GtkIconSize $size; an icon size
=end pod

method set-from-icon-name ( Str $icon_name, GtkIconSize $size ) {
  gtk_image_set_from_icon_name(
    self._get-native-object(:!ref), $icon_name, $size
  );
}

sub gtk_image_set_from_icon_name (
  N-GObject $image, gchar-ptr $icon_name, GEnum $size
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-from-pixbuf:
=begin pod
=head2 set-from-pixbuf

See C<new-from-pixbuf()> for details.

  method set-from-pixbuf ( N-GObject $pixbuf )

=item N-GObject $pixbuf; a B<Gnome::Gtk3::Pixbuf> or C<undefined>
=end pod

method set-from-pixbuf ( $pixbuf is copy ) {
  $pixbuf .= _get-native-object(:!ref) unless $pixbuf ~~ N-GObject;

  gtk_image_set_from_pixbuf(
    self._get-native-object(:!ref), $pixbuf
  );
}

sub gtk_image_set_from_pixbuf (
  N-GObject $image, N-GObject $pixbuf
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-from-resource:
=begin pod
=head2 set-from-resource

See C<new-from-resource()> for details.

  method set-from-resource ( Str $resource_path )

=item Str $resource_path; a resource path or C<undefined>
=end pod

method set-from-resource ( Str $resource_path ) {

  gtk_image_set_from_resource(
    self._get-native-object(:!ref), $resource_path
  );
}

sub gtk_image_set_from_resource (
  N-GObject $image, gchar-ptr $resource_path
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-from-surface:
=begin pod
=head2 set-from-surface

See C<new-from-surface()> for details.

  method set-from-surface ( cairo_surface_t $surface )

=item cairo_surface_t $surface; a cairo-surface-t or C<undefined>
=end pod

method set-from-surface ( $surface is copy ) {
  $surface .= _get-native-object(:!ref) unless $surface ~~ cairo_surface_t;
  gtk_image_set_from_surface( self._get-native-object(:!ref), $surface);
}

sub gtk_image_set_from_surface (
  N-GObject $image, cairo_surface_t $surface
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-pixel-size:
=begin pod
=head2 set-pixel-size

Sets the pixel size to use for named icons. If the pixel size is set to a value != -1, it is used instead of the icon size set by C<set-from-icon-name()>.

  method set-pixel-size ( Int() $pixel_size )

=item Int() $pixel_size; the new pixel size
=end pod

method set-pixel-size ( Int() $pixel_size ) {

  gtk_image_set_pixel_size(
    self._get-native-object(:!ref), $pixel_size
  );
}

sub gtk_image_set_pixel_size (
  N-GObject $image, gint $pixel_size
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_image_new:
#`{{
=begin pod
=head2 _gtk_image_new

Creates a new empty B<Gnome::Gtk3::Image> widget.

Returns: a newly created B<Gnome::Gtk3::Image> widget.

  method _gtk_image_new ( --> N-GObject )

=end pod
}}

sub _gtk_image_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_image_new')
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:1:_gtk_image_new_from_animation:
#`{{
=begin pod
=head2 _gtk_image_new_from_animation

Creates a B<Gnome::Gtk3::Image> displaying the given animation. The B<Gnome::Gtk3::Image> does not assume a reference to the animation; you still need to unref it if you own references. B<Gnome::Gtk3::Image> will add its own reference rather than adopting yours.

Note that the animation frames are shown using a timeout with B<Gnome::Gtk3::-PRIORITY-DEFAULT>. When using animations to indicate busyness, keep in mind that the animation will only be shown if the main loop is not busy with something that has a higher priority.

Returns: a new B<Gnome::Gtk3::Image> widget

  method _gtk_image_new_from_animation ( GdkPixbufAnimation $animation --> N-GObject )

=item GdkPixbufAnimation $animation; an animation
=end pod
}}

sub _gtk_image_new_from_animation ( GdkPixbufAnimation $animation --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_image_new_from_animation')
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_image_new_from_file:
#`{{
=begin pod
=head2 _gtk_image_new_from_file

Creates a new B<Gnome::Gtk3::Image> displaying the file I<filename>. If the file isn’t found or can’t be loaded, the resulting B<Gnome::Gtk3::Image> will display a “broken image” icon. This function never returns C<undefined>, it always returns a valid B<Gnome::Gtk3::Image> widget.

If the file contains an animation, the image will contain an animation.

If you need to detect failures to load the file, use C<gdk-pixbuf-new-from-file()> to load the file yourself, then create the B<Gnome::Gtk3::Image> from the pixbuf. (Or for animations, use C<gdk-pixbuf-animation-new-from-file()>).

The storage type (C<get-storage-type()>) of the returned image is not defined, it will be whatever is appropriate for displaying the file.

Returns: a new B<Gnome::Gtk3::Image>

  method _gtk_image_new_from_file ( Str $filename --> N-GObject )

=item Str $filename; (type filename): a filename
=end pod
}}

sub _gtk_image_new_from_file ( gchar-ptr $filename --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_image_new_from_file')
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:1:_gtk_image_new_from_gicon:
#`{{
=begin pod
=head2 _gtk_image_new_from_gicon

Creates a B<Gnome::Gtk3::Image> displaying an icon from the current icon theme. If the icon name isn’t known, a “broken image” icon will be displayed instead. If the current icon theme is changed, the icon will be updated appropriately.

Returns: a new B<Gnome::Gtk3::Image> displaying the themed icon

  method _gtk_image_new_from_gicon ( GIcon $icon, GtkIconSize $size --> N-GObject )

=item GIcon $icon; an icon
=item GtkIconSize $size; (type int): a stock icon size (B<Gnome::Gtk3::IconSize>)
=end pod
}}

sub _gtk_image_new_from_gicon ( GIcon $icon, GEnum $size --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_image_new_from_gicon')
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_image_new_from_icon_name:
#`{{
=begin pod
=head2 _gtk_image_new_from_icon_name

Creates a B<Gnome::Gtk3::Image> displaying an icon from the current icon theme. If the icon name isn’t known, a “broken image” icon will be displayed instead. If the current icon theme is changed, the icon will be updated appropriately.

Returns: a new B<Gnome::Gtk3::Image> displaying the themed icon

  method _gtk_image_new_from_icon_name ( Str $icon_name, GtkIconSize $size --> N-GObject )

=item Str $icon_name; an icon name or C<undefined>
=item GtkIconSize $size; (type int): a stock icon size (B<Gnome::Gtk3::IconSize>)
=end pod
}}

sub _gtk_image_new_from_icon_name ( gchar-ptr $icon_name, GEnum $size --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_image_new_from_icon_name')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_image_new_from_pixbuf:
#`{{
=begin pod
=head2 _gtk_image_new_from_pixbuf

Creates a new B<Gnome::Gtk3::Image> displaying I<pixbuf>. The B<Gnome::Gtk3::Image> does not assume a reference to the pixbuf; you still need to unref it if you own references. B<Gnome::Gtk3::Image> will add its own reference rather than adopting yours.

Note that this function just creates an B<Gnome::Gtk3::Image> from the pixbuf. The B<Gnome::Gtk3::Image> created will not react to state changes. Should you want that, you should use C<new-from-icon-name()>.

Returns: a new B<Gnome::Gtk3::Image>

  method _gtk_image_new_from_pixbuf ( N-GObject $pixbuf --> N-GObject )

=item N-GObject $pixbuf; a B<Gnome::Gtk3::Pixbuf>, or C<undefined>
=end pod
}}

sub _gtk_image_new_from_pixbuf ( N-GObject $pixbuf --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_image_new_from_pixbuf')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_image_new_from_resource:
#`{{
=begin pod
=head2 _gtk_image_new_from_resource

Creates a new B<Gnome::Gtk3::Image> displaying the resource file I<resource-path>. If the file isn’t found or can’t be loaded, the resulting B<Gnome::Gtk3::Image> will display a “broken image” icon. This function never returns C<undefined>, it always returns a valid B<Gnome::Gtk3::Image> widget.

If the file contains an animation, the image will contain an animation.

If you need to detect failures to load the file, use C<gdk-pixbuf-new-from-file()> to load the file yourself, then create the B<Gnome::Gtk3::Image> from the pixbuf. (Or for animations, use C<gdk-pixbuf-animation-new-from-file()>).

The storage type (C<get-storage-type()>) of the returned image is not defined, it will be whatever is appropriate for displaying the file.

Returns: a new B<Gnome::Gtk3::Image>

  method _gtk_image_new_from_resource ( Str $resource_path --> N-GObject )

=item Str $resource_path; a resource path
=end pod
}}

sub _gtk_image_new_from_resource ( gchar-ptr $resource_path --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_image_new_from_resource')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_image_new_from_surface:
#`{{
=begin pod
=head2 _gtk_image_new_from_surface

Creates a new B<Gnome::Gtk3::Image> displaying I<surface>. The B<Gnome::Gtk3::Image> does not assume a reference to the surface; you still need to unref it if you own references. B<Gnome::Gtk3::Image> will add its own reference rather than adopting yours.

Returns: a new B<Gnome::Gtk3::Image>

  method _gtk_image_new_from_surface ( cairo_surface_t $surface --> N-GObject )

=item cairo_surface_t $surface; a B<cairo-surface-t>, or C<undefined>
=end pod
}}

sub _gtk_image_new_from_surface ( cairo_surface_t $surface --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_image_new_from_surface')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:1:file:
=head3 Filename: file

Filename to load and display
Default value: Any

The B<Gnome::GObject::Value> type of property I<file> is C<G_TYPE_STRING>.

=begin comment
=comment -----------------------------------------------------------------------
=comment #TP:0:gicon:
=head3 Icon: gicon

The GIcon displayed in the GtkImage. For themed icons, If the icon theme is changed, the image will be updated
automatically.

   Widget type: G_TYPE_ICON

The B<Gnome::GObject::Value> type of property I<gicon> is C<G_TYPE_OBJECT>.
=end comment

=comment -----------------------------------------------------------------------
=comment #TP:1:icon-name:
=head3 Icon Name: icon-name

The name of the icon in the icon theme. If the icon theme is changed, the image will be updated automatically.

The B<Gnome::GObject::Value> type of property I<icon-name> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:pixbuf:
=head3 Pixbuf: pixbuf

A GdkPixbuf to display
Widget type: GDK-TYPE-PIXBUF

The B<Gnome::GObject::Value> type of property I<pixbuf> is C<G_TYPE_OBJECT>.

=begin comment
=comment -----------------------------------------------------------------------
=comment #TP:0:pixbuf-animation:
=head3 Animation: pixbuf-animation

GdkPixbufAnimation to display
Widget type: GDK-TYPE-PIXBUF-ANIMATION

The B<Gnome::GObject::Value> type of property I<pixbuf-animation> is C<G_TYPE_OBJECT>.
=end comment

=comment -----------------------------------------------------------------------
=comment #TP:0:resource:
=head3 Resource: resource

A path to a resource file to display.

The B<Gnome::GObject::Value> type of property I<resource> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:storage-type:
=head3 Storage type: storage-type

The representation being used for image data
Default value: False

The B<Gnome::GObject::Value> type of property I<storage-type> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:0:surface:
=head3 Surface: surface

The B<Gnome::GObject::Value> type of property I<surface> is C<G_TYPE_BOXED>.

=comment -----------------------------------------------------------------------
=comment #TP:0:use-fallback:
=head3 Use Fallback: use-fallback

Whether the icon displayed in the GtkImage will use standard icon names fallback. The value of this property is only relevant for images of type C<GTK-IMAGE-ICON-NAME> and C<GTK-IMAGE-GICON>.

The B<Gnome::GObject::Value> type of property I<use-fallback> is C<G_TYPE_BOOLEAN>.
=end pod
