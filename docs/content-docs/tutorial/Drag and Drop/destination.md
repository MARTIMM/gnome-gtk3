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



5.1
 Example
A listing of a set up of a very simple destination widget follows.
void
 setup_dest_button
 (
 GtkWidget
 ∗ dest_widget
 )
{
/
∗
 Allow
 two
 different
 types
 of
 text
 ∗ /
GtkTargetEntry
 text_targets [ ]
 =
 {
{" t e x t / html " ,
 0,
 TEXT_HTML
 },
{ "STRING " ,
 0,
 STRING}
};
gtk_drag_dest_set (
 dest_button ,
9
CSci493.73 Graphical User Interface Programming
The GTK+ Drag-and-Drop Mechanism
Prof. Stewart Weiss
}
0,
text_targets ,
0,
GDK_ACTION_COPY ) ;
/
∗
 Connect
 this
 widget
 to
 all
 of
 the
 signals
 that
 a
 potential
drop
 widget
 might
 emit .
 There
 are
 four
 of
 them :
 drag
 −m o t i o n
 ,
drag
 −d r o p
 ,
 drag
 −d a t a − r e c e i v e d
 ,
 and
 drag
 − l e a v e
 .
∗/
g _ s i g n a l _ c o n n e c t (G_OBJECT( d e s t _ w i d g e t ) ,
" drag_data_received " ,
G_CALLBACK
 ( on_drag_data_received ) ,
NULL ) ;
g _ s i g n a l _ c o n n e c t (G_OBJECT( d e s t _ w i d g e t ) ,
" drag_drop " ,
G_CALLBACK
 ( on_drag_drop ) ,
NULL ) ;
g _ s i g n a l _ c o n n e c t (G_OBJECT( d e s t _ w i d g e t ) ,
" drag_motion " ,
G_CALLBACK
 ( on_drag_motion ) ,
NULL ) ;
g _ s i g n a l _ c o n n e c t (G_OBJECT( d e s t _ w i d g e t ) ,
" drag_leave " ,
G_CALLBACK
 ( on_drag_leave ) ,
NULL ) ;
5.2
 Adding Targets to the Destination
Although it is often sucient to use
 gtk_drag_dest_set()
 to set up a destination widget, it is of lim-
ited use.
 It is often more convenient to create the destination with a
 NULL target table and then call
gtk_drag_dest_set_target_list() to set the target list for the destination. The advantage of doing this is
that there are several functions for adding classes of targets to target lists. For example, there is a function to
add all image targets to a target list, or all text targets. The prototype of
 gtk_drag_dest_set_target_list()
is
void
gtk_drag_dest_set_target_list
( GtkWidget *widget,
GtkTargetList *target_list);
which is given the widget and a target list, not a target table. You can create a target list from a target
table with
GtkTargetList *gtk_target_list_new
 ( const GtkTargetEntry *targets,
guint ntargets);
which is given the table and returns a newly-allocated target list. If you call it as
target_list = gtk_target_list_new(NULL, 0);
you will have an initially empty target list. You can prepend a target table to an existing target list with
10
CSci493.73 Graphical User Interface Programming
The GTK+ Drag-and-Drop Mechanism
void
 gtk_target_list_add_table
Prof. Stewart Weiss
( GtkTargetList *list,
const GtkTargetEntry *targets,
guint ntargets);
and you can append a single target to a target list with
void
 gtk_target_list_add
( GtkTargetList *list,
GdkAtom target,
guint flags,
guint info);
This function requires the target's atom.
 This implies that you must have first interned the target with
gdk_atom_intern() to get an atom for it. The flags value is the same as you would use in the target table,
and the info value is the integer by which you want to refer to this target elsewhere in the application.
To add all image targets that are supported by the system's
 GtkSelectionData
 object, use
void
gtk_target_list_add_image_targets ( GtkTargetList *list,
guint info,
gboolean writable);
where
 info
 is the integer by which you will refer to all image targets, and
 writable is a flag that
 when
