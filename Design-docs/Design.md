[toc]

# Command line
Recognized options by GTK
See https://www.systutorials.com/docs/linux/man/7-gtk-options/

# Web site start

```
bundle exec jekyll serve
```
## Web site config
```plantuml
scale 0.8
```

# Replace text in atom (with regex and case sensitive)
## Replace 'returns' for '-->'
search: `\)\s+returns\s+([A-Za-z0-9_\[\]-]+)`
replace `--> $1 )`

## Replace Since version messages
search: `\s*Since:\s+\d+\.\d+`
replace: ``

## Replace text bracketed function calls
search: `\[\[([\w\-\_\d]+)\]\]`
replace: `C<$1()>`

# Benchmarking result notes
* Always use normal arguments in the method which substitutes a native call search. Do not use slurpy arguments and flatten them in the call to the native sub.
* Call subs directly when there are no arguments or arguments that do not need some conversion like `Str` or `Int`. Also, the call is made on a subroutine of a leaf class. That means that casting is not necessary.
* Call sub via TopLevelSupportClass helper for casting using :sub-class('gtk-name').

# Installing on windows
## Testing on Appveyor
* Links
  * https://www.appveyor.com/docs/build-configuration/
  * https://www.gtk.org/docs/installations/windows
  * https://www.archlinux.org/pacman/pacman.8.html
* Using Visual studio 2019 image
  * has git.
  * has perl.
  * has MSYS2 installed in directory C:\msys64.
  * has curl.
* Search path with SafeDllSearchMode enabled (default)
  * The directory from which the application loaded.
  * The system directory. Use the GetSystemDirectory function to get the path of this directory.
  * The 16-bit system directory. There is no function that obtains the path of this directory, but it is searched.
  * The Windows directory. Use the GetWindowsDirectory function to get the path of this directory.
  * The current directory.
  * The directories that are listed in the PATH environment variable. Note that this does not include the per-application path specified by the App Paths registry key. The App Paths key is not used when computing the DLL search path.
* Install GTK
  * `bash -lc "pacman -S --noconfirm mingw-w64-x86_64-gtk3"`
  * `bash -lc "pacman -S --noconfirm mingw-w64-x86_64-toolchain base-devel"`
* Install Raku
  * `choco install rakudostar`


# Native sub search
```
  SomeModule.some-sub()
  Gnome::GObject::Object.FALLBACK()
    translate some-sub -> some_sub
    SomeModule._fallback
      try some-sub or Gxyz_somemodule_some_sub => sub address
      callsame() if no address until one is found
    Substitute native objects for Raku objects in argument list
    Cast first argument when sub is found in another class

    Gnome::N::X.test-call()
```

# Example code to make downloadable archives

* Tar `tar cvfz todo-viewer.tgz --exclude '.precomp' todo-viewer/`
* Zip `zip -r todo-viewer.zip todo-viewer --exclude '*.precomp*'`

# Codes used in source modules to mark what is tested or not

The codes will show what is tested or not in the source code. The developer can than see what is tested and what is not. The code always start with `#T` followed with a letter for each type or action;
  * `L` module load
  * `M` method
  * `S` signal
  * `P` for properties
  * `E` for enums
  * `T` for structures
Then a colon ':' with a hex digit to show if it is tested or not;
  * 0 not tested
  * 1 tested in test script for this module
  * 2 tested elsewhere in test scripts for this package
  * 4 used elsewhere in test scripts or used programs
It is binary, so combinations are possible. 2 and 4 is not easy to find out. Then another colon followed with the name of the module, method, signal or type. E.g. `#TL:1:Gnome::Gtk3::Widget` or `#TM:0:gtk_widget_get_path`. When 2 and 4 are set, or combinations thereof, another column might follow to show the source. There might be more than one. E.g. `TM:3:gtk_color_chooser_add_palette:ColorChooserWidget`. There can be another column with a file- or package name when it is known where it is tested or used.

Absence of codes means that a particular item is not tested.

# Proto use with multi sub
Need a proto because otherwise the signature.parms will
become Mu in Gnome::N::test-call()
```
proto gtk_builder_add_from_file ( N-GObject, Str, |) { * }
multi sub gtk_builder_add_from_file (
  N-GObject $builder, Str $filename, Any $error
  --> uint32
) { ... }

multi ...
```

# Interface using modules

The `_fallback()` method in a module, which also uses an interface, should also call a likewise method in that interface module. This method is named `_xyz_interface()` and does not need to call callsame() to scan for subs in the parent modules of the interface. An example from `_fallback()` in **Gnome::Gtk3::FileChooserDialog**;

