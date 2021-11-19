---
title: Tutorial - Raku Modules
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# Raku Modules

## Class structure

You can think of the Raku classes in these packages as wrappers around native objects and subroutines. The Raku modules follow the same inheritance tree as the GTK+ 'classes' are made. This is not entirely true because C, where GTK+ is written in, does not have the object oriented mechanism as Raku has. Instead their 'classes' are eleborate structures with many functions around it which mimic class behavior.

The top classes in GTK+ are **GObject**, **GBoxed** and **GInterface**. In Raku the first two classes are named **Gnome::GObject::Object** and **Gnome::GObject::Boxed** but interfaces are defined differently in Raku as roles.

The Object and Boxed classes (I will make names somewhat shorter after introduction) in Raku are inheriting from another class, **Gnome::N::TopLevelClassSupport** to store the native object. The classes inheriting from **Object**, directly or indirectly, the native object type will always be `N-GObject`. Classes inheriting from **Boxed**, the native object types may differ. Examples are `N-GError`, `N-GList` or `N-GSList`.

The **TopLevelClassSupport** also provides common methods such as `.clean-object()` and `.is-valid()`. Also the named argument to `.new()`, `:native-object` is processed in this class.


## Interfaces

Interfaces mentioned above are implemented as roles. When such an interface is added to some class, the methods defined there are available to the class and its child classes.


## Boxed classes

The purpose of these classes is mainly that it is made with less fanfare then a widget class needs to have. So these classes are made smaller with less access functions. Examples of these classes are **Gnome::Gdk3::Pixbuf** and **Gnome::Gtk3::Border**.


## Other classes

There are still other classes which are standalone classes. Examples are **Gnome::Glib::Error** and  **Gnome::Gtk3::Main**. These classes have nothing in common with widgets but are more for control. The **Error** is for handling error messages and **Main** to handle event loops. Some of them still inherit from **TopLevelClassSupport** for some internal processing.


## Instantiation of a class

To instantiate a class you make use of the call to `.new()`. Oftentimes with named arguments to steer the way of its initialization. While initializing the object calls a specific native routine which will cough up a native object which, in turn, is stored somewhere high up in **TopLevelClassSupport**.

For the **Gnome::GObject::Button** class, the native subroutines to create a native button object are for example `gtk_button_new()` or `gtk_button_new_with_label()`. In some of the older module documentation references, they are still visible but they are completely useless because you must first have an initialized object before you can call such a method.
Newer and reviewed modules will not show those methods anymore. All possible methods creating new native objects will be handled by the modules `.new()` methods using named arguments.

There are two important named arguments which do not create new native objects but imports them from other sources. **TopLevelClassSupport** handles the `:native-object` and **Object** handles `:build-id` <!--TODO ref counting?? -->.
* `:native-object` is used when a native object result needs to be imported. This mostly happens when objects are presented to signal handlers or when objects are taken out of glib linked lists.
* `:build-id` takes an id which is defined in an XML file together with an object description. These files can be read by **Gnome::Gtk3::Builder**. The XML can be created by hand but the easier way is to use `glade` which is an interface designer program to generate the XML files.


## Inheriting a class

It is possible to inherit from many classes in the package. There is somewhat more to explain so there is a separate section for it which you can find [here](inheriting.html).


## Native subroutines

Each of the Raku classes have a set of native subroutines which belong in that class. For example the GTK+ structure GtkButton has methods like `gtk_button_set_label()`. So the Raku module **Gnome::Gtk3::Button** has this subroutine defined. Al these subroutines are not exported so they are only accessable from within the class.

There are two ways defined to access the subroutines. An old one with which the project was started and a newer one which is a bit faster.
* The old way uses the Raku `FALLBACK()` method to catch method names which are not implemented as such. The method is defined in the class **TopLevelClassSupport**. In turn it calls `._fallback()` methods in each derived class. `_fallback()` searches for the native sub name in that class if not found it hops over to another class using `.callsame()`. When a subroutine is found with that name, it is called with the necessary arguments. The end result is that the native subroutines behave as if they were methods.
  The old method has the possibility to accept several method names and are shown as follows in the documentation; `_[[gtk_] button_] set_label_`. The brackets `[]` mean that the text there is optional. So the possible method calls for the native sub `gtk_button_set_label()` will be
  ```raku
  $button.gtk_button_set_label('Start');    # original sub name
  $button.gtk-button_set-label('Start');    # intermixed '-' and '_'
  $button.button_set_label('Start');        # drop 'gtk_'
  $button.set_label('Start');               # drop 'gtk_button_'
  $button.set-label('Start');               # only '-'
  ```
  In the end, the older method naming will be deprecated in favor of the newer and faster method. The changes will be visible in the documentation as there will be no flexibility in naming. Check the reference page for the exact names, the example above could already be rewritten into a fixed name `.set-label()`.

