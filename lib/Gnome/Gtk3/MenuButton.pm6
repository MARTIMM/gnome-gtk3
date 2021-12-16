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

The positioning of the popup is determined by the C<direction> property of the menu button.

For menus, the C<halign> and C<valign> properties of the menu are also taken into account. For example, when the direction is C<GTK_ARROW_DOWN> and the horizontal alignment is C<GTK_ALIGN_START>, the menu will be positioned below the button, with the starting edge (depending on the text direction) of the menu aligned with the starting edge of the button. If there is not enough space below the button, the menu is popped up above the button instead. If the alignment would move part of the menu offscreen, it is “pushed in”.

=head2 Direction = Down

=item halign = start

    ![](images/down-start.png)

=item halign = center

    ![](images/down-center.png)

=item halign = end

    ![](images/down-end.png)

=head2 Direction = Up

=item halign = start

    ![](images/up-start.png)

=item halign = center

    ![](images/up-center.png)

=item halign = end

    ![](images/up-end.png)

=head2 Direction = Left

=item valign = start

    ![](images/left-start.png)

=item valign = center

    ![](images/left-center.png)

=item valign = end

    ![](images/left-end.png)

=head2 Direction = Right

=item valign = start

    ![](images/right-start.png)

=item valign = center

    ![](images/right-center.png)

=item valign = end

    ![](images/right-end.png)


=head2 Css Nodes

B<Gnome::Gtk3::MenuButton> has a single CSS node with name button. To differentiate it from a plain B<Gnome::Gtk3::Button>, it gets the .popup style class.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::MenuButton;
  also is Gnome::Gtk3::ToggleButton;


=head2 Uml Diagram

![](plantuml/MenuButton.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::MenuButton;

  unit class MyGuiClass;
  also is Gnome::Gtk3::MenuButton;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::MenuButton class process the options
    self.bless( :GtkMenuButton, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=begin comment
=head2 Example

Setting up a simple popup menu on a button placed on an ApplicationWindow $window. The entries are still inactive because actions must be defined and added to the window. See for examples the L<application tutorial|/gnome-gtk3/content-docs/tutorial/Application/introduction.html>.

  # make menu button and place in window
  my Gnome::Gtk3::MenuButton $menu-button .= new;
  $window.add($menu-button);
  $menu-button.set-direction(GTK_ARROW_RIGHT);
  $menu-button.set-valign(GTK_ALIGN_CENTER);

  # Make a section menu with 2 items in it; Toolbar and Statusbar
  my Gnome::Gio::Menu $section .= new;
  $section.append( 'Toolbar', 'app.set-toolbar');
  $section.append( 'Statusbar', 'app.set-statusbar');

  # make the top menu and append 1st section made above
  my Gnome::Gio::Menu $menu .= new;
  $menu.append-item(Gnome::Gio::MenuItem.new(:section($section)));
  $section.clear-object;

  $menu-button.set-menu-model($menu);

=end comment


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Gio::MenuModel;

use Gnome::Gtk3::ToggleButton;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Popover;
use Gnome::Gtk3::Menu;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::MenuButton:auth<github:MARTIMM>:ver<0.2.0>;
also is Gnome::Gtk3::ToggleButton;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Creates a new B<Gnome::Gtk3::MenuButton> widget with downwards-pointing arrow as the only child. You can replace the child widget with another B<Gnome::Gtk3::Widget> should you wish to.

  multi method new ( )


=head3 :native-object

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )


=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
#  $signals-added = self.add-signal-types( $?CLASS.^name,
#    # ... :type<signame>
#  ) unless $signals-added;

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::MenuButton' or %options<GtkMenuButton> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_menu_button_new___x___($no);
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
        $no = _gtk_menu_button_new();
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkMenuButton');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_menu_button_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkMenuButton');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:1:get-align-widget:
=begin pod
=head2 get-align-widget

Returns the parent widget to use to line up with menu.