```
unit class Gnome::Gtk3::FileChooserDialog;
also is Gnome::Gtk3::Dialog;                # parent class
also does Gnome::Gtk3::FileChooser;         # interface

...

method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;

  # search this module first
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_file_chooser_dialog_$native-sub"); } unless ?$s;

  # then in interfaces
  $s = self._file_chooser_interface($native-sub) unless ?$s;

  # stamp class mark on it
  self.set-class-name-of-sub('GtkFileChooserDialog') if $s;

  # then parent classes
  $s = callsame unless ?$s;

  # return result
  $s;
}
```
And the interface sub in e.g. Buildable;
```
method _buildable_interface ( Str $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &::("$native-sub"); };
  try { $s = &::("gtk_buildable_$native-sub"); } unless ?$s;

  $s
}
```
Interfaces can also define signals sometimes. Define this like so in the interfacing module;
```
method _file_chooser_add_signal_types ( Str $class-name ) {

  self.add-signal-types( $class-name, :w2<row-changed row-inserted>);
  callsame;
}
```
and call this from the interface using class like so;
```
submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<columns-changed cursor-changed select-all unselect-all toggle-cursor-row select-cursor-parent start-interactive-search>,
      :w1<select-cursor-row>,
      :w2<row-activated test-expand-row test-collapse-row row-expanded row-collapsed move-cursor>,
      :w3<expand-collapse-cursor-row>,
    );

    self._file_chooser_add_signal_types($?CLASS.^name);
  }

```
All this is a bit awkward and messy and is all because of using a role for an interface module instead of using classes. It is not possible to define the same method in several roles, like e.g. `_interface()` because they clash when the same role is imported multiple times in the tree. Classes would behave better and then callsame could be used too. The problem then would be (surely for Buildable) that an interface class is inherited by multiple classes which are in the same inheritance tree;


```plantuml
scale 0.7
title Dependency details for hierargy and interfaces, plan A

class TopLevelClassSupport < Catch all class >
class UserClass << (C, #00ffff) user class >>
interface Buildable < Interface >

Buildable <|-- Widget
Buildable <|-- Container
Buildable <|-- Bin
Buildable <|-- Button

TopLevelClassSupport <|-- Object
Object <|-- InitiallyUnowned
InitiallyUnowned <|-- Widget
Widget <|- Container
Container <|- Bin
Bin <|- Button
Button <|-- UserClass

```
## Review the use of interfaces and where they are being used

If you look in the diagram above, we see that **Buildable** is used in all classes below **InitiallyUnowned**. The methods are kind of inherited by the classes below it. Following this we should then use something like the diagram below. By the way, the latest developments are that a 'catch all' class is build and displayed below too.

```plantuml

scale 0.7
title Dependency details for hierargy and interfaces, plan B

class TopLevelClassSupport < Catch all class >
class TopLevelInterfaceSupport << (I, #efad00) catch all interface >>
interface Buildable < Interface >

TopLevelInterfaceSupport <|-- Buildable
Buildable <|-- Widget
class UserClass << (C, #00ffff) user class >>

TopLevelClassSupport <|-- Object
Object <|-- InitiallyUnowned
InitiallyUnowned <|-- Widget
Widget <|- Container
Container <|- Bin
Bin <|- Button
Button <|-- UserClass
```

This is a lot easier. To see if this is at all possible, a list must be made of classes who use an interface and if the below classes are using it too. In a way they did, e.g. if **Button** did not had the interface to **Buildable**, it would use the calls of the interface used by **Bin** or **Container** so effectively it is the same as in the second diagram.

Below is a tree of modules. The letters are explained at the bottom and are linked to the name of the interface module, e.g. b is for Buildable class.

