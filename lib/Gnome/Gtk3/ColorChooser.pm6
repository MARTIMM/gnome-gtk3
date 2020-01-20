#TL:1:Gnome::Gtk3::ColorChooser

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ColorChooser

Interface implemented by widgets for choosing colors

=head1 Description

B<Gnome::Gtk3::ColorChooser> is an interface that is implemented by widgets for choosing colors. Depending on the situation, colors may be allowed to have alpha (translucency).

In GTK+, the main widgets that implement this interface are B<Gnome::Gtk3::ColorChooserWidget>, B<Gnome::Gtk3::ColorChooserDialog> and B<Gnome::Gtk3::ColorButton>.

Since: 3.4

=head2 Known implementations

Gnome::Gtk3::ColorChooser is implemented by

=item [Gnome::Gtk3::ColorButton](ColorButton.html)
=item [Gnome::Gtk3::ColorChooserDialog](ColorChooserDialog.html)
=item [Gnome::Gtk3::ColorChooserWidget](ColorChooserWidget.html)

=head2 See Also

B<Gnome::Gtk3::ColorChooserDialog>, B<Gnome::Gtk3::ColorChooserWidget>, B<Gnome::Gtk3::ColorButton>

=head1 Synopsis
=head2 Declaration

  unit role Gnome::Gtk3::ColorChooser;

=head2 Example

  my Gnome::Gtk3::ColorChooserDialog $ccdialog .= new(
    :title('my color dialog')
  );

  # Use methods defined in the interface
  note "Green channel: ", $ccdialog.get-rgba($color).green;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gdk3::RGBA;
use Gnome::Gtk3::Enums;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit role Gnome::Gtk3::ColorChooser:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

#-------------------------------------------------------------------------------
#TM:2:new():interfacing:ColorChooserDialog.t
# interfaces are not instantiated
#submethod BUILD ( *%options ) { }

