#TL:1:Gnome::Gtk3::ProgressBar:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ProgressBar

A widget which indicates progress visually

![](images/progressbar.png)

=head1 Description

The B<Gnome::Gtk3::ProgressBar> is typically used to display the progress of a long running operation. It provides a visual clue that processing is underway. The B<Gnome::Gtk3::ProgressBar> can be used in two different modes: percentage mode and activity mode.

When an application can determine how much work needs to take place (e.g. read a fixed number of bytes from a file) and can monitor its progress, it can use the B<Gnome::Gtk3::ProgressBar> in percentage mode and the user sees a growing bar indicating the percentage of the work that has been completed. In this mode, the application is required to call C<gtk_progress_bar_set_fraction()> periodically to update the progress bar.

When an application has no accurate way of knowing the amount of work to do, it can use the B<Gnome::Gtk3::ProgressBar> in activity mode, which shows activity by a block moving back and forth within the progress area. In this mode, the application is required to call C<gtk_progress_bar_pulse()> periodically to update the progress bar.

There is quite a bit of flexibility provided to control the appearance of the B<Gnome::Gtk3::ProgressBar>. Functions are provided to control the orientation of the bar, optional text can be displayed along with the bar, and the step size used in activity mode can be set.

=head2 Css Nodes

  progressbar[.osd]
  ├── [text]
  ╰── trough[.empty][.full]
      ╰── progress[.pulse]

B<Gnome::Gtk3::ProgressBar> has a main CSS node with name progressbar and subnodes with names text and trough, of which the latter has a subnode named progress. The text subnode is only present if text is shown. The progress subnode has the style class .pulse when in activity mode. It gets the style classes .left, .right, .top or .bottom added when the progress 'touches' the corresponding end of the B<Gnome::Gtk3::ProgressBar>. The .osd class on the progressbar node is for use in overlays like the one Epiphany has for page loading progress.

=head2 Implemented Interfaces

Gnome::Gtk3::ProgressBar implements
=item [Gnome::Gtk3::Orientable](Orientable.html)

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ProgressBar;
  also is Gnome::Gtk3::Widget;
  also does Gnome::Gtk3::Orientable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Orientable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ProgressBar:auth<github:MARTIMM>;
also is Gnome::Gtk3::Widget;
also does Gnome::Gtk3::Orientable;

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
  return unless self.^name eq 'Gnome::Gtk3::ProgressBar';

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
    self._set-native-object(gtk_progress_bar_new());
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkProgressBar');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_progress_bar_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkProgressBar');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_progress_bar_new:new()
=begin pod
=head2 gtk_progress_bar_new

Creates a new B<Gnome::Gtk3::ProgressBar>.

Returns: a B<Gnome::Gtk3::ProgressBar>.

  method gtk_progress_bar_new ( --> N-GObject )

=end pod

