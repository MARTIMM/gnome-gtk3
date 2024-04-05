use v6;
use NativeCall;
#use lib '/home/marcel/Languages/Raku/Projects/gnome-native/lib';

use Gnome::Gtk3::Window:api<1>;
use Gnome::GObject::Object:api<1>;
use Gnome::N::N-GObject:api<1>;

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

my Gnome::Gtk3::Window $w1 .= new;
my N-GObject() $no = $w1;
say $no.gist;

my Gnome::Gtk3::Window() $w2 = $no;
say $w2.gist;
