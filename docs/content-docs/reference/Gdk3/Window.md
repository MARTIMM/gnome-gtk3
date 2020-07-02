Gnome::Gdk3::Window
===================

Onscreen display areas in the target window system

Description
===========

A **Gnome::Gdk3::Window** is a (usually) rectangular region on the screen. It’s a low-level object, used to implement high-level objects such as **Gnome::Gtk3::Widget** and **Gnome::Gtk3::Window** on the GTK+ level. A **Gnome::Gtk3::Window** is a toplevel window, the thing a user might think of as a “window” with a titlebar and so on; a **Gnome::Gtk3::Window** may contain many **Gnome::Gdk3::Windows**. For example, each **Gnome::Gtk3::Button** has a **Gnome::Gdk3::Window** associated with it.

Composited Windows # {**COMPOSITED**-WINDOWS}
---------------------------------------------

Normally, the windowing system takes care of rendering the contents of a child window onto its parent window. This mechanism can be intercepted by calling `gdk_window_set_composited()` on the child window. For a “composited” window it is the responsibility of the application to render the window contents at the right spot.

Offscreen Windows # {**OFFSCREEN**-WINDOWS}
-------------------------------------------

Offscreen windows are more general than composited windows, since they allow not only to modify the rendering of the child window onto its parent, but also to apply coordinate transformations.

To integrate an offscreen window into a window hierarchy, one has to call `gdk_offscreen_window_set_embedder()` and handle a number of signals. The *pick-embedded-child* signal on the embedder window is used to select an offscreen child at given coordinates, and the *to-embedder* and *from-embedder* signals on the offscreen window are used to translate coordinates between the embedder and the offscreen window.

For rendering an offscreen window onto its embedder, the contents of the offscreen window are available as a surface, via `gdk_offscreen_window_get_surface()`.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gdk3::Window;
    also is Gnome::GObject::Object;

Types
=====

enum GdkWindowWindowClass
-------------------------

*GDK_INPUT_OUTPUT* windows are the standard kind of window you might expect. Such windows receive events and are also displayed on screen. *GDK_INPUT_ONLY* windows are invisible; they are usually placed above other windows in order to trap or filter the events. You can’t draw on *GDK_INPUT_ONLY* windows.

  * GDK_INPUT_OUTPUT: window for graphics and events

  * GDK_INPUT_ONLY: window for events only

enum GdkWindowType
------------------

Describes the kind of window.

  * GDK_WINDOW_ROOT: root window; this window has no parent, covers the entire screen, and is created by the window system

  * GDK_WINDOW_TOPLEVEL: toplevel window (used to implement `Gnome::Gtk3::Window`)

  * GDK_WINDOW_CHILD: child window (used to implement e.g. `Gnome::Gtk3::Entry`)

  * GDK_WINDOW_TEMP: override redirect temporary window (used to implement `Gnome::Gtk3::Menu`)

  * GDK_WINDOW_FOREIGN: foreign window (see `gdk_window_foreign_new()`)

  * GDK_WINDOW_OFFSCREEN: offscreen window (see [Offscreen Windows][OFFSCREEN-WINDOWS]). Since 2.18

  * GDK_WINDOW_SUBSURFACE: subsurface-based window; This window is visually tied to a toplevel, and is moved/stacked with it. Currently this window type is only implemented in Wayland. Since 3.14

enum GdkWindowAttributesType
----------------------------

Used to indicate which fields in the `Gnome::Gdk3::WindowAttr` struct should be honored. For example, if you filled in the “cursor” and “x” fields of `Gnome::Gdk3::WindowAttr`, pass “*GDK_WA_X* \| *GDK_WA_CURSOR*” to `gdk_window_new()`. Fields in `Gnome::Gdk3::WindowAttr` not covered by a bit in this enum are required; for example, the *width*/*height*, *wclass*, and *window_type* fields are required, they have no corresponding flag in `Gnome::Gdk3::WindowAttributesType`.

  * GDK_WA_TITLE: Honor the title field

  * GDK_WA_X: Honor the X coordinate field

  * GDK_WA_Y: Honor the Y coordinate field

  * GDK_WA_CURSOR: Honor the cursor field

  * GDK_WA_VISUAL: Honor the visual field

  * GDK_WA_WMCLASS: Honor the wmclass_class and wmclass_name fields

  * GDK_WA_NOREDIR: Honor the override_redirect field

  * GDK_WA_TYPE_HINT: Honor the type_hint field

enum GdkWindowHints
-------------------

Used to indicate which fields of a `Gnome::Gdk3::Geometry` struct should be paid attention to. Also, the presence/absence of *GDK_HINT_POS*, *GDK_HINT_USER_POS*, and *GDK_HINT_USER_SIZE* is significant, though they don't directly refer to `Gnome::Gdk3::Geometry` fields. *GDK_HINT_USER_POS* will be set automatically by `Gnome::Gtk3::Window` if you call `gtk_window_move()`. *GDK_HINT_USER_POS* and *GDK_HINT_USER_SIZE* should be set if the user specified a size/position using a --geometry command-line argument; `gtk_window_parse_geometry()` automatically sets these flags.

  * GDK_HINT_POS: indicates that the program has positioned the window

  * GDK_HINT_MIN_SIZE: min size fields are set

  * GDK_HINT_MAX_SIZE: max size fields are set

  * GDK_HINT_BASE_SIZE: base size fields are set

  * GDK_HINT_ASPECT: aspect ratio fields are set

  * GDK_HINT_RESIZE_INC: resize increment fields are set

  * GDK_HINT_WIN_GRAVITY: window gravity field is set

  * GDK_HINT_USER_POS: indicates that the window’s position was explicitly set by the user

  * GDK_HINT_USER_SIZE: indicates that the window’s size was explicitly set by the user

enum GdkWMDecoration
--------------------

These are hints originally defined by the Motif toolkit. The window manager can use them when determining how to decorate the window. The hint must be set before mapping the window.

  * GDK_DECOR_ALL: all decorations should be applied.

  * GDK_DECOR_BORDER: a frame should be drawn around the window.

  * GDK_DECOR_RESIZEH: the frame should have resize handles.

  * GDK_DECOR_TITLE: a titlebar should be placed above the window.

  * GDK_DECOR_MENU: a button for opening a menu should be included.

  * GDK_DECOR_MINIMIZE: a minimize button should be included.

  * GDK_DECOR_MAXIMIZE: a maximize button should be included.

enum GdkWMFunction
------------------

These are hints originally defined by the Motif toolkit. The window manager can use them when determining the functions to offer for the window. The hint must be set before mapping the window.

  * GDK_FUNC_ALL: all functions should be offered.

  * GDK_FUNC_RESIZE: the window should be resizable.

  * GDK_FUNC_MOVE: the window should be movable.

  * GDK_FUNC_MINIMIZE: the window should be minimizable.

  * GDK_FUNC_MAXIMIZE: the window should be maximizable.

  * GDK_FUNC_CLOSE: the window should be closable.

enum GdkGravity
---------------

Defines the reference point of a window and the meaning of coordinates passed to `gtk_window_move()`. See `gtk_window_move()` and the "implementation notes" section of the [Extended Window Manager Hints](http://www.freedesktop.org/Standards/wm-spec) specification for more details.

  * GDK_GRAVITY_NORTH_WEST: the reference point is at the top left corner.

  * GDK_GRAVITY_NORTH: the reference point is in the middle of the top edge.

  * GDK_GRAVITY_NORTH_EAST: the reference point is at the top right corner.

  * GDK_GRAVITY_WEST: the reference point is at the middle of the left edge.

  * GDK_GRAVITY_CENTER: the reference point is at the center of the window.

  * GDK_GRAVITY_EAST: the reference point is at the middle of the right edge.

  * GDK_GRAVITY_SOUTH_WEST: the reference point is at the lower left corner.

  * GDK_GRAVITY_SOUTH: the reference point is at the middle of the lower edge.

  * GDK_GRAVITY_SOUTH_EAST: the reference point is at the lower right corner.

  * GDK_GRAVITY_STATIC: the reference point is at the top left corner of the window itself, ignoring window manager decorations.

enum GdkAnchorHints
-------------------

Positioning hints for aligning a window relative to a rectangle.

These hints determine how the window should be positioned in the case that the window would fall off-screen if placed in its ideal position.

For example, `GDK_ANCHOR_FLIP_X` will replace `GDK_GRAVITY_NORTH_WEST` with `GDK_GRAVITY_NORTH_EAST` and vice versa if the window extends beyond the left or right edges of the monitor.

If `GDK_ANCHOR_SLIDE_X` is set, the window can be shifted horizontally to fit on-screen. If `GDK_ANCHOR_RESIZE_X` is set, the window can be shrunken horizontally to fit.

In general, when multiple flags are set, flipping should take precedence over sliding, which should take precedence over resizing.

Stability: Unstable

  * GDK_ANCHOR_FLIP_X: allow flipping anchors horizontally

  * GDK_ANCHOR_FLIP_Y: allow flipping anchors vertically

  * GDK_ANCHOR_SLIDE_X: allow sliding window horizontally

  * GDK_ANCHOR_SLIDE_Y: allow sliding window vertically

  * GDK_ANCHOR_RESIZE_X: allow resizing window horizontally

  * GDK_ANCHOR_RESIZE_Y: allow resizing window vertically

  * GDK_ANCHOR_FLIP: allow flipping anchors on both axes

  * GDK_ANCHOR_SLIDE: allow sliding window on both axes

  * GDK_ANCHOR_RESIZE: allow resizing window on both axes

enum GdkWindowEdge
------------------

Determines a window edge or corner.

  * GDK_WINDOW_EDGE_NORTH_WEST: the top left corner.

  * GDK_WINDOW_EDGE_NORTH: the top edge.

  * GDK_WINDOW_EDGE_NORTH_EAST: the top right corner.

  * GDK_WINDOW_EDGE_WEST: the left edge.

  * GDK_WINDOW_EDGE_EAST: the right edge.

  * GDK_WINDOW_EDGE_SOUTH_WEST: the lower left corner.

  * GDK_WINDOW_EDGE_SOUTH: the lower edge.

  * GDK_WINDOW_EDGE_SOUTH_EAST: the lower right corner.

enum GdkFullscreenMode
----------------------

Indicates which monitor (in a multi-head setup) a window should span over when in fullscreen mode.

  * GDK_FULLSCREEN_ON_CURRENT_MONITOR: Fullscreen on current monitor only.

  * GDK_FULLSCREEN_ON_ALL_MONITORS: Span across all monitors when fullscreen.

class GdkWindowAttr
-------------------

Attributes to use for a newly-created window.

  * Str $.title: title of the window (for toplevel windows)

  * Int $.event_mask: event mask (see `gdk_window_set_events()`)

  * Int $.x: X coordinate relative to parent window (see `gdk_window_move()`)

  * Int $.y: Y coordinate relative to parent window (see `gdk_window_move()`)

  * Int $.width: width of window

  * Int $.height: height of window

  * enum `WindowWindowClass` $.wclass: `GDK_INPUT_OUTPUT` (normal window) or `GDK_INPUT_ONLY` (invisible window that receives events)

  * N-GObject $.visual: `Gnome::Gdk3::Visual` for window

  * enum `GdkWindowType` $.window_type: type of window

  * N-GObject $.cursor: cursor for the window (see `gdk_window_set_cursor()`)

  * Str $.wmclass_name: don’t use (see `gtk_window_set_wmclass()`)

  * Str $.wmclass_class: don’t use (see `gtk_window_set_wmclass()`)

  * Int $.override_redirect: `1` to bypass the window manager

  * `Gnome::Gdk3::WindowTypeHint` $.type_hint: a hint of the function of the window

class GdkGeometry
-----------------

The `Gnome::Gdk3::Geometry` struct gives the window manager information about a window’s geometry constraints. Normally you would set these on the GTK+ level using `gtk_window_set_geometry_hints()`. `Gnome::Gtk3::Window` then sets the hints on the `Gnome::Gdk3::Window` it creates.

`gdk_window_set_geometry_hints()` expects the hints to be fully valid already and simply passes them to the window manager; in contrast, `gtk_window_set_geometry_hints()` performs some interpretation. For example, `Gnome::Gtk3::Window` will apply the hints to the geometry widget instead of the toplevel window, if you set a geometry widget. Also, the *min_width*/*min_height*/*max_width*/*max_height* fields may be set to -1, and `Gnome::Gtk3::Window` will substitute the size request of the window or geometry widget. If the minimum size hint is not provided, `Gnome::Gtk3::Window` will use its requisition as the minimum size. If the minimum size is provided and a geometry widget is set, `Gnome::Gtk3::Window` will take the minimum size as the minimum size of the geometry widget rather than the entire window. The base size is treated similarly.

