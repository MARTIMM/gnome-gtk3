#!/usr/bin/env -S raku

use v6;

use Gnome::Gtk3::ButtonBox:api<1>;
use Gnome::Gtk3::Button:api<1>;
use Gnome::Gtk3::Window:api<1>;
use Gnome::Gtk3::Main:api<1>;

my Gnome::Gtk3::Window $window .= new;
$window.set-title('ButtonBox test');


my Gnome::Gtk3::ButtonBox $bb .= new;
$bb.set-layout(GTK_BUTTONBOX_EXPAND);

my Gnome::Gtk3::Button $button1 .= new(:label<Start>);
$bb.add($button1);
my Gnome::Gtk3::Button $button2 .= new(:label<Stop>);
$bb.add($button2);

my Gnome::Gtk3::Button $button3 .= new(:label<Foo>);
$bb.add($button3);
$bb.set-child-secondary( $button3, True);
my Gnome::Gtk3::Button $button4 .= new(:label<Bar>);
$bb.add($button4);
$bb.set-child-secondary( $button4, True);

$window.add($bb);
$window.show-all;

Gnome::Gtk3::Main.new.main;
