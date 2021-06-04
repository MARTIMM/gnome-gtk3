---
title: Tutorial - Drag and Drop - Source Widget
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---

# Setting Up a Source Widget

A widget is set up as a source widget for drag operations by calling the function `Gnome::Gtk3::DragSOurce.set()` on it. The prototype is

```
method set (
  N-GObject $widget, Int() $start-button-mask,
  Array[N-GtkTargetEntry] $targets, Int() $actions
)
```

The first argument, widget, is the widget to be the drag source. The remaining arguments have the following meaning.

* $start-button-mask; the bitmask of buttons that can start the drag, of type
 `GdkModifierType`.
* $targets; the table of targets (in the form of an Array of N-GtkTargetEntry) that the drag will support, which may be empty.
* $actions; the bitmask of possible actions for a drag from this widget.

The values of the `GdkModifierType` enumeration are listed in the API documentation for the **Gnome::Gdk3::Types**. The values have names such as `GDK_BUTTON1_MASK`, `GDK_BUTTON2_MASK`, and so on. In addition, you can bitwise-or modifiers such as `GDK_CONTROL_MASK` and `GDK_SHIFT_MASK` into the mask. Usually you should just set the mask to be `GDK_BUTTON1_MASK`.

Note. The API documentation for this function states that the widget must have a window. An image, for example, cannot be used as a drag source because of that. A class like **Gnome::Gtk3::EventBox** can be used to embed the image. You need to decide what types of data the widget will supply. Usually this is a simple matter; it has text, or perhaps images, or perhaps it has its own application-specific data chunks.

We will use the following target table in the examples that follow with the enumerations from `TargetInfo` defined before (page Background).
```
my Array[N-GtkTargetEntry] $target-entries = [
  N-GtkTargetEntry.new(
    :target<text/html>, :flags(0), :info(TEXT_HTML)
  ),
  N-GtkTargetEntry.new( :target<STRING>, :flags(0), :info(STRING)),
  N-GtkTargetEntry.new( :target<number>, :flags(0), :info(NUMBER)),
  N-GtkTargetEntry.new(
   :target<image/jpeg>, :flags(0), :info(IMAGE_JPEG)
  ),
  N-GtkTargetEntry.new(
    :target<text/uri-list>, :flags(0), :info(TEXT_URI)),
];
```

The "text/uri-list" target is commonly used to drag links and filenames between applications. You also need to connect the signals that you want to handle to the source widget.

## Example

The following "boilerplate" listing demonstrates the basic steps in setting up a source widget.

```
method setup-source-widget ( $source-widget ) {
  my Array[N-GtkTargetEntry] $target-entries = [];
  my @entry-list-data = (
    'text/html', 0, TEXT_HTML,
    'STRING', 0, STRING,
    'number', 0, NUMBER,
    'image/jpeg', 0, IMAGE_JPEG,
    'text/uri-list', 0, TEXT_URI,
  );
  for @entry-list-data -> $target, $flags, $info {
    $target-entries.push: N-GtkTargetEntry.new( :$target, :$flags, :$info);
  }

  # Make this a drag source offering all of the targets listed above
  my Gnome::Gtk3::DragSource $source;
  $source.set( $source-widget, GDK_BUTTON1_MASK, $target-entries,
    GDK_ACTION_COPY +| GDK_ACTION_MOVE
  );

  # Connect the source widget to all signals that the source should handle.
  # Note that the handler methods are in this same class (referencing self)
  $source-widget.register-signal( self, 'on-drag-begin', 'drag_begin');
  $source-widget.register-signal( self, 'on-drag-data-get', 'drag_data_get');
  $source-widget.register-signal( self, 'on-drag-end', 'drag_end');
}
```

This widget will offer all of the different target types listed in `$target-entries`. It also supports copying and moving of drag data. The only difference is that, on a move, the source has to delete the original data.

We will need to write the three handlers, `on-drag-begin()`, `on-drag-data-get()`, and `on-drag-end()`. These handlers depend upon the specific widget and what types of data it supplies. First let us see how to set up a destination widget, after which we will describe and give examples of handlers for all of the relevant signals.
