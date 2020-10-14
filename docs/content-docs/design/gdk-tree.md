---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Class hierargy

Below there is a table of the object hierarchy taken from [Christoph Reiter](https://lazka.github.io/pgi-docs/Gtk-3.0/index.html) and is used here to show what is implemented and what is deprecated in Gdk. Module path names are removed from the Raku modules when in Gnome::Gdk3. E.g. Screen is implemented as **Gnome::Gdk3::Screen**. `├─✗` in front of a Gdk module means that it is deprecated or will not be implemented for other reasons. Modules made inheritable are noted with ♥. Inheritance is a bit more complex than normal, info will be given in due time. Modules in under construction are marked with ⛏. Modules that will change a lot and even that it can be removed are marked with ⛔. The symbol 🗸 means that the module is tested, unneeded subs are removed, documentation done etc. (that will show up almost nowhere :- ).


```
Tree of Gdk3 C structures             Raku module
------------------------------------- -----------------------------------------
TopLevelClassSupport                  Gnome::N::TopLevelClassSupport
│
GObject                               Gnome::GObject::Object
├─ GdkColormap
├─ GdkDevice                          Device
├─ GdkDisplay                         Display
├─ GdkDisplayManager
├─ GdkDragContext
├─ GdkDrawable
|  ├─ GdkPixmap
|  ╰─ GdkWindow                       Window
├─ GdkGC
├─ GdkImage
├─ GdkKeymap
├─ GdkPixbuf                          Pixbuf
├─ GdkPixbufAnimation
├─ GdkPixbufAnimationIter
├─ GdkPixbufLoader
├─ GdkScreen                          Screen
╰─ GdkVisual

TopLevelClassSupport                  Gnome::N::TopLevelClassSupport
│
GBoxed                                Gnome::GObject::Boxed
├── GdkRGBA                           RGBA (not according to doc!)
╰──
```
