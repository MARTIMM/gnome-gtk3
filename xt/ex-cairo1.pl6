use v6;

use Gnome::N::N-GObject;

#use Gnome::Gdk3::Events;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Frame;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Image;

use Cairo;

my Gnome::Gtk3::Main $m .= new;

class X {
  method exit ( :widget($w) ) {
    $m.gtk-main-quit;
  }

  method drawit ( N-GObject $cc, :widget($da) ) {
note "cc: $cc.perl, da: $da.perl";
#return;
#    my $ci = Cairo::Image.create(Cairo::FORMAT_ARGB32, 128, 128);
    my $ct = Cairo::Context.new($cc);#$da.get-native-object-no-reffing);
note "$ct.perl()";

    $ct.rgb( 0, 0.7, 0.9);
    $ct.rectangle(10, 10, 50, 50);
    $ct.fill :preserve; $ct.rgb(1, 1, 1);
    $ct.stroke;
    #$ci.write_png('f.png');
#    $f.widget_draw($ct.context);
  }
}

my Gnome::Gtk3::Window $w .= new;
$w.set-title('My Drawing In My Window');
$w.set-position(GTK_WIN_POS_MOUSE);
$w.set-size-request( 300, 300);
$w.register-signal( X.new, 'exit', 'destroy');

my Gnome::Gtk3::Frame $f .= new(:label('My Drawing'));
$w.gtk-container-add($f);

my Gnome::Gtk3::Image $da .= new;
$f.gtk-container-add($da);
$da.register-signal( X.new, 'drawit', 'draw');



$w.show-all;

#$w.set-interactive-debugging(1);

$m.gtk-main;
