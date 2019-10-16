#TL:1:Gnome::Gtk3::Paned:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Paned

A widget with two adjustable panes

![](images/panes.png)

=head1 Description


B<Gnome::Gtk3::Paned> has two panes, arranged either
horizontally or vertically. The division between
the two panes is adjustable by the user by dragging
a handle.

Child widgets are
added to the panes of the widget with C<gtk_paned_pack1()> and
C<gtk_paned_pack2()>. The division between the two children is set by default
from the size requests of the children, but it can be adjusted by the
user.

A paned widget draws a separator between the two child widgets and a
small handle that the user can drag to adjust the division. It does not
draw any relief around the children or around the separator. (The space
in which the separator is called the gutter.) Often, it is useful to put
each child inside a B<Gnome::Gtk3::Frame> with the shadow type set to C<GTK_SHADOW_IN>
so that the gutter appears as a ridge. No separator is drawn if one of
the children is missing.

Each child has two options that can be set, I<resize> and I<shrink>. If
I<resize> is true, then when the B<Gnome::Gtk3::Paned> is resized, that child will
expand or shrink along with the paned widget. If I<shrink> is true, then
that child can be made smaller than its requisition by the user.
Setting I<shrink> to C<0> allows the application to set a minimum size.
If I<resize> is false for both children, then this is treated as if
I<resize> is true for both children.

The application can set the position of the slider as if it were set
by the user, by calling C<gtk_paned_set_position()>.


=head2 Css Nodes

  paned
  ├── <child>
  ├── separator[.wide]
  ╰── <child>

B<Gnome::Gtk3::Paned> has a main CSS node with name paned, and a subnode for
the separator with name separator. The subnodes gets a .wide style
class when the paned is supposed to be wide.

In horizontal orientation, the nodes of the children are always arranged
from left to right. So I<first-child> will always select the leftmost child,
regardless of text direction.

=head2 Implemented Interfaces

Gnome::Gtk3::Paned implements
=item Gnome::Atk::ImplementorIface
=item Gnome::Gtk3::Buildable
=item [Gnome::Gtk3::Orientable](Orientable.html)


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Paned;
  also is Gnome::Gtk3::Container;

=head2 Example

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

Create a new object with an orientation set to C<GTK_ORIENTATION_HORIZONTAL> or C<GTK_ORIENTATION_VERTICAL>.

  multi method new ( :$orientation! )


Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:orientation):
#TM:0:new(:widget):
#TM:0:new(:build-id):

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

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkPaned');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_paned_$native-sub"); } unless ?$s;

  # search in the interface modules, name all interfaces which are implemented
  # for this module. not implemented ones are skipped.
  $s = self._query_interfaces(
    $native-sub, <
      Gnome::Atk::ImplementorIface Gnome::Gtk3::Buildable
      Gnome::Gtk3::Orientable
    >
  ) unless $s;

  self.set-class-name-of-sub('GtkPaned');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_paned_new:new(:orientation)
=begin pod
=head2 gtk_paned_new

Creates a new B<Gnome::Gtk3::Paned> widget.

Returns: a new B<Gnome::Gtk3::Paned>.

Since: 3.0

  method gtk_paned_new ( GtkOrientation $orientation --> N-GObject  )

=item GtkOrientation $orientation; the paned’s orientation.

=end pod

sub gtk_paned_new ( int32 $orientation )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_paned_add1:
=begin pod
=head2 gtk_paned_add1

Adds a child to the top or left pane with default parameters. This is
equivalent to
`gtk_paned_pack1 (paned, child, FALSE, TRUE)`.

  method gtk_paned_add1 ( N-GObject $child )

=item N-GObject $child; the child to add

=end pod

sub gtk_paned_add1 ( N-GObject $paned, N-GObject $child )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_paned_add2:
=begin pod
=head2 gtk_paned_add2

Adds a child to the bottom or right pane with default parameters. This
is equivalent to
`gtk_paned_pack2 (paned, child, TRUE, TRUE)`.

  method gtk_paned_add2 ( N-GObject $child )

=item N-GObject $child; the child to add

=end pod

sub gtk_paned_add2 ( N-GObject $paned, N-GObject $child )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_paned_pack1:
=begin pod
=head2 gtk_paned_pack1

Adds a child to the top or left pane.

  method gtk_paned_pack1 ( N-GObject $child, Int $resize, Int $shrink )

=item N-GObject $child; the child to add
=item Int $resize; should this child expand when the paned widget is resized.
=item Int $shrink; can this child be made smaller than its requisition.

=end pod

sub gtk_paned_pack1 ( N-GObject $paned, N-GObject $child, int32 $resize, int32 $shrink )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_paned_pack2:
=begin pod
=head2 gtk_paned_pack2

Adds a child to the bottom or right pane.

  method gtk_paned_pack2 ( N-GObject $child, Int $resize, Int $shrink )

=item N-GObject $child; the child to add
=item Int $resize; should this child expand when the paned widget is resized.
=item Int $shrink; can this child be made smaller than its requisition.

=end pod

sub gtk_paned_pack2 ( N-GObject $paned, N-GObject $child, int32 $resize, int32 $shrink )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_paned_get_position:
=begin pod
=head2 [gtk_paned_] get_position

Obtains the position of the divider between the two panes.

Returns: position of the divider

  method gtk_paned_get_position ( --> Int  )


