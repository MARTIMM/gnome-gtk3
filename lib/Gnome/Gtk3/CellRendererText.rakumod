#TL:1:Gnome::Gtk3::CellRendererText:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellRendererText

Renders text in a cell


=head1 Description

A B<Gnome::Gtk3::CellRendererText> renders a given text in its cell, using the font, color and style information provided by its properties. The text will be ellipsized if it is too long and the  I<ellipsize> property allows it.

If the  I<mode> is C<GTK_CELL_RENDERER_MODE_EDITABLE>, the B<Gnome::Gtk3::CellRendererText> allows to edit its text using an entry.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRendererText;
  also is Gnome::Gtk3::CellRenderer;


=head2 Uml Diagram

![](plantuml/CellRenderer-ea.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::CellRendererText:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::CellRendererText;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::CellRendererText class process the options
    self.bless( :GtkCellRendererText, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gtk3::CellRenderer:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::CellRendererText:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::CellRenderer;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new CellRendererText object.

  multi method new ( )


=head3 :native-object

Create a CellRendererText object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a CellRendererText object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {
  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w2<edited>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::CellRendererText' #`{{ or %options<GtkCellRendererText> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_cell_renderer_text_new___x___($no);
      }

      ##`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      #}}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_cell_renderer_text_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkCellRendererText');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_cell_renderer_text_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_cell_renderer_text_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("cell_renderer_text_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('cell-renderer-text-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-cell-renderer-textn-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

  self._set-class-name-of-sub('GtkCellRendererText');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:set-fixed-height-from-font:
=begin pod
=head2 set-fixed-height-from-font

Sets the height of a renderer to explicitly be determined by the “font” and “y_pad” property set on it. Further changes in these properties do not affect the height, so they must be accompanied by a subsequent call to this function. Using this function is unflexible, and should really only be used if calculating the size of a cell is too slow (ie, a massive number of cells displayed). If I<number_of_rows> is -1, then the fixed height is unset, and the height is determined by the properties again.

  method set-fixed-height-from-font ( Int() $number_of_rows )

=item $number_of_rows; Number of rows of text each cell renderer is allocated, or -1
=end pod

method set-fixed-height-from-font ( Int() $number_of_rows ) {
  gtk_cell_renderer_text_set_fixed_height_from_font(
    self._get-native-object-no-reffing, $number_of_rows
  );
}

sub gtk_cell_renderer_text_set_fixed_height_from_font (
  N-GObject $renderer, gint $number_of_rows
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_cell_renderer_text_new:
#`{{
=begin pod
=head2 _gtk_cell_renderer_text_new

Creates a new B<Gnome::Gtk3::CellRendererText>. Adjust how text is drawn using object properties. Object properties can be set globally (with C<g_object_set()>). Also, with B<Gnome::Gtk3::TreeViewColumn>, you can bind a property to a value in a B<Gnome::Gtk3::TreeModel>. For example, you can bind the “text” property on the cell renderer to a string value in the model, thus rendering a different string in each row of the B<Gnome::Gtk3::TreeView>

Returns: the new cell renderer

  method _gtk_cell_renderer_text_new ( --> N-GObject )

=end pod
}}

sub _gtk_cell_renderer_text_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_cell_renderer_text_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:edited:
=head2 edited

This signal is emitted after I<renderer> has been edited.

It is the responsibility of the application to update the model
and store I<new_text> at the position indicated by I<path>.

  method handler (
    Str $path,
    Str $new_text,
    Gnome::Gtk3::CellRendererText :_widget($renderer),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $path; the path identifying the edited cell
=item $new_text; the new text
=item $renderer; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:0:alignment:
=head2 alignment

How to align the lines

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item the type of this G_TYPE_ENUM object is PANGO_TYPE_ALIGNMENT
=item Parameter is readable and writable.
=item Default value is PANGO_ALIGN_LEFT.


=comment -----------------------------------------------------------------------
=comment #TP:0:attributes:
=head2 attributes

A list of style attributes to apply to the text of the renderer

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOXED
=item the type of this G_TYPE_BOXED object is PANGO_TYPE_ATTR_LIST
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:background:
=head2 background

Background color as a string

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:background-rgba:
=head2 background-rgba

Background color as a GdkRGBA

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOXED
=item the type of this G_TYPE_BOXED object is GDK_TYPE_RGBA
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:1:editable:
=head2 editable

Whether the text can be modified by the user

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:ellipsize:
=head2 ellipsize

The preferred place to ellipsize the string, if the cell renderer does not have enough room to display the entire string

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item the type of this G_TYPE_ENUM object is PANGO_TYPE_ELLIPSIZE_MODE
=item Parameter is readable and writable.
=item Default value is PANGO_ELLIPSIZE_NONE.


=comment -----------------------------------------------------------------------
=comment #TP:1:family:
=head2 family

Name of the font family, e.g. Sans_COMMA_ Helvetica_COMMA_ Times_COMMA_ Monospace

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:font:
=head2 font

Font description as a string, e.g. \Sans Italic 12\

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:font-desc:
=head2 font-desc

Font description as a PangoFontDescription struct

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOXED
=item the type of this G_TYPE_BOXED object is PANGO_TYPE_FONT_DESCRIPTION
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:0:foreground:
=head2 foreground

Foreground color as a string

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:foreground-rgba:
=head2 foreground-rgba

Foreground color as a GdkRGBA

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOXED
=item the type of this G_TYPE_BOXED object is GDK_TYPE_RGBA
=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:1:language:
=head2 language

The language this text is in, as an ISO code. Pango can use this as a hint when rendering the text. If you don't understand this parameter_COMMA_ you probably don't need it

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:0:markup:
=head2 markup

Marked up text to render

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:1:max-width-chars:
=head2 max-width-chars

The maximum width of the cell, in characters

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable and writable.
=item Minimum value is -1.
=item Maximum value is G_MAXINT.
=item Default value is -1.


=comment -----------------------------------------------------------------------
=comment #TP:1:placeholder-text:
=head2 placeholder-text

Text rendered when an editable cell is empty

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:1:rise:
=head2 rise

Offset of text above the baseline (below the baseline if rise is negative)

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable and writable.
=item Minimum value is -G_MAXINT.
=item Maximum value is G_MAXINT.
=item Default value is 0.


=comment -----------------------------------------------------------------------
=comment #TP:1:scale:
=head2 scale

Font scaling factor

=item B<Gnome::GObject::Value> type of this property is G_TYPE_DOUBLE
=item Parameter is readable and writable.
=item Minimum value is 0.0.
=item Maximum value is G_MAXDOUBLE.
=item Default value is 1.0.


=comment -----------------------------------------------------------------------
=comment #TP:1:single-paragraph-mode:
=head2 single-paragraph-mode

Whether to keep all text in a single paragraph

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:size:
=head2 size

Font size

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is G_MAXINT.
=item Default value is 0.


=comment -----------------------------------------------------------------------
=comment #TP:1:size-points:
=head2 size-points

Font size in points

=item B<Gnome::GObject::Value> type of this property is G_TYPE_DOUBLE
=item Parameter is readable and writable.
=item Minimum value is 0.0.
=item Maximum value is G_MAXDOUBLE.
=item Default value is 0.0.


=comment -----------------------------------------------------------------------
=comment #TP:1:stretch:
=head2 stretch

Font stretch

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item the type of this G_TYPE_ENUM object is PANGO_TYPE_STRETCH
=item Parameter is readable and writable.
=item Default value is PANGO_STRETCH_NORMAL.


=comment -----------------------------------------------------------------------
=comment #TP:1:strikethrough:
=head2 strikethrough

Whether to strike through the text

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:0:style:
=head2 style

Font style

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item the type of this G_TYPE_ENUM object is PANGO_TYPE_STYLE
=item Parameter is readable and writable.
=item Default value is PANGO_STYLE_NORMAL.


=comment -----------------------------------------------------------------------
=comment #TP:1:text:
=head2 text

Text to render

=item B<Gnome::GObject::Value> type of this property is G_TYPE_STRING
=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:1:underline:
=head2 underline

Style of underline for this text

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item the type of this G_TYPE_ENUM object is PANGO_TYPE_UNDERLINE
=item Parameter is readable and writable.
=item Default value is PANGO_UNDERLINE_NONE.


=comment -----------------------------------------------------------------------
=comment #TP:1:variant:
=head2 variant

Font variant

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item the type of this G_TYPE_ENUM object is PANGO_TYPE_VARIANT
=item Parameter is readable and writable.
=item Default value is PANGO_VARIANT_NORMAL.


=comment -----------------------------------------------------------------------
=comment #TP:1:weight:
=head2 weight

Font weight

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is G_MAXINT.
=item Default value is PANGO_WEIGHT_NORMAL.


=comment -----------------------------------------------------------------------
=comment #TP:1:width-chars:
=head2 width-chars

The desired width of the label, in characters

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable and writable.
=item Minimum value is -1.
=item Maximum value is G_MAXINT.
=item Default value is -1.


=comment -----------------------------------------------------------------------
=comment #TP:1:wrap-mode:
=head2 wrap-mode

How to break the string into multiple lines, if the cell renderer does not have enough room to display the entire string

=item B<Gnome::GObject::Value> type of this property is G_TYPE_ENUM
=item the type of this G_TYPE_ENUM object is PANGO_TYPE_WRAP_MODE
=item Parameter is readable and writable.
=item Default value is PANGO_WRAP_CHAR.


=comment -----------------------------------------------------------------------
=comment #TP:1:wrap-width:
=head2 wrap-width

The width at which the text is wrapped

=item B<Gnome::GObject::Value> type of this property is G_TYPE_INT
=item Parameter is readable and writable.
=item Minimum value is -1.
=item Maximum value is G_MAXINT.
=item Default value is -1.

=end pod
