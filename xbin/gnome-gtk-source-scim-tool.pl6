#!/usr/bin/env perl6

use v6;

#-------------------------------------------------------------------------------
my Str $library = '';

my Str $include-filename;
my Str $lib-class-name;

my Str $base-sub-name;
my Str $p6-lib-name;
my Str $p6-class-name;
my Str $p6-parentlib-name;
my Str $p6-parentclass-name;

my Str $output-file;

my Str ( $section-doc, $short-description, $see-also);

my @gtkdirlist = ();
my @gdkdirlist = ();
my @gobjectdirlist = ();
my @glibdirlist = ();
my @giodirlist = ();

my @enum-list = ();

#-------------------------------------------------------------------------------
sub MAIN (
  Str:D $base-name, Bool :$sig = False, Bool :$prop = False,
  Bool :$sub = False, Bool :$dep = False
) {

  my Bool $do-all = !( [or] $sig, $prop, $sub, $dep);

  load-dir-lists();

  my Bool $file-found;
  my Str ( $include-content, $source-content);
  $base-sub-name = $base-name;
  ( $file-found, $include-filename, $lib-class-name, $p6-class-name,
    $p6-lib-name, $include-content, $source-content
  ) = setup-names($base-name);

  if $file-found {
    # test for dir 'xt'
    mkdir( 'xt', 0o766) unless 'xt'.IO.e;

    ( $p6-parentclass-name, $p6-parentlib-name) =
       parent-class($include-content);

    ( $section-doc, $short-description, $see-also) =
      get-section($source-content);

    substitute-in-template($include-content);

    get-subroutines( $include-content, $source-content) if $do-all or $sub;
    get-deprecated-subs($include-content) if $do-all or $dep;
    get-signals($source-content) if $do-all or $sig;
    get-properties($source-content) if $do-all or $prop;

    # create var name named after classname. E.g. TextBuffer -> $tb.
    my Str $m = '$' ~ $p6-class-name.comb(/<[A..Z]>/).join.lc;
    my Str $class = [~] 'Gnome::', $p6-lib-name, '::', $p6-class-name;
    my Str $test-content = Q:s:to/EOTEST/;
      use v6;
      use NativeCall;
      use Test;

      use $class;

      #use Gnome::N::X;
      #Gnome::N::debug(:on);

      #-------------------------------------------------------------------------------
      my $class $m .= new(:empty);
      #-------------------------------------------------------------------------------
      subtest 'ISA test', {
        isa-ok $m, $class;
      }

      #-------------------------------------------------------------------------------
      subtest 'Manipulations', {
        is 1, 1, 'ok';
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
sub get-subroutines( Str:D $include-content, Str:D $source-content ) {

  my Str $sub-doc = '';
  my Array $items-src-doc = [];
  my Bool $variable-args-list;

#note "IC: $include-content";
  # get all subroutines starting with 'GDK_AVAILABLE_IN_ALL' or
  # 'GDK_AVAILABLE_IN_\d_\d' version spec. subroutines starting with
  # 'GDK_DEPRECATED_IN_' are ignored.
  $include-content ~~ m:g/^^ ['GDK' || 'GTK' || 'GLIB']
                             '_AVAILABLE_IN_' <-[;]>+ ';'
                         /;
  my List $results = $/[*];

  # process subroutines
  for @$results -> $r {
    $variable-args-list = False;
#note "\n $r";

    my Str $declaration = ~$r;

#next unless $declaration ~~ m:s/ const gchar \* /;
    # skip constants and subs with variable argument lists
    next if $declaration ~~ m/ 'G_GNUC_CONST' /;
    $variable-args-list = True if $declaration ~~ m/ 'G_GNUC_NULL_TERMINATED' /;

    # remove some macros
    $declaration ~~ s/ \s* 'G_GNUC_WARN_UNUSED_RESULT' \s* //;

    # remove prefix and tidy up a bit
    $declaration ~~ s/^ ['GDK' || 'GTK' || 'GLIB'] '_AVAILABLE_IN_' .*?  \n //;
#    $declaration ~~ s:g/ \s* \n \s* / /;
    $declaration ~~ s:g/ \s+ / /;
#note "\n0 >> $declaration";

    my Str ( $return-type, $p6-return-type) = ( '', '');
    my Bool $type-is-class;

    # convert and remove return type from declaration
    ( $declaration, $return-type, $p6-return-type, $type-is-class) =
      get-type( $declaration, :!attr);

    # get the subroutine name and remove from declaration
    $declaration ~~ m/ $<sub-name> = [ <alnum>+ ] \s* /;
    my Str $sub-name = ~$<sub-name>;
    note "get sub $sub-name";
    $declaration ~~ s/ $sub-name \s* //;

    # remove any brackets, and other stuff left before arguments are processed
    $declaration ~~ s:g/ <[();]> || 'void' || 'G_GNUC_NULL_TERMINATED' //;

    # get subroutine documentation from c source
    ( $sub-doc, $items-src-doc) = get-sub-doc( $sub-name, $source-content);

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
          $pod-doc-items ~= "=item $p6-arg-type \$$arg; {$pod-doc-item-doc//''}\n";
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
    }

    my Str $start-comment = $variable-args-list ?? "#`[[\n" !! '';
    my Str $end-comment = $variable-args-list ?? "\n]]" !! '';

    my $pod-sub-name = pod-sub-name($sub-name);
    my Str $sub = Q:qq:to/EOSUB/;

      $start-comment#-------------------------------------------------------------------------------
      #TM:0:$sub-name:

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

    $output-file.IO.spurt( $sub, :append);
  }

  $output-file.IO.spurt( Q:qq:to/EONYI/, :append);

    #-------------------------------------------------------------------------------
    =begin pod
    =begin comment

    =head1 Not yet implemented methods

    =head3 method  ( ... )

    =end comment
    =end pod

    #-------------------------------------------------------------------------------
    =begin pod
    =begin comment

    =head1 Not implemented methods

    =head3 method  ( ... )

    =end comment
    =end pod

    EONYI
}

#-------------------------------------------------------------------------------
sub get-deprecated-subs( Str:D $include-content ) {

  my Hash $dep-versions = {};
  my Str $sub-doc = '';
  my Array $items-src-doc = [];
  my Bool $variable-args-list;

  $include-content ~~ m:g/^^ 'GDK_DEPRECATED_IN_' <-[;]>+ ';'/;
  my List $results = $/[*];

  # process subroutines
  for @$results -> $r {
    my Str $declaration = ~$r;

    $declaration ~~ m/ 'GDK_DEPRECATED_IN_'
                       $<version> = [ <[\d_]>+ ]
                     /;
    my Str $version = ~($<version> // '');
    $version ~~ s:g/ '_' /./;
#note "0 >> $declaration";

    $declaration ~~ s/ 'GDK_DEPRECATED_IN_' .*? \n //;

    my Str ( $return-type, $p6-return-type) = ( '', '');
    my Bool $type-is-class;

    # convert and remove return type from declaration
    #( $declaration, #`{{ rest is ignored }} ) = get-type( $declaration, :!attr);
    ( $declaration, $return-type, $p6-return-type, $type-is-class) =
      get-type( $declaration, :!attr);

#note "1 >> $declaration";
    # get the subroutine name and remove from declaration
    $declaration ~~ m/ $<sub-name> = [ <alnum>+ ] \s* /;
    my Str $sub-name = ~$<sub-name>;
    $declaration ~~ s/ $sub-name \s* //;
    note "get deprecated sub $sub-name version $version";

    # remove any brackets, and other stuff left before arguments are processed
    $declaration ~~ s:g/ <[();]> || 'void' || 'G_GNUC_NULL_TERMINATED' //;

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
          $pod-doc-items ~= "=item $p6-arg-type \$$arg; {$pod-doc-item-doc//''}\n";
        }

        # add argument to list for sub declaration
        $args ~= ', ' if ?$args;
        $args ~= "$arg-type \$$arg";
      }

      $first-arg = False;
    }

    my Str $pod-doc-return = '';
    my Str $pod-returns = '';
    my Str $returns = '';
    if ?$return-type {
      $pod-returns = " --> $p6-return-type ";
      $returns = "\n  returns $return-type";
    }

    $dep-versions{$version} = [] unless $dep-versions{$version}:exists;
    $dep-versions{$version}.push: "method $sub-name ($pod-args$pod-returns )";
  }


  my Str $deprecated-subs = '';
  if ?$dep-versions {
    $deprecated-subs = Q:to/EODEPSUB/;
      #-------------------------------------------------------------------------------
      =begin pod
      =head1 List of deprecated (not implemented!) methods
      EODEPSUB

    for $dep-versions.keys.sort -> $version {
      $deprecated-subs ~= "\n=head2 Since $version\n";
      for @($dep-versions{$version}) -> $sub is copy {
        $sub ~~ s/ '(' <-[)]> * ')' /( ... )/;
        $deprecated-subs ~= "=head3 $sub\n";
      }
    }

    $deprecated-subs ~= "=end pod\n\n";
  }

  $output-file.IO.spurt( $deprecated-subs, :append);
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

