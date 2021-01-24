Gnome::Gtk3::RecentChooser
==========================

Interface implemented by widgets displaying recently used files

Description
===========

**Gnome::Gtk3::RecentChooser** is an interface that can be implemented by widgets displaying the list of recently used files. In GTK+, the main objects that implement this interface are **Gnome::Gtk3::RecentChooserWidget**, **Gnome::Gtk3::RecentChooserDialog** and **Gnome::Gtk3::RecentChooserMenu**.

    * Recently used files are supported since GTK+ 2.10.

See Also
--------

**Gnome::Gtk3::RecentManager**, **Gnome::Gtk3::RecentChooserDialog**, **Gnome::Gtk3::RecentChooserWidget**, **Gnome::Gtk3::RecentChooserMenu**

Synopsis
========

Declaration
-----------

    unit role Gnome::Gtk3::RecentChooser;

Types
=====

enum GtkRecentSortType
----------------------

Used to specify the sorting method to be applied to the recently used resource list.

  * GTK_RECENT_SORT_NONE: Do not sort the returned list of recently used resources.

  * GTK_RECENT_SORT_MRU: Sort the returned list with the most recently used items first.

  * GTK_RECENT_SORT_LRU: Sort the returned list with the least recently used items first.

  * GTK_RECENT_SORT_CUSTOM: Sort the returned list using a custom sorting function passed using `gtk_recent_chooser_set_sort_func()`.

enum GtkRecentChooserError
--------------------------

These identify the various errors that can occur while calling **Gnome::Gtk3::RecentChooser** functions.

  * GTK_RECENT_CHOOSER_ERROR_NOT_FOUND: Indicates that a file does not exist

  * GTK_RECENT_CHOOSER_ERROR_INVALID_URI: Indicates a malformed URI

Methods
=======

error-quark
-----------

Returns: The error quark used for *Gnome::Gtk3::RecentChooser* errors.

    method error-quark ( --> UInt )

set-show-private
----------------

Whether to show recently used resources marked registered as private.

    method set-show-private ( Bool $show_private )

  * Bool $show_private; `True` to show private items, `0` otherwise

get-show-private
----------------

Returns whether *chooser* should display recently used resources registered as private.

Returns: `True` if the recent chooser should show private items, `False` otherwise.

    method get-show-private ( --> Bool )

set-show-not-found
------------------

Sets whether *chooser* should display the recently used resources that it didn’t find. This only applies to local resources.

    method set-show-not-found ( Bool $show_not_found )

  * Bool $show_not_found; whether to show the local items we didn’t find

get-show-not-found
------------------

Retrieves whether *chooser* should show the recently used resources that were not found.

Returns: `True` if the resources not found should be displayed, and `False` otheriwse.

    method get-show-not-found ( --> Bool )

set-select-multiple
-------------------

Sets whether *chooser* can select multiple items.

    method set-select-multiple ( Bool $select_multiple )

  * Bool $select_multiple; `True` if *chooser* can select more than one item

get-select-multiple
-------------------

Gets whether *chooser* can select multiple items.

Returns: `True` if *chooser* can select more than one item.

    method get-select-multiple ( --> Bool )

set-limit
---------

Sets the number of items that should be returned by `gtk_recent_chooser_get_items()` and `gtk_recent_chooser_get_uris()`.

    method set-limit ( Int $limit )

  * Int $limit; a positive integer, or -1 for all items

get-limit
---------

Gets the number of items returned by `gtk_recent_chooser_get_items()` and `gtk_recent_chooser_get_uris()`.

Returns: A positive integer, or -1 meaning that all items are returned.

    method get-limit ( --> Int )

set-local-only
--------------

Sets whether only local resources, that is resources using the file:// URI scheme, should be shown in the recently used resources selector. If *local_only* is `True` (the default) then the shown resources are guaranteed to be accessible through the operating system native file system.

    method set-local-only ( Bool $local_only )

  * Bool $local_only; `1` if only local files can be shown

get-local-only
--------------

Gets whether only local resources should be shown in the recently used resources selector. See `gtk_recent_chooser_set_local_only()`

Returns: `True` if only local resources should be shown.

    method get-local-only ( --> Bool )

set-show-tips
-------------

Sets whether to show a tooltips containing the full path of each recently used resource in a **Gnome::Gtk3::RecentChooser** widget.

    method set-show-tips ( Bool $show_tips )

  * Bool $show_tips; `True` if tooltips should be shown

