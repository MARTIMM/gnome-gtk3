#TL:1:Gnome::Gtk3::Scale:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Scale

A slider widget for selecting a value from a range

![](images/scales.png)

=head1 Description


A B<Gnome::Gtk3::Scale> is a slider control used to select a numeric value. To use it, you’ll probably want to investigate the methods on its base class, B<Gnome::Gtk3::Range>, in addition to the methods for B<Gnome::Gtk3::Scale> itself. To set the value of a scale, you would normally use C<gtk_range_set_value()>. To detect changes to the value, you would normally use the I<value-changed> signal.

Note that using the same upper and lower bounds for the B<Gnome::Gtk3::Scale> (through the B<Gnome::Gtk3::Range> methods) will hide the slider itself. This is useful for applications that want to show an undeterminate value on the scale, without changing the layout of the application (such as movie or music players).

=head2 B<Gnome::Gtk3::Scale> as B<Gnome::Gtk3::Buildable>

B<Gnome::Gtk3::Scale> supports a custom <marks> element, which can contain multiple C<<mark>> elements. The “value” and “position” attributes have the same meaning as C<gtk_scale_add_mark()> parameters of the same name. If the element is not empty, its content is taken as the markup to show at the mark. It can be translated with the usual ”translatable” and “context” attributes.

=head2 Css Nodes

  scale[.fine-tune][.marks-before][.marks-after]
  ├── marks.top
  │   ├── mark
  │   ┊    ├── [label]
  │   ┊    ╰── indicator
  ┊   ┊
  │   ╰── mark
  ├── [value]
  ├── contents
  │   ╰── trough
  │       ├── slider
  │       ├── [highlight]
  │       ╰── [fill]
  ╰── marks.bottom
      ├── mark
      ┊    ├── indicator
      ┊    ╰── [label]
      ╰── mark

B<Gnome::Gtk3::Scale> has a main CSS node with name scale and a subnode for its contents, with subnodes named trough and slider.

The main node gets the style class .fine-tune added when the scale is in 'fine-tuning' mode.

If the scale has an origin (see C<gtk_scale_set_has_origin()>), there is a subnode with name highlight below the trough node that is used for rendering the highlighted part of the trough.

If the scale is showing a fill level (see C<gtk_range_set_show_fill_level()>), there is a subnode with name fill below the trough node that is used for rendering the filled in part of the trough.

If marks are present, there is a marks subnode before or after the contents node, below which each mark gets a node with name mark. The marks nodes get either the .top or .bottom style class.

The mark node has a subnode named indicator. If the mark has text, it also has a subnode named label. When the mark is either above or left of the scale, the label subnode is the first when present. Otherwise, the indicator subnode is the first.

The main CSS node gets the 'marks-before' and/or 'marks-after' style classes added depending on what marks are present.

If the scale is displaying the value (see  I<draw-value>), there is subnode with name value.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Scale;
  also is Gnome::Gtk3::Range;

