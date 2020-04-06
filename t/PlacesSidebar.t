use v6;
use NativeCall;
use Test;

use Gnome::Gio::File;

use Gnome::Gtk3::PlacesSidebar;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#`{{
#-------------------------------------------------------------------------------
class MyGuiClass is Gnome::Gtk3::PlacesSidebar {
  submethod new ( |c ) {
    self.bless( :GtkPlacesSidebar, |c);
  }
}

subtest 'User class test', {
  my MyGuiClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::PlacesSidebar, '.new()';
}

}}
#-------------------------------------------------------------------------------
my Gnome::Gtk3::PlacesSidebar $ps;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $ps .= new;
  isa-ok $ps, Gnome::Gtk3::PlacesSidebar, '.new()';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $ps.set-open-flags(GTK_PLACES_OPEN_NORMAL +| GTK_PLACES_OPEN_NEW_TAB);
  is $ps.get-open-flags, GTK_PLACES_OPEN_NORMAL +| GTK_PLACES_OPEN_NEW_TAB,
     '.set-open-flags() / .get-open-flags()';

  my Gnome::Gio::File $f .= new(:native-object($ps.get-location));
  nok $f.is-valid, '.get-location() no location selected';

#`{{
  $f .= new(:path<t/data/Add.png>);
  $ps.set-location($f);
  ok $f.is-valid, '.get-location() location not in places list';
note "P: ", $f.get-path;

  $f .= new(:path<Desktop>);
  $ps.set-location($f);
  ok $f.is-valid, '.get-location() location not in places list';
  $f .= new(:native-object($ps.get-location));

note "P: ", $f.get-path;
}}

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
