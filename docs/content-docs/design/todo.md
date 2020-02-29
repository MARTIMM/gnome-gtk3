---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## TODO list of things

#### Study
* [ ] Study references and object creation in the light of memory leaks in **Object** and **Boxed** objects.
* [ ] Study Pango and Cairo.

#### Rewriting code
* [x] Reverse testing procedures in `_fallback()` methods. Now the shortest names are found first.
  ```
  try { $s = &::("gtk_list_store_$native-sub"); };
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  ```
  In other packages `gtk_` can be `g_` or `gdk_`.

* [x] Add a test to `_fallback()` so that the prefix 'gtk_' can be left off the sub name when used. So the above tests becomes;
  ```
  try { $s = &::("gtk_list_store_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  ```
  Also here, in other packages `gtk_` can be `g_` or `gdk_`.

  The call to the sub `gtk_list_store_remove` can now be one of `.gtk_list_store_remove()`, `.list_store_remove()` or `.remove()` and the dashed ('-') counterparts. Bringing it down to only one word like the 'remove' above, will not always work. Special cases are `new()` and other methods from classes like **Any** or **Mu**.
  * Find the short named subs which are also defined in Any or Mu. Add a method to catch the call before the one of **Any** or **Mu**.
    * [ ] append
    * [ ] new

* [ ] Is there a way to skip all those if's in the `_fallback()` routines.

* [x] Caching the subroutine's address in **Object** must be more specific. There could be a sub name (short version) in more than one module. It is even a bug, because equally named subs can be called on the wrong objects. This happened on the Library project where `.get-text()` from **Entry** was taken to run on a **Label**. So the class name of the caller should be stored with it too. We can take the `$!gtk-class-name` for it.

* Make some of the routines in several packages the same.
  * `.clear-object()`: A clear function which calls some native free function if any, then invalidates the native object. This is always a class inheriting from Boxed. The exception is **Gnome::GObject::Object** where it is done on behalf of the child classes and also uses native unref.
  * [x] **Gnome::GObject::Boxed**. Implement some subs.
  * [x] **Gnome::GObject::Object**. Implement `clear-object()`.

  * `.is-valid()`: A boolean test to check if a native object is valid. Must be done while implementing clear-object.
  * [x] **Gnome::GObject::Boxed** define `.is-valid()` and some other subs
  * [ ] **Gnome::GObject::Object** define `.is-valid()` and some other subs

  * usage of the above in classes and tests
    * [ ] `Gnome::Gdk3::*`
    * [ ] `Gnome::Glib::*`
    * [ ] `Gnome::GObject::*`
    * [ ] `Gnome::Gtk3::*`
    * [x] `Gnome::Pango::*`
    * [x] `Gnome::Gio::*`

  * [x] `.set-native-object()`
  * [x] `.get-native-object()`.
  * [x] **Gnome::GObject::Boxed**. Old methods are deprecated.
  * [x] **Gnome::GObject::Object**. Old methods are deprecated.
  * Standalone classes. Old methods are removed.
    * [x] Gnome::Glib::Error `.error-is-valid()` method is deprecated.
    * [x] Gnome::Glib::List `.list-is-valid()` method is deprecated.
    * [ ] Gnome::Glib::SList `.gslist-is-valid()` method is deprecated.

  * All modules inheriting from **Gnome::GObject::Boxed**
    * [x] Gnome::GObject::Value `.value-is-valid()` method is deprecated.
    * [ ] Gnome::Gtk3::WidgetPath `.widgetpath-is-valid()` method is deprecated.
    * [ ] Gnome::Gdk3::RGBA `.is-valid()` method implemented.

    * usage of the above in classes and tests
      * [ ] `Gnome::Gdk3::*` modified
      * [ ] `Gnome::Glib::*` modified
      * [ ] `Gnome::GObject::*` modified
      * [ ] `Gnome::Gtk3::*` modified
      * [x] `Gnome::Pango::*` modified

<!--
    * [ ] Gnome::GObject::
    * [ ] Gnome::GObject::
-->

* `DESTROY()`: Cleanup methods called on garbage collection. The sub calls the clear method or free function if the native object is still valid. Easy to add while implementing `clear-object()`.

  * Standalone or top level classes. A DESTROY submethod must be declared.
    * [x] Gnome::Glib::Error
    * [x] Gnome::Glib::List
    * [ ] Gnome::Glib::SList
    * [x] Gnome::GObject::Value

  * Top class is **Gnome::GObject::Boxed**. Classes inheriting from Boxed must define a DESTROY method when native objects must be cleared
    * [ ] `Gnome::Gtk3::*`
    * [x] `Gnome::Pango::*`

  * Interface Roles. Roles do not have to specify a DESTROY submethod unless there are local native objects defined which will be unlikely.

  * Top class is **Gnome::GObject::Object**. A DESTROY method will be defined here because there is the native object stored.

* Make some of the named arguments to new() the same. We now have `:widget`, `:object`, `:tree-iter` etcetera while the value for these attributes are native objects. Rename these to `:native-object`. It's more clear. The type for it can differ but will not pose a problem.
  * Translate below to `:native-object`
    * [x] `:widget` everywhere
    * [ ] `:object`
    * [x] `:widgetpath` in Gnome::Gtk3::WidgetPath
    * [x] `:rgba` partly in Gnome::Gdk3::RGBA
    * [x] `:gvalue` in Gnome::GObject::Value

  * Drop the use of :empty and :default. Instead an argumentless call should be sufficient.
    * [x] `:empty`
    * [x] `:default`

