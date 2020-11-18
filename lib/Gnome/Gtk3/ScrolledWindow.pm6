#TL:1:Gnome::Gtk3::ScrolledWindow:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ScrolledWindow

Adds scrollbars to its child widget

![](images/scrolledwindow.png)

=head1 Description

B<Gnome::Gtk3::ScrolledWindow> is a container that accepts a single child widget, makes that child scrollable using either internally added scrollbars or externally associated adjustments, and optionally draws a frame around the child.

Widgets with native scrolling support, i.e. those whose classes implement the B<Gnome::Gtk3::Scrollable> interface, are added directly. For other types of widget, the class B<Gnome::Gtk3::Viewport> acts as an adaptor, giving scrollability to other widgets. B<Gnome::Gtk3::ScrolledWindow>’s implementation of C<gtk_container_add()> intelligently accounts for whether or not the added child is a B<Gnome::Gtk3::Scrollable>. If it isn’t, B<Gnome::Gtk3::ScrolledWindow> wraps the child in a B<Gnome::Gtk3::Viewport> and adds that for you. Therefore, you can just add any child widget and not worry about the details.

If C<gtk_container_add()> has added a B<Gnome::Gtk3::Viewport> for you, you can remove both your added child widget from the B<Gnome::Gtk3::Viewport>, and the B<Gnome::Gtk3::Viewport> from the B<Gnome::Gtk3::ScrolledWindow>, like this:

=begin comment
|[<!-- language="C" -->
B<Gnome::Gtk3::Widget> *scrolled_window = gtk_scrolled_window_new (NULL, NULL);
B<Gnome::Gtk3::Widget> *child_widget = C<gtk_button_new()>;

// B<Gnome::Gtk3::Button> is not a B<Gnome::Gtk3::Scrollable>, so B<Gnome::Gtk3::ScrolledWindow> will automatically
// add a B<Gnome::Gtk3::Viewport>.
gtk_container_add (GTK_CONTAINER (scrolled_window),
                   child_widget);

// Either of these will result in child_widget being unparented:
gtk_container_remove (GTK_CONTAINER (scrolled_window),
                      child_widget);
// or
gtk_container_remove (GTK_CONTAINER (scrolled_window),
                      gtk_bin_get_child (GTK_BIN (scrolled_window)));
]|
=end comment

Unless  I<policy> is GTK_POLICY_NEVER or GTK_POLICY_EXTERNAL, B<Gnome::Gtk3::ScrolledWindow> adds internal B<Gnome::Gtk3::Scrollbar> widgets around its child. The scroll position of the child, and if applicable the scrollbars, is controlled by the  I<hadjustment> and  I<vadjustment> that are associated with the B<Gnome::Gtk3::ScrolledWindow>. See the docs on B<Gnome::Gtk3::Scrollbar> for the details, but note that the “step_increment” and “page_increment” fields are only effective if the policy causes scrollbars to be present.

If a B<Gnome::Gtk3::ScrolledWindow> doesn’t behave quite as you would like, or doesn’t have exactly the right layout, it’s very possible to set up your own scrolling with B<Gnome::Gtk3::Scrollbar> and for example a B<Gnome::Gtk3::Grid>.


=head2 Touch support

B<Gnome::Gtk3::ScrolledWindow> has built-in support for touch devices. When a touchscreen is used, swiping will move the scrolled window, and will expose 'kinetic' behavior. This can be turned off with the  I<kinetic-scrolling> property if it is undesired.

B<Gnome::Gtk3::ScrolledWindow> also displays visual 'overshoot' indication when the content is pulled beyond the end, and this situation can be captured with the  I<edge-overshot> signal.

If no mouse device is present, the scrollbars will overlayed as narrow, auto-hiding indicators over the content. If traditional scrollbars are desired although no mouse is present, this behaviour can be turned off with the  I<overlay-scrolling> property.


=head2 Css Nodes

B<Gnome::Gtk3::ScrolledWindow> has a main CSS node with name scrolledwindow. It uses subnodes with names overshoot and undershoot to draw the overflow and underflow indications. These nodes get the .left, .right, .top or .bottom style class added depending on where the indication is drawn.

