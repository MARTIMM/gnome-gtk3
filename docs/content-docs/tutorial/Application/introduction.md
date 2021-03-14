---
title: Tutorial - Application Introduction
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

You can do this of course with the available libraries in the system. But, luck is on your side. Gnome already made a library for these specific operations. This makes it much easier to integrate the operations in your application. The library used for this is the Gio library where all types of IO is brought under. The Raku package where some of the modules are implemented in, is called `Gnome::Gio`.

<!-- Some modules are implemented but not all. Not because of deprecations but a lot of IO to, for example, files and network is covered in Raku.
-->

What you can expect from this tutorial is that we will learn about a different approach to building an application. We will see;

<!--
* To make an application providing a service.
* Interacting with the desktop.
* Use dbus to send commands to the application.
-->

* A sceleton application. We will learn what we need basically, and what signals we need to get the application working. In subsequent parts we will extend this framework;
  * By using other application flags.
  * To handle command line arguments.

* We will not be talking about building a GUI using grid, labels, buttons and such. An exception is however the building and managing of menus. While you still can use the menu classes defined in `Gnome::Gtk3`, this knowledge will come in handy when you prepare yourself to work with `Gnome::Gtk4` (that package is not available yet, but it will be) because GTK version 4 will not have classes to build a menu. It only provides some buttons and pulldowns to show an available menu. Also the MenuBar is gone. The only place where you can find one is in the Application class.

* Using actions. Actions are other ways to trigger events. The actions are all usable on gtk widgets which inherit from **Gnome::Gtk3::Activatable**. Those widgets are mainly buttons and menu entries. The above introduced menus will be using actions to do their bidding.
