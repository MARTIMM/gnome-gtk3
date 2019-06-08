#!/usr/bin/env perl6

use v6;

#-------------------------------------------------------------------------------
my Str $library = '';
my Str $sub-declarations = '';
my Str $include-filename;
my Str $lib-class-name;

my Str $base-sub-name;
my Str $p6-lib-name;
my Str $p6-class-name;
my Str $p6-parentlib-name;
my Str $p6-parentclass-name;

my Str ( $section-doc, $short-description, $see-also);
my Str ( $signal-doc, $property-doc);

my @gtkdirlist = ();
my @gdkdirlist = ();
my @gobjectdirlist = ();
my @glibdirlist = ();
#-------------------------------------------------------------------------------
sub MAIN ( Str:D $base-name ) {
  load-dir-lists();

  my Bool $file-found;
  my Str ( $include-content, $source-content);
  $base-sub-name = $base-name;
  ( $file-found, $include-filename, $lib-class-name, $p6-class-name,
    $p6-lib-name, $include-content, $source-content
  ) = setup-names($base-name);

  if $file-found {
    $sub-declarations = process-content( $include-content, $source-content);
    ( $p6-parentclass-name, $p6-parentlib-name) =
       parent-class($include-content);

    ( $section-doc, $short-description, $see-also) =
      get-section($source-content);

    $signal-doc = get-signals($source-content);
    $property-doc = get-properties($source-content);

    my Str $module-text = substitute-in-template();
    say $module-text;
  }

  else {
    note "Include file '$include-filename' is not found";
  }
}

#-------------------------------------------------------------------------------
sub process-content( Str:D $include-content, Str:D $source-content --> Str ) {

  my Str $sub-declarations = '';
  my Str $return-src-doc = '';
  my Str $sub-doc = '';
  my Array $items-src-doc = [];

#note "IC: $include-content";
  $include-content ~~ m:g/^^ 'GDK_AVAILABLE_IN_' <-[;]>+ ';'/;
  my List $results = $/[*];

  for @$results -> $r {
#note "\n\$$r >> $r";

    my Str $declaration = ~$r;
    next if $declaration ~~ m/ 'G_GNUC_CONST' ';' /;

    $declaration ~~ s/^ 'GDK_AVAILABLE_IN_' .*?  \n //;
    $declaration ~~ s:g/ \s* \n \s* //;
    $declaration ~~ s:g/ \s+ / /;
#note "\n0 >> $declaration";

    my Str ( $return-type, $p6-return-type) = ( '', '');
    my Bool $type-is-class;
    ( $declaration, $return-type, $p6-return-type, $type-is-class) =
      get-type($declaration);

#note "1 >> $declaration";
    $declaration ~~ m/ $<sub-name> = [ [<alpha> || '_' || \d]+ ] \s* /;
    my Str $sub-name = ~$<sub-name>;
    $declaration ~~ s/ $sub-name \s* //;
    $declaration ~~ s:g/ <[();]> || 'void' //;

    ( $sub-doc, $return-src-doc, $items-src-doc) =
      get-sub-doc( $sub-name, $source-content);

    my Str $args-declaration = $declaration;
    my Str ( $pod-args, $args, $pod-doc-items) = ( '', '', '');
    my Bool $first-arg = True;
    for $args-declaration.split(',') -> $raw-arg {
      my Str ( $arg, $arg-type, $p6-arg-type);
      ( $arg, $arg-type, $p6-arg-type, $type-is-class) = get-type($raw-arg);

      if ?$arg {
        my Str $pod-doc-item-doc = $items-src-doc.shift // ''
          if $items-src-doc.elems;

        # skip first argument when type is also the class name
        if $first-arg and $type-is-class {
          $first-arg = False;
        }

        else {
          $pod-args ~= ',' if ?$pod-args;
          $pod-args ~= " $p6-arg-type \$$arg";
          $pod-doc-items ~= "=item $p6-arg-type \$$arg; $pod-doc-item-doc\n";
        }

        $args ~= ', ' if ?$args;
        $args ~= " $arg-type \$$arg";

      }
    }

#    note "2 >> $sub-name";
#    note "3 >> $args";
#    note "4 >> $return-type";

    my Str $pod-doc-return = '';
    my Str $pod-returns = '';
    my Str $returns = '';
    if ?$return-type {
      $pod-returns = " --> $p6-return-type ";
      $returns = "\n  returns $return-type";
      $pod-doc-return = "\nReturns $return-type; $return-src-doc";
    }

    my $pod-sub-name = pod-sub-name($sub-name);
    my Str $sub = Q:qq:to/EOSUB/;

      #-------------------------------------------------------------------------------
      =begin pod
      =head2 $pod-sub-name

      $sub-doc
        method $sub-name ($pod-args$pod-returns)

      $pod-doc-items$pod-doc-return
      =end pod

      sub $sub-name ( $args )$returns
        is native($library)
        \{ * \}
      EOSUB


#    note $sub;
    $sub-declarations ~= $sub;
  }

  $sub-declarations
}