Returns: a B<Gnome::Gtk3::Widget> value or C<undefined>

  method get-align-widget ( --> N-GObject )

=end pod

method get-align-widget ( --> N-GObject ) {
  gtk_menu_button_get_align_widget(self._get-native-object-no-reffing)
}

sub gtk_menu_button_get_align_widget (
  N-GObject $menu_button --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-direction:
=begin pod
=head2 get-direction

Returns the direction the popup will be pointing at when popped up.

Returns: a B<Gnome::Gtk3::ArrowType> value

  method get-direction ( --> GtkArrowType )

=end pod

method get-direction ( --> GtkArrowType ) {
  GtkArrowType(
    gtk_menu_button_get_direction(self._get-native-object-no-reffing)
  )
}

sub gtk_menu_button_get_direction (
  N-GObject $menu_button --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-menu-model:
=begin pod
=head2 get-menu-model

Returns the B<Gnome::Gio::MenuModel> used to generate the popup.

Returns: a B<Gnome::Gio::MenuModel> or an C<invalid> object.

  method get-menu-model ( --> Gnome::Gio::MenuModel )

=end pod

method get-menu-model ( --> Gnome::Gio::MenuModel ) {
  Gnome::Gio::MenuModel.new(
    :native-object(
      gtk_menu_button_get_menu_model(self._get-native-object-no-reffing)
    )
  )
}

sub gtk_menu_button_get_menu_model (
  N-GObject $menu_button --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-popover:
=begin pod
=head2 get-popover

Returns the B<Gnome::Gtk3::Popover> that pops out of the button. If the button is not using a B<Gnome::Gtk3::Popover>, this function returns an invalid popover object.

  method get-popover ( --> Gnome::Gtk3::Popover )

=end pod

method get-popover ( --> Gnome::Gtk3::Popover ) {
  Gnome::Gtk3::Popover.new(
    :native-object(
      gtk_menu_button_get_popover(self._get-native-object-no-reffing)
    )
  )
}

sub gtk_menu_button_get_popover (
  N-GObject $menu_button --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-popup:
=begin pod
=head2 get-popup

Returns the B<Gnome::Gtk3::Menu> that pops out of the button. If the button does not use a B<Gnome::Gtk3::Menu>, this function returns an invalid menu object.

  method get-popup ( --> Gnome::Gtk3::Menu )

=end pod

method get-popup ( --> Gnome::Gtk3::Menu ) {
  Gnome::Gtk3::Menu.new(
    :native-object(
      gtk_menu_button_get_popup(self._get-native-object-no-reffing)
    )
  )
}

sub gtk_menu_button_get_popup (
  N-GObject $menu_button --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-use-popover:
=begin pod
=head2 get-use-popover

Returns whether a B<Gnome::Gtk3::Popover> or a B<Gnome::Gtk3::Menu> will be constructed from the menu model.

Returns: C<True> if using a B<Gnome::Gtk3::Popover>

  method get-use-popover ( --> Bool )

=end pod

method get-use-popover ( --> Bool ) {
  gtk_menu_button_get_use_popover(self._get-native-object-no-reffing).Bool
}

sub gtk_menu_button_get_use_popover (
  N-GObject $menu_button --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-align-widget:
=begin pod
=head2 set-align-widget

Sets the B<Gnome::Gtk3::Widget> to use to line the menu with when popped up. Note that the I<$align-widget> must contain the B<Gnome::Gtk3::MenuButton> itself.

Setting it to C<undefined> means that the menu will be aligned with the button itself.

Note that this property is only used with menus currently, and not for popovers.

  method set-align-widget ( N-GObject $align_widget )

=item N-GObject $align_widget; a B<Gnome::Gtk3::Widget>

=end pod

method set-align-widget ( $align_widget is copy ) {
  $align_widget .= _get-native-object-no-reffing
    unless $align_widget ~~ N-GObject;

  gtk_menu_button_set_align_widget(
    self._get-native-object-no-reffing, $align_widget
  );
}

sub gtk_menu_button_set_align_widget (
  N-GObject $menu_button, N-GObject $align_widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-direction:
=begin pod
=head2 set-direction

Sets the direction in which the popup will be popped up, as well as changing the arrow’s direction. The child will not be changed to an arrow if it was customized.

If the does not fit in the available space in the given direction, GTK+ will its best to keep it inside the screen and fully visible.

If you pass C<GTK-ARROW-NONE> for a I<$direction>, the popup will behave as if you passed C<GTK-ARROW-DOWN> (although you won’t see any arrows).

  method set-direction ( GtkArrowType $direction )

=item GtkArrowType $direction; a B<Gnome::Gtk3::ArrowType>

=end pod

method set-direction ( GtkArrowType $direction ) {
  gtk_menu_button_set_direction( self._get-native-object-no-reffing, $direction);
}

sub gtk_menu_button_set_direction (
  N-GObject $menu_button, GEnum $direction
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-menu-model:
=begin pod
=head2 set-menu-model

Sets the B<Gnome::Gtk3::MenuModel> from which the popup will be constructed, or C<undefined> to dissociate any existing menu model and disable the button.

Depending on the value of  I<use-popover>, either a B<Gnome::Gtk3::Menu> will be created, or a B<Gnome::Gtk3::Popover>. In either case, actions will be connected as documented for these functions.

If  I<popup> or I<popover> are already set, those widgets are dissociated from the I<menu-button>, and those properties are set to C<undefined>.

  method set-menu-model ( N-GObject $menu_model )

=item N-GObject $menu_model; a B<Gnome::Gtk3::MenuModel>, or C<undefined> to unset and disable the button

=end pod

method set-menu-model ( $menu_model is copy ) {
  $menu_model .= _get-native-object-no-reffing unless $menu_model ~~ N-GObject;
  gtk_menu_button_set_menu_model(
    self._get-native-object-no-reffing, $menu_model
  );
}

sub gtk_menu_button_set_menu_model (
  N-GObject $menu_button, N-GObject $menu_model
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-popover:
=begin pod
=head2 set-popover

Sets the B<Gnome::Gtk3::Popover> that will be popped up when the I<menu-button> is clicked, or C<undefined> to dissociate any existing popover and disable the button.

If  I<menu-model> or  I<popup> are set, those objects are dissociated from the I<menu-button>, and those properties are set to C<undefined>.

  method set-popover ( N-GObject $popover )

=item N-GObject $popover; a B<Gnome::Gtk3::Popover>, or C<undefined> to unset and disable the button

=end pod

method set-popover ( $popover is copy ) {
  $popover .= _get-native-object-no-reffing unless $popover ~~ N-GObject;

  gtk_menu_button_set_popover(
    self._get-native-object-no-reffing, $popover
  );
}

sub gtk_menu_button_set_popover (
  N-GObject $menu_button, N-GObject $popover
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-popup:
=begin pod
=head2 set-popup

Sets the B<Gnome::Gtk3::Menu> that will be popped up when the I<menu-button> is clicked, or C<undefined> to dissociate any existing menu and disable the button.

If  I<menu-model> or  I<popover> are set, those objects are dissociated from the I<menu-button>, and those properties are set to C<undefined>.

  method set-popup ( N-GObject $menu )

=item N-GObject $menu; a B<Gnome::Gtk3::Menu>, or C<undefined> to unset and disable the button

=end pod

method set-popup ( $menu is copy ) {
  $menu .= _get-native-object-no-reffing unless $menu ~~ N-GObject;

  gtk_menu_button_set_popup(
    self._get-native-object-no-reffing, $menu
  );
}

sub gtk_menu_button_set_popup (
  N-GObject $menu_button, N-GObject $menu
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-use-popover:
=begin pod
=head2 set-use-popover

Sets whether to construct a B<Gnome::Gtk3::Popover> instead of B<Gnome::Gtk3::Menu> when C<set-menu-model()> is called. Note that this property is only consulted when a new menu model is set.

  method set-use-popover ( Bool $use_popover )

=item Bool $use_popover; C<True> to construct a popover from the menu model

=end pod

method set-use-popover ( Bool $use_popover ) {

  gtk_menu_button_set_use_popover(
    self._get-native-object-no-reffing, $use_popover
  );
}

sub gtk_menu_button_set_use_popover (
  N-GObject $menu_button, gboolean $use_popover
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_menu_button_new:
#`{{
=begin pod
=head2 _gtk_menu_button_new

Creates a new B<Gnome::Gtk3::MenuButton> widget with downwards-pointing arrow as the only child. You can replace the child widget with another B<Gnome::Gtk3::Widget> should you wish to.

Returns: The newly created B<Gnome::Gtk3::MenuButton> widget

  method _gtk_menu_button_new ( --> N-GObject )

=end pod
}}

sub _gtk_menu_button_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_menu_button_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:0:align-widget:
=head3 Align with: align-widget

The B<Gnome::Gtk3::Widget> to use to align the menu with.

   Widget type: GTK_TYPE_CONTAINER

The B<Gnome::GObject::Value> type of property I<align-widget> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:direction:
=head3 Direction: direction

The GtkArrowType representing the direction in which the menu or popover will be popped out.

   Widget type: GTK_TYPE_ARROW_TYPE

The B<Gnome::GObject::Value> type of property I<direction> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:0:menu-model:
=head3 Menu model: menu-model

The B<Gnome::Gtk3::MenuModel> from which the popup will be created. Depending on the  I<use-popover> property, that may be a menu or a popover.

See C<set-menu-model()> for the interaction with the
 I<popup> property.

   Widget type: G_TYPE_MENU_MODEL

The B<Gnome::GObject::Value> type of property I<menu-model> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:popover:
=head3 Popover: popover

The B<Gnome::Gtk3::Popover> that will be popped up when the button is clicked.

   Widget type: GTK_TYPE_POPOVER

The B<Gnome::GObject::Value> type of property I<popover> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:popup:
=head3 Popup: popup

The B<Gnome::Gtk3::Menu> that will be popped up when the button is clicked.

   Widget type: GTK_TYPE_MENU

The B<Gnome::GObject::Value> type of property I<popup> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:use-popover:
=head3 Use a popover: use-popover

Whether to construct a B<Gnome::Gtk3::Popover> from the menu model,
or a B<Gnome::Gtk3::Menu>.

The B<Gnome::GObject::Value> type of property I<use-popover> is C<G_TYPE_BOOLEAN>.
=end pod





























=finish
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

Sets the B<N-GObject> from which the popup will be constructed,
or C<Any> to disable the button.

Depending on the value of  I<use-popover>, either a
B<Gnome::Gtk3::Menu> will be created with C<gtk_menu_new_from_model()>, or a
B<Gnome::Gtk3::Popover> with C<gtk_popover_new_from_model()>. In either case,
actions will be connected as documented for these functions.

If  I<popup> or  I<popover> are already set,
their content will be lost and replaced by the newly created popup.

Since: 3.6

  method gtk_menu_button_set_menu_model ( N-GObject $menu_model )

=item N-GObject $menu_model; (allow-none): a B<N-GObject>

=end pod

sub gtk_menu_button_set_menu_model ( N-GObject $menu_button, N-GObject $menu_model )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_button_get_menu_model:
=begin pod
=head2 [[gtk_] menu_button_] get_menu_model

Returns the B<N-GObject> used to generate the popup.

Returns: (nullable) (transfer none): a B<N-GObject> or C<Any>

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

  my Gnome::Gtk3::Label $label .= new;
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


The B<N-GObject> from which the popup will be created.
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