=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Scale;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Scale;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Scale class process the options
    self.bless( :GtkScale, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=head2 Example

  my Gnome::Gtk3::Scale $scale .= new;

  # Set min and max of scale.
  $scale.set-range( -2e0, .2e2);

  # Step (keys left/right) and page (mouse scroll on scale).
  $scale.set-increments( .2e0, 5e0);

  # Value of current position displayed below the scale
  $scale.set-value-pos(GTK_POS_BOTTOM);

  # Want to have two digits after the commma
  $scale.set-digits(2);

  # Want to have some scale ticks also below the scale
  $scale.add-mark( 0e0, GTK_POS_BOTTOM, 'Zero');
  $scale.add-mark( 5e0, GTK_POS_BOTTOM, 'Five');
  $scale.add-mark( 10e0, GTK_POS_BOTTOM, 'Ten');
  $scale.add-mark( 15e0, GTK_POS_BOTTOM, 'Fifteen');
  $scale.add-mark( 20e0, GTK_POS_BOTTOM, 'Twenty');

=end pod

#Result will be like L<this scale detail | https://github.com/MARTIMM/gtk-v3/blob/master/doc/Design-docs/ex-GtkScale-detail.png>.

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Range;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkscale.h
# https://developer.gnome.org/gtk3/stable/GtkScale.html
unit class Gnome::Gtk3::Scale:auth<github:MARTIMM>:ver<0.2.0>;
also is Gnome::Gtk3::Range;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Creates a new B<Gnome::Gtk3::Scale> based on ahorizontal orientation and an undefined adjustment. See below.

  multi method new ( )

Creates a new B<Gnome::Gtk3::Scale> based on an orientation and adjustment.

  multi method new ( GtkOrientation :$orientation!, N-GObject :$adjustment! )

=item $orientation; the scale’s orientation.
=item $adjustment; a value of type B<Gnome::Gtk3::Adjustment> which sets the range of the scale, or NULL to create a new adjustment.


Creates a new scale widget with the given orientation that lets the user input a number between I<$min> and I<$max> (including I<$min> and I<$max>) with the increment I<step>.  I<step> must be nonzero; it’s the distance the slider moves when using the arrow keys to adjust the scale value.

Note that the way in which the precision is derived works best if I<$step> is a power of ten. If the resulting precision is not suitable for your needs, use C<gtk_scale_set_digits()> to correct it.

  multi method new (
    GtkOrientation :$orientation!, Num $min!, Num $max!, Num $step!
  )

=item $orientation; the scale’s orientation. Value is a GtkOrientation enum from GtkEnums.
=item $min; minimum value
=item $max; maximum value
=item $step; step increment (tick size) used with keyboard shortcuts

  multi method new ( :$native-object! )

Create an object using a native object from elsewhere. See also Gnome::GObject::Object.

  multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also Gnome::GObject::Object.

=end pod

#TM:1:new():
#TM:4:new(:min,:max,:step):QAManager
#TM:4:new(:native-object):TopLevelClassSupport
#TM:4:new(:build-id):Object

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :double<format-value>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Scale' or %options<GtkScale> {

    # process all named arguments
    if self.is-valid { }

    # process all named arguments
    elsif %options<native-object>:exists or %options<widget>:exists or
      %options<build-id>:exists { }

    else {
      my $no;

      if %options<orientation>.defined and ? %options<min>.defined and
         %options<max>.defined and %options<step>.defined {

        $no = _gtk_scale_new_with_range(
          %options<orientation>,
          %options<min>.Num, %options<max>.Num, %options<step>.Num
        );
      }
#`{{
      elsif %options.keys.elems {
        die X::Gnome.new(
          :message('Unsupported options for ' ~ self.^name ~
                   ': ' ~ %options.keys.join(', ')
                  )
        );
      }
}}
      elsif %options<orientation>.defined and ? %options<adjustment>.defined {
        # get the native adjustment
        $no = %options<adjustment>;
        $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        # now create the native scale
        $no = _gtk_scale_new( %options<orientation>, $no);
      }

      else {
        $no = _gtk_scale_new( GTK_ORIENTATION_HORIZONTAL, Any);
      }

      self.set-native-object($no);
    }

    # only after creating the widget, the gtype is known
    self.set-class-info('GtkScale');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_scale_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkScale');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:_gtk_scale_new:new()
#`{{
=begin pod
=head2 [gtk_] scale_new

Creates a new B<Gnome::Gtk3::Scale>.

Returns: a new B<Gnome::Gtk3::Scale>


  method gtk_scale_new ( GtkOrientation $orientation, N-GObject $adjustment --> N-GObject  )

=item GtkOrientation $orientation; the scale’s orientation.
=item N-GObject $adjustment; (nullable): the B<Gnome::Gtk3::Adjustment> which sets the range of the scale, or C<Any> to create a new adjustment.

=end pod
}}

sub _gtk_scale_new ( int32 $orientation, N-GObject $adjustment --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_scale_new')
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gtk_scale_new_with_range:new(:orientation,:min,:max,:step)
#`{{
=begin pod
=head2 [[gtk_] scale_] new_with_range

Creates a new scale widget with the given orientation that lets the
user input a number between I<min> and I<max> (including I<min> and I<max>)
with the increment I<step>.  I<step> must be nonzero; it’s the distance
the slider moves when using the arrow keys to adjust the scale
value.

Note that the way in which the precision is derived works best if I<step>
is a power of ten. If the resulting precision is not suitable for your
needs, use C<gtk_scale_set_digits()> to correct it.

Returns: a new B<Gnome::Gtk3::Scale>


  method gtk_scale_new_with_range ( GtkOrientation $orientation, Num $min, Num $max, Num $step --> N-GObject  )

=item GtkOrientation $orientation; the scale’s orientation.
=item Num $min; minimum value
=item Num $max; maximum value
=item Num $step; step increment (tick size) used with keyboard shortcuts

=end pod
}}

