Gnome::Gtk3::SearchEntry
========================

An entry which shows a search icon

![](images/search-entry.png)

Description
===========

**Gnome::Gtk3::SearchEntry** is a subclass of **Gnome::Gtk3::Entry** that has been tailored for use as a search entry.

It will show an inactive symbolic “find” icon when the search entry is empty, and a symbolic “clear” icon when there is text. Clicking on the “clear” icon will empty the search entry.

Note that the search/clear icon is shown using a secondary icon, and thus does not work if you are using the secondary icon position for some other purpose.

To make filtering appear more reactive, it is a good idea to not react to every change in the entry text immediately, but only after a short delay. To support this, **Gnome::Gtk3::SearchEntry** emits the *search-changed* signal which can be used instead of the *changed* signal.

The *previous-match*, *next-match* and *stop-search* signals can be used to implement moving between search results and ending the search.

Often, **Gnome::Gtk3::SearchEntry** will be fed events by means of being placed inside a **Gnome::Gtk3::SearchBar**. If that is not the case, you can use `gtk_search_entry_handle_event()` to pass events.

Since: 3.6

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::SearchEntry;
    also is Gnome::Gtk3::Entry;

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

[gtk_] search_entry_new
-----------------------

Creates a **Gnome::Gtk3::SearchEntry**, with a find icon when the search field is empty, and a clear icon when it isn't.

Returns: a new **Gnome::Gtk3::SearchEntry**

Since: 3.6

    method gtk_search_entry_new ( --> N-GObject  )

[[gtk_] search_entry_] handle_event
-----------------------------------

This function should be called when the top-level window which contains the search entry received a key event. If the entry is part of a **Gnome::Gtk3::SearchBar**, it is preferable to call `gtk_search_bar_handle_event()` instead, which will reveal the entry in addition to passing the event to this function.

If the key event is handled by the search entry and starts or continues a search, `GDK_EVENT_STOP` will be returned. The caller should ensure that the entry is shown in this case, and not propagate the event further.

Returns: `GDK_EVENT_STOP` if the key press event resulted in a search beginning or continuing, `GDK_EVENT_PROPAGATE` otherwise.

Since: 3.16

    method gtk_search_entry_handle_event ( GdkEvent $event --> Int  )

  * GdkEvent $event; a key event

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

### search-changed

The *search-changed* signal is emitted with a short delay of 150 milliseconds after the last change to the entry text.

Since: 3.10

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($entry),
      *%user-options
    );

  * $entry; the entry on which the signal was emitted

### next-match

The *next-match* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted when the user initiates a move to the next match for the current search string.

Applications should connect to it, to implement moving between matches.

The default bindings for this signal is Ctrl-g.

Since: 3.16

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($entry),
      *%user-options
    );

  * $entry; the entry on which the signal was emitted

### previous-match

The *previous-match* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted when the user initiates a move to the previous match for the current search string.

Applications should connect to it, to implement moving between matches.

The default bindings for this signal is Ctrl-Shift-g.

Since: 3.16

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($entry),
      *%user-options
    );

  * $entry; the entry on which the signal was emitted

### stop-search

The *stop-search* signal is a keybinding signal which gets emitted when the user stops a search via keyboard input.

Applications should connect to it, to implement hiding the search entry in this case.

The default bindings for this signal is Escape.

Since: 3.16

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($entry),
      *%user-options
    );

  * $entry; the entry on which the signal was emitted

