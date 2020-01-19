#TL:1:Gnome::Gtk3::MenuButton:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::MenuButton

A widget that shows a popup when clicked on

![](images/menu-button.png)

=head1 Description

The B<Gnome::Gtk3::MenuButton> widget is used to display a popup when clicked on. This popup can be provided either as a B<Gnome::Gtk3::Menu>, a B<Gnome::Gtk3::Popover> or an abstract C<MenuModel>.

The B<Gnome::Gtk3::MenuButton> widget can hold any valid child widget. That is, it can hold almost any other standard B<Gnome::Gtk3::Widget>. The most commonly used child is B<Gnome::Gtk3::Image>. If no widget is explicitely added to the B<Gnome::Gtk3::MenuButton>, a B<Gnome::Gtk3::Image> is automatically created, using an arrow image oriented according to C<direction> or the generic "view-context-menu" icon if the direction is not set.

The positioning of the popup is determined by the C<direction>
property of the menu button.

For menus, the C<halign> and C<valign> properties of the
menu are also taken into account. For example, when the direction is
C<GTK_ARROW_DOWN> and the horizontal alignment is C<GTK_ALIGN_START>, the
menu will be positioned below the button, with the starting edge
(depending on the text direction) of the menu aligned with the starting
edge of the button. If there is not enough space below the button, the
menu is popped up above the button instead. If the alignment would move
part of the menu offscreen, it is “pushed in”.

=head2 Direction = Down

- halign = start

    ![](images/down-start.png)

- halign = center

    ![](images/down-center.png)

- halign = end

    ![](images/down-end.png)

=head2 Direction = Up

- halign = start

    ![](images/up-start.png)

- halign = center

    ![](images/up-center.png)

- halign = end

    ![](images/up-end.png)

=head2 Direction = Left

- valign = start

    ![](images/left-start.png)

- valign = center

    ![](images/left-center.png)

- valign = end

    ![](images/left-end.png)

=head2 Direction = Right

- valign = start

    ![](images/right-start.png)

- valign = center

    ![](images/right-center.png)

- valign = end

    ![](images/right-end.png)


=head2 Css Nodes


B<Gnome::Gtk3::MenuButton> has a single CSS node with name button. To differentiate it from a plain B<Gnome::Gtk3::Button>, it gets the .popup style class.

=head2 Known implementations
=comment item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)
=item Gnome::Gtk3::Actionable
=item Gnome::Gtk3::Activatable

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::MenuButton;
  also is Gnome::Gtk3::ToggleButton;
  also does Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::ToggleButton;
use Gnome::Gtk3::Enums;

use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::MenuButton:auth<github:MARTIMM>;
also is Gnome::Gtk3::ToggleButton;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
#my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:empty):
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
#  $signals-added = self.add-signal-types( $?CLASS.^name,
#    # ... :type<signame>
#  ) unless $signals-added;

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::MenuButton';

  # process all named arguments
  if ? %options<empty> {
    self.set-native-object(gtk_menu_button_new());
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

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkMenuButton');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_menu_button_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkMenuButton');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_button_new:
=begin pod
=head2 [gtk_] menu_button_new

Creates a new B<Gnome::Gtk3::MenuButton> widget with downwards-pointing
arrow as the only child. You can replace the child widget
with another B<Gnome::Gtk3::Widget> should you wish to.

Returns: The newly created B<Gnome::Gtk3::MenuButton> widget

Since: 3.6

  method gtk_menu_button_new ( --> N-GObject  )


=end pod

sub gtk_menu_button_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_button_set_popup:
=begin pod
=head2 [[gtk_] menu_button_] set_popup

Sets the B<Gnome::Gtk3::Menu> that will be popped up when the button is clicked,
or C<Any> to disable the button. If  I<menu-model> or
 I<popover> are set, they will be set to C<Any>.

Since: 3.6

  method gtk_menu_button_set_popup ( N-GObject $menu )

