---
title: Check List
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

# Checklist

### Main documentation, subs and methods documentation
Legend for head of table

* **T**: type column with following values
  * t: is top level of classes, well, TopLevelClassSupport really is but here it is in the Gnome sense of things
  * b: boxed type
  * i: interface type
  * s: standalone module or type
  * N: native class
  * L: native library connection
  * not filled means standard class

* **I**: Inheritable

* Documentation
  * **dm**: Module documentation
    * Title, Description, UML
    * See also, UML, Synopsis
    * Inheritance when supported
    * Synopsis and example use
    * Remove interface information
  * **db**: Build documentation and initialization
    * Use test of `is-valid()` and ease of using `.set-native-object()`.
    * Remove check for wrong / unavailable options if inheritable.
    * Add =head3 to each `.new()` option.
    * Remove doc for :native-object or :build-id except where it is defined
    * Deprecate any option which can be done in a supsequent call like :$title in Window.
    * Move native `.gtk_..._new_...()` documentation to the Build doc. These subroutines must be prefixed with an underscore '\_' to make them unavailable, e.g. `._gtk_..._new_...()`.
  * **ds**: Method and subroutine documentation and additions
    * Add examples to subroutines.
    * Inhibit unusable subroutines and documentation, make note when no support.
    * Add sigils to variables and use `True`/`False` when boolean input. Many cases of C<Any> should become C<undefined>. Change first argument e.g. 'I<widget>' into text 'this widget' first arguments are mostly not provided because the are in the object.
    * Remove Since version text because versions are for GTK+ and not for the Raku modules.
    * Change `returns type` into `--> type`.
    * Provide single word method names. Lower prio.
    * Try to insert url references. Lower prio.
  * **de**: Signal and event documentation.
  * **dp**: Properties documentation.
* Testing.
  * **ts**: Subroutines and Methods.
  * **te**: Signals and events.
  * **tp**: Properties.
* 12: Issue number 12 check.

Entry values can be
* ✗: No info. Mostly for package names but sometimes there are no signals or properties for a class.
* Empty: Not done.
* ⅓, ½ or ⅔ is a raw measure of things partly done. Some subs are not yet available because of dependencies on other types which are not yet implemented. Also, not all subs can be tested because subs might need a more complete setup before being useful. Could also be, that I don't know what to do with it 😄.
* ✓: Done

<style>
table {
  width: 90%;
}
</style>

