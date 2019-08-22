use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::TextTag

=SUBTITLE A tag that can be applied to text in a C<Gnome::Gtk3::TextBuffer>

=head1 Description

You may wish to begin by reading the [text widget conceptual overview](https://developer.gnome.org/gtk3/3.24/TextWidget.html) which gives an overview of all the objects and data types related to the text widget and how they work together.

Tags should be in the C<Gnome::Gtk3::TextTagTable> for a given C<Gnome::Gtk3::TextBuffer> before using them with that buffer.

C<gtk_text_buffer_create_tag()> is the best way to create tags. See “gtk3-demo” for numerous examples.

For each property of C<Gnome::Gtk3::TextTag>, there is a “set” property, e.g. “font-set” corresponds to “font”. These “set” properties reflect whether a property has been set or not. They are maintained by GTK+ and you should not set them independently.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TextTag;
  also is Gnome::GObject::Object;

=head2 Example

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
=head3 multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

=head3 multi method new ( Str :$tag-name! )

Create a new tag object. Tag will have the given name.

=head3 multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

=head3 multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.

=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :eventTIter<event>
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
=begin pod
=head2 gtk_text_tag_new

Creates a C<Gnome::Gtk3::TextTag>. Configure the tag using object arguments,
i.e. using C<g_object_set()>.

Returns: a new C<Gnome::Gtk3::TextTag>

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

Sets the priority of a C<Gnome::Gtk3::TextTag>. Valid priorities
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

Emits the “event” signal on the C<Gnome::Gtk3::TextTag>.

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

Emits the sig C<tag-changed> signal on the C<Gnome::Gtk3::TextTagTable> where
the tag is included.

The signal is already emitted when setting a C<Gnome::Gtk3::TextTag> property. This
function is useful for a C<Gnome::Gtk3::TextTag> subclass.

Since: 3.20

  method gtk_text_tag_changed ( Int $size_changed )

=item Int $size_changed; whether the change affects the C<Gnome::Gtk3::TextView> layout.

=end pod

sub gtk_text_tag_changed ( N-GObject $tag, int32 $size_changed )
  is native(&gtk-lib)
  { * }
#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also C<Gnome::GObject::Object>.

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

=item $tag; the C<Gnome::Gtk3::TextTag> on which the signal is emitted

=item $object; the object the event was fired from (typically a C<Gnome::Gtk3::TextView>)

=item $event; the event which triggered the signal

=item $iter; a C<Gnome::Gtk3::TextIter> pointing at the location the event occurred


=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a C<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

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

The C<Gnome::GObject::Value> type of property I<background-rgba> is C<G_TYPE_BOXED>.

Background color as a C<Gnome::Gdk3::RGBA>.

Since: 3.2



=head3 foreground-rgba

The C<Gnome::GObject::Value> type of property I<foreground-rgba> is C<G_TYPE_BOXED>.

Foreground color as a C<Gnome::Gdk3::RGBA>.

Since: 3.2



=head3 font

The C<Gnome::GObject::Value> type of property I<font> is C<G_TYPE_STRING>.

Font description as string, e.g. \"Sans Italic 12\".

Note that the initial value of this property depends on
the internals of C<PangoFontDescription>.



=head3 language

The C<Gnome::GObject::Value> type of property I<language> is C<G_TYPE_STRING>.

The language this text is in, as an ISO code. Pango can use this as a
hint when rendering the text. If not set, an appropriate default will be
used.

Note that the initial value of this property depends on the current
locale, see also C<gtk_get_default_language()>.



=head3 underline-rgba

The C<Gnome::GObject::Value> type of property I<underline-rgba> is C<G_TYPE_BOXED>.

This property modifies the color of underlines. If not set, underlines
will use the forground color.

If prop C<underline> is set to C<PANGO_UNDERLINE_ERROR>, an alternate
color may be applied instead of the foreground. Setting this property
will always override those defaults.

Since: 3.16



=head3 strikethrough-rgba

The C<Gnome::GObject::Value> type of property I<strikethrough-rgba> is C<G_TYPE_BOXED>.

This property modifies the color of strikeouts. If not set, strikeouts
will use the forground color.

Since: 3.16



=head3 invisible

The C<Gnome::GObject::Value> type of property I<invisible> is C<G_TYPE_BOOLEAN>.

Whether this text is hidden.

Note that there may still be problems with the support for invisible
text, in particular when navigating programmatically inside a buffer
containing invisible segments.

Since: 2.8



=head3 paragraph-background

The C<Gnome::GObject::Value> type of property I<paragraph-background> is C<G_TYPE_STRING>.

The paragraph background color as a string.

Since: 2.8



=head3 paragraph-background-rgba

The C<Gnome::GObject::Value> type of property I<paragraph-background-rgba> is C<G_TYPE_BOXED>.

The paragraph background color as a C<Gnome::Gdk3::RGBA>.

Since: 3.2



=head3 fallback

The C<Gnome::GObject::Value> type of property I<fallback> is C<G_TYPE_BOOLEAN>.

Whether font fallback is enabled.

When set to C<1>, other fonts will be substituted
where the current font is missing glyphs.

Since: 3.16



=head3 letter-spacing

The C<Gnome::GObject::Value> type of property I<letter-spacing> is C<G_TYPE_INT>.

Extra spacing between graphemes, in Pango units.

Since: 3.16



=head3 font-features

The C<Gnome::GObject::Value> type of property I<font-features> is C<G_TYPE_STRING>.

OpenType font features, as a string.

Since: 3.18



=head3 accumulative-margin

The C<Gnome::GObject::Value> type of property I<accumulative-margin> is C<G_TYPE_BOOLEAN>.

Whether the margins accumulate or override each other.

When set to C<1> the margins of this tag are added to the margins
of any other non-accumulative margins present. When set to C<0>
the margins override one another (the default).

Since: 2.12


=end pod
