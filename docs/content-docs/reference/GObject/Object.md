Gnome::GObject::Object
======================

The base object type

Description
===========

Gnome::GObject::Object is the fundamental type providing the common attributes and methods for all object types in GTK+, Pango and other libraries based on GObject. The GObject class provides methods for object construction and destruction, property access methods, and signal support.

Synopsis
========

Declaration
-----------

    unit class Gnome::GObject::Object;
    also is Gnome::N::TopLevelClassSupport;
    also does Gnome::GObject::Signal;

Uml Diagram
-----------

![](plantuml/Object.svg)

Methods
=======

new
---

Create a Raku object using a **Gnome::Gtk3::Builder**. The builder object will provide its object (self) to **Gnome::GObject::Object** when the Builder is created. The Builder object is asked to search for id's defined in the GUI glade design.

    multi method new ( Str :$build-id! )

An example

    my Gnome::Gtk3::Builder $builder .= new(:filename<my-gui.glade>);
    my Gnome::Gtk3::Button $button .= new(:build-id<my-gui-button>);

get-data
--------

Gets a named field from the objects table of associations. See `set-data()` for several examples.

Returns: the data if found, or `undefined` if no such data exists.

    method get-data ( Str $key, $type, Str :$widget-class --> Any )

  * Str $key; name of the key for that association

  * $type; specification of the type of data to return. The recognized types are; int*, uint*, num*, Buf, (U)Int, Num, Str, Bool and N-GObject. the native int and uint type are taken as int64 and uint64 respectively. In the case of N-GObject the method will try to create a raku object. When it was undefined, this is not possible and it will return an undefined N-GObject. The N-GObject type can be helped by specifying the named argument `widget-class`. This should be a name of a raku class like for instance **Gnome::Gtk3::Label**. When the return value was undefined, the result object will always have the raku class type but the call to <.is-valid()> returns False. Note that Int, UInt, and Num is transformed to their 32 bit representations.

  * Str :$widget-class; Create object of this type.

get-properties
--------------

Gets properties of an object.

In general, a copy is made of the property contents and the caller is responsible for freeing the memory in the appropriate manner for the type, for instance by calling `g_free()` or `g_object_unref()`.

The method is defined as;

    method get-properties ( $prop-name, $prop-value-type, … --> List )

  * Str $prop-name; name of a property to set.

  * $prop-value-type; The type of the property to receive. It can be any of Str, Int, UInt, Num, Bool, int*, uint*, num*. (U)Int is converted to (u)int32 and Num to num32.

See `.set()` for an example.

get-property
------------

Gets a property of an object. The value must have been initialized to the expected type of the property (or a type to which the expected type can be transformed).

In general, a copy is made of the property contents and the caller is responsible for freeing the memory by calling `clear-object()`.

Next signature is used when no **Gnome::GObject::Value** is available. The routine will create the Value using `$gtype`.

    multi method get-property (
      Str $property_name, Int $gtype
      --> Gnome::GObject::Value
    )

The following is used when a Value object is available.

    multi method get-property (
      Str $property_name, N-GValue $value
      --> Gnome::GObject::Value
    )

  * Str $property_name; the name of the property to get.

  * Int $gtype; the type of the value, e.g. G_TYPE_INT.

  * N-GValue $value; The value is stored in a N-GValue object. It is used to get the type of the object.

The methods always return a **Gnome::GObject::Value** with the result.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

is-floating
-----------

Checks whether *object* has a floating reference.

Returns: `True` if *object* has a floating reference

    method is-floating ( --> Bool )

  * Pointer $object; (type GObject.Object): a *GObject*

ref-sink
--------

Increase the reference count of this native *object*, and possibly remove the floating reference, if *object* has a floating reference.

In other words, if the object is floating, then this call "assumes ownership" of the floating reference, converting it to a normal reference by clearing the floating flag while leaving the reference count unchanged. If the object is not floating, then this call adds a new normal reference increasing the reference count by one.

The type of *object* will be propagated to the return type under the same conditions as for `g_object_ref()`.

Returns: N-GObject

    method ref-sink ( --> N-GObject )

register-signal
---------------

