---
title: Check List
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

# Checklist

### Main documentation, subs and methods documentation
Legend for head of table

* T: type column with following values
  * p: package name
  * t: is top level of classes,
  * b: boxed type
  * i: interface type
  * s: standalone module or type
  * N: native class
  * L: native library connection
  * not filled means standard class

* Documentation
  * dm: Module documentation
    * Title, Description, UML
    * See also, UML, Synopsis
    * Inheritance when supported
    * Synopsis and example use
    * Remove interface information
  * db: Build documentation and initialization
    * Use test of `is-valid()` and ease of using `.set-native-object()`.
    * Remove check for wrong / unavailable options if inheritable.
    * Add =head3 to each `.new()` option.
    * Remove doc for :native-object or :build-id except where it is defined
    * Deprecate any option which can be done in a supsequent call like :$title in Window.
    * Move native `.gtk_..._new_...()` documentation to the Build doc. These subroutines must be prefixed with an underscore '\_' to make them unavailable, e.g. `._gtk_..._new_...()`.
  * ds: Method and subroutine documentation and additions
    * Add examples to subroutines.
    * Inhibit unusable subroutines and documentation, make note when no support.
    * Add sigils to variables and use `True`/`False` when boolean input. Many cases of C<Any> should become C<undefined>. Change first argument e.g. 'I<widget>' into text 'this widget' first arguments are mostly not provided because the are in the object.
    * Remove Since version text because versions are for GTK+ and not for the Raku modules.
    * Change `returns type` into `--> type`.
    * Provide single word method names. Lower prio.
    * Try to insert url references. Lower prio.
  * de: Signal and event documentation.
  * dp: Properties documentation.
* Testing.
  * ts: Subroutines and Methods.
  * te: Signals and events.
  * tp: Properties.
* no: Notes
  * A star has more priority to finish than others
  * C depends on Cairo
  * P depends on Pango
Entry values can be
* ✗: No info. Mostly for package names but sometimes there are no signals or properties for a class.
* Empty: Not done.
* ⅓, ½ or ⅔ is a raw measure of things partly done. Some subs are not yet available because of dependencies on other types which are not yet implemented. Also, not all subs can be tested because subs might need a more complete setup before being useful. Could also be, that I don't know what to do with it 😄.
* 🗸: Done

| Module/Class            |T |dm|db|ds|de|dp|ts|te|tp|n |
|-------------------------|--|--|--|--|--|--|--|--|--|--|
**Gnome::Gtk3**           |p | ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗|
AboutDialog               |  | 🗸| 🗸| ¾|  |  |  |  |  | ✗|
AccelGroup                |
AccelLabel                |
AccelMap                  |
Accessible                |
Actionable                |i |
ActionBar                 |
Adjustment                |
AppChooserButton          |
AppChooser                |i |
AppChooserWidget          |
Application               |
ApplicationWindow         |
AspectFrame               |
Assistant                 |
Bin                       |
Border                    |b |
Box                       |
Buildable                 |i |
Builder                   |
Button                    |  | 🗸| 🗸| 🗸| 🗸| 🗸| ½| | | ✗|
ButtonBox                 |
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
Dialog                    |  |  |  |  |  |  |  |  |  |* |
DrawingArea               |  | ½| 🗸| 🗸| ✗| ✗| 🗸| ✗| ✗| ✗|
Editable|
Entry|
Enums                     |s |  |  |  | ✗| ✗|  | ✗| ✗|* |
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
Frame                     |  |  |  |  |  |  |  |  |  |* |
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
Grid                      |  |  |  |  |  |  |  |  |  |* |
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
Main                      |s | 🗸| 🗸| ⅔| ✗| ✗| ½| ✗| ✗|P |
Menu                      |
MenuBar                   |
MenuButton                |
MenuItem                  |
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
Widget                    |  | 🗸| 🗸| ⅔| ½| ⅔|  |  |  |* |
WidgetPath|b|
Window                    |  | 🗸| 🗸|  |  |  |  |  |  |* |
WindowGroup|

