---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

{% assign u1 = site.baseurl | append: "/content-docs/design/check-list.html" %}

## Class hierargy

Below there is a table of the object hierarchy taken from [Christoph Reiter](https://lazka.github.io/pgi-docs/Gtk-3.0/index.html) and is used here to show what is implemented and what is deprecated in Atk. Module path names are removed from the Raku modules when in Gnome::Atk. E.g. Window is implemented as **Gnome::Gtk3::Window**. `├✗` in front of a Gtk module means that it is deprecated or will not be implemented for other reasons. Modules that will change a lot, deprecated or that it can be removed altogether, are marked with ⛔. All modules under construction are not marked with an icon. For further progress info check [this page]({{u1}}).

```
Tree of Atk C structures              Raku module
------------------------------------- -----------------------------------------
TopLevelClassSupport                  Gnome::N::TopLevelClassSupport
│
GObject                               Gnome::GObject::Object
├─ AtkHyperlink
├✗ AtkMisc                            ⛔
├─ AtkObject
|  ├─ AtkGObjectAccessible
|  ├─ AtkNoOpObject
|  ├─ AtkPlug
|  ╰─ AtkSocket
├─ AtkObjectFactory
|  ╰─ AtkNoOpObjectFactory
├─ AtkRegistry
├─ AtkRelation
├─ AtkRelationSet
├─ AtkStateSet
╰─ AtkUtil
```
