use v6;

sub MAIN ( Str $class ) {

  my Bool $loaded = False;
  try {
    require ::($class);
    my $o = ::($class).new;
    note "M: ", $o.WHAT;

    $loaded = True;

    CATCH {
      default {
        if .message ~~ m:s/$class/ {
          note "Interface $class not (yet) implemented";
        }

        elsif .message ~~ m:s/Could not find/ {
          note ".new() or ._interface() not defined";
        }

        else {
          note "Error: ", .message();
        }
      }
    }
  }
}
