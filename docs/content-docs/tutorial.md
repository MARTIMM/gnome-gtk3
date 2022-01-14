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
zef install Gnome::Gtk3
```

Assuming that Raku and zef is installed properly


Have fun!
