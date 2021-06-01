---
title: Tutorial - Drag and Drop - Background
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---

# Background

## Atoms

A **Gnome::Gdk3::Atom** is a fundamental type in GDK, its significance arising from the fact that it is an efficient way to represent large chunks of data. Windows under X can have any number of associated properties attached to them. Properties in general are arbitrary chunks of data identified by atoms. In X, an atom is a numeric index into a string table on the X server. They are used to transfer strings efficiently between clients without having to transfer the entire string. A property has an associated type, which is also identified using an atom.

Every property has an associated format, which is an integer describing how many bits are in each unit of data inside the property. It must be 8, 16, or 32. For example, if a property is a chunk of character data, then its format value would be 8, the number of bits in a character. If it is an integer, its format would be 32.

GDK provides functions for manipulating atoms. These will be needed when implementing drag-and-drop in GTK+. Your application will need to intern various strings. To intern a string means to store it in an internal table used by GDK and obtain an atom that identifies it for later access. The function to intern a string is

`multi method new ( Str :$intern! )`

This makes a copy of the string to be interned, i.e., the name of the atom, and returns an atom for that string. The inverse function is

`method name ( --> Str )`

Given an atom, this returns a newly-allocated string containing the string corresponding to atom. You will not need to use any of the other functions related to atoms for DND.

#### Example usage
```
use Gnome::Gdk3::Atom;

my Gnome::Gdk3::Atom $text-type .= new(:intern<text/plain>);
my Gnome::Gdk3::Atom $number-type .= new(:intern<number>);
…
if $some-atom.name ~~ 'number' {
  … process numbers …
}

elsif $some-atom.name ~~ 'text/plain' {
  … process plain text …
}
…
```

## Selections

The selection mechanism provides the basis for different types of communication between processes. In particular, drag-and-drop and the clipboard work because of the selection mechanism. The **Gnome::Gtk3::SelectionData** object is used to store a chunk of data along with the data type and other associated information. In drag-and-drop, the term selection refers to the choice of data that is supplied and/or received by a widget. When a drop is made on a widget, there may be several different types of data in the selection object that is provided to it; the widget has to decide which type of data it wants to accept. Therefore, one says that the widget selects a particular chunk of data.

The **Gnome::Gtk3::SelectionData** object acts like the medium of transport between drag sources and drag destinations. The source will use one of various methods in the **Gnome::Gtk3::SelectionData** class to describe the types of data that it offers, and the destination widgets will use methods to search the selection for data types that interest them. When data is actually transferred, the selection object will be used as the intermediary between the two widgets.


## Targets

The word "target" is a bit misleading in the context of DND. Although it sounds like it means the "target of a drop", it does not. The word "destination" refers to this widget. To avoid any confusion, we will never use the word "target" to mean the destination. A target is a type of data to be used in a DND operation. For example, a widget can supply a string target, an image target, or a numeric target. Targets are represented by the **N-GtkTargetEntry** structure. The **N-GtkTargetEntry** structure represents a single type of data than can be supplied by a widget for a selection or received by a destination widget in a drag-and-drop operation. It consists of three members:
* target, a string representing the type of data in a drag
* flags, a set of bits defining limits on where the target can be dropped
* info, an application assigned integer ID
```
class N-GtkTargetEntry is repr('CStruct') is export {
  has Str $.target;
  has guint $.flags;
  has guint $.info;
}
```

The target string provides a human-understandable description of the data type. It is important to use common sense target names, because if your application will accept drags or offer data to other applications, the names you choose should be those other applications might use also. The info member serves to identify the target in the functions that access and manipulate target data, because integers allow for faster look-ups and comparisons.

The flags value is from the `GtkTargetFlags` enumeration defined in **Gnome::Gtk3::TargetList** and may be one of the following:
* `GTK_TARGET_SAME_APP`: The target will only be selected for drags within a single application. E.g from an image to a label in the same application.
* `GTK_TARGET_SAME_WIDGET`: The target will only be selected for drags within a single widget. E.g. A row in a listbox to another row in the same listbox.
* `GTK_TARGET_OTHER_APP`: The target will not be selected for drags within a single application. This can be used, for example, to drag external files from a file viewer into your application.
* `GTK_TARGET_OTHER_WIDGET`: The target will not be selected for drags withing a single widget.

