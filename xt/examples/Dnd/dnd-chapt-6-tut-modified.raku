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

#use NativeCall;

use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
#use Gnome::N::X;
#Gnome::N::debug(:on);

use Gnome::Gtk3::EventBox;
use Gnome::Gtk3::Image;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Frame;

use Gnome::Gtk3::TargetEntry;
use Gnome::Gtk3::DragSource;
use Gnome::Gtk3::DragDest;
use Gnome::Gtk3::TargetList;
use Gnome::Gtk3::SelectionData;

use Gnome::Gdk3::Atom;
use Gnome::Gdk3::DragContext;
use Gnome::Gdk3::Types;
use Gnome::Gdk3::Pixbuf;

#-------------------------------------------------------------------------------
enum TargetInfo <TEXT_HTML STRING NUMBER IMAGE TEXT_URI>;
enum DestinationType <NUMBER_DROP MARKUP_DROP TEXT_PLAIN_DROP IMAGE_DROP>;

our %leds is export = %(
  :green<xt/data/green-on-256.png>,
  :red<xt/data/red-on-256.png>,
  :amber<xt/data/amber-on-256.png>
);

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
  }
}



#-------------------------------------------------------------------------------
class DragSourceWidget {
  has Instant $!start-time;
  has $!drag-time;
  has Gnome::Gtk3::DragSource $!source;

  #-----------------------------------------------------------------------------
  submethod BUILD ( :$source-widget ) {

    $!start-time = now;

    my Array $target-entries = [
      N-GtkTargetEntry.new( :target<text/html>, :flags(0), :info(TEXT_HTML)),
      N-GtkTargetEntry.new( :target<STRING>, :flags(0), :info(STRING)),
      N-GtkTargetEntry.new( :target<number>, :flags(0), :info(NUMBER)),
      N-GtkTargetEntry.new( :target<image/png>, :flags(0), :info(IMAGE))
    ];

    $!source .= new;
    $!source.set(
      $source-widget, GDK_BUTTON1_MASK, $target-entries,
      GDK_ACTION_MOVE +| GDK_ACTION_COPY
    );

    $source-widget.register-signal( self, 'on-drag-begin', 'drag-begin');
    $source-widget.register-signal( self, 'on-drag-data-get', 'drag-data-get');
  }

  #-----------------------------------------------------------------------------
  method on-drag-begin ( N-GObject $context-no, :_widget($source-widget) ) {
#note "\nsrc begin";

    $!source.set-icon-name( $source-widget, 'text-x-generic');
    $!drag-time = now - $!start-time;

#note "data begin: $!drag-time.fmt('%.3f')";
  }

  #-----------------------------------------------------------------------------
  method on-drag-data-get (
    N-GObject $context-no, N-GObject $selection-data-no, UInt $info, UInt $time,
    :_widget($source-widget)
  ) {
#note "\nsrc get: $info, $time, $!drag-time";

    my Gnome::Gtk3::SelectionData $selection-data .= new(
      :native-object($selection-data-no)
    );

    # here, you can check $info to see what is requested
    given $info {
      when TEXT_HTML {
        my Str $html-data = [~]
          '<span font_family="monospace" style="italic">The time is ',
            '<span weight="bold" foreground="blue">',
            $!drag-time.fmt('%.3f'),
            '</span></span>';

        $selection-data.set(
          Gnome::Gdk3::Atom.new(:intern<text/html>), $html-data
        );
      }

      # number to send is elapsed time. 16 bit gives about 18 hours to run
      # without problems.
      when NUMBER {
        $selection-data.set(
          Gnome::Gdk3::Atom.new(:intern<number>), $!drag-time.Num, :format(16)
        );
      }

      when STRING {
        $selection-data.set(
          Gnome::Gdk3::Atom.new(:intern<STRING>),
          "The drag started $!drag-time.fmt('%.3f') seconds after start"
        );
      }

      when IMAGE {
        $selection-data.set-pixbuf(
          Gnome::Gdk3::Pixbuf.new(:file(%leds{<amber red green>.roll}))
        );
      }
    }
  }
}



#-------------------------------------------------------------------------------
class DragDestinationWidget {

