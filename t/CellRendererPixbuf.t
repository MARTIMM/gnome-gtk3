use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::CellRendererPixbuf;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::CellRendererPixbuf $crp;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $crp .= new;
  isa-ok $crp, Gnome::Gtk3::CellRendererPixbuf, '.new';
}

#-------------------------------------------------------------------------------
done-testing;

=finish


#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::CellRendererPixbuf', {
  class MyClass is Gnome::Gtk3::CellRendererPixbuf {
    method new ( |c ) {
      self.bless( :GtkCellRendererPixbuf, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::CellRendererPixbuf, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
subtest 'Properties …', {
#  my Gnome::Gtk3::CellRendererPixbuf $crp .= new;
  my @r = $crp.get-properties(
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
      Gnome::Gtk3::CellRendererPixbuf :$_widget, gulong :$_handler-id
      # --> …
    ) {

      isa-ok $_widget, Gnome::Gtk3::CellRendererPixbuf;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::CellRendererPixbuf :$widget --> Str ) {

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

  my Gnome::Gtk3::CellRendererPixbuf $crp .= new;

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
