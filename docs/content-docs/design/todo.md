---
title: Planned Todo's
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## TODO list of things

#### Study
* Drag and Drop
* DBus I/O
* Pango
* Cairo

#### Rewriting code
* Is there a way to skip all those if's in the `_fallback()` routines.
* Prevent name clashes. The methods from interfaces have lower priority than those from the classes. Therefore `.set-name()` from Buildable must be written like `.buildable-set-name()`.
  * set-name() in Gnome::Gtk3::Widget must stay while
  * Gnome::Gtk3::Buildable set-name() must become `buildable-set-name()`;
  * Gnome::Gio::Action set-name() must become `action-set-name()`;

* I'm not sure if the named argument `:$widget` to a signal handler needs to be renamed. It holds the Raku object which registered the signal. This might not always be a 'widget' i.e. inheriting from **Gnome::Gtk3::Widget**.

* I have noticed that True and False can be used on int32 typed values when provided to the native sub in the argument list. The G_TYPE_BOOLEAN (Gtk) or gboolean (Glib C) are defined as int32. Therefore, in these cases, True and False can be used. This is not clearly shown in the examples and documentation yet. The return values are not coersed automatically to Bool but most of the time not needed.

* Reorder the list of methods in all modules in such a way that they are sorted. This might be of use for documentation to find the methods more quickly.

* Many methods return native objects. In some cases this could be returned as Raku objects.

* Returning a list of values in place of the C method to provide pointers (`is rw` traits) is more convienient. For example the following
  ```
  my Int ( $width, $height) = $window.get-size;
  ```
  Instead of
  ```
  my Int ( $width, $height);
  $window.get-size( $width, $height);
  ```
  which is a teeny bit more cumbersome but also I find that the action is a side effect where the variables `$width` and `$height` are changed in the process. In this case not very confusing but other cases might be.

* Interface modules are defined as Raku roles and are mixed into all classes where the GTK documentation points out that the class uses an interface. After some investigation I found out that the role only needs to be mixed in at the topmost class of the using classes. All child classes inherit the interface data.

* It is not possible to inherit from the modules to create your own class due to the way the classes are BUILD(). Review the initialization methods to overcome this.

* Error messages generated in the packages, should be displayed in other languages as well, starting with the most used ones like German, French and Spanish. And for the fun of it also in Dutch.

* To test for errors, an error code must be tested instead of the text message. The errors generated in the package need to add such a code. To keep a good administration the errors must be centralized in e.g. Gnome::M (for messages). This is also good to have translations there. Need to use tools for that. For localization, GTK+/GNOME uses the GNU gettext interface. gettext works by using the strings in the original language (usually English) as the keys by which the translations are looked up. All the strings marked as needing translation are extracted from the source code with a helper program.

* When a native object is given using `.new(:native-object())`, it is not correct to set the type of the object assuming that the type is the same of the Raku class consuming this native object. E.g it is possible the create a **Gnome::Gtk3::Widget** using a native object of a button. This can give problems when casting or even worse, creating a Gnome::Gtk3::Button using a native GtkContainer. Testing should be done to find the proper native object.


#### Documentation

* All the several possibilities to use a method should be removed eventually and kept only one name. Keep the names where clashes could take place like `get-name()` from **Builder** and **Widget**. Dashes are prevered.
  * Method names kept are the names without the module prefixes. Sometimes a method must be added to prevent calling a method from **Any** or **Mu**. Examples
    * `gtk_grid_attach()` -> `attach()`.
    * `gtk_label_new()` -> `new()`. Handled with submethod `BUILD()`.
    * `gtk_widget_set_name()` -> `widget-set-name()`. Cannot be too short.
    * `gtk-list-store-append()` -> `append()`. Needs an extra method.
  * Adjust documentation.
  * Add deprecate messages for the to be removed names.

* Add a section about a misunderstanding when using `DESTROY()` in a user object to cleanup a native object which inherits a Raku G*::object.
  * Cannot automatically cleanup the natice object in the Raku object when object gets destroyed.
  * Users of the packages must therefore clean the objects themselves when appropriate using `.widget-destroy()` or `.clean-object()`.

