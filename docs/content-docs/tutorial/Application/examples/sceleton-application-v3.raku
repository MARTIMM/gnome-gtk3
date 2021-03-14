#!/usr/bin/env raku

use v6;
#use lib '/home/marcel/Languages/Raku/Projects/gnome-gobject/lib', 'lib';
#use lib '/home/marcel/Languages/Raku/Projects/gnome-gio/lib';
use lib 'lib';

use UserAppClassV3;
exit(UserAppClassV3.new.run);