If `flags` is set to `0`, it means there are no constraints.

Usually you would create an enumeration within the application to provide meaningful names for the info values, for example:
```
enum AppTargetInfoDefs < TEXT_HTML STRING IMAGE_JPEG NUMBER TEXT_URI >;
```

Using this enumeration we could define a few different targets as follows:
```
my Gnome::Gtk3::TargetEntry $string-target .= new(
  :target<string-data>, :flags(0), :info(STRING)
);

my Gnome::Gtk3::TargetEntry $html-target .= new(
  :target<text/html>, :flags(GTK_TARGET_SAME_APP), :info(TEXT_HTML)
);

my Gnome::Gtk3::TargetEntry $image-target .= new(
  :target<image/jpeg>, :flags(GTK_TARGET_SAME_WIDGET), :info(IMAGE_JPEG)
);
```

The `$string-target` and the `$html-target` both represent text, but the latter would identify itself to a destination widget that was capable of parsing the HTML and preferred receiving it over plain text. Such a widget would probably select the `$html-target` rather than the `$string-target`. The `$image-target` could be used for JPEG image formats. The `$string-target` has no flags and therefore no limits on where it can be dropped. The `$html-target` is only allowed to be dropped into the same application as the source widget, and the `$image-target` is constrained to be dropped into the same widget.


## Target Tables and Target Lists

A target table is an array of type `N-GtkTargetEntry`. There is no object specifically declared to be a target table. It is just understood that it is an array of target entries. Target tables are useful in application code for consolidating target entry definitions.

More importantly, the function that sets up a widget as a DND source widget, `Gnome::Gtk3::SelectionData.set()`, requires the set of targets to be passed to it as a table. Target tables can also be passed as arguments to certain other functions related to **Gnome::Gtk3::SelectionData**.
<!--
The following is an example of a target table:
GtkTargetEntry target_entries[] = {
  {"text/html", 0, TEXT_HTML },
  {"STRING", 0, STRING},
  {"number", 0, NUMBER},
  {"image/jpeg", 0, IMAGE_JPEG},
  {"text/uri-list", 0, TEXT_URI}
};
-->

A
 target list is not a list of GtkTargetEntry structures, as you might expect. It is a list of GtkTargetPair
structures, and it serves a different purpose from target tables. A
 GtkTargetPair is a internal data structure
used by GTK+. It is defined by
4
CSci493.73 Graphical User Interface Programming
The GTK+ Drag-and-Drop Mechanism
Prof. Stewart Weiss
struct GtkTargetPair {
GdkAtom
 target;
guint
 flags;
guint
 info;
};
Notice that it differs from a
 GtkTargetEntry
 in a single respect: it uses a
 GdkAtom
 instead of a character
string to identify the target. Recall from Section 2.1 above that a
 GdkAtom
 is an integer that GDK uses to
represent a string internally; it is the index into an array of strings. An atom is only defined when a string
is interned.
The functions that take a GtkTargetEntry and store that target for later use intern the character string and
create an atom for it. Once this has been done, that target can be represented by a GtkTargetPair. In other
words, the target atom in the
 GtkTargetPair
 represents a target that has already been defined in some
GtkTargetEntry.

Because atoms make for faster comparison and identification and save storage space, target lists are more efficient than target tables and are used more extensively than them by GTK+. There are methods in the **Gnome::Gtk3::SelectionData** class for going back and forth between target table and target list representations of the targets. For example:

gtk_target_list_new()
 creates a target list from a target table
gtk_target_list_add_table()
 prepends a target table to an existing target list
gtk_target_table_new_from_list()
 creates a target table that contains the same targets as the given list.

Many of the methods provided by the **Gnome::Gtk3::SelectionData** class expect and manipulate target lists. They are of fundamental importance in using drag-and-drop, and we will have more to say about them below.
