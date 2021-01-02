use v6;
use NativeCall;
use Test;

use Gnome::N::N-GObject;
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
  $l .= new(:native-object($label2.get-native-object));
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

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
