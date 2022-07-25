use v6;
use NativeCall;
use Test;

use Gnome::Glib::List;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::ListBox;
use Gnome::Gtk3::ListBoxRow;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::CheckButton;
use Gnome::Gtk3::Label;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::ListBox() $lb .= new;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $lb, Gnome::Gtk3::ListBox;
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::ListBox', {
  class MyClass is Gnome::Gtk3::ListBox {
    method new ( |c ) {
      self.bless( :GtkListBox, |c);
    }

    submethod BUILD ( *%options ) {

    }
  }

  my MyClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::ListBox, 'MyClass.new()';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {

  # Create an entry in a ListBox. This is a grid containing a CheckButton
  # and a Label
  my Gnome::Gtk3::Grid $grid .= new;
#  $grid.set-visible(True);

  my Gnome::Gtk3::CheckButton $check .= new(:label('abc'));
#  $check.set-visible(True);
  $grid.gtk-grid-attach( $check, 0, 0, 1, 1);

  my Gnome::Gtk3::Label $label .= new(:text('first entry'));
#  $label.set-visible(True);
  $grid.gtk-grid-attach( $label, 1, 0, 1, 1);

  # Add the grid to the ListBox
  $lb.add($grid);

  # Get a list of widgets. There is only one row and is a ListBoxRow. This
  # widget is automatically inserted when the grid was added to the ListBox.
  my Gnome::Glib::List() $gl = $lb.get-children;
  is $gl.length, 1, 'one listbox row in listbox';

  # Get the row and create the ListBoxRow from the native object
  my Gnome::Gtk3::ListBoxRow() $lb-row = $lb.get-row-at-index(0);

  is $lb-row.is-selected, 0, 'row is not selected';
  $lb.select-all;
  is $lb-row.is-selected, 0, 'row is not selected';
  $lb.set-selection-mode(GTK_SELECTION_MULTIPLE);
  $lb.select-all;
  is $lb-row.is-selected, 1, 'row is selected';

  # Get the native grid object from a child and create the Grid again.
  my Gnome::Gtk3::Grid() $lb-grid = $lb-row.get-child;
  $gl = $lb-grid.get-children;
  is $gl.length, 2, 'two entries in grid';

  my Gnome::Gtk3::CheckButton() $lb-cb = $lb-grid.get-child-at( 0, 0);
  is $lb-cb.get-label, 'abc', 'checkbox label found';

  subtest 'selected-foreach', {
    # get selected entries
    class X {
      method cb (
        Gnome::Gtk3::ListBox() $lbx, Gnome::Gtk3::ListBoxRow() $lbxr, :$test ) {
        is $lbx.widget-get-name(), 'GtkListBox', 'listbox';
        is $lbxr.widget-get-name(), 'GtkListBoxRow', 'listboxrow';
        is $test, 'abc', 'user option';
      }
    }

  #Gnome::N::debug(:on);
    $lb.selected-foreach( X.new, 'cb', :test<abc>);
  }
}

#-------------------------------------------------------------------------------
done-testing;

=finish


#-------------------------------------------------------------------------------
subtest 'Properties …', {
#  my Gnome::Gtk3::ListBox $lb .= new;
  my @r = $lb.get-properties(
#    name, type,  …
  );
  is-deeply @r, [
#    value, …
  ], 'properties: ' ~ (
#    name, …
  ).join(', ');
}

#-------------------------------------------------------------------------------
subtest 'Signals …', {
  use Gnome::Gtk3::Main;
  use Gnome::N::GlibToRakuTypes;

  my Gnome::Gtk3::Main $main .= new;

  class SignalHandlers {
    has Bool $!signal-processed = False;

    method … (
      'any-args',
      Gnome::Gtk3::ListBox() :_native-object($_widget), gulong :$_handler-id
      # --> …
    ) {

      isa-ok $_widget, Gnome::Gtk3::ListBox;
      $!signal-processed = True;
    }

    method signal-emitter ( Gnome::Gtk3::ListBox :$widget --> Str ) {

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      $widget.emit-by-name(
        'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      );
      is $!signal-processed, True, '\'…\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }

      #$!signal-processed = False;
      #$widget.emit-by-name(
      #  'signal',
      #  'any-args',
      #  :return-type(int32),
      #  :parameters([int32,])
      #);
      #is $!signal-processed, True, '\'…\' signal processed';

      while $main.gtk-events-pending() { $main.iteration-do(False); }
      sleep(0.4);
      $main.gtk-main-quit;

      'done'
    }
  }

  my Gnome::Gtk3::ListBox $lb .= new;

  #my Gnome::Gtk3::Window $w .= new;
  #$w.add($m);

  my SignalHandlers $sh .= new;
  $lb.register-signal( $sh, 'method', 'signal');

  my Promise $p = $lb.start-thread(
    $sh, 'signal-emitter',
    # :!new-context,
    # :start-time(now + 1)
  );

  is $main.gtk-main-level, 0, "loop level 0";
  $main.gtk-main;
  #is $main.gtk-main-level, 0, "loop level is 0 again";

  is $p.result, 'done', 'emitter finished';
}

#-------------------------------------------------------------------------------
subtest 'Themes …', {
}

#-------------------------------------------------------------------------------
subtest 'Interface …', {
}
