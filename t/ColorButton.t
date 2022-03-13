use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::RGBA;

use Gnome::Gtk3::ColorButton;

use Gnome::N::GlibToRakuTypes;
use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::ColorButton $cb .= new;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $cb .= new;
  isa-ok $cb, Gnome::Gtk3::ColorButton, '.new';

   my N-GdkRGBA $color .= new(
    :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
  );

  $cb .= new(:$color);
  isa-ok $cb, Gnome::Gtk3::ColorButton, '.new(:color)';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $cb.set-title('choose your favorite color');
  is $cb.get-title, 'choose your favorite color',
     '.set-title() / .get-title()';
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::ColorButton', {
  class MyClass is Gnome::Gtk3::ColorButton {
    method new ( |c ) {
      self.bless( :GtkColorButton, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::ColorButton, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  my @r = $cb.get-properties(
    'show-editor', gboolean, 'title', Str, 'use-alpha', gboolean
  );
  is-deeply @r, [ 0, 'choose your favorite color', 0],
    'show-editor, title, use-alpha';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
  my Gnome::Gdk3::RGBA() $rgba = $cb.get-rgba;
  is-deeply [ $rgba.red, $rgba.blue, $rgba.green], [ .5e0, .5e0, .5e0],
    '.get-rgba()';
}

#`{{

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
