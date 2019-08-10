TITLE
=====

Gnome::Gtk3::WidgetPath

SUBTITLE
========

Widget path abstraction

Description
===========

`Gnome::Gtk3::WidgetPath` is a boxed type that represents a widget hierarchy from the topmost widget, typically a toplevel, to any child. This widget path abstraction is used in `Gnome::Gtk3::StyleContext` on behalf of the real widget in order to query style information.

If you are using GTK+ widgets, you probably will not need to use this API directly, as there is `gtk_widget_get_path()`, and the style context returned by `gtk_widget_get_style_context()` will be automatically updated on widget hierarchy changes.

See Also
--------

`Gnome::Gtk3::StyleContext`

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::WidgetPath;
    also is Gnome::GObject::Boxed;

Example
-------

Methods
=======

new
---

### multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

### multi method new ( N-GtkWidgetPath :$widgetpath! )

Create an object using a native object from elsewhere.

clear-widget-path
-----------------

Clear the widget path and return native object to memory.

    method clear-widget-path ( )

widgetpath-is-valid
-------------------

Returns True if native object is valid, otherwise False.

    method widgetpath-is-valid ( --> Bool )

gtk_widget_path_new
-------------------

Returns an empty native widget path object.

Since: 3.0

    method gtk_widget_path_new ( --> N-GtkWidgetPath  )

gtk_widget_path_copy
--------------------

Returns a copy of the native object

Since: 3.0

    method gtk_widget_path_copy ( --> N-GtkWidgetPath  )

[gtk_widget_path_] to_string
----------------------------

Dumps the widget path into a string representation. It tries to match the CSS style as closely as possible (Note that there might be paths that cannot be represented in CSS).

The main use of this code is for debugging purposes.

Returns: A new string describing the path.

Since: 3.2

    method gtk_widget_path_to_string ( --> Str )

gtk_widget_path_length
----------------------

Returns the number of widget `GTypes` between the represented widget and its topmost container.

Returns: the number of elements in the path

Since: 3.0

    method gtk_widget_path_length ( --> Int )

[gtk_widget_path_] append_type
------------------------------

Appends a widget type to the widget hierarchy represented by the path.

Returns: the position where the element was inserted

Since: 3.0

    method gtk_widget_path_append_type ( Int $type --> Int  )

  * Int $type; widget type to append

[gtk_widget_path_] prepend_type
-------------------------------

Prepends a widget type to the widget hierachy represented by the path.

Since: 3.0

    method gtk_widget_path_prepend_type ( Int $type )

  * N-GObject $type; widget type to prepend

[gtk_widget_path_] append_with_siblings
---------------------------------------

Appends a widget type with all its siblings to the widget hierarchy represented by *path*. Using this function instead of `gtk_widget_path_append_type()` will allow the CSS theming to use sibling matches in selectors and apply prop `nth-child`() pseudo classes. In turn, it requires a lot more care in widget implementations as widgets need to make sure to call `gtk_widget_reset_style()` on all involved widgets when the *siblings* path changes.

Returns: the position where the element was inserted.

Since: 3.2

    method gtk_widget_path_append_with_siblings ( N-GObject $siblings, UInt $sibling_index --> Int  )

  * N-GtkWidgetPath $siblings; a widget path describing a list of siblings. This path may not contain any siblings itself and it must not be modified afterwards.

  * UInt $sibling_index; index into *siblings* for where the added element is positioned.

[gtk_widget_path_] append_for_widget
------------------------------------

    method gtk_widget_path_append_for_widget ( N-GObject $widget --> Int  )

  * N-GObject $widget;

[gtk_widget_path_] iter_get_object_type
---------------------------------------

Returns the object `GType` that is at position *pos* in the widget hierarchy defined in *path*.

Returns: a widget type

Since: 3.0

    method gtk_widget_path_iter_get_object_type ( Int $pos --> N-GObject  )

  * Int $pos; position to get the object type for, -1 for the path head

[gtk_widget_path_] iter_set_object_type
---------------------------------------

Sets the object type for a given position in the widget hierarchy defined by *path*.

