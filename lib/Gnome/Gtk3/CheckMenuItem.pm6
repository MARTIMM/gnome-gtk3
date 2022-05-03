#TL:1:Gnome::Gtk3::CheckMenuItem:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CheckMenuItem

A menu item with a check box

=comment ![](images/X.png)

=head1 Description


A B<Gnome::Gtk3::CheckMenuItem> is a menu item that maintains the state of a boolean value in addition to a B<Gnome::Gtk3::MenuItem> usual role in activating application code.

A check box indicating the state of the boolean value is displayed at the left side of the B<Gnome::Gtk3::MenuItem>. Activating the B<Gnome::Gtk3::MenuItem> toggles the value.


=head2 Css Nodes

  menuitem
  ├── check.left
  ╰── <child>

B<Gnome::Gtk3::CheckMenuItem> has a main CSS node with name menuitem, and a subnode with name check, which gets the .left or .right style class.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CheckMenuItem;
  also is Gnome::Gtk3::MenuItem;


=head2 Uml Diagram

![](plantuml/CheckMenuItem.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::CheckMenuItem;

  unit class MyGuiClass;
  also is Gnome::Gtk3::CheckMenuItem;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::CheckMenuItem class process the options
    self.bless( :GtkCheckMenuItem, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::Gtk3::MenuItem;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::CheckMenuItem:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::Gtk3::MenuItem;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new CheckMenuItem object.

  multi method new ( )

=head3 :label

Creates a new B<Gnome::Gtk3::CheckMenuItem> with a label.

  multi method new ( Str :$label! )

=head3 :mnemonic

Creates a new B<Gnome::Gtk3::CheckMenuItem> containing a label. The label will be created using the C<:mnemonic> option to the C<.new()> call of B<Gnome::Gtk3::Label>, so underscores in I<label> indicate the mnemonic for the menu item.

  multi method new ( Str :$mnemonic! )

=head3 :native-object

Create a CheckMenuItem object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a CheckMenuItem object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new():
#TM:1:new(:label):
#TM:1:new(:mnemonic):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<toggled>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::CheckMenuItem' or %options<GtkCheckMenuItem> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;
      if ? %options<label> {
        $no = _gtk_check_menu_item_new_with_label(%options<label>);
      }

      elsif ? %options<mnemonic> {
        $no = _gtk_check_menu_item_new_with_mnemonic(%options<mnemonic>);
      }

      #`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      }}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_check_menu_item_new();
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkCheckMenuItem');
  }
}

#`{{
#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_check_menu_item_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkCheckMenuItem');
  $s = callsame unless ?$s;

  $s;
}
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_check_menu_item_new:
#`{{
=begin pod
=head2 _gtk_check_menu_item_new

Creates a new B<Gnome::Gtk3::CheckMenuItem>.

Returns: a new B<Gnome::Gtk3::CheckMenuItem>.

  method _gtk_check_menu_item_new ( --> N-GObject )


=end pod
}}

sub _gtk_check_menu_item_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_check_menu_item_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_check_menu_item_new_with_label:
#`{{
=begin pod
=head2 _gtk_check_menu_item_new_with_label

Creates a new B<Gnome::Gtk3::CheckMenuItem> with a label.

Returns: a new B<Gnome::Gtk3::CheckMenuItem>.

  method _gtk_check_menu_item_new_with_label (  Str  $label --> N-GObject )

=item  Str  $label; the string to use for the label.

=end pod
}}

sub _gtk_check_menu_item_new_with_label ( gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_check_menu_item_new_with_label')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_check_menu_item_new_with_mnemonic:
#`{{
=begin pod
=head2 _gtk_check_menu_item_new_with_mnemonic

Creates a new B<Gnome::Gtk3::CheckMenuItem> containing a label. The label will be created using C<gtk_label_new_with_mnemonic()>, so underscores in I<label> indicate the mnemonic for the menu item.

Returns: a new B<Gnome::Gtk3::CheckMenuItem>

  method _gtk_check_menu_item_new_with_mnemonic (  Str  $label --> N-GObject )

=item  Str  $label; The text of the button, with an underscore in front of the character

=end pod
}}

