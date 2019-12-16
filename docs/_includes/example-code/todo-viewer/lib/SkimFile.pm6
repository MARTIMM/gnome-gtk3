use v6;

unit class SkimFile;

enum MarkTypes is export <
     TODO DOING DONE PLANNING FIXME ARCHIVE HACK CHANGED
     XXX IDEA NOTE REVIEW
     >;

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

    if $line ~~
          m/^ \s*
            [ '#' || '#`{' '{'? || '#`[' '['? || '/*' || '//' ]
            \s*
            $<marker>=[ TODO || DOING || DONE || PLANNING || FIXME ||
                        ARCHIVE || HACK || CHANGED || XXX || IDEA ||
                        NOTE || REVIEW ]
            $<xyz-text>=[<-[\n]>+]
            $/ {
      my Str $t = ~$<xyz-text>;

      $!todo-texts.push: [
        ~$<marker>, $line-count, $t
#        MarkTypes(MarkTypes.enums{~$<marker>}), $line-count, $t
      ];
    }
  }

#note "\nT: \n[", $!todo-texts.join("]\n["), "]";
}