* I'm not sure if the named argument :$widget to a signal handler needs to be renamed. It holds the Raku object which registered the signal. This might not always be a 'widget' i.e. inheriting from **Gnome::Gtk3::Widget**.

* [ ] I have noticed that True and False can be used on int32 typed values. The G_TYPE_BOOLEAN (Gtk) or gboolean (Glib C) are defined as int32. Therefore, in these cases, True and False can be used. This is not clearly shown in the examples and documentation.

* [ ] Reorder the list of methods in all modules in such a way that they are sorted. This might be of use for documentation

* [ ] Many methods return native objects. this could be molded into Raku objects when possible.

* [ ] Make it possible to call e.g. `.gtk_label_new()` on a typed object. Now there are several ways implemented using named arguments on the BUILD() submethod.

* [ ] Add 'is export' to all subs in interface modules. This can help when the subs are needed directly from the interface using modules. Perhaps it can also simplify the `_fallback()` calls to search for subs in interfaces.


#### Documentation
There are still a lot of bugs and documentation anomalies. Also not all subs, signals and properties are covered in tests. As a side note, modify **#`{\{...}\}** in pod doc comments because the github pages understand **{{...}}** to substitute variables.

  * Complete documentation and C-Quirks left from the generated output.
    * [ ] **Gnome::Gdk3**.
    * [ ] **Gnome::Glib**.
    * [ ] **Gnome::Gio**. Not much yet!
    * [ ] **Gnome::GObject**.
    * [ ] **Gnome::Gtk3**.
    * [ ] **Gnome::Gtk3::Glade**.
    * [ ] **Gnome::Pango**. Not much yet!
    * [ ] **Gnome::Cairo**. Not much yet!

* Documentation and examples mentioning the use of 0 and 1, must be rewritten to show True and False where possible.

* All the several possibilities to use a method should be removed eventually and kept only one name. Keep the names where clashes could take place like `get-name()` from **Builder** and **Widget**. These must be kept as `builder-get-name()` and `widget-get-name()` resp. Dashes are preverred.
  * [ ] Method names kept are the names without the module prefixes. Sometimes a method must be added to prevent calling a method from **Any** or **Mu**. Examples
    * `gtk_grid_attach()` -> `attach()`.
    * `gtk_label_new()` -> `new()`. Handled with submethod `BUILD()`.
    * `gtk_widget_set_name()` -> `widget-set-name()`. Cannot be too short.
    * `gtk-list-store-append()` -> `append()`. Needs an extra method.
  * [ ] Adjust documentation.
  * [ ] Add deprecate messages for the to be removed names.

* [ ] Remove `Since <version>` lines. These lines are version remarks of Gnome libraries and not of the Raku modules.

#### Test coverage

* **Gnome::Gdk3**
  * [ ] subs
  * [ ] signals
  * [ ] properties
* **Gnome::Glib**
  * [ ] subs
  * [ ] signals
  * [ ] properties
* **Gnome::GObject**
  * [ ] subs
  * [ ] signals
  * [ ] properties
* **Gnome::Gtk3**
  * [ ] subs
  * [ ] signals
  * [ ] properties
* **Gnome::Pango**
  * [ ] subs
  * [ ] signals
  * [ ] properties

* Add necessary packages. I am not sure if the Gio and Atk packages are useful additions. Clutter and WebKit are low priority projects. Not mentioned are Tracker, Poppler, Telepathy, Folks, Champlain, Geoclue2 and Geocode-glib which is of personal interest.
  * [ ] **Gnome::Atk**. Accessibility toolkit to implement support for screen readers and other tools.
  * [ ] **Gnome::Gio**. File and URI handling, asynchronous file operations, volume handling and also for network I/O, application and settings, D-Bus.
  * [ ] **Gnome::Cairo**. 2D, vector-based drawing for high-quality graphics.
  * [ ] **Gnome::Pango**. International text rendering with full Unicode support.
  * [ ] **Gnome::Clutter**. Animations and scene graph.
  * [ ] **Gnome::WebKit**. HTML5 web page rendering.

#### Site changes.
* [ ] Reference pages have two sections shown per module. One for a table of contents and one for generated html from the pod doc of the module. Turn this into one display. Also the header of a section should be clickable to return to the table of contents.

* [ ] In the sidebar of the reference section, the doc and test icons should be replaced by one icon. Pressing on it should show a table with test coverage and documentation status instead of showing at the top of the ref page. It can also show issues perhaps.

* [ ] The sidebar for Gtk references is messy. Should be ordered better.

* [ ] Code samples shown are taken directly from real working programs. This makes it easy to work on the programs without modifying the code in the docs. However with longer listings I want to show parts of it using min and max line numbers.

* Add more tutorials
  * [x] Find material of other tutorials and books in other programming languages.

  Change 'Getting Started' into a shorter page
  * Top level widgets and containers
    * [ ] Window
    * [ ] Dialogs
    * [ ] Grid

  * Controls
    * [ ] Buttons
    * [ ] Menus
    * [ ] ComboxBox

  * Display
    * [ ] Labels
    * [ ] LevelBar

  * Lists and Edit
    * [ ] Entry
    * [ ] ListBox
    * [ ] TreeView

* Add more examples
  * [ ] Configuration editor
  * [ ] Simple calculator

* [ ] Check licensing of the whole project, contact Gnome.

* [ ] Remove changelog from About page and add separate pages for the changelog from the packages.
