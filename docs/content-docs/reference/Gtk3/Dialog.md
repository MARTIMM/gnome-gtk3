Gnome::Gtk3::Dialog
===================

Create popup windows

Description
===========

Dialog boxes are a convenient way to prompt the user for a small amount of input, e.g. to display a message, ask a question, or anything else that does not require extensive effort on the user’s part.

GTK+ treats a dialog as a window split vertically. The top section is a VBox, and is where widgets such as a **Gnome::Gtk3::Label** or a be packed. The bottom area is known as the “action area”. This is generally used for packing buttons into the dialog which may perform functions such as cancel, ok, or apply.

**Gnome::Gtk3::Dialog** boxes are created with a call to `gtk_dialog_new()` or `gtk_dialog_new_with_buttons()`. `gtk_dialog_new_with_buttons()` is recommended; it allows you to set the dialog title, some convenient flags, and add simple buttons.

If “dialog” is a newly created dialog, the two primary areas of the window can be accessed through `gtk_dialog_get_content_area()` and `gtk_dialog_get_action_area()`, as can be seen from the example below.

A “modal” dialog (that is, one which freezes the rest of the application from user input), can be created by calling `gtk_window_set_modal()` on the dialog. Use the `GTK_WINDOW()` macro to cast the widget returned from `gtk_dialog_new()` into a **Gnome::Gtk3::Window**. When using `gtk_dialog_new_with_buttons()` you can also pass the **GTK_DIALOG_MODAL** flag to make a dialog modal.

If you add buttons to **Gnome::Gtk3::Dialog** using `gtk_dialog_new_with_buttons()`, `gtk_dialog_add_button()`, `gtk_dialog_add_buttons()`, or `gtk_dialog_add_action_widget()`, clicking the button will emit a signal called *response* with a response ID that you specified. GTK+ will never assign a meaning to positive response IDs; these are entirely user-defined. But for convenience, you can use the response IDs in the **Gnome::Gtk3::ResponseType** enumeration (these all have values less than zero). If a dialog receives a delete event, the *response* signal will be emitted with a response ID of **GTK_RESPONSE_DELETE_EVENT**.

If you want to block waiting for a dialog to return before returning control flow to your code, you can call `gtk_dialog_run()`. This function enters a recursive main loop and waits for the user to respond to the dialog, returning the response ID corresponding to the button the user clicked.

For the simple dialog in the following example, in reality you’d probably use **Gnome::Gtk3::MessageDialog** to save yourself some effort. But you’d need to create the dialog contents manually if you had more than a simple message in the dialog.

An example for simple **Gnome::Gtk3::Dialog** usage:

    method quick-message ( Gnome::Gtk3::Window $parent, Str $message ) {

      my Gnome::Gtk3::Dialog $dialog .= new(
        :title<Message>, :$parent, :flags(GTK_DIALOG_DESTROY_WITH_PARENT),
        :button-spec( "Ok", GTK_RESPONSE_NONE)
      );

      my $content-area = $dialog.get-content-area;
      my Gnome::Gtk3::Label $label .= new(:label($message));
      $dialog.gtk_container_add($label);

      # Show the dialog. After return (Ok pressed) the dialog widget
      # is destroyed. show-all() must be called, otherwise the message
      # will not be seen.
      $dialog.show-all;
      $dialog.gtk-dialog-run;
      $dialog.gtk_widget_destroy;
    }

Gnome::Gtk3::Dialog as Gnome::Gtk3::Buildable
---------------------------------------------

The **Gnome::Gtk3::Dialog** implementation of the **Gnome::Gtk3::Buildable** interface exposes the *vbox* and *action_area* as internal children with the names “vbox” and “action_area”.

**Gnome::Gtk3::Dialog** supports a custom <action-widgets> element, which can contain multiple <action-widget> elements. The “response” attribute specifies a numeric response, and the content of the element is the id of widget (which should be a child of the dialogs *action_area*). To mark a response as default, set the “default“ attribute of the <action-widget> element to true.

**Gnome::Gtk3::Dialog** supports adding action widgets by specifying “action“ as the “type“ attribute of a <child> element. The widget will be added either to the action area or the headerbar of the dialog, depending on the “use-header-bar“ property. The response id has to be associated with the action widget using the <action-widgets> element.

