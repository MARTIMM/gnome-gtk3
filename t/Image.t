use v6;
use NativeCall;
use Test;

#use Gnome::Cairo;
#use Gnome::Cairo::Enums;
use Gnome::Cairo::Types;
use Gnome::Cairo::ImageSurface;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Image;
#use Gnome::Gtk3::Window;

use Gnome::Gdk3::Pixbuf;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Image $i;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $i .= new;
  isa-ok $i, Gnome::Gtk3::Image, ".new";
  is GtkImageType($i.get-storage-type), GTK_IMAGE_EMPTY,
     '.get-storage-type() empty';

  $i .= new(:filename<t/data/Add.png>);
  isa-ok $i, Gnome::Gtk3::Image, ".new(:filename)";
  is $i.get-storage-type, GTK_IMAGE_PIXBUF, '.get-storage-type() pixbuf';

  $i .= new(:filename<desktop>);
  is $i.get-storage-type, GTK_IMAGE_ICON_NAME, '.get-storage-type() icon name';

  $i .= new(:filename<t/data/Alexis-Kaufman.gif>);
  is $i.get-storage-type, GTK_IMAGE_ANIMATION, '.get-storage-type() animation';

  $i .= new( :icon-name<media-seek-forward>, :size(GTK_ICON_SIZE_DIALOG));
  is $i.get-storage-type, GTK_IMAGE_ICON_NAME, '.new( :icon, :size)';

  my Gnome::Cairo::ImageSurface $is .= new(:png<t/data/Add.png>);
  $i .= new(:surface($is));
  is $i.get-storage-type, GTK_IMAGE_SURFACE, '.new(:surface)';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  $i.image-clear;
  is GtkImageType($i.get-storage-type), GTK_IMAGE_EMPTY, '.image-clear()';

  $i .= new(:filename<t/data/Add.png>);
  my Gnome::Gdk3::Pixbuf $pb .= new(:native-object($i.get-pixbuf));
  is $pb.get-width, 16, '.get-pixbuf()';
#  note $i.get-pixel-size;

  $i .= new( :icon-name<media-seek-forward>, :size(GTK_ICON_SIZE_DIALOG));

  my List $info = $i.get-icon-name;
  is-deeply $info, ( 'media-seek-forward', GTK_ICON_SIZE_DIALOG),
            '.get-icon-name()';
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Image', {
  class MyClass is Gnome::Gtk3::Image {
    method new ( |c ) {
      self.bless( :GtkImage, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Image, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Image $i .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $i.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    if $approx {
      is-approx $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }

    # dependency on local settings might result in different values
    elsif $is-local {
      if $gv-value ~~ /$value/ {
        like $gv-value, /$value/, "property $prop, value: " ~ $gv-value;
      }

      else {
        ok 1, "property $prop, value: " ~ $gv-value;
      }
    }

    else {
      is $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }
    $gv.clear-object;
  }

  # example calls
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', 0);
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  use Gnome::Gtk3::Main;
  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method ... (
      'any-args',
      Gnome::Gtk3::Image :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::Image;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Image :$widget --> Str ) {

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      $widget.emit-by-name(
        'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      );
      is $!signal-processed, True, '\'...\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      #$!signal-processed = False;
      #$widget.emit-by-name(
      #  'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      #);
      #is $!signal-processed, True, '\'...\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }
      sleep(0.4);
      $main.gtk-main-quit;

      'done'
    }
  }

  my Gnome::Gtk3::Image $i .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $i.register-signal( $sh, 'method', 'signal');

  my Promise $p = $i.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