=item N-GObject $menu; (allow-none): a B<Gnome::Gtk3::Menu>

=end pod

sub gtk_menu_button_set_popup ( N-GObject $menu_button, N-GObject $menu )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_button_get_popup:
=begin pod
=head2 [[gtk_] menu_button_] get_popup

Returns the B<Gnome::Gtk3::Menu> that pops out of the button.
If the button does not use a B<Gnome::Gtk3::Menu>, this function
returns C<Any>.

Returns: (nullable) (transfer none): a B<Gnome::Gtk3::Menu> or C<Any>

Since: 3.6

  method gtk_menu_button_get_popup ( --> N-GObject  )


=end pod

sub gtk_menu_button_get_popup ( N-GObject $menu_button )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_button_set_popover:
=begin pod
=head2 [[gtk_] menu_button_] set_popover

Sets the B<Gnome::Gtk3::Popover> that will be popped up when the button is
clicked, or C<Any> to disable the button. If  I<menu-model>
or  I<popup> are set, they will be set to C<Any>.

Since: 3.12

  method gtk_menu_button_set_popover ( N-GObject $popover )

=item N-GObject $popover; (allow-none): a B<Gnome::Gtk3::Popover>

=end pod

sub gtk_menu_button_set_popover ( N-GObject $menu_button, N-GObject $popover )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_button_get_popover:
=begin pod
=head2 [[gtk_] menu_button_] get_popover

Returns the B<Gnome::Gtk3::Popover> that pops out of the button.
If the button is not using a B<Gnome::Gtk3::Popover>, this function
returns C<Any>.

Returns: (nullable) (transfer none): a B<Gnome::Gtk3::Popover> or C<Any>

Since: 3.12

  method gtk_menu_button_get_popover ( --> N-GObject  )


=end pod

sub gtk_menu_button_get_popover ( N-GObject $menu_button )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_menu_button_set_direction:
=begin pod
=head2 [[gtk_] menu_button_] set_direction

Sets the direction in which the popup will be popped up, as
well as changing the arrow’s direction. The child will not
be changed to an arrow if it was customized.

If the does not fit in the available space in the given direction,
GTK+ will its best to keep it inside the screen and fully visible.

If you pass C<GTK_ARROW_NONE> for a I<direction>, the popup will behave
as if you passed C<GTK_ARROW_DOWN> (although you won’t see any arrows).

Since: 3.6

  method gtk_menu_button_set_direction ( GtkArrowType $direction )

=item GtkArrowType $direction; a B<Gnome::Gtk3::ArrowType>

=end pod

sub gtk_menu_button_set_direction ( N-GObject $menu_button, int32 $direction )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_menu_button_get_direction:
=begin pod
=head2 [[gtk_] menu_button_] get_direction

Returns the direction the popup will be pointing at when popped up.

Returns: a B<Gnome::Gtk3::ArrowType> value

Since: 3.6

  method gtk_menu_button_get_direction ( --> GtkArrowType  )


=end pod

sub gtk_menu_button_get_direction ( N-GObject $menu_button )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_button_set_menu_model:
=begin pod
=head2 [[gtk_] menu_button_] set_menu_model

Sets the B<GMenuModel> from which the popup will be constructed,
or C<Any> to disable the button.

Depending on the value of  I<use-popover>, either a
B<Gnome::Gtk3::Menu> will be created with C<gtk_menu_new_from_model()>, or a
B<Gnome::Gtk3::Popover> with C<gtk_popover_new_from_model()>. In either case,
actions will be connected as documented for these functions.

If  I<popup> or  I<popover> are already set,
their content will be lost and replaced by the newly created popup.

Since: 3.6

  method gtk_menu_button_set_menu_model ( N-GObject $menu_model )

=item N-GObject $menu_model; (allow-none): a B<GMenuModel>

=end pod

sub gtk_menu_button_set_menu_model ( N-GObject $menu_button, N-GObject $menu_model )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_button_get_menu_model:
=begin pod
=head2 [[gtk_] menu_button_] get_menu_model

