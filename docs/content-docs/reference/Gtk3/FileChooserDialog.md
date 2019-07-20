TITLE
=====

Gnome::Gtk3::FileChooserDialog

SUBTITLE
========



    unit class Gnome::Gtk3::FileChooserDialog;
    also is Gnome::Gtk3::Dialog;

FileChooserDialog — A file chooser dialog
-----------------------------------------

Synopsis
========

    use Gnome::Gtk3::Dialog;
    use Gnome::Gtk3::FileChooserDialog;

    my Gnome::Gtk3::FileChooserDialog $fchoose .= new(:build-id<save-dialog>);

    # show the dialog
    my Int $response = $fchoose.gtk-dialog-run;
    if $response == GTK_RESPONSE_ACCEPT {
      ...
    }

    # when dialog buttons are pressed hide it again
    $fchoose.hide;

Methods
=======

[gtk_file_chooser_] dialog_new_two_buttons
------------------------------------------

    method gtk_file_chooser_dialog_new_two_buttons (
      Str $title, N-GObject $parent-window, int32 $file-chooser-action,
      Str $first_button_text, int32 $first-button-response,
      Str $secnd-button-text, int32 $secnd-button-response,
      OpaquePointer $stopper
      --> N-GObject
    )

Creates a new filechooser dialog widget. It returns a native object which must be stored in another object. Better, shorter and easier is to use `.new(....)`. See info below.

new
---

    multi method new ( Str :$title! )

Create a filechooser dialog with given title. There will be only two buttons `:bt1text` and `:bt2text`. These are by default `Cancel` and `Accept`. There response types are given by `:bt1response` and `:bt2response`. Defaults for these are `GTK_RESPONSE_CANCEL` and `GTK_RESPONSE_ACCEPT` respectively.

The filechooser action is set with `:action` which has `GTK_FILE_CHOOSER_ACTION_OPEN` as its default.

The parent window is set by `:window` and is by default `Any`.

The values are defined in `Gnome::Gtk3::Dialog` and `GtkFileChooser`.

    multi method new ( :$widget! )

Create a filechooser dialog using a native object from elsewhere. See also Gnome::GObject::Object.

    multi method new ( Str :$build-id! )

Create a filechooser dialog using a native object from a builder. See also Gnome::GObject::Object.

