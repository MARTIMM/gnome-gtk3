#!/usr/bin/env -S raku -Ilib

# Example taken from https://askubuntu.com/questions/702762/how-to-create-a-custom-splash-screen-for-a-program

use v6.d;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Main;

class BW {
  method build-window (
    Gnome::Gtk3::Window :_widget($main-window), :$splash
  ) {
    $main-window.set-size-request( 600, 400);
    $main-window.set-border-width(20);
    $main-window.set-position(GTK_WIN_POS_CENTER);

    my Gnome::Gtk3::Button $b .= new(:label<Stop>);
    $b.register-signal( self, 'stop-app', 'clicked');
    $b.set-sensitive(False);
    $main-window.container-add($b);

    sleep 1;
    $main-window.show-all;
    sleep 3;
    $splash.destroy;
    sleep 1;
    $b.set-sensitive(True);
  }

  method stop-app ( ) {
    Gnome::Gtk3::Main.quit;
  }
}

my Gnome::Gtk3::Window $w .= new;
my Gnome::Gtk3::Window $main-window .= new;
$main-window.start-thread( BW.new, 'build-window', :splash($w));

note 'setup splash';

$w.set-decorated(False);
$w.set-resizable(False);
$w.set-position(GTK_WIN_POS_CENTER);

my Gnome::Gtk3::Grid $g .= new;
$w.container-add($g);
$g.set-border-width(80);

my Gnome::Gtk3::Label $l .= new(
  :text('Eat bananas while you are waiting for Firefox')
);
$g.attach( $l, 0, 0, 1, 1);

note 'show splash';
$w.show-all;



#sleep 5;

Gnome::Gtk3::Main.main;
