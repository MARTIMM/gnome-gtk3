#TL:1:Gnome::Gtk3::AppChooserDialog:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::AppChooserDialog

An application chooser dialog


![](images/appchooserdialog.png)


=head1 Description

B<Gnome::Gtk3::AppChooserDialog> shows a B<Gnome::Gtk3::AppChooserWidget> inside a B<Gnome::Gtk3::Dialog>.

Note that B<Gnome::Gtk3::AppChooserDialog> does not have any interesting methods of its own. Instead, you should get the embedded B<Gnome::Gtk3::AppChooserWidget> using C<get-widget()> and call its methods if the generic B<Gnome::Gtk3::AppChooser> interface is not sufficient for your needs.

To set the heading that is shown above the B<Gnome::Gtk3::AppChooserWidget>,  use C<gtk-app-chooser-dialog-set-heading()>.


=head1 Synopsis

=head2 Declaration

  unit class Gnome::Gtk3::AppChooserDialog;
  also is Gnome::Gtk3::Dialog;
  also does Gnome::Gtk3::AppChooser;

=head2 Uml Diagram

![](plantuml/AppChooserDialog.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::AppChooserDialog:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::AppChooserDialog;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::AppChooserDialog class process the options
    self.bless( :GtkAppChooserDialog, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gtk3::Dialog:api<1>;
use Gnome::Gtk3::AppChooser:api<1>;
use Gnome::Gtk3::AppChooserWidget:api<1>;

use Gnome::Gio::File:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::AppChooserDialog:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Dialog;
also does Gnome::Gtk3::AppChooser;

#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 :file, :flags, :parent

Creates a new B<Gnome::Gtk3::AppChooserDialog> for the provided file, to allow the user to select an application for it.

  multi method new (
    Str :$file!, Gnome::GObject::Object :$parent = N-GObject,
    UInt :$flags = 0
  )

=item $file; a path to a file.
=item $parent; Transient parent of the dialog, or C<undefined>.
=item $flags; flags for this dialog. Default is GTK_DIALOG_MODAL which is from GtkDialogFlags enumeration found in  B<Gnome::Gtk3::Dialog>.

B<Note>: When files are provided without an extension (or maybe other reasons), Gnome somehow cannot find out the content type of the file and throws critical errors like

  (AppChooserDialog.t:646972): GLib-GIO-CRITICAL **: 13:27:01.077: g_file_info_get_content_type: assertion 'G_IS_FILE_INFO (info)' failed



=head3 :content-type, :flags

Creates a new B<Gnome::Gtk3::AppChooserDialog> for the provided content type, to allow the user to select an application for it.

  multi method new (
    Str :$content-type!, UInt :$flags = GTK_DIALOG_MODAL,
    Gnome::GObject::Object :$parent = N-GObject,
  )

=item $content-type; a content type to handle.
=item $parent; Transient parent of the dialog, or C<undefined>.
=item $flags; flags for this dialog. Default is GTK_DIALOG_MODAL which is from GtkDialogFlags enumeration found in  B<Gnome::Gtk3::Dialog>.


=head3 :native-object

Create a AppChooserDialog object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a AppChooserDialog object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new(:file,:flags,:parent):
#TM:1:new(:content-type,:flags,:parent):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {
  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::AppChooserDialog' or
    %options<GtkAppChooserDialog>
  {
    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<file> {
        my Gnome::Gio::File $gfile .= new(:path(%options<file>));
        my $parent = %options<parent> // N-GObject;
        $parent .= _get-native-object-no-reffing unless $parent ~~ N-GObject;
        $no = _gtk_app_chooser_dialog_new(
          $parent, %options<flags> // 0, $gfile._get-native-object-no-reffing
        );

        $gfile.clear-object;
      }

      elsif ? %options<content-type> {
        my $parent = %options<parent> // N-GObject;
        $parent .= _get-native-object-no-reffing unless $parent ~~ N-GObject;
        $no = _gtk_app_chooser_dialog_new_for_content_type(
          $parent, %options<flags> // 0, %options<content-type>
        );
      }


      #`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      }}

      ##`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      #}}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_app_chooser_dialog_new();
      }
      }}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkAppChooserDialog');
  }
}


#-------------------------------------------------------------------------------
#TM:1:get-heading:
=begin pod
=head2 get-heading

Returns the text to display at the top of the dialog.

Returns: the text to display at the top of the dialog, or C<undefined>, in which case a default text is displayed

  method get-heading ( --> Str )

