use v6;
use NativeCall;
use Test;

use Gnome::Gdk3::RGBA;
use Gnome::Gtk3::ColorButton;

#-------------------------------------------------------------------------------
subtest 'color button set', {
  my GdkRGBA $color .= new(
    :red(.5e0), :green(.5e0), :blue(.5e0), :alpha(.5e0)
  );

  is $color.green, 0.5, 'green ok';

  my Gnome::Gtk3::ColorButton $cb .= new(:$color);
  isa-ok $cb, Gnome::Gtk3::ColorButton;
}

#-------------------------------------------------------------------------------
done-testing;
