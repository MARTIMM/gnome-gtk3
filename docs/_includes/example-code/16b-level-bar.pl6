#!/usr/bin/env raku

use v6;

my $t0 = now;

use Gnome::Gtk3::Enums:api<1>;
use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::Window:api<1>;
use Gnome::Gtk3::Grid:api<1>;
use Gnome::Gtk3::Button:api<1>;
use Gnome::Gtk3::ToggleButton:api<1>;
use Gnome::Gtk3::TextView:api<1>;
use Gnome::Gtk3::TextBuffer:api<1>;
use Gnome::Gtk3::LevelBar:api<1>;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# Class to handle signals
class AppSignalHandlers {

  has Gnome::Gtk3::LevelBar $!level-bar;
  has Gnome::Gtk3::TextView $!text-view;
  has Gnome::Gtk3::ToggleButton $!inverted-button;

  submethod BUILD ( :$!level-bar, :$!text-view, :$!inverted-button ) {
    self!update-status;
  }

  # increment level bar
  method inc-level-bar ( ) {
    my Num $v = $!level-bar.get-value;
    my Num $vmx = $!level-bar.get-max-value;
    $!level-bar.set-value(min( $v + 0.1, $vmx));
    self!update-status;
  }

  # decrement level bar
  method dec-level-bar ( ) {
    my Num $v = $!level-bar.get-value;
    my Num $vmn = $!level-bar.get-min-value;
    $!level-bar.set-value(max( $v - 0.1, $vmn));
    self!update-status;
  }

  method invert-level-bar ( ) {
    $!level-bar.set-inverted($!inverted-button.get-active());
    self!update-status;
  }

  method exit-program ( ) {
    $m.quit;
  }

  method !update-status {
    my Str $text = sprintf( "value=%3.2f", $!level-bar.get-value);

    my Gnome::Gtk3::TextBuffer $text-buffer .= new(
      :native-object($!text-view.get-buffer)
    );

    $text-buffer.set-text($text);
  }
}

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new;

$top-window.set-title('Level Bar Demo');
$top-window.set-border-width(20);

# Create a grid and add it to the window
my Gnome::Gtk3::Grid $grid .= new;
$top-window.add($grid);

# Create the other widgets and add them to the grid
my Gnome::Gtk3::Button $inc-button .= new(:label("+"));
$grid.attach( $inc-button, 1, 0, 1, 1);

my Gnome::Gtk3::Button $dec-button .= new(:label("-"));
$grid.attach( $dec-button, 1, 1, 1, 1);

my Gnome::Gtk3::ToggleButton $inverted-button .= new(:label("Inverted"));
$grid.attach( $inverted-button, 1, 2, 1, 1);

my Gnome::Gtk3::LevelBar $level-bar .= new;
$level-bar.set-orientation(GTK_ORIENTATION_VERTICAL);
$grid.attach( $level-bar, 0, 0, 1, 3);

my Gnome::Gtk3::TextView $text-view .= new;
$grid.attach( $text-view, 0, 4, 3, 1);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new( :$level-bar, :$text-view, :$inverted-button);
$inc-button.register-signal( $ash, 'inc-level-bar', 'clicked');
$dec-button.register-signal( $ash, 'dec-level-bar', 'clicked');
$inverted-button.register-signal( $ash, 'invert-level-bar', 'toggled');

$top-window.register-signal( $ash, 'exit-program', 'destroy');

# Show everything and activate all
$top-window.show-all;

note "Set up time: ", now - $t0;
$m.main;
