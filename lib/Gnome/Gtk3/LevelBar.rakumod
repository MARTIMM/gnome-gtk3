#TL:1:Gnome::Gtk3::LevelBar:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::LevelBar

A bar that can used as a level indicator

![](images/levelbar.png)

=head1 Description


The B<Gnome::Gtk3::LevelBar> is a bar widget that can be used
as a level indicator. Typical use cases are displaying the strength
of a password, or showing the charge level of a battery.

Use C<gtk_level_bar_set_value()> to set the current value, and
C<gtk_level_bar_add_offset_value()> to set the value offsets at which
the bar will be considered in a different state. GTK will add a few
offsets by default on the level bar: B<GTK_LEVEL_BAR_OFFSET_LOW>,
B<GTK_LEVEL_BAR_OFFSET_HIGH> and B<GTK_LEVEL_BAR_OFFSET_FULL>, with
values 0.25, 0.75 and 1.0 respectively.

Note that it is your responsibility to update preexisting offsets
when changing the minimum or maximum value. GTK+ will simply clamp
them to the new range.

=head2 Adding a custom offset on the bar

  method create-level-bar ( ) {

    # The following adds a new offset to the bar; the application
    # will be able to change its color CSS like this:
    #
    # levelbar block.my-offset {
    #   background-color: magenta;
    #   border-style: solid;
    #   border-color: black;
    #   border-style: 1px;
    # }
    my Gnome::Gtk3::LevelBar $bar .= new;
    $bar.add-offset-value( "my-offset", 0.60);
  }

The default interval of values is between zero and one, but it’s possible to
modify the interval using C<gtk_level_bar_set_min_value()> and
C<gtk_level_bar_set_max_value()>. The value will be always drawn in proportion to
the admissible interval, i.e. a value of 15 with a specified interval between
10 and 20 is equivalent to a value of 0.5 with an interval between 0 and 1.
When B<GTK_LEVEL_BAR_MODE_DISCRETE> is used, the bar level is rendered
as a finite number of separated blocks instead of a single one. The number
of blocks that will be rendered is equal to the number of units specified by
the admissible interval.

For instance, to build a bar rendered with five blocks, it’s sufficient to
set the minimum value to 0 and the maximum value to 5 after changing the indicator
mode to discrete.

B<Gnome::Gtk3::LevelBar> was introduced in GTK+ 3.6.


=head2 B<Gnome::Gtk3::LevelBar> as B<Gnome::Gtk3::Buildable>

The B<Gnome::Gtk3::LevelBar> implementation of the B<Gnome::Gtk3::Buildable> interface supports a
custom <offsets> element, which can contain any number of <offset> elements,
each of which must have name and value attributes.


=head2 Css Nodes

  levelbar[.discrete]
  ╰── trough
      ├── block.filled.level-name
      ┊
      ├── block.empty
      ┊

B<Gnome::Gtk3::LevelBar> has a main CSS node with name levelbar and one of the style
classes .discrete or .continuous and a subnode with name trough. Below the
trough node are a number of nodes with name block and style class .filled
or .empty. In continuous mode, there is exactly one node of each, in discrete
mode, the number of filled and unfilled nodes corresponds to blocks that are
drawn. The block.filled nodes also get a style class .level-name corresponding
to the level for the current value.

In horizontal orientation, the nodes are always arranged from left to right,
regardless of text direction.

=head2 Implemented Interfaces

Gnome::Gtk3::LevelBar implements
=item [Gnome::Gtk3::Orientable](Orientable.html)

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::LevelBar;
  also is Gnome::Gtk3::Widget;
  also does Gnome::Gtk3::Buildable;
  also does Gnome::Gtk3::Orientable;

=head2 Example

  my Gnome::Gtk3::LevelBar $level-bar .= new;
  $level-bar.set-orientation(GTK_ORIENTATION_VERTICAL);

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::Gtk3::Widget:api<1>;
use Gnome::Gtk3::Orientable:api<1>;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/INCLUDE
# See /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::LevelBar:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Widget;
also does Gnome::Gtk3::Orientable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types

=head2 GTK_LEVEL_BAR_OFFSET_LOW

A predefined constant to be used with C<gtk_level_bar_add_offset_value()>.
The name isused for the stock low offset.

  constant GTK_LEVEL_BAR_OFFSET_LOW "low"

=head2 GTK_LEVEL_BAR_OFFSET_HIGH

