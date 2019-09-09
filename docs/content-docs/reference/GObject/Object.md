Gnome::GObject::Object
======================

The base object type

Description
===========

GObject is the fundamental type providing the common attributes and methods for all object types in GTK+, Pango and other libraries based on GObject. The GObject class provides methods for object construction and destruction, property access methods, and signal support.

Synopsis
========

Declaration
-----------

    unit class Gnome::GObject::Object;

Example
-------

Top level class of almost all classes in the GTK, GDK and Glib libraries.

This object is almost never used directly. Most of the classes inherit from this class. The below example shows how label text is set on a button using properties. This can be made much simpler by setting this label directly in the init of **Gnome::Gtk3::Button**. The purpose of this example, however, is that there might be other properties which can only be set this way.

    use Gnome::GObject::Object;
    use Gnome::GObject::Value;
    use Gnome::GObject::Type;
    use Gnome::Gtk3::Button;

    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));

    my Gnome::Gtk3::Button $b .= new(:empty);
    $gv.g-value-set-string('Open file');
    $b.g-object-set-property( 'label', $gv);

Methods
=======

new Please note that this class is mostly not instantiated directly but is used indirectly when child classes are instantiated.
-------------------------------------------------------------------------------------------------------------------------------

### multi method new ( :$widget! )

Create a Perl6 widget object using a native widget from elsewhere. $widget can be a N-GObject or a Perl6 widget like `Gnome::Gtk3::Button`.

    # Some set of radio buttons grouped together
    my Gnome::Gtk3::RadioButton $rb1 .= new(:label('Download everything'));
    my Gnome::Gtk3::RadioButton $rb2 .= new(
      :group-from($rb1), :label('Download core only')
    );

    # Get all radio buttons in the group of button $rb2
    my Gnome::GObject::SList $rb-list .= new(:gslist($rb2.get-group));
    loop ( Int $i = 0; $i < $rb-list.g_slist_length; $i++ ) {
      # Get button from the list
      my Gnome::Gtk3::RadioButton $rb .= new(
        :widget($rb-list.nth-data-gobject($i))
      );

      # If radio button is selected (=active) ...
      if $rb.get-active == 1 {
        ...

        last;
      }
    }

Another example is a difficult way to get a button.

    my Gnome::Gtk3::Button $start-button .= new(
      :widget(Gnome::Gtk3::Button.gtk_button_new_with_label('Start'))
    );

### multi method new ( Str :$build-id! )

Create a Perl6 widget object using a **Gnome::Gtk3::Builder**. The builder object will provide its object (self) to **Gnome::GObject::Object** when the Builder is created. The Builder object is asked to search for id's defined in the GUI glade design.

    my Gnome::Gtk3::Builder $builder .= new(:filename<my-gui.glade>);
    my Gnome::Gtk3::Button $button .= new(:build-id<my-gui-button>);

get-class-gtype
---------------

Return class's type code after registration. this is like calling Gnome::GObject::Type.new().g_type_from_name(GTK+ class type name).

    method get-class-gtype ( --> Int )

get-class-name
--------------

Return class name.

    method get-class-name ( --> Str )

register-signal
---------------

Register a handler to process a signal or an event. There are several types of callbacks which can be handled by this regstration. They can be controlled by using a named argument with a special name.

    method register-signal (
      $handler-object, Str:D $handler-name,
      Str:D $signal-name, *%user-options
      --> Bool
    )

  * $handler-object; The object wherein the handler is defined.

  * $handler-name; The name of the method. Commonly used signatures for those handlers are;

Simple handlers e.g. click event handler have only named arguments and are optional. The more elaborate handlers also have positional arguments and MUST be typed. Most of the time the handlers must return a value. This can be an Int to let other layers also handle the signal(0) or not(1). Any user options are provided from the call to register-signal().

Some examples

    method click-button ( :$widget, *%user-options --> Int )

    method focus-handle ( Int $direction, :$widget, *%user-options --> Int )

    method keyboard-event ( GdkEvent $event, :$widget, *%user-options --> Int )

  * $signal-name; The name of the event to be handled. Each gtk object has its own series of signals.

  * %user-options; Any other user data in whatever type. These arguments are provided to the user handler when an event for the handler is fired. There will always be one named argument `:$widget` which holds the class object on which the signal was registered. The name 'widget' is therefore reserved.

      # create a class holding a handler method to process a click event
      # of a button.
      class X {
        method click-handler ( :widget($button), Array :$my-data ) {
          say $my-data.join(' ');
        }
      }

      # create a button and some data to send with the signal
      my Gnome::Gtk3::Button $button .= new(:label('xyz'));
      my Array $data = [<Hello World>];

      # register button signal
      my X $x .= new;
      $button.register-signal( $x, 'click-handler', 'clicked', :my-data($data));

start-thread
------------

Start a thread in such a way that the function can modify the user interface in a save way and that these updates are automatically made visible without explicitly process events queued and waiting in the main loop.

    method start-thread (
      $handler-object, Str:D $handler-name, Int $priority = G_PRIORITY_DEFAULT,
      Bool :$new-context = False, *%user-options
      --> Promise
    )

  * $handler-object is the object wherein the handler is defined.

  * $handler-name is name of the method.

  * $priority; The priority to which the handler is started. The default is G_PRIORITY_DEFAULT. These are constants defined in **Gnome::GObject::GMain**.

  * $new-context; Whether to run the handler in a new context or to run it in the context of the main loop. Default is to run in the main loop.

  * *%user-options; Any name not used above is provided to the handler

Returns a `Promise` object. If the call fails, the object is undefined.

The handlers signature is at least `:$widget` of the object on which the call was made. Furthermore all users named arguments to the call defined in `*%user-options`. The handler may return any value which becomes the result of the `Promise` returned from `start-thread`.

g_initially_unowned_get_type
----------------------------

    method g_initially_unowned_get_type ( --> int32  )

[g_object_] new_with_properties
-------------------------------

Creates a new instance of a *GObject* subtype and sets its properties using the provided arrays. Both arrays must have exactly *n_properties* elements, and the names and values correspond by index.

Construction parameters (see `G_PARAM_CONSTRUCT`, `G_PARAM_CONSTRUCT_ONLY`) which are not explicitly specified are set to their default values.

Returns: (type GObject.Object) (transfer full): a new instance of *object_type*

Since: 2.54

    method g_object_new_with_properties (
      int32 $object_type, UInt $n_properties,
      CArray[Str] $names, CArray[N-GValue] $values
      --> N-GObject
    )

  * int32 $object_type; the object type to instantiate

  * UInt $n_properties; the number of properties

  * CArray[Str] $names; (array length=n_properties): the names of each property to be set

  * CArray[N-GValue] $values; (array length=n_properties): the values of each property to be set

g_object_unref
--------------

Decreases the reference count of *object*. When its reference count drops to 0, the object is finalized (i.e. its memory is freed).

If the pointer to the *GObject* may be reused in future (for example, if it is an instance variable of another object), it is recommended to clear the pointer to `Any` rather than retain a dangling pointer to a potentially invalid *GObject* instance. Use `g_clear_object()` for this.

    method g_object_unref ( Pointer $object )

  * Pointer $object; (type GObject.Object): a *GObject*

