use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::AboutDialog

=SUBTITLE Display information about an application

=head1 Description


The C<Gnome::Gtk3::AboutDialog> offers a simple way to display information about
a program like its logo, name, copyright, website and license. It is
also possible to give credits to the authors, documenters, translators
and artists who have worked on the program. An about dialog is typically
opened when the user selects the `About` option from the `Help` menu.
All parts of the dialog are optional.

About dialogs often contain links and email addresses. C<Gnome::Gtk3::AboutDialog>
displays these as clickable links. By default, it calls gtk_show_uri()
when a user clicks one. The behaviour can be overridden with the
C<Gnome::Gtk3::AboutDialog>::activate-link signal.

To specify a person with an email address, use a string like
"Edgar Allan Poe <edgarI<poe>.com>". To specify a website with a title,
use a string like "GTK+ team http://www.gtk.org".

To make constructing a C<Gnome::Gtk3::AboutDialog> as convenient as possible, you can
use the function gtk_show_about_dialog() which constructs and shows a dialog
and keeps it around so that it can be shown again.

Note that GTK+ sets a default title of `_("About %s")` on the dialog
window (where \%s is replaced by the name of the application, but in
order to ensure proper translation of the title, applications should
set the title property explicitly when constructing a C<Gnome::Gtk3::AboutDialog>.
It is also possible to show a C<Gnome::Gtk3::AboutDialog> like any other C<Gnome::Gtk3::Dialog>, e.g. using gtk_dialog_run(). In this case, you might need to know that the “Close” button returns the C<GTK_RESPONSE_CANCEL> response id.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::AboutDialog;
  also is Gnome::Gtk3::Dialog;

=head1 Example

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
# no pod. user does not have to know about it.
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

Creates a new native widget.

  method gtk_about_dialog_new ( --> N-GObject )

Returns N-GObject;
=end pod

sub gtk_about_dialog_new ( )
  returns N-GObject       # GtkAboutDialog
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] gtk_show_about_dialog

This is a convenience function for showing an application’s about box. The constructed dialog is associated with the parent window and reused for future invocations of this function.

  method gtk_show_about_dialog ( N-GObject $parent, Str $first_property_name, G_GNUC_NULL_TERMINATED $... )

=item N-GObject $parent;
=item Str $first_property_name; (allow-none): transient parent, or Any for none
=item G_GNUC_NULL_TERMINATED $...; the name of the first property

=end pod

sub gtk_show_about_dialog ( N-GObject $parent, str $first_property_name, G_GNUC_NULL_TERMINATED $... )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_program_name

Returns the program name displayed in the about dialog.

  method gtk_about_dialog_get_program_name ( --> Str  )


Returns Str;
=end pod

sub gtk_about_dialog_get_program_name ( N-GObject $about )
  returns str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_program_name

Sets the name to display in the about dialog. If this is not set, it defaults to g_get_application_name().

  method gtk_about_dialog_set_program_name ( Str $name )