```
Tree of Gtk C structures                              Interface use
----------------------------------------------------- ------------------------
GObject                                               
├── GInitiallyUnowned
│   ├── GtkWidget                                     b
│   │   ├── GtkContainer                              b
│   │   │   ├── GtkBin                                b
│   │   │   │   ├── GtkWindow                         b
│   │   │   │   │   ├── GtkDialog                     b
│   │   │   │   │   │   ├── GtkAboutDialog            b
│   │   │   │   │   │   ├── GtkAppChooserDialog       b,ap
│   │   │   │   │   │   ├── GtkColorChooserDialog     b,cc
│   │   │   │   │   │   ├─✗ GtkColorSelectionDialog   b
│   │   │   │   │   │   ├── GtkFileChooserDialog      b,fic
│   │   │   │   │   │   ├── GtkFontChooserDialog      b,foc
│   │   │   │   │   │   ├─✗ GtkFontSelectionDialog    b
│   │   │   │   │   │   ├── GtkMessageDialog          b
│   │   │   │   │   │   ├── GtkPageSetupUnixDialog    b
│   │   │   │   │   │   ├── GtkPrintUnixDialog        b
│   │   │   │   │   │   ╰── GtkRecentChooserDialog    b,rc
│   │   │   │   │   ├── GtkApplicationWindow          b
│   │   │   │   │   ├── GtkAssistant                  b
│   │   │   │   │   ├── GtkOffscreenWindow            b
│   │   │   │   │   ├── GtkPlug                       b
│   │   │   │   │   ╰── GtkShortcutsWindow            b
│   │   │   │   ├── GtkActionBar                      b
│   │   │   │   ├─✗ GtkAlignment                      b
│   │   │   │   ├── GtkComboBox                       b,cl,ce
│   │   │   │   │   ├── GtkAppChooserButton           b,ap,cl,ce
│   │   │   │   │   ╰── GtkComboBoxText               b,cl,ce
│   │   │   │   ├── GtkFrame                          b
│   │   │   │   │   ╰── GtkAspectFrame                b
│   │   │   │   ├── GtkButton                         b,ac
│   │   │   │   │   ├── GtkToggleButton               b,ac
│   │   │   │   │   │   ├── GtkCheckButton            b,ac
│   │   │   │   │   │   │   ╰── GtkRadioButton        b,ac
│   │   │   │   │   │   ╰── GtkMenuButton             b,ac
│   │   │   │   │   ├── GtkColorButton                b,ac,cc
│   │   │   │   │   ├── GtkFontButton                 b,ac,foc
│   │   │   │   │   ├── GtkLinkButton                 b,ac
│   │   │   │   │   ├── GtkLockButton                 b,ac
│   │   │   │   │   ├── GtkModelButton                b,ac
│   │   │   │   │   ╰── GtkScaleButton                b,o,ac
│   │   │   │   │       ╰── GtkVolumeButton           b,o,ac
│   │   │   │   ├── GtkMenuItem                       b,ac
│   │   │   │   │   ├── GtkCheckMenuItem              b,ac
│   │   │   │   │   │   ╰── GtkRadioMenuItem          b,ac
│   │   │   │   │   ├─✗ GtkImageMenuItem              b,ac
│   │   │   │   │   ├── GtkSeparatorMenuItem          b,ac
│   │   │   │   │   ╰─✗ GtkTearoffMenuItem            b,ac
│   │   │   │   ├── GtkEventBox                       b
│   │   │   │   ├── GtkExpander                       b
│   │   │   │   ├── GtkFlowBoxChild                   b
│   │   │   │   ├── GtkHandleBox                      b
│   │   │   │   ├── GtkListBoxRow                     b,ac
│   │   │   │   ├── GtkToolItem                       b
│   │   │   │   │   ├── GtkToolButton                 b,ac
│   │   │   │   │   │   ├── GtkMenuToolButton         b,ac
│   │   │   │   │   │   ╰── GtkToggleToolButton       b,ac
│   │   │   │   │   │       ╰── GtkRadioToolButton    b,ac
│   │   │   │   │   ╰── GtkSeparatorToolItem          b
│   │   │   │   ├── GtkOverlay                        b
│   │   │   │   ├── GtkScrolledWindow                 b
│   │   │   │   │   ╰── GtkPlacesSidebar              b
│   │   │   │   ├── GtkPopover                        b
│   │   │   │   │   ╰── GtkPopoverMenu                b
│   │   │   │   ├── GtkRevealer                       b
│   │   │   │   ├── GtkSearchBar                      b
│   │   │   │   ├── GtkStackSidebar                   b
│   │   │   │   ╰── GtkViewport                       b,s
│   │   │   ├── GtkBox                                b,o
│   │   │   │   ├── GtkAppChooserWidget               b,o,ap
│   │   │   │   ├── GtkButtonBox                      b,o
│   │   │   │   │   ├─✗ GtkHButtonBox                 b,o
│   │   │   │   │   ╰─✗ GtkVButtonBox                 b,o
│   │   │   │   ├── GtkColorChooserWidget             b,o,cc
│   │   │   │   ├─✗ GtkColorSelection                 b,o
│   │   │   │   ├── GtkFileChooserButton              b,o,fic
│   │   │   │   ├── GtkFileChooserWidget              b,o,fic
│   │   │   │   ├── GtkFontChooserWidget              b,o,foc
│   │   │   │   ├─✗ GtkFontSelection                  b,o
│   │   │   │   ├─✗ GtkHBox                           b,o
│   │   │   │   ├── GtkInfoBar                        b,o
│   │   │   │   ├── GtkRecentChooserWidget            b,o,rc
│   │   │   │   ├── GtkShortcutsSection               b,o
│   │   │   │   ├── GtkShortcutsGroup                 b,o
│   │   │   │   ├── GtkShortcutsShortcut              b,o
│   │   │   │   ├── GtkStackSwitcher                  b,o
│   │   │   │   ├── GtkStatusbar                      b,o
│   │   │   │   ╰─✗ GtkVBox                           b,o
│   │   │   ├── GtkFixed                              b
│   │   │   ├── GtkFlowBox                            b,o
│   │   │   ├── GtkGrid                               b,o
│   │   │   ├── GtkHeaderBar                          b
│   │   │   ├── GtkPaned                              b,o
│   │   │   │   ├─✗ GtkHPaned                         b,o
│   │   │   │   ╰─✗ GtkVPaned                         b,o
│   │   │   ├── GtkIconView                           b,cl,s
│   │   │   ├── GtkLayout                             b,s
│   │   │   ├── GtkListBox                            b
│   │   │   ├── GtkMenuShell                          b
│   │   │   │   ├── GtkMenuBar                        b
│   │   │   │   ╰── GtkMenu                           b
│   │   │   │       ╰── GtkRecentChooserMenu          b,rc
│   │   │   ├── GtkNotebook                           b
│   │   │   ├── GtkSocket                             b
│   │   │   ├── GtkStack                              b
│   │   │   ├─✗ GtkTable                              b
│   │   │   ├── GtkTextView                           b,s
│   │   │   ├── GtkToolbar                            b,o,tsh
│   │   │   ├── GtkToolItemGroup                      b,tsh
│   │   │   ├── GtkToolPalette                        b,o,s
│   │   │   ╰── GtkTreeView                           b,s
│   │   ├─✗ GtkMisc                                   b
│   │   │   ├── GtkLabel                              b
│   │   │   │   ╰── GtkAccelLabel                     b
│   │   │   ├─✗ GtkArrow                              b
│   │   │   ╰── GtkImage                              b
│   │   ├── GtkCalendar                               b
│   │   ├── GtkCellView                               b,o,cl
│   │   ├── GtkDrawingArea                            b
│   │   ├── GtkEntry                                  b,ce,e
│   │   │   ├── GtkSearchEntry                        b,ce,e
│   │   │   ╰── GtkSpinButton                         b,o,ce,e
│   │   ├── GtkGLArea                                 b
│   │   ├── GtkRange                                  b,o
│   │   │   ├── GtkScale                              b,o
│   │   │   │   ├─✗ GtkHScale                         b,o
│   │   │   │   ╰─✗ GtkVScale                         b,o
│   │   │   ╰── GtkScrollbar                          b,o
│   │   │       ├─✗ GtkHScrollbar                     b,o
│   │   │       ╰─✗ GtkVScrollbar                     b,o
│   │   ├── GtkSeparator                              b,o
│   │   │   ├─✗ GtkHSeparator                         b,o
│   │   │   ╰─✗ GtkVSeparator                         b,o
│   │   ├─✗ GtkHSV                                    b
│   │   ├─✗ GtkInvisible                              b
│   │   ├── GtkProgressBar                            b,o
│   │   ├── GtkSpinner                                b
│   │   ├── GtkSwitch                                 b,ac
│   │   ╰── GtkLevelBar                               b,o
│   ├── GtkAdjustment
│   ├── GtkCellArea                                   b,cl
│   │   ╰── GtkCellAreaBox                            b,o,cl
│   ├── GtkCellRenderer                               
│   │   ├── GtkCellRendererText                       
│   │   │   ├── GtkCellRendererAccel                  
│   │   │   ├── GtkCellRendererCombo                  
│   │   │   ╰── GtkCellRendererSpin                   
│   │   ├── GtkCellRendererPixbuf                     
│   │   ├── GtkCellRendererProgress                   o
│   │   ├── GtkCellRendererSpinner                    
│   │   ╰── GtkCellRendererToggle                     
│   ├── GtkFileFilter                                 b
│   ├── GtkTreeViewColumn                             b,cl
│   ╰── GtkRecentFilter                               b
├── GtkAccelGroup
├── GtkAccelMap
├── AtkObject
│   ╰── GtkAccessible
├─✗ GtkAction                                         b
│   ├─✗ GtkToggleAction                               b
│   │   ╰─✗ GtkRadioAction                            b
│   ╰─✗ GtkRecentAction                               b,rc
├─✗ GtkActionGroup                                    b
├── GApplication                                      
│   ╰── GtkApplication                                
├── GtkBuilder                                        
├── GtkCellAreaContext
├── GtkClipboard
├── GtkCssProvider                                    sp
├── GtkEntryBuffer                                    
├── GtkEntryCompletion                                b,cl
├── GtkEventController
│   ├── GtkEventControllerKey
│   ├── GtkEventControllerMotion
│   ├── GtkEventControllerScroll
│   ├── GtkGesture
│   │   ├── GtkGestureSingle
│   │   │   ├── GtkGestureDrag
│   │   │   │   ╰── GtkGesturePan
│   │   │   ├── GtkGestureLongPress
│   │   │   ├── GtkGestureMultiPress
│   │   │   ├── GtkGestureStylus
│   │   │   ╰── GtkGestureSwipe
│   │   ├── GtkGestureRotate
│   │   ╰── GtkGestureZoom
│   ╰── GtkPadController
├── GtkIconFactory                                    b
├── GtkIconTheme
├── GtkIMContext
│   ├── GtkIMContextSimple
│   ╰── GtkIMMulticontext
├── GtkListStore                                      b,tm,tds,tdd,ts
├── GMountOperation                                   
│   ╰── GtkMountOperation                             
├── GEmblemedIcon                                     
│   ╰─✗ GtkNumerableIcon                              
├── GtkPageSetup
├── GtkPrinter
├── GtkPrintContext
├── GtkPrintJob
├── GtkPrintOperation                                 pop
├── GtkPrintSettings
├── GtkRcStyle
├── GtkRecentManager
├── GtkSettings                                       sp
├── GtkSizeGroup                                      b
├─✗ GtkStatusIcon                                     
├─✗ GtkStyle                                          
├── GtkStyleContext                                   
├── GtkTextBuffer                                     
├── GtkTextChildAnchor
├── GtkTextMark
├── GtkTextTag                                        
├── GtkTextTagTable                                   b
├─✗ GtkThemingEngine                                  
├── GtkTreeModelFilter                                tm,tds
├── GtkTreeModelSort                                  tm,tds,ts
├── GtkTreeSelection
├── GtkTreeStore                                      b,tm,tds,tdd,ts
├─✗ GtkUIManager                                      b
├── GtkWindowGroup
├── GtkTooltip
╰── GtkPrintBackend

GInterface                                            
├── GtkBuildable                                      b
├── GtkActionable                                     ac
├─✗ GtkActivatable                                    
├── GtkAppChooser                                     ap
├── GtkCellLayout                                     cl
├── GtkCellEditable                                   ce
├── GtkOrientable                                     o
├── GtkColorChooser                                   cc
├── GtkStyleProvider                                  sp
├── GtkEditable                                       e
├── GtkFileChooser                                    fic
├── GtkFontChooser                                    foc
├── GtkScrollable                                     s
├── GtkTreeModel                                      tm
├── GtkTreeDragSource                                 tds
├── GtkTreeDragDest                                   tdd
├── GtkTreeSortable                                   ts
├── GtkPrintOperationPreview                          pop
├── GtkRecentChooser                                  rc
╰── GtkToolShell                                      tsh
```


