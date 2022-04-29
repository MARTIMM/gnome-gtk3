#TL:1:Gnome::Gtk3::CellRendererToggle:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellRendererToggle

Renders a toggle button in a cell


=head1 Description

B<Gnome::Gtk3::CellRendererToggle> renders a toggle button in a cell. The button is drawn as a radio or a checkbutton, depending on the I<radio> property. When activated, it emits the  I<toggled> signal.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRendererToggle;
  also is Gnome::Gtk3::CellRenderer;


=head2 Uml Diagram

=comment ![](plantuml/CellRenderer-ea.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::CellRendererToggle;

  unit class MyGuiClass;
  also is Gnome::Gtk3::CellRendererToggle;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::CellRendererToggle class process the options
    self.bless( :GtkCellRendererToggle, |c);
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
use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::CellRenderer;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::CellRendererToggle:auth<github:MARTIMM>;
also is Gnome::Gtk3::CellRenderer;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new CellRendererToggle object.

  multi method new ( )


=head3 :native-object

Create a CellRendererToggle object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a CellRendererToggle object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w1<toggled>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::CellRendererToggle' #`{{ or %options<GtkCellRendererToggle> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_cell_renderer_toggle_new___x___($no);
      }

      ##`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      #}}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_cell_renderer_toggle_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkCellRendererToggle');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_cell_renderer_toggle_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_cell_renderer_toggle_$native-sub", $new-patt, '0.48.3', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('cell-renderer-toggle-'),
        '0.48.3', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-cell-renderer-toggle-'),
          '0.48.3', '0.50.0'
        );
      }
    }
  }

  self._set-class-name-of-sub('GtkCellRendererToggle');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:get-activatable:
=begin pod
=head2 get-activatable

Returns whether the cell renderer is activatable. See C<set_activatable()>.

Returns: C<True> if the cell renderer is activatable.

  method get-activatable ( --> Bool )

=end pod

method get-activatable ( --> Bool ) {
  gtk_cell_renderer_toggle_get_activatable(
    self._get-native-object-no-reffing
  ).Bool
}

