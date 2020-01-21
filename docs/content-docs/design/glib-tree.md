---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Class hierargy

Below there is a table of the object hierarchy and is used here to show what is implemented and what is deprecated in Glib and GObject. Module path names are removed from the Raku modules. E.g. Value is implemented as **Gnome::GObject::Value** and Error as **Gnome::Glib::Error**. `├─✗` in front of a Glib/GObject module means that it is deprecated or will not be implemented for other reasons.

```
Tree of Gtk C structures                              Raku module
----------------------------------------------------- ------------------------
GObject                                               Object
├──                                       
╰──

GBoxed                                                Boxed
├── GValue                                            Value  
╰──
```