After plotting the dependencies on **GtkBuildable**, it looks as if the class can be inherited by the highest class where it is needed, such as **Widget** and all child widgets will then have the methods available of that interface. After plotting all interface modules in above chart, the conclusion taken above is correct.
Also the interface module will have a role type.

## Structure of modules, plan B

```plantuml
'skinparam packageStyle rectangle
skinparam stereotypeCBackgroundColor #80ffff
'set namespaceSeparator ::

scale 0.8

class TopLevelClassSupport < Catch all class > {
  has Any $!n-native-object
  has Bool $.is-valid = False

  has Int $!class-gtype
  has Str $!class-name
  has Str $!class-name-of-sub

  my Bool $gui-initialized = False

  new()

  BUILD()

  FALLBACK()
  _fallback()

  get-native-object()
  set-native-object()

  {abstract} native-object-ref()
  {abstract} native-object-unref()
  clear-object()
  DESTROY()

  set-class-info()
  set-class-name-of-sub()
  get-class-name-of-sub()
  get-class-gtype()
}

note left of TopLevelClassSupport
  <b>$!n-native-object</b> is where the native object
  is stored. It is used by the toplevel class and its
  descendent classes. The type is always the same as
  set by all classes inheriting from the same toplevel
  class.

  <b>$.is-valid</b> is a readable variable and is checked
  to see if $!n-native-object is valid.

  <b>$!class-gtype</b>, <b>$!class-name</b> and
  <b>$!class-name-of-sub</b> are used to keep track
  of native class types and names.

  <b>$gui-initialized</b> is used to check on native
  initialization. It is defined that it is global to all
  of the TopLevelClassSupport classes.

  --

  Method <b>new()</b> is defined to cleanup the native object
  in case of an assignement like <b><i>$c .= new(...);</i></b>.
  The native object, if any, must be cleared first.

  <b>BUILD()</b> must check for <b>$gui-initialized</b>
  and also handle the <b>:native-object</b> option

  <b>FALLBACK</b> is called when a method is not available
  in the classes. It starts a search for a native sub with
  the method name in the tree using <b>_fallback()</b>. The
  search starts at the lowest child _fallback() working up
  to the top level class.

  The search will end with this <b>_fallback()</b>.

  <b>get-native-object()</b> and <b>set-native-object()</b>
  get and set the native object. They also handle
  referencing.

  {abstract} native-object-ref()
  {abstract} native-object-unref()
  clear-object()
  DESTROY()

  set-class-info()
  set-class-name-of-sub()
  get-class-name-of-sub()
  get-class-gtype()
end note


class SomeFooClassTop {
  BUILD()
  _fallback()
  native-object-ref()
  native-object-unref()
}

note left of SomeFooClassTop
  <b>BUILD()</b> handles this classes options
  to create a specialized native object. It
  uses <b>set-native-object()</b> to store it.

  <b>_fallback()</b> is passed through to search
  for native subs defined in this class. Use <b>callsame()</b>
  when no sub is found.

  <b>native-object-ref()</b> and <b>native-object-unref()</b>
  are implementations of the abstract methods of
  its parent.
end note

note left of SomeFooClass
  <b>BUILD()</b> and <b>set-native-object()</b> do the same
  as above.

  <b>_fallback()</b> does the same as in its parent and
  addition also tries to search for native subroutines in
  its interface parent class.
end note

class SomeFooClass {
  BUILD()
  _fallback()
}

class UserClass << (C, #00ffff) user class >> {
  new()
  BUILD()
}

note left of UserClass
  With the <b>new()</b> method, the user is able to inject
  options to control parent classes to create a native
  object on behalf of this user class. Later this
  classes <b>BUILD()</b> method can modify it.

  <b>BUILD()</b> is for processing the users object options
  and/or to modify the native object created by one of
  the parents
end note

'class TopLevelInterfaceSupport < Catch all interface > {
'  _interface()
'}

'note right of TopLevelInterfaceSupport
'  Not sure if this support class
'  is needed
'end note

interface SomeFooInterface < Interface > {
  _someFoo_interface()
}
Interface  SomeFooInterface<Interface>
class SomeFooInterface <<(R,#80ffff)>>

note top of SomeFooInterface
  There wil be no <b>new()</b>, <b>BUILD()</b>
  or any use of storage of native
  objects.

  <b>_interface()</b> has the same task
  as the <b>_fallback()</b> method in
  normal classes.
end note

'Connections of classes and interfaces

TopLevelClassSupport <|-- SomeFooClassTop
SomeFooClassTop <|-- SomeFooClass
SomeFooClass <|-- UserClass

'TopLevelInterfaceSupport <|-- SomeFooInterface
SomeFooClass .|> SomeFooInterface
```

