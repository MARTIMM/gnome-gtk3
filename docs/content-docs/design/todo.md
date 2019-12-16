---
title: Perl6 GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## TODO list of things
* [ ] Study references and object creation in the light of memory leaks in **Object** and **Boxed** objects.
  * [ ] Study ref/unref of gtk objects.
  * [ ] A boolean test to check if object is valid
  * [ ] A clear function which calls some free function -> toggles the valid flag
  * [ ] A `DESTROY()` submethod which calls the clear method or free function if object is still valid.

* [x] Reverse testing procedures in `_fallback()` methods. Now the shortest names are found first.
  ```
  try { $s = &::("gtk_list_store_$native-sub"); };
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  ```
  In other packages `gtk_` can be `g_` or `gdk_`.
  * [x] glib
  * [x] gobject
  * [x] gdk
  * [x] gtk

* [x] Add a test to `_fallback()` so that the prefix 'gtk_' can be left of the sub name when used. So the above tests becomes;
  ```
  try { $s = &::("gtk_list_store_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  ```
  Also here, in other packages `gtk_` can be `g_` or `gdk_`.
  * [x] glib
  * [x] gobject
  * [x] gdk
  * [x] gtk
  The call to the sub `gtk_list_store_remove` can now be one of `.gtk_list_store_remove()`, `.list_store_remove()` or `.remove()` and the dashed ('-') counterparts. Bringing it down to only one word like the 'remove' above, will not always work. Special cases are `new()` and other methods from classes like **Any** or **Mu**.
  * Find the short named subs which are also defined in Any or Mu. Add a method to catch the call before the one of Any/Mu
    * [ ] append
    * [ ] new. This method will never be captured.

* [ ] Is there a way to skip all those if's in the `_fallback()` routines.

* [x] Caching the sub address in **Object** must be more specific. There could be a sub name (short version) in more than one module. It is even a bug, because equally named subs can be called on the wrong objects. This happened on the Library project where .get-text() from **Entry** was taken to run on a **Label**. So the class name of the caller should be stored with it too. We can take the $!gtk-class-name for it.

* [ ] Make some of the routines in several packages the same
  * [ ] .clear-object()
  * [ ] .set-native-object()
  * [ ] .get-native-object()
  * [ ] .is-valid()

* [ ] Make some of the named arguments to new() the same. We now have :widget, :object, :tree-iter etcetera while the value for these attributes are native objects. Rename these to :native-object. It's more clear. The type for it can differ but will not pose a problem.

* [ ] I have noticed that True and False can be used on int32 typed values. The G_TYPE_BOOLEAN (Gtk) or gboolean (Glib C) are defined as int32. Therefore, in these cases, True and False can be used. This is not clearly shown in the examples and documentation.

* [ ] Reorder the list of methods in all modules in such a way that they are sorted. This might be of use for documentation

* [ ] Many methods return native objects. this could be molded into perl6 objects when possible.

* [ ] Make it possible to call e.g. `.gtk_label_new()` on a typed object.

* [ ] Add 'is export' to all subs in interface modules. This can help when the subs are needed directly from the interface using modules. Perhaps it can also simplify the `_fallback()` calls to search for subs in interfaces.

* [ ] Use **Method::Also** to have several names for methods. Later on, the other methods can be deprecated. This might be needed when the export TODO above will not help keeping the sub a sub. This might not be needed because I found other ways to keep the sub version.
