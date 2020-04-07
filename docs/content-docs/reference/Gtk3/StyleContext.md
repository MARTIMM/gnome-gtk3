Gnome::Gtk3::StyleContext
=========================

Rendering UI elements

Description
===========

**Gnome::Gtk3::StyleContext** is an object that stores styling information affecting a widget.

In order to construct the final style information, **Gnome::Gtk3::StyleContext** queries information from all attached **Gnome::Gtk3::StyleProviders**. Style providers can be either attached explicitly to the context through `gtk_style_context_add_provider()`, or to the screen through `gtk_style_context_add_provider_for_screen()`. The resulting style is a combination of all providers’ information in priority order.

For GTK+ widgets, any **Gnome::Gtk3::StyleContext** returned by `gtk_widget_get_style_context()` will already have a **Gnome::Gtk3::WidgetPath**, a **Gnome::Gdk3::Screen** and RTL/LTR information set. The style context will also be updated automatically if any of these settings change on the widget.

If you are using the theming layer standalone, you will need to set a widget path and a screen yourself to the created style context through `gtk_style_context_set_path()` and `gtk_style_context_set_screen()`, as well as updating the context yourself using `gtk_style_context_invalidate()` whenever any of the conditions change, such as a change in the prop `gtk-theme-name` setting or a hierarchy change in the rendered widget. See the “Foreign drawing“ example in gtk3-demo.

Style Classes
-------------

Widgets can add style classes to their context, which can be used to associate different styles by class. The documentation for individual widgets lists which style classes it uses itself, and which style classes may be added by applications to affect their appearance.

GTK+ defines macros for a number of style classes.

Custom styling in UI libraries and applications
-----------------------------------------------

If you are developing a library with custom **Gnome::Gtk3::Widgets** that render differently than standard components, you may need to add a **Gnome::Gtk3::StyleProvider** yourself with the `GTK_STYLE_PROVIDER_PRIORITY_FALLBACK` priority, either a **Gnome::Gtk3::CssProvider** or a custom object implementing the **Gnome::Gtk3::StyleProvider** interface. This way themes may still attempt to style your UI elements in a different way if needed so.

If you are using custom styling on an application, you probably want then to make your style information prevail to the theme’s, so you must use a **Gnome::Gtk3::StyleProvider** with the `GTK_STYLE_PROVIDER_PRIORITY_APPLICATION` priority, keep in mind that the user settings in `XDG_CONFIG_HOME/gtk-3.0/gtk.css` will still take precedence over your changes, as it uses the `GTK_STYLE_PROVIDER_PRIORITY_USER` priority.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::StyleContext;
    also is Gnome::GObject::Object;

Example
-------

Methods
=======

new
---

### multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

### multi method new ( N-GObject :$native-object! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

[gtk_] style_context_new
------------------------

Creates a standalone **Gnome::Gtk3::StyleContext**, this style context won’t be attached to any widget, so you may want to call `gtk_style_context_set_path()` yourself.

This function is only useful when using the theming layer separated from GTK+, if you are using **Gnome::Gtk3::StyleContext** to theme **Gnome::Gtk3::Widget**s, use `gtk_widget_get_style_context()` in order to get a style context ready to theme the widget.

Returns: A newly created **Gnome::Gtk3::StyleContext**.

    method gtk_style_context_new ( --> N-GObject  )

[[gtk_] style_context_] add_provider_for_screen
-----------------------------------------------

Adds a global style provider to **Gnome::Gdk3::Screen**, which will be used in style construction for all **Gnome::Gtk3::StyleContext**s under **Gnome::Gdk3::Screen**.

GTK+ uses this to make styling information from **Gnome::Gtk3::Settings** available.

Note: If both priorities are the same, A **Gnome::Gtk3::StyleProvider** added through `gtk_style_context_add_provider()` takes precedence over another added through this function.

Note: Priorities are unsigned integers renaging from 1 to lets say 1000. An enumeration `GtkStyleProviderPriority` in StyleProvider is defined for specific priorities such as `GTK_STYLE_PROVIDER_PRIORITY_SETTINGS` and `GTK_STYLE_PROVIDER_PRIORITY_USER`.

