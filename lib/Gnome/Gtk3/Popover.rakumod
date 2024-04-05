#TL:1:Gnome::Gtk3::Popover:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Popover

Context dependent bubbles

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::Popover> is a bubble-like context window, primarily meant to provide context-dependent information or options. Popovers are attached to a widget, passed at construction time on C<gtk_popover_new()>, or updated afterwards through C<gtk_popover_set_relative_to()>, by default they will point to the whole widget area, although this behavior can be changed through C<gtk_popover_set_pointing_to()>.

The position of a popover relative to the widget it is attached to can also be changed through C<gtk_popover_set_position()>.

By default, B<Gnome::Gtk3::Popover> performs a GTK+ grab, in order to ensure input events get redirected to it while it is shown, and also so the popover is dismissed in the expected situations (clicks outside the popover, or the Esc key being pressed). If no such modal behavior is desired on a popover, C<gtk_popover_set_modal()> may be called on it to tweak its behavior.

=begin comment
GMenu is deprecated
=head2 B<Gnome::Gtk3::Popover> as menu replacement

B<Gnome::Gtk3::Popover> is often used to replace menus.
To use this rendering, set the ”display-hint” attribute of the
section to ”horizontal-buttons” and set the icons of your items
with the ”verb-icon” attribute.

|[
<section>
  <attribute name="display-hint">horizontal-buttons</attribute>
  <item>
    <attribute name="label">Cut</attribute>
    <attribute name="action">app.cut</attribute>
    <attribute name="verb-icon">edit-cut-symbolic</attribute>
  </item>
  <item>
    <attribute name="label">Copy</attribute>
    <attribute name="action">app.copy</attribute>
    <attribute name="verb-icon">edit-copy-symbolic</attribute>
  </item>
  <item>
    <attribute name="label">Paste</attribute>
    <attribute name="action">app.paste</attribute>
    <attribute name="verb-icon">edit-paste-symbolic</attribute>
  </item>
</section>
]|
=end comment

=head2 Css Nodes

B<Gnome::Gtk3::Popover> has a single css node called popover. It always gets the .background style class and it gets the .menu style class if it is menu-like (e.g. B<Gnome::Gtk3::PopoverMenu> or created using C<gtk_popover_new_from_model()>.

Particular uses of B<Gnome::Gtk3::Popover>, such as touch selection popups or magnifiers in B<Gnome::Gtk3::Entry> or B<Gnome::Gtk3::TextView> get style classes like .touch-selection or .magnifier to differentiate from plain popovers.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Popover;
  also is Gnome::Gtk3::Bin;

=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Popover:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Popover;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Popover class process the options
    self.bless( :GtkPopover, |c);
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
use Gnome::Gdk3::Types:api<1>;
use Gnome::Gio::MenuModel:api<1>;
use Gnome::Gtk3::Bin:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Popover:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Bin;
#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new Popover object to point to I<relative_to>.

  multi method new ( N-GObject :$relative-to! )

Create a Popover object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

Create a Popover object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:0:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<closed>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Popover' #`{{ or %options<GtkPopover> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

#`{{
    elsif ? %options<relative-to>  and ? %options<model> {
      my $no = %options<relative-to>;
      $no .= _get-native-object if $no.^can('_get-native-object');
      my $mo = %options<model>;
      $mo .= _get-native-object if $mo.^can('_get-native-object');
      self._set-native-object(_gtk_popover_new_from_model( $no, $mo));
    }
}}

    elsif ? %options<relative-to> {
      my $no = %options<relative-to>;
      $no .= _get-native-object if $no.^can('_get-native-object');
      self._set-native-object(_gtk_popover_new($no));
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

    #`{{ when there are defaults use this instead
    # create default object
    else {
      self._set-native-object(gtk_popover_new());
    }
    }}

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkPopover');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_popover_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkPopover');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:0:_gtk_popover_new:
#`{{
=begin pod
=head2 gtk_popover_new

Creates a new popover to point to I<relative_to>

Returns: a new B<Gnome::Gtk3::Popover>


  method gtk_popover_new ( N-GObject $relative_to --> N-GObject )

=item N-GObject $relative_to; (allow-none): B<Gnome::Gtk3::Widget> the popover is related to

=end pod
}}

