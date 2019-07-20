use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::ColorChooser

=SUBTITLE Interface implemented by widgets for choosing colors

=head1 Description

C<Gnome::Gtk3::ColorChooser> is an interface that is implemented by widgets
for choosing colors. Depending on the situation, colors may be
allowed to have alpha (translucency).

In GTK+, the main widgets that implement this interface are
C<Gnome::Gtk3::ColorChooserWidget>, C<Gnome::Gtk3::ColorChooserDialog> and C<Gnome::Gtk3::ColorButton>.

Since: 3.4


=head2 See Also

C<Gnome::Gtk3::ColorChooserDialog>, C<Gnome::Gtk3::ColorChooserWidget>, C<Gnome::Gtk3::ColorButton>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ColorChooser;
  also is Gnome::GObject::Interface;

=head2 Example

  my Gnome::Gtk3::ColorChooserDialog $ccdialog .= new(
    :title('my color dialog')
  );

  # get color chooser widget from widgets that implement the interface
  my Gnome::Gtk3::ColorChooser $cc .= new(:widget($ccdialog));

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Interface;
use Gnome::Gdk3::RGBA;
use Gnome::Gtk3::Enums;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ColorChooser:auth<github:MARTIMM>;
also is Gnome::GObject::Interface;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 multi method new ( Gnome::GObject::Object :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :color<color-activated>
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::ColorChooser';

  # process all named arguments
  if ? %options<widget> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkColorChooser');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_color_chooser_$native-sub"); } unless ?$s;

  self.set-class-name-of-sub('GtkColorChooser');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_color_chooser_] get_rgba

Gets the currently-selected color.

Since: 3.4

  method gtk_color_chooser_get_rgba ( N-GObject $color)

=item GdkRGBA $color;  (out): a C<GdkRGBA> structure to fill in with the current color

=end pod

sub gtk_color_chooser_get_rgba ( N-GObject $chooser, GdkRGBA:D $color )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_color_chooser_] set_rgba

Sets the color.

Since: 3.4

  method gtk_color_chooser_set_rgba ( N-GObject $color)

=item GdkRGBA $color;  the new color

=end pod

sub gtk_color_chooser_set_rgba ( N-GObject $chooser, GdkRGBA:D $color )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_color_chooser_] get_use_alpha

Returns whether the color chooser shows the alpha channel.

Returns: C<1> if the color chooser uses the alpha channel,
C<0> if not

Since: 3.4

  method gtk_color_chooser_get_use_alpha ( --> Int )

=end pod

sub gtk_color_chooser_get_use_alpha ( N-GObject $chooser )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_color_chooser_] set_use_alpha

Sets whether or not the color chooser should use the alpha channel.

Since: 3.4

  method gtk_color_chooser_set_use_alpha ( Int $use_alpha)

=item Int $use_alpha;  1 if color chooser should use alpha channel, 0 if not

=end pod

sub gtk_color_chooser_set_use_alpha ( N-GObject $chooser, int32 $use_alpha )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_color_chooser_] add_palette

Adds a palette to the color chooser. If I<orientation> is horizontal,
the colors are grouped in rows, with I<colors_per_line> colors
in each row. If I<horizontal> is C<0>, the colors are grouped
in columns instead.

The default color palette of C<Gnome::Gtk3::ColorChooserWidget> has
27 colors, organized in columns of 3 colors. The default gray
palette has 9 grays in a single row.

The layout of the color chooser widget works best when the
palettes have 9-10 columns.

Calling this function for the first time has the
side effect of removing the default color and gray palettes
from the color chooser.

If I<colors> is C<Any>, removes all previously added palettes.

Since: 3.4

  method gtk_color_chooser_add_palette ( GtkOrientation $orientation, Int $colors_per_line, Int $n_colors, N-GObject $colors )

=item GtkOrientation $orientation;  C<GTK_ORIENTATION_HORIZONTAL> if the palette should be displayed in rows, C<GTK_ORIENTATION_VERTICAL> for columns
=item Int $colors_per_line;  the number of colors to show in each row/column
=item Int $n_colors;  the total number of elements in @colors
=item CArray[num64] $colors; (allow-none) (array length=n_colors): the colors of the palette, or C<Any>.

