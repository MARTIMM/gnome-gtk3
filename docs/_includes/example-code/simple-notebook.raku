#!/usr/bin/env perl6

use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Notebook;
use Gnome::Gtk3::Label;

my Gnome::Gtk3::Main $m .= new;

# A callback handler class to respond to the 'close application event'
class AppSignalHandlers {
  method exit-program ( ) {
    $m.quit;
  }
}

# Initialize the callback handler class
my AppSignalHandlers $ash .= new;

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new();
$top-window.set-title('A very simple notebook');
$top-window.set-default-size( 640, 480);
$top-window.register-signal( $ash, 'exit-program', 'destroy');

# Add two tabs to create Notebook
my Gnome::Gtk3::Notebook $nb .= new();
$top-window.add($nb);
my Gnome::Gtk3::Label $tab1-content .= new(:text("It's the first tab"));
my Gnome::Gtk3::Label $tab1-label   .= new(:text("Tab 1"));
$nb.append-page($tab1-content,$tab1-label);
my Gnome::Gtk3::Label $tab2-content .= new(:text("It's the second tab"));
my Gnome::Gtk3::Label $tab2-label   .= new(:text("Tab 2"));
$nb.append-page($tab2-content,$tab2-label);

$top-window.show-all;

$m.main;
