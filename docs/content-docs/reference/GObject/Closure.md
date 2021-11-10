Gnome::GObject::Closure
=======================

Functions as first-class objects

Description
===========

A **Gnome::GObject::Closure** represents a callback supplied by the programmer. It will generally comprise a function of some kind and a marshaller used to call it. It is the responsibility of the marshaller to convert the arguments for the invocation from **Gnome::GObject::Values** into a suitable form, perform the callback on the converted arguments, and transform the return value back into a **Gnome::GObject::Value**.

**Note**: This module is kept very simple because Raku does not need an implementation of a closure in C, which Raku can do that very neatly. So this closure is only created to provide a callback which is needed in some cases. The other items provided in the C closure class like controlling the marshaller, providing data to the closure, the destroy function for that data, etcetera, is not supported by the Raku module.

Synopsis
========

Declaration
-----------

    unit class Gnome::GObject::Closure;
    also is Gnome::GObject::Boxed;

Example
-------

The following example is translated from [the example here](https://github.com/bstpierre/gtk-examples/blob/master/c/accel.c). It shows an empty window where you can type two control commands `<ctrl>A ` and `<ctrl><shift>C `. The first shows a message on the console and the second stops the program.

    use v6;

    use Gnome::GObject::Closure;

    use Gnome::Gtk3::Window;
    use Gnome::Gtk3::Main;
    use Gnome::Gtk3::AccelGroup;

    use Gnome::Gdk3::Types;
    use Gnome::Gdk3::Keysyms;


    class CTest {
      method accelerator-pressed ( Str :$arg1 ) {
        note "accelerator pressed, user argument = '$arg1'";
      }

      method stop-test ( ) {
        note "program stopped";
        Gnome::Gtk3::Main.new.quit;
      }
    }

    my CTest $ctest .= new;


    with my Gnome::Gtk3::AccelGroup $accel-group .= new {
      .connect(
        GDK_KEY_A, GDK_CONTROL_MASK, 0,
        Gnome::GObject::Closure.new(
          :handler-object($ctest), :handler-name<accelerator-pressed>,
          :handler-opts(:arg1<'foo'>)
        )
      );

      .connect(
        GDK_KEY_C, GDK_CONTROL_MASK +| GDK_SHIFT_MASK, 0,
        Gnome::GObject::Closure.new(
          :handler-object($ctest), :handler-name<stop-test>
        )
      );
    }

    with my Gnome::Gtk3::Window $window .= new {
      .add-accel-group($accel-group);
      .register-signal( $ctest, 'stop-test', 'destroy');
      .show;
    }

    Gnome::Gtk3::Main.new.main;

Types
=====

Methods
=======

new
---

### default, no options

Create a new Closure object.

    multi method new ( )

### :native-object

Create a Closure object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

invalidate
----------

Sets a flag on the closure to indicate that its calling environment has become invalid, and thus causes any future invocations of `invoke()` on this *closure* to be ignored. Also, invalidation notifiers installed on the closure will be called at this point. Note that unless you are holding a reference to the closure yourself, the invalidation notifiers may unref the closure and cause it to be destroyed, so if you need to access the closure after calling `g-closure-invalidate()`, make sure that you've previously called `g-closure-ref()`.

Note that `g-closure-invalidate()` will also be called when the reference count of a closure drops to zero (unless it has already been invalidated before).

    method invalidate ( )

