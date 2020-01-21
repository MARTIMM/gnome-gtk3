use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Border;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
subtest 'ISA test', {
  my Gnome::Gtk3::Border $b1 .= new;
  isa-ok $b1, Gnome::Gtk3::Border;
}

#-------------------------------------------------------------------------------
subtest 'Border manipulations', {
  my Gnome::Gtk3::Border $b1 .= new;
  my Gnome::Gtk3::Border $b2 .= new( :10left, :10right, :5top, :5bottom);
  isa-ok $b2, Gnome::Gtk3::Border;
  is $b2().left, 10, 'left border 10';
  is $b2().right, 10, 'right border 10';
  is $b2().top, 5, 'left border 5';
  is $b2().bottom, 5, 'left border 5';

  my Gnome::Gtk3::Border $b3 .= new(:border($b2.gtk_border_copy));
  isa-ok $b3, Gnome::Gtk3::Border;
  is $b3.left, 10, 'left border 10 after copy';
  is $b3.right, 10, 'right border 10 after copy';
  is $b3.top, 5, 'left border 5 after copy';
  is $b3.bottom, 5, 'left border 5 after copy';

  is $b3.left(5), 5, 'left border now 5';
  is $b3.right(5), 5, 'right border now 5';
  is $b3.top(15), 15, 'left border now 15';
  is $b3.bottom(15), 15, 'left border now 15';

  $b1.clear-border;
  $b2.clear-border;
  $b3.clear-border;
}

#-------------------------------------------------------------------------------
subtest 'Border error', {
  my Gnome::Gtk3::Border $b1 .= new;
  $b1.clear-border;

  ok !$b1.border-is-valid, 'border is not valid';

  throws-like(
    { $b1.left(10); },
    X::Gnome, 'try set a value on an invalid border object',
    :message('Cannot set left width, Border is not valid')
  );
}

#-------------------------------------------------------------------------------
done-testing;
