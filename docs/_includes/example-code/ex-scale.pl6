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
use Gnome::Gtk3::Scale:api<1>;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# Class to handle signals
class AppSignalHandlers {

  has Gnome::Gtk3::Scale $!scale;
  has Gnome::Gtk3::TextView $!text-view;
  has Gnome::Gtk3::ToggleButton $!inverted-button;
  has Num $!min;
  has Num $!max;
  has Num $!step;

  submethod BUILD (
    :$!scale, :$!text-view, :$!inverted-button, :$!min, :$!max, :$!step
  ) {
    self!update-status;
  }

  # increment level bar
  method inc-scale ( ) {
    my Num $v = $!scale.get-value;
    $!scale.set-value(min( $v + $!step, $!max));
    self!update-status;
  }

  # decrement level bar
  method dec-scale ( ) {
    my Num $v = $!scale.get-value;
    $!scale.set-value(max( $v - $!step, $!min));
    self!update-status;
  }

  method invert-scale ( ) {
    $!scale.set-inverted($!inverted-button.get-active());
    self!update-status;
  }

  method exit-program ( ) {
    $m.quit;
  }

  method !update-status {
    my Str $text = sprintf(
      "value=%3.2f, min=%3.2f, max=%3.2f, inverted=%s",
      $!scale.get-value, $!min, $!max,
      ?$!scale.get-inverted ?? 'True' !! 'False'
    );

    my Gnome::Gtk3::TextBuffer $text-buffer .= new(
      :native-object($!text-view.get-buffer)
    );

    $text-buffer.set-text($text);
  }
}

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new;

$top-window.set-title('Scale Demo');
$top-window.set-border-width(20);

# Create a grid and add it to the window
my Gnome::Gtk3::Grid $grid .= new;
$top-window.add($grid);

# Create the other widgets and add them to the grid
my Gnome::Gtk3::Button $inc-button .= new(:label("+"));
$grid.attach( $inc-button, 0, 0, 1, 1);

my Gnome::Gtk3::Button $dec-button .= new(:label("-"));
$grid.attach( $dec-button, 1, 0, 1, 1);

my Gnome::Gtk3::ToggleButton $inverted-button .= new(:label("Inverted"));
$grid.attach( $inverted-button, 2, 0, 1, 1);

my Gnome::Gtk3::Scale $scale .= new;
# Set min and max of scale.
$scale.set-range( -2e0, .2e2);
# Step (keys left/right) and page (mouse scroll on scale).
$scale.set-increments( .2e0, 5e0);
$scale.set-value-pos(GTK_POS_BOTTOM);
$scale.set-digits(2);
$scale.add-mark( 0e0, GTK_POS_BOTTOM, 'Zero');
$scale.add-mark( 5e0, GTK_POS_BOTTOM, 'Five');
$scale.add-mark( 10e0, GTK_POS_BOTTOM, 'Ten');
$scale.add-mark( 15e0, GTK_POS_BOTTOM, 'Fifteen');
$scale.add-mark( 20e0, GTK_POS_BOTTOM, 'Twenty');
$grid.attach( $scale, 0, 1, 3, 1);

my Gnome::Gtk3::TextView $text-view .= new;
$grid.attach( $text-view, 0, 2, 3, 1);

#$grid.debug(:on);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new(
  :$scale, :$text-view, :$inverted-button, :min(-2e0), :max(.2e2), :step(.2e0)
);
$inc-button.register-signal( $ash, 'inc-scale', 'clicked');
$dec-button.register-signal( $ash, 'dec-scale', 'clicked');
$inverted-button.register-signal( $ash, 'invert-scale', 'toggled');

$top-window.register-signal( $ash, 'exit-program', 'destroy');

# Show everything and activate all
$top-window.show-all;

note "Set up time: ", now - $t0;
$m.main;
