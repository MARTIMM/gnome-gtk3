---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Class hierargy

Below there is a table of the object hierarchy and is used here to show what is implemented and what is deprecated in Glib. Module path names are removed from the Raku modules when in Gnome::Glib. E.g. Error is implemented as **Gnome::Glib::Error**. `├─✗` in front of a Glib module means that it is deprecated or will not be implemented for other reasons. Modules made inheritable are noted with ♥. Modules in under construction are marked with ⛏. Modules that will change a lot and even that it can be removed are marked with ⛔. The symbol 🗸 means that the module is tested, unneeded subs are removed, documentation done etc. (that will show up almost nowhere :- ).

```
Tree of Glib C structures           Raku module
----------------------------------- ------------------------
TopLevelClassSupport                   Gnome::N::TopLevelClassSupport
│
├─ GError                              Error
├─ GList                               List
├─ GMain                               Main
├─ GOptionContext                   ⛏ OptionContext
├─ GQuark                              Quark
├─ GSlist                              Slist
├─ GVariant                         ⛔ Variant
├─ GVariantType                     ⛔ VariantType
├─ GVariantBuilder                  ⛔ VariantBuilder
╰──
```
