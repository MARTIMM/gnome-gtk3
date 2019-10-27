Gnome::Gtk3::StyleProvider
==========================

Interface to provide style information to **Gnome::Gtk3::StyleContext**

Description
===========

**Gnome::Gtk3::StyleProvider** is an interface used to provide style information to a **Gnome::Gtk3::StyleContext**. See `gtk_style_context_add_provider()` and `gtk_style_context_add_provider_for_screen()`.

Known implementations
---------------------

Gnome::Gtk3::StyleProvider is implemented by Gnome::Gtk3::CssProvider and Gnome::Gtk3::Settings.

See Also
--------

**Gnome::Gtk3::StyleContext**, **Gnome::Gtk3::CssProvider**

Synopsis
========

Declaration
-----------

    unit role Gnome::Gtk3::StyleProvider;

commenthead2
============

Example

Types
=====

enum GtkStyleProviderPriority
-----------------------------

  * GTK_STYLE_PROVIDER_PRIORITY_FALLBACK(1): The priority used for default style information that is used in the absence of themes. Note that this is not very useful for providing default styling for custom style classes - themes are likely to override styling provided at this priority.

  * GTK_STYLE_PROVIDER_PRIORITY_THEME(200): The priority used for style information provided by themes.

  * GTK_STYLE_PROVIDER_PRIORITY_SETTINGS(400): The priority used for style information provided via Gnome::Gtk3::Settings. This priority is higher than GTK_STYLE_PROVIDER_PRIORITY_THEME to let settings override themes.

  * GTK_STYLE_PROVIDER_PRIORITY_APPLICATION(600): A priority that can be used when adding a #GtkStyleProvider for application-specific style information.

  * GTK_STYLE_PROVIDER_PRIORITY_USER(800): The priority used for the style information from `~/.gtk-3.0.css`. You should not use priorities higher than this, to give the user the last word.

