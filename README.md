![gtk logo][logo]

# Gnome Gtk3 - Widget toolkit for graphical interfaces

[![License](http://martimm.github.io/label/License-label.svg)](http://www.perlfoundation.org/artistic_license_2_0)

Documentation at [this site](http://martimm.github.io/gnome-gtk3) has the `GNU Free Documentation License`.

# Description

The purpose of this project is to create an interface to the **GTK+** version 3 library.

# History
There is already a bit of history for this package. It started off building the `GTK::Glade` package which soon became too big. So a part was separated into `GTK::V3`. After some working with the library I felt that the class names were a bit too long and that the words `gtk` and `gdk` were repeated too many times in the class path. E.g. there was `GTK::V3::Gtk::GtkButton` and `GTK::V3::Gdk::GdkScreen` to name a few. So, finally it was split into several other packages named, `Gnome::N` for the native linkup on behalf of any other Gnome module, `Gnome::Glib`, `Gnome::GObject`, `Gnome::Gdk3` and `Gnome::Gtk3` according to what is shown [on the developers page here][devel refs]. The classes in these packages are now renamed into e.g. `Gnome::Gtk3::Button`, `Gnome::Gdk3::Screen`, `Gnome::GObject::Object` and `Gnome::Glib::List`. As a side effect the package `GTK::Glade` is also renamed into `Gnome::Glade3` to show that it is from Gnome and that it is based on Gtk version 3.

# Example

This example does the same as the example from `GTK::Simple` to show you the differences between the implementations. What immediately is clear is that this example is somewhat longer. To sum up;
### Pros
  * The defaults of GTK+ are kept. Therefore the buttons are in the proper size compared to what GTK::Simple produces.
  * Separation of callbacks from other code. Closures are not needed to get data into the callback code. Data can be provided with named arguments to the `register-signal()` method.
  * The package is designed with the usage of glade interface designer in mind. So to build the interface by hand like below, is not necessary. Use of `Gnome::Gtk3::Glade` is preferable when building larger user interfaces.
  * No fancy stuff like tapping into channels to run signal handlers.
  * There is a registration of callback methods to process signals like button clicks as well as events like keyboard input and mouse clicks. This is not available in `GTK::Simple`. The provided way to handle a signal there, is fixed into a method. E.g. the button has a 'clicked' method and the container has none while an observer might want to know if an object is inserted into a grid using the 'add' signal.
  * The same method, `register-signal()`, is also used to register other types of signals. There are, for example, events to handle keyboard input and mouse clicks. Not all signal handlers can be written yet because the provided native objects can not be imported into a Raku object because of its missing class.

### Cons
  * The code is larger.
  * Code is somewhat slower. The setup of the example shown next is about 0.05 sec slower. That isn't much seen in the light that a user interface is mostly set up and drawn once.


|![-this screenshot-][screenshot 1]|
|:--:|
|**A screenshot of the example**|

The code can be found down on the [Getting Started](https://martimm.github.io/gnome-gtk3/content-docs/tutorial/getting-started.html) page.

```
use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Grid;
use Gnome::Gtk3::Button;

# Instantiate main module for UI control
my Gnome::Gtk3::Main $m .= new;

# Class to handle signals
class AppSignalHandlers {

  # Handle 'Hello World' button click
  method first-button-click ( :widget($b1), :other-button($b2) ) {
    $b1.set-sensitive(False);
    $b2.set-sensitive(True);
  }

  # Handle 'Goodbye' button click
  method second-button-click ( ) {
    $m.gtk-main-quit;
  }

  # Handle window managers 'close app' button
  method exit-program ( ) {
    $m.gtk-main-quit;
  }
}

# Create a top level window and set a title
my Gnome::Gtk3::Window $top-window .= new;
$top-window.set-title('Hello GTK!');
$top-window.set-border-width(20);

# Create a grid and add it to the window
my Gnome::Gtk3::Grid $grid .= new;
$top-window.gtk-container-add($grid);

# Create buttons and disable the second one
my Gnome::Gtk3::Button $button .= new(:label('Hello World'));
my Gnome::Gtk3::Button $second .= new(:label('Goodbye'));
$second.set-sensitive(False);

# Add buttons to the grid
$grid.gtk-grid-attach( $button, 0, 0, 1, 1);
$grid.gtk-grid-attach( $second, 0, 1, 1, 1);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new;
$button.register-signal(
  $ash, 'first-button-click', 'clicked',  :other-button($second)
);
$second.register-signal( $ash, 'second-button-click', 'clicked');

$top-window.register-signal( $ash, 'exit-program', 'destroy');

# Show everything and activate all
$top-window.show-all;

$m.gtk-main;
```

# TODO

# Versions of involved software

* Program is tested against the latest version of **Raku** on **rakudo** en **moarvm**. It is also necessary to have the (almost) newest compiler, because there are some code changes which made e.g. variable argument lists to the native subs possible. Older compilers cannot handle that (before summer 2019 I believe). This means that Rakudo Star is not usable because the newest release is from March 2019.

  Some steps to follow if you want to be at the top of things. You need `git` to get software from the github site.
  1) Make a directory to work in e.g. Raku
  2) Go in that directory and run `git clone https://github.com/rakudo/rakudo.git`
  3) Then go into the created rakudo directory
  4) Run `perl Configure.pl --gen-moar --gen-nqp --backends=moar`
  5) Run `make test`
  6) And run `make install`

  Subsequent updates of the Raku compiler and moarvm can be installed with
  1) Go into the rakudo directory
  2) Run `git pull`
  then repeat steps 4 to 6 from above

  Your path must then be set to the program directories where `$Rakudo` is your  `rakudo` directory;
  `${PATH}:$Rakudo/install/bin:$Rakudo/install/share/perl6/site/bin`

  You can read the README for more details on the same site: https://github.com/rakudo/rakudo

  After this, you will notice that the `raku` command is available next to `perl6` so it is also a move forward in the renaming of perl6.

  The rakudo star installation must be removed, because otherwise there will be two raku compilers wanting to be the captain on your ship. Also all modules must be reinstalled of course and are installed at `$Rakudo/install/share/perl6/site`.

