#TL:1:Gnome::Gtk3::Actionable:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Actionable

An interface for widgets that can be associated with actions


=head1 Description

This interface provides a convenient way of associating widgets with actions on a B<Gnome::Gtk3::ApplicationWindow> or B<Gnome::Gtk3::Application>.

It primarily consists of two properties: I<action-name> and I<action-target>. There are also some convenience APIs for setting these properties.

The action will be looked up in action groups that are found among the widgets ancestors. Most commonly, these will be the actions with the “win.” or “app.” prefix that are associated with the B<Gnome::Gtk3::ApplicationWindow> or B<Gnome::Gtk3::Application>, but other action groups that are added with C<gtk-widget-insert-action-group()> will be consulted as well.


=head1 Synopsis
=head2 Declaration

  unit role Gnome::Gtk3::Actionable;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

#-------------------------------------------------------------------------------
unit role Gnome::Gtk3::Actionable:auth<github:MARTIMM>:ver<0.1.0>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

#-------------------------------------------------------------------------------
#TM:1:get-action-name:
=begin pod
=head2 get-action-name

Gets the action name for I<actionable>.

See C<set-action-name()> for more information.

Returns: the action name, or C<undefined> if none is set

  method get-action-name ( --> Str )

=end pod

method get-action-name ( --> Str ) {

  gtk_actionable_get_action_name(
    self._f('GtkActionable'),
  );
}

sub gtk_actionable_get_action_name ( N-GObject $actionable --> gchar-ptr )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-action-target-value:
=begin pod
=head2 get-action-target-value

Gets the current target value of I<actionable>.

See C<set-action-target-value()> for more information.

Returns: the current target value

  method get-action-target-value ( --> N-GObject )


=end pod

method get-action-target-value ( --> N-GObject ) {

  gtk_actionable_get_action_target_value(
    self._f('GtkActionable'),
  );
}

sub gtk_actionable_get_action_target_value ( N-GObject $actionable --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-action-name:
=begin pod
=head2 set-action-name


Specifies the name of the action with which this widget should be
associated.  If I<action-name> is C<undefined> then the widget will be
unassociated from any previous action.

Usually this function is used when the widget is located (or will be
located) within the hierarchy of a B<Gnome::Gtk3::ApplicationWindow>.

Names are of the form “win.save” or “app.quit” for actions on the
containing B<Gnome::Gtk3::ApplicationWindow> or its associated B<Gnome::Gtk3::Application>,
respectively.  This is the same form used for actions in the B<GMenu>
associated with the window.



  method set-action-name ( Str $action_name )

=item Str $action_name; (nullable): an action name, or C<undefined>

=end pod

method set-action-name ( Str $action_name ) {

  gtk_actionable_set_action_name(
    self._f('GtkActionable'), $action_name
  );
}

sub gtk_actionable_set_action_name ( N-GObject $actionable, gchar-ptr $action_name  )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:0:set-action-target:
=begin pod
=head2 set-action-target

Sets the target of an actionable widget.

This is a convenience function that calls C<g-variant-new()> for I<format-string> and uses the result to call
C<set-action-target-value()>.

If you are setting a string-valued target and want to set the action
name at the same time, you can use
C<gtk-actionable-set-detailed-action-name()>.



  method set-action-target ( Str $format_string )

=item Str $format_string; a GVariant format string @...: arguments appropriate for I<format-string>

=end pod

method set-action-target ( Str $format_string ) {

  gtk_actionable_set_action_target(
    self._f('GtkActionable'), $format_string
  );
}

sub gtk_actionable_set_action_target ( N-GObject $actionable, gchar-ptr $format_string, Any $any = Any  )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:set-action-target-value:
=begin pod
=head2 set-action-target-value

Sets the target value of an actionable widget.

If I<$target-value> is C<undefined> then the target value is unset.

The target value has two purposes.  First, it is used as the parameter to activation of the action associated with the B<Gnome::Gtk3::Actionable> widget. Second, it is used to determine if the widget should be rendered as “active” — the widget is active if the state is equal to the given target.

Consider the example of associating a set of buttons with a B<N-GAction> with string state in a typical “radio button” situation.  Each button will be associated with the same action, but with a different target value for that action.  Clicking on a particular button will activate the action with the target of that button, which will typically cause the action’s state to change to that value.  Since the action’s state is now equal to the target value of the button, the button will now be rendered as active (and the other buttons, with different targets, rendered inactive).

  method set-action-target-value ( N-GObject $target_value )

=item N-GObject $target_value; a B<GVariant> to set as the target value, or C<undefined>

=end pod

method set-action-target-value ( $target_value ) {
  my $no = $target_value;
  $no .= _get-native-object-no-reffing unless $no ~~ N-GObject;

  gtk_actionable_set_action_target_value(
    self._f('GtkActionable'), $no
  );
}

sub gtk_actionable_set_action_target_value ( N-GObject $actionable, N-GObject $target_value  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-detailed-action-name:
=begin pod
=head2 set-detailed-action-name

Sets the action-name and associated string target value of an actionable widget.

I<$detailed-action-name> is a string in the format accepted by C<g-action-parse-detailed-name()>.

=comment (Note that prior to version 3.22.25, this function is only usable for actions with a simple "s" target, and I<detailed-action-name> must be of the form `"action::target"` where `action` is the action name and `target` is the string to use as the target.)

  method set-detailed-action-name ( Str $detailed_action_name )

=item Str $detailed_action_name; the detailed action name

=end pod

method set-detailed-action-name ( Str $detailed_action_name ) {

  gtk_actionable_set_detailed_action_name(
    self._f('GtkActionable'), $detailed_action_name
  );
}

sub gtk_actionable_set_detailed_action_name ( N-GObject $actionable, gchar-ptr $detailed_action_name  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:1:action-name:
=head3 Action name: action-name

The name of the associated action, like 'app.quit'
Default value: Any

The B<Gnome::GObject::Value> type of property I<action-name> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:action-target:
=head3 Action target value: action-target


The B<Gnome::GObject::Value> type of property I<action-target> is C<G_TYPE_VARIANT>.
=end pod
