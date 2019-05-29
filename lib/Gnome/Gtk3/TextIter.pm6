use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::GObject::Boxed;
#use Gnome::Gtk3::TextBuffer;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktextiter.h
# https://developer.gnome.org/gtk3/stable/GtkTextIter.html
# https://developer.gnome.org/gtk3/stable/TextWidget.html
unit class Gnome::Gtk3::TextIter:auth<github:MARTIMM>;
also is Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
# This is a representation of an opaque structure. Spelled out here
# to set proper size.
class N-GTextIter is repr('CStruct') is export {
  has Pointer $!dummy1;
  has Pointer $!dummy2;
  has int32 $!dummy3;
  has int32 $!dummy4;
  has int32 $!dummy5;
  has int32 $!dummy6;
  has int32 $!dummy7;
  has int32 $!dummy8;
  has Pointer $!dummy9;
  has Pointer $!dummy10;
  has int32 $!dummy11;
  has int32 $!dummy12;
  # padding
  has int32 $!dummy13;
  has Pointer $!dummy14;
};

enum GtkTextSearchFlags is export (
  GTK_TEXT_SEARCH_VISIBLE_ONLY     => 1 <+ 0,
  GTK_TEXT_SEARCH_TEXT_ONLY        => 1 <+ 1,
  GTK_TEXT_SEARCH_CASE_INSENSITIVE => 1 <+ 2,
  # Possible future plans: SEARCH_REGEXP
);

#-------------------------------------------------------------------------------
sub gtk_text_iter_get_buffer ( N-GTextIter $iter )
  returns N-GObject # GtkTextBuffer
  is native(&gtk-lib)
  { * }

sub gtk_text_iter_set_offset ( N-GTextIter $iter, int32 $char_offset )
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::TextIter';

  self.native-gboxed(N-GTextIter.new);

  if %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub, |c ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_text_iter_$native-sub"); } unless ?$s;

  $s
}
