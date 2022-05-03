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

We see that several classes inherit from Object directly or inderectly and therefore have access to the mechanisms provided by Object.


## Initialization

As discussed in the document [Raku Modules](raku-modules.html), each widget must be initialized to have a native object representing the C object stored in the Raku object. Most Raku objects accept the `:native-object` named argument and many (widgets) know about the `:build-id` next to their own set of arguments if any.

* `:native-object`; This argument is not handled here really, it is handled at the top of the food chain, in **Gnome::N::TopLevelClassSupport**. It is handled there because the native object is defined in that class. Therefore, any class inheriting from that class knows about this named argument. Its use is to import a native object from elsewhere into the Raku object. After that, the methods can be used to access that object.

* `:build-id`; This argument can be used when GUI descriptions in XML are created by hand or with the use of the designer program `glade`. The XML can be loaded with the use of class **Gnome::Gtk3:Builder**. When the **Builder** class is instantiated, the object is also stored in the **Object** class in such a way that any other **Object** object can access the **Builder** object. The entities described in the XML can have id's unique in that XML. This then makes it possible to retrieve an object from the **Builder** by using this `:build-id` argument. When calling this;

  ```raku
  my Gnome::Gtk3::Button $button .= new(:build-id<my-stop-button>);
  ```

  would be something like this under the hood;

  ```raku
  my Gnome::Gtk3::Button $button .= new(:native-object(
      $builder.get-object('my-stop-button')
    )
  );
  ```


## Signals and events

The **Object** of Gnome also helps with the handling of signals of events. It uses the **Gnome::GObject::Signal** role for it. It is a rather large subject so there is [more on this is described here](Signal.html).

## Concurrent processes

Concurrency is implemented in the modules **Gnome::Glib::MainLoop** and **Gnome::Glib::MainContext**. A method `Gnome::GObject::Object.start-thread()` is implemented as a convenience for the use of these modules.

An example of its use comes from the testing programs where some of the events are tested. Below, events for the **Gnome::Gtk3::AboutDialog** are tested;

```raku
use Test;
use NativeCall;

use Gnome::N::GlibToRakuTypes;
use Gnome::Gtk3::AboutDialog;
use Gnome::Gdk3::Pixbuf;
use Gnome::Gtk3::Main;

my Gnome::Gtk3::Main $main .= new;

class SignalHandlers {
  has Bool $!signal-processed = False;

  method activate ( Str $uri --> Bool ) {                             # 1
    is $uri, 'https://example.com/my-favourite-items.html',
      'uri received from event';
    $!signal-processed = True;

    True
  }

  method signal-emitter (
    Gnome::Gtk3::AboutDialog :_widget($about-dialog) --> Str
  ) {                                                                 # 2

    $about-dialog.emit-by-name(                                       # 3
      'activate-link',
      'https://example.com/my-favourite-items.html',
      :return-type(gboolean),
      :parameters([gchar-ptr,])
    );

    sleep(0.4);
    is $!signal-processed, True, '\'activate-link\' signal processed';

    $main.main-quit;

    'done'
  }
}

my SignalHandlers $sh .= new;
$a.register-signal( $sh, 'activate', 'activate-link');                # 4

my Promise $p = $a.start-thread( $sh, 'signal-emitter', :new-context);# 5

$main.main;                                                           # 6

is $p.result, 'done', 'emitter finished';
```

1. There are two handlers in the **SignalHandlers** class. The signal to be tested is `activate-link` and the method `.activate()` receives it. This handler receives an uri.

2. The second handler is the one running in a thread. We need a thread if long running work is to be done and it should not hold up the interaction of the user interface. Here it just fires an event to test the event handler.

3. The method `.emit-by-name()` is used to fire the event. It must deliver all arguments which an event handler can receive. After emitting, we need some rest and then finish the event loop. The types are native types used in Gtk and are defined in **Gnome::N::GlibToRakuTypes** as a convenience. The `gboolean` is an `int32` and `gchar-ptr` is an `Str`.

4. We must register the signal handler.

5. Now we can create a thread which, in this case, also creates a new event context. This is not always necessary, but in that case you need to process the events yourself like here;
  ```raku
  while $main.events-pending() { $main.iteration-do(False); }
  ```

6. Start the event loop. We return here when `.main-quit()` is called to end the loop. After that we can test for any results comming back from the thread.


## Properties

Properties are predefined items in the native object, i.e all GTK+ objects inheriting from the native object wrapped in **Gnome::GObject::Object**. Each gtk class has its own set of variables to store data. Most of the values can be retrieved by the methods as well as setting these values. Sometimes however, there are no methods defined and we must use special calls to get and set them.

For instance, in the module **Gnome::Gtk3::AboutDialog** we can find the methods to get and set the program name which is shown in the dialog.

