#TL:1:Gnome::Gtk3::MenuBar:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::MenuBar

A subclass of B<Gnome::Gtk3::MenuShell> which holds B<Gnome::Gtk3::MenuItem> widgets

![](images/menubar.png)

=head1 Description


The B<Gnome::Gtk3::MenuBar> is a subclass of B<Gnome::Gtk3::MenuShell> which contains one or
more B<Gnome::Gtk3::MenuItems>. The result is a standard menu bar which can hold
many menu items.


=head2 Css Nodes


B<Gnome::Gtk3::MenuBar> has a single CSS node with name menubar.

=head2 Implemented Interfaces

Gnome::Gtk3::MenuBar implements
=item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)

=head2 See Also

B<Gnome::Gtk3::MenuShell>, B<Gnome::Gtk3::Menu>, B<Gnome::Gtk3::MenuItem>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::MenuBar;
  also is Gnome::Gtk3::MenuShell;
  also does Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::MenuShell;

use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::MenuBar:auth<github:MARTIMM>;
also is Gnome::Gtk3::MenuShell;
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

#TM:0:new():inheriting
#TM:1:new(:empty):
#TM:0:new(:native-object):
#TM:0:new(:build-id):
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::MenuBar';

  # process all named arguments
  if ? %options<empty> {
    self.set-native-object(gtk_menu_bar_new());
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
  self.set-class-info('GtkMenuBar');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_menu_bar_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkMenuBar');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_menu_bar_new:new(:empty)
=begin pod
=head2 [gtk_] menu_bar_new

Creates a new B<Gnome::Gtk3::MenuBar>

Returns: the new menu bar, as a B<Gnome::Gtk3::Widget>

  method gtk_menu_bar_new ( --> N-GObject  )


=end pod

sub gtk_menu_bar_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_bar_new_from_model:
=begin pod
=head2 [[gtk_] menu_bar_] new_from_model

Creates a new B<Gnome::Gtk3::MenuBar> and populates it with menu items
and submenus according to I<model>.

The created menu items are connected to actions found in the
B<Gnome::Gtk3::ApplicationWindow> to which the menu bar belongs - typically
by means of being contained within the B<Gnome::Gtk3::ApplicationWindows>
widget hierarchy.

Returns: a new B<Gnome::Gtk3::MenuBar>

Since: 3.4

  method gtk_menu_bar_new_from_model ( N-GObject $model --> N-GObject  )

=item N-GObject $model; a B<GMenuModel>

=end pod

sub gtk_menu_bar_new_from_model ( N-GObject $model )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_menu_bar_get_pack_direction:
=begin pod
=head2 [[gtk_] menu_bar_] get_pack_direction

Retrieves the current pack direction of the menubar.
See C<gtk_menu_bar_set_pack_direction()>.

Returns: the pack direction

Since: 2.8

  method gtk_menu_bar_get_pack_direction ( --> GtkPackDirection  )


=end pod

sub gtk_menu_bar_get_pack_direction ( N-GObject $menubar )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_menu_bar_set_pack_direction:
=begin pod
=head2 [[gtk_] menu_bar_] set_pack_direction

Sets how items should be packed inside a menubar.

Since: 2.8

  method gtk_menu_bar_set_pack_direction ( GtkPackDirection $pack_dir )

=item GtkPackDirection $pack_dir; a new B<Gnome::Gtk3::PackDirection>

=end pod

sub gtk_menu_bar_set_pack_direction ( N-GObject $menubar, int32 $pack_dir )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_bar_get_child_pack_direction:
=begin pod
=head2 [[gtk_] menu_bar_] get_child_pack_direction

Retrieves the current child pack direction of the menubar.
See C<gtk_menu_bar_set_child_pack_direction()>.

Returns: the child pack direction

Since: 2.8

  method gtk_menu_bar_get_child_pack_direction ( --> GtkPackDirection  )


=end pod

sub gtk_menu_bar_get_child_pack_direction ( N-GObject $menubar )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_menu_bar_set_child_pack_direction:
=begin pod
=head2 [[gtk_] menu_bar_] set_child_pack_direction

Sets how widgets should be packed inside the children of a menubar.

Since: 2.8

  method gtk_menu_bar_set_child_pack_direction ( GtkPackDirection $child_pack_dir )

=item GtkPackDirection $child_pack_dir; a new B<Gnome::Gtk3::PackDirection>

=end pod

sub gtk_menu_bar_set_child_pack_direction ( N-GObject $menubar, int32 $child_pack_dir )
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

=comment #TP:0:pack-direction:
=head3 Pack direction


The pack direction of the menubar. It determines how
menuitems are arranged in the menubar.
Since: 2.8
Widget type: GTK_TYPE_PACK_DIRECTION

The B<Gnome::GObject::Value> type of property I<pack-direction> is C<G_TYPE_ENUM>.

=comment #TP:0:child-pack-direction:
=head3 Child Pack direction


The child pack direction of the menubar. It determines how
the widgets contained in child menuitems are arranged.
Since: 2.8
Widget type: GTK_TYPE_PACK_DIRECTION

The B<Gnome::GObject::Value> type of property I<child-pack-direction> is C<G_TYPE_ENUM>.
=end pod



























=finish

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_] menu_bar_new

