---
title: Tutorial - Drag and Drop - Destination Widget
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---

# Setting Up a Destination Widget

A widget is set up as a destination widget by calling `Gnome::Gtk3::DragDest.set()`, whose prototype is

```
multi method set (
  N-GObject $widget, Int() $flags,
  Array[N-GtkTargetEntry] $targets, Int() $actions
)
```

The first argument, $widget, is the widget to be the drag destination. The remaining arguments have the following meaning.

* $flags; the default drag behaviors to use targets the table of targets that the destination will accept, or `GTK_DEST_DEFAULT_NONE` for none. This is an enumeration type of `GtkDestDefaults` defined in **Gnome::Gtk3::DragDest**.
* $actions; the bitmask of possible actions for a drop onto this widget.

The flags argument can be used to specify default behaviors for this widget. The values make it possible to write a very simple destination widget if you are willing to accept default behaviors for it. If it is set to `GTK_DEST_DEFAULT_NONE`, there will be no defaults, and you will have to write handlers for all of the possible signals. The possible values for the flags argument as as follows:

* `GTK_DEST_DEFAULT_MOTION`; If set for a widget, GTK+, during a drag over this widget will check if the drag matches this widget's list of possible targets and actions, and will call `Gnome::Gdk3::DragContext.status()` as appropriate. If you set this flag, you will not need to write a handler for the "drag-motion" signal; GTK+ will supply a default handler. Conversely, you should not set this flag if you do connect your own handler, because unless you really know what you are doing, there will be unpredictable results.
* `GTK_DEST_DEFAULT_HIGHLIGHT`; If set for a widget, GTK+ will draw a highlight on this widget as long as a drag is over this widget and the widget drag format and action are acceptable. If you set this flag, then you will not need to do the highlighting yourself in the "drag-motion" handler, and if you do the highlighting there, then you should not set this flag.
* `GTK_DEST_DEFAULT_DROP`; If set for a widget, when a drop occurs, GTK+ will check if the drag matches this widget's list of possible targets and actions. If so, GTK+ will call gtk_drag_get_data() on behalf of the widget and it will also gtk_drag_finish(). GTK+ will also take care of passing the appropriate values to `Gnome::Gtk3::DragDest.finish()` to make sure that move actions and copy actions are handled correctly. If you set this flag, you will have to know what you are doing in your own custom "drag-motion" handler, and you will not need to write a handler for the "drag-drop" signal.
* `GTK_DEST_DEFAULT_ALL`; If set, all of the above default actions will be taken. In this case, you will only need to write a handler for the "drag-data-receive" signal. The destination does not have to accept the exact set of targets ofiered by the source. It might be a subset, or a superset, or it may even be unrelated, depending on the nature of your application. If DND is being used strictly to allow drags within your application, you may want to place the target table definition in a header file that can be included by all widgets, so that destination and source widgets share the same target names and info values.


## Example

A listing of a set up of a very simple destination widget follows.

```
method setup-dest-widget ( $destination-widget ) {
  # Allow two different types of text
  my Array[N-GtkTargetEntry] $target-entries = [];
  my @entry-list-data = (
    'text/html', 0, TEXT_HTML,
    'STRING', 0, STRING,
  );
  for @entry-list-data -> $target, $flags, $info {
    $target-entries.push: N-GtkTargetEntry.new( :$target, :$flags, :$info);
  }

  my Gnome::Gtk3::DragDest $destination .= new;
  $destination.set( $destination-widget, GTK_DEST_DEFAULT_NONE, $target-entries,
    GDK_ACTION_COPY +| GDK_ACTION_MOVE
  );

  # Connect this widget to all of the signals that a potential drop
  # widget might emit. There are four of them: drag−motion,
  # drag-drop, drag-data-received and drag-leave
  $destination-widget.register-signal(
    self, 'on-drag-data-receive', 'drag-data-receive'
  );
  $destination-widget.register-signal( self, 'on-drag-drop', 'drag-drop');
  $destination-widget.register-signal( self, 'on-drag-motion', 'drag-motion');
  $destination-widget.register-signal( self, 'on-drag-leave', 'drag-leave');
}
```

