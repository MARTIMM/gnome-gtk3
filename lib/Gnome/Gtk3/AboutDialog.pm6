#TL:1:Gnome::Gtk3::AboutDialog:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::AboutDialog

Display information about an application

![](images/aboutdialog.png)

=head1 Description

The B<Gnome::Gtk3::AboutDialog> offers a simple way to display information about a program like its logo, name, copyright, website and license. It is also possible to give credits to the authors, documenters, translators and artists who have worked on the program. An about dialog is typically opened when the user selects the `About` option from the `Help` menu. All parts of the dialog are optional.

About dialogs often contain links and email addresses. B<Gnome::Gtk3::AboutDialog> displays these as clickable links. By default, it calls gtk_show_uri() when a user clicks one. The behavior can be overridden with the C<activate-link> signal.

To specify a person with an email address, use a string like "Edgar Allan Poe <edgar@poe.com>". To specify a website with a title, use a string like "GTK+ team http://www.gtk.org".

To make constructing a B<Gnome::Gtk3::AboutDialog> as convenient as possible, you can use the function C<gtk_show_about_dialog()> which constructs and shows a dialog and keeps it around so that it can be shown again.

Note that GTK+ sets a default title of `_("About %s")` on the dialog window (where \%s is replaced by the name of the application, but in order to ensure proper translation of the title, applications should set the title property explicitly when constructing a B<Gnome::Gtk3::AboutDialog>.

It is also possible to show a B<Gnome::Gtk3::AboutDialog> like any other B<Gnome::Gtk3::Dialog>, e.g. C<using gtk_dialog_run()>. In this case, you might need to know that the “Close” button returns the C<GTK_RESPONSE_CANCEL> response id.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::AboutDialog;
  also is Gnome::Gtk3::Dialog;


=head2 Uml Diagram

![](plantuml/AboutDialog.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::AboutDialog;

  unit class MyGuiClass;
  also is Gnome::Gtk3::AboutDialog;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::AboutDialog class process the options
    self.bless( :GtkAboutDialog, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=head1 Example

  my Gnome::Gtk3::AboutDialog $about .= new;

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
use Gnome::N::GlibToRakuTypes;

use Gnome::Gdk3::Pixbuf;

use Gnome::Gtk3::Dialog;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkaboutdialog.h
# https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html
unit class Gnome::Gtk3::AboutDialog:auth<github:MARTIMM>;
also is Gnome::Gtk3::Dialog;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types

=head2 enum GtkLicense

The type of license for an application. This enumeration can be expanded at later date.

=item GTK_LICENSE_UNKNOWN: No license specified
=item GTK_LICENSE_CUSTOM: A license text is going to be specified by the developer
=item GTK_LICENSE_GPL_2_0: The GNU General Public License, version 2.0 or later
=item GTK_LICENSE_GPL_3_0: The GNU General Public License, version 3.0 or later
=item GTK_LICENSE_LGPL_2_1: The GNU Lesser General Public License, version 2.1 or later
=item GTK_LICENSE_LGPL_3_0: The GNU Lesser General Public License, version 3.0 or later
=item GTK_LICENSE_BSD: The BSD standard license
=item GTK_LICENSE_MIT_X11: The MIT/X11 standard license
=item GTK_LICENSE_ARTISTIC: The Artistic License, version 2.0
=item GTK_LICENSE_GPL_2_0_ONLY: The GNU General Public License, version 2.0 only. Since 3.12.
=item GTK_LICENSE_GPL_3_0_ONLY: The GNU General Public License, version 3.0 only. Since 3.12.
=item GTK_LICENSE_LGPL_2_1_ONLY: The GNU Lesser General Public License, version 2.1 only. Since 3.12.
=item GTK_LICENSE_LGPL_3_0_ONLY: The GNU Lesser General Public License, version 3.0 only. Since 3.12.
=item GTK_LICENSE_AGPL_3_0: The GNU Affero General Public License, version 3.0 or later. Since: 3.22.
=item GTK_LICENSE_AGPL_3_0_ONLY: The GNU Affero General Public License, version 3.0 only. Since: 3.22.27.

=end pod

#TE:1:GtkLicense:
enum GtkLicense is export <
  GTK_LICENSE_UNKNOWN   GTK_LICENSE_CUSTOM   GTK_LICENSE_GPL_2_0
  GTK_LICENSE_GPL_3_0   GTK_LICENSE_LGPL_2_1 GTK_LICENSE_LGPL_3_0
  GTK_LICENSE_BSD       GTK_LICENSE_MIT_X11  GTK_LICENSE_ARTISTIC
  GTK_LICENSE_GPL_2_0_ONLY   GTK_LICENSE_GPL_3_0_ONLY
  GTK_LICENSE_LGPL_2_1_ONLY  GTK_LICENSE_LGPL_3_0_ONLY
  GTK_LICENSE_AGPL_3_0       GTK_LICENSE_AGPL_3_0_ONLY
>;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Creates a new B<Gnome::Gtk3::AboutDialog>.

  multi method new ( )

=head3 :native-object

Create an object using a native object from elsewhere. See also B<Gnome::N::TopLevelSupportClass>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:4:new(:native-object):TopLevelSupportClass
#TM:4:new(:build-id):Object

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w1<activate-link>,    # returns bool
  ) unless $signals-added;

  # prevent creating wrong widgets
  if self.^name eq 'Gnome::Gtk3::AboutDialog' or %options<GtkAboutDialog> {

    if self.is-valid { }

    # process all named arguments
    elsif %options<native-object>:exists or %options<widget>:exists or
      %options<build-id>:exists { }

    else {
      my $no;

      $no = _gtk_about_dialog_new();

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkAboutDialog');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_about_dialog_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_about_dialog_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); };
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('about-dialog-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-about-dialog-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

#note "ad $native-sub: ", $s.signature if ?$s;
  self._set-class-name-of-sub('GtkAboutDialog');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:add-credit-section:
=begin pod
=head2 add-credit-section

Creates a new section in the Credits page.

  method add-credit-section (
    Str $section_name, *@people
  )

=item $section_name; The name of the section
=item @people; A list of people who belong to that section

=end pod

method add-credit-section ( Str $section_name, *@people ) {
  my $people = gchar-pptr.new( |@people, Str);
  _gtk_about_dialog_add_credit_section(
    self._get-native-object-no-reffing, $section_name, $people
  );
}

sub gtk_about_dialog_add_credit_section (
  N-GObject $about, gchar-ptr $section_name, *@people
) {
  my $people = gchar-pptr.new( |@people, Str);
  _gtk_about_dialog_add_credit_section( $about, $section_name, $people);
}

sub _gtk_about_dialog_add_credit_section (
  N-GObject $about, gchar-ptr $section_name, gchar-pptr $people
) is symbol('gtk_about_dialog_add_credit_section')
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-artists:
=begin pod
=head2 get-artists

Returns the string which are displayed in the artists tab of the secondary credits dialog.

Returns: A string array containing the artists.

  method get-artists ( --> Array )

=end pod

method get-artists ( --> Array ) {
  my gchar-pptr $artists = _gtk_about_dialog_get_artists(
    self._get-native-object-no-reffing
  );
  my @artists = ();
  my Int $i = 0;
  while $artists[$i].defined {
    @artists.push: $artists[$i++];
  }

  @artists
}

sub gtk_about_dialog_get_artists ( N-GObject $about --> Array ) {
  my gchar-pptr $artists = _gtk_about_dialog_get_artists($about);
  my @artists = ();
  my Int $i = 0;
  while $artists[$i].defined {
    @artists.push: $artists[$i++];
  }

  @artists
}

sub _gtk_about_dialog_get_artists ( N-GObject $about --> gchar-pptr )
  is native(&gtk-lib)
  is symbol('gtk_about_dialog_get_artists')
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-authors:
=begin pod
=head2 get-authors

Returns the string which are displayed in the authors tab of the secondary credits dialog.

Returns: An array containing the authors.

  method get-authors ( --> Array )

=end pod

method get-authors ( --> Array ) {
  my $authors = _gtk_about_dialog_get_authors(
    self._get-native-object-no-reffing
  );
  my @authors = ();
  my Int $i = 0;
  while $authors[$i].defined {
    @authors.push: $authors[$i++];
  }

  @authors
}

sub gtk_about_dialog_get_authors ( N-GObject $about --> Array ) {
  my $authors = _gtk_about_dialog_get_authors($about);
  my @authors = ();
  my Int $i = 0;
  while $authors[$i].defined {
    @authors.push: $authors[$i++];
  }

  @authors
}

sub _gtk_about_dialog_get_authors ( N-GObject $about --> gchar-pptr )
  is native(&gtk-lib)
  is symbol('gtk_about_dialog_get_authors')
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-comments:
=begin pod
=head2 get-comments

Returns the comments string. The string is owned by the about dialog and must not be modified.

  method get-comments ( --> Str )

=end pod

method get-comments ( --> Str ) {
  gtk_about_dialog_get_comments(
    self._get-native-object-no-reffing
  )
}

sub gtk_about_dialog_get_comments ( N-GObject $about --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-copyright:
=begin pod
=head2 get-copyright

Returns the copyright string.

Returns: The copyright string. The string is owned by the about dialog and must not be modified.

  method get-copyright ( --> Str )

=end pod

method get-copyright ( ) {
  gtk_about_dialog_get_copyright(self._get-native-object-no-reffing)
}

sub gtk_about_dialog_get_copyright ( N-GObject $about --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-documenters:
=begin pod
=head2 get-documenters

Returns the string which are displayed in the documenters tab of the secondary credits dialog.

Returns: An array containing the documenters

  method get-documenters ( --> Array )

=end pod

method get-documenters ( --> Array ) {
  my gchar-pptr $documenters = _gtk_about_dialog_get_documenters(
    self._get-native-object-no-reffing
  );
  my @documenters = ();
  my Int $i = 0;
  while $documenters[$i].defined {
    @documenters.push: $documenters[$i++];
  }

  @documenters
}

sub gtk_about_dialog_get_documenters ( N-GObject $about --> Array ) {
  my gchar-pptr $documenters = _gtk_about_dialog_get_documenters($about);
  my @documenters = ();
  my Int $i = 0;
  while $documenters[$i].defined {
    @documenters.push: $documenters[$i++];
  }

  @documenters
}

sub _gtk_about_dialog_get_documenters ( N-GObject $about --> gchar-pptr )
  is native(&gtk-lib)
  is symbol('gtk_about_dialog_get_documenters')
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-license:
=begin pod
=head2 get-license

Returns the license information.The string is owned by the about dialog and must not be modified.

  method get-license ( --> Str )

=end pod

method get-license ( --> Str ) {
  gtk_about_dialog_get_license(
    self._get-native-object-no-reffing
  )
}

sub gtk_about_dialog_get_license ( N-GObject $about --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-license-type:
=begin pod
=head2 get-license-type

Retrieves the license set using C<set_license_type()>. Returns a I<GtkLicense> value.

  method get-license-type ( --> GtkLicense  )

=end pod

method get-license-type ( --> GtkLicense ) {
  GtkLicense(
    _gtk_about_dialog_get_license_type(self._get-native-object-no-reffing)
  );
}

sub gtk_about_dialog_get_license_type ( N-GObject $about --> GtkLicense ) {
  GtkLicense(_gtk_about_dialog_get_license_type($about));
}

sub _gtk_about_dialog_get_license_type ( N-GObject $about --> gint )
  is native(&gtk-lib)
  is symbol('gtk_about_dialog_get_license_type')
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-logo:
=begin pod
=head2 get-logo

Returns the pixbuf displayed as logo in the about dialog.

Returns: the pixbuf displayed as logo. The pixbuf is owned by the about dialog. If you want to keep a reference to it, you have to call C<g_object_ref()> on it.

  method get-logo ( --> N-GObject  )

=end pod

method get-logo ( --> N-GObject ) {
  gtk_about_dialog_get_logo(self._get-native-object-no-reffing)
}

sub gtk_about_dialog_get_logo ( N-GObject $about --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-logo-icon-name:
=begin pod
=head2 get-logo-icon-name

Returns the icon name displayed as logo in the about dialog.

Returns: the icon name displayed as logo.

  method get-logo-icon-name ( --> Str )

=end pod

method get-logo-icon-name ( --> Str ) {
  gtk_about_dialog_get_logo_icon_name(self._get-native-object-no-reffing)
}

sub gtk_about_dialog_get_logo_icon_name ( N-GObject $about --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-program-name:
=begin pod
=head2 get-program-name

Returns the program name displayed in the about dialog.

Returns: The program name. The string is owned by the about dialog and must not be modified.

  method get-program-name ( --> Str )

=end pod

method get-program-name ( --> gchar-ptr ) {
  gtk_about_dialog_get_program_name(self._get-native-object-no-reffing)
}

sub gtk_about_dialog_get_program_name ( N-GObject $about --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-translator-credits:
=begin pod
=head2 get-translator-credits

Returns the translator credits string which is displayed in the translators tab of the secondary credits dialog. The string is owned by the about dialog and must not be modified.

  method get-translator-credits ( --> Str  )

=end pod

method get-translator-credits ( --> Str ) {
  gtk_about_dialog_get_translator_credits(self._get-native-object-no-reffing)
}

sub gtk_about_dialog_get_translator_credits ( N-GObject $about --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-version:
=begin pod
=head2 get-version

Returns the version string.

Returns: The version string. The string is owned by the about dialog and must not be modified.

  method get-version ( --> Str  )

=end pod

method get-version ( --> gchar-ptr ) {
  gtk_about_dialog_get_version(self._get-native-object-no-reffing);
}

sub gtk_about_dialog_get_version ( N-GObject $about --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-website:
=begin pod
=head2 get-website

Returns the website URL. The string is owned by the about dialog and must not be modified.

  method get-website ( --> Str  )

=end pod

method get-website ( --> Str ) {
  gtk_about_dialog_get_website(self._get-native-object-no-reffing)
}

sub gtk_about_dialog_get_website ( N-GObject $about --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-website-label:
=begin pod
=head2 get-website-label

Returns the label used for the website link. The string is owned by the about dialog and must not be modified.

  method get-website-label ( --> Str )

=end pod

method get-website-label ( --> Str ) {
  gtk_about_dialog_get_website_label(self._get-native-object-no-reffing)
}

sub gtk_about_dialog_get_website_label ( N-GObject $about --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-wrap-license:
=begin pod
=head2 get-wrap-license

Returns C<True> if the license text in this about dialog is automatically wrapped.

  method get-wrap-license ( --> Bool )

=end pod

method get-wrap-license ( --> Bool ) {
  gtk_about_dialog_get_wrap_license(self._get-native-object-no-reffing).Bool
}

sub gtk_about_dialog_get_wrap_license ( N-GObject $about --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-artists:
=begin pod
=head2 set-artists

Sets the strings which are displayed in the artists tab of the secondary credits dialog.

  method set-artists ( *@artists )

=item @artists; A list of string arguments

=end pod

method set-artists ( *@artists ) {
  my $artists = gchar-pptr.new( |@artists, Str);
  _gtk_about_dialog_set_artists( self._get-native-object-no-reffing, $artists);
}

sub gtk_about_dialog_set_artists ( N-GObject $about, *@artists ) {
  my $artists = gchar-pptr.new( |@artists, Str);
  _gtk_about_dialog_set_artists( $about, $artists);
}

sub _gtk_about_dialog_set_artists ( N-GObject $about, gchar-pptr $artists )
  is native(&gtk-lib)
  is symbol('gtk_about_dialog_set_artists')
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-authors:
=begin pod
=head2 set-authors

Sets the strings which are displayed in the authors tab of the secondary credits dialog.

  method set-authors ( *@authors )

=item @authors; a list of string arguments

=head3 Example

  my Gnome::Gtk3::AboutDialog $a .= new;
  $a.set-authors( 'mt++', 'pietje puk');

=end pod

method set-authors ( *@authors ) {
  my $authors = gchar-pptr.new( |@authors, Str);
  _gtk_about_dialog_set_authors( self._get-native-object-no-reffing, $authors);
}

sub gtk_about_dialog_set_authors ( N-GObject $about, *@authors ) {
  my $authors = gchar-pptr.new( |@authors, Str);
  _gtk_about_dialog_set_authors( $about, $authors);
}

sub _gtk_about_dialog_set_authors ( N-GObject $about, char-pptr $authors )
  is native(&gtk-lib)
  is symbol('gtk_about_dialog_set_authors')
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-comments:
=begin pod
=head2 set-comments

Sets the comments string to display in the about dialog. This should be a short string of one or two lines.

  method set-comments ( Str $comments )

=item $comments; a comments string

=end pod

method set-comments ( Str $comments ) {
  gtk_about_dialog_set_comments(
    self._get-native-object-no-reffing, $comments
  )
}

sub gtk_about_dialog_set_comments ( N-GObject $about, gchar-ptr $comments )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-copyright:
=begin pod
=head2 set-copyright

Sets the copyright string to display in the about dialog. This should be a short string of one or two lines.

  method set-copyright ( Str $copyright )

=item $copyright; the copyright string

=end pod

method set-copyright ( $copyright ) {
  gtk_about_dialog_set_copyright(
    self._get-native-object-no-reffing, $copyright
  );
}

sub gtk_about_dialog_set_copyright ( N-GObject $about, gchar-ptr $copyright )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-documenters:
=begin pod
=head2 set-documenters

Sets the strings which are displayed in the documenters tab of the secondary credits dialog.

  method set-documenters ( *@documenters )

=item @documenters; an list of string arguments

=end pod

method set-documenters ( *@documenters ) {
  my $documenters = gchar-pptr.new( |@documenters, Str);
  _gtk_about_dialog_set_documenters(
    self._get-native-object-no-reffing, $documenters
  );
}

sub gtk_about_dialog_set_documenters ( N-GObject $about, *@documenters ) {
  my $documenters = gchar-pptr.new( |@documenters, Str);
  _gtk_about_dialog_set_documenters( $about, $documenters);
}

sub _gtk_about_dialog_set_documenters (
  N-GObject $about, gchar-pptr $documenters
) is native(&gtk-lib)
  is symbol('gtk_about_dialog_set_documenters')
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-license:
=begin pod
=head2 set-license

Sets the license information to be displayed in the secondary license dialog. If I<license> is C<Any>, the license button is hidden.

  method set-license ( Str $license )

=item $license; the license information or C<Any>

=end pod

method set-license ( Str $license ) {
  gtk_about_dialog_set_license(
    self._get-native-object-no-reffing, $license
  )
}

sub gtk_about_dialog_set_license ( N-GObject $about, gchar-ptr $license )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-license-type:
=begin pod
=head2 set-license-type

Sets the license of the application showing the this about dialog dialog from a list of known licenses. This function overrides the license set using C<set-license()>.

  method set-license-type ( GtkLicense $license_type )

=item $license_type; the type of license

=end pod

method set-license-type ( GtkLicense $license_type ) {
  gtk_about_dialog_set_license_type(
    self._get-native-object-no-reffing, $license_type
  )
}

sub gtk_about_dialog_set_license_type ( N-GObject $about, gint $license_type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-logo:
=begin pod
=head2 set-logo

Sets the pixbuf to be displayed as logo in the about dialog. If it is undefined, the default window icon set with C<gtk_window_set_default_icon()> will be used.

  method set-logo ( Gnome::Gdk3::Pixbuf $logo )

=item $logo; a I<Gnome::Gdk3::Pixbuf> object

=end pod

method set-logo ( Gnome::Gdk3::Pixbuf $logo ) {
  gtk_about_dialog_set_logo(
    self._get-native-object-no-reffing,
    $logo._get-native-object-no-reffing
  );
}

sub gtk_about_dialog_set_logo ( N-GObject $about, N-GObject $logo )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-logo-icon-name:
=begin pod
=head2 set-logo-icon-name

Sets the pixbuf to be displayed as logo in the about dialog. If it is undefined, the default window icon set with C<g=tk_window_set_default_icon()> will be used.

  method set-logo-icon-name ( Str $icon_name )

=item $icon_name; an icon name, or undefined

=end pod

method set-logo-icon-name ( Str $icon_name ) {
  gtk_about_dialog_set_logo_icon_name(
    self._get-native-object-no-reffing, $icon_name
  );
}

sub gtk_about_dialog_set_logo_icon_name (
  N-GObject $about, gchar-ptr $icon_name
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-program-name:
=begin pod
=head2 set-program-name

Sets the name to display in the about dialog. If this is not set, it defaults to C<g_get_application_name()>.

  method set-program-name ( Str $name )

=item $name; the program name

=end pod

method set-program-name ( $name ) {
  gtk_about_dialog_set_program_name( self._get-native-object-no-reffing, $name);
}

sub gtk_about_dialog_set_program_name ( N-GObject $about, gchar-ptr $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-translator-credits:
=begin pod
=head2 set-translator-credits

Sets the translator credits string which is displayed in the translators tab of the secondary credits dialog.

The intended use for this string is to display the translator of the language which is currently used in the user interface. Using C<gettext()>, a simple way to achieve that is to mark the string for translation:

  $about-dialog.set-translator-credits("translator-credits");

It is a good idea to use the customary msgid “translator-credits” for this purpose, since translators will already know the purpose of that msgid, and since I<Gnome::Gtk3::AboutDialog> will detect if “translator-credits” is untranslated and hide the tab.

  method set-translator-credits ( Str $translator_credits )

=item $translator_credits; the translator credits

=end pod

method set-translator-credits ( Str $translator_credits ) {
  gtk_about_dialog_set_translator_credits(
    self._get-native-object-no-reffing, $translator_credits
  );
}

sub gtk_about_dialog_set_translator_credits (
  N-GObject $about, gchar-ptr $translator_credits
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-version:
=begin pod
=head2 set-version

Sets the version string to display in the about dialog.

  method set-version ( Str $version )

=item $version; the version string

=end pod

method set-version ( $version ) {
  gtk_about_dialog_set_version(
    self._get-native-object-no-reffing, $version
  );
}

sub gtk_about_dialog_set_version ( N-GObject $about, gchar-ptr $version )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-website:
=begin pod
=head2 set-website

Sets the URL to use for the website link.

  method set-website ( Str $website )

=item $website; a URL string starting with "http://"

=end pod

method set-website ( Str $website ) {
  gtk_about_dialog_set_website(
    self._get-native-object-no-reffing, $website
  )
}

sub gtk_about_dialog_set_website ( N-GObject $about, gchar-ptr $website )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-website-label:
=begin pod
=head2 set-website-label

Sets the label to be used for the website link.

  method set-website-label ( Str $website_label )

=item $website_label; the label used for the website link

=end pod

method set-website-label ( Str $website_label ) {
  gtk_about_dialog_set_website_label(
    self._get-native-object-no-reffing, $website_label
  )
}

sub gtk_about_dialog_set_website_label ( N-GObject $about, gchar-ptr $website_label )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-wrap-license:
=begin pod
=head2 set-wrap-license

Sets whether the license text in this about dialog is automatically wrapped.

  method set-wrap-license ( Bool $wrap_license )

=item $wrap_license; whether to wrap the license

=end pod

method set-wrap-license ( Int $wrap_license ) {
  gtk_about_dialog_set_wrap_license(
    self._get-native-object-no-reffing, $wrap_license
  )
}

sub gtk_about_dialog_set_wrap_license (
  N-GObject $about, gboolean $wrap_license
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:0:gtk_show_about_dialog:
=begin pod
=head2 [gtk_] show_about_dialog

This is a convenience function for showing an application’s about box. The constructed dialog is associated with the parent window and reused for future invocations of this function.

  method gtk_show_about_dialog ( N-GObject() $parent, Str $first_property_name )

=item $parent; (allow-none): transient parent, or Any for none
=item $first_property_name; the name of the first property

=end pod

sub gtk_show_about_dialog ( N-GObject $parent, Str $first_property_name, Any $any = Any )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_about_dialog_new:
#`{{
=begin pod
=head2 [gtk_] about_dialog_new

Creates a new B<Gnome::Gtk3::AboutDialog>.

Returns: a newly created native AboutDialog object.

  method gtk_about_dialog_new ( --> N-GObject  )

Returns N-GObject; a newly created native C<GtkAboutDialog>
=end pod
}}

sub _gtk_about_dialog_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_about_dialog_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

=comment -----------------------------------------------------------------------
=comment #TS:1:activate-link:
=head2 activate-link

The signal which gets emitted to activate a URI. Applications may connect to it to override the default behaviour, which is to call C<gtk_show_uri()>.

Returns: C<True> if the link has been activated.

  method handler (
    Str $uri,
    Gnome::Gtk3::AboutDialog :_widget($dialog),
    Int $_handler-id,
    N-GObject :$_native-object,
    *%user-options

    --> Bool
  );

=item $uri; the URI that is activated.
=item $dialog; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:1:artists:
=head2 artists

The people who contributed artwork to the program, as a C<undefined>-terminated array of strings. Each string may contain email addresses and URLs, which will be displayed as links, see the introduction for more details.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOXED
=item the type of this G_TYPE_BOXED object is G_TYPE_STRV
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:authors:
=head2 authors

The authors of the program, as a C<undefined>-terminated array of strings. Each string may contain email addresses and URLs, which will be displayed as links, see the introduction for more details.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOXED
=item the type of this G_TYPE_BOXED object is G_TYPE_STRV
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:1:comments:
=head2 comments

Comments about the program. This string is displayed in a label in the main dialog, thus it should be a short explanation of the main purpose of the program, not a detailed list of features.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:1:copyright:
=head2 copyright

Copyright information for the program.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:documenters:
=head2 documenters

The people documenting the program, as a C<undefined>-terminated array of strings. Each string may contain email addresses and URLs, which will be displayed as links, see the introduction for more details.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOXED
=item the type of this G_TYPE_BOXED object is G_TYPE_STRV
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:license:
=head2 license

The license of the program. This string is displayed in a text view in a secondary dialog, therefore it is fine to use a long multi-paragraph text.

Note that the text is only wrapped in the text view if the "wrap-license" property is set to C<True>; otherwise the text itself must contain the intended linebreaks.

When setting this property to a non-C<undefined> value, the I<license-type> property is set to C<GTK_LICENSE_CUSTOM> as a side effect.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:1:license-type:
=head2 license-type

The license of the program, as a value of the C<GtkLicense> enumeration.

The B<Gnome::Gtk3::AboutDialog> will automatically fill out a standard disclaimer and link the user to the appropriate online resource for the license text.

If C<GTK_LICENSE_UNKNOWN> is used, the link used will be the same specified in the  I<website> property.

If C<GTK_LICENSE_CUSTOM> is used, the current contents of the  I<license> property are used.

For any other B<Gnome::Gtk3::License> value, the contents of the  I<license> property are also set by this property as a side effect.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item the type of this G_TYPE_ENUM object is GTK_TYPE_LICENSE
=item Parameter is readable and writable.
=item Default value is GTK_LICENSE_UNKNOWN.


=comment -----------------------------------------------------------------------
=comment #TP:0:logo:
=head2 logo

A logo for the about box. If it is C<undefined>, the default window icon set with C<gtk_window_set_default_icon()> will be used.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_OBJECT
=item the type of this G_TYPE_OBJECT object is GDK_TYPE_PIXBUF
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:1:logo-icon-name:
=head2 logo-icon-name

A named icon to use as the logo for the about box. This property overrides the  I<logo> property.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is image-missing.


=comment -----------------------------------------------------------------------
=comment #TP:1:program-name:
=head2 program-name

The name of the program. If this is not set, it defaults to C<g_get_application_name()>.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:1:translator-credits:
=head2 translator-credits

Credits to the translators. This string should be marked as translatable. The string may contain email addresses and URLs, which will be displayed as links, see the introduction for more details.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:1:version:
=head2 version

The version of the program.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:1:website:
=head2 website

The URL for the link to the website of the program. This should be a string starting with "http://.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:1:website-label:
=head2 website-label

The label for the link to the website of the program.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.

=comment -----------------------------------------------------------------------
=comment #TP:1:wrap-license:
=head2 wrap-license

Whether to wrap the text in the license dialog.

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.

=end pod
