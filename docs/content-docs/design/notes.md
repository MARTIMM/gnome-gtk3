---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## The notes comprising the design

The following is a (not very exhaustive) list of points which make up the design of the Raku packages.

* Native objects are wrapped into Raku classes. The native objects are mostly created or imported using the `.new()` method of the class and stored in the class with `.native-gobject()`. In rare occasions, the user may retrieve the object by using `.get-native-gobject()`.

* I want to follow the interface of the classes in **Gtk**, **Gdk** and **Glib** as closely as possible by keeping the names of the native functions the same as provided by their libraries.

* The native subroutines are defined in their corresponding Raku classes. They are defined and looked up in such a way that they are usable as methods in those classes.

* Many subs also have as their first argument the native object. Because this object is held in the class, it is automatically inserted when the sub is called. E.g. a definition like the following in the `Gnome::Gtk3::Button` class
  ```
  sub gtk_button_set_label ( N-GObject $widget, Str $label )
    is native(&gtk-lib)
    { * }
  ```
  can be used as
  ```
  my Gnome::Gtk3::Button $button .= new;
  $button.gtk_button_set_label('Start Program');
  ```

* Classes can use the methods of inherited classes. E.g. The **Gnome::Gtk3::Button** class inherits **Gnome::Gtk3::Bin** and **Gnome::Gtk3::Bin** inherits **Gnome::Gtk3::Container** etc. Therefore, a method like `gtk_widget_set_tooltip_text()` defined in **Gnome::Gtk3::Widget** can be used.
  ```
  $button.gtk_widget_set_tooltip_text('When pressed, program will start');
  ```

* Classes can use methods from their interfaces. E.g. All widgets like **Gnome::Gtk3::Button** use the **Gnome::Gtk3::Buildable** interface.
  ```
  my Str $button-name = $button.gtk_buildable_get_name();
  ```

* The GTK naming of the classes are like **GtkButton** and **GtkWindow** and the subroutine names in those classes all start with `gtk_button_` and `gtk_label_` resp. Therefore we can cut those parts from the sub name and make them shorter. An example method defined in **Gnome::Gtk3::Button** class is `gtk_button_get_label()`. This can be shortened to `get_label()`.
  ```
  my Str $button-label = $button.get_label;
  ```
  In the documentation this will be shown with brackets around the part that can be left out. In this case it is shown as `[[gtk]_button_] get_label`.  
* Names can not be shortened too much. E.g. `gtk_button_new()` and `gtk_label_new()` yield the name *new* which is a Raku method from class **Mu**. There are other exceptions where the possibilities are narrowed. This happens when real methods are implemented instead of subs. This difference is not yet visible in the documentation.

* All the subroutine names are written with an underscore. However, following a Raku tradition, dashed versions are also possible.
  ```
  my Str $button-label1 = $button.gtk-button-get-label;
  my Str $button-label2 = $button.get-label;
  ```
  A few examples of all possible names which have the same outcome;
  * The prefix used in GTK for the class GtkListStore is *gtk_list_store_*. So the subroutine gtk_list_store_insert_before from **Gnome::Gtk3::ListStore** can be used as;
    * `.gtk_list_store_insert_before()`
    * `.list_store_insert_before()`
    * `.insert_before()`
    * `.gtk-list-store-insert-before()`
    * `.list-store-insert-before()`
    * `.insert-before()`
  * The prefix used in GTK for the class GtkGrid is *gtk_grid_*. So the subroutine gtk_grid_attach from **Gnome::Gtk3::Grid** can be used as;
    * `.gtk_grid_attach()`
    * `.grid_attach()`
    * `.attach()`
    * `.gtk-grid-attach()`
    * `.grid-attach()`
  * The prefix used in GTK for the class GValue is *g_value_*. So the subroutine g_value_reset from **Gnome::GObject::Value** can be used as;
    * `.g_value_reset()`
    * `.value_reset()`
    * `.reset()`
    * `.g-value-reset()`
    * `.value-reset()`

  All have their pros and cons. Longer names show where they are defined and short ones are easier to write. I propose to use short names when the subs are defined in the class you're calling them from and use the longer names when they are in parent classes and interface classes, also to prevent problems like explained above. You can still leave the 'gtk_' part off without having doubt where the heck the sub came from. Take care using short names like `.append()`, `.new()` and others. As explained above, these are methods from **Any** or **Mu**. Some of them can be trapped by adding a method `append` to the module which can call the proper GTK+ sub, but for now that will be a TODO.