Register a handler to process a signal or an event. There are several types of callbacks which can be handled by this regstration. They can be controlled by using a named argument with a special name.

    method register-signal (
      $handler-object, Str:D $handler-name,
      Str:D $signal-name, *%user-options
      --> Int
    )

  * $handler-object; The object wherein the handler is defined.

  * $handler-name; The name of the method.

  * $signal-name; The name of the event to be handled. Each gtk object has its own series of signals.

  * %user-options; Any other user data in whatever type provided as one or more named arguments. These arguments are provided to the user handler when an event for the handler is fired. The names starting with '_' are reserved to provide other info to the user.

    The following reserved named arguments are available;

      * `:$_handler-id`; The handler id which is returned from the registration

      * `:$_native-object`; The native object provided by the caller.

          method some-handler (
            …,
            Gnome::Gtk3::Button() :_native-object($button)
          ) {
            …
          }

The method returns a handler id which can be used for example to disconnect the callback later.

### Callback handlers

  * Simple handlers; e.g. a click event handler has only named arguments and are optional.

  * Complex handlers (only a bit) also have positional arguments and **MUST** be typed because they are checked to create a signature for the call to a native subroutine. You can use the raku native types like `int32` but several types are automatically converted to native types. The types such as gboolean, etc are defined in **Gnome::N::GlibToRakuTypes**.

    <table class="pod-table">
    <thead><tr>
    <th>Raku type</th> <th>Native glib type</th> <th>Native Raku type</th>
    </tr></thead>
    <tbody>
    <tr> <td>Bool</td> <td>gboolean</td> <td>int32</td> </tr> <tr> <td>UInt</td> <td>guint</td> <td>uint32/uint64</td> </tr> <tr> <td>Int</td> <td>gint</td> <td>int32/int64</td> </tr> <tr> <td>Num</td> <td>gfloat</td> <td>num32</td> </tr> <tr> <td>Rat</td> <td>gdouble</td> <td>num64</td> </tr>
    </tbody>
    </table>

  * Some handlers must return a value and is used by the calling process. You **MUST** describe this too in the andlers API, otherwise the returned value is thrown away.

  * Any user options are provided via named arguments from the call to `register-signal()`.

### Example 1

An example of a registration and the handlers signature to handle a button click event.

    # Handler class with callback methods
    class ButtonHandlers {
      method click-button (
        Gnome::Gtk3::Button() :_native-object($button),
        Int :$_handler_id, :$my-option ) {
        …
      }
    }

    $button.register-signal(
      ButtonHandlers.new, 'click-button', 'clicked', :my-option(…)
    );

### Example 2

An example where a keyboard press is handled.

    # Handler class with callback methods
    class KeyboardHandlers {
      method keyboard-handler (
        N-GdkEvent $event,
        Int :$_handler_id, :$my-option
        Gnome::Gtk3::Window() :_native-object($bwindow),
        --> gboolean
      ) {
        …

      }
    }

    $window.register-signal(
      KeyboardHandlers.new, 'keyboard-handler',
      'key-press-event', :my-option(…)
    );

set-data
--------

Each object carries around a table of associations from strings to pointers. This function lets you set an association.

If the object already had an association with that name, the old association will be destroyed.

    method set-data ( Str $key, $data )

  * Str $key; name of the key.

  * $data; data to associate with that key. Supported types are int*, uint*, num*, Pointer, Buf, Int, Num, Str, Bool and N-GObject. A raku widget object such as Gnome::Gdk3::Screen can also be given. The native object is retrieved from the raku widget and then stored as a N-GObject. Further is it important to note that Int, UInt, and Num is transformed to their 32 bit representations.

### Example 1

Here is an example to show how to associate some data to an object and to retrieve it again. You must import the raku **NativeCall** module to get access to some of the native types and routines.

    my Gnome::Gtk3::Button $button .= new(:label<Start>);
    my Gnome::Gtk3::Label $att-label .= new(:text<a-label>);
    $button.set-data( 'attached-label-data', $att-label);

    …

    my Gnome::Gtk3::Label $att-label2 =
      $button.get-data( 'attached-label-data', N-GObject);

or, if you want to be sure, add the `widget-class` named argument;

    my Gnome::Gtk3::Label $att-label2 = $button.get-data(
      'attached-label-data', N-GObject,
      :widget-class<Gnome::Gtk3::Label>
    );

### Example 2

Other types can be used as well to store data. The next example shows what is possible;

    $button.set-data( 'my-text-key', 'my important text');
    $button.set-data( 'my-uint32-key', my uint32 $x = 12345);

    …

    my Str $text = $button.get-data( 'my-text-key', Str);
    my Int $number = $button.get-data( 'my-uint32-key', uint32);

