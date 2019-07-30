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
subtest 'Manips', {
  is $cbt.get-active, -1, 'nothing selected';
  is $cbt.get-has-entry, 0, 'no entries';
#`{{
  $cbt.append-text('Amerika');
  $cbt.append-text('Australia');
  $cbt.append-text('China');
  $cbt.append-text('Great-Brittain');
  $cbt.append-text('Netherlands');

  is $cbt.get-has-entry, 1, 'there are entries';
}}
}

#-------------------------------------------------------------------------------
done-testing;
