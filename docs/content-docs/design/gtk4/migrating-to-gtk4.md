---
title: Benchmark Overview
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

Migrating from GTK 3.x to GTK 4

Preparation in GTK 3.x

    Do not use deprecated symbols
    Enable diagnostic warnings
    Do not use GTK-specific command line arguments
    Do not use widget style properties
    Review your window creation flags
    Stop using direct access to GdkEvent structs
    Stop using gdk_pointer_warp()
    Stop using non-RGBA visuals
    Stop using GtkBox padding, fill and expand child properties
    Stop using the state argument of GtkStyleContext getters
    Stop using gdk_pixbuf_get_from_window() and gdk_cairo_set_source_surface()
    Stop using GtkWidget event signals
    Set a proper application ID
    Stop using gtk_main() and related APIs
    Reduce the use of gtk_widget_destroy()
    Reduce the use of generic container APIs
    Review your use of icon resources

Changes that need to be done at the time of the switch

    Larger changes
    Stop using GdkScreen
    Stop using the root window
    Stop using GdkVisual
    Stop using GdkDeviceManager
    Adapt to GdkWindow API changes
    The “iconified” window state has been renamed to “minimized”
    Adapt to GdkEvent API changes
    Stop using grabs
    Adapt to coordinate API changes
    Adapt to GdkKeymap API changes
    Adapt to changes in keyboard modifier handling
    Replace GtkClipboard with GdkClipboard
    Stop using gtk_get_current_... APIs
    Convert your ui files
    Adapt to GtkBuilder API changes
    Adapt to event controller API changes
    Focus handling changes
    Use the new apis for keyboard shortcuts
    Stop using GtkEventBox
    Stop using GtkButtonBox
    Adapt to GtkBox API changes
    Adapt to GtkWindow API changes
    Adapt to GtkHeaderBar and GtkActionBar API changes
    Adapt to GtkStack, GtkAssistant and GtkNotebook API changes
    Adapt to button class hierarchy changes
    Adapt to GtkScrolledWindow API changes
    Adapt to GtkBin removal
    Adapt to GtkContainer removal
    Stop using GtkContainer::border-width
    Adapt to gtk_widget_destroy() removal
    Adapt to coordinate API changes
    Adapt to GtkStyleContext API changes
    Adapt to GtkCssProvider API changes
    Stop using GtkShadowType and GtkRelief properties
    Adapt to GtkWidget’s size request changes
    Adapt to GtkWidget’s size allocation changes
    Switch to GtkWidget’s children APIs
    Don’t use -gtk-gradient in your CSS
    Don’t use -gtk-icon-effect in your CSS
    Don’t use -gtk-icon-theme in your CSS
    Don’t use -gtk-outline-…-radius in your CSS
    Adapt to drawing model changes
    Stop using APIs to query GdkSurfaces
    Widgets are now visible by default
    Adapt to changes in animated hiding and showing of widgets
    Stop passing commandline arguments to gtk_init
    GdkPixbuf is deemphasized
    GtkWidget event signals are removed
    Invalidation handling has changed
    Stop using GtkWidget::draw
    Window content observation has changed
    Monitor handling has changed
    Adapt to monitor API changes
    Adapt to cursor API changes
    Adapt to icon size API changes
    Adapt to changes in the GtkAssistant API
    Adapt to changes in the API of GtkEntry, GtkSearchEntry and GtkSpinButton
    Adapt to changes in GtkOverlay API
    Use GtkFixed instead of GtkLayout
    Adapt to search entry changes
    Adapt to GtkScale changes
    Stop using gtk_window_activate_default()
    Stop using gtk_widget_grab_default()
    Stop setting ::has-default and ::has-focus in .ui files
    Stop using the GtkWidget::display-changed signal
    GtkPopover::modal has been renamed to autohide
    gtk_widget_get_surface has been removed
    gtk_widget_is_toplevel has been removed
    gtk_widget_get_toplevel has been removed
    GtkEntryBuffer ::deleted-text has changed
    GtkMenu, GtkMenuBar and GtkMenuItem are gone
    GtkToolbar has been removed
    GtkAspectFrame is no longer a frame
    Stop using custom tooltip windows
    Switch to the new Drag-and-Drop api
    Adapt to GtkIconTheme API changes
    Update to GtkFileChooser API changes
    Stop using blocking dialog functions
    Stop using GtkBuildable API
    Adapt to GtkAboutDialog API changes
    Adapt to GtkTreeView and GtkIconView tooltip context changes
    Stop using GtkFileChooserButton
    Adapt to changed GtkSettings properties

Changes to consider after the switch

    Consider porting to the new list widgets

