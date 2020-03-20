---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Class hierargy

Below there is a table of the object hierarchy and is used here to show what is implemented and what is deprecated in GObject. Module path names are removed from the Raku modules when in Gnome::GObject. E.g. Value is implemented as **Gnome::GObject::Value**. `├─✗` in front of a GObject module means that it is deprecated or will not be implemented for other reasons.

```
Tree of Glib C structures           Raku module
----------------------------------- ------------------------
TopLevelClassSupport                Gnome::N::TopLevelClassSupport
│
GObject                             Object
├── InitiallyUnowned                           
╰──

GBoxed                              Boxed
├── GValue                          Value  
╰──


├── GEnums Enums
├── GParam Param
├── GSignal Signal
├── GType Type

```
