#TL:1:Gnome::Gtk3::TextTag:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TextTag

A tag that can be applied to text in a Gnome::Gtk3::TextBuffer

=head1 Description

You may wish to begin by reading the [text widget conceptual overview](https://developer.gnome.org/gtk3/3.24/TextWidget.html) which gives an overview of all the objects and data types related to the text widget and how they work together.

Tags should be in the B<Gnome::Gtk3::TextTagTable> for a given B<Gnome::Gtk3::TextBuffer> before using them with that buffer.

C<gtk_text_buffer_create_tag()> is the best way to create tags. See “gtk3-demo” for numerous examples.

For each property of B<Gnome::Gtk3::TextTag>, there is a “set” property, e.g. “font-set” corresponds to “font”. These “set” properties reflect whether a property has been set or not. They are maintained by GTK+ and you should not set them independently.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TextTag;
  also is Gnome::GObject::Object;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Object;
use Gnome::Gdk3::Events;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::TextTag:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new


Create a new plain object.

  multi method new ( Bool :$empty! )

Create a new tag object. Tag will have the given name.

  multi method new ( Str :$tag-name! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:empty):
#TM:1:new(:tag-name):
#TM:0:new(:widget):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w3<event>
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::TextTag';

  # process all named arguments
  if ? %options<empty> {
    self.native-gobject(gtk_text_tag_new(Any));
  }

  elsif ? %options<tag-name> {
    self.native-gobject(gtk_text_tag_new(%options<tag-name>));
  }

  elsif ? %options<widget> || %options<build-id> {
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
  self.set-class-info('GtkTextTag');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_text_tag_$native-sub"); } unless ?$s;

  self.set-class-name-of-sub('GtkTextTag');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_text_tag_new:new(:empty),new(:tag-name)
=begin pod
=head2 gtk_text_tag_new

Creates a B<Gnome::Gtk3::TextTag>. Configure the tag using object arguments,
i.e. using C<g_object_set()>.

Returns: a new B<Gnome::Gtk3::TextTag>

  method gtk_text_tag_new ( Str $name --> N-GObject  )

=item Str $name; tag name, or C<Any>

=end pod

sub gtk_text_tag_new ( Str $name )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_tag_get_priority:
=begin pod
=head2 [gtk_text_tag_] get_priority

Get the tag priority.

Returns: The tag’s priority.

  method gtk_text_tag_get_priority ( --> Int  )


=end pod

sub gtk_text_tag_get_priority ( N-GObject $tag )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_tag_set_priority:
=begin pod
=head2 [gtk_text_tag_] set_priority

Sets the priority of a B<Gnome::Gtk3::TextTag>. Valid priorities
start at 0 and go to one less than C<gtk_text_tag_table_get_size()>.
Each tag in a table has a unique priority; setting the priority
of one tag shifts the priorities of all the other tags in the
table to maintain a unique priority for each tag. Higher priority
tags “win” if two tags both set the same text attribute. When adding
a tag to a tag table, it will be assigned the highest priority in
the table by default; so normally the precedence of a set of tags
is the order in which they were added to the table, or created with
C<gtk_text_buffer_create_tag()>, which adds the tag to the buffer’s table
automatically.

  method gtk_text_tag_set_priority ( Int $priority )

=item Int $priority; the new priority

=end pod

sub gtk_text_tag_set_priority ( N-GObject $tag, int32 $priority )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_tag_event:
=begin pod
=head2 gtk_text_tag_event

Emits the “event” signal on the B<Gnome::Gtk3::TextTag>.

Returns: result of signal emission (whether the event was handled)

  method gtk_text_tag_event (
    N-GObject $event_object, GdkEvent $event, N-GObject $iter
    --> Int
  )

=item N-GObject $event_object; object that received the event, such as a widget
=item GdkEvent $event; the event
=item N-GObject $iter; location where the event was received

=end pod

sub gtk_text_tag_event ( N-GObject $tag, N-GObject $event_object, GdkEvent $event, N-GObject $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_text_tag_changed:
=begin pod
=head2 gtk_text_tag_changed

Emits the  I<tag-changed> signal on the B<Gnome::Gtk3::TextTagTable> where
the tag is included.

The signal is already emitted when setting a B<Gnome::Gtk3::TextTag> property. This function is useful for a B<Gnome::Gtk3::TextTag> subclass.

Since: 3.20

  method gtk_text_tag_changed ( Int $size_changed )

=item Int $size_changed; whether the change affects the B<Gnome::Gtk3::TextView> layout.

=end pod

sub gtk_text_tag_changed ( N-GObject $tag, int32 $size_changed )
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


=comment #TS:0:event:
=head3 event

The I<event> signal is emitted when an event occurs on a region of the
buffer marked with this tag.

Returns: C<1> to stop other handlers from being invoked for the
event. C<0> to propagate the event further.

  method handler (
    N-GObject $object,
    GdkEvent $event,
    N-GObject $iter,
    Gnome::GObject::Object :widget($tag),
    *%user-options
    --> Int
  );

=item $tag; the B<Gnome::Gtk3::TextTag> on which the signal is emitted
=item $object; the object the event was fired from (typically a native Gnome::Gtk3::TextView)
=item $event; the event which triggered the signal
=item $iter; a native Gnome::Gtk3::TextIter pointing at the location the event occurred


=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:name:
=head3 Tag name

Name used to refer to the text tag. NULL for anonymous tags
Default value: Any


The B<Gnome::GObject::Value> type of property I<name> is C<G_TYPE_STRING>.

=comment #TP:0:background:
=head3 Background color name

Background color as a string
Default value: Any


The B<Gnome::GObject::Value> type of property I<background> is C<G_TYPE_STRING>.

=comment #TP:0:background-rgba:
=head3 Background RGBA


Background color as a B<Gnome::Gdk3::RGBA>.
Since: 3.2

The B<Gnome::GObject::Value> type of property I<background-rgba> is C<G_TYPE_BOXED>.

=comment #TP:0:background-full-height:
=head3 Background full height

Whether the background color fills the entire line height or only the height of the tagged characters
Default value: False


The B<Gnome::GObject::Value> type of property I<background-full-height> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:foreground:
=head3 Foreground color name

Foreground color as a string
Default value: Any


The B<Gnome::GObject::Value> type of property I<foreground> is C<G_TYPE_STRING>.

=comment #TP:0:foreground-rgba:
=head3 Foreground RGBA


Foreground color as a B<Gnome::Gdk3::RGBA>.
Since: 3.2

The B<Gnome::GObject::Value> type of property I<foreground-rgba> is C<G_TYPE_BOXED>.

=comment #TP:0:direction:
=head3 Text direction

Text direction, e.g. right-to-left or left-to-right
Default value: False


The B<Gnome::GObject::Value> type of property I<direction> is C<G_TYPE_ENUM>.

=comment #TP:0:editable:
=head3 Editable

Whether the text can be modified by the user
Default value: True


The B<Gnome::GObject::Value> type of property I<editable> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:font:
=head3 Font


Font description as string, e.g. \"Sans Italic 12\".
Note that the initial value of this property depends on
the internals of B<PangoFontDescription>.

The B<Gnome::GObject::Value> type of property I<font> is C<G_TYPE_STRING>.



=begin comment
=comment #TP:0:font-desc:
=head3 Font

The B<Gnome::GObject::Value> type of property I<font-desc> is C<G_TYPE_BOXED>.
=end comment


=comment #TP:0:family:
=head3 Font family

Name of the font family, e.g. Sans_COMMA_ Helvetica_COMMA_ Times_COMMA_ Monospace
Default value: Any


The B<Gnome::GObject::Value> type of property I<family> is C<G_TYPE_STRING>.

=comment #TP:0:style:
=head3 Font style

Font style as a PangoStyle, e.g. PANGO_STYLE_ITALIC
Default value: False


The B<Gnome::GObject::Value> type of property I<style> is C<G_TYPE_ENUM>.

=comment #TP:0:variant:
=head3 Font variant

Font variant as a PangoVariant, e.g. PANGO_VARIANT_SMALL_CAPS
Default value: False


The B<Gnome::GObject::Value> type of property I<variant> is C<G_TYPE_ENUM>.

=comment #TP:0:weight:
=head3 Font weight



The B<Gnome::GObject::Value> type of property I<weight> is C<G_TYPE_INT>.

=comment #TP:0:stretch:
=head3 Font stretch

Font stretch as a PangoStretch, e.g. PANGO_STRETCH_CONDENSED
Default value: False


The B<Gnome::GObject::Value> type of property I<stretch> is C<G_TYPE_ENUM>.

=comment #TP:0:size:
=head3 Font size



The B<Gnome::GObject::Value> type of property I<size> is C<G_TYPE_INT>.

=comment #TP:0:scale:
=head3 Font scale



The B<Gnome::GObject::Value> type of property I<scale> is C<G_TYPE_DOUBLE>.

=comment #TP:0:size-points:
=head3 Font points



The B<Gnome::GObject::Value> type of property I<size-points> is C<G_TYPE_DOUBLE>.

=comment #TP:0:justification:
=head3 Justification

Left, right_COMMA_ or center justification
Default value: False


The B<Gnome::GObject::Value> type of property I<justification> is C<G_TYPE_ENUM>.

=comment #TP:0:language:
=head3 Language


The language this text is in, as an ISO code. Pango can use this as a
hint when rendering the text. If not set, an appropriate default will be
used.
Note that the initial value of this property depends on the current
locale, see also C<gtk_get_default_language()>.

The B<Gnome::GObject::Value> type of property I<language> is C<G_TYPE_STRING>.

=comment #TP:0:left-margin:
=head3 Left margin



The B<Gnome::GObject::Value> type of property I<left-margin> is C<G_TYPE_INT>.

=comment #TP:0:right-margin:
=head3 Right margin



The B<Gnome::GObject::Value> type of property I<right-margin> is C<G_TYPE_INT>.

=comment #TP:0:indent:
=head3 Indent



The B<Gnome::GObject::Value> type of property I<indent> is C<G_TYPE_INT>.

=comment #TP:0:rise:
=head3 Rise



The B<Gnome::GObject::Value> type of property I<rise> is C<G_TYPE_INT>.

=comment #TP:0:pixels-above-lines:
=head3 Pixels above lines



The B<Gnome::GObject::Value> type of property I<pixels-above-lines> is C<G_TYPE_INT>.

=comment #TP:0:pixels-below-lines:
=head3 Pixels below lines



The B<Gnome::GObject::Value> type of property I<pixels-below-lines> is C<G_TYPE_INT>.

=comment #TP:0:pixels-inside-wrap:
=head3 Pixels inside wrap



The B<Gnome::GObject::Value> type of property I<pixels-inside-wrap> is C<G_TYPE_INT>.

=comment #TP:0:strikethrough:
=head3 Strikethrough

Whether to strike through the text
Default value: False


The B<Gnome::GObject::Value> type of property I<strikethrough> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:underline:
=head3 Underline

Style of underline for this text
Default value: False


The B<Gnome::GObject::Value> type of property I<underline> is C<G_TYPE_ENUM>.

=begin comment
=comment #TP:0:underline-rgba:
=head3 Underline RGBA


This property modifies the color of underlines. If not set, underlines
will use the forground color.
If  I<underline> is set to C<PANGO_UNDERLINE_ERROR>, an alternate
color may be applied instead of the foreground. Setting this property
will always override those defaults.
Since: 3.16

The B<Gnome::GObject::Value> type of property I<underline-rgba> is C<G_TYPE_BOXED>.
=end comment


=begin comment
=comment #TP:0:strikethrough-rgba:
=head3 Strikethrough RGBA


This property modifies the color of strikeouts. If not set, strikeouts
will use the forground color.
Since: 3.16

The B<Gnome::GObject::Value> type of property I<strikethrough-rgba> is C<G_TYPE_BOXED>.
=end comment

=comment #TP:0:wrap-mode:
=head3 Wrap mode

Whether to wrap lines never, at word boundaries_COMMA_ or at character boundaries
Default value: False


The B<Gnome::GObject::Value> type of property I<wrap-mode> is C<G_TYPE_ENUM>.

=begin comment
=comment #TP:0:tabs:
=head3 Tabs

The B<Gnome::GObject::Value> type of property I<tabs> is C<G_TYPE_BOXED>.
=end comment

=comment #TP:0:invisible:
=head3 Invisible


Whether this text is hidden.
Note that there may still be problems with the support for invisible
text, in particular when navigating programmatically inside a buffer
containing invisible segments.
Since: 2.8

The B<Gnome::GObject::Value> type of property I<invisible> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:paragraph-background:
=head3 Paragraph background color name


The paragraph background color as a string.
Since: 2.8

The B<Gnome::GObject::Value> type of property I<paragraph-background> is C<G_TYPE_STRING>.

=begin comment
=comment #TP:0:paragraph-background-rgba:
=head3 Paragraph background RGBA


The paragraph background color as a B<Gnome::Gdk3::RGBA>.
Since: 3.2

The B<Gnome::GObject::Value> type of property I<paragraph-background-rgba> is C<G_TYPE_BOXED>.
=end comment

=comment #TP:0:fallback:
=head3 Fallback


Whether font fallback is enabled.
When set to C<1>, other fonts will be substituted
where the current font is missing glyphs.
Since: 3.16

The B<Gnome::GObject::Value> type of property I<fallback> is C<G_TYPE_BOOLEAN>.

=comment #TP:0:letter-spacing:
=head3 Letter Spacing


Extra spacing between graphemes, in Pango units.
Since: 3.16

The B<Gnome::GObject::Value> type of property I<letter-spacing> is C<G_TYPE_INT>.

=comment #TP:0:font-features:
=head3 Font Features


OpenType font features, as a string.
Since: 3.18

The B<Gnome::GObject::Value> type of property I<font-features> is C<G_TYPE_STRING>.

=comment #TP:0:accumulative-margin:
=head3 Margin Accumulates


Whether the margins accumulate or override each other.
When set to C<1> the margins of this tag are added to the margins
of any other non-accumulative margins present. When set to C<0>
the margins override one another (the default).
Since: 2.12

The B<Gnome::GObject::Value> type of property I<accumulative-margin> is C<G_TYPE_BOOLEAN>.

=comment #TP:0: g_object_class_install_property (object_class:
=head3 propval



The B<Gnome::GObject::Value> type of property I< g_object_class_install_property (object_class> is C<G_TYPE_>.
=end pod
















=finish
#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_text_tag_new

Creates a B<Gnome::Gtk3::TextTag>. Configure the tag using object arguments,
i.e. using C<g_object_set()>.

Returns: a new B<Gnome::Gtk3::TextTag>

  method gtk_text_tag_new ( Str $name --> N-GObject  )

=item Str $name; tag name, or C<Any>

=end pod

sub gtk_text_tag_new ( Str $name )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_tag_] get_priority

Get the tag priority.

Returns: The tag’s priority.

  method gtk_text_tag_get_priority ( --> Int  )


=end pod

sub gtk_text_tag_get_priority ( N-GObject $tag )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_text_tag_] set_priority

Sets the priority of a B<Gnome::Gtk3::TextTag>. Valid priorities
start at 0 and go to one less than C<gtk_text_tag_table_get_size()>.
Each tag in a table has a unique priority; setting the priority
of one tag shifts the priorities of all the other tags in the
table to maintain a unique priority for each tag. Higher priority
tags “win” if two tags both set the same text attribute. When adding
a tag to a tag table, it will be assigned the highest priority in
the table by default; so normally the precedence of a set of tags
is the order in which they were added to the table, or created with
C<gtk_text_buffer_create_tag()>, which adds the tag to the buffer’s table
automatically.

  method gtk_text_tag_set_priority ( Int $priority )

=item Int $priority; the new priority

=end pod

sub gtk_text_tag_set_priority ( N-GObject $tag, int32 $priority )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_text_tag_event

Emits the “event” signal on the B<Gnome::Gtk3::TextTag>.

Returns: result of signal emission (whether the event was handled)

  method gtk_text_tag_event ( N-GObject $event_object, GdkEvent $event, N-GObject $iter --> Int  )

=item N-GObject $event_object; object that received the event, such as a widget
=item GdkEvent $event; the event
=item N-GObject $iter; location where the event was received

=end pod

sub gtk_text_tag_event ( N-GObject $tag, N-GObject $event_object, GdkEvent $event, N-GObject $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_text_tag_changed

Emits the sig C<tag-changed> signal on the B<Gnome::Gtk3::TextTagTable> where
the tag is included.

The signal is already emitted when setting a B<Gnome::Gtk3::TextTag> property. This
function is useful for a B<Gnome::Gtk3::TextTag> subclass.

Since: 3.20

  method gtk_text_tag_changed ( Int $size_changed )

=item Int $size_changed; whether the change affects the B<Gnome::Gtk3::TextView> layout.

=end pod

sub gtk_text_tag_changed ( N-GObject $tag, int32 $size_changed )
  is native(&gtk-lib)
  { * }
#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also B<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., :$user-optionN
  )

=begin comment
=head2 Supported signals
=head2 Unsupported signals
=end comment

=head2 Not yet supported signals


=head3 event

The sig I<event> signal is emitted when an event occurs on a region of the
buffer marked with this tag.

Returns: C<1> to stop other handlers from being invoked for the
event. C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($tag),
    :handler-arg0($object),
    :handler-arg1($event),
    :handler-arg2($iter),
    :$user-option1, ..., :$user-optionN
  );

=item $tag; the B<Gnome::Gtk3::TextTag> on which the signal is emitted

=item $object; the object the event was fired from (typically a B<Gnome::Gtk3::TextView>)

=item $event; the event which triggered the signal

=item $iter; a B<Gnome::Gtk3::TextIter> pointing at the location the event occurred


=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=begin comment

=head2 Supported properties

=head2 Unsupported properties

=end comment

=head2 Not yet supported properties


=head3 background-rgba

The B<Gnome::GObject::Value> type of property I<background-rgba> is C<G_TYPE_BOXED>.

Background color as a B<Gnome::Gdk3::RGBA>.

Since: 3.2


=begin comment

=head3 foreground-rgba

The B<Gnome::GObject::Value> type of property I<foreground-rgba> is C<G_TYPE_BOXED>.

Foreground color as a B<Gnome::Gdk3::RGBA>.

Since: 3.2
=end comment



=head3 font

The B<Gnome::GObject::Value> type of property I<font> is C<G_TYPE_STRING>.

Font description as string, e.g. \"Sans Italic 12\".

Note that the initial value of this property depends on
the internals of C<PangoFontDescription>.



=head3 language

The B<Gnome::GObject::Value> type of property I<language> is C<G_TYPE_STRING>.

The language this text is in, as an ISO code. Pango can use this as a
hint when rendering the text. If not set, an appropriate default will be
used.

Note that the initial value of this property depends on the current
locale, see also C<gtk_get_default_language()>.



=begin comment
=head3 underline-rgba

The B<Gnome::GObject::Value> type of property I<underline-rgba> is C<G_TYPE_BOXED>.

This property modifies the color of underlines. If not set, underlines
will use the forground color.

If prop C<underline> is set to C<PANGO_UNDERLINE_ERROR>, an alternate
color may be applied instead of the foreground. Setting this property
will always override those defaults.

Since: 3.16
=end comment


=begin comment
=head3 strikethrough-rgba

The B<Gnome::GObject::Value> type of property I<strikethrough-rgba> is C<G_TYPE_BOXED>.

This property modifies the color of strikeouts. If not set, strikeouts
will use the forground color.

Since: 3.16
=end comment


=head3 invisible

The B<Gnome::GObject::Value> type of property I<invisible> is C<G_TYPE_BOOLEAN>.

Whether this text is hidden.

Note that there may still be problems with the support for invisible
text, in particular when navigating programmatically inside a buffer
containing invisible segments.

Since: 2.8



=head3 paragraph-background

The B<Gnome::GObject::Value> type of property I<paragraph-background> is C<G_TYPE_STRING>.

The paragraph background color as a string.

Since: 2.8



=begin comment
=head3 paragraph-background-rgba

The B<Gnome::GObject::Value> type of property I<paragraph-background-rgba> is C<G_TYPE_BOXED>.

The paragraph background color as a B<Gnome::Gdk3::RGBA>.

Since: 3.2
=end comment


=head3 fallback

The B<Gnome::GObject::Value> type of property I<fallback> is C<G_TYPE_BOOLEAN>.

Whether font fallback is enabled.

When set to C<1>, other fonts will be substituted
where the current font is missing glyphs.

Since: 3.16



=head3 letter-spacing

The B<Gnome::GObject::Value> type of property I<letter-spacing> is C<G_TYPE_INT>.

Extra spacing between graphemes, in Pango units.

Since: 3.16



=head3 font-features

The B<Gnome::GObject::Value> type of property I<font-features> is C<G_TYPE_STRING>.

OpenType font features, as a string.

Since: 3.18



=head3 accumulative-margin

The B<Gnome::GObject::Value> type of property I<accumulative-margin> is C<G_TYPE_BOOLEAN>.

Whether the margins accumulate or override each other.

When set to C<1> the margins of this tag are added to the margins
of any other non-accumulative margins present. When set to C<0>
the margins override one another (the default).

Since: 2.12


=end pod
