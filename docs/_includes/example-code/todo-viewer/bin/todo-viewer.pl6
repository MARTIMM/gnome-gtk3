
use v6;
use Gui;
use SkimFile;

use MAIN ( Str $test-file ) {

  my SkimFile $sf .= new(:file($test-file));
  
}
