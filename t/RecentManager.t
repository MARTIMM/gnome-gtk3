use v6;
use NativeCall;
use Test;

#use Gnome::Glib::Quark;
use Gnome::Glib::Error;
use Gnome::Glib::List;

use Gnome::Gtk3::RecentManager;
use Gnome::Gtk3::RecentInfo;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Glib::Error $e;
my Gnome::Gtk3::RecentManager $rm;
my Gnome::Gtk3::RecentInfo $ri;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $rm .= new;
  isa-ok $rm, Gnome::Gtk3::RecentManager, '.new()';
  $rm .= new(:default);
  isa-ok $rm, Gnome::Gtk3::RecentManager, '.new(:default)';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  given $rm {
    ok .add-item('file:///tmp'), '.add-item()';

    my N-GtkRecentData $rd .= new(
      :display_name<Home>, :description('home sweet home'),
      :mime_type<inode/directory>,
      #:app_name(), :app_exec(),
      :groups([<root>]), :!is_private
    );
    ok .add-full( 'file:///home', $rd), '.add-full()';

    ok .has-item('file:///home'), '.has-item()';

    ( $ri, $e ) = .lookup-item('file:///home');
    is $ri.get-uri, 'file:///home', '.lookup-item()';

    $e = .remove-item('file:///hoeperdepoep.something');
    ok $e.is-valid, $e.message;
    $e = .remove-item('file:///home');
    nok $e.is-valid, '.remove-item()';  # .add-item uri not removable?

    ( $ri, $e ) = .lookup-item('file:///home');
    ok $e.is-valid, $e.message;
    nok $ri.is-valid, 'home is removed';

    $rd .= new(
      :display_name("Marcels Home"), :description('my home sweet home'),
      :mime_type<inode/directory>,
      #:app_name(), :app_exec(),
      :groups([<root>]), :!is_private
    );
    ok $rm.add-full( 'file:///home/marcel', $rd), 'add new item';
    $e = .move-item( 'file:///home/marcel', 'file:///home/marcel2');
    nok $e.is-valid, '.move-item()';
    $e = .move-item( 'file:///home/marcel', 'file:///home/marcel2');
    ok $e.is-valid, $e.message;
    $e = .remove-item('file:///home/marcel2');
    diag "'file:///home/marcel2' removed";

    my Gnome::Glib::List $l = .get-items;
    diag '.get-items(); ' ~ $l.length;
    if $l.length {
      $ri .= new(:native-object($l.data));
      ok 1, '.get-items() [0]: ' ~ $ri.get-uri;
      clear-list($l);
    }

    else {
      skip 'No uris in list', 1;
    }

    # is tested ok but inhibited if it does affect real live lists
    #ok 1, 'Items purged: ' ~ .purge-items;
  }
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::RecentManager $rm .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value, Bool :$approx = False,
    Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $rm.get-property( $prop, $gv);
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
  test-property( G_TYPE_INT, 'size', 'get-int', 10, :is-local);
  test-property( G_TYPE_STRING, 'filename', 'get-string', '.xbel', :is-local);
}

#-------------------------------------------------------------------------------
sub clear-list ( Gnome::Glib::List $l is copy ) {
  while $l.is-valid {
    my Gnome::Gtk3::RecentInfo $ri .= new(:native-object($l.data));
#note 'clear: ', $ri.get-uri;
    $ri.clear-object;
    $l .= next;
  }
  $l.first.clear-object;
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::RecentManager', {
  class MyClass is Gnome::Gtk3::RecentManager {
    method new ( |c ) {
      self.bless( :GtkRecentManager, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::RecentManager, '.new()';
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
      Gnome::Gtk3::RecentManager :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::RecentManager;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::RecentManager :$widget --> Str ) {

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

  my Gnome::Gtk3::RecentManager $rm .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $rm.register-signal( $sh, 'method', 'signal');

  my Promise $p = $rm.start-thread(
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
