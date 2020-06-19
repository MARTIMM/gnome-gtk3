#TL:0:Gnome::Gtk3::DrawingArea:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::DrawingArea

A widget for custom user interface elements

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gtk3::DrawingArea> widget is used for creating custom user interface elements. It’s essentially a blank widget; you can draw on it. After creating a drawing area, the application may want to connect to:

=item Mouse and button press signals to respond to input from the user.
=comment (Use C<gtk_widget_add_events()> to enable events you wish to receive.)

=item The I<realize> signal to take any necessary actions when the widget is instantiated on a particular display. (Create GDK resources in response to this signal.)

=item The I<size-allocate> signal to take any necessary actions when the widget changes size.

=item The I<draw> signal to handle redrawing the contents of the widget.

The following code portion demonstrates using a drawing area to display a circle in the normal widget foreground color.

Note that GDK automatically clears the exposed area before sending the expose event, and that drawing is implicitly clipped to the exposed area. If you want to have a theme-provided background, you need to call C<gtk_render_background()> in your I<draw> method.

=head2 Simple B<Gnome::Gtk3::DrawingArea> usage

=begin comment
|[<!-- language="C" -->
gboolean
draw_callback (B<Gnome::Gtk3::Widget> *widget, cairo_t *cr, gpointer data)
{
  guint width, height;
  B<Gnome::Gdk3::RGBA> color;
  B<Gnome::Gtk3::StyleContext> *context;

  context = gtk_widget_get_style_context (widget);

  width = gtk_widget_get_allocated_width (widget);
  height = gtk_widget_get_allocated_height (widget);

  gtk_render_background (context, cr, 0, 0, width, height);

  cairo_arc (cr,
             width / 2.0, height / 2.0,
             MIN (width, height) / 2.0,
             0, 2 * G_PI);

  gtk_style_context_get_color (context,
                               gtk_style_context_get_state (context),
                               &color);
  gdk_cairo_set_source_rgba (cr, &color);

  cairo_fill (cr);

 return FALSE;
}
[...]
  B<Gnome::Gtk3::Widget> *drawing_area = C<gtk_drawing_area_new()>;
  gtk_widget_set_size_request (drawing_area, 100, 100);
  g_signal_connect (G_OBJECT (drawing_area), "draw",
                    G_CALLBACK (draw_callback), NULL);
]|
=end comment

Draw signals are normally delivered when a drawing area first comes onscreen, or when it’s covered by another window and then uncovered. You can also force an expose event by adding to the “damage region” of the drawing area’s window; C<gtk_widget_queue_draw_area()> and C<gdk_window_invalidate_rect()> are equally good ways to do this. You’ll then get a draw signal for the invalid region.

The available routines for drawing are documented on the [GDK Drawing Primitives][gdk3-Cairo-Interaction] page and the cairo documentation.

To receive mouse events on a drawing area, you will need to enable them with C<gtk_widget_add_events()>. To receive keyboard events, you will need to set the “can-focus” property on the drawing area, and you should probably draw some user-visible indication that the drawing area is focused. Use C<gtk_widget_has_focus()> in your expose event handler to decide whether to draw the focus indicator. See C<gtk_render_focus()> for one way to draw focus.

=head2 See Also

B<Gnome::Gtk3::Image>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::DrawingArea;
  also is Gnome::Gtk3::Widget;

=comment head2 Uml Diagram

=comment ![](plantuml/.png)

=begin comment
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

=end comment
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

=head3 new()

Create a new DrawingArea object.

  multi method new ( )

=end pod

#TM:1:new():
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::DrawingArea' #`{{ or %options<GtkDrawingArea> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;
      # if ? %options<> {
      #   $no = %options<>;
      #   $no .= get-native-object-no-reffing
      #     if $no.^can('get-native-object-no-reffing');
      #   $no = ...($no);
      # }

      # use this when the module is not made inheritable
      # check if there are unknown options
      if %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      # create default object
      else {
        $no = _gtk_drawing_area_new;
      }

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkDrawingArea');
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

  self.set-class-name-of-sub('GtkDrawingArea');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:_gtk_drawing_area_new:new()
#`{{
=begin pod
=head2 _gtk_drawing_area_new

Creates a new drawing area.

Returns: a new B<Gnome::Gtk3::DrawingArea>

  method gtk_drawing_area_new ( --> N-GObject )

=end pod
}}
sub _gtk_drawing_area_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_drawing_area_new')
  { * }
