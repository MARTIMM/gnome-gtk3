---
title: Benchmark Overview
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

```
GObject
├── GInitiallyUnowned
│   ├── GtkWidget
│   │   ├── GtkWindow
│   │   │   ├── GtkAboutDialog
│   │   │   ├── GtkDialog
│   │   │   │   ├── GtkAppChooserDialog
│   │   │   │   ├── GtkColorChooserDialog
│   │   │   │   ├── GtkFileChooserDialog
│   │   │   │   ├── GtkFontChooserDialog
│   │   │   │   ├── GtkMessageDialog
│   │   │   │   ├── GtkPageSetupUnixDialog
│   │   │   │   ╰── GtkPrintUnixDialog
│   │   │   ├── GtkApplicationWindow
│   │   │   ├── GtkAssistant
│   │   │   ╰── GtkShortcutsWindow
│   │   ├── GtkActionBar
│   │   ├── GtkAppChooserButton
│   │   ├── GtkAppChooserWidget
│   │   ├── GtkAspectFrame
│   │   ├── GtkBox
│   │   │   ├── GtkShortcutsSection
│   │   │   ╰── GtkShortcutsGroup
│   │   ├── GtkButton
│   │   │   ├── GtkLinkButton
│   │   │   ├── GtkLockButton
│   │   │   ╰── GtkToggleButton
│   │   ├── GtkCalendar
│   │   ├── GtkCellView
│   │   ├── GtkCenterBox
│   │   ├── GtkCheckButton
│   │   ├── GtkColorButton
│   │   ├── GtkColorChooserWidget
│   │   ├── GtkColumnView
│   │   ├── GtkComboBox
│   │   │   ╰── GtkComboBoxText
│   │   ├── GtkDragIcon
│   │   ├── GtkDrawingArea
│   │   ├── GtkDropDown
│   │   ├── GtkEditableLabel
│   │   ├── GtkPopover
│   │   │   ├── GtkEmojiChooser
│   │   │   ╰── GtkPopoverMenu
│   │   ├── GtkEntry
│   │   ├── GtkExpander
│   │   ├── GtkFileChooserWidget
│   │   ├── GtkFixed
│   │   ├── GtkFlowBox
│   │   ├── GtkFlowBoxChild
│   │   ├── GtkFontButton
│   │   ├── GtkFontChooserWidget
│   │   ├── GtkFrame
│   │   ├── GtkGLArea
│   │   ├── GtkGrid
│   │   ├── GtkListBase
│   │   │   ├── GtkGridView
│   │   │   ╰── GtkListView
│   │   ├── GtkHeaderBar
│   │   ├── GtkIconView
│   │   ├── GtkImage
│   │   ├── GtkInfoBar
│   │   ├── GtkLabel
│   │   ├── GtkListBox
│   │   ├── GtkListBoxRow
│   │   ├── GtkMediaControls
│   │   ├── GtkMenuButton
│   │   ├── GtkNotebook
│   │   ├── GtkOverlay
│   │   ├── GtkPaned
│   │   ├── GtkPasswordEntry
│   │   ├── GtkPicture
│   │   ├── GtkPopoverMenuBar
│   │   ├── GtkProgressBar
│   │   ├── GtkRange
│   │   │   ╰── GtkScale
│   │   ├── GtkRevealer
│   │   ├── GtkScaleButton
│   │   │   ╰── GtkVolumeButton
│   │   ├── GtkScrollbar
│   │   ├── GtkScrolledWindow
│   │   ├── GtkSearchBar
│   │   ├── GtkSearchEntry
│   │   ├── GtkSeparator
│   │   ├── GtkShortcutLabel
│   │   ├── GtkShortcutsShortcut
│   │   ├── GtkSpinButton
│   │   ├── GtkSpinner
│   │   ├── GtkStack
│   │   ├── GtkStackSidebar
│   │   ├── GtkStackSwitcher
│   │   ├── GtkStatusbar
│   │   ├── GtkSwitch
│   │   ├── GtkLevelBar
│   │   ├── GtkText
│   │   ├── GtkTextView
│   │   ├── GtkTreeExpander
│   │   ├── GtkTreeView
│   │   ├── GtkVideo
│   │   ├── GtkViewport
│   │   ├── GtkWindowControls
│   │   ╰── GtkWindowHandle
│   ├── GtkAdjustment
│   ├── GtkCellArea
│   │   ╰── GtkCellAreaBox
│   ├── GtkCellRenderer
│   │   ├── GtkCellRendererText
│   │   │   ├── GtkCellRendererAccel
│   │   │   ├── GtkCellRendererCombo
│   │   │   ╰── GtkCellRendererSpin
│   │   ├── GtkCellRendererPixbuf
│   │   ├── GtkCellRendererProgress
│   │   ├── GtkCellRendererSpinner
│   │   ╰── GtkCellRendererToggle
│   ╰── GtkTreeViewColumn
├── GtkFilter
│   ├── GtkMultiFilter
│   │   ├── GtkAnyFilter
│   │   ╰── GtkEveryFilter
│   ├── GtkBoolFilter
│   ├── GtkCustomFilter
│   ├── GtkFileFilter
│   ╰── GtkStringFilter
├── GApplication
│   ╰── GtkApplication
├── GtkAssistantPage
├── GtkATContext
├── GtkLayoutManager
│   ├── GtkBinLayout
│   ├── GtkBoxLayout
│   ├── GtkCenterLayout
│   ├── GtkConstraintLayout
│   ├── GtkCustomLayout
│   ├── GtkFixedLayout
│   ├── GtkGridLayout
│   ╰── GtkOverlayLayout
├── GtkBookmarkList
├── GtkBuilderCScope
├── GtkBuilder
├── GtkListItemFactory
│   ├── GtkBuilderListItemFactory
│   ╰── GtkSignalListItemFactory
├── GtkCellAreaContext
├── GtkColumnViewColumn
├── GtkConstraint
├── GtkConstraintGuide
├── GtkCssProvider
├── GtkSorter
│   ├── GtkCustomSorter
│   ├── GtkMultiSorter
│   ├── GtkNumericSorter
│   ├── GtkStringSorter
│   ╰── GtkTreeListRowSorter
├── GtkDirectoryList
├── GtkEventController
│   ├── GtkGesture
│   │   ├── GtkGestureSingle
│   │   │   ├── GtkDragSource
│   │   │   ├── GtkGestureClick
│   │   │   ├── GtkGestureDrag
│   │   │   │   ╰── GtkGesturePan
│   │   │   ├── GtkGestureLongPress
│   │   │   ├── GtkGestureStylus
│   │   │   ╰── GtkGestureSwipe
│   │   ├── GtkGestureRotate
│   │   ╰── GtkGestureZoom
│   ├── GtkDropControllerMotion
│   ├── GtkDropTargetAsync
│   ├── GtkDropTarget
│   ├── GtkEventControllerKey
│   ├── GtkEventControllerFocus
│   ├── GtkEventControllerLegacy
│   ├── GtkEventControllerMotion
│   ├── GtkEventControllerScroll
│   ├── GtkPadController
│   ╰── GtkShortcutController
├── GtkEntryBuffer
├── GtkEntryCompletion
├── GtkNativeDialog
│   ╰── GtkFileChooserNative
├── GtkFilterListModel
├── GtkFlattenListModel
├── GtkLayoutChild
│   ├── GtkGridLayoutChild
│   ├── GtkOverlayLayoutChild
│   ├── GtkConstraintLayoutChild
│   ╰── GtkFixedLayoutChild
├── GtkIconTheme
├── GtkIMContext
│   ├── GtkIMContextSimple
│   ╰── GtkIMMulticontext
├── GtkListItem
├── GtkListStore
├── GtkMapListModel
├── GtkMediaStream
│   ╰── GtkMediaFile
├── GMountOperation
│   ╰── GtkMountOperation
├── GtkMultiSelection
├── GtkNoSelection
├── GtkNotebookPage
├── GtkPageSetup
├── GtkPrinter
├── GtkPrintContext
├── GtkPrintJob
├── GtkPrintOperation
├── GtkPrintSettings
├── GtkRecentManager
├── GtkSelectionFilterModel
├── GtkSettings
├── GtkShortcut
├── GtkSingleSelection
├── GtkSizeGroup
├── GtkSliceListModel
├── GdkSnapshot
│   ╰── GtkSnapshot
├── GtkSortListModel
├── GtkStackPage
├── GtkStringList
├── GtkStringObject
├── GtkStyleContext
├── GtkTextBuffer
├── GtkTextChildAnchor
├── GtkTextMark
├── GtkTextTag
├── GtkTextTagTable
├── GtkTreeListModel
├── GtkTreeListRow
├── GtkTreeModelFilter
├── GtkTreeModelSort
├── GtkTreeSelection
├── GtkTreeStore
├── GtkWidgetPaintable
├── GtkWindowGroup
├── GtkTooltip
├── GtkShortcutAction
│   ├── GtkSignalAction
│   ├── GtkNothingAction
│   ├── GtkNamedAction
│   ╰── GtkCallbackAction
├── GtkShortcutTrigger
│   ├── GtkKeyvalTrigger
│   ├── GtkNeverTrigger
│   ╰── GtkAlternativeTrigger
╰── GtkPrintBackend
GInterface
├── GtkAccessible
├── GtkBuildable
├── GtkConstraintTarget
├── GtkNative
├── GtkShortcutManager
├── GtkRoot
├── GtkActionable
├── GtkAppChooser
├── GtkOrientable
├── GtkBuilderScope
├── GtkCellLayout
├── GtkCellEditable
├── GtkColorChooser
├── GtkScrollable
├── GtkStyleProvider
├── GtkEditable
├── GtkFileChooser
├── GtkFontChooser
├── GtkTreeModel
├── GtkTreeDragSource
├── GtkTreeDragDest
├── GtkTreeSortable
├── GtkSelectionModel
╰── GtkPrintOperationPreview
GBoxed
├── GtkBitset
├── GtkPaperSize
├── GtkTextIter
├── GtkTreeIter
├── GtkCssSection
╰── GtkTreePath
GtkExpression
```
Copyright © 2005‒2014 The GNOME Project
