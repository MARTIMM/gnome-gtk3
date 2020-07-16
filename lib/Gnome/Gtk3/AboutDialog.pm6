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

![](plantuml/AboutDialog.png)

=begin comment

= begin code :lang<plantuml>
@startuml
scale 0.8

package Gnome::GObject as gobject <<Rectangle>> {
  class InitialyUnowned
  class Object

  Object <|-- InitialyUnowned
}

package Gnome::Gtk3 as gtk3 <<Rectangle>> {
  class AboutDialog
  Interface Buildable <Interface>
  Dialog <|- AboutDialog
  Window <|- Dialog
  Bin <|- Window
  Container <|- Bin
  Widget <|- Container
  InitialyUnowned <|- Widget

  Buildable <|-- Widget
}

gobject <--[hidden]- gtk3
@enduml
= end code

=end comment

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
#use Gnome::GObject::Object;
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

#TE:0:GtkLicense:
enum GtkLicense is export (
  'GTK_LICENSE_UNKNOWN',
  'GTK_LICENSE_CUSTOM',
  'GTK_LICENSE_GPL_2_0',
  'GTK_LICENSE_GPL_3_0',
  'GTK_LICENSE_LGPL_2_1',
  'GTK_LICENSE_LGPL_3_0',
  'GTK_LICENSE_BSD',
  'GTK_LICENSE_MIT_X11',
  'GTK_LICENSE_ARTISTIC',
  'GTK_LICENSE_GPL_2_0_ONLY',
  'GTK_LICENSE_GPL_3_0_ONLY',
  'GTK_LICENSE_LGPL_2_1_ONLY',
  'GTK_LICENSE_LGPL_3_0_ONLY',
  'GTK_LICENSE_AGPL_3_0',
  'GTK_LICENSE_AGPL_3_0_ONLY'
);

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 new()

Creates a new B<Gnome::Gtk3::AboutDialog>.

  multi method new ( )

=end pod

#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

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

      if ? %options<empty> {
        Gnome::N::deprecate( '.new(:empty)', '.new()', '0.21.3', '0.30.0');
        $no = _gtk_about_dialog_new();
      }

      else {  # if ? %options<empty> {
        $no = _gtk_about_dialog_new();
      }

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkAboutDialog');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_about_dialog_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

#note "ad $native-sub: ", $s;
  self.set-class-name-of-sub('GtkAboutDialog');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:_gtk_about_dialog_new:
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

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_show_about_dialog:
=begin pod
=head2 [gtk_] show_about_dialog

This is a convenience function for showing an application’s about box. The constructed dialog is associated with the parent window and reused for future invocations of this function.

  method gtk_show_about_dialog ( N-GObject $parent, Str $first_property_name )

=item N-GObject $parent; (allow-none): transient parent, or Any for none
=item Str $first_property_name; the name of the first property

=end pod

sub gtk_show_about_dialog ( N-GObject $parent, Str $first_property_name, Any $any = Any )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_program_name:
=begin pod
=head2 [[gtk_] about_dialog_] get_program_name

Returns the program name displayed in the about dialog.

Returns: The program name. The string is owned by the about
dialog and must not be modified.


  method gtk_about_dialog_get_program_name ( --> Str  )


=end pod

sub gtk_about_dialog_get_program_name ( N-GObject $about )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_program_name:
=begin pod
=head2 [[gtk_] about_dialog_] set_program_name

Sets the name to display in the about dialog.
If this is not set, it defaults to C<g_get_application_name()>.


  method gtk_about_dialog_set_program_name ( Str $name )

=item Str $name; the program name

=end pod