#-------------------------------------------------------------------------------
sub parent-class ( Str:D $include-content --> List ) {

  $include-content ~~ m/
    ^^ \s*
    $<lib-parent> = [<alnum>+]
    \s+ 'parent_class'
  /;

  my Str $p6-lib-parentclass = ~($<lib-parent> // '');
  my Str $p6-parentlib-name = '';
  given $p6-lib-parentclass {
    when /^ Gtk / {
      $p6-parentlib-name = 'Gtk3';
    }

    when /^ Gdk / {
      $p6-parentlib-name = 'Gdk3';
    }
  }

  $p6-lib-parentclass ~~ s:g/ ['Gtk' || 'Gdk'|| 'Class'] //;

  ( $p6-lib-parentclass, $p6-parentlib-name);
}

#-------------------------------------------------------------------------------
# Get the type from the start of the declaration and remove it from that
# declaration. The type is cleaned up by removing 'const', 'void' and pointer(*)
sub get-type( Str:D $declaration is copy --> List ) {

  $declaration ~~ m/ $<type> = [
                     'const'? \s* <alnum>+ [ \s+ \* ]? \s*
                     ]
                   /;
  my Str $type = ~($<type> // '');
  $declaration ~~ s/ $type  \s* //;

  # convert a pointer char type before cleanup
  $type ~~ s/ 'gchar' \s+ '*' /str/;

  # cleanup
  $type ~~ s:g/ ['const' || 'void' || '*'] //;
  $type ~~ s/ \s+ / /;
  $type ~~ s/ \s+ $//;
  $type ~~ s/^ \s+ //;
  $type ~~ s/^ \s* $//;
#note "Cleaned type: $type";

  # check type for its class name
  my Bool $type-is-class = $type eq $lib-class-name;

  # convert to native perl types
  $type = 'N-GObject' if is-n-gobject($type);

  # copy to perl6 type for independent convertions
  my Str $p6-type = $type;

  # convert to native perl types
  #$type ~~ s/ 'gchar' \s+ '*' /str/;

  $type ~~ s:s/ gboolean || gint || gint32 /int32/;
  $type ~~ s:s/ gchar || gint8 /int8/;
  $type ~~ s:s/ gshort || gint16 /int16/;
  $type ~~ s:s/ glong || gint64 /int64/;

  $type ~~ s:s/ guint || guint32 /uint32/;
  $type ~~ s:s/ guchar || guint8 /byte/;
  $type ~~ s:s/ gushort || guint16 /uint16/;
  $type ~~ s:s/ gulong || guint64 /uint64/;

  $type ~~ s:s/ gssize || goffset /int64/;
  $type ~~ s:s/ gsize /uint64/;
  $type ~~ s:s/ gfloat /num32/;
  $type ~~ s:s/ gdouble /num64/;

  # convert to perl types
  #$p6-type ~~ s/ 'gchar' \s+ '*' /Str/;
  $p6-type ~~ s/ str /Str/;

  $p6-type ~~ s:s/ gboolean || gint || gint32 ||
                   gchar || gint8 || gshort || gint16 ||
                   glong || gint64 ||
                   gssize || goffset
                 /Int/;

  $p6-type ~~ s:s/ guint || guint32 || guchar || guint8 ||
                   gushort || guint16 || gulong || guint64 ||
                   gsize
                 /UInt/;

  $p6-type ~~ s:s/ gfloat || gdouble /Num/;

#note "type: $type, p6 type: $p6-type";

  ( $declaration, $type, $p6-type, $type-is-class)
}

#-------------------------------------------------------------------------------
sub setup-names ( Str:D $base-sub-name --> List ) {
  my Str $include-file = $base-sub-name;
  $include-file ~~ s:g/ '_' //;

  my @parts = $base-sub-name.split('_');
  my Str $lib-class = @parts>>.tc.join;

  my Str $p6-class = @parts[1..*-1]>>.tc.join;
#`{{
  my Str $p6-lib-name = '';
  given $lib-class {
    when /^ Gtk / {
      $p6-lib-name = 'Gtk3';
    }

    when /^ Gdk / {
      $p6-lib-name = 'Gdk3';
    }
  }
}}

  # assume linux fedora
  my Str $gtk-path = '/usr/include/gtk-3.0/gtk';
  my Str $gdk-path = '/usr/include/gtk-3.0/gdk';
  my Str $glib-path = '/usr/include/glib-2.0/glib';
  my Str $gobject-path = '/usr/include/glib-2.0/gobject';

  # c-source file text paths, downloaded latest version. the version does not
  # matter much, just searching for documentation.
  my Str $gtk-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/gtk+-3.22.0/gtk';
  my Str $gdk-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/gtk+-3.22.0/gdk';
  my Str $glib-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/glib-2.60.0/glib';
  my Str $gobject-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/glib-2.60.0/gobject';

  my Str ( $include-content, $source-content);
  my Bool $file-found = False;
  for $gtk-path, $gdk-path, $glib-path, $gobject-path -> $path {
    if "$path/$include-file.h".IO.r {
      $file-found = True;
      $include-content = "$path/$include-file.h".IO.slurp;
      given $path {
        when $gtk-path {
          $source-content = "$gtk-srcpath/$include-file.c".IO.slurp;
          $library = "&gtk-lib";
          $p6-lib-name = 'Gtk3';
        }

        when $gdk-path {
          $source-content = "$gdk-srcpath/$include-file.c".IO.slurp;
          $library = "&gdk-lib";
          $p6-lib-name = 'Gdk3';
        }

        when $glib-path {
          $source-content = "$glib-srcpath/$include-file.c".IO.slurp;
          $library = "&glib-lib";
          $p6-lib-name = 'Glib';
        }

        when $gobject-path {
          $source-content = "$gobject-srcpath/$include-file.c".IO.slurp;
          $library = "&gobject-lib";
          $p6-lib-name = 'GObject';
        }
      }

      last;
    }
  }

  ( $file-found, $include-file, $lib-class, $p6-class, $p6-lib-name,
    $include-content, $source-content
  )
}