Since: 3.0

    method gtk_style_context_add_provider_for_screen (
      N-GObject $screen, N-GObject $provider, UInt $priority
    )

  * N-GObject $screen; a **Gnome::Gdk3::Screen**.

  * N-GObject $provider; a **Gnome::Gtk3::StyleProvider**.

  * UInt $priority; the priority of the style provider. The lower it is, the earlier it will be used in the style construction. Typically this will be in the range between `GTK_STYLE_PROVIDER_PRIORITY_FALLBACK` (= 1) and `GTK_STYLE_PROVIDER_PRIORITY_USER` (= 800).

    my Gnome::Gdk3::Screen $screen .= new;
    my Gnome::Gtk3::StyleContext $sc .= new;
    my Gnome::Gtk3::CssProvider $cp .= new;

    $sc.add-provider-for-screen(
      $screen, $cp, GTK_STYLE_PROVIDER_PRIORITY_FALLBACK
    );

[[gtk_] style_context_] remove_provider_for_screen
--------------------------------------------------

Removes a **Gnome::Gtk3::StyleProvider** from the global style providers list in **Gnome::Gdk3::Screen**.

Since: 3.0

    method gtk_style_context_remove_provider_for_screen ( N-GObject $screen, N-GObject $provider )

  * N-GObject $screen; a **Gnome::Gdk3::Screen**

  * N-GObject $provider; a **Gnome::Gtk3::StyleProvider**

[[gtk_] style_context_] add_provider
------------------------------------

Adds a style provider to the *context*, to be used in style construction. Note that a style provider added by this function only affects the style of the widget to which *context* belongs. If you want to affect the style of all widgets, use `gtk_style_context_add_provider_for_screen()`.

Note: If both priorities are the same, a **Gnome::Gtk3::StyleProvider** added through this function takes precedence over another added through `gtk_style_context_add_provider_for_screen()`.

Since: 3.0

    method gtk_style_context_add_provider ( N-GObject $provider, UInt $priority )

  * N-GObject $provider; a **Gnome::Gtk3::StyleProvider**

  * UInt $priority; the priority of the style provider. The lower it is, the earlier it will be used in the style construction. Typically this will be in the range between `GTK_STYLE_PROVIDER_PRIORITY_FALLBACK` and `GTK_STYLE_PROVIDER_PRIORITY_USER`

    my Gnome::Gtk3::StyleContext $sc .= new;
    my Gnome::Gtk3::CssProvider $cp .= new;

    $sc.add-provider( $cp, 234);

[[gtk_] style_context_] remove_provider
---------------------------------------

Removes a **Gnome::Gtk3::StyleProvider** from the style providers list in *context*.

Since: 3.0

    method gtk_style_context_remove_provider ( N-GObject $provider )

  * N-GObject $provider; a **Gnome::Gtk3::StyleProvider**

[gtk_] style_context_save
-------------------------

Saves the *context* state, so temporary modifications done through `gtk_style_context_add_class()`, `gtk_style_context_remove_class()`, `gtk_style_context_set_state()`, etc. can quickly be reverted in one go through `gtk_style_context_restore()`.

The matching call to `gtk_style_context_restore()` must be done before GTK returns to the main loop.

Since: 3.0

    method gtk_style_context_save ( )

[gtk_] style_context_restore
----------------------------

Restores *context* state to a previous stage. See `gtk_style_context_save()`.

Since: 3.0

    method gtk_style_context_restore ( )

[[gtk_] style_context_] get_section
-----------------------------------

Queries the location in the CSS where *property* was defined for the current *context*. Note that the state to be queried is taken from `gtk_style_context_get_state()`.

If the location is not available, `Any` will be returned. The location might not be available for various reasons, such as the property being overridden, *property* not naming a supported CSS property or tracking of definitions being disabled for performance reasons.

Shorthand CSS properties cannot be queried for a location and will always return `Any`.

Returns: (nullable) (transfer none): `Any` or the section where a value for *property* was defined

    method gtk_style_context_get_section ( Str $property --> N-GObject  )

  * Str $property; style property name

[[gtk_] style_context_] get_property
------------------------------------

Gets a style property from *context* for the given state.

Note that not all CSS properties that are supported by GTK+ can be retrieved in this way, since they may not be representable as `GValue`. GTK+ defines macros for a number of properties that can be used with this function.

Note that passing a state other than the current state of *context* is not recommended unless the style context has been saved with `gtk_style_context_save()`.

When *value* is no longer needed, `clear-object()` must be called to free any allocated memory.

Since: 3.0

    method gtk_style_context_get_property ( Str $property, GtkStateFlags $state, N-GObject $value )

  * Str $property; style property name

  * GtkStateFlags $state; state to retrieve the property value for

  * N-GObject $value; (out) (transfer full): return location for the style property value

