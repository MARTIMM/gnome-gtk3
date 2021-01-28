---
title: Tutorial - Raku Modules
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# Raku Modules

## Class structure

You can think of the Raku classes in these packages as wrappers around native objects and subroutines. The Raku modules follow the same inheritance tree as the GTK+ 'classes' are made. This is not entirely true because C, where GTK+ is written in, does not have the object oriented mechanism as Raku has. Instead their 'classes' are eleborate structures with many functions around it which mimic class behavior.

The top classes in GTK+ are **GObject**, **GBoxed** and **GInterface**. In Raku the first two classes are named **Gnome::GObject::Object** and **Gnome::GObject::Boxed** but interfaces are defined differently in Raku as roles and are more or less standalone.

The Object and Boxed classes (I will make names somewhat shorter after introduction) in Raku are inheriting from another class, **Gnome::N::TopLevelClassSupport** to store the native object. From Object, the native object type will almost always be `N-GObject`. From Boxed, the native object types may differ. Examples are `N-GError`, `N-GList` or `N-GSList`.

The TopLevelClassSupport also provides common methods such as `.clean-object()` and `.is-valid()`. Also a `.new()` option `:native-object` is handled in the submethod `BUILD()` of this class.


## Interfaces

Interfaces mentioned above are implemented as roles. When such an interface is added to some class, the methods defined there are available to the class and its child classes.


## Boxed classes

The purpose of these classes is mainly that it is made with less fanfare then a widget class needs to have. So these classes are made smaller with less access functions. Examples of these classes are **Gnome::Gdk3::Pixbuf** and **Gnome::Gtk3::Border**.


## Other classes

There are still other classes which are standalone classes. Examples are **Gnome::Glib::Error** and  **Gnome::Gtk3::Main**. These classes have nothing in common with widgets but are more for control. Error to handle error messages and Main to handle event loops. Some of them still inherit from TopLevelClassSupport.


## Instantiation of a class


## Inheriting a class


## Native subroutines

Each of the classes have a set of native subroutines which belong in that class. For example the GTK+ structure GtkButton has methods like `gtk_button_set_label()`. So the Raku module **Gnome::Gtk3::Button** has this subroutine defined. Al these subroutines are not exported so they are only accessable from within the class.

To access the subroutines, the Raku `FALLBACK()` method is implemented to catch method names which are not implemented as such. The method is defined in the class TopLevelClassSupport. In turn it calls `._fallback()`. This `_fallback()` method is defined in every class to search for the native sub name in that class. The call from TopLevelClassSupport starts at the leaf class, the one you want to instantiate. If found, it returns the native sub address. When the name is not found, it continues its search with `.callsame()`. The end result is that the native subroutines behave as if they were methods.

Because all these calls start a search in `FALLBACK()` and after that, the `_fallback()` in every child class, there is the opportunity to change the name of the subroutine before searching. One could then use the name `.gtk-button-set-label()` with all dashes in it or remove the prefixes 'gtk_' or even 'gtk_button_' to call `.set-label()` instead.

So the possible method calls for the native sub `gtk_button_set_label()` are expanded to
```
my Gnome::Gtk3::Button $button .= new;

$button.gtk_button_set_label('Start');
$button.gtk-button_set-label('Start');  # intermixed '-' and '_'
$button.button_set_label('Start');      # drop 'gtk_'
$button.set_label('Start');             # drop 'gtk_button_'
$button.set-label('Start');
```

The reference documentation will show what possible method names you can use. Take method `.gtk_button_set_label()` for instance. The table of contents and the header of the method in the reference will be shown as _**[[gtk\_] button\_] set\_label**_, where all text between brackets can be left out. The underscores may be replaced by dashes.

New developments using real methods accessing the native subroutines without using `FALLBACK()` show, that access is much faster. So, it is decided that those are implemented alongside each native subroutine. This will not happen overnight. New modules however, are generated with those methods and do not have the search implementation described using the fallback routines. The names of the methods are the shortest possible and the documentation will show only that possibility.

When older modules are changed, the change will become visible in the documentation showing only one possibility. The old names are still accepted until they get deprecated. So `.gtk_button_set_label()`, with the documentation showing _**[[gtk\_] button\_] set\_label**_, will become simply _**set-label**_.

Having said all this, it is therefore best to use the shortest possible name with dashes in it instead of underscores to prevent being forced to comply to future changes in your code.
