---
title: Interfacing Perl6 to Gnome GTK+
#nav_title: Home
nav_menu: default-nav
layout: default
---

##### A warning: the documentation here as well as the different packages are far from complete.

# What's this all about
This package, together with a few others is an interface to the great Gnome libraries Gtk, Gdk, Cairo, Pango, GObject and Glib. There are already a few interfaces made by other fellow programmers such as **GTK::Simple**, **GTK::Simpler** and **GTK::Scintilla**. Why then, would you ask, build another one? There were several reasons to do this, to sum up a few;
* Learning to handle Perl6 native interface to C libraries and having example code with the packages mentioned above.
* I wanted to follow the Gnome documents as closely as possible. This meant that the subroutine names are kept the same as those in the libs. Later on, I introduced some modifications to shorten these names where possible.
* I wanted to have classes with methods instead of the subroutines.
* I wanted the event handling code in separate classes where the information about specific procedures can be stored.
* I wanted all possible event handlers available for the user, not just the most used ones.
* I didn't want to fix events in method calls like `click()`.
* Later, I decided that I also wanted a more complete set of methods interfaced to GTK+ et al. This happened after I had created a program to scim through the source code of the gtk libraries (.h and .c), because these files are very well documented, and generate a perl6 module from it.
* I wanted to follow the obsolete markings of Gnome. E.g. the GtkHBox and GtkVBox are not supported anymore in favor of GtkGrid.

## History
There is already a bit of history for these packages. It started off building the **GTK::Glade** package which soon became too big. So a part was separated into **GTK::V3**. After some time working with the library I felt that the class names were a bit too long and that the words `gtk` and `gdk` were repeated too many times in the class path. E.g. there was **GTK::V3::Gtk::GtkButton** and **GTK::V3::Gdk::GdkScreen** to name a few. So, finally it was split into several other packages named, **Gnome::N** for the native linkup on behalf of any other Gnome module, **Gnome::Glib**, **Gnome::GObject**, **Gnome::Gdk3** and **Gnome::Gtk3** according to what is shown [on the developers page here](https://developer.gnome.org/references). The classes in these packages are now renamed into e.g. **Gnome::Gtk3::Button**, **Gnome::Gdk3::Screen**, **Gnome::GObject::Object** and **Gnome::Glib::List**. As a side effect the package **GTK::Glade** is also renamed into **Gnome::Gtk3::Glade** to show that it is from Gnome and that it is based on Gtk version 3.

## What are the benefits
### Pros
  * The defaults of GTK+ are kept. Therefore, e.g, the buttons are in the proper size compared to what `GTK::Simple` produces. This has to do with presetting the size of the application window. The user might decide to set sizes themselves but the software should not impose this.
  * Separation of callbacks from other code by having the callbacks defined in classes. Closures are therefore not necessary to get data into the callback code. Callbacks can just read/write the data in the classes attributes. Also, data can be provided with named arguments to the `register-signal()` method defined in class `Gnome::GObject::Object`. Btw. this method is available to any class inheriting from `Gnome::GObject::Object` which almost every class does.
  * The package was designed with the usage of glade interface designer in mind. So to build the interface by hand like in the examples and tutorial, is not always necessary. Feeding a saved design from the glade program to modules in `Gnome::Gtk3::Glade` is preferable when building larger user interfaces. Also it was therefore not necessary to implement every method to build a gui which made the handwork somewhat lighter. Lately, this is shifting towards almost fully implementing every class because a generator was made to help me out. The generator creates a Perl6 module from the c-sources of some widget. The only thing left for me was to iron the generated module to get it working.
  * No fancy stuff like tapping into channels to run signal handlers.
  * There is a registration of callback methods to process signals like button clicks as well as events like keyboard input and mouse clicks. This is not available in `GTK::Simple`. The provided way to handle a signal there, is fixed into a method. E.g. the button has a 'clicked' method and the container has none while an observer might want to know if an object is inserted into a grid using the 'add' signal.
  * Not all signals are supported yet but will be installed in time. There is, for example, a I<parent-set> signal which is emitted when a new parent has been set on a widget.
  * It is possible to create threads where longer runs can be done without crippling the user interface responses and also show the results from there in the gui.

### Cons
  * The code is larger but I think it gives you greater flexibility.
  * Code is somewhat slower. The setup of the 'hello world' example shown in the tutorials and examples, is about 0.05 sec slower. That isn't much seen in the light that a user interface is mostly set up and drawn once.

## Packages
### Gnome::N
Used to hold any access specs to the libraries. Also there is some debugging possible and an exception class defined.

### Gnome::Glib
C-based object and type system with signals and slots

### Gnome::GObject
Data structures and utilities for C programs

### Gnome::Gdk3
Low-level abstraction for the windowing system

### Gnome::Gtk3
Widget toolkit for graphical interfaces

### Gnome::Gtk3::Glade
Package to make use of the graphical user interface designer program **Glade**.

# Dependencies on external software
The software in these packages do not (yet) install the GTK+ software, so there is a dependency on several libraries which must be installed before the perl6 software can be used.

# Site Contents
## Tutorial
A tutorial about using the modules in all its forms.

## Examples
A series of examples.

## Reference
References of all the modules in all packages. All information is gathered here so there is no need to go to the other packages for information.

## Design
Notes on how things are set up.

# Installation

Before any code can be run we must install the packages we want to use. It is assumed that **Perl6** (See [Perl6 Site](https://perl6.org/downloads/)) and the **GTK+** libraries (See [Gtk Site](https://www.gtk.org/)) are already installed. The program `zef` is used to install the modules. Enter the following command on the command line to install the modules needed for this tutorial and any other dependencies will be installed too.

```
> zef install Gnome::Gtk3::Glade
```

# Warning
The software as well as this website is far from finished as well as the documentation is not yet available for all modules in the packages.
