Gnome::Gtk3::Scale
==================

A slider widget for selecting a value from a range

![](images/scales.png)

Description
===========

A **Gnome::Gtk3::Scale** is a slider control used to select a numeric value. To use it, you’ll probably want to investigate the methods on its base class, **Gnome::Gtk3::Range**, in addition to the methods for **Gnome::Gtk3::Scale** itself. To set the value of a scale, you would normally use `gtk_range_set_value()`. To detect changes to the value, you would normally use the *value-changed* signal.

Note that using the same upper and lower bounds for the **Gnome::Gtk3::Scale** (through the **Gnome::Gtk3::Range** methods) will hide the slider itself. This is useful for applications that want to show an undeterminate value on the scale, without changing the layout of the application (such as movie or music players).

**Gnome::Gtk3::Scale** as **Gnome::Gtk3::Buildable**
----------------------------------------------------

**Gnome::Gtk3::Scale** supports a custom <marks> element, which can contain multiple `mark` elements. The “value” and “position” attributes have the same meaning as `gtk_scale_add_mark()` parameters of the same name. If the element is not empty, its content is taken as the markup to show at the mark. It can be translated with the usual ”translatable” and “context” attributes.

Css Nodes
---------

    scale[.fine-tune][.marks-before][.marks-after]
    ├── marks.top
    │   ├── mark
    │   ┊    ├── [label]
    │   ┊    ╰── indicator
    ┊   ┊
    │   ╰── mark
    ├── [value]
    ├── contents
    │   ╰── trough
    │       ├── slider
    │       ├── [highlight]
    │       ╰── [fill]
    ╰── marks.bottom
        ├── mark
        ┊    ├── indicator
        ┊    ╰── [label]
        ╰── mark

**Gnome::Gtk3::Scale** has a main CSS node with name scale and a subnode for its contents, with subnodes named trough and slider.

The main node gets the style class .fine-tune added when the scale is in 'fine-tuning' mode.

If the scale has an origin (see `gtk_scale_set_has_origin()`), there is a subnode with name highlight below the trough node that is used for rendering the highlighted part of the trough.

If the scale is showing a fill level (see `gtk_range_set_show_fill_level()`), there is a subnode with name fill below the trough node that is used for rendering the filled in part of the trough.

If marks are present, there is a marks subnode before or after the contents node, below which each mark gets a node with name mark. The marks nodes get either the .top or .bottom style class.

The mark node has a subnode named indicator. If the mark has text, it also has a subnode named label. When the mark is either above or left of the scale, the label subnode is the first when present. Otherwise, the indicator subnode is the first.

The main CSS node gets the 'marks-before' and/or 'marks-after' style classes added depending on what marks are present.

