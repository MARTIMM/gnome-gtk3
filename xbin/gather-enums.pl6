use v6;

my @dir-roots = <
  /home/marcel/Languages/Perl6/Projects/gnome-gtk3/lib
  /home/marcel/Languages/Perl6/Projects/gnome-gtk3/xt/NewModules
  /home/marcel/Languages/Perl6/Projects/gnome-gdk3/lib
  /home/marcel/Languages/Perl6/Projects/gnome-gobject/lib
  /home/marcel/Languages/Perl6/Projects/gnome-glib/lib
  /home/marcel/Languages/Perl6/Projects/gnome-native/lib
  >;

my @enum-list = ();

for @dir-roots -> $dir-root {
  try {
    my Proc $p = run "egrep", "-rIh", "--color=never",
                     "enum [[:alnum:]]+ is export",
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

'Design-docs/scim-tool-enum-list'.IO.spurt(@enum-list.join("\n") ~ "\n");
