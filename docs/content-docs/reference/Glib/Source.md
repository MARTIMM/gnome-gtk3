Gnome::Glib::Source
===================

manages all available sources of events

Description
===========

To get a bigger picture, you can read the description of class **Gnome::Glib::MainContext**.

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::Source;
    also is Gnome::N::TopLevelClassSupport;

Methods
=======

new
---

### :idle

Create a new Source object to run processes in idle time. The source will not initially be associated with any **Gnome::Glib::MainContext** and must be added to one with `attach()` before it will be executed. Note that the default priority for idle sources is `G-PRIORITY-DEFAULT-IDLE`, as compared to other sources which have a default priority of `G-PRIORITY-DEFAULT`.

    multi method new ( :idle! )

### :timout

Creates a new timeout source. The source will not initially be associated with any **Gnome::Glib::MainContext** and must be added to one with `attach()` before it will be executed.

The interval given is in terms of monotonic time, not wall clock time. See `get-monotonic-time()`.

    multi method new ( Int :$timeout!, Bool :$seconds = False )

  * UInt $interval; the timeout interval in milliseconds.

### :native-object

Create a Source object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

attach
------

Adds a **Gnome::Glib::Source** to a *context* so that it will be executed within that context. Remove it by calling `destroy()`.

Returns: the ID (greater than 0) for the source within the **Gnome::Glib::MainContext**.

    method attach ( N-GObject $context --> UInt )

  * N-GObject $context; a **Gnome::Glib::MainContext** (if `undefined`, the default context will be used)

destroy
-------

Removes a source from its **Gnome::Glib::MainContext**, if any, and mark it as destroyed. The source cannot be subsequently added to another context. It is safe to call this on sources which have already been removed from their context.

    method destroy ( )

get-monotonic-time
------------------

Queries the system monotonic time.

The monotonic clock will always increase and doesn't suffer discontinuities when the user (or NTP) changes the system time. It may or may not continue to tick during times where the machine is suspended.

We try to use the clock that corresponds as closely as possible to the passage of time as measured by system calls such as `poll()` but it may not always be possible to do this.

Returns: the monotonic time, in microseconds

    method get-monotonic-time ( --> Int )

get-real-time
-------------

Queries the system wall-clock time.

This call is functionally equivalent to `g-get-current-time()` except that the return value is often more convenient than dealing with a **Gnome::Glib::TimeVal**.

You should only use this call if you are actually interested in the real wall-clock time. `g-get-monotonic-time()` is probably more useful for measuring intervals.

Returns: the number of microseconds since January 1, 1970 UTC.

    method get-real-time ( --> Int )

idle-add
--------

Adds a function to be called whenever there are no higher priority events pending to the default main loop. The function is given the default idle priority, `G-PRIORITY-DEFAULT-IDLE`. If the function returns `False` it is automatically removed from the list of event sources and will not be called again.

This internally creates a main loop source using `g-idle-source-new()` and attaches it to the global **Gnome::Glib::MainContext** using `attach()`, so the callback will be invoked in whichever thread is running that main context. You can do these steps manually if you need greater control or to use a custom main context.

Returns: the ID (greater than 0) of the event source.

    method idle-add (
      Any:D $handler-object, Str:D $method, *%user-options
      --> UInt
    )

  * $handler-object; User object where $method is defined

  * Str $method; name of callback handler

  * %user-options; optional named arguments to be provided to the callback

idle-add-full
-------------

Adds a function to be called whenever there are no higher priority events pending. If the function returns `False` it is automatically removed from the list of event sources and will not be called again.

This internally creates a main loop source using `g-idle-source-new()` and attaches it to the global **Gnome::Glib::MainContext** using `attach()`, so the callback will be invoked in whichever thread is running that main context. You can do these steps manually if you need greater control or to use a custom main context.

Returns: the ID (greater than 0) of the event source.

    method idle-add-full (
      Int $priority,
      Any:D $handler-object, Str:D $method, Str $method-notify = Str,
      *%user-options
      --> UInt
    )

  * Int $priority; the priority of the idle source. Typically this will be in the range between `G-PRIORITY-DEFAULT-IDLE` and `G-PRIORITY-HIGH-IDLE`.

  * $handler-object; User object where both methods are defined

  * Str $method; name of callback handler

  * Str $method-notify; name of callback handler. Ignored when $method-notify is undefined. This function is called when the source is removed.

  * %user-options; optional named arguments to be provided to both callbacks

