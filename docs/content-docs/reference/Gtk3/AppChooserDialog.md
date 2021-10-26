Gnome::Gtk3::AppChooserDialog
=============================

An application chooser dialog

![](images/appchooserdialog.png)

Description
===========

**Gnome::Gtk3::AppChooserDialog** shows a **Gnome::Gtk3::AppChooserWidget** inside a **Gnome::Gtk3::Dialog**.

Note that **Gnome::Gtk3::AppChooserDialog** does not have any interesting methods of its own. Instead, you should get the embedded **Gnome::Gtk3::AppChooserWidget** using `get-widget()` and call its methods if the generic **Gnome::Gtk3::AppChooser** interface is not sufficient for your needs.

To set the heading that is shown above the **Gnome::Gtk3::AppChooserWidget**, use `gtk-app-chooser-dialog-set-heading()`.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::AppChooserDialog;
    also is Gnome::Gtk3::Dialog;
    also does Gnome::Gtk3::AppChooser;

Uml Diagram
-----------

![](plantuml/AppChooserDialog.svg)

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::AppChooserDialog;

    unit class MyGuiClass;
    also is Gnome::Gtk3::AppChooserDialog;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::AppChooserDialog class process the options
      self.bless( :GtkAppChooserDialog, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Methods
=======

new
---

### :file, :flags, :parent

Creates a new **Gnome::Gtk3::AppChooserDialog** for the provided file, to allow the user to select an application for it.

    multi method new (
      Str :$file!, Gnome::GObject::Object :$parent = N-GObject,
      UInt :$flags = 0
    )

  * Str $file; a path to a file.

  * N-GObject $parent; Transient parent of the dialog, or `undefined`.

  * UInt $flags; flags for this dialog. Default is GTK_DIALOG_MODAL which is from GtkDialogFlags enumeration found in **Gnome::Gtk3::Dialog**.

**Note**: When files are provided without an extension (or maybe other reasons), Gnome somehow cannot find out the content type of the file and throws critical errors like

    (AppChooserDialog.t:646972): GLib-GIO-CRITICAL **: 13:27:01.077: g_file_info_get_content_type: assertion 'G_IS_FILE_INFO (info)' failed

### :content-type, :flags

Creates a new **Gnome::Gtk3::AppChooserDialog** for the provided content type, to allow the user to select an application for it.

    multi method new (
      Str :$content-type!, UInt :$flags = GTK_DIALOG_MODAL,
      Gnome::GObject::Object :$parent = N-GObject,
    )

  * Str $content-type; a content type to handle.

  * N-GObject $parent; Transient parent of the dialog, or `undefined`.

  * UInt $flags; flags for this dialog. Default is GTK_DIALOG_MODAL which is from GtkDialogFlags enumeration found in **Gnome::Gtk3::Dialog**.

### :native-object

Create a AppChooserDialog object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a AppChooserDialog object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

get-heading
-----------

Returns the text to display at the top of the dialog.

Returns: the text to display at the top of the dialog, or `undefined`, in which case a default text is displayed

    method get-heading ( --> Str )

get-widget, get-widget-rk
-------------------------

Returns the **Gnome::Gtk3::AppChooserWidget** of this dialog.

    method get-widget ( --> N-GObject )
    method get-widget-rk ( --> Gnome::Gtk3::AppChooserWidget )

set-heading
-----------

Sets the text to display at the top of the dialog. If the heading is not set, the dialog displays a default text.

    method set-heading ( Str $heading )

  * Str $heading; a string containing Pango markup

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **.set-text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.get-property( 'label', $gv);
    $gv.set-string('my text label');

Supported properties
--------------------

### PROP_GFILE: g_object_class_install_property (gobject_class

    g-object-class-install-property (gobject-class, PROP-GFILE, pspec);
    /**

The text to show at the top of the dialog. * The string may contain Pango markup. The **Gnome::GObject::Value** type of property * g_object_class_install_property (gobject_class* is `G_TYPE_`.