The canonical use-case for `gtk_window_set_geometry_hints()` is to get a terminal widget to resize properly. Here, the terminal text area should be the geometry widget; `Gnome::Gtk3::Window` will then automatically set the base size to the size of other widgets in the terminal window, such as the menubar and scrollbar. Then, the *width_inc* and *height_inc* fields should be set to the size of one character in the terminal. Finally, the base size should be set to the size of one character. The net effect is that the minimum size of the terminal will have a 1x1 character terminal area, and only terminal sizes on the “character grid” will be allowed.

Here’s an example of how the terminal example would be implemented, assuming a terminal area widget called “terminal” and a toplevel window “toplevel”:

|[<!-- language="C" --> `Gnome::Gdk3::Geometry` hints;

hints.base_width = terminal->char_width; hints.base_height = terminal->char_height; hints.min_width = terminal->char_width; hints.min_height = terminal->char_height; hints.width_inc = terminal->char_width; hints.height_inc = terminal->char_height;

gtk_window_set_geometry_hints (GTK_WINDOW (toplevel), GTK_WIDGET (terminal), &hints, GDK_HINT_RESIZE_INC | GDK_HINT_MIN_SIZE | GDK_HINT_BASE_SIZE); ]|

The other useful fields are the *min_aspect* and *max_aspect* fields; these contain a width/height ratio as a floating point number. If a geometry widget is set, the aspect applies to the geometry widget rather than the entire window. The most common use of these hints is probably to set *min_aspect* and *max_aspect* to the same value, thus forcing the window to keep a constant aspect ratio.

  * Int $.min_width: minimum width of window (or -1 to use requisition, with `Gnome::Gtk3::Window` only)

  * Int $.min_height: minimum height of window (or -1 to use requisition, with `Gnome::Gtk3::Window` only)

  * Int $.max_width: maximum width of window (or -1 to use requisition, with `Gnome::Gtk3::Window` only)

  * Int $.max_height: maximum height of window (or -1 to use requisition, with `Gnome::Gtk3::Window` only)

  * Int $.base_width: allowed window widths are *base_width* + *width_inc* * N where N is any integer (-1 allowed with `Gnome::Gtk3::Window`)

  * Int $.base_height: allowed window widths are *base_height* + *height_inc* * N where N is any integer (-1 allowed with `Gnome::Gtk3::Window`)

  * Int $.width_inc: width resize increment

  * Int $.height_inc: height resize increment

  * Num $.min_aspect: minimum width/height ratio

  * Num $.max_aspect: maximum width/height ratio

  * enum `GdkGravity` $.win_gravity: window gravity, see `gtk_window_set_gravity()`

Methods
=======

new
---

gdk_window_destroy
------------------

Internal function to destroy a window. Like `gdk_window_destroy()`, but does not drop the reference count created by `gdk_window_new()`.

    method gdk_window_destroy ( )

[[gdk_] window_] get_window_type
--------------------------------

Gets the type of the window. See **Gnome::Gdk3::WindowType**.

Returns: type of window

    method gdk_window_get_window_type ( --> GdkWindowType  )

[[gdk_] window_] is_destroyed
-----------------------------

Check to see if a window is destroyed..

Returns: `1` if the window is destroyed

    method gdk_window_is_destroyed ( --> Int  )

[[gdk_] window_] get_visual
---------------------------

Gets the **Gnome::Gdk3::Visual** describing the pixel format of *window*.

    method gdk_window_get_visual ( --> N-GObject  )

[[gdk_] window_] get_screen
---------------------------

Gets the **Gnome::Gdk3::Screen** associated with a **Gnome::Gdk3::Window**.

    method gdk_window_get_screen ( --> N-GObject  )

[[gdk_] window_] get_display
----------------------------

Gets the **Gnome::Gdk3::Display** associated with a **Gnome::Gdk3::Window**.

Returns: (transfer none): the **Gnome::Gdk3::Display** associated with *window*

    method gdk_window_get_display ( --> N-GObject  )

gdk_window_show
---------------

Like `gdk_window_show_unraised()`, but also raises the window to the top of the window stack (moves the window to the front of the Z-order).

This function maps a window so it’s visible onscreen. Its opposite is `gdk_window_hide()`.

When implementing a **Gnome::Gtk3::Widget**, you should call this function on the widget's **Gnome::Gdk3::Window** as part of the “map” method.

    method gdk_window_show ( )

gdk_window_hide
---------------

For toplevel windows, withdraws them, so they will no longer be known to the window manager; for all windows, unmaps them, so they won’t be displayed. Normally done automatically as part of `gtk_widget_hide()`.

    method gdk_window_hide ( )

gdk_window_withdraw
-------------------

Withdraws a window (unmaps it and asks the window manager to forget about it). This function is not really useful as `gdk_window_hide()` automatically withdraws toplevel windows before hiding them.

    method gdk_window_withdraw ( )

[[gdk_] window_] show_unraised
------------------------------

Shows a **Gnome::Gdk3::Window** onscreen, but does not modify its stacking order. In contrast, `gdk_window_show()` will raise the window to the top of the window stack.

On the X11 platform, in Xlib terms, this function calls `XMapWindow()` (it also updates some internal GDK state, which means that you can’t really use `XMapWindow()` directly on a GDK window).

    method gdk_window_show_unraised ( )

gdk_window_move
---------------

Repositions a window relative to its parent window. For toplevel windows, window managers may ignore or modify the move; you should probably use `gtk_window_move()` on a **Gnome::Gtk3::Window** widget anyway, instead of using GDK functions. For child windows, the move will reliably succeed.

If you’re also planning to resize the window, use `gdk_window_move_resize()` to both move and resize simultaneously, for a nicer visual effect.

    method gdk_window_move ( Int $x, Int $y )

  * Int $x; X coordinate relative to window’s parent

  * Int $y; Y coordinate relative to window’s parent

gdk_window_resize
-----------------

Resizes *window*; for toplevel windows, asks the window manager to resize the window. The window manager may not allow the resize. When using GTK+, use `gtk_window_resize()` instead of this low-level GDK function.

Windows may not be resized below 1x1.

If you’re also planning to move the window, use `gdk_window_move_resize()` to both move and resize simultaneously, for a nicer visual effect.

    method gdk_window_resize ( Int $width, Int $height )

  * Int $width; new width of the window

  * Int $height; new height of the window

[[gdk_] window_] move_resize
----------------------------

Equivalent to calling `gdk_window_move()` and `gdk_window_resize()`, except that both operations are performed at once, avoiding strange visual effects. (i.e. the user may be able to see the window first move, then resize, if you don’t use `gdk_window_move_resize()`.)

    method gdk_window_move_resize ( Int $x, Int $y, Int $width, Int $height )

  * Int $x; new X position relative to window’s parent

  * Int $y; new Y position relative to window’s parent

  * Int $width; new width

  * Int $height; new height

[[gdk_] window_] move_to_rect
-----------------------------

Moves *window* to *rect*, aligning their anchor points.

*rect* is relative to the top-left corner of the window that *window* is transient for. *rect_anchor* and *window_anchor* determine anchor points on *rect* and *window* to pin together. *rect*'s anchor point can optionally be offset by *rect_anchor_dx* and *rect_anchor_dy*, which is equivalent to offsetting the position of *window*.

