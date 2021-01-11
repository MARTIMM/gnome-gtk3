use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::CellRenderer;
ok 1, 'loads ok';

# rest is tested using CellRendererText and friends

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
done-testing;
