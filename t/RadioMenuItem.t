use v6;
use NativeCall;
use Test;

use Gnome::Glib::SList;
use Gnome::Gtk3::RadioMenuItem;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::RadioMenuItem $rmi;
my Gnome::Glib::SList $sl .= new;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $rmi .= new(:group($sl));
  isa-ok $rmi, Gnome::Gtk3::RadioMenuItem, '.new(:group)';
  $sl .= new(:native-object($rmi.get-group));
  is $sl.slist-length(), 1, '.get-group()';

  $rmi .= new( :group($sl), :label('Size 10x10'));
  isa-ok $rmi, Gnome::Gtk3::RadioMenuItem, '.new( :group, :label)';

  $rmi .= new( :group($sl), :mnemonic('_Size 100x100'));
  isa-ok $rmi, Gnome::Gtk3::RadioMenuItem, '.new( :group, :mnemonic)';

  $rmi .= new(:group-widget($rmi));
  isa-ok $rmi, Gnome::Gtk3::RadioMenuItem, '.new(:group-widget)';

  $rmi .= new( :group-widget($rmi), :label('Size 10x1000'));
  isa-ok $rmi, Gnome::Gtk3::RadioMenuItem, '.new( :group-widget, :label)';

  $rmi .= new( :group-widget($rmi), :mnemonic('_Big Size 1000x1000'));
  isa-ok $rmi, Gnome::Gtk3::RadioMenuItem, '.new( :group-widget, :mnemonic)';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  is $rmi.get-label, '_Big Size 1000x1000', '.get-label()';

  $sl .= new(:native-object($rmi.get-group));
  is $sl.slist-length, 6, '.get-group()';

  my Gnome::Gtk3::RadioMenuItem $rmi2 .= new(
    :group(N-GSList), :mnemonic('_Size 100x100')
  );
  $rmi2.set-group($sl);
  $sl .= new(:native-object($rmi2.get-group));
  is $sl.slist-length, 7, '.set-group()';

  my Gnome::Gtk3::RadioMenuItem $rmi3 .= new( :group(N-GSList), :label<bla>);
  $rmi3.join-group($rmi2);
  $sl .= new(:native-object($rmi3.get-group));
  is $sl.slist-length, 8, '.join-group()';
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::RadioMenuItem', {
  class MyClass is Gnome::Gtk3::RadioMenuItem {
    has Gnome::Glib::SList $!group;

    method new ( |c ) {
      self.bless( :GtkRadioMenuItem, |c, :group(N-GSList), :label<1st>);
    }

    submethod BUILD ( *%options ) {
      $!group .= new(:native-object(self.get-group));
    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::RadioMenuItem, '$mgc.new()';
  my Gnome::Glib::SList $gsl .= new(:native-object($mgc.get-group));
  is $gsl.slist-length, 1, '$mgc.get-group()';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::RadioMenuItem $rmi .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value, Bool :$approx = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $rmi.get-property( $prop, $gv);
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
      Gnome::Gtk3::RadioMenuItem :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::RadioMenuItem;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::RadioMenuItem :$widget --> Str ) {

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

  my Gnome::Gtk3::RadioMenuItem $rmi .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.container-add($m);

  my SignalHandlers $sh .= new;
  $rmi.register-signal( $sh, 'method', 'signal');

  my Promise $p = $rmi.start-thread(
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
