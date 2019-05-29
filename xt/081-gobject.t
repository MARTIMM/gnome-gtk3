use v6;
use Test;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Label;

#-------------------------------------------------------------------------------
class ThreadCode {
  method th-runner ( :$widget, :$option1, :$main-thread-id ) {

    sleep(1.1);
    my Gnome::Gtk3::Main $main .= new;
    is $main.gtk-main-level, 1, "loop level now 1";

    if $main-thread-id == $*THREAD.id {
      diag "TID: $*THREAD.id(), In handler on same thread";
    }

    else {
      diag "TID: $*THREAD.id(), In handler on different thread -> new context";
    }

    isa-ok $widget, Gnome::Gtk3::Label;
    is $option1, 't1', 'first option matches';

    diag "TID: $*THREAD.id(), Use g-main-loop-quit() to stop loop";
    $main.gtk-main-quit;

    $option1.succ
  }
}

#-------------------------------------------------------------------------------
my ThreadCode $th .= new;
my Gnome::Gtk3::Label $lbl .= new(:label<test-label>);

#-------------------------------------------------------------------------------
subtest "start thread with a default context", {
  my Promise $p = $lbl.start-thread(
    $th, 'th-runner', :option1<t1>, :main-thread-id($*THREAD.id)
  );

  my Gnome::Gtk3::Main $main .= new;
  is $main.gtk-main-level, 0, "loop level 0";
  diag "TID: $*THREAD.id(), start loop with gtk-main()";
  $main.gtk-main;
  diag "TID: $*THREAD.id(), loop stopped";
  is $main.gtk-main-level, 0, "loop level is 0 again";

  await $p;
  is $p.result, 't2', 'result promise ok';
}

#-------------------------------------------------------------------------------
subtest "start thread with a new context", {
  my Promise $p = $lbl.start-thread(
    $th, 'th-runner', :new-context, :option1<t1>, :main-thread-id($*THREAD.id)
  );

  my Gnome::Gtk3::Main $main .= new;
  is $main.gtk-main-level, 0, "loop level 0";
  diag "TID: $*THREAD.id(), start loop with gtk-main()";
  $main.gtk-main;
  diag "TID: $*THREAD.id(), loop stopped";
  is $main.gtk-main-level, 0, "loop level is 0 again";

  await $p;
  is $p.result, 't2', 'result promise ok';
}

#-------------------------------------------------------------------------------
done-testing;
