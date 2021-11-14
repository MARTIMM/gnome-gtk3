Gnome::Gtk3::AccelMap
=====================

Loadable keyboard accelerator specifications

Description
===========

Accelerator maps are used to define runtime configurable accelerators. Functions for manipulating them are usually used by higher level convenience mechanisms like **Gnome::Gtk3::Builder** and are thus considered “low-level”. You’ll want to use them if you’re manually creating menus that should have user-configurable accelerators.

An accelerator is uniquely defined by:

  * accelerator path

  * accelerator key

  * accelerator modifiers

The _accelerator path_ must consist of `I<“<WINDOWTYPE>/Category1/Category2/.../Action”>`, where `WINDOWTYPE` should be a unique application-specific identifier that corresponds to the kind of window the accelerator is being used in, e.g. “Gimp-Image”, “Abiword-Document” or “Gnumeric-Settings”. The `“Category1/.../Action”` portion is most appropriately chosen by the action the accelerator triggers, i.e. for accelerators on menu items, choose the item’s menu path, e.g. `“File/Save As”`, `“Image/View/Zoom”` or `“Edit/Select All”`. So a full valid accelerator path may look like: “<Gimp-Toolbox>/File/Dialogs/Tool Options...”.

All accelerators are stored inside one global **Gnome::Gtk3::AccelMap** that can be obtained using `get()`.

Manipulating accelerators
-------------------------

New accelerators can be added using `add-entry()`. To search for specific accelerator, use `lookup-entry()`. Modifications of existing accelerators should be done using `change-entry()`.

In order to avoid having some accelerators changed, they can be locked using `lock-path()`. Unlocking is done using `unlock-path()`.

Saving and loading accelerator maps
-----------------------------------

Accelerator maps can be saved to and loaded from some external resource. For simple saving and loading from file, `save()` and `load()` are provided.

Monitoring changes
------------------

**Gnome::Gtk3::AccelMap** object is only useful for monitoring changes of accelerators. By connecting to *changed* signal, one can monitor changes of all accelerators. It is also possible to monitor only single accelerator path by using it as a detail of the *changed* signal.

See Also
--------

**Gnome::Gtk3::AccelGroup**, `Gnome::Gtk3::Widget.set-accel-path()`, `Gnome::Gtk3::MenuItem-set-accel-path()`

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::AccelMap;
    also is Gnome::GObject::Object;

Uml Diagram
-----------

![](plantuml/AccelMap-Group.svg)

Methods
=======

new
---

This module is a singleton. The modules `new()` method throws an exeption. To get an object of this class use the method `instance()`.

add-entry
---------

Registers a new accelerator with the global accelerator map. This function should only be called once per *a$ccel-path* with the canonical *$accel-key* and *$accel-mods* for this path. To change the accelerator during runtime programatically, use `change-entry()`.

Set *$accel-key* and *$accel-mods* to 0 to request a removal of the accelerator.

    method add-entry (
      Str $accel-path, UInt $accel-key, UInt $accel-mods
    )

  * Str $accel-path; valid accelerator path

  * UInt $accel-key; the accelerator key

  * UInt $accel-mods; the accelerator modifiers mask from GdkModifierType to be found in **Gnome::Gdk3::Types**.

add-filter
----------

Adds a filter to the global list of accel path filters.

Accel map entries whose accel path matches one of the filters are skipped by `foreach()`.

This function is intended for GTK+ modules that create their own menus, but don’t want them to be saved into the applications accelerator map dump.

    method add-filter ( Str $filter_pattern )

  * Str $filter_pattern; a pattern (see **Gnome::Gtk3::PatternSpec**)

change-entry
------------

Changes the *$accel-key* and *$accel-mods* currently associated with *accel-path*. Due to conflicts with other accelerators, a change may not always be possible, *$replace* indicates whether other accelerators may be deleted to resolve such conflicts. A change will only occur if all conflicts could be resolved (which might not be the case if conflicting accelerators are locked). Successful changes are indicated by a `True` return value.

Returns: `True` if the accelerator could be changed, `False` otherwise

    method change-entry (
      Str $accel-path, UInt $accel-key,
      UInt $accel-mods, Bool $replace
      --> Bool
    )

  * Str $accel-path; a valid accelerator path

  * UInt $accel-key; the new accelerator key

  * UInt $accel-mods; the new accelerator modifier mask from GdkModifierType to be found in **Gnome::Gdk3::Types**.

  * Bool $replace; `True` if other accelerators may be deleted upon conflicts

