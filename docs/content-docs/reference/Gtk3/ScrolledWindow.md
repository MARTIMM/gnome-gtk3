Gnome::Gtk3::ScrolledWindow
===========================

Adds scrollbars to its child widget

![](images/scrolledwindow.png)

Description
===========

**Gnome::Gtk3::ScrolledWindow** is a container that accepts a single child widget, makes that child scrollable using either internally added scrollbars or externally associated adjustments, and optionally draws a frame around the child.

Widgets with native scrolling support, i.e. those whose classes implement the **Gnome::Gtk3::Scrollable** interface, are added directly. For other types of widget, the class **Gnome::Gtk3::Viewport** acts as an adaptor, giving scrollability to other widgets. **Gnome::Gtk3::ScrolledWindow**’s implementation of `gtk_container_add()` intelligently accounts for whether or not the added child is a **Gnome::Gtk3::Scrollable**. If it isn’t, **Gnome::Gtk3::ScrolledWindow** wraps the child in a **Gnome::Gtk3::Viewport** and adds that for you. Therefore, you can just add any child widget and not worry about the details.

If `gtk_container_add()` has added a **Gnome::Gtk3::Viewport** for you, you can remove both your added child widget from the **Gnome::Gtk3::Viewport**, and the **Gnome::Gtk3::Viewport** from the **Gnome::Gtk3::ScrolledWindow**, like this:

Unless *policy* is GTK_POLICY_NEVER or GTK_POLICY_EXTERNAL, **Gnome::Gtk3::ScrolledWindow** adds internal **Gnome::Gtk3::Scrollbar** widgets around its child. The scroll position of the child, and if applicable the scrollbars, is controlled by the *hadjustment* and *vadjustment* that are associated with the **Gnome::Gtk3::ScrolledWindow**. See the docs on **Gnome::Gtk3::Scrollbar** for the details, but note that the “step_increment” and “page_increment” fields are only effective if the policy causes scrollbars to be present.

If a **Gnome::Gtk3::ScrolledWindow** doesn’t behave quite as you would like, or doesn’t have exactly the right layout, it’s very possible to set up your own scrolling with **Gnome::Gtk3::Scrollbar** and for example a **Gnome::Gtk3::Grid**.

Touch support
-------------

**Gnome::Gtk3::ScrolledWindow** has built-in support for touch devices. When a touchscreen is used, swiping will move the scrolled window, and will expose 'kinetic' behavior. This can be turned off with the *kinetic-scrolling* property if it is undesired.

**Gnome::Gtk3::ScrolledWindow** also displays visual 'overshoot' indication when the content is pulled beyond the end, and this situation can be captured with the *edge-overshot* signal.

If no mouse device is present, the scrollbars will overlayed as narrow, auto-hiding indicators over the content. If traditional scrollbars are desired although no mouse is present, this behaviour can be turned off with the *overlay-scrolling* property.

Css Nodes
---------

**Gnome::Gtk3::ScrolledWindow** has a main CSS node with name scrolledwindow. It uses subnodes with names overshoot and undershoot to draw the overflow and underflow indications. These nodes get the .left, .right, .top or .bottom style class added depending on where the indication is drawn.

**Gnome::Gtk3::ScrolledWindow** also sets the positional style classes (.left, .right, .top, .bottom) and style classes related to overlay scrolling (.overlay-indicator, .dragging, .hovering) on its scrollbars.

If both scrollbars are visible, the area where they meet is drawn with a subnode named junction.

See Also
--------

**Gnome::Gtk3::Scrollable**, **Gnome::Gtk3::Viewport**, **Gnome::Gtk3::Adjustment**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::ScrolledWindow;
    also is Gnome::Gtk3::Bin;

Types
=====

enum GtkCornerType
------------------

