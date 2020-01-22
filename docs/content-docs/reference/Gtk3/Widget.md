Gnome::Gtk3::Widget
===================

Base class for all widgets

Description
===========

**Gnome::Gtk3::Widget** is the base class all widgets in this package derive from. It manages the widget lifecycle, states and style.

Height-for-width Geometry Management
------------------------------------

GTK+ uses a height-for-width (and width-for-height) geometry management system. Height-for-width means that a widget can change how much vertical space it needs, depending on the amount of horizontal space that it is given (and similar for width-for-height). The most common example is a label that reflows to fill up the available width, wraps to fewer lines, and therefore needs less height.

Height-for-width geometry management is implemented in GTK+ by way of five virtual methods:

  * `get_request_mode()`

  * `get_preferred_width()`

  * `get_preferred_height()`

  * `get_preferred_height_for_width()`

  * `get_preferred_width_for_height()`

  * `get_preferred_height_and_baseline_for_width()`

There are some important things to keep in mind when implementing height-for-width and when using it in container implementations.

The geometry management system will query a widget hierarchy in only one orientation at a time. When widgets are initially queried for their minimum sizes it is generally done in two initial passes in the `GtkSizeRequestMode` chosen by the toplevel.

For example, when queried in the normal `GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH` mode:

  * First, the default minimum and natural width for each widget in the interface will be computed using `gtk_widget_get_preferred_width()`. Because the preferred widths for each container depend on the preferred widths of their children, this information propagates up the hierarchy, and finally a minimum and natural width is determined for the entire toplevel.

  * Next, the toplevel will use the minimum width to query for the minimum height contextual to that width using `gtk_widget_get_preferred_height_for_width()`, which will also be a highly recursive operation. The minimum height for the minimum width is normally used to set the minimum size constraint on the toplevel (unless `gtk_window_set_geometry_hints()` is explicitly used instead).

After the toplevel window has initially requested its size in both dimensions it can go on to allocate itself a reasonable size (or a size previously specified with `gtk_window_set_default_size()`). During the recursive allocation process it’s important to note that request cycles will be recursively executed while container widgets allocate their children. Each container widget, once allocated a size, will go on to first share the space in one orientation among its children and then request each child's height for its target allocated width or its width for allocated height, depending.

In this way a **Gnome::Gtk3::Widget** will typically be requested its size a number of times before actually being allocated a size. The size a widget is finally allocated can of course differ from the size it has requested. For this reason, **Gnome::Gtk3::Widget** caches a small number of results to avoid re-querying for the same sizes in one allocation cycle.