## Definitions of interfaces and class inheritance

### Interfaces

**Interfaces** define a common contract. Such as an interface called IAnimal, where all animals share functions such as Eat(), Move(), Attack() etc. While all of them share the same functions, all or most of them have a different way (implementation) of achieving it. **Interfaces** are for **_can do_** or **_can be treated as_** type of relationships. In Raku this is called a role.

### Classes
**Abstract** ( as well as **concrete** ) classes are for **_is a_** kind of relationship. **Abstract or concrete classes** define a common implementation and optionally common contracts. For example a simple Calculator could qualify as an abstract class which implements all the basic logical and bitwise operators and then gets extended by ScientificCalculator, GraphicalCalculator and so on.

Look at these examples:

class Bird **_is an_** Animal **_can do_** Flight;
class Plane **_is a_** Vehicle **can do_** Flight, **_can be treated as_** AccountableAsset;
class Mosquito **_is an_** Animal **_can do_** Flight;
class Horse **_is an_** Animal;
class RaceHorse **_is a_** Horse **_can be treated as_** AccountableAsset;
class Pegasus **is a** Horse **_can do_** Flight;

Bird, Mosquito and Horse are Animals. They are related. They inherit common methods from Animal like eat(), metabolize() and reproduce(). Maybe they override these methods, adding a little extra to them, but they take advantage of the default behavior implemented in Animal like metabolizeGlucose().

