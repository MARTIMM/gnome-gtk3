Gnome::Gtk3::Image
==================

A widget displaying an image

Description
===========

The **Gnome::Gtk3::Image** widget displays an image. Various kinds of object can be displayed as an image; most typically, you would load a **Gnome::Gdk3::Pixbuf** ("pixel buffer") from a file, and then display that. There’s a convenience function to do this, `gtk_image_set_from_file()`, used as follows:

    my Gnome::Gtk3::Image $image .= new;
    $image.set-from-file("myfile.png");

To make it shorter;

    my Gnome::Gtk3::Image $image .= new(:filename<myfile.png>);

If the file isn’t loaded successfully, the image will contain a “broken image” icon similar to that used in many web browsers. If you want to handle errors in loading the file yourself, for example by displaying an error message, then load the image with `gdk_pixbuf_new_from_file()`, then create the **Gnome::Gtk3::Image** with `gtk_image_new_from_pixbuf()`.

The image file may contain an animation, if so the **Gnome::Gtk3::Image** will display an animation (**Gnome::Gdk3::PixbufAnimation**) instead of a static image.

**Gnome::Gtk3::Image** is a “no window” widget (has no **Gnome::Gdk3::Window** of its own), so by default does not receive events. If you want to receive events on the image, such as button clicks, place the image inside a **Gnome::Gtk3::EventBox**, then connect to the event signals on the event box.

Handling button press events on a Gnome::Gtk3::Image.
-----------------------------------------------------

    # Define a button press event handler
    method button-press-handler (
      GdkEventButton $event, Gnome::Gtk3::EventBox :widget($event-box)
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
      $eb.gtk-container-add($image);
      $eb.register-signal( self, button-press-handler, 'button_press_event');

      $image;
    }

When handling events on the event box, keep in mind that coordinates in the image may be different from event box coordinates due to the alignment and padding settings on the image (see **Gnome::Gtk3::Misc**). The simplest way to solve this is to set the alignment to 0.0 (left/top), and set the padding to zero. Then the origin of the image will be the same as the origin of the event box.

A note: **Gnome::Gtk3::Misc** is almost completely deprecated. It exists only to support the inheritance tree below the Misc class. For alignment and padding look for the methods in **Gnome::Gtk3::Widget**.

Css Nodes
---------

**Gnome::Gtk3::Image** has a single CSS node with the name image.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Image;
    also is Gnome::Gtk3::Misc;

Inheriting this class
---------------------

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

Types
=====

enum GtkImageType
-----------------

Describes the image data representation used by a **Gnome::Gtk3::Image**. If you want to get the image from the widget, you can only get the currently-stored representation. e.g. if the `gtk_image_get_storage_type()` returns **GTK_IMAGE_PIXBUF**, then you can call `gtk_image_get_pixbuf()` but not `gtk_image_get_stock()`. For empty images, you can request any storage type (call any of the "get" functions), but they will all return `Any` values.

  * GTK_IMAGE_EMPTY: there is no image displayed by the widget

  * GTK_IMAGE_PIXBUF: the widget contains a **Gnome::Gdk3::Pixbuf**

  * GTK_IMAGE_STOCK: the widget contains a [stock item name][gtkstock]

  * GTK_IMAGE_ICON_SET: the widget contains a **Gnome::Gtk3::IconSet**

  * GTK_IMAGE_ANIMATION: the widget contains a **Gnome::Gdk3::PixbufAnimation**

  * GTK_IMAGE_ICON_NAME: the widget contains a named icon. This image type was added in GTK+ 2.6

  * GTK_IMAGE_GICON: the widget contains a **GIcon**. This image type was added in GTK+ 2.14

  * GTK_IMAGE_SURFACE: the widget contains a **cairo_surface_t**. This image type was added in GTK+ 3.10

Methods
=======

new
---

Create a new plain object without an image.

    multi method new ( )

Creates a new **Gnome::Gtk3::Image** displaying the file *filename*. If the file isn’t found or can’t be loaded, the resulting **Gnome::Gtk3::Image** will display a “broken image” icon.

