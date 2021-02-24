---
title: Check List
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

# Checklist

### Main documentation, subs and methods documentation
Legend for head of table

* **T**: Type column with following values
  * **Tl**: Inherit directly from TopLevelClassSupport.
  * **Bx**: Boxed type.
  * **R**: Interface type programmed as Raku roles.
  * **S**: Standalone module or type.
  * **N**: Native class structure or union.
  * **L**: Native library connection.
  * Not filled in means that it is a standard class.

* **I**: Inheritable by a user class.

* Documentation
  * **dm**: Module documentation
    * Title, Description
    * See also, UML, Synopsis
    * Inheritance description and example when supported
    * Example of use
    * Remove interface information
  * **db**: Build documentation and initialization
    * Use test of `is-valid()` and ease of using `.set-native-object()`.
    * Remove check for wrong / unavailable options if inheritable.
    * Add =head3 to each `.new()` option.
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
* **12**: Issue number 12; check use of types and modify.
* **14**: Issue number 14; implement methods on shortest name, remove from docs, deprecate rest later.
* **so**: Subroutines are sorted

Entry values can be
* ✗: No info. Unavailable e.g. there are no signals or properties for a class.
* Empty: Not done or do not have a value like for **T** or **I**.
* ⅓, ½, ⅔, etc, is a raw measure of things partly done. Some subs are not yet available because of dependencies on other types which are not yet implemented. Also, not all subs can be tested because subs might need a more complete setup before being useful. Could also be, that I don't know what to do with it 😄.
* ✓: Done

<style>
table {
  width: 90%;
}
</style>