#-------------------------------------------------------------------------------
# setup signals from interface
method _add_color_chooser_signal_types ( Str $class-name ) {

  self.add-signal-types( $class-name, :w1<color-activated>);
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
# Hook for modules using this interface. Same principle as _fallback but
# does not need callsame. Also this method must be usable without
# an instated object
method _color_chooser_interface ( Str $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_color_chooser_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s
}

#-------------------------------------------------------------------------------
#TM:2:gtk_color_chooser_get_rgba:ColorChooserDialog.t
=begin pod
=head2 [[gtk_] color_chooser_] get_rgba

Gets the currently-selected color.

Since: 3.4

  method gtk_color_chooser_get_rgba ( --> N-GdkRGBA )

=end pod

sub gtk_color_chooser_get_rgba ( N-GObject $chooser --> N-GdkRGBA ) {
  my N-GdkRGBA $clr .= new;
  _gtk_color_chooser_get_rgba( $chooser, $clr);
  $clr
}

sub _gtk_color_chooser_get_rgba ( N-GObject $chooser, N-GdkRGBA $color is rw )
  is native(&gtk-lib)
  is symbol('gtk_color_chooser_get_rgba')
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_color_chooser_set_rgba:ColorChooserDialog.t
=begin pod
=head2 [[gtk_] color_chooser_] set_rgba

Sets the color.

Since: 3.4

  method gtk_color_chooser_set_rgba ( N-GObject $color )

=item N-GdkRGBA $color: the new color

=end pod

sub gtk_color_chooser_set_rgba ( N-GObject $chooser, N-GdkRGBA:D $color )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_color_chooser_get_use_alpha:ColorChooserDialog.t
=begin pod
=head2 [[gtk_] color_chooser_] get_use_alpha

Check whether the color chooser shows the alpha channel.

Returns: C<1> if the color chooser uses the alpha channel, C<0> if not.

Since: 3.4

  method gtk_color_chooser_get_use_alpha ( --> Int )

=end pod

sub gtk_color_chooser_get_use_alpha ( N-GObject $chooser )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_color_chooser_set_use_alpha:ColorChooserDialog.t
=begin pod
=head2 [[gtk_] color_chooser_] set_use_alpha

Sets whether or not the color chooser should use the alpha channel.

Since: 3.4

  method gtk_color_chooser_set_use_alpha ( Int $use_alpha)

=item Int $use_alpha: C<1> if color chooser should use alpha channel, C<0> if not

=end pod

sub gtk_color_chooser_set_use_alpha ( N-GObject $chooser, int32 $use_alpha )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_color_chooser_add_palette:ColorChooserDialog.t
=begin pod
=head2 [[gtk_] color_chooser_] add_palette

Adds a palette to the color chooser. If I<$orientation> is horizontal, the colors are grouped in rows, with I<$colors_per_line> colors in each row. If I<$horizontal> is C<0>, the colors are grouped in columns instead.

The default color palette of B<Gnome::Gtk3::ColorChooserWidget> has 27 colors, organized in columns of 3 colors. The default gray palette has 9 grays in a single row.

The layout of the color chooser widget works best when the palettes have 9-10 columns.

Calling this function for the first time has the side effect of removing the default color and gray palettes from the color chooser.

If I<$colors> is undefined, the method removes all previously added palettes.

Since: 3.4

  method gtk_color_chooser_add_palette (
    GtkOrientation $orientation,
    Int $colors_per_line, Int $n_colors,
    Array $colors
  )

=item GtkOrientation $orientation; C<GTK_ORIENTATION_HORIZONTAL> if the palette should be displayed in rows, C<GTK_ORIENTATION_VERTICAL> for columns.
=item Int $colors_per_line;  the number of colors to show in each row/column.
=item Int $n_colors;  the total number of elements in @colors.
=item Array[Num] or Array[N-GdkRGBA] $colors; the colors of the palette, or C<Any>.

=head3 An Example

According to the documentation, an array of N-GdkRGBA Structures should be given. Raku however, turns a CArray[N-GdkRGBA] into references to the structure so it becomes an array of pointers. The sub is modified in such a way that either Array[N-GdkRGBA] or Array[Num] can be given. The latter one must always have elems % 4 == 0.

  use NativeCall;
  use Gnome::Gdk3::RGBA;
  use Gnome::Gtk3::ColorChooser;

  my Array $palette = [
    .0e0, .0e0, .0e0, 1e0, # color1: red, green, blue, opacity
    .1e0, .0e0, .0e0, 1e0, # color2: ...
    .2e0, .0e0, .0e0, 1e0,
    .3e0, .0e0, .0e0, 1e0,
    .4e0, .0e0, .0e0, 1e0,
    .5e0, .0e0, .0e0, 1e0,
    .6e0, .0e0, .0e0, 1e0,
    .7e0, .0e0, .0e0, 1e0,
    .8e0, .0e0, .0e0, 1e0,
    .9e0, .0e0, .0e0, 1e0,
    .0e0, .0e0, .0e0, 1e0,
    .0e0, .1e0, .0e0, 1e0,
    .0e0, .2e0, .0e0, 1e0,
    .0e0, .3e0, .0e0, 1e0,
    .0e0, .4e0, .0e0, 1e0,
    .0e0, .5e0, .0e0, 1e0,
    .0e0, .6e0, .0e0, 1e0,
    .0e0, .7e0, .0e0, 1e0,
    .0e0, .8e0, .0e0, 1e0,
    .0e0, .9e0, .0e0, 1e0, # color20: ...
  ];

  my Gnome::Gdk3::RGBA $color .= new(
    :red(1e0), :green(.0e0), :blue(.0e0), :alpha(1e0)
  );

  my Gnome::Gtk3::ColorButton $cb .= new(:$color);
  $cb.add-palette( GTK_ORIENTATION_HORIZONTAL, 10, 20, $palette);

Or it can be done like this

  my Array $palette = [];
  for .0, .1 ... .9 -> Num $rgb-gray {
    $palette.push: N-GdkRGBA.new(
      :red($rgb-gray), :green($rgb-gray), :blue($rgb-gray), :alpha(1e0)
    );
  }

  my N-GdkRGBA $color .= new(
    :red(0e0), :green(.0e0), :blue(.0e0), :alpha(1e0)
  );
  my Gnome::Gtk3::ColorButton $cb .= new(:$color);
  $cb.add-palette( GTK_ORIENTATION_HORIZONTAL, 10, 10, $palette);

=end pod

sub gtk_color_chooser_add_palette (
  N-GObject $chooser, Int $orientation, Int $colors_per_line,
  Int $n_colors, Array $colors
) {

  my CArray[num64] $palette;
  $palette .= new;

  given $colors {
    when Array[Gnome::Gdk3::RGBA::N-GdkRGBA] {
      my Int $index = 0;
      for 0..$colors.elems - 1 -> $pos {
        my N-GdkRGBA $c = $colors.shift;
        $palette[$index++] = $c.red;
        $palette[$index++] = $c.green;
        $palette[$index++] = $c.blue;
        $palette[$index++] = $c.alpha;
      }
    }

    when any(Array[Num], Array[Int], Array[Str], Array)  {
      if $colors.elems % 4 == 0 {
        my Int $index = 0;
        for @$colors -> $n {
          $palette[$index++] = $n.Num;
        }
      }

      else {
        die X::Gnome.new(:message('Not proper number of elements (e % 4 ≠ 0)'));
      }
    }

    default {
      die X::Gnome.new(
        :message('Not a supported type for $colors: ' ~ $colors.^name)
      );
    }
  }

  _gtk_color_chooser_add_palette(
    $chooser, $orientation, $colors_per_line, $n_colors, $palette
  );
}

sub _gtk_color_chooser_add_palette (
  N-GObject $chooser, int32 $orientation, int32 $colors_per_line,
  int32 $n_colors, CArray[num64] $colors
) is native(&gtk-lib)
  is symbol('gtk_color_chooser_add_palette')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<g_signal_connect_object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

The register method is defined as;

  my Bool $is-registered = $widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., :$user-optionN
  )

