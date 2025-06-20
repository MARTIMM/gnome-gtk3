---
title: Perl6 GTK+ Tutorial
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# Tutorials

The tutorial section tries to explain how you can build your own **GUI** (Graphical User Interface) in **Raku** based on the **gnome** libraries such as **gtk**, **gdk** and **glib**. As the GTK+ library builds upon other libraries such as glib and gdk, the **Gnome::Gtk3** package depends on **Gnome::Gdk3** and **Gnome::Glib** among others.

Many techniques will pass and lead you along all kinds of details like creating and showing windows, adding widgets, using dialogs and sending signals to name a few.

At first, a large part of the tutorial will be about building your GUI by hand. There are some sections in between to tell you something about how the Raku modules are set up. Later sections will be about making use of *XML* files, possibly generated from the GTK+ GUI designer program *Glade*, how to make use of stylesheets, resources, applications, drag and drop, ….

Have fun!


# References

To get more detailed information of each module, there is also a reference section of the implemented modules on this web site;
{% assign url = site.baseurl | append: '/content-docs/reference-gtk3.html' %}
* Package reference for [Gnome::Gtk3]({{ url }})
{% assign url = site.baseurl | append: '/content-docs/reference-gdk3.html' %}
* Package reference for [Gnome::Gdk3]({{ url }})
{% assign url = site.baseurl | append: '/content-docs/reference-gobject.html' %}
* Package reference for [Gnome::GObject]({{ url }})
{% assign url = site.baseurl | append: '/content-docs/reference-glib.html' %}
* Package reference for [Gnome::Glib]({{ url }})
{% assign url = site.baseurl | append: '/content-docs/reference-gio.html' %}
* Package reference for [Gnome::Gio]({{ url }})
{% assign url = site.baseurl | append: '/content-docs/reference-cairo.html' %}
* Package reference for [Gnome::Cairo]({{ url }})
{% assign url = site.baseurl | append: '/content-docs/reference-native.html' %}
* Package reference for [Gnome::N]({{ url }})

<!--{% assign url = site.baseurl | append: '/content-docs/reference-pango.html' %}
* Package reference for [Gnome::Pango]({{ url }}) -->
<!--{% assign url = site.baseurl | append: '/content-docs/reference-t.html' %}
* Package reference for [Gnome::T]({{ url }}) -->



# Installing

Installing all packages is simple, just run the following command;
```
zef install Gnome::Gtk3:api<1>
```

Assuming that Raku and zef is installed properly


# Attribution

There is a small but not less important thing to say. The documentation found here are often taken from other sources and changed where there is some code, often in Python or C. Therefore I like to express my gratitude towards these writers;

* [Wikibooks](https://en.wikibooks.org/wiki/GTK%2B_By_Example) For explanations on Gtk+, Pango and Cairo.
* [Zetcode](http://zetcode.com/tutorials/gtktutorial/) for the several tutorials on Gtk+ and Cairo.
* Prof Stewart Weiss, [web address](http://www.compsci.hunter.cuny.edu/~sweiss/index.php). On his site are numerous documents under which many about GTK+. I have used parts from these to explain many aspects of the user interface system.
* Bert Timmerman for his Cairo transformation examples: https://gist.github.com/bert/1164354/c0391388afffc4b287c46ac79287f77e94c712e3
