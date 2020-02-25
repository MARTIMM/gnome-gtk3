---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Implementation details
* The native objects wrapped in Raku classes are mostly not visible to the user, but if they do, their types always start wit *N-*. E.g. **N-GObject**, **N-GValue**, etc. **_This is not yet done everywhere_**.

* The `FALLBACK()` method defined in **Gnome::GObject::Object** is called if a method is not found. This makes it possible to search for the defined native subroutines in the class and inherited classes. It calls the `_fallback()` method, which starts with the class at the bottom and working its way up until the subroutine is found. Each `_fallback()` method is calling `callsame()` when a sub is not found yet. The resulting subroutine address is returned and processed with the `test-call()` functions from **Gnome::N::X**. Thrown exceptions are handled by the function `test-catch-exception()` from the same module.

* Interface modules like e.g. **Gnome::Gtk3::FileChooser**, have methods like `_file_chooser_interface()` which is called by the interface using modules from their `_fallback()` method. For the mentioned interface module this can be e.g. **Gnome::Gtk3::FileChooserDialog**. All methods defined by that interface can be used by the interface using module.

* All classes deriving from **Gnome::GObject::Object** know about the `:native-object(…)` named attribute when instantiating a widget class. This is used when the result of another native sub returns a **N-GObject**. In most cases a Raku object can be provided. The method will retrieve the native object from the given Raku object.

* The same classes also recognize the named argument `:build-id(…)` which is used to get a **N-GObject** from a **Gnome::Gtk3::Builder** object. It does something like `$builder.gtk_builder_get_object(…)`. A builder must be initialized and loaded with a GUI description before to be useful. This option works for all child classes too if those classes are managed by **Gnome::Gtk3::Builder**.

  An example to see both named arguments in use is when cleaning a list box;
  ```
  # instantiate a list box using the :build-id argument
  my Gnome::Gtk3::ListBox $list-box .= new(:build-id<someListBox>);
  loop {
    # Keep the index 0, entries will shift up after removal
    my $nw = $list-box.get-row-at-index(0);
    last unless $nw.defined;

    # Instantiate a container object using the :widget argument
    my Gnome::Gtk3::ListBoxRow $row .= new(:native-object($nw));
    $row.gtk-widget-destroy;
  }
  ```

* Wrapped subs
  * The C functions can only return simple values like **int32**, **num64**, etc or **Pointer** to the values or structures. This can be handled by Raku and is not a problem. However, many subs are defined so that the values are returned in a Pointer argument and Perl users must handle that properly by giving a real location instead of a constant. Also this can be done properly, simple types need a rw trait and structures and arrays are already given by pointer. But to make things a bit comfortable, those functions are converted to return the values normally. **_Many subs stil need to be converted to show this behavior!_**.

    So the definition of the sub is changed like so;
    ```
    sub gtk_range_get_range_rect ( N-GObject $range --> GdkRectangle ) {
      _gtk_range_get_range_rect( $range, my GdkRectangle $rectangle .= new);
      $rectangle
    }

    sub _gtk_range_get_range_rect ( N-GObject $range, GdkRectangle $rectangle )
      is native(&gtk-lib)
      is symbol('gtk_range_get_range_rect')
      { * }
    ```
    Now we can do
    ```
    my GdkRectangle $rectangle = $range.get-range-rect();
    ```

  * The same situation arises when a native sub wants to return more than one value. Again this is solved by creating a wrapper around the native sub, the arguments can be provided locally and after the call, the wrapper returns a list of values. **_also here, many subs still need to be converted to show this behavior!_**

    An example from `Gnome::Gdk3::Window` to get the coordinates of a window;
    ```
    sub gdk_window_get_position ( N-GObject $window --> List ) {
      _gdk_window_get_position( $window, my int32 $x, my int32 $y);
      ( $x, $y)
    }

    sub _gdk_window_get_position (
      N-GObject $window, int32 $x is rw, int32 $y is rw
    ) is native(&gdk-lib)
      is symbol('gdk_window_get_position')
      { * }
    ```
    To use it one can write the following
    ```
    my Int ( $x, $y) = $w.get-position;
    ```

  * There is no Boolean type in C. All Booleans are int32 and only 0 (False) or 1 (True) is used. One can use `True` and `False` when needed as an argument, but it is not possible to store an int32 back into a boolean. So the next definition;
    ```
    sub gtk_widget_set_visible ( N-GObject $widget, int32 $visible )
      is native(&gtk-lib)
      { * }
    ```
    can be used as;
    ```
    $button.gtk_widget_set_visible(True);
    ```
    **_Documentation and examples mentioning the use of 0 and 1, must be rewritten to show True and False where possible_**.

    Testing the returned 'boolean' can be done using if/else and no extra changes are needed. However, to store it, the value must be coersed into Bool if one needs it that way.
    ```
    sub gtk_widget_get_visible ( N-GObject $widget )
      returns int32
      is native(&gtk-lib)
      { * }
    ```
    Use when testing
    ```
    if !$button.gtk_widget_get_visible {
      $button.gtk_widget_set_visible(True);
    }
    ```
    Use following when storing it in a boolean.
    ```
    my Bool $is-visible = $button.gtk_widget_get_visible.Bool;
    ```
    To wrap a sub like above is a bit too much so it is not done.

  * Subs are also wrapped to cope with subroutines which have variable argument lists.