Returns the B<GMenuModel> used to generate the popup.

Returns: (nullable) (transfer none): a B<GMenuModel> or C<Any>

Since: 3.6

  method gtk_menu_button_get_menu_model ( --> N-GObject  )


=end pod

sub gtk_menu_button_get_menu_model ( N-GObject $menu_button )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_button_set_align_widget:
=begin pod
=head2 [[gtk_] menu_button_] set_align_widget

Sets the B<Gnome::Gtk3::Widget> to use to line the menu with when popped up.
Note that the I<align_widget> must contain the B<Gnome::Gtk3::MenuButton> itself.

Setting it to C<Any> means that the menu will be aligned with the
button itself.

Note that this property is only used with menus currently,
and not for popovers.

Since: 3.6

  method gtk_menu_button_set_align_widget ( N-GObject $align_widget )

=item N-GObject $align_widget; (allow-none): a B<Gnome::Gtk3::Widget>

=end pod

sub gtk_menu_button_set_align_widget ( N-GObject $menu_button, N-GObject $align_widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_button_get_align_widget:
=begin pod
=head2 [[gtk_] menu_button_] get_align_widget

Returns the parent B<Gnome::Gtk3::Widget> to use to line up with menu.

Returns: (nullable) (transfer none): a B<Gnome::Gtk3::Widget> value or C<Any>

Since: 3.6

  method gtk_menu_button_get_align_widget ( --> N-GObject  )


=end pod

sub gtk_menu_button_get_align_widget ( N-GObject $menu_button )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_button_set_use_popover:
=begin pod
=head2 [[gtk_] menu_button_] set_use_popover

Sets whether to construct a B<Gnome::Gtk3::Popover> instead of B<Gnome::Gtk3::Menu>
when C<gtk_menu_button_set_menu_model()> is called. Note that
this property is only consulted when a new menu model is set.

Since: 3.12

  method gtk_menu_button_set_use_popover ( Int $use_popover )

=item Int $use_popover; C<1> to construct a popover from the menu model

=end pod

sub gtk_menu_button_set_use_popover ( N-GObject $menu_button, int32 $use_popover )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_button_get_use_popover:
=begin pod
=head2 [[gtk_] menu_button_] get_use_popover

Returns whether a B<Gnome::Gtk3::Popover> or a B<Gnome::Gtk3::Menu> will be constructed
from the menu model.

Returns: C<1> if using a B<Gnome::Gtk3::Popover>

Since: 3.12

  method gtk_menu_button_get_use_popover ( --> Int  )


=end pod

sub gtk_menu_button_get_use_popover ( N-GObject $menu_button )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:popup:
=head3 Popup


The B<Gnome::Gtk3::Menu> that will be popped up when the button is clicked.
Since: 3.6
Widget type: GTK_TYPE_MENU

The B<Gnome::GObject::Value> type of property I<popup> is C<G_TYPE_OBJECT>.

=comment #TP:0:menu-model:
=head3 Menu model


The B<GMenuModel> from which the popup will be created.
Depending on the  I<use-popover> property, that may
be a menu or a popover.
See C<gtk_menu_button_set_menu_model()> for the interaction with the
 I<popup> property.
Since: 3.6
Widget type: G_TYPE_MENU_MODEL

The B<Gnome::GObject::Value> type of property I<menu-model> is C<G_TYPE_OBJECT>.

=comment #TP:0:align-widget:
=head3 Align with


The B<Gnome::Gtk3::Widget> to use to align the menu with.
Since: 3.6
Widget type: GTK_TYPE_CONTAINER

The B<Gnome::GObject::Value> type of property I<align-widget> is C<G_TYPE_OBJECT>.

=comment #TP:0:direction:
=head3 Direction


The B<Gnome::Gtk3::ArrowType> representing the direction in which the
menu or popover will be popped out.
Since: 3.6
Widget type: GTK_TYPE_ARROW_TYPE

The B<Gnome::GObject::Value> type of property I<direction> is C<G_TYPE_ENUM>.

=comment #TP:0:use-popover:
=head3 Use a popover


Whether to construct a B<Gnome::Gtk3::Popover> from the menu model,
or a B<Gnome::Gtk3::Menu>.
Since: 3.12

The B<Gnome::GObject::Value> type of property I<use-popover> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:popover:
=head3 Popover


The B<Gnome::Gtk3::Popover> that will be popped up when the button is clicked.
Since: 3.12
Widget type: GTK_TYPE_POPOVER

The B<Gnome::GObject::Value> type of property I<popover> is C<G_TYPE_OBJECT>.
=end pod















=finish
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_] menu_button_new

