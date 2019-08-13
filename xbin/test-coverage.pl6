#!/usr/bin/env perl6

use v6;
use JSON::Fast;

#-------------------------------------------------------------------------------
sub MAIN ( *@module ) {

  # load the coverage admin data.
  my Str $test-coverage-config = "$*HOME/Languages/Perl6/Projects/perl6-gnome-gtk3/docs/_data/testCoverage.json";
  my %test-coverage = %();
  %test-coverage = from-json($test-coverage-config.IO.slurp // '')
    if $test-coverage-config.IO.r;

  for @module -> Str $module {

    # check if module exists
    unless $module.IO.r {
      note "File $module not found";
      next;
    }

    # get content and process it
    my Str $content = $module.IO.slurp;
    my ( $subs-total, $subs-tested, $sub-hash) = sub-coverage($content);

    my Rat $coverage = $subs-total ?? 100.0 * $subs-tested/$subs-total !! 0.0;
    note "$module $subs-total, $subs-tested, coverage: $coverage";

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
      when /Native/ { $path = "content-docs/reference/Native/$module-name"; }
    }

    %test-coverage{$path}<routines> = {
      :$subs-total, :$subs-tested, :coverage($coverage.fmt("%.2f"));
#      :data($sub-hash)
    };
  }

  $test-coverage-config.IO.spurt(to-json(%test-coverage));
}

#-------------------------------------------------------------------------------
sub sub-coverage( Str:D $content ) {
  my Hash $sub-cover = {};
  my Int ( $subs-total, $subs-tested) = ( 0, 0);

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
        || handler      # only in pod docs as an example
        || fallback     # used to find subs
        || FALLBACK     # starter to call fallback
        || 'CALL-ME'    # used to get native objects
      ]
    /;

#note $name unless $sub-cover{$name}:exists;
    # assume that no tests are done on this sub/method (0)
    $sub-cover{$name} = 0 unless $sub-cover{$name};
  }

  # get total nbr of subs/methods
  $subs-total = $sub-cover.elems;

  # search for special notes like '#TM:+:gtk_window_set_has_user_ref_count'
  $content ~~ m:g/^^ '#TM:' ['+' || <[1..9]>] ':' [<alnum> || '-']+ /;
  $results = $/[*];
  for @$results -> $r {
    my Str $header = ~$r;
    $header ~~ m/
      '#TM:'
      $<state> = (['+' || <[1..9]>])
      ':'
      $<name> = ([<alnum> || '-']+)
    /;

    my Str $name = ~$/<name>;

    my Str $state = ~$/<state>;
    $state = '1' if $state eq '+';
    $subs-tested++ if $state ne '0';
    $sub-cover{$name} = $state.Int;

#note "$name, $state";
  }


  return ( $subs-total, $subs-tested, $sub-cover);
}
