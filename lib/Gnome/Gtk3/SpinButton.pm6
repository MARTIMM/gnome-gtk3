#TL:1:Gnome::Gtk3::SpinButton:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::SpinButton

Retrieve an integer or floating-point number from the user

![](images/spinbutton.png)

=head1 Description


A B<Gnome::Gtk3::SpinButton> is an ideal way to allow the user to set the value of some attribute. Rather than having to directly type a number into a B<Gnome::Gtk3::Entry>, B<Gnome::Gtk3::SpinButton> allows the user to click on one of two arrows to increment or decrement the displayed value. A value can still be typed in, with the bonus that it can be checked to ensure it is in a given range.

The main properties of a B<Gnome::Gtk3::SpinButton> are through an adjustment. See the B<Gnome::Gtk3::Adjustment> section for more details about an adjustment's properties. Note that B<Gnome::Gtk3::SpinButton> will by default make its entry large enough to accomodate the lower and upper bounds of the adjustment, which can lead to surprising results. Best practice is to set both the  I<width-chars> and  I<max-width-chars> poperties to the desired number of characters to display in the entry.


=head2 Css Nodes

  spinbutton.horizontal
  ├── undershoot.left
  ├── undershoot.right
  ├── entry
  │   ╰── ...
  ├── button.down
  ╰── button.up

  spinbutton.vertical
  ├── undershoot.left
  ├── undershoot.right
  ├── button.up
  ├── entry
  │   ╰── ...
  ╰── button.down

B<Gnome::Gtk3::SpinButtons> main CSS node has the name spinbutton. It creates subnodes for the entry and the two buttons, with these names. The button nodes have the style classes .up and .down. The B<Gnome::Gtk3::Entry> subnodes (if present) are put below the entry node. The orientation of the spin button is reflected in the .vertical or .horizontal style class on the main node.


=head2 See Also

B<Gnome::Gtk3::Entry>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::SpinButton;
  also is Gnome::Gtk3::Entry;


=head2 Uml Diagram

