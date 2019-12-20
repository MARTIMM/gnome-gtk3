use v6;

unit class SkimFile;

has Str $!file-path;
has Array $.mark-texts;

#-------------------------------------------------------------------------------
submethod BUILD ( Str :$!file-path ) {
  die "File $!file-path does not exist" unless $!file-path.IO.r;
  self!search-texts;
}

#-------------------------------------------------------------------------------
method reread-file ( ) {
  self!search-texts;
}

#-------------------------------------------------------------------------------
method !search-texts ( ) {
  $!mark-texts = [];
  my $line-count = 0;
  for $!file-path.IO.slurp.lines -> $line {
    $line-count++;

    if $line ~~
          m/^ \s*
            [ '#' ||                      # Comments in several languages
              '#`{' '{'? || '#`[' '['? || # Comment block in Raku
              '=comment' ||               # Pod document in Raku
              '/*' || '//' ||             # C, C++, Javascript, Qml
              '<!--'                      # XML, html
            ]
            \s*
            $<marker>=[ TODO || DOING || DONE || PLANNING || FIXME ||
                        ARCHIVE || HACK || CHANGED || XXX || IDEA ||
                        NOTE || REVIEW ]
            \s* $<marker-text>=[<-[\n]>+]
            $/ {

      $!mark-texts.push: [ ~$<marker>, $line-count, ~$<marker-text> ];
    }
  }
}
