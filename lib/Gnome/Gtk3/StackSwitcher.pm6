#TL:1:Gnome::Gtk3::StackSwitcher:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::StackSwitcher

A controller for B<Gnome::Gtk3::Stack>

![](images/stackswitcher.png)

=head1 Description

The B<Gnome::Gtk3::StackSwitcher> widget acts as a controller for a B<Gnome::Gtk3::Stack>; it shows a row of buttons to switch between the various pages of the associated stack widget.

All the content for the buttons comes from the child properties of the B<Gnome::Gtk3::Stack>; the button visibility in a B<Gnome::Gtk3::StackSwitcher> widget is controlled by the visibility of the child in the B<Gnome::Gtk3::Stack>.

It is possible to associate multiple B<Gnome::Gtk3::StackSwitcher> widgets with the same B<Gnome::Gtk3::Stack> widget.

The B<Gnome::Gtk3::StackSwitcher> widget was added in 3.10.

=head2 Css Nodes

B<Gnome::Gtk3::StackSwitcher> has a single CSS node named stackswitcher and style class .stack-switcher.

When circumstances require it, B<Gnome::Gtk3::StackSwitcher> adds the .needs-attention style class to the widgets representing the stack pages.


=head2 See Also

B<Gnome::Gtk3::Stack>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::StackSwitcher;
  also is Gnome::Gtk3::Box;


=head2 Uml Diagram
![](plantuml/StackSwitcher.svg)


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Box;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::StackSwitcher:auth<github:MARTIMM>;
also is Gnome::Gtk3::Box;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 new()

Create a new StackSwitcher object.

  multi method new ( )

=begin comment

Create a StackSwitcher object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create a StackSwitcher object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end comment
=end pod

#TM:1:new():
#TM:1:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::StackSwitcher';

  # process all named arguments
  if ? %options<widget> || ? %options<native-object> ||
     ? %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message(
        'Unsupported, undefined, incomplete or wrongly typed options for ' ~
        self.^name ~ ': ' ~ %options.keys.join(', ')
      )
    );
  }

  # create default object
  else {
    self._set-native-object(_gtk_stack_switcher_new());
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkStackSwitcher');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_stack_switcher_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkStackSwitcher');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:_gtk_stack_switcher_new:new()
#`{{
=begin pod
=head2 [gtk_] stack_switcher_new

Create a new B<Gnome::Gtk3::StackSwitcher>.

Returns: a new B<Gnome::Gtk3::StackSwitcher>.

  method gtk_stack_switcher_new ( --> N-GObject )


=end pod
}}

sub _gtk_stack_switcher_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_stack_switcher_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_switcher_set_stack:
=begin pod
=head2 [[gtk_] stack_switcher_] set_stack

Sets the stack to control.

  method gtk_stack_switcher_set_stack ( N-GObject $stack )

=item N-GObject $stack; a B<Gnome::Gtk3::Stack>

=end pod

sub gtk_stack_switcher_set_stack ( N-GObject $switcher, N-GObject $stack  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_switcher_get_stack:
=begin pod
=head2 [[gtk_] stack_switcher_] get_stack

Retrieves the stack, or C<Any> if none has been set explicitly. See C<gtk_stack_switcher_set_stack()>.

  method gtk_stack_switcher_get_stack ( --> N-GObject )

=end pod

sub gtk_stack_switcher_get_stack ( N-GObject $switcher --> N-GObject )
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

=comment -----------------------------------------------------------------------
=comment #TP:1:icon-size:
=head3 Icon Size

Use the "icon-size" property to change the size of the image displayed when a B<Gnome::Gtk3::StackSwitcher> is displaying icons.

The B<Gnome::GObject::Value> type of property I<icon-size> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:stack:
=head3 Stack

Stack

The B<Gnome::GObject::Value> type of property I<stack> is C<G_TYPE_OBJECT>.

=end pod