![](plantuml/SpinButton.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::SpinButton;

  unit class MyGuiClass;
  also is Gnome::Gtk3::SpinButton;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::SpinButton class process the options
    self.bless( :GtkSpinButton, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=head2 Example

=head3 Using a B<Gnome::Gtk3::SpinButton> to get an integer

An example which shows a B<Gnome::Gtk3::SpinButton> in a B<Gnome::Gtk3::Window> which models percentage values. The class also has a signal handler to copy an integer value from the SpinButton in a local storage. This can be retrieved by calling C<.local-store()>.

  has Int $.local-store;
  method grab-int-value ( Gnome::Gtk3::SpinButton :_widget($button) ) {
     $!local-store = $button.get-value-as-int;
  }

  method create-integer-spin-button ( ) {

    my Gnome::Gtk3::Adjustment $adjustment .= new(
      :value(50.0), :lower(0.0), :upper(100.0), :step-increment(1.0),
      :page-increment(5.0), :page-size(0.0)
    );
    $!local-store = 50.0;

    # creates the spinbutton, with no decimal places
    my Gnome::Gtk3::SpinButton $button .= new(
      :$adjustment, :climb_rate(1.0), :digits(0)
    );
    $button.register-signal( self, 'grab-int-value', 'value-changed');

    given my Gnome::Gtk3::Window $window .= new {
      .set-title('my 1st spin button demo');
      .set-border-width(5);
      .container_add($button);
      .show_all;
    }
  }


=head3 Using a B<Gnome::Gtk3::SpinButton> to get a floating point value

The second example shows a B<Gnome::Gtk3::SpinButton> which provides a method to retrieve a floating point value. The SpinButton is created as a high precision spin button.

  has Gnome::Gtk3::Window $!window;
  has Gnome::Gtk3::SpinButton $!button;

  method grab-float-value ( --> Num ) {
    $!button.get-value
  }

  method create-floating-spin-button ( ) {

    my Gnome::Gtk3::Adjustment $adjustment .= new(
      :value(2.500), :lower(0.0), :upper(5.0),
      :step-increment(0.001), :page-increment(0.1),
      :page-size(0.0)
    );

    # creates the spinbutton, with three decimal places
    $!button .= new( :$adjustment, :climb_rate(0.001), :digits(3));

    given $!window .= new {
      .set-title('my 2nd spin button demo');
      .set-border-width(5);
      .container_add($!button);
      .show_all;
    }
  }

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;

use Gnome::Gtk3::Entry;
use Gnome::Gtk3::Orientable;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::SpinButton:auth<github:MARTIMM>;
also is Gnome::Gtk3::Entry;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkSpinButtonUpdatePolicy

The spin button update policy determines whether the spin button displays values even if they are outside the bounds of its adjustment. See C<gtk_spin_button_set_update_policy()>.

=item GTK_UPDATE_ALWAYS: When refreshing your B<Gnome::Gtk3::SpinButton>, the value is always displayed
=item GTK_UPDATE_IF_VALID: When refreshing your B<Gnome::Gtk3::SpinButton>, the value is only displayed if it is valid within the bounds of the spin button's adjustment

=end pod

#TE:0:GtkSpinButtonUpdatePolicy:
enum GtkSpinButtonUpdatePolicy is export (
  'GTK_UPDATE_ALWAYS',
  'GTK_UPDATE_IF_VALID'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkSpinType

The values of the B<Gnome::Gtk3::SpinType> enumeration are used to specify the change to make in C<gtk_spin_button_spin()>.

=item GTK_SPIN_STEP_FORWARD: Increment by the adjustments step increment.
=item GTK_SPIN_STEP_BACKWARD: Decrement by the adjustments step increment.
=item GTK_SPIN_PAGE_FORWARD: Increment by the adjustments page increment.
=item GTK_SPIN_PAGE_BACKWARD: Decrement by the adjustments page increment.
=item GTK_SPIN_HOME: Go to the adjustments lower bound.
=item GTK_SPIN_END: Go to the adjustments upper bound.
=item GTK_SPIN_USER_DEFINED: Change by a specified amount.

=end pod

#TE:0:GtkSpinType:
enum GtkSpinType is export (
  'GTK_SPIN_STEP_FORWARD',
  'GTK_SPIN_STEP_BACKWARD',
  'GTK_SPIN_PAGE_FORWARD',
  'GTK_SPIN_PAGE_BACKWARD',
  'GTK_SPIN_HOME',
  'GTK_SPIN_END',
  'GTK_SPIN_USER_DEFINED'
);

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkSpinButton

The B<Gnome::Gtk3::SpinButton>-struct contains only private data and should not be directly modified.

=end pod

#TT:0:N-GtkSpinButton:
class N-GtkSpinButton is export is repr('CStruct') {
  has N-GObject $.entry;
  has GtkSpinButtonPrivate $.priv;
}
}}

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 new( :adjustment, :climb_rate, :digits)

Create a new SpinButton object.

  multi method new (
    N-GObject :$adjustment!, Num :$climb_rate = 1e-1, UInt :$digits = 1
  )

=item N-GObject $adjustment; the B<Gnome::Gtk3::Adjustment> object that this spin button should use.
=item Num $climb_rate; specifies by how much the rate of change in the value will accelerate if you continue to hold down an up/down button or arrow key
=item UInt $digits; the number of decimal places to display.

=head3 new( :min, :max, :step)

This is a convenience constructor that allows creation of a numeric B<Gnome::Gtk3::SpinButton> without manually creating an adjustment. The value is initially set to the minimum value and a page increment of 10 * I<$step> is the default. The precision of the spin button is equivalent to the precision of I<$step>.  Note that the way in which the precision is derived works best if I<$step> is a power of ten. If the resulting precision is not suitable for your needs, use C<.gtk_spin_button_set_digits()> to correct it.

  multi method new ( Num :$min = 0e0, Num :$max = 1e0, Num :$step! )

=item Num $min; Minimum allowable value
=item Num $max; Maximum allowable value
=item Num $step; Increment added or subtracted by spinning the widget

=begin comment
Create a SpinButton object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

Create a SpinButton object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )
=end comment

=end pod

