#!/usr/bin/env -S raku -I lib

#`{{
Example taken from documents written by Stewart Weiss
Site: http://www.compsci.hunter.cuny.edu/~sweiss/index.php
Course: CSci 493.70, Graphical User Interface Programming
  follow 'lecture notes' then select 'Drag-and-drop in GTK+' -> download pdf
}}

use v6;
#use lib '../gnome-gdk3/lib';
#use lib '../gnome-gobject/lib';

use NativeCall;

use Gnome::N::N-GObject;
use Gnome::N::X;
use Gnome::N::GlibToRakuTypes;
#Gnome::N::debug(:on);

use Gnome::Gtk3::EventBox;
use Gnome::Gtk3::Image;
#use Gnome::Gtk3::Button;
use Gnome::Gtk3::Label;
#use Gnome::Gtk3::DrawingArea;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Frame;

#use Gnome::Gtk3::TargetEntry;
use Gnome::Gtk3::DragSource;
use Gnome::Gtk3::DragDest;
use Gnome::Gtk3::TargetList;
use Gnome::Gtk3::SelectionData;

use Gnome::Gdk3::Atom;
use Gnome::Gdk3::DragContext;
use Gnome::Gdk3::Types;
use Gnome::Gdk3::Pixbuf;

#-------------------------------------------------------------------------------
enum TargetInfo <TEXT_HTML STRING NUMBER IMAGE_JPEG TEXT_URI>;
enum DestinationType <NUMBER_DROP MARKUP_DROP TEXT_PLAIN_DROP IMAGE_DROP>;

#-------------------------------------------------------------------------------
# Simple class to be able to stop the application
class AppHandlers {
  #-----------------------------------------------------------------------------
  method quit ( ) {
    Gnome::Gtk3::Main.new.main-quit;
  }
}

#-------------------------------------------------------------------------------
# A convenience class for frames to pimp up the destination labels a bit
class Frame is Gnome::Gtk3::Frame {
  #-----------------------------------------------------------------------------
  method new ( |c ) {
    self.bless( :GtkFrame, |c);
  }

  #-----------------------------------------------------------------------------
  submethod BUILD ( Str :$label = '' ) {
    my Gnome::Gtk3::Label $l .= new(:text("<b>$label\</b>"));
    $l.set-use-markup(True);
    self.set-label-widget($l);

    self.set-label-align( 0.04, 0.5);
    self.set-margin-bottom(3);
    self.set-hexpand(True);
  }
}

#-------------------------------------------------------------------------------
# Also a convenience class for labels
class Label is Gnome::Gtk3::Label {
  #-----------------------------------------------------------------------------
  method new ( Str :$text = ' ', |c ) {
    self.bless( :GtkLabel, :$text, |c);
  }

  #-----------------------------------------------------------------------------
  submethod BUILD ( Str :$text ) {
    self.set-text($text);
    self.set-justify(GTK_JUSTIFY_FILL);
    self.set-halign(GTK_ALIGN_START);
    self.set-margin-start(3);
    self.set-use-markup(True);
  }
}

#-------------------------------------------------------------------------------
class DragSourceWidget {
  has Instant $!start-time;
  has Gnome::Gtk3::DragSource $!source;
  has Hash $!target-data;
  has Hash $!targets;