[[gtk_] style_context_] set_state
---------------------------------

Sets the state to be used for style matching.

Since: 3.0

    method gtk_style_context_set_state ( GtkStateFlags $flags )

  * GtkStateFlags $flags; state to represent

[[gtk_] style_context_] get_state
---------------------------------

Returns the state used for style matching.

This method should only be used to retrieve the **Gnome::Gtk3::StateFlags** to pass to **Gnome::Gtk3::StyleContext** methods, like `gtk_style_context_get_padding()`. If you need to retrieve the current state of a **Gnome::Gtk3::Widget**, use `gtk_widget_get_state_flags()`.

Returns: the state flags

Since: 3.0

    method gtk_style_context_get_state ( --> GtkStateFlags  )

[[gtk_] style_context_] set_scale
---------------------------------

Sets the scale to use when getting image assets for the style.

Since: 3.10

    method gtk_style_context_set_scale ( Int $scale )

  * Int $scale; scale

[[gtk_] style_context_] get_scale
---------------------------------

Returns the scale used for assets.

Returns: the scale

Since: 3.10

    method gtk_style_context_get_scale ( --> Int  )

[[gtk_] style_context_] set_path
--------------------------------

Sets the **Gnome::Gtk3::WidgetPath** used for style matching. As a consequence, the style will be regenerated to match the new given path.

If you are using a **Gnome::Gtk3::StyleContext** returned from `gtk_widget_get_style_context()`, you do not need to call this yourself.

Since: 3.0

    method gtk_style_context_set_path ( N-GObject $path )

  * N-GObject $path; a **Gnome::Gtk3::WidgetPath**

[[gtk_] style_context_] get_path
--------------------------------

    method gtk_style_context_get_path ( --> N-GObject )

Returns the widget path

[[gtk_] style_context_] set_parent
----------------------------------