Creates a new B<Gnome::Gtk3::MenuBar>

Returns: the new menu bar, as a B<Gnome::Gtk3::Widget>

  method gtk_menu_bar_new ( --> N-GObject  )


=end pod

sub gtk_menu_bar_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_bar_] new_from_model

Creates a new B<Gnome::Gtk3::MenuBar> and populates it with menu items
and submenus according to I<model>.

The created menu items are connected to actions found in the
B<Gnome::Gtk3::ApplicationWindow> to which the menu bar belongs - typically
by means of being contained within the B<Gnome::Gtk3::ApplicationWindows>
widget hierarchy.

Returns: a new B<Gnome::Gtk3::MenuBar>

Since: 3.4

  method gtk_menu_bar_new_from_model ( N-GObject $model --> N-GObject  )

=item N-GObject $model; a C<GMenuModel>

=end pod

sub gtk_menu_bar_new_from_model ( N-GObject $model )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_bar_] get_pack_direction

Retrieves the current pack direction of the menubar.
See C<gtk_menu_bar_set_pack_direction()>.

Returns: the pack direction

Since: 2.8

  method gtk_menu_bar_get_pack_direction ( --> GtkPackDirection  )


=end pod

sub gtk_menu_bar_get_pack_direction ( N-GObject $menubar )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_bar_] set_pack_direction

Sets how items should be packed inside a menubar.

Since: 2.8

  method gtk_menu_bar_set_pack_direction ( GtkPackDirection $pack_dir )

=item GtkPackDirection $pack_dir; a new B<Gnome::Gtk3::PackDirection>

=end pod

sub gtk_menu_bar_set_pack_direction ( N-GObject $menubar, int32 $pack_dir )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_bar_] get_child_pack_direction

Retrieves the current child pack direction of the menubar.
See C<gtk_menu_bar_set_child_pack_direction()>.

Returns: the child pack direction

Since: 2.8

  method gtk_menu_bar_get_child_pack_direction ( --> GtkPackDirection  )


=end pod

sub gtk_menu_bar_get_child_pack_direction ( N-GObject $menubar )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] menu_bar_] set_child_pack_direction

Sets how widgets should be packed inside the children of a menubar.

Since: 2.8

  method gtk_menu_bar_set_child_pack_direction ( GtkPackDirection $child_pack_dir )

=item GtkPackDirection $child_pack_dir; a new B<Gnome::Gtk3::PackDirection>

=end pod

sub gtk_menu_bar_set_child_pack_direction ( N-GObject $menubar, int32 $child_pack_dir )
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

=head3 pack-direction

The B<Gnome::GObject::Value> type of property I<pack-direction> is C<G_TYPE_ENUM>.

The pack direction of the menubar. It determines how
menuitems are arranged in the menubar.

Since: 2.8

=head3 child-pack-direction

The B<Gnome::GObject::Value> type of property I<child-pack-direction> is C<G_TYPE_ENUM>.

The child pack direction of the menubar. It determines how
the widgets contained in child menuitems are arranged.

Since: 2.8

=end pod