  #-----------------------------------------------------------------------------
  submethod BUILD ( :$grid, :$x, :$y, :$w, :$h ) {
    my Gnome::Gtk3::Image $image .= new;
    $image.set-from-file('xt/data/amber-on-256.png');
    my Gnome::Gtk3::EventBox $widget .= new;
    $widget.add($image);
    $grid.attach( $widget, $x, $y, $w, $h);

    $!start-time = now;

    $!source .= new;
    $!source.set(
      $widget, GDK_BUTTON1_MASK, [], GDK_ACTION_MOVE +| GDK_ACTION_MOVE
    );

#`{{
    # the target list and images are attached to the widget.
    my Array $te = [
      Gnome::Gtk3::TargetEntry.new(
        :target<string>, :flags(GTK_TARGET_SAME_APP), :info(NUMBER)
      ),
    ];
    my Gnome::Gtk3::TargetList $target-list .= new(:targets($te));
}}

    my Gnome::Gtk3::TargetList $target-list .= new;
    $!targets = %(
      :number(Gnome::Gdk3::Atom.new(:intern<number>)),
      :string(Gnome::Gdk3::Atom.new(:intern<text/plain>)),
    );
    $target-list.add( $!targets<number>, GTK_TARGET_SAME_APP, NUMBER);
    $target-list.add( $!targets<string>, GTK_TARGET_SAME_APP, STRING);
    $!source.set-target-list( $widget, $target-list);

    $widget.register-signal( self, 'begin', 'drag-begin');
    $widget.register-signal( self, 'get', 'drag-data-get');
    $widget.register-signal( self, 'end', 'drag-end');
    $widget.register-signal( self, 'delete', 'drag-data-delete');
    $widget.register-signal( self, 'failed', 'drag-failed');
  }

  #-----------------------------------------------------------------------------
  method begin ( N-GObject $context, :_widget($widget) ) {
note "\nsrc begin";

    $!source.set-icon-name( $widget, 'text-x-generic');
    $!target-data = %(
      :number((now - $!start-time).Int),
#      :string('some textual string with strange characters ☺ ≠ ñ');
    );
note "data begin: $!target-data<number>";
  }

  #-----------------------------------------------------------------------------
  method get (
    N-GObject $context, N-GObject $data, UInt $info, UInt $time,
    :_widget($widget)
  ) {
note "\nsrc get: $info, $time, $!target-data<number>";

    my Gnome::Gtk3::SelectionData $sd .= new(:native-object($data));
#my Gnome::Gdk3::Atom $atom .= new(:native-object($sd.get-target));
#note 'target: ', $atom.name;
#note 'format: ', $sd.get-format, ' -> 16';
#note 'length: ', $sd.get-length, ' -> 1';

    # here, you can check for target name to decide what to return
    # now always 'number'. number to send is elapsed time. 16 bit gives
    # about 18 hours to run without problems.
    given $info {
      when NUMBER {
        $sd.set( $!targets<number>, 16, $!target-data<number>);
      }

      when STRING {
        $sd.set(
          $!targets<string>,
          "The drag started $!target-data<number> seconds after start"
        );
      }
    }
  }

  #-----------------------------------------------------------------------------
  method end ( N-GObject $context, :_widget($widget) ) {
note "\nsrc end: ";
  }

  #-----------------------------------------------------------------------------
  method delete ( N-GObject $context, :_widget($widget) ) {
note "\nsrc delete";
  }

  #-----------------------------------------------------------------------------
  method failed (
    N-GObject $context, Int $result, :_widget($widget) --> Bool
  ) {
note "src fail: {GtkDragResult($result)}";
    True
  }
}

#-------------------------------------------------------------------------------
class DragDestinationWidget {

  has Gnome::Gtk3::DragDest $!destination;

  #-----------------------------------------------------------------------------
  submethod BUILD ( :$grid, :$x, :$y, :$w, :$h   ) {

    my Gnome::Gtk3::Label $widget .= new(:text('Drag Zone'));
    $grid.attach( $widget, $x, $y, $w, $h);

    $!destination .= new;
#    $!destination.set( $widget, GTK_DEST_DEFAULT_ALL, [], GDK_ACTION_COPY);
    $!destination.set( $widget, 0, GDK_ACTION_COPY +| GDK_ACTION_MOVE);

    my Gnome::Gtk3::TargetList $target-list .= new;
    $target-list.add(
#      Gnome::Gdk3::Atom.new(:intern<number>), GTK_TARGET_SAME_APP, NUMBER
      Gnome::Gdk3::Atom.new(:intern<text/plain>), GTK_TARGET_SAME_APP, STRING
    );

    $!destination.set-target-list( $widget, $target-list);

    $widget.register-signal( self, 'motion', 'drag-motion');
    $widget.register-signal( self, 'drop', 'drag-drop');
    $widget.register-signal( self, 'received', 'drag-data-received');
    $widget.register-signal( self, 'leave', 'drag-leave');
  }

  #-----------------------------------------------------------------------------
  method motion (
    N-GObject $context, Int $x, Int $y, UInt $time, :_widget($widget)
    --> Bool
  ) {
    my Bool $status;
note "\ndst motion: $x, $y, $time";

    my Gnome::Gdk3::Atom $a = $!destination.find-target(
      $widget, $context, $!destination.get-target-list($widget)
    );

#note 'Target match: ', $a.name;
    my Gnome::Gdk3::DragContext $dctx .= new(:native-object($context));
    if $a.name ~~ 'NONE' {
      $dctx.status( GDK_ACTION_COPY, $time);
      $status = False;
    }

    else {
      $!destination.highlight($widget);
      $dctx.status( GDK_ACTION_MOVE, $time);
      $status = True;
    }

    $status
  }

