---
title: Interfacing Raku to Gnome GTK+
#nav_title: Home
nav_menu: default-nav
layout: default
---

##### A warning: Although you can do marvelous things with the packages already, the documentation here as well as the different packages are far from complete!

# What's this all about
  There are already a few interfaces made by other fellow programmers such as **GTK::Simple**, **GTK::Simpler** and **GTK::Scintilla**. Why then, would you ask, build another one? There were several reasons to do this, to sum up a few;
* Learning to handle Raku native interface to C libraries and having example code with the packages mentioned above.
* I wanted to follow the Gnome documents as closely as possible. This meant that the subroutine names are kept the same as those in the libs. Later on, I introduced some modifications to shorten these names where possible. See also the [design notes](content-docs/design/notes.html)
* I wanted to have classes with methods instead of the subroutines.
* I wanted the event handling code in separate classes where the information about specific procedures can be stored.
* I wanted all possible event handlers available for the user, not just the most used ones.
* I didn't want to fix signals/events in method calls like `click()`.
* Later, I decided that I also wanted a more complete set of methods interfaced to GTK+ et al. This happened after I had created a program to skim through the source code of the gtk libraries (.h and .c), because these files are very well documented, and generate a Raku module from it.
* I wanted to follow the obsolete markings of Gnome. E.g. the GtkHBox and GtkVBox are not supported anymore in favor of GtkGrid (in Raku module **Gnome::Gtk3::Grid**).

