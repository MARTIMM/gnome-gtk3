#!/usr/bin/env -S raku -Ilib

# Example taken from https://askubuntu.com/questions/702762/how-to-create-a-custom-splash-screen-for-a-program

use v6.d;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Main;

class BW {
  has Gnome::Gtk3::Main $!main .= new;

  method build-window (
    Gnome::Gtk3::Window :_widget($main-window), :$splash-window
  ) {
    $main-window.set-size-request( 600, 400);
    $main-window.set-border-width(20);
    $main-window.set-position(GTK_WIN_POS_CENTER);

    my Gnome::Gtk3::Button $b .= new(:label<Stop>);
    $b.register-signal( self, 'stop-app', 'clicked');
    $main-window.container-add($b);

    sleep 1;
    note 'show main';
    $main-window.show-all;
    while $!main.events-pending() { $!main.iteration-do(False); }
    sleep 4;
    note 'splash destroy';
    $splash-window.destroy;
  }

  method stop-app ( ) {
    $!main.quit;
  }
}

my Gnome::Gtk3::Window $splash-window .= new;
my Gnome::Gtk3::Window $main-window .= new;
$splash-window.set-transient-for($main-window);
$splash-window.set-modal(True);
$main-window.start-thread( BW.new, 'build-window', :$splash-window);

note 'setup splash';

$splash-window.set-decorated(False);
$splash-window.set-resizable(False);
$splash-window.set-position(GTK_WIN_POS_CENTER);

my Gnome::Gtk3::Grid $g .= new;
$splash-window.container-add($g);
$g.set-border-width(80);

my Gnome::Gtk3::Label $l .= new(
  :text('Eat bananas while you are waiting for Firefox')
);
$g.attach( $l, 0, 0, 1, 1);

note 'show splash';
$splash-window.show-all;



#sleep 5;

Gnome::Gtk3::Main.main;