#-------------------------------------------------------------------------------
sub pod-sub-name ( Str:D $sub-name --> Str ) {

  my Str $pod-sub-name = $sub-name;

  my Str $s = $sub-name;
  $s ~~ s/^ $base-sub-name '_' //;
  if $s ~~ m/ '_' / {
    $pod-sub-name = [~] '[', $base-sub-name, '_] ', $s;
  }

  $pod-sub-name
}

#-------------------------------------------------------------------------------
sub is-n-gobject ( Str:D $type-name is copy --> Bool ) {

  my Bool $is-n-gobject = False;
  $type-name .= lc;

  given $type-name {
    when /^ 'gtk' / {
      $is-n-gobject = $type-name ~~ any(@gtkdirlist);
    }

    when /^ 'gdk' / {
      $is-n-gobject = $type-name ~~ any(|@gdkdirlist);
    }

    when /^ 'g' / {

      $is-n-gobject = $type-name ~~ any(|@glibdirlist);
      $is-n-gobject = $type-name ~~ any(|@gobjectdirlist) unless $is-n-gobject;
    }
  }

  $is-n-gobject
}

#-------------------------------------------------------------------------------
sub load-dir-lists ( ) {

  @gtkdirlist = "doc/Design-docs/gtk3-list.txt".IO.slurp.lines;
  @gdkdirlist = "doc/Design-docs/gdk3-list.txt".IO.slurp.lines;
  @gobjectdirlist = "doc/Design-docs/gobject-list.txt".IO.slurp.lines;
  @glibdirlist = "doc/Design-docs/glib-list.txt".IO.slurp.lines;
}

