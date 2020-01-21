use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Entry;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Entry $e;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $e .= new;
  isa-ok $e, Gnome::Gtk3::Entry, ".new";
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  ok $e.get-visibility, '.get-visibility()';

  $e.set-text('new text in entry');
  is $e.get-text, 'new text in entry', '.set-text() / .get-text()';
  is $e.get-text-length, 'new text in entry'.chars, '.get-text-length()';

  is Uni.new($e.get-invisible-char).NFC.Str, '●', 'invisible char is ●';
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
