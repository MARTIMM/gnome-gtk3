use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::FileChooser;
use Gnome::Gtk3::FileChooserButton;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::FileChooserButton $fcb;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $fcb .= new(
    :title('test to select'),
    :action(GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER)
  );
  isa-ok $fcb, Gnome::Gtk3::FileChooserButton, '.new( :title, :action)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $fcb.set-title('abc');
  is $fcb.get-title, 'abc', '.set-title() / .get-title()';

  # $fcb.get-width-chars; returns -1 because it is not mapped
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  my Gnome::Gtk3::FileChooserButton $fcb .= new(:title('test to select'));

  sub test-property ( $type, Str $prop, Str $routine, $value ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $fcb.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    is $gv-value, $value, "property $prop";
    $gv.clear-object;
  }

  test-property( G_TYPE_STRING, 'title', 'get-string', 'test to select');
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::FileChooserButton', {
  class MyClass is Gnome::Gtk3::FileChooserButton {
    method new ( |c ) {
      self.bless( :GtkFileChooserButton, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::FileChooserButton, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
  #use Gnome::Glib::Main;
  use Gnome::Gtk3::Main;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method ... ( 'any-args', Gnome::Gtk3::FileChooserButton :$widget #`{{ --> ...}} ) {

      isa-ok $widget, Gnome::Gtk3::FileChooserButton;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::FileChooserButton :$widget --> Str ) {

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

  my Gnome::Gtk3::FileChooserButton $fcb .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.container-add($m);

  my SignalHandlers $sh .= new;
  $fcb.register-signal( $sh, 'method', 'signal');

  my Promise $p = $fcb.start-thread(
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
