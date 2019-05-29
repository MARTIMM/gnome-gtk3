use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::AboutDialog

=SUBTITLE AboutDialog — Display information about an application

  unit class Gnome::Gtk3::AboutDialog;
  also is Gnome::Gtk3::Dialog;

=head1 Synopsis

  my Gnome::Gtk3::AboutDialog $about .= new(:empty);
  $about.set-program-name('My-First-GTK-Program');

  # Show the dialog.The status can be tested for which button was pressed
  my Int $return-status = $about.gtk-dialog-run;

  # When dialog buttons are pressed control returns here.
  # Hide the dialog again.
  $about.gtk-widget-hide;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Dialog;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkaboutdialog.h
# https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html
unit class Gnome::Gtk3::AboutDialog:auth<github:MARTIMM>;
also is Gnome::Gtk3::Dialog;

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

  multi method new ( Bool :$empty! )

Create an empty about dialog

  multi method new ( :$widget! )

Create an about dialog using a native object from elsewhere. See also ::V3::Glib::GObject.

  multi method new ( Str :$build-id! )

Create an about dialog using a native object from a builder. See also Gnome::GObject::Object.

=end pod

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :strretbool<activate-link>,    # returns bool
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::AboutDialog';

  if ? %options<empty> {
    self.native-gobject(gtk_about_dialog_new());
  }

  elsif ? %options<widget> || %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_about_dialog_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod

=head2 gtk_about_dialog_new

  method gtk_about_dialog_new ( --> N-GObject )

Creates a new empty about dialog widget. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-new>.
Better, shorter and easier is to use C<.new(:empty)>. See info for C<new()>.
=end pod

sub gtk_about_dialog_new ( )
  returns N-GObject       # GtkAboutDialog
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_program_name

  method gtk_about_dialog_get_program_name ( --> Str )

Get the program name from the dialog. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-program-name>.
=end pod

sub gtk_about_dialog_get_program_name ( N-GObject $dialog )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_program_name

  method gtk_about_dialog_set_program_name ( Str $pname )

Set the program name in the about dialog. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-program-name>.
=end pod

sub gtk_about_dialog_set_program_name ( N-GObject $dialog, Str $pname )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_version

  method gtk_about_dialog_get_version ( --> Str )

Get the version. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-version>.
=end pod

sub gtk_about_dialog_get_version ( N-GObject $dialog )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_version

  method gtk_about_dialog_set_version ( Str $version )

Set version. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-version>.
=end pod

sub gtk_about_dialog_set_version ( N-GObject $dialog, Str $version )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_copyright

  method gtk_about_dialog_get_copyright

Get copyright. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-copyright>.
=end pod

sub gtk_about_dialog_get_copyright ( N-GObject $dialog )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod

=head2 [gtk_about_dialog_] set_copyright

  method gtk_about_dialog_set_copyright

Set copyright. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-copyright>.
=end pod

sub gtk_about_dialog_set_copyright ( N-GObject $dialog, Str $copyright )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod

=head2 [gtk_about_dialog_] get_comments

  method gtk_about_dialog_get_comments

Get comments. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-comments>.
=end pod

sub gtk_about_dialog_get_comments ( N-GObject $dialog )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_comments

  method gtk_about_dialog_set_comments

Set comments. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-comments>.
=end pod

sub gtk_about_dialog_set_comments ( N-GObject $dialog, Str $comments )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_license

  method gtk_about_dialog_get_license

Get license. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-license>.
=end pod

sub gtk_about_dialog_get_license ( N-GObject $dialog )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_license

  method gtk_about_dialog_set_license

Set license. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-license>.
=end pod

sub gtk_about_dialog_set_license ( N-GObject $dialog, Str $license )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_wrap_license

  method gtk_about_dialog_get_wrap_license

Return 1 if license is wrapped. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-wrap-license>.
=end pod

sub gtk_about_dialog_get_wrap_license ( N-GObject $dialog )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_wrap_license

  method gtk_about_dialog_set_wrap_license

Sets whether the license text in about is automatically wrapped. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-wrap-license>.
=end pod

sub gtk_about_dialog_set_wrap_license ( N-GObject $dialog, int32 $wrap_license )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_license_type

  method gtk_about_dialog_get_license_type

Get license type. This is an integer representing GtkLicense described above.
Example;

  my Int $lt = $dialog.get_license_type;
  say "License type: ", GtkLicense($lt);

See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-license-type>.
=end pod

sub gtk_about_dialog_get_license_type ( N-GObject $dialog )
  returns int32 # GtkLicense
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_license_type

  method gtk_about_dialog_set_license_type

Set license type. E.g.

  $dialog.set_license_type(GTK_LICENSE_ARTISTIC);

See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-license-type>.
=end pod

