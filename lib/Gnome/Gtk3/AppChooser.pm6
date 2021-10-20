#TL:1:Gnome::Gtk3::AppChooser:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::AppChooser

Interface implemented by widgets for choosing an application


=comment ![](images/X.png)


=head1 Description

B<Gnome::Gtk3::AppChooser> is an interface that can be implemented by widgets which allow the user to choose an application (typically for the purpose of opening a file). The main objects that implement this interface are B<Gnome::Gtk3::AppChooserWidget>, B<Gnome::Gtk3::AppChooserDialog> and B<Gnome::Gtk3::AppChooserButton>.

Applications are represented by B<Gnome::Gio::AppInfo> objects here. GIO has a concept of recommended and fallback applications for a given content type. Recommended applications are those that claim to handle the content type itself, while fallback also includes applications that handle a more generic content type. GIO also knows the default and last-used application for a given content type. The B<Gnome::Gtk3::AppChooserWidget> provides detailed control over whether the shown list of applications should include default, recommended or fallback applications.

To obtain the application that has been selected in a B<Gnome::Gtk3::AppChooser>, use C<get-app-info()>.


=head2 See Also

B<Gnome::Gio::AppInfo>


=head1 Synopsis

=head2 Declaration

  unit role Gnome::Gtk3::AppChooser;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;


#-------------------------------------------------------------------------------
unit role Gnome::Gtk3::AppChooser:auth<github:MARTIMM>:ver<0.1.0>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

# interfaces are not instantiated
#submethod BUILD ( *%options ) { }

#`{{
# All interface calls should become methods
#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _app_chooser_interface ( $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &:("gtk_app_chooser_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &:("gtk_$native-sub"); } unless ?$s;
  try { $s = &:($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s;
}
}}


#-------------------------------------------------------------------------------
# setup signals from interface
method _add_app_chooser_interface_signal_types ( Str $class-name ) {
}


#-------------------------------------------------------------------------------
#TM:0:get-app-info:
=begin pod
=head2 get-app-info

Returns the currently selected application.

Returns: a B<Gnome::Gtk3::AppInfo> for the currently selected application, or C<undefined> if none is selected. Free with C<g-object-unref()>

  method get-app-info ( --> GAppInfo )

=end pod

method get-app-info ( --> GAppInfo ) {

  gtk_app_chooser_get_app_info(
    self._f('GtkAppChooser'),
  )
}

sub gtk_app_chooser_get_app_info (
  N-GObject $self --> GAppInfo
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-content-type:
=begin pod
=head2 get-content-type

Returns the current value of the  I<content-type> property.

Returns: the content type of I<self>. Free with C<g-free()>

  method get-content-type ( --> Str )

=end pod

method get-content-type ( --> Str ) {

  gtk_app_chooser_get_content_type(
    self._f('GtkAppChooser'),
  )
}

sub gtk_app_chooser_get_content_type (
  N-GObject $self --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:refresh:
=begin pod
=head2 refresh

Reloads the list of applications.

  method refresh ( )

=end pod

method refresh ( ) {

  gtk_app_chooser_refresh(
    self._f('GtkAppChooser'),
  );
}

sub gtk_app_chooser_refresh (
  N-GObject $self
) is native(&gtk-lib)
  { * }