A predefined constant to be used with C<gtk_level_bar_add_offset_value()>.
The name isused for the stock high offset.

  constant GTK_LEVEL_BAR_OFFSET_HIGH "high"

=head2 GTK_LEVEL_BAR_OFFSET_FULL

A predefined constant to be used with C<gtk_level_bar_add_offset_value()>.
The name isused for the stock high offset.

  constant GTK_LEVEL_BAR_OFFSET_FULL "full"


=end pod

constant GTK_LEVEL_BAR_OFFSET_LOW is export = "low";
constant GTK_LEVEL_BAR_OFFSET_HIGH = "high";
constant GTK_LEVEL_BAR_OFFSET_FULL = "full";

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

  multi method new ( Bool :$empty! )

Create a GtkLevelBar object.

  multi method new ( Num :$min!, Num :$max! )

Create a new GtkLevelBar with a specified range.

  multi method new ( :$native-object! )

Create an object using a native object from elsewhere. See also Gnome::GObject::Object.

  multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also Gnome::GObject::Object.

=end pod

#TM:1:new():
#TM:0:new(:min, :max):
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w1<offset-changed>
  ) unless $signals-added;

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::LevelBar';

  if ? %options<min> and ? %options<max> {
    self._set-native-object(gtk_level_bar_new_for_interval(
      %options<min>, %options<max>)
    );
  }

  elsif ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  else {#if ? %options<empty> {
    self._set-native-object(gtk_level_bar_new());
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkLevelBar');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_level_bar_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkLevelBar');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_level_bar_new:new()
=begin pod
=head2 [gtk_] level_bar_new

Creates a new B<Gnome::Gtk3::LevelBar>.

Returns: a B<Gnome::Gtk3::LevelBar>.

Since: 3.6

  method gtk_level_bar_new ( --> N-GObject  )


=end pod

sub gtk_level_bar_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_level_bar_new_for_interval:new(:min,:max)
=begin pod
=head2 [[gtk_] level_bar_] new_for_interval

Utility constructor that creates a new B<Gnome::Gtk3::LevelBar> for the specified
interval.

Returns: a B<Gnome::Gtk3::LevelBar>

Since: 3.6

  method gtk_level_bar_new_for_interval ( Num $min_value, Num $max_value --> N-GObject  )

=item Num $min_value; a positive value
=item Num $max_value; a positive value

=end pod

sub gtk_level_bar_new_for_interval ( num64 $min_value, num64 $max_value )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_level_bar_set_mode:
=begin pod
=head2 [[gtk_] level_bar_] set_mode

Sets the value of the  I<mode> property.

Since: 3.6

  method gtk_level_bar_set_mode ( GtkLevelBarMode $mode )

=item GtkLevelBarMode $mode; a B<Gnome::Gtk3::LevelBarMode>

=end pod

sub gtk_level_bar_set_mode ( N-GObject $self, int32 $mode )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_level_bar_get_mode:
=begin pod
=head2 [[gtk_] level_bar_] get_mode

Returns the value of the  I<mode> property.

Returns: a B<Gnome::Gtk3::LevelBarMode>

Since: 3.6

  method gtk_level_bar_get_mode ( --> GtkLevelBarMode  )


=end pod

sub gtk_level_bar_get_mode ( N-GObject $self )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_level_bar_set_value:
=begin pod
=head2 [[gtk_] level_bar_] set_value

Sets the value of the  I<value> property.

Since: 3.6

  method gtk_level_bar_set_value ( Num $value )

=item Num $value; a value in the interval between  I<min-value> and  I<max-value>

=end pod