| Gnome::Gtk3             |T |I |dm|db|ds|de|dp|ts|te|tp|12|14|so|
|-------------------------|--|--|--|--|--|--|--|--|--|--|--|--|--|
AboutDialog               |  | ✓| ✓| ✓| ✓| ✓| ✓| ✓| ✓| ⅔| ✓| ✓| ✓|
Actionable                |R | ✗| ✓| ✓| ✓| ✗| ✓| ✓| ✗| ½| ✓| ✓| ✓|
Adjustment                |  |  | ✓| ✓| ✓| ✓| ✓| ✓|  | ✓|  |  |  |
Application               |  | ✓|  | ✓|  |  |  |  |  |  |  |  |  |
ApplicationWindow         |  | ✓|  | ✓|  |  |  |  |  |  |  |  |  |
AspectFrame               |  |  | ✓| ✓| ✓| ✗|  | ✓| ✗|  |  |  |  |
Assistant                 |  | ✓| ✓| ✓| ✓| ✓| ✓| ⅘|  |  | ✓| ✓|  |
Bin                       |  |  |  |  |  |  |  |  |  |  |  |  |  |
Border                    |Bx|  |  |  |  |  |  |  |  |  |  |  |  |
Box                       |  |  |  |  |  |  |  |  |  |  |  |  |  |
Buildable                 |R | ✗| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓| ✓| ✓|
Builder                   |  |  |  |  |  |  |  |  |  |  |  |  |  |
Button                    |  | ✓| ✓| ✓| ✓| ✓| ✓| ½|  |  |  |  |  |
CellRenderer              |  |  |  |  |  |  |  |  |  |  |  |  |  |
CellRendererAccel         |  |  |  |  |  |  |  |  |  |  |  |  |  |
CellRendererCombo         |  |  |  |  |  |  |  |  |  |  |  |  |  |
CellRendererPixbuf        |  |  |  |  |  |  |  |  |  |  |  |  |  |
CellRendererProgress      |  |  |  |  |  |  |  |  |  |  |  |  |  |
CellRendererSpin          |  |  |  |  |  |  |  |  |  |  |  |  |  |
CellRendererSpinner       |  |  |  |  |  |  |  |  |  |  |  |  |  |
CellRendererText          |  |  |  |  |  |  |  |  |  |  |  |  |  |
CellRendererToggle        |  |  |  |  |  |  |  |  |  |  |  |  |  |
CheckButton               |  | ✓| ✓| ✓| ✓| ✓| ✓| ✓| ✓| ✓| ✓| ✓|  |
CheckMenuItem             |  |  |  |  |  |  |  |  |  |  |  |  |  |
ColorButton               |  |  |  |  |  |  |  |  |  |  |  |  |  |
ColorChooser              |R | ✗| ✓| ✓| ✓| ✓| ✓| ✓| ✓| ½| ✓| ✓| ✓|
ColorChooserDialog        |  |  |  |  |  |  |  |  |  |  |  |  |  |
ColorChooserWidget        |  |  |  |  |  |  |  |  |  |  |  |  |  |
ComboBox                  |  |  |  |  |  |  |  |  |  |  |  |  |  |
ComboBoxText              |  |  |  |  |  |  |  |  |  |  |  |  |  |
Container                 |  |  |  |  |  |  |  |  |  |  |  |  |  |
CssProvider               |  |  |  |  |  |  |  |  |  |  |  |  |  |
DrawingArea               |  |  | ½| ✓| ✓| ✗| ✗| ✓| ✗| ✗|  |  |  |
Dialog                    |  | ✓|  |  |  |  |  |  |  |  |  |  |  |
Entry                     |  | ✓|  |  |  |  |  |  |  |  |  |  |  |
Enums                     |S |  |  |  |  | ✗| ✗|  | ✗| ✗|  |  |  |
FileChooserButton         |  | ✓| ✓| ✓| ✓| ✓| ✓| ½|  | ⅓|  |  |  |
FileChooser               |R | ✗|  |  |  |  |  |  |  |  |  |  |  |
FileChooserDialog         |  |  |  |  |  |  |  |  |  |  |  |  |  |
FileFilter                |  |  |  |  |  |  |  |  |  |  |  |  |  |
Fixed                     |  | ✓| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓| ✓|  |
Frame                     |  |  |  |  |  |  |  |  |  |  |  |  |  |
Grid                      |  | ✓| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓| ✓|  |
IconTheme                 |  |  | ✓|  |  |  |  |  |  |  |  |  |  |
IconView                  |  |  | ✓|  |  |  |  |  |  |  |  |  |  |
Image                     |  |  | ✓| ✓| ✓| ✗| ✓| ⅓| ✗|  |  |  |  |
Label                     |  | ✓| ✓| ✓| ✓|  | ✓| ⅘|  | ⅗| ✓| ✓|  |
LevelBar                  |  |  |  |  |  |  |  |  |  |  |  |  |  |
ListBox                   |  |  |  |  |  |  |  |  |  |  |  |  |  |
ListBoxRow                |  |  |  |  |  |  |  |  |  |  |  |  |  |
ListStore                 |  |  |  |  |  |  |  |  |  |  |  |  |  |
Main                      |S |  | ✓| ✓| ⅔| ✗| ✗| ½| ✗| ✗|  |  |  |
Menu                      |  |  |  |  |  |  |  |  |  |  |  |  |  |
MenuBar                   |  |  |  |  |  |  |  |  |  |  |  |  |  |
MenuButton                |  |  |  |  |  |  |  |  |  |  |  |  |  |
MenuItem                  |  |  |  |  |  |  |  |  |  |  |  |  |  |
MenuShell                 |  |  |  |  |  |  |  |  |  |  |  |  |  |
MessageDialog             |  | ✓| ✓| ✓| ✓| ✗| ✓| ✓| ✗| ½| ✓| ✓|  |
Misc                      |  |  |  |  |  |  |  |  |  |  |  |  |  |
Notebook                  |  | ✓|  |  |  |  |  |  |  |  |  |  |  |
Orientable                |R | ✗| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓| ✓| ✓|
Paned                     |  |  |  |  |  |  |  |  |  |  |  |  |  |
PlacesSidebar             |  |  |  |  |  |  |  |  |  |  |  |  |  |
Popover                   |  |  |  |  |  |  |  |  |  |  |  |  |  |
PopoverMenu               |  |  |  |  |  |  |  |  |  |  |  |  |  |
ProgressBar               |  |  |  |  |  |  |  |  |  |  |  |  |  |
RadioButton               |  | ✓|  |  |  |  |  |  |  |  |  |  |  |
RadioMenuItem             |  | ✓| ✓| ✓| ✓| ✓| ✗| ✓|  | ✗| ✓| ✓|  |
Range                     |  |  |  |  |  |  |  |  |  |  |  |  |  |
RecentChooser             |R | ✗| ✓| ✓| ✓| ✓| ✓| ¾|  | ¾| ✓| ✓|  |
RecentChooserDialog       |  | ✓| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓| ✓|  |
RecentChooserMenu         |  | ✓| ✓| ✓| ✓| ✗| ✓| ✓| ✗| ✓| ✓| ✓|  |
RecentChooserWidget       |  | ✗| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓| ✓|  |
RecentInfo                |S | ✗| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓| ✓|  |
RecentFilter              |  | ✗| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓| ✓|  |
RecentManager             |  | ✗| ✓| ✓| ✓| ✓| ✓| ⅘|  | ✓| ✓| ✓|  |
Revealer                  |  |  | ✓| ✓| ✓| ✗| ✓| ✓| ✗| ¾|  |  |  |
Scale                     |  | ✓| ✓| ✓| ✓|  | ✗| ✓|  | ✗| ✓| ✓|  |
ScrolledWindow            |  |  |  |  |  |  |  |  |  |  |  |  |  |
SearchBar                 |  |  |  |  |  |  |  |  |  |  |  |  |  |
SearchEntry               |  |  |  |  |  |  |  |  |  |  |  |  |  |
Separator                 |  |  |  |  |  |  |  |  |  |  |  |  |  |
SeparatorMenuItem         |  | ✗| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓| ✓|  |
SpinButton                |  | ✓| ✓| ✓| ✓| ✓| ✓| ✓|  | ✓|  |
Spinner                   |  |  |  |  |  |  |  |  |  |  |  |
Stack                     |  | ✓| ✓| ✓| ✓| ✗| ✓| ✓| ✗| ✓|  |
StackSidebar              |  |  | ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗|  |
StackSwitcher             |  |  | ✓| ✓| ✓| ✗| ✓| ✓| ✗| ✓|  |
Statusbar                 |  | ✓| ✓| ✓| ✓| ✓| ✗| ✓| ✓| ✗|  |
StyleContext              |  |  |  |  |  |  |  |  |  |  |  |
StyleProvider             |R | ✗|  |  |  |  |  |  |  |  |  |
Switch                    |  |  |  |  |  |  |  |  |  |  |  |
TextBuffer                |  |  |  |  |  |  |  |  |  |  |  |
TextIter                  |Bx|  |  |  |  |  |  |  |  |  |  |
TextTag                   |  |  |  |  |  |  |  |  |  |  |  |
TextTagTable              |  |  |  |  |  |  |  |  |  |  |  |
TextView                  |  |  |  |  |  |  |  |  |  |  |  |
ToggleButton              |  |  |  |  |  |  |  |  |  |  |  |
ToolButton                |  |  |  |  |  |  |  |  |  |  |  |
ToolItem                  |  |  |  |  |  |  |  |  |  |  |  |
TreeIter                  |Bx| ✗| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗|  |
TreeModel                 |R | ✗| ✓| ✓|  |  |  |  |  |  |  |
TreePath                  |Bx| ✗| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗|  |
TreeRowReference          |Bx|  |  |  |  |  |  |  |  |  |  |
TreeSelection             |  |  |  |  |  |  |  |  |  |  |  |
TreeStore                 |  | ✓|  |  |  |  |  |  |  |  |  |
TreeView                  |  | ✓|  |  |  |  |  |  |  |  |  |
TreeViewColumn            |  |  |  |  |  |  |  |  |  |  |  |
Widget                    |  | ✗| ✓| ✓| ⅔| ½| ⅔| ⅓|  |  |  |
WidgetPath                |Bx|  |  |  |  |  |  |  |  |  |  |
Window                    |  | ✓| ✓| ✓|  |  |  |  |  |  |  |

