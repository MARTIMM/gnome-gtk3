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
  my Gnome::Gtk3::Box() $content-box = $d.get-content-area;
  is $content-box.get-name, 'GtkBox', '.get-content-area()';

  my Gnome::Gtk3::HeaderBar() $header-bar = $d.get-header-bar;
  nok $header-bar.is-valid, '.get-header-bar()';

  $d.add-button( 'Stop', 4556);

#`{{
  is $d.get-response-for-widget, GTK_RESPONSE_NONE,
    '.get-response-for-widget()';
}}
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  my @pvs = $d.get-properties( 'use-header-bar', Bool);
  is-deeply @pvs, [ 0], 'properties: use-header-bar';
}

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
done-testing;

=finish

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
