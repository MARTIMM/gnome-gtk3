Gnome::Glib::MainContext
========================

Description
===========

See for more information [here at module Gnome::Glib::Main](Main.html).

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::MainContext;
    also is Gnome::N::TopLevelClassSupport;

Types
=====

Methods
=======

new
---

### default, no options

Create a new MainContext object.

    multi method new ( )

### :default

Set this object to the global default main context. This is the main context used for main loop functions when a main loop is not explicitly specified, and corresponds to the "main" main loop. See also `new(:thread-default()`.

    multi method new ( :default! )

### :thread-default

Gets the thread-default **N-GMainContext** for this thread. Asynchronous operations that want to be able to be run in contexts other than the default one should call this method.

    multi method new ( :default! )

acquire
-------

Tries to become the owner of the specified context. If some other thread is the owner of the context, returns `False` immediately. Ownership is properly recursive: the owner can require ownership again and will release ownership when `release()` is called as many times as `acquire()`. You must be the owner of a context before you can call `prepare()`, `query()`, `check()`, `dispatch()`.

Returns: `True` if the operation succeeded, and this thread is now the owner of the context.

    method acquire ( --> Bool )

dispatch
--------

Dispatches all pending sources. You must have successfully acquired the context with `acquire()` before you may call this function.

    method dispatch ( )

invoke
------

Invokes a function in such a way that the context is owned during the invocation of the callback handler.

If the context is owned by the current thread, the callback handler is called directly. Otherwise, if the context is the thread-default main context of the current thread and `acquire()` succeeds, then the callback handler is called and `release()` is called afterwards.

In any other case, an idle source is created to call the callback handler and that source is attached to the context (presumably to be run in another thread). The idle source is attached with **G-PRIORITY-DEFAULT** priority. If you want a different priority, use `invoke-full()`.

Note that, as with normal idle functions, the callback handler should probably return G_SOURCE_REMOVE. If it returns G_SOURCE_CONTINUE, it will be continuously run in a loop (and may prevent this call from returning).

    method invoke (
      Any:D $handler-object, Str:D $method, *%options
    )

  * $handler-object; The object where the callback method is defined

  * $method; The name of the callback method

  * %options; Options which can be provided to the handler

The callback method API must be like

    method handler1 ( *%options --> Int )

Where %options are free to use options given at the call to `invoke()`. The method must return G_SOURCE_REMOVE or G_SOURCE_CONTINUE depending if it wants to be recalled again.

invoke-full
-----------

Invokes a function in such a way that the context is owned during the invocation of the callback handler. This function is the same as `invoke()` except that it lets you specify the priority in case the callback handler ends up being scheduled as an idle and also lets you define a destroy notify handler. The notify handler should not assume that it is called from any particular thread or with any particular context acquired.

**Note: Tests have shown that returning G_SOURCE_CONTINUE does not show the same results as with `invoke()`**.

    method invoke-full (
      Int $priority, Any:D $handler-object, Str:D $method,
      Any:D $handler-notify-object, Str:D $method-notify, *%options
    )

  * Int $priority; the priority at which to run the callback.

  * $handler-object; The object where the callback method is defined.

  * $method; The name of the callback method.

  * $handler-notify-object; The object where the destroy notify method method is defined. This is optional.

  * $method-notify; The name of the notify method.

  * %options; Options which are provided to the callback handler and notify methods.

The callback method API must be like

    method handler1 ( *%options --> Int )

Where %options are free to use options given at the call to `invoke-full()`. The method must return G_SOURCE_REMOVE or G_SOURCE_CONTINUE depending if it wants to be recalled again.

is-owner
--------

Determines whether this thread holds the (recursive) ownership of this **N-GMainContext**. This is useful to know before waiting on another thread that may be blocking to get ownership of the context.

Returns: `True` if current thread is owner of the context.

    method is-owner ( --> Int )

iteration
---------

Runs a single iteration for the given main loop. This involves checking to see if any event sources are ready to be processed, then if no events sources are ready and *$may-block* is `True`, waiting for a source to become ready, then dispatching the highest priority events sources that are ready. Otherwise, if *may-block* is `False` sources are not waited to become ready, only those highest priority events sources will be dispatched (if any), that are ready at this given moment without further waiting. Note that even when *$may-block* is `True`, it is still possible for `iteration()` to return `False`, since the wait may be interrupted for other reasons than an event source becoming ready.

Returns: `True` if events were dispatched.

    method iteration ( Bool $may_block --> Bool )

  * Bool $may_block; whether the call may block.

pending
-------

Checks if any sources have pending events for the given context.

Returns: `True` if events are pending.

    method pending ( --> Bool )

pop-thread-default
------------------

Pops the context off the thread-default context stack (verifying that it was on the top of the stack).

    method pop-thread-default ( )

push-thread-default
-------------------

Acquires the context and sets it as the thread-default context for the current thread. This will cause certain asynchronous operations (such as most gio-based I/O) which are started in this thread to run under the context and deliver their results to its main loop, rather than running under the global default context in the main thread. Note that calling this function changes the context created by `new(:thread-default)`, not the one created by `new(:default)`.

Normally you would call this function shortly after creating a new thread, passing it a **Gnome::Glib::MainContext** which will be run by a **Gnome::Glib::MainLoop** in that thread, to set a new default context for all async operations in that thread. In this case you may not need to ever call `pop-thread-default()`, assuming you want the new **Gnome::Glib::MainContext** to be the default for the whole lifecycle of the thread.

If you don't have control over how the new thread was created (e.g. if the thread isn't newly created

In some cases you may want to schedule a single operation in a non-default context, or temporarily use a non-default context in the main thread. In that case, you can wrap the call to the asynchronous operation inside a `push-thread-default()` / `pop-thread-default()` pair, but it is up to you to ensure that no other asynchronous operations accidentally get started while the non-default context is active.

    method push-thread-default ( )

release
-------

Releases ownership of a context previously acquired by this thread with `acquire()`. If the context was acquired multiple times, the ownership will be released only when `release()` is called as many times as it was acquired.

    method release ( )

wakeup
------

If the context is currently blocking in `iteration()` waiting for a source to become ready, cause it to stop blocking and return. Otherwise, cause the next invocation of `iteration()` to return without blocking. This API is useful for low-level control over **N-GMainContext**; for example, integrating it with main loop implementations such as **Gnome::Glib::MainLoop**. Another related use for this function is when implementing a main loop with a termination condition, computed from multiple threads: |[<!-- language="C" --> **define** NUM-TASKS 10 static volatile gint tasks-remaining = NUM-TASKS; ... while (g-atomic-int-get (&tasks-remaining) != 0) iteration (NULL, TRUE); ]| Then in a thread: |[<!-- language="C" --> `perform-work()`; if (g-atomic-int-dec-and-test (&tasks-remaining)) wakeup (NULL); ]|

    method wakeup ( )

