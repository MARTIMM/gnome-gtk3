Gnome::Gtk3::MessageDialog
==========================

A convenient message window

![](images/messagedialog.png)

Description
===========

**Gnome::Gtk3::MessageDialog** presents a dialog with some message text. It’s simply a convenience widget; you could construct the equivalent of **Gnome::Gtk3::MessageDialog** from **Gnome::Gtk3::Dialog** without too much effort, but **Gnome::Gtk3::MessageDialog** saves typing.

One difference from **Gnome::Gtk3::Dialog** is that **Gnome::Gtk3::MessageDialog** sets the *skip-taskbar-hint* property to `1`, so that the dialog is hidden from the taskbar by default.

The easiest way to do a modal message dialog is to use `gtk_dialog_run()`, though you can also pass in the `GTK_DIALOG_MODAL` flag, `gtk_dialog_run()` automatically makes the dialog modal and waits for the user to respond to it. `gtk_dialog_run()` returns when any dialog button is clicked.

**Gnome::Gtk3::MessageDialog** as **Gnome::Gtk3::Buildable**
------------------------------------------------------------

The **Gnome::Gtk3::MessageDialog** implementation of the **Gnome::Gtk3::Buildable** interface exposes the message area as an internal child with the name “message_area”.

See Also
--------

**Gnome::Gtk3::Dialog**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::MessageDialog;
    also is Gnome::Gtk3::Dialog;

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::MessageDialog;

    unit class MyGuiClass;
    also is Gnome::Gtk3::MessageDialog;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::MessageDialog class process the options
      self.bless( :GtkMessageDialog, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Types
=====

enum GtkButtonsType
-------------------

Prebuilt sets of buttons for the dialog. If none of these choices are appropriate, simply use `GTK_BUTTONS_NONE` then call `gtk_dialog_add_buttons()`.

Please note that `GTK_BUTTONS_OK`, `GTK_BUTTONS_YES_NO` and `GTK_BUTTONS_OK_CANCEL` are discouraged by the [GNOME Human Interface Guidelines](http://library.gnome.org/devel/hig-book/stable/).

  * GTK_BUTTONS_NONE: no buttons at all

  * GTK_BUTTONS_OK: an OK button

  * GTK_BUTTONS_CLOSE: a Close button

  * GTK_BUTTONS_CANCEL: a Cancel button

  * GTK_BUTTONS_YES_NO: Yes and No buttons

  * GTK_BUTTONS_OK_CANCEL: OK and Cancel buttons

Methods
=======

new
---

Create a new MessageDialog object.

    multi method new (
      Str :$message!, N-GObject :$parent?, GtkDialogFlags :$flags?,
      GtkMessageType :$type?, GtkButtonsType :$buttons?
      --> N-GObject
    )

    Creates a new message dialog, which is a simple dialog with some text that is marked up with the [Pango text markup language][PangoMarkupFormat].

     multi method new (
       Str :$markup-message!, N-GObject :$parent?, GtkDialogFlags :$flags?,
       GtkMessageType :$type?, GtkButtonsType :$buttons?
       --> N-GObject
     )

  * N-GObject $parent; transient parent, or `Any` for none

  * GtkDialogFlags $flags; flags. Default is GTK_DIALOG_MODAL.

  * GtkMessageType $type; type of message. Default is GTK_MESSAGE_INFO.

  * GtkButtonsType $buttons; set of buttons to use. Default is GTK_BUTTONS_CLOSE.

  * Str $message; a string. XML is converted to proper text.

  * Str $markup-message; a string with Pango markup

Create a MessageDialog object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create a MessageDialog object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_message_dialog_] set_markup
--------------------------------

Sets the text of the message dialog to be *$str*, which is marked up with the [Pango text markup language](PangoMarkupFormathttps://developer.gnome.org/pygtk/stable/pango-markup-language.html). DeleteMsgDialog

    method gtk_message_dialog_set_markup ( Str $str )

  * Str $str; markup string (see [Pango markup format][PangoMarkupFormat])

[gtk_message_dialog_] format_secondary_text
-------------------------------------------

Sets the secondary text of the message dialog to be *$message*. DeleteMsgDialog

    method gtk_message_dialog_format_secondary_text ( Str $message )

  * Str $message; a string

[gtk_message_dialog_] format_secondary_markup
---------------------------------------------

Sets the secondary text of the message dialog to be *$message* (with `printf()`-style), which is marked up with the [Pango text markup language][PangoMarkupFormat].

Due to an oversight, this function does not escape special XML characters like `gtk_message_dialog_new_with_markup()` does.

DeleteMsgDialog

    method gtk_message_dialog_format_secondary_markup ( Str $message )

  * Str $message; a message

[gtk_message_dialog_] get_message_area
--------------------------------------

Returns the message area of the dialog. This is the box where the dialog’s primary and secondary labels are packed. You can add your own extra content to that box and it will appear below those labels. See `gtk_dialog_get_content_area()` for the corresponding function in the parent **Gnome::Gtk3::Dialog**.

Returns: (transfer none): A **Gnome::Gtk3::Box** corresponding to the “message area” in the *message_dialog*. DeleteMsgDialog

    method gtk_message_dialog_get_message_area ( --> N-GObject )

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Message Type

The type of the message. Widget type: GTK_TYPE_MESSAGE_TYPE

The **Gnome::GObject::Value** type of property *message-type* is `G_TYPE_ENUM`.

### Message Buttons

The buttons shown in the message dialog Default value: False

The **Gnome::GObject::Value** type of property *buttons* is `G_TYPE_ENUM`.

### Text

The primary text of the message dialog. If the dialog has a secondary text, this will appear as the title. DeleteMsgDialog

The **Gnome::GObject::Value** type of property *text* is `G_TYPE_STRING`.

### Use Markup

`1` if the primary text of the dialog includes Pango markup. See `pango_parse_markup()`. DeleteMsgDialog

The **Gnome::GObject::Value** type of property *use-markup* is `G_TYPE_BOOLEAN`.

### Secondary Text

The secondary text of the message dialog.DeleteMsgDialog

The **Gnome::GObject::Value** type of property *secondary-text* is `G_TYPE_STRING`.

### Use Markup in secondary

`1` if the secondary text of the dialog includes Pango markup. See `pango_parse_markup()`.DeleteMsgDialog

The **Gnome::GObject::Value** type of property *secondary-use-markup* is `G_TYPE_BOOLEAN`.

### Message area

The **Gnome::Gtk3::Box** that corresponds to the message area of this dialog. See `gtk_message_dialog_get_message_area()` for a detailed description of this area.DeleteMsgDialog Widget type: GTK_TYPE_WIDGET

The **Gnome::GObject::Value** type of property *message-area* is `G_TYPE_OBJECT`.