Plane is not related to Bird, Mosquito or Horse.

Flight is implemented by dissimilar, unrelated classes, like Bird and Plane.

AccountableAsset is also implemented by dissimilar, unrelated classes, like Plane and RaceHorse.

Horse doesn't implement Flight.

As you can see classes (abstract or concrete) helps you build a hierarchies, letting you inhering code from the upper levels to the lower levels of the hierarchy. In theory the lower you are in the hierarchy, the more specialized your behavior is, but you don't have to worry about a lot of things that are already taken care of.

Interfaces, in the other hand, create no hierarchy, but they can help homogenize certain behaviors across hierarchies so you can abstract them from the hierarchy in certain contexts.

For example you can have a program sum the value of a group of AccountableAssets regardless of their being RaceHorses or Planes.


# Creation subroutines
A widget, e.g. Button is created using the BUILD Api of perl like so
```
my Gnome::Gtk3::Button $b .= new(:label('start'));
```
Under the hood it calls `gtk_button_new_with_label('start')`. These subs cannot be called directly if one wants to do that, because the subs are searched for and to do that the class must be instantiated.

```
my Gnome::Gtk3::Button $b .= new;
$b .= new(:widget($b.new-with-label('start'));
```
This is messy. so to do it directly, these subs should be exported and then can be used like; (note that a full name must be used now!)
```
my Gnome::Gtk3::Button $b .= new(:native-object(gtk_button_new_with_label('start')));
```
This is just an example how it could be done, however, implementations will provide the proper `.new()` with the proper options.


# Variable argument lists
This is work of Elizabeth (lizmat)

```
# mail example variable lists
# Vittore Scolari
sub pera-int-f(Str $format, *@args) {
    state $ptr = cglobal(Str, "printf", Pointer);
    my $signature = Signature.new(
        params => (
            Parameter.new(type => Str),
            |(@args.map: { Parameter.new(type => .WHAT) })
        ),

        returns => int32
    );

    my &f = nativecast($signature, $ptr);
    f($format, |@args)
}

pera-int-f("Pera + Mela = %d + %d %s\n", 25, 12, "cippas");
```


