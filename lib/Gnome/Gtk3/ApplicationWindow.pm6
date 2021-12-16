#TL:1:Gnome::Gtk3::ApplicationWindow:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ApplicationWindow

B<Gnome::Gtk3::Window> subclass with B<Gnome::Gtk3::Application> support

=comment ![](images/X.png)

=head1 Description

B<Gnome::Gtk3::ApplicationWindow> is a B<Gnome::Gtk3::Window> subclass that offers some extra functionality for better integration with B<Gnome::Gtk3::Application> features.  Notably, it can handle both the application menu as well as the menubar. See C<gtk_application_set_app_menu()> and C<gtk_application_set_menubar()>.

This class implements the B<GActionGroup> and B<GActionMap> interfaces, to let you add window-specific actions that will be exported by the associated B<Gnome::Gtk3::Application>, together with its application-wide actions.  Window-specific actions are prefixed with the “win.” prefix and application-wide actions are prefixed with the “app.” prefix.  Actions must be addressed with the prefixed name when referring to them from a B<GMenuModel>.

Note that widgets that are placed inside a B<Gnome::Gtk3::ApplicationWindow> can also activate these actions, if they implement the B<Gnome::Gtk3::Actionable> interface.

As with B<Gnome::Gtk3::Application>, the GDK lock will be acquired when processing actions arriving from other processes and should therefore be held when activating actions locally (if GDK threads are enabled).

The settings  I<gtk-shell-shows-app-menu> and I<gtk-shell-shows-menubar> tell GTK+ whether the desktop environment is showing the application menu and menubar models outside the application as part of the desktop shell. For instance, on OS X, both menus will be displayed remotely; on Windows neither will be. gnome-shell (starting with version 3.4) will display the application menu, but not the menubar.

If the desktop environment does not display the menubar, then B<Gnome::Gtk3::ApplicationWindow> will automatically show a B<Gnome::Gtk3::MenuBar> for it. This behaviour can be overridden with the  I<show-menubar> property. If the desktop environment does not display the application menu, then it will automatically be included in the menubar or in the windows client-side decorations.

=head2 A B<Gnome::Gtk3::ApplicationWindow> with a menubar

  my Gnome::Gtk3::Application $app .= new(:app-id("org.gtk.test"));
  my Str $gui-interface = Q:to/EOMENU/;
    <interface>
      <menu id='menubar'>
        <submenu label='_Edit'>
          <item label='_Copy' action='win.copy'/>
          <item label='_Paste' action='win.paste'/>
        </submenu>
      </menu>
    </interface>
    EOMENU

  my Gnome::Gtk3::Builder $builder .= new(:string($gui-interface));

  my Gnome::Gio::MenuModel $menubar .= new(:build-id<menubar>);
  $app.set-menubar($menubar);

  …

  my Gnome::Gtk3::ApplicationWindow $app-window .= new(:application($app));


=head2 Handling fallback yourself

