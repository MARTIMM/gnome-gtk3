TITLE
=====

Gnome::Gtk3::Dialog

SUBTITLE
========



    unit class Gnome::Gtk3::Dialog;
    also is Gnome::Gtk3::Window;

#=head2 Dialog — Create popup windows

Synopsis
========

    my Gnome::Gtk3::Dialog $dialog .= new(:build-id<simple-dialog>);

    # show the dialog
    my Int $response = $dialog.gtk-dialog-run;
    if $response == GTK_RESPONSE_ACCEPT {
      ...
    }

unit class Gnome::Gdk3::Events;git also is Gnome::Gtk3::Window;
===============================================================

Types
=====

enum GtkResponseType
--------------------

Possible types of response

<table class="pod-table">
<thead><tr>
<th>Response type</th> <th>When</th>
</tr></thead>
<tbody>
<tr> <td>GTK_RESPONSE_NONE</td> <td>Returned if an action widget has no response id, or if the dialog gets programmatically hidden or destroyed</td> </tr> <tr> <td>GTK_RESPONSE_REJECT</td> <td>Generic response id, not used by GTK+ dialogs</td> </tr> <tr> <td>GTK_RESPONSE_ACCEPT</td> <td>Generic response id, not used by GTK+ dialogs</td> </tr> <tr> <td>GTK_RESPONSE_DELETE_EVENT</td> <td>Returned if the dialog is deleted</td> </tr> <tr> <td>GTK_RESPONSE_OK</td> <td>Returned by OK buttons in GTK+ dialogs</td> </tr> <tr> <td>GTK_RESPONSE_CANCEL</td> <td>Returned by Cancel buttons in GTK+ dialogs</td> </tr> <tr> <td>GTK_RESPONSE_CLOSE</td> <td>Returned by Close buttons in GTK+ dialogs</td> </tr> <tr> <td>GTK_RESPONSE_YES</td> <td>Returned by Yes buttons in GTK+ dialogs</td> </tr> <tr> <td>GTK_RESPONSE_NO</td> <td>Returned by No buttons in GTK+ dialogs</td> </tr> <tr> <td>GTK_RESPONSE_APPLY</td> <td>Returned by Apply buttons in GTK+ dialogs</td> </tr> <tr> <td>GTK_RESPONSE_HELP</td> <td>Returned by Help buttons in GTK+ dialogs</td> </tr>
</tbody>
</table>

Methods
=======

gtk_dialog_new
--------------

Creates a new dialog box.

gtk_dialog_run
--------------

Blocks in a recursive main loop until the dialog either emits the “response” signal, or is destroyed. If the dialog is destroyed during the call to gtk_dialog_run(), gtk_dialog_run() returns GTK_RESPONSE_NONE

gtk_dialog_response
-------------------

Emits the “response” signal with the given response ID. Used to indicate that the user has responded to the dialog in some way; typically either you or gtk_dialog_run() will be monitoring the ::response signal and take appropriate action.

new
---

    multi method new ( Bool :$empty! )

Create an empty dialog

    multi method new ( :$widget! )

Create a dialog using a native object from elsewhere. See also Gnome::GObject::Object.

    multi method new ( Str :$build-id! )

Create a dialog using a native object from a builder. See also Gnome::GObject::Object.

