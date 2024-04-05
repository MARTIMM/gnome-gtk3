#!/usr/bin/env -S raku -I lib

use v6;

use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::Window:api<1>;
use Gnome::Gtk3::Button:api<1>;
use Gnome::Gtk3::Grid:api<1>;
use Gnome::Glib::List:api<1>;

#use Gnome::N::X:api<1>;
#Gnome::N::debug(:on);

#instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;
#create grid
my Gnome::Gtk3::Grid $grid .= new;

# A callback handler class to respond to signals
class AppSignalHandlers {
	method exit-program() { $m.gtk-main-quit; }

	method first-button-click (
    :_widget($b1), :other-button($b2), :$container
  ) {
		$b1.set-sensitive(False);
		$b2.set-sensitive(True);

		my Gnome::Glib::List $l .= new(
      :native-object($container.get-children)
    );
    note 'nbr widgets: ', $l.length;
	}

	method second-button-clicked() { $m.gtk-main-quit; }
}

#create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new;
$top-window.set-border-width(20);
$top-window.set-title("Example");

#Gnome::N::debug(:on);
$top-window.add($grid);
#Gnome::N::debug(:off);

# create button
#my Gnome::Gtk3::Button $button1 .= new(:label('Exit program'));
#my Gnome::Gtk3::Button $button2 .= new(:label('also Exit program'));
my Gnome::Gtk3::Button $button1 .= new(:label('hello world'));
my Gnome::Gtk3::Button $button2 .= new(:label('goodbye'));
#disable second button
$button2.set-sensitive(False);

# add buttons to the grid
$grid.attach($button1, 0, 0, 2, 1);
$grid.attach($button2, 0, 1, 1, 1);


# set up signal event handler
my AppSignalHandlers $ash .= new;
$top-window.register-signal($ash, 'exit-program', 'destroy');
$button1.register-signal(
  $ash, 'first-button-click', 'clicked', :other-button($button2),
  :container($grid)
);
$button2.register-signal($ash, 'second-button-clicked', 'clicked');

# show everything and activate
$top-window.gtk-widget-show-all;

$m.gtk-main;
