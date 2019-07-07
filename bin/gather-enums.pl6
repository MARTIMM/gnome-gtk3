use v6;

my @dir-roots = <
  /home/marcel/Languages/Perl6/Projects/perl6-gnome-gtk3
  /home/marcel/Languages/Perl6/Projects/perl6-gnome-gdk3
  /home/marcel/Languages/Perl6/Projects/perl6-gnome-gobject
  /home/marcel/Languages/Perl6/Projects/perl6-gnome-glib
  /home/marcel/Languages/Perl6/Projects/perl6-gnome-native
  >;

my @enum-list = ();

for @dir-roots -> $dir-root {
  try {
    my Proc $p = run "egrep", "-rIh", "--color=never",
                     "enum [[:alnum:]]+ is export",
                     $dir-root, :out;

    for $p.out.lines -> $line {
      $line ~~ m:s/^ enum $<enum-type> = [<alnum>+] is export /;
      @enum-list.push: ~$<enum-type> if ?$<enum-type>;
    }

    $p.out.close;
  }
}

'doc/Design-docs/scim-tool-enum-list'.IO.spurt(@enum-list.join("\n") ~ "\n");