=comment [A simple example](https://git.gnome.org/browse/gtk+/tree/examples/sunny.c)

The XML format understood by B<Gnome::Gtk3::Builder> for B<GMenuModel> consists of a toplevel `<menu>` element, which contains one or more `<item>` elements. Each `<item>` element contains `<attribute>` and `<link>` elements with a mandatory name attribute. `<link>` elements have the same content model as `<menu>`. Instead of `<link name="submenu>` or `<link name="section">`, you can use `<submenu>` or `<section>` elements.

Attribute values can be translated using gettext, like other B<Gnome::Gtk3::Builder> content. `<attribute>` elements can be marked for translation with a `translatable="yes"` attribute. It is also possible to specify message context and translator comments, using the context and comments attributes. To make use of this, the B<Gnome::Gtk3::Builder> must have been given the gettext domain to use.

The following attributes are used when constructing menu items:
=item "label": a user-visible string to display
=item "action": the prefixed name of the action to trigger
=item "target": the parameter to use when activating the action
=item "icon" and "verb-icon": names of icons that may be displayed
=item "submenu-action": name of an action that may be used to determine if a submenu can be opened
=item "hidden-when": a string used to determine when the item will be hidden. Possible values include "action-disabled", "action-missing", "macos-menubar".

The following attributes are used when constructing sections:
=item "label": a user-visible string to use as section heading
=item "display-hint": a string used to determine special formatting for the section. Possible values include "horizontal-buttons".
=item "text-direction": a string used to determine the B<Gnome::Gtk3::TextDirection> to use when "display-hint" is set to "horizontal-buttons". Possible values include "rtl", "ltr", and "none".

The following attributes are used when constructing submenus:
=item "label": a user-visible string to display
=item "icon": icon name to display


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ApplicationWindow;
  also is Gnome::Gtk3::Window;
=comment  also does Gnome::Atk::ImplementorIface;
=comment  also does Gnome::Gio::ActionGroup;
  also does Gnome::Gio::ActionMap;


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::ApplicationWindow;

  unit class MyGuiClass;
  also is Gnome::Gtk3::ApplicationWindow;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::ApplicationWindow class process the options
    self.bless( :GtkApplicationWindow, |c);
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

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Application;
use Gnome::Gio::ActionMap;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::ApplicationWindow:auth<github:MARTIMM>;
also is Gnome::Gtk3::Window;
#also does Gnome::Atk::ImplementorIface;
#also does Gnome::Gio::ActionGroup;
also does Gnome::Gio::ActionMap;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :application

Create a new B<Gnome::Gtk3::ApplicationWindow> based on a B<Gnome::Gtk3::Application> object.

  multi method new ( N-GObject :$application! )

=head3 :native-object

Create a ApplicationWindow object using a native object from elsewhere. See also B<Gnome::N::TopLevelSupportClass>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a ApplicationWindow object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new(:application):
#TM:4:new(:native-object):
#TM:4:new(:build-id):

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ApplicationWindow' or %options<GtkApplicationWindow> {

    if self.is-valid { }

    elsif %options<widget>:exists or %options<native-object>:exists or
      %options<build-id>:exists { }

    # process all named arguments
    elsif ? %options<application> {
      my $a = %options<application>;
      $a .= _get-native-object if $a ~~ Gnome::Gtk3::Application;
      self._set-native-object(_gtk_application_window_new($a));
    }

    elsif %options.keys.elems {
      die X::Gnome.new(
        :message(
          'Unsupported, undefined, incomplete or wrongly typed options for ' ~
          self.^name ~ ': ' ~ %options.keys.join(', ')
        )
      );
    }

    # create default object
    else {
      die X::Gnome.new(:message('No options provided for ' ~ self.^name));
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkApplicationWindow');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_application_window_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkApplicationWindow');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:get-help-overlay:
#TM:0:get-help-overlay-rk:
=begin pod
=head2 get-help-overlay, get-help-overlay-rk

Gets the B<Gnome::Gtk3::ShortcutsWindow> that has been set up with a prior call to C<set-help-overlay()>.

Returns: the help overlay associated with I<window>, or C<undefined>

  method get-help-overlay ( --> N-GObject )
  method get-help-overlay-rk ( :$child-type? --> Gnome::GObject::Object )

=item $child-type: This is an optional argument. You can specify a real type or a type as a string. In the latter case the type must be defined in a module which can be found by the Raku require call.

=end pod

method get-help-overlay ( --> N-GObject ) {
  gtk_application_window_get_help_overlay(
    self._get-native-object-no-reffing,
  )
}

method get-help-overlay-rk ( *%options --> Gnome::GObject::Object ) {
  self._wrap-native-type-from-no(
    gtk_application_window_get_help_overlay(self._get-native-object-no-reffing),
    |%options
  )
}

sub gtk_application_window_get_help_overlay (
  N-GObject $window --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-id:
=begin pod
=head2 get-id

Returns the unique ID of the window. If the window has not yet been added to a B<Gnome::Gtk3::Application>, returns `0`.

Returns: the unique ID for I<window>, or `0` if the window has not yet been added to a B<Gnome::Gtk3::Application>

  method get-id ( --> UInt )

=end pod

method get-id ( --> UInt ) {
  gtk_application_window_get_id(
    self._get-native-object-no-reffing,
  )
}

sub gtk_application_window_get_id (
  N-GObject $window --> guint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-show-menubar:
=begin pod
=head2 get-show-menubar

Returns whether the window will display a menubar for the app menu and menubar as needed.

Returns: C<True> if I<window> will display a menubar when needed

  method get-show-menubar ( --> Bool )

=end pod

method get-show-menubar ( --> Bool ) {

  gtk_application_window_get_show_menubar(
    self._get-native-object-no-reffing,
  ).Bool
}

sub gtk_application_window_get_show_menubar (
  N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-help-overlay:
=begin pod
=head2 set-help-overlay

Associates a shortcuts window with the application window, and sets up an action with the name win.show-help-overlay to present it.

I<window> takes resposibility for destroying I<help-overlay>.

  method set-help-overlay ( N-GObject $help_overlay )

=item N-GObject $help_overlay; a B<Gnome::Gtk3::ShortcutsWindow>
=end pod

method set-help-overlay ( $help_overlay is copy ) {
  $help_overlay .= _get-native-object-no-reffing
    unless $help_overlay ~~ N-GObject;

  gtk_application_window_set_help_overlay(
    self._get-native-object-no-reffing, $help_overlay
  );
}

sub gtk_application_window_set_help_overlay (
  N-GObject $window, N-GObject $help_overlay
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-show-menubar:
=begin pod
=head2 set-show-menubar

Sets whether the window will display a menubar for the app menu and menubar as needed.

  method set-show-menubar ( Bool $show_menubar )

=item Bool $show_menubar; whether to show a menubar when needed
=end pod

method set-show-menubar ( Bool $show_menubar ) {

  gtk_application_window_set_show_menubar(
    self._get-native-object-no-reffing, $show_menubar
  );
}

sub gtk_application_window_set_show_menubar (
  N-GObject $window, gboolean $show_menubar
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_application_window_new:
#`{{
=begin pod
=head2 _gtk_application_window_new

Creates a new B<Gnome::Gtk3::ApplicationWindow>.

Returns: a newly created B<Gnome::Gtk3::ApplicationWindow>

  method _gtk_application_window_new ( N-GObject $application --> N-GObject )

=item N-GObject $application; a B<Gnome::Gtk3::Application>
=end pod
}}

sub _gtk_application_window_new ( N-GObject $application --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_application_window_new')
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
=comment #TP:0:show-menubar:
=head3 Show a menubar: show-menubar


If this property is C<True>, the window will display a menubar
that includes the app menu and menubar, unless these are
shown by the desktop shell. See C<gtk-application-set-app-menu()>
and C<gtk-application-set-menubar()>.

If C<False>, the window will not display a menubar, regardless
   * of whether the desktop shell is showing the menus or not.
The B<Gnome::GObject::Value> type of property I<show-menubar> is C<G_TYPE_BOOLEAN>.
=end pod





























=finish
#-------------------------------------------------------------------------------
#TM:0:_gtk_application_window_new:
#`{{
=begin pod
=head2 gtk_application_window_new

Creates a new B<Gnome::Gtk3::ApplicationWindow>.

Returns: a newly created B<Gnome::Gtk3::ApplicationWindow>

  method gtk_application_window_new ( N-GObject $application --> N-GObject )

=item N-GObject $application; a B<Gnome::Gtk3::Application>

=end pod
}}

sub _gtk_application_window_new ( N-GObject $application --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_application_window_new')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_window_set_show_menubar:
=begin pod
=head2 [gtk_application_window_] set_show_menubar

Sets whether the window will display a menubar for the app menu
and menubar as needed.

  method gtk_application_window_set_show_menubar ( Int $show_menubar )

=item Int $show_menubar; whether to show a menubar when needed

=end pod

sub gtk_application_window_set_show_menubar ( N-GObject $window, int32 $show_menubar  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_window_get_show_menubar:
=begin pod
=head2 [gtk_application_window_] get_show_menubar

Returns whether the window will display a menubar for the app menu
and menubar as needed.

Returns: C<1> if I<window> will display a menubar when needed

  method gtk_application_window_get_show_menubar ( --> Int )


=end pod

sub gtk_application_window_get_show_menubar ( N-GObject $window --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_window_get_id:
=begin pod
=head2 [gtk_application_window_] get_id

Returns the unique ID of the window. If the window has not yet been added to
a B<Gnome::Gtk3::Application>, returns `0`.

Returns: the unique ID for I<window>, or `0` if the window
has not yet been added to a B<Gnome::Gtk3::Application>

  method gtk_application_window_get_id ( --> UInt )


=end pod

sub gtk_application_window_get_id ( N-GObject $window --> uint32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_window_set_help_overlay:
=begin pod
=head2 [gtk_application_window_] set_help_overlay

Associates a shortcuts window with the application window, and
sets up an action with the name win.show-help-overlay to present
it.

I<window> takes resposibility for destroying I<help_overlay>.

  method gtk_application_window_set_help_overlay ( N-GObject $help_overlay )

=item N-GObject $help_overlay; (nullable): a B<Gnome::Gtk3::ShortcutsWindow>

=end pod

sub gtk_application_window_set_help_overlay ( N-GObject $window, N-GObject $help_overlay  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_application_window_get_help_overlay:
=begin pod
=head2 [gtk_application_window_] get_help_overlay

Gets the B<Gnome::Gtk3::ShortcutsWindow> that has been set up with
a prior call to C<gtk_application_window_set_help_overlay()>.

Returns: (transfer none) (nullable): the help overlay associated with I<window>, or C<Any>

  method gtk_application_window_get_help_overlay ( --> N-GObject )


=end pod

sub gtk_application_window_get_help_overlay ( N-GObject $window --> N-GObject )
  is native(&gtk-lib)
  { * }
