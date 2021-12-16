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
use Gnome::Gtk3::Dialog;

#use Gnome::Gtk3::Buildable;
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

Create a new object with a title. The transient $parent-window which may be C<Any>.

  multi method new ( Str :$title!, Gnome::GObject::Object :$parent-window )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( Gnome::GObject::Object :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:title,:parent-window):
#TM:0:new(:native-object):
#TM:0:new(:build-id):

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
  return unless self.^name eq 'Gnome::Gtk3::ColorChooserDialog';

  # process all named arguments
  if ? %options<title> {
    self._set-native-object(gtk_color_chooser_dialog_new(
      %options<title>, %options<parent-window>)
    );
  }

  elsif ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkColorChooserDialog');
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
=begin pod
=head2 [gtk_] color_chooser_dialog_new

Creates a new native C<Gtk3ColorChooserDialog>.

Returns: a new B<Gnome::Gtk3::ColorChooserDialog>

Since: 3.4

  method gtk_color_chooser_dialog_new (
    Str $title, N-GObject $parent
    --> N-GObject
  )

=item Str $title;  (allow-none): Title of the dialog, or %NULL
=item N-GObject $parent;  (allow-none): Transient parent of the dialog, or %NULL

=end pod

sub gtk_color_chooser_dialog_new (  str $title,  N-GObject $parent )
  returns N-GObject
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

=head2 Supported properties

=comment #TP:0:show-editor:
=head3 Show editor

Show editor
Default value: False


The B<Gnome::GObject::Value> type of property I<show-editor> is C<G_TYPE_BOOLEAN>.
=end pod
