#!/usr/bin/env -S raku -Ilib

#use v6;
use lib '/home/marcel/Languages/Perl6/Projects/perl6-gnome-gtk3/lib';
use Gui;
use SkimFile;

sub MAIN ( Str $test-file, Str :$project = $*CWD.Str ) {

  my SkimFile $sf .= new( :root-to-file($test-file), :root($project));
  my Gui $gui .= new;

  $gui.add-file-data( $sf.root-basename, $test-file, $sf.todo-texts);

  $gui.activate;
}
