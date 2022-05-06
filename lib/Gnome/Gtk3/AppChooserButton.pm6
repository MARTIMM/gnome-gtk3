#TL:1:Gnome::Gtk3::AppChooserButton:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::AppChooserButton

A button to launch an application chooser dialog


![](images/appchooserbutton.png)


=head1 Description

The B<Gnome::Gtk3::AppChooserButton> is a widget that lets the user select an application. It implements the B<Gnome::Gtk3::AppChooser> interface.

Initially, a B<Gnome::Gtk3::AppChooserButton> selects the first application in its list, which will either be the most-recently used application or, if  I<show-default-item> property is C<True>, the default application.

The list of applications shown in a B<Gnome::Gtk3::AppChooserButton> includes the recommended applications for the given content type. When  I<show-default-item> is set, the default application is also included. To let the user choose other applications, you can set the  I<show-dialog-item> property, which allows to open a full B<Gnome::Gtk3::AppChooserDialog>.

It is possible to add custom items to the list, using C<append-custom-item()>. These items cause the  I<custom-item-activated> signal to be emitted when they are selected.

To track changes in the selected application, use the I<changed> signal.


=head1 Synopsis

=head2 Declaration

  unit class Gnome::Gtk3::AppChooserButton;
  also is Gnome::Gtk3::ComboBox;
  also does Gnome::Gtk3::AppChooser;


=head2 Uml Diagram

![](plantuml/ComboBox-ea.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::AppChooserButton;

  unit class MyGuiClass;
  also is Gnome::Gtk3::AppChooserButton;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::AppChooserButton class process the options
    self.bless( :GtkAppChooserButton, |c);
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

use Gnome::Gtk3::ComboBox;
use Gnome::Gtk3::AppChooser;


#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::AppChooserButton:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::Gtk3::ComboBox;
also does Gnome::Gtk3::AppChooser;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :content-type

Creates a new B<Gnome::Gtk3::AppChooserButton> for applications that can handle content of the given type.

  multi method new ( Str :$content-type! )


=head3 :native-object

Create a AppChooserButton object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a AppChooserButton object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new(:content-type):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w1<custom-item-activated>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::AppChooserButton' or
     %options<GtkAppChooserButton>
  {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<content-type> {
        $no = _gtk_app_chooser_button_new(%options<content-type>);
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

      ##`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      #}}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_app_chooser_button_new();
      }
      }}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkAppChooserButton');
  }
}

#-------------------------------------------------------------------------------
#TM:1:append-custom-item:
=begin pod
=head2 append-custom-item

Appends a custom item to the list of applications that is shown in the popup; the item name must be unique per-widget. Clients can use the provided name as a detail for the  I<custom-item-activated> signal, to add a callback for the activation of a particular custom item in the list. See also C<append-separator()>.

  method append-custom-item ( Str $name, Str $label, N-GObject() $icon )

=item $name; the name of the custom item
=item $label; the label for the custom item
=item $icon; the icon for the custom item
=end pod

method append-custom-item ( Str $name, Str $label, N-GObject() $icon ) {
  gtk_app_chooser_button_append_custom_item(
    self._get-native-object-no-reffing, $name, $label, $icon
  );
}

