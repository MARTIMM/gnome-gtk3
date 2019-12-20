#!/usr/bin/env raku

use Gui;
use SkimFile;

sub MAIN ( Str $filename?, Str :$project-dir = $*CWD.Str ) {

  my Gui $gui .= new;

  if ?$filename and "$project-dir/$filename".IO.r {
    my SkimFile $sf .= new( :file-path("$project-dir/$filename"));
    $gui.add-file-data( $project-dir, $filename, $sf.mark-texts);
  }

  $gui.activate;
}
