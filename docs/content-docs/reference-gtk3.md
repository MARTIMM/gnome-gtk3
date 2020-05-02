---
title: References to the Gtk3 package modules
nav_menu: references-nav
sidebar_menu: references-gtk3-sidebar
layout: sidebar
---
# Gnome::Gtk3 Reference

The modules are all generated from the GTK+ C source code and the documentation refers specifically to operations in C. Most of it is converted on the fly into Raku types or Raku native types. Sometimes, however, there is a mention of an operation like for instance, referencing or un-referencing objects. Those parts must be investigated still to see what the impact exactly is in Raku.

Each entry in the sidebar shows the name of a module with two icons, one icon to show the state of documentation and one for the state of testing. When hoovering over the icons a tool tip appears with a message about its state.

## Color coding of the entries in the sidebar
* <strong style="color:#005f00;">object classes</strong>
* <strong style="color:#9000af;">interface classes</strong>
* <strong style="color:#d5000d;">widget classes</strong>
* <strong style="color:#00a0a0;">boxed classes</strong>
* <strong style="color:#006f6f;">standalone classes</strong>

<!--
The documentation icons are
* 📔 There is no documentation. Older modules were made by hand and did not have documentation. Now, with the help of a Raku program C-source files are skimmed to get the subroutines and types along with their documentation. The entry will not be active.
* 🕮 Documentation generated. Documentation is only generated. Needs a rewrite to change c-code examples etc. Also subroutines are commented out when there are unsupported (for now) dependencies or that subroutines do not have any use in the Raku environment.
* 📖 Documentation rewritten. This means that the documentation is reread and changed to show a more Raku attitude.
* 🗸 Documentation has examples. There are examples in the documentation added.

The test icons are
* 🗒 No tests for this module.
* 🗇 Module parses ok (module load). This means that the `use module-name;` statement as well as the `.new()` call, succeeds.
* 🗊 Module subs and methods are tested.
* 🗲 Signals are tested when available, otherwise it is skipped.
* ⌺ Styling is tested when available, otherwise it is skipped.
* 🗸 All that is available is tested.
-->

## Deprecated classes in GTK+ Version 3

The following modules will not be implemented in this Raku package because they are deprecated in the GTK libraries. There is no reason to have people use old stuff which is going to disappear in version 4.

* GtkSymbolicColor — Symbolic colors
* GtkGradient — Gradients
* Resource Files mentioned [here](https://developer.gnome.org/gtk3/stable/gtk3-Resource-Files.html) — Deprecated routines for handling resource files. In GTK+ 3.0, resource files have been deprecated and replaced by CSS-like style sheets, which are understood by **Gnome::Gtk3::GtkCssProvider**. However, there are methods like `gtk_builder_add_from_resource()` in **Gnome::Gtk3::Builder** which load files from directories from the so called resources path. This is an entirely different matter. Definitions and modules are found in **Gnome::Gio::Resource**.
* GtkStyle — Deprecated object that holds style information for widgets
* GtkHScale — A horizontal slider widget for selecting a value from a range
* GtkVScale — A vertical slider widget for selecting a value from a range
* GtkTearoffMenuItem — A menu item used to tear off and re-attach its menu
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