# Memory
Notes from https://developer.gnome.org/gtk3/stable/gtk-question-index.html

### How does memory management work in GTK+? Should I free data returned from functions?

See the documentation for GObject and GInitiallyUnowned. For GObject note specifically g_object_ref() and g_object_unref(). GInitiallyUnowned is a subclass of GObject so the same points apply, except that it has a "floating" state (explained in its documentation).

For strings returned from functions, they will be declared "const" if they should not be freed. Non-const strings should be freed with g_free(). Arrays follow the same rule. If you find an undocumented exception to the rules, please report a bug on GitLab.

### Why does my program leak memory, if I destroy a widget immediately after creating it ?


If GtkFoo isn't a toplevel window, then
```
foo = gtk_foo_new ();
gtk_widget_destroy (foo);
```

is a memory leak, because no one assumed the initial floating reference. If you are using a widget and you aren't immediately packing it into a container, then you probably want standard reference counting, not floating reference counting.

To get this, you must acquire a reference to the widget and drop the floating reference (“ref and sink” in GTK+ parlance) after creating it:

```
foo = gtk_foo_new ();         # floating reference
g_object_ref_sink (foo);      # acquire a reference and drop floating ref
```

When you want to get rid of the widget, you must call gtk_widget_destroy() to break any external connections to the widget before dropping your reference:

```
gtk_widget_destroy (foo);     # get rid of the widget
g_object_unref (foo);         # drop reference
```

When you immediately add a widget to a container, it takes care of assuming the initial floating reference and you don't have to worry about reference counting at all ... just call gtk_widget_destroy() to get rid of the widget.

**Notes**
* gtk_foo_new -> floating reference if from **InitiallyUnowned**

# Internationalize
### How do I internationalize a GTK+ program?

Most people use GNU gettext, already required in order to install GLib. On a UNIX or Linux system with gettext installed, type info gettext to read the documentation.

The short checklist on how to use gettext is: call bindtextdomain() so gettext can find the files containing your translations, call textdomain() to set the default translation domain, call bind_textdomain_codeset() to request that all translated strings are returned in UTF-8, then call gettext() to look up each string to be translated in the default domain.

gi18n.h provides the following shorthand macros for convenience. Conventionally, people define macros as follows for convenience:

```
#define  _(x)     gettext (x)
#define N_(x)     x
#define C_(ctx,x) pgettext (ctx, x)
```

You use N_() (N stands for no-op) to mark a string for translation in a location where a function call to gettext() is not allowed, such as in an array initializer. You eventually have to call gettext() on the string to actually fetch the translation. _() both marks the string for translation and actually translates it. The C_() macro (C stands for context) adds an additional context to the string that is marked for translation, which can help to disambiguate short strings that might need different translations in different parts of your program.

Code using these macros ends up looking like this:

```
#include <gi18n.h>

static const char *global_variable = N_("Translate this string");

static void
make_widgets (void)
{
   GtkWidget *label1;
   GtkWidget *label2;

   label1 = gtk_label_new (_("Another string to translate"));
   label2 = gtk_label_new (_(global_variable));
...
```

Libraries using gettext should use dgettext() instead of gettext(), which allows them to specify the translation domain each time they ask for a translation. Libraries should also avoid calling textdomain(), since they will be specifying the domain instead of using the default.

With the convention that the macro GETTEXT_PACKAGE is defined to hold your libraries translation domain, gi18n-lib.h can be included to provide the following convenience:

```
#define _(x) dgettext (GETTEXT_PACKAGE, x)
```

### How do I use non-ASCII characters in GTK+ programs ?

GTK+ uses Unicode (more exactly UTF-8) for all text. UTF-8 encodes each Unicode codepoint as a sequence of one to six bytes and has a number of nice properties which make it a good choice for working with Unicode text in C programs:

    ASCII characters are encoded by their familiar ASCII codepoints.

    ASCII characters never appear as part of any other character.

    The zero byte doesn't occur as part of a character, so that UTF-8 strings can be manipulated with the usual C library functions for handling zero-terminated strings.

More information about Unicode and UTF-8 can be found in the UTF-8 and Unicode FAQ for Unix/Linux. GLib provides functions for converting strings between UTF-8 and other encodings, see g_locale_to_utf8() and g_convert().

Text coming from external sources (e.g. files or user input), has to be converted to UTF-8 before being handed over to GTK+. The following example writes the content of a IS0-8859-1 encoded text file to stdout:

```
gchar *text, *utf8_text;
gsize length;
GError *error = NULL;

if (g_file_get_contents (filename, &text, &length, NULL))
  {
     utf8_text = g_convert (text, length, "UTF-8", "ISO-8859-1",
                            NULL, NULL, &error);
     if (error != NULL)
       {
         fprintf ("Couldn't convert file %s to UTF-8\n", filename);
         g_error_free (error);
       }
     else
       g_print (utf8_text);
  }
else
  fprintf (stderr, "Unable to read file %s\n", filename);
```

