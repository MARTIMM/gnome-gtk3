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

* [x] Add a test to `_fallback()` so that the prefix 'gtk_' can be left of the sub name when used. So the above tests becomes;
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
  * `.clear-object()`: A clear function which calls some free function -> toggles the valid flag
  * usage of the above
    * [ ] `Gnome::Gdk3::*`
    * [ ] `Gnome::Glib::*`
    * [ ] `Gnome::GObject::*`
    * [ ] `Gnome::Gtk3::*`
    * [x] `Gnome::Pango::*`

  * `.set-native-object()` and `.get-native-object()`.
    * [x] **Gnome::GObject::Boxed**. Old methods are deprecated.
    * usage of the above
      * [x] `Gnome::Gdk3::*` modified
      * [x] `Gnome::Glib::*` modified
      * [x] `Gnome::GObject::*` modified
      * [x] `Gnome::Gtk3::*` modified
      * [x] `Gnome::Pango::*` modified

    * [x] **Gnome::Glib::Option**. Old methods are removed.
    * [x] **Gnome::GObject::Object**. Old methods are deprecated.
    * usage of the above
      * [x] `Gnome::Gdk3::*` modified
      * [x] `Gnome::Glib::*` modified
      * [x] `Gnome::GObject::*` modified
      * [x] `Gnome::Gtk3::*` modified
      * [x] `Gnome::Pango::*` modified

  * `.is-valid()`: A boolean test to check if a native object is valid
    * [x] Gnome::GObject::Boxed
    * [ ] Gnome::GObject::Object
    * [x] Gnome::GObject::Value `.value-is-valid()` method is deprecated.
    * [ ] Gnome::Glib::Error `.error-is-valid()` method is deprecated.
    * [ ] Gnome::Glib::List `.list-is-valid()` method is deprecated.
    * [ ] Gnome::Glib::SList `.gslist-is-valid()` method is deprecated.

    * usage of the above
      * [ ] `Gnome::Gdk3::*` modified
      * [ ] `Gnome::Glib::*` modified
      * [ ] `Gnome::GObject::*` modified
      * [ ] `Gnome::Gtk3::*` modified
      * [x] `Gnome::Pango::*` modified

<!--
    * [ ] Gnome::GObject::
    * [ ] Gnome::GObject::
-->

* `DESTROY()`: Cleanup methods called on garbage collection. The sub calls the clear method or free function if the native object is still valid.

  * Standalone classes. A DESTROY method must be declared.
    * [ ] Gnome::Glib::Error
    * [ ] Gnome::Glib::List
    * [ ] Gnome::Glib::SList
    * [ ] Gnome::GObject::Value

  * Top class is **Gnome::GObject::Boxed**. Classes inheriting from Boxed must define a DESTROY method when native objects must be cleared
    * [ ] `Gnome::Gtk3::*`
    * [x] `Gnome::Pango::*`

  * Interface Roles. Roles do not have to specify a DESTROY method unless there are local native objects defined which will be unlikely.

  * Top class is **Gnome::GObject::Object**. A DESTROY method will be defined here because there is the native object stored.

* Make some of the named arguments to new() the same. We now have `:widget`, `:object`, `:tree-iter` et cetera while the value for these attributes are native objects. Rename these to `:native-object`. It's more clear. The type for it can differ but will not pose a problem.
  * Translate `:widget`, `:object` etc. to `:native-object`
    * [x] **Gnome::GObject::Object** Modify the test for `:widget`
    * [x] `Gnome::Gdk3::*` Modify the use for `:widget`
    * [x] `Gnome::Glib::*`
    * [x] `Gnome::GObject::*`
    * [ ] `Gnome::Gtk3::*` Modify the use for `:widget`
    * [x] `Gnome::Pango::*` Never implemented that way

  * Drop the use of :empty. Instead an argumentless call should be sufficient.
    * [ ] **Gnome::GObject::Object** Remove test of empty options hash
    * [x] **Gnome::GObject::Boxed** Remove test of empty options hash

    * [ ] `Gnome::GObject::*`
    * [ ] `Gnome::Gdk3::*`
    * [ ] `Gnome::Glib::*`
    * [ ] `Gnome::GObject::*`
    * [ ] `Gnome::Gtk3::*`
    * [x] `Gnome::Pango::*` Never implemented that way

* I'm not sure if the named argument :$widget to a signal handler needs to be renamed. It holds the Raku object which registered the signal. This might not always be a 'widget' inheriting from **Gnome::Gtk3::Widget**.

* [ ] I have noticed that True and False can be used on int32 typed values. The G_TYPE_BOOLEAN (Gtk) or gboolean (Glib C) are defined as int32. Therefore, in these cases, True and False can be used. This is not clearly shown in the examples and documentation.

* [ ] Reorder the list of methods in all modules in such a way that they are sorted. This might be of use for documentation

* [ ] Many methods return native objects. this could be molded into Raku objects when possible.

* [ ] Make it possible to call e.g. `.gtk_label_new()` on a typed object. Now there are several ways implemented using named arguments on the BUILD() submethod.

* [ ] Add 'is export' to all subs in interface modules. This can help when the subs are needed directly from the interface using modules. Perhaps it can also simplify the `_fallback()` calls to search for subs in interfaces.

* [ ] Use **Method::Also** to have several names for methods. Later on, the other methods can be deprecated. This might be needed when the export TODO entry mentioned above will not help keeping the sub a sub. This might not be needed because I found other ways to keep the sub version.


#### Documentation
* There are still a lot of bugs and documentation anomalies. Also not all subs, signals and properties are covered in tests. As a side note, modify **#`{\{...}\}** in pod doc comments because the github pages understand **{{...}}** to substitute variables.

  * Complete documentation and C-Quirks left from the generated output.
    * [ ] **Gnome::Gdk3**.
    * [ ] **Gnome::Glib**.
    * [ ] **Gnome::GObject**.
    * [ ] **Gnome::Gtk3**.
    * [ ] **Gnome::Gtk3::Glade**.
    * [ ] **Gnome::Pango**.

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

* Add necessary packages. I am not sure if the Gio and Atk packages are useful additions. Also Clutter and WebKit are low priority projects. Not mentioned are Tracker, Poppler, Telepathy, Folks, Champlain, Geoclue2 and Geocode-glib which is of personal interest.
  * [ ] **Gnome::Atk**. Accessibility toolkit to implement support for screen readers and other tools.
  * [ ] **Gnome::Gio**. File and URI handling, asynchronous file operations, volume handling and also for network I/O.
  * [ ] **Gnome::Cairo**. 2D, vector-based drawing for high-quality graphics.
  * [ ] **Gnome::Pango**. International text rendering with full Unicode support.
  * [ ] **Gnome::Clutter**. Animations and scene graph.
  * [ ] **Gnome::WebKit**. HTML5 web page rendering.

#### Site changes.
* [ ] Reference pages have two sections shown per module. One for a table of contents and one for generated html from the pod doc of the module. Turn this into one display. Also the header of a section should be clickable to return to the table of contents.

* [ ] In the sidebar of the reference section, the doc and test icons should be replaced by one icon. Pressing on it should show a table with test coverage and documentation status instead of showing at the top of the ref page. It can also show issues perhaps.

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