Since: 3.0

    method gtk_widget_path_iter_set_object_type ( Int $pos, N-GObject $type )

  * Int $pos; position to modify, -1 for the path head

  * N-GObject $type; object type to set

[gtk_widget_path_] iter_get_object_name
---------------------------------------

Returns the object name that is at position pos in the widget hierarchy defined in path

    method gtk_widget_path_iter_get_object_name ( Int $pos --> Str )

  * gtk_widget_path_iter_get_object_name const GtkWidgetPath *path;

  * Int $pos;

[gtk_widget_path_] iter_set_object_name
---------------------------------------

Sets the object name for a given position in the widget hierarchy defined by *path*.

When set, the object name overrides the object type when matching CSS.

Since: 3.20

    method gtk_widget_path_iter_set_object_name ( Int $pos, Str $name )

  * Int $pos; position to modify, -1 for the path head

  * char $name; (allow-none): object name to set or `Any` to unset

[gtk_widget_path_] iter_get_siblings
------------------------------------

Returns the list of siblings for the element at *pos*. If the element was not added with siblings, `Any` is returned.

Returns: `Any` or the list of siblings for the element at *pos*.

    method gtk_widget_path_iter_get_siblings ( Int $pos --> N-GObject  )

  * Int $pos; position to get the siblings for, -1 for the path head

[gtk_widget_path_] iter_get_sibling_index
-----------------------------------------

Returns the index into the list of siblings for the element at *pos* as returned by `gtk_widget_path_iter_get_siblings()`. If that function would return `Any` because the element at *pos* has no siblings, this function will return 0.

Returns: 0 or the index into the list of siblings for the element at *pos*.

    method gtk_widget_path_iter_get_sibling_index ( Int $pos --> UInt  )

  * Int $pos; position to get the sibling index for, -1 for the path head

[gtk_widget_path_] iter_get_name
--------------------------------

Returns the name corresponding to the widget found at the position *$pos* in the widget hierarchy. This name can be set using `$widget.gtk_widget_set_name('...')`.

Returns: The widget name, or `Str` if none was set.

    method gtk_widget_path_iter_get_name ( Int $pos --> Str  )

  * Int $pos; position to get the widget name for, -1 for the path head

[gtk_widget_path_] iter_set_name
--------------------------------

Sets the widget name for the widget found at position *$pos* in the widget hierarchy.

Since: 3.0

    method gtk_widget_path_iter_set_name ( Int $pos, Str $name )

  * Int $pos; position to modify, -1 for the path head

  * Str $name; widget name

[gtk_widget_path_] iter_has_name
--------------------------------

Returns `1` if the widget at position *$pos* has the name *name*, `0` otherwise.

Since: 3.0

    method gtk_widget_path_iter_has_name ( Int $pos, Str $name --> Int  )

  * Int $pos; position to query, -1 for the path head

  * Str $name; a widget name

[gtk_widget_path_] iter_has_qname
---------------------------------

See `gtk_widget_path_iter_has_name()`. This is a version that operates on `GQuarks`.

Returns: `1` if the widget at *pos* has this name

Since: 3.0

    method gtk_widget_path_iter_has_qname ( Int $pos, Int $qname --> Int  )

  * Int $pos; position to query, -1 for the path head

  * Int $qname; widget name as a `GQuark`

[gtk_widget_path_] iter_get_state
---------------------------------

Returns the state flags corresponding to the widget found at the position *$pos* in the widget hierarchy.

Returns: The state flags

Since: 3.14

    method gtk_widget_path_iter_get_state ( Int $pos --> GtkStateFlags  )

  * Int $pos; position to get the state for, -1 for the path head

[gtk_widget_path_] iter_set_state
---------------------------------

Sets the widget name for the widget found at position *$pos* in the widget hierarchy.

If you want to update just a single state flag, you need to do this manually, as this function updates all state flags.

Example setting a flag on 3rd item in the widget path

    my Int $new-state = $wp.iter-get-state(2) +| GTK_STATE_FLAG_INSENSITIVE.value;
    $wp.iter-set-state( 2, $new-state);

And unsetting a flag

    my Int $drop-flag = GTK_STATE_FLAG_INSENSITIVE.value +^ 0xFFFFFFFF;
    my Int $new-state = $wp.iter-get-state(2) +& $drop-flag;
    $wp.iter-set-state( 2, $new-state);

