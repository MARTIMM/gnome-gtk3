#!/usr/bin/env -S raku -I lib

#`{{
Example drag and drop;
- one target type
- one source and one destination
- show events on console
- show use of eventbox for drag source image
}}

use v6;

use NativeCall;

use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::EventBox;
use Gnome::Gtk3::Image;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Label;
#use Gnome::Gtk3::DrawingArea;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Window;
#use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Main;
use Gnome::Gtk3::Enums;

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
constant TEXT_PLAIN_DROP = 0xff;

#-------------------------------------------------------------------------------
class AppHandlers {
  #-----------------------------------------------------------------------------
  method quit ( ) {
    Gnome::Gtk3::Main.new.main-quit;
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

    my Gnome::Gtk3::TargetList $target-list .= new;
    $!targets = %(:string(Gnome::Gdk3::Atom.new(:intern<text/plain>)));
    $target-list.add( $!targets<string>, GTK_TARGET_SAME_APP, TEXT_PLAIN_DROP);
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
    $!target-data = %(:string((now - $!start-time).fmt('%.3f')));
  }

  #-----------------------------------------------------------------------------
  method get (
    N-GObject $context, N-GObject $selection-data, UInt $info, UInt $time,
    :_widget($widget)
  ) {
    note "src get: info=$info, time=$time, time since begin=$!target-data<string>";

    my Gnome::Gtk3::SelectionData $sd .= new(:native-object($selection-data));

    # here, you can check for target name to decide what to return
    # now always 'string'.
    $sd.set(
      $!targets<string>,
      "The drag started $!target-data<string> seconds after start"
    );
  }

  #-----------------------------------------------------------------------------
  method end ( N-GObject $context, :_widget($widget) ) {
    note "src end";
  }

  #-----------------------------------------------------------------------------
  method delete ( N-GObject $context, :_widget($widget) ) {
    note "src delete";
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
  submethod BUILD ( :$grid, :$x, :$y, :$w, :$h ) {

    my Gnome::Gtk3::Label $widget .= new(:text('Drag Zone'));
    $grid.attach( $widget, $x, $y, $w, $h);

    $!destination .= new;
    $!destination.set( $widget, 0, GDK_ACTION_COPY +| GDK_ACTION_MOVE);

    my Gnome::Gtk3::TargetList $target-list .= new;
    $target-list.add(
      Gnome::Gdk3::Atom.new(:intern<text/plain>), GTK_TARGET_SAME_APP, TEXT_PLAIN_DROP
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
    note "dst motion: x=$x, y=$y, time=$time";

    my Gnome::Gdk3::Atom $a = $!destination.find-target(
      $widget, $context, $!destination.get-target-list($widget)
    );

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
    note "dst drop: x=$x, y=$y, time=$time";
    my Gnome::Gdk3::Atom $a = $!destination.find-target(
      $widget, $context, $!destination.get-target-list($widget)
    );

    # ask for data. triggers drag-data-get on source. when data is received or
    # error, drag-data-received on destination is triggered
    $!destination.get-data( $widget, $context, $a, $time);

    True
  }

  #-----------------------------------------------------------------------------
  method received (
    N-GObject $context, Int $x, Int $y,
    N-GObject $selection-data, UInt $info, UInt $time, :_widget($widget)
  ) {
    note "dst received:, x=$x, y=$y, info=$info, time=$time";
    my Gnome::Gtk3::SelectionData $sd .= new(:native-object($selection-data));

    if ( my Str $str = $sd.get(:data-type(Str)) ).defined {
      $widget.set-text($str);
      $!destination.finish( $context, True, True, $time);
    }

    else {
      $!destination.finish( $context, False, False, $time);
    }
  }

  #-----------------------------------------------------------------------------
  method leave ( N-GObject $context, UInt $time, :_widget($widget) ) {
    note "dst leave: time=$time";
    $!destination.unhighlight($widget);
  }
}

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Grid $grid .= new;
$grid.set-border-width(10);
my DragSourceWidget $dsb1 .= new( :$grid, :0x, :0y, :1w, :1h);
my DragDestinationWidget $ddb1 .= new( :$grid, :1x, :2y, :2w, :1h);

my Gnome::Gtk3::Label $ph .= new(:text(''));
$grid.attach( $ph, 0, 1, 2, 1);

my AppHandlers $ah .= new;
given my Gnome::Gtk3::Window $window .= new {
  .set-title('drag and drop');
  .set-size-request( 400, 300);
  .register-signal( $ah, 'quit', 'destroy');
  .add($grid);
  .show-all;
}

Gnome::Gtk3::Main.new.main;