*anchor_hints* determines how *window* will be moved if the anchor points cause it to move off-screen. For example, `GDK_ANCHOR_FLIP_X` will replace `GDK_GRAVITY_NORTH_WEST` with `GDK_GRAVITY_NORTH_EAST` and vice versa if *window* extends beyond the left or right edges of the monitor.

Connect to the *moved-to-rect* signal to find out how it was actually positioned.

Stability: Private

    method gdk_window_move_to_rect ( N-GObject $rect, GdkGravity $rect_anchor, GdkGravity $window_anchor, GdkAnchorHints $anchor_hints, Int $rect_anchor_dx, Int $rect_anchor_dy )

  * N-GObject $rect; (not nullable): the destination **Gnome::Gdk3::Rectangle** to align *window* with

  * GdkGravity $rect_anchor; the point on *rect* to align with *window*'s anchor point

  * GdkGravity $window_anchor; the point on *window* to align with *rect*'s anchor point

  * GdkAnchorHints $anchor_hints; positioning hints to use when limited on space

  * Int $rect_anchor_dx; horizontal offset to shift *window*, i.e. *rect*'s anchor point

  * Int $rect_anchor_dy; vertical offset to shift *window*, i.e. *rect*'s anchor point

gdk_window_reparent
-------------------

Reparents *window* into the given *new_parent*. The window being reparented will be unmapped as a side effect.

    method gdk_window_reparent ( N-GObject $new_parent, Int $x, Int $y )

  * N-GObject $new_parent; new parent to move *window* into

  * Int $x; X location inside the new parent

  * Int $y; Y location inside the new parent

gdk_window_raise
----------------

Raises *window* to the top of the Z-order (stacking order), so that other windows with the same parent window appear below *window*. This is true whether or not the windows are visible.

If *window* is a toplevel, the window manager may choose to deny the request to move the window in the Z-order, `gdk_window_raise()` only requests the restack, does not guarantee it.

    method gdk_window_raise ( )

gdk_window_lower
----------------

Lowers *window* to the bottom of the Z-order (stacking order), so that other windows with the same parent window appear above *window*. This is true whether or not the other windows are visible.

If *window* is a toplevel, the window manager may choose to deny the request to move the window in the Z-order, `gdk_window_lower()` only requests the restack, does not guarantee it.

Note that `gdk_window_show()` raises the window again, so don’t call this function before `gdk_window_show()`. (Try `gdk_window_show_unraised()`.)

    method gdk_window_lower ( )

gdk_window_restack
------------------

Changes the position of *window* in the Z-order (stacking order), so that it is above *sibling* (if *above* is `1`) or below *sibling* (if *above* is `0`).

If *sibling* is `Any`, then this either raises (if *above* is `1`) or lowers the window.

If *window* is a toplevel, the window manager may choose to deny the request to move the window in the Z-order, `gdk_window_restack()` only requests the restack, does not guarantee it.

    method gdk_window_restack ( N-GObject $sibling, Int $above )

  * N-GObject $sibling; (allow-none): a **Gnome::Gdk3::Window** that is a sibling of *window*, or `Any`

  * Int $above; a boolean

gdk_window_focus
----------------

Sets keyboard focus to *window*. In most cases, `gtk_window_present()` should be used on a **Gnome::Gtk3::Window**, rather than calling this function.

    method gdk_window_focus ( UInt $timestamp )

  * UInt $timestamp; timestamp of the event triggering the window focus

[[gdk_] window_] set_user_data
------------------------------

For most purposes this function is deprecated in favor of `g_object_set_data()`. However, for historical reasons GTK+ stores the **Gnome::Gtk3::Widget** that owns a **Gnome::Gdk3::Window** as user data on the **Gnome::Gdk3::Window**. So, custom widget implementations should use this function for that. If GTK+ receives an event for a **Gnome::Gdk3::Window**, and the user data for the window is non-`Any`, GTK+ will assume the user data is a **Gnome::Gtk3::Widget**, and forward the event to that widget.

    method gdk_window_set_user_data ( Pointer $user_data )

  * Pointer $user_data; (allow-none) (type GObject.Object): user data

[[gdk_] window_] set_override_redirect
--------------------------------------

An override redirect window is not under the control of the window manager. This means it won’t have a titlebar, won’t be minimizable, etc. - it will be entirely under the control of the application. The window manager can’t see the override redirect window at all.

Override redirect should only be used for short-lived temporary windows, such as popup menus. **Gnome::Gtk3::Menu** uses an override redirect window in its implementation, for example.

    method gdk_window_set_override_redirect ( Int $override_redirect )

  * Int $override_redirect; `1` if window should be override redirect

[[gdk_] window_] get_accept_focus
---------------------------------

Determines whether or not the desktop environment shuld be hinted that the window does not want to receive input focus.

Returns: whether or not the window should receive input focus.

    method gdk_window_get_accept_focus ( --> Int  )

[[gdk_] window_] set_accept_focus
---------------------------------

Setting *accept_focus* to `0` hints the desktop environment that the window doesn’t want to receive input focus.

On X, it is the responsibility of the window manager to interpret this hint. ICCCM-compliant window manager usually respect it.

    method gdk_window_set_accept_focus ( Int $accept_focus )

  * Int $accept_focus; `1` if the window should receive input focus

[[gdk_] window_] get_focus_on_map
---------------------------------

Determines whether or not the desktop environment should be hinted that the window does not want to receive input focus when it is mapped.

Returns: whether or not the window wants to receive input focus when it is mapped.

    method gdk_window_get_focus_on_map ( --> Int  )

[[gdk_] window_] set_focus_on_map
---------------------------------

Setting *focus_on_map* to `0` hints the desktop environment that the window doesn’t want to receive input focus when it is mapped. focus_on_map should be turned off for windows that aren’t triggered interactively (such as popups from network activity).

On X, it is the responsibility of the window manager to interpret this hint. Window managers following the freedesktop.org window manager extension specification should respect it.

    method gdk_window_set_focus_on_map ( Int $focus_on_map )

  * Int $focus_on_map; `1` if the window should receive input focus when mapped

gdk_window_scroll
-----------------

Scroll the contents of *window*, both pixels and children, by the given amount. *window* itself does not move. Portions of the window that the scroll operation brings in from offscreen areas are invalidated. The invalidated region may be bigger than what would strictly be necessary.

For X11, a minimum area will be invalidated if the window has no subwindows, or if the edges of the window’s parent do not extend beyond the edges of the window. In other cases, a multi-step process is used to scroll the window which may produce temporary visual artifacts and unnecessary invalidations.

    method gdk_window_scroll ( Int $dx, Int $dy )

  * Int $dx; Amount to scroll in the X direction

  * Int $dy; Amount to scroll in the Y direction

[[gdk_] window_] ensure_native
------------------------------

Tries to ensure that there is a window-system native window for this **Gnome::Gdk3::Window**. This may fail in some situations, returning `0`.

Offscreen window and children of them can never have native windows.

Some backends may not support native child windows.

Returns: `1` if the window has a native window, `0` otherwise

    method gdk_window_ensure_native ( --> Int  )

[[gdk_] window_] set_child_shapes
---------------------------------

Sets the shape mask of *window* to the union of shape masks for all children of *window*, ignoring the shape mask of *window* itself. Contrast with `gdk_window_merge_child_shapes()` which includes the shape mask of *window* in the masks to be merged.

    method gdk_window_set_child_shapes ( )

[[gdk_] window_] merge_child_shapes
-----------------------------------

Merges the shape masks for any child windows into the shape mask for *window*. i.e. the union of all masks for *window* and its children will become the new mask for *window*. See `gdk_window_shape_combine_region()`.

This function is distinct from `gdk_window_set_child_shapes()` because it includes *window*’s shape mask in the set of shapes to be merged.

    method gdk_window_merge_child_shapes ( )

[[gdk_] window_] set_child_input_shapes
---------------------------------------

Sets the input shape mask of *window* to the union of input shape masks for all children of *window*, ignoring the input shape mask of *window* itself. Contrast with `gdk_window_merge_child_input_shapes()` which includes the input shape mask of *window* in the masks to be merged.

    method gdk_window_set_child_input_shapes ( )

[[gdk_] window_] merge_child_input_shapes
-----------------------------------------

Merges the input shape masks for any child windows into the input shape mask for *window*. i.e. the union of all input masks for *window* and its children will become the new input mask for *window*. See `gdk_window_input_shape_combine_region()`.

This function is distinct from `gdk_window_set_child_input_shapes()` because it includes *window*’s input shape mask in the set of shapes to be merged.

    method gdk_window_merge_child_input_shapes ( )

[[gdk_] window_] set_pass_through
---------------------------------

Sets whether input to the window is passed through to the window below.

The default value of this is `0`, which means that pointer events that happen inside the window are send first to the window, but if the event is not selected by the event mask then the event is sent to the parent window, and so on up the hierarchy.

If *pass_through* is `1` then such pointer events happen as if the window wasn't there at all, and thus will be sent first to any windows below *window*. This is useful if the window is used in a transparent fashion. In the terminology of the web this would be called "pointer-events: none".

Note that a window with *pass_through* `1` can still have a subwindow without pass through, so you can get events on a subset of a window. And in that cases you would get the in-between related events such as the pointer enter/leave events on its way to the destination window.

    method gdk_window_set_pass_through ( Int $pass_through )

  * Int $pass_through; a boolean

[[gdk_] window_] get_pass_through
---------------------------------

Returns whether input to the window is passed through to the window below.

See `gdk_window_set_pass_through()` for details

    method gdk_window_get_pass_through ( --> Int  )

[[gdk_] window_] is_visible
---------------------------

Checks whether the window has been mapped (with `gdk_window_show()` or `gdk_window_show_unraised()`).

Returns: `1` if the window is mapped

    method gdk_window_is_visible ( --> Int  )

[[gdk_] window_] is_viewable
----------------------------

Check if the window and all ancestors of the window are mapped. (This is not necessarily "viewable" in the X sense, since we only check as far as we have GDK window parents, not to the root window.)

Returns: `1` if the window is viewable

    method gdk_window_is_viewable ( --> Int  )