sub _gtk_check_menu_item_new_with_mnemonic ( gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_check_menu_item_new_with_mnemonic')
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-active:
=begin pod
=head2 set-active

Sets the active state of the menu item’s check box.

  method set-active ( Bool $is_active )

=item Bool $is_active; boolean value indicating whether the check box is active.

=end pod

method set-active ( Bool $is_active ) {

  gtk_check_menu_item_set_active(
    self._f('GtkCheckMenuItem'), $is_active.Int
  );
}

sub gtk_check_menu_item_set_active ( N-GObject $check_menu_item, gboolean $is_active  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-active:
=begin pod
=head2 get-active

Returns whether the check menu item is active. See C<.set-active()>.

Returns: C<True> if the menu item is checked.

  method get-active ( --> Bool )

=end pod

method get-active ( --> Bool ) {

  gtk_check_menu_item_get_active(
    self._f('GtkCheckMenuItem'),
  ).Bool;
}

sub gtk_check_menu_item_get_active ( N-GObject $check_menu_item --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:toggled:
=begin pod
=head2 toggled

Emits the  I<toggled> signal.

  method toggled ( )

=end pod

method toggled ( ) {

  gtk_check_menu_item_toggled(
    self._f('GtkCheckMenuItem'),
  );
}

sub gtk_check_menu_item_toggled ( N-GObject $check_menu_item  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-inconsistent:
=begin pod
=head2 set-inconsistent

If the user has selected a range of elements (such as some text or spreadsheet cells) that are affected by a boolean setting, and the current values in that range are inconsistent, you may want to display the check in an “in between” state. This function turns on “in between” display.  Normally you would turn off the inconsistent state again if the user explicitly selects a setting. This has to be done manually, C<gtk_check_menu_item_set_inconsistent()> only affects visual appearance, it doesn’t affect the semantics of the widget.

  method set-inconsistent ( Bool $setting )

=item Bool $setting; C<True> to display an “inconsistent” third state check

=end pod

method set-inconsistent ( Bool $setting ) {

  gtk_check_menu_item_set_inconsistent(
    self._f('GtkCheckMenuItem'), $setting
  );
}

sub gtk_check_menu_item_set_inconsistent ( N-GObject $check_menu_item, gboolean $setting  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-inconsistent:
=begin pod
=head2 get-inconsistent

Retrieves the value set by C<gtk_check_menu_item_set_inconsistent()>.

Returns: C<1> if inconsistent

  method get-inconsistent ( --> Bool )

=end pod

method get-inconsistent ( --> Bool ) {

  gtk_check_menu_item_get_inconsistent(
    self._f('GtkCheckMenuItem'),
  ).Bool;
}

sub gtk_check_menu_item_get_inconsistent ( N-GObject $check_menu_item --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-draw-as-radio:
=begin pod
=head2 set-draw-as-radio

Sets whether I<check_menu_item> is drawn like a B<Gnome::Gtk3::RadioMenuItem>

  method set-draw-as-radio ( Bool $draw_as_radio )

=item Bool $draw_as_radio; whether I<check_menu_item> is drawn like a B<Gnome::Gtk3::RadioMenuItem>

=end pod

method set-draw-as-radio ( Bool $draw_as_radio ) {

  gtk_check_menu_item_set_draw_as_radio(
    self._f('GtkCheckMenuItem'), $draw_as_radio
  );
}

sub gtk_check_menu_item_set_draw_as_radio ( N-GObject $check_menu_item, gboolean $draw_as_radio  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-draw-as-radio:
=begin pod
=head2 get-draw-as-radio

Returns whether I<check_menu_item> looks like a B<Gnome::Gtk3::RadioMenuItem>

  method get-draw-as-radio ( --> Bool )

=end pod

method get-draw-as-radio ( --> Bool ) {

  gtk_check_menu_item_get_draw_as_radio(
    self._f('GtkCheckMenuItem'),
  ).Bool;
}

sub gtk_check_menu_item_get_draw_as_radio ( N-GObject $check_menu_item --> gboolean )
  is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

=comment -----------------------------------------------------------------------
=comment #TS:1:toggled:
=head2 toggled

This signal is emitted when the state of the check box is changed.

A signal handler can use C<get_active()>
to discover the new state.

  method handler (
    Gnome::Gtk3::CheckMenuItem :_widget($checkmenuitem),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $checkmenuitem; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:1:active:
=head2 active

Whether the menu item is checked

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:draw-as-radio:
=head2 draw-as-radio

Whether the menu item looks like a radio menu item

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:inconsistent:
=head2 inconsistent

Whether to display an \inconsistent\ state

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.

=end pod






















=finish
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


=comment #TS:1:toggled:
=head3 toggled

This signal is emitted when the state of the check box is changed.

A signal handler can use C<gtk_check_menu_item_get_active()>
to discover the new state.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($checkmenuitem),
    *%user-options
  );

=item $checkmenuitem; the object which received the signal.

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

=comment #TP:1:active:
=head3 Active

Whether the menu item is checked
Default value: False

The B<Gnome::GObject::Value> type of property I<active> is C<G_TYPE_BOOLEAN>.

=comment #TP:1:inconsistent:
=head3 Inconsistent

Whether to display an \inconsistent\ state
Default value: False

The B<Gnome::GObject::Value> type of property I<inconsistent> is C<G_TYPE_BOOLEAN>.

=comment #TP:1:draw-as-radio:
=head3 Draw as radio menu item

Whether the menu item looks like a radio menu item
Default value: False

The B<Gnome::GObject::Value> type of property I<draw-as-radio> is C<G_TYPE_BOOLEAN>.
=end pod