An example of a dialog UI definition fragment:

    <object class="GtkDialog" id="dialog1">
      <child type="action">
        <object class="GtkButton" id="button_cancel"/>
      </child>
      <child type="action">
        <object class="GtkButton" id="button_ok">
          <property name="can-default">True</property>
        </object>
      </child>
      <action-widgets>
        <action-widget response="cancel">button_cancel</action-widget>
        <action-widget response="ok" default="true">button_ok</action-widget>
      </action-widgets>
    </object>

See Also
--------

**Gnome::Gtk3::VBox**, **Gnome::Gtk3::Window**, **Gnome::Gtk3::Button**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Dialog;
    also is Gnome::Gtk3::Window;
    also does Gnome::Gtk3::Buildable;

Example
-------

    my Gnome::Gtk3::Dialog $dialog .= new(:build-id<simple-dialog>);

    # show the dialog
    my Int $response = $dialog.gtk-dialog-run;
    if $response == GTK_RESPONSE_ACCEPT {
    ...
    }

Types
=====

enum GtkDialogFlags
-------------------

Flags used to influence dialog construction.

  * GTK_DIALOG_MODAL: Make the constructed dialog modal, see `gtk_window_set_modal()`

  * GTK_DIALOG_DESTROY_WITH_PARENT: Destroy the dialog when its parent is destroyed, see `gtk_window_set_destroy_with_parent()`

  * GTK_DIALOG_USE_HEADER_BAR: Create dialog with actions in header bar instead of action area. Since 3.12.

enum GtkResponseType
--------------------

Predefined values for use as response ids in `gtk_dialog_add_button()`. All predefined values are negative; GTK+ leaves values of 0 or greater for application-defined response ids.

  * GTK_RESPONSE_NONE: Returned if an action widget has no response id, or if the dialog gets programmatically hidden or destroyed

  * GTK_RESPONSE_REJECT: Generic response id, not used by GTK+ dialogs

  * GTK_RESPONSE_ACCEPT: Generic response id, not used by GTK+ dialogs

  * GTK_RESPONSE_DELETE_EVENT: Returned if the dialog is deleted

  * GTK_RESPONSE_OK: Returned by OK buttons in GTK+ dialogs

  * GTK_RESPONSE_CANCEL: Returned by Cancel buttons in GTK+ dialogs

  * GTK_RESPONSE_CLOSE: Returned by Close buttons in GTK+ dialogs

  * GTK_RESPONSE_YES: Returned by Yes buttons in GTK+ dialogs

  * GTK_RESPONSE_NO: Returned by No buttons in GTK+ dialogs

  * GTK_RESPONSE_APPLY: Returned by Apply buttons in GTK+ dialogs

  * GTK_RESPONSE_HELP: Returned by Help buttons in GTK+ dialogs

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :empty! )

Create a dialog with title flags and buttons. It uses `gtk_dialog_new_with_buttons()` to create the dialog.

    multi method new (
      Str :$title!, Gnome::GObject::Object :$parent, Int :$flags,
      List :$buttons-spec
    )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_dialog_new
--------------

Creates a new dialog box.

Widgets should not be packed into this **Gnome::Gtk3::Window** directly, but into the *vbox* and *action_area*, as described above.

Returns: the new dialog as a **Gnome::Gtk3::Widget**

    method gtk_dialog_new ( --> N-GObject  )

[gtk_dialog_] new_with_buttons
------------------------------

Creates a new **Gnome::Gtk3::Dialog** with title *$title* (or `Any` for the default title; see `gtk_window_set_title()`) and transient parent *$parent* (or `Any` for none; see `gtk_window_set_transient_for()`). The *$flags* argument can be used to make the dialog modal (**GTK_DIALOG_MODAL**) and/or to have it destroyed along with its transient parent (**GTK_DIALOG_DESTROY_WITH_PARENT**). After *$flags*, button text/response ID pairs should be listed, with a `Any` pointer ending the list. Button text can be arbitrary text. A response ID can be any positive number, or one of the values in the **GtkResponseType** enumeration. If the user clicks one of these dialog buttons, **Gnome::Gtk3::Dialog** will emit the *response* signal with the corresponding response ID. If a **Gnome::Gtk3::Dialog** receives the *delete-event* signal, it will emit *response* with a response ID of **GTK_RESPONSE_DELETE_EVENT**. However, destroying a dialog does not emit the *response* signal; so be careful relying on *response* when using the **GTK_DIALOG_DESTROY_WITH_PARENT** flag. Buttons are from left to right, so the first button in the list will be the leftmost button in the dialog.