[[gdk_] window_] is_input_only
------------------------------

Determines whether or not the window is an input only window.

Returns: `1` if *window* is input only

    method gdk_window_is_input_only ( --> Int  )

[[gdk_] window_] is_shaped
--------------------------

Determines whether or not the window is shaped.

Returns: `1` if *window* is shaped

    method gdk_window_is_shaped ( --> Int  )

[[gdk_] window_] get_state
--------------------------

Gets the bitwise OR of the currently active window state flags, from the **Gnome::Gdk3::WindowState** enumeration.

Returns: window state bitfield

    method gdk_window_get_state ( --> GdkWindowState  )

[[gdk_] window_] has_native
---------------------------

Checks whether the window has a native window or not. Note that you can use `gdk_window_ensure_native()` if a native window is needed.

Returns: `1` if the *window* has a native window, `0` otherwise.

    method gdk_window_has_native ( --> Int  )

[[gdk_] window_] set_type_hint
------------------------------

The application can use this call to provide a hint to the window manager about the functionality of a window. The window manager can use this information when determining the decoration and behaviour of the window.

The hint must be set before the window is mapped.

    method gdk_window_set_type_hint ( GdkWindowTypeHint32 $hint )

  * GdkWindowTypeHint32 $hint; A hint of the function this window will have

[[gdk_] window_] get_type_hint
------------------------------

This function returns the type hint set for a window.

Returns: The type hint set for *window*

    method gdk_window_get_type_hint ( --> GdkWindowTypeHint32  )

[[gdk_] window_] get_modal_hint
-------------------------------

Determines whether or not the window manager is hinted that *window* has modal behaviour.

Returns: whether or not the window has the modal hint set.

    method gdk_window_get_modal_hint ( --> Int  )

[[gdk_] window_] set_modal_hint
-------------------------------

The application can use this hint to tell the window manager that a certain window has modal behaviour. The window manager can use this information to handle modal windows in a special way.

You should only use this on windows for which you have previously called `gdk_window_set_transient_for()`

    method gdk_window_set_modal_hint ( Int $modal )

  * Int $modal; `1` if the window is modal, `0` otherwise.

[[gdk_] window_] set_skip_taskbar_hint
--------------------------------------

Toggles whether a window should appear in a task list or window list. If a window’s semantic type as specified with `gdk_window_set_type_hint()` already fully describes the window, this function should not be called in addition, instead you should allow the window to be treated according to standard policy for its semantic type.

    method gdk_window_set_skip_taskbar_hint ( Int $skips_taskbar )

  * Int $skips_taskbar; `1` to skip the taskbar

[[gdk_] window_] set_skip_pager_hint
------------------------------------

Toggles whether a window should appear in a pager (workspace switcher, or other desktop utility program that displays a small thumbnail representation of the windows on the desktop). If a window’s semantic type as specified with `gdk_window_set_type_hint()` already fully describes the window, this function should not be called in addition, instead you should allow the window to be treated according to standard policy for its semantic type.

    method gdk_window_set_skip_pager_hint ( Int $skips_pager )

  * Int $skips_pager; `1` to skip the pager

[[gdk_] window_] set_urgency_hint
---------------------------------

Toggles whether a window needs the user's urgent attention.

    method gdk_window_set_urgency_hint ( Int $urgent )

  * Int $urgent; `1` if the window is urgent

[[gdk_] window_] set_geometry_hints
-----------------------------------

Sets the geometry hints for *window*. Hints flagged in *geom_mask* are set, hints not flagged in *geom_mask* are unset. To unset all hints, use a *geom_mask* of 0 and a *geometry* of `Any`.

This function provides hints to the windowing system about acceptable sizes for a toplevel window. The purpose of this is to constrain user resizing, but the windowing system will typically (but is not required to) also constrain the current size of the window to the provided values and constrain programatic resizing via `gdk_window_resize()` or `gdk_window_move_resize()`.

Note that on X11, this effect has no effect on windows of type `GDK_WINDOW_TEMP` or windows where override redirect has been turned on via `gdk_window_set_override_redirect()` since these windows are not resizable by the user.

Since you can’t count on the windowing system doing the constraints for programmatic resizes, you should generally call `gdk_window_constrain_size()` yourself to determine appropriate sizes.

    method gdk_window_set_geometry_hints ( GdkGeometry $geometry, GdkWindowHints $geom_mask )

  * GdkGeometry $geometry; geometry hints

  * GdkWindowHints $geom_mask; bitmask indicating fields of *geometry* to pay attention to

[[gdk_] window_] end_draw_frame
-------------------------------

Indicates that the drawing of the contents of *window* started with `gdk_window_begin_frame()` has been completed.

This function will take care of destroying the **Gnome::Gdk3::DrawingContext**.

It is an error to call this function without a matching `gdk_window_begin_frame()` first.

    method gdk_window_end_draw_frame ( N-GObject $context )

  * N-GObject $context; the **Gnome::Gdk3::DrawingContext** created by `gdk_window_begin_draw_frame()`

[[gdk_] window_] set_title
--------------------------

Sets the title of a toplevel window, to be displayed in the titlebar. If you haven’t explicitly set the icon name for the window (using `gdk_window_set_icon_name()`), the icon name will be set to *title* as well. *title* must be in UTF-8 encoding (as with all user-readable strings in GDK/GTK+). *title* may not be `Any`.

    method gdk_window_set_title ( Str $title )

  * Str $title; title of *window*

[[gdk_] window_] set_role
-------------------------

When using GTK+, typically you should use `gtk_window_set_role()` instead of this low-level function.

The window manager and session manager use a window’s role to distinguish it from other kinds of window in the same application. When an application is restarted after being saved in a previous session, all windows with the same title and role are treated as interchangeable. So if you have two windows with the same title that should be distinguished for session management purposes, you should set the role on those windows. It doesn’t matter what string you use for the role, as long as you have a different role for each non-interchangeable kind of window.

    method gdk_window_set_role ( Str $role )

  * Str $role; a string indicating its role

[[gdk_] window_] set_startup_id
-------------------------------

When using GTK+, typically you should use `gtk_window_set_startup_id()` instead of this low-level function.

    method gdk_window_set_startup_id ( Str $startup_id )

  * Str $startup_id; a string with startup-notification identifier

[[gdk_] window_] set_transient_for
----------------------------------

Indicates to the window manager that *window* is a transient dialog associated with the application window *parent*. This allows the window manager to do things like center *window* on *parent* and keep *window* above *parent*.

See `gtk_window_set_transient_for()` if you’re using **Gnome::Gtk3::Window** or **Gnome::Gtk3::Dialog**.

    method gdk_window_set_transient_for ( N-GObject $parent )

  * N-GObject $parent; another toplevel **Gnome::Gdk3::Window**

[[gdk_] window_] set_cursor
---------------------------

Sets the default mouse pointer for a **Gnome::Gdk3::Window**.

Note that *cursor* must be for the same display as *window*.

Use `gdk_cursor_new_for_display()` or `gdk_cursor_new_from_pixbuf()` to create the cursor. To make the cursor invisible, use `GDK_BLANK_CURSOR`. Passing `Any` for the *cursor* argument to `gdk_window_set_cursor()` means that *window* will use the cursor of its parent window. Most windows should use this default.

    method gdk_window_set_cursor ( N-GObject $cursor )

  * N-GObject $cursor; (allow-none): a cursor

[[gdk_] window_] get_cursor
---------------------------

Retrieves a **Gnome::Gdk3::Cursor** pointer for the cursor currently set on the specified **Gnome::Gdk3::Window**, or `Any`. If the return value is `Any` then there is no custom cursor set on the specified window, and it is using the cursor for its parent window.

Returns: (nullable) (transfer none): a **Gnome::Gdk3::Cursor**, or `Any`. The returned object is owned by the **Gnome::Gdk3::Window** and should not be unreferenced directly. Use `gdk_window_set_cursor()` to unset the cursor of the window

    method gdk_window_get_cursor ( --> N-GObject  )

[[gdk_] window_] set_device_cursor
----------------------------------

Sets a specific **Gnome::Gdk3::Cursor** for a given device when it gets inside *window*. Use `gdk_cursor_new_for_display()` or `gdk_cursor_new_from_pixbuf()` to create the cursor. To make the cursor invisible, use `GDK_BLANK_CURSOR`. Passing `Any` for the *cursor* argument to `gdk_window_set_cursor()` means that *window* will use the cursor of its parent window. Most windows should use this default.

    method gdk_window_set_device_cursor ( N-GObject $device, N-GObject $cursor )

  * N-GObject $device; a master, pointer **Gnome::Gdk3::Device**

  * N-GObject $cursor; a **Gnome::Gdk3::Cursor**

[[gdk_] window_] get_device_cursor
----------------------------------

Retrieves a **Gnome::Gdk3::Cursor** pointer for the *device* currently set on the specified **Gnome::Gdk3::Window**, or `Any`. If the return value is `Any` then there is no custom cursor set on the specified window, and it is using the cursor for its parent window.

Returns: (nullable) (transfer none): a **Gnome::Gdk3::Cursor**, or `Any`. The returned object is owned by the **Gnome::Gdk3::Window** and should not be unreferenced directly. Use `gdk_window_set_cursor()` to unset the cursor of the window

    method gdk_window_get_device_cursor ( N-GObject $device --> N-GObject  )

  * N-GObject $device; a master, pointer **Gnome::Gdk3::Device**.

[[gdk_] window_] get_user_data
------------------------------

Retrieves the user data for *window*, which is normally the widget that *window* belongs to. See `gdk_window_set_user_data()`.

    method gdk_window_get_user_data ( Pointer $data )

  * Pointer $data; (out): return location for user data

[[gdk_] window_] get_geometry
-----------------------------

Any of the return location arguments to this function may be `Any`, if you aren’t interested in getting the value of that field.

The X and Y coordinates returned are relative to the parent window of *window*, which for toplevels usually means relative to the window decorations (titlebar, etc.) rather than relative to the root window (screen-size background window).