| Gnome::Gtk3             |T |I |dm|db|ds|de|dp|ts|te|tp|12|
|-------------------------|--|--|--|--|--|--|--|--|--|--|--|
AboutDialog               |  | ✓| ✓| ✓| ✓| ✓| ✓| ✓| ✓| ⅔| ✓|
Adjustment                |  |  | ✓| ✓| ✓|✓| ✓| ✓| | ✓|  |
Application               |  | ✓|  | ✓|  |  |  |  |  |  |  |
ApplicationWindow         |  | ✓|  | ✓|  |  |  |  |  |  |  |
AspectFrame               |  |  | ✓| ✓| ✓| ✗|  | ✓| ✗|  |  |
Assistant                 |  |  | ✓| ✓|  |  |  |  |  |  |  |
Bin                       |  |  |  |  |  |  |  |  |  |  |  |
Border                    |b |  |  |  |  |  |  |  |  |  |  |
Box                       |  |  |  |  |  |  |  |  |  |  |  |
Buildable                 |i |  |  |  |  |  |  |  |  |  |  |
Builder                   |  |  |  |  |  |  |  |  |  |  |  |
Button                    |  | ✓| ✓| ✓| ✓| ✓| ✓| ½| | | |
CellRenderer              |  |  |  |  |  |  |  |  |  |  |  |
CellRendererAccel         |  |  |  |  |  |  |  |  |  |  |  |
CellRendererCombo         |  |  |  |  |  |  |  |  |  |  |  |
CellRendererPixbuf        |  |  |  |  |  |  |  |  |  |  |  |
CellRendererProgress      |  |  |  |  |  |  |  |  |  |  |  |
CellRendererSpin          |  |  |  |  |  |  |  |  |  |  |  |
CellRendererSpinner       |  |  |  |  |  |  |  |  |  |  |  |
CellRendererText          |  |  |  |  |  |  |  |  |  |  |  |
CellRendererToggle        |  |  |  |  |  |  |  |  |  |  |  |
CheckButton               |  | ✓|  |  |  |  |  |  |  |  |  |
ColorButton               |  |  |  |  |  |  |  |  |  |  |  |
ColorChooser              |i |  |  |  |  |  |  |  |  |  |  |
ColorChooserDialog        |  |  |  |  |  |  |  |  |  |  |  |
ColorChooserWidget        |  |  |  |  |  |  |  |  |  |  |  |
ComboBox                  |  |  |  |  |  |  |  |  |  |  |  |
ComboBoxText              |  |  |  |  |  |  |  |  |  |  |  |
Container                 |  |  |  |  |  |  |  |  |  |  |  |
CssProvider               |  |  |  |  |  |  |  |  |  |  |  |
Dialog                    |  | ✓|  |  |  |  |  |  |  |  | |
DrawingArea               |  |  | ½| ✓| ✓| ✗| ✗| ✓| ✗| ✗| |
Entry                     |  | ✓|  |  |  |  |  |  |  |  |  |
Enums                     |s |  |  |  |  | ✗| ✗|  | ✗| ✗| |
FileChooser               |i |  |  |  |  |  |  |  |  |  |  |
FileChooserButton         |  | ✓| ✓| ✓|✓| ✓| ✓|½|  |⅓ |  |
FileChooserDialog         |  |  |  |  |  |  |  |  |  |  |  |
FileFilter                |  |  |  |  |  |  |  |  |  |  |  |
Frame                     |  |  |  |  |  |  |  |  |  |  | |
Grid                      |  | ✓|  |  |  |  |  |  |  |  | |
IconTheme                 |  |  | ✓|  |  |  |  |  |  |  |  |
IconView                  |  |  | ✓|  |  |  |  |  |  |  |  |
Image                     |  |  | ✓| ✓| ✓| ✗| ✓| ⅓| ✗|  |  |
Label                     |  | ✓|  |  |  |  |  |  |  |  |  |
LevelBar                  |  |  |  |  |  |  |  |  |  |  |  |
ListBox                   |  |  |  |  |  |  |  |  |  |  |  |
ListBoxRow                |  |  |  |  |  |  |  |  |  |  |  |
ListStore                 |  |  |  |  |  |  |  |  |  |  |  |
Main                      |s |  | ✓| ✓| ⅔| ✗| ✗| ½| ✗| ✗| |
Menu                      |  |  |  |  |  |  |  |  |  |  |  |
MenuBar                   |  |  |  |  |  |  |  |  |  |  |  |
MenuButton                |  |  |  |  |  |  |  |  |  |  |  |
MenuItem                  |  |  |  |  |  |  |  |  |  |  |  |
MenuShell                 |  |  |  |  |  |  |  |  |  |  |  |
MessageDialog             |  | ✓|  |  |  |  |  |  |  |  |  |
Misc                      |  |  |  |  |  |  |  |  |  |  |  |
Notebook                  |  | ✓|  |  |  |  |  |  |  |  |  |
Orientable                |i |  |  |  |  |  |  |  |  |  |  |
Paned                     |  |  |  |  |  |  |  |  |  |  |  |
PlacesSidebar             |  |  |  |  |  |  |  |  |  |  |  |
Popover                   |  |  |  |  |  |  |  |  |  |  |  |
PopoverMenu               |  |  |  |  |  |  |  |  |  |  |  |
ProgressBar               |  |  |  |  |  |  |  |  |  |  |  |
RadioButton               |  | ✓|  |  |  |  |  |  |  |  |  |
Range                     |  |  |  |  |  |  |  |  |  |  |  |
RecentChooserMenu         |  | ✓|  |  |  |  |  |  |  |  |  |
Revealer                  |  |  | ✓| ✓| ✓| ✗| ✓| ✓| ✗| ¾|  |
Scale                     |  | ✓|  |  |  |  |  |  |  |  |  |
ScrolledWindow            |  |  |  |  |  |  |  |  |  |  |  |
SearchBar                 |  |  |  |  |  |  |  |  |  |  |  |
SearchEntry               |  |  |  |  |  |  |  |  |  |  |  |
Separator                 |  |  |  |  |  |  |  |  |  |  |  |
SpinButton                |  | ✓| ✓| ✓| ✓| ✓| ✓| ✓|  | ✓|  |
Spinner                   |  |  |  |  |  |  |  |  |  |  |  |
Stack                     |  | ✓| ✓| ✓| ✓| ✗| ✓| ✓| ✗| ✓|  |
StackSidebar              |  |  | ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗|  |
StackSwitcher             |  |  | ✓| ✓| ✓| ✗| ✓| ✓| ✗| ✓|  |
Statusbar                 |  | ✓| ✓| ✓| ✓| ✓| ✗| ✓| ✓| ✗|  |
StyleContext              |  |  |  |  |  |  |  |  |  |  |  |
StyleProvider             |i |  |  |  |  |  |  |  |  |  |  |
Switch                    |  |  |  |  |  |  |  |  |  |  |  |
TextBuffer                |  |  |  |  |  |  |  |  |  |  |  |
TextIter                  |b |  |  |  |  |  |  |  |  |  |  |
TextTag                   |  |  |  |  |  |  |  |  |  |  |  |
TextTagTable              |  |  |  |  |  |  |  |  |  |  |  |
TextView                  |  |  |  |  |  |  |  |  |  |  |  |
ToggleButton              |  |  |  |  |  |  |  |  |  |  |  |
ToolButton                |  |  |  |  |  |  |  |  |  |  |  |
ToolItem                  |  |  |  |  |  |  |  |  |  |  |  |
TreeIter                  |b | ✗| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗|  |
TreeModel                 |i | ✗| ✓| ✓|  |  |  |  |  |  |  |
TreePath                  |b | ✗| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗|  |
TreeRowReference          |b |  |  |  |  |  |  |  |  |  |  |
TreeSelection             |  |  |  |  |  |  |  |  |  |  |  |
TreeStore                 |  | ✓|  |  |  |  |  |  |  |  |  |
TreeView                  |  | ✓|  |  |  |  |  |  |  |  |  |
TreeViewColumn            |  |  |  |  |  |  |  |  |  |  |  |
Widget                    |  |  | ✓| ✓| ⅔| ½| ⅔|  |  |  | |
WidgetPath                |b |  |  |  |  |  |  |  |  |  |  |
Window                    |  | ✓| ✓| ✓|  |  |  |  |  |  | |

