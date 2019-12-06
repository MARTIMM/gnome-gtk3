use v6;

unit class SkimFile;

enum MarkTypes is export <TODOMARK>;

has Str $!file-path;
has Str $.root-basename;
has Array $.todo-texts;

submethod BUILD ( Str :$root, Str :$root-to-file ) {
  die "File $root-to-file does not exist in $root"
      unless "$root/$root-to-file".IO.r;

  $!file-path = "$root/$root-to-file";
  $!root-basename = $root.IO.basename;
  self!search-texts;
}

method reread-file ( ) {
  self!search-texts;
}

method !search-texts ( ) {
  $!todo-texts = [];
  my $line-count = 0;
  for $!file-path.IO.slurp.lines -> $line {
    $line-count++;

    if $line ~~ m/^ \s* '#' \s* TODO $<todo-text>=[<-[\n]>+] $/ {
      my Str $t = ~$<todo-text>;
      $!todo-texts.push: [ TODOMARK, $line-count, $t];
    }
  }

note "\nT: \n[", $!todo-texts.join("]\n["), "]";
}
