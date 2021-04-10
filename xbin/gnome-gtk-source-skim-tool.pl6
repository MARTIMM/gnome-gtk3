#!/usr/bin/env raku

use v6;

#-------------------------------------------------------------------------------
my Str $output-file;

my Str ( $section-doc, $short-description, $see-also);

my @gtkdirlist = ();
my @gdkpixbufdirlist = ();
my @gdkdirlist = ();
my @gobjectdirlist = ();
my @glibdirlist = ();
my @pangodirlist = ();
#my @giodirlist = ();

my @enum-list = ();

# No leaf, role, top or standalone means class not at the top nor at the end.
# Methods must call self._f('gtk widget class name') to get native object and
# perform casting. Leaf classes do not need casting and can call
# self.get-native-object-no-reffing. Roles have a simpler interface and does not
# inherit from TopLevelClassSupport. Top classes inherit directly from
# TopLevelClassSupport and have a native object of their own, and do not need
# Boxed class. Standalone classes do not have an object and therefore no need to
# inherit anything
my Bool $class-is-leaf;
my Bool $class-is-role; # is leaf implicitly
my Bool $class-is-top;

#-------------------------------------------------------------------------------
sub MAIN (
  Str:D $base-name, Str $base-sub-name? is copy,
  Bool :$main = False, Bool :$sig = False, Bool :$prop = False,
  Bool :$sub = False, Bool :$types = False, Bool :$test = False,
  Bool :$leaf = False, Bool :$role = False, Bool :$top = False,
) {

  my Str $include-content;    # contents of xyz.h
  my Str $source-content;     # contents of xyz.c

  my Str $*base-sub-name;
  my Str $*library = '';
  my Str $*raku-lib-name;
  my Str $*lib-class-name;
  my Str $*raku-class-name;
  my Str $*raku-parentlib-name = '';
  my Str $*raku-parentclass-name = '';

  my Bool $do-all = !( [or] $main, $sig, $prop, $sub, $types, $test );

  # Gtk interfaces (roles) are always leaf classes but need to cast their
  # object types, so leaf get False if role is True.
  $class-is-leaf = ($leaf and not $role);
  $class-is-role = $role;
  $class-is-top = $top;

  load-dir-lists();

  $*base-sub-name = $base-sub-name // $base-name;

  # get content of include and source file. exit if files not found
  ( $include-content, $source-content) = setup-names($base-name);

  # test for dir 'xt'
  mkdir( 'xt', 0o766) unless 'xt'.IO.e;
  mkdir( 'xt/NewModules', 0o766) unless 'xt/NewModules'.IO.e;

  set-parent-classes($include-content);

  ( $section-doc, $short-description, $see-also) =
    get-section($source-content);

  substitute-in-template( $do-all, $main, $types, $include-content);

  get-subroutines( $include-content, $source-content) if $do-all or $sub;
  get-signals($source-content) if $do-all or $sig;
  get-properties($source-content) if $do-all or $prop;

  generate-test if $test or $do-all;
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
  $include-content ~~ m:g/^^ <[\w]>+ '_AVAILABLE_IN_' <-[;]>+ ';' /;
  my List $results = $/[*];

  # process subroutines
  print "Find subroutines ";
  my Hash $sub-documents = %();
  for @$results -> $r {
    print ".";
    $*OUT.flush;

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
    $declaration ~~ s/^ <[\w]>+ '_AVAILABLE_IN_' .*?  \n //;
#    $declaration ~~ s:g/ \s* \n \s* / /;
    $declaration ~~ s:g/ \s+ / /;
    $declaration ~~ s/\s* 'G_GNUC_PURE' \s*//;
#note "\n0 >> $declaration";

    my Str ( $return-type, $raku-return-type) = ( '', '');
    my Bool $type-is-class;

    # convert and remove return type from declaration
    ( $declaration, $return-type, $raku-return-type, $type-is-class) =
      get-type( $declaration, :!attr);

    # get the subroutine name and remove from declaration
    $declaration ~~ m/ $<sub-name> = [ <alnum>+ ] \s* /;
    my Str $sub-name = ~$<sub-name>;
    $declaration ~~ s/ $sub-name \s* //;

    # remove any brackets, and other stuff left before arguments are processed
    $declaration ~~ s:g/ <[();]> || 'void' || 'G_GNUC_NULL_TERMINATED' //;

    # get subroutine documentation from c source
    ( $sub-doc, $items-src-doc) = get-sub-doc( $sub-name, $source-content);
    $sub-doc ~~ s:g/ '(' [
            nullable | 'transfer none' | 'transfer full' | 'allow-none' |
            'array zero-terminated=1' | optional | inout | out | in |
            'not nullable'
          ] ')' //;
    $sub-doc ~~ s/ 'Returns:' \s* ':' \s+ /Returns: /;

#note "Pod items: $items-src-doc.elems()\n  ", $items-src-doc.join("\n  ");

    my Str $args-declaration = $declaration;
    my Str ( $pod-args, $call-args, $args, $pod-doc-items) = ( '', '', '', '');
    my Bool $first-arg = True;
    my Str $convert-lines = "";
    my Str $method-args = '';

    # process arguments
#print "\n$sub-name\n";
    for $args-declaration.split(/ \s* ',' \s* /) -> $raw-arg {
      my Str ( $arg, $arg-type, $raku-arg-type);
      ( $arg, $arg-type, $raku-arg-type, $type-is-class) =
        get-type( $raw-arg, :attr);
#note "  $sub-name, $arg, $arg-type, $raku-arg-type";
      if ?$arg {
        my Str $pod-doc-item-doc = $items-src-doc.shift if $items-src-doc.elems;
#note "pod info: $raku-arg-type, $arg, $pod-doc-item-doc";

        # skip first argument when type is also the class name
        if $first-arg and $type-is-class {
          #note "  skip $arg";
          #$first-arg = False;
          #next;
        }

        # skip also when variable is $any set to default Any type
        elsif $arg eq 'any = Any' { }

        else {
#note "  not skipped... $sub-name, $arg, $arg-type, $raku-arg-type";

          if $raku-arg-type ~~ any(
            < N-GObject N-GSList N-GList N-GOptionContext N-GOptionGroup
              N-GOptionEntry N-GError
            >
          ) {

            $convert-lines ~= "  \$$arg .= get-native-object-no-reffing unless \$$arg ~~ $raku-arg-type;\n";

            $method-args ~= ',' if ?$method-args;
            $method-args ~= " \$$arg is copy";
            $call-args ~= ',' if ?$call-args;
            $call-args ~= " \$$arg";
            $pod-args ~= ',' if ?$pod-args;
            $pod-args ~= " $raku-arg-type \$$arg";
          }

          elsif $raku-arg-type eq 'Int-ptr' {
            # don't define method args should insert '--> List' at the end
            # also no pod args and also add '--> List' at the end, but how
            # and not always if it only one
            $raku-arg-type = 'Int';
            $call-args ~= ',' if ?$call-args;
            $call-args ~= " my gint \$$arg";
          }

          else {
            $method-args ~= ',' if ?$method-args;
            $method-args ~= " $raku-arg-type \$$arg";
            $call-args ~= ',' if ?$call-args;
            $call-args ~= " \$$arg";
            $pod-args ~= ',' if ?$pod-args;
            $pod-args ~= " $raku-arg-type \$$arg";
          }



          # remove some c-oriented remarks
          if ?$pod-doc-item-doc {
            $pod-doc-item-doc ~~ s:g/'(' [
                    nullable | 'transfer none' | 'transfer full' |
                    'allow-none' | 'not nullable' | 'array zero-terminated=1' |
                    optional | inout | out | in
                  ] ')' //;
            $pod-doc-item-doc ~~ s/^ \s* <[:;]> \s+ //;
            $pod-doc-item-doc ~~ s/ 'C<Any>-terminated' //;
            $pod-doc-items ~=
              "=item $raku-arg-type \$$arg; $pod-doc-item-doc\n";
          }

          else {
            $pod-doc-items ~= "=item $raku-arg-type \$$arg; \n";
          }

          $pod-doc-items ~~ s/^ \s+ $//;

#note "  not skipped... $sub-name\n    $pod-args\n    $call-args\n    $pod-doc-items";
        }

        # add argument to list for sub declaration
        $args ~= ', ' if ?$args;
        if $arg-type eq 'gint-ptr' {
          $arg-type = 'gint';
          $args ~= "$arg-type \$$arg is rw";
        }

        else {
          $args ~= "$arg-type \$$arg";
        }
#note "  sub... $sub-name    $args";
      }

      $first-arg = False;
    }

#    note "2 >> $sub-name";
#    note "3 >> $args";
#    note "4 >> $return-type";

    my Str $return-dot-comma = '';
    my Str $pod-returns = '';
    my Str $returns = '';
    if ?$return-type {
      $pod-returns = " --> $raku-return-type";
      $returns = "--> $return-type";
    }

    else {
      $return-dot-comma = ';';
    }

    my Str $start-comment = $variable-args-list ?? '#`{{' ~ "\n" !! '';
    my Str $end-comment = $variable-args-list ?? "\n" ~ '}}' !! '';

    my $pod-sub-name = pod-sub-name($sub-name);

    my Str $sub = '';

    my Str $pod-doc-key;

    my Str $return-conversion = '';
    given $raku-return-type {
      when 'Bool' { $return-conversion = '.Bool'; }
    }

    # process new subroutines. they will be sorted to the end and do not get a
    # method because they are accessed from BUILD. Also doc is commented out.
    if $sub-name ~~ m/^ $*base-sub-name '_new' / {
      $pod-doc-key = "_$sub-name";
#      note "get sub as $pod-doc-key";
      $sub = Q:qq:to/EOSUB/;

        $start-comment#-------------------------------------------------------------------------------
        #TM:1:_$sub-name:
        #`\{\{
        =begin pod
        =head2 _$sub-name

        $sub-doc

          method _$sub-name ($pod-args$pod-returns )

        $pod-doc-items=end pod
        \}\}

        sub _$sub-name ( $args $returns )
          is native($*library)
          is symbol\('$sub-name')
          \{ * \}$end-comment
        EOSUB
    }

    # process methods in leaf classes. they do not need casting
    elsif $class-is-leaf {
      $pod-doc-key = $pod-sub-name;
#      note "get sub as $pod-sub-name";

      $sub = Q:qq:to/EOSUB/;

        $start-comment#-------------------------------------------------------------------------------
        #TM:0:$pod-sub-name:
        =begin pod
        =head2 $pod-sub-name

        $sub-doc

          method $pod-sub-name ($pod-args$pod-returns )

        $pod-doc-items=end pod

        method $pod-sub-name ($method-args$pod-returns ) \{
        $convert-lines
          $sub-name\(
            self\.get-native-object-no-reffing,$call-args
          )$return-conversion$return-dot-comma
        \}

        sub $sub-name (
          $args $returns
        ) is native($*library)
          \{ * \}$end-comment
        EOSUB
    }

    # process methods in other classes. they do need casting
    else {
      $pod-doc-key = $pod-sub-name;
#      note "get sub as $pod-sub-name";

      $sub = Q:qq:to/EOSUB/;

        $start-comment#-------------------------------------------------------------------------------
        #TM:0:$pod-sub-name:
        =begin pod
        =head2 $pod-sub-name

        $sub-doc

          method $pod-sub-name ($pod-args$pod-returns )

        $pod-doc-items=end pod

        method $pod-sub-name ($method-args$pod-returns ) \{
        $convert-lines
          $sub-name\(
            self\._f\('$*lib-class-name'),$call-args
          )$return-conversion$return-dot-comma
        \}

        sub $sub-name (
          $args $returns
        ) is native($*library)
          \{ * \}$end-comment
        EOSUB
    }