Specifies which corner a child widget should be placed in when packed into a **Gnome::Gtk3::ScrolledWindow**. This is effectively the opposite of where the scroll bars are placed.

  * GTK_CORNER_TOP_LEFT: Place the scrollbars on the right and bottom of the widget (default behaviour).

  * GTK_CORNER_BOTTOM_LEFT: Place the scrollbars on the top and right of the widget.

  * GTK_CORNER_TOP_RIGHT: Place the scrollbars on the left and bottom of the widget.

  * GTK_CORNER_BOTTOM_RIGHT: Place the scrollbars on the top and left of the widget.

enum GtkPolicyType
------------------

Determines how the size should be computed to achieve the one of the visibility mode for the scrollbars.

  * GTK_POLICY_ALWAYS: The scrollbar is always visible. The view size is independent of the content.

  * GTK_POLICY_AUTOMATIC: The scrollbar will appear and disappear as necessary. For example, when all of a **Gnome::Gtk3::TreeView** can not be seen.

  * GTK_POLICY_NEVER: The scrollbar should never appear. In this mode the content determines the size.

  * GTK_POLICY_EXTERNAL: Don't show a scrollbar, but don't force the size to follow the content. This can be used e.g. to make multiple scrolled windows share a scrollbar. Since: 3.16

Methods
=======

new
---

Create a new ScrolledWindow object.

    multi method new ( )

Create a ScrolledWindow object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

Create a ScrolledWindow object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_scrolled_window_] set_hadjustment
--------------------------------------

Sets the **Gnome::Gtk3::Adjustment** for the horizontal scrollbar. You cannot cleanup the adjustment object afterwards because the scrolled window keeps a reference to it.

    method gtk_scrolled_window_set_hadjustment ( N-GObject $hadjustment )

  * N-GObject $hadjustment; (nullable): the **Gnome::Gtk3::Adjustment** to use, or `Any` to create a new one

[gtk_scrolled_window_] set_vadjustment
--------------------------------------

Sets the **Gnome::Gtk3::Adjustment** for the vertical scrollbar. You cannot cleanup the adjustment object afterwards because the scrolled window keeps a reference to it.

    method gtk_scrolled_window_set_vadjustment ( N-GObject $vadjustment )

  * N-GObject $vadjustment; (nullable): the **Gnome::Gtk3::Adjustment** to use, or `Any` to create a new one.

[gtk_scrolled_window_] get_hadjustment
--------------------------------------

Returns the horizontal scrollbar’s adjustment, used to connect the horizontal scrollbar to the child widget’s horizontal scroll functionality.

Returns: (transfer none): the horizontal **Gnome::Gtk3::Adjustment**

    method gtk_scrolled_window_get_hadjustment ( --> N-GObject )

[gtk_scrolled_window_] get_vadjustment
--------------------------------------

Returns the vertical scrollbar’s adjustment, used to connect the vertical scrollbar to the child widget’s vertical scroll functionality.

Returns: (transfer none): the vertical **Gnome::Gtk3::Adjustment**

    method gtk_scrolled_window_get_vadjustment ( --> N-GObject )

[gtk_scrolled_window_] get_hscrollbar
-------------------------------------

Returns the horizontal scrollbar of *scrolled_window*.

Returns: (transfer none): the horizontal scrollbar of the scrolled window.

    method gtk_scrolled_window_get_hscrollbar ( --> N-GObject )

[gtk_scrolled_window_] get_vscrollbar
-------------------------------------

Returns the vertical scrollbar of *scrolled_window*.

Returns: (transfer none): the vertical scrollbar of the scrolled window.

    method gtk_scrolled_window_get_vscrollbar ( --> N-GObject )

[gtk_scrolled_window_] set_policy
---------------------------------

Sets the scrollbar policy for the horizontal and vertical scrollbars.

