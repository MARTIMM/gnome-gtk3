#TL:1:Gnome::Gtk3::StyleContext:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::StyleContext

Rendering UI elements

=head1 Description

B<Gnome::Gtk3::StyleContext> is an object that stores styling information affecting a widget.

In order to construct the final style information, B<Gnome::Gtk3::StyleContext> queries information from all attached B<Gnome::Gtk3::StyleProviders>. Style providers can be either attached explicitly to the context through C<gtk_style_context_add_provider()>, or to the screen through C<gtk_style_context_add_provider_for_screen()>. The resulting style is a combination of all providers’ information in priority order.

For GTK+ widgets, any B<Gnome::Gtk3::StyleContext> returned by C<gtk_widget_get_style_context()> will already have a B<Gnome::Gtk3::WidgetPath>, a B<Gnome::Gdk3::Screen> and RTL/LTR information set. The style context will also be updated automatically if any of these settings change on the widget.

If you are using the theming layer standalone, you will need to set a widget path and a screen yourself to the created style context through C<gtk_style_context_set_path()> and C<gtk_style_context_set_screen()>, as well as updating the context yourself using C<gtk_style_context_invalidate()> whenever any of the conditions change, such as a change in the prop C<gtk-theme-name> setting or a hierarchy change in the rendered widget. See the “Foreign drawing“ example in gtk3-demo.

=head2 Style Classes

Widgets can add style classes to their context, which can be used to associate different styles by class. The documentation for individual widgets lists which style classes it uses itself, and which style classes may be added by applications to affect their appearance.

GTK+ defines macros for a number of style classes.

=begin comment
=head2 Style Regions

Widgets can also add regions with flags to their context. This feature is deprecated and will be removed in a future GTK+ update. Please use style classes instead.

GTK+ defines macros for a number of style regions.
=end comment

=head2 Custom styling in UI libraries and applications

If you are developing a library with custom B<Gnome::Gtk3::Widgets> that render differently than standard components, you may need to add a B<Gnome::Gtk3::StyleProvider> yourself with the C<GTK_STYLE_PROVIDER_PRIORITY_FALLBACK> priority, either a B<Gnome::Gtk3::CssProvider> or a custom object implementing the B<Gnome::Gtk3::StyleProvider> interface. This way themes may still attempt to style your UI elements in a different way if needed so.

If you are using custom styling on an application, you probably want then to make your style information prevail to the theme’s, so you must use a B<Gnome::Gtk3::StyleProvider> with the C<GTK_STYLE_PROVIDER_PRIORITY_APPLICATION> priority, keep in mind that the user settings in `XDG_CONFIG_HOME/gtk-3.0/gtk.css` will still take precedence over your changes, as it uses the C<GTK_STYLE_PROVIDER_PRIORITY_USER> priority.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::StyleContext;
  also is Gnome::GObject::Object;

=head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::GObject::Object;
use Gnome::Gdk3::Screen;
use Gnome::Gtk3::Border;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkstylecontext.h
# https://developer.gnome.org/gtk3/stable/GtkStyleContext.html
unit class Gnome::Gtk3::StyleContext:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
enum GtkStyleContextPrintFlags is export (
  GTK_STYLE_CONTEXT_PRINT_NONE         => 0,
  GTK_STYLE_CONTEXT_PRINT_RECURSE      => 1 +< 0,
  GTK_STYLE_CONTEXT_PRINT_SHOW_STYLE   => 1 +< 1
);

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
#TM:1:new(:empty):
#TM:0:new(:widget):

=begin pod
=head1 Methods
=head2 new
=head3 multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

=head3 multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<changed>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::StyleContext';

  if ? %options<empty> {
    self.native-gobject(gtk_style_context_new());
  }

  elsif ? %options<widget> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkStyleContext');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_style_context_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkStyleContext');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:2:gtk_style_context_new:new(:empty)
=begin pod
=head2 [gtk_] style_context_new

Creates a standalone B<Gnome::Gtk3::StyleContext>, this style context won’t be attached to any widget, so you may want to call C<gtk_style_context_set_path()> yourself.

This function is only useful when using the theming layer separated from GTK+, if you are using B<Gnome::Gtk3::StyleContext> to theme B<Gnome::Gtk3::Widget>s, use C<gtk_widget_get_style_context()> in order to get a style context ready to theme the widget.

Returns: A newly created B<Gnome::Gtk3::StyleContext>.

  method gtk_style_context_new ( --> N-GObject  )

=end pod

