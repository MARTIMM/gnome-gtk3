#TL:1:Gnome::Gtk3::TextTagTable:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TextTagTable

=Collection of tags that can be used together

=head1 Description

You may wish to begin by reading the [text widget conceptual overview](https://developer.gnome.org/gtk3/3.24/TextWidget.html) which gives an overview of all the objects and data types related to the text widget and how they work together.

=head2 Gnome::Gtk3::TextTagTables as Gnome::Gtk3::Buildable

The B<Gnome::Gtk3::TextTagTable> implementation of the B<Gnome::Gtk3::Buildable> interface supports adding tags by specifying “tag” as the “type” attribute of a <child> element.

An example of a UI definition fragment specifying tags:

  <object class="GtkTextTagTable">
    <child type="tag">
      <object class="GtkTextTag"/>
    </child>
  </object>

=head2 Implemented Interfaces

Gnome::Gtk3::TextTagTable implements
=item [Gnome::Gtk3::Buildable](Buildable.html)

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TextTagTable;
  also is Gnome::GObject::Object;
  also does Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::GObject::Object;

use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktexttagtable.h
# https://developer.gnome.org/gtk3/stable/GtkTextTagTable.html
unit class Gnome::Gtk3::TextTagTable:auth<github:MARTIMM>;
also is Gnome::GObject::Object;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:empty):
#TM:0:new(:widget):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w1<tag-added tag-removed>, :w2<tag-changed>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::TextTagTable';

  if ? %options<empty> {
    self.native-gobject(gtk_text_tag_table_new());
  }

  elsif ? %options<widget> || ? %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkTextTagTable');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_text_tag_table_$native-sub"); };
  try { $s = &::("gtk_table_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkTextTagTable');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:2:gtk_text_tag_table_new:new(:empty)
=begin pod
=head2 gtk_text_tag_table_new

Creates a new B<Gnome::Gtk3::TextTagTable>. The table contains no tags by
default.

Returns: a new B<Gnome::Gtk3::TextTagTable>

  method gtk_text_tag_table_new ( --> N-GObject  )

=end pod

sub gtk_text_tag_table_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_tag_table_add:
=begin pod
=head2 gtk_text_tag_table_add

Add a tag to the table. The tag is assigned the highest priority
in the table.

I<tag> must not be in a tag table already, and may not have
the same name as an already-added tag.

Returns: C<1> on success.

  method gtk_text_tag_table_add ( N-GObject $tag --> Int  )

=item N-GObject $tag; a B<Gnome::Gtk3::TextTag>

=end pod

sub gtk_text_tag_table_add ( N-GObject $table, N-GObject $tag )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_tag_table_remove:
=begin pod
=head2 gtk_text_tag_table_remove

Remove a tag from the table. If a B<Gnome::Gtk3::TextBuffer> has I<table> as its tag table,
the tag is removed from the buffer. The table’s reference to the tag is
removed, so the tag will end up destroyed if you don’t have a reference to
it.

  method gtk_text_tag_table_remove ( N-GObject $tag )

=item N-GObject $tag; a B<Gnome::Gtk3::TextTag>

=end pod

sub gtk_text_tag_table_remove ( N-GObject $table, N-GObject $tag )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_text_tag_table_lookup:
=begin pod
=head2 gtk_text_tag_table_lookup

Look up a named tag.

Returns: (nullable) (transfer none): The tag, or C<Any> if none by that
name is in the table.

  method gtk_text_tag_table_lookup ( Str $name --> N-GObject  )

=item Str $name; name of a tag

=end pod

sub gtk_text_tag_table_lookup ( N-GObject $table, Str $name )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_text_tag_table_foreach:
=begin pod
=head2 gtk_text_tag_table_foreach

Calls I<func> on each tag in I<table>, with user data I<data>.
Note that the table may not be modified while iterating
over it (you can’t add/remove tags).

  method gtk_text_tag_table_foreach ( GtkTextTagTableForeach $func, Pointer $data )

=item GtkTextTagTableForeach $func; (scope call): a function to call on each tag
=item Pointer $data; user data

=end pod

sub gtk_text_tag_table_foreach ( N-GObject $table, GtkTextTagTableForeach $func, Pointer $data )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_text_tag_table_get_size:
=begin pod
=head2 [gtk_text_tag_table_] get_size

Returns the size of the table (number of tags)

Returns: number of tags in I<table>

  method gtk_text_tag_table_get_size ( --> Int  )

=end pod

sub gtk_text_tag_table_get_size ( N-GObject $table )
  returns int32
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


=comment #TS:0:tag-changed:
=head3 tag-changed

  method handler (
    N-GObject $tag,
    Int $size_changed,
    Gnome::GObject::Object :widget($texttagtable),
    *%user-options
  );

=item $texttagtable; the object which received the signal.
=item $tag; the changed tag, a native B<Gnome::Gtk3::TextTag>.
=item $size_changed; whether the change affects the B<Gnome::Gtk3::TextView> layout.


=comment #TS:0:tag-added:
=head3 tag-added

  method handler (
    N-GObject $tag,
    Gnome::GObject::Object :widget($texttagtable),
    *%user-options
  );

=item $texttagtable; the object which received the signal.
=item $tag; the added tag, a native B<Gnome::Gtk3::TextTag>.


=comment #TS:0:tag-removed:
=head3 tag-removed

  method handler (
    N-GObject $tag,
    Gnome::GObject::Object :widget($texttagtable),
    *%user-options
  );

=item $texttagtable; the object which received the signal.
=item $tag; the removed tag, a native B<Gnome::Gtk3::TextTag>.


=end pod