The policy determines when the scrollbar should appear; it is a value from the **Gnome::Gtk3::PolicyType** enumeration. If `GTK_POLICY_ALWAYS`, the scrollbar is always present; if `GTK_POLICY_NEVER`, the scrollbar is never present; if `GTK_POLICY_AUTOMATIC`, the scrollbar is present only if needed (that is, if the slider part of the bar would be smaller than the trough — the display is larger than the page size).

    method gtk_scrolled_window_set_policy ( GtkPolicyType $hscrollbar_policy, GtkPolicyType $vscrollbar_policy )

  * GtkPolicyType $hscrollbar_policy; policy for horizontal bar

  * GtkPolicyType $vscrollbar_policy; policy for vertical bar

[gtk_scrolled_window_] get_policy
---------------------------------

Retrieves the current policy values for the horizontal and vertical scrollbars. See `gtk_scrolled_window_set_policy()`.

    method gtk_scrolled_window_get_policy ( GtkPolicyType $hscrollbar_policy, GtkPolicyType $vscrollbar_policy )

  * GtkPolicyType $hscrollbar_policy; (out) (optional): location to store the policy for the horizontal scrollbar, or `Any`

  * GtkPolicyType $vscrollbar_policy; (out) (optional): location to store the policy for the vertical scrollbar, or `Any`

[gtk_scrolled_window_] set_placement
------------------------------------

Sets the placement of the contents with respect to the scrollbars for the scrolled window.

The default is `GTK_CORNER_TOP_LEFT`, meaning the child is in the top left, with the scrollbars underneath and to the right. Other values in **Gnome::Gtk3::CornerType** are `GTK_CORNER_TOP_RIGHT`, `GTK_CORNER_BOTTOM_LEFT`, and `GTK_CORNER_BOTTOM_RIGHT`.

See also `gtk_scrolled_window_get_placement()` and `gtk_scrolled_window_unset_placement()`.

    method gtk_scrolled_window_set_placement ( GtkCornerType $window_placement )

  * GtkCornerType $window_placement; position of the child window

[gtk_scrolled_window_] unset_placement
--------------------------------------

Unsets the placement of the contents with respect to the scrollbars for the scrolled window. If no window placement is set for a scrolled window, it defaults to `GTK_CORNER_TOP_LEFT`.

See also `gtk_scrolled_window_set_placement()` and `gtk_scrolled_window_get_placement()`.

    method gtk_scrolled_window_unset_placement ( )

[gtk_scrolled_window_] get_placement
------------------------------------

Gets the placement of the contents with respect to the scrollbars for the scrolled window. See `gtk_scrolled_window_set_placement()`.

Returns: the current placement value.

See also `gtk_scrolled_window_set_placement()` and `gtk_scrolled_window_unset_placement()`.

    method gtk_scrolled_window_get_placement ( --> GtkCornerType )

[gtk_scrolled_window_] set_shadow_type
--------------------------------------

Changes the type of shadow drawn around the contents of *scrolled_window*.

    method gtk_scrolled_window_set_shadow_type ( GtkShadowType $type )

  * GtkShadowType $type; kind of shadow to draw around scrolled window contents

[gtk_scrolled_window_] get_shadow_type
--------------------------------------

Gets the shadow type of the scrolled window. See `gtk_scrolled_window_set_shadow_type()`.

Returns: the current shadow type

    method gtk_scrolled_window_get_shadow_type ( --> GtkShadowType )

[gtk_scrolled_window_] get_min_content_width
--------------------------------------------

Gets the minimum content width of *scrolled_window*, or -1 if not set.

Returns: the minimum content width

    method gtk_scrolled_window_get_min_content_width ( --> Int )

[gtk_scrolled_window_] set_min_content_width
--------------------------------------------

Sets the minimum width that *scrolled_window* should keep visible. Note that this can and (usually will) be smaller than the minimum size of the content.

It is a programming error to set the minimum content width to a value greater than *max-content-width*.

    method gtk_scrolled_window_set_min_content_width ( Int $width )

  * Int $width; the minimal content width

[gtk_scrolled_window_] get_min_content_height
---------------------------------------------

