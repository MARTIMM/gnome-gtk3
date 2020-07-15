#TL:1:Gnome::Gtk3::Label:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Label

A widget that displays a small to medium amount of text

![](images/label.png)

=head1 Description


The B<Gnome::Gtk3::Label> widget displays a small amount of text. As the name
implies, most labels are used to label another widget such as a
B<Gnome::Gtk3::Button>, a B<Gnome::Gtk3::MenuItem>, or a B<Gnome::Gtk3::ComboBox>.


=head2 Css Nodes

  label
  ├── [selection]
  ├── [link]
  ┊
  ╰── [link]

B<Gnome::Gtk3::Label> has a single CSS node with the name label. A wide variety
of style classes may be applied to labels, such as .title, .subtitle,
.dim-label, etc. In the B<Gnome::Gtk3::ShortcutsWindow>, labels are used wth the
.keycap style class.

If the label has a selection, it gets a subnode with name selection.

If the label has links, there is one subnode per link. These subnodes
carry the link or visited state depending on whether they have been
visited.

=begin comment
=head2 Gnome::Gtk3::Label as Gnome::Gtk3::Buildable

The B<Gnome::Gtk3::Label> implementation of the B<Gnome::Gtk3::Buildable> interface supports a
custom <attributes> element, which supports any number of <attribute>
elements. The <attribute> element has attributes named “name“, “value“,
“start“ and “end“ and allows you to specify B<PangoAttribute> values for
this label.

An example of a UI definition fragment specifying Pango attributes:

  <object class="GtkLabel">
    <attributes>
      <attribute name="weight" value="PANGO_WEIGHT_BOLD"/>
      <attribute name="background" value="red" start="5" end="10"/>"
    </attributes>
  </object>

=end comment

The start and end attributes specify the range of characters to which the
Pango attribute applies. If start and end are not specified, the attribute is
applied to the whole text. Note that specifying ranges does not make much
sense with translatable attributes. Use markup embedded in the translatable
content instead.


=head2 Mnemonics

Labels may contain “mnemonics”. Mnemonics are
underlined characters in the label, used for keyboard navigation.
Mnemonics are created by providing a string with an underscore before
the mnemonic character, such as `"_File"`, to the
functions C<gtk_label_new_with_mnemonic()> or
C<gtk_label_set_text_with_mnemonic()>.

Mnemonics automatically activate any activatable widget the label is
inside, such as a B<Gnome::Gtk3::Button>; if the label is not inside the
mnemonic’s target widget, you have to tell the label about the target
using C<.new(:mnemonic())>. Here’s a simple example where
the label is inside a button:

  # Pressing Alt+H will activate this button
  my Gnome::Gtk3::Button $b .= new;
  my Gnome::Gtk3::Label $l .= new(:mnemonic<_Hello>);
  $b.gtk-container-add($l);


There’s a convenience function to create buttons with a mnemonic label
already inside:

  # Pressing Alt+H will activate this button
  my Gnome::Gtk3::Button $b .= new(:mnemonic<_Hello>);


To create a mnemonic for a widget alongside the label, such as a
B<Gnome::Gtk3::Entry>, you have to point the label at the entry with
C<gtk_label_set_mnemonic_widget()>:

  # Pressing Alt+H will focus the entry
  my Gnome::Gtk3::Entry $e .= new;
  my Gnome::Gtk3::Label $l .= new(:mnemonic<_Hello>);
  $l.set-mnemonic-widget($e);

=begin comment
=head2 Markup (styled text)

To make it easy to format text in a label (changing colors,
fonts, etc.), label text can be provided in a simple
[markup format][PangoMarkupFormat].

Here’s how to create a label with a small font:
|[<!-- language="C" -->
  label = gtk_label_new (NULL);
  gtk_label_set_markup (GTK_LABEL (label), "<small>Small text</small>");
]|

(See [complete documentation][PangoMarkupFormat] of available
tags in the Pango manual.)

The markup passed to C<gtk_label_set_markup()> must be valid; for example,
literal <, > and & characters must be escaped as &lt;, &gt;, and &amp;.
If you pass text obtained from the user, file, or a network to
C<gtk_label_set_markup()>, you’ll want to escape it with
C<g_markup_escape_text()> or C<g_markup_printf_escaped()>.

Markup strings are just a convenient way to set the B<PangoAttrList> on
a label; C<gtk_label_set_attributes()> may be a simpler way to set
attributes in some cases. Be careful though; B<PangoAttrList> tends to
cause internationalization problems, unless you’re applying attributes
to the entire string (i.e. unless you set the range of each attribute
to [0, C<G_MAXINT>)). The reason is that specifying the start_index and
end_index for a B<PangoAttribute> requires knowledge of the exact string
being displayed, so translations will cause problems.
=end comment

=head2 Selectable labels

Labels can be made selectable with C<gtk_label_set_selectable()>.
Selectable labels allow the user to copy the label contents to
the clipboard. Only labels that contain useful-to-copy information
— such as error messages — should be made selectable.

=begin comment
=head2 Text layout

A label can contain any number of paragraphs, but will have
performance problems if it contains more than a small number.
Paragraphs are separated by newlines or other paragraph separators
understood by Pango.

Labels can automatically wrap text if you call
C<gtk_label_set_line_wrap()>.

C<gtk_label_set_justify()> sets how the lines in a label align
with one another. If you want to set how the label as a whole
aligns in its available space, see the  I<halign> and
 I<valign> properties.