## History
There is already a bit of history for these packages. It started off building the **GTK::Glade** package which soon became too big. So a part was separated into **GTK::V3**. After some time working with the library I felt that the class names were a bit too long and that the words `gtk` and `gdk` were repeated too many times in the class path. E.g. there was **GTK::V3::Gtk::GtkButton** and **GTK::V3::Gdk::GdkScreen** to name a few. So, finally it was split into several other packages named, **Gnome::N** for the native linkup on behalf of any other Gnome module, **Gnome::Glib**, **Gnome::GObject**, **Gnome::Gdk3**, **Gnome::Gtk3** and some others, according to what is shown [on the developers page here](https://developer.gnome.org/references). The classes in these packages are now renamed into e.g. **Gnome::Gtk3::Button**, **Gnome::Gdk3::Screen**, **Gnome::GObject::Object** and **Gnome::Glib::List**. As a side effect the package **GTK::Glade** is also renamed into **Gnome::Gtk3::Glade** to show that it is from Gnome and that it is based on Gtk version 3.

A later step might be merging some tools from **Gnome::Gtk3::Glade** back to **Gnome::Gtk3** or make other modules. Here, I think for example about the testing of interfaces in **Gnome::T** (I've taken short names like **Gnome::N** to not interfere with eventually new names from Gnome).

## What are the benefits

When the packages mature, the next points are/become available;

### Pros
  * The defaults of GTK+ are kept. Therefore, e.g, the buttons are in the proper size. The user may decide to set sizes of windows and windgets but the libraries should not impose this.
  * Separation of callbacks from other code by having the callbacks defined in classes. Callbacks can then just read/write the data in the classes attributes. Also, data can be provided with named arguments to the `register-signal()` method defined in class **Gnome::GObject::Object**. This method is available to any class inheriting from **Gnome::GObject::Object** which almost every class does.
  * Building the interface by hand like in the examples and tutorial, is not always necessary. Feeding a saved design from the glade designer program to methods in module **Gnome::Gtk3::Builder** is preferable when building larger user interfaces.
  * No fancy stuff like tapping into channels to run signal handlers.
  * It is possible to create threads where longer runs can be done without crippling the user interface responses and also show the results from there in the gui.
  * It is possible to make use of actions besides signal processing.
  * It is possible to make use of resource files. This is a different approach than what Raku can do for you. It can be combined however.
  * It is possible to make use of D-Bus. This is one of the things that makes an application able to interact with the system and other processes as well as the desktop manager.
  * Drag and drop will help you to drag documents from a filebrowser into your application as well as moving widgets from one place to another in your GUI.
  * Drawing is available with Cairo.
  * Text manipulations are supported using Pango.

### Cons
  * The code base is much larger but I think it gives you greater flexibility.
  * Code is somewhat slower. That is not a big problem when a user interface is mostly set up and drawn once. Compiling the software takes much time when installing the packages.
  * When programs run the first time, it might take some time to compile.

## Packages
This package, together with a few others is an interface to the great Gnome libraries Gtk, Gdk, Pango, GObject, Gio and Glib. Cairo is an independed project but Gnome makes significant use of that package. Not all libraries are available yet like Pango and not all modules are defined in any of those packages.

|Package|Travis-CI & Appveyor tests and Notes|
|--|--|
**Gnome::Gtk3** | ![T][travis-gtk3] ![A][appveyor-gtk3] <br/> Version 3 widget toolkit for graphical interfaces.
**Gnome::Gdk3** | ![T][travis-gdk3] ![A][appveyor-gdk3] <br/> Version 3 low-level abstraction for the windowing system.
**Gnome::Gio** | ![T][travis-gio] ![A][appveyor-gio] <br/> File and URI handling. Support of resources for applications and D-Bus communication.
**Gnome::Cairo** | ![T][travis-cairo] ![A][appveyor-cairo] <br/> 2D, vector-based drawing for high-quality graphics.
**Gnome::Pango** | ![T][travis-pango] ![A][appveyor-pango] <br/> International text rendering with full Unicode support. Not yet available to the public.
**Gnome::GObject** | ![T][travis-gobject] ![A][appveyor-gobject] <br/> Data structures and utilities for C programs.
**Gnome::Glib** | ![T][travis-glib] ![A][appveyor-glib] <br/> C-based object and type system with signals and slots.
|
**Gnome::T** |![T][travis-T] ![A][appveyor-T] <br/> GUI test package. Not yet available to the public.
**Gnome::N** |![T][travis-N] ![A][appveyor-N] <br/> Used to hold any access specs to the libraries. Also there is some debugging possible and an exception class defined.
|
**Gnome::Gtk4** | ![T][travis-gtk4] ![A][appveyor-gtk4] <br/> Version 4 widget toolkit for graphical interfaces. Yes, of course I will … but not yet. So, not yet available to the public.
**Gnome::Gdk4** | ![T][travis-gdk4] ![A][appveyor-gdk4] <br/> Version 4 low-level abstraction for the windowing system. Must be combined with **Gnome::Gtk4**. Also not yet available to the public.


# Site Contents
* [Tutorials](content-docs/tutorial.html): Tutorials about using the modules in all its forms.

* [Examples](content-docs/examples.html): A series of examples.

* [Reference](content-docs/reference-gtk3.html): References of all the modules in all packages. All information is contained here so there is no need to go to the other packages for information.

* [Design](content-docs/design.html): Notes on how things are set up.

* [Todo](content-docs/todo.html): There's still a lot to do.

# Installation

## Dependencies on external software

The software in these packages do not (yet) install the GTK+ libraries and tools (gtk, glib, cairo, pango, glade, etc), so there is a dependency on several libraries which must be installed before the Raku software can be used.

Before any code can be run we must install the packages we want to use. It is assumed that **Raku** (See [Raku Site](https://raku.org/downloads/)) and the **GTK+** libraries (See [Gtk Site](https://www.gtk.org/)) are already installed. The program `zef` is used to install the modules. Enter the following command on the command line to install the modules needed for this tutorial and any other dependencies will be installed too. Run `zef install Gnome::Gtk3` to work with GTK+ or `zef install Gnome::Gtk3::Glade` to add some tools.

## Versions

#### GTK+ Documentation derived from
<!-- * Atk; **2.26.1** -->
<!-- * Cairo; **1.16.0** -->
* Gdk Pixbuf; **2.38.2**
* Glib, Gio and Gobject; **2.60.7**
* Gtk and Gdk; **3.24.13**
<!-- * Pango; **1.42.4** -->
<!-- * Pixman; **0.38.4** -->

#### Raku
* Tested against (noted since 2020 01 using `$*PERL.compiler.version;`)
  * **v2019.07.1.439.\***
  * **v2019.11.328.\***
  * **v2019.11.503.\***
  * **v2020.12-32.\***

## Raku

**NOTE**: It is really important to install the latest version of Raku because some of the encountered bugs went away after upgrading. Also some tricks like variable argument lists to native functions were only possible after summer 2019.

  Here are some steps to follow if you want to be at the top of things. You need `git` to get the Rakudo software from the github site. However, the people who distribute the compiler, put much effort to keep the distribution packages up to date nowadays for *nixes and windows. So the next steps become less important.

  Anyways …
  1) Make a directory to work in, e.g. Raku
  2) Go in that directory and run `git clone https://github.com/rakudo/rakudo.git`
  3) Then go into the created rakudo directory
  4) Run `perl Configure.pl --gen-moar --gen-nqp --backends=moar`
  5) Run `make test`
  6) And run `make install`

  Subsequent updates of the Raku compiler and moarvm can be installed with
  1) Go into the rakudo directory
  2) Run `git pull`
  then repeat steps 4 to 6 from above

  Your path must then be set to the program directories where `$Rakudo` is your `rakudo` directory; `${PATH}:$Rakudo/install/bin:$Rakudo/install/share/perl6/site/bin`

  You can read the README for more details [on the same site](https://github.com/rakudo/rakudo).

  After this, you will notice that the `raku` command is available next to `perl6` so it is also a move forward in the renaming of Perl6 to Raku.

  The rakudo star installation must be removed if it was used, because otherwise there will be two Raku compilers wanting to be the captain on your ship. Also all modules must be reinstalled of course and will be installed at `$Rakudo/install/share/perl6/site`.


<!-- ----------------------------------------------------------------------- -->
[travis-gtk3]: https://travis-ci.org/MARTIMM/gnome-gtk3.svg?branch=master
[travis-gdk3]: https://travis-ci.org/MARTIMM/gnome-gdk3.svg?branch=master
[travis-gio]: https://travis-ci.org/MARTIMM/gnome-gio.svg?branch=master
[travis-gobject]: https://travis-ci.org/MARTIMM/gnome-gobject.svg?branch=master
[travis-glib]: https://travis-ci.org/MARTIMM/gnome-glib.svg?branch=master
[travis-cairo]: https://travis-ci.org/MARTIMM/gnome-cairo.svg?branch=master
[travis-pango]: https://travis-ci.org/MARTIMM/gnome-pango.svg?branch=master
[travis-N]: https://travis-ci.org/MARTIMM/gnome-native.svg?branch=master
[travis-T]: https://travis-ci.org/MARTIMM/gnome-test.svg?branch=master
[travis-gtk4]: https://travis-ci.org/MARTIMM/gnome-gtk4.svg?branch=master
[travis-gdk4]: https://travis-ci.org/MARTIMM/gnome-gdk4.svg?branch=master

[appveyor-gtk3]: https://ci.appveyor.com/api/projects/status/github/MARTIMM/gnome-gtk3?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true
[appveyor-gdk3]: https://ci.appveyor.com/api/projects/status/github/MARTIMM/gnome-gdk3?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true
[appveyor-gio]: https://ci.appveyor.com/api/projects/status/github/MARTIMM/gnome-gio?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true
[appveyor-gobject]: https://ci.appveyor.com/api/projects/status/github/MARTIMM/gnome-gobject?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true
[appveyor-glib]: https://ci.appveyor.com/api/projects/status/github/MARTIMM/gnome-glib?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true
[appveyor-cairo]: https://ci.appveyor.com/api/projects/status/github/MARTIMM/gnome-cairo?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true
[appveyor-pango]: https://ci.appveyor.com/api/projects/status/github/MARTIMM/gnome-pango?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true
[appveyor-N]: https://ci.appveyor.com/api/projects/status/github/MARTIMM/gnome-native?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true
[appveyor-T]: https://ci.appveyor.com/api/projects/status/github/MARTIMM/gnome-test?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true
[appveyor-gtk4]: https://ci.appveyor.com/api/projects/status/github/MARTIMM/gnome-gtk4?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true
[appveyor-gdk4]: https://ci.appveyor.com/api/projects/status/github/MARTIMM/gnome-gdk4?branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending&svg=true
