use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::StyleProvider

=SUBTITLE Interface to provide style information to C<Gnome::Gtk3::StyleContext>

=head1 Description

C<Gnome::Gtk3::StyleProvider> is an interface used to provide style information to a C<Gnome::Gtk3::StyleContext>. See C<gtk_style_context_add_provider()> and C<gtk_style_context_add_provider_for_screen()>.

=head2 See Also

C<Gnome::Gtk3::StyleContext>, C<Gnome::Gtk3::CssProvider>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::StyleProvider;
  also is Gnome::GObject::Interface;

=head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Interface;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::StyleProvider:auth<github:MARTIMM>;
also is Gnome::GObject::Interface;

#-------------------------------------------------------------------------------
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
#my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  #$signals-added = self.add-signal-types( $?CLASS.^name,
  #  # ... :type<signame>
  #) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::StyleProvider';

  # process all named arguments
  if ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkStyleProvider');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_style_provider_$native-sub"); } unless ?$s;

  self.set-class-name-of-sub('GtkStyleProvider');
  $s = callsame unless ?$s;

  $s;
}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_style_provider_] get_style_property

Looks up a widget style property as defined by I<provider> for
the widget represented by I<path>.

Returns: C<1> if the property was found and has a value, C<0> otherwise

Since: 3.0

  method gtk_style_provider_get_style_property (
    N-GObject $path, GtkStateFlags $state, GParamSpec $pspec,
    N-GObject $value
    --> Int
  )

=item N-GObject $path; C<Gnome::Gtk3::WidgetPath> to query
=item GtkStateFlags $state; state to query the style property for
=item GParamSpec $pspec; The C<GParamSpec> to query
=item N-GObject $value; (out): return location for the property value

=end pod

sub gtk_style_provider_get_style_property ( N-GObject $provider, N-GObject $path, int32 $state, GParamSpec $pspec, N-GObject $value )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=begin comment

=head1 Not yet implemented methods

=head3 method gtk_style_provider_get_style_property ( ... )

=end comment
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 List of deprecated (not implemented!) methods

=head2 Since 3.8
=head3 method gtk_style_provider_get_style ( ... )
=head3 method gtk_style_provider_get_icon_factory ( ... )
=end pod