* Each user class inheriting a Raku G*::object must have a new() to create the native object. this must be repeated for other client use classes because only the leaf new() is run!

* Add plantuml diagrams to documents. Not (yet?) possible on github pages to do it directly. For the moment generate png and use those.

#### Site changes.
* In the sidebar of the reference section, the doc and test icons should be replaced by one icon. Pressing on it should show a table with test coverage and documentation status instead of showing at the top of the ref page. It can also show issues perhaps.

* Code samples shown are taken directly from real working programs. This makes it easy to work on the programs without modifying the code in the docs. However with longer listings I want to show parts of it using min and max line numbers.

* Tutorials
  * Window details
    * [x] Window decoration, title and icon
    * [x] Window size
    * Centering with position
    * Destroy signal
    * Some Container methods
    * Some Widget methods

  * Intermezzo: search of native subroutines
    * Search process starting in `FALLBACK()` in **Gnome::N::TopLevelClassSupport**. Show UML diagram.
    * FALLBACK -> \_fallback() -> callsame()
    * Substitution of arguments

    * (Scrolled)Window
    * Dialogs

    * Frame
    * Grid

  * Intermezzo: common names and init
    * Common method names used in classes
    * Initialization of classes

  * Widgets
    * Controls
      * Buttons
      * Menus
      * Toolbars
      * ComboxBox

    * Display
      * Labels
      * LevelBar

    * Lists and Edit
      * Entry
      * ListBox
      * TreeView

  * Intermezzo: widget life cycle
    * Widget creation. Reference state, weak references
    * Widget (un)referencing
    * Destroy
    * Finalization
    * `.clear-object()`

  * Signals
  * Threads
    * Main
      * Start loop
      * Stop loop
      * Nest loops
      * Loop Context
      * Process events
  * Builder
    * Glade
    * Gui XML description
    * Menu XML description
  * Styling
  * Resources
  * Inheriting a class

  * Intermezzo: tell something about
    * Object
    * InitiallyUnowned
    * Boxed: https://en.wikipedia.org/wiki/GObject
      Some data structures that are too simple to be made full-fledged class types (with all the overhead incurred) may still need to be registered with the type system. For example, we might have a class to which we want to add a background-color property, whose values should be instances of a structure that looks like struct color { int r, g, b; }. To avoid having to subclass GObject, we can create a boxed type to represent this structure, and provide functions for copying and freeing. GObject ships with a handful of boxed types wrapping simple GLib data types. Another use for boxed types is as a way to wrap foreign objects in a tagged container that the type system can identify and will know how to copy and free.
    * Interfaces: https://en.wikipedia.org/wiki/GObject
      Most types in a GObject application will be classes — in the normal object-oriented sense of the word — derived directly or indirectly from the root class, GObject. There are also interfaces, which, unlike classic Java-style interfaces, can contain implemented methods. GObject interfaces can thus be described as mixins.

  * Application
    * Phases
    * Signals
    * Multiple program entities or not

  * Drag and drop
  * Drawing
  * Font and other text handling
  * D-Bus

  * Debugging
    * Testing your program with Gnome::T.
    * `Gnome::N::debug()`.
    * Environment variables: See also [Running GLib Applications: GLib Reference Manual](https://developer.gnome.org/glib/stable/glib-running.html#G_SLICE).
      * G-DEBUG all
      * G_MESSAGES_DEBUG all
      * G_SLICE debug-blocks
    * CATCH in callback handler to intercept an Exception when registering a callback using `g_signal_connect_object()` instead of `.register-signal()`.
    * Do's and Don'ts.
      * Do not call `.clean-object()` on iterators, widgets, or in callback handlers.

* Code examples
  * Configuration editor
  * Simple calculator

* Check licensing of the whole project, contact Gnome?

* Remove changelog from About page and add separate pages for the changelog from the packages.
