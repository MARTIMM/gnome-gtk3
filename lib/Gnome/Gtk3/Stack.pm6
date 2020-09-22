#TL:1:Gnome::Gtk3::Stack:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Stack

A stacking container

![](images/stack.png)

=head1 Description

The B<Gnome::Gtk3::Stack> widget is a container which only shows one of its children at a time. In contrast to B<Gnome::Gtk3::Notebook>, B<Gnome::Gtk3::Stack> does not provide a means for users to change the visible child. Instead, the B<Gnome::Gtk3::StackSwitcher> widget can be used with B<Gnome::Gtk3::Stack> to provide this functionality.

Transitions between pages can be animated as slides or fades. This can be controlled with C<gtk_stack_set_transition_type()>. These animations respect the I<gtk-enable-animations> setting.

The B<Gnome::Gtk3::Stack> widget was added in GTK+ 3.10.


=head2 Css Nodes

B<Gnome::Gtk3::Stack> has a single CSS node named stack.


=head2 See Also

B<Gnome::Gtk3::Notebook>, B<Gnome::Gtk3::StackSwitcher>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Stack;
  also is Gnome::Gtk3::Container;

=head2 Uml Diagram
![](plantuml/Stack.svg)

=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Stack;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Stack;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Stack class process the options
    self.bless( :GtkStack, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Stack:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2 enum GtkStackTransitionType

These enumeration values describe the possible transitions between pages in a GtkStack widget.

New values may be added to this enumeration over time.

=end pod
#TT:1:GtkStackTransitionType:
enum GtkStackTransitionType is export <
  GTK_STACK_TRANSITION_TYPE_NONE
  GTK_STACK_TRANSITION_TYPE_CROSSFADE
  GTK_STACK_TRANSITION_TYPE_SLIDE_RIGHT
  GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT
  GTK_STACK_TRANSITION_TYPE_SLIDE_UP
  GTK_STACK_TRANSITION_TYPE_SLIDE_DOWN
  GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT
  GTK_STACK_TRANSITION_TYPE_SLIDE_UP_DOWN
  GTK_STACK_TRANSITION_TYPE_OVER_UP
  GTK_STACK_TRANSITION_TYPE_OVER_DOWN
  GTK_STACK_TRANSITION_TYPE_OVER_LEF
  GTK_STACK_TRANSITION_TYPE_OVER_RIGHT
  GTK_STACK_TRANSITION_TYPE_UNDER_UP
  GTK_STACK_TRANSITION_TYPE_UNDER_DOWN
  GTK_STACK_TRANSITION_TYPE_UNDER_LEFT
  GTK_STACK_TRANSITION_TYPE_UNDER_RIGHT
  GTK_STACK_TRANSITION_TYPE_OVER_UP_DOWN
  GTK_STACK_TRANSITION_TYPE_OVER_DOWN_UP
  GTK_STACK_TRANSITION_TYPE_OVER_LEFT_RIGHT
  GTK_STACK_TRANSITION_TYPE_OVER_RIGHT_LEFT
>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new Stack object.

  multi method new ( )

Create a Stack object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create a Stack object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting:
#TM:0:new():
#TM:4:new(:native-object):TopLevelClassSupport
#TM:4:new(:build-id):Object
submethod BUILD ( *%options ) {

  # prevent creating wrong objects
  if self.^name eq 'Gnome::Gtk3::Stack' or %options<GtkStack> {

    if self.is-valid { }

    # process all named arguments
    elsif %options<native-object>:exists or %options<widget>:exists or
      %options<build-id>:exists { }

    else {
      my $no;

      # create default object
      $no = _gtk_stack_new();

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkStack');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_stack_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkStack');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:_gtk_stack_new:
#`{{
=begin pod
=head2 _gtk_stack_new

Creates a new B<Gnome::Gtk3::Stack> container.

  method gtk_stack_new ( --> N-GObject )

=end pod
}}
sub _gtk_stack_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_stack_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_add_named:
=begin pod
=head2 [gtk_stack_] add_named

Adds a child to this stack. The child is identified by the I<$name>.

  method gtk_stack_add_named ( N-GObject $child, Str $name )

=item N-GObject $child; the widget to add
=item Str $name; the name for I<child>

=end pod

sub gtk_stack_add_named ( N-GObject $stack, N-GObject $child, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_add_titled:
=begin pod
=head2 [gtk_stack_] add_titled

Adds a child to this stack. The child is identified by the I<$name>. The I<$title> will be used by B<Gnome::Gtk3::StackSwitcher> to represent I<$child> in a tab bar, so it should be short.

  method gtk_stack_add_titled ( N-GObject $child, Str $name, Str $title )

=item N-GObject $child; the widget to add
=item Str $name; the name for I<$child>
=item Str $title; a human-readable title for I<$child>

=end pod

sub gtk_stack_add_titled ( N-GObject $stack, N-GObject $child, Str $name, Str $title  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_get_child_by_name:
=begin pod
=head2 [gtk_stack_] get_child_by_name

Finds the child of the B<Gnome::Gtk3::Stack> with the name given as the argument. Returns C<Any> if there is no child with this name.

Returns: the requested child of the B<Gnome::Gtk3::Stack> if any.

  method gtk_stack_get_child_by_name ( Str $name --> N-GObject )

=item Str $name; the name of the child to find

=end pod

sub gtk_stack_get_child_by_name ( N-GObject $stack, Str $name --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_set_visible_child:
=begin pod
=head2 [gtk_stack_] set_visible_child

Makes I<$child> the visible child of this stack.

If I<$child> is different from the currently visible child, the transition between the two will be animated with the current transition type of this stack.

Note that the I<$child> widget has to be visible itself (see C<gtk_widget_show()>) in order to become the visible child of this stack.

  method gtk_stack_set_visible_child ( N-GObject $child )

=item N-GObject $child; a child of this stack

=end pod

sub gtk_stack_set_visible_child ( N-GObject $stack, N-GObject $child  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_get_visible_child:
=begin pod
=head2 [gtk_stack_] get_visible_child

Gets the currently visible child of this stack, or C<Any> if there are no visible children.

Returns: the visible child of the B<Gnome::Gtk3::Stack>.

  method gtk_stack_get_visible_child ( --> N-GObject )

=end pod

sub gtk_stack_get_visible_child ( N-GObject $stack --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_set_visible_child_name:
=begin pod
=head2 [gtk_stack_] set_visible_child_name

Makes the child with the given name visible.

If the child with the name is different from the currently visible child, the transition between the two will be animated with the current transition type of this stack.

Note that the child widget has to be visible itself (see C<gtk_widget_show()>) in order to become the visible child of this stack.

  method gtk_stack_set_visible_child_name ( Str $name )

=item Str $name; the name of the child to make visible

=end pod

sub gtk_stack_set_visible_child_name ( N-GObject $stack, Str $name  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_get_visible_child_name:
=begin pod
=head2 [gtk_stack_] get_visible_child_name

Returns the name of the currently visible child of this stack, or C<Any> if there is no visible child.

Returns: the name of the visible child of the B<Gnome::Gtk3::Stack>

  method gtk_stack_get_visible_child_name ( --> Str )

=end pod

sub gtk_stack_get_visible_child_name ( N-GObject $stack --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_set_visible_child_full:
=begin pod
=head2 [gtk_stack_] set_visible_child_full

Makes the child with the given name visible.

Note that the child widget has to be visible itself (see C<gtk_widget_show()>) in order to become the visible child of this stack.

  method gtk_stack_set_visible_child_full (
    Str $name, GtkStackTransitionType $transition
  )

=item Str $name; the name of the child to make visible
=item GtkStackTransitionType $transition; the transition type to use

=end pod

sub gtk_stack_set_visible_child_full (
  N-GObject $stack, Str $name, int32 $transition
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_set_homogeneous:
=begin pod
=head2 [gtk_stack_] set_homogeneous

Sets the B<Gnome::Gtk3::Stack> to be homogeneous or not. If it is homogeneous, the B<Gnome::Gtk3::Stack> will request the same size for all its children. If it isn't, the stack may change size when a different child becomes visible.

Homogeneity can be controlled separately for horizontal and vertical size, with the C<gtk_stack_set_hhomogeneous> and  C<gtk_stack_set_vhomogeneous>.

  method gtk_stack_set_homogeneous ( Bool $homogeneous )

=item Int $homogeneous; C<1> to make this stack homogeneous

=end pod

sub gtk_stack_set_homogeneous ( N-GObject $stack, int32 $homogeneous  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_get_homogeneous:
=begin pod
=head2 [gtk_stack_] get_homogeneous

Gets whether this stack is homogeneous. See C<gtk_stack_set_homogeneous()>.

  method gtk_stack_get_homogeneous ( --> Int )

=end pod

sub gtk_stack_get_homogeneous ( N-GObject $stack --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_set_hhomogeneous:
=begin pod
=head2 [gtk_stack_] set_hhomogeneous

Sets the B<Gnome::Gtk3::Stack> to be horizontally homogeneous or not. If it is homogeneous, the B<Gnome::Gtk3::Stack> will request the same width for all its children. If it isn't, the stack may change width when a different child becomes visible.

  method gtk_stack_set_hhomogeneous ( Bool $hhomogeneous )

=item Int $hhomogeneous; C<1> to make this stack horizontally homogeneous

=end pod

sub gtk_stack_set_hhomogeneous ( N-GObject $stack, int32 $hhomogeneous  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_get_hhomogeneous:
=begin pod
=head2 [gtk_stack_] get_hhomogeneous

Gets whether this stack is horizontally homogeneous. See C<gtk_stack_set_hhomogeneous()>.

  method gtk_stack_get_hhomogeneous ( --> Int )

=end pod

sub gtk_stack_get_hhomogeneous ( N-GObject $stack --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_set_vhomogeneous:
=begin pod
=head2 [gtk_stack_] set_vhomogeneous

Sets the B<Gnome::Gtk3::Stack> to be vertically homogeneous or not. If it is homogeneous, the B<Gnome::Gtk3::Stack> will request the same height for all its children. If it isn't, the stack may change height when a different child becomes visible.

  method gtk_stack_set_vhomogeneous ( Bool $vhomogeneous )

=item Int $vhomogeneous; C<1> to make this stack vertically homogeneous

=end pod

sub gtk_stack_set_vhomogeneous ( N-GObject $stack, int32 $vhomogeneous  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_get_vhomogeneous:
=begin pod
=head2 [gtk_stack_] get_vhomogeneous

Gets whether this stack is vertically homogeneous. See C<gtk_stack_set_vhomogeneous()>.

  method gtk_stack_get_vhomogeneous ( --> Int )

=end pod

sub gtk_stack_get_vhomogeneous ( N-GObject $stack --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_set_transition_duration:
=begin pod
=head2 [gtk_stack_] set_transition_duration

Sets the duration that transitions between pages in this stack will take.

  method gtk_stack_set_transition_duration ( UInt $duration )

=item UInt $duration; the new duration, in milliseconds

=end pod

sub gtk_stack_set_transition_duration ( N-GObject $stack, uint32 $duration  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_get_transition_duration:
=begin pod
=head2 [gtk_stack_] get_transition_duration

Returns the amount of time (in milliseconds) that transitions between pages in this stack will take.

  method gtk_stack_get_transition_duration ( --> UInt )

=end pod

sub gtk_stack_get_transition_duration ( N-GObject $stack --> uint32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_set_transition_type:
=begin pod
=head2 [gtk_stack_] set_transition_type

Sets the type of animation that will be used for transitions between pages in this stack. Available types include various kinds of fades and slides.

The transition type can be changed without problems at runtime, so it is possible to change the animation based on the page that is about to become current.

  method gtk_stack_set_transition_type ( GtkStackTransitionType $transition )

=item GtkStackTransitionType $transition; the new transition type

=end pod

sub gtk_stack_set_transition_type ( N-GObject $stack, int32 $transition  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_get_transition_type:
=begin pod
=head2 [gtk_stack_] get_transition_type

Gets the type of animation that will be used for transitions between pages in this stack.

  method gtk_stack_get_transition_type ( --> int32 )

=end pod

sub gtk_stack_get_transition_type ( N-GObject $stack --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_get_transition_running:
=begin pod
=head2 [gtk_stack_] get_transition_running

Returns whether this stack is currently in a transition from one page to another. C<1> if the transition is currently running, C<0> otherwise.

  method gtk_stack_get_transition_running ( --> Int )

=end pod

sub gtk_stack_get_transition_running ( N-GObject $stack --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_set_interpolate_size:
=begin pod
=head2 [gtk_stack_] set_interpolate_size

Sets whether or not this stack will interpolate its size when changing the visible child. If the I<$interpolate-size> property is set to C<1>, this stack will interpolate its size between the current one and the one it'll take after changing the visible child, according to the set transition duration.

  method gtk_stack_set_interpolate_size ( Bool $interpolate_size )

=item Int $interpolate_size; the new value

=end pod

sub gtk_stack_set_interpolate_size (
  N-GObject $stack, int32 $interpolate_size
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_get_interpolate_size:
=begin pod
=head2 [gtk_stack_] get_interpolate_size

Returns wether the B<Gnome::Gtk3::Stack> is set up to interpolate between the sizes of children on page switch. Returns: C<1> if child sizes are interpolated, C<0> otherwise.

  method gtk_stack_get_interpolate_size ( --> Int )

=end pod

sub gtk_stack_get_interpolate_size ( N-GObject $stack --> int32 )
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

#-------------------------------------------------------------------------------
=comment #TP:1:homogeneous:
=head3 Homogeneous

Homogeneous sizing
Default value: True

The B<Gnome::GObject::Value> type of property I<homogeneous> is C<G_TYPE_BOOLEAN>.

#-------------------------------------------------------------------------------
=comment #TP:1:hhomogeneous:
=head3 Horizontally homogeneous

C<1> if the stack allocates the same width for all children.

The B<Gnome::GObject::Value> type of property I<hhomogeneous> is C<G_TYPE_BOOLEAN>.

#-------------------------------------------------------------------------------
=comment #TP:1:vhomogeneous:
=head3 Vertically homogeneous

C<1> if the stack allocates the same height for all children.

The B<Gnome::GObject::Value> type of property I<vhomogeneous> is C<G_TYPE_BOOLEAN>.

#-------------------------------------------------------------------------------
=comment #TP:0:visible-child:
=head3 Visible child

The widget currently visible in the stack. Widget type: GTK_TYPE_WIDGET

The B<Gnome::GObject::Value> type of property I<visible-child> is C<G_TYPE_OBJECT>.

#-------------------------------------------------------------------------------
=comment #TP:1:visible-child-name:
=head3 Name of visible child

The name of the widget currently visible in the stack Default value: Any

The B<Gnome::GObject::Value> type of property I<visible-child-name> is C<G_TYPE_STRING>.

#-------------------------------------------------------------------------------
=comment #TP:1:transition-duration:
=head3 Transition duration

The B<Gnome::GObject::Value> type of property I<transition-duration> is C<G_TYPE_UINT>.

#-------------------------------------------------------------------------------
=comment #TP:1:transition-type:
=head3 Transition type

The type of animation used to transition. Default value: False.

The B<Gnome::GObject::Value> type of property I<transition-type> is C<G_TYPE_ENUM>.

#-------------------------------------------------------------------------------
=comment #TP:1:transition-running:
=head3 Transition running

Whether or not the transition is currently running. Default value: False.

The B<Gnome::GObject::Value> type of property I<transition-running> is C<G_TYPE_BOOLEAN>.

#-------------------------------------------------------------------------------
=comment #TP:1:interpolate-size:
=head3 Interpolate size

Whether or not the size should smoothly change when changing between differently sized children. Default value: False.

The B<Gnome::GObject::Value> type of property I<interpolate-size> is C<G_TYPE_BOOLEAN>.

#-------------------------------------------------------------------------------
=begin comment
----- Child Property Details -----

=comment #TP:0:name:
=head3 Name

The name of the child page. Default value: Any.

The B<Gnome::GObject::Value> type of property I<name> is C<G_TYPE_STRING>.

#-------------------------------------------------------------------------------
=comment #TP:0:title:
=head3 Title

The title of the child page. Default value: Any.

The B<Gnome::GObject::Value> type of property I<title> is C<G_TYPE_STRING>.

#-------------------------------------------------------------------------------
=comment #TP:0:icon-name:
=head3 Icon name

The icon name of the child page
Default value: Any

The B<Gnome::GObject::Value> type of property I<icon-name> is C<G_TYPE_STRING>.

#-------------------------------------------------------------------------------
=comment #TP:0:position:
=head3 Position

The B<Gnome::GObject::Value> type of property I<position> is C<G_TYPE_INT>.

#-------------------------------------------------------------------------------
=comment #TP:0:needs-attention:
=head3 Needs Attention

Sets a flag specifying whether the child requires the user attention.
This is used by the B<Gnome::Gtk3::StackSwitcher> to change the appearance of the
corresponding button when a page needs attention and it is not the
current one.

The B<Gnome::GObject::Value> type of property I<needs-attention> is C<G_TYPE_BOOLEAN>.

----- Child Property Details -----
=end comment
=end pod
