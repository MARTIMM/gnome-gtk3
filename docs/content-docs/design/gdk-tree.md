---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Class hierargy

Below there is a table of the object hierarchy and is used here to show what is implemented and what is deprecated in Gdk. Module path names are removed from the Raku modules when in Gnome::Gdk3. E.g. Screen is implemented as **Gnome::Gdk3::Screen**. `├─✗` in front of a Gdk module means that it is deprecated or will not be implemented for other reasons.

```
Tree of Gtk C structures                              Raku module
----------------------------------------------------- ------------------------
GObject                                               Gnome::GObject::Object
├──                                       
╰──

GInterface                                            Modules are defined as Roles
├──                                       
╰──

GBoxed                                                Gnome::GObject::Boxed
├── GdkRGBA                                           RGBA (not according to doc!) 
╰──
```