#    note $sub;

#    $output-file.IO.spurt( $sub, :append);$sub-documents
    $sub-documents{$pod-doc-key} = $sub;
  }
  print "\n";

  # place all non-new modules at the end
  for $sub-documents.keys.sort -> $key {
    next if $key ~~ m/^ '_' /;
    note "save doc for sub $key";
    $output-file.IO.spurt( $sub-documents{$key}, :append);
  }

  # place all new modules at the end
  for $sub-documents.keys.sort -> $key {
    next unless $key ~~ m/^ '_' /;
    note "save doc for sub $key";
    $output-file.IO.spurt( $sub-documents{$key}, :append);
  }
}

#-------------------------------------------------------------------------------
sub set-parent-classes ( Str:D $include-content ) {

  $include-content ~~ m/
    ^^ \s*
    $<lib-parent> = [<alnum>+]
    \s+ 'parent_class'
  /;

  $*raku-parentclass-name = ~($<lib-parent> // '');
  given $*raku-parentclass-name {
    when /^ Gtk / {
      $*raku-parentlib-name = 'Gtk3';
    }

    when /^ Gdk / {
      $*raku-parentlib-name = 'Gdk3';
    }
  }

  $*raku-parentclass-name ~~ s:g/ ['Gtk' || 'Gdk'|| 'Class'] //;
}

#-------------------------------------------------------------------------------
# Get the type from the start of the declaration and remove it from that
# declaration. The type is cleaned up by removing 'const', 'void' and pointer(*)
sub get-type( Str:D $declaration is copy, Bool :$attr --> List ) {

#note "\nDeclaration: ", $declaration if $declaration ~~ m/ gtk_widget_path_iter_get_siblings /;

  # process types from arg lists, inconsequent use of gchar/char
  if $attr {
    $declaration ~~ m/ ^
      $<type> = [
        [
          \s* const \s* g?char \s* '*' \s* const \s* '*'* \s* ||
          \s* const \s* g?char \s* '*'* \s* ||
          \s* g?char \s* '*'* \s* ||
          \s* const \s* <alnum>+ \s* '*'* \s* ||
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
          const \s* g?char \s* '*' \s* const \s* '*'* \s* ||
          const \s* g?char \s* '*' \s* ||
          g?char \s* '*'* \s* ||
          const \s* '*' <alnum>+ \s* '*'* \s* ||
          const \s* <alnum>+ \s* '*'* \s* ||
          <alnum>+ \s* '*'* \s*
        ]
      ] <alnum>+
    /;
  }

  #[ [const]? \s* <alnum>+ \s* \*? ]*

  my Str $type = ~($<type> // '');
  $declaration ~~ s/ $type //;

  #drop the const
  $type ~~ s:g/ const //;

  # convert pointer char types
  $type ~~ s/ g?char \s* '*' \s* '*' \s* '*' /gchar-ppptr/;
  $type ~~ s/ g?char \s* '*' \s* '*' /gchar-pptr/;
  $type ~~ s/ g?char \s* '*' /gchar-ptr/;

  # convert other pointer types
  $type ~~ s/ void \s* '*' /void-ptr/;
  $type ~~ s/ g?int \s* '*' /gint-ptr/;

#  if $type ~~ m/ g?char \s* '*' / {
#    $type ~~ s/ g?char \s* '*' / Str /;
#
#    # if there is still another pointer, make a CArray
#    $type = "CArray[$type]" if $type ~~ m/ '*' /;
#    $type ~~ s:g/ \s* //;
#  }

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
  my Bool $type-is-class = $type eq $*lib-class-name;

  # convert to native Raku types
#note "Type: $type";
  given $type {
    when /GError/ { $type = 'N-GError'; }
    #$type = 'GQuark' if $type ~~ m/GQuark/;
    when /GList/ { $type = 'N-GList'; }
    when /GSList/ { $type = 'N-GSList'; }
    when /PangoItem/ { $type = 'N-PangoItem'; }
    when /GVariantType || GVariantDict || GVariant/ { $type = 'N-GObject'; }
    when /GtkTreePath/ { $type = 'N-GtkTreePath'; }
    when /GOptionContext/ { $type = 'N-GOptionContext'; }
    when /GOptionGroup/ { $type = 'N-GOptionGroup'; }
    when /GOptionEntry/ { $type = 'N-GOptionEntry'; }
#    when // { $type = 'N-'; }

    default {
      $type = 'N-GObject' if is-n-gobject($type);
    }
  }

#`{{
  $type = 'uint64' if $type ~~ m/GType/;

  $type = 'int32' if $type ~~ m/GQuark/;
}}

  # copy to Raku type for independent convertions
  my Str $raku-type = $type;

  # convert to native perl types
  #$type ~~ s/ g?char \s+ '*' /str/;

  # process all types from GtkEnum and some
  # use bin/gather-enums.pl6 to create a list in
  # doc/Design-docs/skim-tool-enum-list.txt
  $type = 'GEnum' if $type ~~ any(@enum-list);

#`{{ not translated anymore. they are mapped in Gnome::N::GlibToRakuTypes

  $type ~~ s:s/ gboolean || gint /int/;
  $type ~~ s:s/ gint32 /int32/;
  $type ~~ s:s/ g?char || gint8 /int8/;
  $type ~~ s:s/ gshort || gint16 /int16/;
  $type ~~ s:s/ glong || gint64 /int64/;

  $type ~~ s:s/ guint32 /uint32/;
  $type ~~ s:s/ guint /uint/;
  $type ~~ s:s/ guchar || guint8 /byte/;
  $type ~~ s:s/ gushort || guint16 /uint16/;
  $type ~~ s:s/ gulong || guint64 /uint64/;

  $type ~~ s:s/ gssize || goffset /int64/;
  $type ~~ s:s/ gsize /uint64/;
  $type ~~ s:s/ gfloat /num32/;
  $type ~~ s:s/ gdouble /num64/;

  $type ~~ s:s/ int /int32/;
  $type ~~ s:s/ gpointer /Pointer/;
}}

  # convert to perl types
  #$raku-type ~~ s/ 'gchar' \s+ '*' /Str/;
  #$raku-type ~~ s/ str /Str/;

  $raku-type ~~ s:s/ g?char\-ppptr / CArray[CArray[Str]] /;
  $raku-type ~~ s:s/ g?char\-pptr / CArray[Str] /;
  $raku-type ~~ s:s/ g?char\-ptr / Str /;

  $raku-type ~~ s:s/ guint || guint32 || guchar || guint8 ||
                   gushort || guint16 || gulong || guint64 ||
                   gsize || uint32 || uint64 || uint
                 /UInt/;

  $raku-type ~~ s:s/ gint || gint32 ||
                   gchar || gint8 || gshort || gint16 ||
                   glong || gint64 ||
                   gssize || goffset || int32 || int64 || int || time_t
                 /Int/;

  $raku-type ~~ s:s/ gboolean /Bool/;

