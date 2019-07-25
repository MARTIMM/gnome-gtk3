use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::GObject::Object;
use Gnome::Gtk3::TextTagTable;
use Gnome::Gtk3::TextIter;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktextbuffer.h
# https://developer.gnome.org/gtk3/stable/GtkTextBuffer.html
# https://developer.gnome.org/gtk3/stable/TextWidget.html
unit class Gnome::Gtk3::TextBuffer:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<begin-user-action changed end-user-action modified-changed>,
    :nativewidget<mark-deleted paste-done>,
    :tagiter2<apply-tag remove-tag>,
    :iter2<delete-range>,
    :iteranchor<insert-child-anchor>,
    :iterpix<insert-pixbuf>,
    :iterstrint<insert-text>,
    :itermark<mark-set>,
  ) unless $signals-added;

  return unless self.^name eq 'Gnome::Gtk3::TextBuffer';

  if ? %options<empty> {
    my Gnome::Gtk3::TextTagTable $tag-table .= new(:empty);
    self.native-gobject(gtk_text_buffer_new($tag-table()));
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
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_text_buffer_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
sub gtk_text_buffer_new ( N-GObject $text-tag-table )
  returns N-GObject       # GtkTextBuffer
  is native(&gtk-lib)
  { * }

sub gtk_text_buffer_get_start_iter ( N-GObject $buffer, N-GTextIter $i )
  is native(&gtk-lib)
  { * }

sub gtk_text_buffer_get_end_iter( N-GObject $buffer, N-GTextIter $i )
  is native(&gtk-lib)
  { * }

sub gtk_text_buffer_set_text( N-GObject $buffer, Str $text, int32 $len )
  is native(&gtk-lib)
  { * }

sub gtk_text_buffer_get_text (
  N-GObject $buffer, N-GTextIter $start, N-GTextIter $end,
  int32 $include_hidden_chars
) returns Str
  is native(&gtk-lib)
  { * }

sub gtk_text_buffer_insert(
  N-GObject $buffer, CArray[int32] $start,
  Str $text, int32 $len
) is native(&gtk-lib)
  { * }