#note "\nDeclaration: ", $declaration if $declaration ~~ m/ gtk_widget_path_iter_get_siblings /;

  # process types from arg lists
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

  # process types from sub return
  else {
    $declaration ~~ m/ ^
      $<type> = [
        [
          'const' \s* 'gchar' \s* '*' \s* 'const' \s* '*'* \s* ||
          'const' \s* 'gchar' \s* '*' \s* ||
          'gchar' \s* '*'* \s* ||
          'const' \s* '*' <alnum>+ \s* '*'* \s* ||
          'const' \s* <alnum>+ \s* '*'* \s* ||
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
note "Type: $type";
  $type = 'N-GError' if $type ~~ m/GError/;
  $type = 'N-GList' if $type ~~ m/GList/;
  $type = 'N-GSList' if $type ~~ m/GSList/;
  $type = 'N-GObject' if is-n-gobject($type);
  $type = 'int32' if $type ~~ m/GType/;
  $type = 'int32' if $type ~~ m/GQuark/;

  # copy to perl6 type for independent convertions
  my Str $p6-type = $type;

  # convert to native perl types
  #$type ~~ s/ 'gchar' \s+ '*' /str/;

  # process all types from GtkEnum and some
  # use bin/gather-enums.pl6 to create a list in
  # doc/Design-docs/scim-tool-enum-list.txt
  if $type ~~ any(@enum-list) {
    $type = 'int32';
  }

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

  $type ~~ s:s/ int /int32/;
  $type ~~ s:s/ gpointer /Pointer/;


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

  $p6-type ~~ s:s/ int /int32/;
  $p6-type ~~ s:s/ gpointer /Pointer/;

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
  my Str $gio-path = '/usr/include/glib-2.0/gio';

  # c-source file text paths, downloaded latest version. the version does not
  # matter much, just searching for documentation.
  my Str $gtk-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/gtk+-3.22.0/gtk';
  my Str $gdk-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/gtk+-3.22.0/gdk';
  my Str $glib-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/glib-2.60.0/glib';
  my Str $gobject-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/glib-2.60.0/gobject';
  my Str $gio-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/glib-2.60.0/gio';

  my Str ( $include-content, $source-content) = ( '', '');
  my Bool $file-found = False;
  for $gtk-path, $gdk-path, $glib-path, $gobject-path, $gio-path -> $path {
#note $path;
    if "$path/$include-file.h".IO.r {
      $file-found = True;
      $include-content = "$path/$include-file.h".IO.slurp;

      given $path {
        when $gtk-path {
          if "$gtk-srcpath/$include-file.c".IO.r {
            $source-content = "$gtk-srcpath/$include-file.c".IO.slurp;
            $library = "&gtk-lib";
            $p6-lib-name = 'Gtk3';
          }
        }

        when $gdk-path {
          if "$gdk-srcpath/$include-file.c".IO.r {
            $source-content = "$gdk-srcpath/$include-file.c".IO.slurp;
            $library = "&gdk-lib";
            $p6-lib-name = 'Gdk3';
          }
        }

        when $glib-path {
          if "$glib-srcpath/$include-file.c".IO.r {
            $source-content = "$glib-srcpath/$include-file.c".IO.slurp;
            $library = "&glib-lib";
            $p6-lib-name = 'Glib';
          }
        }

        when $gobject-path {
          if "$gobject-srcpath/$include-file.c".IO.r {
            $source-content = "$gobject-srcpath/$include-file.c".IO.slurp;
            $library = "&gobject-lib";
            $p6-lib-name = 'GObject';
          }
        }

        when $gio-path {
          if "$gio-srcpath/$include-file.c".IO.r {
            $source-content = "$gio-srcpath/$include-file.c".IO.slurp;
            $library = "&glib-lib";
            $p6-lib-name = 'Glib';
          }
        }
      }

#note "$library, $p6-lib-name";
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
      $is-n-gobject = $type-name ~~ any(|@giodirlist) unless $is-n-gobject;
    }
  }

  $is-n-gobject
}

#-------------------------------------------------------------------------------
sub load-dir-lists ( ) {

  @gtkdirlist = "Design-docs/gtk3-list.txt".IO.slurp.lines;
  @gdkdirlist = "Design-docs/gdk3-list.txt".IO.slurp.lines;
  @gobjectdirlist = "Design-docs/gobject-list.txt".IO.slurp.lines;
  @glibdirlist = "Design-docs/glib-list.txt".IO.slurp.lines;
  @giodirlist = "Design-docs/gio-list.txt".IO.slurp.lines;

  @enum-list = 'Design-docs/scim-tool-enum-list'.IO.slurp.lines;
}

#-------------------------------------------------------------------------------
sub substitute-in-template ( Str $include-content ) {

  my Str $template-text = Q:q:to/EOTEMPLATE/;
    #TL:0:Gnome::LIBRARYMODULE:

    use v6;
    #-------------------------------------------------------------------------------
    =begin pod

    =TITLE Gnome::LIBRARYMODULE

    =SUBTITLE MODULE-SHORTDESCRIPTION

    =head1 Description

    MODULE-DESCRIPTION

    =head2 See Also

    MODULE-SEEALSO

    =head1 Synopsis
    =head2 Declaration

      unit class Gnome::LIBRARYMODULE;
      ALSO-IS-LIBRARY-PARENT

    =head2 Example

    =end pod
    #-------------------------------------------------------------------------------
    use NativeCall;

    use Gnome::N::X;
    use Gnome::N::NativeLib;
    use Gnome::N::N-GObject;
    USE-LIBRARY-PARENT

    #-------------------------------------------------------------------------------
    # /usr/include/gtk-3.0/gtk/INCLUDE
    # https://developer.gnome.org/WWW
    unit class Gnome::LIBRARYMODULE:auth<github:MARTIMM>;
    ALSO-IS-LIBRARY-PARENT

    EOTEMPLATE

  my Str ( $t1, $t2) = ( '', '');
  if $p6-parentlib-name and $p6-parentclass-name {
    $t1 = "use Gnome::{$p6-parentlib-name}::{$p6-parentclass-name};";
    $t2 = "also is Gnome::{$p6-parentlib-name}::{$p6-parentclass-name};";
  }

  $template-text ~~ s:g/ 'LIBRARYMODULE' /{$p6-lib-name}::{$p6-class-name}/;
  $template-text ~~ s:g/ 'USE-LIBRARY-PARENT' /$t1/;
  $template-text ~~ s:g/ 'ALSO-IS-LIBRARY-PARENT' /$t2/;

  $template-text ~~ s:g/ 'MODULE-SHORTDESCRIPTION' /$short-description/;
  $template-text ~~ s:g/ 'MODULE-DESCRIPTION' /$section-doc/;
  $template-text ~~ s:g/ 'MODULE-SEEALSO' /$see-also/;

  $output-file = "xt/$p6-class-name.pm6";
  $output-file.IO.spurt($template-text);

  get-vartypes($include-content);


  $template-text = Q:q:to/EOTEMPLATE/;
    #-------------------------------------------------------------------------------
    my Bool $signals-added = False;
    #-------------------------------------------------------------------------------
    =begin pod
    =head1 Methods
    =head2 new
    =head3 multi method new ( Bool :$empty! )

    Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

    =head3 multi method new ( N-GObject :$widget! )

    Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

    =head3 multi method new ( Str :$build-id! )

    Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.

    =end pod

    #TM:0:new(:empty):
    #TM:0:new(:widget):
    #TM:0:new(:build-id):

    submethod BUILD ( *%options ) {

      # add signal info in the form of group<signal-name>.
      # groups are e.g. signal, event, nativeobject etc
      $signals-added = self.add-signal-types( $?CLASS.^name,
        # ... :type<signame>
      ) unless $signals-added;

      # prevent creating wrong widgets
      return unless self.^name eq 'Gnome::LIBRARYMODULE';

      # process all named arguments
      if ? %options<empty> {
        # self.native-gobject(BASE-SUBNAME_new());
      }

      elsif ? %options<widget> || %options<build-id> {
        # provided in Gnome::GObject::Object
      }

      elsif %options.keys.elems {
        die X::Gnome.new(
          :message('Unsupported options for ' ~ self.^name ~
                   ': ' ~ %options.keys.join(', ')
                  )
        );
      }

      # only after creating the widget, the gtype is known
      self.set-class-info('LIBCLASSNAME');
    }

    #-------------------------------------------------------------------------------
    # no pod. user does not have to know about it.
    method fallback ( $native-sub is copy --> Callable ) {

      my Callable $s;
      try { $s = &::($native-sub); }
      try { $s = &::("BASE-SUBNAME_$native-sub"); } unless ?$s;

      self.set-class-name-of-sub('LIBCLASSNAME');
      $s = callsame unless ?$s;

      $s;
    }

    EOTEMPLATE

  $template-text ~~ s:g/ 'LIBRARYMODULE' /{$p6-lib-name}::{$p6-class-name}/;
  $template-text ~~ s:g/ 'BASE-SUBNAME' /$base-sub-name/;
  $template-text ~~ s:g/ 'LIBCLASSNAME' /$lib-class-name/;
  $output-file.IO.spurt( $template-text, :append);
}

#-------------------------------------------------------------------------------
sub get-sub-doc ( Str:D $sub-name, Str:D $source-content --> List ) {

  $source-content ~~ m/ '/**' .*? $sub-name ':' $<sub-doc> = [ .*? '*/' ] /;
  my Str $doc = ~($<sub-doc> // '');

  my Array $items-src-doc = [];
  my Bool $gather-items-doc = True;
  my Str ( $item, $sub-doc) = ( '', '');
  for $doc.lines -> $line {

    if $line ~~ m/ ^ \s+ '* @' <alnum>+ ':' $<item-doc> = [ .* ] / {
      # check if there was some item. if so save before set to new item
      # @ can be in documentation too!
      if $gather-items-doc {
        $items-src-doc.push(primary-doc-changes($item)) if ?$item;
      }

      # new item. remove first space char
      $item = ~($<item-doc> // '');
      $item ~~ s/ ^ \s+ //;
    }

    elsif $line ~~ m/ ^ \s+ '*' \s+ $<doc> = [ .+ ] / {
      # additional doc for items. separate with a space.
      if $gather-items-doc {
        $item ~= " " ~ ~($<doc> // '');
      }

      else {
        $sub-doc ~= "\n" ~ ~($<doc> // '');
      }
    }


    # an empty line is end of items doc and starts/continues sub doc
    elsif $line ~~ m/ ^ \s+ '*' \s* $ / {
      if $gather-items-doc {
        # save previous item
        $items-src-doc.push(primary-doc-changes($item));

        $gather-items-doc = False;
        $sub-doc ~= "\n";
      }

      else {
        $sub-doc ~= "\n";
      }
    }
  }

  # in case there is no doc, we need to save the last item still
  $items-src-doc.push(primary-doc-changes($item)) if $gather-items-doc;

  $sub-doc ~~ s/ ^ \s+ //;

  ( primary-doc-changes($sub-doc), $items-src-doc )
}

#-------------------------------------------------------------------------------
# get the class title and class info from the source file
sub get-section ( Str:D $source-content --> List ) {

  $source-content ~~ m/ '/**' .*? SECTION ':' .*? '*/' /;
  return ( '', '', '') unless ?$/;

  my Str $section-doc = ~$/;

  $section-doc ~~ m:i/
      ^^ \s+ '*' \s+ '@Short_description:' \s* $<text> = [.*?] $$
  /;
  my Str $short-description = ~($<text>//'');
  $section-doc ~~ s:i/ ^^ \s+ '*' \s+ '@Short_description:' [.*?] \n //;

  $section-doc ~~ m:i/ ^^ \s+ '*' \s+ '@See_also:' \s* $<text> = [.*?] $$ /;
  my Str $see-also = ~($<text>//'');
  $section-doc ~~ s:i/ ^^ \s+ '*' \s+ '@See_also:' [.*?] \n //;

  # cleanup rest
  $section-doc ~~ s:i/ ^^ \s+ '*' \s+ 'SECTION:' [.*?] \n //;
  $section-doc ~~ s:i/ ^^ \s+ '*' \s+ '@Title:' [.*?] \n //;
  $section-doc = cleanup-source-doc($section-doc);
  $section-doc ~~ s:g:i/ ^^ '#' \s+ 'CSS' \s+ 'nodes'/\n=head2 Css Nodes\n/;
#note "doc 2: ", $section-doc;

  ( primary-doc-changes($section-doc),
    primary-doc-changes($short-description),
    primary-doc-changes($see-also)
  )
}

#-------------------------------------------------------------------------------
sub get-signals ( Str:D $source-content is copy ) {

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
#note "SDoc: $sdoc";

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

    $signal-doc ~= "\n=comment #TS:0:$signal-name:\n=head3 $signal-name\n";
    note "get signal $signal-name";

#    ( $sdoc, $items-src-doc) = get-podding-items($sdoc);
#`{{}}
    # get arguments for this signal handler
    my Str ( $item-doc, $item-name, $spart-doc) = ( '', '', '');
    my Bool $item-scan = True;
    #my Bool $first-arg = True;

#    my Str $doc-info = $sdoc;
#    for $doc-info.lines -> $line {
    for $sdoc.lines -> $line {
#note "L: $line";

      # argument doc start
      if $item-scan and $line ~~ m/^ \s* '*' \s+ '@' / {

        # push when 2nd arg is found
        $items-src-doc.push: %( :$item-name, :$item-doc) if ?$item-name;

        $line ~~ m/ '*' \s+ '@' $<item-name> = [<alnum>+] ':'
                    \s* $<item-doc> = [ .* ]
                  /;

        $item-name = ~($<item-name> // '');
        $item-doc = primary-doc-changes(~($<item-doc> // '')) ~ "\n";
#note "n, d: $item-name, $item-doc";

#        $sdoc ~~ s/^^ \s* '*' \s* '@' $item-name ':' \s* $item-doc $$//;
      }

      # continue previous argument doc
      elsif $item-scan and
            $line ~~ m/^ \s* '*' \s ** 2..* $<item-doc> = [ .* ] / {
        my Str $s = ~($<item-doc> // '');
        $item-doc ~= primary-doc-changes($s) ~ "\n";
#note "d: $item-doc";
#        $sdoc ~~ s/^^ '*' \s* $s $$//;
      }

      # on empty line after '*' start sub doc
      elsif $line ~~ m/^ \s* '*' \s* $/ {
        # push last arg
        $items-src-doc.push: %( :$item-name, :$item-doc)
          if $item-scan and ?$item-name;

        $spart-doc ~= "\n";
#        $sdoc ~~ s/$line \n//;
        $item-scan = False;
      }

      # rest is sub doc
      elsif !$item-scan {
        # skip end of document
        next if $line ~~ m/ '*/' /;

        my Str $l = $line;
        $l ~~ s/^ \s* '*' \s* //;
        $spart-doc ~= $l ~ "\n";
#        $sdoc ~~ s/$line \n//;
      }
    }

    # when there is no sub doc, it might end a bit abdrupt
    $items-src-doc.push: %( :$item-name, :$item-doc)
      if $item-scan and ?$item-name;

    $signal-doc ~= primary-doc-changes($spart-doc);


#`[[
    loop {
      $sdoc ~~ m/
        ^^ \s+ '*' \s+ '@'
        $<item-name> = [<alnum>+] ':'
        \s* $<item-doc> = [ <-[\n]>+ \n [ \s+ '*' \s ** 4..* <-[\n]>+ \n ]* ]
      /;

      my Str $item-name = ~($<item-name> // '');
      my Str $item-doc = ~($<item-doc> // '');
      $sdoc ~~ s/ ^^ \s+ '*' \s+ '@' $item-name ':' \s* $item-doc //;
note "item doc: ", $item-doc;
#note "sdoc: ", $sdoc;

      last unless ?$item-name;
      $sdoc ~~ s/ '*' \s+ '@' $item-name ':' $item-doc \n //;

#`{{
      $item-doc ~~ m/ '#' (<alnum>+) /;
      my Str $oct = ~($/[0] // '');
      $oct ~~ s/^ ('Gtk' || 'Gdk') (<alnum>+) /Gnome::$/[0]3::$/[1]/;
      $item-doc ~~ s/ '#' (<alnum>+) /C\<$oct>/;
}}
#note "item doc 1: ", $item-doc;
      $item-doc = primary-doc-changes($item-doc);
      $item-doc ~~ s:g/ ^^ \s+ '*' \s* //;
      $item-doc ~~ s:g/ \n / /;

      $items-src-doc.push: %(:$item-name, :$item-doc);
    }
]]







#note "item doc 2: ", $sdoc;

    # cleanup info
#    $sdoc = primary-doc-changes($sdoc);
#    $sdoc = cleanup-source-doc($sdoc);


    $signal-doc ~= "\n  method handler (\n";

    my Int $count = 0;
    for @$items-src-doc -> $idoc {
      if $count == 0 {
        $signal-doc ~= "    Gnome::GObject::Object " ~
                       "\:widget\(\$$idoc<item-name>\),\n";
      }

      else {
        $signal-doc ~= "    \:handler-arg{$count - 1}\(\$$idoc<item-name>\),\n";
      }

      $count++;
    }

    $signal-doc ~= "    \:\$user-option1, ..., :\$user-optionN\n  );\n\n";

    for @$items-src-doc -> $idoc {
      $signal-doc ~= "=item \$$idoc<item-name>; $idoc<item-doc>\n";
    }
  }

  if ?$signal-doc {

    $signal-doc = Q:q:to/EOSIGDOC/ ~ $signal-doc ~ "\n=end pod\n\n";
      #-------------------------------------------------------------------------------
      =begin pod
      =head1 Signals

      Register any signal as follows. See also C<Gnome::GObject::Object>.

        my Bool $is-registered = $my-widget.register-signal (
          $handler-object, $handler-name, $signal-name,
          :$user-option1, ..., :$user-optionN
        )

      =begin comment
      =head2 Supported signals
      =head2 Unsupported signals
      =end comment

      =head2 Not yet supported signals

      EOSIGDOC

  }

  $output-file.IO.spurt( $signal-doc, :append);
}

#-------------------------------------------------------------------------------
sub get-properties ( Str:D $source-content is copy ) {

  my Str $property-name;
  my Str $property-doc = '';

  loop {
    $property-name = '';

    $source-content ~~ m/
      $<property-doc> = [ '/**' \s+ '*' \s+
      $lib-class-name ':' <-[:]> .*? '*/' \s+
      .*? 'g_param_spec_' .*? ');' ]
    /;
    my Str $sdoc = ~($<property-doc> // '');

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
    $property-doc ~= "\n=comment #TP:0:$property-name:\n=head3 $property-name\n";
#note "sdoc 2: $sdoc";
    note "get property $property-name";

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

  $property-doc ~= "=end pod\n" if ?$property-doc;

  $output-file.IO.spurt( $property-doc, :append);
}

#-------------------------------------------------------------------------------
sub get-vartypes ( Str:D $include-content ) {

#  my Str $enums-doc = get-enumerations($include-content);
#  my Str $structs-doc = get-structures($include-content);

  get-enumerations($include-content);
  get-structures($include-content);
}

#-------------------------------------------------------------------------------
sub get-enumerations ( Str:D $include-content is copy ) {

  my Str $enums-doc = Q:qq:to/EODOC/;

    #-------------------------------------------------------------------------------
    =begin pod
    =head1 Types
    =end pod
    EODOC


  my Bool $found-doc = False;

  loop {
    my Str $enum-name = '';
    my Str $items-doc = '';
    my Str $enum-doc = '';
    my Str $enum-spec = '';

    $include-content ~~ m:s/
      $<enum-type-section> = [
         '/**' .*? '*/' 'typedef' 'enum' '{' .*? '}' <-[;]>+ ';'
      ]
    /;
    my Str $enum-type-section = ~($<enum-type-section> // '');
#note $enum-type-section;

    # if no enums are found, clear the string
    if !?$enum-type-section {
      $enums-doc = '' unless $found-doc;
      last;
    }

    # this match "m:g/'/**' .*? '*/' ...etc... /" can fail. It can gather
    # too many comment blocks to stop at a final enum. So try to find the
    # last doc section.
    my Int $start-doc = 1;  # There is a '/**' string at 0!
    my Int $x;
    while ?($x = $enum-type-section.index( '/**', $start-doc)) {
      $start-doc = $x + 1;
    }

    $start-doc -= 1;
    $enum-type-section = $enum-type-section.substr(
      $start-doc, $enum-type-section.chars - $start-doc
    );

    # remove type info for next search
    $include-content ~~ s/ $enum-type-section //;

    # enums found
    $found-doc = True;

    my Bool ( $get-item-doc, $get-enum-doc, $process-enum) =
            ( False, False, False);

    for $enum-type-section.lines -> $line {
#note "Line: $line";

      next if $line ~~ m/ '/**' /;

      if $line ~~ m/ ^ \s+ '*' \s+ $<enum-name> = [<alnum>+] ':' \s* $ / {
        $enum-name = ~($<enum-name>//'');
        note "get enumeration $enum-name";
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

        $enum-doc ~= "\n";
      }

      # end of type documentation
      elsif $line ~~ m/ ^ \s+ '*'*? '*/' \s* $ / {
        $get-item-doc = False;
        $get-enum-doc = False;
        $process-enum = True;

        $enum-spec = "\n=end pod\n\n#TE:0:$enum-name:\nenum $enum-name is export (\n";
      }

#      elsif $line ~~ m/ ^ \s+ '*' \s* 'Since:' .* $ / {
#        # ignore
#      }

      elsif $line ~~ m/ ^ \s+ '*' \s+ $<doc> = [ \S .* ] $ / {
        if $get-item-doc {
          $items-doc ~= " " ~ ~($<doc>//'');
        }

        elsif $get-enum-doc {
          $enum-doc ~= "\n" ~ ~($<doc>//'');
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

    $enum-doc = primary-doc-changes($enum-doc);
    $items-doc = primary-doc-changes($items-doc);

    $enums-doc ~= Q:qq:to/EODOC/;
      #-------------------------------------------------------------------------------
      =begin pod
      =head2 enum $enum-name

      $enum-doc

      $items-doc

      $enum-spec
      EODOC
  }

  $output-file.IO.spurt( $enums-doc, :append);
}

#-------------------------------------------------------------------------------
sub get-structures ( Str:D $include-content is copy ) {

  my Str $structs-doc = '';
  my Bool $found-doc = False;

  # now we try again to get structs
  loop {
    my Str $struct-name = '';
    my Str $items-doc = '';
    my Str $struct-doc = '';
    my Str $struct-spec = '';
    my Str ( $entry-type, $p6-entry-type);
    my Bool $type-is-class;

    $include-content ~~ m:s/
      $<struct-type-section> = [
          '/**' .*? '*/' struct <-[{]>+ '{' <-[}]>+ '};'
      ]
    /;

    my Str $struct-type-section = ~($<struct-type-section> // '');
#note $struct-type-section;

    # if no structs are found, clear the string
    if !?$struct-type-section {
      $structs-doc = '' unless $found-doc;
      last;
    }

    # this match "m:g/'/**' .*? '*/' ...etc... /" can fail. It can gather
    # too many comment blocks to stop at a final struct. So try to find the
    # last doc section.
    my Int $start-doc = 1;  # There is a '/**' string at 0!
    my Int $x;
    while ?($x = $struct-type-section.index( '/**', $start-doc)) {
      $start-doc = $x + 1;
    }

    $start-doc -= 1;
    $struct-type-section = $struct-type-section.substr(
      $start-doc, $struct-type-section.chars - $start-doc
    );
#note $struct-type-section;


    # remove struct info for next search
    $include-content ~~ s/$struct-type-section//;

    # structs found
    $found-doc = True;
    my Bool $struct-skip = False;

    my Bool ( $get-item-doc, $get-struct-doc, $process-struct) =
            ( False, False, False);

    for $struct-type-section.lines -> $line {
      next if $line ~~ m/ '/**' /;

      if $line ~~ m/^ \s+ '*' \s+ $<struct-name> = [<alnum>+] ':' \s* $/ {
        $struct-name = ~($<struct-name> // '');

        # skip this structure if it is about this classes structure
        if $struct-name ~~ m/ \w+ Class $/ {
          $struct-skip = True;
          last;
        }
        note "get structure $struct-name";
        $get-item-doc = True;
      }

      elsif $line ~~ m/^ \s+ '*' \s+ '@' $<item> = [ <alnum>+ ':' .* ] $ / {
        # Add extra characters to insert type information later on
        $items-doc ~= "\n=item ___" ~ ~($<item>//'');
#note "Item: $items-doc";
      }

      # on empty line swith from item to enum doc
      elsif $line ~~ m/ ^ \s+ '*' \s* $ / {
        $get-item-doc = False;
        $get-struct-doc = True;

        $struct-doc ~= "\n";
      }

      # end of type documentation
      elsif $line ~~ m/ ^ \s+ '*'*? '*/' \s* $ / {
        $get-item-doc = False;
        $get-struct-doc = False;
        $process-struct = True;

        $struct-spec = "\n=end pod\n\n#TT:0:$struct-name:\n" ~
          "class $struct-name is export is repr\('CStruct') \{\n";
      }

#      elsif $line ~~ m/ ^ \s+ '*' \s* 'Since:' .* $ / {
#        # ignore
#      }

      elsif $line ~~ m/ ^ \s+ '*' \s+ $<doc> = [ \S .* ] $ / {
        if $get-item-doc {
          $items-doc ~= " " ~ ~($<doc>//'');
        }

        elsif $get-struct-doc {
          $struct-doc ~= "\n" ~ ~($<doc>//'');
        }
      }

      elsif $line ~~ m:s/ '};' / {
        $struct-spec ~= "}\n";
      }

      elsif $line ~~ m/^ \s+ $<struct-entry> = [ .*? ] ';' $/ {
        my Str $s = ~($<struct-entry> // '');
        ( $s, $entry-type, $p6-entry-type, $type-is-class) =
          get-type( $s, :!attr);

        # entry type Str must be converted to str
        $entry-type ~~ s/Str/str/;

        # if there is a comma separated list then split vars up
        if $s ~~ m/ ',' / {
          my @varlist = $s.split( / \s* ',' \s* /);
          for @varlist -> $var {
            $struct-spec ~= "  has $entry-type \$.$var;\n";
            $items-doc ~~ s/ 'item ___' $var /item $p6-entry-type \$.$var/;
          }
        }

        # $s is holding a single var
        else {
          $struct-spec ~= "  has $entry-type \$.$s;\n";
  #note "check for 'item ___$s'";
          $items-doc ~~ s/ 'item ___' $s /item $p6-entry-type \$.$s/;
        }
      }
    }

    # remove first space
    $struct-doc ~~ s/ ^ \s+ //;

    $struct-doc = primary-doc-changes($struct-doc);
    $items-doc = primary-doc-changes($items-doc);

    unless $struct-skip {
      $structs-doc ~= Q:qq:to/EODOC/;
        #-------------------------------------------------------------------------------
        =begin pod
        =head2 class $struct-name

        $struct-doc

        $items-doc

        $struct-spec
        EODOC
    }
  }

  $output-file.IO.spurt( $structs-doc, :append);
}

#-------------------------------------------------------------------------------
sub cleanup-source-doc ( Str:D $text is copy --> Str ) {

  # remove property and signal line
  $text ~~ s/ ^^ \s+ '*' \s+ $lib-class-name ':'+ .*? \n //;
#  $text ~~ s/ ^^ \s+ '*' \s+ $lib-class-name ':' .*? \n //;

  $text ~~ s/ ^^ '/**' .*? \n //;                   # Doc start
  $text ~~ s/ \s* '*/' .* $ //;                     # Doc end
#  $text ~~ s/ ^^ \s+ '*' \s+ Since: .*? \n //;      # Since: version
#  $text ~~ s/ ^^ \s+ '*' \s+ Deprecated: .*? \n //; # Deprecated: version
#  $text ~~ s/ ^^ \s+ '*' \s+ Stability: .*? \n //;  # Stability: status
  $text ~~ s:g/ ^^ \s+ '*' ' '? (.*?) $$ /$/[0]/;   # Leading star
  $text ~~ s:g/ ^^ \s+ '*' \s* \n //;               # Leading star on Empty line
#  $text ~~ s:g/ ^^ \s* \n //;

  $text ~ "\n\n"
}

#-------------------------------------------------------------------------------
sub primary-doc-changes ( Str:D $text is copy --> Str ) {

  $text = podding-class($text);
  $text = podding-signal($text);
  $text = podding-property($text);
  $text = modify-at-vars($text);
  $text = modify-percent-types($text);
  $text = podding-function($text);
  $text = adjust-image-path($text);

  $text
}

#-------------------------------------------------------------------------------
# change any #GtkClass to C<Gnome::Gtk::Class> and Gdk likewise
sub podding-class ( Str:D $text is copy --> Str ) {

  loop {
    # check for property spec with classname in doc
    $text ~~ m/ '#' (<alnum>+) ':' ([<alnum> || '-']+) /;
    my Str $oct = ~($/[1] // '');
    last unless ?$oct;

    $text ~~ s/ '#' (<alnum>+) ':' [<alnum> || '-']+ /prop C\<$oct\>/;
  }

  loop {
    # check for signal spec with classname in doc
    $text ~~ m/ '#' (<alnum>+) '::' ([<alnum> || '-']+) /;
    my Str $oct = ~($/[1] // '');
    last unless ?$oct;

    $text ~~ s/ '#' (<alnum>+) '::' [<alnum> || '-']+ /sig C\<$oct\>/;
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
# change any ::signal to C<signal>
sub podding-signal ( Str:D $text is copy --> Str ) {

  loop {
    last unless $text ~~ m/ \s '::' [<alnum> || '-']+ /;
    $text ~~ s/ \s '::' ([<alnum> || '-']+) / sig I<$/[0]>/;
  }

  $text
}

#-------------------------------------------------------------------------------
# change any :property to C<property>
sub podding-property ( Str:D $text is copy --> Str ) {

  loop {
    last unless $text ~~ m/ \s ':' [<alnum> || '-']+ /;
    $text ~~ s/ \s ':' ([<alnum> || '-']+) / prop C<$/[0]>/;
  }

  $text
}

#-------------------------------------------------------------------------------
# change any function() to C<function()>
sub podding-function ( Str:D $text is copy --> Str ) {

  # change any function() to C<function()>. first change to [[function]] to
  # prevent nested substitutions.
  $text ~~ s:g/ ([<alnum> || '_']+) \s* '()' /\[\[$/[0]\]\]/;
  $text ~~ s:g/ '[[' ([<alnum> || '_']+ )']]' /C<$/[0]\()>/;

  $text
}

#-------------------------------------------------------------------------------
# change any %type to C<type>
sub modify-percent-types ( Str:D $text is copy --> Str ) {
  $text ~~ s:g/ '%TRUE' /C<1>/;
  $text ~~ s:g/ '%FALSE' /C<0>/;
  $text ~~ s:g/ '%NULL' /C<Any>/;
  $text ~~ s:g/ '%' ([<alnum> || '_' ]+) /C<$/[0]>/;

  $text
}

#-------------------------------------------------------------------------------
# change any @var to I<var>
sub modify-at-vars ( Str:D $text is copy --> Str ) {
  $text ~~ s:g/ '@' (<alnum>+) /I<$/[0]>/;

  $text
}

#-------------------------------------------------------------------------------
# change any ![alt](path) to ![alt](images/path)
sub adjust-image-path ( Str:D $text is copy --> Str ) {
  $text ~~ s:g/ '![' (<-[\]]>*) '](' (<-[\)]>+) ')'
              /\!\[$/[0]\]\(images\/$/[1]\)/;

  $text
}

#`[[
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
]]
