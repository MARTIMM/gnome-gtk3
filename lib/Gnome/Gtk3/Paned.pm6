use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::Paned

=SUBTITLE Paned — A widget with two adjustable panes

  unit class Gnome::Gtk3::Paned;
  also is Gnome::Gtk3::Container;

=head1 Synopsis

  my Gnome::Gtk3::Paned $p .= new(:orientation(GTK_ORIENTATION_HORIZONTAL));
  my Gnome::Gtk3::ListBox $lb1 .= new(:empty);
  my Gnome::Gtk3::ListBox $lb2 .= new(:empty);
  $p.gtk-paned-add1($lb1);
  $p.gtk-paned-add2($lb2);

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkpaned.h
# https://developer.gnome.org/gtk3/stable/GtkPaned.html
unit class Gnome::Gtk3::Paned:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

  multi method new ( :$orientation! )

Create a new object with an orientation set to C<GTK_ORIENTATION_HORIZONTAL> or C<GTK_ORIENTATION_VERTICAL>.

  multi method new ( :$widget! )

Create an object using a native object from elsewhere. See also Gnome::GObject::Object.

  multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also Gnome::GObject::Object.

=end pod

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<accept-position cancel-position toggle-handle-focus>,
    :bool<cycle-child-focus cycle-handle-focus>,
    :enum<move-handle>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Paned';

  if %options<orientation>.defined #`{{orientation can be 0}} {
    self.native-gobject(gtk_paned_new(%options<orientation>));
  }

  elsif ? %options<widget> || %options<build-id> {
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
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_paned_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_paned_new

Creates a new native pane

  method gtk_paned_new ( Int $orientation --> N-GObject )

Returns a native widget. Can be used to initialize another object using :widget. This is very cumbersome when you know that a oneliner does the job for you: `my Gnome::Gtk3::Paned $m .= new(:$orientation);

  my Gnome::Gtk3::Paned $m;
  $m .= :new(:widget($m.gtk_paned_new(GTK_ORIENTATION_HORIZONTAL));

=end pod

sub gtk_paned_new ( int32 $orientation )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_paned_add1

Adds a child to the top or left pane with default parameters. This is equivalent to C<$p.gtk_paned_pack1( $child-widget, 0, 1)>.

  method gtk_paned_add1 ( N-GObject $child-widget )

=item $child-widget; Native child widget to add. When a Perl6 widget object is provided, the native widget is retrieved from that object. See example in the synopsis.

=end pod

sub gtk_paned_add1 ( N-GObject $paned, N-GObject $child)
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_paned_add2

Adds a child to the bottom or right pane with default parameters. This is equivalent to C<$p.gtk_paned_pack2( $child-widget, 1, 1)>.

  method gtk_paned_add2 ( N-GObject $child-widget )

=item $child-widget; Native child widget to add. When a Perl6 widget object is provided, the native widget is retrieved from that object. See example in the synopsis.

=end pod

sub gtk_paned_add2 ( N-GObject $paned, N-GObject $child)
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_paned_pack1

Adds a child to the top or left pane.

  method gtk_paned_pack1 ( N-GObject $child, Int $resize, Int $shrink )

=item $child; the child to add. When a Perl6 widget object is provided, the native widget is retrieved from that object. See example in the synopsis.
=item $resize; should this child expand when the paned widget is resized.
=item $shrink; can this child be made smaller than its requisition.
=end pod

sub gtk_paned_pack1 (
  N-GObject $paned, N-GObject $child, int32 $resize, int32 $shrink
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_paned_pack2

Adds a child to the bottom or right pane.

  method gtk_paned_pack2 ( N-GObject $child, Int $resize, Int $shrink )

=item $child; the child to add. When a Perl6 widget object is provided, the native widget is retrieved from that object. See example in the synopsis.
=item $resize; should this child expand when the paned widget is resized.
=item $shrink; can this child be made smaller than its requisition.
=end pod

sub gtk_paned_pack2 (
  N-GObject $paned, N-GObject $child, int32 $resize, int32 $shrink
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_paned_] get_child1

Obtains the first child of the paned widget.

  method gtk_paned_get_child1 ( --> N-GObject )

Returns the first child

  my Gnome::Gtk3::ListBox $lb .= new(:widget($p.get-child1()));

=end pod

sub gtk_paned_get_child1 ( N-GObject $paned )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_paned_] get_child2

Obtains the second child of the paned widget.

  method gtk_paned_get_child2 ( --> N-GObject )

Returns the second child

=end pod

sub gtk_paned_get_child2 ( N-GObject $paned )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_paned_] set_position

Sets the position of the divider between the two panes.

  method gtk_paned_set_position ( Int $position )

=item $position; pixel position of divider, a negative value means that the position is unset.

=end pod

sub gtk_paned_set_position ( N-GObject $paned, int32 $position)
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_paned_] get_position

Obtains the position of the divider between the two panes.

  method gtk_paned_get_position ( --> Int )

Returns position of the devider.

=end pod

sub gtk_paned_get_position ( N-GObject $paned )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_paned_] get_handle_window

Returns the C<GdkWindow> of the handle. This function is useful when handling button or motion events because it enables the callback to distinguish between the window of the paned, a child and the handle.

  method gtk_paned_get_handle_window ( --> N-GObject )

Returns a native C<GdkWindow>

=end pod

sub gtk_paned_get_handle_window ( N-GObject $paned )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_paned_] set_wide_handle

Sets the “wide-handle” property.

  method gtk_paned_set_wide_handle ( Int $wide )

=item $wide; the new value for the “wide-handle” property, this is 0 or 1.

=end pod

sub gtk_paned_set_wide_handle ( N-GObject $paned, int32 $wide )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_paned_] get_wide_handle

Gets the “wide-handle” property.

  method gtk_paned_get_wide_handle ( --> Int )

Returns 0 or 1 for the wide-handle property.

=end pod

sub gtk_paned_get_wide_handle ( N-GObject $paned )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals
=head2 Supported signals
=head3 accept-position

The C<accept-position> signal is a keybinding signal which gets emitted to accept the current position of the handle when moving it using key bindings.

The default binding for this signal is B<Return> or B<Space>.

=head3 cancel-position

The C<cancel-position> signal is a keybinding signal which gets emitted to cancel moving the position of the handle using key bindings. The position of the handle will be reset to the value prior to moving it.

The default binding for this signal is B<Escape>.

=head3 toggle-handle-focus

The C<toggle-handle-focus> is a keybinding signal which gets emitted to accept the current position of the handle and then move focus to the next widget in the focus chain.

The default binding is B<Tab>.


=head2 Not yet supported signals
=head3 cycle-child-focus

The C<cycle-child-focus> signal is a keybinding signal which gets emitted to cycle the focus between the children of the paned.

The default binding is B<f6>.

=head3 cycle-handle-focus

The C<cycle-handle-focus> signal is a keybinding signal which gets emitted to cycle whether the paned should grab focus to allow the user to change position of the handle by using key bindings.

The default binding for this signal is B<f8>.

=head3 move-handle

The C<move-handle> signal is a keybinding signal which gets emitted to move the handle when the user is using key bindings to move it.

=end pod
