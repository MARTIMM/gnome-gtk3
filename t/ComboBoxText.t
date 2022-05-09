use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::ComboBoxText;

#use Gnome::N::GlibToRakuTypes;
#use Gnome::N::N-GObject;
#use Gnome::N::X;
#Gnome::N::debug(:on);

my Gnome::Gtk3::ComboBoxText $cbt;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $cbt .= new;
  ok $cbt.is-valid, '.new()';

  $cbt .= new(:entry);
  ok $cbt.is-valid, '.new(:entry)';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  lives-ok {
    $cbt.append-text('Amerika');
    $cbt.append-text('Australia');
    $cbt.append-text('China');
    $cbt.append-text('Great-Brittain');
    $cbt.append-text('Netherlands');
  }, '.append-text()';

  lives-ok { $cbt.append( 'Ty', 'Turkey'); }, '.append()';
  lives-ok { $cbt.insert( 0, 'Nh', 'Noord Holland'); }, '.insert()';
  lives-ok { $cbt.insert-text( -1, 'Zuid Holland'); }, '.insert-text()';
  lives-ok { $cbt.prepend( 'D', 'Drente'); }, '.prepend()';
  lives-ok { $cbt.prepend-text('Friesland'); }, '.prepend-text()';

  for ^100 -> $i {
    $cbt.set-active($i);
    my Str $txt = $cbt.get-active-text;
    last if $cbt.get-active == -1;
    diag "$i: $txt";
  }

  # from GtkComboBox
  is $cbt.get-has-entry, True, '.get-has-entry()';
  is $cbt.get-active, -1, '.get-active()';
  $cbt.set-active(4);
  is $cbt.get-active, 4, '.set-active()';


  # from GtkComboBoxText
  is $cbt.get-active-text, 'Australia', '.get-active-text()';

  $cbt.set-active(8);
  is $cbt.get-active-text, 'Turkey', '.get-active-text()';
  is $cbt.get-active-id, 'Ty', '.get-active-id()';
  ok $cbt.set-active-id('Nh'), '.set-active-id()';

  $cbt.remove(9);
  $cbt.set-active(9);
#  diag "act1: $cbt.get-active()";
  is $cbt.get-active, -1, '.remove()';

#  for ^100 -> $i {
#    $cbt.set-active($i);
#    my Str $txt = $cbt.get-active-text;
#    last if $cbt.get-active == -1;
#    diag "$i: $txt";
#  }

  $cbt.remove-all;
  $cbt.set-active(9);
#  diag "act2: $cbt.get-active()";
  is $cbt.get-active, -1, '.remove-all()';

}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::ComboBoxText', {
  class MyClass is Gnome::Gtk3::ComboBoxText {
    method new ( |c ) {
      self.bless( :GtkComboBoxText, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::ComboBoxText, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Properties …', {
#  my Gnome::Gtk3::ComboBoxText $cbt .= new;
  my @r = $cbt.get-properties(
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
      Gnome::Gtk3::ComboBoxText :$_widget, gulong :$_handler-id
      # --> …
    ) {

      isa-ok $_widget, Gnome::Gtk3::ComboBoxText;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::ComboBoxText :$widget --> Str ) {

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

  my Gnome::Gtk3::ComboBoxText $cbt .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $cbt.register-signal( $sh, 'method', 'signal');

  my Promise $p = $cbt.start-thread(
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
