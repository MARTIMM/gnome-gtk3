use v6;
#use lib '../perl6-gnome-gobject/lib';
#use lib '../perl6-gnome-glib/lib';
#use lib '../perl6-gnome-native/lib';
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
my Gnome::Glib::Quark $quark .= new(:empty);
my Gnome::Glib::Error $e;

my Str $ui-file = 't/data/ui.glade';

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
  isa-ok $builder, Gnome::Gtk3::Builder, '.new(:empty)';
}

#-------------------------------------------------------------------------------
subtest 'Add ui from file to builder', {
  my Gnome::Gtk3::Builder $builder .= new(:empty);

  $e = $builder.add-from-file($ui-file);
  nok $e.error-is-valid, ".add-from-file()";

  my Str $text = $ui-file.IO.slurp;
  $e = $builder.add-from-string($text);
  nok $e.error-is-valid, ".add-from-string()";

  my N-GObject $b = $builder.new-from-string( $text, $text.chars);
  ok $b.defined, '.new-from-string()';

  $b = $builder.new-from-file($ui-file);
  ok $b.defined, '.new-from-file()';
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
    $e = $builder.add-from-file('x.glade');
    ok $e.error-is-valid, "error from .add-from-file()";
    ok $e.domain > 0, "domain code: $e.domain()";
    is $quark.to-string($e.domain), 'g-file-error-quark', 'error domain ok';
    is $e.code, 4, 'error code for this error is 4 and is from file IO';
    is $e.message,
       'Failed to open file “x.glade”: No such file or directory',
       $e.message;
  }

  subtest "errorcode return from gtk_builder_add_from_string", {
    my Gnome::Glib::Quark $quark .= new(:empty);

    $e = $builder.add-from-string($text);
    ok $e.error-is-valid, "error from .add-from-string()";
    is $e.domain, $builder.error-quark(), "domain code: $e.domain()";
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
  $e = $builder.add-from-file($ui-file);
  nok $e.error-is-valid, ".add-from-file()";

  isa-ok $builder.get-object('my-button'), N-GObject, '.get-object()';

  my Gnome::Gtk3::Button $b .= new(:build-id<my-button>);
  is $b.get-label, 'button text', '.get-label()';
  is $b.gtk-widget-get-name, 'GtkButton', '.gtk-widget-get-name()';
  is $b.get-border-width, 0, '.get-border-width()';

  #$b.gtk-widget-show;
}

#-------------------------------------------------------------------------------
done-testing;