  #-----------------------------------------------------------------------------
  method drop (
    N-GObject $context, Int $x, Int $y, UInt $time, :_widget($widget)
    --> Bool
  ) {
note "\ndst drop: $x, $y, $time";
    my Gnome::Gdk3::Atom $a = $!destination.find-target(
      $widget, $context, $!destination.get-target-list($widget)
    );

note 'Target match: ', $a.name;
    # ask for data. triggers drag-data-get on source. when data is received or
    # error, drag-data-received on destination is triggered
    $!destination.get-data( $widget, $context, $a, $time);

    True
  }

  #-----------------------------------------------------------------------------
  method received (
    N-GObject $context, Int $x, Int $y,
    N-GObject $data, UInt $info, UInt $time, :_widget($widget)
  ) {
note "\ndst received:, $x, $y, $info, $time";
    my Gnome::Gtk3::SelectionData $sd .= new(:native-object($data));
my Gnome::Gdk3::Atom $atom .= new(:native-object($sd.get-target));
note 'target: ', $atom.name;
note 'format: ', $sd.get-format;
note 'length: ', $sd.get-length;
note 'selection: ', $sd.get-selection.name;
my Gnome::Gdk3::DragContext $dctx .= new(:native-object($context));
note 'action: ', $dctx.get-selected-action;

    if ( my Str $str = $sd.get(:data-type(Str)) ).defined {
note "string: $str";
      $widget.set-text($str);
      $!destination.finish( $context, True, True, $time);
    }

    else {
      $!destination.finish( $context, False, False, $time);
    }
  }

  #-----------------------------------------------------------------------------
  method leave ( N-GObject $context, UInt $time, :_widget($widget) ) {
note "\ndst leave: $time";
    $!destination.unhighlight($widget);
  }
}





#-------------------------------------------------------------------------------
# Setup of the main page. All widgets are placed in a grid which is placed in
# a window.
my Gnome::Gtk3::Grid $grid .= new;
$grid.set-border-width(10);

# An image as a source widget. The image is embedded in an EventBox.
# Three labels and another image as the destination widgets. This time
# the image does not have to be embedded.

# Source image
my Gnome::Gtk3::Image $image .= new;
$image.set-from-file('xt/data/green-on-256.png');
my Gnome::Gtk3::EventBox $source-widget .= new;
$source-widget.add($image);
$grid.attach( $source-widget, 0, 0, 1, 1);

# setup-source-widget($source-widget);


# Destination label for plain text
my Frame $frame .= new(:label('Drop plain text'));
my Label $plain-text-drop .= new;
$frame.add($plain-text-drop);
$grid.attach( $frame, 0, 1, 1, 1);
# setup-destination-widget($plain-text-drop);

$frame .= new(:label('Drop markup text'));
my Label $markup-text-drop .= new;
$frame.add($markup-text-drop);
$grid.attach( $frame, 0, 2, 1, 1);
# setup-destination-widget($markup-text-drop);

$frame .= new(:label('Drop number'));
my Label $number-drop .= new;
$frame.add($number-drop);
$grid.attach( $frame, 0, 3, 1, 1);
# setup-destination-widget($number-drop);

$frame .= new(:label('Drop image'));
my Label $image-drop .= new;
$frame.add($image-drop);
$grid.attach( $frame, 0, 4, 1, 1);
# setup-destination-widget($image-drop);




#my DragSourceWidget $dsb1 .= new( :$grid, :0x, :0y, :1w, :1h);
#my DragDestinationWidget $ddb1 .= new( :$grid, :1x, :2y, :2w, :1h);

#my Gnome::Gtk3::Label $ph .= new(:text(''));
#$grid.attach( $ph, 0, 1, 2, 1);

my AppHandlers $ah .= new;
given my Gnome::Gtk3::Window $window .= new {
  .set-title('drag and drop');
  .set-size-request( 400, 300);
  .register-signal( $ah, 'quit', 'destroy');
  .add($grid);
  .show-all;
}

Gnome::Gtk3::Main.new.main;
