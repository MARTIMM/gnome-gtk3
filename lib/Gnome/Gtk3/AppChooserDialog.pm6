#TL:1:Gnome::Gtk3::AppChooserDialog:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::AppChooserDialog

An application chooser dialog


=comment ![](images/X.png)


=head1 Description

 
B<Gnome::Gtk3::AppChooserDialog> shows a B<Gnome::Gtk3::AppChooserWidget> inside a B<Gnome::Gtk3::Dialog>. 
 
Note that B<Gnome::Gtk3::AppChooserDialog> does not have any interesting methods 
of its own. Instead, you should get the embedded B<Gnome::Gtk3::AppChooserWidget> 
using C<get-widget()> and call its methods if 
the generic B<Gnome::Gtk3::AppChooser> interface is not sufficient for your needs. 
 
To set the heading that is shown above the B<Gnome::Gtk3::AppChooserWidget>,  use C<gtk-app-chooser-dialog-set-heading()>.





=head1 Synopsis

=head2 Declaration

  unit class Gnome::Gtk3::AppChooserDialog;
  also is Gnome::Gtk3::Dialog;


=comment head2 Uml Diagram

=comment ![](plantuml/.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::AppChooserDialog;

  unit class MyGuiClass;
  also is Gnome::Gtk3::AppChooserDialog;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::AppChooserDialog class process the options
    self.bless( :GtkAppChooserDialog, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::Gtk3::Dialog;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::AppChooserDialog:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::Gtk3::Dialog;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new AppChooserDialog object.

  multi method new ( )

=head3 :native-object

Create a AppChooserDialog object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a AppChooserDialog object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {



  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::AppChooserDialog' #`{{ or %options<GtkAppChooserDialog> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        $no = %options<___x___>;
        $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_app_chooser_dialog_new___x___($no);
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

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_app_chooser_dialog_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkAppChooserDialog');
  }
}


#-------------------------------------------------------------------------------
#TM:0:get-heading:
=begin pod
=head2 get-heading

Returns the text to display at the top of the dialog.

Returns: the text to display at the top of the dialog, or C<undefined>, in which case a default text is displayed

  method get-heading ( --> Str )

=end pod

method get-heading ( --> Str ) {

  gtk_app_chooser_dialog_get_heading(
    self.get-native-object-no-reffing,
  )
}

sub gtk_app_chooser_dialog_get_heading (
  N-GObject $self --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-widget:
=begin pod
=head2 get-widget

Returns the B<Gnome::Gtk3::AppChooserWidget> of this dialog.

Returns: the B<Gnome::Gtk3::AppChooserWidget> of I<self>

  method get-widget ( --> N-GObject )

=end pod

method get-widget ( --> N-GObject ) {

  gtk_app_chooser_dialog_get_widget(
    self.get-native-object-no-reffing,
  )
}

sub gtk_app_chooser_dialog_get_widget (
  N-GObject $self --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-heading:
=begin pod
=head2 set-heading

Sets the text to display at the top of the dialog. If the heading is not set, the dialog displays a default text.

  method set-heading ( Str $heading )

=item Str $heading; a string containing Pango markup
=end pod

method set-heading ( Str $heading ) {

  gtk_app_chooser_dialog_set_heading(
    self.get-native-object-no-reffing, $heading
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

=item N-GObject $parent; a B<Gnome::Gtk3::Window>, or C<undefined>
=item GtkDialogFlags $flags; flags for this dialog
=item GFile $file; a B<Gnome::Gtk3::File>
=end pod
}}

sub _gtk_app_chooser_dialog_new ( N-GObject $parent, GEnum $flags, GFile $file --> N-GObject )
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

=item N-GObject $parent; a B<Gnome::Gtk3::Window>, or C<undefined>
=item GtkDialogFlags $flags; flags for this dialog
=item Str $content_type; a content type string
=end pod
}}

sub _gtk_app_chooser_dialog_new_for_content_type ( N-GObject $parent, GEnum $flags, gchar-ptr $content_type --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_app_chooser_dialog_new_for_content_type')
  { * }

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
