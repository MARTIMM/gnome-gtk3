Gnome::Gtk3::Container
======================

Base class for widgets which contain other widgets

Description
===========

A GTK+ user interface is constructed by nesting widgets inside widgets. Container widgets are the inner nodes in the resulting tree of widgets: they contain other widgets. So, for example, you might have a **Gnome::Gtk3::Window** containing a **Gnome::Gtk3::Frame** containing a **Gnome::Gtk3::Label**. If you wanted an image instead of a textual label inside the frame, you might replace the **Gnome::Gtk3::Label** widget with a **Gnome::Gtk3::Image** widget.

There are two major kinds of container widgets in GTK+. Both are subclasses of the abstract **Gnome::Gtk3::Container** base class.

The first type of container widget has a single child widget and derives from **Gnome::Gtk3::Bin**. These containers are decorators, which add some kind of functionality to the child. For example, a **Gnome::Gtk3::Button** makes its child into a clickable button; a **Gnome::Gtk3::Frame** draws a frame around its child and a **Gnome::Gtk3::Window** places its child widget inside a top-level window.

The second type of container can have more than one child; its purpose is to manage layout. This means that these containers assign sizes and positions to their children. For example, a **Gnome::Gtk3::HBox** arranges its children in a horizontal row, and a **Gnome::Gtk3::Grid** arranges the widgets it contains in a two-dimensional grid.

For implementations of **Gnome::Gtk3::Container** the virtual method **Gnome::Gtk3::ContainerClass**.`forall()` is always required, since it's used for drawing and other internal operations on the children. If the **Gnome::Gtk3::Container** implementation expect to have non internal children it's needed to implement both **Gnome::Gtk3::ContainerClass**.`add()` and **Gnome::Gtk3::ContainerClass**.`remove()`. If the **Gnome::Gtk3::Container** implementation has internal children, they should be added with `gtk_widget_set_parent()` on `init()` and removed with `gtk_widget_unparent()` in the **Gnome::Gtk3::WidgetClass**.`destroy()` implementation. See more about implementing custom widgets at https://wiki.gnome.org/HowDoI/CustomWidgets

Height for width geometry management
------------------------------------

GTK+ uses a height-for-width (and width-for-height) geometry management system. Height-for-width means that a widget can change how much vertical space it needs, depending on the amount of horizontal space that it is given (and similar for width-for-height).

There are some things to keep in mind when implementing container widgets that make use of GTK+’s height for width geometry management system. First, it’s important to note that a container must prioritize one of its dimensions, that is to say that a widget or container can only have a **Gnome::Gtk3::SizeRequestMode** that is `GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH` or `GTK_SIZE_REQUEST_WIDTH_FOR_HEIGHT`. However, every widget and container must be able to respond to the APIs for both dimensions, i.e. even if a widget has a request mode that is height-for-width, it is possible that its parent will request its sizes using the width-for-height APIs.

To ensure that everything works properly, here are some guidelines to follow when implementing height-for-width (or width-for-height) containers.

Each request mode involves 2 virtual methods. Height-for-width apis run through `gtk_widget_get_preferred_width()` and then through `gtk_widget_get_preferred_height_for_width()`. When handling requests in the opposite **Gnome::Gtk3::SizeRequestMode** it is important that every widget request at least enough space to display all of its content at all times.

When `gtk_widget_get_preferred_height()` is called on a container that is height-for-width, the container must return the height for its minimum width. This is easily achieved by simply calling the reverse apis implemented for itself.

Similarly, when `gtk_widget_get_preferred_width_for_height()` is called for a container or widget that is height-for-width, it then only needs to return the base minimum width

Height for width requests are generally implemented in terms of a virtual allocation of widgets in the input orientation. Assuming an height-for-width request mode, a container would implement the `get_preferred_height_for_width()` virtual function by first calling `gtk_widget_get_preferred_width()` for each of its children.

For each potential group of children that are lined up horizontally, the values returned by `gtk_widget_get_preferred_width()` should be collected in an array of **Gnome::Gtk3::RequestedSize** structures. Any child spacing should be removed from the input *for_width* and then the collective size should be allocated using the `gtk_distribute_natural_allocation()` convenience function.