| Module/Class            |T |dm|db|ds|de|dp|ts|te|tp|n |
|-------------------------|--|--|--|--|--|--|--|--|--|--|
**Gnome::Gdk3**           |p | ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗|
Device                    |  |  |  |  |  |  |  |
Display                   |  |  |  |  |  |  |  |
Events                    |  |  |  |  |  |  |  |  |  |* |
Keysyms                   |  |  |  |  |  |  |  |
Pixbuf                    |  |  |  |  |  |  |  |
RGBA                      |  |  |  |  |  |  |  |
Screen                    |  |  |  |  |  |  |  |
Types                     |  |  |  |  |  |  |  |  |  |* |
Window                    |  |  |  |  |  |  |  |

| Module/Class            |T |dm|db|ds|de|dp|ts|te|tp|n |
|-------------------------|--|--|--|--|--|--|--|--|--|--|
**Gnome::GObject**        |p | ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗|
Boxed                     |t |  |  |  |  |  |  |
Enums                     |s |  |  |  |  |  |  |
InitiallyUnowned          |  |  |  |  |  |  |  |
Object                    |t |  |  |  |  |  |  |  |  |* |
Signal                    |- |  |  |  |  |  |  |  |  |* |
Type                      |s |  |  |  |  |  |  |
value                     |b |  |  |  |  |  |  |

| Module/Class            |T |dm|db|ds|de|dp|ts|te|tp|n |
|-------------------------|--|--|--|--|--|--|--|--|--|--|
**Gnome::Glib**           |p | ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗|
Error                     |  |  |  |  |  |  |  |
List                      |  |  |  |  |  |  |  |
Main                      |  |  |  |  |  |  |  |
Quark                     |  |  |  |  |  |  |  |
SList                     |  |  |  |  |  |  |  |
Variant                   |  |  |  |  |  |  |  |

| Module/Class            |T |dm|db|ds|de|dp|ts|te|tp|n |
|-------------------------|--|--|--|--|--|--|--|--|--|--|
**Gnome::Gio**            |p | ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗|
Action                    |i |  |  |  |  |  |  |
ActionMap                 |i |  |  |  |  |  |  |
Application               |  |  |  |  |  |  |  |
EmblemedIcon              |  |  |  |  |  |  |  |
Enums                     |s |  |  |  |  |  |  |
File                      |i |  |  |  |  |  |  |
MenuModel                 |  |  |  |  |  |  |  |
MountOperation            |  |  |  |  |  |  |  |
Resource                  |b |  |  |  |  |  |  |
SimpleAction              |  |  |  |  |  |  |  |

| Module/Class            |T |dm|db|ds|de|dp|ts|te|tp|n |
|-------------------------|--|--|--|--|--|--|--|--|--|--|
**Gnome::N**              |p | ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗|
N-GObject                 |N |  |  |  |  |  |  |
NativeLib                 |L |  |  |  |  |  |- |
TopLevelClassSupport      |t |  |  |  |  |  |* |
X                         |  |  |  |  |  |  |* |

| Module/Class            |T |dm|db|ds|de|dp|ts|te|tp|n |
|-------------------------|--|--|--|--|--|--|--|--|--|--|
**Gnome::Cairo**          |p | ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗|
Enums                     |  |  |  |  |  |  |  |
FontFace                  |  |  |  |  |  |  |  |
FontOptions               |  |  |  |  |  |  |  |
ImageSurface              |  |  |  |  |  |  |  |
Matrix                    |  |  |  |  |  |  |  |
Path                      |  |  |  |  |  |  |  |
Pattern                   |  |  |  |  |  |  |  |
ScaledFont                |  |  |  |  |  |  |  |
Surface                   |  |  |  |  |  |  |  |
Types                     |  |  |  |  |  |  |  |

<!--
**Gnome::Atk**            |p | ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗|
Object                    |  |
-->
