
use v6;

use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
#use Gnome::N::X;
#Gnome::N::debug(:on);

use Gnome::Gtk3::Enums;

use Gnome::Gtk3::TargetEntry;
use Gnome::Gtk3::Drag;
use Gnome::Gtk3::DragDest;
use Gnome::Gtk3::TargetList;
use Gnome::Gtk3::SelectionData;

use Gnome::Gdk3::Atom;
use Gnome::Gdk3::DragContext;
use Gnome::Gdk3::Types;
use Gnome::Gdk3::Pixbuf;

use ExDND::Types;

#-------------------------------------------------------------------------------
unit class ExDND::DragDestinationWidget;

has Gnome::Gtk3::DragDest $!destination;
has DestinationType $!destination-type;
has Gnome::Gtk3::Drag $!dnd;

#-----------------------------------------------------------------------------
submethod BUILD ( :$destination-widget, DestinationType :$!destination-type ) {

  $!dnd .= new;
  $!destination .= new;
  $!destination.set( $destination-widget, 0, GDK_ACTION_COPY);

  my Gnome::Gtk3::TargetList $target-list;
  given $!destination-type {
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

  $!destination.set-target-list( $destination-widget, $target-list);

  $destination-widget.register-signal( self, 'on-drag-motion', 'drag-motion');
  $destination-widget.register-signal( self, 'on-drag-leave', 'drag-leave');
  $destination-widget.register-signal( self, 'on-drag-drop', 'drag-drop');
  $destination-widget.register-signal(
    self, 'on-drag-data-received', 'drag-data-received'
  );
}

#-----------------------------------------------------------------------------
method on-drag-motion (
  N-GObject $context-no, Int $x, Int $y, UInt $time,
  :_widget($destination-widget)
  --> Bool
) {
  my Bool $status;
#note "\ndst motion: $x, $y, $time";

  my Gnome::Gdk3::DragContext() $context = $context-no;
  my Gnome::Gdk3::Atom() $target-atom = $!destination.find-target(
    $destination-widget, $context,
    $!destination.get-target-list($destination-widget)
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
    $!dnd.highlight($destination-widget) if $suggest-action;
    $context.status( $suggest-action, $time);
    $status = True;
  }

  $status
}

#-----------------------------------------------------------------------------
method on-drag-leave (
  N-GObject $context-no, UInt $time, :_widget($destination-widget)
) {
#note "\ndst leave: $time";
  $!dnd.unhighlight($destination-widget);
}

#-----------------------------------------------------------------------------
method on-drag-drop (
  N-GObject $context-no, Int $x, Int $y, UInt $time,
  :_widget($destination-widget)
  --> Bool
) {
#note "\ndst drop: $x, $y, $time";

  my Gnome::Gdk3::DragContext() $context .= new(:native-object($context-no));
  my Gnome::Gdk3::Atom() $target-atom = $!destination.find-target(
    $destination-widget, $context,
    $!destination.get-target-list($destination-widget)
  );

#note $?LINE, ', Target match: ', (?$target-atom ?? $target-atom.name !! 'NONE');

  # ask for data. triggers a drag-data-get on source. when data is received or
  # error, drag-data-received on destination is triggered
  $!dnd.get-data(
    $destination-widget, $context-no, $target-atom, $time
  ) if ?$target-atom;

  True
}

#-----------------------------------------------------------------------------
method on-drag-data-received (
  N-GObject $context-no, Int $x, Int $y,
  N-GObject $selection-data-no, UInt $info, UInt $time,
  :_widget($destination-widget)
) {
#note "\ndst received:, $x, $y, $info, $time";
  my Gnome::Gtk3::SelectionData $selection-data .= new(
    :native-object($selection-data-no)
  );

  my $source-data;
  given $!destination-type {
    when MARKUP_DROP {
      $source-data = $selection-data.get(:data-type(Str));
      $destination-widget.set-markup($source-data);
    }

    when TEXT_PLAIN_DROP {
      $source-data = $selection-data.get-text;
      $destination-widget.set-text($source-data);
    }

    when NUMBER_DROP {
      $source-data = $selection-data.get(:data-type(Num));
      $destination-widget.set-text($source-data.fmt('%.3f'));
    }

    when IMAGE_DROP {
      my Gnome::Gdk3::Atom() $target-atom = $!destination.find-target(
        $destination-widget, $context-no,
        $!destination.get-target-list($destination-widget)
      );

      given $target-atom.name {
        when 'image/png' {
          $source-data = $selection-data.get-pixbuf;
          $destination-widget.set-from-pixbuf($source-data);
        }

        when 'text/uri-list' {
          $source-data = $selection-data.get-uris;
#note $source-data.elems, ', ', $source-data;
          for @$source-data -> $uri is copy {
            if $uri.IO.extension ~~ any(<jpg png jpeg svg>) {
              # drop the protocol part and when dragged from file explorer
              # replace the %20 url encoding for a space.
              $uri ~~ s/^ 'file://' //;
              $uri ~~ s:g/'%20'/ /;

              # Next statement works but we want to have a max width
              # of 380 pix to prevent expanding into huge displays,
              # so we need to get a bit more elaborate
              #$destination-widget.set-from-file($uri);

              $destination-widget.set-from-pixbuf(
                Gnome::Gdk3::Pixbuf.new(
                  :file($uri), :380width, :380height, :preserve_aspect_ratio
                )
              );
              last;
            }
          }
        }

        default {
          note "Computer says, No! target type '$_'";
        }
      }
    }
  }
}
