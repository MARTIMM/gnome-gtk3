Gnome::Gtk3::FileChooserButton
==============================

A button to launch a file selection dialog

![](images/file-button.png)

Description
===========

The **Gnome::Gtk3::FileChooserButton** is a widget that lets the user select a file. It implements the **Gnome::Gtk3::FileChooser** interface. Visually, it is a file name with a button to bring up a **Gnome::Gtk3::FileChooserDialog**. The user can then use that dialog to change the file associated with that button. This widget does not support setting the *select-multiple* property to `1`.

The **Gnome::Gtk3::FileChooserButton** supports the **GtkFileChooserAction**s (from **Gnome::Gtk3::FileChooser**) `GTK_FILE_CHOOSER_ACTION_OPEN` and `GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER`.

The **Gnome::Gtk3::FileChooserButton** will ellipsize the label, and will thus request little horizontal space. To give the button more space, you should call `gtk_widget_get_preferred_size()`, `gtk_file_chooser_button_set_width_chars()`, or pack the button in such a way that other interface elements give space to the widget.

Css Nodes
---------

**Gnome::Gtk3::FileChooserButton** has a CSS node with name “filechooserbutton”, containing a subnode for the internal button with name “button” and style class “.file”.

See Also
--------

**Gnome::Gtk3::FileChooserDialog**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::FileChooserButton;
    also is Gnome::Gtk3::Box;
    also does Gnome::Gtk3::FileChooser;

![](plantuml/FileChooserButton.svg)

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::FileChooserButton;

    unit class MyGuiClass;
    also is Gnome::Gtk3::FileChooserButton;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::FileChooserButton class process the options
      self.bless( :GtkFileChooserButton, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Example
-------

Create a button to let the user select a file in /etc

    use Gnome::Gtk3::FileChooser;
    use Gnome::Gtk3::FileChooserButton;

    my Gnome::Gtk3::FileChooserButton $button .= new(
      :title('Select a file'), :action(GTK_FILE_CHOOSER_ACTION_OPEN)
    );
    $button.set-current-folder("/etc");

Methods
=======

new
---

### new( :title, :action)

Create a new FileChooserButton object.

    multi method new (
      Str :$title!, GtkFileChooserAction,
      GtkFileChooserAction :$action = GTK_FILE_CHOOSER_ACTION_OPEN
    )

### :native-object

Create an object using a native object from elsewhere. See also **Gnome::N::TopLevelSupportClass**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

get-title
---------

Retrieves the title of the browse dialog used by *button*. The returned value should not be modified or freed.

Returns: a pointer to the browse dialog’s title.

    method get-title ( --> Str )

get-width-chars
---------------

Retrieves the width in characters of the *button* widget’s entry and/or label.

Returns: an integer width (in characters) that the button will use to size itself.

    method get-width-chars ( --> Int )

set-title
---------

Modifies the *title* of the browse dialog used by *button*.

    method set-title ( Str $title )

  * $title; the new browse dialog title.

set-width-chars
---------------

Sets the width (in characters) that *button* will use to *n_chars*.

    method set-width-chars ( Int() $n_chars )

  * $n_chars; the new width, in characters.

Signals
=======

file-set
--------

The *file-set* signal is emitted when the user selects a file.

Note that this signal is only emitted when the user changes the file.

    method handler (
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

Properties
==========

dialog
------

The file chooser dialog to use.

  * **Gnome::GObject::Value** type of this property is G_TYPE_OBJECT

  * The type of this G_TYPE_OBJECT object is GTK_TYPE_FILE_CHOOSER

  * Parameter is writable.

  * Parameter is set on construction of object.

title
-----

The title of the file chooser dialog.

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is readable and writable.

  * Default value is _(DEFAULT_TITLE.

width-chars
-----------

The desired width of the button widget, in characters.

  * **Gnome::GObject::Value** type of this property is G_TYPE_INT

  * Parameter is readable and writable.

  * Minimum value is -1.

  * Maximum value is G_MAXINT.

  * Default value is -1.