  #-----------------------------------------------------------------------------
  submethod BUILD ( :$destination-widget, DestinationType :$destination-type ) {

    my Gnome::Gtk3::DragDest $destination .= new;
    $destination.set( $destination-widget, 0, GDK_ACTION_COPY);

    my Gnome::Gtk3::TargetList $target-list;
    given $destination-type {
      when NUMBER_DROP {
        $target-list .= new(:targets( [
              N-GtkTargetEntry.new(
                :target<number>, :flags(GTK_TARGET_SAME_APP), :info(NUMBER)
              ),
            ]
          )
        );
      }

      when MARKUP_DROP {
        $target-list .= new(:targets( [
              N-GtkTargetEntry.new(
                :target<text/html>, :flags(0), :info(TEXT_HTML)
              ),
            ]
          )
        );
      }

      when TEXT_PLAIN_DROP {
        $target-list .= new(:targets( [
              N-GtkTargetEntry.new( :target<STRING>, :flags(0), :info(STRING)),
            ]
          )
        );
      }

      when IMAGE_DROP {
        $target-list .= new;
        $target-list.add-image-targets( IMAGE, True);
        $target-list.add-uri-targets(TEXT_URI);
      }
    }

    $destination.set-target-list( $destination-widget, $target-list);

    $destination-widget.register-signal(
      self, 'on-drag-motion', 'drag-motion', :$destination
    );
    $destination-widget.register-signal(
      self, 'on-drag-leave', 'drag-leave', :$destination
    );
    $destination-widget.register-signal(
      self, 'on-drag-drop', 'drag-drop',
      :$destination, :$destination-type
    );
    $destination-widget.register-signal(
      self, 'on-drag-data-received', 'drag-data-received',
      :$destination, :$destination-type
    );
  }

  #-----------------------------------------------------------------------------
  method on-drag-motion (
    N-GObject $context-no, Int $x, Int $y, UInt $time,
    :_widget($destination-widget), Gnome::Gtk3::DragDest :$destination
    --> Bool
  ) {
    my Bool $status;
#note "\ndst motion: $x, $y, $time";

    my Gnome::Gdk3::DragContext $context .= new(:native-object($context-no));
    my Gnome::Gdk3::Atom $target-atom = $destination.find-target(
      $destination-widget, $context,
      $destination.get-target-list($destination-widget)
    );

#note $?LINE, ', Target match: ', $target-atom.name;

    if $target-atom.name ~~ 'NONE' {
      $context.status( GDK_ACTION_NONE, $time);
      $status = False;
    }

    else {
      # $suggest-action changes when control keys are used
      # default: GDK_ACTION_COPY
      # <SHIFT>: GDK_ACTION_MOVE
      # <ALT>: GDK_ACTION_LINK (from file browser, source above only
      # supports copy and move)
      # <CTR><SHIFT>: GDK_ACTION_NONE
      my GdkDragAction $suggest-action = $context.get-suggested-action;
#note $?LINE, ', action: ', $suggest-action;
      $destination.highlight($destination-widget) if $suggest-action;
      $context.status( $suggest-action, $time);
      $status = True;
    }

    $status
  }

  #-----------------------------------------------------------------------------
  method on-drag-leave (
    N-GObject $context-no, UInt $time,
    :_widget($destination-widget), Gnome::Gtk3::DragDest :$destination
  ) {
#note "\ndst leave: $time";
    $destination.unhighlight($destination-widget);
  }

  #-----------------------------------------------------------------------------
  method on-drag-drop (
    N-GObject $context-no, Int $x, Int $y, UInt $time,
    :_widget($destination-widget), DestinationType :$destination-type,
    Gnome::Gtk3::DragDest :$destination
    --> Bool
  ) {
#note "\ndst drop: $x, $y, $time";

    my Gnome::Gdk3::DragContext $context .= new(:native-object($context-no));
    my Gnome::Gdk3::Atom $target-atom = $destination.find-target(
      $destination-widget, $context,
      $destination.get-target-list($destination-widget)
    );

#note $?LINE, ', Target match: ', (?$target-atom ?? $target-atom.name !! 'NONE');

    # ask for data. triggers drag-data-get on source. when data is received or
    # error, drag-data-received on destination is triggered
    $destination.get-data(
      $destination-widget, $context-no, $target-atom, $time
    ) if ?$target-atom;

    True
  }

