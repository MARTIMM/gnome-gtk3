use v6;
use NativeCall;
use Test;

use Gnome::Glib::List;

use Gnome::Gtk3::RecentManager;
use Gnome::Gtk3::RecentChooserWidget;
use Gnome::Gtk3::RecentInfo;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::RecentChooserWidget $rcw;
my Gnome::Gtk3::RecentManager $rm;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $rcw .= new;
  isa-ok $rcw, Gnome::Gtk3::RecentChooserWidget, '.new()';

  $rm .= new(:default);
  $rm.add-item('file:///tmp');
  $rcw .= new(:manager($rm));
  isa-ok $rcw, Gnome::Gtk3::RecentChooserWidget, '.new(:manager)';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Glib::List $l = $rcw.get-items;
  diag '.get-items(); ' ~ $l.g_list_length;
  if $l.g_list_length {
    my Gnome::Gtk3::RecentInfo $ri .= new(:native-object($l.data));
    my $uris = $rcw.get-uris;
    is $ri.get-uri, $uris[0], '.get-uris() / .get-uri()';
  }

  else {
    skip 'No uris in list', 1;
  }
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::RecentChooserWidget', {
  class MyClass is Gnome::Gtk3::RecentChooserWidget {
    method new ( |c ) {
      self.bless( :GtkRecentChooserWidget, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::RecentChooserWidget, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::RecentChooserWidget $rcw .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $rcw.get-property( $prop, $gv);
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
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', 0);
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
      Gnome::Gtk3::RecentChooserWidget :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::RecentChooserWidget;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::RecentChooserWidget :$widget --> Str ) {

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

  my Gnome::Gtk3::RecentChooserWidget $rcw .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.container-add($m);

  my SignalHandlers $sh .= new;
  $rcw.register-signal( $sh, 'method', 'signal');

  my Promise $p = $rcw.start-thread(
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