Here’s a simple example:

    my $dialog = gtk_dialog_new_with_buttons(
      "My dialog", $top-window,
      GTK_DIALOG_MODAL +| GTK_DIALOG_DESTROY_WITH_PARENT,
      'Ok', GTK_RESPONSE_ACCEPT, "Cancel", GTK_RESPONSE_REJECT
    );

Returns: a new native Dialog.

    method gtk_dialog_new_with_buttons (
      Str $title, N-GObject $parent, Int $flags,
      *@buttons-spec
      --> N-GObject
    )

  * Str $title; (allow-none): Title of the dialog, or `Any`.

  * N-GObject $parent; Transient parent of the dialog, or `Any`.

  * Int $flags. A mask of GtkDialogFlags values.

  * *@buttons-spec is a list button specifications. The list has an even number of members of which;

    * Str $button-label to go on the button.

    * $response-code, an Int, GtkResponseType or other enum (with int values) to return for the button. Taking a GtkResponseType will help the chooser dialog make a proper decision if needed. Otherwise, the user can always check codes returned by the dialog to find out what to do next.

[gtk_dialog_] add_action_widget
-------------------------------

Adds an activatable widget to the action area of a **Gnome::Gtk3::Dialog**, connecting a signal handler that will emit the *response* signal on the dialog when the widget is activated. The widget is appended to the end of the dialog’s action area. If you want to add a non-activatable widget, simply pack it into the *action_area* field of the **Gnome::Gtk3::Dialog** struct.

    method gtk_dialog_add_action_widget ( N-GObject $child, Int $response_id )

  * N-GObject $child; an activatable widget

  * Int $response_id; response ID for *child*

[gtk_dialog_] add_button
------------------------

Adds a button with the given text and sets things up so that clicking the button will emit the *response* signal with the given *response_id*. The button is appended to the end of the dialog’s action area. The button widget is returned, but usually you don’t need it.

Returns: (transfer none): the **Gnome::Gtk3::Button** widget that was added

    method gtk_dialog_add_button ( Str $button_text, Int $response_id --> N-GObject  )

  * Str $button_text; text of button

  * Int $response_id; response ID for the button

[gtk_dialog_] set_response_sensitive
------------------------------------

Calls `gtk_widget_set_sensitive (widget, *setting*)` for each widget in the dialog’s action area with the given *response_id*. A convenient way to sensitize/desensitize dialog buttons.

    method gtk_dialog_set_response_sensitive ( Int $response_id, Int $setting )

  * Int $response_id; a response ID

  * Int $setting; `1` for sensitive

[gtk_dialog_] set_default_response
----------------------------------

Sets the last widget in the dialog’s action area with the given *response_id* as the default widget for the dialog. Pressing “Enter” normally activates the default widget.

    method gtk_dialog_set_default_response ( Int $response_id )

  * Int $response_id; a response ID

[gtk_dialog_] get_widget_for_response
-------------------------------------

Gets the widget button that uses the given response ID in the action area of a dialog.

Returns: (nullable) (transfer none): the *widget* button that uses the given *response_id*, or `Any`.

Since: 2.20

    method gtk_dialog_get_widget_for_response ( Int $response_id --> N-GObject  )

  * Int $response_id; the response ID used by the *dialog* widget

[gtk_dialog_] get_response_for_widget
-------------------------------------

Gets the response id of a widget in the action area of a dialog.

Returns: the response id of *widget*, or `GTK_RESPONSE_NONE` if *widget* doesn’t have a response id set.

Since: 2.8

    method gtk_dialog_get_response_for_widget ( N-GObject $widget --> Int  )

  * N-GObject $widget; a widget in the action area of *dialog*

gtk_dialog_response
-------------------

