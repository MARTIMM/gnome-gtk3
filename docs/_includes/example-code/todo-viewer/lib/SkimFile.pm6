use v6;

unit class SkimFile;

has Str $!file;
submethod BUILD ( Str :$!file where .IO.r ) { }

method get-texts ( --> Array ) {

  my Array $texts = [];
  my $count = 1;
  for $!file.IO.slurp.lines -> $line {
    if $line ~~ m/^ \s* '#' \s* TODO $<todo-text>=[<-[\n]>+ $/ {
      my Str $t = ~$<todo-text>;
      $texts.push: [$count, $t];
      $count++;
    }
  }

  $texts
}