timeout-add
-----------

Sets a function to be called at regular intervals, with the default priority, `G-PRIORITY-DEFAULT`. The function is called repeatedly until it returns `False`, at which point the timeout is automatically destroyed and the function will not be called again. The first call to the function will be at the end of the first *$interval*.

Note that timeout functions may be delayed, due to the processing of other event sources. Thus they should not be relied on for precise timing. After each call to the timeout function, the time of the next timeout is recalculated based on the current time and the given interval (it does not try to 'catch up' time lost in delays).

If you want to have a timer in the "seconds" range and do not care about the exact time of the first call of the timer, use the `timeout-add-seconds()` function; this function allows for more optimizations and more efficient system power usage.

The interval given is in terms of monotonic time, not wall clock time. See `get-monotonic-time()`.

Returns: the ID (greater than 0) of the event source.

    method timeout-add (
      UInt $interval,
      Any:D $handler-object, Str:D $method, *%user-options
      --> UInt
    )

  * UInt $interval; the time between calls to the function, in milliseconds (1/1000ths of a second)

  * $handler-object; User object where $method is defined

  * Str $method; name of callback handler

  * %user-options; optional named arguments to be provided to the callback

timeout-add-full
----------------

Sets a function to be called at regular intervals, with the given priority. The function is called repeatedly until it returns `False`, at which point the timeout is automatically destroyed and the function will not be called again. The *notify* function is called when the timeout is destroyed. The first call to the function will be at the end of the first *interval*.

Note that timeout functions may be delayed, due to the processing of other event sources. Thus they should not be relied on for precise timing. After each call to the timeout function, the time of the next timeout is recalculated based on the current time and the given interval (it does not try to 'catch up' time lost in delays).

This internally creates a main loop source using `g-timeout-source-new()` and attaches it to the global **Gnome::Glib::MainContext** using `attach()`, so the callback will be invoked in whichever thread is running that main context. You can do these steps manually if you need greater control or to use a custom main context.

The interval given is in terms of monotonic time, not wall clock time. See `g-get-monotonic-time()`.

Returns: the ID (greater than 0) of the event source.

    method timeout-add-full (
      Int $priority, UInt $interval,
      Any:D $handler-object, Str:D $method, Str $method-notify = Str,
      *%user-options
      --> UInt
    )

  * Int $priority; the priority of the timeout source. Typically this will be in the range between `G-PRIORITY-DEFAULT` and `G-PRIORITY-HIGH`.

  * UInt $interval; the time between calls to the function, in milliseconds (1/1000ths of a second)

  * $handler-object; User object where both methods are defined

  * Str $method; name of callback handler

  * Str $method-notify; name of callback handler. Ignored when $method-notify is undefined. This function is called when the source is removed.

  * %user-options; optional named arguments to be provided to both callbacks

timeout-add-seconds
-------------------

Sets a function to be called at regular intervals with the default priority, `G-PRIORITY-DEFAULT`. The function is called repeatedly until it returns `False`, at which point the timeout is automatically destroyed and the function will not be called again.

This internally creates a main loop source using `g-timeout-source-new-seconds()` and attaches it to the main loop context using `attach()`. You can do these steps manually if you need greater control. Also see `timeout-add-seconds-full()`.

Note that the first call of the timer may not be precise for timeouts of one second. If you need finer precision and have such a timeout, you may want to use `timeout-add()` instead.

The interval given is in terms of monotonic time, not wall clock time. See `g-get-monotonic-time()`.

Returns: the ID (greater than 0) of the event source.

    method timeout-add-seconds (
      UInt $interval, Any:D $handler-object, Str:D $method, *%user-options
      --> UInt
    )

  * UInt $interval; the time between calls to the function, in seconds

  * $handler-object; User object where $method is defined

  * Str $method; name of callback handler

  * %user-options; optional named arguments to be provided to the callback

timeout-add-seconds-full
------------------------

Sets a function to be called at regular intervals, with *priority*. The function is called repeatedly until it returns `False`, at which point the timeout is automatically destroyed and the function will not be called again.

Unlike `timeout-add()`, this function operates at whole second granularity. The initial starting point of the timer is determined by the implementation and the implementation is expected to group multiple timers together so that they fire all at the same time. To allow this grouping, the *$interval* to the first timer is rounded and can deviate up to one second from the specified interval. Subsequent timer iterations will generally run at the specified interval.

