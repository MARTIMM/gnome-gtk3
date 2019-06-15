use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::MenuButton

=SUBTITLE

=head1 Description

I<short_description>: A widget that shows a popup when clicked on
I<title>: C<Gnome::Gtk3::MenuButton>

The C<Gnome::Gtk3::MenuButton> widget is used to display a popup when clicked on.
This popup can be provided either as a C<Gnome::Gtk3::Menu>, a C<Gnome::Gtk3::Popover> or an
abstract C<GMenuModel>.

The C<Gnome::Gtk3::MenuButton> widget can hold any valid child widget. That is, it
can hold almost any other standard C<Gnome::Gtk3::Widget>. The most commonly used
child is C<Gnome::Gtk3::Image>. If no widget is explicitely added to the C<Gnome::Gtk3::MenuButton>,
a C<Gnome::Gtk3::Image> is automatically created, using an arrow image oriented
according to C<direction> or the generic "view-context-menu"
icon if the direction is not set.

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

## Direction = Down
=Image file:///home/marcel/Languages/Perl6/Projects/perl6-gnome-gtk3/doc/images/down-start.png

- halign = start

    ![](down-start.png)

- halign = center

    ![](down-center.png)

- halign = end

    ![](down-end.png)

## Direction = Up

- halign = start

    ![](up-start.png)

- halign = center

    ![](up-center.png)

- halign = end

    ![](up-end.png)

## Direction = Left

- valign = start

    ![](left-start.png)

- valign = center

    ![](left-center.png)

- valign = end

    ![](left-end.png)

## Direction = Right

- valign = start

    ![](right-start.png)

- valign = center

    ![](right-center.png)

- valign = end

    ![](right-end.png)


=head2 Css Nodes


C<Gnome::Gtk3::MenuButton> has a single CSS node with name button. To differentiate
it from a plain C<Gnome::Gtk3::Button>, it gets the .popup style class.



=head2 See Also



=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::MenuButton;
  also is Gnome::Gtk3::ToggleButton;

=head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
#use Gnome::GObject::Object;
use Gnome::Gtk3::ToggleButton;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::MenuButton:auth<github:MARTIMM>;
also is Gnome::Gtk3::ToggleButton;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

  multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

  multi method new ( Gnome::GObject::Object :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    # ... :type<signame>
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::MenuButton';

  # process all named arguments
  if ? %options<empty> {
    # self.native-gobject(gtk_menu_button_new());
  }

  elsif ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::GTK::V3.new(
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
  try { $s = &::("gtk_menu_button_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_menu_button_new

Creates a new C<Gnome::Gtk3::MenuButton> widget with downwards-pointing arrow as the only child. You can replace the child widget with another C<Gnome::Gtk3::Widget> should you wish to.

  method gtk_menu_button_new ( --> N-GObject  )


Returns N-GObject; The newly created C<Gnome::Gtk3::MenuButton> widget
=end pod

sub gtk_menu_button_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_button_] set_popup

Sets the C<Gnome::Gtk3::Menu> that will be popped up when the button is clicked, or C<Any> to disable the button. If C<menu>-model or C<popover> are set, they will be set to C<Any>.

  method gtk_menu_button_set_popup ( N-GObject $menu )

=item N-GObject $menu; (allow-none): a C<Gnome::Gtk3::Menu>

=end pod

sub gtk_menu_button_set_popup ( N-GObject $menu_button, N-GObject $menu )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_button_] get_popup

Returns the C<Gnome::Gtk3::Menu> that pops out of the button. If the button does not use a C<Gnome::Gtk3::Menu>, this function returns C<Any>.

  method gtk_menu_button_get_popup ( --> N-GObject  )


Returns N-GObject; (nullable) (transfer none): a C<Gnome::Gtk3::Menu> or C<Any>
=end pod

sub gtk_menu_button_get_popup ( N-GObject $menu_button )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_button_] set_popover

Sets the C<Gnome::Gtk3::Popover> that will be popped up when the button is clicked, or C<Any> to disable the button. If C<menu>-model or C<popup> are set, they will be set to C<Any>.

  method gtk_menu_button_set_popover ( N-GObject $popover )

=item N-GObject $popover; (allow-none): a C<Gnome::Gtk3::Popover>

=end pod

sub gtk_menu_button_set_popover ( N-GObject $menu_button, N-GObject $popover )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_button_] get_popover

