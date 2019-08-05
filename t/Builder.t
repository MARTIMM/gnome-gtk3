use v6;
#use lib '../perl6-gnome-gobject/lib';
use lib '../perl6-gnome-glib/lib';
use lib '../perl6-gnome-native/lib';
use Test;

use Gnome::N::N-GObject;
use Gnome::Glib::Error;
use Gnome::Glib::Quark;
use Gnome::GObject::Object;
use Gnome::Gtk3::Builder;
use Gnome::Gtk3::Button;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my $dir = 't/ui';
mkdir $dir unless $dir.IO ~~ :e;

#-------------------------------------------------------------------------------
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
subtest 'ISA tests', {
  my Gnome::Gtk3::Builder $builder;
  throws-like
    { $builder .= new; },
    X::Gnome, "No options used",
    :message('No options used to create or set the native widget');

  throws-like
    { $builder .= new( :build, :load); },
    X::Gnome, "Wrong options used",
    :message(
      /:s Unsupported options for
          'Gnome::Gtk3::Builder:'
          [(build||load) ',']+/
    );

  $builder .= new(:empty);
  isa-ok $builder, Gnome::Gtk3::Builder;
  isa-ok $builder(), N-GObject;
}

#-------------------------------------------------------------------------------
subtest 'Add ui from file to builder', {
  my Gnome::Gtk3::Builder $builder .= new(:empty);

#Gnome::N::debug(:on);

  my Int $e-code = $builder.add-from-file( $ui-file, Any);
  is $e-code, 1, "ui file added ok";

  my Str $text = $ui-file.IO.slurp;
  my N-GObject $b = $builder.new-from-string( $text, $text.chars);
  ok ?$b, 'builder is set';

  $builder .= new(:empty);
  $builder.add-gui(:filename($ui-file));
  ok ?$builder(), 'builder is added';
}

#-------------------------------------------------------------------------------
subtest 'Test builder errors', {
  my Gnome::Gtk3::Builder $builder .= new(:empty);

  throws-like
    { $builder.add-gui(:filename('x.glade')); },
    X::Gnome, "non existent file not added",
    :message('Failed to open file “x.glade”: No such file or directory');

  # Get the text glade text again and corrupt it by removing an element
  my Str $text = $ui-file.IO.slurp;
  $text ~~ s/ '<interface>' //;

  throws-like
    { $builder.add-gui(:string($text)); },
    X::Gnome, "erronenous xml file added",
    :message("<input>:4:40 Unhandled tag: <requires>");

  subtest "errorcode return from gtk_builder_add_from_file", {
    my Gnome::Glib::Quark $quark .= new;

    my Gnome::Glib::Error $e = $builder.add-from-file('x.glade');
    ok $e.domain > 0, "domain code: $e.domain()";
    is $quark.to-string($e.domain), 'g-file-error-quark', 'error domain ok';
    is $e.code, 4, 'error code for this error is 4 and is from file IO';
    is $e.message,
       'Failed to open file “x.glade”: No such file or directory',
       $e.message;
  }

  subtest "errorcode return from gtk_builder_add_from_string", {
    my Gnome::Glib::Quark $quark .= new;

    my Gnome::Glib::Error $e = $builder.add-from-string($text);
    is $e.domain, $builder.gtk_builder_error_quark(),
       "domain code: $e.domain()";
    is $quark.to-string($e.domain), 'gtk-builder-error-quark',
       "error domain: $quark.to-string($e.domain())";
    is $e.code, GTK_BUILDER_ERROR_UNHANDLED_TAG.value,
       'error code for this error is GTK_BUILDER_ERROR_UNHANDLED_TAG';
    is $e.message, '<input>:4:40 Unhandled tag: <requires>', $e.message;
  }
}

#-------------------------------------------------------------------------------
subtest 'Test items from ui', {
  my Gnome::Gtk3::Builder $builder .= new(:empty);

  my Int $e-code = $builder.add-from-file( $ui-file, Any);
  is $e-code, 1, "ui file added ok";

  isa-ok $builder.get-object('button'), N-GObject, 'returned a native object';

  my Gnome::Gtk3::Button $b .= new(:build-id<button>);
  is $b.get-label, 'button', 'button label ok';
  is $b.get-name, 'GtkButton', 'button name ok';
  is $b.get-border-width, 0, 'border width is 0';

  #$b.gtk-widget-show;
}

#-------------------------------------------------------------------------------
done-testing;

unlink $ui-file;
rmdir $dir;