=head3 An Example
According to the documentation, an array of GdkRGBA Structures should be given. Perl6 however, turns a CArray[GdkRGBA] into references to the structure so it becomes an array of pointers. The sub is modified in such a way that either CArray[GdkRGBA] or CArray[num64] can be given. The latter one must always have elems % 4 == 0.

  my $palette = CArray[num64].new(
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
    .0e0, .9e0, .0e0, 1e0, color20: ...
  );

  my GdkRGBA $color .= new( :red(1e0), :green(.0e0), :blue(.0e0), :alpha(1e0));
  my Gnome::Gtk3::ColorButton $cb .= new(:$color);
  my Gnome::Gtk3::ColorChooser $cc .= new(:widget($cb));
  $cc.add-palette( GTK_ORIENTATION_HORIZONTAL, 10, 20, $palette);

Or it can be done like this

  my $palette = CArray[GdkRGBA].new;
  my Int $index = 0;
  for .0, .1 ... .9 -> Num $rgb-gray {
    $palette[$index++] = GdkRGBA.new(
      :red($rgb-gray), :green($rgb-gray), :blue($rgb-gray), :alpha(1e0)
    );
  }

  my GdkRGBA $color .= new( :red(1e0), :green(.0e0), :blue(.0e0), :alpha(1e0));
  my Gnome::Gtk3::ColorButton $cb .= new(:$color);
  my Gnome::Gtk3::ColorChooser $cc .= new(:widget($cb));
  $cc.add-palette( GTK_ORIENTATION_HORIZONTAL, 10, 10, $palette);

=end pod

#-------------------------------------------------------------------------------
sub gtk_color_chooser_add_palette (
  N-GObject $chooser, int32 $orientation, int32 $colors_per_line,
  int32 $n_colors, CArray $colors
) {

  my CArray[num64] $palette;
  given $colors {
    when CArray[GdkRGBA] {
      $palette .= new;
      my Int $index = 0;
      for 0..$colors.elems - 1 -> $pos {
        my GdkRGBA $c = $colors.AT-POS($pos);
        $palette[$index++] = $c.red;
        $palette[$index++] = $c.green;
        $palette[$index++] = $c.blue;
        $palette[$index++] = $c.alpha;
      }
    }

    when CArray[num64] {
      if $colors.elems % 4 == 0 {
        $palette = $colors;
      }

      else {
        die X::Gnome.new(:message(''));
      }
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

Register any signal as follows. See also C<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., $user-optionN
  )

=begin comment

=head2 Supported signals

=head2 Unsupported signals

=end comment

=head2 Not yet supported signals

=head3 color-activated:

Emitted when a color is activated from the color chooser.
This usually happens when the user clicks a color swatch,
or a color is selected and the user presses one of the keys
Space, Shift+Space, Return or Enter.

Since: 3.4

  method handler (
    Gnome::GObject::Object :widget($chooser),
    :handle-arg0($color),
    :$user-option1, ..., :$user-optionN
  );

=item $chooser; the object which received the signal
=item $color; the color

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a C<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');


=head2 Supported properties
=head3 use-alpha

The C<Gnome::GObject::Value> type of property I<use-alpha> is C<G_TYPE_BOOLEAN>.

When ::use-alpha is C<1>, colors may have alpha (translucency)
information. When it is C<0>, the C<Gnome::Gdk3::RGBA> struct obtained
via the prop C<rgba> property will be forced to have
alpha == 1.

Implementations are expected to show alpha by rendering the color
over a non-uniform background (like a checkerboard pattern).

Since: 3.4


=head2 Not yet supported properties

=head3 rgba

The C<Gnome::GObject::Value> type of property I<rgba> is C<G_TYPE_BOXED>.

The ::rgba property contains the currently selected color,
as a C<Gnome::Gdk3::RGBA> struct. The property can be set to change
the current selection programmatically.

Since: 3.4

=end pod


#`{{
#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2

=item

=end pod
}}
