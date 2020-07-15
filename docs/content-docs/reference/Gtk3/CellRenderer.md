Gnome::Gtk3::CellRenderer
=========================

An object for rendering a single cell

Description
===========

The **Gnome::Gtk3::CellRenderer** is a base class of a set of objects used for rendering a cell to a **cairo_t**. These objects are used primarily by the **Gnome::Gtk3::TreeView** widget, though they aren’t tied to them in any specific way. It is worth noting that **Gnome::Gtk3::CellRenderer** is not a **Gnome::Gtk3::Widget** and cannot be treated as such.

The primary use of a **Gnome::Gtk3::CellRenderer** is for drawing certain graphical elements on a **cairo_t**. Typically, one cell renderer is used to draw many cells on the screen. To this extent, it isn’t expected that a CellRenderer keeps any permanent state around. Instead, any state is set just prior to use using **GObjects** property system. Then, the cell is measured using `gtk_cell_renderer_get_size()`. Finally, the cell is rendered in the correct location using `gtk_cell_renderer_render()`.

Many properties of **Gnome::Gtk3::CellRenderer** and its subclasses have a corresponding “set” property, e.g. “cell-background-set” corresponds to “cell-background”. These “set” properties reflect whether a property has been set or not. You should not set them independently.

See Also
--------

**Gnome::Gtk3::CellRendererText**, **Gnome::Gtk3::CellRendererPixbuf**, **Gnome::Gtk3::CellRendererToggle**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::CellRenderer;
    also is Gnome::GObject::InitiallyUnowned;

Types
=====

enum GtkCellRendererState
-------------------------

Tells how a cell is to be rendered.

  * GTK_CELL_RENDERER_SELECTED: The cell is currently selected, and probably has a selection colored background to render to.

  * GTK_CELL_RENDERER_PRELIT: The mouse is hovering over the cell.

  * GTK_CELL_RENDERER_INSENSITIVE: The cell is drawn in an insensitive manner

  * GTK_CELL_RENDERER_SORTED: The cell is in a sorted row

  * GTK_CELL_RENDERER_FOCUSED: The cell is in the focus row.

  * GTK_CELL_RENDERER_EXPANDABLE: The cell is in a row that can be expanded. Since 3.4

  * GTK_CELL_RENDERER_EXPANDED: The cell is in a row that is expanded. Since 3.4

enum GtkCellRendererMode
------------------------

Identifies how the user can interact with a particular cell.

  * GTK_CELL_RENDERER_MODE_INERT: The cell is just for display and cannot be interacted with. Note that this doesn’t mean that eg. the row being drawn can’t be selected -- just that a particular element of it cannot be individually modified.

  * GTK_CELL_RENDERER_MODE_ACTIVATABLE: The cell can be clicked.

  * GTK_CELL_RENDERER_MODE_EDITABLE: The cell can be edited or otherwise modified.

Methods
=======

new
---

Create a new plain object.

    multi method new ( )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[[gtk_] cell_renderer_] get_request_mode
----------------------------------------

Gets whether the cell renderer prefers a height-for-width layout or a width-for-height layout.

Returns: The **GtkSizeRequestMode** enum preferred by this renderer.

Since: 3.0

    method gtk_cell_renderer_get_request_mode ( --> GtkSizeRequestMode  )

[[gtk_] cell_renderer_] get_preferred_width
-------------------------------------------

Retreives a renderer’s natural size when rendered to *$widget*.

Since: 3.0

    method gtk_cell_renderer_get_preferred_width ( N-GObject $widget --> List )

  * N-GObject $widget; the widget this cell will be rendering to

The method returns a list with

  * Int $minimum_size; the minimum size

  * Int $natural_size; the natural size

[[gtk_] cell_renderer_] get_preferred_height_for_width
------------------------------------------------------

Retreives a cell renderers’s minimum and natural height if it were rendered to *$widget* with the specified *$width*.

Since: 3.0

    method gtk_cell_renderer_get_preferred_height_for_width (
      N-GObject $widget, Int $width
      --> List
    )

  * N-GObject $widget; the widget this cell will be rendering to

  * Int $width; the size which is available for allocation

