use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::RGBA;
use Gnome::Gtk3::ColorButton;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::ColorButton $cb .= new;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $cb .= new;
  isa-ok $cb, Gnome::Gtk3::ColorButton, '.new';

   my GdkRGBA $color .= new(
    :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
  );

  $cb .= new(:$color);
  isa-ok $cb, Gnome::Gtk3::ColorButton, '.new(:color)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $cb.set-title('choose your favorite color');
  is $cb.get-title, 'choose your favorite color',
     '.set-title() / .get-title()';
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
