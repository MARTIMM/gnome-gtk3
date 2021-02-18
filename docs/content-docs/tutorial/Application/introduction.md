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
* Using resources and settings
* Using communication channels like d-bus on Linux
* Programming actions as additions to signal processing

You can do this of course with the available libraries in the system but there are libraries from Gnome for these specific operations which makes it much easier to integrate this in your application. The library used for this is the Gio library where all types of IO is brought under. The Raku package where some of the modules are implemented in, is called `Gnome::Gio`.
