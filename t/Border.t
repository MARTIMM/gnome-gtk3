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
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Border manipulations', {
  my Gnome::Gtk3::Border $b1 .= new;
  my Gnome::Gtk3::Border $b2 .= new( :10left, :10right, :5top, :5bottom);
#  isa-ok $b2, Gnome::Gtk3::Border;
  is $b2._get-native-object.left, 10, 'left border 10';
  is $b2._get-native-object.right, 10, 'right border 10';
  is $b2._get-native-object.top, 5, 'left border 5';
  is $b2._get-native-object.bottom, 5, 'left border 5';

  my Gnome::Gtk3::Border $b3 .= new(:native-object($b2.border-copy));
#  isa-ok $b3, Gnome::Gtk3::Border;
  is $b3.left, 10, 'left border 10 after copy';
  is $b3.right, 10, 'right border 10 after copy';
  is $b3.top, 5, 'left border 5 after copy';
  is $b3.bottom, 5, 'left border 5 after copy';

  my Gnome::Gtk3::Border() $b4 = $b2.border-copy;
#  isa-ok $b4, Gnome::Gtk3::Border;
  is $b4.left, 10, 'left border 10 after copy';
  is $b4.right, 10, 'right border 10 after copy';
  is $b4.top, 5, 'left border 5 after copy';
  is $b4.bottom, 5, 'left border 5 after copy';
  $b4.clear-object;

  # modify
  is $b3.left(5), 5, 'left border now 5';
  is $b3.right(5), 5, 'right border now 5';
  is $b3.top(15), 15, 'left border now 15';
  is $b3.bottom(15), 15, 'left border now 15';

  $b1.clear-object;
  $b2.clear-object;
  $b3.clear-object;
}

#-------------------------------------------------------------------------------
subtest 'Border error', {

  dies-ok( {
      my Gnome::Gtk3::Border $b1 .= new;
      $b1.clear-object;
      ok !$b1.is-valid, 'border is not valid';

      $b1.left(10);
    }, 'try set a value on an invalid border object'
  );
}

#-------------------------------------------------------------------------------
done-testing;
