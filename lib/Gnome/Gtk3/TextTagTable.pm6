use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::TextTagTable

=SUBTITLE Collection of tags that can be used together

=head1 Description

You may wish to begin by reading the [text widget conceptual overview](https://developer.gnome.org/gtk3/3.24/TextWidget.html) which gives an overview of all the objects and data types related to the text widget and how they work together.

=head2 Gnome::Gtk3::TextTagTables as Gnome::Gtk3::Buildable

The C<Gnome::Gtk3::TextTagTable> implementation of the C<Gnome::Gtk3::Buildable> interface supports adding tags by specifying “tag” as the “type” attribute of a <child> element.

An example of a UI definition fragment specifying tags:
  <object class="GtkTextTagTable">
    <child type="tag">
      <object class="GtkTextTag"/>
    </child>
  </object>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TextTagTable;
  also is Gnome::GObject::Object;

=head2 Example

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::GObject::Object;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktexttagtable.h
# https://developer.gnome.org/gtk3/stable/GtkTextTagTable.html
unit class Gnome::Gtk3::TextTagTable:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :nativewidget<tag-added tag-removed>,
    :tagbool<tag-changed>,
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
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_text_tag_table_$native-sub"); } unless ?$s;

  self.set-class-name-of-sub('GtkTextTagTable');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_text_tag_table_new

Creates a new C<Gnome::Gtk3::TextTagTable>. The table contains no tags by
default.

Returns: a new C<Gnome::Gtk3::TextTagTable>

  method gtk_text_tag_table_new ( --> N-GObject  )

=end pod

sub gtk_text_tag_table_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_text_tag_table_add

Add a tag to the table. The tag is assigned the highest priority
in the table.

I<tag> must not be in a tag table already, and may not have
the same name as an already-added tag.

Returns: C<1> on success.

  method gtk_text_tag_table_add ( N-GObject $tag --> Int  )

=item N-GObject $tag; a C<Gnome::Gtk3::TextTag>

=end pod

sub gtk_text_tag_table_add ( N-GObject $table, N-GObject $tag )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_text_tag_table_remove

Remove a tag from the table. If a C<Gnome::Gtk3::TextBuffer> has I<table> as its tag table,
the tag is removed from the buffer. The table’s reference to the tag is
removed, so the tag will end up destroyed if you don’t have a reference to
it.

  method gtk_text_tag_table_remove ( N-GObject $tag )

=item N-GObject $tag; a C<Gnome::Gtk3::TextTag>

=end pod

sub gtk_text_tag_table_remove ( N-GObject $table, N-GObject $tag )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
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
=head1 Not yet implemented methods

=head2 method gtk_text_tag_table_foreach ( ... )

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also C<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., :$user-optionN
  )

=head2 Supported signals

=head3 tag-added

  method handler (
    Gnome::GObject::Object :widget($texttagtable),
    :handler-arg0($tag),
    :$user-option1, ..., :$user-optionN
  );

=item $texttagtable; the object which received the signal.
=item $tag; the added tag.


=head3 tag-removed

  method handler (
    Gnome::GObject::Object :widget($texttagtable),
    :handler-arg0($tag),
    :$user-option1, ..., :$user-optionN
  );

=item $texttagtable; the object which received the signal.
=item $tag; the removed tag.


=begin comment
=head2 Unsupported signals
=end comment

=head2 Not yet supported signals

=head3 tag-changed

  method handler (
    Gnome::GObject::Object :widget($texttagtable),
    :handler-arg0($tag),
    :handler-arg1($size_changed),
    :$user-option1, ..., :$user-optionN
  );

=item $texttagtable; the object which received the signal.
=item $tag; the changed tag.
=item $size_changed; whether the change affects the C<Gnome::Gtk3::TextView> layout.


=end pod
