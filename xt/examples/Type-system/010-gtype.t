use v6;
use NativeCall;
use Test;

use Gnome::GObject::Type;
use Gnome::Gtk3::Builder;

#-------------------------------------------------------------------------------
my $dir = 't/ui';
mkdir $dir unless $dir.IO ~~ :e;

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Str $ui-file = "$dir/ui.xml";
$ui-file.IO.spurt(Q:q:to/EOXML/);
  <?xml version="1.0" encoding="UTF-8"?>
  <!-- Generated with glade 3.22.1 -->
  <interface>
    <requires lib="gtk+" version="3.20"/>
    <object class="GtkWindow" id="window">
      <property name="can_focus">False</property>
      <child>
        <placeholder/>
      </child>
      <child>
        <object class="GtkButton" id="button">
          <property name="label" translatable="yes">button</property>
          <property name="visible">True</property>
          <property name="can_focus">True</property>
          <property name="receives_default">True</property>
        </object>
      </child>
    </object>
  </interface>
  EOXML

#-------------------------------------------------------------------------------
subtest 'button type', {
  my Gnome::Gtk3::Builder $builder .= new(:filename($ui-file));

  my Int $gtype = $builder.get-type-from-name('GtkButton');
  my Gnome::GObject::Type $t .= new;
  is $t.g-type-name($gtype), 'GtkButton', "gtype code $gtype is GtkButton";
  is $t.from-name('GtkButton'), $gtype, 'gtype codes are the same';
  is $t.g-type-name($t.g-type-parent($gtype)), 'GtkBin',
     'parent class is GtkBin';
  is $t.g-type-depth($gtype), 6,
     "Depth = 6: Button, Bin, Container, Widget, GInitiallyUnowned, GObject";
}

#-------------------------------------------------------------------------------
done-testing;

unlink $ui-file;
rmdir $dir;