The  I<width-chars> and  I<max-width-chars> properties
can be used to control the size allocation of ellipsized or wrapped
labels. For ellipsizing labels, if either is specified (and less
than the actual text size), it is used as the minimum width, and the actual
text size is used as the natural width of the label. For wrapping labels,
width-chars is used as the minimum width, if specified, and max-width-chars
is used as the natural width. Even if max-width-chars specified, wrapping
labels will be rewrapped to use all of the available width.

Note that the interpretation of  I<width-chars> and
 I<max-width-chars> has changed a bit with the introduction of
[width-for-height geometry management.][geometry-management]
=end comment

=head2 Links

Since 2.18, GTK+ supports markup for clickable hyperlinks in addition
to regular Pango markup. The markup for links is borrowed from HTML,
using the `<a>` with “href“ and “title“ attributes. GTK+ renders links
similar to the way they appear in web browsers, with colored, underlined
text. The “title“ attribute is displayed as a tooltip on the link.

An example looks like this:

  my Str $text = [+] "Go to the",
    "<a href=\"http://www.gtk.org title="&lt;i&gt;Our&lt;/i&gt; website\">",
    "GTK+ website</a> for more...";
  my Gnome::Gtk3::Label $l .= new;
  $l.set-markup($text);

It is possible to implement custom handling for links and their tooltips with
the  I<activate-link> signal and the C<gtk_label_get_current_uri()> function.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Label;
  also is Gnome::Gtk3::Misc;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Misc;

#use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtklabel.h
# https://developer.gnome.org/gtk3/stable/GtkLabel.html
unit class Gnome::Gtk3::Label:auth<github:MARTIMM>;
also is Gnome::Gtk3::Misc;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new object with text.

  multi method new ( Str :text! )

