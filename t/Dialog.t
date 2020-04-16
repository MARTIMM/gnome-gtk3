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

  my Gnome::Gtk3::Window $parent .= new(:title('My App'));
  $d .= new(
    :title('msg dialog'), :$parent,
    :flags(GTK_DIALOG_MODAL +| GTK_DIALOG_DESTROY_WITH_PARENT),
    :button-spec( 'Ok', GTK_RESPONSE_ACCEPT, "Cancel", GTK_RESPONSE_REJECT)
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
