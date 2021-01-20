---
title: Tutorial - Intermezzo Methods
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# Intermezzo: Methods

## Method naming

You can think of the Raku classes in these packages as wrappers around native objects and subroutines. To let the subroutines behave as if they were methods, a trick using `FALLBACK()` is implemented to search for the subroutines.

The subroutine names are derived from their gnome classes. For instance, the gtk class GtkButton has subroutines like `gtk_button_set_relief()` and `gtk_button_set_label()`. The Raku equivalent of that class is **Gnome::Gtk3::Button** using the same name definitions for their functions. So one could say;

```
my Gnome::Gtk3::Button $button .= new;
$button.gtk_button_set_label('Start');
```

Using the FALLBACK trick, it is also possible to accept other names and find their corresponding subroutines. In the first place we could chop 'gtk_' from the name and use `.button_set_label()`. But if possible, when the name is long enough we could even chop 'gtk_button' to have `.set_label()` as a result. And another trick would substitute '-' characters for '\_' leaving `.set-label()` as result.

```
$button.gtk_button_set_label('Start');
$button.button_set_label('Start');
$button.set_label('Start');
$button.set-label('Start');
```

For the moment, names cannot be too short because at the top, the classes are inheriting from **Any** and **Mu**. When a method is defined there, it will take precedence over the FALLBACK because that is a real method. The use of it will of course return wrong results or even throw compiler errors. Later, such methods will be added to the classes so that the short form is usable too.

The reference documentation will show what possible method names you can use. Take method `.gtk_button_set_label()` for instance. The table of contents and the header of the method in the reference will be shown as _**[[gtk\_] button\_] set\_label**_. The underscores may be replaced by dashes.

New developments using real methods accessing the native subroutines without using `FALLBACK()` also show that those routines are faster. So it is decided that those are implemented alongside each native subroutine. This will not happen overnight. New modules however, are generated with those methods. The names of the methods are the shortest possible and the documentation will show only that possibility. The changes in older modules will be visible in the documentation where only one possibility is shown while the other names are still accepted until they get deprecated. So `.gtk_button_set_label()`, with the documentation showing _**[[gtk\_] button\_] set\_label**_, will become simply _**set-label**_.

Having said all this, I guess that the best name to use is the shortest possible one with dashes in it instead of underscores.
