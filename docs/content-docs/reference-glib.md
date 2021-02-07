---
title: References to the Glib package modules
nav_menu: references-nav
sidebar_menu: references-glib-sidebar
layout: sidebar
---
# Gnome::Glib Reference

There are a few classes defined which are in an experimental state, that is, it is a bit uncertain if they are useful to the Raku user.

The Variant set of modules are now getting a bit more clear where to use it for. Variants are used to define a kind of data structure which are used by the Action set of modules from GIO. In turn they get used by the Application and Window classes defined in GIO and GTK.

As I see it now, they are provided to the GIO Action routines to transport the data to signal handlers when an action needs to take place. So this means that those Variant modules are not needed because the registry of signals have a way to get all sorts of data to the handler using closures. So the data does not have to travel through the C-lbraries.

At least Error, List, Quark and SList are usable.