  #-----------------------------------------------------------------------------
  method on-drag-data-received (
    N-GObject $context-no, Int $x, Int $y,
    N-GObject $selection-data-no, UInt $info, UInt $time,
    :_widget($destination-widget), DestinationType :$destination-type,
    Gnome::Gtk3::DragDest :$destination
  ) {
#note "\ndst received:, $x, $y, $info, $time";
    my Gnome::Gtk3::SelectionData $selection-data .= new(
      :native-object($selection-data-no)
    );

    my $source-data;
    given $destination-type {
      when MARKUP_DROP {
        $source-data = $selection-data.get(:data-type(Str));
        $destination-widget.set-markup($source-data);
      }

      when TEXT_PLAIN_DROP {
        $source-data = $selection-data.get(:data-type(Str));
        $destination-widget.set-text($source-data);
      }

      when NUMBER_DROP {
        $source-data = $selection-data.get(:data-type(Num));
        $destination-widget.set-text($source-data.fmt('%.3f'));
      }

      when IMAGE_DROP {
        my Gnome::Gdk3::DragContext $context .= new(
          :native-object($context-no)
        );
        
        my Gnome::Gdk3::Atom $target-atom = $destination.find-target(
          $destination-widget, $context,
          $destination.get-target-list($destination-widget)
        );

        given $target-atom.name {
          when 'image/png' {
            $source-data = $selection-data.get-pixbuf;
            $destination-widget.set-from-pixbuf($source-data);
          }

          when 'text/uri-list' {
            $source-data = $selection-data.get-uris;
            note $source-data.elems, ', ', $source-data;
            for @$source-data -> $uri is copy {
              if $uri.IO.extension ~~ any(<jpg png jpeg svg>) {
                $uri ~~ s/^ 'file://' //;
                $uri ~~ s:g/'%20'/ /;

                # Next statement works but we want to have a max width
                # of 380 pix to prevent expanding into huge displays,
                # so we need to get a bit more dificult
                #$destination-widget.set-from-file($uri);

                my Gnome::Gdk3::Pixbuf $pixbuf .= new(
                  :file($uri), :380width, :380height, :preserve_aspect_ration
                );
                $destination-widget.set-from-pixbuf($pixbuf);
                last;
              }
            }
          }
        }
      }
    }
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
$image.set-from-file(%leds<green>);
my Gnome::Gtk3::EventBox $source-widget .= new;
$source-widget.add($image);
$grid.attach( $source-widget, 0, 0, 1, 1);
my DragSourceWidget $drag-source-widget .= new(:$source-widget);


# Destination label for plain text
my Frame $frame .= new(:label('Drop plain text'));
my Label $plain-text-drop .= new(:text('... drop here ...'));
$frame.add($plain-text-drop);
$grid.attach( $frame, 0, 1, 1, 1);
my DragDestinationWidget $dd1 .= new(
  :destination-widget($plain-text-drop), :destination-type(TEXT_PLAIN_DROP)
);

$frame .= new(:label('Drop markup text'));
my Label $markup-text-drop .= new(:text('... drop here ...'));
#$markup-text-drop.set-use-markup(True);
$frame.add($markup-text-drop);
$grid.attach( $frame, 0, 2, 1, 1);
my DragDestinationWidget $dd2 .= new(
  :destination-widget($markup-text-drop), :destination-type(MARKUP_DROP)
);

$frame .= new(:label('Drop number'));
my Label $number-drop .= new(:text('... drop here ...'));
$frame.add($number-drop);
$grid.attach( $frame, 0, 3, 1, 1);
my DragDestinationWidget $dd3 .= new(
  :destination-widget($number-drop), :destination-type(NUMBER_DROP)
);

$frame .= new(:label('Drop image'));
my Gnome::Gtk3::Image $image-drop .= new;
$image-drop.set-size-request( 380, 380);
$frame.add($image-drop);
$grid.attach( $frame, 0, 4, 1, 1);
my DragDestinationWidget $dd4 .= new(
  :destination-widget($image-drop), :destination-type(IMAGE_DROP)
);




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
