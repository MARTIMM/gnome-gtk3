use v6;
use NativeCall;
#use lib '/home/marcel/Languages/Raku/Projects/gnome-native/lib';

use Gnome::Gtk3::Window;
use Gnome::GObject::Object;
use Gnome::N::N-GObject;

#-------------------------------------------------------------------------------
class X {
  has Int $!i;

  submethod BUILD ( Int() :$!i = 10 ) { }
  method print ( ) { note $!i; }

  multi method COERCE( Int $x --> X ) { X.new(:i($x)) }
  multi method COERCE( Str $x --> X ) { X.new(:i($x)) }
}

my X $x .= new(:2i);
$x.print;

my X() $x2 = 11;
$x2.print;
my X() $x3 = '101';
$x3.print;

#-------------------------------------------------------------------------------
# TDOD, FALLBACK in TopLevelClassSupport is in the way.
#---
#class N-GObject is repr('CPointer') is export {
#  method COERCE( Gnome::GObject::Object $o --> N-GObject ) {
#    say $o.gist;
#    $o.get-native-object;
#  }
#}

my Gnome::Gtk3::Window $w .= new;
my N-GObject() $no = $w;

say $no.gist;