See [Gnome::Gtk3::Container’s geometry management section](https://developer.gnome.org/gtk3/stable/GtkContainer.html) to learn more about how height-for-width allocations are performed by container widgets.

If a widget does move content around to intelligently use up the allocated size then it must support the request in both `GtkSizeRequestMode`s even if the widget in question only trades sizes in a single orientation.

For instance, a **Gnome::Gtk3::Label** that does height-for-width word wrapping will not expect to have `get_preferred_height()` called because that call is specific to a width-for-height request. In this case the label must return the height required for its own minimum possible width. By following this rule any widget that handles height-for-width or width-for-height requests will always be allocated at least enough space to fit its own content.

Since 3.10 GTK+ also supports baseline vertical alignment of widgets. This means that widgets are positioned such that the typographical baseline of widgets in the same row are aligned. This happens if a widget supports baselines, has a vertical alignment of `GTK_ALIGN_BASELINE`, and is inside a container that supports baselines and has a natural “row” that it aligns to the baseline, or a baseline assigned to it by the grandparent.

Baseline alignment support for a widget is done by the `get_preferred_height_and_baseline_for_width()` virtual function. It allows you to report a baseline in combination with the minimum and natural height. If there is no baseline you can return -1 to indicate this. The default implementation of this virtual function calls into the `get_preferred_height()` and `get_preferred_height_for_width()`, so if baselines are not supported it doesn’t need to be implemented.

If a widget ends up baseline aligned it will be allocated all the space in the parent as if it was `GTK_ALIGN_FILL`, but the selected baseline can be found via `gtk_widget_get_allocated_baseline()`. If this has a value other than -1 you need to align the widget such that the baseline appears at the position.

Style Properties
----------------

**Gnome::Gtk3::Widget** introduces “style properties” - these are basically object properties that are stored not on the object, but in the style object associated to the widget. Style properties are set in gtk resource files. This mechanism is used for configuring such things as the location of the scrollbar arrows through the theme, giving theme authors more control over the look of applications without the need to write a theme engine in C.

Use `gtk_widget_class_install_style_property()` to install style properties for a widget class, `gtk_widget_class_find_style_property()` or `gtk_widget_class_list_style_properties()` to get information about existing style properties and `gtk_widget_style_get_property()`, `gtk_widget_style_get()` or `gtk_widget_style_get_valist()` to obtain the value of a style property.

Gnome::Gtk3::Widget as Gnome::Gtk3::Buildable
---------------------------------------------

The **Gnome::Gtk3::Widget** implementation of the **Gnome::Gtk3::Buildable** interface supports a custom <accelerator> element, which has attributes named ”key”, ”modifiers” and ”signal” and allows to specify accelerators.

An example of a UI definition fragment specifying an accelerator (please note that in this XML the C-Source widget class names must be used; GtkButton instead of Gnome::Gtk3::Button):

    <object class="GtkButton">
      <accelerator key="q" modifiers="GDK_CONTROL_MASK" signal="clicked"/>
    </object>

In addition to accelerators, **Gnome::Gtk3::Widget** also support a custom <accessible> element, which supports actions and relations. Properties on the accessible implementation of an object can be set by accessing the internal child “accessible” of a **Gnome::Gtk3::Widget**.

An example of a UI definition fragment specifying an accessible:

    <object class="GtkButton" id="label1"/>
      <property name="label">I am a Label for a Button</property>
    </object>
    <object class="GtkButton" id="button1">
      <accessibility>
        <action action_name="click" translatable="yes">
          Click the button.
        </action>
        <relation target="label1" type="labelled-by"/>
      </accessibility>
      <child internal-child="accessible">
        <object class="AtkObject" id="a11y-button1">
          <property name="accessible-name">
            Clickable Button
          </property>
        </object>
      </child>
    </object>

Finally, **Gnome::Gtk3::Widget** allows style information such as style classes to be associated with widgets, using the custom <style> element:

    <object class="GtkButton>" id="button1">
      <style>
        <class name="my-special-button-class"/>
        <class name="dark-button"/>
      </style>
    </object>

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Widget;
    also is Gnome::GObject::InitiallyUnowned;
    also does Gnome::Gtk3::Buildable;

Example
-------

    # create a button and set a tooltip
    my Gnome::Gtk3::Button $start-button .= new(:label<Start>);
    $start-button.set-tooltip-text('Nooooo don\'t touch that button!!!!!!!');

Types
=====

enum GtkWidgetHelpType
----------------------

Kinds of widget-specific help. Used by the ::show-help signal.

  * GTK_WIDGET_HELP_TOOLTIP: Tooltip.

  * GTK_WIDGET_HELP_WHATS_THIS: What’s this.

class N-GtkRequisition
----------------------

A **Gnome::Gtk3::Requisition**-struct represents the desired size of a widget. See [**Gnome::Gtk3::Widget**’s geometry management section][geometry-management] for more information.

  * Int $.width: the widget’s desired width

  * Int $.height: the widget’s desired height

Methods
=======

[gtk_] widget_destroy
---------------------

Destroys a widget.

When a widget is destroyed all references it holds on other objects will be released:

- if the widget is inside a container, it will be removed from its parent - if the widget is a container, all its children will be destroyed, recursively - if the widget is a top level, it will be removed from the list of top level widgets that GTK+ maintains internally

It's expected that all references held on the widget will also be released; you should connect to the sig `destroy` signal if you hold a reference to *widget* and you wish to remove it when this function is called. It is not necessary to do so if you are implementing a **Gnome::Gtk3::Container**, as you'll be able to use the **Gnome::Gtk3::ContainerClass**.`remove()` virtual function for that.

It's important to notice that `gtk_widget_destroy()` will only cause the *widget* to be finalized if no additional references, acquired using `g_object_ref()`, are held on it. In case additional references are in place, the *widget* will be in an "inert" state after calling this function; *widget* will still point to valid memory, allowing you to release the references you hold, but you may not query the widget's own state.

You should typically call this function on top level widgets, and rarely on child widgets.

See also: `gtk_container_remove()`

    method gtk_widget_destroy ( )

[gtk_] widget_destroyed
-----------------------

This function sets **widget_pointer* to `Any` if *widget_pointer* != `Any`. It’s intended to be used as a callback connected to the “destroy” signal of a widget. You connect `gtk_widget_destroyed()` as a signal handler, and pass the address of your widget variable as user data. Then when the widget is destroyed, the variable will be set to `Any`. Useful for example to avoid multiple copies of the same dialog.

    method gtk_widget_destroyed ( N-GObject $widget_pointer )

  * N-GObject $widget_pointer; (inout) (transfer none): address of a variable that contains *widget*

[gtk_] widget_unparent
----------------------

This function is only for use in widget implementations. Should be called by implementations of the remove method on **Gnome::Gtk3::Container**, to dissociate a child from the container.

    method gtk_widget_unparent ( )

[gtk_] widget_show
------------------

Flags a widget to be displayed. Any widget that isn’t shown will not appear on the screen. If you want to show all the widgets in a container, it’s easier to call `gtk_widget_show_all()` on the container, instead of individually showing the widgets.

Remember that you have to show the containers containing a widget, in addition to the widget itself, before it will appear onscreen.

When a toplevel container is shown, it is immediately realized and mapped; other shown widgets are realized and mapped when their toplevel container is realized and mapped.

    method gtk_widget_show ( )

[gtk_] widget_hide
------------------

Reverses the effects of `gtk_widget_show()`, causing the widget to be hidden (invisible to the user).

    method gtk_widget_hide ( )

[[gtk_] widget_] show_now
-------------------------

Shows a widget. If the widget is an unmapped toplevel widget (i.e. a **Gnome::Gtk3::Window** that has not yet been shown), enter the main loop and wait for the window to actually be mapped. Be careful; because the main loop is running, anything can happen during this function.

    method gtk_widget_show_now ( )

[[gtk_] widget_] show_all
-------------------------

Recursively shows a widget, and any child widgets (if the widget is a container).

    method gtk_widget_show_all ( )

[[gtk_] widget_] set_no_show_all
--------------------------------

Sets the prop `no-show-all` property, which determines whether calls to `gtk_widget_show_all()` will affect this widget.

This is mostly for use in constructing widget hierarchies with externally controlled visibility, see **Gnome::Gtk3::UIManager**.

Since: 2.4

    method gtk_widget_set_no_show_all ( Int $no_show_all )

  * Int $no_show_all; the new value for the “no-show-all” property

[[gtk_] widget_] get_no_show_all
--------------------------------

Returns the current value of the prop `no-show-all` property, which determines whether calls to `gtk_widget_show_all()` will affect this widget.

Returns: the current value of the “no-show-all” property.

Since: 2.4

    method gtk_widget_get_no_show_all ( --> Int  )

[gtk_] widget_map
-----------------

This function is only for use in widget implementations. Causes a widget to be mapped if it isn’t already.

    method gtk_widget_map ( )

[gtk_] widget_unmap
-------------------

This function is only for use in widget implementations. Causes a widget to be unmapped if it’s currently mapped.

    method gtk_widget_unmap ( )

[gtk_] widget_realize
---------------------

Creates the GDK (windowing system) resources associated with a widget. For example, *widget*->window will be created when a widget is realized. Normally realization happens implicitly; if you show a widget and all its parent containers, then the widget will be realized and mapped automatically.

Realizing a widget requires all the widget’s parent widgets to be realized; calling `gtk_widget_realize()` realizes the widget’s parents in addition to *widget* itself. If a widget is not yet inside a toplevel window when you realize it, bad things will happen.

This function is primarily used in widget implementations, and isn’t very useful otherwise. Many times when you think you might need it, a better approach is to connect to a signal that will be called after the widget is realized automatically, such as sig `draw`. Or simply `g_signal_connect()` to the sig `realize` signal.

    method gtk_widget_realize ( )

[gtk_] widget_unrealize
-----------------------

This function is only useful in widget implementations. Causes a widget to be unrealized (frees all GDK resources associated with the widget, such as *widget*->window).

    method gtk_widget_unrealize ( )

[[gtk_] widget_] queue_draw
---------------------------

Equivalent to calling `gtk_widget_queue_draw_area()` for the entire area of a widget.

    method gtk_widget_queue_draw ( )

[[gtk_] widget_] queue_draw_area
--------------------------------

Convenience function that calls `gtk_widget_queue_draw_region()` on the region created from the given coordinates.

The region here is specified in widget coordinates. Widget coordinates are a bit odd; for historical reasons, they are defined as *widget*->window coordinates for widgets that return `1` for `gtk_widget_get_has_window()`, and are relative to *widget*->allocation.x, *widget*->allocation.y otherwise.

*width* or *height* may be 0, in this case this function does nothing. Negative values for *width* and *height* are not allowed.

    method gtk_widget_queue_draw_area ( Int $x, Int $y, Int $width, Int $height )

  * Int $x; x coordinate of upper-left corner of rectangle to redraw

  * Int $y; y coordinate of upper-left corner of rectangle to redraw

  * Int $width; width of region to draw

  * Int $height; height of region to draw

[[gtk_] widget_] queue_resize
-----------------------------

This function is only for use in widget implementations. Flags a widget to have its size renegotiated; should be called when a widget for some reason has a new size request. For example, when you change the text in a **Gnome::Gtk3::Label**, **Gnome::Gtk3::Label** queues a resize to ensure there’s enough space for the new text.

Note that you cannot call `gtk_widget_queue_resize()` on a widget from inside its implementation of the **Gnome::Gtk3::WidgetClass**::size_allocate virtual method. Calls to `gtk_widget_queue_resize()` from inside **Gnome::Gtk3::WidgetClass**::size_allocate will be silently ignored.

    method gtk_widget_queue_resize ( )

[[gtk_] widget_] queue_resize_no_redraw
---------------------------------------

This function works like `gtk_widget_queue_resize()`, except that the widget is not invalidated.

Since: 2.4

    method gtk_widget_queue_resize_no_redraw ( )

[[gtk_] widget_] queue_allocate
-------------------------------

This function is only for use in widget implementations.

Flags the widget for a rerun of the **Gnome::Gtk3::WidgetClass**::size_allocate function. Use this function instead of `gtk_widget_queue_resize()` when the *widget*'s size request didn't change but it wants to reposition its contents.

An example user of this function is `gtk_widget_set_halign()`.

Since: 3.20

    method gtk_widget_queue_allocate ( )

[[gtk_] widget_] get_frame_clock
--------------------------------

Obtains the frame clock for a widget. The frame clock is a global “ticker” that can be used to drive animations and repaints. The most common reason to get the frame clock is to call `gdk_frame_clock_get_frame_time()`, in order to get a time to use for animating. For example you might record the start of the animation with an initial value from `gdk_frame_clock_get_frame_time()`, and then update the animation by calling `gdk_frame_clock_get_frame_time()` again during each repaint.

`gdk_frame_clock_request_phase()` will result in a new frame on the clock, but won’t necessarily repaint any widgets. To repaint a widget, you have to use `gtk_widget_queue_draw()` which invalidates the widget (thus scheduling it to receive a draw on the next frame). `gtk_widget_queue_draw()` will also end up requesting a frame on the appropriate frame clock.

A widget’s frame clock will not change while the widget is mapped. Reparenting a widget (which implies a temporary unmap) can change the widget’s frame clock.

Unrealized widgets do not have a frame clock.

Returns: (nullable) (transfer none): a **Gnome::Gdk3::FrameClock**, or `NULL` if widget is unrealized

Since: 3.8

    method gtk_widget_get_frame_clock ( --> N-GObject  )

[[gtk_] widget_] size_allocate
------------------------------

    method gtk_widget_size_allocate ( GtkAllocation $allocation )

  * GtkAllocation $allocation;

[[gtk_] widget_] size_allocate_with_baseline
--------------------------------------------

This function is only used by **Gnome::Gtk3::Container** subclasses, to assign a size, position and (optionally) baseline to their child widgets.

In this function, the allocation and baseline may be adjusted. It will be forced to a 1x1 minimum size, and the adjust_size_allocation virtual and adjust_baseline_allocation methods on the child will be used to adjust the allocation and baseline. Standard adjustments include removing the widget's margins, and applying the widget’s prop `halign` and prop `valign` properties.

If the child widget does not have a valign of `GTK_ALIGN_BASELINE` the baseline argument is ignored and -1 is used instead.

Since: 3.10

    method gtk_widget_size_allocate_with_baseline ( GtkAllocation $allocation, Int $baseline )

  * GtkAllocation $allocation; position and size to be allocated to *widget*

  * Int $baseline; The baseline of the child, or -1

[[gtk_] widget_] get_request_mode
---------------------------------

Gets whether the widget prefers a height-for-width layout or a width-for-height layout.

GtkBin widgets generally propagate the preference of their child, container widgets need to request something either in context of their children or in context of their allocation capabilities.

    method gtk_widget_get_request_mode ( --> GtkSizeRequestMode  )

[[gtk_] widget_] get_preferred_width
------------------------------------

Retrieves a widget’s initial minimum and natural width.

This call is specific to height-for-width requests.

The returned request will be modified by the GtkWidgetClass::adjust_size_request virtual method and by any GtkSizeGroups that have been applied. That is, the returned request is the one that should be used for layout, not necessarily the one returned by the widget itself. method gtk_widget_get_preferred_width ( --> List )

Returns a List with

  * Int $minimum_width;

  * Int $natural_width;

[[gtk_] widget_] get_preferred_height_for_width
-----------------------------------------------

Retrieves a widget’s minimum and natural height if it would be given the specified width .

The returned request will be modified by the GtkWidgetClass::adjust_size_request virtual method and by any GtkSizeGroups that have been applied. That is, the returned request is the one that should be used for layout, not necessarily the one returned by the widget itself.

    method gtk_widget_get_preferred_height_for_width (
      Int $width --> List
    )

  * Int $width;

Returns a List with

  * Int $minimum_height;

  * Int $natural_height;

[[gtk_] widget_] get_preferred_height
-------------------------------------

Retrieves a widget’s initial minimum and natural height.

This call is specific to width-for-height requests.

The returned request will be modified by the GtkWidgetClass::adjust_size_request virtual method and by any GtkSizeGroups that have been applied. That is, the returned request is the one that should be used for layout, not necessarily the one returned by the widget itself.

    method gtk_widget_get_preferred_height ( --> List )

Returns a List with

  * Int $minimum_height;

  * Int $natural_height;

[[gtk_] widget_] get_preferred_width_for_height
-----------------------------------------------

Retrieves a widget’s minimum and natural width if it would be given the specified height .

The returned request will be modified by the GtkWidgetClass::adjust_size_request virtual method and by any GtkSizeGroups that have been applied. That is, the returned request is the one that should be used for layout, not necessarily the one returned by the widget itself.

    method gtk_widget_get_preferred_width_for_height ( Int $height --> List )

  * Int $height;

Returning a List with

  * Int $minimum_width;

  * Int $natural_width;

[[gtk_] widget_] get_preferred_height_and_baseline_for_width
------------------------------------------------------------

Retrieves a widget’s minimum and natural height and the corresponding baselines if it would be given the specified width , or the default height if width is -1. The baselines may be -1 which means that no baseline is requested for this widget.

The returned request will be modified by the GtkWidgetClass::adjust_size_request and GtkWidgetClass::adjust_baseline_request virtual methods and by any GtkSizeGroups that have been applied. That is, the returned request is the one that should be used for layout, not necessarily the one returned by the widget itself.

    method gtk_widget_get_preferred_height_and_baseline_for_width (
      Int $width
      --> List
    )

  * Int $width;

Returning a List with

  * Int $minimum_height;

  * Int $natural_height;

  * Int $minimum_baseline;

  * Int $natural_baseline;

[[gtk_] widget_] get_preferred_size
-----------------------------------

Retrieves the minimum and natural size of a widget, taking into account the widget’s preference for height-for-width management.

This is used to retrieve a suitable size by container widgets which do not impose any restrictions on the child placement. It can be used to deduce toplevel window and menu sizes as well as child widgets in free-form containers such as GtkLayout.

Handle with care. Note that the natural height of a height-for-width widget will generally be a smaller size than the minimum height, since the required height for the natural width is generally smaller than the required height for the minimum width.

Use gtk_widget_get_preferred_height_and_baseline_for_width() if you want to support baseline alignment.

    method gtk_widget_get_preferred_size ( --> List )

The returned list holds

  * N-GtkRequisition $minimum_size;

  * N-GtkRequisition $natural_size;

[[gtk_] widget_] remove_accelerator
-----------------------------------

Removes an accelerator from *widget*, previously installed with `gtk_widget_add_accelerator()`.

Returns: whether an accelerator was installed and could be removed

    method gtk_widget_remove_accelerator ( N-GObject $accel_group, UInt $accel_key, GdkModifierType $accel_mods --> Int  )

  * N-GObject $accel_group; accel group for this widget

  * UInt $accel_key; GDK keyval of the accelerator

  * GdkModifierType $accel_mods; modifier key combination of the accelerator

[[gtk_] widget_] set_accel_path
-------------------------------

Given an accelerator group, *accel_group*, and an accelerator path, *accel_path*, sets up an accelerator in *accel_group* so whenever the key binding that is defined for *accel_path* is pressed, *widget* will be activated. This removes any accelerators (for any accelerator group) installed by previous calls to `gtk_widget_set_accel_path()`. Associating accelerators with paths allows them to be modified by the user and the modifications to be saved for future use. (See `gtk_accel_map_save()`.)

This function is a low level function that would most likely be used by a menu creation system like **Gnome::Gtk3::UIManager**. If you use **Gnome::Gtk3::UIManager**, setting up accelerator paths will be done automatically.

Even when you you aren’t using **Gnome::Gtk3::UIManager**, if you only want to set up accelerators on menu items `gtk_menu_item_set_accel_path()` provides a somewhat more convenient interface.

Note that *accel_path* string will be stored in a `GQuark`. Therefore, if you pass a static string, you can save some memory by interning it first with `g_intern_static_string()`.

    method gtk_widget_set_accel_path ( Str $accel_path, N-GObject $accel_group )

  * Str $accel_path; (allow-none): path used to look up the accelerator

  * N-GObject $accel_group; (allow-none): a **Gnome::Gtk3::AccelGroup**.

[[gtk_] widget_] list_accel_closures
------------------------------------

Lists the closures used by *widget* for accelerator group connections with `gtk_accel_group_connect_by_path()` or `gtk_accel_group_connect()`. The closures can be used to monitor accelerator changes on *widget*, by connecting to the *C*<Gnome::Gtk3::AccelGroup>::accel-changed signal of the **Gnome::Gtk3::AccelGroup** of a closure which can be found out with `gtk_accel_group_from_accel_closure()`.

Returns: (transfer container) (element-type GClosure): a newly allocated `GList` of closures

    method gtk_widget_list_accel_closures ( --> N-GObject  )

[[gtk_] widget_] can_activate_accel
-----------------------------------

Determines whether an accelerator that activates the signal identified by *signal_id* can currently be activated. This is done by emitting the sig `can-activate-accel` signal on *widget*; if the signal isn’t overridden by a handler or in a derived widget, then the default check is that the widget must be sensitive, and the widget and all its ancestors mapped.

Returns: `1` if the accelerator can be activated.

Since: 2.4

    method gtk_widget_can_activate_accel ( UInt $signal_id --> Int  )

  * UInt $signal_id; the ID of a signal installed on *widget*

[[gtk_] widget_] mnemonic_activate
----------------------------------

Emits the sig `mnemonic-activate` signal.

The default handler for this signal activates the *widget* if *group_cycling* is `0`, and just grabs the focus if *group_cycling* is `1`.

Returns: `1` if the signal has been handled

    method gtk_widget_mnemonic_activate ( Int $group_cycling --> Int  )

  * Int $group_cycling; `1` if there are other widgets with the same mnemonic

[gtk_] widget_event
-------------------

Rarely-used function. This function is used to emit the event signals on a widget (those signals should never be emitted without using this function to do so). If you want to synthesize an event though, don’t use this function; instead, use `gtk_main_do_event()` so the event will behave as if it were in the event queue. Don’t synthesize expose events; instead, use `gdk_window_invalidate_rect()` to invalidate a region of the window.

Returns: return from the event signal emission (`1` if the event was handled)

    method gtk_widget_event ( GdkEvent $event --> Int  )

  * GdkEvent $event; a **Gnome::Gdk3::Event**

[[gtk_] widget_] send_focus_change
----------------------------------

Sends the focus change *event* to *widget*

This function is not meant to be used by applications. The only time it should be used is when it is necessary for a **Gnome::Gtk3::Widget** to assign focus to a widget that is semantically owned by the first widget even though it’s not a direct child - for instance, a search entry in a floating window similar to the quick search in **Gnome::Gtk3::TreeView**.

An example of its usage is:

|[<!-- language="C" --> **Gnome::Gdk3::Event** *fevent = gdk_event_new (GDK_FOCUS_CHANGE);

fevent->focus_change.type = GDK_FOCUS_CHANGE; fevent->focus_change.in = TRUE; fevent->focus_change.window = _gtk_widget_get_window (widget); if (fevent->focus_change.window != NULL) g_object_ref (fevent->focus_change.window);

gtk_widget_send_focus_change (widget, fevent);

gdk_event_free (event); ]|

Returns: the return value from the event signal emission: `1` if the event was handled, and `0` otherwise

Since: 2.20

    method gtk_widget_send_focus_change ( GdkEvent $event --> Int  )

  * GdkEvent $event; a **Gnome::Gdk3::Event** of type GDK_FOCUS_CHANGE

[gtk_] widget_activate
----------------------

For widgets that can be “activated” (buttons, menu items, etc.) this function activates them. Activation is what happens when you press Enter on a widget during key navigation. If *widget* isn't activatable, the function returns `0`.

Returns: `1` if the widget was activatable

    method gtk_widget_activate ( --> Int  )

[gtk_] widget_intersect
-----------------------

Computes the intersection of a *widget*’s area and *area*, storing the intersection in *intersection*, and returns `1` if there was an intersection. *intersection* may be `Any` if you’re only interested in whether there was an intersection.

Returns: `1` if there was an intersection

    method gtk_widget_intersect ( N-GObject $area, N-GObject $intersection --> Int  )

  * N-GObject $area; a rectangle

  * N-GObject $intersection; (nullable): rectangle to store intersection of *widget* and *area*

[[gtk_] widget_] freeze_child_notify
------------------------------------

Stops emission of sig `child-notify` signals on *widget*. The signals are queued until `gtk_widget_thaw_child_notify()` is called on *widget*.

This is the analogue of `g_object_freeze_notify()` for child properties.

    method gtk_widget_freeze_child_notify ( )

[[gtk_] widget_] child_notify
-----------------------------

Emits a sig `child-notify` signal for the [child property][child-properties] *child_property* on *widget*.

This is the analogue of `g_object_notify()` for child properties.

Also see `gtk_container_child_notify()`.

    method gtk_widget_child_notify ( Str $child_property )

  * Str $child_property; the name of a child property installed on the class of *widget*’s parent

[[gtk_] widget_] thaw_child_notify
----------------------------------

Reverts the effect of a previous call to `gtk_widget_freeze_child_notify()`. This causes all queued sig `child-notify` signals on *widget* to be emitted.

    method gtk_widget_thaw_child_notify ( )

[[gtk_] widget_] set_can_focus
------------------------------

Specifies whether *widget* can own the input focus. See `gtk_widget_grab_focus()` for actually setting the input focus on a widget.

Since: 2.18

    method gtk_widget_set_can_focus ( Int $can_focus )

  * Int $can_focus; whether or not *widget* can own the input focus.

[[gtk_] widget_] get_can_focus
------------------------------

Determines whether *widget* can own the input focus. See `gtk_widget_set_can_focus()`.

Returns: `1` if *widget* can own the input focus, `0` otherwise

Since: 2.18

    method gtk_widget_get_can_focus ( --> Int  )

[[gtk_] widget_] has_focus
--------------------------

Determines if the widget has the global input focus. See `gtk_widget_is_focus()` for the difference between having the global input focus, and only having the focus within a toplevel.

Returns: `1` if the widget has the global input focus.

Since: 2.18

    method gtk_widget_has_focus ( --> Int  )

[[gtk_] widget_] is_focus
-------------------------

Determines if the widget is the focus widget within its toplevel. (This does not mean that the prop `has-focus` property is necessarily set; prop `has-focus` will only be set if the toplevel widget additionally has the global input focus.)

Returns: `1` if the widget is the focus widget.

    method gtk_widget_is_focus ( --> Int  )

[[gtk_] widget_] has_visible_focus
----------------------------------

Determines if the widget should show a visible indication that it has the global input focus. This is a convenience function for use in ::draw handlers that takes into account whether focus indication should currently be shown in the toplevel window of *widget*. See `gtk_window_get_focus_visible()` for more information about focus indication.

To find out if the widget has the global input focus, use `gtk_widget_has_focus()`.

Returns: `1` if the widget should display a “focus rectangle”

Since: 3.2

    method gtk_widget_has_visible_focus ( --> Int  )

[[gtk_] widget_] grab_focus
---------------------------

Causes *widget* to have the keyboard focus for the **Gnome::Gtk3::Window** it's inside. *widget* must be a focusable widget, such as a **Gnome::Gtk3::Entry**; something like **Gnome::Gtk3::Frame** won’t work.

More precisely, it must have the `GTK_CAN_FOCUS` flag set. Use `gtk_widget_set_can_focus()` to modify that flag.

The widget also needs to be realized and mapped. This is indicated by the related signals. Grabbing the focus immediately after creating the widget will likely fail and cause critical warnings.

    method gtk_widget_grab_focus ( )

[[gtk_] widget_] set_focus_on_click
-----------------------------------

Sets whether the widget should grab focus when it is clicked with the mouse. Making mouse clicks not grab focus is useful in places like toolbars where you don’t want the keyboard focus removed from the main area of the application.

Since: 3.20

    method gtk_widget_set_focus_on_click ( Int $focus_on_click )

  * Int $focus_on_click; whether the widget should grab focus when clicked with the mouse

[[gtk_] widget_] get_focus_on_click
-----------------------------------

Returns whether the widget should grab focus when it is clicked with the mouse. See `gtk_widget_set_focus_on_click()`.

Returns: `1` if the widget should grab focus when it is clicked with the mouse.

Since: 3.20

    method gtk_widget_get_focus_on_click ( --> Int  )

[[gtk_] widget_] set_can_default
--------------------------------

Specifies whether *widget* can be a default widget. See `gtk_widget_grab_default()` for details about the meaning of “default”.

Since: 2.18

    method gtk_widget_set_can_default ( Int $can_default )

  * Int $can_default; whether or not *widget* can be a default widget.

[[gtk_] widget_] get_can_default
--------------------------------

Determines whether *widget* can be a default widget. See `gtk_widget_set_can_default()`.

Returns: `1` if *widget* can be a default widget, `0` otherwise

Since: 2.18

    method gtk_widget_get_can_default ( --> Int  )

[[gtk_] widget_] has_default
----------------------------

Determines whether *widget* is the current default widget within its toplevel. See `gtk_widget_set_can_default()`.

Returns: `1` if *widget* is the current default widget within its toplevel, `0` otherwise

Since: 2.18

    method gtk_widget_has_default ( --> Int  )

[[gtk_] widget_] grab_default
-----------------------------

Causes *widget* to become the default widget. *widget* must be able to be a default widget; typically you would ensure this yourself by calling `gtk_widget_set_can_default()` with a `1` value. The default widget is activated when the user presses Enter in a window. Default widgets must be activatable, that is, `gtk_widget_activate()` should affect them. Note that **Gnome::Gtk3::Entry** widgets require the “activates-default” property set to `1` before they activate the default widget when Enter is pressed and the **Gnome::Gtk3::Entry** is focused.

    method gtk_widget_grab_default ( )

[[gtk_] widget_] set_receives_default
-------------------------------------

Specifies whether *widget* will be treated as the default widget within its toplevel when it has the focus, even if another widget is the default.

See `gtk_widget_grab_default()` for details about the meaning of “default”.

Since: 2.18

    method gtk_widget_set_receives_default ( Int $receives_default )

  * Int $receives_default; whether or not *widget* can be a default widget.

[[gtk_] widget_] get_receives_default
-------------------------------------

Determines whether *widget* is always treated as the default widget within its toplevel when it has the focus, even if another widget is the default.

See `gtk_widget_set_receives_default()`.

Returns: `1` if *widget* acts as the default widget when focused, `0` otherwise

Since: 2.18

    method gtk_widget_get_receives_default ( --> Int  )

[[gtk_] widget_] has_grab
-------------------------

Determines whether the widget is currently grabbing events, so it is the only widget receiving input events (keyboard and mouse).

See also `gtk_grab_add()`.

Returns: `1` if the widget is in the grab_widgets stack

Since: 2.18

    method gtk_widget_has_grab ( --> Int  )

[[gtk_] widget_] device_is_shadowed
-----------------------------------

Returns `1` if *device* has been shadowed by a GTK+ device grab on another widget, so it would stop sending events to *widget*. This may be used in the sig `grab-notify` signal to check for specific devices. See `gtk_device_grab_add()`.

Returns: `1` if there is an ongoing grab on *device* by another **Gnome::Gtk3::Widget** than *widget*.

Since: 3.0

    method gtk_widget_device_is_shadowed ( N-GObject $device --> Int  )

  * N-GObject $device; a **Gnome::Gdk3::Device**

[[gtk_] widget_] set_name
-------------------------

Widgets can be named, which allows you to refer to them from a CSS file. You can apply a style to widgets with a particular name in the CSS file. See the documentation for the CSS syntax (on the same page as the docs for **Gnome::Gtk3::StyleContext**).

Note that the CSS syntax has certain special characters to delimit and represent elements in a selector (period, #, >, *...), so using these will make your widget impossible to match by name. Any combination of alphanumeric symbols, dashes and underscores will suffice.

    method gtk_widget_set_name ( Str $name )

  * Str $name; name for the widget

[[gtk_] widget_] get_name
-------------------------

Retrieves the name of a widget. See `gtk_widget_set_name()` for the significance of widget names.

Returns: name of the widget. This string is owned by GTK+ and should not be modified or freed

    method gtk_widget_get_name ( --> Str  )

[[gtk_] widget_] set_state_flags
--------------------------------

This function is for use in widget implementations. Turns on flag values in the current widget state (insensitive, prelighted, etc.).

This function accepts the values `GTK_STATE_FLAG_DIR_LTR` and `GTK_STATE_FLAG_DIR_RTL` but ignores them. If you want to set the widget's direction, use `gtk_widget_set_direction()`.

It is worth mentioning that any other state than `GTK_STATE_FLAG_INSENSITIVE`, will be propagated down to all non-internal children if *widget* is a **Gnome::Gtk3::Container**, while `GTK_STATE_FLAG_INSENSITIVE` itself will be propagated down to all **Gnome::Gtk3::Container** children by different means than turning on the state flag down the hierarchy, both `gtk_widget_get_state_flags()` and `gtk_widget_is_sensitive()` will make use of these.

Since: 3.0

    method gtk_widget_set_state_flags ( GtkStateFlags $flags, Int $clear )

  * GtkStateFlags $flags; State flags to turn on

  * Int $clear; Whether to clear state before turning on *flags*

[[gtk_] widget_] unset_state_flags
----------------------------------

This function is for use in widget implementations. Turns off flag values for the current widget state (insensitive, prelighted, etc.). See `gtk_widget_set_state_flags()`.

Since: 3.0

    method gtk_widget_unset_state_flags ( GtkStateFlags $flags )

  * GtkStateFlags $flags; State flags to turn off

[[gtk_] widget_] get_state_flags
--------------------------------

Returns the widget state as a flag set. It is worth mentioning that the effective `GTK_STATE_FLAG_INSENSITIVE` state will be returned, that is, also based on parent insensitivity, even if *widget* itself is sensitive.

Also note that if you are looking for a way to obtain the **Gnome::Gtk3::StateFlags** to pass to a **Gnome::Gtk3::StyleContext** method, you should look at `gtk_style_context_get_state()`.

Returns: The state flags for widget

Since: 3.0

    method gtk_widget_get_state_flags ( --> GtkStateFlags  )

[[gtk_] widget_] set_sensitive
------------------------------

Sets the sensitivity of a widget. A widget is sensitive if the user can interact with it. Insensitive widgets are “grayed out” and the user can’t interact with them. Insensitive widgets are known as “inactive”, “disabled”, or “ghosted” in some other toolkits.

    method gtk_widget_set_sensitive ( Int $sensitive )

  * Int $sensitive; `1` to make the widget sensitive

[[gtk_] widget_] get_sensitive
------------------------------

Returns the widget’s sensitivity (in the sense of returning the value that has been set using `gtk_widget_set_sensitive()`).

The effective sensitivity of a widget is however determined by both its own and its parent widget’s sensitivity. See `gtk_widget_is_sensitive()`.

Returns: `1` if the widget is sensitive

Since: 2.18

    method gtk_widget_get_sensitive ( --> Int  )

[[gtk_] widget_] is_sensitive
-----------------------------

Returns the widget’s effective sensitivity, which means it is sensitive itself and also its parent widget is sensitive

Returns: `1` if the widget is effectively sensitive

Since: 2.18

    method gtk_widget_is_sensitive ( --> Int  )

[[gtk_] widget_] set_visible
----------------------------

Sets the visibility state of *widget*. Note that setting this to `1` doesn’t mean the widget is actually viewable, see `gtk_widget_get_visible()`.

This function simply calls `gtk_widget_show()` or `gtk_widget_hide()` but is nicer to use when the visibility of the widget depends on some condition.

Since: 2.18

    method gtk_widget_set_visible ( Int $visible )

  * Int $visible; whether the widget should be shown or not

[[gtk_] widget_] get_visible
----------------------------

Determines whether the widget is visible. If you want to take into account whether the widget’s parent is also marked as visible, use `gtk_widget_is_visible()` instead.

This function does not check if the widget is obscured in any way.

See `gtk_widget_set_visible()`.

Returns: `1` if the widget is visible

Since: 2.18

    method gtk_widget_get_visible ( --> Int  )

[[gtk_] widget_] is_visible
---------------------------

Determines whether the widget and all its parents are marked as visible.

This function does not check if the widget is obscured in any way.

See also `gtk_widget_get_visible()` and `gtk_widget_set_visible()`

Returns: `1` if the widget and all its parents are visible

Since: 3.8

    method gtk_widget_is_visible ( --> Int  )

[[gtk_] widget_] set_has_window
-------------------------------

Specifies whether *widget* has a **Gnome::Gdk3::Window** of its own. Note that all realized widgets have a non-`Any` “window” pointer (`gtk_widget_get_window()` never returns a `Any` window when a widget is realized), but for many of them it’s actually the **Gnome::Gdk3::Window** of one of its parent widgets. Widgets that do not create a `window` for themselves in sig `realize` must announce this by calling this function with *has_window* = `0`.

This function should only be called by widget implementations, and they should call it in their `init()` function.

Since: 2.18

    method gtk_widget_set_has_window ( Int $has_window )

  * Int $has_window; whether or not *widget* has a window.

[[gtk_] widget_] get_has_window
-------------------------------

Determines whether *widget* has a **Gnome::Gdk3::Window** of its own. See `gtk_widget_set_has_window()`.

Returns: `1` if *widget* has a window, `0` otherwise

Since: 2.18

    method gtk_widget_get_has_window ( --> Int  )

[[gtk_] widget_] is_toplevel
----------------------------

Determines whether *widget* is a toplevel widget.

Currently only **Gnome::Gtk3::Window** and **Gnome::Gtk3::Invisible** (and out-of-process **Gnome::Gtk3::Plugs**) are toplevel widgets. Toplevel widgets have no parent widget.

Returns: `1` if *widget* is a toplevel, `0` otherwise

Since: 2.18

    method gtk_widget_is_toplevel ( --> Int  )

[[gtk_] widget_] is_drawable
----------------------------

Determines whether *widget* can be drawn to. A widget can be drawn to if it is mapped and visible.

Returns: `1` if *widget* is drawable, `0` otherwise

Since: 2.18

    method gtk_widget_is_drawable ( --> Int  )

[[gtk_] widget_] set_realized
-----------------------------

Marks the widget as being realized. This function must only be called after all **Gnome::Gdk3::Windows** for the *widget* have been created and registered.

This function should only ever be called in a derived widget's “realize” or “unrealize” implementation.

Since: 2.20

    method gtk_widget_set_realized ( Int $realized )

  * Int $realized; `1` to mark the widget as realized

[[gtk_] widget_] get_realized
-----------------------------

Determines whether *widget* is realized.

Returns: `1` if *widget* is realized, `0` otherwise

Since: 2.20

    method gtk_widget_get_realized ( --> Int  )

[[gtk_] widget_] set_mapped
---------------------------

Marks the widget as being realized.

This function should only ever be called in a derived widget's “map” or “unmap” implementation.

Since: 2.20

    method gtk_widget_set_mapped ( Int $mapped )

  * Int $mapped; `1` to mark the widget as mapped

[[gtk_] widget_] get_mapped
---------------------------

Whether the widget is mapped.

Returns: `1` if the widget is mapped, `0` otherwise.

Since: 2.20

    method gtk_widget_get_mapped ( --> Int  )

[[gtk_] widget_] set_app_paintable
----------------------------------

Sets whether the application intends to draw on the widget in an sig `draw` handler.

This is a hint to the widget and does not affect the behavior of the GTK+ core; many widgets ignore this flag entirely. For widgets that do pay attention to the flag, such as **Gnome::Gtk3::EventBox** and **Gnome::Gtk3::Window**, the effect is to suppress default themed drawing of the widget's background. (Children of the widget will still be drawn.) The application is then entirely responsible for drawing the widget background.

Note that the background is still drawn when the widget is mapped.

    method gtk_widget_set_app_paintable ( Int $app_paintable )

  * Int $app_paintable; `1` if the application will paint on the widget

[[gtk_] widget_] get_app_paintable
----------------------------------

Determines whether the application intends to draw on the widget in an sig `draw` handler.

See `gtk_widget_set_app_paintable()`

Returns: `1` if the widget is app paintable

Since: 2.18

    method gtk_widget_get_app_paintable ( --> Int  )

[[gtk_] widget_] set_redraw_on_allocate
---------------------------------------

Sets whether the entire widget is queued for drawing when its size allocation changes. By default, this setting is `1` and the entire widget is redrawn on every size change. If your widget leaves the upper left unchanged when made bigger, turning this setting off will improve performance. Note that for widgets where `gtk_widget_get_has_window()` is `0` setting this flag to `0` turns off all allocation on resizing: the widget will not even redraw if its position changes; this is to allow containers that don’t draw anything to avoid excess invalidations. If you set this flag on a widget with no window that does draw on *widget*->window, you are responsible for invalidating both the old and new allocation of the widget when the widget is moved and responsible for invalidating regions newly when the widget increases size.

    method gtk_widget_set_redraw_on_allocate ( Int $redraw_on_allocate )

  * Int $redraw_on_allocate; if `1`, the entire widget will be redrawn when it is allocated to a new size. Otherwise, only the new portion of the widget will be redrawn.

[[gtk_] widget_] set_parent
---------------------------

This function is useful only when implementing subclasses of **Gnome::Gtk3::Container**. Sets the container as the parent of *widget*, and takes care of some details such as updating the state and style of the child to reflect its new location. The opposite function is `gtk_widget_unparent()`.

    method gtk_widget_set_parent ( N-GObject $parent )

  * N-GObject $parent; parent container

[[gtk_] widget_] get_parent
---------------------------

Returns the parent container of *widget*.

Returns: (transfer none) (nullable): the parent container of *widget*, or `Any`

    method gtk_widget_get_parent ( --> N-GObject  )

[[gtk_] widget_] set_parent_window
----------------------------------

Sets a non default parent window for *widget*.

For **Gnome::Gtk3::Window** classes, setting a *parent_window* effects whether the window is a toplevel window or can be embedded into other widgets.

For **Gnome::Gtk3::Window** classes, this needs to be called before the window is realized.

    method gtk_widget_set_parent_window ( N-GObject $parent_window )

  * N-GObject $parent_window; the new parent window.

[[gtk_] widget_] get_parent_window
----------------------------------

Gets *widget*’s parent window.

Returns: (transfer none): the parent window of *widget*.

    method gtk_widget_get_parent_window ( --> N-GObject  )

[[gtk_] widget_] set_child_visible
----------------------------------

Sets whether *widget* should be mapped along with its when its parent is mapped and *widget* has been shown with `gtk_widget_show()`.

The child visibility can be set for widget before it is added to a container with `gtk_widget_set_parent()`, to avoid mapping children unnecessary before immediately unmapping them. However it will be reset to its default state of `1` when the widget is removed from a container.

Note that changing the child visibility of a widget does not queue a resize on the widget. Most of the time, the size of a widget is computed from all visible children, whether or not they are mapped. If this is not the case, the container can queue a resize itself.

This function is only useful for container implementations and never should be called by an application.

    method gtk_widget_set_child_visible ( Int $is_visible )

  * Int $is_visible; if `1`, *widget* should be mapped along with its parent.

[[gtk_] widget_] get_child_visible
----------------------------------

Gets the value set with `gtk_widget_set_child_visible()`. If you feel a need to use this function, your code probably needs reorganization.

This function is only useful for container implementations and never should be called by an application.

Returns: `1` if the widget is mapped with the parent.

    method gtk_widget_get_child_visible ( --> Int  )

[[gtk_] widget_] set_window
---------------------------

Sets a widget’s window. This function should only be used in a widget’s sig `realize` implementation. The `window` passed is usually either new window created with `gdk_window_new()`, or the window of its parent widget as returned by `gtk_widget_get_parent_window()`.

Widgets must indicate whether they will create their own **Gnome::Gdk3::Window** by calling `gtk_widget_set_has_window()`. This is usually done in the widget’s `init()` function.

Note that this function does not add any reference to *window*.

Since: 2.18

    method gtk_widget_set_window ( N-GObject $window )

  * N-GObject $window; (transfer full): a **Gnome::Gdk3::Window**

[[gtk_] widget_] get_window
---------------------------

Returns the widget’s window if it is realized, `Any` otherwise

Returns: (transfer none) (nullable): *widget*’s window.

Since: 2.14

    method gtk_widget_get_window ( --> N-GObject  )

[[gtk_] widget_] register_window
--------------------------------

Registers a **Gnome::Gdk3::Window** with the widget and sets it up so that the widget receives events for it. Call `gtk_widget_unregister_window()` when destroying the window.

Before 3.8 you needed to call `gdk_window_set_user_data()` directly to set this up. This is now deprecated and you should use `gtk_widget_register_window()` instead. Old code will keep working as is, although some new features like transparency might not work perfectly.

Since: 3.8

    method gtk_widget_register_window ( N-GObject $window )

  * N-GObject $window; a **Gnome::Gdk3::Window**

[[gtk_] widget_] unregister_window
----------------------------------

Unregisters a **Gnome::Gdk3::Window** from the widget that was previously set up with `gtk_widget_register_window()`. You need to call this when the window is no longer used by the widget, such as when you destroy it.

Since: 3.8

    method gtk_widget_unregister_window ( N-GObject $window )

  * N-GObject $window; a **Gnome::Gdk3::Window**

[[gtk_] widget_] get_allocated_width
------------------------------------

Returns the width that has currently been allocated to *widget*. This function is intended to be used when implementing handlers for the sig `draw` function.

Returns: the width of the *widget*

    method gtk_widget_get_allocated_width ( --> int32  )

[[gtk_] widget_] get_allocated_height
-------------------------------------

Returns the height that has currently been allocated to *widget*. This function is intended to be used when implementing handlers for the sig `draw` function.

Returns: the height of the *widget*

    method gtk_widget_get_allocated_height ( --> int32  )

[[gtk_] widget_] get_allocated_baseline
---------------------------------------

Returns the baseline that has currently been allocated to *widget*. This function is intended to be used when implementing handlers for the sig `draw` function, and when allocating child widgets in sig `size_allocate`.

Returns: the baseline of the *widget*, or -1 if none

Since: 3.10

    method gtk_widget_get_allocated_baseline ( --> int32  )

[[gtk_] widget_] get_allocated_size
-----------------------------------

Retrieves the widget’s allocated size.

This function returns the last values passed to `gtk_widget_size_allocate_with_baseline()`. The value differs from the size returned in `gtk_widget_get_allocation()` in that functions like `gtk_widget_set_halign()` can adjust the allocation, but not the value returned by this function.

If a widget is not visible, its allocated size is 0.

Since: 3.20

    method gtk_widget_get_allocated_size ( GtkAllocation $allocation, int32 $baseline )

  * GtkAllocation $allocation; (out): a pointer to a **Gnome::Gtk3::Allocation** to copy to

  * int32 $baseline; (out) (allow-none): a pointer to an integer to copy to

[[gtk_] widget_] get_allocation
-------------------------------

Retrieves the widget’s allocation.

Note, when implementing a **Gnome::Gtk3::Container**: a widget’s allocation will be its “adjusted” allocation, that is, the widget’s parent container typically calls `gtk_widget_size_allocate()` with an allocation, and that allocation is then adjusted (to handle margin and alignment for example) before assignment to the widget. `gtk_widget_get_allocation()` returns the adjusted allocation that was actually assigned to the widget. The adjusted allocation is guaranteed to be completely contained within the `gtk_widget_size_allocate()` allocation, however. So a **Gnome::Gtk3::Container** is guaranteed that its children stay inside the assigned bounds, but not that they have exactly the bounds the container assigned. There is no way to get the original allocation assigned by `gtk_widget_size_allocate()`, since it isn’t stored; if a container implementation needs that information it will have to track it itself.

Since: 2.18

    method gtk_widget_get_allocation ( GtkAllocation $allocation )

  * GtkAllocation $allocation; (out): a pointer to a **Gnome::Gtk3::Allocation** to copy to

[[gtk_] widget_] set_allocation
-------------------------------

Sets the widget’s allocation. This should not be used directly, but from within a widget’s size_allocate method.

The allocation set should be the “adjusted” or actual allocation. If you’re implementing a **Gnome::Gtk3::Container**, you want to use `gtk_widget_size_allocate()` instead of `gtk_widget_set_allocation()`. The **Gnome::Gtk3::WidgetClass**::adjust_size_allocation virtual method adjusts the allocation inside `gtk_widget_size_allocate()` to create an adjusted allocation.

Since: 2.18

    method gtk_widget_set_allocation ( GtkAllocation $allocation )

  * GtkAllocation $allocation; a pointer to a **Gnome::Gtk3::Allocation** to copy from

[[gtk_] widget_] set_clip
-------------------------

Sets the widget’s clip. This must not be used directly, but from within a widget’s size_allocate method. It must be called after `gtk_widget_set_allocation()` (or after chaining up to the parent class), because that function resets the clip.

The clip set should be the area that *widget* draws on. If *widget* is a **Gnome::Gtk3::Container**, the area must contain all children's clips.

If this function is not called by *widget* during a ::size-allocate handler, the clip will be set to *widget*'s allocation.

Since: 3.14

    method gtk_widget_set_clip ( GtkAllocation $clip )

  * GtkAllocation $clip; a pointer to a **Gnome::Gtk3::Allocation** to copy from

[[gtk_] widget_] get_clip
-------------------------

Retrieves the widget’s clip area.

The clip area is the area in which all of *widget*'s drawing will happen. Other toolkits call it the bounding box.

Historically, in GTK+ the clip area has been equal to the allocation retrieved via `gtk_widget_get_allocation()`.

Since: 3.14

    method gtk_widget_get_clip ( GtkAllocation $clip )

  * GtkAllocation $clip; (out): a pointer to a **Gnome::Gtk3::Allocation** to copy to

[[gtk_] widget_] child_focus
----------------------------

This function is used by custom widget implementations; if you're writing an app, you’d use `gtk_widget_grab_focus()` to move the focus to a particular widget, and `gtk_container_set_focus_chain()` to change the focus tab order. So you may want to investigate those functions instead.

`gtk_widget_child_focus()` is called by containers as the user moves around the window using keyboard shortcuts. *direction* indicates what kind of motion is taking place (up, down, left, right, tab forward, tab backward). `gtk_widget_child_focus()` emits the sig `focus` signal; widgets override the default handler for this signal in order to implement appropriate focus behavior.

The default ::focus handler for a widget should return `1` if moving in *direction* left the focus on a focusable location inside that widget, and `0` if moving in *direction* moved the focus outside the widget. If returning `1`, widgets normally call `gtk_widget_grab_focus()` to place the focus accordingly; if returning `0`, they don’t modify the current focus location.

Returns: `1` if focus ended up inside *widget*

    method gtk_widget_child_focus ( GtkDirectionType $direction --> Int  )

  * GtkDirectionType $direction; direction of focus movement

[[gtk_] widget_] keynav_failed
------------------------------

This function should be called whenever keyboard navigation within a single widget hits a boundary. The function emits the sig `keynav-failed` signal on the widget and its return value should be interpreted in a way similar to the return value of `gtk_widget_child_focus()`:

When `1` is returned, stay in the widget, the failed keyboard navigation is OK and/or there is nowhere we can/should move the focus to.

When `0` is returned, the caller should continue with keyboard navigation outside the widget, e.g. by calling `gtk_widget_child_focus()` on the widget’s toplevel.

The default ::keynav-failed handler returns `1` for `GTK_DIR_TAB_FORWARD` and `GTK_DIR_TAB_BACKWARD`. For the other values of **Gnome::Gtk3::DirectionType** it returns `0`.

Whenever the default handler returns `1`, it also calls `gtk_widget_error_bell()` to notify the user of the failed keyboard navigation.

A use case for providing an own implementation of ::keynav-failed (either by connecting to it or by overriding it) would be a row of **Gnome::Gtk3::Entry** widgets where the user should be able to navigate the entire row with the cursor keys, as e.g. known from user interfaces that require entering license keys.

Returns: `1` if stopping keyboard navigation is fine, `0` if the emitting widget should try to handle the keyboard navigation attempt in its parent container(s).

Since: 2.12

    method gtk_widget_keynav_failed ( GtkDirectionType $direction --> Int  )

  * GtkDirectionType $direction; direction of focus movement

[[gtk_] widget_] error_bell
---------------------------

Notifies the user about an input-related error on this widget. If the prop `gtk-error-bell` setting is `1`, it calls `gdk_window_beep()`, otherwise it does nothing.

Note that the effect of `gdk_window_beep()` can be configured in many ways, depending on the windowing backend and the desktop environment or window manager that is used.

Since: 2.12

    method gtk_widget_error_bell ( )

[[gtk_] widget_] set_size_request
---------------------------------

Sets the minimum size of a widget; that is, the widget’s size request will be at least *width* by *height*. You can use this function to force a widget to be larger than it normally would be.

In most cases, `gtk_window_set_default_size()` is a better choice for toplevel windows than this function; setting the default size will still allow users to shrink the window. Setting the size request will force them to leave the window at least as large as the size request. When dealing with window sizes, `gtk_window_set_geometry_hints()` can be a useful function as well.

Note the inherent danger of setting any fixed size - themes, translations into other languages, different fonts, and user action can all change the appropriate size for a given widget. So, it's basically impossible to hardcode a size that will always be correct.

The size request of a widget is the smallest size a widget can accept while still functioning well and drawing itself correctly. However in some strange cases a widget may be allocated less than its requested size, and in many cases a widget may be allocated more space than it requested.

If the size request in a given direction is -1 (unset), then the “natural” size request of the widget will be used instead.

The size request set here does not include any margin from the **Gnome::Gtk3::Widget** properties margin-left, margin-right, margin-top, and margin-bottom, but it does include pretty much all other padding or border properties set by any subclass of **Gnome::Gtk3::Widget**.

    method gtk_widget_set_size_request ( Int $width, Int $height )

  * Int $width; width *widget* should request, or -1 to unset

  * Int $height; height *widget* should request, or -1 to unset

[[gtk_] widget_] get_size_request
---------------------------------

Gets the size request that was explicitly set for the widget using `gtk_widget_set_size_request()`. A value of -1 stored in *width* or *height* indicates that that dimension has not been set explicitly and the natural requisition of the widget will be used instead. See `gtk_widget_set_size_request()`. To get the size a widget will actually request, call `gtk_widget_get_preferred_size()` instead of this function.

    method gtk_widget_get_size_request ( Int $width, Int $height )

  * Int $width; (out) (allow-none): return location for width, or `Any`

  * Int $height; (out) (allow-none): return location for height, or `Any`

[[gtk_] widget_] set_events
---------------------------

Sets the event mask (see **Gnome::Gdk3::EventMask**) for a widget. The event mask determines which events a widget will receive. Keep in mind that different widgets have different default event masks, and by changing the event mask you may disrupt a widget’s functionality, so be careful. This function must be called while a widget is unrealized. Consider `gtk_widget_add_events()` for widgets that are already realized, or if you want to preserve the existing event mask. This function can’t be used with widgets that have no window. (See `gtk_widget_get_has_window()`). To get events on those widgets, place them inside a **Gnome::Gtk3::EventBox** and receive events on the event box.

    method gtk_widget_set_events ( Int $events )

  * Int $events; event mask

[[gtk_] widget_] add_events
---------------------------

Adds the events in the bitfield *events* to the event mask for *widget*. See `gtk_widget_set_events()` and the [input handling overview][event-masks] for details.

    method gtk_widget_add_events ( Int $events )

  * Int $events; an event mask, see **Gnome::Gdk3::EventMask**

[[gtk_] widget_] set_opacity
----------------------------

Request the *widget* to be rendered partially transparent, with opacity 0 being fully transparent and 1 fully opaque. (Opacity values are clamped to the [0,1] range.). This works on both toplevel widget, and child widgets, although there are some limitations:

For toplevel widgets this depends on the capabilities of the windowing system. On X11 this has any effect only on X screens with a compositing manager running. See `gtk_widget_is_composited()`. On Windows it should work always, although setting a window’s opacity after the window has been shown causes it to flicker once on Windows.

For child widgets it doesn’t work if any affected widget has a native window, or disables double buffering.

Since: 3.8

    method gtk_widget_set_opacity ( Num $opacity )

  * Num $opacity; desired opacity, between 0 and 1

[[gtk_] widget_] get_opacity
----------------------------

Fetches the requested opacity for this widget. See `gtk_widget_set_opacity()`.

Returns: the requested opacity for this widget.

Since: 3.8

    method gtk_widget_get_opacity ( --> Num  )

[[gtk_] widget_] set_device_enabled
-----------------------------------

Enables or disables a **Gnome::Gdk3::Device** to interact with *widget* and all its children.

It does so by descending through the **Gnome::Gdk3::Window** hierarchy and enabling the same mask that is has for core events (i.e. the one that `gdk_window_get_events()` returns).

Since: 3.0

    method gtk_widget_set_device_enabled ( N-GObject $device, Int $enabled )

  * N-GObject $device; a **Gnome::Gdk3::Device**

  * Int $enabled; whether to enable the device

[[gtk_] widget_] get_device_enabled
-----------------------------------

Returns whether *device* can interact with *widget* and its children. See `gtk_widget_set_device_enabled()`.

Returns: `1` is *device* is enabled for *widget*

Since: 3.0

    method gtk_widget_get_device_enabled ( N-GObject $device --> Int  )

  * N-GObject $device; a **Gnome::Gdk3::Device**

[[gtk_] widget_] get_toplevel
-----------------------------

This function returns the topmost widget in the container hierarchy *widget* is a part of. If *widget* has no parent widgets, it will be returned as the topmost widget. No reference will be added to the returned widget; it should not be unreferenced.

Note the difference in behavior vs. `gtk_widget_get_ancestor()`; `gtk_widget_get_ancestor (widget, GTK_TYPE_WINDOW)` would return `Any` if *widget* wasn’t inside a toplevel window, and if the window was inside a **Gnome::Gtk3::Window**-derived widget which was in turn inside the toplevel **Gnome::Gtk3::Window**. While the second case may seem unlikely, it actually happens when a **Gnome::Gtk3::Plug** is embedded inside a **Gnome::Gtk3::Socket** within the same application.

To reliably find the toplevel **Gnome::Gtk3::Window**, use `gtk_widget_get_toplevel()` and call `gtk_widget_is_toplevel()` on the result. |[<!-- language="C" --> **Gnome::Gtk3::Widget** *toplevel = gtk_widget_get_toplevel (widget); if (gtk_widget_is_toplevel (toplevel)) { // Perform action on toplevel. } ]|

Returns: (transfer none): the topmost ancestor of *widget*, or *widget* itself if there’s no ancestor.

    method gtk_widget_get_toplevel ( --> N-GObject  )

[[gtk_] widget_] get_ancestor
-----------------------------

Gets the first ancestor of *widget* with type *widget_type*. For example, `gtk_widget_get_ancestor (widget, GTK_TYPE_BOX)` gets the first **Gnome::Gtk3::Box** that’s an ancestor of *widget*. No reference will be added to the returned widget; it should not be unreferenced. See note about checking for a toplevel **Gnome::Gtk3::Window** in the docs for `gtk_widget_get_toplevel()`.

Note that unlike `gtk_widget_is_ancestor()`, `gtk_widget_get_ancestor()` considers *widget* to be an ancestor of itself.

Returns: (transfer none) (nullable): the ancestor widget, or `Any` if not found

    method gtk_widget_get_ancestor ( N-GObject $widget_type --> N-GObject  )

  * N-GObject $widget_type; ancestor type

[[gtk_] widget_] get_visual
---------------------------

Gets the visual that will be used to render *widget*.

Returns: (transfer none): the visual for *widget*

    method gtk_widget_get_visual ( --> N-GObject  )

[[gtk_] widget_] set_visual
---------------------------

Sets the visual that should be used for by widget and its children for creating **Gnome::Gdk3::Windows**. The visual must be on the same **Gnome::Gdk3::Screen** as returned by `gtk_widget_get_screen()`, so handling the sig `screen-changed` signal is necessary.

Setting a new *visual* will not cause *widget* to recreate its windows, so you should call this function before *widget* is realized.

    method gtk_widget_set_visual ( N-GObject $visual )

  * N-GObject $visual; (allow-none): visual to be used or `Any` to unset a previous one

[[gtk_] widget_] get_screen
---------------------------

Get the **Gnome::Gdk3::Screen** from the toplevel window associated with this widget. This function can only be called after the widget has been added to a widget hierarchy with a **Gnome::Gtk3::Window** at the top.

In general, you should only create screen specific resources when a widget has been realized, and you should free those resources when the widget is unrealized.

Returns: (transfer none): the **Gnome::Gdk3::Screen** for the toplevel for this widget.

Since: 2.2

    method gtk_widget_get_screen ( --> N-GObject  )

[[gtk_] widget_] has_screen
---------------------------

Checks whether there is a **Gnome::Gdk3::Screen** is associated with this widget. All toplevel widgets have an associated screen, and all widgets added into a hierarchy with a toplevel window at the top.

Returns: `1` if there is a **Gnome::Gdk3::Screen** associated with the widget.

Since: 2.2

    method gtk_widget_has_screen ( --> Int  )

[[gtk_] widget_] get_scale_factor
---------------------------------

Retrieves the internal scale factor that maps from window coordinates to the actual device pixels. On traditional systems this is 1, on high density outputs, it can be a higher value (typically 2).

See `gdk_window_get_scale_factor()`.

Returns: the scale factor for *widget*

Since: 3.10

    method gtk_widget_get_scale_factor ( --> Int  )

[[gtk_] widget_] get_display
----------------------------

Get the **Gnome::Gdk3::Display** for the toplevel window associated with this widget. This function can only be called after the widget has been added to a widget hierarchy with a **Gnome::Gtk3::Window** at the top.

In general, you should only create display specific resources when a widget has been realized, and you should free those resources when the widget is unrealized.

Returns: (transfer none): the **Gnome::Gdk3::Display** for the toplevel for this widget.

Since: 2.2

    method gtk_widget_get_display ( --> N-GObject  )

[[gtk_] widget_] get_settings
-----------------------------

Gets the settings object holding the settings used for this widget.

Note that this function can only be called when the **Gnome::Gtk3::Widget** is attached to a toplevel, since the settings object is specific to a particular **Gnome::Gdk3::Screen**.

Returns: (transfer none): the relevant **Gnome::Gtk3::Settings** object

    method gtk_widget_get_settings ( --> N-GObject  )

[[gtk_] widget_] get_hexpand
----------------------------

Gets whether the widget would like any available extra horizontal space. When a user resizes a **Gnome::Gtk3::Window**, widgets with expand=TRUE generally receive the extra space. For example, a list or scrollable area or document in your window would often be set to expand.

Containers should use `gtk_widget_compute_expand()` rather than this function, to see whether a widget, or any of its children, has the expand flag set. If any child of a widget wants to expand, the parent may ask to expand also.

This function only looks at the widget’s own hexpand flag, rather than computing whether the entire widget tree rooted at this widget wants to expand.

Returns: whether hexpand flag is set

    method gtk_widget_get_hexpand ( --> Int  )

[[gtk_] widget_] set_hexpand
----------------------------

Sets whether the widget would like any available extra horizontal space. When a user resizes a **Gnome::Gtk3::Window**, widgets with expand=TRUE generally receive the extra space. For example, a list or scrollable area or document in your window would often be set to expand.

Call this function to set the expand flag if you would like your widget to become larger horizontally when the window has extra room.

By default, widgets automatically expand if any of their children want to expand. (To see if a widget will automatically expand given its current children and state, call `gtk_widget_compute_expand()`. A container can decide how the expandability of children affects the expansion of the container by overriding the compute_expand virtual method on **Gnome::Gtk3::Widget**.).

Setting hexpand explicitly with this function will override the automatic expand behavior.

This function forces the widget to expand or not to expand, regardless of children. The override occurs because `gtk_widget_set_hexpand()` sets the hexpand-set property (see `gtk_widget_set_hexpand_set()`) which causes the widget’s hexpand value to be used, rather than looking at children and widget state.

    method gtk_widget_set_hexpand ( Int $expand )

  * Int $expand; whether to expand

[[gtk_] widget_] get_hexpand_set
--------------------------------

Gets whether `gtk_widget_set_hexpand()` has been used to explicitly set the expand flag on this widget.

If hexpand is set, then it overrides any computed expand value based on child widgets. If hexpand is not set, then the expand value depends on whether any children of the widget would like to expand.

There are few reasons to use this function, but it’s here for completeness and consistency.

Returns: whether hexpand has been explicitly set

    method gtk_widget_get_hexpand_set ( --> Int  )

[[gtk_] widget_] set_hexpand_set
--------------------------------

Sets whether the hexpand flag (see `gtk_widget_get_hexpand()`) will be used.

The hexpand-set property will be set automatically when you call `gtk_widget_set_hexpand()` to set hexpand, so the most likely reason to use this function would be to unset an explicit expand flag.

If hexpand is set, then it overrides any computed expand value based on child widgets. If hexpand is not set, then the expand value depends on whether any children of the widget would like to expand.

There are few reasons to use this function, but it’s here for completeness and consistency.

    method gtk_widget_set_hexpand_set ( Int $set )

  * Int $set; value for hexpand-set property

[[gtk_] widget_] get_vexpand
----------------------------

Gets whether the widget would like any available extra vertical space.

See `gtk_widget_get_hexpand()` for more detail.

Returns: whether vexpand flag is set

    method gtk_widget_get_vexpand ( --> Int  )

[[gtk_] widget_] set_vexpand
----------------------------

Sets whether the widget would like any available extra vertical space.

See `gtk_widget_set_hexpand()` for more detail.

    method gtk_widget_set_vexpand ( Int $expand )

  * Int $expand; whether to expand

[[gtk_] widget_] get_vexpand_set
--------------------------------

Gets whether `gtk_widget_set_vexpand()` has been used to explicitly set the expand flag on this widget.

See `gtk_widget_get_hexpand_set()` for more detail.

Returns: whether vexpand has been explicitly set

    method gtk_widget_get_vexpand_set ( --> Int  )

[[gtk_] widget_] set_vexpand_set
--------------------------------

Sets whether the vexpand flag (see `gtk_widget_get_vexpand()`) will be used.

See `gtk_widget_set_hexpand_set()` for more detail.

    method gtk_widget_set_vexpand_set ( Int $set )

  * Int $set; value for vexpand-set property

[[gtk_] widget_] queue_compute_expand
-------------------------------------

Mark *widget* as needing to recompute its expand flags. Call this function when setting legacy expand child properties on the child of a container.

See `gtk_widget_compute_expand()`.

    method gtk_widget_queue_compute_expand ( )

[[gtk_] widget_] compute_expand
-------------------------------

Computes whether a container should give this widget extra space when possible. Containers should check this, rather than looking at `gtk_widget_get_hexpand()` or `gtk_widget_get_vexpand()`.

This function already checks whether the widget is visible, so visibility does not need to be checked separately. Non-visible widgets are not expanded.

The computed expand value uses either the expand setting explicitly set on the widget itself, or, if none has been explicitly set, the widget may expand if some of its children do.

Returns: whether widget tree rooted here should be expanded

    method gtk_widget_compute_expand ( GtkOrientation $orientation --> Int  )

  * GtkOrientation $orientation; expand direction

[[gtk_] widget_] get_support_multidevice
----------------------------------------

Returns `1` if *widget* is multiple pointer aware. See `gtk_widget_set_support_multidevice()` for more information.

Returns: `1` if *widget* is multidevice aware.

    method gtk_widget_get_support_multidevice ( --> Int  )

[[gtk_] widget_] set_support_multidevice
----------------------------------------

Enables or disables multiple pointer awareness. If this setting is `1`, *widget* will start receiving multiple, per device enter/leave events. Note that if custom **Gnome::Gdk3::Windows** are created in sig `realize`, `gdk_window_set_support_multidevice()` will have to be called manually on them.

Since: 3.0

    method gtk_widget_set_support_multidevice ( Int $support_multidevice )

  * Int $support_multidevice; `1` to support input from multiple devices.

[[gtk_] widget_] get_halign
---------------------------

Gets the value of the prop `halign` property.

For backwards compatibility reasons this method will never return `GTK_ALIGN_BASELINE`, but instead it will convert it to `GTK_ALIGN_FILL`. Baselines are not supported for horizontal alignment.

Returns: the horizontal alignment of *widget*

    method gtk_widget_get_halign ( --> GtkAlign  )

[[gtk_] widget_] set_halign
---------------------------

Sets the horizontal alignment of *widget*. See the prop `halign` property.

    method gtk_widget_set_halign ( GtkAlign $align )

  * GtkAlign $align; the horizontal alignment

[[gtk_] widget_] get_valign
---------------------------

Gets the value of the prop `valign` property.

For backwards compatibility reasons this method will never return `GTK_ALIGN_BASELINE`, but instead it will convert it to `GTK_ALIGN_FILL`. If your widget want to support baseline aligned children it must use `gtk_widget_get_valign_with_baseline()`, or `g_object_get (widget, "valign", &value, NULL)`, which will also report the true value.

Returns: the vertical alignment of *widget*, ignoring baseline alignment

    method gtk_widget_get_valign ( --> GtkAlign  )

[[gtk_] widget_] get_valign_with_baseline
-----------------------------------------

Gets the value of the prop `valign` property, including `GTK_ALIGN_BASELINE`.

Returns: the vertical alignment of *widget*

Since: 3.10

    method gtk_widget_get_valign_with_baseline ( --> GtkAlign  )

[[gtk_] widget_] set_valign
---------------------------

Sets the vertical alignment of *widget*. See the prop `valign` property.

    method gtk_widget_set_valign ( GtkAlign $align )

  * GtkAlign $align; the vertical alignment

[[gtk_] widget_] get_margin_start
---------------------------------

Gets the value of the prop `margin-start` property.

Returns: The start margin of *widget*

Since: 3.12

    method gtk_widget_get_margin_start ( --> Int  )

[[gtk_] widget_] set_margin_start
---------------------------------

Sets the start margin of *widget*. See the prop `margin-start` property.

Since: 3.12

    method gtk_widget_set_margin_start ( Int $margin )

  * Int $margin; the start margin

[[gtk_] widget_] get_margin_end
-------------------------------

Gets the value of the prop `margin-end` property.

Returns: The end margin of *widget*

Since: 3.12

    method gtk_widget_get_margin_end ( --> Int  )

[[gtk_] widget_] set_margin_end
-------------------------------

Sets the end margin of *widget*. See the prop `margin-end` property.

Since: 3.12

    method gtk_widget_set_margin_end ( Int $margin )

  * Int $margin; the end margin

[[gtk_] widget_] get_margin_top
-------------------------------

Gets the value of the prop `margin-top` property.

Returns: The top margin of *widget*

Since: 3.0

    method gtk_widget_get_margin_top ( --> Int  )

[[gtk_] widget_] set_margin_top
-------------------------------

Sets the top margin of *widget*. See the prop `margin-top` property.

Since: 3.0

    method gtk_widget_set_margin_top ( Int $margin )

  * Int $margin; the top margin

[[gtk_] widget_] get_margin_bottom
----------------------------------

Gets the value of the prop `margin-bottom` property.

Returns: The bottom margin of *widget*

Since: 3.0

    method gtk_widget_get_margin_bottom ( --> Int  )

[[gtk_] widget_] set_margin_bottom
----------------------------------

Sets the bottom margin of *widget*. See the prop `margin-bottom` property.

Since: 3.0

    method gtk_widget_set_margin_bottom ( Int $margin )

  * Int $margin; the bottom margin

[[gtk_] widget_] get_events
---------------------------

Returns the event mask (see **Gnome::Gdk3::EventMask**) for the widget. These are the events that the widget will receive.

Note: Internally, the widget event mask will be the logical OR of the event mask set through `gtk_widget_set_events()` or `gtk_widget_add_events()`, and the event mask necessary to cater for every **Gnome::Gtk3::EventController** created for the widget.

Returns: event mask for *widget*

    method gtk_widget_get_events ( --> Int  )

[[gtk_] widget_] is_ancestor
----------------------------

Determines whether *widget* is somewhere inside *ancestor*, possibly with intermediate containers.

Returns: `1` if *ancestor* contains *widget* as a child, grandchild, great grandchild, etc.

    method gtk_widget_is_ancestor ( N-GObject $ancestor --> Int  )

  * N-GObject $ancestor; another **Gnome::Gtk3::Widget**

[[gtk_] widget_] translate_coordinates
--------------------------------------

Translate coordinates relative to *src_widget*’s allocation to coordinates relative to *dest_widget*’s allocations. In order to perform this operation, both widgets must be realized, and must share a common toplevel.

Returns: `0` if either widget was not realized, or there was no common ancestor. In this case, nothing is stored in **dest_x* and **dest_y*. Otherwise `1`.

    method gtk_widget_translate_coordinates ( N-GObject $dest_widget, Int $src_x, Int $src_y, Int $dest_x, Int $dest_y --> Int  )

  * N-GObject $dest_widget; a **Gnome::Gtk3::Widget**

  * Int $src_x; X position relative to *src_widget*

  * Int $src_y; Y position relative to *src_widget*

  * Int $dest_x; (out) (optional): location to store X position relative to *dest_widget*

  * Int $dest_y; (out) (optional): location to store Y position relative to *dest_widget*

[[gtk_] widget_] hide_on_delete
-------------------------------

Utility function; intended to be connected to the sig `delete-event` signal on a **Gnome::Gtk3::Window**. The function calls `gtk_widget_hide()` on its argument, then returns `1`. If connected to ::delete-event, the result is that clicking the close button for a window (on the window frame, top right corner usually) will hide but not destroy the window. By default, GTK+ destroys windows when ::delete-event is received.

Returns: `1`

    method gtk_widget_hide_on_delete ( --> Int  )

[[gtk_] widget_] reset_style
----------------------------

Updates the style context of *widget* and all descendants by updating its widget path. **Gnome::Gtk3::Containers** may want to use this on a child when reordering it in a way that a different style might apply to it. See also `gtk_container_get_path_for_child()`.

Since: 3.0

    method gtk_widget_reset_style ( )

[[gtk_] widget_] set_direction
------------------------------

Sets the reading direction on a particular widget. This direction controls the primary direction for widgets containing text, and also the direction in which the children of a container are packed. The ability to set the direction is present in order so that correct localization into languages with right-to-left reading directions can be done. Generally, applications will let the default reading direction present, except for containers where the containers are arranged in an order that is explicitly visual rather than logical (such as buttons for text justification).

If the direction is set to `GTK_TEXT_DIR_NONE`, then the value set by `gtk_widget_set_default_direction()` will be used.

    method gtk_widget_set_direction ( GtkTextDirection $dir )

  * GtkTextDirection $dir; the new direction

[[gtk_] widget_] get_direction
------------------------------

Gets the reading direction for a particular widget. See `gtk_widget_set_direction()`.

Returns: the reading direction for the widget.

    method gtk_widget_get_direction ( --> GtkTextDirection  )

[[gtk_] widget_] set_default_direction
--------------------------------------

Sets the default reading direction for widgets where the direction has not been explicitly set by `gtk_widget_set_direction()`.

    method gtk_widget_set_default_direction ( GtkTextDirection $dir )

  * GtkTextDirection $dir; the new default direction. This cannot be `GTK_TEXT_DIR_NONE`.

[[gtk_] widget_] get_default_direction
--------------------------------------

Obtains the current default reading direction. See `gtk_widget_set_default_direction()`.

Returns: the current default direction.

    method gtk_widget_get_default_direction ( --> GtkTextDirection  )

[[gtk_] widget_] list_mnemonic_labels
-------------------------------------

Returns a newly allocated list of the widgets, normally labels, for which this widget is the target of a mnemonic (see for example, `gtk_label_set_mnemonic_widget()`). The widgets in the list are not individually referenced. If you want to iterate through the list and perform actions involving callbacks that might destroy the widgets, you must call `g_list_foreach (result, (GFunc)g_object_ref, NULL)` first, and then unref all the widgets afterwards. Returns: (element-type **Gnome::Gtk3::Widget**) (transfer container): the list of mnemonic labels; free this list with `g_list_free()` when you are done with it.

Since: 2.4

    method gtk_widget_list_mnemonic_labels ( --> N-GObject  )

[[gtk_] widget_] add_mnemonic_label
-----------------------------------

Adds a widget to the list of mnemonic labels for this widget. (See `gtk_widget_list_mnemonic_labels()`). Note the list of mnemonic labels for the widget is cleared when the widget is destroyed, so the caller must make sure to update its internal state at this point as well, by using a connection to the sig `destroy` signal or a weak notifier.

Since: 2.4

    method gtk_widget_add_mnemonic_label ( N-GObject $label )

  * N-GObject $label; a **Gnome::Gtk3::Widget** that acts as a mnemonic label for *widget*

[[gtk_] widget_] remove_mnemonic_label
--------------------------------------

Removes a widget from the list of mnemonic labels for this widget. (See `gtk_widget_list_mnemonic_labels()`). The widget must have previously been added to the list with `gtk_widget_add_mnemonic_label()`.

Since: 2.4

    method gtk_widget_remove_mnemonic_label ( N-GObject $label )

  * N-GObject $label; a **Gnome::Gtk3::Widget** that was previously set as a mnemonic label for *widget* with `gtk_widget_add_mnemonic_label()`.

[[gtk_] widget_] set_tooltip_window
-----------------------------------

Replaces the default, usually yellow, window used for displaying tooltips with *custom_window*. GTK+ will take care of showing and hiding *custom_window* at the right moment, to behave likewise as the default tooltip window. If *custom_window* is `Any`, the default tooltip window will be used.

If the custom window should have the default theming it needs to have the name “gtk-tooltip”, see `gtk_widget_set_name()`.

Since: 2.12

    method gtk_widget_set_tooltip_window ( N-GObject $custom_window )

  * N-GObject $custom_window; (allow-none): a **Gnome::Gtk3::Window**, or `Any`

[[gtk_] widget_] get_tooltip_window
-----------------------------------

Returns the **Gnome::Gtk3::Window** of the current tooltip. This can be the **Gnome::Gtk3::Window** created by default, or the custom tooltip window set using `gtk_widget_set_tooltip_window()`.

Returns: (transfer none): The **Gnome::Gtk3::Window** of the current tooltip.

Since: 2.12

    method gtk_widget_get_tooltip_window ( --> N-GObject  )

[[gtk_] widget_] trigger_tooltip_query
--------------------------------------

Triggers a tooltip query on the display where the toplevel of *widget* is located. See `gtk_tooltip_trigger_tooltip_query()` for more information.

Since: 2.12

    method gtk_widget_trigger_tooltip_query ( )

[[gtk_] widget_] set_tooltip_text
---------------------------------

Sets *text* as the contents of the tooltip. This function will take care of setting prop `has-tooltip` to `1` and of the default handler for the sig `query-tooltip` signal.

See also the prop `tooltip-text` property and `gtk_tooltip_set_text()`.

Since: 2.12

    method gtk_widget_set_tooltip_text ( Str $text )

  * Str $text; (allow-none): the contents of the tooltip for *widget*

[[gtk_] widget_] get_tooltip_text
---------------------------------

Gets the contents of the tooltip for *widget*.

Returns: (nullable): the tooltip text, or `Any`. You should free the returned string with `g_free()` when done.

Since: 2.12

    method gtk_widget_get_tooltip_text ( --> Str  )

[[gtk_] widget_] set_tooltip_markup
-----------------------------------

Sets *markup* as the contents of the tooltip, which is marked up with the [Pango text markup language](https://developer.gnome.org/pango/stable/PangoMarkupFormat.html).

This function will take care of setting prop `has-tooltip` to `1` and of the default handler for the sig `query-tooltip` signal.

See also the prop `tooltip-markup` property and `gtk_tooltip_set_markup()`.

Since: 2.12

    method gtk_widget_set_tooltip_markup ( Str $markup )

  * Str $markup; (allow-none): the contents of the tooltip for *widget*, or `Any`

[[gtk_] widget_] get_tooltip_markup
-----------------------------------

Gets the contents of the tooltip for *widget*.

Returns: (nullable): the tooltip text, or `Any`. You should free the returned string with `g_free()` when done.

Since: 2.12

    method gtk_widget_get_tooltip_markup ( --> Str  )

[[gtk_] widget_] set_has_tooltip
--------------------------------

Sets the has-tooltip property on *widget* to *has_tooltip*. See prop `has-tooltip` for more information.

Since: 2.12

    method gtk_widget_set_has_tooltip ( Int $has_tooltip )

  * Int $has_tooltip; whether or not *widget* has a tooltip.

[[gtk_] widget_] get_has_tooltip
--------------------------------

Returns the current value of the has-tooltip property. See prop `has-tooltip` for more information.

Returns: current value of has-tooltip on *widget*.

Since: 2.12

    method gtk_widget_get_has_tooltip ( --> Int  )

[[gtk_] widget_] in_destruction
-------------------------------

Returns whether the widget is currently being destroyed. This information can sometimes be used to avoid doing unnecessary work.

Returns: `1` if *widget* is being destroyed

    method gtk_widget_in_destruction ( --> Int  )

[[gtk_] widget_] get_style_context
----------------------------------

Returns the style context associated to *widget*. The returned object is guaranteed to be the same for the lifetime of *widget*.

Returns: (transfer none): a **Gnome::Gtk3::StyleContext**. This memory is owned by *widget* and must not be freed.

    method gtk_widget_get_style_context ( --> N-GObject  )

[[gtk_] widget_] get_path
-------------------------

Returns the **Gnome::Gtk3::WidgetPath** representing the widget. If the widget is not connected to a toplevel widget, a partial path will be created.

Returns: The `N-WidgetPath` representing the widget.

    method gtk_widget_get_path ( --> N-GtkWidgetPath )

[[gtk_] widget_] insert_action_group
------------------------------------

Inserts *group* into *widget*. Children of *widget* that implement **Gnome::Gtk3::Actionable** can then be associated with actions in *group* by setting their “action-name” to *prefix*.`action-name`.

If *group* is `Any`, a previously inserted group for *name* is removed from *widget*.

Since: 3.6

    method gtk_widget_insert_action_group ( Str $name, N-GObject $group )

  * Str $name; the prefix for actions in *group*

  * N-GObject $group; (allow-none): a `GActionGroup`, or `Any`

[[gtk_] widget_] remove_tick_callback
-------------------------------------

Removes a tick callback previously registered with `gtk_widget_add_tick_callback()`.

Since: 3.8

    method gtk_widget_remove_tick_callback ( UInt $id )

  * UInt $id; an id returned by `gtk_widget_add_tick_callback()`

[[gtk_] widget_] init_template
------------------------------

Creates and initializes child widgets defined in templates. This function must be called in the instance initializer for any class which assigned itself a template using `gtk_widget_class_set_template()`

It is important to call this function in the instance initializer of a **Gnome::Gtk3::Widget** subclass and not in `GObject`.`constructed()` or `GObject`.`constructor()` for two reasons.

One reason is that generally derived widgets will assume that parent class composite widgets have been created in their instance initializers.

Another reason is that when calling `g_object_new()` on a widget with composite templates, it’s important to build the composite widgets before the construct properties are set. Properties passed to `g_object_new()` should take precedence over properties set in the private template XML.

Since: 3.10

    method gtk_widget_init_template ( )

[[gtk_] widget_] get_template_child
-----------------------------------

Fetch an object build from the template XML for *widget_type* in this *widget* instance.

This will only report children which were previously declared with `gtk_widget_class_bind_template_child_full()` or one of its variants.

This function is only meant to be called for code which is private to the *widget_type* which declared the child and is meant for language bindings which cannot easily make use of the GObject structure offsets.

Returns: (transfer none): The object built in the template XML with the id *name*

    method gtk_widget_get_template_child ( N-GObject $widget_type, Str $name --> N-GObject  )

  * N-GObject $widget_type; The `GType` to get a template child for

  * Str $name; The “id” of the child defined in the template XML

[[gtk_] widget_] get_action_group
---------------------------------

Retrieves the `GActionGroup` that was registered using *prefix*. The resulting `GActionGroup` may have been registered to *widget* or any **Gnome::Gtk3::Widget** in its ancestry.

If no action group was found matching *prefix*, then `Any` is returned.

Returns: (transfer none) (nullable): A `GActionGroup` or `Any`.

Since: 3.16

    method gtk_widget_get_action_group ( Str $prefix --> N-GObject  )

  * Str $prefix; The “prefix” of the action group.

[[gtk_] widget_] list_action_prefixes
-------------------------------------

Retrieves a %NULL-terminated array of strings containing the prefixes of * #GActionGroup's available to @widget.

    method gtk_widget_list_action_prefixes( --> Array[Str] )

Returns: a `Any` terminated array of strings.

Since: 3.16

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

### destroy

Signals that all holders of a reference to the widget should release the reference that they hold. May result in finalization of the widget if all references are released.

This signal is not suitable for saving widget state.

    method handler (
      Gnome::GObject::Object :widget($object),
      *%user-options
    );

  * $object; the object which received the signal

### show

The *show* signal is emitted when *widget* is shown, for example with `gtk_widget_show()`.

    method handler (
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal.

### hide

The *hide* signal is emitted when *widget* is hidden, for example with `gtk_widget_hide()`.

    method handler (
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal.

### map

The *map* signal is emitted when *widget* is going to be mapped, that is when the widget is visible (which is controlled with `gtk_widget_set_visible()`) and all its parents up to the toplevel widget are also visible. Once the map has occurred, *map-event* will be emitted.

The *map* signal can be used to determine whether a widget will be drawn, for instance it can resume an animation that was stopped during the emission of *unmap*.

    method handler (
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal.

### unmap

The *unmap* signal is emitted when *widget* is going to be unmapped, which means that either it or any of its parents up to the toplevel widget have been set as hidden.

As *unmap* indicates that a widget will not be shown any longer, it can be used to, for example, stop an animation on the widget.

    method handler (
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal.

### realize

The *realize* signal is emitted when *widget* is associated with a **Gnome::Gdk3::Window**, which means that `gtk_widget_realize()` has been called or the widget has been mapped (that is, it is going to be drawn).

    method handler (
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal.

### unrealize

The *unrealize* signal is emitted when the **Gnome::Gdk3::Window** associated with *widget* is destroyed, which means that `gtk_widget_unrealize()` has been called or the widget has been unmapped (that is, it is going to be hidden).

    method handler (
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal.

### size-allocate

    method handler (
      N-GObject $allocation,
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal.

  * $allocation; (a native **Gnome::Gtk3::Allocation**): the region which has been allocated to the widget.

### state-flags-changed

The *state-flags-changed* signal is emitted when the widget state changes, see `gtk_widget_get_state_flags()`.

Since: 3.0

    method handler (
      Int $flags,
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal.

  * $flags; The previous state flags of GtkStateFlags type.

### parent-set

The *parent-set* signal is emitted when a new parent has been set on a widget.

    method handler (
      N-GObject $old_parent,
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object on which the signal is emitted

  * $old_parent; (allow-none): the previous parent, or `Any` if the widget just got its initial parent.

### hierarchy-changed

The *hierarchy-changed* signal is emitted when the anchored state of a widget changes. A widget is “anchored” when its toplevel ancestor is a **Gnome::Gtk3::Window**. This signal is emitted when a widget changes from un-anchored to anchored or vice-versa.

    method handler (
      N-GObject $previous_toplevel,
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object on which the signal is emitted

  * $previous_toplevel; (allow-none): the previous toplevel ancestor, or `Any` if the widget was previously unanchored

### style-updated

The *style-updated* signal is a convenience signal that is emitted when the *changed* signal is emitted on the *widget*'s associated **Gnome::Gtk3::StyleContext** as returned by `gtk_widget_get_style_context()`.

Note that style-modifying functions like `gtk_widget_override_color()` also cause this signal to be emitted.

Since: 3.0

    method handler (
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object on which the signal is emitted

### direction-changed

The *direction-changed* signal is emitted when the text direction of a widget changes.

    method handler (
      Int $previous_direction,
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object on which the signal is emitted

  * $previous_direction; the previous text direction of *widget*, a GtkTextDirection.

### grab-notify

The *grab-notify* signal is emitted when a widget becomes shadowed by a GTK+ grab (not a pointer or keyboard grab) on another widget, or when it becomes unshadowed due to a grab being removed.

A widget is shadowed by a `gtk_grab_add()` when the topmost grab widget in the grab stack of its window group is not its ancestor.

    method handler (
      Int $was_grabbed,
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal

  * $was_grabbed; `0` if the widget becomes shadowed, `1` if it becomes unshadowed

### grab-focus

    method handler (
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal.

### focus

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      Int $direction,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal, a GtkDirectionType.

  * $direction;

### move-focus

    method handler (
      Int $direction,
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal, a GtkDirectionType.

  * $direction;

### keynav-failed

Gets emitted if keyboard navigation fails. See `gtk_widget_keynav_failed()` for details.

Returns: `1` if stopping keyboard navigation is fine, `0` if the emitting widget should try to handle the keyboard navigation attempt in its parent container(s).

Since: 2.12

    method handler (
      Int $direction,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $direction; the direction of movement, a GtkDirectionType.

### event

The GTK+ main loop will emit three signals for each GDK event delivered to a widget: one generic *event* signal, another, more specific, signal that matches the type of event delivered (e.g. *key-press-event*) and finally a generic *event-after* signal.

Returns: `1` to stop other handlers from being invoked for the event and to cancel the emission of the second specific *event* signal. `0` to propagate the event further and to allow the emission of the second signal. The *event-after* signal is emitted regardless of the return value.

    method handler (
      GdkEvent $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal.

  * $event; the event which triggered this signal

### event-after

After the emission of the *event* signal and (optionally) the second more specific signal, *event-after* will be emitted regardless of the previous two signals handlers return values.

    method handler (
      GdkEvent $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal.

  * $event; the event which triggered this signal

### button-press-event

The *button-press-event* signal will be emitted when a button (typically from a mouse) is pressed.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_BUTTON_PRESS_MASK** mask.

This signal will be sent to the grab widget if there is one.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventButton $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal.

  * $event; the event which triggered this signal.

### button-release-event

The *button-release-event* signal will be emitted when a button (typically from a mouse) is released.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_BUTTON_RELEASE_MASK** mask.

This signal will be sent to the grab widget if there is one.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventButton $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal.

  * $event; the event which triggered this signal.

### scroll-event

The *scroll-event* signal is emitted when a button in the 4 to 7 range is pressed. Wheel mice are usually configured to generate button press events for buttons 4 and 5 when the wheel is turned.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_SCROLL_MASK** mask.

This signal will be sent to the grab widget if there is one.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventScroll $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal.

  * $event; the event which triggered this signal.

### motion-notify-event

The *motion-notify-event* signal is emitted when the pointer moves over the widget's **Gnome::Gdk3::Window**.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_POINTER_MOTION_MASK** mask.

This signal will be sent to the grab widget if there is one.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventMotion $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal.

  * $event; the event which triggered this signal.

### composited-changed

The *composited-changed* signal is emitted when the composited status of *widgets* screen changes. See `gdk_screen_is_composited()`.

    method handler (
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object on which the signal is emitted

### delete-event

The *delete-event* signal is emitted if a user requests that a toplevel window is closed. The default handler for this signal destroys the window. Connecting `gtk_widget_hide_on_delete()` to this signal will cause the window to be hidden instead, so that it can later be shown again without reconstructing it.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEvent $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal

  * $event; the event which triggered this signal

### destroy-event

The *destroy-event* signal is emitted when a **Gnome::Gdk3::Window** is destroyed. You rarely get this signal, because most widgets disconnect themselves from their window before they destroy it, so no widget owns the window at destroy time.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_STRUCTURE_MASK** mask. GDK will enable this mask automatically for all new windows.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEvent $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal.

  * $event; the event which triggered this signal

### key-press-event

The *key-press-event* signal is emitted when a key is pressed. The signal emission will reoccur at the key-repeat rate when the key is kept pressed.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_KEY_PRESS_MASK** mask.

This signal will be sent to the grab widget if there is one.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventKey $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $event; the event which triggered this signal.

### key-release-event

The *key-release-event* signal is emitted when a key is released.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_KEY_RELEASE_MASK** mask.

This signal will be sent to the grab widget if there is one.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventKey $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $event; the event which triggered this signal.

### enter-notify-event

The *enter-notify-event* will be emitted when the pointer enters the *widget*'s window.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_ENTER_NOTIFY_MASK** mask.

This signal will be sent to the grab widget if there is one.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventCrossing $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $event; the event which triggered this signal.

### leave-notify-event

The *leave-notify-event* will be emitted when the pointer leaves the *widget*'s window.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_LEAVE_NOTIFY_MASK** mask.

This signal will be sent to the grab widget if there is one.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventCrossing $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $event; the event which triggered this signal.

### configure-event

The *configure-event* signal will be emitted when the size, position or stacking of the *widget*'s window has changed.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_STRUCTURE_MASK** mask. GDK will enable this mask automatically for all new windows.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventConfigure $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $event; the event which triggered this signal.

### focus-in-event

The *focus-in-event* signal will be emitted when the keyboard focus enters the *widget*'s window.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_FOCUS_CHANGE_MASK** mask.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventFocus $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $event; the event which triggered this signal.

### focus-out-event

The *focus-out-event* signal will be emitted when the keyboard focus leaves the *widget*'s window.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_FOCUS_CHANGE_MASK** mask.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventFocus $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $event; the event which triggered this signal.

### map-event

The *map-event* signal will be emitted when the *widget*'s window is mapped. A window is mapped when it becomes visible on the screen.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_STRUCTURE_MASK** mask. GDK will enable this mask automatically for all new windows.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventAny $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $event; the event which triggered this signal.

### unmap-event

The *unmap-event* signal will be emitted when the *widget*'s window is unmapped. A window is unmapped when it becomes invisible on the screen.

To receive this signal, the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_STRUCTURE_MASK** mask. GDK will enable this mask automatically for all new windows.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventAny $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $event; the event which triggered this signal.

### proximity-in-event

To receive this signal the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_PROXIMITY_IN_MASK** mask.

This signal will be sent to the grab widget if there is one.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventProximity $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal

  * $event; the event which triggered this signal.

### proximity-out-event

To receive this signal the **Gnome::Gdk3::Window** associated to the widget needs to enable the **GDK_PROXIMITY_OUT_MASK** mask.

This signal will be sent to the grab widget if there is one.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      GdkEventProximity $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $event; the event which triggered this signal.

### grab-broken-event

Emitted when a pointer or keyboard grab on a window belonging to *widget* gets broken.

On X11, this happens when the grab window becomes unviewable (i.e. it or one of its ancestors is unmapped), or if the same application grabs the pointer or keyboard again.

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

Since: 2.8

    method handler (
      GdkEventGrabBroken $event,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $event; the event which triggered this signal.

### query-tooltip

Emitted when *has-tooltip* is `1` and the hover timeout has expired with the cursor hovering "above" *widget*; or emitted when *widget* got focus in keyboard mode.

Using the given coordinates, the signal handler should determine whether a tooltip should be shown for *widget*. If this is the case `1` should be returned, `0` otherwise. Note that if *keyboard_mode* is `1`, the values of *x* and *y* are undefined and should not be used.

The signal handler is free to manipulate *tooltip* with the therefore destined function calls.

Returns: `1` if *tooltip* should be shown right now, `0` otherwise.

Since: 2.12

    method handler (
      Int $x,
      Int $y,
      Int $keyboard_mode,
      N-GObject $tooltip,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $x; the x coordinate of the cursor position where the request has been emitted, relative to *widget*'s left side

  * $y; the y coordinate of the cursor position where the request has been emitted, relative to *widget*'s top

  * $keyboard_mode; `1` if the tooltip was triggered using the keyboard

  * $tooltip; a native Gnome::Gtk3::Tooltip

### popup-menu

This signal gets emitted whenever a widget should pop up a context menu. This usually happens through the standard key binding mechanism; by pressing a certain key while a widget is focused, the user can cause the widget to pop up a menu. For example, the **Gnome::Gtk3::Entry** widget creates a menu with clipboard commands. See the [Popup Menu Migration Checklist](https://developer.gnome.org/gtk3/3.24/gtk-migrating-checklist.html#checklist-popup-menu) for an example of how to use this signal.

Returns: `1` if a menu was activated

    method handler (
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

### show-help

Returns: `1` to stop other handlers from being invoked for the event. `0` to propagate the event further.

    method handler (
      Int $help_type,
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal.

  * $help_type; a GtkWidgetHelpType

### accel-closures-changed

    method handler (
      Gnome::GObject::Object :widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal.

### screen-changed

The *screen-changed* signal gets emitted when the screen of a widget has changed.

    method handler (
      N-GObject $previous_screen,
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object on which the signal is emitted

  * $previous_screen; the previous screen, or `Any` if the widget was not associated with a screen before. It is a native Gnome::Gdk3::Screen object.

### can-activate-accel

Determines whether an accelerator that activates the signal identified by *signal_id* can currently be activated. This signal is present to allow applications and derived widgets to override the default **Gnome::Gtk3::Widget** handling for determining whether an accelerator can be activated.

Returns: `1` if the signal can be activated.

    method handler (
      UInt $signal_id,
      Gnome::GObject::Object :widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal

  * $signal_id; the ID of a signal installed on *widget*

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Widget name

The name of the widget Default value: Any

The **Gnome::GObject::Value** type of property *name* is `G_TYPE_STRING`.

### Width request

The **Gnome::GObject::Value** type of property *width-request* is `G_TYPE_INT`.

### Height request

The **Gnome::GObject::Value** type of property *height-request* is `G_TYPE_INT`.

### Visible

Whether the widget is visible Default value: False

The **Gnome::GObject::Value** type of property *visible* is `G_TYPE_BOOLEAN`.

### Sensitive

Whether the widget responds to input Default value: True

The **Gnome::GObject::Value** type of property *sensitive* is `G_TYPE_BOOLEAN`.

### Application paintable

Whether the application will paint directly on the widget Default value: False

The **Gnome::GObject::Value** type of property *app-paintable* is `G_TYPE_BOOLEAN`.

### Can focus

Whether the widget can accept the input focus Default value: False

The **Gnome::GObject::Value** type of property *can-focus* is `G_TYPE_BOOLEAN`.

### Has focus

Whether the widget has the input focus Default value: False

The **Gnome::GObject::Value** type of property *has-focus* is `G_TYPE_BOOLEAN`.

### Is focus

Whether the widget is the focus widget within the toplevel Default value: False

The **Gnome::GObject::Value** type of property *is-focus* is `G_TYPE_BOOLEAN`.

### Focus on click

Whether the widget should grab focus when it is clicked with the mouse. This property is only relevant for widgets that can take focus. Before 3.20, several widgets (**Gnome::Gtk3::Button**, **Gnome::Gtk3::FileChooserButton**, **Gnome::Gtk3::ComboBox**) implemented this property individually. Since: 3.20

The **Gnome::GObject::Value** type of property *focus-on-click* is `G_TYPE_BOOLEAN`.

### Can default

Whether the widget can be the default widget Default value: False

The **Gnome::GObject::Value** type of property *can-default* is `G_TYPE_BOOLEAN`.

### Has default

Whether the widget is the default widget Default value: False

The **Gnome::GObject::Value** type of property *has-default* is `G_TYPE_BOOLEAN`.

### Receives default

If TRUE, the widget will receive the default action when it is focused Default value: False

The **Gnome::GObject::Value** type of property *receives-default* is `G_TYPE_BOOLEAN`.

### Composite child

Whether the widget is part of a composite widget Default value: False

The **Gnome::GObject::Value** type of property *composite-child* is `G_TYPE_BOOLEAN`.

### Events

The **Gnome::GObject::Value** type of property *events* is `G_TYPE_FLAGS`.

### No show all

Whether gtk_widget_show_all( should not affect this widget) Default value: False

The **Gnome::GObject::Value** type of property *no-show-all* is `G_TYPE_BOOLEAN`.

### Has tooltip

Enables or disables the emission of *query-tooltip* on *widget*. A value of `1` indicates that *widget* can have a tooltip, in this case the widget will be queried using *query-tooltip* to determine whether it will provide a tooltip or not. Note that setting this property to `1` for the first time will change the event masks of the **Gnome::Gdk3::Windows** of this widget to include leave-notify and motion-notify events. This cannot and will not be undone when the property is set to `0` again. Since: 2.12

The **Gnome::GObject::Value** type of property *has-tooltip* is `G_TYPE_BOOLEAN`.

### Tooltip Text

Sets the text of tooltip to be the given string. Also see `gtk_tooltip_set_text()`. This is a convenience property which will take care of getting the tooltip shown if the given string is not `Any`: *has-tooltip* will automatically be set to `1` and there will be taken care of *query-tooltip* in the default signal handler. Note that if both *tooltip-text* and *tooltip-markup* are set, the last one wins. Since: 2.12

The **Gnome::GObject::Value** type of property *tooltip-text* is `G_TYPE_STRING`.

### Tooltip markup

Sets the text of tooltip to be the given string, which is marked up with the [Pango text markup language][PangoMarkupFormat]. Also see `gtk_tooltip_set_markup()`. This is a convenience property which will take care of getting the tooltip shown if the given string is not `Any`: *has-tooltip* will automatically be set to `1` and there will be taken care of *query-tooltip* in the default signal handler. Note that if both *tooltip-text* and *tooltip-markup* are set, the last one wins. Since: 2.12

The **Gnome::GObject::Value** type of property *tooltip-markup* is `G_TYPE_STRING`.

### Window

The widget's window if it is realized, `Any` otherwise. Since: 2.14 Widget type: GDK_TYPE_WINDOW

The **Gnome::GObject::Value** type of property *window* is `G_TYPE_OBJECT`.

### Horizontal Alignment

How to distribute horizontal space if widget gets extra space, see **Gnome::Gtk3::Align** Since: 3.0 Widget type: GTK_TYPE_ALIGN

The **Gnome::GObject::Value** type of property *halign* is `G_TYPE_ENUM`.

### Vertical Alignment

How to distribute vertical space if widget gets extra space, see **Gnome::Gtk3::Align** Since: 3.0 Widget type: GTK_TYPE_ALIGN

The **Gnome::GObject::Value** type of property *valign* is `G_TYPE_ENUM`.

### Margin on Start

Margin on start of widget, horizontally. This property supports left-to-right and right-to-left text directions. This property adds margin outside of the widget's normal size request, the margin will be added in addition to the size from `gtk_widget_set_size_request()` for example. Since: 3.12

The **Gnome::GObject::Value** type of property *margin-start* is `G_TYPE_INT`.

### Margin on End

Margin on end of widget, horizontally. This property supports left-to-right and right-to-left text directions. This property adds margin outside of the widget's normal size request, the margin will be added in addition to the size from `gtk_widget_set_size_request()` for example. Since: 3.12

The **Gnome::GObject::Value** type of property *margin-end* is `G_TYPE_INT`.

### Margin on Top

Margin on top side of widget. This property adds margin outside of the widget's normal size request, the margin will be added in addition to the size from `gtk_widget_set_size_request()` for example. Since: 3.0

The **Gnome::GObject::Value** type of property *margin-top* is `G_TYPE_INT`.

### Margin on Bottom

Margin on bottom side of widget. This property adds margin outside of the widget's normal size request, the margin will be added in addition to the size from `gtk_widget_set_size_request()` for example. Since: 3.0

The **Gnome::GObject::Value** type of property *margin-bottom* is `G_TYPE_INT`.

### All Margins

Sets all four sides' margin at once. If read, returns max margin on any side. Since: 3.0

The **Gnome::GObject::Value** type of property *margin* is `G_TYPE_INT`.

### Horizontal Expand

Whether to expand horizontally. See `gtk_widget_set_hexpand()`. Since: 3.0

The **Gnome::GObject::Value** type of property *hexpand* is `G_TYPE_BOOLEAN`.

### Horizontal Expand Set

Whether to use the *hexpand* property. See `gtk_widget_get_hexpand_set()`. Since: 3.0

The **Gnome::GObject::Value** type of property *hexpand-set* is `G_TYPE_BOOLEAN`.

### Vertical Expand

Whether to expand vertically. See `gtk_widget_set_vexpand()`. Since: 3.0

The **Gnome::GObject::Value** type of property *vexpand* is `G_TYPE_BOOLEAN`.

### Vertical Expand Set

Whether to use the *vexpand* property. See `gtk_widget_get_vexpand_set()`. Since: 3.0

The **Gnome::GObject::Value** type of property *vexpand-set* is `G_TYPE_BOOLEAN`.

### Expand Both

Whether to expand in both directions. Setting this sets both *hexpand* and *vexpand* Since: 3.0

The **Gnome::GObject::Value** type of property *expand* is `G_TYPE_BOOLEAN`.

### Opacity for Widget

The requested opacity of the widget. See `gtk_widget_set_opacity()` for more details about window opacity. Before 3.8 this was only available in **Gnome::Gtk3::Window** Since: 3.8

The **Gnome::GObject::Value** type of property *opacity* is `G_TYPE_DOUBLE`.

### Scale factor

The scale factor of the widget. See `gtk_widget_get_scale_factor()` for more details about widget scaling. Since: 3.10

The **Gnome::GObject::Value** type of property *scale-factor* is `G_TYPE_INT`.