Returns the C<Gnome::Gtk3::Popover> that pops out of the button. If the button is not using a C<Gnome::Gtk3::Popover>, this function returns C<Any>.

  method gtk_menu_button_get_popover ( --> N-GObject  )


Returns N-GObject; (nullable) (transfer none): a C<Gnome::Gtk3::Popover> or C<Any>
=end pod

sub gtk_menu_button_get_popover ( N-GObject $menu_button )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_button_] set_direction

Sets the direction in which the popup will be popped up, as well as changing the arrow’s direction. The child will not be changed to an arrow if it was customized.

  method gtk_menu_button_set_direction ( GtkArrowType $direction )

=item GtkArrowType $direction; a C<Gnome::Gtk3::ArrowType>

=end pod

sub gtk_menu_button_set_direction ( N-GObject $menu_button, int32 $direction )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_button_] get_direction

Returns the direction the popup will be pointing at when popped up.

  method gtk_menu_button_get_direction ( --> GtkArrowType  )


Returns GtkArrowType; a C<Gnome::Gtk3::ArrowType> value
=end pod

sub gtk_menu_button_get_direction ( N-GObject $menu_button )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_button_] set_menu_model

Sets the C<GMenuModel> from which the popup will be constructed, or C<Any> to disable the button.

  method gtk_menu_button_set_menu_model ( GMenuModel $menu_model )

=item GMenuModel $menu_model; (allow-none): a C<GMenuModel>

=end pod

#sub gtk_menu_button_set_menu_model ( N-GObject $menu_button, GMenuModel $menu_model )
#  is native(&gtk-lib)
#  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_button_] get_menu_model

Returns the C<GMenuModel> used to generate the popup.

  method gtk_menu_button_get_menu_model ( --> GMenuModel  )


Returns GMenuModel; (nullable) (transfer none): a C<GMenuModel> or C<Any>
=end pod

#sub gtk_menu_button_get_menu_model ( N-GObject $menu_button )
#  returns GMenuModel
#  is native(&gtk-lib)
#  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_button_] set_align_widget

Sets the C<Gnome::Gtk3::Widget> to use to line the menu with when popped up. Note that the I<align_widget> must contain the C<Gnome::Gtk3::MenuButton> itself.

  method gtk_menu_button_set_align_widget ( N-GObject $align_widget )

=item N-GObject $align_widget; (allow-none): a C<Gnome::Gtk3::Widget>

=end pod

sub gtk_menu_button_set_align_widget ( N-GObject $menu_button, N-GObject $align_widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_button_] get_align_widget

Returns the parent C<Gnome::Gtk3::Widget> to use to line up with menu.

  method gtk_menu_button_get_align_widget ( --> N-GObject  )


Returns N-GObject; (nullable) (transfer none): a C<Gnome::Gtk3::Widget> value or C<Any>
=end pod

sub gtk_menu_button_get_align_widget ( N-GObject $menu_button )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_button_] set_use_popover

Sets whether to construct a C<Gnome::Gtk3::Popover> instead of C<Gnome::Gtk3::Menu> when C<gtk_menu_button_set_menu_model()> is called. Note that this property is only consulted when a new menu model is set.

  method gtk_menu_button_set_use_popover ( Int $use_popover )

=item Int $use_popover; C<1> to construct a popover from the menu model

=end pod

sub gtk_menu_button_set_use_popover ( N-GObject $menu_button, int32 $use_popover )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_menu_button_] get_use_popover

Returns whether a C<Gnome::Gtk3::Popover> or a C<Gnome::Gtk3::Menu> will be constructed from the menu model.

  method gtk_menu_button_get_use_popover ( --> Int  )


Returns Int; C<1> if using a C<Gnome::Gtk3::Popover>
=end pod

sub gtk_menu_button_get_use_popover ( N-GObject $menu_button )
  returns int32
  is native(&gtk-lib)
  { * }


#=end pod