Returns a list with

  * Int $minimum_height; the minimum size

  * Int $natural_height; the preferred size

[[gtk_] cell_renderer_] get_preferred_height
--------------------------------------------

Retreives a renderer’s natural size when rendered to *$widget*.

Since: 3.0

    method gtk_cell_renderer_get_preferred_height ( N-GObject $widget --> List )

  * N-GObject $widget; the widget this cell will be rendering to

Returns a list with

  * Int $minimum_size; the minimum size

  * Int $natural_size; the natural size

[[gtk_] cell_renderer_] get_preferred_width_for_height
------------------------------------------------------

Retreives a cell renderers’s minimum and natural width if it were rendered to *$widget* with the specified *$height*.

Since: 3.0

    method gtk_cell_renderer_get_preferred_width_for_height (
      N-GObject $widget, Int $height
      --> List
    )

  * N-GObject $widget; the widget this cell will be rendering to

  * Int $height; the size which is available for allocation

Returns a list with

  * Int $minimum_width; the minimum size

  * Int $natural_width; the preferred size

[[gtk_] cell_renderer_] get_preferred_size
------------------------------------------

Retrieves the minimum and natural size of a cell taking into account the widget’s preference for height-for-width management.

Since: 3.0

    method gtk_cell_renderer_get_preferred_size ( N-GObject $widget --> List )

  * N-GObject $widget; the widget this cell will be rendering to

Returns a list with

  * N-GtkRequisition $minimum_size; the minimum size

  * N-GtkRequisition $natural_size; the natural size

[[gtk_] cell_renderer_] set_fixed_size
--------------------------------------

Sets the renderer size to be explicit, independent of the properties set.

    method gtk_cell_renderer_set_fixed_size ( Int $width, Int $height )

  * Int $width; the width of the cell renderer, or -1

  * Int $height; the height of the cell renderer, or -1

[[gtk_] cell_renderer_] get_fixed_size
--------------------------------------

Fills in *width* and *height* with the appropriate size of *cell*.

    method gtk_cell_renderer_get_fixed_size ( --> List )

Returns a list with

  * Int $width; the fixed width of the cell

  * Int $height; the fixed height of the cell

[[gtk_] cell_renderer_] set_alignment
-------------------------------------

Sets the renderer’s alignment within its available space.

Since: 2.18

    method gtk_cell_renderer_set_alignment ( Num $xalign, Num $yalign )

  * Num $xalign; the x alignment of the cell renderer

  * Num $yalign; the y alignment of the cell renderer

[[gtk_] cell_renderer_] get_alignment
-------------------------------------

Returns xalign and yalign with the appropriate values of this cell.

Since: 2.18

    method gtk_cell_renderer_get_alignment ( --> List )

Returns a list with

  * Num $xalign; x alignment of the cell

  * Num $yalign; y alignment of the cell

[[gtk_] cell_renderer_] set_padding
-----------------------------------

Sets the renderer’s padding.

Since: 2.18

    method gtk_cell_renderer_set_padding ( Int $xpad, Int $ypad )

  * Int $xpad; the x padding of the cell renderer

  * Int $ypad; the y padding of the cell renderer

[[gtk_] cell_renderer_] get_padding
-----------------------------------

Returns xpad and ypad with the appropriate values of this cell.

Since: 2.18

    method gtk_cell_renderer_get_padding ( --> List )

Returns list with

  * Int $xpad; x padding of the cell

  * Int $ypad; y padding of the cell

[[gtk_] cell_renderer_] set_visible
-----------------------------------

Sets the cell renderer’s visibility.

Since: 2.18

    method gtk_cell_renderer_set_visible ( Int $visible )

  * Int $visible; the visibility of the cell

[[gtk_] cell_renderer_] get_visible
-----------------------------------

Returns the cell renderer’s visibility.

Returns: `1` if the cell renderer is visible

Since: 2.18

    method gtk_cell_renderer_get_visible ( --> Int  )

[[gtk_] cell_renderer_] set_sensitive
-------------------------------------

Sets the cell renderer’s sensitivity.

Since: 2.18

    method gtk_cell_renderer_set_sensitive ( Int $sensitive )

  * Int $sensitive; the sensitivity of the cell

