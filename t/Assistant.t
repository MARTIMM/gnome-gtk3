use v6;

use NativeCall;
use Test;

use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Frame;
use Gnome::Gtk3::Assistant;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Assistant $a;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $a .= new;
  isa-ok $a, Gnome::Gtk3::Assistant, '.new()';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is $a.get-n-pages, 0, '.get-n-pages()';

  my Gnome::Gtk3::Frame $f1 .= new(:label<ass-page-1>);
  $f1.set-name('f1');
  $a.append-page($f1);
  is $a.get-n-pages, 1, '.append-page()';
  $a.set-page-type( $f1, GTK_ASSISTANT_PAGE_CUSTOM);
  is GtkAssistantPageType($a.get-page-type($f1)), GTK_ASSISTANT_PAGE_CUSTOM,
    '.set-page-type() / .get-page-type()';

  $a.set-page-title( $f1, 'f1');
  is $a.get-page-title($f1), 'f1', '.set-page-title() / .get-page-title()';

  my Gnome::Gtk3::Frame $f2 .= new(:label<ass-page-1>);
  $f2.set-name('f2');
  is $a.prepend-page($f2), 0, '.prepend-page()';
  $a.set-page-type( $f2, GTK_ASSISTANT_PAGE_CUSTOM);
  my Gnome::Gtk3::Widget $w .= new(:native-object($a.get-nth-page(0)));
  is $w.get-name, 'f2', '.get-nth-page()';
  is $a.get-nth-page(0).().get-name, 'f2', '.get-nth-page()';

  is $a.get-current-page, -1, '.get-current-page()';
  $a.set-current-page(1);
  is $a.get-current-page, 1, '.set-current-page()';

  my Gnome::Gtk3::Frame $f3 .= new(:label<ass-page-3>);
  $f3.set-name('f3');
  $a.insert-page( $f3, -1);
  $a.set-page-type( $f3, GTK_ASSISTANT_PAGE_CONFIRM);
  $w .= new(:native-object($a.get-nth-page(2)));
  is $w.get-name, 'f3', '.insert-page()';

  $a.set-page-complete( $f1, True);
  ok $a.get-page-complete($f1), '.set-page-complete() / .get-page-complete()';

#  $a.set-page-complete( $f2, True);
#  $a.set-page-complete( $f3, True);
#  $a.previous-page();
#  is $a.get-current-page, 0, '.previous-page()';
#  $a.next-page();
#  is $a.get-current-page, 1, '.next-page()';


  $a.remove-page(0);
  is $a.get-n-pages, 2, '.remove-page()';
}


#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Assistant', {
  class MyClass is Gnome::Gtk3::Assistant {
    method new ( |c ) {
      self.bless( :GtkAssistant, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Assistant, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Assistant $a .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $a.get-property( $prop, $gv);
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
      Gnome::Gtk3::Assistant :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::Assistant;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Assistant :$widget --> Str ) {

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

  my Gnome::Gtk3::Assistant $a .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $a.register-signal( $sh, 'method', 'signal');

  my Promise $p = $a.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