Create a new object with mnemonic.

  multi method new ( Str :mnemonic! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new(:text):
#TM:1:new(:mnemonic):
#TM:1:new(:native-object):
#TM:1:new(:build-id):
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w3<move-cursor>, :w0<copy-clipboard activate-current-link>,
    :w1<populate-popup activate-link>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::Label';

  if %options<text>.defined {
    self.set-native-object(gtk_label_new(%options<text>));
  }

  elsif %options<mnemonic>.defined {
    self.set-native-object(gtk_label_new_with_mnemonic(%options<mnemonic>));
  }

  elsif ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkLabel');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;

  try { $s = &::("gtk_label_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkLabel') if ?$s;
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:2:gtk_label_new:new(:text)
=begin pod
=head2 [gtk_] label_new

Creates a new label with the given text inside it. You can
pass C<Any> to get an empty label widget.

Returns: the new B<Gnome::Gtk3::Label>

  method gtk_label_new ( Str $str --> N-GObject  )

=item Str $str; (allow-none): The text of the label

=end pod

sub gtk_label_new ( Str $str )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_label_new_with_mnemonic:new(:mnemonic)
=begin pod
=head2 [[gtk_] label_] new_with_mnemonic

Creates a new B<Gnome::Gtk3::Label>, containing the text in I<str>.

If characters in I<str> are preceded by an underscore, they are
underlined. If you need a literal underscore character in a label, use
'__' (two underscores). The first underlined character represents a
keyboard accelerator called a mnemonic. The mnemonic key can be used
to activate another widget, chosen automatically, or explicitly using
C<gtk_label_set_mnemonic_widget()>.

If C<gtk_label_set_mnemonic_widget()> is not called, then the first
activatable ancestor of the B<Gnome::Gtk3::Label> will be chosen as the mnemonic
widget. For instance, if the label is inside a button or menu item,
the button or menu item will automatically become the mnemonic widget
and be activated by the mnemonic.

Returns: the new B<Gnome::Gtk3::Label>

  method gtk_label_new_with_mnemonic ( Str $str --> N-GObject  )

=item Str $str; (allow-none): The text of the label, with an underscore in front of the mnemonic character

=end pod

sub gtk_label_new_with_mnemonic ( Str $str )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_label_set_text:
=begin pod
=head2 [[gtk_] label_] set_text

Sets the text within the B<Gnome::Gtk3::Label> widget. It overwrites any text that
was there before.

This function will clear any previously set mnemonic accelerators, and
set the  I<use-underline> property to C<0> as a side effect.

This function will set the  I<use-markup> property to C<0>
as a side effect.

See also: C<gtk_label_set_markup()>

  method gtk_label_set_text ( Str $str )

=item Str $str; The text you want to set

=end pod

sub gtk_label_set_text ( N-GObject $label, Str $str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_label_get_text:
=begin pod
=head2 [[gtk_] label_] get_text

Fetches the text from a label widget, as displayed on the
screen. This does not include any embedded underlines
indicating mnemonics or Pango markup. (See C<gtk_label_get_label()>)

Returns: the text in the label widget. This is the internal
string used by the label, and must not be modified.

  method gtk_label_get_text ( --> Str  )


=end pod

sub gtk_label_get_text ( N-GObject $label )
  returns Str
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_attributes:
=begin pod
=head2 [[gtk_] label_] set_attributes

Sets a B<PangoAttrList>; the attributes in the list are applied to the
label text.

The attributes set with this function will be applied
and merged with any other attributes previously effected by way
of the  I<use-underline> or  I<use-markup> properties.
While it is not recommended to mix markup strings with manually set
attributes, if you must; know that the attributes will be applied
to the label after the markup string is parsed.

  method gtk_label_set_attributes ( PangoAttrList $attrs )

=item PangoAttrList $attrs; (allow-none): a B<PangoAttrList>, or C<Any>

=end pod

sub gtk_label_set_attributes ( N-GObject $label, PangoAttrList $attrs )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_attributes:
=begin pod
=head2 [[gtk_] label_] get_attributes

Gets the attribute list that was set on the label using
C<gtk_label_set_attributes()>, if any. This function does
not reflect attributes that come from the labels markup
(see C<gtk_label_set_markup()>). If you want to get the
effective attributes for the label, use
pango_layout_get_attribute (gtk_label_get_layout (label)).

Returns: (nullable) (transfer none): the attribute list, or C<Any>
if none was set.

  method gtk_label_get_attributes ( --> PangoAttrList  )


=end pod

sub gtk_label_get_attributes ( N-GObject $label )
  returns PangoAttrList
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_label_set_label:
=begin pod
=head2 [[gtk_] label_] set_label

Sets the text of the label. The label is interpreted as
including embedded underlines and/or Pango markup depending
on the values of the  I<use-underline> and
 I<use-markup> properties.

  method gtk_label_set_label ( Str $str )

=item Str $str; the new text to set for the label

=end pod

sub gtk_label_set_label ( N-GObject $label, Str $str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_label_get_label:
=begin pod
=head2 [[gtk_] label_] get_label

Fetches the text from a label widget including any embedded
underlines indicating mnemonics and Pango markup. (See
C<gtk_label_get_text()>).

Returns: the text of the label widget. This string is
owned by the widget and must not be modified or freed.

  method gtk_label_get_label ( --> Str  )


=end pod

sub gtk_label_get_label ( N-GObject $label )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_markup:
=begin pod
=head2 [[gtk_] label_] set_markup

Parses I<$str> which is marked up with the Pango text markup language, setting the label’s text and attribute list based on the parse results.

=begin comment
If the I<$str> is external data, you may need to escape it with C<g_markup_escape_text()> or C<g_markup_printf_escaped()>:

  my Gnome::Glib::Markup .= new(...)
  my Str $format = "<span style=\"italic\">\C<s></span>";
  my Str $markup =


const char *format = "<span style=\"italic\">\C<s></span>";
char *markup;

markup = g_markup_printf_escaped (format, str);
gtk_label_set_markup (GTK_LABEL (label), markup);
g_free (markup);
]|
=end comment

This function will set the  I<use-markup> property to C<1> as a side effect.

If you set the label contents using the  I<label> property you should also ensure that you set the  I<use-markup> property accordingly.

See also: C<gtk_label_set_text()>

  method gtk_label_set_markup ( Str $str )

=item Str $str; a markup string (see [Pango markup format][PangoMarkupFormat])

=end pod

sub gtk_label_set_markup ( N-GObject $label, Str $str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_label_set_use_markup:
=begin pod
=head2 [[gtk_] label_] set_use_markup

Sets whether the text of the label contains markup in
[Pango’s text markup language](https://developer.gnome.org/pygtk/stable/pango-markup-language.html).
See C<gtk_label_set_markup()>.

  method gtk_label_set_use_markup ( Int $setting )

=item Int $setting; C<1> if the label’s text should be parsed for markup.

=end pod

sub gtk_label_set_use_markup ( N-GObject $label, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_label_get_use_markup:
=begin pod
=head2 [[gtk_] label_] get_use_markup

Returns whether the label’s text is interpreted as marked up with
the [Pango text markup language][PangoMarkupFormat].
See C<gtk_label_set_use_markup()>.

Returns: C<1> if the label’s text will be parsed for markup.

  method gtk_label_get_use_markup ( --> Int  )


=end pod

sub gtk_label_get_use_markup ( N-GObject $label )
  returns int32
  is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
#TM:1:gtk_label_set_use_underline:
=begin pod
=head2 [[gtk_] label_] set_use_underline

If true, an underline in the text indicates the next character should be
used for the mnemonic accelerator key.

  method gtk_label_set_use_underline ( Int $setting )

=item Int $setting; C<1> if underlines in the text indicate mnemonics

=end pod

sub gtk_label_set_use_underline ( N-GObject $label, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_use_underline:
=begin pod
=head2 [[gtk_] label_] get_use_underline

Returns whether an embedded underline in the label indicates a
mnemonic. See C<gtk_label_set_use_underline()>.

Returns: C<1> whether an embedded underline in the label indicates
the mnemonic accelerator keys.

  method gtk_label_get_use_underline ( --> Int  )


=end pod

sub gtk_label_get_use_underline ( N-GObject $label )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_markup_with_mnemonic:
=begin pod
=head2 [[gtk_] label_] set_markup_with_mnemonic

Parses I<str> which is marked up with the
[Pango text markup language](https://developer.gnome.org/pygtk/stable/pango-markup-language.html),
setting the label’s text and attribute list based on the parse results.
If characters in I<str> are preceded by an underscore, they are underlined
indicating that they represent a keyboard accelerator called a mnemonic.

The mnemonic key can be used to activate another widget, chosen
automatically, or explicitly using C<gtk_label_set_mnemonic_widget()>.

  method gtk_label_set_markup_with_mnemonic ( Str $str )

=item Str $str; a markup string (see [Pango markup format][PangoMarkupFormat])

=end pod

sub gtk_label_set_markup_with_mnemonic ( N-GObject $label, Str $str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_mnemonic_keyval:
=begin pod
=head2 [[gtk_] label_] get_mnemonic_keyval

If the label has been set so that it has an mnemonic key this function
returns the keyval used for the mnemonic accelerator. If there is no
mnemonic set up it returns B<GDK_KEY_VoidSymbol>.

Returns: GDK keyval usable for accelerators, or B<GDK_KEY_VoidSymbol>

  method gtk_label_get_mnemonic_keyval ( --> UInt  )


=end pod

sub gtk_label_get_mnemonic_keyval ( N-GObject $label )
  returns uint32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_mnemonic_widget:
=begin pod
=head2 [[gtk_] label_] set_mnemonic_widget

If the label has been set so that it has an mnemonic key (using
i.e. C<gtk_label_set_markup_with_mnemonic()>,
C<gtk_label_set_text_with_mnemonic()>, C<gtk_label_new_with_mnemonic()>
or the “use_underline” property) the label can be associated with a
widget that is the target of the mnemonic. When the label is inside
a widget (like a B<Gnome::Gtk3::Button> or a B<Gnome::Gtk3::Notebook> tab) it is
automatically associated with the correct widget, but sometimes
(i.e. when the target is a B<Gnome::Gtk3::Entry> next to the label) you need to
set it explicitly using this function.

The target widget will be accelerated by emitting the
B<Gnome::Gtk3::Widget>::mnemonic-activate signal on it. The default handler for
this signal will activate the widget if there are no mnemonic collisions
and toggle focus between the colliding widgets otherwise.

  method gtk_label_set_mnemonic_widget ( N-GObject $widget )

=item N-GObject $widget; (allow-none): the target B<Gnome::Gtk3::Widget>

=end pod

sub gtk_label_set_mnemonic_widget ( N-GObject $label, N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_mnemonic_widget:
=begin pod
=head2 [[gtk_] label_] get_mnemonic_widget

Retrieves the target of the mnemonic (keyboard shortcut) of this
label. See C<gtk_label_set_mnemonic_widget()>.

Returns: (nullable) (transfer none): the target of the label’s mnemonic,
or C<Any> if none has been set and the default algorithm will be used.

  method gtk_label_get_mnemonic_widget ( --> N-GObject  )


=end pod

sub gtk_label_get_mnemonic_widget ( N-GObject $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_label_set_text_with_mnemonic:
=begin pod
=head2 [[gtk_] label_] set_text_with_mnemonic

Sets the label’s text from the string I<str>.
If characters in I<str> are preceded by an underscore, they are underlined
indicating that they represent a keyboard accelerator called a mnemonic.
The mnemonic key can be used to activate another widget, chosen
automatically, or explicitly using C<gtk_label_set_mnemonic_widget()>.

  method gtk_label_set_text_with_mnemonic ( Str $str )

=item Str $str; a string

=end pod

sub gtk_label_set_text_with_mnemonic ( N-GObject $label, Str $str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_justify:
=begin pod
=head2 [[gtk_] label_] set_justify

Sets the alignment of the lines in the text of the label relative to
each other. C<GTK_JUSTIFY_LEFT> is the default value when the widget is
first created with C<gtk_label_new()>. If you instead want to set the
alignment of the label as a whole, use C<gtk_widget_set_halign()> instead.
C<gtk_label_set_justify()> has no effect on labels containing only a
single line.

  method gtk_label_set_justify ( GtkJustification $jtype )

=item GtkJustification $jtype; a B<Gnome::Gtk3::Justification>

=end pod

sub gtk_label_set_justify ( N-GObject $label, int32 $jtype )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_justify:
=begin pod
=head2 [[gtk_] label_] get_justify

Returns the justification of the label. See C<gtk_label_set_justify()>.

Returns: B<Gnome::Gtk3::Justification>

  method gtk_label_get_justify ( --> GtkJustification  )


=end pod

sub gtk_label_get_justify ( N-GObject $label )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_ellipsize:
=begin pod
=head2 [[gtk_] label_] set_ellipsize

Sets the mode used to ellipsize (add an ellipsis: "...") to the text
if there is not enough space to render the entire string.

Since: 2.6

  method gtk_label_set_ellipsize ( PangoEllipsizeMode $mode )

=item PangoEllipsizeMode $mode; a B<PangoEllipsizeMode>

=end pod

sub gtk_label_set_ellipsize ( N-GObject $label, PangoEllipsizeMode $mode )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_ellipsize:
=begin pod
=head2 [[gtk_] label_] get_ellipsize

Returns the ellipsizing position of the label. See C<gtk_label_set_ellipsize()>.

Returns: B<PangoEllipsizeMode>

Since: 2.6

  method gtk_label_get_ellipsize ( --> PangoEllipsizeMode  )


=end pod

sub gtk_label_get_ellipsize ( N-GObject $label )
  returns PangoEllipsizeMode
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_width_chars:
=begin pod
=head2 [[gtk_] label_] set_width_chars

Sets the desired width in characters of I<label> to I<n_chars>.

Since: 2.6

  method gtk_label_set_width_chars ( Int $n_chars )

=item Int $n_chars; the new desired width, in characters.

=end pod

sub gtk_label_set_width_chars ( N-GObject $label, int32 $n_chars )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_width_chars:
=begin pod
=head2 [[gtk_] label_] get_width_chars

Retrieves the desired width of I<label>, in characters. See
C<gtk_label_set_width_chars()>.

Returns: the width of the label in characters.

Since: 2.6

  method gtk_label_get_width_chars ( --> Int  )


=end pod

sub gtk_label_get_width_chars ( N-GObject $label )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_max_width_chars:
=begin pod
=head2 [[gtk_] label_] set_max_width_chars

Sets the desired maximum width in characters of I<label> to I<n_chars>.

Since: 2.6

  method gtk_label_set_max_width_chars ( Int $n_chars )

=item Int $n_chars; the new desired maximum width, in characters.

=end pod

sub gtk_label_set_max_width_chars ( N-GObject $label, int32 $n_chars )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_max_width_chars:
=begin pod
=head2 [[gtk_] label_] get_max_width_chars

Retrieves the desired maximum width of I<label>, in characters. See
C<gtk_label_set_width_chars()>.

Returns: the maximum width of the label in characters.

Since: 2.6

  method gtk_label_get_max_width_chars ( --> Int  )


=end pod

sub gtk_label_get_max_width_chars ( N-GObject $label )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_lines:
=begin pod
=head2 [[gtk_] label_] set_lines

Sets the number of lines to which an ellipsized, wrapping label
should be limited. This has no effect if the label is not wrapping
or ellipsized. Set this to -1 if you don’t want to limit the
number of lines.

Since: 3.10

  method gtk_label_set_lines ( Int $lines )

=item Int $lines; the desired number of lines, or -1

=end pod

sub gtk_label_set_lines ( N-GObject $label, int32 $lines )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_lines:
=begin pod
=head2 [[gtk_] label_] get_lines

Gets the number of lines to which an ellipsized, wrapping
label should be limited. See C<gtk_label_set_lines()>.

Returns: The number of lines

Since: 3.10

  method gtk_label_get_lines ( --> Int  )


=end pod

sub gtk_label_get_lines ( N-GObject $label )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_pattern:
=begin pod
=head2 [[gtk_] label_] set_pattern

The pattern of underlines you want under the existing text within the
B<Gnome::Gtk3::Label> widget.  For example if the current text of the label says
“FooBarBaz” passing a pattern of “___   ___” will underline
“Foo” and “Baz” but not “Bar”.

  method gtk_label_set_pattern ( Str $pattern )

=item Str $pattern; The pattern as described above.

=end pod

sub gtk_label_set_pattern ( N-GObject $label, Str $pattern )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_line_wrap:
=begin pod
=head2 [[gtk_] label_] set_line_wrap

Toggles line wrapping within the B<Gnome::Gtk3::Label> widget. C<1> makes it break
lines if text exceeds the widget’s size. C<0> lets the text get cut off
by the edge of the widget if it exceeds the widget size.

Note that setting line wrapping to C<1> does not make the label
wrap at its parent container’s width, because GTK+ widgets
conceptually can’t make their requisition depend on the parent
container’s size. For a label that wraps at a specific position,
set the label’s width using C<gtk_widget_set_size_request()>.

  method gtk_label_set_line_wrap ( Int $wrap )

=item Int $wrap; the setting

=end pod

sub gtk_label_set_line_wrap ( N-GObject $label, int32 $wrap )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_line_wrap:
=begin pod
=head2 [[gtk_] label_] get_line_wrap

Returns whether lines in the label are automatically wrapped.
See C<gtk_label_set_line_wrap()>.

Returns: C<1> if the lines of the label are automatically wrapped.

  method gtk_label_get_line_wrap ( --> Int  )


=end pod

sub gtk_label_get_line_wrap ( N-GObject $label )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_line_wrap_mode:
=begin pod
=head2 [[gtk_] label_] set_line_wrap_mode

If line wrapping is on (see C<gtk_label_set_line_wrap()>) this controls how
the line wrapping is done. The default is C<PANGO_WRAP_WORD> which means
wrap on word boundaries.

Since: 2.10

  method gtk_label_set_line_wrap_mode ( PangoWrapMode $wrap_mode )

=item PangoWrapMode $wrap_mode; the line wrapping mode

=end pod

sub gtk_label_set_line_wrap_mode ( N-GObject $label, PangoWrapMode $wrap_mode )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_line_wrap_mode:
=begin pod
=head2 [[gtk_] label_] get_line_wrap_mode

Returns line wrap mode used by the label. See C<gtk_label_set_line_wrap_mode()>.

Returns: C<1> if the lines of the label are automatically wrapped.

Since: 2.10

  method gtk_label_get_line_wrap_mode ( --> PangoWrapMode  )


=end pod

sub gtk_label_get_line_wrap_mode ( N-GObject $label )
  returns PangoWrapMode
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_selectable:
=begin pod
=head2 [[gtk_] label_] set_selectable

Selectable labels allow the user to select text from the label, for
copy-and-paste.

  method gtk_label_set_selectable ( Int $setting )

=item Int $setting; C<1> to allow selecting text in the label

=end pod

sub gtk_label_set_selectable ( N-GObject $label, int32 $setting )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_selectable:
=begin pod
=head2 [[gtk_] label_] get_selectable

Gets the value set by C<gtk_label_set_selectable()>.

Returns: C<1> if the user can copy text from the label

  method gtk_label_get_selectable ( --> Int  )


=end pod

sub gtk_label_get_selectable ( N-GObject $label )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_angle:
=begin pod
=head2 [[gtk_] label_] set_angle

Sets the angle of rotation for the label. An angle of 90 reads from
from bottom to top, an angle of 270, from top to bottom. The angle
setting for the label is ignored if the label is selectable,
wrapped, or ellipsized.

Since: 2.6

  method gtk_label_set_angle ( Num $angle )

=item Num $angle; the angle that the baseline of the label makes with the horizontal, in degrees, measured counterclockwise

=end pod

sub gtk_label_set_angle ( N-GObject $label, num64 $angle )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_angle:
=begin pod
=head2 [[gtk_] label_] get_angle

Gets the angle of rotation for the label. See
C<gtk_label_set_angle()>.

Returns: the angle of rotation for the label

Since: 2.6

  method gtk_label_get_angle ( --> Num  )


=end pod

sub gtk_label_get_angle ( N-GObject $label )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_select_region:
=begin pod
=head2 [[gtk_] label_] select_region

Selects a range of characters in the label, if the label is selectable.
See C<gtk_label_set_selectable()>. If the label is not selectable,
this function has no effect. If I<start_offset> or
I<end_offset> are -1, then the end of the label will be substituted.

  method gtk_label_select_region ( Int $start_offset, Int $end_offset )

=item Int $start_offset; start offset (in characters not bytes)
=item Int $end_offset; end offset (in characters not bytes)

=end pod

sub gtk_label_select_region ( N-GObject $label, int32 $start_offset, int32 $end_offset )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_selection_bounds:
=begin pod
=head2 [[gtk_] label_] get_selection_bounds

Gets the selected range of characters in the label, returning C<1>
if there’s a selection.

Returns: C<1> if selection is non-empty

  method gtk_label_get_selection_bounds ( Int $start, Int $end --> Int  )

=item Int $start; (out): return location for start of selection, as a character offset
=item Int $end; (out): return location for end of selection, as a character offset

=end pod

sub gtk_label_get_selection_bounds ( N-GObject $label, int32 $start, int32 $end )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_layout:
=begin pod
=head2 [[gtk_] label_] get_layout

Gets the B<PangoLayout> used to display the label.
The layout is useful to e.g. convert text positions to
pixel positions, in combination with C<gtk_label_get_layout_offsets()>.
The returned layout is owned by the I<label> so need not be
freed by the caller. The I<label> is free to recreate its layout at
any time, so it should be considered read-only.

Returns: (transfer none): the B<PangoLayout> for this label

  method gtk_label_get_layout ( --> PangoLayout  )


=end pod

sub gtk_label_get_layout ( N-GObject $label )
  returns PangoLayout
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_layout_offsets:
=begin pod
=head2 [[gtk_] label_] get_layout_offsets

Obtains the coordinates where the label will draw the B<PangoLayout>
representing the text in the label; useful to convert mouse events
into coordinates inside the B<PangoLayout>, e.g. to take some action
if some part of the label is clicked. Of course you will need to
create a B<Gnome::Gtk3::EventBox> to receive the events, and pack the label
inside it, since labels are windowless (they return C<0> from
C<gtk_widget_get_has_window()>). Remember
when using the B<PangoLayout> functions you need to convert to
and from pixels using C<PANGO_PIXELS()> or B<PANGO_SCALE>.

  method gtk_label_get_layout_offsets ( Int $x, Int $y )

=item Int $x; (out) (allow-none): location to store X offset of layout, or C<Any>
=item Int $y; (out) (allow-none): location to store Y offset of layout, or C<Any>

=end pod

sub gtk_label_get_layout_offsets ( N-GObject $label, int32 $x, int32 $y )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_single_line_mode:
=begin pod
=head2 [[gtk_] label_] set_single_line_mode

Sets whether the label is in single line mode.

Since: 2.6

  method gtk_label_set_single_line_mode ( Int $single_line_mode )

=item Int $single_line_mode; C<1> if the label should be in single line mode

=end pod

sub gtk_label_set_single_line_mode ( N-GObject $label, int32 $single_line_mode )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_single_line_mode:
=begin pod
=head2 [[gtk_] label_] get_single_line_mode

Returns whether the label is in single line mode.

Returns: C<1> when the label is in single line mode.

Since: 2.6

  method gtk_label_get_single_line_mode ( --> Int  )


=end pod

sub gtk_label_get_single_line_mode ( N-GObject $label )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_current_uri:
=begin pod
=head2 [[gtk_] label_] get_current_uri

Returns the URI for the currently active link in the label.
The active link is the one under the mouse pointer or, in a
selectable label, the link in which the text cursor is currently
positioned.

This function is intended for use in a  I<activate-link> handler
or for use in a  I<query-tooltip> handler.

Returns: the currently active URI. The string is owned by GTK+ and must
not be freed or modified.

Since: 2.18

  method gtk_label_get_current_uri ( --> Str  )


=end pod

sub gtk_label_get_current_uri ( N-GObject $label )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_track_visited_links:
=begin pod
=head2 [[gtk_] label_] set_track_visited_links

Sets whether the label should keep track of clicked
links (and use a different color for them).

Since: 2.18

  method gtk_label_set_track_visited_links ( Int $track_links )

=item Int $track_links; C<1> to track visited links

=end pod

sub gtk_label_set_track_visited_links ( N-GObject $label, int32 $track_links )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_track_visited_links:
=begin pod
=head2 [[gtk_] label_] get_track_visited_links

Returns whether the label is currently keeping track
of clicked links.

Returns: C<1> if clicked links are remembered

Since: 2.18

  method gtk_label_get_track_visited_links ( --> Int  )


=end pod

sub gtk_label_get_track_visited_links ( N-GObject $label )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_xalign:
=begin pod
=head2 [[gtk_] label_] set_xalign

Sets the  I<xalign> property for I<label>.

Since: 3.16

  method gtk_label_set_xalign ( Num $xalign )

=item Num $xalign; the new xalign value, between 0 and 1

=end pod

sub gtk_label_set_xalign ( N-GObject $label, num32 $xalign )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_xalign:
=begin pod
=head2 [[gtk_] label_] get_xalign

Gets the  I<xalign> property for I<label>.

Returns: the xalign property

Since: 3.16

  method gtk_label_get_xalign ( --> Num  )


=end pod

sub gtk_label_get_xalign ( N-GObject $label )
  returns num32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_set_yalign:
=begin pod
=head2 [[gtk_] label_] set_yalign

Sets the  I<yalign> property for I<label>.

Since: 3.16

  method gtk_label_set_yalign ( Num $yalign )

=item Num $yalign; the new yalign value, between 0 and 1

=end pod

sub gtk_label_set_yalign ( N-GObject $label, num32 $yalign )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_label_get_yalign:
=begin pod
=head2 [[gtk_] label_] get_yalign

Gets the  I<yalign> property for I<label>.

Returns: the yalign property

Since: 3.16

  method gtk_label_get_yalign ( --> Num  )


=end pod

sub gtk_label_get_yalign ( N-GObject $label )
  returns num32
  is native(&gtk-lib)
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


=comment #TS:0:move-cursor:
=head3 move-cursor

The I<move-cursor> signal is a keybinding signal (GtkBindingSignal)
which gets emitted when the user initiates a cursor movement.
If the cursor is not visible in I<entry>, this signal causes
the viewport to be moved instead.

Applications should not connect to it, but may emit it with
C<g_signal_emit_by_name()> if they need to control the cursor
programmatically.

The default bindings for this signal come in two variants,
the variant with the Shift modifier extends the selection,
the variant without the Shift modifer does not.
There are too many key combinations to list them all here.
- Arrow keys move by individual characters/lines
- Ctrl-arrow key combinations move by words/paragraphs
- Home/End keys move to the ends of the buffer

  method handler (
    Unknown type GTK_TYPE_MOVEMENT_STEP $step,
    Int $count,
    Int $extend_selection,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($entry),
    *%user-options
  );

=item $entry; the object which received the signal

=item $step; the granularity of the move, as a B<Gnome::Gtk3::MovementStep>

=item $count; the number of I<step> units to move

=item $extend_selection; C<1> if the move should extend the selection


=comment #TS:0:copy-clipboard:
=head3 copy-clipboard

The I<copy-clipboard> signal is a
[keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted to copy the selection to the clipboard.

The default binding for this signal is Ctrl-c.

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($label),
    *%user-options
  );

=item $label; the object which received the signal


=comment #TS:0:populate-popup:
=head3 populate-popup

The I<populate-popup> signal gets emitted before showing the
context menu of the label. Note that only selectable labels
have context menus.

If you need to add items to the context menu, connect
to this signal and append your menuitems to the I<menu>.

  method handler (
    Unknown type GTK_TYPE_MENU $menu,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($label),
    *%user-options
  );

=item $label; The label on which the signal is emitted

=item $menu; the menu that is being populated


=comment #TS:0:activate-current-link:
=head3 activate-current-link

A [keybinding signal][B<Gnome::Gtk3::BindingSignal>]
which gets emitted when the user activates a link in the label.

Applications may also emit the signal with C<g_signal_emit_by_name()>
if they need to control activation of URIs programmatically.

The default bindings for this signal are all forms of the Enter key.

Since: 2.18

  method handler (
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($label),
    *%user-options
  );

=item $label; The label on which the signal was emitted


=comment #TS:0:activate-link:
=head3 activate-link

The signal which gets emitted to activate a URI.
Applications may connect to it to override the default behaviour,
which is to call C<gtk_show_uri()>.

Returns: C<1> if the link has been activated

Since: 2.18

  method handler (
    Str $uri,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($label),
    *%user-options
    --> Int
  );

=item $label; The label on which the signal was emitted

=item $uri; the URI that is activated


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

=comment #TP:0:label:
=head3 Label


The contents of the label.
If the string contains [Pango XML markup][PangoMarkupFormat], you will
have to set the  I<use-markup> property to C<1> in order for the
label to display the markup attributes. See also C<gtk_label_set_markup()>
for a convenience function that sets both this property and the
 I<use-markup> property at the same time.
If the string contains underlines acting as mnemonics, you will have to
set the  I<use-underline> property to C<1> in order for the label
to display them.

The B<Gnome::GObject::Value> type of property I<label> is C<G_TYPE_STRING>.

=comment #TP:0:attributes:
=head3 Attributes



The B<Gnome::GObject::Value> type of property I<attributes> is C<G_TYPE_BOXED>.

=comment #TP:0:use-markup:
=head3 Use markup

The text of the label includes XML markup. See C<pango_parse_markup()>
Default value: False


The B<Gnome::GObject::Value> type of property I<use-markup> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:use-underline:
=head3 Use underline

If set, an underline in the text indicates the next character should be used for the mnemonic accelerator key
Default value: False


The B<Gnome::GObject::Value> type of property I<use-underline> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:justify:
=head3 Justification

The alignment of the lines in the text of the label relative to each other. This does NOT affect the alignment of the label within its allocation. See B<Gnome::Gtk3::Label>:xalign for that
Default value: False


The B<Gnome::GObject::Value> type of property I<justify> is C<G_TYPE_ENUM>.

=comment #TP:0:xalign:
=head3 X align


The xalign property determines the horizontal aligment of the label text
inside the labels size allocation. Compare this to  I<halign>,
which determines how the labels size allocation is positioned in the
space available for the label.
Since: 3.16

The B<Gnome::GObject::Value> type of property I<xalign> is C<G_TYPE_FLOAT>.

=comment #TP:0:yalign:
=head3 Y align


The yalign property determines the vertical aligment of the label text
inside the labels size allocation. Compare this to  I<valign>,
which determines how the labels size allocation is positioned in the
space available for the label.
Since: 3.16

The B<Gnome::GObject::Value> type of property I<yalign> is C<G_TYPE_FLOAT>.

=comment #TP:0:pattern:
=head3 Pattern

A string with _ characters in positions correspond to characters in the text to underline
Default value: Any


The B<Gnome::GObject::Value> type of property I<pattern> is C<G_TYPE_STRING>.

=comment #TP:0:wrap:
=head3 Line wrap

If set, wrap lines if the text becomes too wide
Default value: False


The B<Gnome::GObject::Value> type of property I<wrap> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:wrap-mode:
=head3 Line wrap mode


If line wrapping is on (see the  I<wrap> property) this controls
how the line wrapping is done. The default is C<PANGO_WRAP_WORD>, which
means wrap on word boundaries.
Since: 2.10
Widget type: PANGO_TYPE_WRAP_MODE

The B<Gnome::GObject::Value> type of property I<wrap-mode> is C<G_TYPE_ENUM>.

=comment #TP:0:selectable:
=head3 Selectable

Whether the label text can be selected with the mouse
Default value: False


The B<Gnome::GObject::Value> type of property I<selectable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:mnemonic-keyval:
=head3 Mnemonic key



The B<Gnome::GObject::Value> type of property I<mnemonic-keyval> is C<G_TYPE_UINT>.

=comment #TP:0:mnemonic-widget:
=head3 Mnemonic widget

The widget to be activated when the label's mnemonic key is pressed
Widget type: GTK_TYPE_WIDGET


The B<Gnome::GObject::Value> type of property I<mnemonic-widget> is C<G_TYPE_OBJECT>.

=comment #TP:0:cursor-position:
=head3 Cursor Position



The B<Gnome::GObject::Value> type of property I<cursor-position> is C<G_TYPE_INT>.

=comment #TP:0:selection-bound:
=head3 Selection Bound



The B<Gnome::GObject::Value> type of property I<selection-bound> is C<G_TYPE_INT>.

=comment #TP:0:ellipsize:
=head3 Ellipsize


The preferred place to ellipsize the string, if the label does
not have enough room to display the entire string, specified as a
B<PangoEllipsizeMode>.
Note that setting this property to a value other than
C<PANGO_ELLIPSIZE_NONE> has the side-effect that the label requests
only enough space to display the ellipsis "...". In particular, this
means that ellipsizing labels do not work well in notebook tabs, unless
the B<Gnome::Gtk3::Notebook> tab-expand child property is set to C<1>. Other ways
to set a label's width are C<gtk_widget_set_size_request()> and
C<gtk_label_set_width_chars()>.
Since: 2.6
Widget type: PANGO_TYPE_ELLIPSIZE_MODE

The B<Gnome::GObject::Value> type of property I<ellipsize> is C<G_TYPE_ENUM>.

=comment #TP:0:width-chars:
=head3 Width In Characters


The desired width of the label, in characters. If this property is set to
-1, the width will be calculated automatically.
See the section on [text layout][label-text-layout]
for details of how  I<width-chars> and  I<max-width-chars>
determine the width of ellipsized and wrapped labels.
Since: 2.6


The B<Gnome::GObject::Value> type of property I<width-chars> is C<G_TYPE_INT>.

=comment #TP:0:single-line-mode:
=head3 Single Line Mode


Whether the label is in single line mode. In single line mode,
the height of the label does not depend on the actual text, it
is always set to ascent + descent of the font. This can be an
advantage in situations where resizing the label because of text
changes would be distracting, e.g. in a statusbar.
Since: 2.6


The B<Gnome::GObject::Value> type of property I<single-line-mode> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:angle:
=head3 Angle


The angle that the baseline of the label makes with the horizontal,
in degrees, measured counterclockwise. An angle of 90 reads from
from bottom to top, an angle of 270, from top to bottom. Ignored
if the label is selectable.
Since: 2.6


The B<Gnome::GObject::Value> type of property I<angle> is C<G_TYPE_DOUBLE>.

=comment #TP:0:max-width-chars:
=head3 Maximum Width In Characters


The desired maximum width of the label, in characters. If this property
is set to -1, the width will be calculated automatically.
See the section on [text layout][label-text-layout]
for details of how  I<width-chars> and  I<max-width-chars>
determine the width of ellipsized and wrapped labels.
Since: 2.6


The B<Gnome::GObject::Value> type of property I<max-width-chars> is C<G_TYPE_INT>.

=comment #TP:0:track-visited-links:
=head3 Track visited links


Set this property to C<1> to make the label track which links
have been visited. It will then apply the B<GTK_STATE_FLAG_VISITED>
when rendering this link, in addition to B<GTK_STATE_FLAG_LINK>.
Since: 2.18

The B<Gnome::GObject::Value> type of property I<track-visited-links> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:lines:
=head3 Number of lines


The number of lines to which an ellipsized, wrapping label
should be limited. This property has no effect if the
label is not wrapping or ellipsized. Set this property to
-1 if you don't want to limit the number of lines.
Since: 3.10

The B<Gnome::GObject::Value> type of property I<lines> is C<G_TYPE_INT>.
=end pod









=finish
#-------------------------------------------------------------------------------
sub gtk_label_new ( Str $text )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_label_get_text ( N-GObject $label )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_label_set_text ( N-GObject $label, Str $str )
  is native(&gtk-lib)
  { * }

sub gtk_label_new_with_mnemonic ( Str $mnem )
  returns N-GObject
  is native(&gtk-lib)
  { * }