#  $raku-type ~~ s:s/ int /Int/;
#  $raku-type ~~ s:s/ uint /UInt/;
  $raku-type ~~ s:s/ gpointer /Pointer/;
  $raku-type ~~ s:s/ gfloat || gdouble /Num/;
  $raku-type ~~ s:s/ GQuark /UInt/;
  $raku-type ~~ s:s/ GFlag /UInt/;

  $raku-type ~~ s:g/ \s+ //;

#note "Result type: $type, raku type: $raku-type, is class = $type-is-class";

  ( $declaration, $type, $raku-type, $type-is-class)
}

#-------------------------------------------------------------------------------
sub setup-names ( Str:D $base-name --> List ) {
  my Str $include-file = $base-name;
  if $include-file ~~ m/ 'gdk_pixbuf' || 'pango' / {
    $include-file ~~ s:g/ '_' /-/;
  }

  else {
    $include-file ~~ s:g/ '_' //;
  }

  my @parts = $*base-sub-name.split(/<[_-]>/);
  $*lib-class-name = @parts>>.tc.join;

  $*raku-class-name = @parts[1..*-1]>>.tc.join;

#note "Files: $base-name, $include-file. $*lib-class-name, $*raku-class-name";

#`{{
  my Str $*raku-lib-name = '';
  given $*lib-class-name {
    when /^ Gtk / {
      $*raku-lib-name = 'Gtk3';
    }

    when /^ Gdk / {
      $*raku-lib-name = 'Gdk3';
    }
  }
}}

#`{{
  # assume linux fedora
  my Str $gtk-path = '/usr/include/gtk-3.0/gtk';
  my Str $gdk-path = '/usr/include/gtk-3.0/gdk';
  my Str $gdk-pixbuf-path = '/usr/include/gtk-3.0/gdk';
  my Str $glib-path = '/usr/include/glib-2.0/glib';
  my Str $gobject-path = '/usr/include/glib-2.0/gobject';
#  my Str $gio-path = '/usr/include/glib-2.0/gio';
}}
#`{{
  # c-source file text paths, downloaded latest version. the version does not
  # matter much, just searching for documentation.
  my Str $gtk-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/gtk+-3.22.0/gtk';
  my Str $gdk-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/gtk+-3.22.0/gdk';
  my Str $glib-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/glib-2.60.0/glib';
  my Str $gobject-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/glib-2.60.0/gobject';
#  my Str $gio-srcpath = '/home/marcel/Software/Packages/Sources/Gnome/glib-2.60.0/gio';
}}

  my $source-root = '/home/marcel/Software/Packages/Sources/Gnome';
  my @source-list = (
    "$source-root/gtk+-3.24.13/gtk",
    "$source-root/gdk-pixbuf-2.38.2/gdk-pixbuf",
    "$source-root/gtk+-3.24.13/gdk",
    "$source-root/glib-2.60.7/gio",
    "$source-root/glib-2.60.7/glib",
    "$source-root/glib-2.60.7/gobject",
    "$source-root/pango-1.42.4/pango",
  );

  my Str ( $include-content, $source-content) = ( '', '');
  my Bool $file-found = False;
  for @source-list -> $path {
#note "Include $path/$include-file.h";
    if "$path/$include-file.h".IO.r {
      $file-found = True;
      if $include-file eq 'gdk-pixbuf' and "$path/{$include-file}-core.h".IO.r {
        $include-content = "$path/{$include-file}-core.h".IO.slurp;
      }
      else {
        $include-content = "$path/$include-file.h".IO.slurp;
      }

      $source-content = "$path/$include-file.c".IO.slurp
        if "$path/$include-file.c".IO.r;

#note "Sources: ", ?$include-content, ', ', ?$source-content;

      given $path {
        when / 'gtk+-' <-[/]>+ '/gtk' / {
          $*library = '&gtk-lib';
          $*raku-lib-name = 'Gtk3';
        }

        when / 'gdk-pixbuf' / {
          $*library = '&gdk-pixbuf-lib';
          $*raku-lib-name = 'Gdk3';
        }

        when / 'gtk+-' <-[/]>+ '/gdk' / {
          $*library = "&gdk-lib";
          $*raku-lib-name = 'Gdk3';
        }

        when / 'glib-' <-[/]>+ '/glib' / {
          $*library = "&glib-lib";
          $*raku-lib-name = 'Glib';
        }

        when / 'glib-' <-[/]>+ '/gio' / {
          $*library = "&gio-lib";
          $*raku-lib-name = 'Gio';
        }

        when / 'glib-' <-[/]>+ '/gobject' / {
          $*library = "&gobject-lib";
          $*raku-lib-name = 'GObject';
        }

        when / 'pango-' <-[/]>+ '/pango' / {
          $*library = "&pango-lib";
          $*raku-lib-name = 'Pango';
        }

        when / 'cairo-' <-[/]>+ '/src/cairo' / {
          $*library = "&cairo-lib";
          $*raku-lib-name = 'Cairo';
        }

#        when $gio-path {
#          $*library = "&glib-lib";
#          $*raku-lib-name = 'Glib';
#        }
      }

#note "Library: $*library, $*lib-class-name, $*raku-lib-name";
      last;
    }
  }

  unless $file-found {
    note "Include file '$include-file' is not found";
    exit(1)
  }

  ( $include-content, $source-content)
}

#-------------------------------------------------------------------------------
sub pod-sub-name ( Str:D $sub-name --> Str ) {

  my Str $pod-sub-name = $sub-name;

  # sometimes the sub name does not start with the base name
  if $sub-name ~~ m/ ^ $*base-sub-name / {
    $pod-sub-name = $sub-name;

    # remove base subname and an '_', then test if there is another '_' to
    # see if a part could be made optional by circumventing with '[' and ']'.
    $pod-sub-name ~~ s/^ $*base-sub-name '_' //;
  }

  # and replace '_' with '-'
  $pod-sub-name ~~ s:g/ '_' /-/;

#note "psn: $sub-name, $pod-sub-name, $*base-sub-name";
  $pod-sub-name

#`{{
  my Str $pod-sub-name = $sub-name;

  # sometimes the sub name does not start with the base name
  if $sub-name ~~ m/ ^ $*base-sub-name / {
    my Str $s = $sub-name;

    # remove base subname and an '_', then test if there is another '_' to
    # see if a part could be made optional by circumventing with '[' and ']'.
    $s ~~ s/^ $*base-sub-name '_' //;
    $pod-sub-name = [~] '[', $*base-sub-name, '_] ', $s if $s ~~ m/ '_' /;

    # then make the first part optional
    $pod-sub-name ~~ s/^ ( <-[_]>+ '_' ) /[$0] /;
  }

  $pod-sub-name
}}
}

