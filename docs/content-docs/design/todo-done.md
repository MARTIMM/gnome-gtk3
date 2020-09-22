---
title: Finished Todo's
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## List of finished todo things

#### Study
* [References and object creation in the light of memory leaks](https://developer.gnome.org/gobject/stable/gobject-memory.html#gobject-memory-refcount).
  * Cannot automatically cleanup the native object in the Raku object when object gets destroyed.
  * Users of the packages must therefore clean the objects themselves when appropriate using `.widget-destroy()` or `.clean-object()`.
* Applications behaviour from Gtk and Gio packages
* Resources from Gio package
* Menus and Actions
* Cairo

#### Rewriting code
* Is there a way to skip all those if's in the `_fallback()` routines.
* Prevent name clashes. The methods from interfaces have lower priority than those from the classes. Therefore `.set-name()` from Buildable must be written like `.buildable-set-name()`.
  * set-name() in Gnome::Gtk3::Widget must stay while
  * Gnome::Gtk3::Buildable set-name() must become `buildable-set-name()`;
  * Gnome::Gio::Action set-name() must become `action-set-name()`;

* Interface modules are defined as Raku roles and are mixed into all classes where the GTK documentation points out that the class uses an interface. After some investigation I found out that the role only needs to be mixed in at the topmost class of the using classes. All child classes inherit the interface data.

* It is not possible to inherit from the modules to create your own class due to the way the classes are BUILD(). Review the initialization methods to overcome this.

* Reverse testing procedures in `_fallback()` methods. Now the shortest names are found first.
  ```
  try { $s = &::("gtk_list_store_$native-sub"); };
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  ```
  In other packages `gtk_` can be `g_` or `gdk_`.

* Add a test to `_fallback()` so that the prefix 'gtk_' can be left off the subname when used. So the above tests becomes;
  ```
  try { $s = &::("gtk_list_store_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  ```
  Also here, in other packages `gtk_` can be `g_`, `gdk_` etc.

  The call to the sub `gtk_list_store_remove` can now be one of `.gtk_list_store_remove()`, `.list_store_remove()` or `.remove()` and the dashed ('-') counterparts. Bringing it down to only one word like the 'remove' above, will not always work. Special cases are `new()` and other methods from classes like **Any** or **Mu**.

* Caching the subroutine's address in **Object** must be more specific. There could be a sub name (short version) in more than one module. It is even a bug, because equally named subs can be called on the wrong objects. This happened on the Library project where `.get-text()` from **Entry** was taken to run on a **Label**. So the class name of the caller should be stored with it too. We can take the `$!gtk-class-name` for it.

* Make some of the routines in toplevel classes the same.
  * `.clear-object()`: A clear function which calls some native free function if any, then invalidates the native object. This is always a class inheriting from Boxed. The exception is **Gnome::GObject::Object** where it is done on behalf of the child classes and also uses native unref. In Boxed this must be an abstract method. This is done now in the TopLevelClassSupport

  * `.is-valid()`: A boolean test to check if a native object is valid.

  * `.set-native-object()`
  * `.get-native-object()`.

* Defining DESTROY() at the top was a big mistake! Obvious when you think of it! dereferencing or cleaning up a native object should only be done explicitly because when the Raku object goes out of scope doesn't mean that the native object isn't in use anymore. Also calling `.clear-object()` in `.new()` and several other places is wrong for the same reason.

* Make some of the named arguments to new() the same. We now have `:widget`, `:object`, `:tree-iter` etcetera while the value for these attributes are native objects. Rename these to `:native-object`. It's more clear. The type for it can differ but will not pose a problem.

* Drop the use of `:empty` and `:default`. Instead an argumentless call should be sufficient.

* Remove CALL-ME methods and all uses of them.

* There is an issue about tests going wrong because of a different native speaking language instead of English.

* Add a toplevel class to support standalone classes in glib something like **Gnome::GObject::Boxed** is. The class is called **Gnome::N::TopLevelClassSupport**.

* Add `CATCH { default { .message.note; .backtrace.concise.note } }` at the top of callback routines. This is done for all callback routines which are registered using `.register-signal()` but other places must be searched for, e.g. like foreach in **Gnome::Gtk3::Container**.

#### Documentation
See also checklist below.


#### Site changes.
* Reference pages have two sections shown per module. One for a table of contents and one for generated html from the pod doc of the module. Turn this into one display. Also the header of a section should be clickable to return to the table of contents.

* The sidebar for Gtk references is messy.
  * Should be ordered alphabetically.
  * Coloring should make clear if class is widget, interface, boxed or miscellenous.
  * Gnome::Gtk3 Reference main doc must be modified

* Jekyll shows errors which must be removed. Site content looks good however.

* Tutorials
  * Find material of other tutorials and books in other programming languages. E.g. Zetcode and Wikibooks

  * Getting started
    * Empty window
    * Window with a button
    * Show a mistake of two buttons in window
    * Buttons in a grid

  * Intermezzo: method names
    * Method names of the native subroutines

  * Window details
    * Window decoration, title and icon
    * Window size
