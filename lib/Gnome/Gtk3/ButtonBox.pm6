#TL:1:Gnome::Gtk3::ButtonBox:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ButtonBox

A container for arranging buttons

![](images/buttonbox.png)

=head1 Description


A button box should be used to provide a consistent layout of buttons throughout your application. The layout/spacing can be altered by the programmer, or if desired, by the user to alter the “feel” of a program to a small degree.

C<get-layout()> and C<set-layout()> retrieve and alter the method used to spread the buttons in a button box across the container, respectively.

The main purpose of GtkButtonBox is to make sure the children have all the same size. GtkButtonBox gives all children the same size, but it does allow 'outliers' to keep their own larger size.

To exempt individual children from homogeneous sizing regardless of their 'outlier' status, you can set the non-homogeneous child property.


=head2 Css Nodes

GtkButtonBox uses a single CSS node with name buttonbox.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ButtonBox;
  also is Gnome::Gtk3::Box;


=head2 Uml Diagram

![](plantuml/ButtonBox.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::ButtonBox;

  unit class MyGuiClass;
  also is Gnome::Gtk3::ButtonBox;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::ButtonBox class process the options
    self.bless( :GtkButtonBox, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=head2 Example

The below example creates a ButtonBox with 4 buttons. The result is shown in the picture at the start of this document.

  my Gnome::Gtk3::ButtonBox $bb .= new;
  $bb.set-layout(GTK_BUTTONBOX_EXPAND);

  my Gnome::Gtk3::Button $button1 .= new(:label<Start>);
  $bb.add($button1);
  my Gnome::Gtk3::Button $button2 .= new(:label<Stop>);
  $bb.add($button2);

  my Gnome::Gtk3::Button $button3 .= new(:label<Foo>);
  $bb.add($button3);
  $bb.set-child-secondary( $button3, True);
  my Gnome::Gtk3::Button $button4 .= new(:label<Bar>);
  $bb.add($button4);
  $bb.set-child-secondary( $button4, True);

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::Box;
use Gnome::Gtk3::Enums;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::ButtonBox:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::Gtk3::Box;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkButtonBoxStyle

Used to dictate the style that a B<Gnome::Gtk3::ButtonBox> uses to layout the buttons it contains.

=item GTK-BUTTONBOX-SPREAD: Buttons are evenly spread across the box.
=item GTK-BUTTONBOX-EDGE: Buttons are placed at the edges of the box.
=item GTK-BUTTONBOX-START: Buttons are grouped towards the start of the box, (on the left or at the top).
=item GTK-BUTTONBOX-END: Buttons are grouped towards the end of the box, (on the right or at the bottom).
=item GTK-BUTTONBOX-CENTER: Buttons are centered in the box.
=item GTK-BUTTONBOX-EXPAND: Buttons expand to fill the box. This entails giving buttons a "linked" appearance, making button sizes homogeneous, and setting spacing to 0 (same as calling C<Gnome::Gtk3::Box.set-homogeneous()> and C<Gnome::Gtk3::Box.set-spacing()> manually).
=end pod

#TE:1:GtkButtonBoxStyle:
enum GtkButtonBoxStyle is export (
  'GTK_BUTTONBOX_SPREAD' => 1,
  'GTK_BUTTONBOX_EDGE',
  'GTK_BUTTONBOX_START',
  'GTK_BUTTONBOX_END',
  'GTK_BUTTONBOX_CENTER',
  'GTK_BUTTONBOX_EXPAND'
);

#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 :orientation

Create a new ButtonBox object.

  multi method new ( :$orientation = GTK_ORIENTATION_HORIZONTAL )


=head3 :native-object

Create a ButtonBox object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a ButtonBox object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:1:new(:orientation):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ButtonBox' or %options<GtkButtonBox> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if %options<orientation>:exists {
        $no = _gtk_button_box_new(%options<orientation>);
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
        $no = _gtk_button_box_new(GTK_ORIENTATION_HORIZONTAL);
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkButtonBox');
  }
}


#-------------------------------------------------------------------------------
#TM:1:get-child-non-homogeneous:
=begin pod
=head2 get-child-non-homogeneous

Returns whether the child is exempted from homogenous sizing.

Returns: C<True> if the child is not subject to homogenous sizing

  method get-child-non-homogeneous ( N-GObject $child --> Bool )

=item N-GObject $child; a child of the button box
=end pod

method get-child-non-homogeneous ( $child is copy --> Bool ) {
  $child .= _get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_button_box_get_child_non_homogeneous(
    self._get-native-object-no-reffing, $child
  ).Bool
}

