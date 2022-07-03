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
use Gnome::N::GlibToRakuTypes;
#use Gnome::N::X;
#Gnome::N::debug(:on);

#use Gnome::Gtk3::EventBox;
use Gnome::Gtk3::Image;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Label;
#use Gnome::Gtk3::DrawingArea;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Frame;
use Gnome::Gtk3::Window;
#use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Enums;

use Gnome::Gtk3::Drag;
#use Gnome::Gtk3::DragSource;
use Gnome::Gtk3::DragDest;
use Gnome::Gtk3::TargetList;
use Gnome::Gtk3::SelectionData;

use Gnome::Gdk3::Atom;
use Gnome::Gdk3::DragContext;
use Gnome::Gdk3::Types;
#use Gnome::Gdk3::Pixbuf;

use Gnome::Glib::List;

#-------------------------------------------------------------------------------
# a convenience class for frames
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
# a convenience class for labels
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
class AppHandlers {
  #-----------------------------------------------------------------------------
  method quit ( ) {
    Gnome::Gtk3::Main.new.main-quit;
  }
}

#-------------------------------------------------------------------------------
class SourceTargetViewer is Gnome::Gtk3::Grid {

  has Gnome::Gtk3::DragDest $!destination;
  has Label $!target-view;
  has Label $!text-view;

  #-----------------------------------------------------------------------------
  method new ( |c ) {
    self.bless( :GtkGrid, |c);
  }

  #-----------------------------------------------------------------------------
  submethod BUILD ( ) {

    # place border around grid
    self.set-border-width(10);

    # provide some explanation
    my Frame $f .= new(:label('Explanation'));
    self.attach( $f, 0, 0, 1, 1);

    my Label $explain .= new(:text(Q:q:to/EOEXPL/));
      You can drag widgets from elsewhere onto the bullseye
      shown below. When hovering over the bullseye, a list
      of atom targets appear which are supported by the
      source widget.
      When dropped, and one of the target listed atoms shows
      <b>text/plain</b>, a textual representation will be shown.
      EOEXPL

    $f.add($explain);

    # place the bullseye being the drop zone
    my Gnome::Gtk3::Image $image .= new;
    $image.set-from-file('xt/data/bullseye.jpg');
    self.attach( $image, 0, 1, 1, 1);

    # a frame for targets view list
    $f .= new(:label('Target list'));
    self.attach( $f, 0, 2, 1, 1);

    # targets view list in frame
    $!target-view .= new;#(:text(''));
    $f.add($!target-view);

    # a frame for text output
    $f .= new(:label('Textual representation'));
    self.attach( $f, 0, 3, 1, 1);

    # text output in frame
    $!text-view .= new;#(:text(''));
    $f.add($!text-view);

    # initialize destination widget
    $!destination .= new;
    $!destination.set( $image, 0, [], GDK_ACTION_COPY);

    # droppable target atom can manage 'text/plain' mimetypes
    # and source widgets are from other programs
    # info is 0xff and has no purpose here.
    my Gnome::Gtk3::TargetList $target-list .= new;
    $target-list.add(
      Gnome::Gdk3::Atom.new(:intern<text/plain>), GTK_TARGET_OTHER_APP, 0xff
    );

    # target list is placed on drop destination
    $!destination.set-target-list( $image, $target-list);

    # register necessary signal handlers
    $image.register-signal( self, 'motion', 'drag-motion');
    $image.register-signal( self, 'drop', 'drag-drop');
    $image.register-signal( self, 'received', 'drag-data-received');
    $image.register-signal( self, 'leave', 'drag-leave');
  }

  #-----------------------------------------------------------------------------
  # motion is called for drag-motion events. as long the mouse hovers over the
  # drop area, events come pooring in until a drop is done (i.e. a mouse
  # button is released)
  method motion (
    N-GObject $context, Int $x, Int $y, UInt $time, :_widget($widget)
    --> Bool
  ) {
    my Bool $status;

    # get the list of source targets and put them in a string
    my Gnome::Gdk3::DragContext() $dctx = $context;
    my Gnome::Glib::List() $lt = $dctx.list-targets;
    my Str $label-text = '';
    for ^$lt.length -> $i {
      my Gnome::Gdk3::Atom() $lt-a = $lt.nth-data($i);
      my Str $name = $lt-a.name;
      if $name ~~ 'text/plain' {
        $label-text ~= "<b>$name\n</b>";
      }

      else {
        $label-text ~= "$name\n";
      }
    }

    # compare with a previously saved list to prevent updating the label
    # all the time that motion events are calling this handler
    state $prev-text = '';
    if $prev-text !~~ $label-text {
      $!target-view.set-label($label-text);
      $prev-text = $label-text;
    }


    # check if there is a 'text/plain' atom in the list
    my Gnome::Gdk3::Atom() $a = $!destination.find-target(
      $widget, $context, $!destination.get-target-list($widget)
    );

    # if not, 'NONE' is returned. return False to show that we
    # cannot handle the data from the source
    if $a.name ~~ 'NONE' {
      $dctx.status( GDK_ACTION_COPY, $time);
      $status = False;
    }

    # if the name is different than 'NONE', return True to show
    # that we can handle the data.
    else {
      $*dnd.highlight($widget);
      $dctx.status( GDK_ACTION_COPY, $time);
      $status = True;
    }

    $status
  }

  #-----------------------------------------------------------------------------
  # after releasing the mouse button, indicating a drop, the drag has ended
  # so far the user concerned. the drag-leave shows the
  method leave ( N-GObject $context, UInt $time, :_widget($widget) ) {
    $*dnd.unhighlight($widget);
  }

  #-----------------------------------------------------------------------------
  # when the user releases the mouse button over the drop widget and motion
  # above returned True, the drag-drop event calls this handler.
  method drop (
    N-GObject $context, Int $x, Int $y, UInt $time, :_widget($widget)
    --> Bool
  ) {
    # ask for data. it triggers drag-data-get event on the source. when data
    # is received or an error occurs, drag-data-received event on
    # destination is triggered.
    $*dnd.get-data(
      $widget, $context, Gnome::Gdk3::Atom.new(:intern<text/plain>), $time
    );

    True
  }

  #-----------------------------------------------------------------------------
  # when the drag source widget delivers the data, the drag-data-received event
  # calls this handler.
  method received (
    N-GObject $context, Int $x, Int $y,
    N-GObject $selection-data, UInt $info, UInt $time, :_widget($widget)
  ) {
    # 'text/plain' mimetype is about string data. when something is not
    # right, $sd.get() returns an undefined string. finish() is called
    # to round things up.
    my Gnome::Gtk3::SelectionData() $sd = $selection-data;
    if ( my Str $str = $sd.get(:data-type(Str)) ).defined {
      $!text-view.set-text($str);
      $*dnd.finish( $context, True, False, $time);
    }

    else {
      $*dnd.finish( $context, False, False, $time);
    }

    # resize back to original. result is that the window shrinks to
    # what is needed at this moment
    my Gnome::Gtk3::Window() $window = $widget.get-toplevel;
    $window.resize( 400, 300);
  }
}

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Drag $*dnd .= new;

# initialize handler objects
my SourceTargetViewer $target-viewer .= new;
my AppHandlers $ah .= new;

# create window and fiddle a bit
given my Gnome::Gtk3::Window $window .= new {
  .set-title('drag and drop');
  .set-size-request( 400, 300);
  .register-signal( $ah, 'quit', 'destroy');
  .add($target-viewer);
  .show-all;
}

# start main loop
Gnome::Gtk3::Main.new.main;
