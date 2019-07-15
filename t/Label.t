use v6;
use NativeCall;
use Test;

#use lib '../perl6-gnome-gobject/lib';

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Builder;
use Gnome::Gtk3::Label;

#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
subtest 'Label create', {

  my Gnome::Gtk3::Label $label1 .= new(:label('abc def'));
  isa-ok $label1, Gnome::Gtk3::Label;
  isa-ok $label1, Gnome::Gtk3::Widget;
  isa-ok $label1(), N-GObject;

  throws-like
    { $label1.get_nonvisible(); },
    X::Gnome, "non existent sub called",
    :message("Could not find native sub 'get_nonvisible\(...\)'");

  is $label1.gtk_label_get_text, 'abc def',
    'label 1 text ok, read with $label1.gtk_label_get_text';

  my Gnome::Gtk3::Label $label2 .= new(:label('pqr'));
  is $label2.gtk-label-get-text, 'pqr',
     'label 2 text ok, read with $label1.gtk-label-get-text';
  $label1($label2());
  is $label1.get-text, 'pqr',
     'label 1 text replaced, read with $label1.get-text';
}

#-------------------------------------------------------------------------------
subtest 'Builder config', {

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
done-testing;