=end pod

sub gtk_paned_get_position ( N-GObject $paned )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_paned_set_position:
=begin pod
=head2 [gtk_paned_] set_position

Sets the position of the divider between the two panes.

  method gtk_paned_set_position ( Int $position )

=item Int $position; pixel position of divider, a negative value means that the position is unset.

=end pod

sub gtk_paned_set_position ( N-GObject $paned, int32 $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_paned_get_child1:
=begin pod
=head2 [gtk_paned_] get_child1

Obtains the first child of the paned widget.

Returns: (nullable) (transfer none): first child, or C<Any> if it is not set.

Since: 2.4

  method gtk_paned_get_child1 ( --> N-GObject  )


=end pod

sub gtk_paned_get_child1 ( N-GObject $paned )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_paned_get_child2:
=begin pod
=head2 [gtk_paned_] get_child2

Obtains the second child of the paned widget.

Returns: (nullable) (transfer none): second child, or C<Any> if it is not set.

Since: 2.4

  method gtk_paned_get_child2 ( --> N-GObject  )


=end pod

sub gtk_paned_get_child2 ( N-GObject $paned )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_paned_get_handle_window:
=begin pod
=head2 [gtk_paned_] get_handle_window

Returns the B<Gnome::Gdk3::Window> of the handle. This function is
useful when handling button or motion events because it
enables the callback to distinguish between the window
of the paned, a child and the handle.

Returns: (transfer none): the paned’s handle window.

Since: 2.20

  method gtk_paned_get_handle_window ( --> N-GObject  )


=end pod

sub gtk_paned_get_handle_window ( N-GObject $paned )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_paned_set_wide_handle:
=begin pod
=head2 [gtk_paned_] set_wide_handle

Sets the  I<wide-handle> property.

Since: 3.16

  method gtk_paned_set_wide_handle ( Int $wide )

=item Int $wide; the new value for the  I<wide-handle> property

=end pod

sub gtk_paned_set_wide_handle ( N-GObject $paned, int32 $wide )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_paned_get_wide_handle:
=begin pod
=head2 [gtk_paned_] get_wide_handle

Gets the  I<wide-handle> property.

Returns: C<1> if the paned should have a wide handle

Since: 3.16

  method gtk_paned_get_wide_handle ( --> Int  )


=end pod

sub gtk_paned_get_wide_handle ( N-GObject $paned )
  returns int32
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

=comment #TS:0:cycle-child-focus:
=head3 cycle-child-focus

The I<cycle-child-focus> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to cycle the focus between the children of the paned.

The default binding is f6.

Since: 2.0

  method handler (
    Int $reversed,
    Gnome::GObject::Object :widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object that received the signal

=item $reversed; whether cycling backward or forward


=comment #TS:0:toggle-handle-focus:
=head3 toggle-handle-focus

The I<toggle-handle-focus> is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to accept the current position of the handle and then
move focus to the next widget in the focus chain.

The default binding is Tab.

Since: 2.0

  method handler (
    Gnome::GObject::Object :widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object that received the signal


=comment #TS:0:move-handle:
=head3 move-handle

The I<move-handle> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to move the handle when the user is using key bindings
to move it.

Since: 2.0

  method handler (
    Int $scroll_type,
    Gnome::GObject::Object :widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object that received the signal

=item $scroll_type; a B<Gnome::Gtk3::ScrollType>


=comment #TS:0:cycle-handle-focus:
=head3 cycle-handle-focus

The I<cycle-handle-focus> signal is a keybinding signal
which gets emitted to cycle whether the paned should grab focus to allow
the user to change position of the handle by using key bindings.

The default binding for this signal is f8.

Since: 2.0

  method handler (
    Int $reversed,
    Gnome::GObject::Object :widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object that received the signal

=item $reversed; whether cycling backward or forward


=comment #TS:0:accept-position:
=head3 accept-position

The I<accept-position> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to accept the current position of the handle when
moving it using key bindings.

The default binding for this signal is Return or Space.

Since: 2.0

  method handler (
    Gnome::GObject::Object :widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object that received the signal


=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:position:
=head3 Position



The B<Gnome::GObject::Value> type of property I<position> is C<G_TYPE_INT>.

=comment #TP:0:position-set:
=head3 Position Set

TRUE if the Position property should be used
Default value: False


The B<Gnome::GObject::Value> type of property I<position-set> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:min-position:
=head3 Minimal Position


The smallest possible value for the position property.
This property is derived from the size and shrinkability
of the widget's children.
Since: 2.4

The B<Gnome::GObject::Value> type of property I<min-position> is C<G_TYPE_INT>.

=comment #TP:0:max-position:
=head3 Maximal Position


The largest possible value for the position property.
This property is derived from the size and shrinkability
of the widget's children.
Since: 2.4

The B<Gnome::GObject::Value> type of property I<max-position> is C<G_TYPE_INT>.

=comment #TP:0:wide-handle:
=head3 Wide Handle


Setting this property to C<1> indicates that the paned needs
to provide stronger visual separation (e.g. because it separates
between two notebooks, whose tab rows would otherwise merge visually).
Since: 3.16

The B<Gnome::GObject::Value> type of property I<wide-handle> is C<G_TYPE_BOOLEAN>.
=end pod
























=finish
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