On the X11 platform, the geometry is obtained from the X server, so reflects the latest position of *window*; this may be out-of-sync with the position of *window* delivered in the most-recently-processed **Gnome::Gdk3::EventConfigure**. `gdk_window_get_position()` in contrast gets the position from the most recent configure event.

Note: If *window* is not a toplevel, it is much better to call `gdk_window_get_position()`, `gdk_window_get_width()` and `gdk_window_get_height()` instead, because it avoids the roundtrip to the X server and because these functions support the full 32-bit coordinate space, whereas `gdk_window_get_geometry()` is restricted to the 16-bit coordinates of X11.

    method gdk_window_get_geometry ( Int $x, Int $y, Int $width, Int $height )

  * Int $x; (out) (allow-none): return location for X coordinate of window (relative to its parent)

  * Int $y; (out) (allow-none): return location for Y coordinate of window (relative to its parent)

  * Int $width; (out) (allow-none): return location for width of window

  * Int $height; (out) (allow-none): return location for height of window

[[gdk_] window_] get_width
--------------------------

Returns the width of the given *window*.

On the X11 platform the returned size is the size reported in the most-recently-processed configure event, rather than the current size on the X server.

Returns: The width of *window*

    method gdk_window_get_width ( --> int32  )

[[gdk_] window_] get_height
---------------------------

Returns the height of the given *window*.

On the X11 platform the returned size is the size reported in the most-recently-processed configure event, rather than the current size on the X server.

Returns: The height of *window*

    method gdk_window_get_height ( --> int32  )

[[gdk_] window_] get_position
-----------------------------

Obtains the position of the window as reported in the most-recently-processed **Gnome::Gdk3::EventConfigure**. Contrast with `gdk_window_get_geometry()` which queries the X server for the current window position, regardless of which events have been received or processed.

The position coordinates are relative to the window’s parent window.

    method gdk_window_get_position ( --> List )

Returns a List with

  * Int $x; X coordinate of window

  * Int $y; Y coordinate of window

[[gdk_] window_] get_origin
---------------------------

Obtains the position of a window in root window coordinates. (Compare with `gdk_window_get_position()` and `gdk_window_get_geometry()` which return the position of a window relative to its parent window.)

Returns: not meaningful, ignore

    method gdk_window_get_origin ( Int $x, Int $y --> Int  )

  * Int $x; (out) (allow-none): return location for X coordinate

  * Int $y; (out) (allow-none): return location for Y coordinate

[[gdk_] window_] get_root_coords
--------------------------------

Obtains the position of a window position in root window coordinates. This is similar to `gdk_window_get_origin()` but allows you to pass in any position in the window, not just the origin.

    method gdk_window_get_root_coords ( Int $x, Int $y, Int $root_x, Int $root_y )

  * Int $x; X coordinate in window

  * Int $y; Y coordinate in window

  * Int $root_x; (out): return location for X coordinate

  * Int $root_y; (out): return location for Y coordinate

[[gdk_] window_] coords_to_parent
---------------------------------

Transforms window coordinates from a child window to its parent window, where the parent window is the normal parent as returned by `gdk_window_get_parent()` for normal windows, and the window's embedder as returned by `gdk_offscreen_window_get_embedder()` for offscreen windows.

For normal windows, calling this function is equivalent to adding the return values of `gdk_window_get_position()` to the child coordinates. For offscreen windows however (which can be arbitrarily transformed), this function calls the **Gnome::Gdk3::Window**::to-embedder: signal to translate the coordinates.

You should always use this function when writing generic code that walks up a window hierarchy.

See also: `gdk_window_coords_from_parent()`

    method gdk_window_coords_to_parent ( Num $x, Num $y, Num $parent_x, Num $parent_y )

  * Num $x; X coordinate in child’s coordinate system

  * Num $y; Y coordinate in child’s coordinate system

  * Num $parent_x; (out) (allow-none): return location for X coordinate in parent’s coordinate system, or `Any`

  * Num $parent_y; (out) (allow-none): return location for Y coordinate in parent’s coordinate system, or `Any`

[[gdk_] window_] coords_from_parent
-----------------------------------

Transforms window coordinates from a parent window to a child window, where the parent window is the normal parent as returned by `gdk_window_get_parent()` for normal windows, and the window's embedder as returned by `gdk_offscreen_window_get_embedder()` for offscreen windows.

For normal windows, calling this function is equivalent to subtracting the return values of `gdk_window_get_position()` from the parent coordinates. For offscreen windows however (which can be arbitrarily transformed), this function calls the **Gnome::Gdk3::Window**::from-embedder: signal to translate the coordinates.

You should always use this function when writing generic code that walks down a window hierarchy.

See also: `gdk_window_coords_to_parent()`

    method gdk_window_coords_from_parent ( Num $parent_x, Num $parent_y, Num $x, Num $y )

  * Num $parent_x; X coordinate in parent’s coordinate system

  * Num $parent_y; Y coordinate in parent’s coordinate system

  * Num $x; (out) (allow-none): return location for X coordinate in child’s coordinate system

  * Num $y; (out) (allow-none): return location for Y coordinate in child’s coordinate system

[[gdk_] window_] get_root_origin
--------------------------------

Obtains the top-left corner of the window manager frame in root window coordinates.

    method gdk_window_get_root_origin ( Int $x, Int $y )

  * Int $x; (out): return location for X position of window frame

  * Int $y; (out): return location for Y position of window frame

[[gdk_] window_] get_frame_extents
----------------------------------

Obtains the bounding box of the window, including window manager titlebar/borders if any. The frame position is given in root window coordinates. To get the position of the window itself (rather than the frame) in root window coordinates, use `gdk_window_get_origin()`.

    method gdk_window_get_frame_extents ( N-GObject $rect )

  * N-GObject $rect; (out): rectangle to fill with bounding box of the window frame

[[gdk_] window_] get_scale_factor
---------------------------------

Returns the internal scale factor that maps from window coordiantes to the actual device pixels. On traditional systems this is 1, but on very high density outputs this can be a higher value (often 2).

A higher value means that drawing is automatically scaled up to a higher resolution, so any code doing drawing will automatically look nicer. However, if you are supplying pixel-based data the scale value can be used to determine whether to use a pixel resource with higher resolution data.

The scale of a window may change during runtime, if this happens a configure event will be sent to the toplevel window.

Returns: the scale factor

    method gdk_window_get_scale_factor ( --> Int  )

[[gdk_] window_] get_device_position
------------------------------------

Obtains the current device position and modifier state. The position is given in coordinates relative to the upper left corner of *window*.

Use `gdk_window_get_device_position_double()` if you need subpixel precision.

Returns: (nullable) (transfer none): The window underneath *device* (as with `gdk_device_get_window_at_position()`), or `Any` if the window is not known to GDK.

    method gdk_window_get_device_position ( N-GObject $device, Int $x, Int $y, GdkModifierType $mask --> N-GObject  )

  * N-GObject $device; pointer **Gnome::Gdk3::Device** to query to.

  * Int $x; (out) (allow-none): return location for the X coordinate of *device*, or `Any`.

  * Int $y; (out) (allow-none): return location for the Y coordinate of *device*, or `Any`.

  * GdkModifierType $mask; (out) (allow-none): return location for the modifier mask, or `Any`.

[[gdk_] window_] get_device_position_double
-------------------------------------------

Obtains the current device position in doubles and modifier state. The position is given in coordinates relative to the upper left corner of *window*.

Returns: (nullable) (transfer none): The window underneath *device* (as with `gdk_device_get_window_at_position()`), or `Any` if the window is not known to GDK.

    method gdk_window_get_device_position_double ( N-GObject $device, Num $x, Num $y, GdkModifierType $mask --> N-GObject  )

  * N-GObject $device; pointer **Gnome::Gdk3::Device** to query to.

  * Num $x; (out) (allow-none): return location for the X coordinate of *device*, or `Any`.

  * Num $y; (out) (allow-none): return location for the Y coordinate of *device*, or `Any`.

  * GdkModifierType $mask; (out) (allow-none): return location for the modifier mask, or `Any`.

[[gdk_] window_] get_parent
---------------------------

Obtains the parent of *window*, as known to GDK. Does not query the X server; thus this returns the parent as passed to `gdk_window_new()`, not the actual parent. This should never matter unless you’re using Xlib calls mixed with GDK calls on the X11 platform. It may also matter for toplevel windows, because the window manager may choose to reparent them.

Note that you should use `gdk_window_get_effective_parent()` when writing generic code that walks up a window hierarchy, because `gdk_window_get_parent()` will most likely not do what you expect if there are offscreen windows in the hierarchy.

Returns: (transfer none): parent of *window*

    method gdk_window_get_parent ( --> N-GObject  )

[[gdk_] window_] get_toplevel
-----------------------------

Gets the toplevel window that’s an ancestor of *window*.

Any window type but `GDK_WINDOW_CHILD` is considered a toplevel window, as is a `GDK_WINDOW_CHILD` window that has a root window as parent.

Note that you should use `gdk_window_get_effective_toplevel()` when you want to get to a window’s toplevel as seen on screen, because `gdk_window_get_toplevel()` will most likely not do what you expect if there are offscreen windows in the hierarchy.

Returns: (transfer none): the toplevel window containing *window*

    method gdk_window_get_toplevel ( --> N-GObject  )

[[gdk_] window_] get_effective_parent
-------------------------------------

Obtains the parent of *window*, as known to GDK. Works like `gdk_window_get_parent()` for normal windows, but returns the window’s embedder for offscreen windows.

See also: `gdk_offscreen_window_get_embedder()`

Returns: (transfer none): effective parent of *window*

    method gdk_window_get_effective_parent ( --> N-GObject  )

[[gdk_] window_] get_effective_toplevel
---------------------------------------

Gets the toplevel window that’s an ancestor of *window*.

Works like `gdk_window_get_toplevel()`, but treats an offscreen window's embedder as its parent, using `gdk_window_get_effective_parent()`.

See also: `gdk_offscreen_window_get_embedder()`