```raku
$about-dialog.set-program-name('AboutDialog.t');
say $about-dialog.get-program-name;         # AboutDialog.t
```

To use the property for this data you can run the following snippet;
```raku
my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));            # 1
$about-dialog.get-property( 'program-name', $gv);                     # 2
say $gv.get-string;                         # AboutDialog.t           # 3
$gv.clear-object;                                                     # 4
```
1. Initialize the **Gnome::GObject::Value** object with the type we have to get data from. These types are defined in **Gnome::GObject::Type**.

2. Then we can get the property from the about dialog object into the **Gnome::GObject::Value** object.

3. Using the call `.get-string()`, we are able to retrieve the string from the property. For each type, there is another method. Examples are `.get-boolean()` and `.get-int64()`. There is also a set property method. In this case `.set-string()`. Note that not all properties are writable.

4. When done with the **Value** object, we need to clean it up.

Das war damals, but it still usable. Now, new methods are added and are much simpler to work with. The methods are `.get-properties()` and `.set-properties()`.
```raku
my @r = $about-dialog.get-properties( 'program-name', Str);
say @r[0];                                  # AboutDialog.t
```

More than one property can be returned from one call. Therefore, the values are returned in a list.

Errors like the next one, are shown at the terminal when wrong or non-existant property names are used.
```raku
(AboutDialog.t:10839): GLib-GObject-WARNING **: 16:25:15.822: g_object_get_is_valid_property: object class 'GtkAboutDialog' has no property named 'program-nme'
```

## Data

Properties are predefined values of a gtk class. The user of a widget might have a few of their own to add to the native object. But first …

There was this issue #23 posted by Grenzionky about loosing information set in attributes of classes inheriting some gnome widget. The problem happened when the object of such a class was set as a page in a notebook. Later the object was returned again from the notebook by some call to a method. The strange thing was that, when the Raku object was recreated again, the attributes in that object were not having the values which were set before.

A code snippet to show the situation
```raku
class ExtendedLabel is Gnome::Gtk3::Label {                           # 1
  has Str $.custom-data;

  submethod new (|c) {                                                # 2
    self.bless( :GtkLabel, |c );
  }
}

my ExtendedLabel $label .= new(
  :custom-data('some data contents'), :text('words')
);

my Gnome::Gtk3::Notebook $notebook .= new;                            # 3
$notebook.append-page( $label, Gnome::Gtk3::Label.new(:text('title')));

my Gnome::Gtk3::Window $window .= new;                                # 4
$window.add($notebook);

… Further setup and start main loop …

say ExtendedLabel.new(                                                # 5
  :native-object($notebook.get-nth-page(0))
).custom-data;

```

1. This is the class we want to talk about. `$!custom-data` is the attribute we need to use later.

2. A necessary step to inherit the Label widget. Initializing the class with the label text as 'words' and the attribute `$.custom-data` to 'some data contents'.

3. Create the notebook and add the **ExtendedLabel** object as a page.

4. Create a window and add the notebook to it. Additionally, we need to register callback handlers, show everything and start the main loop.

5. Sometime later we want to get the object again to do some work and we expect to get `'some data contents'` as the stored text. Unfortunately, it will be undefined!

So, why did the Raku class not initialize to its original value?
The problem lies in the fact that all Raku widget classes wrap a native object. This native object is the only structure to be given to the native suboutines in order to complete their tasks. When, at a later moment, the object is retrieved, the object can only be wrapped in again into the Raku class without any knowledge of the previous settings of its attributes. In the above case it is more or less obvious that the object is imported (See line `(5`).

It is less clear when a `-rk` version is used like below;

```raku
my Gnome::Gtk3::Label $label = $notebook.get-nth-page-rk(0);
```

**Note** that the `-rk` routines are deprecated because of newer code which can help to coerce to the proper Raku objects. As an example taken from above, the same result is produced using the following code;
```raku
my Gnome::Gtk3::Label() $label = $notebook.get-nth-page(0);
```

Essentially, it does the same besides finding out what Raku widget object to create. Note that it can only return a **Gnome::Gtk3::Label**, the code cannot possibly know about other classes. Therefore this is not usable on child classes like **ExtendedLabel**.

To solve this problem I proposed to create a singleton class where the Raku class objects can register themselves using a key. This key can also be used as a widget name which is stored on the native object. When the object is retrieved, the widget name can be asked for and with that the Raku object found in the registry of the singleton.

That works of course but the **Object** module is extended with new methods `.get-data()` and `.set-data()`. With these calls you can store data on the native object. Now, when the object returns, the data can be retrieved from the object.

Some examples;

### Example 1

Here is an example to show how to associate some data to an object and to retrieve it again. We are using our issue example explained above.

