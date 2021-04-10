use v6;
use NativeCall;
use Test;

use Gnome::Glib::Quark;
use Gnome::Glib::Error;
use Gnome::Glib::List;

use Gnome::Gtk3::RecentChooserMenu;
use Gnome::Gtk3::RecentChooser;
use Gnome::Gtk3::RecentInfo;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::RecentChooserMenu $rc;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $rc .= new;
  isa-ok $rc, Gnome::Gtk3::RecentChooserMenu;
  does-ok $rc, Gnome::Gtk3::RecentChooser;
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Glib::Quark $q .= new;
  is $q.to-string($rc.error-quark), 'gtk-recent-chooser-error-quark',
    '.error-quark()';

  given $rc {
    .set-show-private(True);
    ok .get-show-private, '.set-show-private() / .get-show-private()';

    .set-show-not-found(True);
    ok .get-show-not-found, '.set-show-not-found() / .get-show-not-found()';

    #RecentChooserMenu cannot have multiple selections, Error;
    #  (RecentChooser.t:141843): Gtk-WARNING **: 20:14:03.975:
    #  gtk_recent_chooser_menu_set_property: Choosers of type
    #  'GtkRecentChooserMenu' do not support selecting multiple items.
    #.set-select-multiple(True);
    nok .get-select-multiple, '.set-select-multiple() / .get-select-multiple()';

    .set-limit(20);
    is .get-limit, 20, '.set-limit() / .get-limit()';

    .set-local-only(True);
    ok .get-local-only, '.set-local-only() / .get-local-only()';

    .set-show-tips(True);
    ok .get-show-tips, '.set-show-tips() / .get-show-tips()';

    .set-show-icons(True);
    ok .get-show-icons, '.set-show-icons() / .get-show-icons()';

    .set-sort-type(GTK_RECENT_SORT_MRU);
    is .get-sort-type, GTK_RECENT_SORT_MRU,
      '.set-sort-type() / .get-sort-type()';

    my Gnome::Glib::Error $e = .set-current-uri(
      'file:///_h_oe_p_er_de_poep_.something'
    );
    ok $e.is-valid, $e.message;
    is .get-current-uri, Str, '.set-current-uri() / .get-current-uri()';

    $e = .select-uri('file:///_h_oe_p_er_de_poep_.something');
    ok $e.is-valid, $e.message;
    .unselect-uri('file:///_h_oe_p_er_de_poep_.something');

    # next shows error
    #  (RecentChooser.t:153542): Gtk-WARNING **: 13:43:08.530: This function is
    #  not implemented for widgets of class 'GtkRecentChooserMenu'
    #.select-all;
    #.unselect-all;

    my Gnome::Glib::List $l = .get-items;
    diag '.get-items(); ' ~ $l.g_list_length;
    if $l.g_list_length {
      my Gnome::Gtk3::RecentInfo $ri .= new(:native-object($l.data));
      my $uris = .get-uris;
      is $ri.get-uri, $uris[0], '.get-uris() / .get-uri()';
    }

    else {
      skip 'No uris in list', 1;
    }
  }
}

#-------------------------------------------------------------------------------
class Sorters {
  method alpha-uri (
    Gnome::Gtk3::RecentInfo $a, Gnome::Gtk3::RecentInfo $b
    --> Int
  ) {
    $a.get-uri cmp $b.get-uri
  }
}

subtest 'Sorting recent ...', {
  $rc.set-sort-type(GTK_RECENT_SORT_CUSTOM);
  $rc.set-sort-func( Sorters.new, 'alpha-uri');
#note "\nUris:\n  " ~ $rc.get-uris.join("\n  ");
  lives-ok {$rc.get-uris},
    '.set-sort-func(); ' ~ ($rc.get-uris[0] // '-') ~ ' …';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::RecentChooser $rc .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value, Bool :$approx = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $rc.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    if $approx {
      is-approx $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }

    else {
      is $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }
    $gv.clear-object;
  }

  # example calls
  test-property( G_TYPE_BOOLEAN, 'show-private', 'get-boolean', 1);
  test-property( G_TYPE_BOOLEAN, 'show-tips', 'get-boolean', 1);
  test-property( G_TYPE_BOOLEAN, 'show-not-found', 'get-boolean', 1);
  test-property( G_TYPE_BOOLEAN, 'select-multiple', 'get-boolean', 0);
  test-property( G_TYPE_BOOLEAN, 'local-only', 'get-boolean', 1);
  test-property( G_TYPE_INT, 'limit', 'get-int', 20);
  #test-property( G_TYPE_STRING, 'label', 'get-string', '...');
  #test-property( G_TYPE_FLOAT, 'xalign', 'get-float', 23e-2, :approx);
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
  #$w.add($m);

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
