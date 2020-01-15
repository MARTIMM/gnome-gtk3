---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Class hierargy

Below there is a table of the object hierarchy taken from [the developers page](https://developer.gnome.org/gtk3/3.24/ch02.html) and is used here to show what is implemented and what is deprecated. Every Raku class is in the Gnome:: name space. Also prefixes and module path names are removed from the Raku modules. so GObject is implemented in **Gnome::GObject::Object** and Window is implemented in **Gnome::Gtk3::Window**. `├─✗` in front of a Gtk module means that it is deprecated or will not be implemented for other reasons.

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
│   │   │   │   │   │   ├─✗ GtkColorSelectionDialog
│   │   │   │   │   │   ├── GtkFileChooserDialog      FileChooserDialog
│   │   │   │   │   │   ├── GtkFontChooserDialog
│   │   │   │   │   │   ├─✗ GtkFontSelectionDialog
│   │   │   │   │   │   ├── GtkMessageDialog
│   │   │   │   │   │   ├── GtkPageSetupUnixDialog
│   │   │   │   │   │   ├── GtkPrintUnixDialog
│   │   │   │   │   │   ╰── GtkRecentChooserDialog
│   │   │   │   │   ├── GtkApplicationWindow
│   │   │   │   │   ├── GtkAssistant
│   │   │   │   │   ├── GtkOffscreenWindow
│   │   │   │   │   ├── GtkPlug
│   │   │   │   │   ╰── GtkShortcutsWindow
│   │   │   │   ├── GtkActionBar
│   │   │   │   ├─✗ GtkAlignment
│   │   │   │   ├── GtkComboBox                       ComboBox
│   │   │   │   │   ├── GtkAppChooserButton
│   │   │   │   │   ╰── GtkComboBoxText               ComboBoxText
│   │   │   │   ├── GtkFrame
│   │   │   │   │   ╰── GtkAspectFrame
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
│   │   │   │   │   ├─✗ GtkImageMenuItem
│   │   │   │   │   ├── GtkSeparatorMenuItem
│   │   │   │   │   ╰─✗ GtkTearoffMenuItem
│   │   │   │   ├── GtkEventBox
│   │   │   │   ├── GtkExpander
│   │   │   │   ├── GtkFlowBoxChild
│   │   │   │   ├── GtkHandleBox
│   │   │   │   ├── GtkListBoxRow                     ListBoxRow
│   │   │   │   ├── GtkToolItem
│   │   │   │   │   ├── GtkToolButton
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
│   │   │   │   ├── GtkStackSidebar
│   │   │   │   ╰── GtkViewport
│   │   │   ├── GtkBox                                Box
│   │   │   │   ├── GtkAppChooserWidget
│   │   │   │   ├── GtkButtonBox
│   │   │   │   │   ├─✗ GtkHButtonBox
│   │   │   │   │   ╰─✗ GtkVButtonBox
│   │   │   │   ├── GtkColorChooserWidget             ColorChooserWidget
│   │   │   │   ├─✗ GtkColorSelection
│   │   │   │   ├── GtkFileChooserButton
│   │   │   │   ├── GtkFileChooserWidget
│   │   │   │   ├── GtkFontChooserWidget
│   │   │   │   ├─✗ GtkFontSelection
│   │   │   │   ├─✗ GtkHBox
│   │   │   │   ├── GtkInfoBar
│   │   │   │   ├── GtkRecentChooserWidget
│   │   │   │   ├── GtkShortcutsSection
│   │   │   │   ├── GtkShortcutsGroup
│   │   │   │   ├── GtkShortcutsShortcut
│   │   │   │   ├── GtkStackSwitcher
│   │   │   │   ├── GtkStatusbar
│   │   │   │   ╰─✗ GtkVBox
│   │   │   ├── GtkFixed
│   │   │   ├── GtkFlowBox
│   │   │   ├── GtkGrid                               Grid
│   │   │   ├── GtkHeaderBar
│   │   │   ├── GtkPaned                              Paned
│   │   │   │   ├─✗ GtkHPaned                         
│   │   │   │   ╰─✗ GtkVPaned
│   │   │   ├── GtkIconView
│   │   │   ├── GtkLayout
│   │   │   ├── GtkListBox                            ListBox
│   │   │   ├── GtkMenuShell                          MenuShell
│   │   │   │   ├── GtkMenuBar                        MenuBar
│   │   │   │   ╰── GtkMenu                           Menu
│   │   │   │       ╰── GtkRecentChooserMenu
│   │   │   ├── GtkNotebook
│   │   │   ├── GtkSocket
│   │   │   ├── GtkStack
│   │   │   ├─✗ GtkTable
│   │   │   ├── GtkTextView                           TextView
│   │   │   ├── GtkToolbar
│   │   │   ├── GtkToolItemGroup
│   │   │   ├── GtkToolPalette
│   │   │   ╰── GtkTreeView                           TreeView
│   │   ├─✗ GtkMisc                                   Misc (Keep hierarchy)
│   │   │   ├── GtkLabel                              Label
│   │   │   │   ╰── GtkAccelLabel
│   │   │   ├─✗ GtkArrow
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
│   │   │   │   ├─✗ GtkHScale
│   │   │   │   ╰─✗ GtkVScale
│   │   │   ╰── GtkScrollbar
│   │   │       ├─✗ GtkHScrollbar
│   │   │       ╰─✗ GtkVScrollbar
│   │   ├── GtkSeparator
│   │   │   ├─✗ GtkHSeparator
│   │   │   ╰─✗ GtkVSeparator
│   │   ├─✗ GtkHSV
│   │   ├── GtkInvisible
│   │   ├── GtkProgressBar
│   │   ├── GtkSpinner
│   │   ├── GtkSwitch
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
├─✗ GtkAction
│   ├─✗ GtkToggleAction
│   │   ╰─✗ GtkRadioAction
│   ╰─✗ GtkRecentAction
├─✗ GtkActionGroup
├─✗ GApplication                                      Gnome::Gio not implemented
│   ╰─✗ GtkApplication                                Depends on Gio
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
│   ╰─✗ GtkNumerableIcon
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
├─✗ GtkStatusIcon
├─✗ GtkStyle
├── GtkStyleContext                                   StyleContext
├── GtkTextBuffer                                     TextBuffer
├── GtkTextChildAnchor
├── GtkTextMark
├── GtkTextTag                                        TextTag
├── GtkTextTagTable                                   TextTagTable
├─✗ GtkThemingEngine
├── GtkTreeModelFilter
├── GtkTreeModelSort
├── GtkTreeSelection
├── GtkTreeStore                                      TreeStore
├─✗ GtkUIManager
├── GtkWindowGroup
├── GtkTooltip
╰── GtkPrintBackend

GInterface                                            Modules are defined as Roles
├── GtkBuildable                                      Buildable
├── GtkActionable
├─✗ GtkActivatable
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
╰── GtkTargetList
```