## Adding Targets to the Destination

Although it is often suffcient to use `Gnome::Gtk3::DragDest.set()` to set up a destination widget, it is of limited use. It is often more convenient to create the destination with an empty target table and then call `Gnome::Gtk3::DragDest.set-target-list()` to set the target list for the destination. The advantage of doing this is that there are several functions for adding classes of targets to target lists. For example, there is a function to add all image targets to a target list, or all text targets **¹**. The prototype of `.set-target-list()` is

```
method set-target-list ( N-GObject $widget, N-GtkTargetList $target-list )
```
which is given the widget and a target list, not a target table. You can create a target list from a target table with

```
my Gnome::Gtk3::TargetList $target-list .= new(:targets($target-entries));
```
which is given the table and instantiates a newly allocated target list object. You can prepend a target table to an existing target list with
```
$target-list.add-table($target-entries);
```
and you can append a single target to a target list with
```
$target-list.add(
  Gnome::Gdk3::Atom.new(:intern<text/html>), 0, TEXT_HTML
);
```

This function requires the target's atom. The flags value is the same as you would use in the target table, and the info value is the integer by which you want to refer to this target elsewhere in the application.

To add all image targets that are supported by the applications **Gnome::Gtk3::DragDest** object, use **²**
```
$target-list.add-image-targets( $info, $writable);
```
where
* $info; is the integer by which you will refer to all image targets
* $writable is a boolean that when True, limits the image types to those that can be written, and when False, allows all image types, those can can be read only as well as written.

You may refer to the API documentation for the other similar functions: `.add-text-targets()`, `.add-uri-targets()`, and `add-rich-text-targets()`.

The order in which the targets occur in the target list is important. When the drop occurs, the widget will need to decide which of the targets to accept. The simplest function for this purpose will traverse the target list from front to back looking for the first target that satisfies the criteria. There are other methods of choosing that do not depend on order, but they will take more work.

The following listing shows how to set up a **Gnome::Gtk3DrawingArea** widget to accept drops of any image format and the URIs. It might be interested in accepting the drop of a URI in case it is an image file, in which case it can load the image from the file.

<!--
  TODO do we need this in classes?
  # Initialize a pixbuf pointer to NULL to indicate there is no image
  $drawing-area.set-data( 'pixbuf', Nil)
-->

```
method setup-drawing-area ( $drawing-area ) {
  # Create an empty target list from an empty target table
  my Gnome::Gtk3::TargetList $target-list .= new(:targets([]));

  # Add all supported image targets to the list The IMAGE_TARGET argument is
  # an integer defined in the `TargetInfo` enumeration. All image formats will
  # have this same info value.
  $target-list.add-image-targets( IMAGE_TARGET, False);

  # Add supported text/uri targets. These are appended to the list so
  # that preference is given to actual image formats.
  $target-list.add-uri-targets(TEXT_URI);

  # add empty target array
  my Gnome::Gtk3::DragDest $destination .= new;
  $destination.set(
    $drawing-area, GTK_DEST_DEFAULT_NONE, [], GDK_ACTION_COPY
  );

  # Add the target list to the widget
  $destination.set-target-list( $drawing-area, $target-list);

  # Connect draw event handler
  $drawing-area.register-signal( self, 'on-draw', 'draw');

  # Connect handlers for remaining signals
  $drawing-area.register-signal(
    self, 'on-drag-data-received', 'drag-data-received'
  );
  $drawing-area.register-signal( self, 'on-drag-drop', 'drag-drop');
  $drawing-area.register-signal( self, 'on-drag-motion', 'drag-motion');
  $drawing-area.register-signal( self, 'on-drag-leave', 'drag-leave');
}
```

<hr/>

**1)** Nowadays, the drag destination class also provides methods to add text, image and uri targets altough with a different api which offers less control. This is also true for the drag source class.

**2)** See also the same method defined in **Gnome::Gtk3::DragDest** and **Gnome::Gtk3::DragSource** with a simpler api. I.e. info is set to 0.
