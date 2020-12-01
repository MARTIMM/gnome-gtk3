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
* Need to find out what must be freed and what isn't because of Raku cleaning up. Must study [Notes_on_memory_management](https://docs.raku.org/language/nativecall#Notes_on_memory_management). A hint on what to free is found [here point 1.4, 1.5](https://developer.gnome.org/gtk3/stable/gtk-question-index.html) and [here](https://docs.raku.org/language/nativecall#Explicit_memory_management).

#### Rewriting code
* Is there a way to skip all those if's in the `_fallback()` routines.

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

* Add methods for most used subs and for those subs where the name is brought back to one word like the `.remove()` for the sub `.gtk_list_store_remove()`.

* Error messages generated in the packages, should be displayed in other languages as well, starting with the most used ones like German, French and Spanish. And for the fun of it also in Dutch. Gtk already has done this for several return messages from the Gtk libraries.

* To test for errors, an error code must be tested instead of the text message. The errors generated in the package need to add such a code. To keep a good administration the errors must be centralized in e.g. Gnome::M (for messages). This is also good to have translations there. Need to use tools for that. For localization, GTK+/GNOME uses the GNU gettext interface. gettext works by using the strings in the original language (usually English) as the keys by which the translations are looked up. All the strings marked as needing translation are extracted from the source code with a helper program.

* When a native object is given using `.new(:native-object())`, it is not correct to set the type of the object assuming that the type is the same of the Raku class consuming this native object. E.g it is possible to create a **Gnome::Gtk3::Widget** using a native object of a button. This can give problems when casting or even worse, creating a Gnome::Gtk3::Button using a native GtkContainer. Testing should be done to accept the proper native object.

* When a native object other then N-GObject is needed in a library module, e.g. N-GtkTreeIter, a use statement is used to load the module wherein it is defined, TreeIter in this case. In the library, the modules using such a type, mostly need it only to type the native routine arguments and no other content is used. Loading and parsing should go faster when the type definition is placed in a separate file like is done for N-GObject.

