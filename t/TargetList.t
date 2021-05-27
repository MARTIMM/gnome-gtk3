use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::TargetList;
use Gnome::Gdk3::Atom;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TargetList $tl;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $tl .= new;
  isa-ok $tl, Gnome::Gtk3::TargetList, '.new()';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  $tl.add( Gnome::Gdk3::Atom.new(:intern<number>), GTK_TARGET_SAME_APP, 0);
  $tl.add( Gnome::Gdk3::Atom.new(:intern<string>), GTK_TARGET_SAME_APP, 1);

  my List $list-find = $tl.find(Gnome::Gdk3::Atom.new(:intern<text>));
  nok $list-find[0], '.find(): atom \'text\' not found';
  $list-find = $tl.find(Gnome::Gdk3::Atom.new(:intern<number>));
  ok $list-find[0], '.find(): atom \'number\' found';
  is $list-find[1], 0, '.find(): info == 0';

#`{{
TODO TargetEntry does not work right
note $tl.table-from-list.gist;

#note $?LINE;
  my Array $te = [
    Gnome::Gtk3::TargetEntry.new(
      :target<foobar>, :flags(GTK_TARGET_SAME_APP), :info(2)
    ),
  ];
  $tl.clear-object;
  $tl = Gnome::Gtk3::TargetList.new; #(:targets($te));
  $tl.add-table($te);
note $tl.table-from-list.gist;

  $list-find = $tl.find(Gnome::Gdk3::Atom.new(:intern<foobar>));
  ok $list-find[0], '.find(): atom \'foobar\' found';
  is $list-find[1], 2, '.find(): info == 2';
}}
}


#-------------------------------------------------------------------------------
done-testing;

=finish


#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::TargetList', {
  class MyClass is Gnome::Gtk3::TargetList {
    method new ( |c ) {
      self.bless( :GtkTargetList, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::TargetList, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::TargetList $tl .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $tl.get-property( $prop, $gv);
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
      Gnome::Gtk3::TargetList :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::TargetList;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::TargetList :$widget --> Str ) {

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

  my Gnome::Gtk3::TargetList $tl .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $tl.register-signal( $sh, 'method', 'signal');

  my Promise $p = $tl.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