Creates a new B<Gnome::Gtk3::MenuButton> widget with downwards-pointing arrow as the only child. You can replace the child widget with another B<Gnome::Gtk3::Widget> should you wish to.

  method gtk_menu_button_new ( --> N-GObject  )


Returns N-GObject; The newly created B<Gnome::Gtk3::MenuButton> widget
=end pod

sub gtk_menu_button_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_button_] set_popup

Sets the B<Gnome::Gtk3::Menu> that will be popped up when the button is clicked, or C<Any> to disable the button. If C<menu>-model or C<popover> are set, they will be set to C<Any>.

  method gtk_menu_button_set_popup ( N-GObject $menu )

=item N-GObject $menu; (allow-none): a B<Gnome::Gtk3::Menu>

=end pod

sub gtk_menu_button_set_popup ( N-GObject $menu_button, N-GObject $menu )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_button_] get_popup

Returns the B<Gnome::Gtk3::Menu> that pops out of the button. If the button does not use a B<Gnome::Gtk3::Menu>, this function returns C<Any>.

  method gtk_menu_button_get_popup ( --> N-GObject  )


Returns N-GObject; (nullable) (transfer none): a B<Gnome::Gtk3::Menu> or C<Any>
=end pod

sub gtk_menu_button_get_popup ( N-GObject $menu_button )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_button_] set_popover

Sets the B<Gnome::Gtk3::Popover> that will be popped up when the button is clicked, or C<Any> to disable the button. If C<menu>-model or C<popup> are set, they will be set to C<Any>.

  method gtk_menu_button_set_popover ( N-GObject $popover )

=item N-GObject $popover; (allow-none): a B<Gnome::Gtk3::Popover>

=end pod

sub gtk_menu_button_set_popover ( N-GObject $menu_button, N-GObject $popover )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_button_] get_popover

Returns the B<Gnome::Gtk3::Popover> that pops out of the button. If the button is not using a B<Gnome::Gtk3::Popover>, this function returns C<Any>.

  method gtk_menu_button_get_popover ( --> N-GObject  )


Returns N-GObject; (nullable) (transfer none): a B<Gnome::Gtk3::Popover> or C<Any>
=end pod

sub gtk_menu_button_get_popover ( N-GObject $menu_button )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_button_] set_direction

Sets the direction in which the popup will be popped up, as well as changing the arrow’s direction. The child will not be changed to an arrow if it was customized.

  method gtk_menu_button_set_direction ( GtkArrowType $direction )

=item GtkArrowType $direction; a B<Gnome::Gtk3::ArrowType>

=end pod

sub gtk_menu_button_set_direction ( N-GObject $menu_button, int32 $direction )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_button_] get_direction

Returns the direction the popup will be pointing at when popped up.

  method gtk_menu_button_get_direction ( --> GtkArrowType  )


Returns GtkArrowType; a B<Gnome::Gtk3::ArrowType> value
=end pod

sub gtk_menu_button_get_direction ( N-GObject $menu_button )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#`{{
=begin pod
=head2 [[gtk_] menu_button_] set_menu_model

Sets the C<GMenuModel> from which the popup will be constructed, or C<Any> to disable the button.

  method gtk_menu_button_set_menu_model ( GMenuModel $menu_model )