Where
=item $handler-object; A Raku object holding the handler method =I<self>
=item $handler-name; The handler method =I<mouse-event>
=item $signal-name; The signal to connect to =I<button-press-event>
=item $user-option*; User options are given to the user unchanged as named arguments. The name 'widget' is reserved.

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<g_signal_connect_object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals

=comment #TS:0:color-activated:
=head3 color-activated:

Emitted when a color is activated from the color chooser. This usually happens when the user clicks a color swatch, or a color is selected and the user presses one of the keys Space, Shift+Space, Return or Enter.

Since: 3.4

  method handler (
    N-GdkRGBA $color,
    Gnome::GObject::Object :widget($chooser),
    :$user-option1, ..., :$user-optionN
  );

=item $chooser; the object which received the signal
=item $color; the color

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.


  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');


=head2 Supported properties

=begin comment
=comment #TP:0:rgba:
=head3 rgba

The prop I<rgba> property contains the currently selected color, as a B<Gnome::Gdk3::RGBA> struct. The property can be set to change the current selection programmatically.

Since: 3.4

The B<Gnome::GObject::Value> type of property I<rgba> is C<G_TYPE_BOXED>.
=end comment

=comment #TP:0:use-alpha:
=head3 use-alpha

When prop I<use-alpha> is C<1>, colors may have alpha (translucency) information. When it is C<0>, the B<Gnome::Gdk3::RGBA> struct obtained via the prop I<rgba> property will be forced to have alpha == 1.

Implementations are expected to show alpha by rendering the color over a non-uniform background (like a checkerboard pattern).

Since: 3.4

The B<Gnome::GObject::Value> type of property I<use-alpha> is C<G_TYPE_BOOLEAN>.

=end pod
