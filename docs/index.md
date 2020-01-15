---
title: Interfacing Raku to Gnome GTK+
#nav_title: Home
nav_menu: default-nav
layout: default
---

##### A warning: the documentation here as well as the different packages are far from complete.

# What's this all about
This package, together with a few others is an interface to the great Gnome libraries Gtk, Gdk, Pango, Cairo, GObject and Glib.
```
  GTK+ — Widget toolkit for graphical interfaces
  GDK — Low-level abstraction for the windowing system
  GLib — Data structures and utilities for C programs
  GObject — C-based object and type system with signals and slots
  Cairo — 2D, vector-based drawing for high-quality graphics
  Pango — International text rendering with full Unicode support
```


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
There is already a bit of history for these packages. It started off building the **GTK::Glade** package which soon became too big. So a part was separated into **GTK::V3**. After some time working with the library I felt that the class names were a bit too long and that the words `gtk` and `gdk` were repeated too many times in the class path. E.g. there was **GTK::V3::Gtk::GtkButton** and **GTK::V3::Gdk::GdkScreen** to name a few. So, finally it was split into several other packages named, **Gnome::N** for the native linkup on behalf of any other Gnome module, **Gnome::Glib**, **Gnome::GObject**, **Gnome::Gdk3** and **Gnome::Gtk3** according to what is shown [on the developers page here](https://developer.gnome.org/references). The classes in these packages are now renamed into e.g. **Gnome::Gtk3::Button**, **Gnome::Gdk3::Screen**, **Gnome::GObject::Object** and **Gnome::Glib::List**. As a side effect the package **GTK::Glade** is also renamed into **Gnome::Gtk3::Glade** to show that it is from Gnome and that it is based on Gtk version 3.

A later step might be merging some tools from **Gnome::Gtk3::Glade** back to **Gnome::Gtk3** or make other modules. Here, I think for example about the testing of interfaces in **Gnome::T** (I've taken short names like **Gnome::N** to not interfere with eventually new names from Gnome).

## What are the benefits
### Pros
  * The defaults of GTK+ are kept. Therefore, e.g, the buttons are in the proper size compared to what `GTK::Simple` produces. This has to do with presetting the size of the application window. The user might decide to set sizes themselves but the software should not impose this.
  * Separation of callbacks from other code by having the callbacks defined in classes. Closures are therefore not necessary to get data into the callback code. Callbacks can just read/write the data in the classes attributes. Also, data can be provided with named arguments to the `register-signal()` method defined in class **Gnome::GObject::Object**. Btw. this method is available to any class inheriting from **Gnome::GObject::Object** which almost every class does.
  * The package was designed with the usage of glade interface designer in mind. So to build the interface by hand like in the examples and tutorial, is not always necessary. Feeding a saved design from the glade program to modules in **Gnome::Gtk3::Glade** is preferable when building larger user interfaces. Also it was therefore not necessary to implement every method to build a gui which made the handwork somewhat lighter. Lately, this is shifting towards almost fully implementing every class because a generator was made to help me out. The generator creates a Raku module from the c-sources of some widget. The only thing left for me was to iron the generated module to get it working.
  * No fancy stuff like tapping into channels to run signal handlers.
  * There is a registration of callback methods to process signals like button clicks as well as events like keyboard input and mouse clicks. This is not available in `GTK::Simple`. The provided way to handle a signal there, is fixed into a method. E.g. the button has a 'clicked' method and the container has none while an observer might want to know if an object is inserted into a grid using the 'add' signal.
  * In principle, all kinds of signals or events are possible to handle now but some signals will provide native objects to the handler which are not yet possible to wrap into a Raku object because it is not implemented yet.
  * It is possible to create threads where longer runs can be done without crippling the user interface responses and also show the results from there in the gui.

### Cons
  * The code base is much larger but I think it gives you greater flexibility. It is even possible that there is too much. This will show later on when applications are made and show that the modules can be slimmed down. E.g. the **Gnome::Gtk3::Widget** module is about 7600 lines (with pod doc).
  * Code is somewhat slower. The setup of the 'hello world' example shown in the tutorials and examples, is about 0.05 sec slower. That isn't much seen in the light that a user interface is mostly set up and drawn once.
  * When programs run the first time, it might take some time to compile.
  * Installation of the packages takes a long time.

## Packages
* **Gnome::N**: Used to hold any access specs to the libraries. Also there is some debugging possible and an exception class defined.

* **Gnome::Glib**: C-based object and type system with signals and slots

* **Gnome::GObject**: Data structures and utilities for C programs

* **Gnome::Gdk3**: Low-level abstraction for the windowing system

* **Gnome::Gtk3**: Widget toolkit for graphical interfaces

* **Gnome::Gtk3::Glade**: Package to make use of the graphical user interface designer program **Glade**.

# Site Contents
* [Tutorials](content-docs/tutorial.html): Tutorials about using the modules in all its forms.

* [Examples](content-docs/examples.html): A series of examples.

* [Reference](content-docs/reference-gtk3.html): References of all the modules in all packages. All information is gathered here so there is no need to go to the other packages for information.

* [Design](content-docs/design.html): Notes on how things are set up.

# Installation

## Dependencies on external software

The software in these packages do not (yet) install the GTK+ libraries and tools (gtk, glib, cairo, pango, glade, etc), so there is a dependency on several libraries which must be installed before the Raku software can be used.

Before any code can be run we must install the packages we want to use. It is assumed that **Raku** (See [Raku Site](https://raku.org/downloads/)) and the **GTK+** libraries (See [Gtk Site](https://www.gtk.org/)) are already installed. The program `zef` is used to install the modules. Enter the following command on the command line to install the modules needed for this tutorial and any other dependencies will be installed too. Run `zef install Gnome::Gtk3` to work with GTK+ or `zef install Gnome::Gtk3::Glade` to add some tools.

## Versions

#### GTK+ Documentation derived from
<!-- * Atk; **2.26.1** -->
<!-- * Cairo; **1.16.0** -->
* Gdk Pixbuf; **2.38.2**
* Glib and Gobject; **2.60.7**
* Gtk and Gdk; **3.24.13**
<!-- * Pango; **1.42.4** -->
<!-- * Pixman; **0.38.4** -->

#### Raku
* Tested against (noted since 2020 01 using `$*PERL.compiler.version;`)
  * **v2019.07.1.439.\***
  * **v2019.11.328.\***
  * **v2019.11.503.\***
* Minimal version; **v2019.07.1.439\***

## Raku

**NOTE**: It is really important to install the latest version of Raku because some of the encountered bugs went away after upgrading. Also some tricks like variable argument lists to native functions were only possible after summer this year(2019). This means that Rakudo Star is not usable because the newest release is from March 2019.

  Here are some steps to follow if you want to be at the top of things. You need `git` to get the Rakudo software from the github site.
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

# Licenses and Attribution

## Licenses
* GTK is entirely open-source under the [LGPL license](content-docs/license-lgpl.txt).
* The Raku module libraries are available under the [Artistic license version 2.0](content-docs/license-art.txt).
* Documentation on this site is under the [GNU free documentation license version 1.3](content-docs/license-doc.txt).

## Attribution
* First of all, I would like to thank the developers of the `GTK::Simple` project because of the information I got while reading the code. Also because one of the files is copied unaltered for which I did not had to think about to get that right. The examples in that project are also useful to compare code with each other and to see what is or is not possible.
* The inventors of Perl6 of course and the writers of the documentation which help me out every time again and again. Also the people replying to questions on several mailing-lists were a great help.
* The builders of the GTK+ library and the documentation have helped me a lot too to see how things work, (although not all is yet clear). Their source code is also very helpful in the way that I could write a program to generate Perl6 source code from it. After that, only some fiddling a bit to get the modules to load, and a bit more to adjust some of the subroutines. Also, many images used in their documentation is reused here in the reference guides.

## Author
Name: **Marcel Timmerman**

Github account name: **MARTIMM**

# Warning
The software, as well as this website, is far from finished. The documentation in the references might need some ironing too.
