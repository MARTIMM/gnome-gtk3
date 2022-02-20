---
title: Planned Todo's
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

# TODO list of things

## Summary
A list of things to do. More info in the following sections.

* Study
  * [ ] Study memory management
  * [ ] Study dbus I/O
  * [ ] Study examples from zcode and other sources

* Code
  * [ ] Implement methods to access native subs.
  * [ ] When methods are implemented add deprecation methods in `_fallback()`.
  * [ ] Remove `FALLBACK()` and `_fallback()` after deprecation period.
  * [ ] Order the enums, types, signal, property and subroutine name alphabetically.
  * [ ] Return lists when more than one value is returned from native sub.
  * [ ] Generated error messages should also display in other languages, **Gnome::M** for language support?
  * [ ] In `.new(:native-object)` the native type should be tested against its proper type to match its Raku wrapper class.
  * [ ] Remove `-rk()` subroutines in favor of coercing.
  * [ ] Add routines in `N-xyz` (like in N-GObject) and `TopLevelClassSupport` classes to coerce types.
  * [ ] Make use of coercion like `N-GObject()` in other `repr('CPointer')` types.
  * [ ] Add more modules to Gtk3 package.
  * [ ] Add more modules to Gdk3 package.
  * [ ] Add more modules to Cairo package.
  * [ ] Add more modules to Gio package.
  * [ ] Add more modules to Glib package.
  * [ ] Add Pango package.
  * [ ] Add Atk package.

* Documentation
  * [ ] Modify wrongly generated names and methods in doc.
  * [ ] Add plantuml diagrams to Gtk class doc.
  * [ ] Remove property and signal examples in those sections and move it to tutorials.

  * [ ] Preparations for Gtk4.
  * [ ] Gtk/Gdk 4; differences, future implementations.

* Tutorials
  * [x] Getting Started; simple examples.

  * [x] Groundwork; Classes, lightly touch Object, Signal and Inheriting.
  * [ ] Common sub names, init, coercion; N-GObject, ToplevelClassSupport.
  * [ ] Object; store parameters and arguments.
  * [ ] Signals; (un)register, event loop, send events, …
  * [ ] Actions; button, menu, …

  * [x] Basic widgets; Window, Label, …
  * [ ] Input widgets; Entry, TextView, Switch, Check/Radio button, …
  * [ ] Advanced widgets; Containers, Dialogs, Tree models, Notebook, Stack, …
  * [x] Applications; sceleton, commandline, multi instances.

  * [x] Drag and drop.

  * [x] Cairo; drawing, use with Gtk.
  * [ ] Pango; Text control, use with Cairo and Gtk.

  * [ ] Resources;
  * [ ] Builder; glade, gui / menu XML description in text, file or resource.
  * [ ] Theming and styling; style sheets in text, file or resource.

  * [ ] Widget life cycle; creation, reference, clear-obj, map, realize, destroy.
  * [ ] Threads; event loop, nest loops, context.

  * [ ] D-Bus; advertize actions.
  * [ ] Gdk; lower level interaction.

  * [ ] Gnome::M; Multi language support