```raku
class ExtendedLabel is Gnome::Gtk3::Label {
  has Str $.custom-data;

  submethod new (|c) {
    self.bless( :GtkLabel, |c );
  }

  submethod BUILD ( Str $!custom-data, :$native-object ) {
    if ? $native-object {                                             # 1
      $!custom-data = self.get-data( 'custom data', Str);
    }

    else {                                                            # 2
      self.set-data( 'custom data', $!custom-data);
    }
  }
}

my ExtendedLabel $label .= new(
  :custom-data('some data contents'), :text('words')
);

…

say ExtendedLabel.new(                                                # 3
  :native-object($notebook.get-nth-page(0))
).custom-data;
```
1. Create the class from our issue example but now we test for a named argument `:$native-object`. The argument is handled in **TopLevelClassSupport** but we use it here to see if the native object is imported or that it is created anew. When imported, we retrieve the data back from the native object with `.get-data()`.
2. Otherwise, when created anew, the data is also stored on the native object.
3. Then, when needed, the same call is used as before but the attribute `$!custom-data` will be set automatically.

Note that the data is stored with a key. This means that you can store more data items on an object. Above the key `custom data` is used.

In the case of a `N-GObject` typed objects, you can use the `widget-class` named argument to get a Raku object, e.g. get a previously stored grid object from a button using a key `my attached grid`;

```raku
class MyGrid is Gnome::Gtk3::Grid { … }
$button.set-data( 'my attached grid', MyGrid.new);

my MyGrid $grid = $button.get-data(
  'my attached grid', N-GObject, :widget-class<MyGrid>
);
```


### Example 2

Other types can be used as well to store data. The next example shows what is possible;

```raku
$button.set-data( 'my number key', 2e101);
$button.set-data( 'my-uint32-key', my uint32 $x = 12345);

…

my Str $text = $button.get-data( 'my number key', Num);
my Int $number = $button.get-data( 'my-uint32-key', uint32);
```

### Example 3

An elaborate example of more complex data can be used with **BSON**. This is an implementation of a JSON like structure but is serialized into a binary representation. It is used for transport to and from a MongoDB server. Here we use it to attach complex data in serialized form to an **Gnome::GObject::Object**. (Please note that the **BSON** package must be of version 0.13.2 or higher.)

```raku
# Create the data structure
my BSON::Document $bson .= new: (
  :int-number(-10),
  :num-number(-2.34e-3),
  :strings( :s1<abc>, :s2<def>, :s3<xyz> )
);

# And store it on a label
my Gnome::Gtk3::Label $bl .= new(:text<a-label>);
$bl.set-data( 'my-buf-key', $bson.encode);

…

# Later, we want to access the data again,
my BSON::Document $bson2 .= new($bl.get-data( 'my-buf-key', Buf));

# Now you can use the data again.
say $bson2<int-number>;  # -10
say $bson2<num-number>;  # -234e-5
say $bson2<strings><s2>; # 'def'
```

## BUILD into child class

The method calls to `.set-data()` and `.get-data()` could be conveniently tucked away in the `BUILD()` submethod of the child class like so;
```raku
class ExtendedLabel is Gnome::Gtk3::Label {
  has Str $.custom-data;
  method new ( |c ) {
    self.bless( :GtkLabel, |c );
  }

  submethod BUILD ( Str :$!custom-data, :$native-object? ) {
    if $native-object {                                               # 1
      $!custom-data = self.get-data( 'custom-data', Str);
    }

    else {                                                            # 2
      self.set-data( 'custom-data', $!custom-data);
    }
  }
}
```

1) when imported, get data

2) otherwise, set data

<!--
## Reference counting
### Floating references
### :native-object
### ._get-native-object()
### ._get-native-object-no-reffing()
### .clear-object()

-->

# References
{% assign url = site.baseurl | append: "/content-docs/reference" %}
* [Gnome::N::TopLevelClassSupport]({{ url }}/Native/TopLevelClassSupport.html)

* [Gnome::GObject::Object]({{ url }}/GObject/Object.html)
* [Gnome::GObject::Signal]({{ url }}/GObject/Signal.html)
* [Gnome::GObject::Value]({{ url }}/GObject/Value.html)
* [Gnome::GObject::Type]({{ url }}/GObject/Type.html)

* [Gnome::Glib::MainLoop]({{ url }}/Glib/MainLoop.html)
* [Gnome::Glib::MainContext]({{ url }}/Glib/MainContext.html)

* [Gnome::Gdk3::Pixbuf]({{ url }}/Gdk3/Pixbuf.html)

* [Gnome::Gtk3::AboutDialog]({{ url }}/Gtk3/AboutDialog.html)
* [Gnome::Gtk3::Builder]({{ url }}/Gtk3/Builder.html)
* [Gnome::Gtk3::Main]({{ url }}/Gtk3/Main.html)