=item GMenuModel $menu_model; (allow-none): a C<GMenuModel>

=end pod

sub gtk_menu_button_set_menu_model ( N-GObject $menu_button, GMenuModel $menu_model )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_button_] get_menu_model

Returns the C<GMenuModel> used to generate the popup.

  method gtk_menu_button_get_menu_model ( --> GMenuModel  )


Returns GMenuModel; (nullable) (transfer none): a C<GMenuModel> or C<Any>
=end pod

sub gtk_menu_button_get_menu_model ( N-GObject $menu_button )
  returns GMenuModel
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_button_] set_align_widget

Sets the B<Gnome::Gtk3::Widget> to use to line the menu with when popped up. Note that the I<align_widget> must contain the B<Gnome::Gtk3::MenuButton> itself.

  method gtk_menu_button_set_align_widget ( N-GObject $align_widget )

=item N-GObject $align_widget; (allow-none): a B<Gnome::Gtk3::Widget>

=end pod

sub gtk_menu_button_set_align_widget ( N-GObject $menu_button, N-GObject $align_widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_button_] get_align_widget

Returns the parent B<Gnome::Gtk3::Widget> to use to line up with menu.

  method gtk_menu_button_get_align_widget ( --> N-GObject  )


Returns N-GObject; (nullable) (transfer none): a B<Gnome::Gtk3::Widget> value or C<Any>
=end pod

sub gtk_menu_button_get_align_widget ( N-GObject $menu_button )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_button_] set_use_popover

Sets whether to construct a B<Gnome::Gtk3::Popover> instead of B<Gnome::Gtk3::Menu> when C<gtk_menu_button_set_menu_model()> is called. Note that this property is only consulted when a new menu model is set.

  method gtk_menu_button_set_use_popover ( Int $use_popover )

=item Int $use_popover; C<1> to construct a popover from the menu model

=end pod

sub gtk_menu_button_set_use_popover ( N-GObject $menu_button, int32 $use_popover )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_button_] get_use_popover

Returns whether a B<Gnome::Gtk3::Popover> or a B<Gnome::Gtk3::Menu> will be constructed from the menu model.

  method gtk_menu_button_get_use_popover ( --> Int  )


Returns Int; C<1> if using a B<Gnome::Gtk3::Popover>
=end pod

sub gtk_menu_button_get_use_popover ( N-GObject $menu_button )
  returns int32
  is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=head3 direction

The B<Gnome::GObject::Value> type of property I<direction> is C<G_TYPE_ENUM>.

The B<Gnome::Gtk3::ArrowType> representing the direction in which the
menu or popover will be popped out.

=head3 use-popover

The B<Gnome::GObject::Value> type of property I<use-popover> is C<G_TYPE_BOOLEAN>.

Whether to construct a B<Gnome::Gtk3::Popover> from the menu model,
or a B<Gnome::Gtk3::Menu>.



=begin comment

=head2 Unsupported properties

=end comment

=head2 Not yet supported properties


=head3 popup

The B<Gnome::GObject::Value> type of property I<popup> is C<G_TYPE_OBJECT>.

The B<Gnome::Gtk3::Menu> that will be popped up when the button is clicked.

=head3 menu-model

The B<Gnome::GObject::Value> type of property I<menu-model> is C<G_TYPE_OBJECT>.

The C<GMenuModel> from which the popup will be created.
Depending on the C<use>-popover property, that may
be a menu or a popover.

See C<gtk_menu_button_set_menu_model()> for the interaction with the
C<popup> property.

=head3 align-widget

The B<Gnome::GObject::Value> type of property I<align-widget> is C<G_TYPE_OBJECT>.

The B<Gnome::Gtk3::Widget> to use to align the menu with.

=head3 popover

The B<Gnome::GObject::Value> type of property I<popover> is C<G_TYPE_OBJECT>.

The B<Gnome::Gtk3::Popover> that will be popped up when the button is clicked.

=end pod