sub gtk_about_dialog_set_license_type ( N-GObject $dialog, int32 $license_type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_website

  method gtk_about_dialog_get_website

Get website. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-website>.
=end pod

sub gtk_about_dialog_get_website ( N-GObject $dialog )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_website

  method gtk_about_dialog_set_website

Set website. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-website>.
=end pod

sub gtk_about_dialog_set_website ( N-GObject $dialog, Str $website )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_website_label

  method gtk_about_dialog_get_website_label

Returns the label used for the website link. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-website-label>.
=end pod

sub gtk_about_dialog_get_website_label ( N-GObject $dialog )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_website_label

  method gtk_about_dialog_set_website_label

Set website label. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-website-label>.
=end pod

sub gtk_about_dialog_set_website_label ( N-GObject $dialog, Str $website_label )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_authors

  method gtk_about_dialog_get_authors

Get list of authors. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-authors>.
=end pod

sub gtk_about_dialog_get_authors ( N-GObject $dialog )
  returns CArray[Str]
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_authors

  method gtk_about_dialog_set_authors

Set auhors. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-authors>.
=end pod

sub gtk_about_dialog_set_authors ( N-GObject $dialog, CArray[Str] $authors )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_artists

  method gtk_about_dialog_get_artists

Get artists. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-artists>.
=end pod

sub gtk_about_dialog_get_artists ( N-GObject $dialog )
  returns CArray[Str]
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_artists

  method gtk_about_dialog_set_artists

Set artists. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-artists>.
=end pod

sub gtk_about_dialog_set_artists ( N-GObject $dialog, CArray[Str] $artists )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_documenters

  method gtk_about_dialog_get_documenters

Get documenters. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-documenters>.
=end pod

sub gtk_about_dialog_get_documenters ( N-GObject $dialog )
  returns CArray[Str]
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_documenters

  method gtk_about_dialog_set_documenters

Set documenters. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-documenters>.
=end pod

sub gtk_about_dialog_set_documenters (
  N-GObject $dialog, CArray[Str] $documenters
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_translator_credits

  method gtk_about_dialog_get_translator_credits

Get translator credits See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-translator-credits>.
=end pod

sub gtk_about_dialog_get_translator_credits ( N-GObject $dialog )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_translator_credits

  method gtk_about_dialog_set_translator_credits

Set translator credits See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-translator-credits>.
=end pod

sub gtk_about_dialog_set_translator_credits (
  N-GObject $dialog , Str $translator_credits
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_logo

  method gtk_about_dialog_get_logo

Get pixel buffer of logo. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-logo>.
=end pod

sub gtk_about_dialog_get_logo ( N-GObject $dialog )
  returns OpaquePointer # GdkPixbuf
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_logo

  method gtk_about_dialog_set_logo ( OpaquePointer $logo-pixbuf )

Set the logo from a pixel buffer. E.g.

  my Gnome::Gtk3::Image $logo .= new(
    :filename(%?RESOURCES<library-logo.png>.Str)
  );
  $about-dialog.set-logo($logo.get-pixbuf);

See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-logo>.
=end pod

sub gtk_about_dialog_set_logo ( N-GObject $dialog, OpaquePointer $logo-pixbuf )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_logo_icon_name

  method gtk_about_dialog_get_logo_icon_name

Get name of logo icon. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-get-logo-icon-name>.
=end pod

sub gtk_about_dialog_get_logo_icon_name ( N-GObject $dialog )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_logo_icon_name

  method gtk_about_dialog_set_logo_icon_name

Set name of logo icon. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-set-logo-icon-name>.
=end pod

sub gtk_about_dialog_set_logo_icon_name ( N-GObject $dialo, Str $icon_name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] add_credit_section

  method gtk_about_dialog_add_credit_section

Add credit section. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html#gtk-about-dialog-add-credit-section>.
=end pod

sub gtk_about_dialog_add_credit_section (
  N-GObject $dialo, Str $section_name, CArray[Str] $people
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod

=head1 Types

=head2 enum GtkLicense

A series of names to set the license type.
=item GTK_LICENSE_UNKNOWN; No license specified
=item GTK_LICENSE_CUSTOM; A license text is going to be specified by the developer
=item GTK_LICENSE_GPL_2_0; The GNU General Public License, version 2.0 or later
=item GTK_LICENSE_GPL_3_0; The GNU General Public License, version 3.0 or later
=item GTK_LICENSE_LGPL_2_1; The GNU Lesser General Public License, version 2.1 or later
=item GTK_LICENSE_LGPL_3_0; The GNU Lesser General Public License, version 3.0 or later
=item GTK_LICENSE_BSD; The BSD standard license
=item GTK_LICENSE_MIT_X11; The MIT/X11 standard license
=item GTK_LICENSE_ARTISTIC; The Artistic License, version 2.0
=item GTK_LICENSE_GPL_2_0_ONLY; The GNU General Public License, version 2.0 only. Since 3.12.
=item GTK_LICENSE_GPL_3_0_ONLY; The GNU General Public License, version 3.0 only. Since 3.12.
=item GTK_LICENSE_LGPL_2_1_ONLY; The GNU Lesser General Public License, version 2.1 only. Since 3.12.
=item GTK_LICENSE_LGPL_3_0_ONLY; The GNU Lesser General Public License, version 3.0 only. Since 3.12.
=item GTK_LICENSE_AGPL_3_0; The GNU Affero General Public License, version 3.0 or later. Since: 3.22.
=item GTK_LICENSE_AGPL_3_0_ONLY; The GNU Affero General Public License, version 3.0 only. Since: 3.22.27.

See C<gtk_about_dialog_get_license_type> for an example.
=end pod

enum GtkLicense is export <
  GTK_LICENSE_UNKNOWN
  GTK_LICENSE_CUSTOM

  GTK_LICENSE_GPL_2_0
  GTK_LICENSE_GPL_3_0
  GTK_LICENSE_LGPL_2_1
  GTK_LICENSE_LGPL_3_0

  GTK_LICENSE_BSD
  GTK_LICENSE_MIT_X11

  GTK_LICENSE_ARTISTIC

  GTK_LICENSE_GPL_2_0_ONLY
  GTK_LICENSE_GPL_3_0_ONLY
  GTK_LICENSE_LGPL_2_1_ONLY
  GTK_LICENSE_LGPL_3_0_ONLY

  GTK_LICENSE_AGPL_3_0
  GTK_LICENSE_AGPL_3_0_ONLY
>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

=head2 Not yet supported signals
=head3 activate-link

The signal which gets emitted to activate a URI. Applications may connect to it to override the default behaviour, which is to call gtk_show_uri_on_window().

=end pod
