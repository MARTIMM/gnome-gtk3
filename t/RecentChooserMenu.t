use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::RecentChooserMenu;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#`{{}}
#-------------------------------------------------------------------------------
class MyGuiClass is Gnome::Gtk3::RecentChooserMenu {
  submethod new ( |c ) {
    self.bless( :GtkRecentChooserMenu, |c);
  }
}

subtest 'User class test', {
  my MyGuiClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::RecentChooserMenu, '.new()';
}


#-------------------------------------------------------------------------------
my Gnome::Gtk3::RecentChooserMenu $rcm;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $rcm .= new;
  isa-ok $rcm, Gnome::Gtk3::RecentChooserMenu, '.new()';
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
