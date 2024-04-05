#TL:1:Gnome::Gtk3::Layout:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Layout

Infinite scrollable area containing child widgets and/or custom drawing

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::Layout> is similar to B<Gnome::Gtk3::DrawingArea> in that it’s a “blank slate” and doesn’t do anything except paint a blank background by default. It’s different in that it supports scrolling natively due to implementing B<Gnome::Gtk3::Scrollable>, and can contain child widgets since it’s a B<Gnome::Gtk3::Container>.

If you just want to draw, a B<Gnome::Gtk3::DrawingArea> is a better choice since it has lower overhead. If you just need to position child widgets at specific points, then B<Gnome::Gtk3::Fixed> provides that functionality on its own.

When handling expose events on a B<Gnome::Gtk3::Layout>, you must draw to the B<Gnome::Gtk3::Window> returned by C<get-bin-window()>, rather than to the one returned by C<Gnome::Gtk3::Widget.get-window()> as you would for a B<Gnome::Gtk3::DrawingArea>.


=head2 See Also

B<Gnome::Gtk3::DrawingArea>, B<Gnome::Gtk3::Fixed>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Layout;
  also is Gnome::Gtk3::Container;
  also does Gnome::Gtk3::Scrollable;


=head2 Uml Diagram

![](plantuml/Layout.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Layout:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Layout;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Layout class process the options
    self.bless( :GtkLayout, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=head2 Example

An example where 3 buttons are placed somewhere on a B<Gnome::Gtk3::Layout>. In this case a B<Gnome::Gtk3::Fixed> would as described above.

  given my Gnome::Gtk3::Layout $l .= new {
    .set-size( 400, 300);
    my Gnome::Gtk3::Button $b .= new(:label<Start>);
    .put( $b, 100, 100);
    $b .= new(:label<Stop>);
    .put( $b, 100, 100);
    .move( $b, 200, 250);
    $b .= new(:label<Quit>);
    .put( $b, 300, 150);
  }

This displays as;
![](images/Layout.png)

=end pod


#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gtk3::Container:api<1>;
use Gnome::Gtk3::Scrollable:api<1>;
#use Gnome::Gtk3::Adjustment:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Layout:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Container;
also does Gnome::Gtk3::Scrollable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 Default, no arguments

Creates a new B<Gnome::Gtk3::Layout>. The horizontal and vertical adjustments are set to default values.

  multi method new ( )


=head3 :hadjustment, :vadjustment

Creates a new B<Gnome::Gtk3::Layout>. Unless you have a specific adjustment you’d like the layout to use for scrolling, pass C<undefined> for I<$hadjustment> and I<$vadjustment>.

  multi method new ( N-GObject :$hadjustment!, N-GObject :$vadjustment! )


=head3 :native-object

Create a Layout object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a Layout object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new():
#TM:1:new(:hadjustment,:vadjustment):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Layout' or %options<GtkLayout> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<hadjustment> and ? %options<vadjustment> {
        my $no-h = %options<hadjustment>;
        $no-h .= _get-native-object-no-reffing unless $no-h ~~ N-GObject;
        my $no-v = %options<vadjustment>;
        $no-v .= _get-native-object-no-reffing unless $no-v ~~ N-GObject;
        $no = _gtk_layout_new( $no-h, $no-v);
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
        $no = _gtk_layout_new( N-GObject, N-GObject);
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkLayout');
  }
}


#-------------------------------------------------------------------------------
#TM:0:get-bin-window:
=begin pod
=head2 get-bin-window

Retrieve the bin window of the layout used for drawing operations.

Returns: a B<Gnome::Gtk3::Window>

  method get-bin-window ( --> N-GObject )

=end pod

method get-bin-window ( --> N-GObject ) {

  gtk_layout_get_bin_window(
    self._get-native-object-no-reffing,
  )
}

sub gtk_layout_get_bin_window (
  N-GObject $layout --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-size:
=begin pod
=head2 get-size

Gets the size that has been set on the layout, and that determines the total extents of the layout’s scrollbar area. See C<set-size()>.

  method get-size ( --> List )

The list returns;
=item UInt width; width set on I<layout>, or C<undefined>
=item UInt height; height set on I<layout>, or C<undefined>
=end pod

method get-size ( --> List ) {
  my guint $height;
  my guint $width;
  gtk_layout_get_size(
    self._get-native-object-no-reffing, $width, $height
  );

  ( $width, $height)
}

sub gtk_layout_get_size (
  N-GObject $layout, guint $width is rw, guint $height is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:move:
=begin pod
=head2 move

Moves a current child of I<layout> to a new position.

  method move ( N-GObject $child_widget, Int() $x, Int() $y )

=item N-GObject $child_widget; a current child of I<layout>
=item Int() $x; X position to move to
=item Int() $y; Y position to move to
=end pod

method move ( $child_widget is copy, Int() $x, Int() $y ) {
  $child_widget .= _get-native-object-no-reffing unless $child_widget ~~ N-GObject;

  gtk_layout_move(
    self._get-native-object-no-reffing, $child_widget, $x, $y
  );
}

sub gtk_layout_move (
  N-GObject $layout, N-GObject $child_widget, gint $x, gint $y
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:put:
=begin pod
=head2 put

Adds I<child-widget> to I<layout>, at position (I<x>,I<y>). I<layout> becomes the new parent container of I<child-widget>.

  method put ( N-GObject $child_widget, Int() $x, Int() $y )

=item N-GObject $child_widget; child widget
=item Int() $x; X position of child widget
=item Int() $y; Y position of child widget
=end pod

method put ( $child_widget is copy, Int() $x, Int() $y ) {
  $child_widget .= _get-native-object-no-reffing unless $child_widget ~~ N-GObject;

  gtk_layout_put(
    self._get-native-object-no-reffing, $child_widget, $x, $y
  );
}

sub gtk_layout_put (
  N-GObject $layout, N-GObject $child_widget, gint $x, gint $y
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-size:
=begin pod
=head2 set-size

Sets the size of the scrollable area of the layout.

  method set-size ( UInt $width, UInt $height )

=item UInt $width; width of entire scrollable area
=item UInt $height; height of entire scrollable area
=end pod

method set-size ( UInt $width, UInt $height ) {

  gtk_layout_set_size(
    self._get-native-object-no-reffing, $width, $height
  );
}

sub gtk_layout_set_size (
  N-GObject $layout, guint $width, guint $height
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_layout_new:
#`{{
=begin pod
=head2 _gtk_layout_new

Creates a new B<Gnome::Gtk3::Layout>. Unless you have a specific adjustment you’d like the layout to use for scrolling, pass C<undefined> for I<hadjustment> and I<vadjustment>.

Returns: a new B<Gnome::Gtk3::Layout>

  method _gtk_layout_new ( N-GObject $hadjustment, N-GObject $vadjustment --> N-GObject )

=item N-GObject $hadjustment; horizontal scroll adjustment, or C<undefined>
=item N-GObject $vadjustment; vertical scroll adjustment, or C<undefined>
=end pod
}}

sub _gtk_layout_new ( N-GObject $hadjustment, N-GObject $vadjustment --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_layout_new')
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
=comment #TP:1:height:
=head3 Height: height


The B<Gnome::GObject::Value> type of property I<height> is C<G_TYPE_UINT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:width:
=head3 Width: width


The B<Gnome::GObject::Value> type of property I<width> is C<G_TYPE_UINT>.
=end pod