[[gtk_] cell_renderer_] get_sensitive
-------------------------------------

Returns the cell renderer’s sensitivity.

Returns: `1` if the cell renderer is sensitive

Since: 2.18

    method gtk_cell_renderer_get_sensitive ( --> Int  )

[[gtk_] cell_renderer_] is_activatable
--------------------------------------

Checks whether the cell renderer can do something when activated.

Returns: `1` if the cell renderer can do anything when activated

Since: 3.0

    method gtk_cell_renderer_is_activatable ( --> Int  )

[[gtk_] cell_renderer_] get_state
---------------------------------

Translates the cell renderer state to **GtkStateFlags**, based on the cell renderer and widget sensitivity, and the given **GtkCellRendererState**.

Returns: the widget state flags applying to this cell

Since: 3.0

    method gtk_cell_renderer_get_state ( N-GObject $widget, GtkCellRendererState $cell_state --> GtkStateFlags  )

  * N-GObject $widget; a widget

  * GtkCellRendererState $cell_state; cell renderer state

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

### editing-canceled

This signal gets emitted when the user cancels the process of editing a cell. For example, an editable cell renderer could be written to cancel editing when the user presses Escape.

See also: `gtk_cell_renderer_stop_editing()`.

Since: 2.4

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($renderer),
      *%user-options
    );

  * $renderer; the object which received the signal

### editing-started

This signal gets emitted when a cell starts to be edited. The intended use of this signal is to do special setup on *editable*, e.g. adding a **Gnome::Gtk3::EntryCompletion** or setting up additional columns in a **Gnome::Gtk3::ComboBox**.

Note that GTK+ doesn't guarantee that cell renderers will continue to use the same kind of widget for editing in future releases, therefore you should check the type of *editable* before doing any specific setup, as in the following example:

Since: 2.6

    method handler (
      Unknown type GTK_TYPE_CELL_EDITABLE $editable,
      Str $path,
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($renderer),
      *%user-options
    );

  * $renderer; the object which received the signal

  * $editable; the **Gnome::Gtk3::CellEditable**

  * $path; the path identifying the edited cell

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### mode

Editable mode of the CellRenderer. Its an enumeration value of GtkCellRendererMode. To retrieve value use G_TYPE_INT.

Default value: GTK_CELL_RENDERER_MODE_INERT

The **Gnome::GObject::Value** type of property *mode* is `G_TYPE_INT`.

### visible

Display the cell Default value: `1`

The **Gnome::GObject::Value** type of property *visible* is `G_TYPE_BOOLEAN`.

### Sensitive

Display the cell sensitive Default value: True

The **Gnome::GObject::Value** type of property *sensitive* is `G_TYPE_BOOLEAN`.

### xalign

The **Gnome::GObject::Value** type of property *xalign* is `G_TYPE_FLOAT`.

### yalign

The **Gnome::GObject::Value** type of property *yalign* is `G_TYPE_FLOAT`.

### xpad

The **Gnome::GObject::Value** type of property *xpad* is `G_TYPE_UINT`.

### ypad

The **Gnome::GObject::Value** type of property *ypad* is `G_TYPE_UINT`.

### width

The **Gnome::GObject::Value** type of property *width* is `G_TYPE_INT`.

### height

The **Gnome::GObject::Value** type of property *height* is `G_TYPE_INT`.

### Is Expander

Row has children Default value: False

The **Gnome::GObject::Value** type of property *is-expander* is `G_TYPE_BOOLEAN`.

### Is Expanded

Row is an expander row, and is expanded Default value: False

The **Gnome::GObject::Value** type of property *is-expanded* is `G_TYPE_BOOLEAN`.

### Cell background color name

Cell background color as a string Default value: Any

The **Gnome::GObject::Value** type of property *cell-background* is `G_TYPE_STRING`.

### Editing

Whether the cell renderer is currently in editing mode Default value: False

The **Gnome::GObject::Value** type of property *editing* is `G_TYPE_BOOLEAN`.

### propval

The **Gnome::GObject::Value** type of property *g_object_class_install_property (object_class* is `G_TYPE_`.