sub gtk_style_context_new ( --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_style_context_add_provider_for_screen:
=begin pod
=head2 [[gtk_] style_context_] add_provider_for_screen

Adds a global style provider to B<Gnome::Gdk3::Screen>, which will be used in style construction for all B<Gnome::Gtk3::StyleContext>s under B<Gnome::Gdk3::Screen>.

GTK+ uses this to make styling information from B<Gnome::Gtk3::Settings> available.

Note: If both priorities are the same, A B<Gnome::Gtk3::StyleProvider> added through C<gtk_style_context_add_provider()> takes precedence over another added through this function.

Note: Priorities are unsigned integers renaging from 1 to lets say 1000. An enumeration C<GtkStyleProviderPriority> in StyleProvider is defined for specific priorities such as C<GTK_STYLE_PROVIDER_PRIORITY_SETTINGS> and C<GTK_STYLE_PROVIDER_PRIORITY_USER>.

Since: 3.0

  method gtk_style_context_add_provider_for_screen (
    N-GObject $screen, N-GObject $provider, UInt $priority
  )

=item N-GObject $screen; a B<Gnome::Gdk3::Screen>.
=item N-GObject $provider; a B<Gnome::Gtk3::StyleProvider>.
=item UInt $priority; the priority of the style provider. The lower it is, the earlier it will be used in the style construction. Typically this will be in the range between C<GTK_STYLE_PROVIDER_PRIORITY_FALLBACK> (= 1) and C<GTK_STYLE_PROVIDER_PRIORITY_USER> (= 800).

  my Gnome::Gdk3::Screen $screen .= new(:default);
  my Gnome::Gtk3::StyleContext $sc .= new(:empty);
  my Gnome::Gtk3::CssProvider $cp .= new(:empty);

  $sc.add-provider-for-screen(
    $screen, $cp, GTK_STYLE_PROVIDER_PRIORITY_FALLBACK
  );


=end pod

# needed to apply this trick to prevent a wrong interpretation of N-GObject
# $screen argument in test-call() from Gnome::N::X. It would be replaced by the
# N-GObject $context argument which is wrong.
sub gtk_style_context_add_provider_for_screen( |c ) is inlinable {
  _gtk_style_context_add_provider_for_screen(|c);
}

sub _gtk_style_context_add_provider_for_screen (
  N-GObject $screen, N-GObject $provider, int32 $priority
) is native(&gtk-lib)
  is symbol('gtk_style_context_add_provider_for_screen')
  { * }


#-------------------------------------------------------------------------------
#TM:1:gtk_style_context_remove_provider_for_screen:
=begin pod
=head2 [[gtk_] style_context_] remove_provider_for_screen

Removes a B<Gnome::Gtk3::StyleProvider> from the global style providers list in B<Gnome::Gdk3::Screen>.

Since: 3.0

  method gtk_style_context_remove_provider_for_screen ( N-GObject $screen, N-GObject $provider )

=item N-GObject $screen; a B<Gnome::Gdk3::Screen>
=item N-GObject $provider; a B<Gnome::Gtk3::StyleProvider>

=end pod

# needed to apply this trick to prevent a wrong interpretation of N-GObject
# $screen argument in test-call() from Gnome::N::X. It would be replaced by the
# N-GObject $context argument which is wrong.
sub gtk_style_context_remove_provider_for_screen( |c ) is inlinable {
  _gtk_style_context_remove_provider_for_screen(|c);
}

sub _gtk_style_context_remove_provider_for_screen (
  N-GObject $screen, N-GObject $provider
) is native(&gtk-lib)
  is symbol('gtk_style_context_remove_provider_for_screen')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_style_context_add_provider:
=begin pod
=head2 [[gtk_] style_context_] add_provider

Adds a style provider to the I<context>, to be used in style construction. Note that a style provider added by this function only affects the style of the widget to which I<context> belongs. If you want to affect the style of all widgets, use C<gtk_style_context_add_provider_for_screen()>.

Note: If both priorities are the same, a B<Gnome::Gtk3::StyleProvider> added through this function takes precedence over another added through C<gtk_style_context_add_provider_for_screen()>.

Since: 3.0

  method gtk_style_context_add_provider ( N-GObject $provider, UInt $priority )

=item N-GObject $provider; a B<Gnome::Gtk3::StyleProvider>
=item UInt $priority; the priority of the style provider. The lower it is, the earlier it will be used in the style construction. Typically this will be in the range between C<GTK_STYLE_PROVIDER_PRIORITY_FALLBACK> and C<GTK_STYLE_PROVIDER_PRIORITY_USER>

  my Gnome::Gdk3::Screen $screen .= new(:default);
  my Gnome::Gtk3::StyleContext $sc .= new(:empty);
  my Gnome::Gtk3::CssProvider $cp .= new(:empty);

  $sc.add-provider( $cp, 234);

=end pod

sub gtk_style_context_add_provider ( N-GObject $context, N-GObject $provider, uint32 $priority )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_style_context_remove_provider:
=begin pod
=head2 [[gtk_] style_context_] remove_provider

Removes a B<Gnome::Gtk3::StyleProvider> from the style providers list in I<context>.

Since: 3.0

  method gtk_style_context_remove_provider ( N-GObject $provider )

=item N-GObject $provider; a B<Gnome::Gtk3::StyleProvider>

=end pod

sub gtk_style_context_remove_provider ( N-GObject $context, N-GObject $provider )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_save:
=begin pod
=head2 [gtk_] style_context_save

Saves the I<context> state, so temporary modifications done through C<gtk_style_context_add_class()>, C<gtk_style_context_remove_class()>, C<gtk_style_context_set_state()>, etc. can quickly be reverted in one go through C<gtk_style_context_restore()>.

The matching call to C<gtk_style_context_restore()> must be done before GTK returns to the main loop.

Since: 3.0

  method gtk_style_context_save ( )

=end pod

sub gtk_style_context_save ( N-GObject $context )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_restore:
=begin pod
=head2 [gtk_] style_context_restore

Restores I<context> state to a previous stage. See C<gtk_style_context_save()>.

Since: 3.0

  method gtk_style_context_restore ( )

=end pod

sub gtk_style_context_restore ( N-GObject $context )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_section:
=begin pod
=head2 [[gtk_] style_context_] get_section

Queries the location in the CSS where I<property> was defined for the
current I<context>. Note that the state to be queried is taken from
C<gtk_style_context_get_state()>.

If the location is not available, C<Any> will be returned. The
location might not be available for various reasons, such as the
property being overridden, I<property> not naming a supported CSS
property or tracking of definitions being disabled for performance
reasons.

Shorthand CSS properties cannot be queried for a location and will
always return C<Any>.

Returns: (nullable) (transfer none): C<Any> or the section where a value
for I<property> was defined

  method gtk_style_context_get_section ( Str $property --> N-GObject  )

=item Str $property; style property name

=end pod

sub gtk_style_context_get_section ( N-GObject $context, Str $property )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_property:
=begin pod
=head2 [[gtk_] style_context_] get_property

Gets a style property from I<context> for the given state.

Note that not all CSS properties that are supported by GTK+ can be
retrieved in this way, since they may not be representable as C<GValue>.
GTK+ defines macros for a number of properties that can be used
with this function.

Note that passing a state other than the current state of I<context>
is not recommended unless the style context has been saved with
C<gtk_style_context_save()>.

When I<value> is no longer needed, C<g_value_unset()> must be called
to free any allocated memory.

Since: 3.0

  method gtk_style_context_get_property ( Str $property, GtkStateFlags $state, N-GObject $value )

=item Str $property; style property name
=item GtkStateFlags $state; state to retrieve the property value for
=item N-GObject $value; (out) (transfer full):  return location for the style property value

=end pod

sub gtk_style_context_get_property ( N-GObject $context, Str $property, int32 $state, N-GObject $value )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_valist:
=begin pod
=head2 [[gtk_] style_context_] get_valist

Retrieves several style property values from I<context> for a given state.

See C<gtk_style_context_get_property()> for details.

Since: 3.0

  method gtk_style_context_get_valist ( GtkStateFlags $state, va_list $args )

=item GtkStateFlags $state; state to retrieve the property values for
=item va_list $args; va_list of property name/return location pairs, followed by C<Any>

=end pod

sub gtk_style_context_get_valist ( N-GObject $context, int32 $state, va_list $args )
  is native(&gtk-lib)
  { * }
}}

