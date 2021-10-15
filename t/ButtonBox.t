use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::ButtonBox;
use Gnome::Gtk3::Button;

#use Gnome::N::X;
#Gnome::N::debug(:on);
use Gnome::N::GlibToRakuTypes;

#-------------------------------------------------------------------------------
my Gnome::Gtk3::ButtonBox $bb;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $bb .= new;
  isa-ok $bb, Gnome::Gtk3::ButtonBox, '.new()';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gtk3::Button $button1 .= new(:label<Start>);
  $bb.add($button1);
  my Gnome::Gtk3::Button $button2 .= new(:label<Stop>);
  $bb.add($button2);

  my Gnome::Gtk3::Button $button3 .= new(:label<Foo>);
  $bb.add($button3);
  $bb.set-child-secondary( $button3, True);
  my Gnome::Gtk3::Button $button4 .= new(:label<Bar>);
  $bb.add($button4);
  $bb.set-child-secondary( $button4, True);

  $bb.set-child-non-homogeneous( $button1, True);
  ok $bb.get-child-non-homogeneous($button1),
    '.set-child-non-homogeneous() / .get-child-non-homogeneous()';

  ok $bb.get-child-secondary($button4),
    '.set-child-secondary() / .get-child-secondary()';

  $bb.set-layout(GTK_BUTTONBOX_EXPAND);
  is $bb.get-layout, GTK_BUTTONBOX_EXPAND, '.set-layout() / .get-layout()';
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::ButtonBox', {
  class MyClass is Gnome::Gtk3::ButtonBox {
    method new ( |c ) {
      self.bless( :GtkButtonBox, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::ButtonBox, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  my @r = $bb.get-properties( 'layout-style', GEnum);
  is-deeply @r, [GTK_BUTTONBOX_EXPAND.value,], 'layout-style';
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::ButtonBox $bb .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $bb.get-property( $prop, $gv);
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
      Gnome::Gtk3::ButtonBox :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::ButtonBox;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::ButtonBox :$widget --> Str ) {

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

  my Gnome::Gtk3::ButtonBox $bb .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $bb.register-signal( $sh, 'method', 'signal');

  my Promise $p = $bb.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
