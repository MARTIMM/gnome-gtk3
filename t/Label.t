use v6;
use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::Gdk3::Keysyms;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Builder;
use Gnome::Gtk3::Label;

#use Gnome::N::X;
#Gnome::N::debug(:on);
#-------------------------------------------------------------------------------
my Gnome::Gtk3::Label $l;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $l .= new(:text(Str));
  isa-ok $l, Gnome::Gtk3::Label, ".new(:text) undefined text";

  $l .= new(:text('abc def'));
  isa-ok $l, Gnome::Gtk3::Label, ".new(:text)";
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations 0', {

#  dies-ok(
#    { $l.get-nonvisible(); },
#    'non existent sub called'
#  );

  is $l.get-text, 'abc def', '.get-text()';

  my Gnome::Gtk3::Label $label2 .= new(:text('pqr'));
  $l .= new(:native-object($label2._get-native-object));
  is $l.get-text, 'pqr', '.new(:widget)';

  $l .= new(:mnemonic('Search _filename'));
  $l.set-use-markup(True);
  ok $l.get-use-markup, '.get-use-markup() / .set-use-markup()';
  $l.set-use-underline(True);
  ok $l.get-use-underline, '.get-use-underline() / .set-use-underline()';
  is $l.get-text, 'Search filename', '.new(:mnemonic)';

  $l.set-text('Search filename');
  is $l.get-text, 'Search filename', '.set-text()';
  $l.set-text-with-mnemonic('Search _filename');
  is $l.get-text, 'Search filename', '.set-text-with-mnemonic()';

  $l.set-markup('Be <b>Strong</b>');
  is $l.get-text, 'Be Strong', '.set-markup()';

  $l.set-label('Search <u>filename</u>');
  is $l.get-label, 'Search <u>filename</u>', '.set-label() / .get-label()';
  is $l.get-text, 'Search filename', '.get-text() after set label';
  $l.set-use-markup(False);
  is $l.get-text, 'Search <u>filename</u>', '.get-text() after turn off markup';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations 1', {

  my Str $cfg = q:to/EOTXT/;
    <?xml version="1.0" encoding="UTF-8"?>
    <!-- Generated with glade 3.22.1 -->
    <interface>
       <requires lib="gtk+" version="3.10"/>
       <object class="GtkLabel" id="copyLabel">
        <property name="label" translatable="yes">Text to copy</property>
        <attributes>
          <attribute name="weight" value="PANGO_WEIGHT_BOLD"/>
          <attribute name="background" value="red" start="5" end="10"/>
        </attributes>
      </object>
    </interface>
    EOTXT

  my Gnome::Gtk3::Builder $builder .= new(:string($cfg));
  my Gnome::Gtk3::Label $label .= new(:build-id<copyLabel>);
  is $label.get-text, "Text to copy", 'label text found from config';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  $l.set-text('Search filename');
  $l.set-xalign(0.23);
  $l.set-yalign(0.21);
#  $l.set-justify(GTK_JUSTIFY_RIGHT);
  $l.gtk-label-set-pattern('___   _');
  $l.set-line-wrap(True);
  $l.set-selectable(True);

  sub test-property (
    $type, Str $prop, Str $routine, $value, Bool :$apprx = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $l.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    if $apprx {
      is-approx $gv-value, $value, "property $prop, " ~ $gv-value;
    }

    else {
      is $gv-value, $value, "property $prop, " ~ $gv-value;
    }
    $gv.clear-object;
  }

  test-property( G_TYPE_STRING, 'label', 'get-string', 'Search filename');
  test-property( G_TYPE_BOOLEAN, 'use-markup', 'get-boolean', False);
  test-property( G_TYPE_BOOLEAN, 'use-underline', 'get-boolean', False);
#  test-property( G_TYPE_ENUM, 'justify', 'get-enum', GTK_JUSTIFY_RIGHT.value);
  test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :apprx);
  test-property( G_TYPE_FLOAT, 'yalign', 'get-float', 21e-2, :apprx);
#TODO  test-property( G_TYPE_STRING, 'pattern', 'get-string', '___   _');
  test-property( G_TYPE_BOOLEAN, 'wrap', 'get-boolean', True);
#  test-property( G_TYPE_ENUM, 'wrap-mode', 'get-enum', ....value);
  test-property( G_TYPE_BOOLEAN, 'selectable', 'get-boolean', True);
  test-property(
    G_TYPE_UINT, 'mnemonic-keyval', 'get-uint', GDK_KEY_VoidSymbol
  );

  test-property( G_TYPE_INT, 'cursor-position', 'get-int', 0);
  test-property( G_TYPE_INT, 'selection-bound', 'get-int', 0);
  test-property( G_TYPE_INT, 'width-chars', 'get-int', -1);
  test-property( G_TYPE_BOOLEAN, 'single-line-mode', 'get-boolean', False);
  test-property( G_TYPE_DOUBLE, 'angle', 'get-double', 0e0, :apprx);
  test-property( G_TYPE_INT, 'max-width-chars', 'get-int', -1);
  test-property( G_TYPE_BOOLEAN, 'track-visited-links', 'get-boolean', True);
  test-property( G_TYPE_INT, 'lines', 'get-int', -1);
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Label', {
  class MyClass is Gnome::Gtk3::Label {
    method new ( |c ) {
      self.bless( :GtkLabel, |c, :text(''));
    }

    submethod BUILD ( *%options ) {
      self.set-text('default label text');
    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Label, '$mgc.new()';
  is $mgc.get-text, 'default label text', 'self.get-text() / $mgc.get-text()';
}

#-------------------------------------------------------------------------------
done-testing;