If the file contains an animation, the image will contain an animation.

If you need to detect failures to load the file, use `gdk_pixbuf_new_from_file()` to load the file yourself, then create the **Gnome::Gtk3::Image** from the pixbuf. (Or for animations, use `gdk_pixbuf_animation_new_from_file()`).

The storage type (`gtk_image_get_storage_type()`) of the returned image is not defined, it will be whatever is appropriate for displaying the file. Create a new object and load an image from file.

    multi method new ( Str :$filename! )

Creates a new **Gnome::Gtk3::Image** displaying the resource file *$resource-path*. If the file isn’t found or can’t be loaded, the resulting **Gnome::Gtk3::Image** will display a “broken image” icon. This function never returns `Any`, it always returns a valid **Gnome::Gtk3::Image** widget.

If the file contains an animation, the image will contain an animation.

If you need to detect failures to load the file, use `gdk_pixbuf_new_from_file()` to load the file yourself, then create the **Gnome::Gtk3::Image** from the pixbuf. (Or for animations, use `gdk_pixbuf_animation_new_from_file()`).

The storage type (`gtk_image_get_storage_type()`) of the returned image is not defined, it will be whatever is appropriate for displaying the file.

    multi method new ( Str :$resource-path! )

Creates a new **Gnome::Gtk3::Image** displaying *$pixbuf*. The **Gnome::Gtk3::Image** does not assume a reference to the pixbuf; you still need to unref it if you own references. **Gnome::Gtk3::Image** will add its own reference rather than adopting yours.

