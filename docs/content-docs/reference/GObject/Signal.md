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

Connects a callback function to a signal for a particular object.

    method g_signal_connect_object (
      N-GObject $instance, Str $detailed-signal, Callable $handler
      --> Int
    ) {

[[g_] signal_] emit_by_name
---------------------------

Emits a signal. Note that `g_signal_emit_by_name()` resets the return value to the default if no handlers are connected.

    g_signal_emit_by_name (
      Str $detailed-signal, *@handler-arguments, *%options
    )

  * $signal; a string of the form "signal-name::detail". '::detail' part is mostly not defined such as a button click signal called 'clicked'.

  * *@handler-arguments; a series of arguments needed for the signal handler.

  * *%options; needed to modify argument types and return value;

    * :parameters([type, ...]); a series of types, one for each argument. Most of the time the types are correctly interpreted but for e.g. int64 or num64 this option must be provided. All types for all arguments must be specified if used.

    * :return-type(type); specifies the type of the return value. When there is no return value, you can omit this. An error is be thrown by GTK+ when a return value type is not specified while the signal handler does return something.

    (Window.t:46695): GLib-GObject-WARNING **: 15:04:59.689: ../gobject/gsignal.c:3417: value location for 'gboolean' passed as NULL

### An example

      # The extra argument here is $toggle
      method enable-debugging-handler (
        int32 $toggle, Gnome::Gtk3::Window :$widget
        --> int32
      ) {
        ...
        1
      }

      $w.register-signal( self, 'enable-debugging-handler', 'enable-debugging');

      ... loop started ...
      ... in another thread ...
      my Gnome::Gtk3::Main $main .= new;
      while $main.gtk-events-pending() { $main.iteration-do(False); }
      $widget.emit-by-name(
        'enable-debugging', 1, :return-type(int32), :parameters([int32,])
      );

      ...

[[g_] signal_] handler_disconnect
---------------------------------

Disconnects a handler from an instance so it will not be called during any future or currently ongoing emissions of the signal it has been connected to. The handler_id becomes invalid and may be reused.

The handler_id has to be a valid signal handler id, connected to a signal of instance.

    g_signal_handler_disconnect( Int $handler_id )

  * $handler_id; Handler id of the handler to be disconnected.

