![gtk logo][logo]

[toc]

# Gnome Gtk3 - Widget toolkit for graphical interfaces

[![License](http://martimm.github.io/label/License-label.svg)](http://www.perlfoundation.org/artistic_license_2_0)

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
  * There is a registration of callback methods to process signals like button clicks as well as events like keyboard input and mouse clicks.. This is not available in `GTK::Simple`. The provided way to handle a signal there, is fixed into a method. E.g. the button has a 'clicked' method and the container has none while an observer might want to know if an object is inserted into a grid using the 'add' signal.
  * The same method, `register-signal()`, is also used to register other types of signals. There are, for example, events to handle keyboard input and mouse clicks. Not all signal handler types are supported yet but can be installed in time.

### Cons
  * The code is larger.
  * Code is somewhat slower. The setup of the example shown next is about 0.05 sec slower. That isn't much seen in the light that a user interface is mostly set up and drawn once.

A screenshot of the example
![-this screenshot-][screenshot 1].
The code can be found at `examples/01-hello-world.pl6`.
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
my Gnome::Gtk3::Window $top-window .= new(:empty);
$top-window.set-title('Hello GTK!');
$top-window.set-border-width(20);

# Create a grid and add it to the window
my Gnome::Gtk3::Grid $grid .= new(:empty);
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

# Design

I want to follow the interface of the classes in **Gtk**, **Gdk** and **Glib** as closely as possible by keeping the names of the native functions the same as provided with the following exceptions;
* The native subroutines are defined in their corresponding classes. They are set up in such a way that they have become methods in those classes. Many subs also have as their first argument the native object. This object is held in the class and is automatically inserted when the sub is called. E.g. a definition like the following in the `Gnome::Gtk3::Button` class
```
sub gtk_button_set_label ( N-GObject $widget, Str $label )
  is native(&gtk-lib)
  { * }
```
  can be used as
```
my Gnome::Gtk3::Button $button .= new(:empty);
$button.gtk_button_set_label('Start Program');
```

* Classes can use the methods of inherited classes. E.g. The `Gnome::Gtk3::Button` class inherits `Gnome::Gtk3::Bin` and `Gnome::Gtk3::Bin` inherits `Gnome::Gtk3::Container` etcetera. Therefore a method like `gtk_widget_set_tooltip_text` from `Gnome::Gtk3::Widget` can be used.
```
$button.gtk_widget_set_tooltip_text('When pressed, program will start');
```

* The names are sometimes long and prefixed with words which are also used in the class path name. Therefore, those names can be shortened by removing those prefixes. An example method in the `Gnome::Gtk3::Button` class is `gtk_button_get_label()`. This can be shortened to `get_label()`.
```
my Str $button-label = $button.get_label;
```
  In the documentation this will be shown with brackets around the part that can be left out. In this case it is shown as `[gtk_button_] get_label`.

* Names can not be shortened too much. E.g. `gtk_button_new` and `gtk_label_new` yield `new` which is a perl method from class `Mu`. I am thinking about chopping off the `g_`, `gdk_` and `gtk_` prefixes.

* All the method names are written with an underscore. Following a perl6 tradition, dashed versions is also possible.
```
my Str $button-label1 = $button.gtk-button-get-label;
my Str $button-label2 = $button.get-label;
```

* Not all native subs or even classes will be implemented or implemented much later because of the following reasons;
  * Many subs and some classes in **GTK+** are obsolete.
  * The original idea was to have the interface build by the glade interface designer. This lib was in the `GTK::Glade`(now `Gnome::Gtk3::Glade`) project before refactoring. Therefore a `Gnome::Gtk3::Button` does not have to have all subs to create a button. On the other hand a `Gnome::Gtk3::ListBox` is a widget which is changed dynamically most of the time and therefore need more subs to manipulate the widget and its contents.
  * The need to implement classes like `Gnome::Gtk3::Assistant`, `Gnome::Gtk3::Alignment` or `Gnome::Gtk3::ScrolledWindow` is on a low priority because these can all be instantiated by `GtkBuilder` using your Glade design.

* There are native subroutines which need a native object as an argument. The `gtk_grid_attach` in `Gnome::Gtk3::Grid` is an example of such a routine. It is possible to provide the perl6 object in that place. The signature of the native sub is checked and will automatically retrieve the native object from that class if needed.

  The declaration of the `gtk_grid_attach` native sub;
```
sub gtk_grid_attach (
  N-GObject $grid, N-GObject $child,
  int32 $x, int32 $y, int32 $width, int32 $height
) is native(&gtk-lib)
  { * }
```
  And its use;
```
my Gnome::Gtk::Grid $grid .= new(:empty);
my Gnome::Gtk::Label $label .= new(:label('server name'));
$grid.gtk-grid-attach( $label, 0, 0, 1, 1);
```

# Errors and crashes

I came to the conclusion that Perl6 is not (yet) capable to return a proper message when some type of mistakes are made. E.g. spelling errors or using wrong types when using the native call interface. Most of them end up in **MoarVM panic: Internal error: Unwound entire stack and missed handler**. Other times it ends in just a plain crash. Some of the crashes are happening within GTK and cannot be captured by Perl6. One of those moments are the use of GTK calls without initializing GTK with `gtk_init`. The panic mentioned above mostly happens when perl6 code is called from C as a callback and an exception is (re)thrown. The stack might not be interpreted completely at that moment hence the message.

A few measures are implemented to help a bit preventing problems;

* The failure to initialize GTK on time (in most cases) is solved by using an initialization flag which is checked in the `Gnome::Gtk3::Main` module. The module is referred to by `Gnome::GObject::Object` which almost all modules inherit from. GObject calls a method in `Gnome::Gtk3::Main` to check for this flag and initialize if needed. Therefore the user never has to initialize GTK.
* Throwing an exception while in Perl6 code called from C (in a callback), Perl6 will crash with the '*internal error*' message mentioned above without being able to process the exception.

  To at least show why it happens, all messages which are set in the exception are printed first before calling `die()` which will perl6 force to wander off aimlessly. A debug flag in the class `X::Gnome::N` can be set to show these messages which might help solving your problems.

# Documentation

| Pdf from pod | Link to Gnome Developer |
|-------|--------------|
| [Gnome::Gtk3::AboutDialog][Gnome::Gtk3::AboutDialog pdf] | [GtkAboutDialog.html][GtkAboutDialog]
| [Gnome::Gtk3::Bin][Gnome::Gtk3::Bin pdf] | [GtkBin.html][GtkBin]
| [Gnome::Gtk3::Builder][Gnome::Gtk3::Builder pdf] |  [GtkBuilder.html][GtkBuilder]
| [Gnome::Gtk3::Button][Gnome::Gtk3::Button pdf] |  [GtkButton.html][GtkButton]
| [Gnome::Gtk3::Box][Gnome::Gtk3::Box pdf] |  [GtkBox.html][GtkBox]
| [Gnome::Gtk3::CheckButton][Gnome::Gtk3::CheckButton pdf] |  [GtkCheckButton.html][GtkCheckButton]
| [Gnome::Gtk3::ComboBox][Gnome::Gtk3::ComboBox pdf] |  [GtkComboBox.html][GtkComboBox]
| [Gnome::Gtk3::ComboBoxText][Gnome::Gtk3::ComboBoxText pdf] |  [GtkComboBoxText.html][GtkComboBoxText]
| [Gnome::Gtk3::ColorButton][Gnome::Gtk3::ColorButton pdf] |  [GtkColorButton.html][GtkColorButton]
| [Gnome::Gtk3::ColorChooser][Gnome::Gtk3::ColorChooser pdf] |  [GtkColorChooser.html][GtkColorChooser]
| [Gnome::Gtk3::ColorChooserDialog][Gnome::Gtk3::ColorChooserDialog pdf] |  [GtkColorChooserDialog.html][GtkColorChooserDialog]
| [Gnome::Gtk3::ColorChooserWidget][Gnome::Gtk3::ColorChooserWidget pdf] |  [GtkColorChooserWidget.html][GtkColorChooserWidget]
| Gnome::Gtk3::Container |  [GtkContainer.html][GtkContainer]
| Gnome::Gtk3::CssProvider |  [GtkCssProvider.html][GtkCssProvider]
| Gnome::Gtk3::StyleContext |  [GtkStyleContext.html][GtkStyleContext]
| [Gnome::Gtk3::Dialog][Gnome::Gtk3::Dialog pdf] |  [GtkDialog.html][GtkDialog]
| Gnome::Gtk3::Entry |  [GtkEntry.html][GtkEntry]
| Gnome::Gtk3::FileChooser |  [GtkFileChooser.html][GtkFileChooser]
| [Gnome::Gtk3::FileChooserDialog][Gnome::Gtk3::FileChooserDialog pdf] |  [GtkFileChooserDialog.html][GtkFileChooserDialog]
| Gnome::Gtk3::FileFilter |  [GtkFileFilter.html][GtkFileFilter]
| Gnome::Gtk3::Grid |  [GtkGrid.html][GtkGrid]
| Gnome::Gtk3::Image |  [GtkImage.html][GtkImage]
| Gnome::Gtk3::ImageMenuItem |  [GtkImageMenuItem.html][GtkImageMenuItem]
| Gnome::Gtk3::Label |  [GtkLabel.html][GtkLabel]
| [ Gnome::Gtk3::LevelBar ][ Gnome::Gtk3::LevelBar pdf] |  [GtkLevelBar.html][GtkLevelBar]
| Gnome::Gtk3::ListBox |  [GtkListBox.html][gtklistbox]
| [Gnome::Gtk3::Main][Gnome::Gtk3::Main pdf] |  [GtkMain.html][GtkMain]
| Gnome::Gtk3::MenuItem |  [GtkMenuItem.html][GtkMenuItem]
| [Gnome::Gtk3::Orientable][Gnome::Gtk3::Orientable pdf] |  [GtkOrientable.html][GtkOrientable]
| [Gnome::Gtk3::Paned][Gnome::Gtk3::Paned pdf] |  [GtkPaned.html][GtkPaned]
| Gnome::Gtk3::RadioButton |  [GtkRadioButton.html][GtkRadioButton]
| [Gnome::Gtk3::Range][Gnome::Gtk3::Range pdf] |  [GtkRange.html][GtkRange]
| [Gnome::Gtk3::Scale][Gnome::Gtk3::Scale pdf] |  [GtkScale.html][GtkScale]
| Gnome::Gtk3::StyleContext |  [GtkStyleContext.html][GtkStyleContext]
| Gnome::Gtk3::TextBuffer |  [GtkTextBuffer.html][GtkTextBuffer]
| Gnome::Gtk3::TextTagTable |  [GtkTextTagTable.html][GtkTextTagTable] |
| Gnome::Gtk3::TextView |  [GtkTextView.html][GtkTextView]
| [Gnome::Gtk3::ToggleButton][Gnome::Gtk3::ToggleButton pdf] |  [GtkToggleButton.html][GtkToggleButton]
| [Gnome::Gtk3::Widget][Gnome::Gtk3::Widget pdf] |  [GtkWidget.html][GtkWidget]
| [Gnome::Gtk3::Window][Gnome::Gtk3::Window pdf] |  [GtkWindow.html][GtkWindow]

## Release notes
* [Release notes][release]

## Miscellaneous
* [Release notes][release]

# TODO

# Versions of involved software

* Program is tested against the latest version of **perl6** on **rakudo** en **moarvm**.
* Gtk library used **Gtk >= 3.24**.


# Installation
There are several crossing dependencies from one package to the other because it was one package in the past. To get all packages, just install the `Gnome::Gtk3` package and the rest will be installed with it.

`zef install Gnome::Gtk3`

# Issues

There are always some problems! If you find one, please help by filing an issue at [my github project](https://github.com/MARTIMM/perl6-gnome-gtk3/issues).

# Attribution
* First of all, I would like to thank the developers of the `GTK::Simple` project because of the information I got while reading the code. Also because one of the files is copied unaltered for which I did not had to think about to get that right. The examples in that project are also useful to compare code with each other and to see what is or is not possible.
* The inventors of Perl6 of course and the writers of the documentation which help me out every time again and again.
* The builders of the GTK+ library and the documentation.
* Other helpful modules for their insight and use.

# Author

Name: **Marcel Timmerman**
Github account name: **MARTIMM**


[//]: # (---- [refs] ----------------------------------------------------------)
[changes]: https://github.com/MARTIMM/perl6-gnome-gtk3/blob/master/CHANGES.md
[logoX]: https://github.com/MARTIMM/perl6-gnome-gtk3/blob/master/doc/images/gtk-logo-100.png
[logo]: docs/images/gtk-logo-100.png
[devel refs]: https://developer.gnome.org/references

[screenshot 1X]: https://github.com/MARTIMM/perl6-gnome-gtk3/blob/master/doc/images/examples/01-hello-world.png
[screenshot 1]: docs/images/examples/01-hello-world.png
[screenshot 2]: https://github.com/MARTIMM/perl6-gnome-gtk3/blob/master/doc/images/examples/16a-level-bar.png
[screenshot 3]: https://github.com/MARTIMM/perl6-gnome-gtk3/blob/master/doc/images/examples/16b-level-bar.png
[screenshot 4]: https://github.com/MARTIMM/perl6-gnome-gtk3/blob/master/doc/images/examples/ex-GtkScale.png


[GtkAboutDialog]: https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html
[GtkBin]: https://developer.gnome.org/gtk3/stable/GtkBin.html
[GtkBuilder]: https://developer.gnome.org/gtk3/stable/GtkBuilder.html
[GtkBox]: https://developer.gnome.org/gtk3/stable/GtkBox.html
[GtkButton]: https://developer.gnome.org/gtk3/stable/GtkButton.html
[GtkCheckButton]: https://developer.gnome.org/gtk3/stable/GtkCheckButton.html
[GtkComboBox]: https://developer.gnome.org/gtk3/stable/GtkComboBox.html
[GtkComboBoxText]: https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html
[GtkColorButton]: https://developer.gnome.org/gtk3/stable/GtkColorButton.html
[GtkColorChooser]: https://developer.gnome.org/gtk3/stable/GtkColorChooser.html
[GtkColorChooserDialog]: https://developer.gnome.org/gtk3/stable/GtkColorChooserDialog.html
[GtkColorChooserWidget]: https://developer.gnome.org/gtk3/stable/GtkColorChooserWidget.html
[GtkContainer]: https://developer.gnome.org/gtk3/stable/GtkContainer.html
[GtkCssProvider]: https://developer.gnome.org/gtk3/stable/GtkCssProvider.html
[GtkDialog]: https://developer.gnome.org/gtk3/stable/GtkDialog.html
[GtkEntry]: https://developer.gnome.org/gtk3/stable/GtkEntry.html
[GtkFileChooser]: https://developer.gnome.org/gtk3/stable/GtkFileChooser.html
[GtkFileChooserDialog]: https://developer.gnome.org/gtk3/stable/GtkFileChooserDialog.html
[GtkFileFilter]: https://developer.gnome.org/gtk3/stable/GtkFileFilter.html
[GtkGrid]: https://developer.gnome.org/gtk3/stable/GtkGrid.html
[GtkImage]: https://developer.gnome.org/gtk3/stable/GtkImage.html
[GtkImageMenuItem]: https://developer.gnome.org/gtk3/stable/GtkImageMenuItem.html
[GtkLabel]: https://developer.gnome.org/gtk3/stable/GtkLabel.html
[GtkLevelBar]: https://developer.gnome.org/gtk3/stable/GtkLevelBar.html
[GtkListBox]: https://developer.gnome.org/gtk3/stable/GtkListBox.html
[GtkMain]: https://developer.gnome.org/gtk3/stable/gtk3-General.html
[GtkMenuItem]: https://developer.gnome.org/gtk3/stable/GtkMenuItem.html
[GtkOrientable]: https://developer.gnome.org/gtk3/stable/gtk3-Orientable.html
[GtkPaned]: https://developer.gnome.org/gtk3/stable/GtkPaned.html
[GtkRadioButton]: https://developer.gnome.org/gtk3/stable/GtkRadioButton.html
[GtkRange]: https://developer.gnome.org/gtk3/stable/GtkRange.html
[GtkStyleContext]: https://developer.gnome.org/gtk3/stable/GtkStyleContext.html
[GtkScale]: https://developer.gnome.org/gtk3/stable/GtkScale.html
[GtkTextBuffer]: https://developer.gnome.org/gtk3/stable/GtkTextBuffer.html
[GtkTextTagTable]: https://developer.gnome.org/gtk3/stable/GtkTextTagTable.html
[GtkTextView]: https://developer.gnome.org/gtk3/stable/GtkTextView.html
[GtkToggleButton]: https://developer.gnome.org/gtk3/stable/GtkToggleButton.html
[GtkWidget]: https://developer.gnome.org/gtk3/stable/GtkWidget.html
[GtkWindow]: https://developer.gnome.org/gtk3/stable/GtkWindow.html

[//]: # (Pod documentation rendered with)
[//]: # (pod-render.pl6 --pdf --g=MARTIMM/perl6-gnome-gtk3 lib)
[Gnome::Gtk3::AboutDialog html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/AboutDialog.html
[Gnome::Gtk3::AboutDialog pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/AboutDialog.pdf
[Gnome::Gtk3::Bin html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Bin.html
[Gnome::Gtk3::Bin pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Bin.pdf
[Gnome::Gtk3::Builder html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Builder.html
[Gnome::Gtk3::Builder pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Builder.pdf
[Gnome::Gtk3::Button html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Button.html
[Gnome::Gtk3::Button pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Button.pdf
[Gnome::Gtk3::CheckButton html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/CheckButton.html
[Gnome::Gtk3::CheckButton pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/CheckButton.pdf
[Gnome::Gtk3::ColorButton pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/ColorButton.pdf
[Gnome::Gtk3::ColorChooserDialog pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/ColorChooserDialog.pdf
[Gnome::Gtk3::ComboBox html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/ComboBox.html
[Gnome::Gtk3::ComboBox pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/ComboBox.pdf
[Gnome::Gtk3::ComboBoxText html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/ComboBoxText.html
[Gnome::Gtk3::ComboBoxText pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/ComboBoxText.pdf
[Gnome::Gtk3::Dialog html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Dialog.html
[Gnome::Gtk3::Dialog pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Dialog.pdf
[Gnome::Gtk3::Enums html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Enums.html
[Gnome::Gtk3::Enums pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Enums.pdf
[Gnome::Gtk3::FileChooser html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/FileChooser.html
[Gnome::Gtk3::FileChooser pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/FileChooser.pdf
[Gnome::Gtk3::FileChooserDialog html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/FileChooserDialog.html
[Gnome::Gtk3::FileChooserDialog pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/FileChooserDialog.pdf
[Gnome::Gtk3::LevelBar html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/LevelBar.html
[Gnome::Gtk3::LevelBar pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/LevelBar.pdf
[Gnome::Gtk3::Main html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Main.html
[Gnome::Gtk3::Main pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Main.pdf
[Gnome::Gtk3::Orientable html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Orientable.html
[Gnome::Gtk3::Orientable pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Orientable.pdf
[Gnome::Gtk3::Paned html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Paned.html
[Gnome::Gtk3::Paned pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Paned.pdf
[Gnome::Gtk3::Range html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Range.html
[Gnome::Gtk3::Range pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Range.pdf
[Gnome::Gtk3::Scale html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Scale.html
[Gnome::Gtk3::Scale pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Scale.pdf
[Gnome::Gtk3::ToggleButton html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/ToggleButton.html
[Gnome::Gtk3::ToggleButton pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/ToggleButton.pdf
[Gnome::Gtk3::Widget html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Widget.html
[Gnome::Gtk3::Widget pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Widget.pdf
[Gnome::Gtk3::Window html]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Window.html
[Gnome::Gtk3::Window pdf]: https://nbviewer.jupyter.org/github/MARTIMM/perl6-gnome-gtk3/blob/master/doc/Window.pdf
