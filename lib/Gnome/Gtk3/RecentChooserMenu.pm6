#TL:1:Gnome::Gtk3::RecentChooserMenu:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::RecentChooserMenu

Displays recently used files in a menu

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::RecentChooserMenu> is a widget suitable for displaying recently used files inside a menu.  It can be used to set a sub-menu of a B<Gnome::Gtk3::MenuItem> using C<gtk_menu_item_set_submenu()>, or as the menu of a B<Gnome::Gtk3::MenuToolButton>.

Note that B<Gnome::Gtk3::RecentChooserMenu> does not have any methods of its own. Instead, you should use the functions that work on a B<Gnome::Gtk3::RecentChooser>.

Note also that B<Gnome::Gtk3::RecentChooserMenu> does not support multiple filters, as it has no way to let the user choose between them as the B<Gnome::Gtk3::RecentChooserWidget> and B<Gnome::Gtk3::RecentChooserDialog> widgets do. Thus using C<gtk_recent_chooser_add_filter()> on a B<Gnome::Gtk3::RecentChooserMenu> widget will yield the same effects as using C<gtk_recent_chooser_set_filter()>, replacing any currently set filter with the supplied filter; C<gtk_recent_chooser_remove_filter()> will remove any currently set B<Gnome::Gtk3::RecentFilter> object and will unset the current filter; C<gtk_recent_chooser_list_filters()> will return a list containing a single B<Gnome::Gtk3::RecentFilter> object.

Recently used files are supported since GTK+ 2.10.


=head2 Implemented Interfaces

Gnome::Gtk3::RecentChooserMenu implements
=comment item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)
=comment item [Gnome::Gtk3::Orientable](Orientable.html)


=head2 See Also

B<Gnome::Gtk3::RecentChooser>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::RecentChooserMenu;
  also is Gnome::Gtk3::Menu;
  also does Gnome::Gtk3::Buildable;
=comment  also does Gnome::Gtk3::Orientable;

=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::RecentChooserMenu;

  unit class MyGuiClass;
  also is Gnome::Gtk3::RecentChooserMenu;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::RecentChooserMenu class process the options
    self.bless( :GtkRecentChooserMenu, |c);
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
use Gnome::Gtk3::Menu;

#use Gnome::Gtk3::Orientable;
use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::RecentChooserMenu:auth<github:MARTIMM>;
also is Gnome::Gtk3::Menu;
also does Gnome::Gtk3::Buildable;
#also does Gnome::Gtk3::Orientable;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new RecentChooserMenu object.

  multi method new ( )

Create a RecentChooserMenu object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

Create a RecentChooserMenu object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::RecentChooserMenu' or %options<GtkRecentChooserMenu> {

    # check if native object is set by other parent class BUILDers
    if self.is-valid { }

#`{{
    # process all named arguments
    elsif %options.elems == 0 {
      die X::Gnome.new(:message('No options specified ' ~ self.^name));
    }

    if ? %options<native-object> || ? %options<build-id> {
      # provided in Gnome::N::TopLevelClassSupport
      # and in Gnome::GObject::Object
    }
    elsif %options.keys.elems {
      die X::Gnome.new(
        :message(
          'Unsupported, undefined, incomplete or wrongly typed options for ' ~
          self.^name ~ ': ' ~ %options.keys.join(', ')
        )
      );
    }
}}

    # create default object
    else {
      self.set-native-object(_gtk_recent_chooser_menu_new());
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkRecentChooserMenu');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_recent_chooser_menu_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;
#  $s = self._orientable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkRecentChooserMenu');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:_gtk_recent_chooser_menu_new:new()
#`{{
Creates a new B<Gnome::Gtk3::RecentChooserMenu> widget.

This kind of widget shows the list of recently used resources as
a menu, each item as a menu item.  Each item inside the menu might
have an icon, representing its MIME type, and a number, for mnemonic
access.

This widget implements the B<Gnome::Gtk3::RecentChooser> interface.

This widget creates its own B<Gnome::Gtk3::RecentManager> object.  See the
C<gtk_recent_chooser_menu_new_for_manager()> function to know how to create
a B<Gnome::Gtk3::RecentChooserMenu> widget bound to another B<Gnome::Gtk3::RecentManager> object.

Returns: a new B<Gnome::Gtk3::RecentChooserMenu>

  method gtk_recent_chooser_menu_new ( --> N-GObject )
}}

sub _gtk_recent_chooser_menu_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_recent_chooser_menu_new')
  { * }

#-------------------------------------------------------------------------------
#`{{
#TM:0:gtk_recent_chooser_menu_new_for_manager:
=begin pod
=head2 [gtk_recent_chooser_menu_] new_for_manager

Creates a new B<Gnome::Gtk3::RecentChooserMenu> widget using I<manager> as the underlying recently used resources manager.

This is useful if you have implemented your own recent manager, or if you have a customized instance of a B<Gnome::Gtk3::RecentManager> object or if you wish to share a common B<Gnome::Gtk3::RecentManager> object among multiple B<Gnome::Gtk3::RecentChooser> widgets.

Returns: a new B<Gnome::Gtk3::RecentChooserMenu>, bound to I<manager>.

  method gtk_recent_chooser_menu_new_for_manager (
    N-GObject $manager --> N-GObject
  )

=item N-GObject $manager; a B<Gnome::Gtk3::RecentManager>

=end pod

sub gtk_recent_chooser_menu_new_for_manager ( N-GObject $manager --> N-GObject )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_recent_chooser_menu_get_show_numbers:
=begin pod
=head2 [gtk_recent_chooser_menu_] get_show_numbers

Returns the value set by C<gtk_recent_chooser_menu_set_show_numbers()>.

Returns: C<1> if numbers should be shown.

  method gtk_recent_chooser_menu_get_show_numbers ( --> Int )


=end pod

sub gtk_recent_chooser_menu_get_show_numbers ( N-GObject $menu --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_recent_chooser_menu_set_show_numbers:
=begin pod
=head2 [gtk_recent_chooser_menu_] set_show_numbers

Sets whether a number should be added to the items of I<menu>.  The
numbers are shown to provide a unique character for a mnemonic to
be used inside ten menu item’s label.  Only the first the items
get a number to avoid clashes.

  method gtk_recent_chooser_menu_set_show_numbers ( Int $show_numbers )

=item Int $show_numbers; whether to show numbers

=end pod

sub gtk_recent_chooser_menu_set_show_numbers ( N-GObject $menu, int32 $show_numbers  )
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

=comment #TP:0:show-numbers:
=head3 Show Numbers


Whether the first ten items in the menu should be prepended by
a number acting as a unique mnemonic.

The B<Gnome::GObject::Value> type of property I<show-numbers> is C<G_TYPE_BOOLEAN>.
=end pod