Returns: (transfer none): the effective toplevel window containing *window*

    method gdk_window_get_effective_toplevel ( --> N-GObject  )

[[gdk_] window_] get_children
-----------------------------

Gets the list of children of *window* known to GDK. This function only returns children created via GDK, so for example it’s useless when used with the root window; it only returns windows an application created itself.

The returned list must be freed, but the elements in the list need not be.

Returns: (transfer container) (element-type **Gnome::Gdk3::Window**): list of child windows inside *window*

    method gdk_window_get_children ( --> N-GList  )

[[gdk_] window_] peek_children
------------------------------

Like `gdk_window_get_children()`, but does not copy the list of children, so the list does not need to be freed.

Returns: (transfer none) (element-type **Gnome::Gdk3::Window**): a reference to the list of child windows in *window*

    method gdk_window_peek_children ( --> N-GList  )

[[gdk_] window_] get_children_with_user_data
--------------------------------------------

Gets the list of children of *window* known to GDK with a particular *user_data* set on it.

The returned list must be freed, but the elements in the list need not be.

The list is returned in (relative) stacking order, i.e. the lowest window is first.

Returns: (transfer container) (element-type **Gnome::Gdk3::Window**): list of child windows inside *window*

    method gdk_window_get_children_with_user_data ( Pointer $user_data --> N-GList  )

  * Pointer $user_data; user data to look for

[[gdk_] window_] get_events
---------------------------

Gets the event mask for *window* for all master input devices. See `gdk_window_set_events()`.

Returns: event mask for *window*

    method gdk_window_get_events ( --> GdkEventMask  )

[[gdk_] window_] set_events
---------------------------

The event mask for a window determines which events will be reported for that window from all master input devices. For example, an event mask including **GDK_BUTTON_PRESS_MASK** means the window should report button press events. The event mask is the bitwise OR of values from the **Gnome::Gdk3::EventMask** enumeration.

See the [input handling overview][event-masks] for details.

    method gdk_window_set_events ( GdkEventMask $event_mask )

  * GdkEventMask $event_mask; event mask for *window*

[[gdk_] window_] set_device_events
----------------------------------

Sets the event mask for a given device (Normally a floating device, not attached to any visible pointer) to *window*. For example, an event mask including **GDK_BUTTON_PRESS_MASK** means the window should report button press events. The event mask is the bitwise OR of values from the **Gnome::Gdk3::EventMask** enumeration.

See the [input handling overview][event-masks] for details.

    method gdk_window_set_device_events ( N-GObject $device, GdkEventMask $event_mask )

  * N-GObject $device; **Gnome::Gdk3::Device** to enable events for.

  * GdkEventMask $event_mask; event mask for *window*

[[gdk_] window_] get_device_events
----------------------------------

Returns the event mask for *window* corresponding to an specific device.

Returns: device event mask for *window*

    method gdk_window_get_device_events ( N-GObject $device --> GdkEventMask  )

  * N-GObject $device; a **Gnome::Gdk3::Device**.

[[gdk_] window_] set_source_events
----------------------------------

Sets the event mask for any floating device (i.e. not attached to any visible pointer) that has the source defined as *source*. This event mask will be applied both to currently existing, newly added devices after this call, and devices being attached/detached.

    method gdk_window_set_source_events ( GdkInputSource $source, GdkEventMask $event_mask )

  * GdkInputSource $source; a **Gnome::Gdk3::InputSource** to define the source class.

  * GdkEventMask $event_mask; event mask for *window*

[[gdk_] window_] get_source_events
----------------------------------

Returns the event mask for *window* corresponding to the device class specified by *source*.

Returns: source event mask for *window*

    method gdk_window_get_source_events ( GdkInputSource $source --> GdkEventMask  )

  * GdkInputSource $source; a **Gnome::Gdk3::InputSource** to define the source class.

[[gdk_] window_] set_icon_list
------------------------------

Sets a list of icons for the window. One of these will be used to represent the window when it has been iconified. The icon is usually shown in an icon box or some sort of task bar. Which icon size is shown depends on the window manager. The window manager can scale the icon but setting several size icons can give better image quality since the window manager may only need to scale the icon by a small amount or not at all.

Note that some platforms don't support window icons.

    method gdk_window_set_icon_list ( N-GList $pixbufs )

  * N-GList $pixbufs; (transfer none) (element-type **Gnome::Gdk3::Pixbuf**): A list of pixbufs, of different sizes.

[[gdk_] window_] set_icon_name
------------------------------

Windows may have a name used while minimized, distinct from the name they display in their titlebar. Most of the time this is a bad idea from a user interface standpoint. But you can set such a name with this function, if you like.

After calling this with a non-`Any` *name*, calls to `gdk_window_set_title()` will not update the icon title.

Using `Any` for *name* unsets the icon title; further calls to `gdk_window_set_title()` will again update the icon title as well.

Note that some platforms don't support window icons.

    method gdk_window_set_icon_name ( Str $name )

  * Str $name; (allow-none): name of window while iconified (minimized)

[[gdk_] window_] set_group
--------------------------

Sets the group leader window for *window*. By default, GDK sets the group leader for all toplevel windows to a global window implicitly created by GDK. With this function you can override this default.

The group leader window allows the window manager to distinguish all windows that belong to a single application. It may for example allow users to minimize/unminimize all windows belonging to an application at once. You should only set a non-default group window if your application pretends to be multiple applications.

    method gdk_window_set_group ( N-GObject $leader )

  * N-GObject $leader; (allow-none): group leader window, or `Any` to restore the default group leader window

[[gdk_] window_] get_group
--------------------------

Returns the group leader window for *window*. See `gdk_window_set_group()`.

Returns: (transfer none): the group leader window for *window*

    method gdk_window_get_group ( --> N-GObject  )

[[gdk_] window_] set_decorations
--------------------------------

“Decorations” are the features the window manager adds to a toplevel **Gnome::Gdk3::Window**. This function sets the traditional Motif window manager hints that tell the window manager which decorations you would like your window to have. Usually you should use `gtk_window_set_decorated()` on a **Gnome::Gtk3::Window** instead of using the GDK function directly.

The *decorations* argument is the logical OR of the fields in the **Gnome::Gdk3::WMDecoration** enumeration. If **GDK_DECOR_ALL** is included in the mask, the other bits indicate which decorations should be turned off. If **GDK_DECOR_ALL** is not included, then the other bits indicate which decorations should be turned on.

Most window managers honor a decorations hint of 0 to disable all decorations, but very few honor all possible combinations of bits.

    method gdk_window_set_decorations ( GdkWMDecoration $decorations )

  * GdkWMDecoration $decorations; decoration hint mask

[[gdk_] window_] get_decorations
--------------------------------

Returns the decorations set on the **Gnome::Gdk3::Window** with `gdk_window_set_decorations()`.

Returns: `1` if the window has decorations set, `0` otherwise.

    method gdk_window_get_decorations ( GdkWMDecoration $decorations --> Int  )

  * GdkWMDecoration $decorations; (out): The window decorations will be written here

[[gdk_] window_] set_functions
------------------------------

Sets hints about the window management functions to make available via buttons on the window frame.

On the X backend, this function sets the traditional Motif window manager hint for this purpose. However, few window managers do anything reliable or interesting with this hint. Many ignore it entirely.

The *functions* argument is the logical OR of values from the **WMFunction** enumeration. If the bitmask includes **GDK_FUNC_ALL**, then the other bits indicate which functions to disable; if it doesn’t include **GDK_FUNC_ALL**, it indicates which functions to enable.

    method gdk_window_set_functions ( GdkWMFunction $functions )

  * GdkWMFunction $functions; bitmask of operations to allow on *window*

[[gdk_] window_] create_similar_surface
---------------------------------------

Create a new surface that is as compatible as possible with the given *window*. For example the new surface will have the same fallback resolution and font options as *window*. Generally, the new surface will also use the same backend as *window*, unless that is not possible for some reason. The type of the returned surface may be examined with `cairo_surface_get_type()`.

Initially the surface contents are all 0 (transparent if contents have transparency, black otherwise.)

### Example

The next example shows how to get a surface from a **Gnome::Gtk3::DrawingArea**. This code can be run as an initialization step when called from a *realize* signal registered on the drawing area widget. This surface can then be saved in an attribute. Later, when a *draw* signal is fired. the surface can be stored in the provided cairo context using `.set-source-surface()` and used to paint the drawing.

    class X {
      has Gnome::Cairo::Surface $!surface;

      # called by signal 'realize'
      method make-drawing (
        Gnome::Gtk3::DrawingArea :widget($drawing-area)
        --> Int
      ) {

        my Int $width = $drawing-area.get-allocated-width;
        my Int $height = $drawing-area.get-allocated-height;

        my Gnome::Gdk3::Window $window .= new(
          :native-object($drawing-area.get-window)
        );

        $!surface .= new(
          :native-object(
            $window.create-similar-image-surface(
              CAIRO_CONTENT_COLOR, $width, $height
            )
          )
        );


        given Gnome::Cairo.new(:$!surface) {
          .set-source-rgb( 0.1, 0.1, 0.1);

          # select your own font if 'Z003' is not available
          .select-font-face(
            "Z003", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_BOLD
          );

          .set-font-size(18);

          # A bit of Natasha Beddingfield (your widget should be large enough!)
          for
             20, 30, "Most relationships seem so transitory",
             20, 60, "They're all good but not the permanent one",
             20, 120, "Who doesn't long for someone to hold",
             20, 150, "Who knows how to love you without being told",
             20, 180, "Somebody tell me why I'm on my own",
             20, 210, "If there's a soulmate for everyone"
             -> $x, $y, $text {

            .move-to( $x, $y);
            .show-text($text);
          }

          .clear-object;
        }

        1;
      }

      # Called by the draw signal after changing the window.
      method redraw ( cairo_t $n-cx, --> Int ) {

        # we have received a cairo context in which our surface must be set.
        my Gnome::Cairo $cairo-context .= new(:native-object($n-cx));
        $cairo-context.set-source-surface( $!surface, 0, 0);

        # just repaint the whole scenery
        $cairo-context.paint;

        1
      }
    }

