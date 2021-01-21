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
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  $md.set-markup('aba<i>ca</i>dabra');
  $md.secondary-text('En een gewone mededeling');
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
  use Gnome::GObject::Value;
  use Gnome::GObject::Type;

  #my Gnome::Gtk3::MessageDialog $md .= new;

  sub test-property (
    $type, Str $prop, Str $routine, $value, Bool :$approx = False
  ) {
    my Gnome::GObject::Value $gv .= new(:init($type));
    $md.get-property( $prop, $gv);
    my $gv-value = $gv."$routine"();
    if $approx {
      is-approx $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }

    else {
      is $gv-value, $value,
        "property $prop, value: " ~ $gv-value;
    }
    $gv.clear-object;
  }

  test-property( G_TYPE_STRING, 'text', 'get-string', 'aba<i>ca</i>dabra');
  test-property( G_TYPE_STRING, 'secondary-text', 'get-string', 'En een gewone mededeling');

  test-property( G_TYPE_BOOLEAN, 'use-markup', 'get-boolean', 1);
  test-property( G_TYPE_BOOLEAN, 'secondary-use-markup', 'get-boolean', 0);
}

#-------------------------------------------------------------------------------
subtest 'Inherit Gnome::Gtk3::MessageDialog', {
  class MyClass is Gnome::Gtk3::MessageDialog {
    method new ( |c ) {
      self.bless(
        :GtkMessageDialog, |c, :buttons(GTK_BUTTONS_YES_NO)
      );
    }

    submethod BUILD ( *%options ) {
      self.format-secondary-markup('Press <b>Yes</b> if you are');
    }
  }

  my MyClass $mgc .= new(:message('Well, that is something!'));
  isa-ok $mgc, Gnome::Gtk3::MessageDialog, '$mgc.new()';
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
