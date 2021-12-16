#TL:1:Gnome::Gtk3::PopoverMenu:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::PopoverMenu

Popovers to use as menus

=comment ![](images/X.png)

=head1 Description

B<Gnome::Gtk3::PopoverMenu> is a subclass of B<Gnome::Gtk3::Popover> that treats its children like menus and allows switching between them. It is meant to be used primarily together with B<Gnome::Gtk3::ModelButton>, but any widget can be used, such as B<Gnome::Gtk3::SpinButton> or B<Gnome::Gtk3::Scale>. In this respect, B<Gnome::Gtk3::PopoverMenu> is more flexible than popovers that are created from a B<GMenuModel> with C<gtk_popover_new_from_model()>. Besides that, GMenu is deprecated.

=begin comment
To add a child as a submenu, set the  I<submenu> child property to the name of the submenu. To let the user open this submenu, add a B<Gnome::Gtk3::ModelButton> whose  I<menu-name> property is set to the name you've given to the submenu.

By convention, the first child of a submenu should be a B<Gnome::Gtk3::ModelButton> to switch back to the parent menu. Such a button should use the  I<inverted> and  I<centered> properties to achieve a title-like appearance and place the submenu indicator at the opposite side. To switch back to the main menu, use "main" as the menu name.
=end comment

=begin comment

=head2 Example

  <object class="GtkPopoverMenu">
    <child>
      <object class="GtkBox">
        <property name="visible">True</property>
        <property name="margin">10</property>

        <child>
          <object class="GtkModelButton">
            <property name="visible">True</property>
            <property name="action-name">win.frob</property>
            <property name="text" translatable="yes">Frob</property>
          </object>
        </child>

        <child>
          <object class="GtkModelButton">
            <property name="visible">True</property>
            <property name="menu-name">more</property>
            <property name="text" translatable="yes">More</property>
          </object>
        </child>
      </object>
    </child>

    <child>
      <object class="GtkBox>">
        <property name="visible">True</property>
        <property name="margin">10</property>

        <child>
          <object class="GtkModelButton>">
            <property name="visible">True</property>
            <property name="action-name">win.foo</property>
            <property name="text" translatable="yes">Foo</property>
          </object>
        </child>

        <child>
          <object class="GtkModelButton">
            <property name="visible">True</property>
            <property name="action-name">win.bar</property>
            <property name="text" translatable="yes">Bar</property>
          </object>
        </child>
      </object>

      <packing>
        <property name="submenu">more</property>
      </packing>
    </child>
  </object>

=end comment

Just like normal popovers, B<Gnome::Gtk3::PopoverMenu> instances have a single css node called "popover" and get the .menu style class.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::PopoverMenu;
  also is Gnome::Gtk3::Popover;

=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::PopoverMenu;

  unit class MyGuiClass;
  also is Gnome::Gtk3::PopoverMenu;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::PopoverMenu class process the options
    self.bless( :GtkPopoverMenu, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Popover;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::PopoverMenu:auth<github:MARTIMM>;
also is Gnome::Gtk3::Popover;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new PopoverMenu object.

  multi method new ( )

Create a PopoverMenu object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

Create a PopoverMenu object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:2:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::PopoverMenu' #`{{ or %options<GtkPopoverMenu> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    # elsif ? %options<> {
    # }

    # check if there are unknown options
    elsif %options.elems {
      die X::Gnome.new(
        :message(
          'Unsupported, undefined, incomplete or wrongly typed options for ' ~
          self.^name ~ ': ' ~ %options.keys.join(', ')
        )
      );
    }

    #`{{ when there are no defaults use this
    # check if there are any options
    elsif %options.elems == 0 {
      die X::Gnome.new(:message('No options specified ' ~ self.^name));
    }
    }}

    ##`{{ when there are defaults use this instead
    # create default object
    else {
      self._set-native-object(_gtk_popover_menu_new());
    }
    #}}

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkPopoverMenu');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_popover_menu_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkPopoverMenu');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:_gtk_popover_menu_new:new()
#`{{
=begin pod
=head2 gtk_popover_menu_new

Creates a new popover menu.

Returns: a new B<Gnome::Gtk3::PopoverMenu>


  method gtk_popover_menu_new ( --> N-GObject )


=end pod
}}

sub _gtk_popover_menu_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_popover_menu_new')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_popover_menu_open_submenu:
=begin pod
=head2 [gtk_popover_menu_] open_submenu

Opens a submenu of the I<popover>. The I<name> must be one of the names given to the submenus of I<popover> with  I<submenu>, or "main" to switch back to the main menu.

B<Gnome::Gtk3::ModelButton> will open submenus automatically when the  I<menu-name> property is set, so this function is only needed when you are using other kinds of widgets to initiate menu changes.

  method gtk_popover_menu_open_submenu ( Str $name )

=item Str $name; the name of the menu to switch to

=end pod

sub gtk_popover_menu_open_submenu ( N-GObject $popover, Str $name  )
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

=comment #TP:0:visible-submenu:
=head3 Visible submenu

The name of the visible submenu
Default value: Any


The B<Gnome::GObject::Value> type of property I<visible-submenu> is C<G_TYPE_STRING>.
=end pod