#TM:1:new():inheriting
#TM:1:new(:adjustment!,:climb_rate,:digits):
#TM:1:new(:min,:max,:step):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w1<input change-value>, :w0<output value-changed wrapped>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::SpinButton' or %options<GtkSpinButton> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;
      if ? %options<step> {
        my Num $step = %options<step>.Num;
        my Num $min = (%options<min> // 0e0).Num;
        my Num $max = (%options<max> // 1e0).Num;
        $no = _gtk_spin_button_new_with_range( $min, $max, $step);
      }

      elsif ? %options<adjustment> {
        my $no-a = %options<adjustment>;
        $no-a = $no-a.get-native-object-no-reffing
          if $no-a.^can('get-native-object-no-reffing');

        my Num $climb_rate = %options<climb_rate>.Num // 1e-1;
        my Int $digits = %options<digits> // 1;
        $no = _gtk_spin_button_new( $no-a, $climb_rate, $digits);
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

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_spin_button_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkSpinButton');

  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_spin_button_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  try { $s = self._orientable_interface($native-sub); } unless ?$s;


  self.set-class-name-of-sub('GtkSpinButton');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:1:_gtk_spin_button_new:
#`{{
=begin pod
=head2 [gtk_] spin_button_new

Creates a new B<Gnome::Gtk3::SpinButton>.

Returns: The new spin button as a B<Gnome::Gtk3::Widget>

  method gtk_spin_button_new ( N-GObject $adjustment, Num $climb_rate, UInt $digits --> N-GObject )

=item N-GObject $adjustment; (allow-none): the B<Gnome::Gtk3::Adjustment> object that this spin button should use, or C<Any>
=item Num $climb_rate; specifies by how much the rate of change in the value will accelerate if you continue to hold down an up/down button or arrow key
=item UInt $digits; the number of decimal places to display

=end pod
}}
sub _gtk_spin_button_new ( N-GObject $adjustment, num64 $climb_rate, uint32 $digits --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_spin_button_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_spin_button_new_with_range:
#`{{
=begin pod
=head2 [[gtk_] spin_button_] new_with_range

This is a convenience constructor that allows creation of a numeric B<Gnome::Gtk3::SpinButton> without manually creating an adjustment. The value is initially set to the minimum value and a page increment of 10 * I<step> is the default. The precision of the spin button is equivalent to the precision of I<step>.  Note that the way in which the precision is derived works best if I<step> is a power of ten. If the resulting precision is not suitable for your needs, use C<gtk_spin_button_set_digits()> to correct it.

Returns: The new spin button as a B<Gnome::Gtk3::Widget>

  method gtk_spin_button_new_with_range ( Num $min, Num $max, Num $step --> N-GObject )

=item Num $min; Minimum allowable value
=item Num $max; Maximum allowable value
=item Num $step; Increment added or subtracted by spinning the widget

=end pod
}}