Note that this function just creates an **Gnome::Gtk3::Image** from the pixbuf. The **Gnome::Gtk3::Image** created will not react to state changes. Should you want that, you should use `gtk_image_new_from_icon_name()`.

    multi method new ( Str :$pixbuf! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[[gtk_] image_] new_from_icon_name
----------------------------------

Creates a **Gnome::Gtk3::Image** displaying an icon from the current icon theme. If the icon name isn’t known, a “broken image” icon will be displayed instead. If the current icon theme is changed, the icon will be updated appropriately.

Returns: a new **Gnome::Gtk3::Image** displaying the themed icon

Since: 2.6

    method gtk_image_new_from_icon_name ( Str $icon_name, GtkIconSize $size --> N-GObject  )

  * Str $icon_name; an icon name

  * GtkIconSize $size; (type int): a stock icon size (**Gnome::Gtk3::IconSize**)

[gtk_] image_clear
------------------

Resets the image to be empty.

Since: 2.8

    method gtk_image_clear ( )

[[gtk_] image_] set_from_file
-----------------------------

See `gtk_image_new_from_file()` for details.

    method gtk_image_set_from_file ( Str $filename )

  * Str $filename; (type filename) (allow-none): a filename or `Any`

[[gtk_] image_] set_from_resource
---------------------------------

See `gtk_image_new_from_resource()` for details.

    method gtk_image_set_from_resource ( Str $resource_path )

  * Str $resource_path; (allow-none): a resource path or `Any`

[[gtk_] image_] set_from_pixbuf
-------------------------------

See `gtk_image_new_from_pixbuf()` for details.

    method gtk_image_set_from_pixbuf ( N-GObject $pixbuf )

  * N-GObject $pixbuf; (allow-none): a **Gnome::Gdk3::Pixbuf** or `Any`

[[gtk_] image_] set_from_icon_name
----------------------------------

See `gtk_image_new_from_icon_name()` for details.

Since: 2.6

    method gtk_image_set_from_icon_name ( Str $icon_name, GtkIconSize $size )

  * Str $icon_name; an icon name

  * GtkIconSize $size; (type int): an icon size (**Gnome::Gtk3::IconSize**)

[[gtk_] image_] set_from_gicon
------------------------------

See `gtk_image_new_from_gicon()` for details.

Since: 2.14

    method gtk_image_set_from_gicon ( N-GObject $icon, GtkIconSize $size )

  * N-GObject $icon; an icon

  * GtkIconSize $size; (type int): an icon size (**Gnome::Gtk3::IconSize**)

[[gtk_] image_] set_pixel_size
------------------------------

Sets the pixel size to use for named icons. If the pixel size is set to a value != -1, it is used instead of the icon size set by `gtk_image_set_from_icon_name()`.

Since: 2.6

    method gtk_image_set_pixel_size ( Int $pixel_size )

  * Int $pixel_size; the new pixel size

[[gtk_] image_] get_storage_type
--------------------------------

Gets the type of representation being used by the **Gnome::Gtk3::Image** to store image data. If the **Gnome::Gtk3::Image** has no image data, the return value will be `GTK_IMAGE_EMPTY`.

Returns: image representation being used

    method gtk_image_get_storage_type ( --> GtkImageType  )

[[gtk_] image_] get_pixbuf
--------------------------

Gets the **Gnome::Gdk3::Pixbuf** being displayed by the **Gnome::Gtk3::Image**. The storage type of the image must be `GTK_IMAGE_EMPTY` or `GTK_IMAGE_PIXBUF` (see `gtk_image_get_storage_type()`). The caller of this function does not own a reference to the returned pixbuf.

Returns: (nullable) (transfer none): the displayed pixbuf, or `Any` if the image is empty

    method gtk_image_get_pixbuf ( --> N-GObject  )

[[gtk_] image_] get_gicon
-------------------------

Gets the **GIcon** and size being displayed by the **Gnome::Gtk3::Image**. The storage type of the image must be `GTK_IMAGE_EMPTY` or `GTK_IMAGE_GICON` (see `gtk_image_get_storage_type()`). The caller of this function does not own a reference to the returned **GIcon**.

Since: 2.14

    method gtk_image_get_gicon ( N-GObject $gicon, GtkIconSize $size )

  * N-GObject $gicon; (out) (transfer none) (allow-none): place to store a **GIcon**, or `Any`

  * GtkIconSize $size; (out) (allow-none) (type int): place to store an icon size (**Gnome::Gtk3::IconSize**), or `Any`

[[gtk_] image_] get_pixel_size
------------------------------

Gets the pixel size used for named icons.

Returns: the pixel size used for named icons.

Since: 2.6

    method gtk_image_get_pixel_size ( --> Int  )

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Pixbuf

A **Gnome::Gdk3::Pixbuf** to display Widget type: GDK_TYPE_PIXBUF

The **Gnome::GObject::Value** type of property *pixbuf* is `G_TYPE_OBJECT`.

### Surface

The **Gnome::GObject::Value** type of property *surface* is `G_TYPE_BOXED`.

### Filename

Filename to load and display Default value: Any

The **Gnome::GObject::Value** type of property *file* is `G_TYPE_STRING`.

### Animation

**Gnome::Gdk3::PixbufAnimation** to display Widget type: GDK_TYPE_PIXBUF_ANIMATION

The **Gnome::GObject::Value** type of property *pixbuf-animation* is `G_TYPE_OBJECT`.

### Icon Name

The name of the icon in the icon theme. If the icon theme is changed, the image will be updated automatically. Since: 2.6

The **Gnome::GObject::Value** type of property *icon-name* is `G_TYPE_STRING`.

### Icon

The GIcon displayed in the **Gnome::Gtk3::Image**. For themed icons, If the icon theme is changed, the image will be updated automatically. Since: 2.14 Widget type: G_TYPE_ICON

The **Gnome::GObject::Value** type of property *gicon* is `G_TYPE_OBJECT`.

### Resource

A path to a resource file to display. Since: 3.8

The **Gnome::GObject::Value** type of property *resource* is `G_TYPE_STRING`.

### Storage type

The representation being used for image data Default value: False

The **Gnome::GObject::Value** type of property *storage-type* is `G_TYPE_ENUM`.

### Use Fallback

Whether the icon displayed in the **Gnome::Gtk3::Image** will use standard icon names fallback. The value of this property is only relevant for images of type `GTK_IMAGE_ICON_NAME` and `GTK_IMAGE_GICON`. Since: 3.0

The **Gnome::GObject::Value** type of property *use-fallback* is `G_TYPE_BOOLEAN`.

