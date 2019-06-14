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
my Str ( $signal-doc, $property-doc, $type-doc);

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
    $type-doc = get-vartypes($include-content);

    my Str $module-text = substitute-in-template();
    "xt/$p6-class-name.pm6".IO.spurt($module-text);

    my Str $m = '$v';
    my Str $class = [~] 'Gnome::', $p6-lib-name, '::', $p6-class-name;
    my Str $test-content = Q:s:to/EOTEST/;
      use v6;
      use NativeCall;
      use Test;

      use $class;

      #use Gnome::N::X;
      #X::Gnome.debug(:on);

      #-------------------------------------------------------------------------------
      subtest 'ISA test', {
        my $class $m .= new(...);
        isa-ok $m, $class;
      }

      #-------------------------------------------------------------------------------
      done-testing;

      EOTEST

    "xt/$p6-class-name.t".IO.spurt($test-content);
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
  my Bool $variable-args-list;

#note "IC: $include-content";
  # get all subroutines starting with 'GDK_AVAILABLE_IN_ALL' or
  # 'GDK_AVAILABLE_IN_\d_\d' version spec. subroutines starting with
  # 'GDK_DEPRECATED_IN_' are ignored.
  $include-content ~~ m:g/^^ 'GDK_AVAILABLE_IN_' <-[;]>+ ';'/;
  my List $results = $/[*];

  # process subroutines
  for @$results -> $r {
    $variable-args-list = False;
#note "\n\$$r >> $r";

    my Str $declaration = ~$r;

#next unless $declaration ~~ m:s/ const gchar \* /;
    # skip constants and subs with variable argument lists
    next if $declaration ~~ m/ 'G_GNUC_CONST' ';' /;
    $variable-args-list = True if $declaration ~~ m/ 'G_GNUC_NULL_TERMINATED' /;

    # remove prefix and tidy up a bit
    $declaration ~~ s/^ 'GDK_AVAILABLE_IN_' .*?  \n //;
    $declaration ~~ s:g/ \s* \n \s* //;
    $declaration ~~ s:g/ \s+ / /;
#note "\n0 >> $declaration";

    my Str ( $return-type, $p6-return-type) = ( '', '');
    my Bool $type-is-class;

    # convert and remove return type from declaration
    ( $declaration, $return-type, $p6-return-type, $type-is-class) =
      get-type( $declaration, :!attr);

#note "1 >> $declaration";
    # get the subroutine name and remove from declaration
    $declaration ~~ m/ $<sub-name> = [ <alnum>+ ] \s* /;
    my Str $sub-name = ~$<sub-name>;
    $declaration ~~ s/ $sub-name \s* //;

    # remove any brackets, and other stuff left before arguments are processed
    $declaration ~~ s:g/ <[();]> || 'void' || 'G_GNUC_NULL_TERMINATED' //;

    # get subroutine documentation from c source
    ( $sub-doc, $return-src-doc, $items-src-doc) =
      get-sub-doc( $sub-name, $source-content);

#note "Pod items: $items-src-doc.elems()\n  ", $items-src-doc.join("\n  ");

    my Str $args-declaration = $declaration;
    my Str ( $pod-args, $args, $pod-doc-items) = ( '', '', '');
    my Bool $first-arg = True;

    # process arguments
    for $args-declaration.split(/ \s* ',' \s* /) -> $raw-arg {
      my Str ( $arg, $arg-type, $p6-arg-type);
      ( $arg, $arg-type, $p6-arg-type, $type-is-class) =
        get-type( $raw-arg, :attr);

      if ?$arg {
        my Str $pod-doc-item-doc = $items-src-doc.shift if $items-src-doc.elems;
#note "pod info: $p6-arg-type, $arg, $pod-doc-item-doc";

        # skip first argument when type is also the class name
        if $first-arg and $type-is-class {
        }

        # skip also when variable is $any set to default Any type
        elsif $arg eq 'any = Any' {
        }

        else {
          # make arguments pod doc
          $pod-args ~= ',' if ?$pod-args;
          $pod-args ~= " $p6-arg-type \$$arg";
          $pod-doc-items ~= "=item $p6-arg-type \$$arg; $pod-doc-item-doc\n";
        }

        # add argument to list for sub declaration
        $args ~= ', ' if ?$args;
        $args ~= "$arg-type \$$arg";
      }

      $first-arg = False;
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
      $pod-doc-return = "\nReturns $p6-return-type; $return-src-doc";
    }

    my Str $start-comment = $variable-args-list ?? "#`[[\n" !! '';
    my Str $end-comment = $variable-args-list ?? "\n]]" !! '';

    my $pod-sub-name = pod-sub-name($sub-name);
    my Str $sub = Q:qq:to/EOSUB/;

      $start-comment#-------------------------------------------------------------------------------
      =begin pod
      =head2 $pod-sub-name

      $sub-doc

        method $sub-name ($pod-args$pod-returns )

      $pod-doc-items$pod-doc-return
      =end pod

      sub $sub-name ( $args )$returns
        is native($library)
        \{ * \}$end-comment
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
sub get-type( Str:D $declaration is copy, Bool :$attr --> List ) {


#note "\nDeclaration: attr=$attr, ", $declaration;
  if $attr {
    $declaration ~~ m/ ^
      $<type> = [
        [
          \s* 'const' \s* 'gchar' \s* '*' \s* 'const' \s* '*'* \s* ||
          \s* 'const' \s* 'gchar' \s* '*'* \s* ||
          \s* 'gchar' \s* '*'* \s* ||
          \s* 'const' \s* <alnum>+ \s* '*'* \s* ||
          \s* <alnum>+  \s* '*'* \s* ||
          \s* '...'
        ]
      ] <alnum>+ $
    /;
  }

  else {
    $declaration ~~ m/ ^
      $<type> = [
        [
          'const' \s* 'gchar' \s* '*' \s* 'const' \s* '*'* \s* ||
          'const' \s* 'gchar' \s* '*' \s* ||
          'gchar' \s* '*'* \s* ||
          'const' \s* '*' <alnum>+ \s* '*'* \s* ||
          <alnum>+ \s* '*'* \s*
        ]
      ] <alnum>+
    /;
  }

  #[ ['const']? \s* <alnum>+ \s* \*? ]*

  my Str $type = ~($<type> // '');
  $declaration ~~ s/ $type //;

  #drop the const
  $type ~~ s:g/ 'const' //;

  # convert a pointer char type
  if $type ~~ m/ 'gchar' \s* '*' / {
    $type ~~ s/ 'gchar' \s* '*' / Str /;

    # if there is still another pointer, make a CArray
    $type = "CArray[$type]" if $type ~~ m/ '*' /;
    $type ~~ s:g/ \s* //;
  }

  if $declaration ~~ m/ ^ '...' / {
    $type = 'Any';
    $declaration = 'any = Any';
  }

#note "Type: $type";
  # cleanup
  $type ~~ s:g/ ['void' || '*'] //;
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

  # process all types from GtkEnum and some
  $type ~~ s:s/ GtkAlign || GtkArrowType || GtkBaselinePosition ||
                GtkSensitivityType || GtkTextDirection || GtkJustification ||
                GtkMenuDirectionType || GtkMessageType || GtkMovementStep ||
                GtkScrollStep || GtkOrientation || GtkPackType ||
                GtkPositionType || GtkReliefStyle || GtkScrollType ||
                GtkSelectionMode || GtkShadowType || GtkStateType ||
                GtkToolbarStyle || GtkWrapMode || GtkSortType ||
                GtkIMPreeditStyle || GtkIMStatusStyle || GtkPackDirection ||
                GtkPrintPages || GtkPageSet || GtkNumberUpLayout ||
                GtkPageOrientation || GtkPrintQuality || GtkPrintDuplex ||
                GtkUnit || GtkTreeViewGridLines || GtkDragResult ||
                GtkSizeGroupMode || GtkSizeRequestMode || GtkScrollablePolicy ||
                GtkStateFlags || GtkRegionFlags || GtkJunctionSides ||
                GtkBorderStyle || GtkLevelBarMode || GtkInputPurpose ||
                GtkInputHints || GtkPropagationPhase || GtkEventSequenceState ||
                GtkPanDirection || GtkPopoverConstraint ||

                GdkRectangle || GdkModifierType || GdkWindowTypeHint ||

                GtkDeleteType || GtkDirectionType || GtkIconSize || GtkLicense
              /int32/;

  # convert to perl types
  #$p6-type ~~ s/ 'gchar' \s+ '*' /Str/;
  #$p6-type ~~ s/ str /Str/;

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

#note "Result type: $type, p6 type: $p6-type, is class = $type-is-class";

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

  # sometimes the sub name does not start with the base name
  if $sub-name ~~ m/ ^ $base-sub-name / {
    my Str $s = $sub-name;
    $s ~~ s/^ $base-sub-name '_' //;
    if $s ~~ m/ '_' / {
      $pod-sub-name = [~] '[', $base-sub-name, '_] ', $s;
    }
  }

  $pod-sub-name
}

#-------------------------------------------------------------------------------
sub is-n-gobject ( Str:D $type-name is copy --> Bool ) {

  my Bool $is-n-gobject = False;
  $type-name .= lc;

  given $type-name {
    when /^ 'gtk' / {
      $is-n-gobject = $type-name ~~ any(|@gtkdirlist);
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

  $template-text ~~ s:g/ 'BASE-SUBNAME' /$base-sub-name/;
  $template-text ~~ s:g/ 'SUB-DECLARATIONS' /$sub-declarations/;

  $template-text ~~ s:g/ 'MODULE-SHORTDESCRIPTION' /$short-description/;
  $template-text ~~ s:g/ 'MODULE-DESCRIPTION' /$section-doc/;
  $template-text ~~ s:g/ 'MODULE-SEEALSO' /$see-also/;

  $template-text ~~ s:g/ 'SIGNAL-DOC' /$signal-doc/;
  $template-text ~~ s:g/ 'PROPERTY-DOC' /$property-doc/;
  $template-text ~~ s:g/ 'TYPE-DOC' /$type-doc/;

  $template-text
}

#-------------------------------------------------------------------------------
sub get-sub-doc ( Str:D $sub-name, Str:D $source-content --> List ) {


  $source-content ~~ m/ '/**' .*? $sub-name ':' $<sub-doc> = [ .*? '*/' ] /;
  my Str $doc = ~($<sub-doc> // '');

#  $doc = primary-doc-changes($doc);

  my Array $items-src-doc = [];
  my Bool ( $gather-items-doc, $gather-sub-doc, $gather-returns-doc) =
          ( True, False, False);
  my Str ( $item, $sub-doc, $return-src-doc) = ( '', '', '');
  for $doc.lines -> $line {
    #next if $line ~~ m/ '/**' /;
    #next if $line ~~ m/ $sub-name ':' /;

    if $line ~~ m/ ^ \s+ '* @' <alnum>+ ':' $<item-doc> = [ .* ] / {
      # check if there was some item. if so save before set to new item
      if $gather-items-doc {
        $items-src-doc.push(primary-doc-changes($item)) if ?$item;
      }

      else {
        $gather-items-doc = True;
      }

      # new item. remove first space char
      $item = ~($<item-doc> // '');
      $item ~~ s/ ^ \s+ //;
    }

    elsif $line ~~ m/^ \s+ '* Returns:' \s* $<doc> = [.*] $ / {
      $return-src-doc = ~($<doc> // '');

      $gather-items-doc = False;
      $gather-sub-doc = False;
      $gather-returns-doc = True;
    }

    elsif $line ~~ m/ ^ \s+ '*' \s ** 2 \s* $<doc> = [ .* ] / {
      # additional doc for items. separate with a space.
      if $gather-items-doc {
        $item ~= ' ' ~ ~($<doc> // '');
      }

      # additional doc for return info. separate with a space. first char
      # is a space and is used later.
      elsif $gather-returns-doc {
        $return-src-doc ~= ' ' ~ ~($<doc> // '');
      }
    }

    elsif $line ~~ m/ ^ \s+ '*' \s ** 1 $<doc> = [ .* ] / {
      # additional doc for items. separate with a space.
      if $gather-sub-doc {
        $sub-doc ~= ' ' ~ ~($<doc> // '');
      }
    }


    # an empty line is end of items doc, returns foc or sub doc
    elsif $line ~~ m/ ^ \s+ '*' \s* $ / {
      if $gather-items-doc {
        $items-src-doc.push(primary-doc-changes($item));
        $gather-items-doc = False;
        $gather-sub-doc = True;
      }

      elsif $gather-sub-doc {
        $gather-sub-doc = False;
      }

      elsif $gather-returns-doc {
        $gather-returns-doc = False;
      }
    }
  }

  $sub-doc ~~ s/ ^ \s+ //;

  ( primary-doc-changes($sub-doc),
    primary-doc-changes($return-src-doc),
    $items-src-doc
  )
}

#-------------------------------------------------------------------------------
# get the class title and class info from the source file
sub get-section ( Str:D $source-content --> List ) {

  $source-content ~~ m/ '/**' .*? SECTION ':' .*? '*/' /;
  my Str $section-doc = ~$/;

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

  ( primary-doc-changes($section-doc),
    primary-doc-changes($short-description),
    primary-doc-changes($see-also)
  )
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

    # get lib class name and remove line from source
    $sdoc ~~ m/
      ^^ \s+ '*' \s+ $lib-class-name '::' $<signal-name> = [ [<alnum> || '-']+ ]
    /;
    $signal-name = ~($<signal-name> // '');
    $sdoc ~~ s/ ^^ \s+ '*' \s+ $lib-class-name '::' $signal-name ':'? //;

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
      $item-doc = primary-doc-changes($item-doc);

      $items-src-doc.push: %(:$item-name, :$item-doc);
    }

#note "item doc 2: ", $sdoc;

    # cleanup info
    $sdoc = primary-doc-changes($sdoc);
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

  if ?$signal-doc {
    my $sd = $signal-doc;
    $signal-doc = Q:q:to/EOSIGDOC/;
      #-------------------------------------------------------------------------------
      =begin pod
      =head1 Signals

      Register any signal as follows. See also C<Gnome::GObject::Object>.

        my Bool $is-registered = $my-widget.register-signal (
          $handler-object, $handler-name, $signal-name,
          :$user-option1, ..., $user-optionN
        )

      =begin comment

      =head2 Supported signals

      =head2 Unsupported signals

      =end comment

      =head2 Not yet supported signals

      EOSIGDOC

    $signal-doc ~= $sd ~ Q:q:to/EOSIGDOC/;
      =begin comment

      =head4 Signal Handler Signature

        method handler (
          Gnome::GObject::Object :$widget, :$user-option1, ..., $user-optionN
        )

      =head4 Event Handler Signature

        method handler (
          Gnome::GObject::Object :$widget, GdkEvent :$event,
          :$user-option1, ..., $user-optionN
        )

      =head4 Native Object Handler Signature

        method handler (
          Gnome::GObject::Object :$widget, N-GObject :$nativewidget,
          :$user-option1, ..., :$user-optionN
        )

      =end comment


      =begin comment

      =head4 Handler Method Arguments
      =item $widget; This can be any perl6 widget with C<Gnome::GObject::Object> as the top parent class e.g. C<Gnome::Gtk3::Button>.
      =item $event; A structure defined in C<Gnome::Gdk3::EventTypes>.
      =item $nativewidget; A native widget (a C<N-GObject>) which can be turned into a perl6 widget using C<.new(:widget())> on the appropriate class.
      =item $user-option*; Any extra options given by the user when registering the signal.

      =end comment

      =end pod

      EOSIGDOC
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
      $lib-class-name ':' <-[:]> .*? '*/' \s+
      'props[' .*? ');' ]
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
        #-------------------------------------------------------------------------------
        =begin pod
        =head1 Properties

        An example of using a string type property of a C<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

          my Gnome::Gtk3::Label $label .= new(:empty);
          my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
          $label.g-object-get-property( 'label', $gv);
          $gv.g-value-set-string('my text label');

        =begin comment

        =head2 Supported properties

        =head2 Unsupported properties

        =end comment

        =head2 Not yet supported properties

        EODOC
    }
#note "Property sdoc 1:\n", $sdoc;

    $sdoc ~~ m/
      ^^ \s+ '*' \s+ $lib-class-name ':'
      $<prop-name> = [ <-[:]> [<alnum> || '-']+ ]
    /;
    $property-name = ~($<prop-name> // '');
    $property-doc ~= "\n=head3 $property-name\n";
#note "sdoc 2: $sdoc";

    # modify and cleanup
    $sdoc ~~ s/ ^^ \s+ '*' \s+ <alnum>+ ':' [ <alnum> || '-' ]+ ':' \n //;
    $sdoc ~~ m/ ^^ \s+ 'g_param_spec_' $<prop-type> = [ <alnum>+ ] \s* '(' /;
    my Str $prop-type = 'G_TYPE_' ~ ~($<prop-type> // '' ).uc;

    $sdoc = primary-doc-changes($sdoc);
    $sdoc = cleanup-source-doc($sdoc);

#note "sdoc 3: ", $sdoc;

    $property-doc ~=
      "\nThe C<Gnome::GObject::Value> type of property I<$property-name> is C<$prop-type>.\n$sdoc\n";
  }

  $property-doc ~ "=end pod\n"
}

#-------------------------------------------------------------------------------
sub get-vartypes ( Str:D $include-content is copy --> Str ) {

  my Str $types-doc = Q:qq:to/EODOC/;

    #-------------------------------------------------------------------------------
    =begin pod
    =head1 Types
    EODOC


  my Bool $found-doc = False;

  loop {
    my Str $enum-name = '';
    my Str $items-doc = '';
    my Str $enum-doc = '';
    my Str $enum-spec = '';

    $include-content ~~ m:s/
      $<enum-type> = [ '/**' .*? '*/' 'typedef' 'enum' '{' .*? '}' <-[;]>+ ';' ]
    /;
    my Str $enum-type-section = ~($<enum-type> // '');
#note $enum-type-section;

    # if no enums are found, clear the string
    if !?$enum-type-section {
      $types-doc = '' unless $found-doc;
      last;
    }

    # enums found
    $found-doc = True;

    # remove type info for next search
    $include-content ~~ s/ $enum-type-section //;

    my Bool ( $get-item-doc, $get-enum-doc, $process-enum) =
            ( False, False, False);

    for $enum-type-section.lines -> $line {
#note "Line: $line";

      next if $line ~~ m/ '/**' /;

      if $line ~~ m/ ^ \s+ '*' \s+ $<enum-name> = [<alnum>+] ':' \s* $ / {
        $enum-name = ~($<enum-name>//'');
#note "Ename: $enum-name";

        $get-item-doc = True;
      }

      elsif $line ~~ m/ ^ \s+ '* @' $<item> = [ <alnum>+ ':' .* ] $ / {
        $items-doc ~= "\n=item " ~ ~($<item>//'');
#note "Item: $items-doc";
      }

      # on empty line swith from item to enum doc
      elsif $line ~~ m/ ^ \s+ '*' \s* $ / {
        $get-item-doc = False;
        $get-enum-doc = True;
      }

      # end of type documentation
      elsif $line ~~ m/ ^ \s+ '*/' \s* $ / {
        $get-item-doc = False;
        $get-enum-doc = False;
        $process-enum = True;

        $enum-spec = "\n=end pod\n\nenum $enum-name is export (\n";
      }

      elsif $line ~~ m/ ^ \s+ '*' \s* 'Since:' .* $ / {
        # ignore
      }

      elsif $line ~~ m/ ^ \s+ '*' \s+ $<doc> = [ \S .* ] $ / {
        if $get-item-doc {
          $items-doc ~= ' ' ~ ~($<doc>//'');
        }

        elsif $get-enum-doc {
          $enum-doc ~= ' ' ~ ~($<doc>//'');
        }
      }

      elsif $line ~~ m/ ^ \s+ $<item-name> = [<alnum>+ <-[,]>* ','? ] \s* $ / {
        my Str $s = ~($<item-name> // '');
        $s ~~ s/ '=' /=>/;
        $s ~~ s/ '<<' /+</;
        $s ~~ s/ ( <alnum>+ ) /'$/[0]'/;
        $enum-spec ~= "  $s\n";
      }

      elsif $line ~~ m:s/ '}' $enum-name ';' / {
        $enum-spec ~= ");\n";
      }
    }

    # remove first space
    $enum-doc ~~ s/ ^ \s+ //;

    $types-doc ~= Q:qq:to/EODOC/;

      =head2 enum $enum-name

      $enum-doc

      $items-doc

      $enum-spec
      EODOC
  }

  $types-doc
}

#-------------------------------------------------------------------------------
sub cleanup-source-doc ( Str:D $text is copy --> Str ) {

  # remove property and signal line
  $text ~~ s/ ^^ \s+ '*' \s+ $lib-class-name ':' .*? \n //;
  $text ~~ s/ ^^ \s+ '*' \s+ $lib-class-name '::' .*? \n //;

  $text ~~ s/ ^^ '/**' .*? \n //;                   # Doc start
  $text ~~ s/ ^^ \s+ '*/' .* $ //;                  # Doc end
  $text ~~ s/ ^^ \s+ '*' \s+ Since: .*? \n //;      # Since: version
  $text ~~ s/ ^^ \s+ '*' \s+ Deprecated: .*? \n //; # Deprecated: version
  $text ~~ s:g/ ^^ \s+ '*' ' '? (.*?) $$ /$/[0]/;   # Leading star
  $text ~~ s:g/ ^^ \s+ '*' \s* \n //;               # Leading star on Empty line
  #$text ~~ s:g/ ^^ \s* \n //;

  $text ~ "\n"
}

#-------------------------------------------------------------------------------
sub primary-doc-changes (
  Str:D $text is copy,
  Bool :$skip-class-subst = False
  --> Str
) {

  $text = podding-class($text) unless $skip-class-subst;
  $text = podding-property($text);
  $text = modify-at-vars($text);
  $text = modify-percent-vars($text);
  $text = podding-function($text);
}

#-------------------------------------------------------------------------------
# change any #GtkClass to C<Gnome::Gtk::Class> and Gdk likewise
sub podding-class ( Str:D $text is copy --> Str ) {

  loop {
    # check for property spec in doc
    $text ~~ m/ '#' (<alnum>+) ':' (<alnum>+) /;
    my Str $oct = ~($/[1] // '');
    last unless ?$oct;

    $text ~~ s/ '#' (<alnum>+) ':' (<alnum>+) /C\<$oct\>/;
  }

  loop {
    # check for class specs
    $text ~~ m/ '#' (<alnum>+) /;
    my Str $oct = ~($/[0] // '');
    last unless ?$oct;

    $oct ~~ s/^ ('Gtk' || 'Gdk') (<alnum>+) /Gnome::$/[0]3::$/[1]/;
    $text ~~ s/ '#' (<alnum>+) /C\<$oct\>/;
  }

  # convert a few without leading octagon (#)
  $text ~~ s:g/ <!after '%' > ('Gtk' || 'Gdk') (\D <alnum>+)
              /C<Gnome::$/[0]3::$/[1]>/;

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

  # change any function() to C<function()>. first change to [[function]] to
  # prevent nested substitutions.
  $text ~~ s:g/ ([<alnum> || '_']+) '()' /\[\[$/[0]\]\]/;
  $text ~~ s:g/ '[[' ([<alnum> || '_']+ )']]' /C<$/[0]\()>/;

  $text
}

#-------------------------------------------------------------------------------
# change any function() C<function()>
sub modify-percent-vars ( Str:D $text is copy --> Str ) {
  $text ~~ s:g/ '%TRUE' /C<1>/;
  $text ~~ s:g/ '%FALSE' /C<0>/;
  $text ~~ s:g/ '%NULL' /C<Any>/;
  $text ~~ s:g/ '%' ([<alnum> || '_' ]+) /C<$/[0]>/;

  $text
}

#-------------------------------------------------------------------------------
# change any function() C<function()>
sub modify-at-vars ( Str:D $text is copy --> Str ) {
  $text ~~ s:g/ '@' (<alnum>+) /I<$/[0]>/;

  $text
}
