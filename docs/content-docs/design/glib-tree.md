---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Class hierargy

Below there is a table of the object hierarchy and is used here to show what is implemented and what is deprecated in Glib. Module path names are removed from the Raku modules when in Gnome::Glib. E.g. Error is implemented as **Gnome::Glib::Error**. `├─✗` in front of a Glib module means that it is deprecated or will not be implemented for other reasons.

```
Tree of Glib C structures           Raku module
----------------------------------- ------------------------
TopLevelClassSupport                   Gnome::N::TopLevelClassSupport
│
├─ GError                              Error
├─ GList                               List
├─ GSlist                              Slist
╰──

Stand alone classes
-----------------------------------
── GMain                               Main
── GQuark                              Quark

```
<!--
├─ GOptionContext                   ⛔ OptionContext
├─ GVariant                         ⛔ Variant
├─ GVariantBuilder                  ⛔ VariantBuilder
├─ GVariantIter                     ⛔ VariantIter
├─ GVariantType                     ⛔ VariantType
-->