#`[[
#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get:
=begin pod
=head2 [gtk_] style_context_get

Retrieves several style property values from I<context> for a
given state.

See C<gtk_style_context_get_property()> for details.

Since: 3.0

  method gtk_style_context_get ( GtkStateFlags $state )

=item GtkStateFlags $state; state to retrieve the property values for @...: property name /return value pairs, followed by C<Any>

=end pod

sub gtk_style_context_get ( N-GObject $context, int32 $state, Any $any = Any )
  is native(&gtk-lib)
  { * }
]]

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_set_state:
=begin pod
=head2 [[gtk_] style_context_] set_state

Sets the state to be used for style matching.

Since: 3.0

  method gtk_style_context_set_state ( GtkStateFlags $flags )

=item GtkStateFlags $flags; state to represent

=end pod

sub gtk_style_context_set_state ( N-GObject $context, int32 $flags )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_state:
=begin pod
=head2 [[gtk_] style_context_] get_state

Returns the state used for style matching.

This method should only be used to retrieve the B<Gnome::Gtk3::StateFlags>
to pass to B<Gnome::Gtk3::StyleContext> methods, like C<gtk_style_context_get_padding()>.
If you need to retrieve the current state of a B<Gnome::Gtk3::Widget>, use
C<gtk_widget_get_state_flags()>.

Returns: the state flags

Since: 3.0

  method gtk_style_context_get_state ( --> GtkStateFlags  )


=end pod

sub gtk_style_context_get_state ( N-GObject $context )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_set_scale:
=begin pod
=head2 [[gtk_] style_context_] set_scale

Sets the scale to use when getting image assets for the style.

Since: 3.10

  method gtk_style_context_set_scale ( Int $scale )

=item Int $scale; scale

=end pod

sub gtk_style_context_set_scale ( N-GObject $context, int32 $scale )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_scale:
=begin pod
=head2 [[gtk_] style_context_] get_scale

Returns the scale used for assets.

Returns: the scale

Since: 3.10

  method gtk_style_context_get_scale ( --> Int  )


=end pod

sub gtk_style_context_get_scale ( N-GObject $context )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_set_path:
=begin pod
=head2 [[gtk_] style_context_] set_path

Sets the B<Gnome::Gtk3::WidgetPath> used for style matching. As a
consequence, the style will be regenerated to match
the new given path.

If you are using a B<Gnome::Gtk3::StyleContext> returned from
C<gtk_widget_get_style_context()>, you do not need to call
this yourself.

Since: 3.0

  method gtk_style_context_set_path ( N-GObject $path )

=item N-GObject $path; a B<Gnome::Gtk3::WidgetPath>

=end pod

sub gtk_style_context_set_path ( N-GObject $context, N-GObject $path )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_path:
=begin pod
=head2 [[gtk_] style_context_] get_path

  method gtk_style_context_get_path ( --> N-GObject )

Returns the widget path

=end pod

sub gtk_style_context_get_path ( N-GObject $context )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_set_parent:
=begin pod
=head2 [[gtk_] style_context_] set_parent