#-------------------------------------------------------------------------------
sub is-n-gobject ( Str:D $type-name is copy --> Bool ) {

  my Bool $is-n-gobject = False;
  $type-name .= lc;
#note "TN: $type-name";

  given $type-name {
    when /^ gtk / {
      $is-n-gobject = $type-name ~~ any(|@gtkdirlist);
    }

    when /^ gdk / {
      $is-n-gobject = $type-name ~~ any(|@gdkdirlist);
    }

    when /^ gquark / { #`(skip this type) }

    when /^ g / {

      $is-n-gobject = $type-name ~~ any(|@glibdirlist);
      $is-n-gobject = $type-name ~~ any(|@gobjectdirlist) unless $is-n-gobject;
#      $is-n-gobject = $type-name ~~ any(|@giodirlist) unless $is-n-gobject;
    }

    when /^ pango / {
      state @modified-pangodirlist = map(
        { .subst( / '-' /, ''); }, @pangodirlist
      );

      $is-n-gobject = $type-name ~~ any(|@modified-pangodirlist);
    }
  }

  $is-n-gobject
}

#-------------------------------------------------------------------------------
sub load-dir-lists ( ) {

  my Str $root-dir = '/home/marcel/Languages/Raku/Projects/gnome-gtk3';
  @gtkdirlist = "$root-dir/Design-docs/gtk3-list.txt".IO.slurp.lines;
  @gdkdirlist = "$root-dir/Design-docs/gdk3-list.txt".IO.slurp.lines;
  @gdkpixbufdirlist = "$root-dir/Design-docs/gdk3-pixbuf-list.txt".IO.slurp.lines;
  @gobjectdirlist = "$root-dir/Design-docs/gobject-list.txt".IO.slurp.lines;
  @glibdirlist = "$root-dir/Design-docs/glib-list.txt".IO.slurp.lines;
#  @giodirlist = "$root-dir/Design-docs/gio-list.txt".IO.slurp.lines;

  @pangodirlist = "$root-dir/Design-docs/pango-list.txt".IO.slurp.lines;

  @enum-list = "$root-dir/Design-docs/skim-tool-enum-list".IO.slurp.lines;
}

#-------------------------------------------------------------------------------
sub substitute-in-template (
  Bool $do-all, Bool $main, Bool $types, Str $include-content
) {

  my Str $template-text = Q:q:to/EOTEMPLATE/;
    #TL:1:Gnome::LIBRARYMODULE:

    use v6;
    #-------------------------------------------------------------------------------
    =begin pod

    =head1 Gnome::LIBRARYMODULE

    MODULE-SHORTDESCRIPTION

    =comment ![](images/X.png)

    =head1 Description

    MODULE-DESCRIPTION

    MODULE-SEEALSO

    =head1 Synopsis
    =head2 Declaration
    EOTEMPLATE

  if $class-is-role {
    # no extra info for roles
    $template-text ~= Q:q:to/EOTEMPLATE/;

        unit role Gnome::LIBRARYMODULE;

      =end pod
      #-------------------------------------------------------------------------------
      use NativeCall;

      #use Gnome::N::X;
      use Gnome::N::NativeLib;
      use Gnome::N::N-GObject;
      use Gnome::N::GlibToRakuTypes;
      USE-LIBRARY-PARENT

      #-------------------------------------------------------------------------------
      unit role Gnome::LIBRARYMODULE:auth<github:MARTIMM>:ver<0.1.0>;
      ALSO-IS-LIBRARY-PARENT
      EOTEMPLATE
  }

  else {
    $template-text ~= Q:q:to/EOTEMPLATE/;

        unit class Gnome::LIBRARYMODULE;
        ALSO-IS-LIBRARY-PARENT


      =comment head2 Uml Diagram

      =comment ![](plantuml/.svg)


      =begin comment
      =head2 Inheriting this class

      Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

        use Gnome::LIBRARYMODULE;

        unit class MyGuiClass;
        also is Gnome::LIBRARYMODULE;

        submethod new ( |c ) {
          # let the Gnome::LIBRARYMODULE class process the options
          self.bless( :LIBCLASSNAME, |c);
        }

        submethod BUILD ( ... ) {
          ...
        }

      =end comment
      =comment head2 Example

      =end pod
      #-------------------------------------------------------------------------------
      use NativeCall;

      #use Gnome::N::X;
      use Gnome::N::NativeLib;
      use Gnome::N::N-GObject;
      use Gnome::N::GlibToRakuTypes;
      USE-LIBRARY-PARENT

      #-------------------------------------------------------------------------------
      unit class Gnome::LIBRARYMODULE:auth<github:MARTIMM>:ver<0.1.0>;
      ALSO-IS-LIBRARY-PARENT
      EOTEMPLATE
  }

  my Str ( $t1, $t2) = ( '', '');
  if $class-is-top {
    $t1 = "use Gnome::N::TopLevelClassSupport;";
    $t2 = "also is Gnome::N::TopLevelClassSupport;";
  }

  elsif $*raku-parentlib-name and $*raku-parentclass-name {
    $t1 = "use Gnome::{$*raku-parentlib-name}::{$*raku-parentclass-name};";
    $t2 = "also is Gnome::{$*raku-parentlib-name}::{$*raku-parentclass-name};";
  }


  $template-text ~~ s:g/ 'MODULENAME' /$*raku-class-name/;
  $template-text ~~ s:g/ 'LIBRARYMODULE' /{$*raku-lib-name}::{$*raku-class-name}/;
  $template-text ~~ s:g/ 'USE-LIBRARY-PARENT' /$t1/;
  $template-text ~~ s:g/ 'ALSO-IS-LIBRARY-PARENT' /$t2/;

  $template-text ~~ s:g/ 'MODULE-SHORTDESCRIPTION' /$short-description/;
  $template-text ~~ s:g/ 'MODULE-DESCRIPTION' /$section-doc/;
  $template-text ~~ s:g/ 'MODULE-SEEALSO' /$see-also/;
  $template-text ~~ s:g/ 'LIBCLASSNAME' /$*lib-class-name/;

  $output-file = "xt/NewModules/$*raku-class-name.pm6";
  $output-file.IO.spurt($template-text);

  note "Write Gnome::{$*raku-lib-name}::{$*raku-class-name} to $output-file";

  get-vartypes($include-content) if $do-all or $types;

  if $do-all or $main {
    if $class-is-role {
      $template-text = Q:q:to/EOTEMPLATE/;
        #-------------------------------------------------------------------------------
        =begin pod
        =head1 Methods
        =end pod

        # interfaces are not instantiated
        #submethod BUILD ( *%options ) { }

        #`{{
        # All interface calls should become methods
        #-------------------------------------------------------------------------------
        # no pod. user does not have to know about it.
        method _INTERFACE_NAME ( $native-sub --> Callable ) {

          my Callable $s;
          try { $s = &:("BASE-SUBNAME_$native-sub"); };
        # check for gtk_, gdk_, g_, pango_, cairo_ !!!
          try { $s = &:("gtk_$native-sub"); } unless ?$s;
          try { $s = &:($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

          $s;
        }
        }}


        #-------------------------------------------------------------------------------
        # setup signals from interface
        method _add_INTERFACE_NAME_signal_types ( Str $class-name ) {
        BUILD-ADD-SIGNALS}

        EOTEMPLATE

      my Str $iname = $*base-sub-name;
      $iname ~~ s/ [ gtk | gdk | gio ] '_' //;
      $template-text ~~ s:g/ INTERFACE_NAME /{$iname}_interface/;
#`{{
  TODO must call interfaces after .set-class-name-of-sub()
  and in interface must also call .set-class-name-of-sub() if sub is found.
  this is for casting.

  Methods can be written for interfaces and remove self._xyz_interface() from
  classes. ==> interfaces can not be handled as leafs because casting necessary

  self.set-class-name-of-sub('GSimpleAction') if ?$s;
}}
    }

    else {
      $template-text = Q:q:to/EOTEMPLATE/;
        #-------------------------------------------------------------------------------
        BOOL-SIGNALS-ADDED
        =begin pod
        =head1 Methods
        =head2 new

        =head3 default, no options

        Create a new RAKU-CLASS-NAME object.

          multi method new ( )

        =head3 :native-object

        Create a RAKU-CLASS-NAME object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

          multi method new ( N-GObject :$native-object! )

        =head3 :build-id

        Create a RAKU-CLASS-NAME object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

          multi method new ( Str :$build-id! )

        =end pod

        #TM:0:new():inheriting
        #TM:1:new():
        #TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
        #TM:4:new(:build-id):Gnome::GObject::Object

        submethod BUILD ( *%options ) {

        BUILD-ADD-SIGNALS

          # prevent creating wrong native-objects
          if self.^name eq 'Gnome::LIBRARYMODULE' #`{{ or %options<LIBCLASSNAME> }} {

            # check if native object is set by a parent class
            if self.is-valid { }

            # check if common options are handled by some parent
            elsif %options<native-object>:exists { }
            elsif %options<build-id>:exists { }

            # process all other options
            else {
              my $no;
              if ? %options<___x___> {
                $no = %options<___x___>;
                $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
                #$no = _BASE-SUBNAME_new___x___($no);
              }

              #`{{ use this when the module is not made inheritable
              # check if there are unknown options
              elsif %options.elems {
                die X::Gnome.new(
                  :message(
                    'Unsupported, undefined, incomplete or wrongly typed options for ' ~
                    self.^name ~ ': ' ~ %options.keys.join(', ')
                  )
                );
              }
              }}

              #`{{ when there are no defaults use this
              # check if there are any options
              elsif %options.elems == 0 {
                die X::Gnome.new(:message('No options specified ' ~ self.^name));
              }
              }}

              #`{{ when there are defaults use this instead
              # create default object
              else {
                $no = _BASE-SUBNAME_new();
              }
              }}

              self.set-native-object($no);
            }

            # only after creating the native-object, the gtype is known
            self.set-class-info('LIBCLASSNAME');
          }
        }

        EOTEMPLATE
    }

    $template-text ~~ s:g/ 'RAKU-CLASS-NAME' /$*raku-class-name/;
    $template-text ~~ s:g/ 'LIBRARYMODULE' /{$*raku-lib-name}::{$*raku-class-name}/;
    $template-text ~~ s:g/ 'BASE-SUBNAME' /$*base-sub-name/;
    $template-text ~~ s:g/ 'LIBCLASSNAME' /$*lib-class-name/;
    $output-file.IO.spurt( $template-text, :append);

    note "add BUILD routine to $output-file";
  }
}

