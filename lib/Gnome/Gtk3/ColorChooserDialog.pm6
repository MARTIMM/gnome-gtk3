#TL:1:Gnome::Gtk3::ColorChooserDialog:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ColorChooserDialog

A dialog for choosing colors

![](images/colorchooser.png)


=head1 Description

The B<Gnome::Gtk3::ColorChooserDialog> widget is a dialog for choosing a color. It implements the B<Gnome::Gtk3::ColorChooser> interface.


=head2 See Also

B<Gnome::Gtk3::ColorChooser>, B<Gnome::Gtk3::Dialog>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ColorChooserDialog;
  also is Gnome::Gtk3::Dialog;
  also does Gnome::Gtk3::ColorChooser;


=head2 Uml Diagram

![](plantuml/ColorChooserDialog.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::ColorChooserDialog;

  unit class MyGuiClass;
  also is Gnome::Gtk3::ColorChooserDialog;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::ColorChooserDialog class process the options
    self.bless( :GtkColorChooserDialog, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=head2 Example

  my Gnome::Gtk3::ColorChooserDialog $dialog .= new(
    :title('my color dialog')
  );

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::Dialog;
use Gnome::Gtk3::ColorChooser;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ColorChooserDialog:auth<github:MARTIMM>;
also is Gnome::Gtk3::Dialog;
also does Gnome::Gtk3::ColorChooser;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :title, :parent-window

Create a new object with a title. The transient $parent-window which may be C<Any>.

  multi method new ( Str :$title!, N-GObject() :$parent-window )


=head3 :native-object

Create a ColorChooserDialog object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject() :$native-object! )


=head3 :build-id

Create a ColorChooserDialog object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:title,:parent-window):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  unless $signals-added {
    # no signals of its own
    $signals-added = True;

    # signals from interfaces
    self._add_color_chooser_signal_types($?CLASS.^name);
  }

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ColorChooserDialog' or
     %options<GtkColorChooserDialog> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;

      # process all named arguments
      if ? %options<title> {
        $no = _gtk_color_chooser_dialog_new(
          %options<title>, %options<parent-window>
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
        $no = _gtk_color_chooser_dialog_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkColorChooserDialog');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_color_chooser_dialog_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._color_chooser_interface($native-sub) unless ?$s;

  self._set-class-name-of-sub('GtkColorChooserDialog');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:_gtk_color_chooser_dialog_new:
#`{{
=begin pod
=head2 _gtk_color_chooser_dialog_new

Creates a new B<Gnome::Gtk3::ColorChooserDialog>.

Returns: a new B<Gnome::Gtk3::ColorChooserDialog>

  method _gtk_color_chooser_dialog_new ( Str $title, N-GObject()() $parent, N-GObject() $parent --> N-GObject )

=item $title; Title of the dialog, or C<undefined>
=item $parent; Transient parent of the dialog, or C<undefined>
=end pod
}}

sub _gtk_color_chooser_dialog_new (
  gchar-ptr $title, N-GObject $parent --> N-GObject
) is native(&gtk-lib)
  is symbol('gtk_color_chooser_dialog_new')
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
=comment #TP:0:show-editor:
=head3 Show editor: show-editor

Show editor
Default value: False

The B<Gnome::GObject::Value> type of property I<show-editor> is C<G_TYPE_BOOLEAN>.
=end pod
