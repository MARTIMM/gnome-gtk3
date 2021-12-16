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

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::GObject::InitiallyUnowned;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Adjustment:auth<github:MARTIMM>:ver<0.2.0>;
also is Gnome::GObject::InitiallyUnowned;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 :value, :lower, :upper, :step-increment, :page-increment, :page-size

Create a new Adjustment object.

  multi method new (
    Num() :$value!, Num() :$lower!, Num() :$upper!,
    Num() :$step-increment!, Num() :$page-increment!,
    Num() :$page-size!
  )

=item Num() $value; the initial value.
=item Num() $lower; the minimum value.
=item Num() $upper; the maximum value
=item Num() $step_increment; the step increment
=item Num() $page_increment; the page increment
=item Num() $page_size; the page size

=head3 :native-object

Create an object using a native object from elsewhere. See also B<Gnome::N::TopLevelSupportClass>.

  multi method new ( N-GtkTreePath :$native-object! )

=begin comment
=head3 :build-id

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )
=end comment

=end pod

# TM:0:new():inheriting
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
    elsif %options<native-object>:exists { }
#    elsif %options<build-id>:exists { }

    elsif %options<value>:exists and %options<lower>:exists and
      %options<upper>:exists and %options<step-increment>:exists and
      %options<page-increment>:exists and %options<page-size>:exists {

      self._set-native-object(_gtk_adjustment_new(
          %options<value>.Num, %options<lower>.Num, %options<upper>.Num,
          %options<step-increment>.Num, %options<page-increment>.Num,
          %options<page-size>.Num
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
      self._set-native-object(_gtk_adjustment_new());
    }
    }}

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkAdjustment');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_adjustment_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkAdjustment');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:1:clamp-page:
=begin pod
=head2 clamp-page

Updates the  I<value> property to ensure that the range between I<lower> and I<upper> is in the current page (i.e. between  I<value> and  I<value> +  I<page-size>). If the range is larger than the page size, then only the start of it will be in the current page.

A  I<value-changed> signal will be emitted if the value is changed.

  method clamp-page ( Num() $lower, Num() $upper )

=item Num() $lower; the lower value
=item Num() $upper; the upper value
=end pod

method clamp-page ( Num() $lower, Num() $upper ) {
  gtk_adjustment_clamp_page(
    self._get-native-object-no-reffing, $lower, $upper
  );
}