Since: 3.14

    method gtk_widget_path_iter_set_state ( Int $pos, GtkStateFlags $state )

  * Int $pos; position to modify, -1 for the path head

  * GtkStateFlags $state; state flags

[gtk_widget_path_] iter_add_class
---------------------------------

Adds the class *name* to the widget at position *pos* in the hierarchy defined in *path*. See `gtk_style_context_add_class()`.

Since: 3.0

    method gtk_widget_path_iter_add_class ( Int $pos, Str $name )

  * Int $pos; position to modify, -1 for the path head

  * Str $name; a class name

[gtk_widget_path_] iter_remove_class
------------------------------------

Removes the class *name* from the widget at position *pos* in the hierarchy defined in *path*.

Since: 3.0

    method gtk_widget_path_iter_remove_class ( Int $pos, Str $name )

  * Int $pos; position to modify, -1 for the path head

  * Str $name; class name

[gtk_widget_path_] iter_clear_classes
-------------------------------------

Removes all classes from the widget at position *pos* in the hierarchy defined in *path*.

Since: 3.0

    method gtk_widget_path_iter_clear_classes ( Int $pos )

  * Int $pos; position to modify, -1 for the path head

[gtk_widget_path_] iter_list_classes
------------------------------------

Returns a list with all the class names defined for the widget at position *pos* in the hierarchy defined in *path*.

Returns: The list of classes, This is a list of strings, the `GSList` contents are owned by GTK+, but you should use `g_slist_free()` to free the list itself.

Since: 3.0

    method gtk_widget_path_iter_list_classes ( Int $pos --> N-GSList )

  * Int $pos; position to query, -1 for the path head

[gtk_widget_path_] iter_has_class
---------------------------------

Returns `1` if the widget at position *pos* has the class *name* defined, `0` otherwise.

Returns: `1` if the class *name* is defined for the widget at *pos*

Since: 3.0

    method gtk_widget_path_iter_has_class ( Int $pos, Str $name --> Int  )

  * Int $pos; position to query, -1 for the path head

  * Str $name; class name

[gtk_widget_path_] iter_has_qclass
----------------------------------

See `gtk_widget_path_iter_has_class()`. This is a version that operates with GQuarks.

Returns: `1` if the widget at *pos* has the class defined.

Since: 3.0

    method gtk_widget_path_iter_has_qclass ( Int $pos, N-GtkWidgetPath $qname --> Int  )

  * Int $pos; position to query, -1 for the path head

  * int32 $qname; class name as a `GQuark`

[gtk_widget_path_] get_object_type
----------------------------------

Returns the topmost object type, that is, the object type this path is representing.

Returns: The object type

Since: 3.0

    method gtk_widget_path_get_object_type ( --> int32 )

[gtk_widget_path_] is_type
--------------------------

Returns `1` if the widget type represented by this path is *type*, or a subtype of it.

Returns: `1` if the widget represented by *path* is of type *type*

Since: 3.0

    method gtk_widget_path_is_type ( Int $type --> Int  )

  * Int $type; widget type to match

[gtk_widget_path_] has_parent
-----------------------------

Returns `1` if any of the parents of the widget represented in *path* is of type *type*, or any subtype of it.

Returns: `1` if any parent is of type *type*

Since: 3.0

    method gtk_widget_path_has_parent ( Int $type --> Int  )

  * Int $type; widget type to check in parents

List of deprecated (not implemented!) methods
=============================================

Since 3.14
----------

### method gtk_widget_path_iter_add_region ( Int $pos, Str $name, GtkRegionFlags $flags )

### method gtk_widget_path_iter_remove_region ( Int $pos, Str $name )

### method gtk_widget_path_iter_clear_regions ( Int $pos )

### method gtk_widget_path_iter_list_regions ( Int $pos --> N-GObject )

### method gtk_widget_path_iter_has_region ( Int $pos, Str $name, GtkRegionFlags $flags --> Int )

### method gtk_widget_path_iter_has_qregion ( Int $pos, N-GObject $qname, GtkRegionFlags $flags --> Int )