* New developments using real methods accessing the native subroutines without using `FALLBACK()` showed, that access is much faster. So, it is decided that those methods should be implemented alongside each native subroutine. This will not happen overnight. New modules however, are generated with those methods and do not have the search implementation described using the fallback routines. The names of the methods are the shortest possible and the documentation will show only that possibility.
  I would like to quote the words of Johan Cruyff here: _for every disadvantage there is an advantage_. Also here, not only the methods are faster but it is possible to convert native types like gboolean into the Raku type **Bool** before returning them, native arrays can be converted to Raku **Array**s or **List**s and native objects (`N-GObject`) can be returned as a Raku Gtk type, see below for an example.

Having said all this, it is therefore best to use the shortest possible name with dashes in it instead of underscores to prevent being forced to comply to future changes in your code.

Another note to add is this; many routine arguments, named or positional, expect native objects with types like `N-GObject` or `N-Error`. Instead of retrieving the native objects from the Raku objects, it is possible to hand over the Raku object instead. The routines expecting such elements will find the native objects themselves. This will keep your code clean. For example, the **Gnome::Gtk3::Grid** class expects an `N-GObject` native widget as the first argument to the call `.attach()`.

```raku
method attach (
  N-GObject $child, Int $left, Int $top, Int $width, Int $height
)
```

But instead you can give a label or a button object for example, like here adding an Entry and a Label;
```raku
my Gnome::Gtk3::Label $l .= new(:text('input a number'));
my Gnome::Gtk3::Entry $e .= new;
$grid.attach( $l, 0, 0, 1, 1);
$grid.attach( $e, 1, 0, 1, 1);
```

Newer modules and modified modules will also be able to return Raku objects. For instance in **Grid**, there is a method to get the native object from some cell. The method used for it is called `.get-child-at()`. Now there is also a method named `get-child-at-rk()` which is able to return a raku object. So, extending the example above with some lines to retrieve the widgets again;

```raku
my Gnome::Gtk3::Label $l = $grid,get-child-at-rk( 0, 0);
my Gnome::Gtk3::Entry $e = $grid,get-child-at-rk( 1, 0);
```

which is much cleaner than
```raku
my Gnome::Gtk3::Label $l .= new(:native-object($grid,get-child-at( 0, 0));
my Gnome::Gtk3::Entry $e .= new(:native-object($grid,get-child-at( 1, 0));
```

To be sure that there is an object at some grid location you should test the returned object before using it;
```raku
my Gnome::Gtk3::Label $l = $grid,get-child-at-rk( 12, 100);
if $l.is-valid {
  # … now we can safely use it …
}
```

# References
{% assign url = site.baseurl | append: "/content-docs/reference" %}
* [Gnome::N::TopLevelClassSupport]({{ url }}/Native/TopLevelClassSupport.html)

* [Gnome::GObject::Boxed]({{ url }}/GObject/Boxed.html)
* [Gnome::GObject::Object]({{ url }}/GObject/Object.html)

* [Gnome::Glib::Error]({{ url }}/Glib/Error.html)

* [Gnome::Gdk3::Pixbuf]({{ url }}/Gdk3/Pixbuf.html)

* [Gnome::Gtk3::Border]({{ url }}/Gtk3/Border.html)
* [Gnome::Gtk3::Main]({{ url }}/Gtk3/Main.html)
* [Gnome::Gtk3::Label]({{ url }}/Gtk3/Label.html)
* [Gnome::Gtk3::Entry]({{ url }}/Gtk3/Entry.html)
* [Gnome::Gtk3::Button]({{ url }}/Gtk3/Button.html)
* [Gnome::Gtk3::Grid]({{ url }}/Gtk3/Grid.html)
