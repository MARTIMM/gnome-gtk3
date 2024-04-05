#TL:1:Gnome::Gtk3::Expander:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Expander

A container which can hide its child


=comment ![](images/X.png)


=head1 Description

A B<Gnome::Gtk3::Expander> allows the user to hide or show its child by clicking on an expander triangle similar to the triangles used in a B<Gnome::Gtk3::TreeView>.

Normally you use an expander as you would use any other descendant of B<Gnome::Gtk3::Bin>; you create the child widget and use C<add()> to add it to the expander. When the expander is toggled, it will take care of showing and hiding the child automatically.


=begin comment
=head2 Special Usage

There are situations in which you may prefer to show and hide the expanded widget yourself, such as when you want to actually create the widget at expansion time. In this case, create a B<Gnome::Gtk3::Expander> but do not add a child to it. The expander widget has an I<expanded> property which can be used to monitor its expansion state. You should watch this property with a signal connection as follows:

  method init-expander( Gnome::Gtk::Expander :_widget($expander) ) {
    if $expander.get-expanded {
      # Show or create widgets
    }

    else {
      # Hide or destroy widgets
    }
  }

  method create-expander ( ) {
    my Gnome::Gtk::Expander $expander .= new(:mnemonic("_More Options"));
    $expander.register-signal( self, 'init-expander', 'notify::expanded');
  }
=end comment


=head2 B<Gnome::Gtk3::Expander> as B<Gnome::Gtk3::Buildable>

The B<Gnome::Gtk3::Expander> implementation of the B<Gnome::Gtk3::Buildable> interface supports placing a child in the label position by specifying “label” as the “type” attribute of a <child> element. A normal content child can be specified without specifying a <child> type attribute.

An example of a UI definition fragment with GtkExpander:

  <object class="GtkExpander">
    <child type="label">
      <object class="GtkLabel" id="expander-label"/>
    </child>
    <child>
      <object class="GtkEntry" id="expander-content"/>
    </child>
  </object>


=head2 Css Nodes

  expander
  ├── title
  │  ├── arrow
  │  ╰── <label widget>
  ╰── <child>


B<Gnome::Gtk3::Expander> has three CSS nodes, the main node with the name expander, a subnode with name title and node below it with name arrow. The arrow of an expander that is showing its child gets the :checked pseudoclass added to it.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Expander;
  also is Gnome::Gtk3::Bin;


=head2 Uml Diagram

![](plantuml/Expander.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Expander:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Expander;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Expander class process the options
    self.bless( :GtkExpander, |c);
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
use Gnome::Gtk3::Bin:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Expander:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 :label

Create a new Expander object using I<label> as the text of the label.

  multi method new ( Str :$label! )


=head3 :mnemonic

Creates a new expander using I<label> as the text of the label. If characters in I<label> are preceded by an underscore, they are underlined. If you need a literal underscore character in a label, use “__” (two underscores). The first underlined character represents a keyboard accelerator called a mnemonic. Pressing Alt and that key activates the button.

  multi method new ( Str :$mnemonic! )


=head3 :native-object

Create a Expander object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a Expander object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:1:new(:label)
#TM:1:new(:mnemonic)
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<activate>,
    );
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Expander'or %options<GtkExpander> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my N-GObject $no;
      if ? %options<label> {
        $no = _gtk_expander_new(%options<label>);
      }

      elsif ? %options<mnemonic> {
        $no = _gtk_expander_new_with_mnemonic(%options<mnemonic>);
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

      ##`{{  when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      # }}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_expander_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkExpander');
  }
}

#-------------------------------------------------------------------------------
#TM:1:get-expanded:
=begin pod
=head2 get-expanded

Queries a B<Gnome::Gtk3::Expander> and returns its current state. Returns C<True> if the child widget is revealed.

See C<set_expanded()>.

Returns: the current state of the expander

  method get-expanded ( --> Bool )

=end pod

method get-expanded ( --> Bool ) {
  gtk_expander_get_expanded( self._get-native-object-no-reffing).Bool
}