<!-- | Module/Class       |T |I |dm|db|ds|de|dp|ts|te|tp|12|14| -->

<br/>

<!--
AccelGroup                |
AccelLabel                |
AccelMap                  |
Accessible                |
ActionBar                 |
AppChooserButton          |
AppChooser                |R | ✗|
AppChooserWidget          |
ButtonBox                 |
Calendar|
CellArea|
CellAreaBox|
CellAreaContext|
CellEditable              |R | ✗|
CellLayout                |R | ✗|
CellView|
ChooserDialog|
Clipboard|
CssSection                |Bx| ✗|
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
FlowBox|
FlowBoxChild|
FontButton|
FontChooserDialog|
FontChooser               |R | ✗|
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
PaperSize                 |Bx| ✗|
Plug|
PrintBackend|
PrintContext|
Printer|
PrintJob|
PrintOperation|
PrintOperationPreview     |R | ✗|
PrintSettings|
PrintUnixDialog|
RadioToolButton|
RcStyle|
Requisition|b|
ScaleButton|
Scrollable|i|
Scrollbar|
SelectionData|b|
SeparatorToolItem|
Settings|
ShortcutsGroup|
ShortcutsSection|
ShortcutsShortcut|
ShortcutsWindow|
SizeGroup|
Socket|
TargetList                |Bx| ✗|
TextChildAnchor|
TextMark|
ToggleToolButton|
Toolbar|
ToolItemGroup|
ToolPalette|
ToolShell                 |R | ✗|
Tooltip|
TreeDragDest              |R | ✗|
TreeDragSource            |R | ✗|
TreeModelFilter|
TreeModelSort|
TreeSortable              |R | ✗|
Viewport|
VolumeButton|
WindowGroup|

