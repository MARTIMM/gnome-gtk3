#TL:1:Gnome::Gtk3::DrawingArea:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::DrawingArea

A widget for custom user interface elements

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gtk3::DrawingArea> widget is used for creating custom user interface elements. It’s essentially a blank widget; you can draw on it. After creating a drawing area, the application may want to connect to:

=item Mouse and button press signals to respond to input from the user. (Use C<Gnome::Gtk3::Widget.add_events()> to enable events you wish to receive.)

=item The I<realize> signal to take any necessary actions when the widget is instantiated on a particular display. (Create GDK resources in response to this signal.)

=item The I<size-allocate> signal to take any necessary actions when the widget changes size.

=item The I<draw> signal to handle redrawing the contents of the widget.

The following code portion demonstrates using a drawing area to display a circle in the normal widget foreground color.

Note that GDK automatically clears the exposed area before sending the expose event, and that drawing is implicitly clipped to the exposed area. If you want to have a theme-provided background, you need to call C<Gnome::Gtk3::StyleContext.render_background()> in your I<draw> method.

=head2 Simple B<Gnome::Gtk3::DrawingArea> usage

  class DA {
    method draw-callback (
      cairo_t $cr-no, Gnome::Gtk3::DrawingArea :_widget($area)
    ) {
      my UInt ( $width, $height);
      my Gnome::Gtk3::StyleContext $context .= new(
        :native-object($area.get-style-context)
      );
      $width = $area.get-allocated-width;
      $height = $area.get-allocated-height;

      my Gnome::Cairo $cr .= new(:native-object($cr-no));
      $context.render-background( $cr, 0, 0, $width, $height);

      $cr.cairo-arc(
        $width/2.0, $height/2.0, min( $width, $height)/2.0, 0, 2.0 * π
      );

      my N-GdkRGBA $color-no = $context.get-color($context.get-state);
      $cr.set-source-rgba(
        $color-no.red, $color-no.green, $color-no.blue, $color-no.alpha
      );

      $cr.cairo-fill;

      False;
    }
  }


  given my Gnome::Gtk3::DrawingArea $drawing-area .= new {
    .set-size-request( 100, 100);
    .register-signal( DA.new, 'draw-callback', 'draw');
  }

Draw signals are normally delivered when a drawing area first comes onscreen, or when it’s covered by another window and then uncovered. You can also force an expose event by adding to the “damage region” of the drawing area’s window; C<Gnome::Gtk3::Widget.queue_draw_area()> and C<Gnome::Gdk3::Window.invalidate_rect()> are equally good ways to do this. You’ll then get a draw signal for the invalid region.

=comment The available routines for drawing are documented on the L<GDK Drawing Primitives|> page and the cairo documentation.

To receive mouse events on a drawing area, you will need to enable them with C<Gnome::Gtk3::Widget.add_events()>. To receive keyboard events, you will need to set the “can-focus” property on the drawing area, and you should probably draw some user-visible indication that the drawing area is focused. Use C<Gnome::Gtk3::Widget.has_focus()> in your expose event handler to decide whether to draw the focus indicator. See C<Gnome::Gtk3::StyleContext.render_focus()> for one way to draw focus.


=head2 See Also

B<Gnome::Gtk3::Image>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::DrawingArea;
  also is Gnome::Gtk3::Widget;


=head2 Uml Diagram

![](plantuml/DrawingArea.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::DrawingArea;

  unit class MyGuiClass;
  also is Gnome::Gtk3::DrawingArea;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::DrawingArea class process the options
    self.bless( :GtkDrawingArea, |c);
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
use Gnome::Gtk3::Widget;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::DrawingArea:auth<github:MARTIMM>;
also is Gnome::Gtk3::Widget;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new DrawingArea object.

  multi method new ( )

=end pod

#TM:1:inheriting:
#TM:1:new():
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::DrawingArea' or %options<GtkDrawingArea> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;
      # if ? %options<> {
      #   $no = %options<>;
      #   $no .= get-native-object-no-reffing
      #     if $no.^can('get-native-object-no-reffing');
      #   $no = ...($no);
      # }

      #`{{ use this when the module is not made inheritable
      # check if there are unknown options
      if %options.elems {
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

      # create default object
      #else {
        $no = _gtk_drawing_area_new;
      #}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkDrawingArea');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_drawing_area_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkDrawingArea');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:_gtk_drawing_area_new:new()
#`{{
=begin pod
=head2 [gtk_] drawing_area_new

Creates a new drawing area.

Returns: a new B<Gnome::Gtk3::DrawingArea>

  method gtk_drawing_area_new ( --> N-GObject )

=end pod
}}
sub _gtk_drawing_area_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_drawing_area_new')
  { * }