* There is still a chance that a different method is found than the one you had in mind. The subs `gtk_widget_get_name()` and `gtk_buildable_get_name()` have the same short version n.l. `get_name()`. So it is important to know what the search path is, which is;
  * search in the current class
  * search in their interfaces
  * search in parent class
  * search in parent class interfaces
  * etc.

  So it follows that the sub `get_name()` from **Gnome::Gtk3::Buildable** interface has a higher priority than `get_name()` found in **Gnome::Gtk3::Widget** when search starts at e.g. **Gnome::Gtk3::Button** class. To prevent these situations you better only leave of the prefixes `gtk_`, `gdk_` or `g_` to get `buildable-get-name()` or `widget-get-name()`.

*  **_Note: Because of all these possibilities, chances are that you will use several names to call the same method and that will be confusing when you reread your code. So therefore, in the near future, work will be done to only yield the shortest method names where possible and use of dashed versions only._**

* Not all native subs or even classes will be implemented or implemented much later because of the following reasons;
  * Many subs and classes in **GTK+** are deprecated. It seems logical to not implement them because there is no history of the Raku packages to support. Exceptions are e.g. **Gnome::Gtk3::Misc** which is kept to keep the hierarchy of classes in tact.
  * The need to implement classes like **Gnome::Gtk3::Assistant**, **Gnome::Gtk3::Plug** or **Gnome::Gtk3::ScrolledWindow** is on a low priority because these can all be instantiated by **Gnome::Gtk3::Builder** using your Glade design.

* There are native subroutines which need a native object as one of their arguments. The `gtk_grid_attach()` in **Gnome::Gtk3::Grid** is an example of such a routine. The declaration of the `gtk_grid_attach()` native sub is;
  ```
  sub gtk_grid_attach (
    N-GObject $grid, N-GObject $child,
    int32 $x, int32 $y, int32 $width, int32 $height
  ) is native(&gtk-lib)
    { * }
  ```

  The afore mentioned method `get-native-gobject()` is defined in **Gnome::GObject::Object** to return the native object so we can use the gtk_grid_attach as follows.
  ```
  my Gnome::Gtk3::Grid $grid .= new;
  my Gnome::Gtk3::Label $label .= new(:label('my label'));
  $grid.gtk-grid-attach( $label.get-native-gobject(), 0, 0, 1, 1);
  ```
  However, the signatures of all subroutines are checked against the arguments provided, so it is possible to retrieve the native object hidden in the object when a Raku type is noticed. So the example becomes more simple;
  ```
  my Gnome::Gtk3::Grid $grid .= new(:empty);
  my Gnome::Gtk3::Label $label .= new(:label('server name'));
  $grid.gtk-grid-attach( $label, 0, 0, 1, 1);
  ```

* Sometimes I had to stray away from the native function names because of the way the sub must be defined in Raku. Causes can be;
  * Returning different types of values. E.g. `g_slist_nth_data()`, found in **Gnome::Glib**, can return several types of data. This is solved using several subs linking to the same native sub (using `is symbol()`). In this library, the methods `g_slist_nth_data_str()` and `g_slist_nth_data_gobject()` are added. This can be extended for other native types like integer or float.

    ```
    sub g_slist_nth_data_str ( N-GSList $list, uint32 $n --> Str )
      is native(&gtk-lib)
      is symbol('g_slist_nth_data')
      { * }

    sub g_slist_nth_data_gobject ( N-GSList $list, uint32 $n --> N-GObject )
      is native(&gtk-lib)
      is symbol('g_slist_nth_data')
      { * }
    ```
  * Variable argument lists where I had to choose for the extra arguments. E.g. in the **Gnome::Gtk3::FileChooserDialog** the native sub `gtk_file_chooser_dialog_new()` has a way to extend it with a number of buttons on the dialog. I had to fix that list to a known number of arguments and renamed the sub `gtk_file_chooser_dialog_new_two_buttons()`.
    **NOTE** This is now changed; It is possible to implement variable argument lists with the newest Raku version (about July 2019). The above sub is therefore deprecated and `gtk_file_chooser_dialog_new()` can be used.

  * Callback handlers in many cases can have different signatures. When used in a subroutine definition the subroutine must be declared differently every time another type of handler is used. This happens mainly when connecting a signal where a callback handler is provided. To make things easier, the method `register-signal()` defined in **Gnome::GObject::Object**, is created for this purpose. At the moment only the most common types of signals can be processed.
    **NOTE** Also this is changed; Now all types of signals can be processed, although some native objects provided to the signal handler might not yet possible to wrap in a Raku class because the class is not implemented.

  * Many subroutines also return native objects. For some of them, the type is known and can therefore be returned in a Raku class object instead of a native object.
