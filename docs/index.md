---
title: Interfacing Perl6 to Gnome GTK+
#nav_title: Home
nav_menu: default-nav
layout: default
---

# What is this all about
## History

## Packages
### Gnome::N
### ...
### Gnome::Gtk3
### Gnome::Gtk3::Glade

# Install Perl6 Packages
## Gnome::GTK3
## Gnome::Gtk3::Glade

# Dependencies on external software

# Site Contents
## Tutorial
## Examples
## Reference
## Design

# Warning




## An Example

This example does the same as the example from `GTK::Simple` to show you the differences between the implementations. What immediately is clear is that this example is somewhat longer. To sum up;
### Pros
  * The defaults of GTK+ are kept. Therefore the buttons are in the proper size compared to what GTK::Simple produces.
  * Separation of callbacks from other code. Closures are not needed to get data into the callback code. Data can be provided with named arguments to the `register-signal()` method.
  * The package is designed with the usage of glade interface designer in mind. So to build the interface by hand like below, is not necessary. Use of `Gnome::Gtk3::Glade` is preferable when building larger user interfaces.
  * No fancy stuff like tapping into channels to run signal handlers.
  * There is a registration of callback methods to process signals like button clicks as well as events like keyboard input and mouse clicks.. This is not available in `GTK::Simple`. The provided way to handle a signal there, is fixed into a method. E.g. the button has a 'clicked' method and the container has none while an observer might want to know if an object is inserted into a grid using the 'add' signal.
  * The same method, `register-signal()`, is also used to register other types of signals. There are, for example, events to handle keyboard input and mouse clicks. Not all signal handler types are supported yet but can be installed in time.

### Cons
  * The code is larger.
  * Code is somewhat slower. The setup of the example shown next is about 0.05 sec slower. That isn't much seen in the light that a user interface is mostly set up and drawn once.

A screenshot of the example

![-this screenshot-](content-docs/examples/images/01-hello-world.png)

The code can be found at `examples/01-hello-world.pl6`.
```
{% include example-code/01-hello-world.pl6 %}
```





[screenshot 1]: images/01-hello-world.png

[screenshot 2]: https://martimm.github.io/perl6-gnome-gtk3/images/examples/16a-level-bar.png
[screenshot 3]: https://martimm.github.io/perl6-gnome-gtk3/images/examples/16b-level-bar.png
[screenshot 4]: https://martimm.github.io/perl6-gnome-gtk3/images/examples/ex-GtkScale.png