get-show-tips
-------------

Gets whether *chooser* should display tooltips containing the full path of a recently user resource.

Returns: `True` if the recent chooser should show tooltips, `False` otherwise.

    method get-show-tips ( --> Bool )

set-show-icons
--------------

Sets whether *chooser* should show an icon near the resource when displaying it.

    method set-show-icons ( Bool $show_icons )

  * Bool $show_icons; whether to show an icon near the resource

get-show-icons
--------------

Retrieves whether *chooser* should show an icon near the resource.

Returns: `True` if the icons should be displayed, `False` otherwise.

    method get-show-icons ( --> Bool )

set-sort-type
-------------

Changes the sorting order of the recently used resources list displayed by *chooser*.

    method set-sort-type ( GtkRecentSortType $sort_type )

  * GtkRecentSortType $sort_type; sort order that the chooser should use

get-sort-type
-------------

Gets the value set by `gtk_recent_chooser_set_sort_type()`.

Returns: the sorting order of the *chooser*.

    method get-sort-type ( --> GtkRecentSortType )

set-sort-func
-------------

Sets the comparison function used when sorting to be *sort_func*. If the *chooser* has the sort type set to **GTK_RECENT_SORT_CUSTOM** then the chooser will sort using this function. To the sort method will be passed two **Gnome::Gtk3::RecentInfo** structs. The sort method should return a positive integer if the first item comes before the second, zero if the two items are equal and a negative integer if the first item comes after the second.

    method set-sort-func (
      $sort-method-object, Str $sort-methodname
    )

An example which sorts the recent information alphabetically;

    class Sorters {
      method alpha-uri (
        Gnome::Gtk3::RecentInfo $a, Gnome::Gtk3::RecentInfo $b
        --> Int
      ) {
        $a.get-uri cmp $b.get-uri
      }
    }

    my Gnome::Gtk3::RecentChooserMenu $rc;
    $rc.set-sort-type(GTK_RECENT_SORT_CUSTOM);
    $rc.set-sort-func( Sorters.new, 'alpha-uri');

    # next output dump shows the recent list sorted alphabetically
    note "\nUris:\n  " ~ $rc.get-uris.join("\n  ");
      #diag '.get-uris(); ' ~ (.get-uris[0] // '-') ~ ' …';
    }

set-current-uri
---------------

Sets *$uri* as the current URI for *chooser*.

Returns: A **Gnome::Glib::Error** object. When the uri was found, the error object is invalid.

    method set-current-uri ( Str $uri --> Gnome::Glib::Error )

  * Str $uri; a URI

get-current-uri
---------------

Gets the URI currently selected by *chooser*.

Returns: a newly allocated string holding a URI.

    method get-current-uri ( -->  Str )

get-current-item
----------------

Gets the **Gnome::Gtk3::RecentInfo** currently selected by *chooser*.

Returns: a **Gnome::Gtk3::RecentInfo**. Use `clear-object()` when when you have finished using it.

    method get-current-item ( --> GtkRecentInfo )

select-uri
----------

Selects *uri* inside *chooser*.

Returns: A **Gnome::Glib::Error** object. When the uri was found, the error object is invalid.

    method select-uri (  Str  $uri --> Gnome::Glib::Error )

  * Str $uri; a URI

unselect-uri
------------

Unselects *uri* inside *chooser*.

    method unselect-uri (  Str  $uri )

  * Str $uri; a URI

select-all
----------

Selects all the items inside *chooser*, if the *chooser* supports multiple selection.

    method select-all ( )

unselect-all
------------

Unselects all the items inside *chooser*.

    method unselect-all ( )

get-items
---------

Gets the list of recently used resources in form of **Gnome::Gtk3::RecentInfo** objects. The return value of this function is affected by the “sort-type” and “limit” properties of *chooser*.

Returns: (element-type **Gnome::Gtk3::RecentInfo**) (transfer full): A newly allocated list of **Gnome::Gtk3::RecentInfo** objects. You should use `clear-object()` on every item of the list, and then free the list itself also using `clear-object()`.

    method get-items ( --> Gnome::Glib::List )

get-uris
--------

Gets the URI of the recently used resources. The return value of this function is affected by the “sort-type” and “limit” properties of *chooser*.

Returns: An array of strings.

    method get-uris ( --> Array )

add-filter
----------

