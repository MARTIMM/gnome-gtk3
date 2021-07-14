use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::CheckMenuItem;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::CheckMenuItem $cmi;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $cmi .= new;
  isa-ok $cmi, Gnome::Gtk3::CheckMenuItem, '.new()';

  $cmi .= new(:label<Bold>);
  isa-ok $cmi, Gnome::Gtk3::CheckMenuItem, '.new(:label)';

  $cmi .= new(:mnemonic<_Bold>);
  isa-ok $cmi, Gnome::Gtk3::CheckMenuItem, '.new(:mnemonic)';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  given $cmi {
    .set-active(True);
    ok .get-active, '.active() / .active()';
    .set-inconsistent(True);
    ok .get-inconsistent, '.set-inconsistent() / .get-inconsistent()';
    .set-draw-as-radio(True);
    ok .get-draw-as-radio, '.set-draw-as-radio() / .get-draw-as-radio()';
  }
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::CheckMenuItem', {
  class MyClass is Gnome::Gtk3::CheckMenuItem {
    method new ( |c ) {
      self.bless( :GtkCheckMenuItem, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new(:label<Dashing>);
  isa-ok $mgc, Gnome::Gtk3::CheckMenuItem, '.new(:label)';
  is $mgc.get-label, 'Dashing', '.get-label()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  my Gnome::Gtk3::CheckMenuItem $cmi .= new(:label<Raku>);
  $cmi.set-active(True);

  sub test-property (
    $type, Str $prop, Str $routine, $value, Bool :$approx = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $cmi.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    if $approx {
      is-approx $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }

    else {
      is $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }
    $gv.clear-object;
  }

  # example calls
  test-property( G_TYPE_BOOLEAN, 'active', 'get-boolean', True);
  test-property( G_TYPE_BOOLEAN, 'inconsistent', 'get-boolean', False);
  test-property( G_TYPE_BOOLEAN, 'draw-as-radio', 'get-boolean', False);
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}
}}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  use Gnome::Gtk3::Main;
  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method is-toggled (
      Gnome::Gtk3::CheckMenuItem :$_widget, gulong :$_handler-id
    ) {

      isa-ok $_widget, Gnome::Gtk3::CheckMenuItem;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::CheckMenuItem :$widget --> Str ) {

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      $widget.emit-by-name(
        'toggled',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      );
      is $!signal-processed, True, '\'toggled\' signal processed';

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

  my Gnome::Gtk3::CheckMenuItem $cmi .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $cmi.register-signal( $sh, 'is-toggled', 'toggled');

  my Promise $p = $cmi.start-thread(
    $sh, 'signal-emitter',
    # G_PRIORITY_DEFAULT,       # enable 'use Gnome::Glib::Main'
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}


#-------------------------------------------------------------------------------
done-testing;
