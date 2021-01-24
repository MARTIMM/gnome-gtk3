Gnome::Gtk3::RecentInfo
=======================

Class for recently used files information

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::RecentInfo;
    also is Gnome::N::TopLevelClassSupport;

Types
=====

class N-GtkRecentInfo
---------------------

**N-GtkRecentInfo**-struct contains only private data and should be accessed using the provided API.

Methods
=======

get-uri
-------

Gets the URI of the resource.

Returns: the URI of the resource. The returned string is owned by the recent manager, and should not be freed.

    method get-uri ( -->  Str  )

get-display-name
----------------

Gets the name of the resource. If none has been defined, the basename of the resource is obtained.

Returns: the display name of the resource. The returned string is owned by the recent manager, and should not be freed.

    method get-display-name ( -->  Str  )

get-description
---------------

Gets the (short) description of the resource.

Returns: the description of the resource. The returned string is owned by the recent manager, and should not be freed.

    method get-description ( -->  Str  )

get-mime-type
-------------

Gets the MIME type of the resource.

Returns: the MIME type of the resource. The returned string is owned by the recent manager, and should not be freed.

    method get-mime-type ( -->  Str  )

get-private-hint
----------------

Gets the value of the “private” flag. Resources in the recently used list that have this flag set to `1` should only be displayed by the applications that have registered them.

Returns: `1` if the private flag was found, `0` otherwise

    method get-private-hint ( --> Int )

has-application
---------------

Checks whether an application registered this resource using *app_name*.

Returns: `1` if an application with name *app_name* was found, `0` otherwise

    method has-application ( Str  $app_name --> Int )

  * Str $app_name; a string containing an application name

has-group
---------

Checks whether *group_name* appears inside the groups registered for the recently used item *info*.

Returns: `1` if the group was found

    method has-group ( Str  $group_name --> Int )

  * Str $group_name; name of a group

get-icon
--------

Retrieves the icon of size *size* associated to the resource MIME type.

Returns: (nullable) (transfer full): a **Gnome::Gdk3::Pixbuf** containing the icon, or `Any`. Use `g_object_unref()` when finished using the icon.

    method get-icon ( Int $size --> N-GObject )

  * Int $size; the size of the icon in pixels

get-age
-------

Gets the number of days elapsed since the last update of the resource pointed by *info*.

Returns: a positive integer containing the number of days elapsed since the time this resource was last modified

    method get-age ( --> Int )

is-local
--------

Checks whether the resource is local or not by looking at the scheme of its URI.

Returns: `1` if the resource is local

    method is-local ( --> Int )

exists
------

Checks whether the resource pointed by *info* still exists. At the moment this check is done only on resources pointing to local files.

Returns: `1` if the resource exists

    method exists ( --> Int )

match
-----

Checks whether two **Gnome::Gtk3::RecentInfo**-struct point to the same resource.

Returns: `True` if both **Gnome::Gtk3::RecentInfo**-struct point to the same resource, `False` otherwise.

    method match ( N-GtkRecentInfo $info --> Bool )

  * N-GtkRecentInfo $info; a native **Gnome::Gtk3::RecentInfo** object.

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

### changed

Emitted when the current recently used resources manager changes its contents, either by calling `gtk_recent_manager_add_item()` or by another application.

Since: 2.10

    method handler (
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($recent_manager),
      *%user-options
    );

  * $recent_manager; the recent manager

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Filename

The full path to the file to be used to store and read the recently used resources list

    * Since: 2.10

The **Gnome::GObject::Value** type of property *filename* is `G_TYPE_STRING`.

### Size

The size of the recently used resources list.

    * Since: 2.10

The **Gnome::GObject::Value** type of property *size* is `G_TYPE_INT`.

