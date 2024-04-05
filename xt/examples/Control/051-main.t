use v6;
use NativeCall;
use Test;

use Gnome::Glib::Main:api<1>;
use Gnome::Gtk3::Main:api<1>;

diag "\nGTK main loop test";

# initialize
my Gnome::Gtk3::Main $main .= new;

#-------------------------------------------------------------------------------
my Gnome::Glib::Main $gmain .= new;

diag "$*THREAD.id(), Start thread";
my Promise $p = start {
  # wait for loop to start
  sleep(1.1);
  is $main.gtk-main-level, 1, "loop level now 1";

  diag "$*THREAD.id(), Create context to invoke handler on thread";

  # This part is important that it happens in the thread where the
  # function is invoked in that context!
  my $main-context = $gmain.context-get-thread-default;

  diag "$*THREAD.id(), Use g-main-context-invoke to invoke sub on thread";

  $gmain.context-invoke(
    $main-context,
    -> $d {

      diag "$*THREAD.id(), In handler on same thread";
      diag "$*THREAD.id(), Use gtk-main-quit() to stop loop";
      $main.gtk-main-quit;

      0
    },
    OpaquePointer
  );

  'test done'
}

is $main.gtk-main-level, 0, "loop level 0";
diag "$*THREAD.id(), start loop with gtk-main()";
$main.gtk-main;
diag "$*THREAD.id(), loop stopped";
is $main.gtk-main-level, 0, "loop level is 0 again";

await $p;
is $p.result, 'test done', 'result promise ok';

#-------------------------------------------------------------------------------
done-testing;
