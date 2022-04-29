use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::CellRendererToggle;

use Gnome::N::GlibToRakuTypes;
#use Gnome::N::N-GObject;
#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::CellRendererToggle $crt;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $crt .= new;
  isa-ok $crt, Gnome::Gtk3::CellRendererToggle, '.new';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  nok $crt.get-radio, '.get-radio()';
  $crt.set-radio(True);
  ok $crt.get-radio, '.get-radio() now radio';

  nok $crt.get-active, '.get-active()';
  $crt.set-active(True);
  ok $crt.get-active, '.get-active() now active';

  ok $crt.get-activatable, '.get-activatable()';
  $crt.set-activatable(False);
  nok $crt.get-activatable, '.get-activatable() now not activatable';
}

#-------------------------------------------------------------------------------
subtest 'Properties …', {
#  my Gnome::Gtk3::CellRendererToggle $crt .= new;
  my @r = $crt.get-properties(
    'activatable', gboolean, 'active', gboolean, 'inconsistent', gboolean,
    'radio', gboolean
  );
  is-deeply @r, [ 0, 1, 0, 1], 'properties: ' ~ (
    'activatable', 'active', 'inconsistent', 'radio'
  ).join(', ');
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::CellRendererToggle', {
  class MyClass is Gnome::Gtk3::CellRendererToggle {
    method new ( |c ) {
      self.bless( :GtkCellRendererToggle, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::CellRendererToggle, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
subtest 'Properties …', {
#  my Gnome::Gtk3::CellRendererToggle $crt .= new;
  my @r = $crt.get-properties(
#    name, type,  …
  );
  is-deeply @r, [
#    value, …
  ], 'properties: ' ~ (
#    name, …
  ).join(', ');
}

#-------------------------------------------------------------------------------
subtest 'Signals …', {
  use Gnome::Gtk3::Main;
  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method … (
      'any-args',
      Gnome::Gtk3::CellRendererToggle :$_widget, gulong :$_handler-id
      # --> …
    ) {

      isa-ok $_widget, Gnome::Gtk3::CellRendererToggle;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::CellRendererToggle :$widget --> Str ) {

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

  my Gnome::Gtk3::CellRendererToggle $crt .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $crt.register-signal( $sh, 'method', 'signal');

  my Promise $p = $crt.start-thread(
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
