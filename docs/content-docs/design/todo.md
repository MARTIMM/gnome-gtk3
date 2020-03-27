---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## TODO list of things

#### Study
* [ ] [References and object creation in the light of memory leaks](https://developer.gnome.org/gobject/stable/gobject-memory.html#gobject-memory-refcount).
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

* [x] `DESTROY()`: Cleanup methods called on garbage collection. The sub calls the clear method or free function if the native object is still valid. Easy to add while implementing `clear-object()`. This is done now in the TopLevelClassSupport, a catch all class.

  * Interface Roles. Roles do not have to specify a DESTROY submethod unless there are local native objects defined which will be unlikely.

  * Top class is **Gnome::GObject::Object**. A DESTROY method will be defined here because there is the native object stored.

* [x] Make some of the named arguments to new() the same. We now have `:widget`, `:object`, `:tree-iter` etcetera while the value for these attributes are native objects. Rename these to `:native-object`. It's more clear. The type for it can differ but will not pose a problem.

* [x] Drop the use of `:empty` and `:default`. Instead an argumentless call should be sufficient.

* I'm not sure if the named argument `:$widget` to a signal handler needs to be renamed. It holds the Raku object which registered the signal. This might not always be a 'widget' i.e. inheriting from **Gnome::Gtk3::Widget**.

* [ ] I have noticed that True and False can be used on int32 typed values. The G_TYPE_BOOLEAN (Gtk) or gboolean (Glib C) are defined as int32. Therefore, in these cases, True and False can be used. This is not clearly shown in the examples and documentation.

* [ ] Reorder the list of methods in all modules in such a way that they are sorted. This might be of use for documentation

* [ ] Many methods return native objects. this could be molded into Raku objects when possible.

* [ ] Add 'is export' to all subs in interface modules. This can help when the subs are needed directly from the interface using modules. Perhaps it can also simplify the `_fallback()` calls to search for subs in interfaces.

* [ ] It is not possible to inherit from the modules to create your own class due to the way the classes are BUILD(). Review the initialization methods to overcome this.

* Move pieces of code from FALLBACK in **Gnome::GObject::Object** to **Gnome::N::X** so that other toplevel classes can use it too.
  * [x] `convert-to-natives()`
  * [ ] casting
  * [ ] move methods `set-class-info()` / `get-class-info()` to **Gnome::N::X** as well as the storage into $!gtk-class-gtype. This means that the sub `g_type_from_name()` from **Gnome::GObject::Type** must be duplicated to prevent circular dependency.

* [x] Remove CALL-ME methods and all uses of them.

* [x] There is an issue about tests going wrong because of a different native speaking language instead of English.

* [ ] An extention to the language issue above, error messages generated in the packages, should be displayed in other languages as well, starting with the most used ones like German, French and Spanish. And for the fun of it also in Dutch.

* [ ] To test for errors, an error code must be tested instead of the text message. The errors generated in the package need to add such a code. To keep a good administration the errors must be centralized in e.g. Gnome::N. This is also good to have translations there. Need to use tools for that.

* [ ] For localization, GTK+/GNOME uses the GNU gettext interface. gettext works by using the strings in the original language (usually English) as the keys by which the translations are looked up. All the strings marked as needing translation are extracted from the source code with a helper program.

* [ ] Add `method clear-object ( ) { !!! }` to **Gnome::GObject::Boxed**. This removes the need to set/clear `$!is-valid` using calls to methods from the child objects. `.set-native-object()` will handle the clearing then from there.

* [x] Add a toplevel class to support standalone classes in glib something like **Gnome::GObject::Boxed** is. The class is called **Gnome::N::TopLevelClassSupport**.
  * [x] **Gnome::Glib::Error**
  * [x] **Gnome::Glib::List**
  * [x] **Gnome::Glib::Slist**
  * [x] **Gnome::Glib::Variant**
  * [x] **Gnome::Glib::VariantIter**
  * [x] **Gnome::Glib::VariantType**
  * [x] **Gnome::Glib::VariantBuilder**

  * [ ] **Gnome::GObject::Object**
  * [ ] **Gnome::GObject::Boxed**
<!--   * [ ] **Gnome::GObject::** -->



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

* [ ] Remove documentation of native `xyz_new()` creation subs. What is needed will be covered by options like `.new(:$xyz)` in `BUILD()`. The subs can also be prefixed with an underscore '\_' to make them unavailable, e.g. `_xyz_new()`.

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


# Checklist
    - main_doc:
      - 'title, description, see also': 0
      - 'inheritance, synopsis, example': 0
      - typos: 0
    - subs_doc:
      - 'add $ to variables': 0
      - 'use True/False when boolean input': 0
      - 'remove Since version text': 0
      - 'check if :native-object is used and documented in BUILDs': 0
      - typos: 0
      - examples: 0
    - 'complete all tests': 0
    - 'remove unusable subs': 0
    - cleanup: 0

Gnome::N
TopLevelClassSupport

Gnome::GObject
InitiallyUnowned

Gnome::Gtk3
Widget
Container
Bin
Window
Dialog
AboutDialog
ChooserDialog
ColorChooserDialog
FileChooserDialog
FontChooserDialog
MessageDialog
PageSetupUnixDialog
GtkPrintUnixDialog
GtkRecentChooserDialog
ApplicationWindow
Assistant
GtkOffscreenWindow
GtkPlug
GtkShortcutsWindow
ActionBar
ComboBox
AppChooserButton
ComboBoxText
Frame
AspectFrame
Button
ToggleButton
CheckButton
RadioButton
MenuButton
ColorButton
FontButton
LinkButton
LockButton
ModelButton
ScaleButton
VolumeButton
MenuItem
CheckMenuItem
RadioMenuItem
SeparatorMenuItem
EventBox
Expander
FlowBoxChild
HandleBox
ListBoxRow             
ToolItem                   
ToolButton
MenuToolButton
ToggleToolButton
RadioToolButton
SeparatorToolItem
Overlay
ScrolledWindow
PlacesSidebar
Popover
PopoverMenu
Revealer
SearchBar
StackSidebar
Viewport
Box
AppChooserWidget
ButtonBox
ColorChooserWidget
FileChooserButton
FileChooserWidget
FontChooserWidget
InfoBar
RecentChooserWidget
ShortcutsSection
ShortcutsGroup
ShortcutsShortcut
StackSwitcher          
Statusbar
Fixed
FlowBox
Grid
HeaderBar
Paned
IconView
Layout
ListBox
MenuShell
MenuBar
Menu
RecentChooserMenu
Notebook
Socket
Stack
TextView
Toolbar
ToolItemGroup
ToolPalette
TreeView
Label
AccelLabel
Image
Calendar
CellView
DrawingArea
Entry
SearchEntry
SpinButton
GLArea
Range
Scale
Scrollbar
Separator
ProgressBar
Spinner
Switch
LevelBar
Adjustment
CellArea
CellAreaBox
CellRenderer
CellRendererText
CellRendererAccel
CellRendererCombo
CellRendererSpin
CellRendererPixbuf
CellRendererProgress
CellRendererSpinner
CellRendererToggle
FileFilter
TreeViewColumn
RecentFilter
AccelGroup
AccelMap
Accessible
Application
Builder
CellAreaContext
Clipboard
CssProvider
EntryBuffer
EntryCompletion
EventController
EventControllerKey
EventControllerMotion
EventControllerScroll
Gesture
GestureSingle
GestureDrag
GesturePan
GestureLongPress
GestureMultiPress
GestureStylus
GestureSwipe
GestureRotate
GestureZoom
PadController
IconFactory
IconTheme
IMContext
IMContextSimple
IMMulticontext
ListStore
MountOperation
PageSetup
Printer
PrintContext
PrintJob
PrintOperation
PrintSettings
RcStyle
RecentManager
Settings
SizeGroup
StyleContext
TextBuffer
TextChildAnchor
TextMark
TextTag
TextTagTable
TreeModelFilter
TreeModelSort
TreeSelection
TreeStore
WindowGroup
Tooltip
PrintBackend




TopLevelInterfaceSupport               Gnome::N::TopLevelInterfaceSupport
│
GInterface                                            
├── GtkBuildable                       Buildable
├── GtkActionable
├─✗ GtkActivatable                     Deprecated
├── GtkAppChooser
├── GtkCellLayout
├── GtkCellEditable
├── GtkOrientable                      Orientable
├── GtkColorChooser                    ColorChooser
├── GtkStyleProvider                   StyleProvider
├── GtkEditable
├── GtkFileChooser                     FileChooser
├── GtkFontChooser
├── GtkScrollable
├── GtkTreeModel                       TreeModel
├── GtkTreeDragSource
├── GtkTreeDragDest
├── GtkTreeSortable
├── GtkPrintOperationPreview
├── GtkRecentChooser
╰── GtkToolShell

Gnome::GObject
Boxed
PaperSize
TextIter
SelectionData
Requisition
Border
TreeIter
CssSection
TreePath
TreeRowReference
IconSet
TargetList
WidgetPath

Gnome::Atk
Object


Gnome::Gio
Application
MountOperation                                   
EmblemedIcon                                     
