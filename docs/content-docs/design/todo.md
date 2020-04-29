---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## TODO list of things

#### Study
* [x] [References and object creation in the light of memory leaks](https://developer.gnome.org/gobject/stable/gobject-memory.html#gobject-memory-refcount).
  * Cannot automatically cleanup the natice object in the Raku object when object gets destroyed.
  * Users of the packages must therefore clean the objects themselves when appropriate using `.widget-destroy()` or `.clean-object()`.
* [x] Applications behaviour from Gtk and Gio packages
* [x] Resources from Gio package
* [x] Menus and Actions
* [ ] Drag and Drop
* [ ] DBus I/O
* [ ] Pango
* [ ] Cairo.

#### Rewriting code
* Below notes can go to implementation details when done

* [x] Reverse testing procedures in `_fallback()` methods. Now the shortest names are found first.
  ```
  try { $s = &::("gtk_list_store_$native-sub"); };
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  ```
  In other packages `gtk_` can be `g_` or `gdk_`.

* [x] Add a test to `_fallback()` so that the prefix 'gtk_' can be left off the subname when used. So the above tests becomes;
  ```
  try { $s = &::("gtk_list_store_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  ```
  Also here, in other packages `gtk_` can be `g_`, `gdk_` etc.

  The call to the sub `gtk_list_store_remove` can now be one of `.gtk_list_store_remove()`, `.list_store_remove()` or `.remove()` and the dashed ('-') counterparts. Bringing it down to only one word like the 'remove' above, will not always work. Special cases are `new()` and other methods from classes like **Any** or **Mu**.
  * Find the short named subs which are also defined in Any or Mu. Add a method to catch the call before the one of **Any** or **Mu**.
    * [ ] append
    * [ ] new

* [ ] Is there a way to skip all those if's in the `_fallback()` routines.

* [x] Caching the subroutine's address in **Object** must be more specific. There could be a sub name (short version) in more than one module. It is even a bug, because equally named subs can be called on the wrong objects. This happened on the Library project where `.get-text()` from **Entry** was taken to run on a **Label**. So the class name of the caller should be stored with it too. We can take the `$!gtk-class-name` for it.

* Make some of the routines in toplevel classes the same.
  * [x] `.clear-object()`: A clear function which calls some native free function if any, then invalidates the native object. This is always a class inheriting from Boxed. The exception is **Gnome::GObject::Object** where it is done on behalf of the child classes and also uses native unref. In Boxed this must be an abstract method. This is done now in the TopLevelClassSupport

  * [x] `.is-valid()`: A boolean test to check if a native object is valid.

  * [x] `.set-native-object()`
  * [x] `.get-native-object()`.

  * Prevent name clashes
    * [ ] set-name() in Gnome::Gtk3::Widget must stay while
    * [ ] Gnome::Gtk3::Buildable set-name() must become `buildable-set-name()`;
    * [ ] Gnome::Gio::Action set-name() must become `action-set-name()`;
<!--
    * [ ] Gnome::GObject::
    * [ ] Gnome::GObject::
-->

Defining DESTROY() at the top was a big mistake! Obvious when you think of it! dereferencing or cleaning up a native object should only be done explicitly because when the Raku object goes out of scope doesn't mean that the native object isn't in use anymore.

Also calling clear-object() in BUILD() and several other places is wrong for the same reason.

<!--

* [x] `DESTROY()`: Cleanup methods called on garbage collection. The sub calls the clear method or free function if the native object is still valid. Easy to add while implementing `clear-object()`. This is done now in the TopLevelClassSupport, a catch all class.

  * Interface Roles. Roles do not have to specify a DESTROY submethod unless there are local native objects defined which will be unlikely.

  * Top class is **Gnome::GObject::Object**. A DESTROY method will be defined here because there is the native object stored.
-->

* [x] Make some of the named arguments to new() the same. We now have `:widget`, `:object`, `:tree-iter` etcetera while the value for these attributes are native objects. Rename these to `:native-object`. It's more clear. The type for it can differ but will not pose a problem.

* [x] Drop the use of `:empty` and `:default`. Instead an argumentless call should be sufficient.

* I'm not sure if the named argument `:$widget` to a signal handler needs to be renamed. It holds the Raku object which registered the signal. This might not always be a 'widget' i.e. inheriting from **Gnome::Gtk3::Widget**.

* [ ] I have noticed that True and False can be used on int32 typed values. The G_TYPE_BOOLEAN (Gtk) or gboolean (Glib C) are defined as int32. Therefore, in these cases, True and False can be used. This is not clearly shown in the examples and documentation.

* [ ] Reorder the list of methods in all modules in such a way that they are sorted. This might be of use for documentation

* [ ] Many methods return native objects. this could be molded into Raku objects when possible.

* [ ] Interface modules are defined as Raku roles. This must be changed into classes.

* [ ] It is not possible to inherit from the modules to create your own class due to the way the classes are BUILD(). Review the initialization methods to overcome this.

* [x] Remove CALL-ME methods and all uses of them.

* [x] There is an issue about tests going wrong because of a different native speaking language instead of English.

* [ ] An extention to the language issue above, error messages generated in the packages, should be displayed in other languages as well, starting with the most used ones like German, French and Spanish. And for the fun of it also in Dutch.

* [ ] To test for errors, an error code must be tested instead of the text message. The errors generated in the package need to add such a code. To keep a good administration the errors must be centralized in e.g. Gnome::N. This is also good to have translations there. Need to use tools for that.

* [ ] For localization, GTK+/GNOME uses the GNU gettext interface. gettext works by using the strings in the original language (usually English) as the keys by which the translations are looked up. All the strings marked as needing translation are extracted from the source code with a helper program.

* [x] Add a toplevel class to support standalone classes in glib something like **Gnome::GObject::Boxed** is. The class is called **Gnome::N::TopLevelClassSupport**.

* [ ] When a native object is given using `.new(:native-object())`, it is not correct to set the type of the object assuming that the type is the same of the Raku class consuming this native object. E.g it is possible the create a **Gnome::Gtk3::Widget** using a native object of a button. This can give problems when casting or even worse, creating a Gnome::Gtk3::Button using a native GtkContainer. Testing should be done to find the proper native object.

* [x] Add `CATCH { default { .message.note; .backtrace.concise.note } }` at the top of callback routines. This is done for all callback routines which are registered using `.register-signal()` but other places must be searched for, e.g. like foreach in **Gnome::Gtk3::Container**.

#### Documentation
There are still a lot of bugs and documentation anomalies. Also not all subs, signals and properties are covered in tests. As a side note, modify certain Raku comments in pod doc because the github pages understand some of them to substitute variables.

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

* [ ] Remove documentation of native `xyz_new()` creation subs. What is needed will be covered by options like `.new(:$xyz)` in `BUILD()`. The subs can also be prefixed with an underscore '\_' to make them unavailable, e.g. `_xyz_new()`.

* [ ] Add a section about a misunderstanding when using `DESTROY()` in a user object to cleanup a native object which inherits a Raku G*::object.

* [ ] Each user class inheriting a Raku G*::object must have a new() to create the native object. this must be repeated for other client use classes because only the leaf new() is run!

* [ ] Add plantuml diagrams to documents. Not (yet?) possible on github pages.

#### Site changes.
* [x] Reference pages have two sections shown per module. One for a table of contents and one for generated html from the pod doc of the module. Turn this into one display. Also the header of a section should be clickable to return to the table of contents.

* [ ] In the sidebar of the reference section, the doc and test icons should be replaced by one icon. Pressing on it should show a table with test coverage and documentation status instead of showing at the top of the ref page. It can also show issues perhaps.

* [ ] The sidebar for Gtk references is messy. Should be ordered alphabetically perhaps.

* [ ] Code samples shown are taken directly from real working programs. This makes it easy to work on the programs without modifying the code in the docs. However with longer listings I want to show parts of it using min and max line numbers.

* [x] Jekyll shows errors which must be removed. Site content looks good however.

* Tutorials
  * [x] Find material of other tutorials and books in other programming languages. E.g. Zetcode and Wikibooks

  * Getting started
    * [x] Empty window
    * [x] Window with a button
    * [x] Show a mistake of two buttons in window
    * [x] Buttons in a grid

  * Intermezzo (skippable)
    * [ ] Search process starting in `FALLBACK()` in **Gnome::N::TopLevelClassSupport**. Show UML diagram.
    * [ ] Method names of the native subroutines

  * Window details
    * [ ] Window decoration, title and icon
    * [ ] Window size
    * [ ] Centering with position
    * [ ] Destroy signal

    * [ ] (Scrolled)Window
    * [ ] Dialogs

    * [ ] Frame
        * [ ] container border
    * [ ] Grid

  * Intermezzo (skippable)
    * [ ] Common method names used in classes
    * [ ] Initialization of classes

  * Widgets
    * Controls
      * [ ] Buttons
      * [ ] Menus
      * [ ] Toolbars
      * [ ] ComboxBox

    * Display
      * [ ] Labels
      * [ ] LevelBar

    * Lists and Edit
      * [ ] Entry
      * [ ] ListBox
      * [ ] TreeView

  * [ ] Signals
  * [ ] Threads
  * [ ] Builder
    * [ ] Glade
    * [ ] Gui XML description
    * [ ] Menu XML description
  * [ ] Styling
  * [ ] Resources
  * [ ] Inheriting

  * [ ] Drag and drop
  * [ ] Drawing
  * [ ] Font and other text handling

  * [ ] Application
    * [ ] Phases
    * [ ] Signals
    * [ ] Multiple program entities or not
    * [ ] D-Bus

  * Debugging
    * Testing your program with Gnome::T.
    * `Gnome::N::debug()`.
    * Environment variables: See also [Running GLib Applications: GLib Reference Manual](https://developer.gnome.org/glib/stable/glib-running.html#G_SLICE).
      * [ ] G-DEBUG all
      * [ ] G_MESSAGES_DEBUG all
      * [ ] G_SLICE debug-blocks
    * CATCH in callback handler to intercept an Exception when registering a callback using `g_signal_connect_object()` instead of `.register-signal()`.
    * Do's and Don'ts.
      * Do not call `.clean-object()` on iterators, widgets, or in callback handlers.

* Code examples
  * [ ] Configuration editor
  * [ ] Simple calculator

* [ ] Check licensing of the whole project, contact Gnome?

* [ ] Remove changelog from About page and add separate pages for the changelog from the packages.


# Checklist

## Head keys
### Main documentation
* dt: title, description, see also
* db: inheritance, synopsis, example
* bt: typos

### Subs and methods documentation
Legend for head of table

* T: type column
  * p: package name
  * t: is top level of classes,
  * b: boxed type
  * i: interface type
  * s: standalone type
  * not filled means standard class
* s\$: Add \$ to variables
* sb: Use True/False when boolean input
* sv: Remove Since version text
* no: Check if :native-object is used and documented in BUILDs
* to: Check typos
* ex: Add examples
* ct: Complete all tests
* cm: Cleanup subs/methods documentation, remove unusable subs and native new() doc, add =head3 to new() for each multi.
* cp: Cleanup properties documentation
* cs: Cleanup signals documentation



| Module/Class            |T |s$|sb|sv|no|to|ex|ct|cm|cp|cs|
|-------------------------|--|--|--|--|--|--|--|--|--|--|--|
**Gnome::N**              |p | #| #| #| #| #| #| #| #| #| #|
N-GObject                 |  |  |  |  |  |  |  |  |  |  |  |
NativeLib                 |
TopLevelClassSupport      |t|
X                         |
**Gnome::Glib**           |p|#|#|#|#|#|#|#|#|#|#|
**Gnome::GObject**        |p|#|#|#|#|#|#|#|#|#|#|
Boxed                     |  |
Enums                     |s|
InitiallyUnowned          |
Object                    |
Signal                    |s|
Type                      |s|
value                     |b|
**Gnome::Atk**            |p|#|#|#|#|#|#|#|#|#|#|
Object                    ||
**Gnome::Gio**            |p|#|#|#|#|#|#|#|#|#|#|
Application               ||
EmblemedIcon||
MountOperation||
**Gnome::Gdk3**           |p|#|#|#|#|#|#|#|#|#|#|
**Gnome::Gtk3**           |p|#|#|#|#|#|#|#|#|#|#|
AboutDialog|
AccelGroup|
AccelLabel|
AccelMap|
Accessible|
Actionable|i|
ActionBar|
Adjustment|
AppChooserButton|
AppChooser|i|
AppChooserWidget|
Application|
ApplicationWindow|
AspectFrame|
Assistant|
Bin|
Border|b|
Box|
Buildable|i|
Builder|
Button|
ButtonBox|
Calendar|
CellArea|
CellAreaBox|
CellAreaContext|
CellEditable|i|
CellLayout|i|
CellRenderer|
CellRendererAccel|
CellRendererCombo|
CellRendererPixbuf|
CellRendererProgress|
CellRendererSpin|
CellRendererSpinner|
CellRendererText|
CellRendererToggle|
CellView|
CheckButton|
CheckMenuItem|
ChooserDialog|
Clipboard|
ColorButton|
ColorChooserDialog|
ColorChooser|i|
ColorChooserWidget|
ComboBox|
ComboBoxText|
Container|
CssProvider|
CssSection|b|
Dialog|
DrawingArea|
Editable|i|
Entry|
EntryBuffer|
EntryCompletion|
EventBox|
EventController|
EventControllerKey|
EventControllerMotion|
EventControllerScroll|
Expander|
FileChooserButton|
FileChooserDialog|
FileChooser|i|
FileChooserWidget|
FileFilter|
Fixed|
FlowBox|
FlowBoxChild|
FontButton|
FontChooserDialog|
FontChooser|i|
FontChooserWidget|
Frame|
Gesture|
GestureDrag|
GestureLongPress|
GestureMultiPress|
GesturePan|
GestureRotate|
GestureSingle|
GestureStylus|
GestureSwipe|
GestureZoom|
GLArea|
Grid|
GtkOffscreenWindow|
GtkPlug|
GtkPrintUnixDialog|
GtkRecentChooserDialog|
GtkShortcutsWindow|
HandleBox|
HeaderBar|
IconFactory|
IconSet|b|
IconTheme|
IconView|
Image|
IMContext|
IMContextSimple|
IMMulticontext|
InfoBar|
Label|
Layout|
LevelBar|
LinkButton|
ListBox|
ListBoxRow|
ListStore|
LockButton|
Menu|
MenuBar|
MenuButton|
MenuItem|
MenuShell|
MenuToolButton|
MessageDialog|
ModelButton|
MountOperation|
Notebook|
Orientable|i|
Overlay|
PadController|
PageSetup|
PageSetupUnixDialog|
Paned|
PaperSize|b|
PlacesSidebar|
Popover|
PopoverMenu|
PrintBackend|
PrintContext|
Printer|
PrintJob|
PrintOperation|
PrintOperationPreview|i|
PrintSettings|
ProgressBar|
RadioButton|
RadioMenuItem|
RadioToolButton|
Range|
RcStyle|
RecentChooser|i|
RecentChooserMenu|
RecentChooserWidget|
RecentFilter|
RecentManager|
Requisition|b|
Revealer|
Scale|
ScaleButton|
Scrollable|i|
Scrollbar|
ScrolledWindow|
SearchBar|
SearchEntry|
SelectionData|b|
Separator|
SeparatorMenuItem|
SeparatorToolItem|
Settings|
ShortcutsGroup|
ShortcutsSection|
ShortcutsShortcut|
SizeGroup|
Socket|
SpinButton|
Spinner|
Stack|
StackSidebar|
StackSwitcher|
Statusbar|
StyleContext|
StyleProvider|i|
Switch|
TargetList|b|
TextBuffer|
TextChildAnchor|
TextIter|b|
TextMark|
TextTag|
TextTagTable|
TextView|
ToggleButton|
ToggleToolButton|
Toolbar|
ToolButton|
ToolItem|
ToolItemGroup|
ToolPalette|
ToolShell|i|
Tooltip|
TreeDragDest|i|
TreeDragSource|i|
TreeIter|b|
TreeModelFilter|
TreeModel|i|
TreeModelSort|
TreePath|b|
TreeRowReference|b|
TreeSelection|
TreeSortable|i|
TreeStore|
TreeView|
TreeViewColumn|
Viewport|
VolumeButton|
Widget|
WidgetPath|b|
Window|
WindowGroup|
