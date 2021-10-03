use v6.d;
use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::Gtk3::Box;
use Gnome::Gtk3::Dialog;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::HeaderBar;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Dialog $d;

#-------------------------------------------------------------------------------
subtest 'ISA tests', {
  $d .= new;
  isa-ok $d, Gnome::Gtk3::Dialog, '.new';

  my Gnome::Gtk3::Window $parent .= new;
  $parent.set-title('My App');
  $d .= new(
    :title('msg dialog'), :$parent,
    :flags(GTK_DIALOG_MODAL +| GTK_DIALOG_DESTROY_WITH_PARENT),
    :button-spec( 'Ok', GTK_RESPONSE_ACCEPT, "Cancel", GTK_RESPONSE_REJECT)
  );
  isa-ok $d, Gnome::Gtk3::Dialog, '.new(:title)';
}


#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gtk3::Box $content-box = $d.get-content-area-rk;
  is $content-box.get-name, 'GtkBox', '.get-content-area-rk()';

  my Gnome::Gtk3::HeaderBar $header-bar = $d.get-header-bar-rk;
  nok $header-bar.is-valid, '.get-header-bar-rk()';

#`{{
  is $d.get-response-for-widget, GTK_RESPONSE_NONE,
    '.get-response-for-widget()';
}}
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  my @pvs = $d.get-properties( 'use-header-bar', Bool);
  is-deeply @pvs, [0,], 'use-header-bar';
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Dialog', {
  class MyClass is Gnome::Gtk3::Dialog {
    method new ( |c ) {
      self.bless( :GtkDialog, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Dialog, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Dialog $d .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $d.get-property( $prop, $gv);
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
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', False);
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
      Gnome::Gtk3::Dialog :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::Dialog;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Dialog :$widget --> Str ) {

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

  my Gnome::Gtk3::Dialog $d .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $d.register-signal( $sh, 'method', 'signal');

  my Promise $p = $d.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