TRUE,
 limits the image types to those that can be written, and when
 FALSE, allows all image types,
 those
can can be read only as well as written.
You may refer to the API documentation for the other similar functions:
 gtk_target_list_add_text_targets(),
gtk_target_list_add_uri_targets(),
 and
 gtk_target_list_add_rich_text_targets().
The order in which the targets occur in the target list is important. When the drop occurs, the widget will
need to decide which of the targets to accept. The simplest function for this purpose will traverse the target
list from front to back looking for the first target that satisfies the criteria.
 There are other methods of
choosing that do not depend on order, but they will take more work.
The following listing shows how to set up a
 GtkDrawingArea
 widget to accept drops of any image format
and the URIs. It might be interested in accepting the drop of a URI in case it is an image file, in which case
it can load the image from the file.
Listing 1: setup_drawing_area
void
 s e t u p _ d r a w i n g _ a r e a ( GtkWidget
 ∗ drawing_area
 )
{
/
∗
 Create
 an
 empty
 target
 list
 from
 an
 empty
 target
 table
 ∗ /
GtkTargetList
 ∗ target_list
 =
 g t k _ t a r g e t _ l i s t _ n e w (NULL,
 0);
/
∗
 Add
 all
 supported
 image
 targets
 to
 the
 list
The IMAGE_TARGET
 argument
 is
 an
 integer
 defined
 in
 the
 TargetInfo
enumeration .
 All
 image
 formats
 will
 have
 this
 same
 info
 value .
∗/
gtk_target_list_add_image_targets ( t a r g e t _ l i s t ,
 IMAGE_TARGET,
 FALSE ) ;
/
∗
 Add
 supported
 text / uri
 targets .
 These
 are
 appended
 to
 the
 list
so
 that
 preference
 is
 given
 to
 actual
 image
 formats .
∗/
gtk_target_list_add_uri_targets ( t a r g e t _ l i s t ,
 TEXT_URI ) ;
gtk_drag_dest_set (
drawing_area0,
,
11
CSci493.73 Graphical User Interface Programming
The GTK+ Drag-and-Drop Mechanism
Prof. Stewart Weiss
NULL,
 //
 empty
 target
 table
0,
GDK_ACTION_COPY ) ;
/
∗
 Add
 the
 target
 list
 to
 the
 widget
 ∗ /
g t k _ d r a g _ d e s t _ s e t _ t a r g e t _ l i s t ( drawing_area ,
target_list );
/
∗
 Initialize
 a
 pixbuf
 pointer
 to
 NULL
 to
g _ o b j e c t _ s e t _ d a t a (G_OBJECT( d r a w i n g _ a r e a ) ,
indicate
 there
 is
" pixbuf " ,
 NULL ) ;
no
 image
/
∗
 Connect
 expose
 event
 handler
 ∗/
g _ s i g n a l _ c o n n e c t (G_OBJECT( d r a w i n g _ a r e a ) ,
" expose
 −e v e n t " ,
G_CALLBACK
 ( on_expose ) ,
NULL ) ;
}
/
∗
 Connect
 handlers
 for
 remaining
 signals
 ∗ /
g _ s i g n a l _ c o n n e c t (G_OBJECT( d r a w i n g _ a r e a ) ,
" drag_data_received " ,
G_CALLBACK
 ( on_da_drag_data_received ) ,
NULL ) ;
g _ s i g n a l _ c o n n e c t (G_OBJECT( d r a w i n g _ a r e a ) ,
" drag_drop " ,
G_CALLBACK
 ( on_da_drag_drop ) ,
NULL ) ;
g _ s i g n a l _ c o n n e c t (G_OBJECT( d r a w i n g _ a r e a ) ,
" drag_motion " ,
G_CALLBACK
 ( on_da_drag_motion ) ,
NULL ) ;
g _ s i g n a l _ c o n n e c t (G_OBJECT( d r a w i n g _ a r e a ) ,
" drag_leave " ,
G_CALLBACK
 ( on_da_drag_leave ) ,
NULL ) ;
