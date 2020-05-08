Gnome::Gtk3::ProgressBar
========================

A widget which indicates progress visually

![](images/progressbar.png)

Description
===========

The **Gnome::Gtk3::ProgressBar** is typically used to display the progress of a long running operation. It provides a visual clue that processing is underway. The **Gnome::Gtk3::ProgressBar** can be used in two different modes: percentage mode and activity mode.

When an application can determine how much work needs to take place (e.g. read a fixed number of bytes from a file) and can monitor its progress, it can use the **Gnome::Gtk3::ProgressBar** in percentage mode and the user sees a growing bar indicating the percentage of the work that has been completed. In this mode, the application is required to call `gtk_progress_bar_set_fraction()` periodically to update the progress bar.

When an application has no accurate way of knowing the amount of work to do, it can use the **Gnome::Gtk3::ProgressBar** in activity mode, which shows activity by a block moving back and forth within the progress area. In this mode, the application is required to call `gtk_progress_bar_pulse()` periodically to update the progress bar.

There is quite a bit of flexibility provided to control the appearance of the **Gnome::Gtk3::ProgressBar**. Functions are provided to control the orientation of the bar, optional text can be displayed along with the bar, and the step size used in activity mode can be set.

Css Nodes
---------

    progressbar[.osd]
    ├── [text]
    ╰── trough[.empty][.full]
        ╰── progress[.pulse]

**Gnome::Gtk3::ProgressBar** has a main CSS node with name progressbar and subnodes with names text and trough, of which the latter has a subnode named progress. The text subnode is only present if text is shown. The progress subnode has the style class .pulse when in activity mode. It gets the style classes .left, .right, .top or .bottom added when the progress 'touches' the corresponding end of the **Gnome::Gtk3::ProgressBar**. The .osd class on the progressbar node is for use in overlays like the one Epiphany has for page loading progress.

Implemented Interfaces
----------------------

Gnome::Gtk3::ProgressBar implements

  * [Gnome::Gtk3::Orientable](Orientable.html)

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ProgressBar;
    also is Gnome::Gtk3::Widget;
    also does Gnome::Gtk3::Orientable;

Methods
=======

new
---

Create a new default object.

    multi method new ( )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_progress_bar_new
--------------------

Creates a new **Gnome::Gtk3::ProgressBar**.

Returns: a **Gnome::Gtk3::ProgressBar**.

    method gtk_progress_bar_new ( --> N-GObject )

gtk_progress_bar_pulse
----------------------

Indicates that some progress has been made, but you don’t know how much. Causes the progress bar to enter “activity mode,” where a block bounces back and forth. Each call to `gtk_progress_bar_pulse()` causes the block to move by a little bit (the amount of movement per pulse is determined by `gtk_progress_bar_set_pulse_step()`).

    method gtk_progress_bar_pulse ( )

[gtk_progress_bar_] set_text
----------------------------

Causes the given *text* to appear next to the progress bar.

If *text* is `Any` and *show-text* is `1`, the current value of *fraction* will be displayed as a percentage.

If *text* is non-`Any` and *show-text* is `1`, the text will be displayed. In this case, it will not display the progress percentage. If *text* is the empty string, the progress bar will still be styled and sized suitably for containing text, as long as *show-text* is `1`.

    method gtk_progress_bar_set_text ( Str $text )

  * Str $text; (allow-none): a UTF-8 string, or `Any`

[gtk_progress_bar_] set_fraction
--------------------------------

Causes the progress bar to “fill in” the given fraction of the bar. The fraction should be between 0.0 and 1.0, inclusive.

    method gtk_progress_bar_set_fraction ( Num $fraction )

  * Num $fraction; fraction of the task that’s been completed

[gtk_progress_bar_] set_pulse_step
----------------------------------

Sets the fraction of total progress bar length to move the bouncing block for each call to `gtk_progress_bar_pulse()`.

    method gtk_progress_bar_set_pulse_step ( Num $fraction )

  * Num $fraction; fraction between 0.0 and 1.0

[gtk_progress_bar_] set_inverted
--------------------------------

Progress bars normally grow from top to bottom or left to right. Inverted progress bars grow in the opposite direction.

    method gtk_progress_bar_set_inverted ( Int $inverted )

  * Int $inverted; `1` to invert the progress bar

