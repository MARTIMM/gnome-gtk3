---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Class hierargy

Below there is a table of the object hierarchy taken from [the developers page](https://developer.gnome.org/gtk3/3.24/ch02.html) and is used here to show what is implemented and what is deprecated in Gtk. Module path names are removed from the Raku modules when in Gnome::Gtk3. E.g. Window is implemented as **Gnome::Gtk3::Window**. `├─✗` in front of a Gtk module means that it is deprecated or will not be implemented for other reasons. Modules made inheritable are noted with ♥. Inheritance is a bit more complex than normal, info will be given in due time. Modules under construction are marked with ⛏. Modules that will change a lot, deprecated or that it can be removed altogether, are marked with ⛔. The symbol 🗸 means that the module is tested, unneeded subs are removed, documentation done etc. (that will show up almost nowhere :- ).

```
Tree of Gtk C structures                        Raku module
----------------------------------------------- --------------------------------
TopLevelClassSupport                            Gnome::N::TopLevelClassSupport
│
GObject                                         Gnome::GObject::Object
├── GInitiallyUnowned                           Gnome::GObject::InitiallyUnowned
│   ├── GtkWidget                                     Widget
│   │   ├── GtkContainer                              Container
│   │   │   ├── GtkBin                                Bin
│   │   │   │   ├── GtkWindow                         Window
│   │   │   │   │   ├── GtkDialog                     ♥ Dialog
│   │   │   │   │   │   ├── GtkAboutDialog            ♥ AboutDialog
│   │   │   │   │   │   ├── GtkAppChooserDialog
│   │   │   │   │   │   ├── GtkColorChooserDialog     ColorChooserDialog
│   │   │   │   │   │   ├─✗ GtkColorSelectionDialog   ⛔
│   │   │   │   │   │   ├── GtkFileChooserDialog      FileChooserDialog
│   │   │   │   │   │   ├── GtkFontChooserDialog
│   │   │   │   │   │   ├─✗ GtkFontSelectionDialog    ⛔
│   │   │   │   │   │   ├── GtkMessageDialog          ♥ MessageDialog
│   │   │   │   │   │   ├── GtkPageSetupUnixDialog
│   │   │   │   │   │   ├── GtkPrintUnixDialog
│   │   │   │   │   │   ╰── GtkRecentChooserDialog
│   │   │   │   │   ├── GtkApplicationWindow          ♥ ApplicationWindow
│   │   │   │   │   ├── GtkAssistant                  Assistant
│   │   │   │   │   ├── GtkOffscreenWindow
│   │   │   │   │   ├── GtkPlug
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
│   │   │   │   │   ├── GtkCheckMenuItem
│   │   │   │   │   │   ╰── GtkRadioMenuItem
│   │   │   │   │   ├─✗ GtkImageMenuItem        ⛔
│   │   │   │   │   ├── GtkSeparatorMenuItem
│   │   │   │   │   ╰─✗ GtkTearoffMenuItem      ⛔
│   │   │   │   ├── GtkEventBox
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
│   │   │   │   ├── GtkRevealer
│   │   │   │   ├── GtkSearchBar
│   │   │   │   ├── GtkStackSidebar             StackSidebar
│   │   │   │   ╰── GtkViewport
│   │   │   ├── GtkBox                          Box
│   │   │   │   ├── GtkAppChooserWidget
│   │   │   │   ├── GtkButtonBox
│   │   │   │   │   ├─✗ GtkHButtonBox           ⛔
│   │   │   │   │   ╰─✗ GtkVButtonBox           ⛔
│   │   │   │   ├── GtkColorChooserWidget       ColorChooserWidget
│   │   │   │   ├─✗ GtkColorSelection           ⛔
│   │   │   │   ├── GtkFileChooserButton
│   │   │   │   ├── GtkFileChooserWidget
│   │   │   │   ├── GtkFontChooserWidget
│   │   │   │   ├─✗ GtkFontSelection            ⛔
│   │   │   │   ├─✗ GtkHBox                     ⛔
│   │   │   │   ├── GtkInfoBar
│   │   │   │   ├── GtkRecentChooserWidget
│   │   │   │   ├── GtkShortcutsSection
│   │   │   │   ├── GtkShortcutsGroup
│   │   │   │   ├── GtkShortcutsShortcut
│   │   │   │   ├── GtkStackSwitcher            StackSwitcher
│   │   │   │   ├── GtkStatusbar
│   │   │   │   ╰─✗ GtkVBox                     ⛔
│   │   │   ├── GtkFixed
│   │   │   ├── GtkFlowBox
│   │   │   ├── GtkGrid                         ♥ Grid
│   │   │   ├── GtkHeaderBar
│   │   │   ├── GtkPaned                        Paned
│   │   │   │   ├─✗ GtkHPaned                   ⛔
│   │   │   │   ╰─✗ GtkVPaned                   ⛔
│   │   │   ├── GtkIconView
│   │   │   ├── GtkLayout
│   │   │   ├── GtkListBox                      ListBox
│   │   │   ├── GtkMenuShell                    MenuShell
│   │   │   │   ├── GtkMenuBar                  MenuBar
│   │   │   │   ╰── GtkMenu                     Menu
│   │   │   │       ╰── GtkRecentChooserMenu    ♥ RecentChooserMenu
│   │   │   ├── GtkNotebook                     ♥ Notebook
│   │   │   ├── GtkSocket
│   │   │   ├── GtkStack                        Stack
│   │   │   ├─✗ GtkTable                        ⛔
│   │   │   ├── GtkTextView                     TextView
│   │   │   ├── GtkToolbar
│   │   │   ├── GtkToolItemGroup
│   │   │   ├── GtkToolPalette
│   │   │   ╰── GtkTreeView                     ♥ TreeView
│   │   ├─✗ GtkMisc                             ⛔, Created to keep hierarchy
│   │   │   ├── GtkLabel                        Label
│   │   │   │   ╰── GtkAccelLabel
│   │   │   ├─✗ GtkArrow                        ⛔
│   │   │   ╰── GtkImage                        Image
│   │   ├── GtkCalendar
│   │   ├── GtkCellView
│   │   ├── GtkDrawingArea
│   │   ├── GtkEntry                            Entry
│   │   │   ├── GtkSearchEntry                  SearchEntry
│   │   │   ╰── GtkSpinButton
│   │   ├── GtkGLArea
│   │   ├── GtkRange                            Range
│   │   │   ├── GtkScale                        Scale
│   │   │   │   ├─✗ GtkHScale                   ⛔
│   │   │   │   ╰─✗ GtkVScale                   ⛔
│   │   │   ╰── GtkScrollbar
│   │   │       ├─✗ GtkHScrollbar               ⛔
│   │   │       ╰─✗ GtkVScrollbar               ⛔
│   │   ├── GtkSeparator                        🗸 Separator
│   │   │   ├─✗ GtkHSeparator                   ⛔
│   │   │   ╰─✗ GtkVSeparator                   ⛔
│   │   ├─✗ GtkHSV                              ⛔
│   │   ├─✗ GtkInvisible                        Used internally for D&D
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
│   ╰── GtkRecentFilter
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
│   ╰── GtkApplication                          ♥ Application
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
├── GtkIconFactory
├── GtkIconTheme
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
├── GtkRecentManager
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
├── GtkTreeStore                                ♥ TreeStore
├─✗ GtkUIManager                                ⛔
├── GtkWindowGroup
├── GtkTooltip
╰── GtkPrintBackend

TopLevelInterfaceSupport               Gnome::N::TopLevelInterfaceSupport
│
GInterface                                            
├── GtkBuildable                       Buildable
├── GtkActionable
├─✗ GtkActivatable                     ⛔
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

TopLevelClassSupport                   Gnome::N::TopLevelClassSupport
│
GBoxed                                 Gnome::GObject::Boxed
├── GtkPaperSize
├── GtkTextIter                        TextIter
├── GtkSelectionData
├── GtkRequisition
├── GtkBorder                          Border
├── GtkTreeIter                        TreeIter
├── GtkCssSection
├── GtkTreePath                        TreePath
├   GtkTreeRowReference                TreeRowReference, extr. from TreeModel
├── GtkIconSet
├── GtkTargetList
╰── GtkWidgetPath                      WidgetPath
```
