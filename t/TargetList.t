use v6;
use NativeCall;
use Test;
use lib '../gnome-gdk3/lib';

use Gnome::Gtk3::TargetList;
use Gnome::Gtk3::TargetEntry;
use Gnome::Gtk3::TextBuffer;

use Gnome::Gdk3::Atom;

#use Gnome::Glib::List;

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
  $tl .= new(
    :targets[
      Gnome::Gtk3::TargetEntry.new(
        :target<text/TeX>, :flags(GTK_TARGET_SAME_APP), :info(22)
      ),
      Gnome::Gtk3::TargetEntry.new(
        :target<fortune-cookie>, :flags(GTK_TARGET_SAME_APP), :info(0x22)
      ),
    ]
  );

  $tl.add( Gnome::Gdk3::Atom.new(:intern<number>), GTK_TARGET_SAME_APP, 0);
  $tl.add( Gnome::Gdk3::Atom.new(:intern<string>), GTK_TARGET_SAME_APP, 1);

  my List $list-find = $tl.find(Gnome::Gdk3::Atom.new(:intern<text>));
  nok $list-find[0], '.find(): atom \'text\' not found';
  $list-find = $tl.find(Gnome::Gdk3::Atom.new(:intern<number>));
  ok $list-find[0], '.find(): atom \'number\' found';
  is $list-find[1], 0, '.find(): info == 0';
#`{{
  my Gnome::Glib::List $lt .= new(
    :native-object($tl.get-native-object-no-reffing.list)
  );

  for ^$lt.length -> $i {
    my N-GtkTargetPair $tp = nativecast( N-GtkTargetPair, $lt.nth-data($i));
    my Gnome::Gdk3::Atom $a .= new(:native-object($tp.target));
    note "target name: $a.name()";
  }
}}
  my Array $te = [
    Gnome::Gtk3::TargetEntry.new(
      :target<foobar>, :flags(GTK_TARGET_SAME_APP), :info(2)
    ),
    Gnome::Gtk3::TargetEntry.new(
      :target<baz>, :flags(GTK_TARGET_SAME_APP), :info(3)
    ),
  ];

  $tl.add-table($te);

#`{{
  my Gnome::Glib::List $lt .= new(
    :native-object($tl.get-native-object-no-reffing.list)
  );

  for ^$lt.length -> $i {
    my N-GtkTargetPair $tp = nativecast( N-GtkTargetPair, $lt.nth-data($i));
    my Gnome::Gdk3::Atom $a .= new(:native-object($tp.target));
    note "target name: $a.name()";
  }
}}

  my @tnames = ();
  for @($tl.table-from-list) -> $te {
    @tnames.push: $te.target;
  }
  is-deeply @tnames, [<baz foobar fortune-cookie text/TeX number string>],
    '.table-from-list()';

  $list-find = $tl.find(Gnome::Gdk3::Atom.new(:intern<foobar>));
  ok $list-find[0], '.find(): atom \'foobar\' found';
  is $list-find[1], 2, '.find(): info == 2';
  $list-find = $tl.find(Gnome::Gdk3::Atom.new(:intern<baz>));
  ok $list-find[0], '.find(): atom \'baz\' found';
  is $list-find[1], 3, '.find(): info == 3';


  $tl.add-image-targets( 0x29, True);
  $list-find = $tl.find(Gnome::Gdk3::Atom.new(:intern<image/bmp>));
  ok $list-find[0], '.add-image-targets(): atom \'image/bmp\' found';
  is $list-find[1], 0x29, '.add-image-targets(): info == 0x29';

  # it runs but no extra narget types are added
  my Gnome::Gtk3::TextBuffer $tb .= new;
  $tb.set-text('{\rtf1\ansi{\fonttbl\f0\fswiss Helvetica;}\f0\pard This is some {\b bold} text.\par}');
  $tl.add-rich-text-targets( 0xf29, True, $tb);


  $tl.add-text-targets(0x456);
  $list-find = $tl.find(Gnome::Gdk3::Atom.new(:intern<text/plain;charset=utf-8>));
  ok $list-find[0], '.add-text-targets(): atom \'text/plain;charset=utf-8\' found';
  is $list-find[1], 0x456, '.add-text-targets(): info == 0x456';

  $tl.add-uri-targets(0x9876);
  $list-find = $tl.find(Gnome::Gdk3::Atom.new(:intern<text/uri-list>));
  ok $list-find[0], '.add-uri-targets(): atom \'text/uri-list\' found';
  is $list-find[1], 0x9876, '.add-uri-targets(): info == 0x9876';

  $tl.remove(Gnome::Gdk3::Atom.new(:intern<image/icon>));
#  for @($tl.table-from-list) -> $te {
#    note 'tg: ', $te.target;
#  }
  $list-find = $tl.find(Gnome::Gdk3::Atom.new(:intern<image/icon>));
  nok $list-find[0], '.remove()';
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
