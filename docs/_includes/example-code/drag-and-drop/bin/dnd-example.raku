#!/usr/bin/env -S raku -Ilib
use v6;

use lib '/home/marcel/Languages/Raku/Projects/gnome-gtk3/lib';


use Gnome::Gtk3::EventBox:api<1>;
use Gnome::Gtk3::Image:api<1>;
use Gnome::Gtk3::Grid:api<1>;
use Gnome::Gtk3::Window:api<1>;
#use Gnome::Gtk3::Main:api<1>;
#use Gnome::Gtk3::Enums:api<1>;

use ExDND::AppHandlers;
use ExDND::Label;
use ExDND::Frame;
use ExDND::Types;

use ExDND::DragSourceWidget;
use ExDND::DragDestinationWidget;


#-------------------------------------------------------------------------------
# Setup of the window. All widgets are placed in a grid which is placed in
# a window.
my Gnome::Gtk3::Grid $grid .= new;
$grid.set-border-width(10);

# An image as a source widget. The image is embedded in an EventBox.
# Three labels and another image as the destination widgets. This time
# the image does not have to be embedded.

# Source image
my Gnome::Gtk3::Image $image .= new;
$image.set-from-file(%leds<green>);
my Gnome::Gtk3::EventBox $source-widget .= new;
$source-widget.add($image);
$grid.attach( $source-widget, 0, 0, 1, 1);
my ExDND::DragSourceWidget $drag-source-widget .= new(:$source-widget);


# Destination label for plain text
my ExDND::Frame $frame .= new(:label('Drop plain text'));
my ExDND::Label $plain-text-drop .= new(:text('... drop here ...'));
$frame.add($plain-text-drop);
$grid.attach( $frame, 0, 1, 1, 1);
my ExDND::DragDestinationWidget $dd1 .= new(
  :destination-widget($plain-text-drop), :destination-type(TEXT_PLAIN_DROP)
);

$frame .= new(:label('Drop markup text'));
my ExDND::Label $markup-text-drop .= new(:text('... drop here ...'));
#$markup-text-drop.set-use-markup(True);
$frame.add($markup-text-drop);
$grid.attach( $frame, 0, 2, 1, 1);
my ExDND::DragDestinationWidget $dd2 .= new(
  :destination-widget($markup-text-drop), :destination-type(MARKUP_DROP)
);

$frame .= new(:label('Drop number'));
my ExDND::Label $number-drop .= new(:text('... drop here ...'));
$frame.add($number-drop);
$grid.attach( $frame, 0, 3, 1, 1);
my ExDND::DragDestinationWidget $dd3 .= new(
  :destination-widget($number-drop), :destination-type(NUMBER_DROP)
);

$frame .= new(:label('Drop image'));
my Gnome::Gtk3::Image $image-drop .= new;
$image-drop.set-size-request( 380, 380);
$frame.add($image-drop);
$grid.attach( $frame, 0, 4, 1, 1);
my ExDND::DragDestinationWidget $dd4 .= new(
  :destination-widget($image-drop), :destination-type(IMAGE_DROP)
);


my ExDND::AppHandlers $ah .= new;
given my Gnome::Gtk3::Window $window .= new {
  .set-title('drag and drop');
  .set-size-request( 400, 300);
  .register-signal( $ah, 'quit', 'destroy');
  .add($grid);
  .show-all;
}

$ah.run;