Sets the parent style context for I<context>. The parent style context is used to implement [inheritance](https://www.w3.org/TR/css3-cascade/#inheritance) of properties.

If you are using a B<Gnome::Gtk3::StyleContext> returned from C<gtk_widget_get_style_context()>, the parent will be set for you.

Since: 3.4

  method gtk_style_context_set_parent ( N-GObject $parent )

=item N-GObject $parent; (allow-none): the new parent or C<Any>

=end pod

sub gtk_style_context_set_parent ( N-GObject $context, N-GObject $parent )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_parent:
=begin pod
=head2 [[gtk_] style_context_] get_parent

Gets the parent context set via C<gtk_style_context_set_parent()>.
See that function for details.

Returns: (nullable) (transfer none): the parent context or C<Any>

Since: 3.4

  method gtk_style_context_get_parent ( --> N-GObject  )


=end pod

sub gtk_style_context_get_parent ( N-GObject $context )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_list_classes:
=begin pod
=head2 [[gtk_] style_context_] list_classes

Returns the list of classes currently defined in I<context>.

Returns: (transfer container) (element-type utf8): a C<GList> of
strings with the currently defined classes. The contents
of the list are owned by GTK+, but you must free the list
itself with C<g_list_free()> when you are done with it.

Since: 3.0

  method gtk_style_context_list_classes ( --> N-GObject  )


=end pod

sub gtk_style_context_list_classes ( N-GObject $context )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_add_class:
=begin pod
=head2 [[gtk_] style_context_] add_class

Adds a style class to I<context>, so posterior calls to
C<gtk_style_context_get()> or any of the gtk_render_*()
functions will make use of this new class for styling.

In the CSS file format, a B<Gnome::Gtk3::Entry> defining a “search”
class, would be matched by:

  entry.search { ... }

While any widget defining a “search” class would be
matched by:

.search { ... }

Since: 3.0

  method gtk_style_context_add_class ( Str $class_name )

=item Str $class_name; class name to use in styling

=end pod

sub gtk_style_context_add_class ( N-GObject $context, Str $class_name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_remove_class:
=begin pod
=head2 [[gtk_] style_context_] remove_class

Removes I<class_name> from I<context>.

Since: 3.0

  method gtk_style_context_remove_class ( Str $class_name )

=item Str $class_name; class name to remove

=end pod

sub gtk_style_context_remove_class ( N-GObject $context, Str $class_name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_has_class:
=begin pod
=head2 [[gtk_] style_context_] has_class

Returns C<1> if I<context> currently has defined the
given class name.

Returns: C<1> if I<context> has I<class_name> defined

Since: 3.0

  method gtk_style_context_has_class ( Str $class_name --> Int  )

=item Str $class_name; a class name

=end pod

sub gtk_style_context_has_class ( N-GObject $context, Str $class_name )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_style_property:
=begin pod
=head2 [[gtk_] style_context_] get_style_property

Gets the value for a widget style property.

When I<value> is no longer needed, C<g_value_unset()> must be called to free any allocated memory.

  method gtk_style_context_get_style_property (
    Str $property_name, N-GObject $value
  )

=item Str $property_name; the name of the widget style property
=item N-GObject $value; Return location for the property value

=end pod

sub gtk_style_context_get_style_property ( N-GObject $context, Str $property_name, N-GObject $value )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_style_valist:
=begin pod
=head2 [[gtk_] style_context_] get_style_valist

Retrieves several widget style properties from I<context> according to the
current style.

Since: 3.0

  method gtk_style_context_get_style_valist ( va_list $args )

=item va_list $args; va_list of property name/return location pairs, followed by C<Any>

=end pod

sub gtk_style_context_get_style_valist ( N-GObject $context, va_list $args )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_style:
=begin pod
=head2 [[gtk_] style_context_] get_style

Retrieves several widget style properties from I<context> according to the
current style.

Since: 3.0

  method gtk_style_context_get_style ( )


=end pod

sub gtk_style_context_get_style ( N-GObject $context, Any $any = Any )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_set_screen:
=begin pod
=head2 [[gtk_] style_context_] set_screen

Attaches I<context> to the given screen.

The screen is used to add style information from “global” style
providers, such as the screens B<Gnome::Gtk3::Settings> instance.

If you are using a B<Gnome::Gtk3::StyleContext> returned from
C<gtk_widget_get_style_context()>, you do not need to
call this yourself.

Since: 3.0

  method gtk_style_context_set_screen ( N-GObject $screen )

=item N-GObject $screen; a B<Gnome::Gdk3::Screen>

=end pod

sub gtk_style_context_set_screen ( N-GObject $context, N-GObject $screen )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_screen:
=begin pod
=head2 [[gtk_] style_context_] get_screen

Returns the B<Gnome::Gdk3::Screen> to which I<context> is attached.

Returns: (transfer none): a B<Gnome::Gdk3::Screen>.

  method gtk_style_context_get_screen ( --> N-GObject  )


=end pod

sub gtk_style_context_get_screen ( N-GObject $context )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_set_frame_clock:
=begin pod
=head2 [[gtk_] style_context_] set_frame_clock

Attaches I<context> to the given frame clock.

The frame clock is used for the timing of animations.

If you are using a B<Gnome::Gtk3::StyleContext> returned from
C<gtk_widget_get_style_context()>, you do not need to
call this yourself.

Since: 3.8

  method gtk_style_context_set_frame_clock ( N-GObject $frame_clock )

=item N-GObject $frame_clock; a B<Gnome::Gdk3::FrameClock>

=end pod

sub gtk_style_context_set_frame_clock ( N-GObject $context, N-GObject $frame_clock )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_frame_clock:
=begin pod
=head2 [[gtk_] style_context_] get_frame_clock

Returns the B<Gnome::Gdk3::FrameClock> to which I<context> is attached.

Returns: (nullable) (transfer none): a B<Gnome::Gdk3::FrameClock>, or C<Any>
if I<context> does not have an attached frame clock.

Since: 3.8

  method gtk_style_context_get_frame_clock ( --> N-GObject  )


=end pod

sub gtk_style_context_get_frame_clock ( N-GObject $context )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_set_junction_sides:
=begin pod
=head2 [[gtk_] style_context_] set_junction_sides

Sets the sides where rendered elements (mostly through
C<gtk_render_frame()>) will visually connect with other visual elements.

This is merely a hint that may or may not be honored
by themes.

Container widgets are expected to set junction hints as appropriate
for their children, so it should not normally be necessary to call
this function manually.

Since: 3.0

  method gtk_style_context_set_junction_sides ( GtkJunctionSides $sides )

=item GtkJunctionSides $sides; sides where rendered elements are visually connected to other elements

=end pod

sub gtk_style_context_set_junction_sides ( N-GObject $context, int32 $sides )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_junction_sides:
=begin pod
=head2 [[gtk_] style_context_] get_junction_sides

Returns the sides where rendered elements connect visually with others.

Returns: the junction sides

Since: 3.0

  method gtk_style_context_get_junction_sides ( --> GtkJunctionSides  )


=end pod

sub gtk_style_context_get_junction_sides ( N-GObject $context )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_lookup_color:
=begin pod
=head2 [[gtk_] style_context_] lookup_color

Looks up and resolves a color name in the I<context> color map.

Returns: C<1> if I<color_name> was found and resolved, C<0> otherwise

  method gtk_style_context_lookup_color ( Str $color_name, N-GObject $color --> Int  )

=item Str $color_name; color name to lookup
=item N-GObject $color; (out): Return location for the looked up color

=end pod

sub gtk_style_context_lookup_color ( N-GObject $context, Str $color_name, N-GObject $color )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_color:
=begin pod
=head2 [[gtk_] style_context_] get_color

Gets the foreground color for a given state.

See C<gtk_style_context_get_property()> and
C<GTK_STYLE_PROPERTY_COLOR> for details.

Since: 3.0

  method gtk_style_context_get_color ( GtkStateFlags $state, N-GObject $color )

=item GtkStateFlags $state; state to retrieve the color for
=item N-GObject $color; (out): return value for the foreground color

=end pod

sub gtk_style_context_get_color ( N-GObject $context, int32 $state, N-GObject $color )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_border:
=begin pod
=head2 [[gtk_] style_context_] get_border

Gets the border for a given state as a B<Gnome::Gtk3::Border>.

See C<gtk_style_context_get_property()> and
C<GTK_STYLE_PROPERTY_BORDER_WIDTH> for details.

Since: 3.0

  method gtk_style_context_get_border ( GtkStateFlags $state, N-GObject $border )

=item GtkStateFlags $state; state to retrieve the border for
=item N-GObject $border; (out): return value for the border settings

=end pod

sub gtk_style_context_get_border ( N-GObject $context, int32 $state, N-GObject $border )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_padding:
=begin pod
=head2 [[gtk_] style_context_] get_padding

Gets the padding for a given state as a B<Gnome::Gtk3::Border>.
See C<gtk_style_context_get()> and C<GTK_STYLE_PROPERTY_PADDING>
for details.

Since: 3.0

  method gtk_style_context_get_padding ( GtkStateFlags $state, N-GObject $padding )

=item GtkStateFlags $state; state to retrieve the padding for
=item N-GObject $padding; (out): return value for the padding settings

=end pod

sub gtk_style_context_get_padding ( N-GObject $context, int32 $state, N-GObject $padding )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_get_margin:
=begin pod
=head2 [[gtk_] style_context_] get_margin

Gets the margin for a given state as a B<Gnome::Gtk3::Border>.
See C<gtk_style_property_get()> and C<GTK_STYLE_PROPERTY_MARGIN>
for details.

Since: 3.0

  method gtk_style_context_get_margin ( GtkStateFlags $state, N-GObject $margin )

=item GtkStateFlags $state; state to retrieve the border for
=item N-GObject $margin; (out): return value for the margin settings

=end pod

sub gtk_style_context_get_margin ( N-GObject $context, int32 $state, N-GObject $margin )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_reset_widgets:
=begin pod
=head2 [[gtk_] style_context_] reset_widgets

This function recomputes the styles for all widgets under a particular
B<Gnome::Gdk3::Screen>. This is useful when some global parameter has changed that
affects the appearance of all widgets, because when a widget gets a new
style, it will both redraw and recompute any cached information about
its appearance. As an example, it is used when the color scheme changes
in the related B<Gnome::Gtk3::Settings> object.

Since: 3.0

  method gtk_style_context_reset_widgets ( N-GObject $screen )

=item N-GObject $screen; a B<Gnome::Gdk3::Screen>

=end pod

sub gtk_style_context_reset_widgets ( N-GObject $screen )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_style_context_to_string:
=begin pod
=head2 [[gtk_] style_context_] to_string

Converts the style context into a string representation.

The string representation always includes information about the name, state, id, visibility and style classes of the CSS node that is backing I<context>. Depending on the flags, more information may be included.

This function is intended for testing and debugging of the CSS implementation in GTK+. There are no guarantees about the format of the returned string, it may change.

Returns: a newly allocated string representing I<context>

Since: 3.20

  method gtk_style_context_to_string (
    GtkStyleContextPrintFlags $flags --> Str
  )

=item GtkStyleContextPrintFlags $flags; Flags that determine what to print

=end pod

sub gtk_style_context_to_string ( N-GObject $context, int32 $flags )
  returns Str
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_render_check:
=begin pod
=head2 [gtk_] render_check

Renders a checkmark (as in a B<Gnome::Gtk3::CheckButton>).

The C<GTK_STATE_FLAG_CHECKED> state determines whether the check is
on or off, and C<GTK_STATE_FLAG_INCONSISTENT> determines whether it
should be marked as undefined.

Typical checkmark rendering:

![](images/checks.png)

Since: 3.0

  method gtk_render_check ( N-GObject $context, cairo_t $cr, Num $x, Num $y, Num $width, Num $height )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item Num $x; X origin of the rectangle
=item Num $y; Y origin of the rectangle
=item Num $width; rectangle width
=item Num $height; rectangle height

=end pod

sub gtk_render_check ( N-GObject $context, cairo_t $cr, num64 $x, num64 $y, num64 $width, num64 $height )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_render_option:
=begin pod
=head2 [gtk_] render_option

Renders an option mark (as in a B<Gnome::Gtk3::RadioButton>), the C<GTK_STATE_FLAG_CHECKED>
state will determine whether the option is on or off, and
C<GTK_STATE_FLAG_INCONSISTENT> whether it should be marked as undefined.

Typical option mark rendering:

![](images/options.png)

Since: 3.0

  method gtk_render_option ( N-GObject $context, cairo_t $cr, Num $x, Num $y, Num $width, Num $height )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item Num $x; X origin of the rectangle
=item Num $y; Y origin of the rectangle
=item Num $width; rectangle width
=item Num $height; rectangle height

=end pod

sub gtk_render_option ( N-GObject $context, cairo_t $cr, num64 $x, num64 $y, num64 $width, num64 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_render_arrow:
=begin pod
=head2 [gtk_] render_arrow

Renders an arrow pointing to I<angle>.

Typical arrow rendering at 0, 1⁄2 π;, π; and 3⁄2 π:

![](images/arrows.png)

Since: 3.0

  method gtk_render_arrow ( N-GObject $context, cairo_t $cr, Num $angle, Num $x, Num $y, Num $size )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item Num $angle; arrow angle from 0 to 2 * C<G_PI>, being 0 the arrow pointing to the north
=item Num $x; X origin of the render area
=item Num $y; Y origin of the render area
=item Num $size; square side for render area

=end pod

sub gtk_render_arrow ( N-GObject $context, cairo_t $cr, num64 $angle, num64 $x, num64 $y, num64 $size )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_render_background:
=begin pod
=head2 [gtk_] render_background

Renders the background of an element.

Typical background rendering, showing the effect of
`background-image`, `border-width` and `border-radius`:

![](images/background.png)

Since: 3.0.

  method gtk_render_background ( N-GObject $context, cairo_t $cr, Num $x, Num $y, Num $width, Num $height )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item Num $x; X origin of the rectangle
=item Num $y; Y origin of the rectangle
=item Num $width; rectangle width
=item Num $height; rectangle height

=end pod

sub gtk_render_background ( N-GObject $context, cairo_t $cr, num64 $x, num64 $y, num64 $width, num64 $height )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_render_background_get_clip:
=begin pod
=head2 [[gtk_] render_] background_get_clip

Returns the area that will be affected (i.e. drawn to) when
calling C<gtk_render_background()> for the given I<context> and
rectangle.

Since: 3.20

  method gtk_render_background_get_clip ( N-GObject $context, Num $x, Num $y, Num $width, Num $height, N-GObject $out_clip )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item Num $x; X origin of the rectangle
=item Num $y; Y origin of the rectangle
=item Num $width; rectangle width
=item Num $height; rectangle height
=item N-GObject $out_clip; (out): return location for the clip

=end pod

sub gtk_render_background_get_clip ( N-GObject $context, num64 $x, num64 $y, num64 $width, num64 $height, N-GObject $out_clip )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_render_frame:
=begin pod
=head2 [gtk_] render_frame

Renders a frame around the rectangle defined by I<x>, I<y>, I<width>, I<height>.

Examples of frame rendering, showing the effect of `border-image`,
`border-color`, `border-width`, `border-radius` and junctions:

![](images/frames.png)

Since: 3.0

  method gtk_render_frame ( N-GObject $context, cairo_t $cr, Num $x, Num $y, Num $width, Num $height )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item Num $x; X origin of the rectangle
=item Num $y; Y origin of the rectangle
=item Num $width; rectangle width
=item Num $height; rectangle height

=end pod

sub gtk_render_frame ( N-GObject $context, cairo_t $cr, num64 $x, num64 $y, num64 $width, num64 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_render_expander:
=begin pod
=head2 [gtk_] render_expander

Renders an expander (as used in B<Gnome::Gtk3::TreeView> and B<Gnome::Gtk3::Expander>) in the area
defined by I<x>, I<y>, I<width>, I<height>. The state C<GTK_STATE_FLAG_CHECKED>
determines whether the expander is collapsed or expanded.

Typical expander rendering:

![](images/expanders.png)

Since: 3.0

  method gtk_render_expander ( N-GObject $context, cairo_t $cr, Num $x, Num $y, Num $width, Num $height )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item Num $x; X origin of the rectangle
=item Num $y; Y origin of the rectangle
=item Num $width; rectangle width
=item Num $height; rectangle height

=end pod

sub gtk_render_expander ( N-GObject $context, cairo_t $cr, num64 $x, num64 $y, num64 $width, num64 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_render_focus:
=begin pod
=head2 [gtk_] render_focus

Renders a focus indicator on the rectangle determined by I<x>, I<y>, I<width>, I<height>.

Typical focus rendering:

![](images/focus.png)

Since: 3.0

  method gtk_render_focus ( N-GObject $context, cairo_t $cr, Num $x, Num $y, Num $width, Num $height )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item Num $x; X origin of the rectangle
=item Num $y; Y origin of the rectangle
=item Num $width; rectangle width
=item Num $height; rectangle height

=end pod

sub gtk_render_focus ( N-GObject $context, cairo_t $cr, num64 $x, num64 $y, num64 $width, num64 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_render_layout:
=begin pod
=head2 [gtk_] render_layout

Renders I<layout> on the coordinates I<x>, I<y>

Since: 3.0

  method gtk_render_layout ( N-GObject $context, cairo_t $cr, Num $x, Num $y, PangoLayout $layout )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item Num $x; X origin
=item Num $y; Y origin
=item PangoLayout $layout; the I<PangoLayout> to render

=end pod

sub gtk_render_layout ( N-GObject $context, cairo_t $cr, num64 $x, num64 $y, PangoLayout $layout )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_render_line:
=begin pod
=head2 [gtk_] render_line

Renders a line from (x0, y0) to (x1, y1).

Since: 3.0

  method gtk_render_line ( N-GObject $context, cairo_t $cr, Num $x0, Num $y0, Num $x1, Num $y1 )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item Num $x0; X coordinate for the origin of the line
=item Num $y0; Y coordinate for the origin of the line
=item Num $x1; X coordinate for the end of the line
=item Num $y1; Y coordinate for the end of the line

=end pod

sub gtk_render_line ( N-GObject $context, cairo_t $cr, num64 $x0, num64 $y0, num64 $x1, num64 $y1 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_render_slider:
=begin pod
=head2 [gtk_] render_slider

Renders a slider (as in B<Gnome::Gtk3::Scale>) in the rectangle defined by I<x>, I<y>,
I<width>, I<height>. I<orientation> defines whether the slider is vertical
or horizontal.

Typical slider rendering:

![](images/sliders.png)

Since: 3.0

  method gtk_render_slider ( N-GObject $context, cairo_t $cr, Num $x, Num $y, Num $width, Num $height, GtkOrientation $orientation )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item Num $x; X origin of the rectangle
=item Num $y; Y origin of the rectangle
=item Num $width; rectangle width
=item Num $height; rectangle height
=item GtkOrientation $orientation; orientation of the slider

=end pod

sub gtk_render_slider ( N-GObject $context, cairo_t $cr, num64 $x, num64 $y, num64 $width, num64 $height, int32 $orientation )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_render_extension:
=begin pod
=head2 [gtk_] render_extension

Renders a extension (as in a B<Gnome::Gtk3::Notebook> tab) in the rectangle
defined by I<x>, I<y>, I<width>, I<height>. The side where the extension
connects to is defined by I<gap_side>.

Typical extension rendering:

![](images/extensions.png)

Since: 3.0

  method gtk_render_extension ( N-GObject $context, cairo_t $cr, Num $x, Num $y, Num $width, Num $height, GtkPositionType $gap_side )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item Num $x; X origin of the rectangle
=item Num $y; Y origin of the rectangle
=item Num $width; rectangle width
=item Num $height; rectangle height
=item GtkPositionType $gap_side; side where the gap is

=end pod

sub gtk_render_extension ( N-GObject $context, cairo_t $cr, num64 $x, num64 $y, num64 $width, num64 $height, int32 $gap_side )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_render_handle:
=begin pod
=head2 [gtk_] render_handle

Renders a handle (as in B<Gnome::Gtk3::HandleBox>, B<Gnome::Gtk3::Paned> and
B<Gnome::Gtk3::Window>’s resize grip), in the rectangle
determined by I<x>, I<y>, I<width>, I<height>.

Handles rendered for the paned and grip classes:

![](images/handles.png)

Since: 3.0

  method gtk_render_handle ( N-GObject $context, cairo_t $cr, Num $x, Num $y, Num $width, Num $height )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item Num $x; X origin of the rectangle
=item Num $y; Y origin of the rectangle
=item Num $width; rectangle width
=item Num $height; rectangle height

=end pod

sub gtk_render_handle ( N-GObject $context, cairo_t $cr, num64 $x, num64 $y, num64 $width, num64 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_render_activity:
=begin pod
=head2 [gtk_] render_activity

Renders an activity indicator (such as in B<Gnome::Gtk3::Spinner>).
The state C<GTK_STATE_FLAG_CHECKED> determines whether there is
activity going on.

Since: 3.0

  method gtk_render_activity ( N-GObject $context, cairo_t $cr, Num $x, Num $y, Num $width, Num $height )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item Num $x; X origin of the rectangle
=item Num $y; Y origin of the rectangle
=item Num $width; rectangle width
=item Num $height; rectangle height

=end pod

sub gtk_render_activity ( N-GObject $context, cairo_t $cr, num64 $x, num64 $y, num64 $width, num64 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_render_icon:
=begin pod
=head2 [gtk_] render_icon

Renders the icon in I<pixbuf> at the specified I<x> and I<y> coordinates.

This function will render the icon in I<pixbuf> at exactly its size,
regardless of scaling factors, which may not be appropriate when
drawing on displays with high pixel densities.

You probably want to use C<gtk_render_icon_surface()> instead, if you
already have a Cairo surface.

Since: 3.2

  method gtk_render_icon ( N-GObject $context, cairo_t $cr, N-GObject $pixbuf, Num $x, Num $y )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item N-GObject $pixbuf; a B<Gnome::Gdk3::Pixbuf> containing the icon to draw
=item Num $x; X position for the I<pixbuf>
=item Num $y; Y position for the I<pixbuf>

=end pod

sub gtk_render_icon ( N-GObject $context, cairo_t $cr, N-GObject $pixbuf, num64 $x, num64 $y )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_render_icon_surface:
=begin pod
=head2 [[gtk_] render_] icon_surface

Renders the icon in I<surface> at the specified I<x> and I<y> coordinates.

Since: 3.10

  method gtk_render_icon_surface ( N-GObject $context, cairo_t $cr, cairo_surface_t $surface, Num $x, Num $y )

=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item cairo_t $cr; a I<cairo_t>
=item cairo_surface_t $surface; a I<cairo_surface_t> containing the icon to draw
=item Num $x; X position for the I<icon>
=item Num $y; Y position for the I<incon>

=end pod

sub gtk_render_icon_surface ( N-GObject $context, cairo_t $cr, cairo_surface_t $surface, num64 $x, num64 $y )
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_render_insertion_cursor:
=begin pod
=head2 [gtk_] render_insertion_cursor

Draws a text caret on I<cr> at the specified index of I<layout>.

Since: 3.4

  method gtk_render_insertion_cursor ( cairo_t $cr, Num $x, Num $y, PangoLayout $layout, int32 $index, PangoDirection $direction )

=item cairo_t $cr; a C<cairo_t>
=item Num $x; X origin
=item Num $y; Y origin
=item PangoLayout $layout; the C<PangoLayout> of the text
=item int32 $index; the index in the C<PangoLayout>
=item PangoDirection $direction; the C<PangoDirection> of the text

=end pod

sub gtk_render_insertion_cursor ( N-GObject $context, cairo_t $cr, num64 $x, num64 $y, PangoLayout $layout, int32 $index, PangoDirection $direction )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=begin comment

=head1 Not yet implemented methods

=head3 method gtk_style_context_get_style ( ... )
=head3 method gtk_render_check ( ... )
=head3 method gtk_render_option ( ... )
=head3 method gtk_render_arrow ( ... )
=head3 method gtk_render_background ( ... )
=head3 method gtk_render_frame ( ... )
=head3 method gtk_render_expander ( ... )
=head3 method gtk_render_focus ( ... )
=head3 method gtk_render_layout ( ... )
=head3 method gtk_render_line ( ... )
=head3 method gtk_render_slider ( ... )
=head3 method gtk_render_extension ( ... )
=head3 method gtk_render_handle ( ... )
=head3 method gtk_render_activity ( ... )
=head3 method gtk_render_icon ( ... )
=head3 method gtk_render_icon_surface ( ... )
=head3 method gtk_render_insertion_cursor ( ... )
=head3 method  ( ... )
=head3 method  ( ... )
=head3 method  ( ... )
=head3 method  ( ... )
=head3 method  ( ... )
=head3 method  ( ... )

=end comment
=end pod

#-------------------------------------------------------------------------------
=begin pod
=begin comment

=head1 Not implemented methods

=head3 method gtk_style_context_get_valist ( ... )
=head3 method gtk_style_context_get ( ... )
=head3 method gtk_style_context_get_style_valist ( ... )
=head3 method  ( ... )
=head3 method  ( ... )
=head3 method  ( ... )
=head3 method  ( ... )

=end comment
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 List of deprecated (not implemented!) methods

=head2 Since 3.4
=head3 method gtk_draw_insertion_cursor ( ... )

=head2 Since 3.6
=head3 method gtk_style_context_state_is_running ( ... )
=head3 method gtk_style_context_notify_state_change ( ... )
=head3 method gtk_style_context_cancel_animations ( ... )
=head3 method gtk_style_context_scroll_animations ( ... )
=head3 method gtk_style_context_push_animatable_region ( ... )
=head3 method gtk_style_context_pop_animatable_region ( ... )

=head2 Since 3.8.
=head3 method gtk_style_context_set_direction ( ... )
=head3 method gtk_style_context_get_direction ( ... )
=head3 method PangoFontDescription ( ... )

=head2 Since 3.10
=head3 method gtk_icon_set_render_icon_pixbuf ( ... )
=head3 method gtk_icon_set_render_icon_surface ( ... )
=head3 method gtk_style_context_lookup_icon_set ( ... )
=head3 method gtk_render_icon_pixbuf ( ... )

=head2 Since 3.12
=head3 method gtk_style_context_invalidate ( ... )

=head2 Since 3.14
=head3 method gtk_style_context_list_regions ( ... )
=head3 method gtk_style_context_add_region ( ... )
=head3 method gtk_style_context_remove_region ( ... )
=head3 method gtk_style_context_has_region ( ... )

=head2 Since 3.16.
=head3 method gtk_style_context_get_background_color ( ... )
=head3 method gtk_style_context_get_border_color ( ... )

=head2 Since 3.18.
=head3 method gtk_style_context_set_background ( ... )

=head2 Since 3.24.
=head3 method gtk_render_frame_gap ( ... )
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also B<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., :$user-optionN
  )

=begin comment
=head2 Supported signals
=head2 Unsupported signals
=end comment

=head2 Not yet supported signals


=head3 changed

The sig I<changed> signal is emitted when there is a change in the
B<Gnome::Gtk3::StyleContext>.

For a B<Gnome::Gtk3::StyleContext> returned by C<gtk_widget_get_style_context()>, the
sig C<style-updated> signal/vfunc might be more convenient to use.

This signal is useful when using the theming layer standalone.

Since: 3.0

  method handler (
    :$user-option1, ..., :$user-optionN
  );


=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=begin comment

=head2 Supported properties

=head2 Unsupported properties

=end comment

=head2 Not yet supported properties

=head3 parent

The B<Gnome::GObject::Value> type of property I<parent> is C<G_TYPE_OBJECT>.

Sets or gets the style context’s parent. See C<gtk_style_context_set_parent()>
for details.

Since: 3.4

=end pod