foreach
-------

Loops over the entries in the accelerator map whose accel path doesn’t match any of the filters added with `add-filter()`, and execute the method in the provided object on each.

    method foreach (
      Any:D $handler-object, Str:D $handler-name, *%options
    )

  * $handler-object; the object wherein the metod is defined

  * $handler-name; method to be executed for each accel map entry which is not filtered out.

  * %options; Optional data passed to the method.

The method receives the following arguments;

  * Str $accel-path; a valid accelerator path

  * UInt $accel-key; the new accelerator key

  * GdkModifierType $accel-mods; the new accelerator modifier mask found in **Gnome::Gdk3::Types**.

  * Bool $changed; Changed flag of the accelerator (if TRUE, accelerator has changed during runtime and would need to be saved during an accelerator dump).

  * any options provided at the foreach call

    * 

foreach-unfiltered
------------------

Loops over all entries in the accelerator map, and execute *foreach-func* on each. The signature of *foreach-func* is that of **Gnome::Gtk3::AccelMapForeach**, the *changed* parameter indicates whether this accelerator was changed during runtime (thus, would need saving during an accelerator map dump).

    method foreach-unfiltered (
      Any:D $handler-object, Str:D $handler-name, *%options
    )

  * $handler-object; the object wherein the metod is defined

  * $handler-name; method to be executed for each accel map entry which is not filtered out.

  * %options; Optional data passed to the method.

The method receives the following arguments;

  * Str $accel-path; a valid accelerator path

  * UInt $accel-key; the new accelerator key

  * GdkModifierType $accel-mods; the new accelerator modifier mask found in **Gnome::Gdk3::Types**.

  * Bool $changed; Changed flag of the accelerator (if TRUE, accelerator has changed during runtime and would need to be saved during an accelerator dump).

  * any options provided at the foreach call

load
----

Parses a file previously saved with `save()` for accelerator specifications, and propagates them accordingly.

    method load ( Str $file_name )

  * Str $file_name; (type filename): a file containing accelerator specifications, in the GLib file name encoding

lock-path
---------

Locks the given accelerator path. If the accelerator map doesn’t yet contain an entry for *$accel-path*, a new one is created.

Locking an accelerator path prevents its accelerator from being changed during runtime. A locked accelerator path can be unlocked by `unlock-path()`. Refer to `gtk-accel-map-change-entry()` for information about runtime accelerator changes.

If called more than once, *$accel-path* remains locked until `unlock-path()` has been called an equivalent number of times.

Note that locking of individual accelerator paths is independent from locking the **Gnome::Gtk3::AccelGroup** containing them. For runtime accelerator changes to be possible, both the accelerator path and its **Gnome::Gtk3::AccelGroup** have to be unlocked.

    method lock-path ( Str $accel-path )

  * Str $accel-path; a valid accelerator path

lookup-entry
------------

Looks up the accelerator entry for *$accel-path* and returns a `N-GtkAccelKey` structure.

Returns: A defined `N-GtkAccelKey` structure if *$accel-path* is known, undefined otherwise

    method lookup-entry ( Str $accel-path --> N-GtkAccelKey )

  * Str $accel-path; a valid accelerator path

  * N-GtkAccelKey $key; the accelerator key to be filled in

save
----

Saves current accelerator specifications (accelerator path, key and modifiers) to *file-name*. The file is written in a format suitable to be read back in by `load()`.

    method save ( Str $file_name )

  * Str $file_name; (type filename): the name of the file to contain accelerator specifications, in the GLib file name encoding

unlock-path
-----------

Undoes the last call to `lock-path()` on this *accel-path*. Refer to `gtk-accel-map-lock-path()` for information about accelerator path locking.

    method unlock-path ( Str $accel-path )

  * Str $accel-path; a valid accelerator path

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

### changed

Notifies of a change in the global accelerator map. The path is also used as the detail for the signal, so it is possible to connect to changed::`accel-path`.

    method handler (
      Str $accel-path,
      UInt $accel-key,
      UInt $accel-mods,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($object),
      *%user-options
      --> Int
    );

  * $object; the global accel map object

  * $accel-path; the path of the accelerator that changed

  * $accel-key; the key value for the new accelerator

  * $accel-mods; the modifier mask for the new accelerator. A GdkModifierType mask from Gnome::Gdk3::Types

  * $_handle_id; the registered event handler id

