use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::RGBA;
use Gnome::Gtk3::ColorButton;

#use Gnome::N::X;
#X::Gnome.debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my GdkRGBA $color .= new(
    :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
  );

  is $color.green, 0.5, 'green ok';

  my Gnome::Gtk3::ColorButton $v .= new(:$color);
  isa-ok $v, Gnome::Gtk3::ColorButton;
}

#-------------------------------------------------------------------------------
done-testing;
