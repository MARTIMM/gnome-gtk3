#TL:1:Gnome::Gtk3::HeaderBar:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::HeaderBar

A box with a centered child


![](images/headerbar.png)


=head1 Description

GtkHeaderBar is similar to a horizontal B<Gnome::Gtk3::Box>. It allows children to be placed at the start or the end. In addition, it allows a title and subtitle to be displayed. The title will be centered with respect to the width of the box, even if the children at either side take up different amounts of space. The height of the titlebar will be set to provide sufficient space for the subtitle, even if none is currently set. If a subtitle is not needed, the space reservation can be turned off with C<set-has-subtitle()>.

GtkHeaderBar can add typical window frame controls, such as minimize, maximize and close buttons, or the window icon.

For these reasons, GtkHeaderBar is the natural choice for use as the custom titlebar widget of a B<Gnome::Gtk3::Window> (see C<gtk-window-set-titlebar()>), as it gives  features typical of titlebars while allowing the addition of child widgets.


=head2 See Also

B<Gnome::Gtk3::Box>, B<Gnome::Gtk3::ActionBar>


=head1 Synopsis

=head2 Declaration

  unit class Gnome::Gtk3::HeaderBar;
  also is Gnome::Gtk3::Container;


=head2 Uml Diagram

![](plantuml/HeaderBar.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::HeaderBar;

  unit class MyGuiClass;
  also is Gnome::Gtk3::HeaderBar;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::HeaderBar class process the options
    self.bless( :GtkHeaderBar, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::HeaderBar:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::Gtk3::Container;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new HeaderBar object.

  multi method new ( )

=head3 :native-object

Create a HeaderBar object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a HeaderBar object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::HeaderBar' or %options<GtkHeaderBar> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
#        $no = %options<___x___>;
#        $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
#        #$no = _gtk_header_bar_new___x___($no);
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
        $no = _gtk_header_bar_new;
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkHeaderBar');
  }
}


#-------------------------------------------------------------------------------
#TM:1:get-custom-title:
#TM:1:get-custom-title-rk:
=begin pod
=head2 get-custom-title, get-custom-title-rk

Retrieves the custom title widget of the header. See C<set-custom-title()>.

Returns: the custom title widget of the header, or C<undefined> if none has been set explicitly.

  method get-custom-title ( --> N-GObject )
  method get-custom-title-rk ( :$child-type? --> Gnome::Gtk3::Widget )

=item $child-type: This is an optional argument. You can specify a real type or a type as a string. In the latter case the type must be defined in a module which can be found by the Raku require call.

=end pod

method get-custom-title ( --> N-GObject ) {
  gtk_header_bar_get_custom_title(self.get-native-object-no-reffing)
}

method get-custom-title-rk ( *%options --> Any ) {
  self._wrap-native-type-from-no(
    gtk_header_bar_get_custom_title(self.get-native-object-no-reffing),
    |%options
  )
}

