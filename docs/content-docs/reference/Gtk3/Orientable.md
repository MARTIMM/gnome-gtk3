Gnome::Gtk3::Orientable
=======================

An interface for flippable widgets

Description
===========

The **Gnome::Gtk3::Orientable** interface is implemented by all widgets that can be oriented horizontally or vertically. Historically, such widgets have been realized as subclasses of a common base class (e.g **Gnome::Gtk3::Box**/**Gnome::Gtk3::HBox**/**Gnome::Gtk3::VBox** or **Gnome::Gtk3::Scale**/**Gnome::Gtk3::HScale**/**Gnome::Gtk3::VScale**). **Gnome::Gtk3::Orientable** is more flexible in that it allows the orientation to be changed at runtime, allowing the widgets to “flip”.

**Gnome::Gtk3::Orientable** was introduced in GTK+ 2.16.

Known implementations
---------------------

Gnome::Gtk3::Orientable is implemented by Gnome::Gtk3::AppChooserWidget, Gnome::Gtk3::Box, Gnome::Gtk3::ButtonBox, Gnome::Gtk3::CellAreaBox, Gnome::Gtk3::CellRendererProgress, Gnome::Gtk3::CellView, Gnome::Gtk3::ColorChooserWidget, Gnome::Gtk3::ColorSelection, Gnome::Gtk3::FileChooserButton, Gnome::Gtk3::FileChooserWidget, Gnome::Gtk3::FlowBox, Gnome::Gtk3::FontChooserWidget, Gnome::Gtk3::FontSelection, Gnome::Gtk3::Grid, Gnome::Gtk3::InfoBar, Gnome::Gtk3::LevelBar, Gnome::Gtk3::Paned, Gnome::Gtk3::ProgressBar, Gnome::Gtk3::Range, Gnome::Gtk3::RecentChooserWidget, Gnome::Gtk3::Scale, Gnome::Gtk3::ScaleButton, Gnome::Gtk3::Scrollbar, Gnome::Gtk3::Separator, Gnome::Gtk3::ShortcutsGroup, Gnome::Gtk3::ShortcutsSection, Gnome::Gtk3::ShortcutsShortcut, Gnome::Gtk3::SpinButton, Gnome::Gtk3::StackSwitcher, Gnome::Gtk3::Statusbar, Gnome::Gtk3::ToolPalette, Gnome::Gtk3::Toolbar and Gnome::Gtk3::VolumeButton.

Synopsis
========

Declaration
-----------

    unit role Gnome::Gtk3::Orientable;

Example
-------

    my Gnome::Gtk3::LevelBar $level-bar .= new(:empty);
    $level-bar.set-orientation(GTK_ORIENTATION_VERTICAL);

Methods
=======

[gtk_orientable_] set_orientation
---------------------------------

    method gtk_orientable_get_orientation ( GtkOrientation )

Sets the orientation of the orientable. This is a GtkOrientation enum type defined in GtkEnums.

[gtk_orientable_] get_orientation
---------------------------------

    method gtk_orientable_get_orientation ( --> GtkOrientation $orientation )

Retrieves the orientation of the *orientable*.