sub gtk_expander_get_expanded (
  N-GObject $expander --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-label:
=begin pod
=head2 get-label

Fetches the text from a label widget including any embedded underlines indicating mnemonics and Pango markup, as set by C<set_label()>. If the label text has not been set the return value will be C<undefined>. This will be the case if you create an empty button with C<gtk_button_new()> to use as a container.

Note that this function behaved differently in versions prior to 2.14 and used to return the label text stripped of embedded underlines indicating mnemonics and Pango markup. This problem can be avoided by fetching the label text directly from the label widget.

Returns: The text of the label widget. This string is owned by the widget and must not be modified or freed.

  method get-label ( --> Str )

=end pod

method get-label ( --> Str ) {
  gtk_expander_get_label( self._get-native-object-no-reffing)
}

sub gtk_expander_get_label (
  N-GObject $expander --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-label-fill:
=begin pod
=head2 get-label-fill

Returns whether the label widget will fill all available horizontal space allocated to this expander.

Returns: C<True> if the label widget will fill all available horizontal space

  method get-label-fill ( --> Bool )

=end pod

method get-label-fill ( --> Bool ) {
  gtk_expander_get_label_fill( self._get-native-object-no-reffing).Bool
}

sub gtk_expander_get_label_fill (
  N-GObject $expander --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-label-widget:
=begin pod
=head2 get-label-widget

Retrieves the label widget for the frame. See C<set_label_widget()>.

Returns: the label widget, or C<undefined> if there is none

  method get-label-widget ( --> N-GObject )

=end pod

method get-label-widget ( --> N-GObject ) {
  gtk_expander_get_label_widget( self._get-native-object-no-reffing)
}

sub gtk_expander_get_label_widget (
  N-GObject $expander --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-resize-toplevel:
=begin pod
=head2 get-resize-toplevel

Returns whether the expander will resize the toplevel widget containing the expander upon resizing and collpasing.

Returns: the “resize toplevel” setting.

  method get-resize-toplevel ( --> Bool )

=end pod

method get-resize-toplevel ( --> Bool ) {
  gtk_expander_get_resize_toplevel( self._get-native-object-no-reffing).Bool
}

sub gtk_expander_get_resize_toplevel (
  N-GObject $expander --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-spacing:
=begin pod
=head2 get-spacing

Gets the value set by C<set_spacing()>.

Returns: spacing between the expander and child



Deprecated: 3.20: Use margins on the child instead.

  method get-spacing ( --> Int )

=end pod

method get-spacing ( --> Int ) {
  gtk_expander_get_spacing( self._get-native-object-no-reffing)
}

sub gtk_expander_get_spacing (
  N-GObject $expander --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-use-markup:
=begin pod
=head2 get-use-markup

Returns whether the label’s text is interpreted as marked up with the [Pango text markup language][PangoMarkupFormat]. See C<set_use_markup()>.

Returns: C<True> if the label’s text will be parsed for markup

  method get-use-markup ( --> Bool )

=end pod

method get-use-markup ( --> Bool ) {
  gtk_expander_get_use_markup( self._get-native-object-no-reffing).Bool
}

sub gtk_expander_get_use_markup (
  N-GObject $expander --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-use-underline:
=begin pod
=head2 get-use-underline

Returns whether an embedded underline in the expander label indicates a mnemonic. See C<set_use_underline()>.

Returns: C<True> if an embedded underline in the expander label indicates the mnemonic accelerator keys

  method get-use-underline ( --> Bool )

=end pod

method get-use-underline ( --> Bool ) {
  gtk_expander_get_use_underline( self._get-native-object-no-reffing).Bool
}

sub gtk_expander_get_use_underline (
  N-GObject $expander --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-expanded:
=begin pod
=head2 set-expanded

Sets the state of the expander. Set to C<True>, if you want the child widget to be revealed, and C<False> if you want the child widget to be hidden.

  method set-expanded ( Bool $expanded )

=item $expanded; whether the child widget is revealed
=end pod

method set-expanded ( Bool $expanded ) {
  gtk_expander_set_expanded( self._get-native-object-no-reffing, $expanded);
}

sub gtk_expander_set_expanded (
  N-GObject $expander, gboolean $expanded
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-label:
=begin pod
=head2 set-label

Sets the text of the label of the expander to I<label>.

This will also clear any previously set labels.

  method set-label ( Str $label )

=item $label; a string
=end pod

method set-label ( Str $label ) {
  gtk_expander_set_label( self._get-native-object-no-reffing, $label);
}

sub gtk_expander_set_label (
  N-GObject $expander, gchar-ptr $label
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-label-fill:
=begin pod
=head2 set-label-fill

Sets whether the label widget should fill all available horizontal space allocated to I<expander>.

Note that this function has no effect since 3.20.

  method set-label-fill ( Bool $label_fill )

=item $label_fill; C<True> if the label should should fill all available horizontal space
=end pod

method set-label-fill ( Bool $label_fill ) {
  gtk_expander_set_label_fill( self._get-native-object-no-reffing, $label_fill);
}

sub gtk_expander_set_label_fill (
  N-GObject $expander, gboolean $label_fill
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-label-widget:
=begin pod
=head2 set-label-widget

Set the label widget for the expander. This is the widget that will appear embedded alongside the expander arrow.

  method set-label-widget ( N-GObject() $label_widget )

=item $label_widget; the new label widget
=end pod

method set-label-widget ( N-GObject() $label_widget ) {
  gtk_expander_set_label_widget( self._get-native-object-no-reffing, $label_widget);
}

sub gtk_expander_set_label_widget (
  N-GObject $expander, N-GObject $label_widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-resize-toplevel:
=begin pod
=head2 set-resize-toplevel

Sets whether the expander will resize the toplevel widget containing the expander upon resizing and collpasing.

  method set-resize-toplevel ( Bool $resize_toplevel )

=item $resize_toplevel; whether to resize the toplevel
=end pod

method set-resize-toplevel ( Bool $resize_toplevel ) {
  gtk_expander_set_resize_toplevel( self._get-native-object-no-reffing, $resize_toplevel);
}

sub gtk_expander_set_resize_toplevel (
  N-GObject $expander, gboolean $resize_toplevel
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-spacing:
=begin pod
=head2 set-spacing

Sets the spacing field of I<expander>, which is the number of pixels to place between expander and the child.



Deprecated: 3.20: Use margins on the child instead.

  method set-spacing ( Int() $spacing )

=item $spacing; distance between the expander and child in pixels
=end pod

method set-spacing ( Int() $spacing ) {
  gtk_expander_set_spacing( self._get-native-object-no-reffing, $spacing);
}

sub gtk_expander_set_spacing (
  N-GObject $expander, gint $spacing
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-use-markup:
=begin pod
=head2 set-use-markup

Sets whether the text of the label contains markup in [Pango’s text markup language][PangoMarkupFormat]. See C<gtk_label_set_markup()>.

  method set-use-markup ( Bool $use_markup )

=item $use_markup; C<True> if the label’s text should be parsed for markup
=end pod

method set-use-markup ( Bool $use_markup ) {
  gtk_expander_set_use_markup( self._get-native-object-no-reffing, $use_markup);
}

sub gtk_expander_set_use_markup (
  N-GObject $expander, gboolean $use_markup
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-use-underline:
=begin pod
=head2 set-use-underline

If true, an underline in the text of the expander label indicates the next character should be used for the mnemonic accelerator key.

  method set-use-underline ( Bool $use_underline )

=item $use_underline; C<True> if underlines in the text indicate mnemonics
=end pod

method set-use-underline ( Bool $use_underline ) {
  gtk_expander_set_use_underline( self._get-native-object-no-reffing, $use_underline);
}

sub gtk_expander_set_use_underline (
  N-GObject $expander, gboolean $use_underline
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_expander_new:
#`{{
=begin pod
=head2 _gtk_expander_new

Creates a new expander using I<label> as the text of the label.

Returns: a new B<Gnome::Gtk3::Expander> widget.

  method _gtk_expander_new ( Str $label --> N-GObject )

=item $label; the text of the label
=end pod
}}

sub _gtk_expander_new ( gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_expander_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_expander_new_with_mnemonic:
#`{{
=begin pod
=head2 _gtk_expander_new_with_mnemonic

Creates a new expander using I<label> as the text of the label. If characters in I<label> are preceded by an underscore, they are underlined. If you need a literal underscore character in a label, use “__” (two underscores). The first underlined character represents a keyboard accelerator called a mnemonic. Pressing Alt and that key activates the button.

Returns: a new B<Gnome::Gtk3::Expander> widget.

  method _gtk_expander_new_with_mnemonic ( Str $label --> N-GObject )

=item $label; the text of the label with an underscore in front of the mnemonic character
=end pod
}}

sub _gtk_expander_new_with_mnemonic ( gchar-ptr $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_expander_new_with_mnemonic')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:activate:
=head2 activate

  method handler (
    Gnome::Gtk3::Expander :_widget($expander),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $expander; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:0:expanded:
=head2 expanded

Whether the expander has been opened to reveal the child widget

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Parameter is set on construction of object.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:label:
=head2 label

Text of the expander's label

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Parameter is set on construction of object.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:label-fill:
=head2 label-fill

Whether the label widget should fill all available horizontal space

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Parameter is set on construction of object.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:label-widget:
=head2 label-widget

A widget to display in place of the usual expander label

=item B<Gnome::GObject::Value> type of this property is G_TYPE_OBJECT
=item The type of this G_TYPE_OBJECT object is GTK_TYPE_WIDGET
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:resize-toplevel:
=head2 resize-toplevel

Whether the expander will resize the toplevel window upon expanding and collapsing

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:use-markup:
=head2 use-markup

The text of the label includes XML markup. See C<pango_parse_markup()>

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Parameter is set on construction of object.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:use-underline:
=head2 use-underline

If set, an underline in the text indicates the next character should be used for the mnemonic accelerator key

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Parameter is set on construction of object.
=item Default value is FALSE.

=end pod
