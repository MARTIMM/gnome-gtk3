---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

{% assign u1 = site.baseurl | append: "/content-docs/design/check-list.html" %}

## Class hierargy

Below there is a table of the object hierarchy taken from [the developers page](https://developer.gnome.org/gtk3/3.24/ch02.html) and is used here to show what is implemented and what is deprecated in Gtk. Module path names are removed from the Raku modules when in Gnome::Gtk3. E.g. Window is implemented as **Gnome::Gtk3::Window**. `├─✗` in front of a Gtk module means that it is deprecated or will not be implemented for other reasons. Modules that will change a lot, deprecated or that it can be removed altogether, are marked with ⛔. All modules under construction are not marked with an icon. For further progress info check [this page]({{u1}}). ⁇ Don't know if it will be implemented due to dependencies. Maybe very much later.

```
Tree of Gtk C structures                        Raku module
----------------------------------------------- --------------------------------
TopLevelClassSupport                            Gnome::N::TopLevelClassSupport
│
GObject                                         Gnome::GObject::Object
├── GInitiallyUnowned                           Gnome::GObject::InitiallyUnowned
│   ├── GtkWidget                               Widget
│   │   ├── GtkContainer                        Container
│   │   │   ├── GtkBin                          Bin
│   │   │   │   ├── GtkWindow                   Window
│   │   │   │   │   ├── GtkDialog                     Dialog
│   │   │   │   │   │   ├── GtkAboutDialog            AboutDialog
│   │   │   │   │   │   ├── GtkAppChooserDialog
│   │   │   │   │   │   ├── GtkColorChooserDialog     ColorChooserDialog
│   │   │   │   │   │   ├─✗ GtkColorSelectionDialog   ⛔
│   │   │   │   │   │   ├── GtkFileChooserDialog      FileChooserDialog
│   │   │   │   │   │   ├── GtkFontChooserDialog
│   │   │   │   │   │   ├─✗ GtkFontSelectionDialog    ⛔
│   │   │   │   │   │   ├── GtkMessageDialog          MessageDialog
│   │   │   │   │   │   ├── GtkPageSetupUnixDialog
│   │   │   │   │   │   ├── GtkPrintUnixDialog
│   │   │   │   │   │   ╰── GtkRecentChooserDialog    RecentChooserDialog
│   │   │   │   │   │
│   │   │   │   │   ├── GtkApplicationWindow    ApplicationWindow
│   │   │   │   │   ├── GtkAssistant            Assistant
│   │   │   │   │   ├── GtkOffscreenWindow      OffscreenWindow
│   │   │   │   │   ├── GtkPlug                 ⁇ Depends on X11, No Wayland/W10
│   │   │   │   │   ╰── GtkShortcutsWindow
│   │   │   │   ├── GtkActionBar
│   │   │   │   ├─✗ GtkAlignment                ⛔
│   │   │   │   ├── GtkComboBox                 ComboBox
│   │   │   │   │   ├── GtkAppChooserButton
│   │   │   │   │   ╰── GtkComboBoxText         ComboBoxText
│   │   │   │   ├── GtkFrame                    Frame
│   │   │   │   │   ╰── GtkAspectFrame          AspectFrame
│   │   │   │   ├── GtkButton                   Button
│   │   │   │   │   ├── GtkToggleButton         ToggleButton
│   │   │   │   │   │   ├── GtkCheckButton      CheckButton
│   │   │   │   │   │   │   ╰── GtkRadioButton  RadioButton
│   │   │   │   │   │   ╰── GtkMenuButton       MenuButton
│   │   │   │   │   ├── GtkColorButton          ColorButton
│   │   │   │   │   ├── GtkFontButton
│   │   │   │   │   ├── GtkLinkButton
│   │   │   │   │   ├── GtkLockButton
│   │   │   │   │   ├── GtkModelButton
│   │   │   │   │   ╰── GtkScaleButton
│   │   │   │   │       ╰── GtkVolumeButton
│   │   │   │   ├── GtkMenuItem                 MenuItem
│   │   │   │   │   ├── GtkCheckMenuItem        CheckMenuItem
│   │   │   │   │   │   ╰── GtkRadioMenuItem    RadioMenuItem
│   │   │   │   │   ├─✗ GtkImageMenuItem        ⛔
│   │   │   │   │   ├── GtkSeparatorMenuItem    SeparatorMenuItem
│   │   │   │   │   ╰─✗ GtkTearoffMenuItem      ⛔
│   │   │   │   ├── GtkEventBox                 EventBox
│   │   │   │   ├── GtkExpander
│   │   │   │   ├── GtkFlowBoxChild
│   │   │   │   ├── GtkHandleBox
│   │   │   │   ├── GtkListBoxRow               ListBoxRow
│   │   │   │   ├── GtkToolItem                     ToolItem
│   │   │   │   │   ├── GtkToolButton               ToolButton
│   │   │   │   │   │   ├── GtkMenuToolButton
│   │   │   │   │   │   ╰── GtkToggleToolButton
│   │   │   │   │   │       ╰── GtkRadioToolButton
│   │   │   │   │   ╰── GtkSeparatorToolItem
│   │   │   │   ├── GtkOverlay
│   │   │   │   ├── GtkScrolledWindow           ScrolledWindow
│   │   │   │   │   ╰── GtkPlacesSidebar        PlacesSidebar
│   │   │   │   ├── GtkPopover                  Popover
│   │   │   │   │   ╰── GtkPopoverMenu          PopoverMenu
│   │   │   │   ├── GtkRevealer                 Revealer
│   │   │   │   ├── GtkSearchBar
│   │   │   │   ├── GtkStackSidebar             StackSidebar
│   │   │   │   ╰── GtkViewport                 Viewport
│   │   │   ├── GtkBox                          Box
│   │   │   │   ├── GtkAppChooserWidget
│   │   │   │   ├── GtkButtonBox                ButtonBox
│   │   │   │   │   ├─✗ GtkHButtonBox           ⛔
│   │   │   │   │   ╰─✗ GtkVButtonBox           ⛔
│   │   │   │   ├── GtkColorChooserWidget       ColorChooserWidget
│   │   │   │   ├─✗ GtkColorSelection           ⛔
│   │   │   │   ├── GtkFileChooserButton        FileChooserButton
│   │   │   │   ├── GtkFileChooserWidget        FileChooserWidget
│   │   │   │   ├── GtkFontChooserWidget
│   │   │   │   ├─✗ GtkFontSelection            ⛔
│   │   │   │   ├─✗ GtkHBox                     ⛔
│   │   │   │   ├── GtkInfoBar
│   │   │   │   ├── GtkRecentChooserWidget      RecentChooserWidget
│   │   │   │   ├── GtkShortcutsSection
│   │   │   │   ├── GtkShortcutsGroup
│   │   │   │   ├── GtkShortcutsShortcut
│   │   │   │   ├── GtkStackSwitcher            StackSwitcher
│   │   │   │   ├── GtkStatusbar                Statusbar
│   │   │   │   ╰─✗ GtkVBox                     ⛔
│   │   │   ├── GtkFixed                        Fixed
│   │   │   ├── GtkFlowBox
│   │   │   ├── GtkGrid                         Grid
│   │   │   ├── GtkHeaderBar
│   │   │   ├── GtkPaned                        Paned
│   │   │   │   ├─✗ GtkHPaned                   ⛔
│   │   │   │   ╰─✗ GtkVPaned                   ⛔
│   │   │   ├── GtkIconView                     IconView
│   │   │   ├── GtkLayout                       Layout
│   │   │   ├── GtkListBox                      ListBox
│   │   │   ├── GtkMenuShell                    MenuShell
│   │   │   │   ├── GtkMenuBar                  MenuBar
│   │   │   │   ╰── GtkMenu                     Menu
│   │   │   │       ╰── GtkRecentChooserMenu    RecentChooserMenu
│   │   │   ├── GtkNotebook                     Notebook
│   │   │   ├── GtkSocket                       ⁇ Depends on X11, No Wayland/W10
│   │   │   ├── GtkStack                        Stack
│   │   │   ├─✗ GtkTable                        ⛔
│   │   │   ├── GtkTextView                     TextView
│   │   │   ├── GtkToolbar
│   │   │   ├── GtkToolItemGroup
│   │   │   ├── GtkToolPalette
│   │   │   ╰── GtkTreeView                     TreeView
│   │   ├─✗ GtkMisc                             ⛔, Created to keep hierarchy
│   │   │   ├── GtkLabel                        Label
│   │   │   │   ╰── GtkAccelLabel
│   │   │   ├─✗ GtkArrow                        ⛔
│   │   │   ╰── GtkImage                        Image
│   │   ├── GtkCalendar
│   │   ├── GtkCellView
│   │   ├── GtkDrawingArea                      DrawingArea
│   │   ├── GtkEntry                            Entry
│   │   │   ├── GtkSearchEntry                  SearchEntry
│   │   │   ╰── GtkSpinButton
│   │   ├── GtkGLArea                           ⁇ Usefull with OpenGL binding
│   │   ├── GtkRange                            Range
│   │   │   ├── GtkScale                        Scale
│   │   │   │   ├─✗ GtkHScale                   ⛔
│   │   │   │   ╰─✗ GtkVScale                   ⛔
│   │   │   ╰── GtkScrollbar
│   │   │       ├─✗ GtkHScrollbar               ⛔
│   │   │       ╰─✗ GtkVScrollbar               ⛔
│   │   ├── GtkSeparator                        Separator
│   │   │   ├─✗ GtkHSeparator                   ⛔
│   │   │   ╰─✗ GtkVSeparator                   ⛔
│   │   ├─✗ GtkHSV                              ⛔
│   │   ├─✗ GtkInvisible                        ⛔ Used internally for D&D
│   │   ├── GtkProgressBar                      ProgressBar
│   │   ├── GtkSpinner                          Spinner
│   │   ├── GtkSwitch                           Switch
│   │   ╰── GtkLevelBar                         LevelBar
│   ├── GtkAdjustment                           Adjustment
│   ├── GtkCellArea
│   │   ╰── GtkCellAreaBox
│   ├── GtkCellRenderer                         CellRenderer
│   │   ├── GtkCellRendererText                 CellRendererText
│   │   │   ├── GtkCellRendererAccel            CellRendererAccel
│   │   │   ├── GtkCellRendererCombo            CellRendererCombo
│   │   │   ╰── GtkCellRendererSpin             CellRendererSpin
│   │   ├── GtkCellRendererPixbuf               CellRendererPixbuf
│   │   ├── GtkCellRendererProgress             CellRendererProgress
│   │   ├── GtkCellRendererSpinner              CellRendererSpinner
│   │   ╰── GtkCellRendererToggle               CellRendererToggle
│   ├── GtkFileFilter                           FileFilter
│   ├── GtkTreeViewColumn                       TreeViewColumn
│   ╰── GtkRecentFilter                         RecentFilter
├── GtkAccelGroup
├── GtkAccelMap
├── AtkObject
│   ╰── GtkAccessible
├─✗ GtkAction                                   ⛔
│   ├─✗ GtkToggleAction                         ⛔
│   │   ╰─✗ GtkRadioAction                      ⛔
│   ╰─✗ GtkRecentAction                         ⛔
├─✗ GtkActionGroup                              ⛔
├── GApplication                                Gnome::Gio::Application
│   ╰── GtkApplication                          Application
├── GtkBuilder                                  Builder
├── GtkCellAreaContext
├── GtkClipboard
├── GtkCssProvider                              CssProvider
├── GtkEntryBuffer
├── GtkEntryCompletion
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
├─✗ GtkIconFactory                              ⛔
├── GtkIconTheme                                IconTheme
├── GtkIMContext
│   ├── GtkIMContextSimple
│   ╰── GtkIMMulticontext
├── GtkListStore                                ListStore
├── GMountOperation                                   
│   ╰── GtkMountOperation                             
├── GEmblemedIcon                                     
│   ╰─✗ GtkNumerableIcon                        ⛔
├── GtkPageSetup
├── GtkPrinter
├── GtkPrintContext
├── GtkPrintJob
├── GtkPrintOperation
├── GtkPrintSettings
├── GtkRcStyle
├── GtkRecentManager                            RecentManager
├                                               RecentInfo from GtkRecentManager
├── GtkSettings
├── GtkSizeGroup
├─✗ GtkStatusIcon                               ⛔
├─✗ GtkStyle                                    ⛔
├── GtkStyleContext                             StyleContext
├── GtkTextBuffer                               TextBuffer
├── GtkTextChildAnchor
├── GtkTextMark
├── GtkTextTag                                  TextTag
├── GtkTextTagTable                             TextTagTable
├─✗ GtkThemingEngine                            ⛔
├── GtkTreeModelFilter
├── GtkTreeModelSort
├── GtkTreeSelection                            ⛔TreeSelection
├── GtkTreeStore                                TreeStore
├─✗ GtkUIManager                                ⛔
├── GtkWindowGroup
├── GtkTooltip
╰── GtkPrintBackend

TopLevelInterfaceSupport              Gnome::N::TopLevelInterfaceSupport
│
GInterface                                            
├── GtkBuildable                      Buildable
├── GtkActionable                     Actionable
├─✗ GtkActivatable                    ⛔
├── GtkAppChooser
├── GtkCellLayout
├── GtkCellEditable
├── GtkOrientable                     Orientable
├── GtkColorChooser                   ColorChooser
├── GtkStyleProvider                  StyleProvider
├── GtkEditable
├── GtkFileChooser                    FileChooser
├── GtkFontChooser
├── GtkScrollable                     Scrollable
├── GtkTreeModel                      TreeModel
├── GtkTreeDragSource
├── GtkTreeDragDest
├── GtkTreeSortable
├── GtkPrintOperationPreview
├── GtkRecentChooser                  RecentChooser
╰── GtkToolShell

TopLevelClassSupport                  Gnome::N::TopLevelClassSupport
│
GBoxed                                Gnome::GObject::Boxed
├── GtkPaperSize
├── GtkTextIter                       TextIter
├── GtkSelectionData                  SelectionData
├── GtkRequisition
├── GtkBorder                         Border
├── GtkTreeIter                       TreeIter
├── GtkCssSection
├── GtkTreePath                       TreePath
├   GtkTreeRowReference               TreeRowReference, extr. from TreeModel
├─✗ GtkIconSet                        ⛔
├── GtkTargetList                     TargetList
╰── GtkWidgetPath                     WidgetPath

X                                     Some other gtk classes
├─ GtkSourceLanguage                
├─ GtkSourceLanguagesManager
├─ GtkSpell
│
├─                                    DragDest
├─                                    DragSource
├─                                    Targets
├─                                    TargetEntry
├─                                    TargetTable
│
├─                                    Main
├─                                    Enums
```
