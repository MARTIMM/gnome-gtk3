use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Targets;
use Gnome::Gtk3::TextBuffer;

use Gnome::Gdk3::Atom;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Targets $t;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $t .= new;
  isa-ok $t, Gnome::Gtk3::Targets, '.new()';
}


#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Array $targets = [
    Gnome::Gdk3::Atom.new(:intern<text/plain>),
#    Gnome::Gdk3::Atom.new(:intern<image/bmp>),
  ];

  nok $t.include-image( $targets, True), '.include-image(): targets not ok';
  $targets.push: Gnome::Gdk3::Atom.new(:intern<image/bmp>);
  ok $t.include-image( $targets, True), '.include-image(): targets ok';


  ok $t.include-text( $targets), '.include-text(): targets ok';

  my Gnome::Gtk3::TextBuffer $tb .= new;
  $tb.set-text('abc <b> def </b> αβγ');
  nok $t.include-rich-text( $targets, $tb),
    '.include-rich-text(): targets not ok';
#TODO checkout gtk_text_buffer_get_deserialize_formats --> GdkAtom *
#  $targets.push: Gnome::Gdk3::Atom.new(:intern<text/rtf>);
#  nok $t.include-rich-text( $targets, $tb), '.include-rich-text(): bad text';
#  $tb.set-text('{\rtf\ansi\pard Dit is {\b vetgedrukte} tekst.\par}');
#  ok $t.include-rich-text( $targets, $tb),
#    '.include-rich-text(): targets and text ok';

  nok $t.include-uri($targets), '.include-uri(): targets not ok';
  $targets.push: Gnome::Gdk3::Atom.new(:intern<text/uri-list>);
  ok $t.include-uri($targets), '.include-uri(): targets ok';
}

#-------------------------------------------------------------------------------
done-testing;

=finish


#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Targets', {
  class MyClass is Gnome::Gtk3::Targets {
    method new ( |c ) {
      self.bless( :GtkTargets, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Targets, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Targets $t .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $t.get-property( $prop, $gv);
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
      Gnome::Gtk3::Targets :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::Targets;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Targets :$widget --> Str ) {

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

  my Gnome::Gtk3::Targets $t .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $t.register-signal( $sh, 'method', 'signal');

  my Promise $p = $t.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
