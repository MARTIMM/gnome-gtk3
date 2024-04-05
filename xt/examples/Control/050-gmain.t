use v6;
use NativeCall;
use Test;

use Gnome::Glib::Main:api<1>;
use Gnome::Gtk3::Main:api<1>;

diag "\nGlib main loop test";

# initialize
my Gnome::Gtk3::Main $main .= new;

# check with default args
my $argc = CArray[int32].new;
$argc[0] = 0;
is $main.gtk-init-check( $argc, CArray[CArray[Str]]), 1, "gtk initalized";

#-------------------------------------------------------------------------------
my Gnome::Glib::Main $gmain .= new;
my $main-context1 = $gmain.context-new;
my $loop = $gmain.loop-new( $main-context1, False);

#-------------------------------------------------------------------------------
subtest "start thread with a new context", {
  diag "$*THREAD.id(), Start thread";
  my Promise $p = start {
    # wait for loop to start
    sleep(1.1);

    diag "$*THREAD.id(), " ~
         "Use g_main_context_new\() and " ~
         "g_main_context_push_thread_default\() to create and push " ~
         "a new context to invoke handler on thread";

    # This part is important that it happens in the thread where the
    # function is invoked in that context! The context must be
    # different than the one above to create the loop
    my $main-context2 = $gmain.context-new;
    $gmain.context-push-thread-default($main-context2);

    diag "$*THREAD.id(), " ~
         "Use g-main-context-invoke-full() to invoke sub on thread";

    $gmain.context-invoke-full(
      $main-context2, G_PRIORITY_DEFAULT, &handler,
      OpaquePointer, &notify
    );

    diag "$*THREAD.id(), " ~
         "Use g-main-context-pop-thread-default\() to remove the context";
    $gmain.context-pop-thread-default($main-context2);

    'test done'
  }

  diag "$*THREAD.id(), start loop with g-main-loop-run\()";
  $gmain.loop-run($loop);
  diag "$*THREAD.id(), loop stopped";

  await $p;
  is $p.result, 'test done', 'result promise ok';
}

#-------------------------------------------------------------------------------
subtest "start thread with a default context", {
  diag "$*THREAD.id(), Start thread";
  my Promise $p = start {
    # wait for loop to start
    sleep(1.1);

    diag "$*THREAD.id(), " ~
         "Get default context with g-main-context-get-thread-default\() " ~
         "to invoke handler on thread";

    # This part is important that it happens in the thread where the
    # function is invoked in that context! The context must be
    # different than the one above to create the loop
    my $main-context2 = $gmain.context-get-thread-default;

    diag "$*THREAD.id(), " ~
         "Use g-main-context-invoke-full() to invoke sub on thread";

    $gmain.context-invoke-full(
      $main-context2, G_PRIORITY_DEFAULT, &handler,
      OpaquePointer, &notify
    );

    diag "$*THREAD.id(), no need to pop default context";
    'test done'
  }

  diag "$*THREAD.id(), start loop with g-main-loop-run()";
  $gmain.loop-run($loop);
  diag "$*THREAD.id(), loop stopped";

  await $p;
  is $p.result, 'test done', 'result promise ok';
}

#-------------------------------------------------------------------------------
done-testing;

#-------------------------------------------------------------------------------
sub handler ( OpaquePointer ) {

  diag "$*THREAD.id(), In handler on same thread";
  diag "$*THREAD.id(), Use g-main-loop-quit() to stop loop";
  $gmain.g-main-loop-quit($loop);

  G_SOURCE_REMOVE
}

#-------------------------------------------------------------------------------
sub notify ( OpaquePointer ) {
  diag "$*THREAD.id(), In notify handler";
}
