#TL:1:Gnome::Gtk3::CellRendererAccel:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellRendererAccel

Renders a keyboard accelerator in a cell

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::CellRendererAccel> displays a keyboard accelerator (i.e. a key combination like `Control + a`). If the cell renderer is editable, the accelerator can be changed by simply typing the new combination.

The B<Gnome::Gtk3::CellRendererAccel> cell renderer was added in GTK+ 2.10.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRendererAccel;
  also is Gnome::Gtk3::CellRendererText;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::CellRendererText;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::CellRendererAccel:auth<github:MARTIMM>;
also is Gnome::Gtk3::CellRendererText;


#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkCellRendererAccelMode

Determines if the edited accelerators are GTK+ accelerators. If they are, consumed modifiers are suppressed, only accelerators accepted by GTK+ are allowed, and the accelerators are rendered in the same way as they are in menus.

=item GTK_CELL_RENDERER_ACCEL_MODE_GTK: GTK+ accelerators mode
=item GTK_CELL_RENDERER_ACCEL_MODE_OTHER: Other accelerator mode

=end pod

#TE:0:GtkCellRendererAccelMode:
enum GtkCellRendererAccelMode is export (
  'GTK_CELL_RENDERER_ACCEL_MODE_GTK',
  'GTK_CELL_RENDERER_ACCEL_MODE_OTHER'
);

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:0:new(:widget):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w4<accel-edited>, :w1<accel-cleared>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::CellRendererAccel';

  # process all named arguments
  if ? %options<empty> {
    Gnome::N::deprecate( '.new(:empty)', '.new()', '0.21.3', '0.30.0');
    self.set-native-object(gtk_cell_renderer_accel_new());
  }

  elsif ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  else { #if ? %options<empty> {
    self.set-native-object(gtk_cell_renderer_accel_new());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkCellRendererAccel');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_cell_renderer_accel_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkCellRendererAccel');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_accel_new:new()
=begin pod
=head2 gtk_cell_renderer_accel_new

Creates a new B<Gnome::Gtk3::CellRendererAccel>.

Returns: the new cell renderer

Since: 2.10

  method gtk_cell_renderer_accel_new ( --> N-GObject  )


=end pod

sub gtk_cell_renderer_accel_new (  )
  returns N-GObject
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


=comment #TS:0:accel-edited:
=head3 accel-edited

Gets emitted when the user has selected a new accelerator.

Since: 2.10

  method handler (
    Str $path_string,
    uint32 $accel_key,
    uint32 $accel_mods,
    uint32 $hardware_keycode,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($accel),
    *%user-options
    --> Int
  );

=item $accel; the object reveiving the signal

=item $path_string; the path identifying the row of the edited cell

=item $accel_key; the new accelerator keyval

=item $accel_mods; the new acclerator modifier mask defined in Gnome::Gdk3::Window as enum GdkModifierType

=item $hardware_keycode; the keycode of the new accelerator


=comment #TS:0:accel-cleared:
=head3 accel-cleared

Gets emitted when the user has removed the accelerator.

Since: 2.10

  method handler (
    Str $path_string,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($accel),
    *%user-options
  );

=item $accel; the object reveiving the signal

=item $path_string; the path identifying the row of the edited cell


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

=comment #TP:0:accel-key:
=head3 Accelerator key


The keyval of the accelerator.
Since: 2.10

The B<Gnome::GObject::Value> type of property I<accel-key> is C<G_TYPE_UINT>.

=comment #TP:0:accel-mods:
=head3 Accelerator modifiers


The modifier mask of the accelerator.
Since: 2.10

The B<Gnome::GObject::Value> type of property I<accel-mods> is C<G_TYPE_FLAGS>.

=comment #TP:0:keycode:
=head3 Accelerator keycode


The hardware keycode of the accelerator. Note that the hardware keycode is
only relevant if the key does not have a keyval. Normally, the keyboard
configuration should assign keyvals to all keys.
Since: 2.10

The B<Gnome::GObject::Value> type of property I<keycode> is C<G_TYPE_UINT>.

=comment #TP:0:accel-mode:
=head3 Accelerator Mode


Determines if the edited accelerators are GTK+ accelerators. If
they are, consumed modifiers are suppressed, only accelerators
accepted by GTK+ are allowed, and the accelerators are rendered
in the same way as they are in menus.
Since: 2.10
Widget type: GTK_TYPE_CELL_RENDERER_ACCEL_MODE

The B<Gnome::GObject::Value> type of property I<accel-mode> is C<G_TYPE_ENUM>.

=comment #TP:0:accel-mode:
=head3 NULL

NULL
Default value: False


The B<Gnome::GObject::Value> type of property I<accel-mode> is C<G_TYPE_ENUM>.

=comment #TP:0:path:
=head3 NULL

NULL
Default value: Any


The B<Gnome::GObject::Value> type of property I<path> is C<G_TYPE_STRING>.
=end pod
