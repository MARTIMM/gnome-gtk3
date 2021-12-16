use v6;
use NativeCall;

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Builder;

use Gnome::GObject::Type;

use Gnome::N::N-GObject;

use Gnome::Glib::SList;

my Str $design = Q:q:to/EODESIGN/;
    <interface>
      <requires lib="gtk+" version="3.18"/>
      <object class="GtkWindow" id="buildable-window">
        <property name="can_focus">False</property>
        <property name="title">Buildable Window</property>
      </object>
    </interface>
    EODESIGN

my Gnome::Gtk3::Builder $b .= new(:string($design));
my Gnome::Gtk3::Window $w = $b.get-object-rk('buildable-window');
note "names: $w.get-name(), $w.buildable-get-name()";
note "title: $w.get-title()";

my Gnome::GObject::Type $t .= new;

# Checks to see what interface is used
note "instance: $t.check-instance-is-a( $w._get-native-object, $t.from-name('GtkBuildable'))";
note "instance: $t.check-instance-is-a( $w._get-native-object, $t.from-name('GtkActionable'))";

$w.clear-object;
$w .= new;
$w.set-title('abc');
$b.expose-object( 'some-other-name', $w);
#$b.object-set-name( $w, 'some-other-name');
note "names: $w.get-name(), $w.buildable-get-name()";

my Gnome::Glib::SList $list = $b.get-objects;
note 'nbr objects in builder: ', $list.length;
for ^$list.length -> $i {
  my $object = nativecast( N-GObject, $list.nth($i));
note "o; $object.raku";
}

my Gnome::Gtk3::Window $w2 = $b.get-object-rk('some-other-name');
note "title: $w2.get-title()";
