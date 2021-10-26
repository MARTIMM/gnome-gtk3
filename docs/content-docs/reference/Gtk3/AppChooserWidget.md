Gnome::Gtk3::AppChooserWidget
=============================

Application chooser widget that can be embedded in other widgets

Description
===========

**Gnome::Gtk3::AppChooserWidget** is a widget for selecting applications. It is the main building block for **Gnome::Gtk3::AppChooserDialog**. Most applications only need to use the latter; but you can use this widget as part of a larger widget if you have special needs.

**Gnome::Gtk3::AppChooserWidget** offers detailed control over what applications are shown, using the *show-default*, *show-recommended*, *show-fallback*, *show-other* and *show-all* properties. See the **Gnome::Gtk3::AppChooser** documentation for more information about these groups of applications.

To keep track of the selected application, use the *application-selected* and *application-activated* signals.

Css Nodes
---------

GtkAppChooserWidget has a single CSS node with name appchooser.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::AppChooserWidget;
    also is Gnome::Gtk3::Box;
    also does Gnome::Gtk3::AppChooser;

Uml Diagram
-----------

![](plantuml/AppChooserWidget.svg)

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::AppChooserWidget;

    unit class MyGuiClass;
    also is Gnome::Gtk3::AppChooserWidget;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::AppChooserWidget class process the options
      self.bless( :GtkAppChooserWidget, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Methods
=======

new
---

### :content-type

Creates a new **Gnome::Gtk3::AppChooserWidget** for applications that can handle content of the given type.

    multi method new ( Str :$content-type! )

### :native-object

Create a AppChooserWidget object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a AppChooserWidget object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

get-default-text
----------------

Returns the text that is shown if there are no applications that can handle the content type.

Returns: the value of *default-text*

    method get-default-text ( --> Str )

get-show-all
------------

Returns the current value of the *show-all* property.

Returns: the value of *show-all*

    method get-show-all ( --> Bool )

get-show-default
----------------

Returns the current value of the *show-default* property.

Returns: the value of *show-default*

    method get-show-default ( --> Bool )

get-show-fallback
-----------------

Returns the current value of the *show-fallback* property.

Returns: the value of *show-fallback*

    method get-show-fallback ( --> Bool )

get-show-other
--------------

Returns the current value of the *show-other* property.

Returns: the value of *show-other*

    method get-show-other ( --> Bool )

get-show-recommended
--------------------

Returns the current value of the *show-recommended* property.

Returns: the value of *show-recommended*

    method get-show-recommended ( --> Bool )

set-default-text
----------------

Sets the text that is shown if there are not applications that can handle the content type.

    method set-default-text ( Str $text )

  * Str $text; the new value for *default-text*

set-show-all
------------

Sets whether the app chooser should show all applications in a flat list.

    method set-show-all ( Bool $setting )

  * Bool $setting; the new value for *show-all*

set-show-default
----------------

Sets whether the app chooser should show the default handler for the content type in a separate section.

    method set-show-default ( Bool $setting )

  * Bool $setting; the new value for *show-default*

set-show-fallback
-----------------

Sets whether the app chooser should show related applications for the content type in a separate section.

    method set-show-fallback ( Bool $setting )

  * Bool $setting; the new value for *show-fallback*

set-show-other
--------------

Sets whether the app chooser should show applications which are unrelated to the content type.

    method set-show-other ( Bool $setting )

  * Bool $setting; the new value for *show-other*

set-show-recommended
--------------------

Sets whether the app chooser should show recommended applications for the content type in a separate section.

    method set-show-recommended ( Bool $setting )

  * Bool $setting; the new value for *show-recommended*

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `connect-object()` directly from **Gnome::GObject::Signal**.

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

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `connect-object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### application-activated

Emitted when an application item is activated from the widget's list.

This usually happens when the user double clicks an item, or an item is selected and the user presses one of the keys Space, Shift+Space, Return or Enter.

    method handler (
      Unknown type G_TYPE_APP_INFO $application,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($self),
      *%user-options
    );

  * $self; the object which received the signal

  * $application; the activated **Gnome::Gtk3::AppInfo**

  * $_handle_id; the registered event handler id

### application-selected

Emitted when an application item is selected from the widget's list.

    method handler (
      Unknown type G_TYPE_APP_INFO $application,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($self),
      *%user-options
    );

  * $self; the object which received the signal

  * $application; the selected **Gnome::Gtk3::AppInfo**

  * $_handle_id; the registered event handler id

### populate-popup

Emitted when a context menu is about to popup over an application item. Clients can insert menu items into the provided **Gnome::Gtk3::Menu** object in the callback of this signal; the context menu will be shown over the item if at least one item has been added to the menu.

    method handler (
      Unknown type GTK_TYPE_MENU $menu,
      Unknown type G_TYPE_APP_INFO $application,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($self),
      *%user-options
    );

  * $self; the object which received the signal

  * $menu; the **Gnome::Gtk3::Menu** to populate

  * $application; the current **Gnome::Gtk3::AppInfo**

  * $_handle_id; the registered event handler id