=end pod

method get-heading ( --> Str ) {

  gtk_app_chooser_dialog_get_heading(
    self._get-native-object-no-reffing,
  )
}

sub gtk_app_chooser_dialog_get_heading (
  N-GObject $self --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-widget:
=begin pod
=head2 get-widget

Returns the B<Gnome::Gtk3::AppChooserWidget> of this dialog.

  method get-widget ( --> N-GObject )

=end pod

method get-widget ( --> N-GObject ) {
  gtk_app_chooser_dialog_get_widget(self._get-native-object-no-reffing)
}

method get-widget-rk ( --> Gnome::Gtk3::AppChooserWidget ) {
  Gnome::N::deprecate(
    'get-widget-rk', 'coercing from get-widget',
    '0.47.2', '0.50.0'
  );

  Gnome::Gtk3::AppChooserWidget.new(:native-object(
      gtk_app_chooser_dialog_get_widget(self._get-native-object-no-reffing)
    )
  )
}

sub gtk_app_chooser_dialog_get_widget (
  N-GObject $self --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-heading:
=begin pod
=head2 set-heading

Sets the text to display at the top of the dialog. If the heading is not set, the dialog displays a default text.

  method set-heading ( Str $heading )

=item $heading; a string containing Pango markup
=end pod

method set-heading ( Str $heading ) {

  gtk_app_chooser_dialog_set_heading(
    self._get-native-object-no-reffing, $heading
  );
}

sub gtk_app_chooser_dialog_set_heading (
  N-GObject $self, gchar-ptr $heading
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_app_chooser_dialog_new:
#`{{
=begin pod
=head2 _gtk_app_chooser_dialog_new

Creates a new B<Gnome::Gtk3::AppChooserDialog> for the provided B<Gnome::Gtk3::File>, to allow the user to select an application for it.

Returns: a newly created B<Gnome::Gtk3::AppChooserDialog>

  method _gtk_app_chooser_dialog_new ( N-GObject $parent, GtkDialogFlags $flags, GFile $file --> N-GObject )

=item $parent; a B<Gnome::Gtk3::Window>, or C<undefined>
=item $flags; flags for this dialog
=item $file; a B<Gnome::Gtk3::File>
=end pod
}}

sub _gtk_app_chooser_dialog_new ( N-GObject $parent, GEnum $flags, N-GObject $file --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_app_chooser_dialog_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_app_chooser_dialog_new_for_content_type:
#`{{
=begin pod
=head2 _gtk_app_chooser_dialog_new_for_content_type

Creates a new B<Gnome::Gtk3::AppChooserDialog> for the provided content type, to allow the user to select an application for it.

Returns: a newly created B<Gnome::Gtk3::AppChooserDialog>

  method _gtk_app_chooser_dialog_new_for_content_type ( N-GObject $parent, GtkDialogFlags $flags, Str $content_type --> N-GObject )

=item $parent; a B<Gnome::Gtk3::Window>, or C<undefined>
=item $flags; flags for this dialog
=item $content_type; a content type string
=end pod
}}

sub _gtk_app_chooser_dialog_new_for_content_type ( N-GObject $parent, GEnum $flags, gchar-ptr $content_type --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_app_chooser_dialog_new_for_content_type')
  { * }

#-------------------------------------------------------------------------------
# Note; entered by hand. generator does not find info
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:0:gfile:
=head2 gfile

The GFile used by the B<Gnome::Gtk3::AppChooserDialog>. The dialog's B<Gnome::Gtk3::AppChooserWidget> content type will be guessed from the file, if present.

The B<Gnome::GObject::Value> type of property I<gfile> is C<G_TYPE_OBJECT>.

=item Parameter is set on construction of object.
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:heading:
=head2 heading

The text to show at the top of the dialog. The string may contain Pango markup.

The B<Gnome::GObject::Value> type of property I<heading> is C<G_TYPE_STRING>.

=item Parameter is readable and writable.
=item Default value is undefined.

=end pod












=finish
#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:0:
  g_object_class_install_property (gobject_class:
=head3 PROP_GFILE:
  g_object_class_install_property (gobject_class


  g-object-class-install-property (gobject-class, PROP-GFILE, pspec);
  /**

The text to show at the top of the dialog.
   * The string may contain Pango markup.
The B<Gnome::GObject::Value> type of property I<
  g_object_class_install_property (gobject_class> is C<G_TYPE_>.
=end pod
