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

use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gtk3::EventBox:api<1>;
use Gnome::Gtk3::Image:api<1>;
use Gnome::Gtk3::Button:api<1>;
use Gnome::Gtk3::Label:api<1>;
#use Gnome::Gtk3::DrawingArea:api<1>;
use Gnome::Gtk3::Grid:api<1>;
use Gnome::Gtk3::Window:api<1>;
#use Gnome::Gtk3::Widget:api<1>;
use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::Enums:api<1>;

use Gnome::Gtk3::TargetEntry:api<1>;
use Gnome::Gtk3::Drag:api<1>;
use Gnome::Gtk3::DragSource:api<1>;
use Gnome::Gtk3::DragDest:api<1>;
use Gnome::Gtk3::TargetList:api<1>;
use Gnome::Gtk3::SelectionData:api<1>;

use Gnome::Gdk3::Atom:api<1>;
use Gnome::Gdk3::DragContext:api<1>;
use Gnome::Gdk3::Types:api<1>;
use Gnome::Gdk3::Pixbuf:api<1>;

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

  #-----------------------------------------------------------------------------
  submethod BUILD ( :$grid, :$x, :$y, :$w, :$h ) {
    my Gnome::Gtk3::Image $image .= new;
    $image.set-from-file('xt/data/amber-on-256.png');
    my Gnome::Gtk3::EventBox $widget .= new;
    $widget.add($image);
    $grid.attach( $widget, $x, $y, $w, $h);

    $!start-time = now;

    $!source .= new;
    my Array $e-targets = [
      N-GtkTargetEntry.new(
        :target<text/plain>, :flags(GTK_TARGET_SAME_APP), :info(TEXT_PLAIN_DROP)
      )
    ];

    $!source.set(
      $widget, GDK_BUTTON1_MASK, $e-targets,
      GDK_ACTION_MOVE +| GDK_ACTION_COPY +| GDK_ACTION_LINK +| GDK_ACTION_ASK
    );

    $widget.register-signal( self, 'begin', 'drag-begin');
    $widget.register-signal( self, 'get', 'drag-data-get');
    $widget.register-signal( self, 'end', 'drag-end');
    $widget.register-signal( self, 'delete', 'drag-data-delete');
    $widget.register-signal( self, 'failed', 'drag-failed');
  }

  #-----------------------------------------------------------------------------
  method begin ( N-GObject $context-no, :_widget($widget) ) {
    note "\nsrc begin";

    $!source.set-icon-name( $widget, 'text-x-generic');
    $!target-data = %(:string((now - $!start-time).fmt('%.3f')));
  }

  #-----------------------------------------------------------------------------
  method get (
    N-GObject $context-no, N-GObject $selection-data, UInt $info, UInt $time,
    :_widget($widget)
  ) {
    note "src get: info=$info, time=$time, time since begin=$!target-data<string>";

    my Gnome::Gtk3::SelectionData() $sd = $selection-data;

    # here, you can check for target name to decide what to return
    # now always 'string'.
    $sd.set(
      Gnome::Gdk3::Atom.new(:intern<text/plain>),
      "The drag started $!target-data<string> seconds after start"
    );
  }

  #-----------------------------------------------------------------------------
  method end ( N-GObject $context-no, :_widget($widget) ) {
    note "src end";
  }

  #-----------------------------------------------------------------------------
  method delete ( N-GObject $context-no, :_widget($widget) ) {
    note "src delete";
  }

  #-----------------------------------------------------------------------------
  method failed (
    N-GObject $context-no, Int $result, :_widget($widget) --> Bool
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
    $!destination.set(
      $widget, GTK_DEST_DEFAULT_MOTION, [
        Gnome::Gtk3::TargetEntry.new(
          :target<text/plain>, :flags(GTK_TARGET_SAME_APP),
          :info(TEXT_PLAIN_DROP)
        )
      ],
      GDK_ACTION_MOVE +| GDK_ACTION_COPY +| GDK_ACTION_LINK +| GDK_ACTION_ASK
    );

    $widget.register-signal( self, 'motion', 'drag-motion');
    $widget.register-signal( self, 'drop', 'drag-drop');
    $widget.register-signal( self, 'received', 'drag-data-received');
    $widget.register-signal( self, 'leave', 'drag-leave');
  }

  #-----------------------------------------------------------------------------
  method motion (
    N-GObject $context-no, Int $x, Int $y, UInt $time, :_widget($widget)
    --> Bool
  ) {
    my Bool $status = False;
    note "dst motion: x=$x, y=$y, time=$time";

    my Gnome::Gdk3::Atom() $a = $!destination.find-target(
      $widget, $context-no, $!destination.get-target-list($widget)
    );

    my Gnome::Gdk3::DragContext() $context = $context-no;
    if $a.name ~~ 'NONE' {
      $context.status( GDK_ACTION_COPY, $time);
    }

    else {
      my GdkDragAction $suggest-action = $context.get-suggested-action;

      # $suggest-action changes when control keys are used. It also changes
      # when mask is set differently.
      #
      # default: GDK_ACTION_COPY
      # <SHIFT>: GDK_ACTION_MOVE
      # <ALT>: GDK_ACTION_ASK
      # <CTR><SHIFT>: GDK_ACTION_LINK

      # I've also seen (when ASK was not set in mask)
      # <ALT>: GDK_ACTION_LINK
      # <CTR><SHIFT>: GDK_ACTION_NONE
#note "dst motion: action = $suggest-action";
      if $suggest-action {
        $*dnd.highlight($widget);
        $context.status( $suggest-action, $time);
        $status = True;
      }
    }

    $status
  }

  #-----------------------------------------------------------------------------
  method leave ( N-GObject $context-no, UInt $time, :_widget($widget) ) {
    note "dst leave: time=$time";
    $*dnd.unhighlight($widget);
  }

  #-----------------------------------------------------------------------------
  method drop (
    N-GObject $context-no, Int $x, Int $y, UInt $time, :_widget($widget)
    --> Bool
  ) {
    note "dst drop: x=$x, y=$y, time=$time";
    my Gnome::Gdk3::Atom() $a = $!destination.find-target(
      $widget, $context-no, $!destination.get-target-list($widget)
    );

    # ask for data. triggers drag-data-get on source. when data is received or
    # error, drag-data-received on destination is triggered
    $*dnd.get-data( $widget, $context-no, $a, $time);

    True
  }

  #-----------------------------------------------------------------------------
  method received (
    N-GObject $context-no, Int $x, Int $y,
    N-GObject $selection-data, UInt $info, UInt $time, :_widget($widget)
  ) {
    note "dst received:, x=$x, y=$y, info=$info, time=$time";
    my Gnome::Gtk3::SelectionData() $sd = $selection-data;

    if ( my Str $str = $sd.get(:data-type(Str)) ).defined {
      $widget.set-text($str);
      my Gnome::Gdk3::DragContext() $context = $context-no;
      my GdkDragAction $suggest-action = $context.get-suggested-action;

      $*dnd.finish(
        $context-no, True, $suggest-action ~~ GDK_ACTION_MOVE, $time
      );
    }

    else {
      $*dnd.finish( $context-no, False, False, $time);
    }
  }
}

#-------------------------------------------------------------------------------
my Gnome::Gtk3::Drag $*dnd .= new;

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
