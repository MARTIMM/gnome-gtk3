---
title: Perl6 GTK+ Tutorial
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---

# Tutorial

This tutorial is about building your own **GUI** (Graphical User Interface) in **Perl6** based on the **Gnome** libraries **gtk3**, **gdk3** and **glib**.
This tutorial will first explain the modules in the package `Gnome::Gtk3` and then the modules from `Gnome::Gtk3::Glade`. As GTK+ builds upon other libraries such as Glib and Gdk, the `Gnome::Gtk3` also builds upon `Gnome::Gdk3` and `Gnome::Glib`. There are a few more libraries and are mentioned when needed. The first is about building your GUI on your own and the latter is about making use of the generated *XML* file from the GTK+ GUI designer program *Glade*. At the end of the tutorial some of the design ideas of Gnome::Gtk3 are explained followed by a reference of the modules.