Gets the minimal content height of *scrolled_window*, or -1 if not set.

Returns: the minimal content height

    method gtk_scrolled_window_get_min_content_height ( --> Int )

[gtk_scrolled_window_] set_min_content_height
---------------------------------------------

Sets the minimum height that *scrolled_window* should keep visible. Note that this can and (usually will) be smaller than the minimum size of the content.

It is a programming error to set the minimum content height to a value greater than *max-content-height*.

    method gtk_scrolled_window_set_min_content_height ( Int $height )

  * Int $height; the minimal content height

[gtk_scrolled_window_] set_kinetic_scrolling
--------------------------------------------

Turns kinetic scrolling on or off. Kinetic scrolling only applies to devices with source `GDK_SOURCE_TOUCHSCREEN`.

    method gtk_scrolled_window_set_kinetic_scrolling ( Int $kinetic_scrolling )

  * Int $kinetic_scrolling; `1` to enable kinetic scrolling

[gtk_scrolled_window_] get_kinetic_scrolling
--------------------------------------------

Returns the specified kinetic scrolling behavior.

Returns: the scrolling behavior flags.

    method gtk_scrolled_window_get_kinetic_scrolling ( --> Int )

[gtk_scrolled_window_] set_capture_button_press
-----------------------------------------------

Changes the behaviour of *scrolled_window* with regard to the initial event that possibly starts kinetic scrolling. When *capture_button_press* is set to `1`, the event is captured by the scrolled window, and then later replayed if it is meant to go to the child widget.

This should be enabled if any child widgets perform non-reversible actions on *button-press-event*. If they don't, and handle additionally handle *grab-broken-event*, it might be better to set *capture_button_press* to `0`.

This setting only has an effect if kinetic scrolling is enabled.

    method gtk_scrolled_window_set_capture_button_press ( Int $capture_button_press )

  * Int $capture_button_press; `1` to capture button presses

[gtk_scrolled_window_] get_capture_button_press
-----------------------------------------------

Return whether button presses are captured during kinetic scrolling. See `gtk_scrolled_window_set_capture_button_press()`.

Returns: `1` if button presses are captured during kinetic scrolling

    method gtk_scrolled_window_get_capture_button_press ( --> Int )

[gtk_scrolled_window_] set_overlay_scrolling
--------------------------------------------

Enables or disables overlay scrolling for this scrolled window.

    method gtk_scrolled_window_set_overlay_scrolling ( Int $overlay_scrolling )

  * Int $overlay_scrolling; whether to enable overlay scrolling

[gtk_scrolled_window_] get_overlay_scrolling
--------------------------------------------

Returns whether overlay scrolling is enabled for this scrolled window.

Returns: `1` if overlay scrolling is enabled

    method gtk_scrolled_window_get_overlay_scrolling ( --> Int )

[gtk_scrolled_window_] set_max_content_width
--------------------------------------------

Sets the maximum width that *scrolled_window* should keep visible. The *scrolled_window* will grow up to this width before it starts scrolling the content.

It is a programming error to set the maximum content width to a value smaller than *min-content-width*.

    method gtk_scrolled_window_set_max_content_width ( Int $width )

  * Int $width; the maximum content width

[gtk_scrolled_window_] get_max_content_width
--------------------------------------------

Returns the maximum content width set.

Returns: the maximum content width, or -1

    method gtk_scrolled_window_get_max_content_width ( --> Int )

[gtk_scrolled_window_] set_max_content_height
---------------------------------------------

Sets the maximum height that *scrolled_window* should keep visible. The *scrolled_window* will grow up to this height before it starts scrolling the content.

It is a programming error to set the maximum content height to a value smaller than *min-content-height*.

    method gtk_scrolled_window_set_max_content_height ( Int $height )

  * Int $height; the maximum content height

[gtk_scrolled_window_] get_max_content_height
---------------------------------------------

Returns the maximum content height set.