GTK 4 is a major new version of GTK that breaks both API and ABI compared to GTK 3.x. Thankfully, most of the changes are not hard to adapt to and there are a number of steps that you can take to prepare your GTK 3.x application for the switch to GTK 4. After that, there’s a number of adjustments that you may have to do when you actually switch your application to build against GTK 4.
Preparation in GTK 3.x

The steps outlined in the following sections assume that your application is working with GTK 3.24, which is the final stable release of GTK 3.x. It includes all the necessary APIs and tools to help you port your application to GTK 4. If you are using an older version of GTK 3.x, you should first get your application to build and work with the latest minor release in the 3.24 series.
Do not use deprecated symbols

Over the years, a number of functions, and in some cases, entire widgets have been deprecated. These deprecations are clearly spelled out in the API reference, with hints about the recommended replacements. The API reference for GTK 3 also includes an index of all deprecated symbols.

To verify that your program does not use any deprecated symbols, you can use defines to remove deprecated symbols from the header files, as follows:

make CFLAGS+="-DGDK_DISABLE_DEPRECATED -DGTK_DISABLE_DEPRECATED"

Note that some parts of our API, such as enumeration values, are not well covered by the deprecation warnings. In most cases, using them will require you to also use deprecated functions, which will trigger warnings.
Enable diagnostic warnings

Deprecations of properties and signals cannot be caught at compile time, as both properties and signals are installed and used after types have been instantiated. In order to catch deprecations and changes in the run time components, you should use the G_ENABLE_DIAGNOSTIC environment variable when running your application, e.g.:

G_ENABLE_DIAGNOSTIC=1 ./your-app

Do not use GTK-specific command line arguments

GTK4 does not parse command line arguments any more. If you are using command line arguments like --gtk-debug you should use the GTK_DEBUG environment variable instead. If you are using --g-fatal-warnings for debugging purposes, you should use the G_DEBUG environment variable, as specified by the GLib documentation.
Do not use widget style properties

Style properties do not exist in GTK 4. You should stop using them in your custom CSS and in your code.
Review your window creation flags

GTK 4 removes the GDK_WA_CURSOR flag. Instead, just use gdk_window_set_cursor() to set a cursor on the window after creating it. GTK 4 also removes the GDK_WA_VISUAL flag, and always uses an RGBA visual for windows. To prepare your code for this, use gdk_window_set_visual (gdk_screen_get_rgba_visual()) after creating your window. GTK 4 also removes the GDK_WA_WMCLASS flag. If you need this X11-specific functionality, use XSetClassHint() directly.
Stop using direct access to GdkEvent structs

In GTK 4, event structs are opaque and immutable. Many fields already have accessors in GTK 3, and you should use those to reduce the amount of porting work you have to do at the time of the switch.
Stop using gdk_pointer_warp()

Warping the pointer is disorienting and unfriendly to users. GTK 4 does not support it. In special circumstances (such as when implementing remote connection UIs) it can be necessary to warp the pointer; in this case, use platform APIs such as XWarpPointer() directly.
Stop using non-RGBA visuals

GTK 4 always uses RGBA visuals for its windows; you should make sure that your code works with such visuals. At the same time, you should stop using GdkVisual APIs, since this object not longer exists in GTK 4. Most of its APIs are deprecated already and not useful when dealing with RGBA visuals.
Stop using GtkBox padding, fill and expand child properties

GTK 4 removes these GtkBox child properties, so you should stop using them. You can replace GtkBox:padding using the “margin” properties on your GtkBox child widgets.

The fill child property can be replaced by setting appropriate values for the “halign” and “valign” properties of the child widgets. If you previously set the fill child property to TRUE, you can achieve the same effect by setting the halign or valign properties to GTK_ALIGN_FILL, depending on the parent box – halign for a horizontal box, valign for a vertical one.

GtkBox also uses the expand child property. It can be replaced by setting “hexpand” or “vexpand” on the child widgets. To match the old behavior of the GtkBox’s expand child property, you need to set “hexpand” on the child widgets of a horizontal GtkBox and “vexpand” on the child widgets of a vertical GtkBox.

Note that there’s a subtle but important difference between GtkBox’s expand and fill child properties and the ones in GtkWidget: setting “hexpand” or “vexpand” to TRUE will propagate up the widget hierarchy, so a pixel-perfect port might require you to reset the expansion flags to FALSE in a parent widget higher up the hierarchy.
Stop using the state argument of GtkStyleContext getters

The getters in the GtkStyleContext API, such as gtk_style_context_get_property(), gtk_style_context_get(), or gtk_style_context_get_color() only accept the context’s current state for their state argument. You should update all callers to pass the current state.
Stop using gdk_pixbuf_get_from_window() and gdk_cairo_set_source_surface()