The container will then move on to request the preferred height for each child by using `gtk_widget_get_preferred_height_for_width()` and using the sizes stored in the **Gnome::Gtk3::RequestedSize** array.

To allocate a height-for-width container, it’s again important to consider that a container must prioritize one dimension over the other. So if a container is a height-for-width container it must first allocate all widgets horizontally using a **Gnome::Gtk3::RequestedSize** array and `gtk_distribute_natural_allocation()` and then add any extra space (if and where appropriate) for the widget to expand.

After adding all the expand space, the container assumes it was allocated sufficient height to fit all of its content. At this time, the container must use the total horizontal sizes of each widget to request the height-for-width of each of its children and store the requests in a **Gnome::Gtk3::RequestedSize** array for any widgets that stack vertically (for tabular containers this can be generalized into the heights and widths of rows and columns). The vertical space must then again be distributed using `gtk_distribute_natural_allocation()` while this time considering the allocated height of the widget minus any vertical spacing that the container adds. Then vertical expand space should be added where appropriate and available and the container should go on to actually allocating the child widgets.

See [**Gnome::Gtk3::Widget**’s geometry management section](https://developer.gnome.org/gtk3/3.24/GtkWidget.html#geometry-managementgeometry-management) to learn more about implementing height-for-width geometry management for widgets.

Gnome::Gtk3::Container as Gnome::Gtk3::Buildable
------------------------------------------------

The **Gnome::Gtk3::Container** implementation of the **Gnome::Gtk3::Buildable** interface supports a <packing> element for children, which can contain multiple <property> elements that specify child properties for the child.

Since 2.16, child properties can also be marked as translatable using the same “translatable”, “comments” and “context” attributes that are usedfor regular properties.

Since 3.16, containers can have a <focus-chain> element containing multiple <widget> elements, one for each child that should be added to the focus chain. The ”name” attribute gives the id of the widget.

An example of these properties in UI definitions:

    <object class="GtkBox>">
      <child>
        <object class="GtkEntry>" id="entry1"/>
        <packing>
          <property name="pack-type">start</property>
        </packing>
      </child>
      <child>
        <object class="GtkEntry>" id="entry2"/>
      </child>
      <focus-chain>
        <widget name="entry1"/>
        <widget name="entry2"/>
      </focus-chain>
    </object>

Implemented Interfaces
----------------------

Gnome::Gtk3::Container implements

  * [Gnome::Gtk3::Buildable](Buildable.html)

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Container;
    also is Gnome::Gtk3::Widget;
    also does Gnome::Gtk3::Buildable;

Types
=====

enum GtkResizeMode
------------------

  * GTK_RESIZE_PARENT: Pass resize request to the parent

  * GTK_RESIZE_QUEUE: Queue resizes on this widget

  * GTK_RESIZE_IMMEDIATE: Resize immediately. Deprecated.

Methods
=======

new
---

### multi method new ( N-GObject :$native-object! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

### multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

[[gtk_] container_] set_border_width
------------------------------------

Sets the border width of the container.

The border width of a container is the amount of space to leave around the outside of the container. The only exception to this is **Gnome::Gtk3::Window**; because toplevel windows can’t leave space outside, they leave the space inside. The border is added on all sides of the container. To add space to only one side, use a specific *margin* property on the child widget, for example *margin-top*.

    method gtk_container_set_border_width ( UInt $border_width )

  * UInt $border_width; amount of blank space to leave outside the container. Valid values are in the range 0-65535 pixels.

[[gtk_] container_] get_border_width
------------------------------------

Retrieves the border width of the container. See `gtk_container_set_border_width()`.

Returns: the current border width

    method gtk_container_get_border_width ( --> UInt  )

[gtk_] container_add
--------------------

Adds *widget* to *container*. Typically used for simple containers such as **Gnome::Gtk3::Window**, **Gnome::Gtk3::Frame**, or **Gnome::Gtk3::Button**; for more complicated layout containers such as **Gnome::Gtk3::Box** or **Gnome::Gtk3::Grid**, this function will pick default packing parameters that may not be correct. So consider functions such as `gtk_box_pack_start()` and `gtk_grid_attach()` as an alternative to `gtk_container_add()` in those cases. A widget may be added to only one container at a time; you can’t place the same widget inside two different containers.

Note that some containers, such as **Gnome::Gtk3::ScrolledWindow** or **Gnome::Gtk3::ListBox**, may add intermediate children between the added widget and the container.

    method gtk_container_add ( N-GObject $widget )

  * N-GObject $widget; a widget to be placed inside *container*

[gtk_] container_remove
-----------------------

Removes *widget* from *container*. *widget* must be inside *container*. Note that *container* will own a reference to *widget*, and that this may be the last reference held; so removing a widget from its container can destroy that widget. If you want to use *widget* again, you need to add a reference to it before removing it from a container, using `g_object_ref()`. If you don’t want to use *widget* again it’s usually more efficient to simply destroy it directly using `gtk_widget_destroy()` since this will remove it from the container and help break any circular reference count cycles.

    method gtk_container_remove ( N-GObject $widget )

  * N-GObject $widget; a current child of *container*

[[gtk_] container_] check_resize
--------------------------------

    method gtk_container_check_resize ( )

[gtk_] container_foreach
------------------------

Invokes a callback on each non-internal child of this container. For all practical purposes, this function should iterate over precisely those child widgets that were added to the container by the application with explicit `add()` calls.

    method gtk_container_foreach (
      $callback-object, Str $callback_name, *%user-options
    )

  * $callback-object; Object wherein the callback method is declared

  * Str $callback-name; Name of the callback method

  * %user-options; named arguments which will be provided to the callback

The callback method signature is

    method f ( N-GObject $w, *%user-options )

A small example

    # Define a class for the callback
    class X {
      method cb ( N-GObject $nw, :$test = '???' ) {
        my Gnome::Gtk3::Widget $w .= new(:native-object($nw));
        note "WN: $w.widget-get-name(), $test";
      }
    }

    # Setup a grid with widgets
    Gnome::Gtk3::Grid $grid .= new;
    ... insert some widgets ...

    # Call foreach to walk over all children in the grid
    $grid.container-foreach( X.new, 'cb', :test<abcdef>);

[[gtk_] container_] get_children
--------------------------------

Returns the container’s non-internal children. See `gtk_container_forall()` for details on what constitutes an "internal" child.

Returns: a newly-allocated list of the container’s non-internal children. The type of the elements are native widgets.

    method gtk_container_get_children ( --> N-GList  )

[[gtk_] container_] set_focus_child
-----------------------------------

Sets, or unsets if *child* is `Any`, the focused child of *container*.

This function emits the **Gnome::Gtk3::Container**::set_focus_child signal of *container*. Implementations of **Gnome::Gtk3::Container** can override the default behaviour by overriding the class closure of this signal.

This is function is mostly meant to be used by widgets. Applications can use `gtk_widget_grab_focus()` to manually set the focus to a specific widget.

    method gtk_container_set_focus_child ( N-GObject $child )

  * N-GObject $child; (allow-none): a **Gnome::Gtk3::Widget**, or `Any`

[[gtk_] container_] get_focus_child
-----------------------------------

Returns the current focus child widget inside *container*. This is not the currently focused widget. That can be obtained by calling `gtk_window_get_focus()`.

Returns: (nullable) (transfer none): The child widget which will receive the focus inside *container* when the *container* is focused, or `Any` if none is set.

Since: 2.14

    method gtk_container_get_focus_child ( --> N-GObject  )

[[gtk_] container_] set_focus_vadjustment
-----------------------------------------

Hooks up an adjustment to focus handling in a container, so when a child of the container is focused, the adjustment is scrolled to show that widget. This function sets the vertical alignment. See `gtk_scrolled_window_get_vadjustment()` for a typical way of obtaining the adjustment and `gtk_container_set_focus_hadjustment()` for setting the horizontal adjustment.

The adjustments have to be in pixel units and in the same coordinate system as the allocation for immediate children of the container.

    method gtk_container_set_focus_vadjustment ( N-GObject $adjustment )

  * N-GObject $adjustment; an adjustment which should be adjusted when the focus is moved among the descendents of *container*

[[gtk_] container_] get_focus_vadjustment
-----------------------------------------

Retrieves the vertical focus adjustment for the container. See `gtk_container_set_focus_vadjustment()`.

Returns: (nullable) (transfer none): the vertical focus adjustment, or `Any` if none has been set.

    method gtk_container_get_focus_vadjustment ( --> N-GObject  )

[[gtk_] container_] set_focus_hadjustment
-----------------------------------------

Hooks up an adjustment to focus handling in a container, so when a child of the container is focused, the adjustment is scrolled to show that widget. This function sets the horizontal alignment. See `gtk_scrolled_window_get_hadjustment()` for a typical way of obtaining the adjustment and `gtk_container_set_focus_vadjustment()` for setting the vertical adjustment.

The adjustments have to be in pixel units and in the same coordinate system as the allocation for immediate children of the container.

    method gtk_container_set_focus_hadjustment ( N-GObject $adjustment )

  * N-GObject $adjustment; an adjustment which should be adjusted when the focus is moved among the descendents of *container*

[[gtk_] container_] get_focus_hadjustment
-----------------------------------------

Retrieves the horizontal focus adjustment for the container. See `gtk_container_set_focus_hadjustment()`.

Returns: (nullable) (transfer none): the horizontal focus adjustment, or `Any` if none has been set.

    method gtk_container_get_focus_hadjustment ( --> N-GObject  )

[[gtk_] container_] child_type
------------------------------

Returns the type of the children supported by the container.

Note that this may return `G_TYPE_NONE` to indicate that no more children can be added, e.g. for a **Gnome::Gtk3::Paned** which already has two children.

Returns: a **GType**.

    method gtk_container_child_type ( --> UInt  )

[[gtk_] container_] child_set_property
--------------------------------------

Sets a child property for *child* and *container*.

    method gtk_container_child_set_property ( N-GObject $child, Str $property_name, N-GObject $value )

  * N-GObject $child; a widget which is a child of *container*

  * Str $property_name; the name of the property to set

  * N-GObject $value; the value to set the property to

[[gtk_] container_] child_get_property
--------------------------------------

Gets the value of a child property for *child* and *container*.

    method gtk_container_child_get_property ( N-GObject $child, Str $property_name, N-GObject $value )

  * N-GObject $child; a widget which is a child of *container*

  * Str $property_name; the name of the property to get

  * N-GObject $value; a location to return the value

[[gtk_] container_] child_notify
--------------------------------

Emits a *child-notify* signal for the [child property][child-properties] *child_property* on the child.

This is an analogue of `g_object_notify()` for child properties.

Also see `gtk_widget_child_notify()`.

Since: 3.2

    method gtk_container_child_notify ( N-GObject $child, Str $child_property )

  * N-GObject $child; the child widget

  * Str $child_property; the name of a child property installed on the class of *container*

[[gtk_] container_] get_path_for_child
--------------------------------------

Returns a newly created widget path representing all the widget hierarchy from the toplevel down to and including *child*.

Returns: A newly created **Gnome::Gtk3::WidgetPath**

    method gtk_container_get_path_for_child ( N-GObject $child --> N-GObject  )

  * N-GObject $child; a child of *container*

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

### add

    method handler (
      N-GObject $widget,
      Gnome::GObject::Object :widget($container),
      *%user-options
    );

  * $container; the object that received the signal

  * $widget; the added widget

### remove

    method handler (
      N-GObject $widget,
      Gnome::GObject::Object :widget($container),
      *%user-options
    );

  * $container; the object that received the signal

  * $widget; the removed widget

### check-resize

    method handler (
      Gnome::GObject::Object :widget($container),
      *%user-options
    );

  * $container; the object that received the signal

### set-focus-child

    method handler (
      N-GObject $widget,
      Gnome::GObject::Object :widget($container),
      *%user-options
    );

  * $container; the object that received the signal

  * $widget; the focused widget

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Resize mode

Specify how resize events are handled Default value: False

The **Gnome::GObject::Value** type of property *resize-mode* is `G_TYPE_ENUM`.

### Border width

The **Gnome::GObject::Value** type of property *border-width* is `G_TYPE_UINT`.

