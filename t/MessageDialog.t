use v6;
use NativeCall;
use Test;

use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Glib::List;
use Gnome::Gtk3::Box;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::MessageDialog;
use Gnome::Gtk3::Enums;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::MessageDialog $md;
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $md .= new(:message('blub'));
  isa-ok $md, Gnome::Gtk3::MessageDialog, '.new(:message, ...)';

  $md .= new(:markup-message('<b>blub</b>'));
  isa-ok $md, Gnome::Gtk3::MessageDialog, '.new(:markup-message, ...)';
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $md.set-markup('aba<i>ca</i>dabra');
  $md.format-secondary-text('En een gewone mededeling');
  my Gnome::Gtk3::Box $container .= new(:native-object($md.get-message-area));

  my Gnome::Glib::List $l .= new(:native-object($container.get-children));
  is $l.length, 2, '2 messages in dialog';

  my Gnome::Gtk3::Label $lbl .= new(:native-object($l.nth-data(0)));
  is $lbl.get-text, 'abacadabra', '.set-markup()';
  $lbl .= new(:native-object($l.nth-data(1)));
  is $lbl.get-text, 'En een gewone mededeling', '.format-secondary-text()';
}

#-------------------------------------------------------------------------------
subtest 'Properties ...', {
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $md.g-object-get-property( 'text', $gv);
  is $gv.get-string, 'aba<i>ca</i>dabra', 'property text';
  $gv.clear-object;

  $gv .= new(:init(G_TYPE_STRING));
  $md.g-object-get-property( 'secondary-text', $gv);
  is $gv.get-string, 'En een gewone mededeling', 'property secondary-text';
  $gv.clear-object;
}

#`{{
#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
}

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
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