sub gtk_level_bar_set_value ( N-GObject $self, num64 $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_level_bar_get_value:
=begin pod
=head2 [[gtk_] level_bar_] get_value

Returns the value of the  I<value> property.

Returns: a value in the interval between
 I<min-value> and  I<max-value>

Since: 3.6

  method gtk_level_bar_get_value ( --> Num  )


=end pod

sub gtk_level_bar_get_value ( N-GObject $self )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_level_bar_set_min_value:
=begin pod
=head2 [[gtk_] level_bar_] set_min_value

Sets the value of the  I<min-value> property.

You probably want to update preexisting level offsets after calling
this function.

Since: 3.6

  method gtk_level_bar_set_min_value ( Num $value )

=item Num $value; a positive value

=end pod

sub gtk_level_bar_set_min_value ( N-GObject $self, num64 $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_level_bar_get_min_value:
=begin pod
=head2 [[gtk_] level_bar_] get_min_value

Returns the value of the  I<min-value> property.

Returns: a positive value

Since: 3.6

  method gtk_level_bar_get_min_value ( --> Num  )


=end pod

sub gtk_level_bar_get_min_value ( N-GObject $self )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_level_bar_set_max_value:
=begin pod
=head2 [[gtk_] level_bar_] set_max_value

Sets the value of the  I<max-value> property.

You probably want to update preexisting level offsets after calling
this function.

Since: 3.6

  method gtk_level_bar_set_max_value ( Num $value )

=item Num $value; a positive value

=end pod

sub gtk_level_bar_set_max_value ( N-GObject $self, num64 $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_level_bar_get_max_value:
=begin pod
=head2 [[gtk_] level_bar_] get_max_value

Returns the value of the  I<max-value> property.

Returns: a positive value

Since: 3.6

  method gtk_level_bar_get_max_value ( --> Num  )


=end pod

sub gtk_level_bar_get_max_value ( N-GObject $self )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_level_bar_set_inverted:
=begin pod
=head2 [[gtk_] level_bar_] set_inverted

Sets the value of the  I<inverted> property.

Since: 3.8

  method gtk_level_bar_set_inverted ( Int $inverted )

=item Int $inverted; C<1> to invert the level bar

=end pod

sub gtk_level_bar_set_inverted ( N-GObject $self, int32 $inverted )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_level_bar_get_inverted:
=begin pod
=head2 [[gtk_] level_bar_] get_inverted

Return the value of the  I<inverted> property.

Returns: C<1> if the level bar is inverted

Since: 3.8

  method gtk_level_bar_get_inverted ( --> Int  )


=end pod

sub gtk_level_bar_get_inverted ( N-GObject $self )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_level_bar_add_offset_value:
=begin pod
=head2 [[gtk_] level_bar_] add_offset_value

Adds a new offset marker on the levelbar at the position specified by I<$value>.
When the bar value is in the interval topped by I<$value> (or between I<$value>
and  I<max-value> in case the offset is the last one on the bar)
a style class named `level-`I<$name> will be applied
when rendering the level bar fill.
If another offset marker named I<$name> exists, its value will be
replaced by I<$value>.

Since: 3.6

  method gtk_level_bar_add_offset_value ( Str $name, Num $value )

=item Str $name; the name of the new offset
=item Num $value; the value for the new offset

=end pod

sub gtk_level_bar_add_offset_value ( N-GObject $self, Str $name, num64 $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_level_bar_remove_offset_value:
=begin pod
=head2 [[gtk_] level_bar_] remove_offset_value

Removes an offset marker previously added with
C<gtk_level_bar_add_offset_value()>.

Since: 3.6

  method gtk_level_bar_remove_offset_value ( Str $name )

=item Str $name; (allow-none): the name of an offset in the bar

=end pod

sub gtk_level_bar_remove_offset_value ( N-GObject $self, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_level_bar_get_offset_value:
=begin pod
=head2 [[gtk_] level_bar_] get_offset_value

Fetches the value specified for the offset marker I<$name> in the level bar,

Since: 3.6

  method gtk_level_bar_get_offset_value ( Str $name --> List )

=item Str $name; the name of an offset in the bar or C<Any>.

Returns a list of which;
=item Int status; C<1> when name is found as an offset. When C<0> $value is 0.
=item Num $value; location where to store the value.

=end pod

sub gtk_level_bar_get_offset_value (
  N-GObject $level-bar, Str $name --> List
) {

  my Int $ret = _gtk_level_bar_get_offset_value(
    $level-bar, $name, my num64 $value
  );

  ( $ret, $value)
}

sub _gtk_level_bar_get_offset_value (
  N-GObject $level-bar, Str $name, num64 $value is rw
) returns int32
  is symbol('gtk_level_bar_get_offset_value')
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


=comment #TS:1:offset-changed:
=head3 offset-changed

Emitted when an offset specified on the bar changes value as an
effect to C<gtk_level_bar_add_offset_value()> being called.

The signal supports detailed connections; you can connect to the
detailed signal "changed::x" in order to only receive callbacks when
the value of offset "x" changes.

Since: 3.6

  method handler (
    Str $name,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($levelbar),
    *%user-options
  );

=item $levelbar; a B<Gnome::Gtk3::LevelBar>

=item $name; the name of the offset that changed value


=end pod




















=finish
#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
sub gtk_level_bar_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
sub gtk_level_bar_new_for_interval ( num64 $min_value, num64 $max_value )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] level_bar_] set_mode

  method gtk_level_bar_set_mode ( GtkLevelBarMode $mode )

=item $mode; the way that increments are made visible. This is a GtkLevelBarMode enum type defined in GtkEnums.

=end pod

sub gtk_level_bar_set_mode ( N-GObject $levelbar, int32 $mode )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] level_bar_] get_mode

  method gtk_level_bar_get_mode ( --> GtkLevelBarMode )

Returns current mode. This is a GtkLevelBarMode enum type defined in GtkEnums.

=end pod

sub gtk_level_bar_get_mode ( N-GObject $levelbar )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] level_bar_] set_value

  method gtk_level_bar_set_value ( Num $value )

