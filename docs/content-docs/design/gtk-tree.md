---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Class hierargy

Below there is a table of the object hierarchy taken from [the developers page](https://developer.gnome.org/gtk3/3.24/ch02.html) and is used here to show what is implemented and what is deprecated in Gtk. Module path names are removed from the Raku modules when in Gnome::Gtk3. E.g. Window is implemented as **Gnome::Gtk3::Window**. `├─✗` in front of a Gtk module means that it is deprecated or will not be implemented for other reasons.

```
Tree of Gtk C structures                              Raku module
----------------------------------------------------- ------------------------
GObject                                               Gnome::GObject::Object
├── GInitiallyUnowned                                 Gnome::GObject::InitiallyUnowned
│   ├── GtkWidget                                     Widget
│   │   ├── GtkContainer                              Container
│   │   │   ├── GtkBin                                Bin
│   │   │   │   ├── GtkWindow                         Window
│   │   │   │   │   ├── GtkDialog                     Dialog
│   │   │   │   │   │   ├── GtkAboutDialog            AboutDialog
│   │   │   │   │   │   ├── GtkAppChooserDialog
│   │   │   │   │   │   ├── GtkColorChooserDialog     ColorChooserDialog
│   │   │   │   │   │   ├─✗ GtkColorSelectionDialog   Deprecated
│   │   │   │   │   │   ├── GtkFileChooserDialog      FileChooserDialog
│   │   │   │   │   │   ├── GtkFontChooserDialog
│   │   │   │   │   │   ├─✗ GtkFontSelectionDialog    Deprecated
│   │   │   │   │   │   ├── GtkMessageDialog          MessageDialog
│   │   │   │   │   │   ├── GtkPageSetupUnixDialog
│   │   │   │   │   │   ├── GtkPrintUnixDialog
│   │   │   │   │   │   ╰── GtkRecentChooserDialog
│   │   │   │   │   ├── GtkApplicationWindow          ApplicationWindow
│   │   │   │   │   ├── GtkAssistant                  Assistant
│   │   │   │   │   ├── GtkOffscreenWindow
│   │   │   │   │   ├── GtkPlug
│   │   │   │   │   ╰── GtkShortcutsWindow
│   │   │   │   ├── GtkActionBar
│   │   │   │   ├─✗ GtkAlignment                      Deprecated
│   │   │   │   ├── GtkComboBox                       ComboBox
│   │   │   │   │   ├── GtkAppChooserButton
│   │   │   │   │   ╰── GtkComboBoxText               ComboBoxText
│   │   │   │   ├── GtkFrame                          Frame
│   │   │   │   │   ╰── GtkAspectFrame                AspectFrame
│   │   │   │   ├── GtkButton                         Button
│   │   │   │   │   ├── GtkToggleButton               ToggleButton
│   │   │   │   │   │   ├── GtkCheckButton            CheckButton
│   │   │   │   │   │   │   ╰── GtkRadioButton        RadioButton
│   │   │   │   │   │   ╰── GtkMenuButton             MenuButton
│   │   │   │   │   ├── GtkColorButton                ColorButton
│   │   │   │   │   ├── GtkFontButton
│   │   │   │   │   ├── GtkLinkButton
│   │   │   │   │   ├── GtkLockButton
│   │   │   │   │   ├── GtkModelButton
│   │   │   │   │   ╰── GtkScaleButton
│   │   │   │   │       ╰── GtkVolumeButton
│   │   │   │   ├── GtkMenuItem                       MenuItem
│   │   │   │   │   ├── GtkCheckMenuItem
│   │   │   │   │   │   ╰── GtkRadioMenuItem
│   │   │   │   │   ├─✗ GtkImageMenuItem              Deprecated
│   │   │   │   │   ├── GtkSeparatorMenuItem
│   │   │   │   │   ╰─✗ GtkTearoffMenuItem            Deprecated
│   │   │   │   ├── GtkEventBox
│   │   │   │   ├── GtkExpander
│   │   │   │   ├── GtkFlowBoxChild
│   │   │   │   ├── GtkHandleBox
│   │   │   │   ├── GtkListBoxRow                     ListBoxRow
│   │   │   │   ├── GtkToolItem                       ToolItem
│   │   │   │   │   ├── GtkToolButton                 ToolButton
│   │   │   │   │   │   ├── GtkMenuToolButton
│   │   │   │   │   │   ╰── GtkToggleToolButton
│   │   │   │   │   │       ╰── GtkRadioToolButton
│   │   │   │   │   ╰── GtkSeparatorToolItem
│   │   │   │   ├── GtkOverlay
│   │   │   │   ├── GtkScrolledWindow
│   │   │   │   │   ╰── GtkPlacesSidebar
│   │   │   │   ├── GtkPopover
│   │   │   │   │   ╰── GtkPopoverMenu
│   │   │   │   ├── GtkRevealer
│   │   │   │   ├── GtkSearchBar
│   │   │   │   ├── GtkStackSidebar                   StackSidebar
│   │   │   │   ╰── GtkViewport
│   │   │   ├── GtkBox                                Box
│   │   │   │   ├── GtkAppChooserWidget
│   │   │   │   ├── GtkButtonBox
│   │   │   │   │   ├─✗ GtkHButtonBox                 Deprecated
│   │   │   │   │   ╰─✗ GtkVButtonBox                 Deprecated
│   │   │   │   ├── GtkColorChooserWidget             ColorChooserWidget
│   │   │   │   ├─✗ GtkColorSelection                 Deprecated
│   │   │   │   ├── GtkFileChooserButton
│   │   │   │   ├── GtkFileChooserWidget
│   │   │   │   ├── GtkFontChooserWidget
│   │   │   │   ├─✗ GtkFontSelection                  Deprecated
│   │   │   │   ├─✗ GtkHBox                           Deprecated
│   │   │   │   ├── GtkInfoBar
│   │   │   │   ├── GtkRecentChooserWidget
│   │   │   │   ├── GtkShortcutsSection
│   │   │   │   ├── GtkShortcutsGroup
│   │   │   │   ├── GtkShortcutsShortcut
│   │   │   │   ├── GtkStackSwitcher                  StackSwitcher
│   │   │   │   ├── GtkStatusbar
│   │   │   │   ╰─✗ GtkVBox                           Deprecated
│   │   │   ├── GtkFixed
│   │   │   ├── GtkFlowBox
│   │   │   ├── GtkGrid                               Grid
│   │   │   ├── GtkHeaderBar
│   │   │   ├── GtkPaned                              Paned
│   │   │   │   ├─✗ GtkHPaned                         Deprecated
│   │   │   │   ╰─✗ GtkVPaned                         Deprecated
│   │   │   ├── GtkIconView
│   │   │   ├── GtkLayout
│   │   │   ├── GtkListBox                            ListBox
│   │   │   ├── GtkMenuShell                          MenuShell
│   │   │   │   ├── GtkMenuBar                        MenuBar
│   │   │   │   ╰── GtkMenu                           Menu
│   │   │   │       ╰── GtkRecentChooserMenu
│   │   │   ├── GtkNotebook                           Notebook
│   │   │   ├── GtkSocket
│   │   │   ├── GtkStack                              Stack
│   │   │   ├─✗ GtkTable                              Deprecated
│   │   │   ├── GtkTextView                           TextView
│   │   │   ├── GtkToolbar
│   │   │   ├── GtkToolItemGroup
│   │   │   ├── GtkToolPalette
│   │   │   ╰── GtkTreeView                           TreeView
│   │   ├─✗ GtkMisc                                   Deprecated, Keep hierarchy
│   │   │   ├── GtkLabel                              Label
│   │   │   │   ╰── GtkAccelLabel
│   │   │   ├─✗ GtkArrow                              Deprecated
│   │   │   ╰── GtkImage                              Image
│   │   ├── GtkCalendar
│   │   ├── GtkCellView
│   │   ├── GtkDrawingArea
│   │   ├── GtkEntry                                  Entry
│   │   │   ├── GtkSearchEntry                        SearchEntry
│   │   │   ╰── GtkSpinButton
│   │   ├── GtkGLArea
│   │   ├── GtkRange                                  Range
│   │   │   ├── GtkScale                              Scale
│   │   │   │   ├─✗ GtkHScale                         Deprecated
│   │   │   │   ╰─✗ GtkVScale                         Deprecated
│   │   │   ╰── GtkScrollbar
│   │   │       ├─✗ GtkHScrollbar                     Deprecated
│   │   │       ╰─✗ GtkVScrollbar                     Deprecated
│   │   ├── GtkSeparator
│   │   │   ├─✗ GtkHSeparator                         Deprecated
│   │   │   ╰─✗ GtkVSeparator                         Deprecated
│   │   ├─✗ GtkHSV                                    Deprecated
│   │   ├─✗ GtkInvisible                              Used internally for D&D
│   │   ├── GtkProgressBar                            ProgressBar
│   │   ├── GtkSpinner                                Spinner
│   │   ├── GtkSwitch                                 Switch
│   │   ╰── GtkLevelBar                               LevelBar
│   ├── GtkAdjustment
│   ├── GtkCellArea
│   │   ╰── GtkCellAreaBox
│   ├── GtkCellRenderer                               CellRenderer
│   │   ├── GtkCellRendererText                       CellRendererText
│   │   │   ├── GtkCellRendererAccel                  CellRendererAccel
│   │   │   ├── GtkCellRendererCombo                  CellRendererCombo
│   │   │   ╰── GtkCellRendererSpin                   CellRendererSpin
│   │   ├── GtkCellRendererPixbuf                     CellRendererPixbuf
│   │   ├── GtkCellRendererProgress                   CellRendererProgress
│   │   ├── GtkCellRendererSpinner                    CellRendererSpinner
│   │   ╰── GtkCellRendererToggle                     CellRendererToggle
│   ├── GtkFileFilter                                 FileFilter
│   ├── GtkTreeViewColumn                             TreeViewColumn
│   ╰── GtkRecentFilter
├── GtkAccelGroup
├── GtkAccelMap
├── AtkObject
│   ╰── GtkAccessible
├─✗ GtkAction                                         Deprecated
│   ├─✗ GtkToggleAction                               Deprecated
│   │   ╰─✗ GtkRadioAction                            Deprecated
│   ╰─✗ GtkRecentAction                               Deprecated
├─✗ GtkActionGroup                                    Deprecated
├── GApplication                                      Gnome::Gio::Application
│   ╰── GtkApplication                                Application
├── GtkBuilder                                        Builder
├── GtkCellAreaContext
├── GtkClipboard
├── GtkCssProvider                                    CssProvider
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
├── GtkListStore                                      ListStore
├── GMountOperation                                   
│   ╰── GtkMountOperation                             
├── GEmblemedIcon                                     
│   ╰─✗ GtkNumerableIcon                              Deprecated
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
├─✗ GtkStatusIcon                                     Deprecated
├─✗ GtkStyle                                          Deprecated
├── GtkStyleContext                                   StyleContext
├── GtkTextBuffer                                     TextBuffer
├── GtkTextChildAnchor
├── GtkTextMark
├── GtkTextTag                                        TextTag
├── GtkTextTagTable                                   TextTagTable
├─✗ GtkThemingEngine                                  Deprecated
├── GtkTreeModelFilter
├── GtkTreeModelSort
├── GtkTreeSelection
├── GtkTreeStore                                      TreeStore
├─✗ GtkUIManager                                      Deprecated
├── GtkWindowGroup
├── GtkTooltip
╰── GtkPrintBackend

GInterface                                            Modules are defined as Roles
├── GtkBuildable                                      Buildable
├── GtkActionable
├─✗ GtkActivatable                                    Deprecated
├── GtkAppChooser
├── GtkCellLayout
├── GtkCellEditable
├── GtkOrientable                                     Orientable
├── GtkColorChooser                                   ColorChooser
├── GtkStyleProvider                                  StyleProvider
├── GtkEditable
├── GtkFileChooser                                    FileChooser
├── GtkFontChooser
├── GtkScrollable
├── GtkTreeModel                                      TreeModel
├── GtkTreeDragSource
├── GtkTreeDragDest
├── GtkTreeSortable
├── GtkPrintOperationPreview
├── GtkRecentChooser
╰── GtkToolShell

GBoxed                                                Gnome::GObject::Boxed
├── GtkPaperSize
├── GtkTextIter                                       TextIter
├── GtkSelectionData
├── GtkRequisition
├── GtkBorder                                         Border
├── GtkTreeIter                                       TreeIter
├── GtkCssSection                                     CssSection
├── GtkTreePath                                       TreePath
├   GtkTreeRowReference                               TreeRowReference
│                                                     Extracted from TreeModel
├── GtkIconSet
├── GtkTargetList
╰── GtkWidgetPath                                     WidgetPath
```