#-------------------------------------------------------------------------------
sub get-sub-doc ( Str:D $sub-name, Str:D $source-content --> List ) {

#  return ( '', '') unless $source-content;

  return ( '', []) unless $source-content ~~ m/ '/**' <[\s\*]>+ $sub-name/;

  $source-content ~~ m/ '/**' <[\s\*]>+ $sub-name ':' $<sub-doc> = [ .*? '*/' ] /;
  my Str $doc = ~($<sub-doc> // '');

  my Array $items-src-doc = [];
  my Bool $gather-items-doc = True;
  my Str ( $item, $sub-doc) = ( '', '');
  my Int $line-count = 0;
  for $doc.lines -> $line {

    if $line ~~ m/ ^ \s+ '* @' <alnum>+ ':' $<item-doc> = [ .* ] / {
      # check if there was some item. if so, save before set to new item
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
        $sub-doc ~= " ";
      }

      else {
        $sub-doc ~= "\n";
      }
    }

    $line-count++ if ?$sub-doc;
    last if $line-count > 100;
  }

  # in case there is no doc, we need to save the last item still
  if $gather-items-doc {
    $items-src-doc.push(primary-doc-changes($item));
  }

  # cleanup documentation of sub
  $sub-doc ~~ s/ 'Since:' \s*? \d+\.\d+ //;
#  $sub-doc ~~ s:g/^^ \s+ //;
#  $sub-doc ~~ s:g/ \s+ $$/\n/;
#  $sub-doc ~~ s:g/ <[\ \t]>+ / /;
  $sub-doc ~~ s/ \s* 'Returns:'/\n\nReturns:/;
#  $sub-doc ~~ s/ \n $//;

  $sub-doc ~~ s/^ \s+ //;
  $sub-doc ~~ s/ \s+ $//;
#  $sub-doc ~~ s:g/ \n\n\n* /\n\n/;
  $sub-doc ~~ s:g/ \n\n /[=====]/;
  $sub-doc ~~ s:g/ \s+ / /;
  $sub-doc ~~ s:g/ '[=====]' /\n\n/;

  ( primary-doc-changes($sub-doc), $items-src-doc )
}

