use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Container;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Label;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Button $b .= new;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $b, Gnome::Gtk3::Button;
  isa-ok $b, Gnome::Gtk3::Container, 'a button is also a container';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
  is $b.get-border-width, 0, 'border is 0';
  $b.set-border-width(10);
  is $b.get-border-width, 10, 'border is now 10';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  subtest 'container-foreach', {
    class X {
      method cb ( $nw, :$label ) {
        my Gnome::Gtk3::Widget $w .= new(:native-object($nw));
        is $w.widget-get-name(), 'GtkLabel', 'GtkLabel';
        my Gnome::Gtk3::Label $l .= new(:native-object($nw));
        is $l.get-text, $label, 'label text';
      }
    }

    #Gnome::N::debug(:on);
    $b .= new(:label<some-text>);
    $b.container-foreach( X.new, 'cb', :label<some-text>);
    #Gnome::N::debug(:off);
  }
}

#`{{

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
