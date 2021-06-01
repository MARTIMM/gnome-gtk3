use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::TargetTable;
use Gnome::Gtk3::TargetEntry;
use Gnome::Gtk3::TargetList;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TargetTable $tt .= new(:array([]));

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Array $targets = [
    N-GtkTargetEntry.new(
      :target<text/TeX>, :flags(GTK_TARGET_SAME_APP), :info(0x1f)
    ),
    N-GtkTargetEntry.new(
      :target<fortune-cookie>, :flags(GTK_TARGET_SAME_APP), :info(0x45)
    ),
  ];

  $tt .= new(:array($targets));
  my Array $r = $tt.get-array;
  my @tnames = ();
  for @$r -> $te {
#    note "t=$te.target(), f=$te.flags(), i=$te.info()";
    @tnames.push: $te.target;
  }

  is-deeply @tnames, [<text/TeX fortune-cookie>], '.new(:array)';


  my Gnome::Gtk3::TargetList $tl .= new(:$targets);
  $tt .= new(:list($tl));
  $r = $tt.get-array;
  @tnames = ();
  for @$r -> $te {
#    note "t=$te.target(), f=$te.flags(), i=$te.info()";
    @tnames.push: $te.target;
  }

  # when givin the array to a TargetList, the array items are prepended
  # one by one, so result is reversed when returned
  is-deeply @tnames, [<text/TeX fortune-cookie>.reverse], '.new(:list)';
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::TargetTable', {
  class MyClass is Gnome::Gtk3::TargetTable {
    method new ( |c ) {
      self.bless( :GtkTargetTable, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::TargetTable, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::TargetTable $tt .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $tt.get-property( $prop, $gv);
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
      Gnome::Gtk3::TargetTable :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::TargetTable;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::TargetTable :$widget --> Str ) {

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

  my Gnome::Gtk3::TargetTable $tt .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $tt.register-signal( $sh, 'method', 'signal');

  my Promise $p = $tt.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
