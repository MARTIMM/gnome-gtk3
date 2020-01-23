#TL:1:Gnome::Gtk3::Spinner:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Spinner

Show a spinner animation

![](images/spinner.png)

=head1 Description

A B<Gnome::Gtk3::Spinner> widget displays an icon-size spinning animation. It is often used as an alternative to a B<Gnome::Gtk3::ProgressBar> for displaying indefinite activity, instead of actual progress.

To start the animation, use C<gtk_spinner_start()>, to stop it use C<gtk_spinner_stop()>.

=head2 Css Nodes


B<Gnome::Gtk3::Spinner> has a single CSS node with the name spinner. When the animation is active, the I<checked> pseudoclass is added to this node.

=head2 Implemented Interfaces

Gnome::Gtk3::Spinner implements
=comment item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)

=head2 See Also

B<Gnome::Gtk3::CellRendererSpinner>, B<Gnome::Gtk3::ProgressBar>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Spinner;
  also is Gnome::Gtk3::Widget;
  also does Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::Spinner:auth<github:MARTIMM>;
also is Gnome::Gtk3::Widget;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new default object.

  multi method new ( )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::Spinner';

  # process all named arguments
  if ? %options<widget> || ? %options<native-object> ||
     ? %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported, undefined or wrongly typed options for ' ~
               self.^name ~ ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # create default object
  else {
    self.set-native-object(gtk_spinner_new());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkSpinner');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_spinner_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkSpinner');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_spinner_new:new()
=begin pod
=head2 gtk_spinner_new

Returns a new spinner widget. Not yet started.

Returns: a new B<Gnome::Gtk3::Spinner>

Since: 2.20

  method gtk_spinner_new ( --> N-GObject )


=end pod

sub gtk_spinner_new (  --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spinner_start:
=begin pod
=head2 gtk_spinner_start

Starts the animation of the spinner.

Since: 2.20

  method gtk_spinner_start ( )


=end pod

sub gtk_spinner_start ( N-GObject $spinner  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spinner_stop:
=begin pod
=head2 gtk_spinner_stop

Stops the animation of the spinner.

Since: 2.20

  method gtk_spinner_stop ( )


=end pod

sub gtk_spinner_stop ( N-GObject $spinner  )
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

=comment #TP:1:active:
=head3 Active

Whether the spinner is active
Default value: False

The B<Gnome::GObject::Value> type of property I<active> is C<G_TYPE_BOOLEAN>.
=end pod