sub _gtk_scale_new_with_range ( int32 $orientation, num64 $min, num64 $max, num64 $step --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_scale_new_with_range')
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-digits:
=begin pod
=head2 set-digits

Sets the number of decimal places that are displayed in the value. Also causes the value of the adjustment to be rounded to this number of digits, so the retrieved value matches the displayed one, if  I<draw-value> is C<1> when the value changes. If you want to enforce rounding the value when  I<draw-value> is C<0>, you can set  I<round-digits> instead.  Note that rounding to a small number of digits can interfere with the smooth autoscrolling that is built into B<Gnome::Gtk3::Scale>. As an alternative, you can use the  I<format-value> signal to format the displayed value yourself.

  method set-digits ( Int $digits )

=item Int $digits; the number of decimal places to display, e.g. use 1 to display 1.0, 2 to display 1.00, etc

=end pod

method set-digits ( Int $digits ) {
  gtk_scale_set_digits(
    self.get-native-object-no-reffing, $digits
  );
}

sub gtk_scale_set_digits ( N-GObject $scale, gint $digits  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-digits:
=begin pod
=head2 get-digits

Gets the number of decimal places that are displayed in the value.

Returns: the number of decimal places that are displayed

  method get-digits ( --> Int )

=end pod

method get-digits ( --> Int ) {
  gtk_scale_get_digits(
    self.get-native-object-no-reffing,
  );
}

sub gtk_scale_get_digits ( N-GObject $scale --> gint )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-draw-value:
=begin pod
=head2 set-draw-value

Specifies whether the current value is displayed as a string next  to the slider.

  method set-draw-value ( Bool $draw_value )

=item Int $draw_value; C<True> to draw the value

=end pod

method set-draw-value ( $draw_value ) {
  gtk_scale_set_draw_value(
    self.get-native-object-no-reffing, $draw_value.Int
  );
}

sub gtk_scale_set_draw_value ( N-GObject $scale, gboolean $draw_value  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-draw-value:
=begin pod
=head2 get-draw-value

Returns whether the current value is displayed as a string  next to the slider.

Returns: whether the current value is displayed as a string

  method get-draw-value ( --> Bool )

=end pod

method get-draw-value ( --> Bool ) {
  gtk_scale_get_draw_value(
    self.get-native-object-no-reffing,
  ).Bool;
}

sub gtk_scale_get_draw_value ( N-GObject $scale --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-has-origin:
=begin pod
=head2 set-has-origin

If  I<$has-origin> is set to C<True> (the default), the scale will highlight the part of the trough between the origin (bottom or left side) and the current value.

  method set-has-origin ( Bool $has_origin )

=item Int $has_origin; C<True> if the scale has an origin

=end pod

method set-has-origin ( $has_origin ) {
  gtk_scale_set_has_origin(
    self.get-native-object-no-reffing, $has_origin.Int
  );
}

sub gtk_scale_set_has_origin ( N-GObject $scale, gboolean $has_origin  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-has-origin:
=begin pod
=head2 get-has-origin

Returns whether the scale has an origin.

Returns: C<True> if the scale has an origin.

  method get-has-origin ( --> Bool )

=end pod

method get-has-origin ( --> Bool ) {
  gtk_scale_get_has_origin(
    self.get-native-object-no-reffing,
  ).Bool;
}

sub gtk_scale_get_has_origin ( N-GObject $scale --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-value-pos:
=begin pod
=head2 set-value-pos

Sets the position in which the current value is displayed.

  method set-value-pos ( GtkPositionType $pos )

=item GtkPositionType $pos; the position in which the current value is displayed

=end pod

method set-value-pos ( GtkPositionType $pos ) {
  gtk_scale_set_value_pos( self.get-native-object-no-reffing, $pos.value);
}

sub gtk_scale_set_value_pos ( N-GObject $scale, GEnum $pos )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-value-pos:
=begin pod
=head2 get-value-pos

Gets the position in which the current value is displayed.

Returns: the position in which the current value is displayed

  method get-value-pos ( --> GtkPositionType )

=end pod

method get-value-pos ( --> GtkPositionType ) {
  GtkPositionType(
    gtk_scale_get_value_pos(self.get-native-object-no-reffing)
  );
}

sub gtk_scale_get_value_pos ( N-GObject $scale --> GEnum )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-layout:
=begin pod
=head2 get-layout

Gets the B<PangoLayout> used to display the scale. The returned object is owned by the scale so does not need to be freed by the caller.

Returns: (transfer none) (nullable): the B<PangoLayout> for this scale, or C<Any> if the  I<draw-value> property is C<0>.

  method get-layout ( --> N-GObject )


=end pod

method get-layout ( --> N-GObject ) {

  gtk_scale_get_layout(
    self.get-native-object-no-reffing,
  );
}

sub gtk_scale_get_layout ( N-GObject $scale --> N-GObject )
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:get-layout-offsets:
=begin pod
=head2 get-layout-offsets

Obtains the coordinates where the scale will draw the  B<PangoLayout> representing the text in the scale. Remember when using the B<PangoLayout> function you need to convert to and from pixels using C<PANGO_PIXELS()> or B<PANGO_SCALE>.   If the  I<draw-value> property is C<0>, the return  values are undefined.

  method get-layout-offsets ( Int-ptr $x, Int-ptr $y )

=item Int-ptr $x; (out) (allow-none): location to store X offset of layout, or C<Any>
=item Int-ptr $y; (out) (allow-none): location to store Y offset of layout, or C<Any>

=end pod

method get-layout-offsets ( Int-ptr $x, Int-ptr $y ) {

  gtk_scale_get_layout_offsets(
    self.get-native-object-no-reffing, $x, $y
  );
}

sub gtk_scale_get_layout_offsets ( N-GObject $scale, gint-ptr $x, gint-ptr $y  )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:add-mark:
=begin pod
=head2 add-mark

Adds a mark at I<value>.  A mark is indicated visually by drawing a tick mark next to the scale, and GTK+ makes it easy for the user to position the scale exactly at the marks value.  If I<markup> is not C<Any>, text is shown next to the tick mark.  To remove marks from a scale, use C<gtk_scale_clear_marks()>.

  method add-mark ( Num $value, GtkPositionType $position, Str $markup )

=item Num $value; the value at which the mark is placed, must be between the lower and upper limits of the scales’ adjustment

=item GtkPositionType $position; where to draw the mark. For a horizontal scale, C<GTK_POS_TOP> and C<GTK_POS_LEFT> are drawn above the scale, anything else below. For a vertical scale, C<GTK_POS_LEFT> and C<GTK_POS_TOP> are drawn to the left of the scale, anything else to the right.

=item  Str  $markup; Text to be shown at the mark, using L<Pango markup|https://developer.gnome.org/pygtk/stable/pango-markup-language.html>, or undefined

=end pod

method add-mark ( $value, GtkPositionType $position,  Str  $markup ) {
  gtk_scale_add_mark(
    self.get-native-object-no-reffing, $value.Num, $position.value, $markup
  );
}

sub gtk_scale_add_mark ( N-GObject $scale, gdouble $value, GEnum $position, gchar-ptr $markup  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:clear-marks:
=begin pod
=head2 clear-marks

Removes any marks that have been added with C<gtk_scale_add_mark()>.

  method clear-marks ( )

=end pod

method clear-marks ( ) {

  gtk_scale_clear_marks(
    self.get-native-object-no-reffing,
  );
}

sub gtk_scale_clear_marks ( N-GObject $scale  )
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


=comment #TS:0:format-value:
=head3 format-value

Signal which allows you to change how the scale value is displayed.
Connect a signal handler which returns an allocated string representing
I<$value>. That string will then be used to display the scale's value.

Here's an example signal handler which displays a value 1.0 as
with "-->1.0<--".

  method format-value-callback (
    num64 $value, Gnome::Gtk3::Scale :widget($scale)
    --> Str
  ) {
    $value.fmt('-->%.1f<--')
  }


Returns: allocated string representing I<$value>

  method handler (
    num64 $value,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($scale),
    *%user-options
    --> Str
  );

=item $scale; the object which received the signal

=item $value; the value to format


=end pod
