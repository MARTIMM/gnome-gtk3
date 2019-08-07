use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Border;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::Border $b1 .= new(:empty);
  isa-ok $b1, Gnome::Gtk3::Border;
note $b1().perl;

  my Gnome::Gtk3::Border $b2 .= new( :10left, :10right, :5top, :5bottom);
  isa-ok $b2, Gnome::Gtk3::Border;
  is $b2().left, 10, 'left border 10';
  is $b2().right, 10, 'right border 10';
  is $b2().top, 5, 'left border 5';
  is $b2().bottom, 5, 'left border 5';
note $b2().perl;

  my Gnome::Gtk3::Border $b3 .= new(:border($b2.gtk_border_copy));
  isa-ok $b3, Gnome::Gtk3::Border;
  is $b3.left, 10, 'left border 10 after copy';
  is $b3.right, 10, 'right border 10 after copy';
  is $b3.top, 5, 'left border 5 after copy';
  is $b3.bottom, 5, 'left border 5 after copy';
note $b3().perl;

  is $b3.left(5), 5, 'left border now 5';
  is $b3.right(5), 5, 'right border now 5';
  is $b3.top(15), 15, 'left border now 15';
  is $b3.bottom(15), 15, 'left border now 15';
note $b3().perl;

  $b1.gtk_border_free;
  $b2.gtk_border_free;
  $b3.gtk_border_free;
}

#-------------------------------------------------------------------------------
done-testing;
