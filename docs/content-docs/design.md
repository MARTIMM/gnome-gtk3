---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

# Design of the Raku modules

## Introduction

Despite some thinking about the setup, a lot of changes already happened. See the history on the Home page. In time, the following notes crystallized in the 'making of' the set of Raku packages. First what became clear is that there was a need to separate the modules in several packages like Gtk has done. There is glib, gobject, gdk, gtk, etc. It was important for me to keep the same separation among the Raku packages.

All these libraries come from **Gnome** and the Gtk version to adhere to was 3. So the Raku packages became **Gnome::Glib**, **Gnome::GObject**, **Gnome::Gdk3** and **Gnome::Gtk3**. Note that gdk is also following the same version as gtk.

Now it is possible to extend the lot with new packages. For example for Cairo **Gnome::Cairo**, and for Pango **Gnome::Pango**.

A package is added to make the native libraries and native types available to the other packages. This package is called **Gnome::N**. There is also a bit of debugging added to that package. Testing graphical interfaces might come available in **Gnome::T**.


## Errors and crashes
Some errors are mentioned by GTK+ on the command line. These are important messages which can lead up to other problems, even crashes.

When exceptions are thrown, a neat stackdump will be provided. There is only one occasion where it might lead to problems and only an error message **MoarVM panic: Internal error: Unwound entire stack and missed handler** is shown. I found that these occasions are always happening within callback handlers where Raku code is run from C. A `CATCH {}` block is added to make a stackdump happen just before the user handler is called. The user who whishes to use `.g_signal_connect_object()` directly instead of using `.register-signal()` must provide a handler wherein a CATCH block is added.

To summarize a few of the measures implemented to prevent problems, the following is applied;
* The failure to initialize GTK on time (in most cases) is solved by using an initialization flag which is checked in module **Gnome::GObject::Object** which almost all modules inherit from. This way, the user never has to initialize GTK.
* CATCH blocks are inserted in code when there are calls from C to the users callback handlers.
* To see the original exception and messages leading up to the crash a debug flag in the class **Gnome::N** can be set to show these messages which might help solving your problems. To use it write;
  ```
  use Gnome::N::X:api<1>;
  ...
  Gnome::N::debug(:on);
  ... lines leading up to crash ...
  Gnome::N::debug(:!on);
  ```
  or you can use `Gnome::N::debug(:off);` to turn it off.