sub gtk_progress_bar_new (  --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_progress_bar_pulse:
=begin pod
=head2 gtk_progress_bar_pulse

Indicates that some progress has been made, but you don’t know how much. Causes the progress bar to enter “activity mode,” where a block bounces back and forth. Each call to C<gtk_progress_bar_pulse()> causes the block to move by a little bit (the amount of movement per pulse is determined by C<gtk_progress_bar_set_pulse_step()>).

  method gtk_progress_bar_pulse ( )

=end pod

sub gtk_progress_bar_pulse ( N-GObject $pbar  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_progress_bar_set_text:
=begin pod
=head2 [gtk_progress_bar_] set_text

Causes the given I<text> to appear next to the progress bar.

If I<text> is C<Any> and  I<show-text> is C<1>, the current
value of  I<fraction> will be displayed as a percentage.

If I<text> is non-C<Any> and  I<show-text> is C<1>, the text
will be displayed. In this case, it will not display the progress
percentage. If I<text> is the empty string, the progress bar will still
be styled and sized suitably for containing text, as long as
 I<show-text> is C<1>.

  method gtk_progress_bar_set_text ( Str $text )

=item Str $text; (allow-none): a UTF-8 string, or C<Any>

=end pod

sub gtk_progress_bar_set_text ( N-GObject $pbar, Str $text  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_progress_bar_set_fraction:
=begin pod
=head2 [gtk_progress_bar_] set_fraction

Causes the progress bar to “fill in” the given fraction
of the bar. The fraction should be between 0.0 and 1.0,
inclusive.

  method gtk_progress_bar_set_fraction ( Num $fraction )

=item Num $fraction; fraction of the task that’s been completed

=end pod

sub gtk_progress_bar_set_fraction ( N-GObject $pbar, num64 $fraction  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_progress_bar_set_pulse_step:
=begin pod
=head2 [gtk_progress_bar_] set_pulse_step

Sets the fraction of total progress bar length to move the
bouncing block for each call to C<gtk_progress_bar_pulse()>.

  method gtk_progress_bar_set_pulse_step ( Num $fraction )

=item Num $fraction; fraction between 0.0 and 1.0

=end pod

sub gtk_progress_bar_set_pulse_step ( N-GObject $pbar, num64 $fraction  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_progress_bar_set_inverted:
=begin pod
=head2 [gtk_progress_bar_] set_inverted

Progress bars normally grow from top to bottom or left to right.
Inverted progress bars grow in the opposite direction.

  method gtk_progress_bar_set_inverted ( Int $inverted )

=item Int $inverted; C<1> to invert the progress bar

=end pod

sub gtk_progress_bar_set_inverted ( N-GObject $pbar, int32 $inverted  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_progress_bar_get_text:
=begin pod
=head2 [gtk_progress_bar_] get_text

Retrieves the text that is displayed with the progress bar,
if any, otherwise C<Any>. The return value is a reference
to the text, not a copy of it, so will become invalid
if you change the text in the progress bar.

Returns: (nullable): text, or C<Any>; this string is owned by the widget
and should not be modified or freed.

  method gtk_progress_bar_get_text ( --> Str )


=end pod

sub gtk_progress_bar_get_text ( N-GObject $pbar --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_progress_bar_get_fraction:
=begin pod
=head2 [gtk_progress_bar_] get_fraction

Returns the current fraction of the task that’s been completed.

Returns: a fraction from 0.0 to 1.0

  method gtk_progress_bar_get_fraction ( --> Num )


=end pod

sub gtk_progress_bar_get_fraction ( N-GObject $pbar --> num64 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_progress_bar_get_pulse_step:
=begin pod
=head2 [gtk_progress_bar_] get_pulse_step

Retrieves the pulse step set with C<gtk_progress_bar_set_pulse_step()>.

Returns: a fraction from 0.0 to 1.0

  method gtk_progress_bar_get_pulse_step ( --> Num )


=end pod

sub gtk_progress_bar_get_pulse_step ( N-GObject $pbar --> num64 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_progress_bar_get_inverted:
=begin pod
=head2 [gtk_progress_bar_] get_inverted

Gets the value set by C<gtk_progress_bar_set_inverted()>.

Returns: C<1> if the progress bar is inverted

  method gtk_progress_bar_get_inverted ( --> Int )


=end pod

sub gtk_progress_bar_get_inverted ( N-GObject $pbar --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_progress_bar_set_ellipsize:
=begin pod
=head2 [gtk_progress_bar_] set_ellipsize

Sets the mode used to ellipsize (add an ellipsis: "...") the
text if there is not enough space to render the entire string.

Since: 2.6

  method gtk_progress_bar_set_ellipsize ( PangoEllipsizeMode $mode )

=item PangoEllipsizeMode $mode; a B<PangoEllipsizeMode>

=end pod

sub gtk_progress_bar_set_ellipsize ( N-GObject $pbar, int32 $mode  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_progress_bar_get_ellipsize:
=begin pod
=head2 [gtk_progress_bar_] get_ellipsize

Returns the ellipsizing position of the progress bar.
See C<gtk_progress_bar_set_ellipsize()>.

Returns: B<PangoEllipsizeMode>

Since: 2.6

  method gtk_progress_bar_get_ellipsize ( --> PangoEllipsizeMode )


=end pod

sub gtk_progress_bar_get_ellipsize ( N-GObject $pbar --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_progress_bar_set_show_text:
=begin pod
=head2 [gtk_progress_bar_] set_show_text

Sets whether the progress bar will show text next to the bar.
The shown text is either the value of the  I<text>
property or, if that is C<Any>, the  I<fraction> value,
as a percentage.

To make a progress bar that is styled and sized suitably for containing
text (even if the actual text is blank), set  I<show-text> to
C<1> and  I<text> to the empty string (not C<Any>).

Since: 3.0

  method gtk_progress_bar_set_show_text ( Int $show_text )

=item Int $show_text; whether to show text

=end pod

sub gtk_progress_bar_set_show_text ( N-GObject $pbar, int32 $show_text  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_progress_bar_get_show_text:
=begin pod
=head2 [gtk_progress_bar_] get_show_text

Gets the value of the  I<show-text> property.
See C<gtk_progress_bar_set_show_text()>.

Returns: C<1> if text is shown in the progress bar

Since: 3.0

  method gtk_progress_bar_get_show_text ( --> Int )


=end pod

sub gtk_progress_bar_get_show_text ( N-GObject $pbar --> int32 )
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

=comment #TP:1:inverted:
=head3 Inverted

Invert the direction in which the progress bar grows
Default value: False

The B<Gnome::GObject::Value> type of property I<inverted> is C<G_TYPE_BOOLEAN>.

=comment #TP:1:fraction:
=head3 Fraction

The fraction of total work that has been completed.

The B<Gnome::GObject::Value> type of property I<fraction> is C<G_TYPE_DOUBLE>.

=comment #TP:1:pulse-step:
=head3 Pulse Step

The fraction of total progress to move the bouncing block when pulsed.

The B<Gnome::GObject::Value> type of property I<pulse-step> is C<G_TYPE_DOUBLE>.

=comment #TP:0:text:
=head3 Text

Text to be displayed in the progress bar Default value: Any

The B<Gnome::GObject::Value> type of property I<text> is C<G_TYPE_STRING>.

=comment #TP:1:show-text:
=head3 Show text

Sets whether the progress bar will show a text in addition to the bar itself. The shown text is either the value of the  I<text> property or, if that is C<Any>, the  I<fraction> value, as a percentage. To make a progress bar that is styled and sized suitably for showing text (even if the actual text is blank), set I<show-text> to C<1> and  I<text> to the empty string (not C<Any>).

Since: 3.0

The B<Gnome::GObject::Value> type of property I<show-text> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:ellipsize:
=head3 Ellipsize

The preferred place to ellipsize the string, if the progress bar does not have enough room to display the entire string, specified as a B<PangoEllipsizeMode>. Note that setting this property to a value other than C<PANGO_ELLIPSIZE_NONE> has the side-effect that the progress bar requests only enough space to display the ellipsis ("..."). Another means to set a progress bar's width is C<gtk_widget_set_size_request()>.

Since: 2.6 Widget type: PANGO_TYPE_ELLIPSIZE_MODE

The B<Gnome::GObject::Value> type of property I<ellipsize> is C<G_TYPE_ENUM>.
=end pod
