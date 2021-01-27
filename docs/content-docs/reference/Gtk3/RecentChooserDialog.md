Gnome::Gtk3::RecentChooserDialog
================================

Displays recently used files in a dialog

![](images/recentchooserdialog.png)

Description
===========

**Gnome::Gtk3::RecentChooserDialog** is a dialog box suitable for displaying the recently used documents. This widgets works by putting a **Gnome::Gtk3::RecentChooserWidget** inside a **Gnome::Gtk3::Dialog**. It exposes the **Gnome::Gtk3::RecentChooserIface** interface, so you can use all the **Gnome::Gtk3::RecentChooser** functions on the recent chooser dialog as well as those for **Gnome::Gtk3::Dialog**.

Note that **Gnome::Gtk3::RecentChooserDialog** does not have any methods of its own. Instead, you can use the functions added by the interface **Gnome::Gtk3::RecentChooser**.

Typical usage
-------------

In the simplest of cases, you can use the following code to use a **Gnome::Gtk3::RecentChooserDialog** to select a recently used file:

    my Gnome::Gtk3::Window $top .= new;
    # … build up application window

    my Gnome::Gtk3::RecentChooserDialog $recent-dialog .= new(
      :title('Recent Documents'), :parent($top),
      :button-spec(
        'Select', GTK_RESPONSE_ACCEPT, "Cancel", GTK_RESPONSE_REJECT
      )
    );

    # … later
    my Int $r = $recent-dialog.run;
    if $r ~~ GTK_RESPONSE_ACCEPT {
      my Gnome::Gtk3::RecentInfo $selected-item = $recent-dialog.get-uri;
      my Str $uri = $selected-item.get-uri;
      $selected-item.clear-object;
      # … do something with $uri
    }

    $recent-dialog.destroy;

See Also
--------

**Gnome::Gtk3::RecentChooser**, **Gnome::Gtk3::Dialog**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::RecentChooserDialog;
    also is Gnome::Gtk3::Dialog;
    also does Gnome::Gtk3::RecentChooser

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::RecentChooserDialog;

    unit class MyGuiClass;
    also is Gnome::Gtk3::RecentChooserDialog;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::RecentChooserDialog class process the options
      self.bless( :GtkRecentChooserDialog, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Methods
=======

new
---

### :title, :parent, :buttons, :manager

Creates a new **Gnome::Gtk3::RecentChooserDialog**. This function is analogous to `new()` from **Gnome::Gtk3::Dialog**.

    multi method new (
      Str :$title!, N-GObject :$parent, N-GObject :$manager,
      List :$button-spec
    )

  * Str $title; Title of the dialog, or undefined

  * N-GObject $parent; Transient parent of the dialog, or undefined,

  * N-GObject $manager; a native **Gnome::Gtk3::RecentManager**.

  * List $button-spec; a ittermittend list of button label and button reponse. The number elements are therefore always and even.number of items. For example: `:button-spec( 'Select', GTK_RESPONSE_ACCEPT, "Cancel", GTK_RESPONSE_REJECT)`

### :native-object

Create a RecentChooserDialog object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a RecentChooserDialog object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