#-------------------------------------------------------------------------------
sub substitute-in-template ( --> Str ) {

  my Str $template-text = "doc/Design-docs/scim-tool-template.pm6".IO.slurp;

  $template-text ~~ s:g/ 'Gnome::LIBRARYMODULE'
                       /Gnome::{$p6-lib-name}::{$p6-class-name}/;

  my Str ( $t1, $t2) = ( '', '');
  if $p6-parentlib-name and $p6-parentclass-name {
    $t1 = "use Gnome::{$p6-parentlib-name}::{$p6-parentclass-name};";
    $t2 = "also is Gnome::{$p6-parentlib-name}::{$p6-parentclass-name};";
  }

  $template-text ~~ s:g/ 'USE-LIBRARY-PARENT' /$t1/;
  $template-text ~~ s:g/ 'ALSO-IS-LIBRARY-PARENT' /$t2/;

  $template-text ~~ s:g/ 'BASE_SUBNAME' /$base-sub-name/;
  $template-text ~~ s:g/ 'SUB_DECLARATIONS' /$sub-declarations/;

  $template-text ~~ s:g/ 'MODULE-SHORTDESCRIPTION' /$short-description/;
  $template-text ~~ s:g/ 'MODULE-DESCRIPTION' /$section-doc/;
  $template-text ~~ s:g/ 'MODULE-SEEALSO' /$see-also/;

  $template-text ~~ s:g/ 'SIGNAL-DOC' /$signal-doc/;
  $template-text ~~ s:g/ 'PROPERTY-DOC' /$property-doc/;

  $template-text
}

