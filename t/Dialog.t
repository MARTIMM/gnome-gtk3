use v6;
use NativeCall;
use Test;

use Gnome::N::N-GObject;
use Gnome::Gtk3::Dialog;
use Gnome::Gtk3::Window;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Dialog $d;

#-------------------------------------------------------------------------------
subtest 'ISA tests', {
  $d .= new;
  isa-ok $d, Gnome::Gtk3::Dialog, '.new';

  my Gnome::Gtk3::Window $top-window .= new(:title('My App'));
  my N-GObject $n = $d.new-with-buttons(
    'msg dialog', $top-window,
    GTK_DIALOG_MODAL +| GTK_DIALOG_DESTROY_WITH_PARENT,
    'Ok', GTK_RESPONSE_ACCEPT, "Cancel", GTK_RESPONSE_REJECT
  );
  isa-ok $n, N-GObject, '.new-with-buttons()';

  $d .= new(:widget($n));
  isa-ok $d, Gnome::Gtk3::Dialog, '.new(:widget)';

  $d .= new(
    :title('msg dialog'), :parent($top-window),
    :flags(GTK_DIALOG_MODAL +| GTK_DIALOG_DESTROY_WITH_PARENT),
    :button-spec('Ok', GTK_RESPONSE_ACCEPT, "Cancel", GTK_RESPONSE_REJECT)
  );
  isa-ok $d, Gnome::Gtk3::Dialog, '.new(:title)';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

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