* Testing
  * [ ] Debugging; Gnome::N::debug()
  * [ ] Gtk Inspector; ctrl-shift-D, ctrl-shift-I, set-interactive-debugging, env var GTK_DEBUG=interactive.
  * [ ] Environment variables; [Running GLib Applications](https://developer-old.gnome.org/glib/stable/glib-running.html#G_SLICE), [GTK variables and commandline options](https://developer-old.gnome.org/gtk3/stable/gtk-running.html).
  * [ ] CATCH errors and warnings.
  * [ ] Gnome::T; Testing the user interface.

* Examples
  * [x] TODO Viewer.
  * [ ] Simple Calculator.
  * [ ] Theming an application.
  * [ ] Animation with a clock.
  * [ ] Creating a new widget.

* References to other libs and applications based on Gnome::*
  * [ ] QA; Question and Answer.
  * [ ] QA::Manager; Question and Answer handling configurations.
  * [ ] MongoDB::Gui.
  * [ ] desktop-entry-tools.raku; a linux KDE app.


## Study
* DBus I/O
* Need to find out what must be freed and what isn't because of Raku cleaning up. Must study the following;
  * Notes on memory management [here](https://docs.raku.org/language/nativecall#Notes_on_memory_management).
  * A hint on what to free is found here; gtk-question-index [at point 1.4, 1.5](https://developer.gnome.org/gtk3/stable/gtk-question-index.html)
  * and here; [Explicit_memory_management](https://docs.raku.org/language/nativecall#Explicit_memory_management).

## Rewriting code
<!--
NOTDONE, fallback will disappear
* Is there a way to skip all those if's in the `_fallback()` routines.
-->

* I have noticed that True and False can be used on int32 typed values when provided to the native sub in the argument list. The G_TYPE_BOOLEAN (Gtk) or gboolean (Glib C) are defined as int32. Therefore, in these cases, True and False can be used. This is not clearly shown in the examples and documentation yet. The return values are not coersed automatically to Bool but most of the time not needed. _In new generated code, methods are used to get and return all needed Raku types._
  * Add deprecate messages for the 'to be removed' names.

* Reorder the list of methods in all modules in such a way that they are sorted. This might be of use for documentation to find the methods more quickly. _This is done in new generated pod code._

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

* Error messages generated in the packages, should be displayed in other languages as well, starting with the most used ones like German, French and Spanish. And for the fun of it also in Dutch. Gtk already has done this for several return messages from the Gtk libraries.

* To test for errors, an error code must be tested instead of the text message. The errors generated in the package need to add such a code. To keep a good administration the errors must be centralized in e.g. Gnome::M (for messages). This is also good to have translations there. Need to use tools for that. For localization, GTK+/GNOME uses the GNU gettext interface. gettext works by using the strings in the original language (usually English) as the keys by which the translations are looked up. All the strings marked as needing translation are extracted from the source code with a helper program.

* When a native object is given using `.new(:native-object())`, it is not correct to set the type of the object assuming that the type is the same of the Raku class consuming this native object. E.g it is possible to create a **Gnome::Gtk3::Widget** using a native object of a button. This can give problems when casting or even worse, creating a **Gnome::Gtk3::Button** using a native GtkContainer. Testing should be done to accept the proper native object.

* New tests show that the `-rk()` methods are not needed anymore. Code is added to **Gnome::N::TopLevelClassSupport** and **Gnome::N::N-GObject** to coerce to and from a native object stored in a N-GObject type object.
```
my Gnome::Gtk3::Window $w .= new;

# to get the native object
my N-GObject() $no = $w;

# or
$no = $w.N-GObject;

# instead of
$no = $w.get-native-object;


# and from native to Raku object
my Gnome::Gtk3::Window() $w2 = $no;

# or with more control
my Gnome::Gtk3::Window(N-GObject) $w2 = $no;

# instead of
my Gnome::Gtk3::Window $w2 .= new(:native-object($no));


# Other conversion examples
$w.set-title('N-GObject coercion');
$no = $w;

# CALL-ME is used here. There are 3 ways to use it.
say $no(Gnome::Gtk3::Window).get-title;     # N-GObject coercion
say $no('Gnome::Gtk3::Window').get-title;   # N-GObject coercion
say $no().get-title;                        # N-GObject coercion

# or in command chains. note the dot before the round brackets.
my Gnome::Gdk3::Screen $s .= new;
$screen.get-rgba-visual.().get-depth;

# Nice to write this for the same result and documents your statement
$screen.get-rgba-visual.('Gnome::Gdk3::Visual').get-depth;
```

* Error objects are sometimes created when instantiating a class. The error object is then stored and can be reviewed after noticing that the object is not valid. This could be tested like;
  ```
  my XYZ::Object $xyz .= new( … );
  die $xyz.last-error.message unless $xyz.is-valid;
  ```
  Also methods can return error objects. When they do, also set the `$.last-error` attribute so it can still be examined later at a more convenient moment. Maybe always, and no return of an error?
  ```
  $xyz.do-something( … );
  die $xyz.last-error.message unless $xyz.last-error.is-valid;
  ```
  Sometimes the gnome functions return a boolean. Can return that instead?
  ```
  die $xyz.last-error.message unless $xyz.do-something( … );
  ```

## Add other packages
* Pango.
* Atk. [Docs version 2.28](https://developer.gnome.org/atk/2.28/)

## Documentation
* All the several possibilities to use a method should be removed eventually and kept only one name. Keep the names where clashes could take place like `get-name()` from **Builder** and **Widget**. Dashes are prevered.
  * Method names kept are the names without the module prefixes. Sometimes a method must be added to prevent calling a method from **Any** or **Mu**. Examples
    * `gtk_grid_attach()` -> `attach()`.
    * `gtk_label_new()` -> `new()`. Handled with submethod `BUILD()`.
    * `gtk_widget_set_name()` -> `widget-set-name()`. Cannot be too short.
    * `gtk-list-store-append()` -> `append()`. Needs an extra method.
  * Adjust documentation.

* Add a section about a misunderstanding when using `DESTROY()` in a user object to cleanup a native object which inherits a Raku G*::object.
  * Cannot automatically cleanup the native object in the Raku object when object gets destroyed.
  * Users of the packages must therefore clean the objects themselves when appropriate using `.clean-object()`.

* Each user class inheriting a Raku G*::object must have a new() to create the native object. This must be repeated for other subsequent inheriting classes because only the top new() is run!

* Add plantuml diagrams to documents. SVG is the best picture format.

* Explain difference in actions of a widget like show, realize, map events, expose events and map. A [question from a blog](https://blogs.gnome.org/jnelson/2010/10/13/those-realize-map-widget-signals/)

* In some situations, modules need to be imported just for a name from an enumerated type. In those cases it would be better when all enums go into the **Enums** module instead of having some of them in a specific module. E.g. `GTK_WIN_POS_MOUSE` comes from **Window**, `GTK_RESPONSE_NO` from **Dialog** and `GTK_MESSAGE_WARNING` from **Enums**. We might need to include all three of the modules when dealing with e.g. a **MessageDialog**.

* Replacement code for some deprecated Gtk modules, see [Stack Overflow](https://stackoverflow.com/questions/24788045/gtk-action-group-new-and-gtkstock-what-to-use-instead)
  * Gtk.ActionGroup is deprecated, use Gio.SimpleActionGroup
  * Gtk.Action is deprecated, use Gio.SimpleAction
  * If you create a menu, use `.menu_new_with_model()` using **Gnome::Gio::MenuModel** (better approach). Menu handling from gtk is completely removed in version 4, so, to make your program more ready for version 4 use the menu modules from Gnome::Gio. Also the MenuBar is removed from GTK version 4. The only way to have a menubar is to use the Application module which is a bit complex.
  * UIManager is deprecated in GTK, use **Gnome::Gtk3::Builder** instead
  * Stock is deprecated, use `.set_icon_name()` methods instead where applicable. For example, read **Gnome::Gtk3::ToolButton** doc. In menu, unfortunately, GTK has dropped the use of icons in menus. See also [google docs](https://stackoverflow.com/questions/24788045/gtk-action-group-new-and-gtkstock-what-to-use-instead)

## Site documentation.
* Code samples shown are taken directly from real working programs. This makes it easy to work on the programs without modifying the code in the docs. However with longer listings I want to show parts of it using min and max line numbers.

  <!--
  * [ ] Toplevel widgets
    * Dialogs
      * AboutDialog
      * FileChooserDialog
      * MessageDialog
    * Window (already done above)
    * ApplicationWindow

  * [ ] Containers
    * Grid
    * Notebook
    * Frame
    * ListBox
    * ScrolledWindow
    * Revealer
    * Stack

  * [ ] Controls
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

  * [ ] Display
    * Label
    * LevelBar
    * Menu
    * Separator
    * DrawingArea

  * [ ] Models
    * TreeModel
    * ListStore
    * TreeStore
    * TreeView

  * [ ] Text
    * TextBuffer
    * EntryBuffer
    * TextTag
    * TextTagTable

  * [ ] Choosers
    * ColorChooserWidget
    * FontChooserWidget
  -->
<!--
    * Lists and Edit
      * TextView
      * Menus
      * ListBox
      * ListView, TreeView, TreeModel
      * Toolbars
      * Scale
-->
<!--
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
-->
<!--
  * [ ] Threads
    * Main
      * Start loop
      * Stop loop
      * Nest loops
      * Loop Context
      * Process events
-->
<!--
  * [ ] Builder
    * Glade
    * Gui XML description
    * Menu XML description

  * [ ] Styling
  * [ ] Resources


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

* [ ] All module names can be linked to their reference pages.
-->