B<Gnome::Gtk3::ScrolledWindow> also sets the positional style classes (.left, .right, .top, .bottom) and style classes related to overlay scrolling (.overlay-indicator, .dragging, .hovering) on its scrollbars.

If both scrollbars are visible, the area where they meet is drawn with a subnode named junction.


=head2 See Also

B<Gnome::Gtk3::Scrollable>, B<Gnome::Gtk3::Viewport>, B<Gnome::Gtk3::Adjustment>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ScrolledWindow;
  also is Gnome::Gtk3::Bin;

=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::ScrolledWindow;

  unit class MyGuiClass;
  also is Gnome::Gtk3::ScrolledWindow;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::ScrolledWindow class process the options
    self.bless( :GtkScrolledWindow, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;

use Gnome::Gtk3::Bin;
use Gnome::Gtk3::Adjustment;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::ScrolledWindow:auth<github:MARTIMM>;
also is Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkCornerType

Specifies which corner a child widget should be placed in when packed into a B<Gnome::Gtk3::ScrolledWindow>. This is effectively the opposite of where the scroll bars are placed.

=item GTK_CORNER_TOP_LEFT: Place the scrollbars on the right and bottom of the widget (default behaviour).
=item GTK_CORNER_BOTTOM_LEFT: Place the scrollbars on the top and right of the widget.
=item GTK_CORNER_TOP_RIGHT: Place the scrollbars on the left and bottom of the widget.
=item GTK_CORNER_BOTTOM_RIGHT: Place the scrollbars on the top and left of the widget.


=end pod

#TE:1:GtkCornerType:
enum GtkCornerType is export (
  'GTK_CORNER_TOP_LEFT',
  'GTK_CORNER_BOTTOM_LEFT',
  'GTK_CORNER_TOP_RIGHT',
  'GTK_CORNER_BOTTOM_RIGHT'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkPolicyType

Determines how the size should be computed to achieve the one of the
visibility mode for the scrollbars.


=item GTK_POLICY_ALWAYS: The scrollbar is always visible. The view size is independent of the content.
=item GTK_POLICY_AUTOMATIC: The scrollbar will appear and disappear as necessary. For example, when all of a B<Gnome::Gtk3::TreeView> can not be seen.
=item GTK_POLICY_NEVER: The scrollbar should never appear. In this mode the content determines the size.
=item GTK_POLICY_EXTERNAL: Don't show a scrollbar, but don't force the size to follow the content. This can be used e.g. to make multiple scrolled windows share a scrollbar. Since: 3.16


=end pod

#TE:1:GtkPolicyType:
enum GtkPolicyType is export (
  'GTK_POLICY_ALWAYS',
  'GTK_POLICY_AUTOMATIC',
  'GTK_POLICY_NEVER',
  'GTK_POLICY_EXTERNAL'
);

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new ScrolledWindow object.

  multi method new ( )

Create a ScrolledWindow object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

Create a ScrolledWindow object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:1:new(:hadjustment,:vadjustment):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w2<scroll-child>, :w1<move-focus-out edge-overshot edge-reached>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ScrolledWindow' #`{{ or %options<GtkScrolledWindow> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    elsif ? %options<hadjustment> and ? %options<hadjustment> {
      my $n-ha = %options<hadjustment>;
      $n-ha .= get-native-object-no-reffing
        if $n-ha.^can('get-native-object-no-reffing');
      my $n-va = %options<vadjustment>;
      $n-va .= get-native-object-no-reffing
        if $n-va.^can('get-native-object-no-reffing');
      self.set-native-object(_gtk_scrolled_window_new( $n-ha, $n-va));
    }

    # check if there are unknown options
    elsif %options.elems {
      die X::Gnome.new(
        :message(
          'Unsupported, undefined, incomplete or wrongly typed options for ' ~
          self.^name ~ ': ' ~ %options.keys.join(', ')
        )
      );
    }

    # create default object
    else {
      # Default: no adjustents
      self.set-native-object(_gtk_scrolled_window_new( N-GObject, N-GObject));
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkScrolledWindow');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_scrolled_window_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkScrolledWindow');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:_gtk_scrolled_window_new:new(...)
#`{{
=begin pod
=head2 gtk_scrolled_window_new

Creates a new scrolled window.

The two arguments are the scrolled window’s adjustments; these will be shared with the scrollbars and the child widget to keep the bars in sync with the child. Usually you want to pass C<Any> for the adjustments, which will cause the scrolled window to create them for you.

Returns: a new scrolled window

  method gtk_scrolled_window_new ( N-GObject $hadjustment, N-GObject $vadjustment --> N-GObject )

=item N-GObject $hadjustment; (nullable): horizontal adjustment
=item N-GObject $vadjustment; (nullable): vertical adjustment

=end pod
}}
sub _gtk_scrolled_window_new (
  N-GObject $hadjustment, N-GObject $vadjustment --> N-GObject
) is native(&gtk-lib)
  is symbol('gtk_scrolled_window_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_scrolled_window_set_hadjustment:
=begin pod
=head2 [gtk_scrolled_window_] set_hadjustment

Sets the B<Gnome::Gtk3::Adjustment> for the horizontal scrollbar. You cannot cleanup the adjustment object afterwards because the scrolled window keeps a reference to it.

  method gtk_scrolled_window_set_hadjustment ( N-GObject $hadjustment )

=item N-GObject $hadjustment; (nullable): the B<Gnome::Gtk3::Adjustment> to use, or C<Any> to create a new one

=end pod

sub gtk_scrolled_window_set_hadjustment ( N-GObject $scrolled_window, N-GObject $hadjustment  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_scrolled_window_set_vadjustment:
=begin pod
=head2 [gtk_scrolled_window_] set_vadjustment

Sets the B<Gnome::Gtk3::Adjustment> for the vertical scrollbar. You cannot cleanup the adjustment object afterwards because the scrolled window keeps a reference to it.

  method gtk_scrolled_window_set_vadjustment ( N-GObject $vadjustment )

=item N-GObject $vadjustment; (nullable): the B<Gnome::Gtk3::Adjustment> to use, or C<Any> to create a new one.

=end pod

sub gtk_scrolled_window_set_vadjustment ( N-GObject $scrolled_window, N-GObject $vadjustment  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_scrolled_window_get_hadjustment:
=begin pod
=head2 [gtk_scrolled_window_] get_hadjustment

Returns the horizontal scrollbar’s adjustment, used to connect the
horizontal scrollbar to the child widget’s horizontal scroll
functionality.

Returns: (transfer none): the horizontal B<Gnome::Gtk3::Adjustment>

  method gtk_scrolled_window_get_hadjustment ( --> N-GObject )


=end pod

sub gtk_scrolled_window_get_hadjustment ( N-GObject $scrolled_window --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_scrolled_window_get_vadjustment:
=begin pod
=head2 [gtk_scrolled_window_] get_vadjustment

Returns the vertical scrollbar’s adjustment, used to connect the
vertical scrollbar to the child widget’s vertical scroll functionality.

Returns: (transfer none): the vertical B<Gnome::Gtk3::Adjustment>

  method gtk_scrolled_window_get_vadjustment ( --> N-GObject )


=end pod

sub gtk_scrolled_window_get_vadjustment ( N-GObject $scrolled_window --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_hscrollbar:
=begin pod
=head2 [gtk_scrolled_window_] get_hscrollbar

Returns the horizontal scrollbar of I<scrolled_window>.

Returns: (transfer none): the horizontal scrollbar of the scrolled window.


  method gtk_scrolled_window_get_hscrollbar ( --> N-GObject )


=end pod

sub gtk_scrolled_window_get_hscrollbar ( N-GObject $scrolled_window --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_vscrollbar:
=begin pod
=head2 [gtk_scrolled_window_] get_vscrollbar

Returns the vertical scrollbar of I<scrolled_window>.

Returns: (transfer none): the vertical scrollbar of the scrolled window.


  method gtk_scrolled_window_get_vscrollbar ( --> N-GObject )


=end pod

sub gtk_scrolled_window_get_vscrollbar ( N-GObject $scrolled_window --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_set_policy:
=begin pod
=head2 [gtk_scrolled_window_] set_policy

Sets the scrollbar policy for the horizontal and vertical scrollbars.

The policy determines when the scrollbar should appear; it is a value
from the B<Gnome::Gtk3::PolicyType> enumeration. If C<GTK_POLICY_ALWAYS>, the
scrollbar is always present; if C<GTK_POLICY_NEVER>, the scrollbar is
never present; if C<GTK_POLICY_AUTOMATIC>, the scrollbar is present only
if needed (that is, if the slider part of the bar would be smaller
than the trough — the display is larger than the page size).

  method gtk_scrolled_window_set_policy ( GtkPolicyType $hscrollbar_policy, GtkPolicyType $vscrollbar_policy )

=item GtkPolicyType $hscrollbar_policy; policy for horizontal bar
=item GtkPolicyType $vscrollbar_policy; policy for vertical bar

=end pod

sub gtk_scrolled_window_set_policy ( N-GObject $scrolled_window, int32 $hscrollbar_policy, int32 $vscrollbar_policy  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_policy:
=begin pod
=head2 [gtk_scrolled_window_] get_policy

Retrieves the current policy values for the horizontal and vertical
scrollbars. See C<gtk_scrolled_window_set_policy()>.

  method gtk_scrolled_window_get_policy ( GtkPolicyType $hscrollbar_policy, GtkPolicyType $vscrollbar_policy )

=item GtkPolicyType $hscrollbar_policy; (out) (optional): location to store the policy for the horizontal scrollbar, or C<Any>
=item GtkPolicyType $vscrollbar_policy; (out) (optional): location to store the policy for the vertical scrollbar, or C<Any>

=end pod

sub gtk_scrolled_window_get_policy ( N-GObject $scrolled_window, int32 $hscrollbar_policy, int32 $vscrollbar_policy  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_set_placement:
=begin pod
=head2 [gtk_scrolled_window_] set_placement

Sets the placement of the contents with respect to the scrollbars
for the scrolled window.

The default is C<GTK_CORNER_TOP_LEFT>, meaning the child is
in the top left, with the scrollbars underneath and to the right.
Other values in B<Gnome::Gtk3::CornerType> are C<GTK_CORNER_TOP_RIGHT>,
C<GTK_CORNER_BOTTOM_LEFT>, and C<GTK_CORNER_BOTTOM_RIGHT>.

See also C<gtk_scrolled_window_get_placement()> and
C<gtk_scrolled_window_unset_placement()>.

  method gtk_scrolled_window_set_placement ( GtkCornerType $window_placement )

=item GtkCornerType $window_placement; position of the child window

=end pod

sub gtk_scrolled_window_set_placement ( N-GObject $scrolled_window, int32 $window_placement  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_unset_placement:
=begin pod
=head2 [gtk_scrolled_window_] unset_placement

Unsets the placement of the contents with respect to the scrollbars
for the scrolled window. If no window placement is set for a scrolled
window, it defaults to C<GTK_CORNER_TOP_LEFT>.

See also C<gtk_scrolled_window_set_placement()> and
C<gtk_scrolled_window_get_placement()>.


  method gtk_scrolled_window_unset_placement ( )


=end pod

sub gtk_scrolled_window_unset_placement ( N-GObject $scrolled_window  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_placement:
=begin pod
=head2 [gtk_scrolled_window_] get_placement

Gets the placement of the contents with respect to the scrollbars
for the scrolled window. See C<gtk_scrolled_window_set_placement()>.

Returns: the current placement value.

See also C<gtk_scrolled_window_set_placement()> and
C<gtk_scrolled_window_unset_placement()>.

  method gtk_scrolled_window_get_placement ( --> GtkCornerType )


=end pod

sub gtk_scrolled_window_get_placement ( N-GObject $scrolled_window --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_set_shadow_type:
=begin pod
=head2 [gtk_scrolled_window_] set_shadow_type

Changes the type of shadow drawn around the contents of
I<scrolled_window>.

  method gtk_scrolled_window_set_shadow_type ( GtkShadowType $type )

=item GtkShadowType $type; kind of shadow to draw around scrolled window contents

=end pod

sub gtk_scrolled_window_set_shadow_type ( N-GObject $scrolled_window, int32 $type  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_shadow_type:
=begin pod
=head2 [gtk_scrolled_window_] get_shadow_type

Gets the shadow type of the scrolled window. See
C<gtk_scrolled_window_set_shadow_type()>.

Returns: the current shadow type

  method gtk_scrolled_window_get_shadow_type ( --> GtkShadowType )


=end pod

sub gtk_scrolled_window_get_shadow_type ( N-GObject $scrolled_window --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_min_content_width:
=begin pod
=head2 [gtk_scrolled_window_] get_min_content_width

Gets the minimum content width of I<scrolled_window>, or -1 if not set.

Returns: the minimum content width


  method gtk_scrolled_window_get_min_content_width ( --> Int )


=end pod

sub gtk_scrolled_window_get_min_content_width ( N-GObject $scrolled_window --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_set_min_content_width:
=begin pod
=head2 [gtk_scrolled_window_] set_min_content_width

Sets the minimum width that I<scrolled_window> should keep visible.
Note that this can and (usually will) be smaller than the minimum
size of the content.

It is a programming error to set the minimum content width to a
value greater than  I<max-content-width>.


  method gtk_scrolled_window_set_min_content_width ( Int $width )

=item Int $width; the minimal content width

=end pod

sub gtk_scrolled_window_set_min_content_width ( N-GObject $scrolled_window, int32 $width  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_min_content_height:
=begin pod
=head2 [gtk_scrolled_window_] get_min_content_height

Gets the minimal content height of I<scrolled_window>, or -1 if not set.

Returns: the minimal content height


  method gtk_scrolled_window_get_min_content_height ( --> Int )


=end pod

sub gtk_scrolled_window_get_min_content_height ( N-GObject $scrolled_window --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_set_min_content_height:
=begin pod
=head2 [gtk_scrolled_window_] set_min_content_height

Sets the minimum height that I<scrolled_window> should keep visible.
Note that this can and (usually will) be smaller than the minimum
size of the content.

It is a programming error to set the minimum content height to a
value greater than  I<max-content-height>.


  method gtk_scrolled_window_set_min_content_height ( Int $height )

=item Int $height; the minimal content height

=end pod

sub gtk_scrolled_window_set_min_content_height ( N-GObject $scrolled_window, int32 $height  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_set_kinetic_scrolling:
=begin pod
=head2 [gtk_scrolled_window_] set_kinetic_scrolling

Turns kinetic scrolling on or off.
Kinetic scrolling only applies to devices with source
C<GDK_SOURCE_TOUCHSCREEN>.


  method gtk_scrolled_window_set_kinetic_scrolling ( Int $kinetic_scrolling )

=item Int $kinetic_scrolling; C<1> to enable kinetic scrolling

=end pod

sub gtk_scrolled_window_set_kinetic_scrolling ( N-GObject $scrolled_window, int32 $kinetic_scrolling  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_kinetic_scrolling:
=begin pod
=head2 [gtk_scrolled_window_] get_kinetic_scrolling

Returns the specified kinetic scrolling behavior.

Returns: the scrolling behavior flags.


  method gtk_scrolled_window_get_kinetic_scrolling ( --> Int )


=end pod

sub gtk_scrolled_window_get_kinetic_scrolling ( N-GObject $scrolled_window --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_set_capture_button_press:
=begin pod
=head2 [gtk_scrolled_window_] set_capture_button_press

Changes the behaviour of I<scrolled_window> with regard to the initial
event that possibly starts kinetic scrolling. When I<capture_button_press>
is set to C<1>, the event is captured by the scrolled window, and
then later replayed if it is meant to go to the child widget.

This should be enabled if any child widgets perform non-reversible
actions on  I<button-press-event>. If they don't, and handle
additionally handle  I<grab-broken-event>, it might be better
to set I<capture_button_press> to C<0>.

This setting only has an effect if kinetic scrolling is enabled.


  method gtk_scrolled_window_set_capture_button_press ( Int $capture_button_press )

=item Int $capture_button_press; C<1> to capture button presses

=end pod

sub gtk_scrolled_window_set_capture_button_press ( N-GObject $scrolled_window, int32 $capture_button_press  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_capture_button_press:
=begin pod
=head2 [gtk_scrolled_window_] get_capture_button_press

Return whether button presses are captured during kinetic
scrolling. See C<gtk_scrolled_window_set_capture_button_press()>.

Returns: C<1> if button presses are captured during kinetic scrolling


  method gtk_scrolled_window_get_capture_button_press ( --> Int )


=end pod

sub gtk_scrolled_window_get_capture_button_press ( N-GObject $scrolled_window --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_set_overlay_scrolling:
=begin pod
=head2 [gtk_scrolled_window_] set_overlay_scrolling

Enables or disables overlay scrolling for this scrolled window.


  method gtk_scrolled_window_set_overlay_scrolling ( Int $overlay_scrolling )

=item Int $overlay_scrolling; whether to enable overlay scrolling

=end pod

sub gtk_scrolled_window_set_overlay_scrolling ( N-GObject $scrolled_window, int32 $overlay_scrolling  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_overlay_scrolling:
=begin pod
=head2 [gtk_scrolled_window_] get_overlay_scrolling

Returns whether overlay scrolling is enabled for this scrolled window.

Returns: C<1> if overlay scrolling is enabled


  method gtk_scrolled_window_get_overlay_scrolling ( --> Int )


=end pod

sub gtk_scrolled_window_get_overlay_scrolling ( N-GObject $scrolled_window --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_set_max_content_width:
=begin pod
=head2 [gtk_scrolled_window_] set_max_content_width

Sets the maximum width that I<scrolled_window> should keep visible. The
I<scrolled_window> will grow up to this width before it starts scrolling
the content.

It is a programming error to set the maximum content width to a value
smaller than  I<min-content-width>.


  method gtk_scrolled_window_set_max_content_width ( Int $width )

=item Int $width; the maximum content width

=end pod

sub gtk_scrolled_window_set_max_content_width ( N-GObject $scrolled_window, int32 $width  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_max_content_width:
=begin pod
=head2 [gtk_scrolled_window_] get_max_content_width

Returns the maximum content width set.

Returns: the maximum content width, or -1


  method gtk_scrolled_window_get_max_content_width ( --> Int )


=end pod

sub gtk_scrolled_window_get_max_content_width ( N-GObject $scrolled_window --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_set_max_content_height:
=begin pod
=head2 [gtk_scrolled_window_] set_max_content_height

Sets the maximum height that I<scrolled_window> should keep visible. The
I<scrolled_window> will grow up to this height before it starts scrolling
the content.

It is a programming error to set the maximum content height to a value
smaller than  I<min-content-height>.


  method gtk_scrolled_window_set_max_content_height ( Int $height )

=item Int $height; the maximum content height

=end pod

sub gtk_scrolled_window_set_max_content_height ( N-GObject $scrolled_window, int32 $height  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_max_content_height:
=begin pod
=head2 [gtk_scrolled_window_] get_max_content_height

Returns the maximum content height set.

Returns: the maximum content height, or -1


  method gtk_scrolled_window_get_max_content_height ( --> Int )


=end pod

sub gtk_scrolled_window_get_max_content_height ( N-GObject $scrolled_window --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_set_propagate_natural_width:
=begin pod
=head2 [gtk_scrolled_window_] set_propagate_natural_width

Sets whether the natural width of the child should be calculated and propagated
through the scrolled window’s requested natural width.


  method gtk_scrolled_window_set_propagate_natural_width ( Int $propagate )

=item Int $propagate; whether to propagate natural width

=end pod

sub gtk_scrolled_window_set_propagate_natural_width ( N-GObject $scrolled_window, int32 $propagate  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_propagate_natural_width:
=begin pod
=head2 [gtk_scrolled_window_] get_propagate_natural_width

Reports whether the natural width of the child will be calculated and propagated
through the scrolled window’s requested natural width.

Returns: whether natural width propagation is enabled.


  method gtk_scrolled_window_get_propagate_natural_width ( --> Int )


=end pod

sub gtk_scrolled_window_get_propagate_natural_width ( N-GObject $scrolled_window --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_set_propagate_natural_height:
=begin pod
=head2 [gtk_scrolled_window_] set_propagate_natural_height

Sets whether the natural height of the child should be calculated and propagated
through the scrolled window’s requested natural height.


  method gtk_scrolled_window_set_propagate_natural_height ( Int $propagate )

=item Int $propagate; whether to propagate natural height

=end pod

sub gtk_scrolled_window_set_propagate_natural_height ( N-GObject $scrolled_window, int32 $propagate  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_scrolled_window_get_propagate_natural_height:
=begin pod
=head2 [gtk_scrolled_window_] get_propagate_natural_height

Reports whether the natural height of the child will be calculated and propagated
through the scrolled window’s requested natural height.

Returns: whether natural height propagation is enabled.


  method gtk_scrolled_window_get_propagate_natural_height ( --> Int )


=end pod

sub gtk_scrolled_window_get_propagate_natural_height ( N-GObject $scrolled_window --> int32 )
  is native(&gtk-lib)
  { * }

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


=comment #TS:0:scroll-child:
=head3 scroll-child

The I<scroll-child> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when a keybinding that scrolls is pressed.
The horizontal or vertical adjustment is updated which triggers a
signal that the scrolled window’s child may listen to and scroll itself.

  method handler (
    Unknown type GTK_TYPE_SCROLL_TYPE $scroll,
    Int $horizontal,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($scrolled_window),
    *%user-options
    --> Int
  );

=item $scrolled_window; a B<Gnome::Gtk3::ScrolledWindow>

=item $scroll; a B<Gnome::Gtk3::ScrollType> describing how much to scroll

=item $horizontal; whether the keybinding scrolls the child
horizontally or not

=comment #TS:0:move-focus-out:
=head3 move-focus-out

The I<move-focus-out> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>] which gets
emitted when focus is moved away from the scrolled window by a
keybinding. The  I<move-focus> signal is emitted with
I<direction_type> on this scrolled window’s toplevel parent in the
container hierarchy. The default bindings for this signal are
`Ctrl + Tab` to move forward and `Ctrl + Shift + Tab` to move backward.

  method handler (
    Unknown type GTK_TYPE_DIRECTION_TYPE $direction_type,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($scrolled_window),
    *%user-options
  );

=item $scrolled_window; a B<Gnome::Gtk3::ScrolledWindow>

=item $direction_type; either C<GTK_DIR_TAB_FORWARD> or
C<GTK_DIR_TAB_BACKWARD>

=comment #TS:0:edge-overshot:
=head3 edge-overshot

The I<edge-overshot> signal is emitted whenever user initiated scrolling
makes the scrolled window firmly surpass (i.e. with some edge resistance)
the lower or upper limits defined by the adjustment in that orientation.

A similar behavior without edge resistance is provided by the
 I<edge-reached> signal.

Note: The I<pos> argument is LTR/RTL aware, so callers should be aware too
if intending to provide behavior on horizontal edges.


  method handler (
    Unknown type GTK_TYPE_POSITION_TYPE $pos,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($scrolled_window),
    *%user-options
  );

=item $scrolled_window; a B<Gnome::Gtk3::ScrolledWindow>

=item $pos; edge side that was hit


=comment #TS:0:edge-reached:
=head3 edge-reached

The I<edge-reached> signal is emitted whenever user-initiated scrolling
makes the scrolled window exactly reach the lower or upper limits
defined by the adjustment in that orientation.

A similar behavior with edge resistance is provided by the
 I<edge-overshot> signal.

Note: The I<pos> argument is LTR/RTL aware, so callers should be aware too
if intending to provide behavior on horizontal edges.


  method handler (
    Unknown type GTK_TYPE_POSITION_TYPE $pos,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($scrolled_window),
    *%user-options
  );

=item $scrolled_window; a B<Gnome::Gtk3::ScrolledWindow>

=item $pos; edge side that was reached


=end pod
