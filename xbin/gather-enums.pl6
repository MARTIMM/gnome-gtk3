#!/usr/bin/env -S raku -I lib

use v6;

my @dir-roots = <
  /home/marcel/Languages/Raku/Projects/gnome-gtk3/lib
  /home/marcel/Languages/Raku/Projects/gnome-gtk3/xt/NewModules

  /home/marcel/Languages/Raku/Projects/gnome-gdk3/lib
  /home/marcel/Languages/Raku/Projects/gnome-gdk3/xt/NewModules

  /home/marcel/Languages/Raku/Projects/gnome-gobject/lib
  /home/marcel/Languages/Raku/Projects/gnome-gobject/xt/NewModules

  /home/marcel/Languages/Raku/Projects/gnome-gio/lib
  /home/marcel/Languages/Raku/Projects/gnome-gio/xt/NewModules

  /home/marcel/Languages/Raku/Projects/gnome-glib/lib
  /home/marcel/Languages/Raku/Projects/gnome-glib/xt/NewModules

  /home/marcel/Languages/Raku/Projects/gnome-native/lib

  /home/marcel/Languages/Raku/Projects/gnome-pango/lib
  /home/marcel/Languages/Raku/Projects/gnome-pango/xt/NewModules

  /home/marcel/Languages/Raku/Projects/gnome-cairo/lib
  /home/marcel/Languages/Raku/Projects/gnome-cairo/xt/NewModules
  >;

my @enum-list = ();

for @dir-roots -> $dir-root {
  try {
    my Proc $p = run "egrep", "-rIh", "--color=never",
                     "enum [0-9A-Za-z_]+ is export",
                     $dir-root, :out;

    for $p.out.lines -> $line {
      $line ~~ m:s/^ enum $<enum-type> = [<alnum>+] is export /;

      if ?$<enum-type> {
        @enum-list.push: ~$<enum-type>;
        note ~$<enum-type>;
      }
    }

    $p.out.close;
  }
}

'Design-docs/skim-tool-enum-list'.IO.spurt(@enum-list.join("\n") ~ "\n");
