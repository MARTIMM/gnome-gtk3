---
title: Tutorial - The Object class
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# The Gnome::GObject::Object

As the manual states;

_**Gnome::GObject::Object** is the fundamental type providing the common attributes and methods for all object types in GTK+, Pango and other libraries based on `N-GObject`. The `N-GObject` object provides methods for object construction and destruction, property access methods, and signal support._

In this document, we will see what it can do for you. A short list;
* Initialization
* Handling signals and events.
* Using threads to do computing in parallel.
* How variables are maintained by an object, called properties.
* How to store your own data into the native object by associating data to keys.

First a picture of how classes are connected.
![object uml](images/Object.svg)
We see that several classes inherit from Object directly or inderectly and therefore have access to the mechanisms provided by Object. Object also


## Initialization

Each widget must be initialized to have a native object representing the C object stored in the Raku object. Most Raku objects accept the `:native-object` named argument and many (widgets) know about the `:build-id` next to their own set of arguments if any.

### :native-object

This argument is not handled here really, it is handled at the top of the food chain, in **Gnome::N::TopLevelClassSupport**. It is handled there because the native object is defined in that class. Therefore, any class inheriting from that class knows about the argument.
The use of the argument is to import a native object from elsewhere into the Raku object. After that, the methods can be used to access that object.

### :build-id

This argument can be used when GUI descriptions in XML are created by hand or with the use of the designer program `glade`. The XML can be loaded with the use of class **Gnome::Gtk3:Builder**. When the Builder class is instantiated, the object is also stored in the Object class in such a way that any other Object object can access the Builder object. The entities described in the XML can have id's unique in that XML. This then makes it possible to retrieve an object from the Builder by using this `:build-id` argument.

## Signals and events

## Concurrent processes

## Properties

## Data


<!--

## Reference counting
### Floating references
### :native-object
### .get-native-object()
### .get-native-object-no-reffing()
### .clear-object()

-->