### Example 3

An elaborate example of more complex data can be used with BSON. This is an implementation of a JSON like structure but is serialized into a binary representation. It is used for transport to and from a mongodb server. Here we use it to attach complex data in serialized form to an **Gnome::GObject::Object**. (Please note that the BSON package must be of version 0.13.2 or higher. More [documenation at](https://martimm.github.io/raku-mongodb-driver/content-docs/reference/BSON/Document.html))

    # Create the data structure
    my BSON::Document $bson .= new: (
      :int-number(-10),
      :num-number(-2.34e-3),
      :strings( :s1<abc>, :s2<def>, :s3<xyz> )
    );

    # And store it on a label
    my Gnome::Gtk3::Label $bl .= new(:text<a-label>);
    $bl.set-data( 'my-buf-key', $bson.encode);

    …

    # Later, we want to access the data again,
    my BSON::Document $bson2 .= new($bl.get-data( 'my-buf-key', Buf));

    # Now you can use the data again.
    say $bson2<int-number>;  # -10
    say $bson2<num-number>;  # -234e-5
    say $bson2<strings><s2>; # 'def'

set-properties
--------------

Sets properties on an object.

Note that the "notify" signals are queued and only emitted (in reverse order) after all properties have been set.

    method set-properties ( Str :$prop-name($prop-value), … )

  * Str $prop-name; name of a property to set.

  * $prop-value; The value of the property to set. Its type can be any of Str, Int, Num, Bool, int8, int16, int32, int64, num32, num64, GEnum, GFlag, GQuark, GType, gboolean, gchar, guchar, gdouble, gfloat, gint, gint8, gint16, gint32, gint64, glong, gshort, guint, guint8, guint16, guint32, guint64, gulong, gushort, gsize, gssize, gpointer or time_t. Int is converted to int32 and Num to num32. You must use **Gnome::N::GlibToRakuTypes** to have the g* types and time_t.

### Example

A button has e.g. the properties `label` and `use-underline`. To set those and retrieve them, do the following

    my Gnome::Gtk3::Button $b .= new(:label<?>);
    $button.set-properties( :label<_Start>, :use-underline(True));
    …

    method my-button-click-event-handler (
      Gnome::Gtk3::Button :_native-object($button)
    ) {
      # Get the properties set elsewhere on the button
      my @rv = $button.get-properties( 'label', Str, 'use-underline', Bool);

      # Do something with intval, strval, objval
      say @rv[0];   # _Start
      say @rv[1];   # 1
      …

Note that boolean values from C are integers which are 0 or 1.

set-property
------------

Sets a property on an object.

    method set-property ( Str $property_name, N-GValue $value )

  * Str $property_name; the name of the property to set

  * N-GObject $value; the value

start-thread
------------

Start a thread in such a way that the function can modify the user interface in a save way and that these updates are automatically made visible without explicitly process events queued and waiting in the main loop.

    method start-thread (
      $handler-object, Str:D $handler-name,
      Bool :$new-context = False, Num :$start-time = now + 1,
      *%user-options
      --> Promise
    )

  * $handler-object is the object wherein the handler is defined.

  * $handler-name is name of the method.

  * $new-context; Whether to run the handler in a new context or to run it in the context of the main loop. Default is to run in the main loop.

  * $start-time. Start time of thread. Default is now + 1 sec. Most of the time a thread starts too fast when some widget are not ready yet. All depends of course what the thread has to do.

  * %user-options; Any other user data in whatever type provided as one or more named arguments except for :start-time and :new-context. These arguments are provided to the user handler when the callback is invoked.

    There will always be one named argument `:$widget` which holds the class object on which the thread is started. The name 'widget' is therefore reserved.

    The following named arguments can be used in the callback handler next to the other user definable options;

      * `:$_widget`; The instance which registered the signal.

Returns a `Promise` object. If the call fails, the object is undefined.

The handlers signature holds at least `:$_widget` extended with all provided named arguments to the call defined in `*%user-options`. The handler may return any value which becomes the result of the `Promise` returned from `start-thread`.

steal-data
----------

Remove a specified datum from the object's data associations, without invoking the association's destroy handler.

Returns: the data if found, or `Any` if no such data exists.

    method steal-data ( Str $key --> Pointer )

  * Str $key; name of the key