Note that timeout functions may be delayed, due to the processing of other event sources. Thus they should not be relied on for precise timing. After each call to the timeout function, the time of the next timeout is recalculated based on the current time and the given *$interval*

If you want timing more precise than whole seconds, use `timeout-add()` instead.

The grouping of timers to fire at the same time results in a more power and CPU efficient behavior so if your timer is in multiples of seconds and you don't require the first timer exactly one second from now, the use of `timeout-add-seconds()` is preferred over `timeout-add()`.

This internally creates a main loop source using `timeout-source-new-seconds()` and attaches it to the main loop context using `attach()`. You can do these steps manually if you need greater control.

The interval given is in terms of monotonic time, not wall clock time. See `get-monotonic-time()`.

Returns: the ID (greater than 0) of the event source.

    method timeout-add-seconds-full (
      Int $priority, UInt $interval,
      Any:D $handler-object, Str:D $method, Str $method-notify = Str,
      *%user-options
      --> UInt
    )

  * Int $priority; the priority of the timeout source. Typically this will be in the range between `G-PRIORITY-DEFAULT` and `G-PRIORITY-HIGH`.

  * UInt $interval; the time between calls to the function, in seconds

  * $handler-object; User object where both methods are defined

  * Str $method; name of callback handler

  * Str $method-notify; name of callback handler. Ignored when $method-notify is undefined. This function is called when the source is removed.

  * %user-options; optional named arguments to be provided to both callbacks

get-can-recurse
---------------

Checks whether a source is allowed to be called recursively. see `set-can-recurse()`.

Returns: whether recursion is allowed.

    method get-can-recurse ( --> Bool )

get-context
-----------

Gets the **Gnome::Glib::MainContext** with which the source is associated.

You can call this on a source that has been destroyed, provided that the **Gnome::Glib::MainContext** it was attached to still exists (in which case it will return that **Gnome::Glib::MainContext**). In particular, you can always call this function on the source returned from `g-main-current-source()`. But calling this function on a source whose **Gnome::Glib::MainContext** has been destroyed is an error.

Returns: the **Gnome::Glib::MainContext** with which the source is associated, or `undefined` if the context has not yet been added to a source.

    method get-context ( --> N-GObject )

get-id
------

Returns the numeric ID for a particular source. The ID of a source is a positive integer which is unique within a particular main loop context. The reverse mapping from ID to source is done by `g-main-context-find-source-by-id()`.

You can only call this function while the source is associated to a **Gnome::Glib::MainContext** instance; calling this function before `attach()` or after `g-source-destroy()` yields undefined behavior. The ID returned is unique within the **Gnome::Glib::MainContext** instance passed to `g-source-attach()`.

Returns: the ID (greater than 0) for the source

    method get-id ( --> UInt )

get-name
--------

Gets a name for the source, used in debugging and profiling. The name may be **NULL** if it has never been set with `set-name()`.

Returns: the name of the source

    method get-name ( --> Str )

get-priority
------------

Gets the priority of a source.

Returns: the priority of the source

    method get-priority ( --> Int )

get-ready-time
--------------

Gets the "ready time" of *source*, as set by `set-ready-time()`.

Any time before the current monotonic time (including 0) is an indication that the source will fire immediately.

Returns: the monotonic ready time, -1 for "never"

    method get-ready-time ( --> Int )

get-time
--------

Gets the time to be used when checking this source. The advantage of calling this function over calling `g-get-monotonic-time()` directly is that when checking multiple sources, GLib can cache a single value instead of having to repeatedly get the system monotonic time.

The time here is the system monotonic time, if available, or some other reasonable alternative otherwise. See `g-get-monotonic-time()`.

Returns: the monotonic time in microseconds

    method get-time ( --> Int )

remove
------

Removes the source with the given ID from the default main context. You must use `destroy()` for sources added to a non-default main context.

The ID of a **Gnome::Glib::Source** is given by `g-source-get-id()`, or will be returned by the functions `g-source-attach()`, `g-idle-add()`, `g-idle-add-full()`, `g-timeout-add()`, `g-timeout-add-full()`, `g-child-watch-add()`, `g-child-watch-add-full()`, `g-io-add-watch()`, and `g-io-add-watch-full()`.

It is a programmer error to attempt to remove a non-existent source.

