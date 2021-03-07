use v6;
use NativeCall;
use Test;

#use Gnome::Glib::Quark;
use Gnome::Glib::Error;

use Gnome::Gdk3::Pixbuf;
#use Gnome::Gtk3::RecentChooser;
use Gnome::Gtk3::RecentInfo;
use Gnome::Gtk3::RecentManager;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
#my Gnome::Gtk3::RecentChooserMenu $rc .= new;
my Gnome::Glib::Error $e;
my Gnome::Gtk3::RecentManager $rm;
my Gnome::Gtk3::RecentInfo $ri;
#-------------------------------------------------------------------------------
#`{{
subtest 'ISA test', {
  $rc .= new;
  isa-ok $rc, Gnome::Gtk3::RecentChooserMenu;
  does-ok $rc, Gnome::Gtk3::RecentChooser;
}
}}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $rm .= new(:default);
  my N-GtkRecentData $rd .= new(
    :display_name("Marcels Home"), :description('my home sweet home'),
    :mime_type<inode/directory>,
    :app_name('RecentInfo.t'), :app_exec('ls -l %f'),
    :groups([<marcel>]), :!is_private
  );
  ok $rm.add-full( 'file:///home/marcel2', $rd), 'manager.add-full()';
  ( $ri, $e ) = $rm.lookup-item('file:///home/marcel2');
  ok $ri.is-valid, 'manager.lookup-item()';
  my List $l = $ri.get-application-info('RecentInfo.t');
  like $l[0], /:s ls '-l' <[/\\]> home <[/\\]> 'marcel2'/,
       '.get-application-info() [0]: ' ~ $l[0];
  is $l[1], 1, '.get-application-info() [1]: 1 x registered';
  is $l[2], time, '.get-application-info() [2]: 0 sec ago';
  is $ri.get-added, time, '.get-added(): 0 seconds, just inserted';
  is $ri.get-modified, time, '.get-modified(): 0 seconds, just inserted';
  ok 1, '.get-visited(): never visited, should be 0/-1: ' ~ $ri.get-visited;
  is $ri.get-age, 0, '.get-age(): 0 days, just inserted';
  is $ri.get-display-name, "Marcels Home", '.get-display-name()';
  is $ri.get-description, 'my home sweet home', '.get-description()';
  is $ri.get-mime-type, 'inode/directory', '.get-mime-type()';
  nok $ri.get-private-hint, '.get-private-hint()';
  ok $ri.has-application('RecentInfo.t'), '.has-application()';
  nok $ri.has-application('RecentManager.t'), '.has-application() wrong app';
  ok $ri.has-group('marcel'), '.has-group()';
  nok $ri.has-group('piet'), '.has-group() wrong group';
  ok $ri.is-local, '.is-local()';
  nok $ri.exists, '.exists()';
  ok $ri.match($ri), '.match()';

  $rd .= new(
    :display_name("Marcels Home"), :description('my home sweet home'),
    :mime_type<inode/directory>,
    :app_name('RecentManager.t'), :app_exec('ls -lh %f'),
    :groups([<marcel2 root wheel>]), :!is_private
  );
  ok $rm.add-full( 'file:///home/marcel2', $rd), 'add 2nd time with other app';
  ( $ri, $e ) = $rm.lookup-item('file:///home/marcel2');
  ok $ri.is-valid, 'looked up again';
  my Array $a = $ri.get-applications;
  is-deeply [$a.sort], [<RecentInfo.t RecentManager.t>], '.get-applications()';

  is $ri.last-application, 'RecentManager.t', '.last-application()';

  $a = $ri.get-groups;
  is-deeply [$a.sort], [<marcel marcel2 root wheel>], '.get-groups()';

  my Gnome::Gdk3::Pixbuf $pb .= new(:native-object($ri.get-icon(32)));
  ok $pb.is-valid, '.get-icon()';
  is $pb.get-width, 32, 'icon width ok';
  is $pb.get-height, 32, 'icon height ok';

  is $ri.get-short-name, 'marcel2', '.get-short-name()';
  is $ri.get-uri, 'file:///home/marcel2', '.get-uri()';
  like $ri.get-uri-display, / <[/\\]> home <[/\\]> marcel2 /,
    '.get-uri-display()';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::RecentChooser', {
  class MyClass is Gnome::Gtk3::RecentChooser {
    method new ( |c ) {
      self.bless( :GtkRecentChooser, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::RecentChooser, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
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
      Gnome::Gtk3::RecentChooser :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::RecentChooser;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::RecentChooser :$widget --> Str ) {

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

  my Gnome::Gtk3::RecentChooser $rc .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.container-add($m);

  my SignalHandlers $sh .= new;
  $rc.register-signal( $sh, 'method', 'signal');

  my Promise $p = $rc.start-thread(
    $sh, 'signal-emitter',
    # G_PRIORITY_DEFAULT,       # enable 'use Gnome::Glib::Main'
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
}}

#-------------------------------------------------------------------------------
done-testing;
