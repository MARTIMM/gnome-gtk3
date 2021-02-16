Gnome::Gtk3::ColorChooser
=========================

Interface implemented by widgets for choosing colors

Description
===========

**Gnome::Gtk3::ColorChooser** is an interface that is implemented by widgets for choosing colors. Depending on the situation, colors may be allowed to have alpha (translucency).

In GTK+, the main widgets that implement this interface are **Gnome::Gtk3::ColorChooserWidget**, **Gnome::Gtk3::ColorChooserDialog** and **Gnome::Gtk3::ColorButton**.

See Also
--------

**Gnome::Gtk3::ColorChooserDialog**, **Gnome::Gtk3::ColorChooserWidget**, **Gnome::Gtk3::ColorButton**

Synopsis
========

Declaration
-----------

    unit role Gnome::Gtk3::ColorChooser;

Example
-------

    my Gnome::Gtk3::ColorChooserDialog $ccdialog .= new(
      :title('my color dialog')
    );

    # Use methods defined in the interface
    note "Green channel: ", $ccdialog.get-rgba($color).green;

Methods
=======

add-palette
-----------

Adds a palette to the color chooser. If *$orientation* is horizontal, the colors are grouped in rows, with *$colors_per_line* colors in each row. If *$horizontal* is `0`, the colors are grouped in columns instead.

The default color palette of **Gnome::Gtk3::ColorChooserWidget** has 27 colors, organized in columns of 3 colors. The default gray palette has 9 grays in a single row.

The layout of the color chooser widget works best when the palettes have 9-10 columns.

Calling this function for the first time has the side effect of removing the default color and gray palettes from the color chooser.

If *$colors* is undefined, the method removes all previously added palettes.

    method add-palette (
      GtkOrientation $orientation,
      Int $colors_per_line, Int $n_colors,
      Array $colors
    )

  * GtkOrientation $orientation; `GTK_ORIENTATION_HORIZONTAL` if the palette should be displayed in rows, `GTK_ORIENTATION_VERTICAL` for columns.

  * Int $colors_per_line; the number of colors to show in each row/column.

  * Int $n_colors; the total number of elements in @colors.

  * Array[Num] or Array[N-GdkRGBA] $colors; the colors of the palette, or `Any`.

### An Example

According to the documentation, an array of N-GdkRGBA Structures should be given. Raku however, turns a CArray[N-GdkRGBA] into references to the structure so it becomes an array of pointers. The sub is modified in such a way that either Array[N-GdkRGBA] or Array[Num] can be given. The latter one must always have elems % 4 == 0.

    use NativeCall;
    use Gnome::Gdk3::RGBA;
    use Gnome::Gtk3::ColorChooser;

    my Array $palette = [
      .0e0, .0e0, .0e0, 1e0, # color1: red, green, blue, opacity
      .1e0, .0e0, .0e0, 1e0, # color2: ...
      .2e0, .0e0, .0e0, 1e0,
      .3e0, .0e0, .0e0, 1e0,
      .4e0, .0e0, .0e0, 1e0,
      .5e0, .0e0, .0e0, 1e0,
      .6e0, .0e0, .0e0, 1e0,
      .7e0, .0e0, .0e0, 1e0,
      .8e0, .0e0, .0e0, 1e0,
      .9e0, .0e0, .0e0, 1e0,
      .0e0, .0e0, .0e0, 1e0,
      .0e0, .1e0, .0e0, 1e0,
      .0e0, .2e0, .0e0, 1e0,
      .0e0, .3e0, .0e0, 1e0,
      .0e0, .4e0, .0e0, 1e0,
      .0e0, .5e0, .0e0, 1e0,
      .0e0, .6e0, .0e0, 1e0,
      .0e0, .7e0, .0e0, 1e0,
      .0e0, .8e0, .0e0, 1e0,
      .0e0, .9e0, .0e0, 1e0, # color20: ...
    ];

    my Gnome::Gdk3::RGBA $color .= new(
      :red(1e0), :green(.0e0), :blue(.0e0), :alpha(1e0)
    );

    my Gnome::Gtk3::ColorButton $cb .= new(:$color);
    $cb.add-palette( GTK_ORIENTATION_HORIZONTAL, 10, 20, $palette);

Or it can be done like this

    my Array $palette = [];
    for .0, .1 ... .9 -> Num $rgb-gray {
      $palette.push: N-GdkRGBA.new(
        :red($rgb-gray), :green($rgb-gray), :blue($rgb-gray), :alpha(1e0)
      );
    }

    my N-GdkRGBA $color .= new(
      :red(0e0), :green(.0e0), :blue(.0e0), :alpha(1e0)
    );
    my Gnome::Gtk3::ColorButton $cb .= new(:$color);
    $cb.add-palette( GTK_ORIENTATION_HORIZONTAL, 10, 10, $palette);

get-rgba
--------

Gets the currently-selected color.

    method get-rgba ( --> Gnome::Gdk3::RGBA )

Returns a **Gnome::Gdk3::RGBA** filled in with the current color. **Note; Previously the method returned an N-GdkRGBA native object. Now that a real method is defined, a Raku object is returned.**

get-use-alpha
-------------

Returns whether the color chooser shows the alpha channel.

Returns: `True` if the color chooser uses the alpha channel, `False` if not

    method get-use-alpha ( --> Bool )

set-rgba
--------

Sets the color.

    method set-rgba ( N-GObject $color )

  * N-GObject $color; the new color

set-use-alpha
-------------

Sets whether or not the color chooser should use the alpha channel.

    method set-use-alpha ( Bool $use_alpha )

  * Int $use_alpha; `True` if color chooser should use alpha channel, `False` if not

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `connect-object()` directly from **Gnome::GObject::Signal**.

First method
------------

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes `:$widget` and user data are optional.

    # handler method
    method mouse-event ( GdkEvent $event, :$widget ) { ... }

    # connect a signal on window object
    my Gnome::Gtk3::Window $w .= new( ... );
    $w.register-signal( self, 'mouse-event', 'button-press-event');

Second method
-------------

    my Gnome::Gtk3::Window $w .= new( ... );
    my Callable $handler = sub (
      N-GObject $native, GdkEvent $event, OpaquePointer $data
    ) {
      ...
    }

    $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `connect-object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### color-activated

Emitted when a color is activated from the color chooser. This usually happens when the user clicks a color swatch, or a color is selected and the user presses one of the keys Space, Shift+Space, Return or Enter.

    method handler (
      N-GdkRGBA $color,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($chooser),
      *%user-options
    );

  * $chooser; the object which received the signal

  * $color; the color

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Color: rgba

The *rgba* property contains the currently selected color, as a **Gnome::Gdk3::RGBA** struct. The property can be set to change the current selection programmatically.

    *

The **Gnome::GObject::Value** type of property *rgba* is `G_TYPE_BOXED`.

### Use alpha: use-alpha

When *use-alpha* is `True`, colors may have alpha (translucency) information. When it is `False`, the **Gnome::Gdk3::RGBA** struct obtained via the *rgba* property will be forced to have alpha == 1.

Implementations are expected to show alpha by rendering the color over a non-uniform background (like a checkerboard pattern).

    *

The **Gnome::GObject::Value** type of property *use-alpha* is `G_TYPE_BOOLEAN`.