Emits the *response* signal with the given response ID. Used to indicate that the user has responded to the dialog in some way; typically either you or `gtk_dialog_run()` will be monitoring the *response* signal and take appropriate action.

    method gtk_dialog_response ( Int $response_id )

  * Int $response_id; response ID

gtk_dialog_run
--------------

Blocks in a recursive main loop until the dialog either emits the *response* signal, or is destroyed. If the dialog is destroyed during the call to `gtk_dialog_run()`, `gtk_dialog_run()` returns **GTK_RESPONSE_NONE**. Otherwise, it returns the response ID from the *response* signal emission.

Before entering the recursive main loop, `gtk_dialog_run()` calls `gtk_widget_show()` on the dialog for you. Note that you still need to show any children of the dialog yourself.

During `gtk_dialog_run()`, the default behavior of *delete-event* is disabled; if the dialog receives a *delete_event*, it will not be destroyed as windows usually are, and `gtk_dialog_run()` will return **GTK_RESPONSE_DELETE_EVENT**. Also, during `gtk_dialog_run()` the dialog will be modal. You can force `gtk_dialog_run()` to return at any time by calling `gtk_dialog_response()` to emit the *response* signal. Destroying the dialog during `gtk_dialog_run()` is a very bad idea, because your post-run code won’t know whether the dialog was destroyed or not.

After `gtk_dialog_run()` returns, you are responsible for hiding or destroying the dialog if you wish to do so.

Typical usage of this function might be:

    given GtkResponseType($dialog.gtk-dialog-run) {
      when GTK_RESPONSE_ACCEPT {
        do_application_specific_something();
      }

      default {
        do_nothing_since_dialog_was_cancelled();
      }
    }

    $dialog.gtk_widget_destroy;

Note that even though the recursive main loop gives the effect of a modal dialog (it prevents the user from interacting with other windows in the same window group while the dialog is run), callbacks such as timeouts, IO channel watches, DND drops, etc, will be triggered during a `gtk_dialog_run()` call.

Returns: response ID

    method gtk_dialog_run ( --> Int  )

[gtk_dialog_] get_content_area
------------------------------

Returns the content area of *dialog*.

Returns: (type **Gnome::Gtk3::.Box**) the content area **Gnome::Gtk3::Box**.

Since: 2.14

    method gtk_dialog_get_content_area ( --> N-GObject  )

[gtk_dialog_] get_header_bar
----------------------------

Returns the header bar of *dialog*. Note that the headerbar is only used by the dialog if the *use-header-bar* property is `1`.

Returns: (transfer none): the header bar

Since: 3.12

    method gtk_dialog_get_header_bar ( --> N-GObject  )

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `g_signal_connect_object()` directly from **Gnome::GObject::Signal**.

First method
------------

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes `:$widget` and user data are optional.

    # handler method
    method mouse-event ( GdkEvent $event, :$widget ) { ... }

    # connect a signal on window object
    my Gnome::Gtk3::Window $w .= new( ... );
    $w.register-signal( self, 'mouse-event', 'button-press-event');

Second method
-------------

    my Gnome::Gtk3::Window $w .= new( ... );
    my Callable $handler = sub (
      N-GObject $native, GdkEvent $event, OpaquePointer $data
    ) {
      ...
    }

    $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `g_signal_connect_object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### response

Emitted when an action widget is clicked, the dialog receives a delete event, or the application programmer calls `gtk_dialog_response()`. On a delete event, the response ID is **GTK_RESPONSE_DELETE_EVENT**. Otherwise, it depends on which action widget was clicked.

    method handler (
      Int $response_id,
      Gnome::GObject::Object :widget($dialog),
      *%user-options
    );

  * $dialog; the object on which the signal is emitted

  * $response_id; the response ID

### close

The *close* signal is a keybinding signal which gets emitted when the user uses a keybinding to close the dialog.

The default binding for this signal is the Escape key.

    method handler (
      Gnome::GObject::Object :widget($dialog),
      *%user-options
    );

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Content area border

The default border width used around the content area of the dialog, as returned by `gtk_dialog_get_content_area()`, unless `gtk_container_set_border_width()` was called on that widget directly.

The **Gnome::GObject::Value** type of property *content-area-border* is `G_TYPE_INT`.

