use v6;
use NativeCall;
use Test;

use Gnome::Glib::List;

use Gnome::Gtk3::RecentManager;
use Gnome::Gtk3::RecentInfo;
use Gnome::Gtk3::RecentChooserDialog;
use Gnome::Gtk3::Dialog;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::RecentChooserDialog $rcd;
my Gnome::Gtk3::RecentManager $rm;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $rcd .= new(
    :title('Recently Used'),
    :button-spec('Select', GTK_RESPONSE_ACCEPT, "Cancel", GTK_RESPONSE_REJECT)
  );
  isa-ok $rcd, Gnome::Gtk3::RecentChooserDialog, '.new( :title, :button-spec)';

  $rm .= new(:default);
  $rm.add-item('file:///tmp');
  $rcd .= new(
    :title('Recently Used'), :manager($rm),
#    :button-spec('Select', GTK_RESPONSE_ACCEPT, "Cancel", GTK_RESPONSE_REJECT)
    :button-spec('Select', GTK_RESPONSE_ACCEPT, "Cancel", GTK_RESPONSE_REJECT)
  );
  isa-ok $rcd, Gnome::Gtk3::RecentChooserDialog,
      '.new( :title, :manager, :button-spec)';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Glib::List $l = $rcd.get-items;
  diag '.get-items(); ' ~ $l.g_list_length;
  my Gnome::Gtk3::RecentInfo $ri .= new(:native-object($l.data));
  my $uris = $rcd.get-uris;
  is $ri.get-uri, $uris[0], '.get-uris() / .get-uri()';
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::RecentChooserDialog', {
  class MyClass is Gnome::Gtk3::RecentChooserDialog {
    method new ( |c ) {
      self.bless( :GtkRecentChooserDialog, |c, :title<Recent>);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::RecentChooserDialog, '$mgc.new()';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::RecentChooserDialog $rcd .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $rcd.get-property( $prop, $gv);
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
      Gnome::Gtk3::RecentChooserDialog :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::RecentChooserDialog;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::RecentChooserDialog :$widget --> Str ) {

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

  my Gnome::Gtk3::RecentChooserDialog $rcd .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.container-add($m);

  my SignalHandlers $sh .= new;
  $rcd.register-signal( $sh, 'method', 'signal');

  my Promise $p = $rcd.start-thread(
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
