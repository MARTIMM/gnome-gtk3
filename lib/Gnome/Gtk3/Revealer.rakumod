#TL:1:Gnome::Gtk3::Revealer:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Revealer

Hide and show a widget with animation.

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gtk3::Revealer> widget is a container which animates the transition of its child from invisible to visible.  The style of transition can be controlled with C<gtk_revealer_set_transition_type()>.  These animations respect the  I<gtk-enable-animations> setting.

=head2 CSS nodes

B<Gnome::Gtk3::Revealer> has a single CSS node with name revealer.

=head2 See Also

B<Gnome::Gtk3::Expander>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Revealer;
  also is Gnome::Gtk3::Bin;

=comment head2 Uml Diagram

=comment ![](plantuml/Revealer.svg)

=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Revealer:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Revealer;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Revealer class process the options
    self.bless( :GtkRevealer, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }
=end comment

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::Gtk3::Bin:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Revealer:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Bin;
#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2 GtkRevealerTransitionType

These enumeration values describe the possible transitions when the child of a GtkRevealer widget is shown or hidden.

=item GTK_REVEALER_TRANSITION_TYPE_NONE; No transition
=item GTK_REVEALER_TRANSITION_TYPE_CROSSFADE; Fade in
=item GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT; Slide in from the left
=item GTK_REVEALER_TRANSITION_TYPE_SLIDE_LEFT; Slide in from the right
=item GTK_REVEALER_TRANSITION_TYPE_SLIDE_UP; Slide in from the bottom
=item GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN; Slide in from the top

=end pod
#TE:1::GtkRevealerTransitionType
enum GtkRevealerTransitionType is export
  < GTK_REVEALER_TRANSITION_TYPE_NONE GTK_REVEALER_TRANSITION_TYPE_CROSSFADE GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT GTK_REVEALER_TRANSITION_TYPE_SLIDE_LEFT GTK_REVEALER_TRANSITION_TYPE_SLIDE_UP GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN
  >;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 new()

Creates a new B<Gnome::Gtk3::Revealer>.

  multi method new ( )

=begin comment
Create a Revealer object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

Create a Revealer object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )
=end comment

=end pod

# TM:0:new():inheriting
#TM:0:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Revealer' #`{{or %options<GtkRevealer>}} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;
      # if ? %options<> {
      #   $no = %options<>;
      #   $no .= _get-native-object-no-reffing
      #     if $no.^can('_get-native-object-no-reffing');
      #   $no = ...($no);
      # }

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

#      #`{{ when there are defaults use this instead
      # create default object
      #else {
        $no = _gtk_revealer_new();
      #}
#      }}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkRevealer');

  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_revealer_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkRevealer');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:_gtk_revealer_new:new
#`{{
=begin pod
=head2 [gtk_] revealer_new

Creates a new B<Gnome::Gtk3::Revealer>.  Returns: a newly created B<Gnome::Gtk3::Revealer>  Since: 3.10

  method gtk_revealer_new ( --> N-GObject )

=end pod
}}

sub _gtk_revealer_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_revealer_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_revealer_get_reveal_child:
=begin pod
=head2 [[gtk_] revealer_] get_reveal_child

Returns whether the child is currently revealed. See C<gtk_revealer_set_reveal_child()>.  This function returns C<1> as soon as the transition to the revealed state is started. To learn whether the child is fully revealed (ie the transition is completed), use C<gtk_revealer_get_child_revealed()>.

Returns: C<1> if the child is revealed.

  method gtk_revealer_get_reveal_child ( --> Int )

=end pod

sub gtk_revealer_get_reveal_child ( N-GObject $revealer --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_revealer_set_reveal_child:
=begin pod
=head2 [[gtk_] revealer_] set_reveal_child

Tells the B<Gnome::Gtk3::Revealer> to reveal or conceal its child.  The transition will be animated with the current transition type of the I<revealer>.

  method gtk_revealer_set_reveal_child ( Bool $reveal_child )

=item Int $reveal_child; C<True> to reveal the child

=end pod

sub gtk_revealer_set_reveal_child ( N-GObject $revealer, int32 $reveal_child  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_revealer_get_child_revealed:
=begin pod
=head2 [[gtk_] revealer_] get_child_revealed

Returns whether the child is fully revealed, in other words whether the transition to the revealed state is completed.

  method gtk_revealer_get_child_revealed ( --> Int )

=end pod

sub gtk_revealer_get_child_revealed ( N-GObject $revealer --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_revealer_get_transition_duration:
=begin pod
=head2 [[gtk_] revealer_] get_transition_duration

Returns the amount of time (in milliseconds) that transitions will take.

  method gtk_revealer_get_transition_duration ( --> UInt )

=end pod

sub gtk_revealer_get_transition_duration ( N-GObject $revealer --> uint32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_revealer_set_transition_duration:
=begin pod
=head2 [[gtk_] revealer_] set_transition_duration

Sets the duration that transitions will take.

  method gtk_revealer_set_transition_duration ( UInt $duration )

=item UInt $duration; the new duration, in milliseconds

=end pod

sub gtk_revealer_set_transition_duration ( N-GObject $revealer, uint32 $duration  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_revealer_set_transition_type:
=begin pod
=head2 [[gtk_] revealer_] set_transition_type

Sets the type of animation that will be used for transitions in I<revealer>. Available types include various kinds of fades and slides.

  method gtk_revealer_set_transition_type (
    GtkRevealerTransitionType $transition
  )

=item GtkRevealerTransitionType $transition; the new transition type

=end pod

sub gtk_revealer_set_transition_type (
  N-GObject $revealer, int32 $transition
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_revealer_get_transition_type:
=begin pod
=head2 [[gtk_] revealer_] get_transition_type

Gets the type of animation that will be used for transitions in I<revealer>.

  method gtk_revealer_get_transition_type ( --> GtkRevealerTransitionType )

=end pod

sub gtk_revealer_get_transition_type ( N-GObject $revealer --> int32 )
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
=comment #TP:0:transition-type:
=head3 Transition type

The type of animation used to transition  Default value: False.

The B<Gnome::GObject::Value> type of property I<transition-type> is C<G_TYPE_ENUM>.

#-------------------------------------------------------------------------------
=comment #TP:1:transition-duration:
=head3 Transition duration

The animation duration, in milliseconds.

The B<Gnome::GObject::Value> type of property I<transition-duration> is C<G_TYPE_UINT>.

#-------------------------------------------------------------------------------
=comment #TP:1:reveal-child:
=head3 Reveal Child

Whether the container should reveal the child  Default value: False.

The B<Gnome::GObject::Value> type of property I<reveal-child> is C<G_TYPE_BOOLEAN>.

#-------------------------------------------------------------------------------
=comment #TP:1:child-revealed:
=head3 Child Revealed

Whether the child is revealed and the animation target reached  Default value: False.

The B<Gnome::GObject::Value> type of property I<child-revealed> is C<G_TYPE_BOOLEAN>.
=end pod