=item $value; set the level bar value.

=end pod

sub gtk_level_bar_set_value ( N-GObject $levelbar, num64 $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] level_bar_] get_value

  method gtk_level_bar_get_value ( --> Num )

Returns current value.

=end pod

sub gtk_level_bar_get_value ( N-GObject $levelbar )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] level_bar_] set_min_value

  method gtk_level_bar_set_min_value ( Num $value )

=item $value; set the minimum value of the bar.

=end pod

sub gtk_level_bar_set_min_value ( N-GObject $levelbar, num64 $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] level_bar_] get_min_value

  method gtk_level_bar_get_min_value ( --> Num )

Returns the minimum value of the bar.

=end pod

sub gtk_level_bar_get_min_value ( N-GObject $levelbar )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] level_bar_] set_max_value

  method gtk_level_bar_set_max_value ( Num $value )

=item $value; set the maximum value of the bar.

=end pod

sub gtk_level_bar_set_max_value ( N-GObject $levelbar, num64 $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] level_bar_] get_max_value

  method gtk_level_bar_get_max_value ( --> Num )

Returns the maximum value of the bar.

=end pod

sub gtk_level_bar_get_max_value ( N-GObject $levelbar )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] level_bar_] set_inverted

  method gtk_level_bar_set_inverted ( Int $invert )

=item $invert; When 1, the bar is inverted. That is, right to left or bottom to top.

=end pod

sub gtk_level_bar_set_inverted ( N-GObject $levelbar, int32 $invert )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] level_bar_] get_inverted

  method gtk_level_bar_get_inverted ( --> Int )

Returns invert mode; When 1, the bar is inverted. That is, right to left or bottom to top.

=end pod

sub gtk_level_bar_get_inverted ( N-GObject $levelbar )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] level_bar_] add_offset_value

Adds a new offset marker on self at the position specified by value . When the bar value is in the interval topped by value (or between value and “max-value” in case the offset is the last one on the bar) a style class named level-name will be applied when rendering the level bar fill. If another offset marker named name exists, its value will be replaced by value .

  method gtk_level_bar_add_offset_value ( Str $name, Num $value )

=item $name; the name of the new offset.
=item $value; the value for the new offset.

=end pod

sub gtk_level_bar_add_offset_value (
  N-GObject $levelbar, Str $name, num64 $value
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] level_bar_] get_offset_value

Fetches the value specified for the offset marker name.

  method gtk_level_bar_get_offset_value ( Str $name, Num $value --> Int )

=item $name; the name of the new offset.
=item $value; the value of the offset is returned.

Returns Int where 1 means that name is found.

=end pod

sub gtk_level_bar_get_offset_value (
  N-GObject $levelbar, Str $name, num64 $value is rw
) returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] level_bar_] remove_offset_value

Adds a new offset marker on self at the position specified by value . When the bar value is in the interval topped by value (or between value and “max-value” in case the offset is the last one on the bar) a style class named level-name will be applied when rendering the level bar fill. If another offset marker named name exists, its value will be replaced by value.
This offset name can be used to change color and view of the level bar after passing this offset by setting information in a css file. For example when name is C<my-offset> one can do the following.

  levelbar block.my-offset {
     background-color: magenta;
     border-style: solid;
     border-color: black;
     border-style: 1px;
  }

  method gtk_level_bar_remove_offset_value ( Str $name )

=item $name; the name of the offset.

=end pod

sub gtk_level_bar_remove_offset_value (
  N-GObject $levelbar, Str $name, num64 $value
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

=head2 Not yet supported signals
=head3 offset-changed

Emitted when an offset specified on the bar changes value as an effect to C<gtk_level_bar_add_offset_value()> being called.

The signal supports detailed connections; you can connect to the detailed signal "changed::x" in order to only receive callbacks when the value of offset "x" changes.

=end pod
