use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Menu;
use Gnome::Gtk3::MenuItem;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::MenuItem $mi;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $mi .= new;
  isa-ok $mi, Gnome::Gtk3::MenuItem, ".new";
  isa-ok $mi.= new(:label<Open>), Gnome::Gtk3::MenuItem, '.new(:label)';
  isa-ok $mi.= new(:mnemonic<_Open>), Gnome::Gtk3::MenuItem,
    ".new(:mnemonic)";
}


#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  #Error: (MenuItem.t:35293): Gtk-CRITICAL **: 18:26:30.848: gtk_menu_item_set_accel_path: assertion 'accel_path == NULL || (accel_path[0] == '<' && strchr (accel_path, '/'))' failed
  # undefined is returned because AccelMap.add-entry() must be called first
  $mi.set-accel-path('MenuItem-test/File/Save');
  is $mi.get-accel-path, Str, '.set-accel-path() / .get-accel-path()';

  $mi.set-label('_Save');
  is $mi.get-label, '_Save', '.set-label() / .get-label()';

  $mi.set-reserve-indicator(True);
  ok $mi.get-reserve-indicator,
    '.set-reserve-indicator() / .get-reserve-indicator()';

  my Gnome::Gtk3::Menu $menu .= new;
  $mi.set-submenu($menu);

}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::MenuItem', {
  class MyClass is Gnome::Gtk3::MenuItem {
    method new ( |c ) {
      self.bless( :GtkMenuItem, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::MenuItem, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::MenuItem $mi .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $mi.get-property( $prop, $gv);
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
  #test-property( G_TYPE_BOOLEAN, 'homogeneous', 'get-boolean', False);
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
      Gnome::Gtk3::MenuItem :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::MenuItem;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::MenuItem :$widget --> Str ) {

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

  my Gnome::Gtk3::MenuItem $mi .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $mi.register-signal( $sh, 'method', 'signal');

  my Promise $p = $mi.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