These functions are not supported in GTK 4. Instead, either use backend-specific APIs, or render your widgets using GtkWidgetClass.snapshot() (once you are using GTK 4).

Stop using GtkButton’s image-related API

The functions and properties related to automatically add a GtkImage to a GtkButton, and using a GtkSetting to control its visibility, are not supported in GTK 4. Instead, you can just pack a GtkImage inside a GtkButton, and control its visibility like you would for any other widget. If you only want to add a named icon to a GtkButton, you can use gtk_button_new_from_icon_name().
Stop using GtkWidget event signals

Event controllers and gestures replace event signals in GTK 4.

Most of them have been backported to GTK 3.x so you can prepare for this change.
Signal 	Event controller
::event 	GtkEventControllerLegacy
::event-after 	GtkEventControllerLegacy
::button-press-event 	GtkGestureClick
::button-release-event 	GtkGestureClick
::touch-event 	various touch gestures
::scroll-event 	GtkEventControllerScroll
::motion-notify-event 	GtkEventControllerMotion
::delete-event 	-
::key-press-event 	GtkEventControllerKey
::key-release-event 	GtkEventControllerKey
::enter-notify-event 	GtkEventControllerMotion
::leave-notify-event 	GtkEventControllerMotion
::configure-event 	-
::focus-in-event 	GtkEventControllerFocus
::focus-out-event 	GtkEventControllerFocus
::map-event 	-
::unmap-event 	-
::property-notify-event 	replaced by GdkClipboard
::selection-clear-event 	replaced by GdkClipboard
::selection-request-event 	replaced by GdkClipboard
::selection-notify-event 	replaced by GdkClipboard
Drag-and-Drop signals 	GtkDragSource, GtkDropTarget
::proximity-in-event 	GtkGestureStylus
::proximity-out-event 	GtkGestureStylus
::visibility-notify-event 	-
::window-state-event 	-
::damage-event 	-
::grab-broken-event 	-

Event signals which are not directly related to input have to be dealt with on a one-by-one basis. If you were using ::configure-event and ::window-state-event to save window state, you should use property notification for corresponding GtkWindow properties, such as “default-width”, “default-height”, “maximized” or “fullscreened”.
Set a proper application ID

In GTK 4 we want the application’s GApplication “application-id” (and therefore the D-Bus name), the desktop file basename and Wayland’s xdg-shell app_id to match. In order to achieve this with GTK 3.x call g_set_prgname() with the same application ID you passed to GtkApplication. Rename your desktop files to match the application ID if needed.

The call to g_set_prgname() can be removed once you fully migrated to GTK 4.

You should be aware that changing the application ID makes your application appear as a new, different app to application installers. You should consult the appstream documentation for best practices around renaming applications.
Stop using gtk_main() and related APIs

GTK 4 removes the gtk_main_ family of APIs. The recommended replacement is GtkApplication, but you can also iterate the GLib mainloop directly, using GMainContext APIs. The replacement for gtk_events_pending() is g_main_context_pending(), the replacement for gtk_main_iteration() is g_main_context_iteration().
Reduce the use of gtk_widget_destroy()

GTK 4 introduces a gtk_window_destroy() api. While that is not available in GTK 3, you can prepare for the switch by using gtk_widget_destroy() only on toplevel windows, and replace all other uses with gtk_container_remove() or g_object_unref().
Reduce the use of generic container APIs

GTK 4 removes gtk_container_add() and gtk_container_remove(). While there is not always a replacement for gtk_container_remove() in GTK 3, you can replace many uses of gtk_container_add() with equivalent container-specific APIs such as gtk_box_pack_start() or gtk_grid_attach(), and thereby reduce the amount of work you have to do at the time of the switch.
Review your use of icon resources

When using icons as resources, the behavior of GTK 4 is different in one respect: Icons that are directly in $APP_ID/icons/ are treated as unthemed icons, which also means that symbolic icons are not recolored. If you want your icon resources to have icon theme semantics, they need to be placed into theme subdirectories such as $APP_ID/icons/16x16/actions or $APP_ID/icons/scalable/status.

This location works fine in GTK 3 too, so you can prepare for this change before switching to GTK 4.





Changes to consider after the switch

GTK 4 has a number of new features that you may want to take advantage of once the dust has settled over the initial migration.
Consider porting to the new list widgets

In GTK 2 and 3, GtkTreeModel and GtkCellRenderer and widgets using these were the primary way of displaying data and lists. GTK 4 brings a new family of widgets for this purpose that uses list models instead of tree models, and widgets instead of cell renderers.

To learn more about the new list widgets, you can read the List Widget Overview.



Copyright © 2005‒2014 The GNOME Project