#-------------------------------------------------------------------------------
# get the class title and class info from the source file
sub get-section ( Str:D $source-content --> List ) {

  return ( '', '', '') unless $source-content;

  $source-content ~~ m/ '/**' .*? SECTION ':' .*? '*/' /;
  return ( '', '', '') unless ?$/;

  my Str $section-doc = ~$/;

  # get short description and remove it from $section-doc
  $section-doc ~~ m:i/
      ^^ \s+ '*' \s+ '@Short_description:' \s* $<text> = [.*?] $$
  /;
  my Str $short-description = ~($<text>//'');
  $section-doc ~~ s:i/ ^^ \s+ '*' \s+ '@Short_description:' [.*?] \n //;


  # get see also and remove it from $section-doc
  $section-doc ~~ m:i/ ^^ \s+ '*' \s+ '@See_also:' \s* $<text> = [.*?] $$ /;
  my Str $see-also = ~($<text>//'');
  $section-doc ~~ s:i/ ^^ \s+ '*' \s+ '@See_also:' [.*?] \n //;


  # cleanup rest
  $section-doc ~~ s:i/ ^^ \s+ '*' \s+ 'SECTION:' [.*?] \n //;
  $section-doc ~~ s:i/ ^^ \s+ '*' \s+ '@Title:' [.*?] \n //;
  $section-doc = cleanup-source-doc($section-doc);
  $section-doc ~~ s:i/ ^^ '#' \s+ 'CSS' \s+ 'nodes'/\n=head2 Css Nodes\n/;
  $section-doc ~~ s:g:i/ ^^ '#' \s+ /\n=head2 /;
#note "doc 2: ", $section-doc;

  ( primary-doc-changes($section-doc),
    primary-doc-changes($short-description),
    (?$see-also ?? "=head2 See Also\n\n" ~ primary-doc-changes($see-also) !! '')
  )
}

#-------------------------------------------------------------------------------
sub get-signals ( Str:D $source-content is copy ) {

  return unless $source-content;

  my Array $items-src-doc;
  my Str $signal-name;
  my Str $signal-doc = '';
  my Hash $signal-classes = %();

  print "Find signals ";
  my Hash $signal-doc-entries = %();
  loop {
    print ".";
    $*OUT.flush;

    $items-src-doc = [];
    $signal-name = '';

    $source-content ~~ m/
      $<signal-doc> = [ '/**' \s+ '*' \s+ $*lib-class-name '::'  .*? '*/' ]
    /;

    # save doc and remove from source but stop if none left
    my Str $sdoc = ~($<signal-doc> // '');
#note "SDoc 0 $*lib-class-name: ", ?$sdoc;
    my Bool $has-doc = ($sdoc ~~ m/ '/**' / ?? True !! False);

    # possibly no documentation
    if $has-doc {
      $source-content ~~ s/$sdoc//;

      # get lib class name and remove line from source
      $sdoc ~~ m/
        ^^ \s+ '*' \s+ $*lib-class-name '::' $<signal-name> = [ [<alnum> || '-']+ ]
      /;
      $signal-name = ~($<signal-name> // '');
      $sdoc ~~ s/ ^^ \s+ '*' \s+ $*lib-class-name '::' $signal-name '::'? //;
#note "SDoc 1 ", $sdoc;
    }

    # get some more info from the function call
    $source-content ~~ m/
      'g_signal_new' '_class_handler'? \s* '('
      $<signal-args> = [
        [ <[A..Z]> '_('                     || # gtk sources
          'g_intern_static_string' \s* '('     # gdk sources
        ]
        '"' <-[\"]>+ '"' .*?
      ] ');'
    /;
#note "SDoc 2 ",  ~($<signal-args>//'-');

    # save and remove from source but stop if there isn't any left
    my Str $sig-args = ~($<signal-args>//'');
    if !$sig-args {
      $sdoc = '';
      last;
    }
    $source-content ~~
       s/ 'g_signal_new' '_class_handler'? \s* '(' $sig-args ');' //;

#note "sig args: ", $sig-args;
    # when there's no doc, signal name must be retrieved from function argument
    unless $signal-name {
      $sig-args ~~ m/ '"' $<signal-name> = [ <-[\"]>+ ] '"' /;
      $signal-name = ($<signal-name>//'').Str;
    }

#note "SA $signal-name: ", $sig-args;

    # start pod doc
    $signal-doc = Q:qq:to/EOSIG/;

      =comment -----------------------------------------------------------------------
      =comment #TS:0:$signal-name:
      =head3 $signal-name
      EOSIG

#    note "get signal $signal-name";

    # process g_signal_new arguments, remove commas from specific macro
    # by removing the complete argument list. it's not needed.
    $sig-args ~~ s/ 'G_STRUCT_OFFSET' \s* \( <-[\)]>+ \) /G_STRUCT_OFFSET/;
    my @args = ();
    for $sig-args.split(/ \s* ',' \s* /) -> $arg is copy {
#note "arg: '$arg'";
      @args.push($arg);
    }

#note "Args: ", @args[7..*-1];
    # get a return type
    my Str $return-type = '';
    given @args[7] {
      # most of the time it is a boolean ( == c int32)
      when 'G_TYPE_BOOLEAN' { $return-type = 'Int'; }
      when 'G_TYPE_INT' { $return-type = 'Int'; }
      when 'G_TYPE_UINT' { $return-type = 'Int'; }
      when 'G_TYPE_STRING' { $return-type = 'Str'; }
      when 'G_TYPE_NONE' { $return-type = ''; }
      when 'GTK_TYPE_TREE_ITER' { $return-type = 'N-GtkTreeIter'; }
      # show that there is something
      default { $return-type = "Unknown type @args[7]"; }
    }

    my Int $item-count = 0;

    # create proper variable name when not available from the doc
    my Str $iname = $*lib-class-name;
    $iname ~~ s:i/^ [ gtk || gdk || g ] //;
    $iname .= lc;
    $items-src-doc.push: %(
      :item-type<Gnome::GObject::Object>, :item-name($iname),
      :item-doc('')
    );

    my Array $signal-args = ['Gnome::GObject::Object'];
    my Int $arg-count = @args[8].Int;
    loop ( my $i = 0; $i < $arg-count; $i++ ) {

      my Str $arg-type = '';
      given @args[9 + $i] {
        when 'G_TYPE_BOOLEAN' { $arg-type = 'Int'; }
        when 'G_TYPE_INT' { $arg-type = 'Int'; }
        when 'G_TYPE_UINT' { $return-type = 'Int'; }
        when 'G_TYPE_LONG' { $arg-type = 'int64 #`{ use NativeCall }'; }
        when 'G_TYPE_FLOAT' { $arg-type = 'Num'; }
        when 'G_TYPE_DOUBLE' { $arg-type = 'num64 #`{ use NativeCall }'; }
        when 'G_TYPE_STRING' { $arg-type = 'Str'; }
        when 'G_TYPE_ERROR' { $arg-type = 'N-GError'; }

        when 'GTK_TYPE_OBJECT' { $arg-type = 'N-GObject #`{ is object }'; }
        when 'GTK_TYPE_WIDGET' { $arg-type = 'N-GObject #`{ is widget }'; }
        when 'GTK_TYPE_TEXT_ITER' {
          $arg-type = 'N-GObject #`{ native Gnome::Gtk3::TextIter }';
        }
        when 'GTK_TYPE_TREE_ITER' {
          $arg-type = 'N-GtkTreeIter #`{ native Gnome::Gtk3::TreeIter }';
        }

        when 'GDK_TYPE_DISPLAY' {
          $arg-type = 'N-GObject #`{ native Gnome::Gdk3::Display }';
        }
        when 'GDK_TYPE_DEVICE' {
          $arg-type = 'N-GObject #`{ native Gnome::Gdk3::Device }';
        }
        when 'GDK_TYPE_DEVICE_TOOL' {
          $arg-type = 'N-GObject #`{ native Gnome::Gdk3::DeviceTool }';
        }
        when 'GDK_TYPE_MONITOR' {
          $arg-type = 'N-GObject #`{ native Gnome::Gdk3::Monitor }';
        }
        when 'GDK_TYPE_SCREEN' {
          $arg-type = 'N-GObject #`{ native Gnome::Gdk3::Screen }';
        }
        when 'GDK_TYPE_SEAT' {
          $arg-type = 'N-GObject #`{ native Gnome::Gdk3::Seat }';
        }
        when 'GDK_TYPE_MODIFIER_TYPE' {
          $arg-type = 'GdkModifierType #`{ from Gnome::Gdk3::Window }';
        }
        default { $arg-type = "Unknown type @args[{9 + $i}]"; }
      }

      my Str $item-name = $arg-type.lc;
      $item-name ~~ s/ 'gnome::gtk3::' //;
      $items-src-doc.push: %(
        :item-type($arg-type), :$item-name,
        :item-doc('')
      );

#note "AT: $i, $arg-type";
      $signal-args.push: $arg-type;
    }

    # we know the number of extra arguments and signal name
    my Str $sig-class = "w$arg-count";
    $signal-classes{$sig-class} = [] unless $signal-classes{$sig-class}:exists;
    $signal-classes{$sig-class}.push: $signal-name;

    # get arguments for this signal handler
    my Str ( $item-doc, $item-name, $spart-doc) = ( '', '', '');
    my Bool $item-scan = True;
    #my Bool $first-arg = True;

    $item-count = 0;
    if $has-doc {
      $items-src-doc = [];
      for $sdoc.lines -> $line {
#note "L: $line";

        # argument doc start
        if $item-scan and $line ~~ m/^ \s* '*' \s+ '@' / {

          # push when 2nd arg is found
#note "ISD 0: $item-count, $item-name, $signal-args[$item-count]" if ?$item-name;
          $items-src-doc.push: %(
            :item-type($signal-args[$item-count++]), :$item-name, :$item-doc
          ) if ?$item-name;

          # get the info from the current line
          $line ~~ m/ '*' \s+ '@' $<item-name> = [<alnum>+] ':'
                      \s* $<item-doc> = [ .* ]
                    /;

          $item-name = ~($<item-name> // '');
          $item-doc = primary-doc-changes(~($<item-doc> // '')) ~ "\n";
#note "n, d: $item-name, $item-doc";
        }

        # continue previous argument doc
        elsif $item-scan and
              $line ~~ m/^ \s* '*' \s ** 2..* $<item-doc> = [ .* ] / {
          my Str $s = ~($<item-doc> // '');
          $item-doc ~= primary-doc-changes($s);
#note "d: $item-doc";
        }

        # on empty line after '*' start sub doc
        elsif $line ~~ m/^ \s* '*' \s* $/ {
          # push last arg
#note "ISD 1: $item-count, $item-name, $signal-args[$item-count]"
#if $item-scan and ?$item-name;
          $items-src-doc.push: %(
            :item-type($signal-args[$item-count]), :$item-name, :$item-doc
          ) if $item-scan and ?$item-name;

          $spart-doc ~= "\n";
          $item-scan = False;
        }

        # rest is sub doc
        elsif !$item-scan {
          # skip end of document
          next if $line ~~ m/ '*/' /;

          my Str $l = $line;
          $l ~~ s/^ \s* '*' \s* //;
          $spart-doc ~= $l ~ "\n";
        }
      }

      # when there is no sub doc, it might end a bit abdrupt
      #note "ISD 2: $item-count, $item-name, $signal-args[$item-count]"
      #if $item-scan and ?$item-name;

      $items-src-doc.push: %(
      :item-type($signal-args[$item-count]), :$item-name, :$item-doc
      ) if $item-scan and ?$item-name;

      $signal-doc ~= primary-doc-changes($spart-doc);
      $signal-doc ~~ s/^^ 'Since:' \s+ \d+ \. \d+ <-[\n]>* \n? //;
    }


    $signal-doc ~= "\n  method handler (\n";
    $item-count = 0;
    my Str $first-arg = '';
    for @$items-src-doc -> $idoc {
#note "IDoc: $item-count, ", $idoc;
      if $item-count == 0 {
        $first-arg =
          "Int :\$_handle_id,\n    $idoc<item-type> \:_widget\(\$$idoc<item-name>\)";
      }

      else {
        $signal-doc ~= "    {$idoc<item-type>//'-'} \$$idoc<item-name>,\n";
      }

      $item-count++;
    }

    $signal-doc ~= "    $first-arg,\n    \*\%user-options\n";
    $signal-doc ~= "    --> $return-type\n" if ?$return-type;
    $signal-doc ~= "  );\n\n";

    for @$items-src-doc -> $idoc {
      $signal-doc ~= "=item \$$idoc<item-name>; $idoc<item-doc>\n";
    }

    $signal-doc-entries{$signal-name} = $signal-doc;

#note "next signal";
  }
#note "last signal";
  print "\n";

  my Str $bool-signals-added = '';
  my Str $build-add-signals = '';
  if ?$signal-doc-entries {
#    $signal-doc = Q:q:to/EOSIGDOC/ ~ $signal-doc ~ "\n=end pod\n\n";
    note "add signal information to $output-file";
    $output-file.IO.spurt( Q:q:to/EOSIGDOC/, :append);

      #-------------------------------------------------------------------------------
      =begin pod
      =head1 Signals

      There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<connect-object()> directly from B<Gnome::GObject::Signal>.

      =head2 First method

      The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

        # handler method
        method mouse-event ( GdkEvent $event, :$widget ) { ... }

        # connect a signal on window object
        my Gnome::Gtk3::Window $w .= new( ... );
        $w.register-signal( self, 'mouse-event', 'button-press-event');

      =head2 Second method

        my Gnome::Gtk3::Window $w .= new( ... );
        my Callable $handler = sub (
          N-GObject $native, GdkEvent $event, OpaquePointer $data
        ) {
          ...
        }

        $w.connect-object( 'button-press-event', $handler);

      Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<connect-object()> are using the signatures of the handler routines to setup the native call interface.

      =head2 Supported signals

      EOSIGDOC

    for $signal-doc-entries.keys.sort -> $signal {
      note "save signal $signal";
      $output-file.IO.spurt( $signal-doc-entries{$signal}, :append);
    }

    $output-file.IO.spurt( "\n=end pod\n\n", :append);



    # create the class string to substitute in the source
    my Str $sig-class-str = '';
    for $signal-classes.kv -> $class, $signals {
      $sig-class-str ~= "\:$class\<";
      $sig-class-str ~= $signals.join(' ');
      $sig-class-str ~= '>, ';
    }

    $bool-signals-added = Q:q:to/EOBOOL/;
      my Bool $signals-added = False;
      #-------------------------------------------------------------------------------
      EOBOOL

    if $class-is-role {
      $build-add-signals = Q:q:to/EOBUILD/;
          # add signal info in the form of w*<signal-name>.
          self.add-signal-types( $?CLASS.^name,
            SIG_CLASS_STR
          );
        EOBUILD
        $build-add-signals ~~ s/SIG_CLASS_STR/$sig-class-str/;
    }

    else {
      $build-add-signals = Q:q:to/EOBUILD/;
          # add signal info in the form of w*<signal-name>.
          unless $signals-added {
            $signals-added = self.add-signal-types( $?CLASS.^name,
              SIG_CLASS_STR
            );

            # signals from interfaces
            #_add_..._signal_types($?CLASS.^name);
          }
        EOBUILD
        $build-add-signals ~~ s/SIG_CLASS_STR/$sig-class-str/;
    }

    # and append signal data to result module
    #$output-file.IO.spurt( $signal-doc, :append);
  }

  # load the module for substitutions
  my Str $module = $output-file.IO.slurp;

  # substitute
  $module ~~ s/ 'BOOL-SIGNALS-ADDED' /$bool-signals-added/;
  $module ~~ s/ 'BUILD-ADD-SIGNALS' /$build-add-signals/;

  # rewrite
  $output-file.IO.spurt($module);
#  note "add signal information to $output-file";
}

#-------------------------------------------------------------------------------
sub get-properties ( Str:D $source-content is copy ) {

  return unless $source-content;

  my Str $property-name;
  my Str $property-doc;

  print "Find properties ";
  my Hash $property-doc-entries = %();
  loop {
    $property-doc = '';
    print ".";
    $*OUT.flush;

    $property-name = '';

#`{{
    $source-content ~~ m/
      $<property-doc> = [
          [ '/**'                           # start c-comment block
            \s+ '*' \s+ [<alnum>||'-']+     # first line has Gtk class name
           ':' [<alnum>||'-']+ ':'          # and a :property name:
            [^^ \s+ '*' <!before '/'> .*? $$ ]*    # anything else but '*/'
            \s* '*/'                        # till the end of c-comment
          ]?                                # sometimes there's no comment block
          \s+ [ 'g_object_interface_install_property' .*? ||
                                            # sometimes a call for interfaces
            'props[' <-[\]]>+ ']' \s* '=' \s*
                                            # sometimes there's an array def
          ]                             # anything else
        'g_param_spec_'                     # till prop spec starts
        .*? ');'                            # till the spec ends
      ]
    /;
}}
    $source-content ~~ m/
      $<property-doc> = [
        [ '/**'                           # start c-comment block
          \s+ '*' \s+ [<alnum>||'-']+     # first line has Gtk class name
         ':' [<alnum>||'-']+ ':'          # and a :property name:
          .*? '*/'                        # till the end of c-comment
        ]?                                # sometimes there's no comment block
                                          # optional comment block
        \s+ [ 'g_object_interface_install_property' .*? ||
                                          # sometimes a call for interfaces
         'g_object_class_install_property' .*? ||
                                          # sometimes a call for classes
          <alnum>*? 'props[' <-[\]]>+ ']' \s* '=' \s*
                                          # sometimes there's an array def
        ]                                 # anything else
        'g_param_spec_'                   # till prop spec starts
        .*? ');'                          # till the spec ends
      ]
    /;

    my Str $sdoc = ~($<property-doc> // '');
#note "sdoc: ", ?$sdoc;
    last unless ?$sdoc;

    # remove from source
    $source-content ~~ s/$sdoc//;

    # skip deprecated properties
    next if $sdoc ~~ m/ '*' \s+ 'Deprecated:' /;

    my Bool $has-doc = ($sdoc ~~ m/ '/**' / ?? True !! False);
#note "\nHD: $has-doc: ", $sdoc;

    if $has-doc {
      $sdoc ~~ m/
        ^^ \s+ '*' \s+ $*lib-class-name ':'
        $<prop-name> = [ <-[:]> [<alnum> || '-']+ ]
      /;
      $property-name = ~($<prop-name> // '');
    }
# $property-name must come from call to param_spec

# note "sdoc 2: $sdoc";

    # modify and cleanup
    $sdoc ~~ s/ ^^ \s+ '*' \s+ <alnum>+ ':' [ <alnum> || '-' ]+ ':' \n //
      if $has-doc;

    $sdoc ~~ m/ ^^ \s+ 'g_param_spec_' $<prop-type> = [ <alnum>+ ] \s* '(' /;
    my Str $spec-type = ~($<prop-type> // '' );
    my Str $prop-type = 'G_TYPE_' ~ $spec-type.uc;

    my Str $prop-args = $sdoc;
    my Str ( $prop-name, $prop-nick, $prop-blurp);

    if $has-doc {
#      $prop-name = $property-name;
      $sdoc = primary-doc-changes($sdoc);
      $sdoc = cleanup-source-doc($sdoc);
    }

    else {
      $sdoc = '';
    }


    $prop-args ~~ s/ .*? 'g_param_spec_' $spec-type \s* '(' //;
    $prop-args ~~ s/ '));' //;

    # process arguments. first rename commas in string into _COMMA_
    my Bool $in-string = False;
    my Str $temp-prop-args = $prop-args;
    $prop-args = '';
    for $temp-prop-args.split('')[1..*-2] -> $c {
#note "C: '$c'";
      if $c eq '"' {
        $in-string = !$in-string;
        $prop-args ~= '"';
        next;
      }

      if $in-string and $c eq ',' {
        $prop-args ~= '_COMMA_';
      }

      else {
        $prop-args ~= $c;
      }
    }
#note $prop-args;

    my @args = ();
    for $prop-args.split(/ \s* ',' \s* /) -> $arg is copy {
      $arg ~~ s/ '_COMMA_' /,/;
      $arg ~~ s/ 'P_(' //;
      $arg ~~ s/ ')' //;
      $arg ~~ s:g/ \" \s+ \" //;
      $arg ~~ s:g/ \" //;
      @args.push($arg);
    }
#note "args: ", @args.join(', ');

    $prop-name = @args[0];
    $prop-nick = @args[1];
    $prop-blurp = $has-doc ?? $sdoc !! @args[2];
#    $prop-blurp ~~ s/ \s* \* \s+ Since ':' \s+ \d+ \. \d+ \s*//;
#note "blurp: $prop-blurp";

    my Str $flags;
    my Str $gtype-string;
    my $prop-default;
    my Str $prop-doc = '';
    given $spec-type {

      when 'boolean' {
        $prop-default = @args[3] ~~ 'TRUE' ?? True !! False;
        $flags = @args[4];

        $prop-doc = Q:qq:to/EOP/;
          $prop-blurp

          Default value: $prop-default
          EOP
      }

      when 'string' {
        $prop-default = @args[3] ~~ 'NULL' ?? 'Any' !! @args[3];
        $flags = @args[4];

        $prop-doc = Q:qq:to/EOP/;
          $prop-blurp

          Default value: $prop-default
          EOP
      }

      when 'enum' {
        $gtype-string = @args[3];
        $prop-default = @args[4] ~~ 'TRUE' ?? True !! False;
        $flags = @args[5];

        $prop-doc = Q:qq:to/EOP/;
          $prop-blurp

          Default value: $prop-default
          EOP
      }

      when 'object' {
        $gtype-string = @args[3];
        $flags = @args[4];

        $prop-doc = Q:qq:to/EOP/;
          $prop-blurp

          Widget type: $gtype-string
          EOP
      }

      when '' {
      }

    }

    if $has-doc {
      $sdoc ~= "Widget type: $gtype-string\n" if ?$gtype-string;
#      $sdoc ~= "Flags: $flags\n" if ?$flags;
    }

    else {
      $sdoc = $prop-doc;
      $sdoc = primary-doc-changes($sdoc);
      $sdoc = cleanup-source-doc($sdoc);
    }

    $sdoc ~~ s:g/\n\n/\n/;;


#note "sdoc 3: ", $sdoc if $has-doc;

    $sdoc ~~ s/ \* \s* Since ':' \s* \d+\.\d+ \s* \*? //;
    $property-doc ~= Q:qq:to/EOHEADER/;

      =comment -----------------------------------------------------------------------
      =comment #TP:0:$prop-name:
      =head3 $prop-nick: $prop-name

      $sdoc
      The B<Gnome::GObject::Value> type of property I<$prop-name> is C<$prop-type>.
      EOHEADER

    $property-doc-entries{$prop-name} = $property-doc;
#note "end prop";
  }
#note "end of all props";
  print "\n";

  if ?$property-doc-entries {
    note "add property information to $output-file";
    $output-file.IO.spurt( Q:to/EODOC/, :append);

      #-------------------------------------------------------------------------------
      =begin pod
      =head1 Properties

      An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

        my Gnome::Gtk3::Label $label .= new;
        my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
        $label.get-property( 'label', $gv);
        $gv.set-string('my text label');

      =head2 Supported properties
      EODOC

    for $property-doc-entries.keys.sort -> $property {
      note "save property $property";
      $output-file.IO.spurt( $property-doc-entries{$property}, :append);
    }

    $output-file.IO.spurt( "=end pod\n", :append);
  }

#  $output-file.IO.spurt( $property-doc, :append);
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

      elsif $line ~~ m/ ^ \s+ '*' \s* 'Since:' .* $ / {
        # ignore
      }

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
  note "add type information to $output-file";
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
    my Str ( $entry-type, $raku-entry-type);
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
        $struct-name = 'N-' ~ ~($<struct-name> // '');

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

      elsif $line ~~ m/ ^ \s+ '*' \s* 'Since:' .* $ / {
        # ignore
      }

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
        ( $s, $entry-type, $raku-entry-type, $type-is-class) =
          get-type( $s, :!attr);

        # entry type Str must be converted to str
        $entry-type ~~ s/Str/str/;

        # if there is a comma separated list then split vars up
        if $s ~~ m/ ',' / {
          my @varlist = $s.split( / \s* ',' \s* /);
          for @varlist -> $var {
            $struct-spec ~= "  has $entry-type \$.$var;\n";
            $items-doc ~~ s/ 'item ___' $var /item $raku-entry-type \$.$var/;
          }
        }

        # $s is holding a single var
        else {
          $struct-spec ~= "  has $entry-type \$.$s;\n";
  #note "check for 'item ___$s'";
          $items-doc ~~ s/ 'item ___' $s /item $raku-entry-type \$.$s/;
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
  note "add structure information to $output-file";
}

#-------------------------------------------------------------------------------
sub cleanup-source-doc ( Str:D $text is copy --> Str ) {

  # remove property and signal line
  $text ~~ s/ ^^ \s+ '*' \s+ $*lib-class-name ':'+ .*? \n //;
#  $text ~~ s/ ^^ \s+ '*' \s+ $*lib-class-name ':' .*? \n //;

  $text ~~ s/ ^^ '/**' .*? \n //;                       # Doc start
  $text ~~ s/ \s* '*/' .* $ //;                         # Doc end
  $text ~~ s/ ^^ \s* '*'? \s* 'Since:' \d+\.\d+ \n //;  # Since: version
#  $text ~~ s/ ^^ \s+ '*' \s+ Deprecated: .*? \n //;    # Deprecated: version
#  $text ~~ s/ ^^ \s+ '*' \s+ Stability: .*? \n //;     # Stability: status
  $text ~~ s:g/ ^^ \s+ '*' \s+ '-' \s? (.*?) \n /=item $/[0]/; # doc star + dash
  $text ~~ s:g/ ^^ \s+ '*' ' '? (.*?) \n /$/[0] \n/;    # doc star + doc
  $text ~~ s:g/ ^^ \s+ '*' \s*? \n /\n/;                # doc star + empty
#  $text ~~ s:g/ ^^ \s* \n //;
#  $text ~~ s:g/ \n / /;

#  $text ~ "\n\n"
  $text
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
# change;
#   #class::signal to I<signal>
#   #class:property to I<property>
#   #class to B<Gnome::xyz::class>
sub podding-class ( Str:D $text is copy --> Str ) {

  loop {
    # check for property spec with classname in doc
    $text ~~ m/ '#' (<alnum>+) ':' ([<alnum> || '-']+) /;
    my Str $oct = ~($/[1] // '');
    last unless ?$oct;

    $text ~~ s/ '#' (<alnum>+) ':' [<alnum> || '-']+ / I\<$oct\>/;
  }

  loop {
    # check for signal spec with classname in doc
    $text ~~ m/ '#' (<alnum>+) '::' ([<alnum> || '-']+) /;
    my Str $oct = ~($/[1] // '');
    last unless ?$oct;

    $text ~~ s/ '#' (<alnum>+) '::' [<alnum> || '-']+ / I\<$oct\>/;
  }

  loop {
    # check for class specs
    $text ~~ m/ '#' (<alnum>+) /;
    my Str $oct = ~($/[0] // '');
    last unless ?$oct;

    my Str $part = $oct;

    $oct ~~ s/^ ['Gtk' || 'Gdk' || 'G'] ( <alnum>+ )
             /Gnome::$*raku-lib-name\:\:$/[0]/;

    # replace changed part in text
    $text ~~ s/ '#' $part /B\<$oct\>/;
  }

  # convert a few without leading octagon (#)
  #$text ~~ s:g/ <!after '%' > [ 'Gtk' || 'Gdk' || 'G'] (\D <alnum>+)
  #            /B<Gnome::$*raku-lib-name\:\:$/[0]>/;

  $text
}


#-------------------------------------------------------------------------------
# change any :signal to I<signal>
sub podding-signal ( Str:D $text is copy --> Str ) {

  loop {
    last unless $text ~~ m/ \s '::' [<alnum> || '-']+ /;
    $text ~~ s/ \s '::' ([<alnum> || '-']+) / I<$/[0]>/;
  }

  $text
}

#-------------------------------------------------------------------------------
# change any :property to I<property>
sub podding-property ( Str:D $text is copy --> Str ) {

  loop {
    last unless $text ~~ m/ \s ':' [<alnum> || '-']+ /;
    $text ~~ s/ \s ':' ([<alnum> || '-']+) / I<$/[0]>/;
  }

  $text
}

#-------------------------------------------------------------------------------
# change any function() to C<function()>
sub podding-function ( Str:D $text is copy --> Str ) {

  # change any function() to C<function()>. first change to [[function]] to
  # prevent nested substitutions.
  $text ~~ s:g/ ( <[\w\d\-\_]>+ ) \s* '()' /\[\[$/[0]\]\]/;
  $text ~~ s/ $*base-sub-name '_' //;
  $text ~~ s:g/ '_' /-/;
  $text ~~ s:g/ '[[' ( <[\w\d\-\_]>+ )']]' /C<$/[0]\()>/;

  $text
}

#-------------------------------------------------------------------------------
# change any %type to C<type>
sub modify-percent-types ( Str:D $text is copy --> Str ) {
  $text ~~ s:g/ '%TRUE' /C<True>/;
  $text ~~ s:g/ '%FALSE' /C<False>/;
  $text ~~ s:g/ '%NULL' /C<undefined>/;
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

#-------------------------------------------------------------------------------
sub generate-test ( ) {

  # create var name named after classname. E.g. TextBuffer -> $tb.
  my Str $m = '$' ~ $*raku-class-name.comb(/<[A..Z]>/).join.lc;
  my Str $class = [~] 'Gnome::', $*raku-lib-name, '::', $*raku-class-name;
  my Str $test-content = Q:q:s:b:to/EOTEST/;
    use v6;
    use NativeCall;
    use Test;

    use $class;

    #use Gnome::N::X;
    #Gnome::N::debug(:on);

    #-------------------------------------------------------------------------------
    my $class $m;
    #-------------------------------------------------------------------------------
    subtest 'ISA test', {
      $m .= new;
      isa-ok $m, $class, '.new()';
    }

    #-------------------------------------------------------------------------------
    done-testing;

    =finish


    #-------------------------------------------------------------------------------
    # set environment variable 'raku-test-all' if rest must be tested too.
    unless %*ENV<raku_test_all>:exists {
      done-testing;
      exit;
    }

    #-------------------------------------------------------------------------------
    subtest 'Manipulations', {
    }

    #-------------------------------------------------------------------------------
    subtest 'Inherit $class', {
      class MyClass is $class {
        method new ( |c ) {
          self.bless( :$*lib-class-name, |c);
        }

        submethod BUILD ( *%options ) {

        }
      }

      my MyClass \$mgc .= new;
      isa-ok \$mgc, $class, '.new()';
    }

    #-------------------------------------------------------------------------------
    subtest 'Interface ...', {
    }

    #-------------------------------------------------------------------------------
    subtest 'Properties ...', {
      use Gnome::GObject::Value;
      use Gnome::GObject::Type;

      #my $class $m .= new;

      sub test-property (
        \$type, Str \$prop, Str \$routine, \$value,
        Bool :\$approx = False, Bool :\$is-local = False
      ) {
        my Gnome::GObject::Value \$gv .= new\(:init(\$type));
        $m.get-property\( \$prop, \$gv);
        my \$gv-value = \$gv."\$routine"\();
        if \$approx {
          is-approx \$gv-value, \$value,
            "property \$prop, value: " ~ \$gv-value;
        }

        # dependency on local settings might result in different values
        elsif \$is-local {
          if \$gv-value ~~ /\$value/ {
            like \$gv-value, /\$value/, "property \$prop, value: " ~ \$gv-value;
          }

          else {
            ok 1, "property \$prop, value: " ~ \$gv-value;
          }
        }

        else {
          is \$gv-value, \$value,
            "property \$prop, value: " ~ \$gv-value;
        }
        \$gv.clear-object;
      }

      # example calls
      #test-property\( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', 0);
      #test-property\( G_TYPE_STRING, 'label', 'get-string', '...');
      #test-property\( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);
    }

    #-------------------------------------------------------------------------------
    subtest 'Themes ...', {
    }

    #-------------------------------------------------------------------------------
    subtest 'Signals ...', {
      use Gnome::Gtk3::Main;
      use Gnome::N::GlibToRakuTypes;

      my Gnome::Gtk3::Main \$main .= new;

      class SignalHandlers {
        has Bool \$!signal-processed = False;

        method ... (
          'any-args',
          $class :\$_widget, gulong :\$_handler-id
          # --> ...
        ) {

          isa-ok \$_widget, $class;
          \$!signal-processed = True;
        }

        method signal-emitter ( $class :\$widget --> Str ) {

          while \$main.gtk-events-pending\() { \$main.iteration-do\(False); }

          \$widget.emit-by-name\(
            'signal',
          #  'any-args',
          #  :return-type(int32),
          #  :parameters([int32,])
          );
          is \$!signal-processed, True, '\\'...\\' signal processed';

          while \$main.gtk-events-pending\() { \$main.iteration-do\(False); }

          #\$!signal-processed = False;
          #\$widget.emit-by-name\(
          #  'signal',
          #  'any-args',
          #  :return-type(int32),
          #  :parameters([int32,])
          #);
          #is \$!signal-processed, True, '\\'...\\' signal processed';

          while \$main.gtk-events-pending\() { \$main.iteration-do\(False); }
          sleep\(0.4);
          \$main.gtk-main-quit;

          'done'
        }
      }

      my $class $m .= new;

      #my Gnome::Gtk3::Window \$w .= new;
      #\$w.add(\$m);

      my SignalHandlers \$sh .= new;
      $m.register-signal\( \$sh, 'method', 'signal');

      my Promise \$p = $m.start-thread\(
        \$sh, 'signal-emitter',
        # :!new-context,
        # :start-time(now + 1)
      );

      is \$main.gtk-main-level, 0, "loop level 0";
      \$main.gtk-main;
      #is \$main.gtk-main-level, 0, "loop level is 0 again";

      is \$p.result, 'done', 'emitter finished';
    }

    EOTEST

  "xt/NewModules/$*raku-class-name.t".IO.spurt($test-content);
  note "generate tests in xt/NewModules/$*raku-class-name.t";
}
