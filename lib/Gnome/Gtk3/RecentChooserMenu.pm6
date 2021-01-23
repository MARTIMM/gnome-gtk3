#TL:1:Gnome::Gtk3::RecentChooserMenu:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::RecentChooserMenu

Displays recently used files in a menu

=comment ![](images/X.png)


=head1 Description

B<Gnome::Gtk3::RecentChooserMenu> is a widget suitable for displaying recently used files inside a menu.  It can be used to set a sub-menu of a B<Gnome::Gtk3::MenuItem> using C<.set-submenu()>, or as the menu of a B<Gnome::Gtk3::MenuToolButton>.

Note that B<Gnome::Gtk3::RecentChooserMenu> does not have any many methods of its own. Instead, you should use the functions of its role B<Gnome::Gtk3::RecentChooser>.

Note also that B<Gnome::Gtk3::RecentChooserMenu> does not support multiple filters, as it has no way to let the user choose between them as the B<Gnome::Gtk3::RecentChooserWidget> and B<Gnome::Gtk3::RecentChooserDialog> widgets do. Thus using C<.add_filter()> on a B<Gnome::Gtk3::RecentChooserMenu> widget will yield the same effects as using C<.set_filter()>, replacing any currently set filter with the supplied filter; C<.remove_filter()> will remove any currently set B<Gnome::Gtk3::RecentFilter> object and will unset the current filter; C<.list_filters()> will return a list containing a single B<Gnome::Gtk3::RecentFilter> object.


=head2 See Also

B<Gnome::Gtk3::RecentChooser>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::RecentChooserMenu;
  also is Gnome::Gtk3::Menu;
=comment  also does Gnome::Gtk3::RecentChooser;

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
use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::Menu;
use Gnome::Gtk3::RecentChooser;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::RecentChooserMenu:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::Gtk3::Menu;
also does Gnome::Gtk3::RecentChooser;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new RecentChooserMenu object.

  multi method new ( )

=head3 :manager

Creates a new B<Gnome::Gtk3::RecentChooserMenu> widget using I<$manager> as the underlying recently used resources manager.

This is useful if you have implemented your own recent manager, or if you have a customized instance of a B<Gnome::Gtk3::RecentManager> object or if you wish to share a common B<Gnome::Gtk3::RecentManager> object among multiple B<Gnome::Gtk3::RecentChooser> widgets.

  multi method new ( N-GObject :$manager! )

=end pod

#TM:1:new():inheriting
#TM:1:new():
#TM:1:new(:manager):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::RecentChooserMenu' or %options<GtkRecentChooserMenu> {

    # check if native object is set by other parent class BUILDers
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<manager> {
        $no = %options<manager>;
        $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        $no = _gtk_recent_chooser_menu_new_for_manager($no);
      }

      # create default object
      else {
        $no = _gtk_recent_chooser_menu_new;
      }

      self.set-native-object($no);
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

  self._recent_chooser_interface($native-sub) unless ?$s;

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
#TM:2:_gtk_recent_chooser_menu_new_for_manager:new()
#`{{
=begin pod
=head2 _gtk_recent_chooser_menu_new_for_manager

Creates a new B<Gnome::Gtk3::RecentChooserMenu> widget using I<manager> as the underlying recently used resources manager.  This is useful if you have implemented your own recent manager, or if you have a customized instance of a B<Gnome::Gtk3::RecentManager> object or if you wish to share a common B<Gnome::Gtk3::RecentManager> object among multiple B<Gnome::Gtk3::RecentChooser> widgets.

Returns: a new B<Gnome::Gtk3::RecentChooserMenu>, bound to I<manager>.

  method _gtk_recent_chooser_menu_new_for_manager ( N-GObject $manager --> N-GObject )

=item N-GObject $manager; a B<Gnome::Gtk3::RecentManager>

=end pod
}}

sub _gtk_recent_chooser_menu_new_for_manager ( N-GObject $manager --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_recent_chooser_menu_new_for_manager')
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-numbers:
=begin pod
=head2 get-show-numbers

Returns the value set by C<set-show-numbers()>.

Returns: C<True> if numbers should be shown.

  method get-show-numbers ( --> Bool )

=end pod

method get-show-numbers ( --> Bool ) {

  gtk_recent_chooser_menu_get_show_numbers(
    self._f('GtkRecentChooserMenu'),
  ).Bool;
}

sub gtk_recent_chooser_menu_get_show_numbers ( N-GObject $menu --> gboolean )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-numbers:
=begin pod
=head2 set-show-numbers

Sets whether a number should be added to the items of I<menu>.  The numbers are shown to provide a unique character for a mnemonic to be used inside the menu item’s label.  Only the first ten items get a number to avoid clashes.

  method set-show-numbers ( Bool $show_numbers )

=item Int $show_numbers; whether to show numbers

=end pod

method set-show-numbers ( Int $show_numbers ) {

  gtk_recent_chooser_menu_set_show_numbers(
    self._f('GtkRecentChooserMenu'), $show_numbers.Int
  );
}

sub gtk_recent_chooser_menu_set_show_numbers ( N-GObject $menu, gboolean $show_numbers  )
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

=comment #TP:1:show-numbers:
=head3 Show Numbers


Whether the first ten items in the menu should be prepended by
a number acting as a unique mnemonic.

The B<Gnome::GObject::Value> type of property I<show-numbers> is C<G_TYPE_BOOLEAN>.
=end pod