sub gtk_header_bar_get_custom_title (
  N-GObject $bar --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-decoration-layout:
=begin pod
=head2 get-decoration-layout

Gets the decoration layout set with C<set-decoration-layout()>.

Returns: the decoration layout

  method get-decoration-layout ( --> Str )

=end pod

method get-decoration-layout ( --> Str ) {
  gtk_header_bar_get_decoration_layout(self.get-native-object-no-reffing)
}

sub gtk_header_bar_get_decoration_layout (
  N-GObject $bar --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-has-subtitle:
=begin pod
=head2 get-has-subtitle

Retrieves whether the header bar reserves space for a subtitle, regardless if one is currently set or not.

Returns: C<True> if the header bar reserves space for a subtitle

  method get-has-subtitle ( --> Bool )

=end pod

method get-has-subtitle ( --> Bool ) {

  gtk_header_bar_get_has_subtitle(
    self.get-native-object-no-reffing,
  ).Bool
}

sub gtk_header_bar_get_has_subtitle (
  N-GObject $bar --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-close-button:
=begin pod
=head2 get-show-close-button

Returns whether this header bar shows the standard window decorations.

Returns: C<True> if the decorations are shown

  method get-show-close-button ( --> Bool )

=end pod

method get-show-close-button ( --> Bool ) {
  gtk_header_bar_get_show_close_button(self.get-native-object-no-reffing).Bool
}

sub gtk_header_bar_get_show_close_button (
  N-GObject $bar --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-subtitle:
=begin pod
=head2 get-subtitle

Retrieves the subtitle of the header. See C<set-subtitle()>.

Returns: the subtitle of the header, or C<undefined> if none has been set explicitly. The returned string is owned by the widget and must not be modified or freed.

  method get-subtitle ( --> Str )

=end pod

method get-subtitle ( --> Str ) {
  gtk_header_bar_get_subtitle(self.get-native-object-no-reffing)
}

sub gtk_header_bar_get_subtitle (
  N-GObject $bar --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-title:
=begin pod
=head2 get-title

Retrieves the title of the header. See C<set-title()>.

Returns: the title of the header, or C<undefined> if none has been set explicitly. The returned string is owned by the widget and must not be modified or freed.

  method get-title ( --> Str )

=end pod

method get-title ( --> Str ) {

  gtk_header_bar_get_title(
    self.get-native-object-no-reffing,
  )
}

sub gtk_header_bar_get_title (
  N-GObject $bar --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:pack-end:
=begin pod
=head2 pack-end

Adds I<child> to I<bar>, packed with reference to the end of the I<bar>.

  method pack-end ( N-GObject $child )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to be added to I<bar>
=end pod

method pack-end ( $child is copy ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_header_bar_pack_end(
    self.get-native-object-no-reffing, $child
  );
}

sub gtk_header_bar_pack_end (
  N-GObject $bar, N-GObject $child
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:pack-start:
=begin pod
=head2 pack-start

Adds I<child> to I<bar>, packed with reference to the start of the I<bar>.

  method pack-start ( N-GObject $child )

=item N-GObject $child; the B<Gnome::Gtk3::Widget> to be added to I<bar>
=end pod

method pack-start ( $child is copy ) {
  $child .= get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_header_bar_pack_start(
    self.get-native-object-no-reffing, $child
  );
}

sub gtk_header_bar_pack_start (
  N-GObject $bar, N-GObject $child
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-custom-title:
=begin pod
=head2 set-custom-title

Sets a custom title for the B<Gnome::Gtk3::HeaderBar>.

The title should help a user identify the current view. This supersedes any title set by C<set-title()> or C<gtk-header-bar-set-subtitle()>. To achieve the same style as the builtin title and subtitle, use the “title” and “subtitle” style classes.

You should set the custom title to C<undefined>, for the header title label to be visible again.

  method set-custom-title ( N-GObject $title_widget )

=item N-GObject $title_widget; a custom widget to use for a title
=end pod

method set-custom-title ( $title_widget is copy ) {
  $title_widget .= get-native-object-no-reffing unless $title_widget ~~ N-GObject;

  gtk_header_bar_set_custom_title(
    self.get-native-object-no-reffing, $title_widget
  );
}

sub gtk_header_bar_set_custom_title (
  N-GObject $bar, N-GObject $title_widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-decoration-layout:
=begin pod
=head2 set-decoration-layout

Sets the decoration layout for this header bar, overriding the  I<gtk-decoration-layout> setting.

There can be valid reasons for overriding the setting, such as a header bar design that does not allow for buttons to take room on the right, or only offers room for a single close button. Split header bars are another example for overriding the setting.

The format of the string is button names, separated by commas. A colon separates the buttons that should appear on the left from those on the right. Recognized button names are minimize, maximize, close, icon (the window icon) and menu (a menu button for the fallback app menu).

For example, “menu:minimize,maximize,close” specifies a menu on the left, and minimize, maximize and close buttons on the right.

  method set-decoration-layout ( Str $layout )

=item Str $layout; a decoration layout, or C<undefined> to unset the layout
=end pod

method set-decoration-layout ( Str $layout ) {
  gtk_header_bar_set_decoration_layout(
    self.get-native-object-no-reffing, $layout
  );
}

sub gtk_header_bar_set_decoration_layout (
  N-GObject $bar, gchar-ptr $layout
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-has-subtitle:
=begin pod
=head2 set-has-subtitle

Sets whether the header bar should reserve space for a subtitle, even if none is currently set.

  method set-has-subtitle ( Bool $setting )

=item Bool $setting; C<True> to reserve space for a subtitle
=end pod

method set-has-subtitle ( Bool $setting ) {

  gtk_header_bar_set_has_subtitle(
    self.get-native-object-no-reffing, $setting
  );
}

sub gtk_header_bar_set_has_subtitle (
  N-GObject $bar, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-close-button:
=begin pod
=head2 set-show-close-button

Sets whether this header bar shows the standard window decorations, including close, maximize, and minimize.

  method set-show-close-button ( Bool $setting )

=item Bool $setting; C<True> to show standard window decorations
=end pod

method set-show-close-button ( Bool $setting ) {
  gtk_header_bar_set_show_close_button(
    self.get-native-object-no-reffing, $setting
  );
}

sub gtk_header_bar_set_show_close_button (
  N-GObject $bar, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-subtitle:
=begin pod
=head2 set-subtitle

Sets the subtitle of the B<Gnome::Gtk3::HeaderBar>. The title should give a user an additional detail to help him identify the current view.

Note that GtkHeaderBar by default reserves room for the subtitle, even if none is currently set. If this is not desired, set the  I<has-subtitle> property to C<False>.

  method set-subtitle ( Str $subtitle )

=item Str $subtitle; a subtitle, or C<undefined>
=end pod

method set-subtitle ( Str $subtitle ) {
  gtk_header_bar_set_subtitle( self.get-native-object-no-reffing, $subtitle);
}

sub gtk_header_bar_set_subtitle (
  N-GObject $bar, gchar-ptr $subtitle
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-title:
=begin pod
=head2 set-title

Sets the title of the B<Gnome::Gtk3::HeaderBar>. The title should help a user identify the current view. A good title should not include the application name.

  method set-title ( Str $title )

=item Str $title; a title, or C<undefined>
=end pod

method set-title ( Str $title ) {

  gtk_header_bar_set_title(
    self.get-native-object-no-reffing, $title
  );
}

sub gtk_header_bar_set_title (
  N-GObject $bar, gchar-ptr $title
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_header_bar_new:
#`{{
=begin pod
=head2 _gtk_header_bar_new

Creates a new B<Gnome::Gtk3::HeaderBar> widget.

Returns: a new B<Gnome::Gtk3::HeaderBar>

  method _gtk_header_bar_new ( --> N-GObject )

=end pod
}}

sub _gtk_header_bar_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_header_bar_new')
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
=comment #TP:0:custom-title:
=head3 Custom Title: custom-title

Custom title widget to display
Widget type: GTK-TYPE-WIDGET

The B<Gnome::GObject::Value> type of property I<custom-title> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:decoration-layout:
=head3 Decoration Layout: decoration-layout

The decoration layout for buttons. If this property is
not set, the  I<gtk-decoration-layout> setting
is used.

See C<set-decoration-layout()> for information
about the format of this string.


The B<Gnome::GObject::Value> type of property I<decoration-layout> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:decoration-layout-set:
=head3 Decoration Layout Set: decoration-layout-set

Set to C<True> if  I<decoration-layout> is set.


The B<Gnome::GObject::Value> type of property I<decoration-layout-set> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:has-subtitle:
=head3 Has Subtitle: has-subtitle

If C<True>, reserve space for a subtitle, even if none is currently set.

The B<Gnome::GObject::Value> type of property I<has-subtitle> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:show-close-button:
=head3 Show decorations: show-close-button

Whether to show window decorations.

Which buttons are actually shown and where, is determined by the  I<decoration-layout> property, and by the state of the window (e.g. a close button will not be shown if the window can't be closed).

The B<Gnome::GObject::Value> type of property I<show-close-button> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:spacing:
=head3 Spacing: spacing

The B<Gnome::GObject::Value> type of property I<spacing> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:subtitle:
=head3 Subtitle: subtitle

The subtitle to display
Default value: Any

The B<Gnome::GObject::Value> type of property I<subtitle> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:title:
=head3 Title: title

The title to display
Default value: Any

The B<Gnome::GObject::Value> type of property I<title> is C<G_TYPE_STRING>.
=end pod
