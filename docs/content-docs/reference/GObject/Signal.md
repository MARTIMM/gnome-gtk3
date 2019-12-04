Gnome::GObject::Signal
======================

A means for customization of object behaviour and a general purpose notification mechanism

Description
===========

Synopsis
========

Declaration
-----------

    unit class Gnome::GObject::Signal;

Example
-------

    use NativeCall;
    use Gnome::N::N-GObject;
    use Gnome::Gdk3::Events;
    use Gnome::Gtk3::Window;

    # Get a window object
    my Gnome::Gtk3::Window $w .= new( ... );

    # Define proper handler. The handler API must describe all arguments
    # and their types.
    my Callable $handler = sub (
      N-GObject $native-widget, GdkEvent $event, OpaquePointer $ignore-d
    ) {
      ...
    }

    # Connect signal to the handler.
    $w.connect-object( 'button-press-event', $handler);

The other option to connect a signal is to use the `register-signal()` method defined in **Gnome::GObject::Object**. It all depends on how elaborate things are or taste.

    use Gnome::Gdk3::Events;
    use Gnome::Gtk3::Window;

    # Define handler method. The handler API must describe all positional
    # arguments and their types.
    method mouse-event ( GdkEvent $event, :$widget ) { ... }

    # Get a window object
    my Gnome::Gtk3::Window $w .= new( ... );

    # Then register
    $w.register-signal( self, 'mouse-event', 'button-press-event');

Methods
=======

[[g_] signal_] emit_by_name
---------------------------

Emits a signal.

Note that `g_signal_emit_by_name()` resets the return value to the default if no handlers are connected.

    g_signal_emit_by_name ( Str $signal, N-GObject $widget )

  * $signal; a string of the form "signal-name::detail".

  * $widget; widget to pass to the handler.

[[g_] signal_] handler_disconnect
---------------------------------

Disconnects a handler from an instance so it will not be called during any future or currently ongoing emissions of the signal it has been connected to. The handler_id becomes invalid and may be reused.

The handler_id has to be a valid signal handler id, connected to a signal of instance .

    g_signal_handler_disconnect( int32 $handler_id )

  * $handler_id; Handler id of the handler to be disconnected.