<!-- | Module/Class       |T |I |dm|db|ds|de|dp|ts|te|tp|12| -->

<br/>

<!--
AccelGroup                |
AccelLabel                |
AccelMap                  |
Accessible                |
Actionable                |i |
ActionBar                 |
AppChooserButton          |
AppChooser                |i |
AppChooserWidget          |
ButtonBox                 |
Calendar|
CellArea|
CellAreaBox|
CellAreaContext|
CellEditable              |i|
CellLayout                |i|
CellView|
CheckMenuItem|
ChooserDialog|
Clipboard|
CssSection                |b|
Editable|
EntryBuffer|
EntryCompletion|
EventBox|
EventController|
EventControllerKey|
EventControllerMotion|
EventControllerScroll|
Expander|
FileChooserButton|
FileChooserWidget|
Fixed|
FlowBox|
FlowBoxChild|
FontButton|
FontChooserDialog|
FontChooser               |i|
FontChooserWidget|
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
HandleBox|
HeaderBar|
IMContext|
IMContextSimple|
IMMulticontext|
InfoBar|
Layout|
LinkButton|
LockButton|
MenuToolButton|
ModelButton|
MountOperation|
OffscreenWindow|
Overlay|
PadController|
PageSetup|
PageSetupUnixDialog|
PaperSize                 |b|
Plug|
PrintBackend|
PrintContext|
Printer|
PrintJob|
PrintOperation|
PrintOperationPreview     |i|
PrintSettings|
PrintUnixDialog|
RadioMenuItem|
RadioToolButton|
RcStyle|
RecentChooser|i|
RecentChooserDialog|
RecentChooserWidget|
RecentFilter|
RecentManager|
Requisition|b|
ScaleButton|
Scrollable|i|
Scrollbar|
SelectionData|b|
SeparatorMenuItem|
SeparatorToolItem|
Settings|
ShortcutsGroup|
ShortcutsSection|
ShortcutsShortcut|
ShortcutsWindow|
SizeGroup|
Socket|
TargetList                |b|
TextChildAnchor|
TextMark|
ToggleToolButton|
Toolbar|
ToolItemGroup|
ToolPalette|
ToolShell                 |i|
Tooltip|
TreeDragDest              |i|
TreeDragSource            |i|
TreeModelFilter|
TreeModelSort|
TreeSortable              |i|
Viewport|
VolumeButton|
WindowGroup|

