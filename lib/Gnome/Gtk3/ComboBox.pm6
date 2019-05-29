use v6;
# ==============================================================================
=begin pod

=TITLE Gnome::Gtk3::ComboBox

=SUBTITLE

  unit class Gnome::Gtk3::ComboBox;
  also is Gnome::Gtk3::Bin;

=head2 ComboBox — A widget used to choose from a list of items

=head1 Synopsis

  # Get a fully designed combobox
  my Gnome::Gtk3::ComboBox $server-cb .= new(:build-id<serverComboBox>);
  my Str $server = $server-cb.get-active-id;
=end pod
# ==============================================================================
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcombobox.h
# https://developer.gnome.org/gtk3/stable/GtkComboBox.html
unit class Gnome::Gtk3::ComboBox:auth<github:MARTIMM>;
also is Gnome::Gtk3::Bin;

# ==============================================================================
=begin pod

=head1 Methods

=head2 [gtk_combo_box_] get_active

  method gtk_combo_box_get_active ( --> int32 )

Returns the index of the currently active item, or -1 if there’s no active item. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkComboBox.html#gtk-combo-box-get-active>.
=end pod
sub gtk_combo_box_get_active ( N-GObject $combo_box )
  returns int32
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod

=head2 [gtk_combo_box_] set_active

  method gtk_combo_box_set_active ( int32 $index )

Sets the active item of combo_box to be the item at index. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkComboBox.html#gtk-combo-box-set-active>.
=end pod
#TODO automatic conversions of Int <-> int32/int64 etc.
sub gtk_combo_box_set_active ( N-GObject $combo_box, int32 $index )
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod

=head2 [gtk_combo_box_] get_active_id

  method gtk_combo_box_get_active_id ( --> Str )

Returns the ID of the active row of combo_box. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkComboBox.html#gtk-combo-box-get-active-id>.
=end pod
sub gtk_combo_box_get_active_id ( N-GObject $combo_box )
  returns Str
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod

=head2 [gtk_combo_box_] set_active_id

  method gtk_combo_box_set_active_id ( Str $active_id )

Changes the active row of combo_box. See also L<gnome developer docs|https://developer.gnome.org/gtk3/stable/GtkComboBox.html#gtk-combo-box-set-active-id>.
=end pod
sub gtk_combo_box_set_active_id ( N-GObject $combo_box, Str $active_id )
  returns int32 # Bool
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head2 new

  multi method new ( :$widget! )

Create a combobox using a native object from elsewhere. See also Gnome::GObject::Object.

  multi method new ( Str :$build-id! )

Create a combobox using a native object from a builder. See also Gnome::GObject::Object.

=end pod
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<changed popdown popup>,
    :strretstr<format-entry-text>,
    :GtkScrollType<move-active>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::ComboBox';

  #TODO %options.keys ~~ any(<widget build-id id name>) { ... }
  if ? %options<widget> || ? %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_combo_box_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
