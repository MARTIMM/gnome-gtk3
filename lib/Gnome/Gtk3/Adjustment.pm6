#TL:1:Gnome::Gtk3::Adjustment:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Adjustment

A representation of an adjustable bounded value

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gtk3::Adjustment> object represents a value which has an associated lower and upper bound, together with step and page increments, and a page size. It is used within several GTK+ widgets, including B<Gnome::Gtk3::SpinButton>, B<Gnome::Gtk3::Viewport>, and B<Gnome::Gtk3::Range> (which is a base class for B<Gnome::Gtk3::Scrollbar> and B<Gnome::Gtk3::Scale>).

The B<Gnome::Gtk3::Adjustment> object does not update the value itself. Instead it is left up to the owner of the B<Gnome::Gtk3::Adjustment> to control the value.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Adjustment;
  also is Gnome::GObject::InitiallyUnowned;


=head2 Uml Diagram

![](plantuml/Adjustment.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Adjustment;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Adjustment;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Adjustment class process the options
    self.bless( :GtkAdjustment, |c);
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
use Gnome::GObject::InitiallyUnowned;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Adjustment:auth<github:MARTIMM>;
also is Gnome::GObject::InitiallyUnowned;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head2 :value, :lower, :upper, :step-increment, :page-increment, :page-size

Create a new Adjustment object.

  multi method new (
    num64 :$value!, num64 :$lower!, num64 :$upper!,
    num64 :$step-increment!, num64 :$page-increment!,
    num64 :$page-size!
  )

=item Num $value; the initial value.
=item Num $lower; the minimum value.
=item Num $upper; the maximum value
=item Num $step_increment; the step increment
=item Num $page_increment; the page increment
=item Num $page_size; the page size

=head3 :native-object

Create an object using a native object from elsewhere. See also B<Gnome::N::TopLevelSupportClass>.

  multi method new ( N-GtkTreePath :$native-object! )

=head3 :build-id

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new(:value,:lower,:upper,:step-increment,:page-increment,:page-size
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<changed value-changed>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Adjustment' #`{{ or %options<GtkAdjustment> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    elsif %options<value>:exists and %options<lower>:exists and
      %options<upper>:exists and %options<step-increment>:exists and
      %options<page-increment>:exists and %options<page-size>:exists {

      self.set-native-object(_gtk_adjustment_new(
          %options<value>.Num, %options<lower>.Num, %options<upper>.Num,
          %options<step-increment>.Num, %options<page-increment>.Num,
          %options<page-size>.Num
        )
      );
    }

    elsif %options<value>:exists and %options<lower>:exists and
      %options<upper>:exists and %options<step_increment>:exists and
      %options<page_increment>:exists and %options<page_size>:exists {

      Gnome::N::deprecate(
        '.new(:page_increment)', '.new(:page-increment)', '0.33.0', '0.38.0'
      );
      Gnome::N::deprecate(
        '.new(:page_size)', '.new(:page-size)', '0.33.0', '0.38.0');
      Gnome::N::deprecate(
        '.new(:step_increment)', '.new(:step-increment)', '0.33.0', '0.38.0'
      );

      self.set-native-object(_gtk_adjustment_new(
          %options<value>.Num, %options<lower>.Num, %options<upper>.Num,
          %options<step_increment>.Num, %options<page_increment>.Num,
          %options<page_size>.Num
        )
      );
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

    ##`{{ when there are no defaults use this
    # check if there are any options
    elsif %options.elems == 0 {
      die X::Gnome.new(:message('No options specified ' ~ self.^name));
    }
    #}}

    #`{{ when there are options use this instead
    # create default object
    else {
      self.set-native-object(_gtk_adjustment_new());
    }
    }}

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkAdjustment');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_adjustment_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkAdjustment');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:_gtk_adjustment_new:new(:...)
#`{{
=begin pod
=head2 gtk_adjustment_new

Creates a new B<Gnome::Gtk3::Adjustment>.

Returns: a new B<Gnome::Gtk3::Adjustment>

  method gtk_adjustment_new (
    Num $value, Num $lower, Num $upper, Num $step_increment,
    Num $page_increment, Num $page_size --> N-GObject
  )

=item Num $value; the initial value.
=item Num $lower; the minimum value.
=item Num $upper; the maximum value
=item Num $step_increment; the step increment
=item Num $page_increment; the page increment
=item Num $page_size; the page size

