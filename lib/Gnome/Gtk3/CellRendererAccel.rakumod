#TL:1:Gnome::Gtk3::CellRendererAccel:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellRendererAccel

Renders a keyboard accelerator in a cell

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::CellRendererAccel> displays a keyboard accelerator (i.e. a key combination like `Control + a`). If the cell renderer is editable, the accelerator can be changed by simply typing the new combination.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRendererAccel;
  also is Gnome::Gtk3::CellRendererText;


=head2 Uml Diagram

![](plantuml/CellRenderer-ea.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::CellRendererAccel:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::CellRendererAccel;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::CellRendererAccel class process the options
    self.bless( :GtkCellRendererAccel, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gtk3::CellRendererText:api<1>;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::CellRendererAccel:auth<github:MARTIMM>:api<1>;
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

=head3 default, no options

Create a new plain object.

  multi method new ( )


=head3 :native-object

Create a CellRendererAccel object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w4<accel-edited>, :w1<accel-cleared>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::CellRendererAccel' #`{{ or %options<GtkCellRendererAccel> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_cell_renderer_accel_new___x___($no);
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
        $no = _gtk_cell_renderer_accel_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkCellRendererAccel');
  }
}

#`{{
#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_cell_renderer_accel_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_cell_renderer_accel_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('cell-renderer-accel-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-cell-renderer-acceln-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

  self._set-class-name-of-sub('GtkCellRendererAccel');
  $s = callsame unless ?$s;

  $s;
}
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_cell_renderer_accel_new:
#`{{
=begin pod
=head2 _gtk_cell_renderer_accel_new

Creates a new B<Gnome::Gtk3::CellRendererAccel>.

Returns: the new cell renderer

  method _gtk_cell_renderer_accel_new ( --> N-GObject )

=end pod
}}

sub _gtk_cell_renderer_accel_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_cell_renderer_accel_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:accel-cleared:
=head2 accel-cleared

Gets emitted when the user has removed the accelerator.

  method handler (
    Str $path_string,
    Gnome::Gtk3::CellRendererAccel :_widget($accel),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $path_string; the path identifying the row of the edited cell
=item $accel; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:accel-edited:
=head2 accel-edited

Gets emitted when the user has selected a new accelerator.

  method handler (
    Str $path_string,
    Int $accel_key,
    GdkModifierType #`{ from Gnome::Gdk3::Window } $accel_mods,
    Int $hardware_keycode,
    Gnome::Gtk3::CellRendererAccel :_widget($accel),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $path_string; the path identifying the row of the edited cell
=item $accel_key; the new accelerator keyval
=item $accel_mods; the new acclerator modifier mask
=item $hardware_keycode; the keycode of the new accelerator
=item $accel; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:0:accel-key:
=head2 Accelerator key: accel-key

The keyval of the accelerator.

The B<Gnome::GObject::Value> type of property I<accel-key> is C<G_TYPE_UINT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:accel-mode:
=head2 accel-mode

Determines if the edited accelerators are GTK+ accelerators. If they are, consumed modifiers are suppressed, only accelerators accepted by GTK+ are allowed, and the accelerators are rendered in the same way as they are in menus.

Default value: False

The B<Gnome::GObject::Value> type of property I<accel-mode> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:0:accel-mods:
=head2 Accelerator modifiers: accel-mods

The modifier mask of the accelerator.

The B<Gnome::GObject::Value> type of property I<accel-mods> is C<G_TYPE_FLAGS>.

=comment -----------------------------------------------------------------------
=comment #TP:0:keycode:
=head2 Accelerator keycode: keycode

The hardware keycode of the accelerator. Note that the hardware keycode is only relevant if the key does not have a keyval. Normally, the keyboard configuration should assign keyvals to all keys.

The B<Gnome::GObject::Value> type of property I<keycode> is C<G_TYPE_UINT>.

=end pod
