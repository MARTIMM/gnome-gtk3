#TL:1:Gnome::Gtk3::Scrollable:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Scrollable

An interface for scrollable widgets

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::Scrollable> is an interface that is implemented by widgets with native scrolling ability.

To implement this interface you should override the I<hadjustment> and  I<vadjustment> properties.

=head2 Creating a scrollable widget

All scrollable widgets should do the following.

=item When a parent widget sets the scrollable child widget’s adjustments, the widget should populate the adjustments’ I<lower>,  I<upper>, I<step-increment>, I<page-increment> and I<page-size> properties and connect to the I<value-changed> signal.

=item Because its preferred size is the size for a fully expanded widget, the scrollable widget must be able to cope with underallocations. This means that it must accept any value passed to its B<Gnome::Gtk3::WidgetClass>.C<size-allocate()> function.

=item When the parent allocates space to the scrollable child widget, the widget should update the adjustments’ properties with new values.

=item When any of the adjustments emits the  I<value-changed> signal, the scrollable widget should scroll its contents.

=head1 Synopsis
=head2 Declaration

  unit role Gnome::Gtk3::Scrollable;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Border;
use Gnome::Gtk3::Adjustment;

#-------------------------------------------------------------------------------
unit role Gnome::Gtk3::Scrollable:auth<github:MARTIMM>:ver<0.1.0>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

# interfaces are not instantiated
#submethod BUILD ( *%options ) { }

#`{{
# All interface calls should become methods
#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _scrollable_interface ( $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &:("gtk_scrollable_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &:("gtk_$native-sub"); } unless ?$s;
  try { $s = &:($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s;
}
}}


#-------------------------------------------------------------------------------
# setup signals from interface
#method _add_scrollable_interface_signal_types ( Str $class-name ) {
#}


#-------------------------------------------------------------------------------
#TM:1:get-border:
#TM:1:get-border-rk:
=begin pod
=head2 get-border

Returns the size of a non-scrolling border around the outside of the scrollable. An example for this would be treeview headers. GTK+ can use this information to display overlayed graphics, like the overshoot indication, at the right position.

Returns: Undefined or invalid if I<border> has not been set.

  method get-border ( --> N-GtkBorder )
  method get-border-rk ( --> Gnome::Gtk3::Border )

=item N-GObject $border;
=end pod

method get-border ( --> N-GtkBorder ) {
  my N-GtkBorder $border .= new;

  my Bool $r = gtk_scrollable_get_border(
    self._f('GtkScrollable'), $border
  ).Bool;

  $r ?? $border !! N-GtkBorder
}

method get-border-rk ( --> Gnome::Gtk3::Border ) {
  my N-GtkBorder $border .= new;

  my Bool $r = gtk_scrollable_get_border(
    self._f('GtkScrollable'), $border
  ).Bool;

  $r ?? Gnome::Gtk3::Border.new(:native-object($border))
     !! Gnome::Gtk3::Border.new(:native-object(N-GtkBorder))
}