[gtk_progress_bar_] get_text
----------------------------

Retrieves the text that is displayed with the progress bar, if any, otherwise `Any`. The return value is a reference to the text, not a copy of it, so will become invalid if you change the text in the progress bar.

Returns: (nullable): text, or `Any`; this string is owned by the widget and should not be modified or freed.

    method gtk_progress_bar_get_text ( --> Str )

[gtk_progress_bar_] get_fraction
--------------------------------

Returns the current fraction of the task that’s been completed.

Returns: a fraction from 0.0 to 1.0

    method gtk_progress_bar_get_fraction ( --> Num )

[gtk_progress_bar_] get_pulse_step
----------------------------------

Retrieves the pulse step set with `gtk_progress_bar_set_pulse_step()`.

Returns: a fraction from 0.0 to 1.0

    method gtk_progress_bar_get_pulse_step ( --> Num )

[gtk_progress_bar_] get_inverted
--------------------------------

Gets the value set by `gtk_progress_bar_set_inverted()`.

Returns: `1` if the progress bar is inverted

    method gtk_progress_bar_get_inverted ( --> Int )

[gtk_progress_bar_] set_ellipsize
---------------------------------

Sets the mode used to ellipsize (add an ellipsis: "...") the text if there is not enough space to render the entire string.

Since: 2.6

    method gtk_progress_bar_set_ellipsize ( PangoEllipsizeMode $mode )

  * PangoEllipsizeMode $mode; a **PangoEllipsizeMode**

[gtk_progress_bar_] get_ellipsize
---------------------------------

Returns the ellipsizing position of the progress bar. See `gtk_progress_bar_set_ellipsize()`.

Returns: **PangoEllipsizeMode**

Since: 2.6

    method gtk_progress_bar_get_ellipsize ( --> PangoEllipsizeMode )

[gtk_progress_bar_] set_show_text
---------------------------------

Sets whether the progress bar will show text next to the bar. The shown text is either the value of the *text* property or, if that is `Any`, the *fraction* value, as a percentage.

To make a progress bar that is styled and sized suitably for containing text (even if the actual text is blank), set *show-text* to `1` and *text* to the empty string (not `Any`).

Since: 3.0

    method gtk_progress_bar_set_show_text ( Int $show_text )

  * Int $show_text; whether to show text

[gtk_progress_bar_] get_show_text
---------------------------------

Gets the value of the *show-text* property. See `gtk_progress_bar_set_show_text()`.

Returns: `1` if text is shown in the progress bar

Since: 3.0

    method gtk_progress_bar_get_show_text ( --> Int )

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Inverted

Invert the direction in which the progress bar grows Default value: False

The **Gnome::GObject::Value** type of property *inverted* is `G_TYPE_BOOLEAN`.

### Fraction

The fraction of total work that has been completed.

The **Gnome::GObject::Value** type of property *fraction* is `G_TYPE_DOUBLE`.

### Pulse Step

The fraction of total progress to move the bouncing block when pulsed.

The **Gnome::GObject::Value** type of property *pulse-step* is `G_TYPE_DOUBLE`.

### Text

Text to be displayed in the progress bar Default value: Any

The **Gnome::GObject::Value** type of property *text* is `G_TYPE_STRING`.

### Show text

Sets whether the progress bar will show a text in addition to the bar itself. The shown text is either the value of the *text* property or, if that is `Any`, the *fraction* value, as a percentage. To make a progress bar that is styled and sized suitably for showing text (even if the actual text is blank), set *show-text* to `1` and *text* to the empty string (not `Any`).

Since: 3.0

The **Gnome::GObject::Value** type of property *show-text* is `G_TYPE_BOOLEAN`.

### Ellipsize

The preferred place to ellipsize the string, if the progress bar does not have enough room to display the entire string, specified as a **PangoEllipsizeMode**. Note that setting this property to a value other than `PANGO_ELLIPSIZE_NONE` has the side-effect that the progress bar requests only enough space to display the ellipsis ("..."). Another means to set a progress bar's width is `gtk_widget_set_size_request()`.

Since: 2.6 Widget type: PANGO_TYPE_ELLIPSIZE_MODE

The **Gnome::GObject::Value** type of property *ellipsize* is `G_TYPE_ENUM`.

