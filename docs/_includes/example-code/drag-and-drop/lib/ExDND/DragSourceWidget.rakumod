
use v6;

use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
#use Gnome::N::X;
#Gnome::N::debug(:on);

use Gnome::Gtk3::Enums;

use Gnome::Gtk3::TargetEntry;
use Gnome::Gtk3::DragSource;
use Gnome::Gtk3::SelectionData;

use Gnome::Gdk3::Atom;
use Gnome::Gdk3::DragContext;
use Gnome::Gdk3::Types;
use Gnome::Gdk3::Pixbuf;

use ExDND::Types;

#-------------------------------------------------------------------------------
unit class ExDND::DragSourceWidget;

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

  my Gnome::Gtk3::SelectionData() $selection-data = $selection-data-no;

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
