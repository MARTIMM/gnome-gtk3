#TL:1:Gnome::Gtk3::AppChooserWidget:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::AppChooserWidget

Application chooser widget that can be embedded in other widgets


=comment ![](images/X.png)


=head1 Description

B<Gnome::Gtk3::AppChooserWidget> is a widget for selecting applications. It is the main building block for B<Gnome::Gtk3::AppChooserDialog>. Most applications only need to use the latter; but you can use this widget as part of a larger widget if you have special needs.

B<Gnome::Gtk3::AppChooserWidget> offers detailed control over what applications
are shown, using the I<show-default>, I<show-recommended>, I<show-fallback>, I<show-other> and I<show-all> properties. See the B<Gnome::Gtk3::AppChooser> documentation for more information about these groups of applications.

To keep track of the selected application, use the I<application-selected> and  I<application-activated> signals.


=head2 Css Nodes

GtkAppChooserWidget has a single CSS node with name appchooser.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::AppChooserWidget;
  also is Gnome::Gtk3::Box;
  also does Gnome::Gtk3::AppChooser;


=head2 Uml Diagram

![](plantuml/AppChooserWidget.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::AppChooserWidget:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::AppChooserWidget;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::AppChooserWidget class process the options
    self.bless( :GtkAppChooserWidget, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gtk3::Box:api<1>;
use Gnome::Gtk3::AppChooser:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::AppChooserWidget:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Box;
also does Gnome::Gtk3::AppChooser;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :content-type

Creates a new B<Gnome::Gtk3::AppChooserWidget> for applications that can handle content of the given type.

  multi method new ( Str :$content-type! )


=head3 :native-object

Create a AppChooserWidget object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a AppChooserWidget object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

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
      :w1<application-selected application-activated>, :w2<populate-popup>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::AppChooserWidget' or
     %options<GtkAppChooserWidget> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<content-type> {
        $no = _gtk_app_chooser_widget_new(%options<content-type>);
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
        $no = _gtk_app_chooser_widget_new();
      }
      }}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkAppChooserWidget');
  }
}


#-------------------------------------------------------------------------------
#TM:1:get-default-text:
=begin pod
=head2 get-default-text

Returns the text that is shown if there are no applications that can handle the content type.

Returns: the value of  I<default-text>

  method get-default-text ( --> Str )

=end pod

method get-default-text ( --> Str ) {
  gtk_app_chooser_widget_get_default_text(self._get-native-object-no-reffing)
}