sub gtk_button_box_get_child_non_homogeneous (
  N-GObject $widget, N-GObject $child --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-child-secondary:
=begin pod
=head2 get-child-secondary

Returns whether I<$child> should appear in a secondary group of children.

  method get-child-secondary ( N-GObject $child --> Bool )

=item N-GObject $child; a child of the button box
=end pod

method get-child-secondary ( $child is copy --> Bool ) {
  $child .= _get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_button_box_get_child_secondary(
    self._get-native-object-no-reffing, $child
  ).Bool
}

sub gtk_button_box_get_child_secondary (
  N-GObject $widget, N-GObject $child --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-layout:
=begin pod
=head2 get-layout

Retrieves the method being used to arrange the buttons in a button box.

  method get-layout ( --> GtkButtonBoxStyle )

=end pod

method get-layout ( --> GtkButtonBoxStyle ) {
  GtkButtonBoxStyle(gtk_button_box_get_layout(self._get-native-object(:!ref)))
}

sub gtk_button_box_get_layout (
  N-GObject $widget --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-child-non-homogeneous:
=begin pod
=head2 set-child-non-homogeneous

Sets whether the child is exempted from homogeous sizing.

  method set-child-non-homogeneous (
    N-GObject $child, Bool $non_homogeneous
  )

=item N-GObject $child; a child of the button box
=item Bool $non_homogeneous; the new value
=end pod

method set-child-non-homogeneous ( $child is copy, Bool $non_homogeneous ) {
  $child .= _get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_button_box_set_child_non_homogeneous(
    self._get-native-object-no-reffing, $child, $non_homogeneous
  );
}

sub gtk_button_box_set_child_non_homogeneous (
  N-GObject $widget, N-GObject $child, gboolean $non_homogeneous
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-child-secondary:
=begin pod
=head2 set-child-secondary

Sets whether I<$child> should appear in a secondary group of children. A typical use of a secondary child is the help button in a dialog.

This group appears after the other children if the style is C<GTK-BUTTONBOX-START>, C<GTK-BUTTONBOX-SPREAD> or C<GTK-BUTTONBOX-EDGE>, and before the other children if the style is C<GTK-BUTTONBOX-END>. For horizontal button boxes, the definition of before/after depends on direction of the widget (see C<gtk-widget-set-direction()>). If the style is C<GTK-BUTTONBOX-START> or C<GTK-BUTTONBOX-END>, then the secondary children are aligned at the other end of the button box from the main children. For the other styles, they appear immediately next to the main children.

  method set-child-secondary ( N-GObject $child, Bool $is_secondary )

=item N-GObject $child; a child of the button box
=item Bool $is_secondary; if C<True>, the I<$child> appears in a secondary group of the button box.
=end pod

method set-child-secondary ( $child is copy, Bool $is_secondary ) {
  $child .= _get-native-object-no-reffing unless $child ~~ N-GObject;

  gtk_button_box_set_child_secondary(
    self._get-native-object-no-reffing, $child, $is_secondary
  );
}

sub gtk_button_box_set_child_secondary (
  N-GObject $widget, N-GObject $child, gboolean $is_secondary
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-layout:
=begin pod
=head2 set-layout

Changes the way buttons are arranged in their container.

  method set-layout ( GtkButtonBoxStyle $layout_style )

=item GtkButtonBoxStyle $layout_style; the new layout style
=end pod

method set-layout ( GtkButtonBoxStyle $layout_style ) {

  gtk_button_box_set_layout(
    self._get-native-object-no-reffing, $layout_style
  );
}

sub gtk_button_box_set_layout (
  N-GObject $widget, GEnum $layout_style
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_button_box_new:
#`{{
=begin pod
=head2 _gtk_button_box_new

Creates a new B<Gnome::Gtk3::ButtonBox>.

Returns: a new B<Gnome::Gtk3::ButtonBox>.

  method _gtk_button_box_new ( GtkOrientation $orientation --> N-GObject )

=item GtkOrientation $orientation; the box's orientation.
=end pod
}}

sub _gtk_button_box_new ( GEnum $orientation --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_button_box_new')
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
=comment #TP:1:layout-style:
=head3 Layout style: layout-style

How to lay out the buttons in the box. Possible values are: spread, edge-COMMA- start and end
Default value: False

The B<Gnome::GObject::Value> type of property I<layout-style> is C<G_TYPE_ENUM>.
=end pod
