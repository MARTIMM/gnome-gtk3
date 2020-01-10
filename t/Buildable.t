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
my Gnome::Glib::Quark $quark .= new(:empty);

#-------------------------------------------------------------------------------
subtest 'Interface ...', {
  diag ' ';

  $l .= new(:text('text for a label'));
  $l.set-name('buildable');
  is $l.get-name, 'buildable', '.get-name(): buildable';

  # explicitly use full name
  is $l.gtk-widget-get-name, 'GtkLabel', '.gtk-widget-get-name(): GtkLabel';

  # get name is from Buildable, not from Widget
  $l.gtk-widget-set-name('widget-name');
  is $l.gtk-widget-get-name, 'widget-name',
     '.gtk-widget-set-name(): widget-name';


  $builder .= new(:empty);
  $e = $builder.add-from-file($ui-file);
  nok $e.error-is-valid, "ui file added ok";
  note $e.message if $e.error-is-valid;

  # set name is from Buildable, not from Widget
  $l .= new(:build-id<my-label-1>);
  is $l.get-name, 'my-label-1', '.get-name(): my-label-1';

  $b .= new(:build-id<my-button-1>);
  is $b.get-name, 'my-button-1', '.get-name(): button-name-1';
  is $b.gtk-widget-get-name, 'button-name-1',
     '.gtk-widget-get-name(): button-name-1 (same as .get-name())';

  # get name is from Buildable, not from Widget
  $l.gtk-widget-set-name('widget-name');
  is $l.gtk-widget-get-name, 'widget-name',
     '.gtk-widget-set-name(): widget-name (set again)';
}

#`{{
#-------------------------------------------------------------------------------
subtest 'ISA test', {
  $b .= new(:empty);
  isa-ok $b, Gnome::Gtk3::Buildable, '.new(:empty)';
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