-->

<br/>

| Gnome::Gdk3             |T |I |dm|db|ds|de|dp|ts|te|tp|12|14|so|
|-------------------------|--|--|--|--|--|--|--|--|--|--|--|--|--|
Device                    |  |  |  |  |  |  |  |  |  |  |  |  |  |
Display                   |  |  |  |  |  |  |  |  |  |  |  |  |  |
Events                    |  |  |  |  |  |  |  |  |  |  |  |  |  |
Keysyms                   |  |  |  |  |  |  |  |  |  |  |  |  |  |
Pixbuf                    |  |  |  |  |  |  |  |  |  |  |  |  |  |
RGBA                      |  |  |  |  |  |  |  |  |  |  |  |  |  |
Screen                    |  |  |  |  |  |  |  |  |  |  |  |  |  |
Types                     |  |  |  |  |  |  |  |  |  |  |  |  |  |
Window                    |  |  |  |  |  |  |  |  |  |  |  |  |  |

<br/>

| Gnome::GObject          |T |dm|db|ds|de|dp|ts|te|tp|12|14|so|
|-------------------------|--|--|--|--|--|--|--|--|--|--|--|--|
Boxed                     |Tl| ✓| ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✓|  |  |
InitiallyUnowned          |  | ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✗| ✓|  |  |
Object                    |Tl| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓| ✓| ✓|
Signal                    |R | ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓| ✓| ✓|
Type                      |S | ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓|  |  |
value                     |Bx| ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓|  |  |

<br/>