More specifically: source IDs can be reissued after a source has been destroyed and therefore it is never valid to use this function with a source ID which may have already been removed. An example is when scheduling an idle to run in another thread with `g-idle-add()`: the idle may already have run and been removed by the time this function is called on its (now invalid) source ID. This source ID may have been reissued, leading to the operation being performed against the wrong source.

Returns: For historical reasons, this function always returns `True`

    method remove ( UInt $tag --> Bool )

  * UInt $tag; the ID of the source to remove.

remove-child-source
-------------------

Detaches *child-source* from *source* and destroys it.

This API is only intended to be used by implementations of **Gnome::Glib::Source**. Do not call this API on a **Gnome::Glib::Source** that you did not create.

    method remove-child-source ( N-GObject $child_source )

  * N-GObject $child_source; a **Gnome::Glib::Source** previously passed to `add-child-source()`.

set-callback
------------

Sets the callback function for a source. The callback for a source is called from the source's dispatch function.

Typically, you won't use this function. Instead use functions specific to the type of source you are using, such as `g-idle-add()` or `g-timeout-add()`.

It is safe to call this function multiple times on a source which has already been attached to a context. The changes will take effect for the next time the source is dispatched after this call returns.

    method set-callback (
      Any:D $handler-object, Str:D $method, Str $method-notify = Str,
      *%user-options
    )

  * $handler-object; User object where both methods are defined

  * Str $method; name of callback handler

  * Str $method-notify; name of callback handler. Ignored when $method-notify is undefined. This function is called when the source is removed.

  * %user-options; optional named arguments to be provided to both callbacks

set-name
--------

Sets a name for the source, used in debugging and profiling. The name defaults to **NULL**.

The source name should describe in a human-readable way what the source does. For example, "X11 event queue" or "GTK+ repaint idle handler" or whatever it is.

It is permitted to call this function multiple times, but is not recommended due to the potential performance impact. For example, one could change the name in the "check" function of a **Gnome::Glib::SourceFuncs** to include details like the event type in the source name.

Use caution if changing the name while another thread may be accessing it with `get-name()`; that function does not copy the value, and changing the value will free it while the other thread may be attempting to use it.

    method set-name ( Str $name )

  * Str $name; debug name for the source

set-name-by-id
--------------

Sets the name of a source using its ID.

This is a convenience utility to set source names from the return value of `g-idle-add()`, `timeout-add()`, etc.

It is a programmer error to attempt to set the name of a non-existent source.

More specifically: source IDs can be reissued after a source has been destroyed and therefore it is never valid to use this function with a source ID which may have already been removed. An example is when scheduling an idle to run in another thread with `g-idle-add()`: the idle may already have run and been removed by the time this function is called on its (now invalid) source ID. This source ID may have been reissued, leading to the operation being performed against the wrong source.

    method set-name-by-id ( UInt $tag, Str $name )

  * UInt $tag; a **Gnome::Glib::Source** ID

  * Str $name; debug name for the source

set-priority
------------

Sets the priority of a source. While the main loop is being run, a source will be dispatched if it is ready to be dispatched and no sources at a higher (numerically smaller) priority are ready to be dispatched.

A child source always has the same priority as its parent. It is not permitted to change the priority of a source once it has been added as a child of another source.

    method set-priority ( Int $priority )

  * Int $priority; the new priority.

set-ready-time
--------------

Sets a **Gnome::Glib::Source** to be dispatched when the given monotonic time is reached (or passed). If the monotonic time is in the past (as it always will be if *ready-time* is 0) then the source will be dispatched immediately.

If *ready-time* is -1 then the source is never woken up on the basis of the passage of time.

Dispatching the source does not reset the ready time. You should do so yourself, from the source dispatch function.

Note that if you have a pair of sources where the ready time of one suggests that it will be delivered first but the priority for the other suggests that it would be delivered first, and the ready time for both sources is reached during the same main context iteration, then the order of dispatch is undefined.

It is a no-op to call this function on a **Gnome::Glib::Source** which has already been destroyed with `destroy()`.

This API is only intended to be used by implementations of **Gnome::Glib::Source**. Do not call this API on a **Gnome::Glib::Source** that you did not create.

    method set-ready-time ( Int $ready_time )

  * Int $ready_time; the monotonic time at which the source will be ready, 0 for "immediately", -1 for "never"

