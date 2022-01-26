use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::StyleProvider

Interface to provide style information to B<Gnome::Gtk3::StyleContext>

=head1 Description

B<Gnome::Gtk3::StyleProvider> is an interface used to provide style information to a B<Gnome::Gtk3::StyleContext>. See C<gtk_style_context_add_provider()> and C<gtk_style_context_add_provider_for_screen()>.


=head2 See Also

B<Gnome::Gtk3::StyleContext>, B<Gnome::Gtk3::CssProvider>

=head1 Synopsis
=head2 Declaration

  unit role Gnome::Gtk3::StyleProvider;


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;

#-------------------------------------------------------------------------------
# Note that enums must be kept outside roles
=begin pod
=head1 Types
=end pod

#`{{
=begin pod
=head2 class GtkStyleProviderIface

=item ___get_style: Gets a set of style information that applies to a widget path.
=item ___get_style_property: Gets the value of a widget style property that applies to a widget path.
=item ___get_icon_factory: Gets the icon factory that applies to a widget path.


=end pod

class GtkStyleProviderIface is export is repr('CStruct') {
  has GTypeInterface $.g_iface;
  has N-GObject $.path);
  has N-GObject $.value);
  has N-GObject $.path);
}
}}

#-------------------------------------------------------------------------------
# In c-source they are defined with '#define' not as an enum
=begin pod
=head2 enum GtkStyleProviderPriority

=item GTK_STYLE_PROVIDER_PRIORITY_FALLBACK(1): The priority used for default style information that is used in the absence of themes. Note that this is not very useful for providing default styling for custom style classes - themes are likely to override styling provided at this priority.

=item GTK_STYLE_PROVIDER_PRIORITY_THEME(200): The priority used for style information provided by themes.

=item GTK_STYLE_PROVIDER_PRIORITY_SETTINGS(400): The priority used for style information provided via Gnome::Gtk3::Settings. This priority is higher than GTK_STYLE_PROVIDER_PRIORITY_THEME to let settings override themes.

=item GTK_STYLE_PROVIDER_PRIORITY_APPLICATION(600): A priority that can be used when adding a #GtkStyleProvider for application-specific style information.

=item GTK_STYLE_PROVIDER_PRIORITY_USER(800): The priority used for the style information from `~/.gtk-3.0.css`. You should not use priorities higher than this, to give the user the last word.

=end pod

#TT:0:GtkStyleProviderPriority:
enum GtkStyleProviderPriority is export (
  GTK_STYLE_PROVIDER_PRIORITY_FALLBACK => 1,
  GTK_STYLE_PROVIDER_PRIORITY_THEME => 200,
  GTK_STYLE_PROVIDER_PRIORITY_SETTINGS => 400,
  GTK_STYLE_PROVIDER_PRIORITY_APPLICATION => 600,
  GTK_STYLE_PROVIDER_PRIORITY_USER => 800,
);

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit role Gnome::Gtk3::StyleProvider:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
#TM:1:new():interfacing
# interfaces are not instantiated
submethod BUILD ( *%options ) { }

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
# Hook for modules using this interface. Same principle as _fallback but
# does not need callsame. Also this method must be usable without
# an instated object
method _style_provider_interface ( Str $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_style_provider_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s
}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] style_provider_] get_style_property

Looks up a widget style property as defined by I<provider> for
the widget represented by I<path>.

Returns: C<1> if the property was found and has a value, C<0> otherwise

Since: 3.0

  method gtk_style_provider_get_style_property (
    N-GObject $path, GtkStateFlags $state, GParamSpec $pspec,
    N-GObject $value
    --> Int
  )

=item N-GObject $path; B<Gnome::Gtk3::WidgetPath> to query
=item GtkStateFlags $state; state to query the style property for
=item GParamSpec $pspec; The C<GParamSpec> to query
=item N-GObject $value; (out): return location for the property value

=end pod

sub gtk_style_provider_get_style_property ( N-GObject $provider, N-GObject $path, int32 $state, GParamSpec $pspec, N-GObject $value )
  returns int32
  is native(&gtk-lib)
  { * }
}}
