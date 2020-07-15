---
title: Tutorial - Intermezzo Methods
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# Intermezzo: Methods

## Method naming

You can think of the Raku classes in these packages as wrappers around native objects and subroutines. To let the subroutines behave as if they were methods, a trick using `FALLBACK()` is implemented to search for the subroutines. More about this in another intermezzo.

The subroutine names are derived from their gnome classes. For instance, the gtk class GtkButton has subroutines like `gtk_button_set_relief()` and `gtk_button_set_label()`. The Raku equivalent of that class is **Gnome::Gtk3::Button** using the same name definitions for their functions. So one could say;

```
my Gnome::Gtk3::Button $button .= new;
$button.gtk_button_set_label('Start');
```

Using the FALLBACK trick, it is also possible to accept other names and find their corresponding subroutines. In the first place we could chop 'gtk_' from the name and use `.button_set_label()`. But if possible, when the name is long enough we could even chop 'gtk_button' to have `.set_label()` as a result. And another trick would substitute '-' characters for '\_' leaving `.set-label()` as result. All possibilities are at your disposal but use them consequently.

```
$button.gtk_button_set_label('Start');
$button.button_set_label('Start');
$button.set_label('Start');
$button.set-label('Start');
```

For the moment, names cannot be too short. For example there is a subroutine `gtk_grid_attach()`. This cannot be used as `.attach()` because at the top, the classes are inheriting from **Any** and **Mu**. When the attach method is defined there, it will take precedence over the FALLBACK because that is a real method. The use of it will of course return wrong results or even throw compiler errors. Later, such methods will be added to the classes so that the short form is usable too.

```
my Gnome::Gtk3::Grid $grid .= new;
$grid.gtk_grid_attach( $label, 0, 0, 1, 1);
$grid.grid_attach( $label, 0, 0, 1, 1);
```

A last word on how it is noted in the references. Take method `.gtk_button_set_label()` for instance. The table of contents and the header of the method in the reference will be shown as _[[gtk\_] button\_] set\_label_. For the method `.gtk_grid_attach()` this will be _[gtk\_] grid\_attach_. The underscores may be replaced by dashes. When a method like `.attach()` is defined, this notation will be changed into _[[gtk\_] grid\_] attach_.