#### Add other packages
* Pango.
* Atk. [Docs version 2.28](https://developer.gnome.org/atk/2.28/)

#### Documentation
<!--
* All the several possibilities to use a method should be removed eventually and kept only one name. Keep the names where clashes could take place like `get-name()` from **Builder** and **Widget**. Dashes are prevered.
  * Method names kept are the names without the module prefixes. Sometimes a method must be added to prevent calling a method from **Any** or **Mu**. Examples
    * `gtk_grid_attach()` -> `attach()`.
    * `gtk_label_new()` -> `new()`. Handled with submethod `BUILD()`.
    * `gtk_widget_set_name()` -> `widget-set-name()`. Cannot be too short.
    * `gtk-list-store-append()` -> `append()`. Needs an extra method.
  * Adjust documentation.
  * Add deprecate messages for the to be removed names.
-->

* Add a section about a misunderstanding when using `DESTROY()` in a user object to cleanup a native object which inherits a Raku G*::object.
  * Cannot automatically cleanup the native object in the Raku object when object gets destroyed.
  * Users of the packages must therefore clean the objects themselves when appropriate using `.widget-destroy()` or `.clean-object()`.

* Each user class inheriting a Raku G*::object must have a new() to create the native object. This must be repeated for other subsequent inheriting classes because only the top new() is run!

* Add plantuml diagrams to documents. SVG is the best picture format.

* Explain difference in actions of a widget like show, realize, map events, expose events and map. A [question from a blog](https://blogs.gnome.org/jnelson/2010/10/13/those-realize-map-widget-signals/)

* Split up documentation from Gnome::Gtk3 package and move it to the other Gnome projects. The main github entry site at https://martimm.github.io/ should then refer to all projects.

* I've found mistakes in the documentation when enum values are returned. E.g.
`.gtk_stack_get_transition_type()` in **Gnome::Gtk3::Stack** which returns an integer. I mistakenly took that number to be the enum value; In the doc shown as
  ```
    method gtk_stack_get_transition_type ( --> GtkStackTransitionType )
  ```
  while it should be
  ```
    method gtk_stack_get_transition_type ( --> Int )
  ```
  This example is corrected but there are many places where this is not. To test for its value one can do;
  ```
  if $returned-value == GTK_STACK_TRANSITION_TYPE_OVER_DOWN.value { ... }
  ```
  where `GTK_STACK_TRANSITION_TYPE_OVER_DOWN` is an example value of the enum type `GtkStackTransitionType`, or
  ```
  if GtkStackTransitionType($returned-value) ~~ GTK_STACK_TRANSITION_TYPE_OVER_DOWN { ... }
  ```
  which is more readable because of the enum type name used where the returned value should fit in.

  Even better would it be when a second sub is made, calling the native one and returns the value as an enum value. Using the example;
  ```
  sub gtk_stack_get_transition_type (
    N-GObject $stack --> GtkStackTransitionType
  ) {
    GtkStackTransitionType(_gtk_stack_get_transition_type($stack))
  }

  sub _gtk_stack_get_transition_type ( N-GObject $stack --> int32 )
    is native(&gtk-lib)
    is symbol('gtk_stack_get_transition_type')
    { * }
  ```

  I'll go for the last example but will take some time to find all returned enum

#### Site changes.
* Code samples shown are taken directly from real working programs. This makes it easy to work on the programs without modifying the code in the docs. However with longer listings I want to show parts of it using min and max line numbers.

* Tutorials
  * [x] Getting Started
    * A Simple Window
    * Simple Window with a Button
    * Simple Window with two Buttons

  * [x] Intermezzo: Methods
    * Method naming

  * [x] Window Details
    * Window decoration, title and icon
    * Window size
    * Centering with position
    * Modal windows / dialogs
    * Above windows
    <!--
    * [ ] Some Container methods
    * [ ] Some Widget methods
    -->

  * [x] Signals
    * Signals and Events
    * Declaration of the Registration Method
    * Unregistering Signals
    * Other signals
    * Event Loop
    * Sending Events

  * [ ] Intermezzo: search of native subroutines
    * Search process starting in `FALLBACK()` in **Gnome::N::TopLevelClassSupport**. Show UML diagram.
    * FALLBACK -> \_fallback() -> callsame()
    * Substitution of arguments
      * `enum -> Int` if target is `int*`
      * `Bool -> Int` if target is `int*`
      * `Int -> int*` automatic by Raku
      * `* -> num*` if target is `num*`
    * Using `$obj.?xyz()` in a class inheriting from `Gnome::*` fails when `.xyz()` is not defined. It is caused by the FALLBACK routine. Must use `$obj.^lookup('xyz')` to check before calling.

<!--
#  - title: Dialog
#  - title: TreeModel
#  - title: Radio buttons
#  - title:
#  - title:
#  - title: ApplicationWindow
#  - title:
#  - title:
#  - title: Debugging
#  - title: Xml
#  - title: Glade program
#  - title: threading
-->

  * [ ] Widgets, a non-exhoustive list according to the glade program
    * Toplevel widgets
      * Window
      * ApplicationWindow
      * Dialogs
        * AboutDialog
        * FileChooserDialog
        * MessageDialog
      * Assistant

    * Containers
      * Grid
      * Notebook
      * Frame
      * ListBox
      * ScrolledWindow
      * Revealer
      * Stack

    * Controls
      * Buttons
        * RadioButton
        * CheckButton
        * ToggleButton
        * ColorButton
        * FontButton
      * ComboxBox
      * ComboxBoxText
      * Entry, SearchEntry
      * Switch

    * Display
      * Label
      * LevelBar
      * Menu
      * Separator
      * DrawingArea

    * Extra
      * Models
        * TreeModel
        * ListStore
        * TreeStore
        * TreeView
      * Text
        * TextBuffer
        * EntryBuffer
        * TextTag
        * TextTagTable
      * Choosers
        * ColorChooserWidget
        * FontChooserWidget
<!--
    * Lists and Edit
      * TextView
      * Menus
      * ListBox
      * ListView, TreeView, TreeModel
      * Toolbars
      * Scale
-->

  * [ ] Intermezzo: common names and init
    * Common method names used in classes: `clear-object()`, `is-valid()`
    * Common init method attributes, `:native-object`, `:build-id`
    * Initialization of classes, `gtk-main-init()`

  * [ ] Intermezzo: widget life cycle
    * Widget creation. Reference state, weak references
    * Widget (un)referencing
    * Mapping and realizing
    * Destroy
    * Finalization
    * `.clear-object()`

<!--
  * [ ] Threads
    * Main
      * Start loop
      * Stop loop
      * Nest loops
      * Loop Context
      * Process events
-->

  * [ ] Builder
    * Glade
    * Gui XML description
    * Menu XML description

  * [ ] Styling
  * [ ] Resources
  * [ ] Inheriting a class. Making a singleton class. Invalidate the object after $xyz.widget-destroy() is called. Example singleton statusbar.


  * [ ] Intermezzo: tell something about
    * Object
    * InitiallyUnowned
    * Boxed: https://en.wikipedia.org/wiki/GObject
      Some data structures that are too simple to be made full-fledged class types (with all the overhead incurred) may still need to be registered with the type system. For example, we might have a class to which we want to add a background-color property, whose values should be instances of a structure that looks like struct color { int r, g, b; }. To avoid having to subclass GObject, we can create a boxed type to represent this structure, and provide functions for copying and freeing. GObject ships with a handful of boxed types wrapping simple GLib data types. Another use for boxed types is as a way to wrap foreign objects in a tagged container that the type system can identify and will know how to copy and free.
    * Interfaces: https://en.wikipedia.org/wiki/GObject
      Most types in the `Gnome::*` libraries will be classes, derived directly or indirectly from the root class **Gnome::N::TopLevelClassSupport**. There are also interfaces, which can contain implemented methods and variables. These interfaces are declared as roles and are mixed in, in the appropriate class. E.g. a role **Gnome::Gtk3::Buildable** is mixed in **Gnome::Gtk3::Widget**. All objects created from classes inheriting from **Gnome::Gtk3::Widget** can then use the methods from **Gnome::Gtk3::Buildable** too.

  * [ ] ApplicationWindow
    * Phases
    * Signals
    * Multiple program entities or not

  * [ ] Drag and drop
  * [ ] Drawing with Cairo
  * [ ] Font and other text handling with Pango
  * [ ] D-Bus
  * [ ] Cairo
  * [ ] Pango

  * [ ] Debugging
    * `Gnome::N::debug()`.
    * Testing your program with **Gnome::T.**
    * Gtk Inspector
      * `> gsettings set org.gtk.Settings.Debug enable-inspector-keybinding true`
      * `ctrl-shift-D` or `ctrl-shift-I`
      * `$window.set-interactive-debugging(True)`
      * env var GTK_DEBUG=interactive
    * Environment variables: See also [Running GLib Applications: GLib Reference Manual](https://developer.gnome.org/glib/stable/glib-running.html#G_SLICE) and [GTK variables and commandline options](https://developer.gnome.org/gtk3/stable/gtk-running.html).
      * G-DEBUG all
      * G_MESSAGES_DEBUG all
      * G_SLICE debug-blocks
    * CATCH in callback handler to intercept an Exception when registering a callback using `g_signal_connect_object()` instead of `.register-signal()`.
    * Do's and Don'ts.
      * Do not call `.clean-object()` on iterators, widgets, or in callback handlers.

  * [ ] Preparations for Gtk4
    * Use GtkApplication instead of basic window build up.

* Code examples
  * [x] Todo Viewer
  * [ ] Simple calculator
  * [ ] Animation with a clock
  * [ ] A new widget

* [ ] Check licensing of the whole project, contact Gnome?

* [x] Remove changelog from About page and add separate pages for the changelog from the packages.