Sets the parent style context for *context*. The parent style context is used to implement [inheritance](https://www.w3.org/TR/css3-cascade/#inheritance) of properties.

If you are using a **Gnome::Gtk3::StyleContext** returned from `gtk_widget_get_style_context()`, the parent will be set for you.

Since: 3.4

    method gtk_style_context_set_parent ( N-GObject $parent )

  * N-GObject $parent; (allow-none): the new parent or `Any`

[[gtk_] style_context_] get_parent
----------------------------------

Gets the parent context set via `gtk_style_context_set_parent()`. See that function for details.

Returns: (nullable) (transfer none): the parent context or `Any`

Since: 3.4

    method gtk_style_context_get_parent ( --> N-GObject  )

[[gtk_] style_context_] list_classes
------------------------------------

Returns the list of classes currently defined in *context*.

Returns: (transfer container) (element-type utf8): a `GList` of strings with the currently defined classes. The contents of the list are owned by GTK+, but you must free the list itself with `g_list_free()` when you are done with it.

Since: 3.0

    method gtk_style_context_list_classes ( --> N-GObject  )

[[gtk_] style_context_] add_class
---------------------------------

Adds a style class to *context*, so posterior calls to `gtk_style_context_get()` or any of the gtk_render_*() functions will make use of this new class for styling.

In the CSS file format, a **Gnome::Gtk3::Entry** defining a “search” class, would be matched by:

    entry.search { ... }

While any widget defining a “search” class would be matched by:

.search { ... }

Since: 3.0

    method gtk_style_context_add_class ( Str $class_name )

  * Str $class_name; class name to use in styling

[[gtk_] style_context_] remove_class
------------------------------------

Removes *class_name* from *context*.

Since: 3.0

    method gtk_style_context_remove_class ( Str $class_name )

  * Str $class_name; class name to remove

[[gtk_] style_context_] has_class
---------------------------------

Returns `1` if *context* currently has defined the given class name.

Returns: `1` if *context* has *class_name* defined

Since: 3.0

    method gtk_style_context_has_class ( Str $class_name --> Int  )

  * Str $class_name; a class name

[[gtk_] style_context_] get_style_property
------------------------------------------

Gets the value for a widget style property.

When *value* is no longer needed, `clear-object()` must be called to free any allocated memory.

    method gtk_style_context_get_style_property (
      Str $property_name, N-GObject $value
    )

  * Str $property_name; the name of the widget style property

  * N-GObject $value; Return location for the property value

[[gtk_] style_context_] set_screen
----------------------------------

Attaches *context* to the given screen.

The screen is used to add style information from “global” style providers, such as the screens **Gnome::Gtk3::Settings** instance.

If you are using a **Gnome::Gtk3::StyleContext** returned from `gtk_widget_get_style_context()`, you do not need to call this yourself.

Since: 3.0

    method gtk_style_context_set_screen ( N-GObject $screen )

  * N-GObject $screen; a **Gnome::Gdk3::Screen**

[[gtk_] style_context_] get_screen
----------------------------------

Returns the **Gnome::Gdk3::Screen** to which *context* is attached.

Returns: (transfer none): a **Gnome::Gdk3::Screen**.

    method gtk_style_context_get_screen ( --> N-GObject  )

[[gtk_] style_context_] set_frame_clock
---------------------------------------

Attaches *context* to the given frame clock.

The frame clock is used for the timing of animations.

If you are using a **Gnome::Gtk3::StyleContext** returned from `gtk_widget_get_style_context()`, you do not need to call this yourself.

Since: 3.8

    method gtk_style_context_set_frame_clock ( N-GObject $frame_clock )

  * N-GObject $frame_clock; a **Gnome::Gdk3::FrameClock**

[[gtk_] style_context_] get_frame_clock
---------------------------------------

Returns the **Gnome::Gdk3::FrameClock** to which *context* is attached.

Returns: (nullable) (transfer none): a **Gnome::Gdk3::FrameClock**, or `Any` if *context* does not have an attached frame clock.

Since: 3.8

    method gtk_style_context_get_frame_clock ( --> N-GObject  )

[[gtk_] style_context_] set_junction_sides
------------------------------------------

Sets the sides where rendered elements (mostly through `gtk_render_frame()`) will visually connect with other visual elements.

This is merely a hint that may or may not be honored by themes.

Container widgets are expected to set junction hints as appropriate for their children, so it should not normally be necessary to call this function manually.

Since: 3.0

    method gtk_style_context_set_junction_sides ( GtkJunctionSides $sides )

  * GtkJunctionSides $sides; sides where rendered elements are visually connected to other elements

[[gtk_] style_context_] get_junction_sides
------------------------------------------

Returns the sides where rendered elements connect visually with others.

Returns: the junction sides

Since: 3.0

    method gtk_style_context_get_junction_sides ( --> GtkJunctionSides  )

[[gtk_] style_context_] lookup_color
------------------------------------

Looks up and resolves a color name in the *context* color map.

Returns: `1` if *color_name* was found and resolved, `0` otherwise

    method gtk_style_context_lookup_color ( Str $color_name, N-GObject $color --> Int  )

  * Str $color_name; color name to lookup

  * N-GObject $color; (out): Return location for the looked up color

[[gtk_] style_context_] get_color
---------------------------------

Gets the foreground color for a given state.

See `gtk_style_context_get_property()` and `GTK_STYLE_PROPERTY_COLOR` for details.

Since: 3.0

    method gtk_style_context_get_color ( GtkStateFlags $state, N-GObject $color )

  * GtkStateFlags $state; state to retrieve the color for

  * N-GObject $color; (out): return value for the foreground color

[[gtk_] style_context_] get_border
----------------------------------

Gets the border for a given state as a **Gnome::Gtk3::Border**.

See `gtk_style_context_get_property()` and `GTK_STYLE_PROPERTY_BORDER_WIDTH` for details.

Since: 3.0

    method gtk_style_context_get_border ( GtkStateFlags $state, N-GObject $border )

  * GtkStateFlags $state; state to retrieve the border for

  * N-GObject $border; (out): return value for the border settings

[[gtk_] style_context_] get_padding
-----------------------------------

Gets the padding for a given state as a **Gnome::Gtk3::Border**. See `gtk_style_context_get()` and `GTK_STYLE_PROPERTY_PADDING` for details.

Since: 3.0

    method gtk_style_context_get_padding ( GtkStateFlags $state, N-GObject $padding )

  * GtkStateFlags $state; state to retrieve the padding for

  * N-GObject $padding; (out): return value for the padding settings

[[gtk_] style_context_] get_margin
----------------------------------

Gets the margin for a given state as a **Gnome::Gtk3::Border**. See `gtk_style_property_get()` and `GTK_STYLE_PROPERTY_MARGIN` for details.

Since: 3.0

    method gtk_style_context_get_margin ( GtkStateFlags $state, N-GObject $margin )

  * GtkStateFlags $state; state to retrieve the border for

  * N-GObject $margin; (out): return value for the margin settings

[[gtk_] style_context_] reset_widgets
-------------------------------------

This function recomputes the styles for all widgets under a particular **Gnome::Gdk3::Screen**. This is useful when some global parameter has changed that affects the appearance of all widgets, because when a widget gets a new style, it will both redraw and recompute any cached information about its appearance. As an example, it is used when the color scheme changes in the related **Gnome::Gtk3::Settings** object.

Since: 3.0

    method gtk_style_context_reset_widgets ( N-GObject $screen )

  * N-GObject $screen; a **Gnome::Gdk3::Screen**

[[gtk_] style_context_] to_string
---------------------------------

Converts the style context into a string representation.

The string representation always includes information about the name, state, id, visibility and style classes of the CSS node that is backing *context*. Depending on the flags, more information may be included.

This function is intended for testing and debugging of the CSS implementation in GTK+. There are no guarantees about the format of the returned string, it may change.

Returns: a newly allocated string representing *context*

Since: 3.20

    method gtk_style_context_to_string (
      GtkStyleContextPrintFlags $flags --> Str
    )

  * GtkStyleContextPrintFlags $flags; Flags that determine what to print

[[gtk_] render_] background_get_clip
------------------------------------

Returns the area that will be affected (i.e. drawn to) when calling `gtk_render_background()` for the given *context* and rectangle.

Since: 3.20

    method gtk_render_background_get_clip ( N-GObject $context, Num $x, Num $y, Num $width, Num $height, N-GObject $out_clip )

  * N-GObject $context; a **Gnome::Gtk3::StyleContext**

  * Num $x; X origin of the rectangle

  * Num $y; Y origin of the rectangle

  * Num $width; rectangle width

  * Num $height; rectangle height

  * N-GObject $out_clip; (out): return location for the clip

List of deprecated (not implemented!) methods
=============================================

Since 3.4
---------

### method gtk_draw_insertion_cursor ( ... )

Since 3.6
---------

### method gtk_style_context_state_is_running ( ... )

### method gtk_style_context_notify_state_change ( ... )

### method gtk_style_context_cancel_animations ( ... )

### method gtk_style_context_scroll_animations ( ... )

### method gtk_style_context_push_animatable_region ( ... )

### method gtk_style_context_pop_animatable_region ( ... )

Since 3.8.
----------

### method gtk_style_context_set_direction ( ... )

### method gtk_style_context_get_direction ( ... )

### method PangoFontDescription ( ... )

Since 3.10
----------

### method gtk_icon_set_render_icon_pixbuf ( ... )

### method gtk_icon_set_render_icon_surface ( ... )

### method gtk_style_context_lookup_icon_set ( ... )

### method gtk_render_icon_pixbuf ( ... )

Since 3.12
----------

### method gtk_style_context_invalidate ( ... )

Since 3.14
----------

### method gtk_style_context_list_regions ( ... )

### method gtk_style_context_add_region ( ... )

### method gtk_style_context_remove_region ( ... )

### method gtk_style_context_has_region ( ... )

Since 3.16.
-----------

### method gtk_style_context_get_background_color ( ... )

### method gtk_style_context_get_border_color ( ... )

Since 3.18.
-----------

### method gtk_style_context_set_background ( ... )

Since 3.24.
-----------

### method gtk_render_frame_gap ( ... )

Signals
=======

Register any signal as follows. See also **Gnome::GObject::Object**.

    my Bool $is-registered = $my-widget.register-signal (
      $handler-object, $handler-name, $signal-name,
      :$user-option1, ..., :$user-optionN
    )

Not yet supported signals
-------------------------

### changed

The sig *changed* signal is emitted when there is a change in the **Gnome::Gtk3::StyleContext**.

For a **Gnome::Gtk3::StyleContext** returned by `gtk_widget_get_style_context()`, the sig `style-updated` signal/vfunc might be more convenient to use.

This signal is useful when using the theming layer standalone.

Since: 3.0

    method handler (
      :$user-option1, ..., :$user-optionN
    );

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Not yet supported properties
----------------------------

### parent

The **Gnome::GObject::Value** type of property *parent* is `G_TYPE_OBJECT`.

Sets or gets the style context’s parent. See `gtk_style_context_set_parent()` for details.

Since: 3.4