=item Str $name; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_program_name ( N-GObject $about, str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_version

Returns the version string.

  method gtk_about_dialog_get_version ( --> Str  )


Returns Str;
=end pod

sub gtk_about_dialog_get_version ( N-GObject $about )
  returns str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_version

Sets the version string to display in the about dialog.

  method gtk_about_dialog_set_version ( Str $version )

=item Str $version; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_version ( N-GObject $about, str $version )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_copyright

Returns the copyright string.

  method gtk_about_dialog_get_copyright ( --> Str  )


Returns Str;
=end pod

sub gtk_about_dialog_get_copyright ( N-GObject $about )
  returns str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_copyright

Sets the copyright string to display in the about dialog. This should be a short string of one or two lines.

  method gtk_about_dialog_set_copyright ( Str $copyright )

=item Str $copyright; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_copyright ( N-GObject $about, str $copyright )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_comments

Returns the comments string.

  method gtk_about_dialog_get_comments ( --> Str  )


Returns Str;
=end pod

sub gtk_about_dialog_get_comments ( N-GObject $about )
  returns str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_comments

Sets the comments string to display in the about dialog. This should be a short string of one or two lines.

  method gtk_about_dialog_set_comments ( Str $comments )

=item Str $comments; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_comments ( N-GObject $about, str $comments )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_license

Returns the license information.

  method gtk_about_dialog_get_license ( --> Str  )


Returns Str;
=end pod

sub gtk_about_dialog_get_license ( N-GObject $about )
  returns str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_license

Sets the license information to be displayed in the secondary license dialog. If I<license> is Any, the license button is hidden.

  method gtk_about_dialog_set_license ( Str $license )

=item Str $license; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_license ( N-GObject $about, str $license )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_license_type

Sets the license of the application showing the I<about> dialog from a list of known licenses.

  method gtk_about_dialog_set_license_type ( GtkLicense $license_type )

=item GtkLicense $license_type; a C<Gnome::Gtk3::AboutDialog>

=head3 Example

  $dialog.set_license_type(GTK_LICENSE_ARTISTIC);

=end pod

sub gtk_about_dialog_set_license_type ( N-GObject $about, int32 $license_type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_license_type

Retrieves the license set using gtk_about_dialog_set_license_type()

  method gtk_about_dialog_get_license_type ( --> GtkLicense  )

Returns GtkLicense;

=head3 Example

  my Int $lt = $dialog.get-license-type;
  say "License type: ", GtkLicense($lt);

=end pod

sub gtk_about_dialog_get_license_type ( N-GObject $about )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_wrap_license

Returns whether the license text in I<about> is automatically wrapped.

  method gtk_about_dialog_get_wrap_license ( --> Int  )


Returns Int;
=end pod

sub gtk_about_dialog_get_wrap_license ( N-GObject $about )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_wrap_license

Sets whether the license text in I<about> is automatically wrapped.

  method gtk_about_dialog_set_wrap_license ( Int $wrap_license )

=item Int $wrap_license; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_wrap_license ( N-GObject $about, int32 $wrap_license )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_website

Returns the website URL.

  method gtk_about_dialog_get_website ( --> Str  )


Returns Str;
=end pod

sub gtk_about_dialog_get_website ( N-GObject $about )
  returns str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_website

Sets the URL to use for the website link.

  method gtk_about_dialog_set_website ( Str $website )

=item Str $website; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_website ( N-GObject $about, str $website )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_website_label

Returns the label used for the website link.

  method gtk_about_dialog_get_website_label ( --> Str  )


Returns Str;
=end pod

sub gtk_about_dialog_get_website_label ( N-GObject $about )
  returns str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_website_label

Sets the label to be used for the website link.

  method gtk_about_dialog_set_website_label ( Str $website_label )

=item Str $website_label; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_website_label ( N-GObject $about, str $website_label )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 const



  method const ( gtk_about_dialog_get_authors $*GtkAboutDialog *about --> Int  )

=item gtk_about_dialog_get_authors $*GtkAboutDialog *about;

Returns Int;
=end pod

sub const ( gtk_about_dialog_get_authors $*GtkAboutDialog *about )
  returns int8
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_authors

Sets the strings which are displayed in the authors tab of the secondary credits dialog.

  method gtk_about_dialog_set_authors ( Str $*authors )

=item Str $*authors; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_authors ( N-GObject $about, str $*authors )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 const



  method const ( gtk_about_dialog_get_documenters $*GtkAboutDialog *about --> Int  )

=item gtk_about_dialog_get_documenters $*GtkAboutDialog *about;

Returns Int;
=end pod

sub const ( gtk_about_dialog_get_documenters $*GtkAboutDialog *about )
  returns int8
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_documenters

Sets the strings which are displayed in the documenters tab of the secondary credits dialog.

  method gtk_about_dialog_set_documenters ( Str $*documenters )

=item Str $*documenters; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_documenters ( N-GObject $about, str $*documenters )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 const



  method const ( gtk_about_dialog_get_artists $*GtkAboutDialog *about --> Int  )

=item gtk_about_dialog_get_artists $*GtkAboutDialog *about;

Returns Int;
=end pod

sub const ( gtk_about_dialog_get_artists $*GtkAboutDialog *about )
  returns int8
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_artists

Sets the strings which are displayed in the artists tab of the secondary credits dialog.

  method gtk_about_dialog_set_artists ( Str $*artists )

=item Str $*artists; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_artists ( N-GObject $about, str $*artists )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_translator_credits

Returns the translator credits string which is displayed in the translators tab of the secondary credits dialog.

  method gtk_about_dialog_get_translator_credits ( --> Str  )


Returns Str;
=end pod

sub gtk_about_dialog_get_translator_credits ( N-GObject $about )
  returns str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_translator_credits

Sets the translator credits string which is displayed in the translators tab of the secondary credits dialog.

  method gtk_about_dialog_set_translator_credits ( Str $translator_credits )

=item Str $translator_credits; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_translator_credits ( N-GObject $about, str $translator_credits )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_logo

Returns the pixbuf displayed as logo in the about dialog.

  method gtk_about_dialog_get_logo ( --> N-GObject  )


Returns N-GObject;
=end pod

sub gtk_about_dialog_get_logo ( N-GObject $about )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_logo

Sets the pixbuf to be displayed as logo in the about dialog. If it is Any, the default window icon set with gtk_window_set_default_icon() will be used.

  method gtk_about_dialog_set_logo ( N-GObject $logo )

=head3 Example

Set the logo from a pixel buffer. E.g.

  my Gnome::Gtk3::Image $logo .= new(
    :filename(%?RESOURCES<my-logo.png>.Str)
  );
  $about-dialog.set-logo($logo.get-pixbuf);

=item N-GObject $logo; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_logo ( N-GObject $about, N-GObject $logo )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] get_logo_icon_name

Returns the icon name displayed as logo in the about dialog.

  method gtk_about_dialog_get_logo_icon_name ( --> Str  )


Returns Str;
=end pod

sub gtk_about_dialog_get_logo_icon_name ( N-GObject $about )
  returns str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] set_logo_icon_name

Sets the pixbuf to be displayed as logo in the about dialog. If it is Any, the default window icon set with gtk_window_set_default_icon() will be used.

  method gtk_about_dialog_set_logo_icon_name ( Str $icon_name )

=item Str $icon_name; a C<Gnome::Gtk3::AboutDialog>

=end pod

sub gtk_about_dialog_set_logo_icon_name ( N-GObject $about, str $icon_name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_about_dialog_] add_credit_section

Creates a new section in the Credits page.

  method gtk_about_dialog_add_credit_section ( Str $section_name, Str $*people )

=item Str $section_name; A C<Gnome::Gtk3::AboutDialog>
=item Str $*people; The name of the section

=end pod

sub gtk_about_dialog_add_credit_section ( N-GObject $about, str $section_name, str $*people )
  is native(&gtk-lib)
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
