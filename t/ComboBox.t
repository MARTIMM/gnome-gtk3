use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::ComboBox;

use Gnome::N::GlibToRakuTypes;
#use Gnome::N::N-GObject;
#use Gnome::N::X;
#Gnome::N::debug(:on);


#-------------------------------------------------------------------------------
my Gnome::Gtk3::ComboBox $cb .= new;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  ok $cb.is-valid, '.new()';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is $cb.get-has-entry, False, '.get-has-entry()';
  is $cb.get-active, -1, '.get-active()';
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::ComboBox', {
  class MyClass is Gnome::Gtk3::ComboBox {
    method new ( |c ) {
      self.bless( :GtkComboBox, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::ComboBox, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
subtest 'Properties …', {
#  my Gnome::Gtk3::ComboBox $cb .= new;
  my @r = $cb.get-properties(
    'active', Int, 'active-id', Str, 'button-sensitivity', GEnum,
    'column-span-column', Int, 'entry-text-column', Int, 'has-entry', gboolean,
    'has-frame', gboolean, 'id-column', Int, 'popup-fixed-width', gboolean,
    'popup-shown', gboolean, 'row-span-column', Int, 'wrap-width', Int
  );
  is-deeply @r, [
    -1, '', GTK_SENSITIVITY_AUTO.value, -1, -1, 0, 1, -1, 1, 0, -1, 0
  ], 'properties: ' ~ (
    'active', 'active-id', 'button-sensitivity', 'column-span-column',
    'entry-text-column', 'has-entry', 'has-frame', 'id-column',
    'popup-fixed-width', 'popup-shown', 'row-span-column', 'wrap-width'
  ).join(', ');
}

#-------------------------------------------------------------------------------
done-testing;

=finish


#-------------------------------------------------------------------------------
subtest 'Signals …', {
  use Gnome::Gtk3::Main;
  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method … (
      'any-args',
      Gnome::Gtk3::ComboBoxv() :_native-object($_widget), gulong :$_handler-id
      # --> …
    ) {

      isa-ok $_widget, Gnome::Gtk3::ComboBox;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::ComboBox :$widget --> Str ) {

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      $widget.emit-by-name(
        'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      );
      is $!signal-processed, True, '\'…\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      #$!signal-processed = False;
      #$widget.emit-by-name(
      #  'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      #);
      #is $!signal-processed, True, '\'…\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }
      sleep(0.4);
      $main.gtk-main-quit;

      'done'
    }
  }

  my Gnome::Gtk3::ComboBox $cb .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $cb.register-signal( $sh, 'method', 'signal');

  my Promise $p = $cb.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}

#-------------------------------------------------------------------------------
subtest 'Themes …', {
}

#-------------------------------------------------------------------------------
subtest 'Interface …', {
}