sub _gtk_popover_new ( N-GObject $relative_to --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_popover_new')
  { * }

#-------------------------------------------------------------------------------
#TM:0:_gtk_popover_new_from_model:
#`{{
=begin pod
=head2 [gtk_popover_] new_from_model

Creates a B<Gnome::Gtk3::Popover> and populates it according to
I<model>. The popover is pointed to the I<relative_to> widget.

The created buttons are connected to actions found in the
B<Gnome::Gtk3::ApplicationWindow> to which the popover belongs - typically
by means of being attached to a widget that is contained within
the B<Gnome::Gtk3::ApplicationWindows> widget hierarchy.

Actions can also be added using C<gtk_widget_insert_action_group()>
on the menus attach widget or on any of its parent widgets.

Returns: the new B<Gnome::Gtk3::Popover>


  method gtk_popover_new_from_model ( N-GObject $relative_to, GMenuModel $model --> N-GObject )

=item N-GObject $relative_to; (allow-none): B<Gnome::Gtk3::Widget> the popover is related to
=item GMenuModel $model; a B<GMenuModel>

=end pod
}}

#`{{
sub _gtk_popover_new_from_model (
  N-GObject $relative_to, N-GObject $model --> N-GObject
) is native(&gtk-lib)
  is symbol('gtk_popover_new_from_model')
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_set_relative_to:
=begin pod
=head2 [gtk_popover_] set_relative_to

Sets a new widget to be attached to I<popover>. If I<popover> is
visible, the position will be updated.

Note: the ownership of popovers is always given to their I<relative_to>
widget, so if I<relative_to> is set to C<Any> on an attached I<popover>, it
will be detached from its previous widget, and consequently destroyed
unless extra references are kept.


  method gtk_popover_set_relative_to ( N-GObject $relative_to )

=item N-GObject $relative_to; (allow-none): a B<Gnome::Gtk3::Widget>

=end pod

