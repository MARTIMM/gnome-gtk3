---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Class hierargy

Below there is a table of the object hierarchy and is used here to show what is implemented and what is deprecated in GObject. Module path names are removed from the Raku modules when in Gnome::GObject. E.g. Value is implemented as **Gnome::GObject::Value**. `├─✗` in front of a GObject module means that it is deprecated or will not be implemented for other reasons. Modules made inheritable are noted with ♥. Inheritance is a bit more complex than normal, info will be given in due time. Modules in under construction are marked with ⛏. Modules that will change a lot and even that it can be removed are marked with ⛔. The symbol 🗸 means that the module is tested, unneeded subs are removed, documentation done etc. (that will show up almost nowhere :- ).

```
Tree of Glib C structures           Raku module
----------------------------------- ------------------------
TopLevelClassSupport                   Gnome::N::TopLevelClassSupport
│
GObject                             ⛏ Object
├── InitiallyUnowned                           
╰──

TopLevelClassSupport                   Gnome::N::TopLevelClassSupport
│
GBoxed                                 Boxed
├── GValue                             Value  
╰──

TopLevelClassSupport                   Gnome::N::TopLevelClassSupport
│
├── GEnums Enums
├── GParam Param
├── GSignal Signal
├── GType Type
╰──

```
