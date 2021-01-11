use v6;
#use lib '../gnome-gobject/lib';
use NativeCall;
use Test;

use Gnome::Gtk3::Label;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Builder;
use Gnome::Glib::Error;
use Gnome::Glib::Quark;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Label $l;
my Gnome::Gtk3::Button $b;
my Gnome::Glib::Error $e;
my Gnome::Gtk3::Builder $builder;

my Str $ui-file = 't/data/ui.glade';
my Gnome::Glib::Quark $quark .= new;

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
  # get-name() is from Widget, not from Buildable
  $l .= new(:text('text for a label'));
  is $l.get-name, 'GtkLabel', '.get-name(): default is GtkLabel';
  $l.set-name('buildable');
  is $l.get-name, 'buildable', '.set-name() / .get-name()';

  # explicitly use full name for interface
  $l.buildable-set-name("build-name");
  is $l.buildable-get-name, "build-name",
     '.buildable-set-name() / .buildable-get-name()';
  $l.set-name('widget-name');
  is $l.get-name, 'widget-name', '.gtk-widget-set-name(): widget-name';

  $builder .= new;
  $e = $builder.add-from-file($ui-file);
  nok $e.is-valid, "ui file added ok";
  note $e.message if $e.is-valid;

  # set name is from Buildable, not from Widget
  $l .= new(:build-id<my-label-1>);
  is $l.get-name, 'label-name-1', '.get-name(): label-name-1';
  is $l.buildable-get-name, 'my-label-1', '.buildable-get-name() == id';

  $b .= new(:build-id<my-button-1>);
  is $b.get-name, 'button-name-1', '.get-name(): button-name-1';
  is $b.buildable-get-name, 'my-button-1', '.buildable-get-name()';

  # get name is from Buildable, not from Widget
  $l.set-name('widget-name');
  is $l.get-name, 'widget-name', '.set-name(): widget-name (set again)';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $b .= new;
  isa-ok $b, Gnome::Gtk3::Buildable, '.new';
}

#-------------------------------------------------------------------------------
unless %*ENV<raku_test_all>:exists {
  done-testing;
  exit;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
}

#-------------------------------------------------------------------------------
subtest 'Inherit ...', {
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