For string literals in the source code, there are several alternatives for handling non-ASCII content:

* **direct UTF-8**: If your editor and compiler are capable of handling UTF-8 encoded sources, it is very convenient to simply use UTF-8 for string literals, since it allows you to edit the strings in "wysiwyg". Note that choosing this option may reduce the portability of your code.

**escaped UTF-8**: Even if your toolchain can't handle UTF-8 directly, you can still encode string literals in UTF-8 by using octal or hexadecimal escapes like \212 or \xa8 to encode each byte. This is portable, but modifying the escaped strings is not very convenient. Be careful when mixing hexadecimal escapes with ordinary text; "\xa8abcd" is a string of length 1 !

**runtime conversion**: If the string literals can be represented in an encoding which your toolchain can handle (e.g. IS0-8859-1), you can write your source files in that encoding and use g_convert() to convert the strings to UTF-8 at runtime. Note that this has some runtime overhead, so you may want to move the conversion out of inner loops.

Here is an example showing the three approaches using the copyright sign © which has Unicode and ISO-8859-1 codepoint 169 and is represented in UTF-8 by the two bytes 194, 169, or "\302\251" as a string literal:

```
g_print ("direct UTF-8: ©");
g_print ("escaped UTF-8: \302\251");
text = g_convert ("runtime conversion: ©", -1, "ISO-8859-1", "UTF-8", NULL, NULL, NULL);
g_print(text);
g_free (text);
```

If you are using gettext() to localize your application, you need to call bind_textdomain_codeset() to ensure that translated strings are returned in UTF-8 encoding.

# Design graphs

## Details at the top
Most classes at the top depend on TopLevelClassSupport. A few classes are independent.
```plantuml
'scale 0.7
set namespaceSeparator ::

class Gnome::N::TopLevelClassSupport < Catch all class >
'interface Gnome::Gtk3::Buildable < Interface >

class Gnome::GObject::Type
class Gnome::Gtk3::Enums

Gnome::N::TopLevelClassSupport <|--- Gnome::Glib::Error

'Gnome::Gtk3::Buildable <|-- Gnome::Gtk3::Widget

Gnome::N::TopLevelClassSupport <|-- Gnome::GObject::Object
Gnome::N::TopLevelClassSupport <|-- Gnome::GObject::Boxed
Gnome::GObject::Object <|-- Gnome::GObject::InitiallyUnowned
Gnome::GObject::Boxed <|-- Gnome::GObject::Value
Gnome::GObject::Object *-left-> Gnome::GObject::Signal

Gnome::GObject::InitiallyUnowned <|-- Gnome::Gtk3::Widget
Gnome::GObject::InitiallyUnowned <|-- Gnome::Gtk3::Adjustment

'Gnome::N::TopLevelClassSupport <|-- Gnome::Gio::Application
Gnome::GObject::Object <|-- Gnome::Gio::Application
Gnome::Gio::Application <|-- Gnome::Gtk3::Application
```

## Dependency details between packages
```plantuml

scale 0.7
'title Dependency details between packages
allowmixing

!include <tupadr3/common>
!include <tupadr3/font-awesome/archive>
!include <tupadr3/font-awesome/cogs>


package Glib {
  FA_COGS(Glib) #e0e0ff
}
package GObject {
  FA_COGS(GObject) #e0e0ff
}
package Gio {
  FA_COGS(Gio) #e0e0ff
}
package Gtk {
  FA_COGS(Gtk) #e0e0ff
}
package Gdk {
  FA_COGS(Gdk) #e0e0ff
}
'package Pango {
'  FA_COGS(Pango) #e0e0ff
'}
'package Cairo {
'  FA_COGS(Cairo) #e0e0ff
'}


package Gnome::N {
  FA_COGS(RN)
}

package Gnome::Glib {
  FA_COGS(RGlib)
}
package Gnome::Gio {
  FA_COGS(RGio)
}
package Gnome::GObject {
  FA_COGS(RGObject)
}
package Gnome::Gdk3 {
  FA_COGS(RGdk3)
}
package Gnome::Gtk3 {
  FA_COGS(RGtk3)
}


Gnome::Gdk3 <.. Gnome::Gtk3
Gnome::Gio <.. Gnome::Gtk3
Gnome::GObject <... Gnome::Gtk3
Gnome::Glib <... Gnome::Gtk3
Gnome::N <... Gnome::Gtk3
Gtk <....... Gnome::Gtk3

Gnome::GObject <.... Gnome::Gdk3
Gnome::Glib <... Gnome::Gdk3
Gnome::N <... Gnome::Gdk3
Gdk <...... Gnome::Gdk3

Gnome::N <.. Gnome::Gio
Gnome::GObject <.. Gnome::Gio
Gnome::Glib <.. Gnome::Gio
Gio <.... Gnome::Gio

Gnome::N <.. Gnome::GObject
GObject <... Gnome::GObject

Gnome::N <.. Gnome::Glib
Glib <... Gnome::Glib

```
