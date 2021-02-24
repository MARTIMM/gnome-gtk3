#!/usr/bin/env raku

use v6;
use lib '/home/marcel/Languages/Raku/Projects/gnome-gobject/lib', 'lib';

use UserAppClass;

my UserAppClass $user-app .= new;
exit($user-app.run);
















=finish
use Gnome::Gio::Enums;
use Gnome::Gtk3::Application;

#-------------------------------------------------------------------------------
sub MAIN ( Bool :$t0 = False ) {

  if $t0 {
    use UserAppClass;

    my UserAppClass $userapp-class .= new(
      :app-id('io.github.martimm.tutorial.sceleton'),
    #  :flags(G_APPLICATION_HANDLES_OPEN), # +| G_APPLICATION_NON_UNIQUE),
    #  :!initialize
    );
  }
}
