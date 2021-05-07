use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Window;
use Gnome::Gtk3::Notebook;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Enums;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Window $w .= new;
my Gnome::Gtk3::Notebook $n .= new;
$w.add($n);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $n, Gnome::Gtk3::Notebook, '.new()';
}

#-------------------------------------------------------------------------------
# set environment variable 'raku-test-all' if rest must be tested too.
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  my Gnome::Gtk3::Grid $g1 .= new;
  $g1.set-name('g1');

  my Gnome::Gtk3::Grid $g2 .= new;
  $g2.set-name('g2');

  my Gnome::Gtk3::Grid $g3 .= new;
  $g3.set-name('g3');

  my Gnome::Gtk3::Button $b1 .= new(:label<Actie!>);
  $b1.set-name('b1');

  is $n.append-page( $g1, Gnome::Gtk3::Label.new(:text('page 1'))),
    0, '.append-page(): 0';
  is $n.append-page-menu(
      $g2, Gnome::Gtk3::Label.new(:text('page 2')),
      Gnome::Gtk3::Label.new(:text('menu 2'))
  ), 1, '.append-page-menu(): 1';

  $n.detach-tab($g2);
  is $n.get-n-pages, 1, '.detach-tab() / .get-n-pages()';

  # repair and add another
  $g2 .= new;
  $g2.set-name('g2');
  $n.append-page-menu(
      $g2, Gnome::Gtk3::Label.new(:text('page 2')),
      Gnome::Gtk3::Label.new(:text('menu 2'))
  );
  $n.append-page( $g3, Gnome::Gtk3::Label.new(:text('page 3')));
note 'N pages: ', $n.get-n-pages;

  $n.set-action-widget( $b1, GTK_PACK_END);
  is $n.get-action-widget-rk(GTK_PACK_END).get-name, 'b1',
    '.set-action-widget() / .get-action-widget-rk()';

  # must make widgets visible…
  $w.show-all;
  $n.set-current-page(2);
  is $n.get-current-page, 2, '.set-current-page() / .get-current-page()';

  $n.set-group-name('group 1');
  is $n.get-group-name, 'group 1', '.set-group-name() / .get-group-name()';

  $n.set-menu-label( $g2, Gnome::Gtk3::Label.new(:text('menu 2a')));
  is $n.get-menu-label-rk($g2).get-text, 'menu 2a',
    '.set-menu-label() / .get-menu-label-rk()';

  $n.set-menu-label-text( $g2, 'menu 2b');
  is $n.get-menu-label-text($g2), 'menu 2b',
    '.set-menu-label-text() / .get-menu-label-text()';

  my Gnome::Gtk3::Grid $page = $n.get-nth-page-rk(2);
  is $page.get-name, 'g3', '.get-nth-page-rk()';

  $n.set-scrollable(True);
  ok $n.get-scrollable, '.set-scrollable() / .get-scrollable()';

  $n.set-show-border(True);
  ok $n.get-show-border, '.set-show-border() / .get-show-border()';

  $n.set-show-tabs(True);
  ok $n.get-show-tabs, '.set-show-tabs() / .get-show-tabs()';

  $n.set-tab-detachable( $g1, True);
  ok $n.get-tab-detachable($g1),
    '.set-tab-detachable() / .get-tab-detachable()';

  $n.set-tab-label( $g2, Gnome::Gtk3::Label.new(:text('page 2b')));
  is $n.get-tab-label-rk($g2).get-text, 'page 2b',
    '.set-tab-label() / .get-tab-label-rk()';

  $n.set-tab-label-text( $g2, 'page 2c');
  is $n.get-tab-label-text($g2), 'page 2c',
    '.set-tab-label-text() / .get-tab-label-text()';

  $n.set-tab-pos(GTK_POS_RIGHT);
  is $n.get-tab-pos, GTK_POS_RIGHT, '.set-tab-pos() / .get-tab-pos()';

  $n.set-tab-reorderable( $g1, True);
  ok $n.get-tab-reorderable($g1),
   '.set-tab-reorderable() / .get-tab-reorderable()';

  my Gnome::Gtk3::Grid $g4 .= new;
  $g4.set-name('g4');
  $n.insert-page( $g4, Gnome::Gtk3::Label.new(:text('page 4')), 1);
  is $n.get-nth-page-rk(1).get-name, 'g4', '.insert-page()';

  my Gnome::Gtk3::Grid $g5 .= new;
  $g5.set-name('g5');
  $n.insert-page-menu(
    $g5, Gnome::Gtk3::Label.new(:text('page 5')),
    Gnome::Gtk3::Label.new(:text('page 5 menu')), 1
  );
  is $n.get-nth-page-rk(1).get-name, 'g5', '.insert-page-menu()';


  #TODO don't know what next-page() does, seems to stuck on one page (=4)
  # sequence messed up by inserts
  diag 'np: ' ~ $n.get-n-pages;
  for ($g1,$g2,$g3,$g4,$g5) -> $g {
    diag $g.get-name ~ ', ' ~ $n.page-num($g);
  }
  $n.set-current-page(1);
  lives-ok { $n.next-page; }, '.next-page(): 1 -> ' ~ $n.get-current-page;

  lives-ok { $n.popup-disable; }, '.popup-disable(): ';
  lives-ok { $n.popup-enable; }, '.popup-enable(): ';


  my Gnome::Gtk3::Grid $g6 .= new;
  $g6.set-name('g6');
  $n.prepend-page( $g6, Gnome::Gtk3::Label.new(:text('page 6')));
  is $n.get-nth-page-rk(0).get-name, 'g6', '.prepend-page()';

  my Gnome::Gtk3::Grid $g7 .= new;
  $g7.set-name('g7');
  $n.prepend-page-menu(
    $g7, Gnome::Gtk3::Label.new(:text('page 7')),
    Gnome::Gtk3::Label.new(:text('page 7 menu'))
  );
  is $n.get-nth-page-rk(0).get-name, 'g7', '.prepend-page-menu()';

  #TODO don't know what prev-page() does, seems to stuck on one page (=4)
  for ($g1,$g2,$g3,$g4,$g5,$g6,$g7) -> $g {
    diag $g.get-name ~ ', ' ~ $n.page-num($g);
  }
  $n.set-current-page(2);
  lives-ok { $n.prev-page; }, '.prev-page(): 2 -> ' ~ $n.get-current-page;

  $n.reorder-child( $g4, 0);
  is $n.get-nth-page-rk(0).get-name, 'g4', '.reorder-child()';


  lives-ok { $n.remove-page(5); }, '.remove-page()';
}

#-------------------------------------------------------------------------------
done-testing;

=finish


#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::Notebook', {
  class MyClass is Gnome::Gtk3::Notebook {
    method new ( |c ) {
      self.bless( :GtkNotebook, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::Notebook, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::Notebook $n .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value,
    Bool :$approx = False, Bool :$is-local = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $n.get-property( $prop, $gv);
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
      Gnome::Gtk3::Notebook :$_widget, gulong :$_handler-id
      # --> ...
    ) {

      isa-ok $_widget, Gnome::Gtk3::Notebook;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::Notebook :$widget --> Str ) {

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

  my Gnome::Gtk3::Notebook $n .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $n.register-signal( $sh, 'method', 'signal');

  my Promise $p = $n.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}
