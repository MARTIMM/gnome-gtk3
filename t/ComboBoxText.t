use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::ComboBoxText;

#use Gnome::N::X;
#Gnome::N::debug(:on);

my Gnome::Gtk3::ComboBoxText $cbt .= new(:empty);
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  isa-ok $cbt, Gnome::Gtk3::ComboBoxText;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $cbt.append-text('Amerika');
  $cbt.append-text('Australia');
  $cbt.append-text('China');
  $cbt.append-text('Great-Brittain');
  $cbt.append-text('Netherlands');
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
  is $cbt.get-has-entry, 0, 'no Gnome::Gtk3::Entry';

  is $cbt.get-active, -1, 'nothing selected';
  $cbt.set-active(1);
  is $cbt.get-active, 1, 'entry 1 selected';

  is $cbt.get-active-text, 'Australia', 'entry text ok';
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