sub gtk_adjustment_clamp_page (
  N-GObject $adjustment, gdouble $lower, gdouble $upper
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:configure:
=begin pod
=head2 configure

Sets all properties of the adjustment at once.

Use this function to avoid multiple emissions of the  I<changed> signal. See C<set-lower()> for an alternative way of compressing multiple emissions of  I<changed> into one.

  method configure ( Num() $value, Num() $lower, Num() $upper, Num() $step_increment, Num() $page_increment, Num() $page_size )

=item Num() $value; the new value
=item Num() $lower; the new minimum value
=item Num() $upper; the new maximum value
=item Num() $step_increment; the new step increment
=item Num() $page_increment; the new page increment
=item Num() $page_size; the new page size
=end pod

method configure ( Num() $value, Num() $lower, Num() $upper, Num() $step_increment, Num() $page_increment, Num() $page_size ) {

  gtk_adjustment_configure(
    self._get-native-object-no-reffing, $value, $lower, $upper, $step_increment, $page_increment, $page_size
  );
}

sub gtk_adjustment_configure (
  N-GObject $adjustment, gdouble $value, gdouble $lower, gdouble $upper, gdouble $step_increment, gdouble $page_increment, gdouble $page_size
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-lower:
=begin pod
=head2 get-lower

Retrieves the minimum value of the adjustment.

Returns: The current minimum value of the adjustment

  method get-lower ( --> Num() )

=end pod

method get-lower ( --> Num() ) {

  gtk_adjustment_get_lower(
    self._get-native-object-no-reffing,
  )
}

sub gtk_adjustment_get_lower (
  N-GObject $adjustment --> gdouble
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-minimum-increment:
=begin pod
=head2 get-minimum-increment

Gets the smaller of step increment and page increment.

Returns: the minimum increment of I<adjustment>

  method get-minimum-increment ( --> Num() )

=end pod

method get-minimum-increment ( --> Num() ) {

  gtk_adjustment_get_minimum_increment(
    self._get-native-object-no-reffing,
  )
}

sub gtk_adjustment_get_minimum_increment (
  N-GObject $adjustment --> gdouble
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-page-increment:
=begin pod
=head2 get-page-increment

Retrieves the page increment of the adjustment.

Returns: The current page increment of the adjustment

  method get-page-increment ( --> Num() )

=end pod

method get-page-increment ( --> Num() ) {

  gtk_adjustment_get_page_increment(
    self._get-native-object-no-reffing,
  )
}

sub gtk_adjustment_get_page_increment (
  N-GObject $adjustment --> gdouble
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-page-size:
=begin pod
=head2 get-page-size

Retrieves the page size of the adjustment.

Returns: The current page size of the adjustment

  method get-page-size ( --> Num() )

=end pod

method get-page-size ( --> Num() ) {

  gtk_adjustment_get_page_size(
    self._get-native-object-no-reffing,
  )
}

sub gtk_adjustment_get_page_size (
  N-GObject $adjustment --> gdouble
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-step-increment:
=begin pod
=head2 get-step-increment

Retrieves the step increment of the adjustment.

Returns: The current step increment of the adjustment.

  method get-step-increment ( --> Num() )

=end pod

method get-step-increment ( --> Num() ) {

  gtk_adjustment_get_step_increment(
    self._get-native-object-no-reffing,
  )
}

sub gtk_adjustment_get_step_increment (
  N-GObject $adjustment --> gdouble
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-upper:
=begin pod
=head2 get-upper

Retrieves the maximum value of the adjustment.

Returns: The current maximum value of the adjustment

  method get-upper ( --> Num() )

=end pod

method get-upper ( --> Num() ) {

  gtk_adjustment_get_upper(
    self._get-native-object-no-reffing,
  )
}

sub gtk_adjustment_get_upper (
  N-GObject $adjustment --> gdouble
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-value:
=begin pod
=head2 get-value

Gets the current value of the adjustment. See C<set-value()>.

Returns: The current value of the adjustment

  method get-value ( --> Num() )

=end pod

method get-value ( --> Num() ) {

  gtk_adjustment_get_value(
    self._get-native-object-no-reffing,
  )
}

sub gtk_adjustment_get_value (
  N-GObject $adjustment --> gdouble
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-lower:
=begin pod
=head2 set-lower

Sets the minimum value of the adjustment.

When setting multiple adjustment properties via their individual setters, multiple  I<changed> signals will be emitted. However, since the emission of the  I<changed> signal is tied to the emission of the  I<notify> signals of the changed properties, it’s possible to compress the  I<changed> signals into one by calling C<g-object-freeze-notify()> and C<g-object-thaw-notify()> around the calls to the individual setters.

Alternatively, using a single C<g-object-set()> for all the properties to change, or using C<configure()> has the same effect of compressing  I<changed> emissions.

  method set-lower ( Num() $lower )

=item Num() $lower; the new minimum value
=end pod

method set-lower ( Num() $lower ) {

  gtk_adjustment_set_lower(
    self._get-native-object-no-reffing, $lower
  );
}

sub gtk_adjustment_set_lower (
  N-GObject $adjustment, gdouble $lower
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-page-increment:
=begin pod
=head2 set-page-increment

Sets the page increment of the adjustment.

See C<set-lower()> about how to compress multiple emissions of the  I<changed> signal when setting multiple adjustment properties.

  method set-page-increment ( Num() $page_increment )

=item Num() $page_increment; the new page increment
=end pod

method set-page-increment ( Num() $page_increment ) {

  gtk_adjustment_set_page_increment(
    self._get-native-object-no-reffing, $page_increment
  );
}

sub gtk_adjustment_set_page_increment (
  N-GObject $adjustment, gdouble $page_increment
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-page-size:
=begin pod
=head2 set-page-size

Sets the page size of the adjustment.

See C<set-lower()> about how to compress multiple emissions of the GtkAdjustment::changed signal when setting multiple adjustment properties.

  method set-page-size ( Num() $page_size )

=item Num() $page_size; the new page size
=end pod

method set-page-size ( Num() $page_size ) {

  gtk_adjustment_set_page_size(
    self._get-native-object-no-reffing, $page_size
  );
}

sub gtk_adjustment_set_page_size (
  N-GObject $adjustment, gdouble $page_size
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-step-increment:
=begin pod
=head2 set-step-increment

Sets the step increment of the adjustment.

See C<set-lower()> about how to compress multiple emissions of the  I<changed> signal when setting multiple adjustment properties.

  method set-step-increment ( Num() $step_increment )

=item Num() $step_increment; the new step increment
=end pod

method set-step-increment ( Num() $step_increment ) {

  gtk_adjustment_set_step_increment(
    self._get-native-object-no-reffing, $step_increment
  );
}

sub gtk_adjustment_set_step_increment (
  N-GObject $adjustment, gdouble $step_increment
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-upper:
=begin pod
=head2 set-upper

Sets the maximum value of the adjustment.

Note that values will be restricted by `upper - page-size` if the page-size property is nonzero.

See C<set-lower()> about how to compress multiple emissions of the  I<changed> signal when setting multiple adjustment properties.

  method set-upper ( Num() $upper )

=item Num() $upper; the new maximum value
=end pod

method set-upper ( Num() $upper ) {

  gtk_adjustment_set_upper(
    self._get-native-object-no-reffing, $upper
  );
}

sub gtk_adjustment_set_upper (
  N-GObject $adjustment, gdouble $upper
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-value:
=begin pod
=head2 set-value

Sets the B<Gnome::Gtk3::Adjustment> value. The value is clamped to lie between  I<lower> and  I<upper>.

Note that for adjustments which are used in a B<Gnome::Gtk3::Scrollbar>, the effective range of allowed values goes from  I<lower> to  I<upper> -  I<page-size>.

  method set-value ( Num() $value )

=item Num() $value; the new value
=end pod

method set-value ( Num() $value ) {

  gtk_adjustment_set_value(
    self._get-native-object-no-reffing, $value
  );
}

sub gtk_adjustment_set_value (
  N-GObject $adjustment, gdouble $value
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_adjustment_new:
#`{{
=begin pod
=head2 _gtk_adjustment_new

Creates a new B<Gnome::Gtk3::Adjustment>.

Returns: a new B<Gnome::Gtk3::Adjustment>

  method _gtk_adjustment_new ( Num() $value, Num() $lower, Num() $upper, Num() $step_increment, Num() $page_increment, Num() $page_size --> N-GObject )

=item Num() $value; the initial value
=item Num() $lower; the minimum value
=item Num() $upper; the maximum value
=item Num() $step_increment; the step increment
=item Num() $page_increment; the page increment
=item Num() $page_size; the page size
=end pod
}}

sub _gtk_adjustment_new ( gdouble $value, gdouble $lower, gdouble $upper, gdouble $step_increment, gdouble $page_increment, gdouble $page_size --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_adjustment_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<connect-object()> directly from B<Gnome::GObject::Signal>.

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

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<connect-object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment -----------------------------------------------------------------------
=comment #TS:1:changed:
=head3 changed

Emitted when one or more of the B<Gnome::Gtk3::Adjustment> properties have been
changed, other than the  I<value> property.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($adjustment),
    *%user-options
  );

=item $adjustment; the object which received the signal

=item $_handle_id; the registered event handler id

=comment -----------------------------------------------------------------------
=comment #TS:1:value-changed:
=head3 value-changed

Emitted when the  I<value> property has been changed.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($adjustment),
    *%user-options
  );

=item $adjustment; the object which received the signal

=item $_handle_id; the registered event handler id

=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:1:lower:
=head3 Minimum Value: lower


The minimum value of the adjustment.


The B<Gnome::GObject::Value> type of property I<lower> is C<G_TYPE_DOUBLE>.

=comment -----------------------------------------------------------------------
=comment #TP:1:page-increment:
=head3 Page Increment: page-increment


The page increment of the adjustment.


The B<Gnome::GObject::Value> type of property I<page-increment> is C<G_TYPE_DOUBLE>.

=comment -----------------------------------------------------------------------
=comment #TP:1:page-size:
=head3 Page Size: page-size


The page size of the adjustment.
Note that the page-size is irrelevant and should be set to zero
if the adjustment is used for a simple scalar value, e.g. in a
B<Gnome::Gtk3::SpinButton>.


The B<Gnome::GObject::Value> type of property I<page-size> is C<G_TYPE_DOUBLE>.

=comment -----------------------------------------------------------------------
=comment #TP:1:step-increment:
=head3 Step Increment: step-increment


The step increment of the adjustment.


The B<Gnome::GObject::Value> type of property I<step-increment> is C<G_TYPE_DOUBLE>.

=comment -----------------------------------------------------------------------
=comment #TP:1:upper:
=head3 Maximum Value: upper


The maximum value of the adjustment.
Note that values will be restricted by
`upper - page-size` if the page-size
property is nonzero.


The B<Gnome::GObject::Value> type of property I<upper> is C<G_TYPE_DOUBLE>.

=comment -----------------------------------------------------------------------
=comment #TP:1:value:
=head3 Value: value


The value of the adjustment.


The B<Gnome::GObject::Value> type of property I<value> is C<G_TYPE_DOUBLE>.
=end pod
