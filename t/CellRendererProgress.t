use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::CellRendererProgress;

use Gnome::N::GlibToRakuTypes;
#use Gnome::GObject::Object;
#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::CellRendererProgress $crp;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $crp .= new;
  isa-ok $crp, Gnome::Gtk3::CellRendererProgress, '.new';
}


#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Properties …', {
#  my Gnome::Gtk3::CellRendererProgress $crp .= new;
  my @r = $crp.get-properties(
    'inverted', gboolean, 'pulse', Int, 'text', Str,
    'text-xalign', Num, 'text-yalign', Num, 'value', Int
  );
  is-deeply @r, [
    0, -1, '', 5e-1, 5e-1, 0
  ], 'properties: ' ~ (
    'inverted', 'pulse', 'text', 'text-xalign', 'text-yalign', 'value'  ).join(', ');
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::CellRendererProgress', {
  class MyClass is Gnome::Gtk3::CellRendererProgress {
    method new ( |c ) {
      self.bless( :GtkCellRendererProgress, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::CellRendererProgress, 'MyClass.new()';
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
      Gnome::Gtk3::CellRendererProgress :$_widget, gulong :$_handler-id
      # --> …
    ) {

      isa-ok $_widget, Gnome::Gtk3::CellRendererProgress;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::CellRendererProgress :$widget --> Str ) {

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

  my Gnome::Gtk3::CellRendererProgress $crp .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $crp.register-signal( $sh, 'method', 'signal');

  my Promise $p = $crp.start-thread(
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
