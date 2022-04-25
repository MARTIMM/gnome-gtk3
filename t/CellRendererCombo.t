use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::CellRendererCombo;

use Gnome::N::GlibToRakuTypes;
#use Gnome::GObject::Object;
#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::CellRendererCombo $crc;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $crc .= new;
  isa-ok $crc, Gnome::Gtk3::CellRendererCombo, '.new';
}


#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Properties …', {
#  my Gnome::Gtk3::CellRendererCombo $crc .= new;
  my @r = $crc.get-properties(
    'has-entry', gboolean, 'text-column', Int
  );
  is-deeply @r, [ 1, -1 ],
    'properties: ' ~ ( 'has-entry', 'text-column').join(', ');
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::CellRendererCombo', {
  class MyClass is Gnome::Gtk3::CellRendererCombo {
    method new ( |c ) {
      self.bless( :GtkCellRendererCombo, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::CellRendererCombo, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
subtest 'Properties …', {
#  my Gnome::Gtk3::CellRendererCombo $crc .= new;
  my @r = $crc.get-properties(
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
      Gnome::Gtk3::CellRendererCombo :$_widget, gulong :$_handler-id
      # --> …
    ) {

      isa-ok $_widget, Gnome::Gtk3::CellRendererCombo;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::CellRendererCombo :$widget --> Str ) {

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

  my Gnome::Gtk3::CellRendererCombo $crc .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $crc.register-signal( $sh, 'method', 'signal');

  my Promise $p = $crc.start-thread(
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