sub gtk_app_chooser_button_append_custom_item (
  N-GObject $self, gchar-ptr $name, gchar-ptr $label, N-GObject $icon
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:append-separator:
=begin pod
=head2 append-separator

Appends a separator to the list of applications that is shown in the popup.

  method append-separator ( )

=end pod

method append-separator ( ) {
  gtk_app_chooser_button_append_separator(self._get-native-object-no-reffing);
}

sub gtk_app_chooser_button_append_separator (
  N-GObject $self
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-heading:
=begin pod
=head2 get-heading

Returns the text to display at the top of the dialog.

Returns: the text to display at the top of the dialog, or C<undefined>, in which case a default text is displayed

  method get-heading ( --> Str )

=end pod

method get-heading ( --> Str ) {
  gtk_app_chooser_button_get_heading(self._get-native-object-no-reffing)
}

sub gtk_app_chooser_button_get_heading (
  N-GObject $self --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-default-item:
=begin pod
=head2 get-show-default-item

Returns the current value of the  I<show-default-item> property.

Returns: the value of  I<show-default-item>

  method get-show-default-item ( --> Bool )

=end pod

method get-show-default-item ( --> Bool ) {
  gtk_app_chooser_button_get_show_default_item(
    self._get-native-object-no-reffing,
  ).Bool
}

sub gtk_app_chooser_button_get_show_default_item (
  N-GObject $self --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-dialog-item:
=begin pod
=head2 get-show-dialog-item

Returns the current value of the  I<show-dialog-item> property.

Returns: the value of  I<show-dialog-item>

  method get-show-dialog-item ( --> Bool )

=end pod

method get-show-dialog-item ( --> Bool ) {
  gtk_app_chooser_button_get_show_dialog_item(
    self._get-native-object-no-reffing,
  ).Bool
}

sub gtk_app_chooser_button_get_show_dialog_item (
  N-GObject $self --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-active-custom-item:
=begin pod
=head2 set-active-custom-item

Selects a custom item previously added with C<append-custom-item()>.

Use C<Gnome::Gtk3::AppChooser.refresh()> to bring the selection to its initial state.

  method set-active-custom-item ( Str $name )

=item $name; the name of the custom item
=end pod

method set-active-custom-item ( Str $name ) {
  gtk_app_chooser_button_set_active_custom_item(
    self._get-native-object-no-reffing, $name
  );
}

sub gtk_app_chooser_button_set_active_custom_item (
  N-GObject $self, gchar-ptr $name
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-heading:
=begin pod
=head2 set-heading

Sets the text to display at the top of the dialog. If the heading is not set, the dialog displays a default text.

  method set-heading ( Str $heading )

=item $heading; a string containing Pango markup
=end pod

method set-heading ( Str $heading ) {
  gtk_app_chooser_button_set_heading(
    self._get-native-object-no-reffing, $heading
  );
}

sub gtk_app_chooser_button_set_heading (
  N-GObject $self, gchar-ptr $heading
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-default-item:
=begin pod
=head2 set-show-default-item

Sets whether the dropdown menu of this button should show the default application for the given content type at top.

  method set-show-default-item ( Bool $setting )

=item $setting; the new value for  I<show-default-item>
=end pod

method set-show-default-item ( Bool $setting ) {
  gtk_app_chooser_button_set_show_default_item(
    self._get-native-object-no-reffing, $setting
  );
}

sub gtk_app_chooser_button_set_show_default_item (
  N-GObject $self, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-dialog-item:
=begin pod
=head2 set-show-dialog-item

Sets whether the dropdown menu of this button should show an entry to trigger a B<Gnome::Gtk3::AppChooserDialog>.

  method set-show-dialog-item ( Bool $setting )

=item $setting; the new value for  I<show-dialog-item>
=end pod

method set-show-dialog-item ( Bool $setting ) {
  gtk_app_chooser_button_set_show_dialog_item(
    self._get-native-object-no-reffing, $setting
  );
}

sub gtk_app_chooser_button_set_show_dialog_item (
  N-GObject $self, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_app_chooser_button_new:
#`{{
=begin pod
=head2 _gtk_app_chooser_button_new

Creates a new B<Gnome::Gtk3::AppChooserButton> for applications that can handle content of the given type.

Returns: a newly created B<Gnome::Gtk3::AppChooserButton>

  method _gtk_app_chooser_button_new ( Str $content_type --> N-GObject )

=item $content_type; the content type to show applications for
=end pod
}}

sub _gtk_app_chooser_button_new ( gchar-ptr $content_type --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_app_chooser_button_new')
  { * }


#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

=comment -----------------------------------------------------------------------
=comment #TS:0:custom-item-activated:
=head2 custom-item-activated

Emitted when a custom item, previously added with C<append_custom_item()>, is activated from the dropdown menu.

  method handler (
    Str $item_name,
    Gnome::Gtk3::AppChooserButton :_widget($button),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $item_name; the name of the activated item
=item $button; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:0:heading:
=head2 heading

The text to show at the top of the dialog

The B<Gnome::GObject::Value> type of property I<heading> is C<G_TYPE_STRING>.

=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:show-default-item:
=head2 show-default-item

Whether the combobox should show the default application on top

The B<Gnome::GObject::Value> type of property I<show-default-item> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Parameter is set on construction of object.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:show-dialog-item:
=head2 show-dialog-item

Whether the combobox should include an item that triggers a GtkAppChooserDialog

The B<Gnome::GObject::Value> type of property I<show-dialog-item> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Parameter is set on construction of object.
=item Default value is FALSE.

=end pod