sub gtk_cell_renderer_toggle_get_activatable (
  N-GObject $toggle --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-active:
=begin pod
=head2 get-active

Returns whether the cell renderer is active. See C<set_active()>.

Returns: C<True> if the cell renderer is active.

  method get-active ( --> Bool )

=end pod

method get-active ( --> Bool ) {
  gtk_cell_renderer_toggle_get_active(
    self._get-native-object-no-reffing
  ).Bool
}

sub gtk_cell_renderer_toggle_get_active (
  N-GObject $toggle --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-radio:
=begin pod
=head2 get-radio

Returns whether we’re rendering radio toggles rather than checkboxes.

Returns: C<True> if we’re rendering radio toggles.

  method get-radio ( --> Bool )

=end pod

method get-radio ( --> Bool ) {
  gtk_cell_renderer_toggle_get_radio(
    self._get-native-object-no-reffing
  ).Bool
}

sub gtk_cell_renderer_toggle_get_radio (
  N-GObject $toggle --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-activatable:
=begin pod
=head2 set-activatable

Makes the cell renderer activatable.

  method set-activatable ( Bool $setting )

=item $setting; the value to set.
=end pod

method set-activatable ( Bool $setting ) {
  gtk_cell_renderer_toggle_set_activatable(
    self._get-native-object-no-reffing, $setting
  );
}

sub gtk_cell_renderer_toggle_set_activatable (
  N-GObject $toggle, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-active:
=begin pod
=head2 set-active

Activates or deactivates a cell renderer.

  method set-active ( Bool $setting )

=item $setting; the value to set.
=end pod

method set-active ( Bool $setting ) {
  gtk_cell_renderer_toggle_set_active(
    self._get-native-object-no-reffing, $setting
  );
}

sub gtk_cell_renderer_toggle_set_active (
  N-GObject $toggle, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-radio:
=begin pod
=head2 set-radio

If I<radio> is C<True>, the cell renderer renders a radio toggle (i.e. a toggle in a group of mutually-exclusive toggles). If C<False>, it renders a check toggle (a standalone boolean option). This can be set globally for the cell renderer, or changed just before rendering each cell in the model (for B<Gnome::Gtk3::TreeView>, you set up a per-row setting using B<Gnome::Gtk3::TreeViewColumn> to associate model columns with cell renderer properties).

  method set-radio ( Bool $radio )

=item $radio; C<True> to make the toggle look like a radio button
=end pod

method set-radio ( Bool $radio ) {
  gtk_cell_renderer_toggle_set_radio(
    self._get-native-object-no-reffing, $radio
  );
}

sub gtk_cell_renderer_toggle_set_radio (
  N-GObject $toggle, gboolean $radio
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_cell_renderer_toggle_new:
#`{{
=begin pod
=head2 _gtk_cell_renderer_toggle_new

Creates a new B<Gnome::Gtk3::CellRendererToggle>. Adjust rendering parameters using object properties. Object properties can be set globally (with C<g_object_set()>). Also, with B<Gnome::Gtk3::TreeViewColumn>, you can bind a property to a value in a B<Gnome::Gtk3::TreeModel>. For example, you can bind the “active” property on the cell renderer to a boolean value in the model, thus causing the check button to reflect the state of the model.

Returns: the new cell renderer

  method _gtk_cell_renderer_toggle_new ( --> N-GObject )

=end pod
}}

sub _gtk_cell_renderer_toggle_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_cell_renderer_toggle_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:toggled:
=head2 toggled

The I<toggled> signal is emitted when the cell is toggled.

It is the responsibility of the application to update the model
with the correct value to store at I<path>.  Often this is simply the
opposite of the value currently stored at I<path>.

  method handler (
    Str $path,
    Gnome::Gtk3::CellRendererToggle :_widget($cell_renderer),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $path; string representation of B<Gnome::Gtk3::TreePath> describing the  event location
=item $cell_renderer; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:1:activatable:
=head2 activatable

The toggle button can be activated

The B<Gnome::GObject::Value> type of property I<activatable> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:1:active:
=head2 active

The toggle state of the button

The B<Gnome::GObject::Value> type of property I<active> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:inconsistent:
=head2 inconsistent

The inconsistent state of the button

The B<Gnome::GObject::Value> type of property I<inconsistent> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:radio:
=head2 radio

Draw the toggle button as a radio button

The B<Gnome::GObject::Value> type of property I<radio> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is FALSE.

=end pod



































=finish
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

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

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w1<toggled>,
    );
  }

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::CellRendererToggle';

  # process all named arguments
  if ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  else {#if ? %options<empty> {
    self._set-native-object(gtk_cell_renderer_toggle_new());
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkCellRendererToggle');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_cell_renderer_toggle_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkCellRendererToggle');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_toggle_new:new()
=begin pod
=head2 [gtk_] cell_renderer_toggle_new

Creates a new B<Gnome::Gtk3::CellRendererToggle>. Adjust rendering parameters using object properties. Object properties can be set globally (with C<g_object_set()>). Also, with B<Gnome::Gtk3::TreeViewColumn>, you can bind a property to a value in a B<Gnome::Gtk3::TreeModel>. For example, you can bind the “active” property on the cell renderer to a boolean value in the model, thus causing the check button to reflect the state of the model.

Returns: the new cell renderer

  method gtk_cell_renderer_toggle_new ( --> N-GObject  )


=end pod

sub gtk_cell_renderer_toggle_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_cell_renderer_toggle_get_radio:
=begin pod
=head2 [[gtk_] cell_renderer_toggle_] get_radio

Returns C<1> whether we’re rendering radio toggles rather than checkboxes.

  method gtk_cell_renderer_toggle_get_radio ( --> Int  )


=end pod

sub gtk_cell_renderer_toggle_get_radio ( N-GObject $toggle )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_cell_renderer_toggle_set_radio:
=begin pod
=head2 [[gtk_] cell_renderer_toggle_] set_radio

If I<$radio> is C<True>, the cell renderer renders a radio toggle (i.e. a toggle in a group of mutually-exclusive toggles). If C<False>, it renders a check toggle (a standalone boolean option). This can be set globally for the cell renderer, or changed just before rendering each cell in the model (for B<Gnome::Gtk3::TreeView>, you set up a per-row setting using B<Gnome::Gtk3::TreeViewColumn> to associate model columns with cell renderer properties).

  method gtk_cell_renderer_toggle_set_radio ( Bool $radio )

=item Bool $radio; C<True> to make the toggle look like a radio button

=end pod

sub gtk_cell_renderer_toggle_set_radio ( N-GObject $toggle, int32 $radio )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_cell_renderer_toggle_get_active:
=begin pod
=head2 [[gtk_] cell_renderer_toggle_] get_active

Returns C<1> if the cell renderer is active. See C<gtk_cell_renderer_toggle_set_active()>.

  method gtk_cell_renderer_toggle_get_active ( --> Int  )


=end pod

sub gtk_cell_renderer_toggle_get_active ( N-GObject $toggle )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_cell_renderer_toggle_set_active:
=begin pod
=head2 [[gtk_] cell_renderer_toggle_] set_active

Activates or deactivates a cell renderer.

  method gtk_cell_renderer_toggle_set_active ( Bool $setting )

=item Bool $setting; the value to set.

=end pod

sub gtk_cell_renderer_toggle_set_active ( N-GObject $toggle, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_cell_renderer_toggle_get_activatable:
=begin pod
=head2 [[gtk_] cell_renderer_toggle_] get_activatable

Returns C<1> if the cell renderer is activatable. See C<gtk_cell_renderer_toggle_set_activatable()>.

Since: 2.18

  method gtk_cell_renderer_toggle_get_activatable ( --> Int  )


=end pod

sub gtk_cell_renderer_toggle_get_activatable ( N-GObject $toggle )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_cell_renderer_toggle_set_activatable:
=begin pod
=head2 [[gtk_] cell_renderer_toggle_] set_activatable

Makes the cell renderer activatable.

Since: 2.18

  method gtk_cell_renderer_toggle_set_activatable ( Bool $setting )

=item Bool $setting; the value to set.

=end pod

sub gtk_cell_renderer_toggle_set_activatable ( N-GObject $toggle, int32 $setting )
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


=comment #TS:0:toggled:
=head3 toggled

The I<toggled> signal is emitted when the cell is toggled.

It is the responsibility of the application to update the model
with the correct value to store at I<path>.  Often this is simply the
opposite of the value currently stored at I<path>.

  method handler (
    Str $path,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($cell_renderer),
    *%user-options
  );

=item $cell_renderer; the object which received the signal

=item $path; string representation of B<Gnome::Gtk3::TreePath> describing the
event location

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

=comment #TP:0:active:
=head3 Toggle state

The toggle state of the button
Default value: False


The B<Gnome::GObject::Value> type of property I<active> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:inconsistent:
=head3 Inconsistent state

The inconsistent state of the button
Default value: False


The B<Gnome::GObject::Value> type of property I<inconsistent> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:activatable:
=head3 Activatable

The toggle button can be activated
Default value: True


The B<Gnome::GObject::Value> type of property I<activatable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:radio:
=head3 Radio state

Draw the toggle button as a radio button
Default value: False


The B<Gnome::GObject::Value> type of property I<radio> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:indicator-size:
=head3 Indicator size



The B<Gnome::GObject::Value> type of property I<indicator-size> is C<G_TYPE_INT>.
=end pod