sub _gtk_spin_button_new_with_range ( num64 $min, num64 $max, num64 $step --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_spin_button_new_with_range')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_configure:
=begin pod
=head2 [gtk_] spin_button_configure

Changes the properties of an existing spin button. The adjustment, climb rate, and number of decimal places are updated accordingly.

  method gtk_spin_button_configure ( N-GObject $adjustment, Num $climb_rate, UInt $digits )

=item N-GObject $adjustment; a B<Gnome::Gtk3::Adjustment> to replace the spin button’s existing adjustment, or C<Any> to leave its current adjustment unchanged
=item Num $climb_rate; the new climb rate
=item UInt $digits; the number of decimal places to display in the spin button

=end pod

sub gtk_spin_button_configure ( N-GObject $spin_button, N-GObject $adjustment, num64 $climb_rate, uint32 $digits  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_set_adjustment:
=begin pod
=head2 [[gtk_] spin_button_] set_adjustment

Replaces the B<Gnome::Gtk3::Adjustment> associated with I<spin_button>.

  method gtk_spin_button_set_adjustment ( N-GObject $adjustment )

=item N-GObject $adjustment; a B<Gnome::Gtk3::Adjustment> to replace the existing adjustment

=end pod

sub gtk_spin_button_set_adjustment ( N-GObject $spin_button, N-GObject $adjustment  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_get_adjustment:
=begin pod
=head2 [[gtk_] spin_button_] get_adjustment

Get the adjustment associated with a B<Gnome::Gtk3::SpinButton>

Returns: (transfer none): the B<Gnome::Gtk3::Adjustment> of I<spin_button>

  method gtk_spin_button_get_adjustment ( --> N-GObject )

=end pod

sub gtk_spin_button_get_adjustment ( N-GObject $spin_button --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_set_digits:
=begin pod
=head2 [[gtk_] spin_button_] set_digits

Set the precision to be displayed by I<spin_button>. Up to 20 digit precision is allowed.

  method gtk_spin_button_set_digits ( UInt $digits )

=item UInt $digits; the number of digits after the decimal point to be displayed for the spin button’s value

=end pod

sub gtk_spin_button_set_digits ( N-GObject $spin_button, uint32 $digits  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_get_digits:
=begin pod
=head2 [[gtk_] spin_button_] get_digits

Fetches the precision of I<spin_button>. See C<gtk_spin_button_set_digits()>.

Returns: the current precision

  method gtk_spin_button_get_digits ( --> UInt )

=end pod

sub gtk_spin_button_get_digits ( N-GObject $spin_button --> uint32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_set_increments:
=begin pod
=head2 [[gtk_] spin_button_] set_increments

Sets the step and page increments for spin_button.  This affects how quickly the value changes when the spin button’s arrows are activated.

  method gtk_spin_button_set_increments ( Num $step, Num $page )

=item Num $step; increment applied for a button 1 press.
=item Num $page; increment applied for a button 2 press.

=end pod

sub gtk_spin_button_set_increments ( N-GObject $spin_button, num64 $step, num64 $page  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_get_increments:
=begin pod
=head2 [[gtk_] spin_button_] get_increments

Gets the current step and page the increments used by I<spin_button>. See C<gtk_spin_button_set_increments()>.

  method gtk_spin_button_get_increments ( --> List )

Returned List holds;
=item Num $step; location to store step increment, or C<Any>
=item Num $page; location to store page increment, or C<Any>

=end pod

sub gtk_spin_button_get_increments ( N-GObject $spin_button --> List ) {
  my num64 ( $step, $page);
  _gtk_spin_button_get_increments( $spin_button, $step, $page);

  ( $step, $page)
}

sub _gtk_spin_button_get_increments (
  N-GObject $spin_button, num64 $step is rw, num64 $page is rw
) is native(&gtk-lib)
  is symbol('gtk_spin_button_get_increments')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_set_range:
=begin pod
=head2 [[gtk_] spin_button_] set_range

Sets the minimum and maximum allowable values for I<spin_button>.  If the current value is outside this range, it will be adjusted to fit within the range, otherwise it will remain unchanged.

  method gtk_spin_button_set_range ( Num $min, Num $max )

=item Num $min; minimum allowable value
=item Num $max; maximum allowable value

=end pod

sub gtk_spin_button_set_range ( N-GObject $spin_button, num64 $min, num64 $max  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_get_range:
=begin pod
=head2 [[gtk_] spin_button_] get_range

Gets the range allowed for I<spin_button>. See C<gtk_spin_button_set_range()>.

  method gtk_spin_button_get_range ( --> List )

Returned List holds;
=item Num $min; location to store minimum allowed value, or C<Any>
=item Num $max; location to store maximum allowed value, or C<Any>

=end pod


sub gtk_spin_button_get_range ( N-GObject $spin_button --> List ) {
  my num64 ( $min, $max);
  _gtk_spin_button_get_range( $spin_button, $min, $max);

  ( $min, $max)
}

sub _gtk_spin_button_get_range (
  N-GObject $spin_button, num64 $min is rw, num64 $max is rw
) is native(&gtk-lib)
  is symbol('gtk_spin_button_get_range')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_get_value:
=begin pod
=head2 [[gtk_] spin_button_] get_value

Get the value in the I<spin_button>.

  method gtk_spin_button_get_value ( --> Num )

=end pod

sub gtk_spin_button_get_value ( N-GObject $spin_button --> num64 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_get_value_as_int:
=begin pod
=head2 [[gtk_] spin_button_] get_value_as_int

Get the value I<spin_button> represented as an integer.

Returns: the value of I<spin_button>

  method gtk_spin_button_get_value_as_int ( --> Int )


=end pod

sub gtk_spin_button_get_value_as_int ( N-GObject $spin_button --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_set_value:
=begin pod
=head2 [[gtk_] spin_button_] set_value

Sets the value of I<spin_button>.

  method gtk_spin_button_set_value ( Num $value )

=item Num $value; the new value

=end pod

sub gtk_spin_button_set_value ( N-GObject $spin_button, num64 $value  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_set_update_policy:
=begin pod
=head2 [[gtk_] spin_button_] set_update_policy

Sets the update behavior of a spin button. This determines whether the spin button is always updated or only when a valid value is set.

  method gtk_spin_button_set_update_policy ( GtkSpinButtonUpdatePolicy $policy )

=item GtkSpinButtonUpdatePolicy $policy; a B<Gnome::Gtk3::SpinButtonUpdatePolicy> value

=end pod

sub gtk_spin_button_set_update_policy ( N-GObject $spin_button, int32 $policy  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_get_update_policy:
=begin pod
=head2 [[gtk_] spin_button_] get_update_policy

Gets the update behavior of a spin button. See C<gtk_spin_button_set_update_policy()>.

Returns: the current update policy

  method gtk_spin_button_get_update_policy ( --> GtkSpinButtonUpdatePolicy )

=end pod

sub gtk_spin_button_get_update_policy (
  N-GObject $spin_button --> GtkSpinButtonUpdatePolicy
) {
  GtkSpinButtonUpdatePolicy(_gtk_spin_button_get_update_policy($spin_button))
}

sub _gtk_spin_button_get_update_policy ( N-GObject $spin_button --> int32 )
  is native(&gtk-lib)
  is symbol('gtk_spin_button_get_update_policy')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_set_numeric:
=begin pod
=head2 [[gtk_] spin_button_] set_numeric

Sets the flag that determines if non-numeric text can be typed into the spin button.

  method gtk_spin_button_set_numeric ( Bool $numeric )

=item Bool $numeric; flag indicating if only numeric entry is allowed

=end pod

sub gtk_spin_button_set_numeric ( N-GObject $spin_button, int32 $numeric  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_get_numeric:
=begin pod
=head2 [[gtk_] spin_button_] get_numeric

Returns whether non-numeric text can be typed into the spin button. See C<gtk_spin_button_set_numeric()>. Returns: C<1> if only numeric text can be entered

  method gtk_spin_button_get_numeric ( --> Int )


=end pod

sub gtk_spin_button_get_numeric ( N-GObject $spin_button --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_spin:
=begin pod
=head2 [gtk_] spin_button_spin

Increment or decrement a spin button’s value in a specified direction by a specified amount.

  method gtk_spin_button_spin ( GtkSpinType $direction, Num $increment )

=item GtkSpinType $direction; a B<Gnome::Gtk3::SpinType> indicating the direction to spin
=item Num $increment; step increment to apply in the specified direction

=end pod

sub gtk_spin_button_spin ( N-GObject $spin_button, int32 $direction, num64 $increment  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_set_wrap:
=begin pod
=head2 [[gtk_] spin_button_] set_wrap

Sets the flag that determines if a spin button value wraps around to the opposite limit when the upper or lower limit of the range is exceeded.

  method gtk_spin_button_set_wrap ( Bool $wrap )

=item Bool $wrap; a flag indicating if wrapping behavior is performed

=end pod

sub gtk_spin_button_set_wrap ( N-GObject $spin_button, int32 $wrap  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_get_wrap:
=begin pod
=head2 [[gtk_] spin_button_] get_wrap

Returns whether the spin button’s value wraps around to the opposite limit when the upper or lower limit of the range is exceeded. See C<gtk_spin_button_set_wrap()>.

Returns: C<1> if the spin button wraps around

  method gtk_spin_button_get_wrap ( --> Int )


=end pod

sub gtk_spin_button_get_wrap ( N-GObject $spin_button --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_set_snap_to_ticks:
=begin pod
=head2 [[gtk_] spin_button_] set_snap_to_ticks

Sets the policy as to whether values are corrected to the nearest step increment when a spin button is activated after providing an invalid value.

  method gtk_spin_button_set_snap_to_ticks ( Bool $snap_to_ticks )

=item Bool $snap_to_ticks; a flag indicating if invalid values should be corrected

=end pod

sub gtk_spin_button_set_snap_to_ticks ( N-GObject $spin_button, int32 $snap_to_ticks  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_get_snap_to_ticks:
=begin pod
=head2 [[gtk_] spin_button_] get_snap_to_ticks

Returns whether the values are corrected to the nearest step. See C<gtk_spin_button_set_snap_to_ticks()>. Returns: C<1> if values are snapped to the nearest step

  method gtk_spin_button_get_snap_to_ticks ( --> Int )

=end pod

sub gtk_spin_button_get_snap_to_ticks ( N-GObject $spin_button --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_spin_button_update:
=begin pod
=head2 [gtk_] spin_button_update

Manually force an update of the spin button.

  method gtk_spin_button_update ( )

=end pod

sub gtk_spin_button_update ( N-GObject $spin_button  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<g_signal_connect_object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<g_signal_connect_object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment #TS:0:input:
=head3 input

The I<input> signal can be used to influence the conversion of
the users input into a double value. The signal handler is
expected to use C<gtk_entry_get_text()> to retrieve the text of
the entry and set I<new_value> to the new value.

The default conversion uses C<g_strtod()>.

Returns: C<1> for a successful conversion, C<0> if the input
was not handled, and C<GTK_INPUT_ERROR> if the conversion failed.

  method handler (
    Unknown type G_TYPE_POINTER $new_value,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($spin_button),
    *%user-options
    --> Int
  );

=item $spin_button; the object on which the signal was emitted

=item $new_value; (out) (type double): return location for the new value


=comment #TS:0:output:
=head3 output

The I<output> signal can be used to change to formatting
of the value that is displayed in the spin buttons entry.
|[<!-- language="C" -->
// show leading zeros
static gboolean
on_output (B<Gnome::Gtk3::SpinButton> *spin,
gpointer       data)
{
B<Gnome::Gtk3::Adjustment> *adjustment;
gchar *text;
int value;

adjustment = gtk_spin_button_get_adjustment (spin);
value = (int)gtk_adjustment_get_value (adjustment);
text = g_strdup_printf ("C<02d>", value);
gtk_entry_set_text (GTK_ENTRY (spin), text);
g_free (text);

return TRUE;
}
]|

Returns: C<1> if the value has been displayed

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($spin_button),
    *%user-options
    --> Int
  );

=item $spin_button; the object on which the signal was emitted


=comment #TS:0:value-changed:
=head3 value-changed

The I<value-changed> signal is emitted when the value represented by
I<spinbutton> changes. Also see the  I<output> signal.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($spin_button),
    *%user-options
  );

=item $spin_button; the object on which the signal was emitted


=comment #TS:0:wrapped:
=head3 wrapped

The I<wrapped> signal is emitted right after the spinbutton wraps
from its maximum to minimum value or vice-versa.

Since: 2.10

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($spin_button),
    *%user-options
  );

=item $spin_button; the object on which the signal was emitted


=comment #TS:0:change-value:
=head3 change-value

The I<change-value> signal is a [keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user initiates a value change.

Applications should not connect to it, but may emit it with
C<g_signal_emit_by_name()> if they need to control the cursor
programmatically.

The default bindings for this signal are Up/Down and PageUp and/PageDown.

  method handler (
    Unknown type GTK_TYPE_SCROLL_TYPE $scroll,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($spin_button),
    *%user-options
  );

=item $spin_button; the object on which the signal was emitted

=item $scroll; a B<Gnome::Gtk3::ScrollType> to specify the speed and amount of change


=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:adjustment:
=head3 Adjustment

The adjustment that holds the value of the spin button
Widget type: GTK_TYPE_ADJUSTMENT

The B<Gnome::GObject::Value> type of property I<adjustment> is C<G_TYPE_OBJECT>.


=comment #TP:0:climb-rate:
=head3 Climb Rate

The B<Gnome::GObject::Value> type of property I<climb-rate> is C<G_TYPE_DOUBLE>.


=comment #TP:0:digits:
=head3 Digits

The B<Gnome::GObject::Value> type of property I<digits> is C<G_TYPE_UINT>.


=comment #TP:0:snap-to-ticks:
=head3 Snap to Ticks

Whether erroneous values are automatically changed to a spin button's nearest step increment
Default value: False

The B<Gnome::GObject::Value> type of property I<snap-to-ticks> is C<G_TYPE_BOOLEAN>.


=comment #TP:0:numeric:
=head3 Numeric

Whether non-numeric characters should be ignored
Default value: False

The B<Gnome::GObject::Value> type of property I<numeric> is C<G_TYPE_BOOLEAN>.


=comment #TP:0:wrap:
=head3 Wrap

Whether a spin button should wrap upon reaching its limits
Default value: False

The B<Gnome::GObject::Value> type of property I<wrap> is C<G_TYPE_BOOLEAN>.


=comment #TP:0:update-policy:
=head3 Update Policy

Whether the spin button should update always, or only when the value is legal
Default value: False

The B<Gnome::GObject::Value> type of property I<update-policy> is C<G_TYPE_ENUM>.


=comment #TP:0:value:
=head3 Value

The B<Gnome::GObject::Value> type of property I<value> is C<G_TYPE_DOUBLE>.
=end pod