Returns: the maximum content height, or -1

    method gtk_scrolled_window_get_max_content_height ( --> Int )

[gtk_scrolled_window_] set_propagate_natural_width
--------------------------------------------------

Sets whether the natural width of the child should be calculated and propagated through the scrolled window’s requested natural width.

    method gtk_scrolled_window_set_propagate_natural_width ( Int $propagate )

  * Int $propagate; whether to propagate natural width

[gtk_scrolled_window_] get_propagate_natural_width
--------------------------------------------------

Reports whether the natural width of the child will be calculated and propagated through the scrolled window’s requested natural width.

Returns: whether natural width propagation is enabled.

    method gtk_scrolled_window_get_propagate_natural_width ( --> Int )

[gtk_scrolled_window_] set_propagate_natural_height
---------------------------------------------------

Sets whether the natural height of the child should be calculated and propagated through the scrolled window’s requested natural height.

    method gtk_scrolled_window_set_propagate_natural_height ( Int $propagate )

  * Int $propagate; whether to propagate natural height

[gtk_scrolled_window_] get_propagate_natural_height
---------------------------------------------------

Reports whether the natural height of the child will be calculated and propagated through the scrolled window’s requested natural height.

Returns: whether natural height propagation is enabled.

    method gtk_scrolled_window_get_propagate_natural_height ( --> Int )

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

### scroll-child

The *scroll-child* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted when a keybinding that scrolls is pressed. The horizontal or vertical adjustment is updated which triggers a signal that the scrolled window’s child may listen to and scroll itself.

    method handler (
      Unknown type GTK_TYPE_SCROLL_TYPE $scroll,
      Int $horizontal,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($scrolled_window),
      *%user-options
      --> Int
    );

  * $scrolled_window; a **Gnome::Gtk3::ScrolledWindow**

  * $scroll; a **Gnome::Gtk3::ScrollType** describing how much to scroll

  * $horizontal; whether the keybinding scrolls the child horizontally or not

### move-focus-out

The *move-focus-out* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted when focus is moved away from the scrolled window by a keybinding. The *move-focus* signal is emitted with *direction_type* on this scrolled window’s toplevel parent in the container hierarchy. The default bindings for this signal are `Ctrl + Tab` to move forward and `Ctrl + Shift + Tab` to move backward.

    method handler (
      Unknown type GTK_TYPE_DIRECTION_TYPE $direction_type,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($scrolled_window),
      *%user-options
    );

  * $scrolled_window; a **Gnome::Gtk3::ScrolledWindow**

  * $direction_type; either `GTK_DIR_TAB_FORWARD` or `GTK_DIR_TAB_BACKWARD`

### edge-overshot

The *edge-overshot* signal is emitted whenever user initiated scrolling makes the scrolled window firmly surpass (i.e. with some edge resistance) the lower or upper limits defined by the adjustment in that orientation.

A similar behavior without edge resistance is provided by the *edge-reached* signal.

Note: The *pos* argument is LTR/RTL aware, so callers should be aware too if intending to provide behavior on horizontal edges.

    method handler (
      Unknown type GTK_TYPE_POSITION_TYPE $pos,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($scrolled_window),
      *%user-options
    );

  * $scrolled_window; a **Gnome::Gtk3::ScrolledWindow**

  * $pos; edge side that was hit

### edge-reached

The *edge-reached* signal is emitted whenever user-initiated scrolling makes the scrolled window exactly reach the lower or upper limits defined by the adjustment in that orientation.

A similar behavior with edge resistance is provided by the *edge-overshot* signal.

Note: The *pos* argument is LTR/RTL aware, so callers should be aware too if intending to provide behavior on horizontal edges.

    method handler (
      Unknown type GTK_TYPE_POSITION_TYPE $pos,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($scrolled_window),
      *%user-options
    );

  * $scrolled_window; a **Gnome::Gtk3::ScrolledWindow**

  * $pos; edge side that was reached