=end pod
}}
sub _gtk_adjustment_new (
  num64 $value, num64 $lower, num64 $upper, num64 $step_increment,
  num64 $page_increment, num64 $page_size
  --> N-GObject
) is native(&gtk-lib)
  is symbol('gtk_adjustment_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_clamp_page:
=begin pod
=head2 [gtk_adjustment_] clamp_page

Updates the I<value> property to ensure that the range between I<lower> and I<upper> is in the current page (i.e. between I<value> and  I<value> +  I<page-size>). If the range is larger than the page size, then only the start of it will be in the current page.

A  I<value-changed> signal will be emitted if the value is changed.

  method gtk_adjustment_clamp_page ( Num $lower, Num $upper )

=item Num $lower; the lower value
=item Num $upper; the upper value

=end pod

sub gtk_adjustment_clamp_page ( N-GObject $adjustment, num64 $lower, num64 $upper  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_get_value:
=begin pod
=head2 [gtk_adjustment_] get_value

Gets the current value of the adjustment. See C<gtk_adjustment_set_value()>.

Returns: The current value of the adjustment

  method gtk_adjustment_get_value ( --> Num )


=end pod

sub gtk_adjustment_get_value ( N-GObject $adjustment --> num64 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_set_value:
=begin pod
=head2 [gtk_adjustment_] set_value

Sets the B<Gnome::Gtk3::Adjustment> value. The value is clamped to lie between
 I<lower> and  I<upper>.

Note that for adjustments which are used in a B<Gnome::Gtk3::Scrollbar>, the effective range of allowed values goes from  I<lower> to  I<upper> - I<page-size>.

  method gtk_adjustment_set_value ( Num $value )

=item Num $value; the new value

=end pod

sub gtk_adjustment_set_value ( N-GObject $adjustment, num64 $value  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_get_lower:
=begin pod
=head2 [gtk_adjustment_] get_lower

Retrieves the minimum value of the adjustment.

Returns: The current minimum value of the adjustment


  method gtk_adjustment_get_lower ( --> Num )


=end pod

sub gtk_adjustment_get_lower ( N-GObject $adjustment --> num64 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_set_lower:
=begin pod
=head2 [gtk_adjustment_] set_lower

Sets the minimum value of the adjustment.

When setting multiple adjustment properties via their individual setters, multiple  I<changed> signals will be emitted. However, since the emission of the  I<changed> signal is tied to the emission of the  I<notify> signals of the changed properties, it’s possible to compress the  I<changed> signals into one by calling C<g_object_freeze_notify()> and C<g_object_thaw_notify()> around the calls to the individual setters.

Alternatively, using a single C<g_object_set()> for all the properties to change, or using C<gtk_adjustment_configure()> has the same effect of compressing  I<changed> emissions.

  method gtk_adjustment_set_lower ( Num $lower )

=item Num $lower; the new minimum value

=end pod

sub gtk_adjustment_set_lower ( N-GObject $adjustment, num64 $lower  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_get_upper:
=begin pod
=head2 [gtk_adjustment_] get_upper

Retrieves the maximum value of the adjustment.

  method gtk_adjustment_get_upper ( --> Num )

=end pod

sub gtk_adjustment_get_upper ( N-GObject $adjustment --> num64 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_set_upper:
=begin pod
=head2 [gtk_adjustment_] set_upper

Sets the maximum value of the adjustment. Note that values will be restricted by `upper - page-size` if the page-size property is nonzero.

See C<gtk_adjustment_set_lower()> about how to compress multiple emissions of the  I<changed> signal when setting multiple adjustment properties.

  method gtk_adjustment_set_upper ( Num $upper )

=item Num $upper; the new maximum value

=end pod

sub gtk_adjustment_set_upper ( N-GObject $adjustment, num64 $upper  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_get_step_increment:
=begin pod
=head2 [gtk_adjustment_] get_step_increment

Retrieves the step increment of the adjustment.

  method gtk_adjustment_get_step_increment ( --> Num )

=end pod

sub gtk_adjustment_get_step_increment ( N-GObject $adjustment --> num64 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_set_step_increment:
=begin pod
=head2 [gtk_adjustment_] set_step_increment

Sets the step increment of the adjustment.

See C<gtk_adjustment_set_lower()> about how to compress multiple emissions of the  I<changed> signal when setting multiple adjustment properties.

  method gtk_adjustment_set_step_increment ( Num $step_increment )

=item Num $step_increment; the new step increment

=end pod

sub gtk_adjustment_set_step_increment ( N-GObject $adjustment, num64 $step_increment  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_get_page_increment:
=begin pod
=head2 [gtk_adjustment_] get_page_increment

Retrieves the page increment of the adjustment.

  method gtk_adjustment_get_page_increment ( --> Num )

=end pod

sub gtk_adjustment_get_page_increment ( N-GObject $adjustment --> num64 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_set_page_increment:
=begin pod
=head2 [gtk_adjustment_] set_page_increment

Sets the page increment of the adjustment. See C<gtk_adjustment_set_lower()> about how to compress multiple emissions of the  I<changed> signal when setting multiple adjustment properties.

  method gtk_adjustment_set_page_increment ( Num $page_increment )

=item Num $page_increment; the new page increment

=end pod

sub gtk_adjustment_set_page_increment ( N-GObject $adjustment, num64 $page_increment  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_get_page_size:
=begin pod
=head2 [gtk_adjustment_] get_page_size

Retrieves the page size of the adjustment.

  method gtk_adjustment_get_page_size ( --> Num )

=end pod

sub gtk_adjustment_get_page_size ( N-GObject $adjustment --> num64 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_set_page_size:
=begin pod
=head2 [gtk_adjustment_] set_page_size

Sets the page size of the adjustment. See C<gtk_adjustment_set_lower()> about how to compress multiple emissions of the B<Gnome::Gtk3::Adjustment>::changed signal when setting multiple adjustment properties.

  method gtk_adjustment_set_page_size ( Num $page_size )

=item Num $page_size; the new page size

=end pod

sub gtk_adjustment_set_page_size ( N-GObject $adjustment, num64 $page_size  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_configure:
=begin pod
=head2 gtk_adjustment_configure

Sets all properties of the adjustment at once. Use this function to avoid multiple emissions of the  I<changed> signal. See C<gtk_adjustment_set_lower()> for an alternative way of compressing multiple emissions of  I<changed> into one.

  method gtk_adjustment_configure ( Num $value, Num $lower, Num $upper, Num $step_increment, Num $page_increment, Num $page_size )

=item Num $value; the new value
=item Num $lower; the new minimum value
=item Num $upper; the new maximum value
=item Num $step_increment; the new step increment
=item Num $page_increment; the new page increment
=item Num $page_size; the new page size

=end pod

sub gtk_adjustment_configure ( N-GObject $adjustment, num64 $value, num64 $lower, num64 $upper, num64 $step_increment, num64 $page_increment, num64 $page_size  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_adjustment_get_minimum_increment:
=begin pod
=head2 [gtk_adjustment_] get_minimum_increment

Gets the smaller of step increment and page increment.

  method gtk_adjustment_get_minimum_increment ( --> Num )

=end pod

sub gtk_adjustment_get_minimum_increment ( N-GObject $adjustment --> num64 )
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


=comment #TS:0:changed:
=head3 changed

Emitted when one or more of the B<Gnome::Gtk3::Adjustment> properties have been
changed, other than the  I<value> property.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($adjustment),
    *%user-options
  );

=item $adjustment; the object which received the signal


=comment #TS:0:value-changed:
=head3 value-changed

Emitted when the  I<value> property has been changed.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($adjustment),
    *%user-options
  );

=item $adjustment; the object which received the signal


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

=comment #TP:1:value:
=head3 Value

The value of the adjustment.

The B<Gnome::GObject::Value> type of property I<value> is C<G_TYPE_DOUBLE>.


=comment #TP:1:lower:
=head3 Minimum Value

The minimum value of the adjustment.

The B<Gnome::GObject::Value> type of property I<lower> is C<G_TYPE_DOUBLE>.


=comment #TP:1:upper:
=head3 Maximum Value

The maximum value of the adjustment. Note that values will be restricted by `upper - page-size` if the page-size property is nonzero.

The B<Gnome::GObject::Value> type of property I<upper> is C<G_TYPE_DOUBLE>.


=comment #TP:1:step-increment:
=head3 Step Increment


The step increment of the adjustment.

The B<Gnome::GObject::Value> type of property I<step-increment> is C<G_TYPE_DOUBLE>.


=comment #TP:1:page-increment:
=head3 Page Increment

The page increment of the adjustment.

The B<Gnome::GObject::Value> type of property I<page-increment> is C<G_TYPE_DOUBLE>.


=comment #TP:1:page-size:
=head3 Page Size

The page size of the adjustment. Note that the page-size is irrelevant and should be set to zero if the adjustment is used for a simple scalar value, e.g. in a B<Gnome::Gtk3::SpinButton>.

The B<Gnome::GObject::Value> type of property I<page-size> is C<G_TYPE_DOUBLE>.
=end pod
