use v6;
use NativeCall;
use Test;

#use Gnome::Gtk3::Window;
use Gnome::Gtk3::PopoverMenu;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#`{{
#-------------------------------------------------------------------------------
class MyGuiClass is Gnome::Gtk3::PopoverMenu {
  submethod new ( |c ) {
    self.bless( :GtkPopoverMenu, |c);
  }
}

subtest 'User class test', {
  my MyGuiClass $mgc .= new;
  isa-ok $mgc, Gnome::Gtk3::PopoverMenu, '.new()';
}

}}
#-------------------------------------------------------------------------------
#my Gnome::Gtk3::Window $w .= new;
#$w.set-title('Test-Popup');
my Gnome::Gtk3::PopoverMenu $pm;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $pm .= new;
  isa-ok $pm, Gnome::Gtk3::PopoverMenu, '.new()';
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
