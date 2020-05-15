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
    also is Gnome::N::TopLevelClassSupport;

Methods
=======

new
---

Create a Raku object object using a **Gnome::Gtk3::Builder**. The builder object will provide its object (self) to **Gnome::GObject::Object** when the Builder is created. The Builder object is asked to search for id's defined in the GUI glade design.

    multi method new ( Str :$build-id! )

An example

    my Gnome::Gtk3::Builder $builder .= new(:filename<my-gui.glade>);
    my Gnome::Gtk3::Button $button .= new(:build-id<my-gui-button>);

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
      Bool :$new-context = False, Num :$start-time, *%user-options
      --> Promise
    )

  * $handler-object is the object wherein the handler is defined.

  * $handler-name is name of the method.

  * $priority; The priority to which the handler is started. The default is G_PRIORITY_DEFAULT. These are constants defined in **Gnome::GObject::GMain**.

  * $new-context; Whether to run the handler in a new context or to run it in the context of the main loop. Default is to run in the main loop.

  * $start-time. Start time of thread. Default is now + 1 sec. Most of the time a thread starts too fast when some widget are not ready yet. All depends of course what the thread has to do.

  * *%user-options; Any name but :start-time and :new-context is provided to the handler.

Returns a `Promise` object. If the call fails, the object is undefined.

The handlers signature is at least `:$widget` of the object on which the call was made. Furthermore all users named arguments to the call defined in `*%user-options`. The handler may return any value which becomes the result of the `Promise` returned from `start-thread`.

[[g_] object_] set_property
---------------------------

Sets a property on an object.

    method g_object_set_property (
      Str $property_name, Gnome::GObject::Value $value
    )

  * Str $property_name; the name of the property to set

  * N-GObject $value; the value

[[g_] object_] get_property
---------------------------

Gets a property of an object. The value must have been initialized to the expected type of the property (or a type to which the expected type can be transformed).

In general, a copy is made of the property contents and the caller is responsible for freeing the memory by calling `clear-object()`.

Next signature is used when no **Gnome::GObject::Value** is available. The routine will create the Value using `$gtype`.

    method g_object_get_property (
      Str $property_name, Int $gtype
      --> Gnome::GObject::Value
    )

The following is used when a Value object is available.

    method g_object_get_property (
      Str $property_name, Gnome::GObject::Value $value
      --> Gnome::GObject::Value
    )

  * $property_name; the name of the property to get.

  * $gtype; the type of the value, e.g. G_TYPE_INT.

  * $value; the property value. The value is stored in the Value object. Use any of the getter methods of Value to get the data. Also setters are available to modify data.

The methods always return a **Gnome::GObject::Value** with the result.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

[g_] object_ref
---------------

Increases the reference count of this object and returns the same object.

    method g_object_ref ( --> N-GObject  )

[g_] object_unref
-----------------

Decreases the reference count of the native object. When its reference count drops to 0, the object is finalized (i.e. its memory is freed).

When the object has a floating reference because it is not added to a container or it is not a toplevel window, the reference is first sunk followed by `g_object_unref()`.

    method g_object_unref ( )

  * N-GObject $object; a *GObject*

[[g_] object_] is_floating
--------------------------

Checks whether *object* has a [floating][floating-ref] reference.

Since: 2.10

Returns: `1` if *object* has a floating reference

    method g_object_is_floating ( Pointer $object --> Int  )

  * Pointer $object; (type GObject.Object): a *GObject*

[[g_] object_] ref_sink
-----------------------

Increase the reference count of *object*, and possibly remove the [floating][floating-ref] reference, if *object* has a floating reference.

In other words, if the object is floating, then this call "assumes ownership" of the floating reference, converting it to a normal reference by clearing the floating flag while leaving the reference count unchanged. If the object is not floating, then this call adds a new normal reference increasing the reference count by one.

Since GLib 2.56, the type of *object* will be propagated to the return type under the same conditions as for `g_object_ref()`.

Returns: N-GObject

    method g_object_ref_sink ( --> N-GObject )

