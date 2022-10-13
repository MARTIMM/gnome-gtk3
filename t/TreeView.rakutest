use v6;
use NativeCall;
use Test;

use Gnome::GObject::Type;
use Gnome::Gtk3::TreeView;
use Gnome::Gtk3::ListStore;
use Gnome::Gtk3::TreeViewColumn;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::TreeView $tv;
my Gnome::Gtk3::TreeViewColumn $tvc;
my Gnome::Gtk3::ListStore $ls;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $tv .= new;
  isa-ok $tv, Gnome::Gtk3::TreeView, '.new';

  $ls .= new(:field-types( G_TYPE_INT, G_TYPE_STRING));
  $tv .= new(:model($ls));
  isa-ok $tv, Gnome::Gtk3::TreeView, '.new(:model)';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  my Gnome::Gtk3::ListStore $ls2 .= new(:native-object($tv.get-model));
  is $ls.iter-n-children(Any), 0, '.get-model()';

  $tv .= new;
  isa-ok $tv, Gnome::Gtk3::TreeView, '.new';
  is $tv.get-model.defined, False, 'no model defined';
  $tv.set-model($ls2);
  is $tv.get-model.defined, True, '.set-model()';

  ok $tv.get-headers-visible, '.get_headers_visible()';
  $tv.set_headers_visible(False);
  nok $tv.get-headers-visible, '.set_headers_visible()';
  $tv.set_headers_visible(True);

  ok $tv.get_headers_clickable, '.get_headers_clickable()';
#  $tv.set_headers_clickable(False);
#  nok $tv.get_headers_clickable, '.set_headers_clickable()';
#  $tv.set_headers_clickable(True);

  nok $tv.get_activate_on_single_click, '.get_activate_on_single_click()';
  $tv.set_activate_on_single_click(True);
  ok $tv.get_activate_on_single_click, '.set_activate_on_single_click()';

  $tvc .= new;
  $tvc.set-title('book title');
  $tv.append-column($tvc);

  my Gnome::Gtk3::TreeViewColumn $tvc2 .= new(
    :native-object($tv.get-column(0))
  );
  is $tvc2.get-title, 'book title', '.append-column() / .get-column()';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
}

#-------------------------------------------------------------------------------
subtest 'Themes ...', {
}

#-------------------------------------------------------------------------------
subtest 'Signals ...', {
}
}}

#-------------------------------------------------------------------------------
done-testing;