If the scale is displaying the value (see *draw-value*), there is subnode with name value.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Scale;
    also is Gnome::Gtk3::Range;

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::Scale;

    unit class MyGuiClass;
    also is Gnome::Gtk3::Scale;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::Scale class process the options
      self.bless( :GtkScale, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Example
-------

    my Gnome::Gtk3::Scale $scale .= new;

    # Set min and max of scale.
    $scale.set-range( -2e0, .2e2);

    # Step (keys left/right) and page (mouse scroll on scale).
    $scale.set-increments( .2e0, 5e0);

    # Value of current position displayed below the scale
    $scale.set-value-pos(GTK_POS_BOTTOM);

    # Want to have two digits after the commma
    $scale.set-digits(2);

    # Want to have some scale ticks also below the scale
    $scale.add-mark( 0e0, GTK_POS_BOTTOM, 'Zero');
    $scale.add-mark( 5e0, GTK_POS_BOTTOM, 'Five');
    $scale.add-mark( 10e0, GTK_POS_BOTTOM, 'Ten');
    $scale.add-mark( 15e0, GTK_POS_BOTTOM, 'Fifteen');
    $scale.add-mark( 20e0, GTK_POS_BOTTOM, 'Twenty');

Methods
=======

new
---

Creates a new **Gnome::Gtk3::Scale** based on ahorizontal orientation and an undefined adjustment. See below.

    multi method new ( )

Creates a new **Gnome::Gtk3::Scale** based on an orientation and adjustment.

    multi method new ( GtkOrientation :$orientation!, N-GObject :$adjustment! )

  * $orientation; the scale’s orientation.

  * $adjustment; a value of type **Gnome::Gtk3::Adjustment** which sets the range of the scale, or NULL to create a new adjustment.

Creates a new scale widget with the given orientation that lets the user input a number between *$min* and *$max* (including *$min* and *$max*) with the increment *step*. *step* must be nonzero; it’s the distance the slider moves when using the arrow keys to adjust the scale value.

Note that the way in which the precision is derived works best if *$step* is a power of ten. If the resulting precision is not suitable for your needs, use `gtk_scale_set_digits()` to correct it.

    multi method new (
      GtkOrientation :$orientation!, Num $min!, Num $max!, Num $step!
    )

  * $orientation; the scale’s orientation. Value is a GtkOrientation enum from GtkEnums.

  * $min; minimum value

  * $max; maximum value

  * $step; step increment (tick size) used with keyboard shortcuts

    multi method new ( :$native-object! )

Create an object using a native object from elsewhere. See also Gnome::GObject::Object.

    multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also Gnome::GObject::Object.

[[gtk_] scale_] set_digits
--------------------------

Sets the number of decimal places that are displayed in the value. Also causes the value of the adjustment to be rounded off to this number of digits, so the retrieved value matches the value the user saw.

Note that rounding to a small number of digits can interfere with the smooth autoscrolling that is built into **Gnome::Gtk3::Scale**. As an alternative, you can use the *format-value* signal to format the displayed value yourself.

    method gtk_scale_set_digits ( Int $digits )

  * Int $digits; the number of decimal places to display, e.g. use 1 to display 1.0, 2 to display 1.00, etc

[[gtk_] scale_] get_digits
--------------------------

Gets the number of decimal places that are displayed in the value.

Returns: the number of decimal places that are displayed

    method gtk_scale_get_digits ( --> Int  )

[[gtk_] scale_] set_draw_value
------------------------------

Specifies whether the current value is displayed as a string next to the slider.

    method gtk_scale_set_draw_value ( Int $draw_value )

  * Int $draw_value; `1` to draw the value

[[gtk_] scale_] get_draw_value
------------------------------

Returns whether the current value is displayed as a string next to the slider.

Returns: whether the current value is displayed as a string

    method gtk_scale_get_draw_value ( --> Int  )

[[gtk_] scale_] set_has_origin
------------------------------

If *has_origin* is set to `1` (the default), the scale will highlight the part of the scale between the origin (bottom or left side) of the scale and the current value.

    method gtk_scale_set_has_origin ( Int $has_origin )

  * Int $has_origin; `1` if the scale has an origin

[[gtk_] scale_] get_has_origin
------------------------------

Returns whether the scale has an origin.

Returns: `1` if the scale has an origin.

    method gtk_scale_get_has_origin ( --> Int  )

[[gtk_] scale_] set_value_pos
-----------------------------

Sets the position in which the current value is displayed.

    method gtk_scale_set_value_pos ( GtkPositionType $pos )

  * GtkPositionType $pos; the position in which the current value is displayed

[[gtk_] scale_] get_value_pos
-----------------------------

Gets the position in which the current value is displayed.

Returns: the position in which the current value is displayed

    method gtk_scale_get_value_pos ( --> GtkPositionType  )

[[gtk_] scale_] add_mark
------------------------

Adds a mark at *value*.

A mark is indicated visually by drawing a tick mark next to the scale, and GTK+ makes it easy for the user to position the scale exactly at the marks value.

If *markup* is not `Any`, text is shown next to the tick mark.

To remove marks from a scale, use `gtk_scale_clear_marks()`.

    method gtk_scale_add_mark ( Num $value, GtkPositionType $position, Str $markup )

  * Num $value; the value at which the mark is placed, must be between the lower and upper limits of the scales’ adjustment

  * GtkPositionType $position; where to draw the mark. For a horizontal scale, **GTK_POS_TOP** and `GTK_POS_LEFT` are drawn above the scale, anything else below. For a vertical scale, **GTK_POS_LEFT** and `GTK_POS_TOP` are drawn to the left of the scale, anything else to the right.

  * Str $markup; (allow-none): Text to be shown at the mark, using [Pango markup][PangoMarkupFormat], or `Any`

[[gtk_] scale_] clear_marks
---------------------------

Removes any marks that have been added with `gtk_scale_add_mark()`.

    method gtk_scale_clear_marks ( )

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `g_signal_connect_object()` directly from **Gnome::GObject::Signal**.

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

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `g_signal_connect_object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### format-value

Signal which allows you to change how the scale value is displayed. Connect a signal handler which returns an allocated string representing *$value*. That string will then be used to display the scale's value.

Here's an example signal handler which displays a value 1.0 as with "-->1.0<--".

    method format-value-callback (
      num64 $value, Gnome::Gtk3::Scale :widget($scale)
      --> Str
    ) {
      $value.fmt('-->%.1f<--')
    }

Returns: allocated string representing *$value*

    method handler (
      num64 $value,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($scale),
      *%user-options
      --> Str
    );

  * $scale; the object which received the signal

  * $value; the value to format