* Gtk library used **Gtk 3.24**. The versioning of GTK+ is a bit different in that there is also a 3.90 and up. This is only meant as a prelude to version 4. So do not use those versions for the perl packages.


# Installation
There are several dependencies from one package to the other because it was one package in the past. To get all packages, just install the *Gnome::Gtk3* package and the rest will be installed with it.

`zef install Gnome::Gtk3`

# Issues

There are always some problems! If you find one, please help by filing an issue at [my github project](https://github.com/MARTIMM/gnome-gtk3/issues).

# Attribution
* First of all, I would like to thank the developers of the `GTK::Simple` project because of the information I got while reading the code. Also because one of the files is copied unaltered for which I did not had to think about to get that right. The examples in that project are also useful to compare code with each other and to see what is or is not possible.
* The inventors of Raku, formerly known as Perl 6, of course and the writers of the documentation which helped me out every time again and again.
* The builders of the GTK+ library and the documentation.
* Other helpful modules for their insight and use.
* Documentation from [Wikibooks](https://en.wikibooks.org/wiki/GTK%2B_By_Example) and [Zetcode](http://zetcode.com/tutorials/gtktutorial/)

# Author

Name: **Marcel Timmerman**
Github account name: **MARTIMM**

[//]: # (---- [refs] ----------------------------------------------------------)
[changes]: https://martimm.github.io/gnome-gtk3/CHANGES.html
[logo]: https://martimm.github.io/gnome-gtk3/content-docs/images/gtk-perl6.png
[devel refs]: https://developer.gnome.org/references

[screenshot 1]: https://martimm.github.io/gnome-gtk3/content-docs/tutorial/images/01-hello-world.png
[screenshot 2]: https://martimm.github.io/gnome-gtk3/content-docs/images/examples/16a-level-bar.png
[screenshot 3]: https://martimm.github.io/gnome-gtk3/content-docs/images/examples/16b-level-bar.png
[screenshot 4]: https://martimm.github.io/gnome-gtk3/content-docs/images/examples/ex-GtkScale.png


[//]: # (Pod documentation rendered with)
[//]: # (pod-render.pl6 --md --d=../gnome-gtk3/docs/content-docs/references/Gtk3 lib)