-->

<br/>

| Gnome::Gdk3             |T |I |dm|db|ds|de|dp|ts|te|tp|12|
|-------------------------|--|--|--|--|--|--|--|--|--|--|--|
Device                    |  |  |  |  |  |  |  |  |  |  |  |
Display                   |  |  |  |  |  |  |  |  |  |  |  |
Events                    |  |  |  |  |  |  |  |  |  |  | |
Keysyms                   |  |  |  |  |  |  |  |  |  |  |  |
Pixbuf                    |  |  |  |  |  |  |  |  |  |  |  |
RGBA                      |  |  |  |  |  |  |  |  |  |  |  |
Screen                    |  |  |  |  |  |  |  |  |  |  |  |
Types                     |  |  |  |  |  |  |  |  |  |  | |
Window                    |  |  |  |  |  |  |  |  |  |  |  |

<br/>

| Gnome::GObject          |T |dm|db|ds|de|dp|ts|te|tp|12|
|-------------------------|--|--|--|--|--|--|--|--|--|--|
Boxed                     |t | ✓| ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✓|
InitiallyUnowned          |  | ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✓|
Object                    |t | ✓| ✓| ✓| ✗| ✗| ¾| ✗| ✗| ✓|
Signal                    |i | ✓| ✓| ✓| ✗| ✗| ⅚| ✗| ✗| ✓|
Type                      |s | ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓|
value                     |b | ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓|

<br/>

| Gnome::Glib             |T |dm|db|ds|de|ts|te|12|
|-------------------------|--|--|--|--|--|--|--|--|
Error                     |  |  |  |  |  |  |  |  |
List                      |  |  |  |  |  |  |  |  |
Main                      |  |  |  |  |  |  |  |  |
Quark                     |  |  |  |  |  |  |  |  |
SList                     |  |  |  |  |  |  |  |  |
Variant                   |  |  |  |  |  |  |  |  |

<br/>

| Gnome::Gio              |T |dm|db|ds|de|ts|te|12|
|-------------------------|--|--|--|--|--|--|--|--|
Action                    |i |  |  |  |  |  |  |  |
ActionMap                 |i |  |  |  |  |  |  |  |
Application               |  |  |  |  |  |  |  |  |
EmblemedIcon              |  |  |  |  |  |  |  |  |
Enums                     |s |  |  |  |  |  |  |  |
File                      |i |  |  |  |  |  |  |  |
MenuModel                 |  |  |  |  |  |  |  |  |
MountOperation            |  |  |  |  |  |  |  |  |
Resource                  |b |  |  |  |  |  |  |  |
SimpleAction              |  |  |  |  |  |  |  |  |

<br/>

| Gnome::N                |T |dm|db|ds|ts|12|
|-------------------------|--|--|--|--|--|--|
GlibToRakuTypes           |  | ✗| ✗| ✗| ✗| ✓|
N-GObject                 |N | ✗| ✗| ✗| ✗| ✓|
NativeLib                 |L | ✗| ✗| ✗| ✗| ✓|
TopLevelClassSupport      |t |  |  |  |  | ✓|
X                         |  |  |  |  |  | ✓|

<br/>

| Gnome::Cairo            |T |dm|db|ds|ts|12|
|-------------------------|--|--|--|--|--|--|
Enums                     |  |  |  |  |  |  |
FontFace                  |  |  |  |  |  |  |
FontOptions               |  |  |  |  |  |  |
ImageSurface              |  |  |  |  |  |  |
Matrix                    |  |  |  |  |  |  |
Path                      |  |  |  |  |  |  |
Pattern                   |  |  |  |  |  |  |
ScaledFont                |  |  |  |  |  |  |
Surface                   |  |  |  |  |  |  |
Types                     |  |  |  |  |  |  |

<br/>

<!--
| Module/Class            |T |dm|db|ds|de|dp|ts|te|tp|12|
|-------------------------|--|--|--|--|--|--|--|--|--|--|
**Gnome::Atk**            |p | ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗|
Object                    |  |  |  |  |  |  |  |  |  |  |
-->
