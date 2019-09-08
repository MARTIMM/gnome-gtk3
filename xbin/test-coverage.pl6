#!/usr/bin/env perl6

use v6;
use JSON::Fast;

#-------------------------------------------------------------------------------
sub MAIN ( *@modules ) {

  # load the coverage admin data.
  my Str $test-coverage-config = "$*HOME/Languages/Perl6/Projects/perl6-gnome-gtk3/docs/_data/testCoverage.json";
  my %test-coverage = %();
  %test-coverage = from-json($test-coverage-config.IO.slurp // '')
    if $test-coverage-config.IO.r;

  my @m = lazy gather find-modules(|@modules);
  for @m -> Str $module {

    # get content and process it.
    my Str $content = $module.IO.slurp;
    my Bool $load-tested = load-coverage($content);
    my ( $subs-total, $subs-tested, $sub-hash) = sub-coverage($content);
    my ( $sigs-total, $sigs-tested, $sig-hash) = signal-coverage($content);
    my ( $props-total, $props-tested, $prop-hash) = prop-coverage($content);
    my ( $types-total, $types-tested, $type-hash) = type-coverage($content);

    my Rat $sub-coverage = $subs-total
           ?? 100.0 * $subs-tested/$subs-total
           !! 0.0;

    my Rat $sig-coverage = $sigs-total
           ?? 100.0 * $sigs-tested/$sigs-total
           !! 0.0;

    my Rat $prop-coverage = $props-total
           ?? 100.0 * $props-tested/$props-total
           !! 0.0;

    my Rat $type-coverage = $types-total
           ?? 100.0 * $types-tested/$types-total
           !! 0.0;

    note Q:qq:to/EOREPORT/;

      Module $module
        Loading tested: $load-tested
        Nbr subs $subs-total, subs tested $subs-tested, coverage: $sub-coverage.fmt("%.2f")
        Nbr signals $sigs-total, signals tested $sigs-tested, coverage: $sig-coverage.fmt("%.2f")
        Nbr properties $props-total, properties tested $props-tested, coverage: $prop-coverage.fmt("%.2f")
        Nbr types $types-total, types tested $types-tested, coverage: $type-coverage.fmt("%.2f")
      EOREPORT

    # setup structure for this module
    my Str $module-name = $module.IO.basename();
    my Str $ext = $module.IO.extension();
    $module-name ~~ s/ \. $ext /.md/;

    # create a path used on the github site
    my Str $path;
    given $module {
      when /Glade/ { $path = "content-docs/reference/Glade/$module-name"; }
      when /Gtk3/ { $path = "content-docs/reference/Gtk3/$module-name"; }
      when /Gdk3/ { $path = "content-docs/reference/Gdk3/$module-name"; }
      when /GObject/ { $path = "content-docs/reference/GObject/$module-name"; }
      when /Glib/ { $path = "content-docs/reference/Glib/$module-name"; }
      when /N/ { $path = "content-docs/reference/Native/$module-name"; }
    }

    %test-coverage{$path}<unit-load> = { :$load-tested };

    %test-coverage{$path}<routines> = {
      :$subs-total, :$subs-tested, :coverage($sub-coverage.fmt("%.2f")),
      :subs-data($sub-hash)
    };

    %test-coverage{$path}<signals> = {
      :$sigs-total, :$sigs-tested, :coverage($sig-coverage.fmt("%.2f")),
      :sigs-data($sig-hash)
    } if $sigs-total;

    %test-coverage{$path}<properties> = {
      :$props-total, :$props-tested, :coverage($prop-coverage.fmt("%.2f")),
      :props-data($prop-hash)
    } if $props-total;

    %test-coverage{$path}<types> = {
      :$types-total, :$types-tested, :coverage($type-coverage.fmt("%.2f")),
      :types-data($type-hash)
    } if $types-total;
  }

  $test-coverage-config.IO.spurt(to-json(%test-coverage));
}

#-------------------------------------------------------------------------------
# find all perl6 modules from command line or recursivly from dirs
sub find-modules ( *@modules ) {
  for @modules -> Str $m {
    if $m.IO.d {
      next if $m ~~ m/ '.git' || '.precomp' /;
      for dir($m) -> $f {
        find-modules($f.Str);
      }
    }

    # check if module exists
    elsif $m.IO.r and $m ~~ m/ \. [ pm || pl ] 6? $/ {
      take $m.Str;
    }

    else {
      note "$m is not a perl6 module";
    }
  }
}

#-------------------------------------------------------------------------------
sub signal-coverage( Str:D $content --> List ) {
  my Hash $sig-cover = {};
  my Int $sigs-tested = 0;

  # search for special notes like '#TS:sts:sig-name'
  $content ~~ m:g/^^ '=comment #TS:' [<[+-]> || \d] ':' [<alnum> || '-']+ /;
  my List $results = $/[*];
  for @$results -> $r {
    my Str $header = ~$r;
    $header ~~ m/
      '#TS:'
      $<state> = ([<[+-]> || \d])
      ':'
      $<name> = ([<alnum> || '-']+)
    /;

    my Str $name = ~$/<name>;

    my $state = ~$/<state>;
    $state = 0 if $state eq '-';
    $state = 1 if $state eq '+';
    $state .= Int;  # convert to int for all other digit characters
    $sigs-tested++ if $state > 0;
    $sig-cover{$name} = $state;
  }

  # return total nbr of subs/methods, nbr tested and data
  return ( $sig-cover.elems, $sigs-tested, $sig-cover);
}

#-------------------------------------------------------------------------------
sub prop-coverage( Str:D $content --> List ) {
  my Hash $prop-cover = {};
  my Int $props-tested = 0;

  # search for special notes like '#TP:sts:sig-name'
  $content ~~ m:g/^^ '=comment #TP:' [<[+-]> || \d] ':' [<alnum> || '-']+ /;
  my List $results = $/[*];
  for @$results -> $r {
    my Str $header = ~$r;
    $header ~~ m/
      '#TP:'
      $<state> = ([<[+-]> || \d])
      ':'
      $<name> = ([<alnum> || '-']+)
    /;

    my Str $name = ~$/<name>;

    my $state = ~$/<state>;
    $state = 0 if $state eq '-';
    $state = 1 if $state eq '+';
    $state .= Int;  # convert to int for all other digit characters
    $props-tested++ if $state > 0;
    $prop-cover{$name} = $state;
  }

  # return total nbr of subs/methods, nbr tested and data
  return ( $prop-cover.elems, $props-tested, $prop-cover);
}

#-------------------------------------------------------------------------------
sub type-coverage( Str:D $content --> List ) {
  my Hash $type-cover = {};
  my Int $types-tested = 0;

  # search for special notes like '#TT:sts:sig-name' (#TE for enums)
  $content ~~ m:g/^^ '#T' <[TE]> ':' [<[+-]> || \d] ':' [<alnum> || '-']+ /;
  my List $results = $/[*];
  for @$results -> $r {
    my Str $header = ~$r;
    $header ~~ m/
      '#T' <[TE]> ':'
      $<state> = ([<[+-]> || \d])
      ':'
      $<name> = ([<alnum> || '-']+)
    /;

    my Str $name = ~$/<name>;

    my $state = ~$/<state>;
    $state = 0 if $state eq '-';
    $state = 1 if $state eq '+';
    $state .= Int;  # convert to int for all other digit characters
    $types-tested++ if $state > 0;
    $type-cover{$name} = $state;
  }

  # return total nbr of subs/methods, nbr tested and data
  return ( $type-cover.elems, $types-tested, $type-cover);
}

#-------------------------------------------------------------------------------
sub load-coverage( Str:D $content --> Bool ) {
  my Bool $load-tested = False;

  # search for special notes like '#TL:sts:sig-name'
  $content ~~ m/^^ '#TL:' [<[+-]> || \d] ':' [<alnum> || '-']+ /;
  my Str $header = ~($/ || '');
  return $load-tested unless ?$header;
  $header ~~ m/
    '#TL:'
    $<state> = ([<[+-]> || \d])
    ':'
    $<name> = ([<alnum> || '-']+)
  /;

  my Str $name = ~$/<name>;

  my $state = ~$/<state>;
  $state = 0 if $state eq '-';
  $state = 1 if $state eq '+';
  $state .= Int;  # convert to int for all other digit characters
  $load-tested = True if $state > 0;

  # return load status
  return $load-tested;
}

#-------------------------------------------------------------------------------
sub sub-coverage( Str:D $new-content --> List ) {
  my Hash $sub-cover = {};
  my Int $subs-tested = 0;

  # remove all pod sections first
  my Str $content = '';
  my Bool $in-pod = False;
  my Bool $in-comment = False;
  for $new-content.lines -> $line {
    if $line ~~ m/ ^ '=' begin \s* pod / {
      $in-pod = True;
      next;
    }

    elsif $line ~~ m/ ^ '=' finish / {
      last;
    }

    elsif $line ~~ m/ ^ [ '#`{{' || '#`[[' ] / {
      $in-comment = True;
      next;
    }

    $content ~= $line ~ "\n" unless $in-pod || $in-comment;

    if $line ~~ m/^ '=' end \s* pod / {
      $in-pod = False;
      next;
    }

    elsif $line ~~ m/^ [ '}}' || ']]' ] \s* $ / {
      $in-comment = False;
      next;
    }
  }

  # search for the (multi) sub/method names real or in pod
  $content ~~ m:g/^^ \s* [ sub || method ] \s* [<alnum> || '-']+ \s* '(' /;
  my List $results = $/[*];
  for @$results -> $r {
    my Str $header = ~$r;

    # get sub/method name
    $header ~~ m/[ sub || method ] \s* $<name> = ([<alnum> || '-']+)/;
    my Str $name = ~$/<name>;

    # skip some subs/methods
    next if $name ~~ m/^
      [ '_'             # hidden native subs
        || _fallback    # used to find subs
        || FALLBACK     # starter to call _fallback
        || 'CALL-ME'    # used to get native objects
      ]
    /;

    # assume that no tests are done on this sub/method (0)
    $sub-cover{$name} = 0 unless $sub-cover{$name};
  }

  # search for special notes like '#TM:sts:sub-name'
  $content ~~ m:g/^^ '#TM:' [<[+-]> || \d] ':' [<alnum> || '-']+ /;
  $results = $/[*];
  for @$results -> $r {
    my Str $header = ~$r;
    $header ~~ m/
      '#TM:'
      $<state> = ([<[+-]> || \d])
      ':'
      $<name> = ([<alnum> || '-']+)
    /;

    my Str $name = ~$/<name>;

    my $state = ~$/<state>;
    $state = 0 if $state eq '-';
    $state = 1 if $state eq '+';
    $state .= Int;  # convert to int for all other digit characters
    $subs-tested++ if $state > 0;
    $sub-cover{$name} = $state;
  }

  # return total nbr of subs/methods, nbr tested and data, nbr of tested subs
  # can be larger when multi's are seperately tested.
  return ( max( $sub-cover.elems, $subs-tested), $subs-tested, $sub-cover);
}