sub gtk_about_dialog_set_program_name ( N-GObject $about, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_version:
=begin pod
=head2 [[gtk_] about_dialog_] get_version

Returns the version string.

Returns: The version string. The string is owned by the about
dialog and must not be modified.


  method gtk_about_dialog_get_version ( --> Str  )


=end pod

sub gtk_about_dialog_get_version ( N-GObject $about )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_version:
=begin pod
=head2 [[gtk_] about_dialog_] set_version

Sets the version string to display in the about dialog.


  method gtk_about_dialog_set_version ( Str $version )

=item Str $version; (allow-none): the version string

=end pod

sub gtk_about_dialog_set_version ( N-GObject $about, Str $version )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_copyright:
=begin pod
=head2 [[gtk_] about_dialog_] get_copyright

Returns the copyright string.

Returns: The copyright string. The string is owned by the about
dialog and must not be modified.


  method gtk_about_dialog_get_copyright ( --> Str  )


=end pod

sub gtk_about_dialog_get_copyright ( N-GObject $about )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_copyright:
=begin pod
=head2 [[gtk_] about_dialog_] set_copyright

Sets the copyright string to display in the about dialog.
This should be a short string of one or two lines.


  method gtk_about_dialog_set_copyright ( Str $copyright )

=item Str $copyright; (allow-none): the copyright string

=end pod

sub gtk_about_dialog_set_copyright ( N-GObject $about, Str $copyright )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_comments:
=begin pod
=head2 [[gtk_] about_dialog_] get_comments

Returns the comments string.

Returns: The comments. The string is owned by the about
dialog and must not be modified.


  method gtk_about_dialog_get_comments ( --> Str  )


=end pod

sub gtk_about_dialog_get_comments ( N-GObject $about )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_comments:
=begin pod
=head2 [[gtk_] about_dialog_] set_comments

Sets the comments string to display in the about dialog.
This should be a short string of one or two lines.


  method gtk_about_dialog_set_comments ( Str $comments )

=item Str $comments; (allow-none): a comments string

=end pod

sub gtk_about_dialog_set_comments ( N-GObject $about, Str $comments )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_license:
=begin pod
=head2 [[gtk_] about_dialog_] get_license

Returns the license information.

Returns: The license information. The string is owned by the about
dialog and must not be modified.


  method gtk_about_dialog_get_license ( --> Str  )


=end pod

sub gtk_about_dialog_get_license ( N-GObject $about )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_license:
=begin pod
=head2 [[gtk_] about_dialog_] set_license

Sets the license information to be displayed in the secondary
license dialog. If I<license> is C<Any>, the license button is
hidden.


  method gtk_about_dialog_set_license ( Str $license )

=item Str $license; (allow-none): the license information or C<Any>

=end pod

sub gtk_about_dialog_set_license ( N-GObject $about, Str $license )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_license_type:
=begin pod
=head2 [[gtk_] about_dialog_] set_license_type

Sets the license of the application showing the I<about> dialog from a
list of known licenses.

This function overrides the license set using
C<gtk_about_dialog_set_license()>.


  method gtk_about_dialog_set_license_type ( GtkLicense $license_type )

=item GtkLicense $license_type; the type of license

=end pod

sub gtk_about_dialog_set_license_type ( N-GObject $about, int32 $license_type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_license_type:
=begin pod
=head2 [[gtk_] about_dialog_] get_license_type

Retrieves the license set using C<gtk_about_dialog_set_license_type()>

Returns: a I<Gnome::Gtk3::License> value


  method gtk_about_dialog_get_license_type ( --> GtkLicense  )


=end pod

sub gtk_about_dialog_get_license_type ( N-GObject $about )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_wrap_license:
=begin pod
=head2 [[gtk_] about_dialog_] get_wrap_license

Returns whether the license text in I<about> is
automatically wrapped.

Returns: C<1> if the license text is wrapped


  method gtk_about_dialog_get_wrap_license ( --> Int  )


=end pod

sub gtk_about_dialog_get_wrap_license ( N-GObject $about )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_wrap_license:
=begin pod
=head2 [[gtk_] about_dialog_] set_wrap_license

Sets whether the license text in I<about> is
automatically wrapped.


  method gtk_about_dialog_set_wrap_license ( Int $wrap_license )

=item Int $wrap_license; whether to wrap the license

=end pod

sub gtk_about_dialog_set_wrap_license ( N-GObject $about, int32 $wrap_license )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_website:
=begin pod
=head2 [[gtk_] about_dialog_] get_website

Returns the website URL.

Returns: The website URL. The string is owned by the about
dialog and must not be modified.


  method gtk_about_dialog_get_website ( --> Str  )


=end pod

sub gtk_about_dialog_get_website ( N-GObject $about )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_website:
=begin pod
=head2 [[gtk_] about_dialog_] set_website

Sets the URL to use for the website link.


  method gtk_about_dialog_set_website ( Str $website )

=item Str $website; (allow-none): a URL string starting with "http://"

=end pod

sub gtk_about_dialog_set_website ( N-GObject $about, Str $website )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_website_label:
=begin pod
=head2 [[gtk_] about_dialog_] get_website_label

Returns the label used for the website link.

Returns: The label used for the website link. The string is
owned by the about dialog and must not be modified.


  method gtk_about_dialog_get_website_label ( --> Str  )


=end pod

sub gtk_about_dialog_get_website_label ( N-GObject $about )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_website_label:
=begin pod
=head2 [[gtk_] about_dialog_] set_website_label

Sets the label to be used for the website link.


  method gtk_about_dialog_set_website_label ( Str $website_label )

=item Str $website_label; the label used for the website link

=end pod

sub gtk_about_dialog_set_website_label ( N-GObject $about, Str $website_label )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_authors:
=begin pod
=head2 [[gtk_] about_dialog_] get_authors

Returns the string which are displayed in the authors tab
of the secondary credits dialog.

Returns: (array zero-terminated=1) (transfer none): A
C<Any>-terminated string array containing the authors. The array is
owned by the about dialog and must not be modified.


  method gtk_about_dialog_get_authors ( --> CArray[Str]  )


=end pod

sub gtk_about_dialog_get_authors ( N-GObject $about )
  returns CArray[Str]
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_authors:
=begin pod
=head2 [[gtk_] about_dialog_] set_authors

Sets the strings which are displayed in the authors tab
of the secondary credits dialog.


  method gtk_about_dialog_set_authors ( CArray[Str] $authors )

=item CArray[Str] $authors; (array zero-terminated=1): a C<Any>-terminated array of strings

=end pod

sub gtk_about_dialog_set_authors ( N-GObject $about, CArray[Str] $authors )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_documenters:
=begin pod
=head2 [[gtk_] about_dialog_] get_documenters

Returns the string which are displayed in the documenters
tab of the secondary credits dialog.

Returns: (array zero-terminated=1) (transfer none): A
C<Any>-terminated string array containing the documenters. The
array is owned by the about dialog and must not be modified.


  method gtk_about_dialog_get_documenters ( --> CArray[Str]  )


=end pod

sub gtk_about_dialog_get_documenters ( N-GObject $about )
  returns CArray[Str]
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_documenters:
=begin pod
=head2 [[gtk_] about_dialog_] set_documenters

Sets the strings which are displayed in the documenters tab
of the secondary credits dialog.


  method gtk_about_dialog_set_documenters ( CArray[Str] $documenters )

=item CArray[Str] $documenters; (array zero-terminated=1): a C<Any>-terminated array of strings

=end pod

sub gtk_about_dialog_set_documenters ( N-GObject $about, CArray[Str] $documenters )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_artists:
=begin pod
=head2 [[gtk_] about_dialog_] get_artists

Returns the string which are displayed in the artists tab
of the secondary credits dialog.

Returns: (array zero-terminated=1) (transfer none): A
C<Any>-terminated string array containing the artists. The array is
owned by the about dialog and must not be modified.


  method gtk_about_dialog_get_artists ( --> CArray[Str]  )


=end pod

sub gtk_about_dialog_get_artists ( N-GObject $about )
  returns CArray[Str]
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_artists:
=begin pod
=head2 [[gtk_] about_dialog_] set_artists

Sets the strings which are displayed in the artists tab
of the secondary credits dialog.


  method gtk_about_dialog_set_artists ( CArray[Str] $artists )

=item CArray[Str] $artists; (array zero-terminated=1): a C<Any>-terminated array of strings

=end pod

sub gtk_about_dialog_set_artists ( N-GObject $about, CArray[Str] $artists )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_translator_credits:
=begin pod
=head2 [[gtk_] about_dialog_] get_translator_credits

Returns the translator credits string which is displayed
in the translators tab of the secondary credits dialog.

Returns: The translator credits string. The string is
owned by the about dialog and must not be modified.


  method gtk_about_dialog_get_translator_credits ( --> Str  )


=end pod

sub gtk_about_dialog_get_translator_credits ( N-GObject $about )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_translator_credits:
=begin pod
=head2 [[gtk_] about_dialog_] set_translator_credits

Sets the translator credits string which is displayed in the translators tab of the secondary credits dialog.

The intended use for this string is to display the translator of the language which is currently used in the user interface. Using C<gettext()>, a simple way to achieve that is to mark the string for translation:

  $about-dialog.set-translator-credits("translator-credits");

It is a good idea to use the customary msgid “translator-credits” for this purpose, since translators will already know the purpose of that msgid, and since I<Gnome::Gtk3::AboutDialog> will detect if “translator-credits” is untranslated and hide the tab.


  method gtk_about_dialog_set_translator_credits ( Str $translator_credits )

=item Str $translator_credits; (allow-none): the translator credits

=end pod

sub gtk_about_dialog_set_translator_credits ( N-GObject $about, Str $translator_credits )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_logo:
=begin pod
=head2 [[gtk_] about_dialog_] get_logo

Returns the pixbuf displayed as logo in the about dialog.

Returns: (transfer none): the pixbuf displayed as logo. The
pixbuf is owned by the about dialog. If you want to keep a
reference to it, you have to call C<g_object_ref()> on it.


  method gtk_about_dialog_get_logo ( --> N-GObject  )


=end pod

sub gtk_about_dialog_get_logo ( N-GObject $about )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_logo:
=begin pod
=head2 [[gtk_] about_dialog_] set_logo

Sets the pixbuf to be displayed as logo in the about dialog.
If it is C<Any>, the default window icon set with
C<gtk_window_set_default_icon()> will be used.


  method gtk_about_dialog_set_logo ( N-GObject $logo )

=item N-GObject $logo; (allow-none): a I<Gnome::Gdk3::Pixbuf>, or C<Any>

=end pod

sub gtk_about_dialog_set_logo ( N-GObject $about, N-GObject $logo )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_get_logo_icon_name:
=begin pod
=head2 [[gtk_] about_dialog_] get_logo_icon_name

Returns the icon name displayed as logo in the about dialog.

Returns: the icon name displayed as logo. The string is
owned by the dialog. If you want to keep a reference
to it, you have to call C<g_strdup()> on it.


  method gtk_about_dialog_get_logo_icon_name ( --> Str )


=end pod

sub gtk_about_dialog_get_logo_icon_name ( N-GObject $about )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_set_logo_icon_name:
=begin pod
=head2 [[gtk_] about_dialog_] set_logo_icon_name

Sets the pixbuf to be displayed as logo in the about dialog.
If it is C<Any>, the default window icon set with
C<gtk_window_set_default_icon()> will be used.


  method gtk_about_dialog_set_logo_icon_name ( Str $icon_name )

=item Str $icon_name; (allow-none): an icon name, or C<Any>

=end pod

sub gtk_about_dialog_set_logo_icon_name ( N-GObject $about, Str $icon_name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_about_dialog_add_credit_section:
=begin pod
=head2 [[gtk_] about_dialog_] add_credit_section

Creates a new section in the Credits page.


  method gtk_about_dialog_add_credit_section ( Str $section_name, CArray[Str] $people )

=item Str $section_name; The name of the section
=item CArray[Str] $people; (array zero-terminated=1): The people who belong to that section

=end pod

sub gtk_about_dialog_add_credit_section ( N-GObject $about, Str $section_name, CArray[Str] $people )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=comment #TP:0:program-name:
=head3 Program name

The name of the program.
If this is not set, it defaults to C<g_get_application_name()>.


The B<Gnome::GObject::Value> type of property I<program-name> is C<G_TYPE_STRING>.

=comment #TP:0:version:
=head3 Program version

The version of the program.


The B<Gnome::GObject::Value> type of property I<version> is C<G_TYPE_STRING>.

=comment #TP:0:copyright:
=head3 Copyright string

Copyright information for the program.


The B<Gnome::GObject::Value> type of property I<copyright> is C<G_TYPE_STRING>.

=comment #TP:0:comments:
=head3 Comments string

Comments about the program. This string is displayed in a label
in the main dialog, thus it should be a short explanation of
the main purpose of the program, not a detailed list of features.


The B<Gnome::GObject::Value> type of property I<comments> is C<G_TYPE_STRING>.

=comment #TP:0:license:
=head3 License

The license of the program. This string is displayed in a
text view in a secondary dialog, therefore it is fine to use
a long multi-paragraph text. Note that the text is only wrapped
in the text view if the "wrap-license" property is set to C<1>;
otherwise the text itself must contain the intended linebreaks.
When setting this property to a non-C<Any> value, the
sig I<license-type> property is set to C<GTK_LICENSE_CUSTOM>
as a side effect.


The B<Gnome::GObject::Value> type of property I<license> is C<G_TYPE_STRING>.

=comment #TP:0:license-type:
=head3 License Type

The license of the program, as a value of the C<GtkLicense> enumeration.

The I<Gnome::Gtk3::AboutDialog> will automatically fill out a standard disclaimer
and link the user to the appropriate online resource for the license
text.

If C<GTK_LICENSE_UNKNOWN> is used, the link used will be the same
specified in the sig I<website> property.

If C<GTK_LICENSE_CUSTOM> is used, the current contents of the
sig I<license> property are used.

For any other I<Gnome::Gtk3::License> value, the contents of the
sig I<license> property are also set by this property as
a side effect.


Widget type: GTK_TYPE_LICENSE

The B<Gnome::GObject::Value> type of property I<license-type> is C<G_TYPE_ENUM>.

=comment #TP:0:website:
=head3 Website URL

The URL for the link to the website of the program.
This should be a string starting with "http://.


The B<Gnome::GObject::Value> type of property I<website> is C<G_TYPE_STRING>.

=comment #TP:0:website-label:
=head3 Website label

The label for the link to the website of the program.


The B<Gnome::GObject::Value> type of property I<website-label> is C<G_TYPE_STRING>.


=begin comment
=comment #TP:0:authors:
=head3 Authors

The authors of the program, as an C<Any>-terminated array of strings.
Each string may contain email addresses and URLs, which will be displayed
as links, see the introduction for more details.


The B<Gnome::GObject::Value> type of property I<authors> is C<G_TYPE_BOXED>.

=comment #TP:0:documenters:
=head3 Documenters

The people documenting the program, as an C<Any>-terminated array of strings.
Each string may contain email addresses and URLs, which will be displayed
as links, see the introduction for more details.



The B<Gnome::GObject::Value> type of property I<documenters> is C<G_TYPE_BOXED>.

=comment #TP:0:artists:
=head3 Artists

The people who contributed artwork to the program, as a C<Any>-terminated
array of strings. Each string may contain email addresses and URLs, which
will be displayed as links, see the introduction for more details.



The B<Gnome::GObject::Value> type of property I<artists> is C<G_TYPE_BOXED>.

=comment #TP:0:translator-credits:
=head3 Translator credits

Credits to the translators. This string should be marked as translatable.
The string may contain email addresses and URLs, which will be displayed
as links, see the introduction for more details.


The B<Gnome::GObject::Value> type of property I<translator-credits> is C<G_TYPE_STRING>.

=comment #TP:0:logo:
=head3 Logo

A logo for the about box. If it is C<Any>, the default window icon
set with C<gtk_window_set_default_icon()> will be used.


Widget type: it defaults to gtk_window_get_default_icon_list()

The B<Gnome::GObject::Value> type of property I<logo> is C<G_TYPE_OBJECT>.
=end comment

=comment #TP:0:logo-icon-name:
=head3 Logo Icon Name

A named icon to use as the logo for the about box. This property
overrides the sig I<logo> property.


The B<Gnome::GObject::Value> type of property I<logo-icon-name> is C<G_TYPE_STRING>.

=comment #TP:0:wrap-license:
=head3 Wrap license

Whether to wrap the text in the license dialog.


The B<Gnome::GObject::Value> type of property I<wrap-license> is C<G_TYPE_BOOLEAN>.

=end pod

#`{{
=begin comment

=head2 Unsupported properties

=end comment



=head2 Supported properties

=head3 program-name

The B<Gnome::GObject::Value> type of property I<program-name> is C<G_TYPE_STRING>.

The name of the program.
If this is not set, it defaults to C<g_get_application_name()>.

=head3 version

The B<Gnome::GObject::Value> type of property I<version> is C<G_TYPE_STRING>.

The version of the program.

=head3 copyright

The B<Gnome::GObject::Value> type of property I<copyright> is C<G_TYPE_STRING>.

Copyright information for the program.

=head3 comments

The B<Gnome::GObject::Value> type of property I<comments> is C<G_TYPE_STRING>.

Comments about the program. This string is displayed in a label
in the main dialog, thus it should be a short explanation of
the main purpose of the program, not a detailed list of features.

=head3 license

The B<Gnome::GObject::Value> type of property I<license> is C<G_TYPE_STRING>.

The license of the program. This string is displayed in a
text view in a secondary dialog, therefore it is fine to use
a long multi-paragraph text. Note that the text is only wrapped
in the text view if the "wrap-license" property is set to C<1>;
otherwise the text itself must contain the intended linebreaks.
When setting this property to a non-C<Any> value, the
C<license>-type property is set to C<GTK_LICENSE_CUSTOM>
as a side effect.

=head3 license-type

The B<Gnome::GObject::Value> type of property I<license-type> is C<G_TYPE_ENUM>.

The license of the program, as a value of the C<GtkLicense> enumeration.

The B<Gnome::Gtk3::AboutDialog> will automatically fill out a standard disclaimer
and link the user to the appropriate online resource for the license
text.

If C<GTK_LICENSE_UNKNOWN> is used, the link used will be the same
specified in the C<website> property.

If C<GTK_LICENSE_CUSTOM> is used, the current contents of the
C<license> property are used.

For any other B<Gnome::Gtk3::License> value, the contents of the
C<license> property are also set by this property as
a side effect.


=head3 website

The B<Gnome::GObject::Value> type of property I<website> is C<G_TYPE_STRING>.

The URL for the link to the website of the program.
This should be a string starting with "http://.

=head3 website-label

The B<Gnome::GObject::Value> type of property I<website-label> is C<G_TYPE_STRING>.

The label for the link to the website of the program.


=head3 translator-credits

The B<Gnome::GObject::Value> type of property I<translator-credits> is C<G_TYPE_STRING>.

Credits to the translators. This string should be marked as translatable.
The string may contain email addresses and URLs, which will be displayed
as links, see the introduction for more details.

=head3 logo-icon-name

The B<Gnome::GObject::Value> type of property I<logo-icon-name> is C<G_TYPE_STRING>.

A named icon to use as the logo for the about box. This property
overrides the C<logo> property.

=head3 wrap-license

The B<Gnome::GObject::Value> type of property I<wrap-license> is C<G_TYPE_BOOLEAN>.

Whether to wrap the text in the license dialog.



=head2 Not yet supported properties

=head3 authors

The B<Gnome::GObject::Value> type of property I<authors> is C<G_TYPE_BOXED>.

The authors of the program, as a C<Any>-terminated array of strings.
Each string may contain email addresses and URLs, which will be displayed
as links, see the introduction for more details.

=head3 documenters

The B<Gnome::GObject::Value> type of property I<documenters> is C<G_TYPE_BOXED>.

The people documenting the program, as a C<Any>-terminated array of strings.
Each string may contain email addresses and URLs, which will be displayed
as links, see the introduction for more details.

=head3 artists

The B<Gnome::GObject::Value> type of property I<artists> is C<G_TYPE_BOXED>.

The people who contributed artwork to the program, as a C<Any>-terminated
array of strings. Each string may contain email addresses and URLs, which
will be displayed as links, see the introduction for more details.

=head3 logo

The B<Gnome::GObject::Value> type of property I<logo> is C<G_TYPE_OBJECT>.

A logo for the about box. If it is C<Any>, the default window icon
set with C<gtk_window_set_default_icon()> will be used.

=end pod
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<g_signal_connect_object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( N-GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, N-GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<g_signal_connect_object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals

=comment #TS:0:activate-link:
=head2 activate-link

The signal which gets emitted to activate a URI. Applications may connect to it to override the default behaviour, which is to call C<gtk_show_uri()>.

Returns: C<1> if the link has been activated.

  method handler (
    Str $uri,
    Gnome::GObject::Object :$widget,
    *%user-options
    --> Int
  );

=item $widget; The object on which the signal was emitted.
=item $uri; the URI that is activated.

=end pod
