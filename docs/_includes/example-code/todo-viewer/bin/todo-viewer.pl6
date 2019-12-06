
use v6;
use Gui;
use SkimFile;

sub MAIN ( Str $test-file, Str :$project = $*CWD.Str ) {

  my SkimFile $sf .= new( :root-to-file($test-file), :root($project));
  my Gui $gui .= new;

  $gui.add-file-data( $sf.root-basename, $test-file, $sf.todo-texts);
  $gui.add-file-data( $sf.root-basename, 'bin/abc.pl6', $sf.todo-texts);
  $gui.add-file-data( $sf.root-basename, 'bin/aabbcc.pl6', $sf.todo-texts);
  $gui.add-file-data( $sf.root-basename, 'lib/AaBbCc.pm6', $sf.todo-texts);
  $gui.add-file-data( $sf.root-basename, 'lib/Aa.pm6', $sf.todo-texts);
  $gui.add-file-data( $sf.root-basename, 't/AaBbCc.t', $sf.todo-texts);
  $gui.add-file-data( $sf.root-basename, 't/Aa.t', $sf.todo-texts);

  $gui.activate;
}
