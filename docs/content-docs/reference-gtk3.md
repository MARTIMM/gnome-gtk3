---
title: References to the Gtk3 package modules
nav_menu: references-nav
sidebar_menu: references-gtk3-sidebar
layout: sidebar
---
# Gnome::Gtk3 Reference

The modules are all generated from the GTK+ C source code and the documentation refers specifically to operations in C. Most of it is converted on the fly into perl6 types or perl6 native types. Sometimes, however, there is a mention of an operation like for instance, referencing or un-referencing objects. Those parts must be investigated still to see what the impact exactly is in perl6.

## Deprecated classes in GTK+ Version 3

The following modules will not be implemented in this Perl6 package because they are deprecated in the GTK libraries. There is no reason to have people use old stuff which is going to disappear in version 4.

* GtkSymbolicColor — Symbolic colors
* GtkGradient — Gradients
* Resource Files — Deprecated routines for handling resource files. In GTK+ 3.0, resource files have been deprecated and replaced by CSS-like style sheets, which are understood by GtkCssProvider.
* GtkStyle — Deprecated object that holds style information for widgets
* GtkHScale — A horizontal slider widget for selecting a value from a range
* GtkVScale — A vertical slider widget for selecting a value from a range
* GtkTearoffMenuItem — A menu item used to tear off and reattach its menu
* GtkColorSelection — Deprecated widget used to select a color
* GtkColorSelectionDialog — Deprecated dialog box for selecting a color
* GtkHSV — A “color wheel” widget
* GtkFontSelection — Deprecated widget for selecting fonts
* GtkFontSelectionDialog — Deprecated dialog box for selecting fonts
* GtkHBox — A horizontal container box
* GtkVBox — A vertical container box
* GtkHButtonBox — A container for arranging buttons horizontally
* GtkVButtonBox — A container for arranging buttons vertically
* GtkHPaned — A container with two panes arranged horizontally
* GtkVPaned — A container with two panes arranged vertically
* GtkTable — Pack widgets in regular patterns
* GtkHSeparator — A horizontal separator
* GtkVSeparator — A vertical separator
* GtkHScrollbar — A horizontal scrollbar
* GtkVScrollbar — A vertical scrollbar
* GtkUIManager — Constructing menus and toolbars from an XML description
* GtkActionGroup — A group of actions
* GtkAction — A deprecated action which can be triggered by a menu or toolbar item
* GtkToggleAction — An action which can be toggled between two states
* GtkRadioAction — An action of which only one in a group can be active
* GtkRecentAction — An action of which represents a list of recently used files
* GtkActivatable — An interface for activatable widgets
* GtkImageMenuItem — A deprecated widget for a menu item with an icon
* GtkMisc — Base class for widgets with alignments and padding
* Stock Items — Prebuilt common menu/toolbar items and corresponding icons
* Themeable Stock Images — Manipulating stock icons. Since GTK+ 3.10, stock items are deprecated. You should instead set up whatever labels and/or icons you need using normal widget API, rather than relying on GTK+ providing ready-made combinations of these.
* GtkNumerableIcon — A GIcon that allows numbered emblems
* GtkArrow — Displays an arrow
* GtkStatusIcon — Display an icon in the system tray
* GtkThemingEngine — Theming renderers
* GtkAlignment — A widget which controls the alignment and size of its child
