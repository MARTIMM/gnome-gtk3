---
title: Tutorial - Getting Started
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# Introduction

In all the examples shown sofar we were building the GUI starting from a **Gnome::Gtk3::Window** and then placing widgets in this window and so on. You can build a reasonable application this way and for many purposes it is quite enough.

However, for a modern program it lacks some features of which the following stand out;
* Interprocess communication between a second instance of the same running program
* Interaction with the desktop manager

You can do this of course with the available libraries in the system. But, luck is your side. Gnome has already made a library for these specific operations. This makes it much easier to integrate the operations in your application. The library used for this is the Gio library where all types of IO is brought under. The Raku package where some of the modules are implemented in, is called `Gnome::Gio`. Some modules are implemented but not all. Not because of deprecations but a lot of IO to files and network is covered in Raku.

What you can expect from this tutorial is that we will learn about a different approach to building an application. We will see;
* A sceleton application. We will learn what we need basically, and what signals we need to register to get it working.
* A new way to manage menus. You can still use the menu classes defined in `Gnome::Gtk3`. This knowledge will come in handy when you prepare yourself to work with `Gnome::Gtk4` (not available yet, gtk version 4 is still experimental I believe!). Version 4 will not have classes to build a menu, only some buttons and pulldowns to show an available menu.
* Using actions is another way to trigger events. The actions are all usable on gtk widgets which inherit from **Gnome::Gtk3::Activatable**. Those widgets are mainly buttons and menu entries. The above introduced menus will be using actions to do their bidding.