Adds *filter* to the list of **Gnome::Gtk3::RecentFilter** objects held by *chooser*. If no previous filter objects were defined, this function will call `gtk_recent_chooser_set_filter()`.

    method add-filter ( N-GObject $filter )

  * N-GObject $filter; a **Gnome::Gtk3::RecentFilter**

remove-filter
-------------

Removes *filter* from the list of **Gnome::Gtk3::RecentFilter** objects held by *chooser*.

    method remove-filter ( N-GObject $filter )

  * N-GObject $filter; a **Gnome::Gtk3::RecentFilter**

list-filters
------------

Gets the **Gnome::Gtk3::RecentFilter** objects held by *chooser*.

Returns: (element-type **Gnome::Gtk3::RecentFilter**) (transfer container): A singly linked list of **Gnome::Gtk3::RecentFilter** objects. You should just free the returned list using `g_slist_free()`.

    method list-filters ( --> N-GSList )

set-filter
----------

Sets *filter* as the current **Gnome::Gtk3::RecentFilter** object used by *chooser* to affect the displayed recently used resources.

    method set-filter ( N-GObject $filter )

  * N-GObject $filter; (allow-none): a **Gnome::Gtk3::RecentFilter**

get-filter
----------

Gets the **Gnome::Gtk3::RecentFilter** object currently used by *chooser* to affect the display of the recently used resources.

Returns: (transfer none): a **Gnome::Gtk3::RecentFilter** object.

    method get-filter ( --> N-GObject )

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

### selection-changed

This signal is emitted when there is a change in the set of selected recently used resources. This can happen when a user modifies the selection with the mouse or the keyboard, or when explicitly calling functions to change the selection.

Since: 2.10

    method handler (
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($chooser),
      *%user-options
    );

  * $chooser; the object which received the signal

### item-activated

This signal is emitted when the user "activates" a recent item in the recent chooser. This can happen by double-clicking on an item in the recently used resources list, or by pressing `Enter`.

Since: 2.10

    method handler (
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($chooser),
      *%user-options
    );

  * $chooser; the object which received the signal

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Recent Manager

The **Gnome::Gtk3::RecentManager** instance used by the **Gnome::Gtk3::RecentChooser** to display the list of recently used resources.

    Widget type: GTK_TYPE_RECENT_MANAGER

The **Gnome::GObject::Value** type of property *recent-manager* is `G_TYPE_OBJECT`.

### Show Private

Whether this **Gnome::Gtk3::RecentChooser** should display recently used resources marked with the "private" flag. Such resources should be considered private to the applications and groups that have added them.

The **Gnome::GObject::Value** type of property *show-private* is `G_TYPE_BOOLEAN`.

### Show Tooltips

Whether this **Gnome::Gtk3::RecentChooser** should display a tooltip containing the full path of the recently used resources.

The **Gnome::GObject::Value** type of property *show-tips* is `G_TYPE_BOOLEAN`.

### Show Icons

Whether this **Gnome::Gtk3::RecentChooser** should display an icon near the item.

The **Gnome::GObject::Value** type of property *show-icons* is `G_TYPE_BOOLEAN`.

### Show Not Found

Whether this **Gnome::Gtk3::RecentChooser** should display the recently used resources even if not present anymore. Setting this to `0` will perform a potentially expensive check on every local resource (every remote resource will always be displayed).

The **Gnome::GObject::Value** type of property *show-not-found* is `G_TYPE_BOOLEAN`.

### Select Multiple

Allow the user to select multiple resources.

The **Gnome::GObject::Value** type of property *select-multiple* is `G_TYPE_BOOLEAN`.

### Local only

Whether this **Gnome::Gtk3::RecentChooser** should display only local (file:) resources.

The **Gnome::GObject::Value** type of property *local-only* is `G_TYPE_BOOLEAN`.

### Limit

The maximum number of recently used resources to be displayed, or -1 to display all items.

The **Gnome::GObject::Value** type of property *limit* is `G_TYPE_INT`.

### Sort Type

Sorting order to be used when displaying the recently used resources.

Widget type: GTK_TYPE_RECENT_SORT_TYPE

The **Gnome::GObject::Value** type of property *sort-type* is `G_TYPE_ENUM`.

### Filter

The **Gnome::Gtk3::RecentFilter** object to be used when displaying the recently used resources.

Widget type: GTK_TYPE_RECENT_FILTER

The **Gnome::GObject::Value** type of property *filter* is `G_TYPE_OBJECT`.

