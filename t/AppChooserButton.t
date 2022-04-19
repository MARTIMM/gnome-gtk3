use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::AppChooserButton;

#use Gnome::Gio::Icon;
use Gnome::Gio::File;
use Gnome::Gio::FileIcon;
#use Gnome::Gio::AppInfo;

use Gnome::Glib::Error;
use Gnome::Glib::List;

use Gnome::N::N-GObject;
#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::AppChooserButton $acb;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $acb .= new(:content-type<text/plain>);
  isa-ok $acb, Gnome::Gtk3::AppChooserButton, '.new()';
}


#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  lives-ok { $acb.append-separator }, '.append-separator()';

  $acb.set-heading('test-dialog');
  is $acb.get-heading, 'test-dialog', '.set-heading() / .get-heading()';

  $acb.set-show-default-item(True);
  ok $acb.get-show-default-item,
    '.set-show-default-item() / .get-show-default-item()';

  $acb.set-show-dialog-item(True);
  ok $acb.get-show-dialog-item,
    '.set-show-dialog-item() / .get-show-dialog-item()';

  lives-ok {
    my Gnome::Gio::File $file .= new(:path<LICENSE>);
    my Gnome::Gio::FileIcon $filie-icon .= new(:$file);
    $acb.append-custom-item( 'ACB', 'AppChooserButton.t', $filie-icon);
    $acb.set-active-custom-item('ACB');
  }, '.append-custom-item() / .set-active-custom-item()';

#`{{ Nice test code to remove old id's from list
    my Gnome::Gio::AppInfo $ai = $acb.get-app-info-rk;

    my Gnome::Glib::List $list = $ai.get-all;
    ok $list.length > 1, '.get-all()';
    for ^$list.length -> $nth {
      my Gnome::Gio::AppInfo $ai3 .= new(
        :native-object(nativecast( N-GObject, $list.nth-data($nth)))
      );

      my Str $id = $ai3.get-id;

      diag (
        "  " ~ $ai3.get-display-name, $id, $ai3.get-description // '-'
      ).join(", ");

    note 'remove: ', $id, ', result: ', $ai3.delete
      if $id ~~ m/ userapp '-' ls /;
    }
#      diag (
#        "  " ~ $ai3.get-name, $ai3.get-display-name, $ai3.get-id,
#        $ai3.get-description, $ai3.get-commandline, $ai3.get-executable
#      ).join("\n  ");
    $list.clear-object; #TODO no items cleared
}}
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::AppChooserButton', {
  class MyClass is Gnome::Gtk3::AppChooserButton {
    method new ( |c ) {
      self.bless( :GtkAppChooserButton, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::AppChooserButton, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
done-testing;

=finish

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::AppChooserButton $acb .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $acb.get-property( $prop, $gv);
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
      Gnome::Gtk3::AppChooserButton :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::AppChooserButton;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::AppChooserButton :$widget --> Str ) {

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

  my Gnome::Gtk3::AppChooserButton $acb .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $acb.register-signal( $sh, 'method', 'signal');

  my Promise $p = $acb.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