sub gtk_app_chooser_widget_get_default_text (
  N-GObject $self --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-all:
=begin pod
=head2 get-show-all

Returns the current value of the  I<show-all> property.

Returns: the value of  I<show-all>

  method get-show-all ( --> Bool )

=end pod

method get-show-all ( --> Bool ) {
  gtk_app_chooser_widget_get_show_all(self._get-native-object-no-reffing).Bool
}

sub gtk_app_chooser_widget_get_show_all (
  N-GObject $self --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-default:
=begin pod
=head2 get-show-default

Returns the current value of the  I<show-default> property.

Returns: the value of  I<show-default>

  method get-show-default ( --> Bool )

=end pod

method get-show-default ( --> Bool ) {
  gtk_app_chooser_widget_get_show_default(
    self._get-native-object-no-reffing,
  ).Bool
}

sub gtk_app_chooser_widget_get_show_default (
  N-GObject $self --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-fallback:
=begin pod
=head2 get-show-fallback

Returns the current value of the  I<show-fallback> property.

Returns: the value of  I<show-fallback>

  method get-show-fallback ( --> Bool )

=end pod

method get-show-fallback ( --> Bool ) {
  gtk_app_chooser_widget_get_show_fallback(
    self._get-native-object-no-reffing,
  ).Bool
}

sub gtk_app_chooser_widget_get_show_fallback (
  N-GObject $self --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-other:
=begin pod
=head2 get-show-other

Returns the current value of the  I<show-other> property.

Returns: the value of  I<show-other>

  method get-show-other ( --> Bool )

=end pod

method get-show-other ( --> Bool ) {
  gtk_app_chooser_widget_get_show_other(self._get-native-object-no-reffing).Bool
}

sub gtk_app_chooser_widget_get_show_other (
  N-GObject $self --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-show-recommended:
=begin pod
=head2 get-show-recommended

Returns the current value of the  I<show-recommended> property.

Returns: the value of  I<show-recommended>

  method get-show-recommended ( --> Bool )

=end pod

method get-show-recommended ( --> Bool ) {
  gtk_app_chooser_widget_get_show_recommended(
    self._get-native-object-no-reffing,
  ).Bool
}

sub gtk_app_chooser_widget_get_show_recommended (
  N-GObject $self --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-default-text:
=begin pod
=head2 set-default-text

Sets the text that is shown if there are not applications that can handle the content type.

  method set-default-text ( Str $text )

=item $text; the new value for  I<default-text>
=end pod

method set-default-text ( Str $text ) {
  gtk_app_chooser_widget_set_default_text(
    self._get-native-object-no-reffing, $text
  );
}

sub gtk_app_chooser_widget_set_default_text (
  N-GObject $self, gchar-ptr $text
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-all:
=begin pod
=head2 set-show-all

Sets whether the app chooser should show all applications in a flat list.

  method set-show-all ( Bool $setting )

=item $setting; the new value for  I<show-all>
=end pod

method set-show-all ( Bool $setting ) {
  gtk_app_chooser_widget_set_show_all(
    self._get-native-object-no-reffing, $setting
  );
}

sub gtk_app_chooser_widget_set_show_all (
  N-GObject $self, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-default:
=begin pod
=head2 set-show-default

Sets whether the app chooser should show the default handler for the content type in a separate section.

  method set-show-default ( Bool $setting )

=item $setting; the new value for  I<show-default>
=end pod

method set-show-default ( Bool $setting ) {
  gtk_app_chooser_widget_set_show_default(
    self._get-native-object-no-reffing, $setting
  );
}

sub gtk_app_chooser_widget_set_show_default (
  N-GObject $self, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-fallback:
=begin pod
=head2 set-show-fallback

Sets whether the app chooser should show related applications for the content type in a separate section.

  method set-show-fallback ( Bool $setting )

=item $setting; the new value for  I<show-fallback>
=end pod

method set-show-fallback ( Bool $setting ) {
  gtk_app_chooser_widget_set_show_fallback(
    self._get-native-object-no-reffing, $setting
  );
}

sub gtk_app_chooser_widget_set_show_fallback (
  N-GObject $self, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-other:
=begin pod
=head2 set-show-other

Sets whether the app chooser should show applications which are unrelated to the content type.

  method set-show-other ( Bool $setting )

=item $setting; the new value for  I<show-other>
=end pod

method set-show-other ( Bool $setting ) {
  gtk_app_chooser_widget_set_show_other(
    self._get-native-object-no-reffing, $setting
  );
}

sub gtk_app_chooser_widget_set_show_other (
  N-GObject $self, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-show-recommended:
=begin pod
=head2 set-show-recommended

Sets whether the app chooser should show recommended applications for the content type in a separate section.

  method set-show-recommended ( Bool $setting )

=item $setting; the new value for  I<show-recommended>
=end pod

method set-show-recommended ( Bool $setting ) {
  gtk_app_chooser_widget_set_show_recommended(
    self._get-native-object-no-reffing, $setting
  );
}

sub gtk_app_chooser_widget_set_show_recommended (
  N-GObject $self, gboolean $setting
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_app_chooser_widget_new:
#`{{
=begin pod
=head2 _gtk_app_chooser_widget_new

Creates a new B<Gnome::Gtk3::AppChooserWidget> for applications that can handle content of the given type.

Returns: a newly created B<Gnome::Gtk3::AppChooserWidget>

  method _gtk_app_chooser_widget_new ( Str $content_type --> N-GObject )

=item $content_type; the content type to show applications for
=end pod
}}

sub _gtk_app_chooser_widget_new ( gchar-ptr $content_type --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_app_chooser_widget_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:application-activated:
=head2 application-activated

Emitted when an application item is activated from the widget's list.

This usually happens when the user double clicks an item, or an item
is selected and the user presses one of the keys Space, Shift+Space,
Return or Enter.

  method handler (
    N-GObject #`{ native Gnome::Gio::AppInfo } $application,
    Gnome::Gtk3::AppChooserWidget :_widget($self),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $application; the activated B<Gnome::Gio::AppInfo>
=item $self; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:application-selected:
=head2 application-selected

Emitted when an application item is selected from the widget's list.

  method handler (
    N-GObject #`{ native Gnome::Gio::AppInfo } $application,
    Gnome::Gtk3::AppChooserWidget :_widget($self),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $application; the selected B<Gnome::Gio::AppInfo>
=item $self; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:populate-popup:
=head2 populate-popup

Emitted when a context menu is about to popup over an application item.
Clients can insert menu items into the provided B<Gnome::Gtk3::Menu> object in the
callback of this signal; the context menu will be shown over the item
if at least one item has been added to the menu.

  method handler (
    N-GObject #`{ native widget } $menu,
    N-GObject #`{ native Gnome::Gio::AppInfo } $application,
    Gnome::Gtk3::AppChooserWidget :_widget($self),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $menu; the B<Gnome::Gtk3::Menu> to populate
=item $application; the current B<Gnome::Gio::AppInfo>
=item $self; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:1:default-text:
=head2 default-text
GtkAppChooserWidgetI<default-text>:

The I<default-text> property determines the text that appears in the widget when there are no applications for the given content type. See also C<set_default_text()>.

The B<Gnome::GObject::Value> type of property I<default-text> is C<G_TYPE_STRING>.

=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:1:show-all:
=head2 show-all
GtkAppChooserWidgetI<show-all>:

If the I<show-all> property is C<True>, the app chooser presents all applications in a single list, without subsections for default, recommended or related applications.

The B<Gnome::GObject::Value> type of property I<show-all> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Parameter is set on construction of object.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:show-default:
=head2 show-default

The I<show-default> property determines whether the app chooser should show the default handler for the content type in a separate section. If C<False>, the default handler is listed among the recommended applications.

The B<Gnome::GObject::Value> type of property I<show-default> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Parameter is set on construction of object.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:show-fallback:
=head2 show-fallback
GtkAppChooserWidgetI<show-fallback>:

The I<show-fallback> property determines whether the app chooser should show a section for fallback applications. If C<False>, the fallback applications are listed among the other applications.

The B<Gnome::GObject::Value> type of property I<show-fallback> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Parameter is set on construction of object.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:show-other:
=head2 show-other
GtkAppChooserWidgetI<show-other>:

The I<show-other> property determines whether the app chooser should show a section for other applications.

The B<Gnome::GObject::Value> type of property I<show-other> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Parameter is set on construction of object.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:show-recommended:
=head2 show-recommended
GtkAppChooserWidgetI<show-recommended>:

The I<show-recommended> property determines whether the app chooser should show a section for recommended applications. If C<False>, the recommended applications are listed among the other applications.

The B<Gnome::GObject::Value> type of property I<show-recommended> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Parameter is set on construction of object.
=item Default value is TRUE.

=end pod