| Gnome::Glib             |T |dm|db|ds|ts|12|14|so|
|-------------------------|--|--|--|--|--|--|--|--|
Error                     |Tl| ✓| ✓| ✓| ✓| ✓|  |  |
List                      |Tl| ✓| ✓| ✓| ✓| ✓|  |  |
Main                      |S | ✓| ✓| ✓| ✓| ✓|  |  |
MainContext               |S | ✓| ✓| ✓| ⅘| ✓| ✓| ✓|
MainLoop                  |S | ✓| ✓| ✓| ✓| ✓| ✓| ✓|
Quark                     |S | ✓| ✓| ✓| ✓| ✓|  |  |
SList                     |Tl| ✓| ✓| ✓| ✓| ✓|  |  |
Variant                   |Tl| ✓| ✓| ✓| ⅘| ✓| ✓| ✓|
VariantDict               |Tl| ✓| ✓| ✓| ⅘| ✓| ✓| ✓|
VariantType               |Tl| ✓| ✓| ✓| ⅘| ✓| ✓| ✓|

Module Main will be deprecated after version 0.20.0

<br/>

| Gnome::Gio              |T |dm|db|ds|de|dp|ts|te|tp|12|14|so|
|-------------------------|--|--|--|--|--|--|--|--|--|--|--|--|
Action                    |R | ✓| ✓| ✓| ✗| ✓| ✓| ✗| ⅖| ✓| ✓| ✓|
ActionMap                 |R | ✓| ✓| ✓| ✗| ✗| ✓| ✗| ✗| ✓| ✓| ✓|
Application               |  | ✓| ✓| ✓| ✓| ✓| ½| ¼| ⅔| ✓| ✓| ✓|
Enums                     |S |  |  |  |  |  |  |  |  |  |  |  |
File                      |R |  |  |  |  |  |  |  |  |  |  |  |
MenuModel                 |  |  |  |  |  |  |  |  |  |  |  |  |
Resource                  |Bx|  |  |  |  |  |  |  |  |  |  |  |
SimpleAction              |  | ✓| ✓| ✓| ✓| ✓| ✓| ✓| ⅖| ✓| ✓| ✓|

<!--
MountOperation            |  |  |  |  |  |  |  |  |  |  |
EmblemedIcon              |  |  |  |  |  |  |  |  |  |  |
-->

<br/>

| Gnome::Cairo            |T |dm|db|ds|ts|12|14|so|
|-------------------------|--|--|--|--|--|--|--|--|
Enums                     |  |  |  |  |  |  |  |  |
FontFace                  |  |  |  |  |  |  |  |  |
FontOptions               |  |  |  |  |  |  |  |  |
ImageSurface              |  |  |  |  |  |  |  |  |
Matrix                    |  |  |  |  |  |  |  |  |
Path                      |  |  |  |  |  |  |  |  |
Pattern                   |  |  |  |  |  |  |  |  |
ScaledFont                |  |  |  |  |  |  |  |  |
Surface                   |  |  |  |  |  |  |  |  |
Types                     |  |  |  |  |  |  |  |  |

<br/>

<!--
| Gnome::Atk              |T |dm|db|ds|de|dp|ts|te|tp|12|14|so|
|-------------------------|--|--|--|--|--|--|--|--|--|--|--|  |
Object                    |  |  |  |  |  |  |  |  |  |  |  |  |
-->

<!--
| Gnome::Pango            |T |dm|db|ds|de|dp|ts|te|tp|12|14|so|
|-------------------------|--|--|--|--|--|--|--|--|--|--|--|  |
-->

| Gnome::N                |T |dm|db|ds|ts|12|14|so|
|-------------------------|--|--|--|--|--|--|--|--|
GlibToRakuTypes           |  | ✗| ✗| ✗| ✗| ✓|  |  |
N-GObject                 |N | ✗| ✗| ✗| ✗| ✓|  |  |
NativeLib                 |L | ✗| ✗| ✗| ✗| ✓|  |  |
TopLevelClassSupport      |S |  |  |  |  | ✓|  |  |
X                         |  |  |  |  |  | ✓|  |  |

<!--
| Gnome::T                |T |dm|db|ds|de|dp|ts|te|tp|12|14|so|
|-------------------------|--|--|--|--|--|--|--|--|--|--|--|--|
-->