#-------------------------------------------------------------------------------
sub get-sub-doc ( Str:D $sub-name, Str:D $source-content --> List ) {

  my Str $return-src-doc = '';
  my Array $items-src-doc = [];

  $source-content ~~ m/ '/**' .*? $sub-name ':' $<sub-doc> = [ .*? '*/' ] /;
  my Str $doc = ~$<sub-doc>;

  $doc = primary-doc-changes($doc);

#  ( $doc, $items-src-doc) = get-podding-items($doc);
  loop {
    $doc ~~ m/ ^^ \s+ '*' \s+ '@' <alnum>+ ':' $<item-doc> = [ .*? ] $$ /;
    my Str $item = ~($<item-doc> // '');
#    note "doc '$doc'";
#    note "item doc '$sub-name': ", $item;
    last unless ?$item;
    $doc ~~ s/ '*' \s+ '@' <alnum>+ ':' $item //;
#`{{
#    note "item doc 0 '$sub-name': ", $item;
    $item ~~ m/ '#' (<alnum>+) /;
    my Str $oct = ~($/[0] // '');
    $oct ~~ s/^ ('Gtk' || 'Gdk') (<alnum>+) /Gnome::$/[0]3::$/[1]/;
    $item ~~ s/ '#' (<alnum>+) /C\<$oct\>/;
#    note "item doc 1 '$sub-name': ", $item;
}}
    $items-src-doc.push($item);
  }

  $doc ~~ m/ ^^ \s+ '*' \s+ 'Returns:' \s+ $<return-doc> = [ .*? ] $$ /;
  $return-src-doc = ~($<return-doc> // '');
  #$return-src-doc = modify-percent-vars($return-src-doc);
  #$return-src-doc ~~ s/ '%TRUE' /1/;            # booleans are integers
  #$return-src-doc ~~ s/ '%FALSE' /0/;

  # remove 'Returns: doc'
  $doc ~~ s/ ^^ \s+ '*' \s+ 'Returns:' \s+ $<return-doc> = [ .*? ] \n //;
  $doc = cleanup-source-doc($doc);

#note "Doc: $doc";
  ( ~$doc, $return-src-doc, $items-src-doc)
}

#-------------------------------------------------------------------------------
sub get-section ( Str:D $source-content --> List ) {

  $source-content ~~ m/ '/**' .*? SECTION ':' .*? '*/' /;
  my Str $section-doc = ~$/;

  $section-doc = primary-doc-changes($section-doc);

  $section-doc ~~ m/
      ^^ \s+ '*' \s+ '@Short_description:' \s* $<text> = [.*?] $$
  /;
  my Str $short-description = ~($<text>//'');
  $section-doc ~~ s/ ^^ \s+ '*' \s+ '@Short_description:' [.*?] \n //;

  $section-doc ~~ m/ ^^ \s+ '*' \s+ '@See_also:' \s* $<text> = [.*?] $$ /;
  my Str $see-also = ~($<text>//'');
  $section-doc ~~ s/ ^^ \s+ '*' \s+ '@See_also:' [.*?] \n //;

  # cleanup rest
  $section-doc ~~ s/ ^^ \s+ '*' \s+ 'SECTION:' [.*?] \n //;
  $section-doc ~~ s/ ^^ \s+ '*' \s+ '@Title:' [.*?] \n //;
  $section-doc = cleanup-source-doc($section-doc);
  $section-doc ~~ s:g/ ^^ '#' \s+ 'CSS' \s+ 'nodes'/\n=head2 Css Nodes\n/;
#note "doc 2: ", $section-doc;

  ( $section-doc, $short-description, $see-also)
}

#-------------------------------------------------------------------------------
sub get-signals ( Str:D $source-content is copy --> Str ) {

  my Array $items-src-doc;
  my Str $signal-name;
  my Str $signal-doc = '';

  loop {
    $items-src-doc = [];
    $signal-name = '';

    $source-content ~~ m/
      $<signal-doc> = [ '/**' \s+ '*' \s+ $lib-class-name '::'  .*? '*/' ]
    /;
    my Str $sdoc = ~($<signal-doc> // '');
    last unless ?$sdoc;

    # remove from source
    $source-content ~~ s/$sdoc//;


#note "Signal doc:\n", $sdoc;

    $sdoc = primary-doc-changes($sdoc);

    $sdoc ~~ m/
      ^^ \s+ '*' \s+ $lib-class-name '::' $<signal-name> = [ [<alnum> || '-']+ ]
    /;
    $signal-name = ~($<signal-name> // '');

    $signal-doc ~= "\n=head3 $signal-name";
#note "SD: $signal-name, $signal-doc";

    # get arguments for this signal handler
#    ( $sdoc, $items-src-doc) = get-podding-items($sdoc);
    loop {
      $sdoc ~~ m/
        ^^ \s+ '*' \s+ '@'
        $<item-name> = [<alnum>+] ':'
        \s* $<item-doc> = [ .*? ]
        $$
      /;

      my Str $item-name = ~($<item-name> // '');
      my Str $item-doc = ~($<item-doc> // '');
      $sdoc ~~ s/ ^^ \s+ '*' \s+ '@' $item-name ':' \s* $item-doc $$ //;

#note "doc '$doc'";
#note "item doc: ", $item;
      last unless ?$item-name;
      $sdoc ~~ s/ '*' \s+ '@' $item-name ':' $item-doc \n //;

#note "item doc 0: ", $item;
      $item-doc ~~ m/ '#' (<alnum>+) /;
      my Str $oct = ~($/[0] // '');
      $oct ~~ s/^ ('Gtk' || 'Gdk') (<alnum>+) /Gnome::$/[0]3::$/[1]/;
      $item-doc ~~ s/ '#' (<alnum>+) /C\<$oct>/;
#note "item doc 1: ", $item-doc;

      $items-src-doc.push: %(:$item-name, :$item-doc);
    }

#note "item doc 2: ", $sdoc;

    # cleanup info
    $sdoc = cleanup-source-doc($sdoc);

#note "item doc 3: ", $sdoc;

    $signal-doc ~= "\n{$sdoc}  method handler (\n    ";

    my Int $count = 0;
    my Str $type;
    for @$items-src-doc -> $idoc {
      $type = '';
      if $count == 0 and $idoc<item-name> ~~ any(<widget object>) {
        $type = 'Gnome::GObject::Object ';
      }

      elsif $count == 1 and $idoc<item-name> eq 'event' {
        $type = 'GdkEvent';
      }

      $signal-doc ~= "$type:\$$idoc<item-name>, ";
      $count++;
    }

    $signal-doc ~= "\n    :\$user-option1, ..., \$user-optionN\n  );\n\n";

    for @$items-src-doc -> $idoc {
      $signal-doc ~= "=item \$$idoc<item-name>; $idoc<item-doc>\n";
    }
  }

  $signal-doc
}

#-------------------------------------------------------------------------------
sub get-properties ( Str:D $source-content is copy --> Str ) {

  my Str $property-name;
  my Str $property-doc = '';

  loop {
    $property-name = '';

    $source-content ~~ m/
      $<property-doc> = [ '/**' \s+ '*' \s+
      $lib-class-name ':' <-[:]> .*? '*/' ]
    /;
    my Str $sdoc = ~($<property-doc> // '');
#note "Sdoc: $sdoc";
    last unless ?$sdoc;
    # remove from source
    $source-content ~~ s/$sdoc//;

    # skip deprecated properties
    next if $sdoc ~~ m/ '*' \s+ 'Deprecated:' /;

    unless ?$property-doc {
      $property-doc ~= Q:to/EODOC/;
        #TODO Must add type info
        =begin pod
        =head1 Properties

        An example of using a string type property of a C<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties.

          my Gnome::Gtk3::Label $label .= new(:empty);
          my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
          $label.g-object-get-property( 'label', $gv);
          $gv.g-value-set-string('my text label');

        EODOC
    }
#note "Property doc:\n", $sdoc;

    $sdoc ~~ m/
      ^^ \s+ '*' \s+ $lib-class-name ':'
      $<prop-name> = [ <-[:]> [<alnum> || '-']+ ]
    /;
    $property-name = ~($<prop-name> // '');
    $property-doc ~= "\n=head2 $property-name";
#note "RD: $property-name";

    # change any #GtkClass to C<Gnome::Gtk::Class> and cleanup
    $sdoc = cleanup-source-doc($sdoc);
    $sdoc = primary-doc-changes($sdoc);

    # cleanup info

#note "item doc 3: ", $sdoc;

    $property-doc ~= "\n$sdoc\n";
  }

  $property-doc ~ "=end pod\n"
}
#-------------------------------------------------------------------------------
sub cleanup-source-doc ( Str:D $text is copy --> Str ) {

  # remove property and signal line
  $text ~~ s/ ^^ \s+ '*' \s+ $lib-class-name ':' .*? $$ //;
  $text ~~ s/ ^^ \s+ '*' \s+ $lib-class-name '::' .*? $$ //;

  $text ~~ s/ ^^ '/**' .*? \n //;                   # Doc start
  $text ~~ s/ ^^ \s+ '*/' .* $ //;                  # Doc end
  $text ~~ s/ ^^ \s+ '*' \s+ Since: .*? \n //;      # Since: version
  $text ~~ s/ ^^ \s+ '*' \s+ Deprecated: .*? \n //; # Deprecated: version
  $text ~~ s:g/ ^^ \s+ '*' ' '? (.*?) $$ /$/[0]/;   # Leading star
  $text ~~ s:g/ ^^ \s+ '*' \s* \n //;               # Empty lines

  $text ~ "\n"
}

#-------------------------------------------------------------------------------
sub primary-doc-changes ( Str:D $text is copy --> Str ) {

  $text = podding-class($text);
  $text = podding-property($text);
  $text = podding-function($text);
  $text = modify-percent-vars($text);
}

#-------------------------------------------------------------------------------
# change any #GtkClass to C<Gnome::Gtk::Class> and Gdk likewise
sub podding-class ( Str:D $text is copy --> Str ) {

  loop {
    $text ~~ m/ '#' (<alnum>+) /;
    my Str $oct = ~($/[0] // '');
    last unless ?$oct;

    $oct ~~ s/^ ('Gtk' || 'Gdk') (<alnum>+) /Gnome::$/[0]3::$/[1]/;
    $text ~~ s/ '#' (<alnum>+) /C\<$oct\>/;
  }

  # convert a few without leading octagon (#)
  $text ~~ s:g/ ('Gtk' || 'Gdk') (\D <alnum>+) /C<Gnome::$/[0]3::$/[1]>/;

  $text
}


#-------------------------------------------------------------------------------
sub get-podding-items ( Str:D $text is copy --> List ) {

  my Array $items-src-doc = [];

  # get arguments for this signal handler
  loop {
    $text ~~ m/
      ^^ \s+ '*' \s+ '@'
      $<item-name> = [<alnum>+] ':'
      \s* $<item-doc> = [ .*? ]
      $$
    /;

    my Str $item-name = ~($<item-name> // '');
    my Str $item-doc = ~($<item-doc> // '');

#note "doc '$doc'";
#note "item doc: ", $item;
    last unless ?$item-name;

    # remove from string
    $text ~~ s/ ^^ \s+ '*' \s+ '@' $item-name ':' \s* $item-doc \n //;
#    $text ~~ s/ '*' \s+ '@' $item-name ':' $item-doc \n //;

#note "item doc 0: ", $item;
    $item-doc = podding-class($item-doc);
#`{{
    $item-doc ~~ m/ '#' (<alnum>+) /;
    my Str $oct = ~($/[0] // '');
    $oct ~~ s/^ ('Gtk' || 'Gdk') (<alnum>+) /Gnome::$/[0]3::$/[1]/;
    $item-doc ~~ s/ '#' (<alnum>+) /C\<$oct>/;
}}
#note "item doc 1: ", $item-doc;

    $items-src-doc.push: %(:$item-name, :$item-doc);
  }

  ( $text, $items-src-doc)
}

#-------------------------------------------------------------------------------
# change any ::signal to C<signal>
sub podding-signal ( Str:D $text is copy --> Str ) {

  loop {
    last unless $text ~~ m/ \s '::' [<alnum> || '-']+ /;
    $text ~~ s/ \s '::' ([<alnum> || '-']+) / C<$/[0]>/;
  }

  $text
}

#-------------------------------------------------------------------------------
# change any :property to C<property>
sub podding-property ( Str:D $text is copy --> Str ) {

  loop {
    last unless $text ~~ m/ \s ':' [<alnum> || '-']+ /;
    $text ~~ s/ \s ':' ([<alnum> || '-']+) / C<$/[0]>/;
  }

  $text
}

#-------------------------------------------------------------------------------
# change any function() C<function()>
sub podding-function ( Str:D $text is copy --> Str ) {

    # change any function() to C<function()>
#    loop {
#      last unless $text ~~ m/ <!after 'C<'> [<alnum>+ '()'] /;
#      $text ~~ s/ <!after 'C<'> (<alnum>+ '()') /C<$/[0]>/;
#note $text;
#    }

  $text
}

#-------------------------------------------------------------------------------
# change any function() C<function()>
sub modify-percent-vars ( Str:D $text is copy --> Str ) {
  $text ~~ s/ '%TRUE' /1/;
  $text ~~ s/ '%FALSE' /0/;
  $text ~~ s/ '%NILL' /Any/;

  $text
}