Returns: a pointer to the newly allocated surface. The caller owns the surface and should call `cairo_surface_destroy()` when done with it.

This function always returns a valid pointer, but it will return a pointer to a “nil” surface if the surface of this Window is already in an error state or any other error occurs.

    method gdk_window_create_similar_surface (
      cairo_content_t $content, int32 $width, int32 $height
      --> cairo_surface_t
    )

  * cairo_content_t $content; an enum describing the content for the new surface

  * int32 $width; width of the new surface

  * int32 $height; height of the new surface

[[gdk_] window_] create_similar_image_surface
---------------------------------------------

Create a new image surface that is efficient to draw on the given *window*.

Initially the surface contents are all 0 (transparent if contents have transparency, black otherwise.)

The *width* and *height* of the new surface are not affected by the scaling factor of the *window*, or by the *scale* argument; they are the size of the surface in device pixels. If you wish to create an image surface capable of holding the contents of *window* you can use:

### Example

    my Gnome::Gtk3::DrawingArea $drawing-area;
    my Int $width = $drawing-area.get-allocated-width;
    my Int $height = $drawing-area.get-allocated-height;
    ny Int $scale = $drawing-area.get_scale_factor;

    my Gnome::Gdk3::Window $window .= new(:native-object(
      $drawing-area.get-window)
    );

    my Gnome::Cairo::Surface $surface .= new(
      :native-object(
        $window.create-similar-image-surface(
          CAIRO_FORMAT_ARGB32, $width, $height, $scale
        )
      )
    );

Returns: a pointer to the newly allocated surface. The caller owns the surface and should call `cairo_surface_destroy()` when done with it.

This function always returns a valid pointer, but it will return a pointer to a “nil” surface if *other* is already in an error state or any other error occurs.

    method gdk_window_create_similar_image_surface (
      cairo_format_t $format, int32 $width, int32 $height, int32 $scale
      --> cairo_surface_t
    )

  * cairo_format_t $format; the format for the new surface

  * int32 $width; width of the new surface

  * int32 $height; height of the new surface

  * int32 $scale; the scale of the new surface, or 0 to use same as *window*

gdk_window_beep
---------------

Emits a short beep associated to *window* in the appropriate display, if supported. Otherwise, emits a short beep on the display just as `gdk_display_beep()`.

    method gdk_window_beep ( )

gdk_window_iconify
------------------

Asks to iconify (minimize) *window*. The window manager may choose to ignore the request, but normally will honor it. Using `gtk_window_iconify()` is preferred, if you have a **Gnome::Gtk3::Window** widget.

This function only makes sense when *window* is a toplevel window.

    method gdk_window_iconify ( )

gdk_window_deiconify
--------------------

Attempt to deiconify (unminimize) *window*. On X11 the window manager may choose to ignore the request to deiconify. When using GTK+, use `gtk_window_deiconify()` instead of the **Gnome::Gdk3::Window** variant. Or better yet, you probably want to use `gtk_window_present()`, which raises the window, focuses it, unminimizes it, and puts it on the current desktop.

    method gdk_window_deiconify ( )

gdk_window_stick
----------------

“Pins” a window such that it’s on all workspaces and does not scroll with viewports, for window managers that have scrollable viewports. (When using **Gnome::Gtk3::Window**, `gtk_window_stick()` may be more useful.)

On the X11 platform, this function depends on window manager support, so may have no effect with many window managers. However, GDK will do the best it can to convince the window manager to stick the window. For window managers that don’t support this operation, there’s nothing you can do to force it to happen.

    method gdk_window_stick ( )

gdk_window_unstick
------------------

Reverse operation for `gdk_window_stick()`; see `gdk_window_stick()`, and `gtk_window_unstick()`.

    method gdk_window_unstick ( )

gdk_window_maximize
-------------------

Maximizes the window. If the window was already maximized, then this function does nothing.

On X11, asks the window manager to maximize *window*, if the window manager supports this operation. Not all window managers support this, and some deliberately ignore it or don’t have a concept of “maximized”; so you can’t rely on the maximization actually happening. But it will happen with most standard window managers, and GDK makes a best effort to get it to happen.

On Windows, reliably maximizes the window.

    method gdk_window_maximize ( )

gdk_window_unmaximize
---------------------

Unmaximizes the window. If the window wasn’t maximized, then this function does nothing.

On X11, asks the window manager to unmaximize *window*, if the window manager supports this operation. Not all window managers support this, and some deliberately ignore it or don’t have a concept of “maximized”; so you can’t rely on the unmaximization actually happening. But it will happen with most standard window managers, and GDK makes a best effort to get it to happen.

On Windows, reliably unmaximizes the window.

    method gdk_window_unmaximize ( )

gdk_window_fullscreen
---------------------

Moves the window into fullscreen mode. This means the window covers the entire screen and is above any panels or task bars.

If the window was already fullscreen, then this function does nothing.

On X11, asks the window manager to put *window* in a fullscreen state, if the window manager supports this operation. Not all window managers support this, and some deliberately ignore it or don’t have a concept of “fullscreen”; so you can’t rely on the fullscreenification actually happening. But it will happen with most standard window managers, and GDK makes a best effort to get it to happen.

    method gdk_window_fullscreen ( )

[[gdk_] window_] fullscreen_on_monitor
--------------------------------------

Moves the window into fullscreen mode on the given monitor. This means the window covers the entire screen and is above any panels or task bars.

If the window was already fullscreen, then this function does nothing. Since: UNRELEASED

    method gdk_window_fullscreen_on_monitor ( Int $monitor )

  * Int $monitor; Which monitor to display fullscreen on.

[[gdk_] window_] set_fullscreen_mode
------------------------------------

Specifies whether the *window* should span over all monitors (in a multi-head setup) or only the current monitor when in fullscreen mode.

The *mode* argument is from the **Gnome::Gdk3::FullscreenMode** enumeration. If **GDK_FULLSCREEN_ON_ALL_MONITORS** is specified, the fullscreen *window* will span over all monitors from the **Gnome::Gdk3::Screen**.

On X11, searches through the list of monitors from the **Gnome::Gdk3::Screen** the ones which delimit the 4 edges of the entire **Gnome::Gdk3::Screen** and will ask the window manager to span the *window* over these monitors.

If the XINERAMA extension is not available or not usable, this function has no effect.

Not all window managers support this, so you can’t rely on the fullscreen window to span over the multiple monitors when **GDK_FULLSCREEN_ON_ALL_MONITORS** is specified.

    method gdk_window_set_fullscreen_mode ( GdkFullscreenMode $mode )

  * GdkFullscreenMode $mode; fullscreen mode

[[gdk_] window_] get_fullscreen_mode
------------------------------------

Obtains the **Gnome::Gdk3::FullscreenMode** of the *window*.

Returns: The **Gnome::Gdk3::FullscreenMode** applied to the window when fullscreen.

    method gdk_window_get_fullscreen_mode ( --> GdkFullscreenMode  )

gdk_window_unfullscreen
-----------------------

Moves the window out of fullscreen mode. If the window was not fullscreen, does nothing.

On X11, asks the window manager to move *window* out of the fullscreen state, if the window manager supports this operation. Not all window managers support this, and some deliberately ignore it or don’t have a concept of “fullscreen”; so you can’t rely on the unfullscreenification actually happening. But it will happen with most standard window managers, and GDK makes a best effort to get it to happen.

    method gdk_window_unfullscreen ( )

[[gdk_] window_] set_keep_above
-------------------------------

Set if *window* must be kept above other windows. If the window was already above, then this function does nothing.

On X11, asks the window manager to keep *window* above, if the window manager supports this operation. Not all window managers support this, and some deliberately ignore it or don’t have a concept of “keep above”; so you can’t rely on the window being kept above. But it will happen with most standard window managers, and GDK makes a best effort to get it to happen.

    method gdk_window_set_keep_above ( Int $setting )

  * Int $setting; whether to keep *window* above other windows

[[gdk_] window_] set_keep_below
-------------------------------

Set if *window* must be kept below other windows. If the window was already below, then this function does nothing.

On X11, asks the window manager to keep *window* below, if the window manager supports this operation. Not all window managers support this, and some deliberately ignore it or don’t have a concept of “keep below”; so you can’t rely on the window being kept below. But it will happen with most standard window managers, and GDK makes a best effort to get it to happen.

    method gdk_window_set_keep_below ( Int $setting )

  * Int $setting; whether to keep *window* below other windows

[[gdk_] window_] set_opacity
----------------------------

Set *window* to render as partially transparent, with opacity 0 being fully transparent and 1 fully opaque. (Values of the opacity parameter are clamped to the [0,1] range.)

For toplevel windows this depends on support from the windowing system that may not always be there. For instance, On X11, this works only on X screens with a compositing manager running. On Wayland, there is no per-window opacity value that the compositor would apply. Instead, use `gdk_window_set_opaque_region (window, NULL)` to tell the compositor that the entire window is (potentially) non-opaque, and draw your content with alpha, or use `gtk_widget_set_opacity()` to set an overall opacity for your widgets.

For child windows this function only works for non-native windows.

For setting up per-pixel alpha topelevels, see `gdk_screen_get_rgba_visual()`, and for non-toplevels, see `gdk_window_set_composited()`.

Support for non-toplevel windows was added in 3.8.

    method gdk_window_set_opacity ( Num $opacity )

  * Num $opacity; opacity

[[gdk_] window_] register_dnd
-----------------------------

Registers a window as a potential drop destination.

    method gdk_window_register_dnd ( )

[[gdk_] window_] begin_resize_drag
----------------------------------

Begins a window resize operation (for a toplevel window).

This function assumes that the drag is controlled by the client pointer device, use `gdk_window_begin_resize_drag_for_device()` to begin a drag with a different device.

    method gdk_window_begin_resize_drag ( GdkWindowEdge $edge, Int $button, Int $root_x, Int $root_y, UInt $timestamp )

  * GdkWindowEdge $edge; the edge or corner from which the drag is started

  * Int $button; the button being used to drag, or 0 for a keyboard-initiated drag

  * Int $root_x; root window X coordinate of mouse click that began the drag

  * Int $root_y; root window Y coordinate of mouse click that began the drag

  * UInt $timestamp; timestamp of mouse click that began the drag (use `gdk_event_get_time()`)