sub gtk_popover_set_relative_to ( N-GObject $popover, N-GObject $relative_to  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_get_relative_to:
=begin pod
=head2 [gtk_popover_] get_relative_to

Returns the widget I<popover> is currently attached to

Returns: (transfer none): a B<Gnome::Gtk3::Widget>


  method gtk_popover_get_relative_to ( --> N-GObject )


=end pod

sub gtk_popover_get_relative_to ( N-GObject $popover --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_set_pointing_to:
=begin pod
=head2 [gtk_popover_] set_pointing_to

Sets the rectangle that I<popover> will point to, in the coordinate space of the widget I<popover> is attached to, see C<gtk_popover_set_relative_to()>.

  method gtk_popover_set_pointing_to ( N-GdkRectangle $rect )

=item N-GdkRectangle $rect; rectangle to point to

=end pod

sub gtk_popover_set_pointing_to ( N-GObject $popover, N-GdkRectangle $rect  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_get_pointing_to:
=begin pod
=head2 [gtk_popover_] get_pointing_to

If a rectangle to point to has been set, this function will
return C<1> and fill in I<rect> with such rectangle, otherwise
it will return C<0> and fill in I<rect> with the attached
widget coordinates.

Returns: C<1> if a rectangle to point to was set.

  method gtk_popover_get_pointing_to ( N-GObject $rect --> Int )

=item N-GObject $rect; (out): location to store the rectangle

=end pod

sub gtk_popover_get_pointing_to ( N-GObject $popover, N-GObject $rect --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_set_position:
=begin pod
=head2 [gtk_popover_] set_position

Sets the preferred position for I<popover> to appear. If the I<popover>
is currently visible, it will be immediately updated.

This preference will be respected where possible, although
on lack of space (eg. if close to the window edges), the
B<Gnome::Gtk3::Popover> may choose to appear on the opposite side


  method gtk_popover_set_position ( GtkPositionType $position )

=item GtkPositionType $position; preferred popover position

=end pod

sub gtk_popover_set_position ( N-GObject $popover, int32 $position  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_get_position:
=begin pod
=head2 [gtk_popover_] get_position

Returns the preferred position of I<popover>.

Returns: The preferred position.

  method gtk_popover_get_position ( --> GtkPositionType )


=end pod

sub gtk_popover_get_position ( N-GObject $popover --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_set_modal:
=begin pod
=head2 [gtk_popover_] set_modal

Sets whether I<popover> is modal, a modal popover will grab all input
within the toplevel and grab the keyboard focus on it when being
displayed. Clicking outside the popover area or pressing Esc will
dismiss the popover and ungrab input.


  method gtk_popover_set_modal ( Int $modal )

=item Int $modal; B<TRUE> to make popover claim all input within the toplevel

=end pod

sub gtk_popover_set_modal ( N-GObject $popover, int32 $modal  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_get_modal:
=begin pod
=head2 [gtk_popover_] get_modal

Returns whether the popover is modal, see gtk_popover_set_modal to
see the implications of this.

Returns: B<TRUE> if I<popover> is modal


  method gtk_popover_get_modal ( --> Int )


=end pod

sub gtk_popover_get_modal ( N-GObject $popover --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_bind_model:
=begin pod
=head2 [gtk_popover_] bind_model

Establishes a binding between a B<Gnome::Gtk3::Popover> and a B<GMenuModel>.

The contents of I<popover> are removed and then refilled with menu items
according to I<model>.  When I<model> changes, I<popover> is updated.
Calling this function twice on I<popover> with different I<model> will
cause the first binding to be replaced with a binding to the new
model. If I<model> is C<Any> then any previous binding is undone and
all children are removed.

If I<action_namespace> is non-C<Any> then the effect is as if all
actions mentioned in the I<model> have their names prefixed with the
namespace, plus a dot.  For example, if the action “quit” is
mentioned and I<action_namespace> is “app” then the effective action
name is “app.quit”.

This function uses B<Gnome::Gtk3::Actionable> to define the action name and
target values on the created menu items.  If you want to use an
action group other than “app” and “win”, or if you want to use a
B<Gnome::Gtk3::MenuShell> outside of a B<Gnome::Gtk3::ApplicationWindow>, then you will need
to attach your own action group to the widget hierarchy using
C<gtk_widget_insert_action_group()>.  As an example, if you created a
group with a “quit” action and inserted it with the name “mygroup”
then you would use the action name “mygroup.quit” in your
B<GMenuModel>.


  method gtk_popover_bind_model ( N-GObject $model, Str $action_namespace )

=item N-GObject $model; the B<GMenuModel> to bind to or undefined to remove binding
=item Str $action_namespace; the namespace for actions in I<model>. May be undefined

=end pod

sub gtk_popover_bind_model ( N-GObject $popover, N-GObject $model, Str $action_namespace  )
  is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
#TM:0:gtk_popover_set_default_widget:
=begin pod
=head2 [gtk_popover_] set_default_widget

Sets the widget that should be set as default widget while
the popover is shown (see C<gtk_window_set_default()>). B<Gnome::Gtk3::Popover>
remembers the previous default widget and reestablishes it
when the popover is dismissed.


  method gtk_popover_set_default_widget ( N-GObject $widget )

=item N-GObject $widget; (allow-none): the new default widget, or C<Any>

=end pod

sub gtk_popover_set_default_widget ( N-GObject $popover, N-GObject $widget  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_get_default_widget:
=begin pod
=head2 [gtk_popover_] get_default_widget

Gets the widget that should be set as the default while
the popover is shown.

Returns: (nullable) (transfer none): the default widget,
or C<Any> if there is none


  method gtk_popover_get_default_widget ( --> N-GObject )


=end pod

sub gtk_popover_get_default_widget ( N-GObject $popover --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_set_constrain_to:
=begin pod
=head2 [gtk_popover_] set_constrain_to

Sets a constraint for positioning this popover.

Note that not all platforms support placing popovers freely,
and may already impose constraints.


  method gtk_popover_set_constrain_to ( GtkPopoverConstraInt $constraint )

=item GtkPopoverConstraInt $constraint; the new constraint

=end pod

sub gtk_popover_set_constrain_to ( N-GObject $popover, int32 $constraint  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_get_constrain_to:
=begin pod
=head2 [gtk_popover_] get_constrain_to

Returns the constraint for placing this popover.
See C<gtk_popover_set_constrain_to()>.

Returns: the constraint for placing this popover.


  method gtk_popover_get_constrain_to ( --> GtkPopoverConstraInt )


=end pod

sub gtk_popover_get_constrain_to ( N-GObject $popover --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_popup:
=begin pod
=head2 gtk_popover_popup

Pops I<popover> up. This is different than a C<gtk_widget_show()> call
in that it shows the popover with a transition. If you want to show
the popover without a transition, use C<gtk_widget_show()>.


  method gtk_popover_popup ( )


=end pod

sub gtk_popover_popup ( N-GObject $popover  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_popdown:
=begin pod
=head2 gtk_popover_popdown

Pops I<popover> down.This is different than a C<gtk_widget_hide()> call
in that it shows the popover with a transition. If you want to hide
the popover without a transition, use C<gtk_widget_hide()>.


  method gtk_popover_popdown ( )


=end pod

sub gtk_popover_popdown ( N-GObject $popover  )
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


=comment #TS:0:closed:
=head3 closed

This signal is emitted when the popover is dismissed either through
API or user interaction.


  method handler (
    ,
    *%user-options
  );


=end pod
