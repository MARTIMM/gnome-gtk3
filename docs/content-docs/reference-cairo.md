---
title: References to the Cairo package modules
nav_menu: references-nav
sidebar_menu: references-cairo-sidebar
layout: sidebar
---
# Gnome::Cairo Reference

The Cairo modules are created because of the need to get to the native objects whithin the rest of the Gnome packages. I would otherwise have used the package written by Timo. When you only have to draw an image and save it to disk, the modules of Timo might be a better solution. If you want to have drawings in your widgets, the **Gnome::Cairo** package is better.

The modules are all generated from the C source code and the documentation refers specifically to operations in C. Most of it is converted on the fly into Raku types or Raku native types. Sometimes, however, there is a mention of an operation like for instance, referencing or un-referencing objects. Those parts must be investigated still to see what the impact exactly is in Raku.

## Color coding of the entries in the sidebar
* <strong style="color:#e58080;">Toplevel classes</strong> are classes who inherit directly from **Gnome::N::TopLevelClassSupport**. Examples of such classes are **Gnome::Cairo** and **Gnome::Cairo::Surface**.
* <strong style="color:#a04500;">Object classes</strong> are classes which inherit indirectly from **Gnome::GObject::TopLevelClassSupport**. An example is **Gnome::Cairo::ImageSurface** inheriting from **Gnome::Cairo::Surface**.
* <strong style="color:#80bf00;">Standalone classes</strong> are classes which do not inherit from other classes. Most of the time they even do not have a native object to work with. An example is **Gnome::Glib::Quark**.

<!--
## Deprecated classes in Cairo

The following modules will not be implemented in this Raku package because they are deprecated in the Cairo libraries. There is no reason to have people use old stuff which is going to disappear.

*
-->
