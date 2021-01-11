use v6;
#use lib '../gnome-native/lib';
use NativeCall;
use Test;

#use Gnome::GObject::Object;
use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gtk3::Enums;
#use Gnome::Gtk3::Window;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::CellRenderer;
use Gnome::Gtk3::CellRendererText;

use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
#my Gnome::Gtk3::Window $w;
my Gnome::Gtk3::Button $b;
my Gnome::Gtk3::CellRendererText $crt;
my Gnome::GObject::Value $v;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $crt .= new;
  isa-ok $crt, Gnome::Gtk3::CellRendererText, '.new';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Inherit CellRenderer', {
  is GtkSizeRequestMode($crt.get-request-mode),
     GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH, '.get-request-mode()';

#  $w .= new;
  $b .= new(:label<Start>);
#  $w.gtk-container-add($b);
#  $w.show-all;

  ok 1, ".get-preferred-width(): " ~ $crt.get-preferred-width($b).join(', ');
  ok 1, ".get-preferred-height-for-width(): " ~
       $crt.get-preferred-height-for-width( $b, 10).join(', ');
  ok 1, ".get-preferred-height(): " ~ $crt.get-preferred-height($b).join(', ');
  ok 1, ".get-preferred-width-for-height(): " ~
       $crt.get-preferred-width-for-height( $b, 10).join(', ');

  my $ps = $crt.get-preferred-size($b);
  ok 1, [~] ".get-preferred-size() [0]: ", $ps[0].width, ', ', $ps[0].height;
  ok 1, [~] ".get-preferred-size() [1]: ", $ps[1].width, ', ', $ps[1].height;

  $crt.set-fixed-size( 10, 10);
  is-deeply $crt.get-fixed-size, (10, 10),
            '.set-fixed-size() / .get-fixed-size()';

  $crt.set-alignment( 0.1e0, 0.2e0);
  my Num ( $xa, $ya) = $crt.get-alignment;
  is-approx $xa, 0.1, '$xa .set-alignment() / .get-alignment()';
  is-approx $ya, 0.2, '$ya .set-alignment() / .get-alignment()';

  $crt.set-padding( 2, 4);
  is-deeply $crt.get-padding, ( 2, 4), '.set-padding() / .get-padding()';

  ok $crt.get-visible, '.get-visible()';
  $crt.set-visible(0);
  nok $crt.get-visible, '.set-visible()';

  ok $crt.get-sensitive, '.get-sensitive()';
  $crt.set-sensitive(0);
  nok $crt.get-sensitive, '.set-sensitive()';

  nok $crt.is-activatable, '.is-activatable()';
  my Int $state = $crt.get-state( $b, GTK_CELL_RENDERER_INSENSITIVE);
  is GtkStateFlags( $state +& 0b1000), GTK_STATE_FLAG_INSENSITIVE,
     'insensitive .get-state()';
  is GtkStateFlags( $state +& 0b10000000), GTK_STATE_FLAG_DIR_LTR,
     'dir ltr .get-state()';

  #-----------------------------------------------------------------------------
  subtest 'Properties CellRenderer', {

    $v .= new(:init(G_TYPE_INT));
    $crt.get-property( 'mode', $v);
    is GtkCellRendererMode($v.get-int), GTK_CELL_RENDERER_MODE_INERT,
       'property mode';

    $v .= new(:init(G_TYPE_BOOLEAN));
    $crt.get-property( 'visible', $v);
    nok $v.get-boolean, 'property visible'; # turned off in above test
  }
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  $crt.set-fixed-height-from-font(2);
  ok 1, '.set-fixed-height-from-font()';
}

#-------------------------------------------------------------------------------
subtest 'Properties CellRendererText', {

  $v .= new(:init(G_TYPE_STRING));
  $crt.get-property( 'background-rgba', $v);
  is $v.get-string, 'rgba(255,255,255,1)', 'property background';

}
}}

#`{{
#-------------------------------------------------------------------------------
subtest 'Interface ...', {
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