[[gdk_] window_] begin_resize_drag_for_device
---------------------------------------------

Begins a window resize operation (for a toplevel window). You might use this function to implement a “window resize grip,” for example; in fact **Gnome::Gtk3::Statusbar** uses it. The function works best with window managers that support the [Extended Window Manager Hints](http://www.freedesktop.org/Standards/wm-spec) but has a fallback implementation for other window managers.

    method gdk_window_begin_resize_drag_for_device ( GdkWindowEdge $edge, N-GObject $device, Int $button, Int $root_x, Int $root_y, UInt $timestamp )

  * GdkWindowEdge $edge; the edge or corner from which the drag is started

  * N-GObject $device; the device used for the operation

  * Int $button; the button being used to drag, or 0 for a keyboard-initiated drag

  * Int $root_x; root window X coordinate of mouse click that began the drag

  * Int $root_y; root window Y coordinate of mouse click that began the drag

  * UInt $timestamp; timestamp of mouse click that began the drag (use `gdk_event_get_time()`)

[[gdk_] window_] begin_move_drag
--------------------------------

Begins a window move operation (for a toplevel window).

This function assumes that the drag is controlled by the client pointer device, use `gdk_window_begin_move_drag_for_device()` to begin a drag with a different device.

    method gdk_window_begin_move_drag ( Int $button, Int $root_x, Int $root_y, UInt $timestamp )

  * Int $button; the button being used to drag, or 0 for a keyboard-initiated drag

  * Int $root_x; root window X coordinate of mouse click that began the drag

  * Int $root_y; root window Y coordinate of mouse click that began the drag

  * UInt $timestamp; timestamp of mouse click that began the drag

[[gdk_] window_] begin_move_drag_for_device
-------------------------------------------

Begins a window move operation (for a toplevel window). You might use this function to implement a “window move grip,” for example. The function works best with window managers that support the [Extended Window Manager Hints](http://www.freedesktop.org/Standards/wm-spec) but has a fallback implementation for other window managers.

    method gdk_window_begin_move_drag_for_device ( N-GObject $device, Int $button, Int $root_x, Int $root_y, UInt $timestamp )

  * N-GObject $device; the device used for the operation

  * Int $button; the button being used to drag, or 0 for a keyboard-initiated drag

  * Int $root_x; root window X coordinate of mouse click that began the drag

  * Int $root_y; root window Y coordinate of mouse click that began the drag

  * UInt $timestamp; timestamp of mouse click that began the drag

[[gdk_] window_] invalidate_rect
--------------------------------

A convenience wrapper around `gdk_window_invalidate_region()` which invalidates a rectangular region. See `gdk_window_invalidate_region()` for details.

    method gdk_window_invalidate_rect ( N-GObject $rect, Int $invalidate_children )

  * N-GObject $rect; (allow-none): rectangle to invalidate or `Any` to invalidate the whole window

  * Int $invalidate_children; whether to also invalidate child windows

[[gdk_] window_] freeze_updates
-------------------------------

Temporarily freezes a window such that it won’t receive expose events. The window will begin receiving expose events again when `gdk_window_thaw_updates()` is called. If `gdk_window_freeze_updates()` has been called more than once, `gdk_window_thaw_updates()` must be called an equal number of times to begin processing exposes.

    method gdk_window_freeze_updates ( )

[[gdk_] window_] thaw_updates
-----------------------------

Thaws a window frozen with `gdk_window_freeze_updates()`.

    method gdk_window_thaw_updates ( )

[[gdk_] window_] constrain_size
-------------------------------

Constrains a desired width and height according to a set of geometry hints (such as minimum and maximum size).

    method gdk_window_constrain_size ( GdkGeometry $geometry, GdkWindowHints $flags, Int $width, Int $height, Int $new_width, Int $new_height )

  * GdkGeometry $geometry; a **Gnome::Gdk3::Geometry** structure

  * GdkWindowHints $flags; a mask indicating what portions of *geometry* are set

  * Int $width; desired width of window

  * Int $height; desired height of the window

  * Int $new_width; (out): location to store resulting width

  * Int $new_height; (out): location to store resulting height

gdk_get_default_root_window
---------------------------

Obtains the root window (parent all other windows are inside) for the default display and screen.

Returns: (transfer none): the default root window

    method gdk_get_default_root_window ( --> N-GObject  )

gdk_offscreen_window_set_embedder
---------------------------------

    method gdk_offscreen_window_set_embedder ( N-GObject $embedder )

  * N-GObject $embedder;

gdk_offscreen_window_get_embedder
---------------------------------

    method gdk_offscreen_window_get_embedder ( --> N-GObject  )

[[gdk_] window_] geometry_changed
---------------------------------

This function informs GDK that the geometry of an embedded offscreen window has changed. This is necessary for GDK to keep track of which offscreen window the pointer is in.

    method gdk_window_geometry_changed ( )

[[gdk_] window_] set_support_multidevice
----------------------------------------

This function will enable multidevice features in *window*.

Multidevice aware windows will need to handle properly multiple, per device enter/leave events, device grabs and grab ownerships.

    method gdk_window_set_support_multidevice ( Int $support_multidevice )

  * Int $support_multidevice; `1` to enable multidevice support in *window*.

[[gdk_] window_] get_support_multidevice
----------------------------------------

Returns `1` if the window is aware of the existence of multiple devices.

Returns: `1` if the window handles multidevice features.

    method gdk_window_get_support_multidevice ( --> Int  )

[[gdk_] window_] get_frame_clock
--------------------------------

Gets the frame clock for the window. The frame clock for a window never changes unless the window is reparented to a new toplevel window.

Returns: (transfer none): the frame clock

    method gdk_window_get_frame_clock ( --> N-GObject  )

[[gdk_] window_] set_event_compression
--------------------------------------

Determines whether or not extra unprocessed motion events in the event queue can be discarded. If `1` only the most recent event will be delivered.

Some types of applications, e.g. paint programs, need to see all motion events and will benefit from turning off event compression.

By default, event compression is enabled.

    method gdk_window_set_event_compression ( Int $event_compression )

  * Int $event_compression; `1` if motion events should be compressed

[[gdk_] window_] get_event_compression
--------------------------------------

Get the current event compression setting for this window.

Returns: `1` if motion events will be compressed

    method gdk_window_get_event_compression ( --> Int  )

[[gdk_] window_] set_shadow_width
---------------------------------

Newer GTK+ windows using client-side decorations use extra geometry around their frames for effects like shadows and invisible borders. Window managers that want to maximize windows or snap to edges need to know where the extents of the actual frame lie, so that users don’t feel like windows are snapping against random invisible edges.

Note that this property is automatically updated by GTK+, so this function should only be used by applications which do not use GTK+ to create toplevel windows.

    method gdk_window_set_shadow_width ( Int $left, Int $right, Int $top, Int $bottom )

  * Int $left; The left extent

  * Int $right; The right extent

  * Int $top; The top extent

  * Int $bottom; The bottom extent

[[gdk_] window_] show_window_menu
---------------------------------

Asks the windowing system to show the window menu. The window menu is the menu shown when right-clicking the titlebar on traditional windows managed by the window manager. This is useful for windows using client-side decorations, activating it with a right-click on the window decorations.

Returns: `1` if the window menu was shown and `0` otherwise.

    method gdk_window_show_window_menu ( GdkEvent $event --> Int  )

  * GdkEvent $event; a **Gnome::Gdk3::Event** to show the menu for

[[gdk_] window_] create_gl_context
----------------------------------

Creates a new **Gnome::Gdk3::GLContext** matching the framebuffer format to the visual of the **Gnome::Gdk3::Window**. The context is disconnected from any particular window or surface.

If the creation of the **Gnome::Gdk3::GLContext** failed, *error* will be set.

Before using the returned **Gnome::Gdk3::GLContext**, you will need to call `gdk_gl_context_make_current()` or `gdk_gl_context_realize()`.

Returns: (transfer full): the newly created **Gnome::Gdk3::GLContext**, or `Any` on error

    method gdk_window_create_gl_context ( N-GError $error --> N-GObject  )

  * N-GError $error; return location for an error

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

### pick-embedded-child

The *pick-embedded-child* signal is emitted to find an embedded child at the given position.

Returns: (nullable) (transfer none): the **Gnome::Gdk3::Window** of the embedded child at *x*, *y*, or `Any`

    method handler (
      num64 $x,
      num64 $y,
      Gnome::GObject::Object :widget($window),
      *%user-options
      --> Unknown type GDK_TYPE_WINDOW
    );

  * $window; the window on which the signal is emitted

  * $x; x coordinate in the window

  * $y; y coordinate in the window

### moved-to-rect

Emitted when the position of *window* is finalized after being moved to a destination rectangle.

*window* might be flipped over the destination rectangle in order to keep it on-screen, in which case *flipped_x* and *flipped_y* will be set to `1` accordingly.

*flipped_rect* is the ideal position of *window* after any possible flipping, but before any possible sliding. *final_rect* is *flipped_rect*, but possibly translated in the case that flipping is still ineffective in keeping *window* on-screen.

Stability: Private

    method handler (
      Unknown type G_TYPE_POINTER $flipped_rect,
      Unknown type G_TYPE_POINTER $final_rect,
      Int $flipped_x,
      Int $flipped_y,
      Gnome::GObject::Object :widget($window),
      *%user-options
    );

  * $window; the **Gnome::Gdk3::Window** that moved

  * $flipped_rect; (nullable): the position of *window* after any possible flipping or `Any` if the backend can't obtain it

  * $final_rect; (nullable): the final position of *window* or `Any` if the backend can't obtain it

  * $flipped_x; `1` if the anchors were flipped horizontally

  * $flipped_y; `1` if the anchors were flipped vertically