sub gtk_scrollable_get_border (
  N-GObject $scrollable, N-GtkBorder $border --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-hadjustment:
#TM:1:get-hadjustment-rk:
=begin pod
=head2 get-hadjustment

Retrieves the B<Gnome::Gtk3::Adjustment> used for horizontal scrolling.

  method get-hadjustment ( --> N-GObject )
  method get-hadjustment-rk ( --> Gnome::Gtk3::Adjustment )

=end pod

method get-hadjustment ( --> N-GObject ) {
  gtk_scrollable_get_hadjustment(
    self._f('GtkScrollable'),
  )
}

method get-hadjustment-rk ( --> Gnome::Gtk3::Adjustment ) {
  Gnome::Gtk3::Adjustment.new(
    :native-object(gtk_scrollable_get_hadjustment(self._f('GtkScrollable')))
  )
}

sub gtk_scrollable_get_hadjustment (
  N-GObject $scrollable --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-hscroll-policy:
=begin pod
=head2 get-hscroll-policy

Gets the horizontal B<GtkScrollablePolicy> enum value.

  method get-hscroll-policy ( --> GtkScrollablePolicy )

=end pod

method get-hscroll-policy ( --> GtkScrollablePolicy ) {
  GtkScrollablePolicy(
    gtk_scrollable_get_hscroll_policy(self._f('GtkScrollable'))
  )
}

sub gtk_scrollable_get_hscroll_policy (
  N-GObject $scrollable --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-vadjustment:
#TM:1:get-vadjustment-rk:
=begin pod
=head2 get-vadjustment, get-vadjustment-rk

Retrieves the B<Gnome::Gtk3::Adjustment> used for vertical scrolling.

  method get-vadjustment ( --> N-GObject )
  method get-vadjustment-rk ( --> Gnome::Gtk3::Adjustment )

=end pod

method get-vadjustment ( --> N-GObject ) {
  gtk_scrollable_get_vadjustment(self._f('GtkScrollable'))
}

method get-vadjustment-rk ( --> Gnome::Gtk3::Adjustment ) {
  Gnome::Gtk3::Adjustment.new(
    :native-object(gtk_scrollable_get_vadjustment(self._f('GtkScrollable')))
  )
}

sub gtk_scrollable_get_vadjustment (
  N-GObject $scrollable --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-vscroll-policy:
=begin pod
=head2 get-vscroll-policy

Gets the vertical B<GtkScrollablePolicy>.

  method get-vscroll-policy ( --> GtkScrollablePolicy )

=end pod

method get-vscroll-policy ( --> GtkScrollablePolicy ) {
  GtkScrollablePolicy(
    gtk_scrollable_get_vscroll_policy(self._f('GtkScrollable')),
  )
}

sub gtk_scrollable_get_vscroll_policy (
  N-GObject $scrollable --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-hadjustment:
=begin pod
=head2 set-hadjustment

Sets the horizontal adjustment of the B<Gnome::Gtk3::Scrollable>.

  method set-hadjustment ( N-GObject $hadjustment )

=item N-GObject $hadjustment; a B<Gnome::Gtk3::Adjustment>
=end pod

method set-hadjustment ( $hadjustment is copy ) {
  $hadjustment .= get-native-object(:!ref) unless $hadjustment ~~ N-GObject;
  gtk_scrollable_set_hadjustment( self._f('GtkScrollable'), $hadjustment);
}

sub gtk_scrollable_set_hadjustment (
  N-GObject $scrollable, N-GObject $hadjustment
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-hscroll-policy:
=begin pod
=head2 set-hscroll-policy

Sets the B<GtkScrollablePolicy> to determine whether horizontal scrolling should start below the minimum width or below the natural width.

  method set-hscroll-policy ( GtkScrollablePolicy $policy )

=item GtkScrollablePolicy $policy; the horizontal B<GtkScrollablePolicy>.
=end pod

method set-hscroll-policy ( GtkScrollablePolicy $policy ) {
  gtk_scrollable_set_hscroll_policy( self._f('GtkScrollable'), $policy);
}

sub gtk_scrollable_set_hscroll_policy (
  N-GObject $scrollable, GEnum $policy
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-vadjustment:
=begin pod
=head2 set-vadjustment

Sets the vertical adjustment of the B<Gnome::Gtk3::Scrollable>.

  method set-vadjustment ( N-GObject $vadjustment )

=item N-GObject $vadjustment; a B<Gnome::Gtk3::Adjustment>
=end pod

method set-vadjustment ( $vadjustment is copy ) {
  $vadjustment .= get-native-object-no-reffing unless $vadjustment ~~ N-GObject;
  gtk_scrollable_set_vadjustment( self._f('GtkScrollable'), $vadjustment);
}

sub gtk_scrollable_set_vadjustment (
  N-GObject $scrollable, N-GObject $vadjustment
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-vscroll-policy:
=begin pod
=head2 set-vscroll-policy

Sets the B<Gnome::Gtk3::ScrollablePolicy> to determine whether vertical scrolling should start below the minimum height or below the natural height.

  method set-vscroll-policy ( GtkScrollablePolicy $policy )

=item GtkScrollablePolicy $policy; the vertical B<Gnome::Gtk3::ScrollablePolicy>
=end pod

method set-vscroll-policy ( GtkScrollablePolicy $policy ) {
  gtk_scrollable_set_vscroll_policy( self._f('GtkScrollable'), $policy);
}

sub gtk_scrollable_set_vscroll_policy (
  N-GObject $scrollable, GEnum $policy
) is native(&gtk-lib)
  { * }

#`{{ TODO add props manually
#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties
}}
