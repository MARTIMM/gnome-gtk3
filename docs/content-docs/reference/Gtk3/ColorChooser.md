Gnome::Gtk3::ColorChooser
=========================

Interface implemented by widgets for choosing colors

Description
===========

**Gnome::Gtk3::ColorChooser** is an interface that is implemented by widgets for choosing colors. Depending on the situation, colors may be allowed to have alpha (translucency).

In GTK+, the main widgets that implement this interface are **Gnome::Gtk3::ColorChooserWidget**, **Gnome::Gtk3::ColorChooserDialog** and **Gnome::Gtk3::ColorButton**.

Since: 3.4

Known implementations
---------------------

Gnome::Gtk3::ColorChooser is implemented by

  * [Gnome::Gtk3::ColorButton](ColorButton.html)

  * [Gnome::Gtk3::ColorChooserDialog](ColorChooserDialog.html)

  * [Gnome::Gtk3::ColorChooserWidget](ColorChooserWidget.html)

See Also
--------

**Gnome::Gtk3::ColorChooserDialog**, **Gnome::Gtk3::ColorChooserWidget**, **Gnome::Gtk3::ColorButton**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ColorChooser;
    also is Gnome::GObject::Interface;

Example
-------

    my Gnome::Gtk3::ColorChooserDialog $ccdialog .= new(
      :title('my color dialog')
    );

    # Use methods defined in the interface
    note "Green channel: ", $ccdialog.get-rgba($color).green;

Methods
=======

new
---

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

[gtk_color_chooser_] get_rgba
-----------------------------

Gets the currently-selected color.

Since: 3.4

    method gtk_color_chooser_get_rgba ( GdkRGBA $color )

  * GdkRGBA $color: a *GdkRGBA* structure to fill in with the current color

[gtk_color_chooser_] set_rgba
-----------------------------

Sets the color.

Since: 3.4

    method gtk_color_chooser_set_rgba ( N-GObject $color )

  * GdkRGBA $color: the new color

[gtk_color_chooser_] get_use_alpha
----------------------------------

Check whether the color chooser shows the alpha channel.

Returns: `1` if the color chooser uses the alpha channel, `0` if not.

Since: 3.4

    method gtk_color_chooser_get_use_alpha ( --> Int )

[gtk_color_chooser_] set_use_alpha
----------------------------------

Sets whether or not the color chooser should use the alpha channel.

Since: 3.4

    method gtk_color_chooser_set_use_alpha ( Int $use_alpha)

  * Int $use_alpha: `1` if color chooser should use alpha channel, `0` if not

[gtk_color_chooser_] add_palette
--------------------------------

Adds a palette to the color chooser. If *$orientation* is horizontal, the colors are grouped in rows, with *$colors_per_line* colors in each row. If *$horizontal* is `0`, the colors are grouped in columns instead.

The default color palette of **Gnome::Gtk3::ColorChooserWidget** has 27 colors, organized in columns of 3 colors. The default gray palette has 9 grays in a single row.

The layout of the color chooser widget works best when the palettes have 9-10 columns.

Calling this function for the first time has the side effect of removing the default color and gray palettes from the color chooser.

If *$colors* is undefined, the method removes all previously added palettes.

Since: 3.4

    method gtk_color_chooser_add_palette (
      GtkOrientation $orientation,
      Int $colors_per_line, Int $n_colors,
      CArray $colors
    )

  * GtkOrientation $orientation; `GTK_ORIENTATION_HORIZONTAL` if the palette should be displayed in rows, `GTK_ORIENTATION_VERTICAL` for columns.

  * Int $colors_per_line; the number of colors to show in each row/column.

  * Int $n_colors; the total number of elements in @colors.

  * CArray[num64] $colors; (allow-none) (array length=n_colors): the colors of the palette, or `Any`.

### An Example

According to the documentation, an array of GdkRGBA Structures should be given. Perl6 however, turns a CArray[GdkRGBA] into references to the structure so it becomes an array of pointers. The sub is modified in such a way that either CArray[GdkRGBA] or CArray[num64] can be given. The latter one must always have elems % 4 == 0.

    use NativeCall;
    use Gnome::Gdk3::RGBA;
    use Gnome::Gtk3::ColorChooser;

    my $palette = CArray[num64].new(
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
      .0e0, .9e0, .0e0, 1e0, color20: ...
    );

    my GdkRGBA $color .= new( :red(1e0), :green(.0e0), :blue(.0e0), :alpha(1e0));
    my Gnome::Gtk3::ColorButton $cb .= new(:$color);
    my Gnome::Gtk3::ColorChooser $cc .= new(:widget($cb));
    $cc.add-palette( GTK_ORIENTATION_HORIZONTAL, 10, 20, $palette);

Or it can be done like this

    my $palette = CArray[GdkRGBA].new;
    my Int $index = 0;
    for .0, .1 ... .9 -> Num $rgb-gray {
      $palette[$index++] = GdkRGBA.new(
        :red($rgb-gray), :green($rgb-gray), :blue($rgb-gray), :alpha(1e0)
      );
    }

    my GdkRGBA $color .= new(
      :red(1e0), :green(.0e0), :blue(.0e0), :alpha(1e0)
    );
    my Gnome::Gtk3::ColorButton $cb .= new(:$color);
    my Gnome::Gtk3::ColorChooser $cc .= new(:widget($cb));
    $cc.add-palette( GTK_ORIENTATION_HORIZONTAL, 10, 10, $palette);

Signals
=======

Register any signal as follows. See also **Gnome::GObject::Object**.

    my Bool $is-registered = $my-widget.register-signal (
      $handler-object, $handler-name, $signal-name,
      :$user-option1, ..., $user-optionN
    )

Not yet supported signals
-------------------------

### color-activated:

Emitted when a color is activated from the color chooser. This usually happens when the user clicks a color swatch, or a color is selected and the user presses one of the keys Space, Shift+Space, Return or Enter.

Since: 3.4

    method handler (
      Gnome::GObject::Object :widget($chooser),
      :handler-arg0($color),
      :$user-option1, ..., :$user-optionN
    );

  * $chooser; the object which received the signal

  * $color; the color

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### use-alpha

When prop *use-alpha* is `1`, colors may have alpha (translucency) information. When it is `0`, the **Gnome::Gdk3::RGBA** struct obtained via the prop *rgba* property will be forced to have alpha == 1.

Implementations are expected to show alpha by rendering the color over a non-uniform background (like a checkerboard pattern).

Since: 3.4

The **Gnome::GObject::Value** type of property *use-alpha* is `G_TYPE_BOOLEAN`.

