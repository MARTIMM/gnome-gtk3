TITLE
=====

Gnome::Gtk3::FileChooser

SUBTITLE
========

File chooser interface used by Gnome::Gtk3::FileChooserWidget and Gnome::Gtk3::FileChooserDialog

Description
===========

*Gnome::Gtk3::FileChooser* is an interface that can be implemented by file selection widgets. In GTK+, the main objects that implement this interface are *Gnome::Gtk3::FileChooserWidget*, *Gnome::Gtk3::FileChooserDialog*, and *Gnome::Gtk3::FileChooserButton*. You do not need to write an object that implements the *Gnome::Gtk3::FileChooser* interface unless you are trying to adapt an existing file selector to expose a standard programming interface.

*Gnome::Gtk3::FileChooser* allows for shortcuts to various places in the filesystem. In the default implementation these are displayed in the left pane. It may be a bit confusing at first that these shortcuts come from various sources and in various flavours, so lets explain the terminology here:

  * Bookmarks: are created by the user, by dragging folders from the right pane to the left pane, or by using the “Add”. Bookmarks can be renamed and deleted by the user.

  * Shortcuts: can be provided by the application. For example, a Paint program may want to add a shortcut for a Clipart folder. Shortcuts cannot be modified by the user.

  * Volumes: are provided by the underlying filesystem abstraction. They are the “roots” of the filesystem.

File Names and Encodings
------------------------

When the user is finished selecting files in a *Gnome::Gtk3::FileChooser*, your program can get the selected names either as filenames or as URIs. For URIs, the normal escaping rules are applied if the URI contains non-ASCII characters. However, filenames are always returned in the character set specified by the `G_FILENAME_ENCODING` environment variable. Please see the GLib documentation for more details about this variable.

This means that while you can pass the result of `.get-filename()` to Raku `IO`, you may not be able to directly set it as the text of a *Gnome::Gtk3::Label* widget unless you convert it first to UTF-8, which all GTK+ widgets expect. You should use `g_filename_to_utf8()` to convert filenames into strings that can be passed to GTK+ widgets. **Note: open() and fopen() are C functions which are not needed by the Raku user. Furthermore, the Str Raku type is already UTF-8**.

Adding Extra Widgets
--------------------

You can add extra widgets to a file chooser to provide options that are not present in the default design. For example, you can add a toggle button to give the user the option to open a file in read-only mode. You can use `.set-extra-widget()` to insert additional widgets in a file chooser.

If you want to set more than one extra widget in the file chooser, you can a container such as a *Gnome::Gtk3::Box* or a *Gnome::Gtk3::Grid* and include your widgets in it. Then, set the container as the whole extra widget.

See Also
--------

*Gnome::Gtk3::FileChooserDialog*, *Gnome::Gtk3::FileChooserWidget*, *Gnome::Gtk3::FileChooserButton*

Synopsis
========

Declaration
-----------

    unit role Gnome::Gtk3::FileChooser;
    also is Gnome::GObject::Object;

Example to show how to get filenames from the dialog
----------------------------------------------------

    my Gnome::Gtk3::FileChooserDialog $file-select-dialog .= new(
      :build-id($target-widget-name)
    );

    # get-filenames() is from FileChooser class
    my Gnome::Glib::SList $fnames .= new(
      :native-object($file-select-dialog.get-filenames)
    );

    my @files-to-process = ();
    for ^$fnames.g-slist-length -> $i {
      @files-to-process.push($fnames.nth-data-str($i));
    }

    # get the file and directory names
    for @files-to-process -> $file {
      note "Process $file";
    };

    $fnames.g-slist-free;

Types
=====

enum GtkFileChooserAction
-------------------------

Describes whether a *Gnome::Gtk3::FileChooser* is being used to open existing files or to save to a possibly new file.

  * GTK_FILE_CHOOSER_ACTION_OPEN: Indicates open mode. The file chooser will only let the user pick an existing file.

  * GTK_FILE_CHOOSER_ACTION_SAVE: Indicates save mode. The file chooser will let the user pick an existing file, or type in a new filename.

  * GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER: Indicates an Open mode for selecting folders. The file chooser will let the user pick an existing folder.

  * GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER: Indicates a mode for creating a new folder. The file chooser will let the user name an existing or new folder.

enum GtkFileChooserConfirmation
-------------------------------

Used as a return value of handlers for the prop *confirm-overwrite* signal of a *Gnome::Gtk3::FileChooser*. This value determines whether the file chooser will present the stock confirmation dialog, accept the user’s choice of a filename, or let the user choose another filename.

Since: 2.8

  * GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM: The file chooser will present its stock dialog to confirm about overwriting an existing file.

  * GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME: The file chooser will terminate and accept the user’s choice of a file name.

  * GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN: The file chooser will continue running, so as to let the user select another file name.

enum GtkFileChooserError
------------------------

These identify the various errors that can occur while calling *Gnome::Gtk3::FileChooser* functions.

  * GTK_FILE_CHOOSER_ERROR_NONEXISTENT: Indicates that a file does not exist.

  * GTK_FILE_CHOOSER_ERROR_BAD_FILENAME: Indicates a malformed filename.

  * GTK_FILE_CHOOSER_ERROR_ALREADY_EXISTS: Indicates a duplicate path (e.g. when adding a bookmark).

  * GTK_FILE_CHOOSER_ERROR_INCOMPLETE_HOSTNAME: Indicates an incomplete hostname (e.g. "http://foo" without a slash after that).

Methods
=======

add-choice
----------

Adds a 'choice' to the file chooser. This is typically implemented as a combobox or, for boolean choices, as a checkbutton. You can select a value using `set_choice()` before the dialog is shown, and you can obtain the user-selected value in the *response* signal handler using `get-choice()`.

Compare `set-extra-widget()`.

    method add-choice ( Str $id, Str $label, CArray[Str] $options, CArray[Str] $option_labels )

  * $id; id for the added choice

  * $label; user-visible label for the added choice

  * $options; ids for the options of the choice, or `undefined` for a boolean choice

  * $option_labels; user-visible labels for the options, must be the same length as *options*

add-filter
----------

Adds *filter* to the list of filters that the user can select between. When a filter is selected, only files that are passed by that filter are displayed.

Note that the *chooser* takes ownership of the filter, so you have to ref and sink it if you want to keep a reference.

    method add-filter ( N-GObject() $filter )

  * $filter; a **Gnome::Gtk3::FileFilter**

add-shortcut-folder
-------------------

Adds a folder to be displayed with the shortcut folders in a file chooser. Note that shortcut folders do not get saved, as they are provided by the application. For example, you can use this to add a “/usr/share/mydrawprogram/Clipart” folder to the volume list.

Returns: `True` if the folder could be added successfully, `False` otherwise. In the latter case, the *error* will be set as appropriate.

    method add-shortcut-folder ( Str $folder, N-GError $error --> Bool )

  * $folder; (type filename): filename of the folder to add

  * $error; location to store error, or `undefined`

add-shortcut-folder-uri
-----------------------

Adds a folder URI to be displayed with the shortcut folders in a file chooser. Note that shortcut folders do not get saved, as they are provided by the application. For example, you can use this to add a “file:///usr/share/mydrawprogram/Clipart” folder to the volume list.

Returns: `True` if the folder could be added successfully, `False` otherwise. In the latter case, the *error* will be set as appropriate.

    method add-shortcut-folder-uri ( Str $uri, N-GError $error --> Bool )

  * $uri; URI of the folder to add

  * $error; location to store error, or `undefined`

error-quark
-----------

Registers an error quark for **Gnome::Gtk3::FileChooser** if necessary.

Returns: The error quark used for **Gnome::Gtk3::FileChooser** errors.

    method error-quark ( --> UInt )

get-action
----------

Gets the type of operation that the file chooser is performing; see `set_action()`.

Returns: the action that the file selector is performing

    method get-action ( --> GtkFileChooserAction )

get-choice
----------

Gets the currently selected option in the 'choice' with the given ID.

Returns: the ID of the currenly selected option

    method get-choice ( Str $id --> Str )

  * $id; the ID of the choice to get

get-create-folders
------------------

Gets whether file choser will offer to create new folders. See `set_create_folders()`.

Returns: `True` if the Create Folder button should be displayed.

    method get-create-folders ( --> Bool )

get-current-folder
------------------

Gets the current folder of *chooser* as a local filename. See `set_current_folder()`.

Note that this is the folder that the file chooser is currently displaying (e.g. "/home/username/Documents"), which is not the same as the currently-selected folder if the chooser is in `GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER` mode (e.g. "/home/username/Documents/selected-folder/". To get the currently-selected folder in that mode, use `get_uri()` as the usual way to get the selection.

Returns: (type filename): the full path of the current folder, or `undefined` if the current path cannot be represented as a local filename. Free with `g_free()`. This function will also return `undefined` if the file chooser was unable to load the last folder that was requested from it; for example, as would be for calling `set_current_folder()` on a nonexistent folder.

    method get-current-folder ( --> Str )

get-current-folder-file
-----------------------

Gets the current folder of *chooser* as **Gnome::Gio::File**. See `get_current_folder_uri()`.

Returns: the **Gnome::Gio::File** for the current folder.

    method get-current-folder-file ( --> N-GObject )

get-current-folder-uri
----------------------

Gets the current folder of *chooser* as an URI. See `set_current_folder_uri()`.

Note that this is the folder that the file chooser is currently displaying (e.g. "file:///home/username/Documents"), which is not the same as the currently-selected folder if the chooser is in `GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER` mode (e.g. "file:///home/username/Documents/selected-folder/". To get the currently-selected folder in that mode, use `get_uri()` as the usual way to get the selection.

Returns: the URI for the current folder. Free with `g_free()`. This function will also return `undefined` if the file chooser was unable to load the last folder that was requested from it; for example, as would be for calling `set_current_folder_uri()` on a nonexistent folder.

    method get-current-folder-uri ( --> Str )

get-current-name
----------------

Gets the current name in the file selector, as entered by the user in the text entry for “Name”.

This is meant to be used in save dialogs, to get the currently typed filename when the file itself does not exist yet. For example, an application that adds a custom extra widget to the file chooser for “file format” may want to change the extension of the typed filename based on the chosen format, say, from “.jpg” to “.png”.

Returns: The raw text from the file chooser’s “Name” entry. Free this with `g_free()`. Note that this string is not a full pathname or URI; it is whatever the contents of the entry are. Note also that this string is in UTF-8 encoding, which is not necessarily the system’s encoding for filenames.

    method get-current-name ( --> Str )

get-do-overwrite-confirmation
-----------------------------

Queries whether a file chooser is set to confirm for overwriting when the user types a file name that already exists.

Returns: `True` if the file chooser will present a confirmation dialog; `False` otherwise.

    method get-do-overwrite-confirmation ( --> Bool )

get-extra-widget
----------------

Gets the current extra widget; see `set_extra_widget()`.

Returns: the current extra widget, or `undefined`

    method get-extra-widget ( --> N-GObject )

get-file
--------

Gets the **Gnome::Gio::File** for the currently selected file in the file selector. If multiple files are selected, one of the files will be returned at random.

If the file chooser is in folder mode, this function returns the selected folder.

Returns: a selected **Gnome::Gio::File**. You own the returned file; use `g_object_unref()` to release it.

    method get-file ( --> N-GObject )

get-filename
------------

Gets the filename for the currently selected file in the file selector. The filename is returned as an absolute path. If multiple files are selected, one of the filenames will be returned at random.

If the file chooser is in folder mode, this function returns the selected folder.

Returns: (type filename): The currently selected filename, or `undefined` if no file is selected, or the selected file can't be represented with a local filename. Free with `g_free()`.

    method get-filename ( --> Str )

get-filenames
-------------

Lists all the selected files and subfolders in the current folder of *chooser*. The returned names are full absolute paths. If files in the current folder cannot be represented as local filenames they will be ignored. (See `get_uris()`)

Returns: (element-type filename) : a **Gnome::Gio::SList** containing the filenames of all selected files and subfolders in the current folder. Free the returned list with `g_slist_free()`, and the filenames with `g_free()`.

    method get-filenames ( --> N-GSList )

get-files
---------

Lists all the selected files and subfolders in the current folder of *chooser* as **Gnome::Gio::File**. An internal function, see `get_uris()`.

Returns: (element-type GFile) : a **Gnome::Gio::SList** containing a **Gnome::Gio::File** for each selected file and subfolder in the current folder. Free the returned list with `g_slist_free()`, and the files with `g_object_unref()`.

    method get-files ( --> N-GSList )

get-filter
----------

Gets the current filter; see `set_filter()`.

Returns: the current filter, or `undefined`

    method get-filter ( --> N-GObject )

get-local-only
--------------

Gets whether only local files can be selected in the file selector. See `set_local_only()`

Returns: `True` if only local files can be selected.

    method get-local-only ( --> Bool )

get-preview-file
----------------

Gets the **Gnome::Gio::File** that should be previewed in a custom preview Internal function, see `get_preview_uri()`.

Returns: the **Gnome::Gio::File** for the file to preview, or `undefined` if no file is selected. Free with `g_object_unref()`.

    method get-preview-file ( --> N-GObject )

get-preview-filename
--------------------

Gets the filename that should be previewed in a custom preview widget. See `set_preview_widget()`.

Returns: (type filename): the filename to preview, or `undefined` if no file is selected, or if the selected file cannot be represented as a local filename. Free with `g_free()`

    method get-preview-filename ( --> Str )

get-preview-uri
---------------

Gets the URI that should be previewed in a custom preview widget. See `set_preview_widget()`.

Returns: the URI for the file to preview, or `undefined` if no file is selected. Free with `g_free()`.

    method get-preview-uri ( --> Str )

get-preview-widget
------------------

Gets the current preview widget; see `set_preview_widget()`.

Returns: the current preview widget, or `undefined`

    method get-preview-widget ( --> N-GObject )

get-preview-widget-active
-------------------------

Gets whether the preview widget set by `set_preview_widget()` should be shown for the current filename. See `set_preview_widget_active()`.

Returns: `True` if the preview widget is active for the current filename.

    method get-preview-widget-active ( --> Bool )

get-select-multiple
-------------------

Gets whether multiple files can be selected in the file selector. See `set_select_multiple()`.

Returns: `True` if multiple files can be selected.

    method get-select-multiple ( --> Bool )

get-show-hidden
---------------

Gets whether hidden files and folders are displayed in the file selector. See `set_show_hidden()`.

Returns: `True` if hidden files and folders are displayed.

    method get-show-hidden ( --> Bool )

get-uri
-------

Gets the URI for the currently selected file in the file selector. If multiple files are selected, one of the filenames will be returned at random.

If the file chooser is in folder mode, this function returns the selected folder.

Returns: The currently selected URI, or `undefined` if no file is selected. If `set_local_only()` is set to `True` (the default) a local URI will be returned for any FUSE locations. Free with `g_free()`

    method get-uri ( --> Str )

get-uris
--------

Lists all the selected files and subfolders in the current folder of *chooser*. The returned names are full absolute URIs.

Returns: (element-type utf8) : a **Gnome::Gio::SList** containing the URIs of all selected files and subfolders in the current folder. Free the returned list with `g_slist_free()`, and the filenames with `g_free()`.

    method get-uris ( --> N-GSList )

get-use-preview-label
---------------------

Gets whether a stock label should be drawn with the name of the previewed file. See `set_use_preview_label()`.

Returns: `True` if the file chooser is set to display a label with the name of the previewed file, `False` otherwise.

    method get-use-preview-label ( --> Bool )

list-filters
------------

Lists the current set of user-selectable filters; see `add_filter()`, `remove_filter()`.

Returns: (element-type GtkFileFilter) (transfer container): a **Gnome::Gio::SList** containing the current set of user selectable filters. The contents of the list are owned by GTK+, but you must free the list itself with `g_slist_free()` when you are done with it.

    method list-filters ( --> N-GSList )

list-shortcut-folder-uris
-------------------------

Queries the list of shortcut folders in the file chooser, as set by `add_shortcut_folder_uri()`.

Returns: (element-type utf8) : A list of folder URIs, or `undefined` if there are no shortcut folders. Free the returned list with `g_slist_free()`, and the URIs with `g_free()`.

    method list-shortcut-folder-uris ( --> N-GSList )

list-shortcut-folders
---------------------

Queries the list of shortcut folders in the file chooser, as set by `add_shortcut_folder()`.

Returns: (element-type filename) : A list of folder filenames, or `undefined` if there are no shortcut folders. Free the returned list with `g_slist_free()`, and the filenames with `g_free()`.

    method list-shortcut-folders ( --> N-GSList )

remove-choice
-------------

Removes a 'choice' that has been added with `add_choice()`.

    method remove-choice ( Str $id )

  * $id; the ID of the choice to remove

remove-filter
-------------

Removes *filter* from the list of filters that the user can select between.

    method remove-filter ( N-GObject() $filter )

  * $filter; a **Gnome::Gtk3::FileFilter**

remove-shortcut-folder
----------------------

Removes a folder from a file chooser’s list of shortcut folders.

Returns: `True` if the operation succeeds, `False` otherwise. In the latter case, the *error* will be set as appropriate.

See also: `add_shortcut_folder()`

    method remove-shortcut-folder ( Str $folder, N-GError $error --> Bool )

  * $folder; (type filename): filename of the folder to remove

  * $error; location to store error, or `undefined`

remove-shortcut-folder-uri
--------------------------

Removes a folder URI from a file chooser’s list of shortcut folders.

Returns: `True` if the operation succeeds, `False` otherwise. In the latter case, the *error* will be set as appropriate.

See also: `add_shortcut_folder_uri()`

    method remove-shortcut-folder-uri ( Str $uri, N-GError $error --> Bool )

  * $uri; URI of the folder to remove

  * $error; location to store error, or `undefined`

select-all
----------

Selects all the files in the current folder of a file chooser.

    method select-all ( )

select-file
-----------

Selects the file referred to by *file*. An internal function. See `_select_uri()`.

Returns: Not useful.

    method select-file ( N-GObject() $file, N-GError $error --> Bool )

  * $file; the file to select

  * $error; location to store error, or `undefined`

select-filename
---------------

Selects a filename. If the file name isn’t in the current folder of *chooser*, then the current folder of *chooser* will be changed to the folder containing *filename*.

Returns: Not useful.

See also: `set_filename()`

    method select-filename ( Str $filename --> Bool )

  * $filename; (type filename): the filename to select

select-uri
----------

Selects the file to by *uri*. If the URI doesn’t refer to a file in the current folder of *chooser*, then the current folder of *chooser* will be changed to the folder containing *filename*.

Returns: Not useful.

    method select-uri ( Str $uri --> Bool )

  * $uri; the URI to select

set-action
----------

Sets the type of operation that the chooser is performing; the user interface is adapted to suit the selected action. For example, an option to create a new folder might be shown if the action is `GTK_FILE_CHOOSER_ACTION_SAVE` but not if the action is `GTK_FILE_CHOOSER_ACTION_OPEN`.

    method set-action ( GtkFileChooserAction $action )

  * $action; the action that the file selector is performing

set-choice
----------

Selects an option in a 'choice' that has been added with `add_choice()`. For a boolean choice, the possible options are "true" and "false".

    method set-choice ( Str $id, Str $option )

  * $id; the ID of the choice to set

  * $option; the ID of the option to select

set-create-folders
------------------

Sets whether file choser will offer to create new folders. This is only relevant if the action is not set to be `GTK_FILE_CHOOSER_ACTION_OPEN`.

    method set-create-folders ( Bool $create_folders )

  * $create_folders; `True` if the Create Folder button should be displayed

set-current-folder
------------------

Sets the current folder for *chooser* from a local filename. The user will be shown the full contents of the current folder, plus user interface elements for navigating to other folders.

In general, you should not use this function. See the [section on setting up a file chooser dialog][gtkfilechooserdialog-setting-up] for the rationale behind this.

Returns: Not useful.

    method set-current-folder ( Str $filename --> Bool )

  * $filename; (type filename): the full path of the new current folder

set-current-folder-file
-----------------------

Sets the current folder for *chooser* from a **Gnome::Gio::File**. Internal function, see `set_current_folder_uri()`.

Returns: `True` if the folder could be changed successfully, `False` otherwise.

    method set-current-folder-file ( N-GObject() $file, N-GError $error --> Bool )

  * $file; the **Gnome::Gio::File** for the new folder

  * $error; location to store error, or `undefined`.

set-current-folder-uri
----------------------

Sets the current folder for *chooser* from an URI. The user will be shown the full contents of the current folder, plus user interface elements for navigating to other folders.

In general, you should not use this function. See the [section on setting up a file chooser dialog][gtkfilechooserdialog-setting-up] for the rationale behind this.

Returns: `True` if the folder could be changed successfully, `False` otherwise.

    method set-current-folder-uri ( Str $uri --> Bool )

  * $uri; the URI for the new current folder

set-current-name
----------------

Sets the current name in the file selector, as if entered by the user. Note that the name passed in here is a UTF-8 string rather than a filename. This function is meant for such uses as a suggested name in a “Save As...” dialog. You can pass “Untitled.doc” or a similarly suitable suggestion for the *name*.

If you want to preselect a particular existing file, you should use `set_filename()` or `set_uri()` instead. Please see the documentation for those functions for an example of using `set_current_name()` as well.

    method set-current-name ( Str $name )

  * $name; (type utf8): the filename to use, as a UTF-8 string

set-do-overwrite-confirmation
-----------------------------

Sets whether a file chooser in `GTK_FILE_CHOOSER_ACTION_SAVE` mode will present a confirmation dialog if the user types a file name that already exists. This is `False` by default.

If set to `True`, the *chooser* will emit the *confirm-overwrite* signal when appropriate.

If all you need is the stock confirmation dialog, set this property to `True`. You can override the way confirmation is done by actually handling the *confirm-overwrite* signal; please refer to its documentation for the details.

    method set-do-overwrite-confirmation ( Bool $do_overwrite_confirmation )

  * $do_overwrite_confirmation; whether to confirm overwriting in save mode

set-extra-widget
----------------

Sets an application-supplied widget to provide extra options to the user.

    method set-extra-widget ( N-GObject() $extra_widget )

  * $extra_widget; widget for extra options

set-file
--------

Sets *file* as the current filename for the file chooser, by changing to the file’s parent folder and actually selecting the file in list. If the *chooser* is in `GTK_FILE_CHOOSER_ACTION_SAVE` mode, the file’s base name will also appear in the dialog’s file name entry.

If the file name isn’t in the current folder of *chooser*, then the current folder of *chooser* will be changed to the folder containing *filename*. This is equivalent to a sequence of `unselect_all()` followed by `select_filename()`.

Note that the file must exist, or nothing will be done except for the directory change.

If you are implementing a save dialog, you should use this function if you already have a file name to which the user may save; for example, when the user opens an existing file and then does Save As...

Returns: An error object. It is valid when the call fails.

    method set-file ( N-GObject() $file --> N-GError )

  * $file; the **Gnome::Gio::File** to set as the current file.

set-filename
------------

Sets *filename* as the current filename for the file chooser, by changing to the file’s parent folder and actually selecting the file in list; all other files will be unselected. If the *chooser* is in `GTK_FILE_CHOOSER_ACTION_SAVE` mode, the file’s base name will also appear in the dialog’s file name entry.

Note that the file must exist, or nothing will be done except for the directory change.

You should use this function only when implementing a save dialog for which you already have a file name to which the user may save. For example, when the user opens an existing file and then does Save As... to save a copy or a modified version. If you don’t have a file name already — for example, if the user just created a new file and is saving it for the first time, do not call this function. Instead, use something similar to this: |[<!-- language="C" --> if (document_is_new) { // the user just created a new document set_current_name (chooser, "Untitled document"); } else { // the user edited an existing document set_filename (chooser, existing_filename); } ]|

In the first case, the file chooser will present the user with useful suggestions as to where to save his new file. In the second case, the file’s existing location is already known, so the file chooser will use it.

Returns: Not useful.

    method set-filename ( Str $filename --> Bool )

  * $filename; (type filename): the filename to set as current

set-filter
----------

Sets the current filter; only the files that pass the filter will be displayed. If the user-selectable list of filters is non-empty, then the filter should be one of the filters in that list. Setting the current filter when the list of filters is empty is useful if you want to restrict the displayed set of files without letting the user change it.

    method set-filter ( N-GObject() $filter )

  * $filter; a **Gnome::Gtk3::FileFilter**

set-local-only
--------------

Sets whether only local files can be selected in the file selector. If *local_only* is `True` (the default), then the selected file or files are guaranteed to be accessible through the operating systems native file system and therefore the application only needs to worry about the filename functions in **Gnome::Gtk3::FileChooser**, like `get_filename()`, rather than the URI functions like `get_uri()`,

On some systems non-native files may still be available using the native filesystem via a userspace filesystem (FUSE).

    method set-local-only ( Bool $local_only )

  * $local_only; `True` if only local files can be selected

set-preview-widget
------------------

Sets an application-supplied widget to use to display a custom preview of the currently selected file. To implement a preview, after setting the preview widget, you connect to the *update-preview* signal, and call `get_preview_filename()` or `get_preview_uri()` on each change. If you can display a preview of the new file, update your widget and set the preview active using `set_preview_widget_active()`. Otherwise, set the preview inactive.

When there is no application-supplied preview widget, or the application-supplied preview widget is not active, the file chooser will display no preview at all.

    method set-preview-widget ( N-GObject() $preview_widget )

  * $preview_widget; widget for displaying preview.

set-preview-widget-active
-------------------------

Sets whether the preview widget set by `set_preview_widget()` should be shown for the current filename. When *active* is set to false, the file chooser may display an internally generated preview of the current file or it may display no preview at all. See `set_preview_widget()` for more details.

    method set-preview-widget-active ( Bool $active )

  * $active; whether to display the user-specified preview widget

set-select-multiple
-------------------

Sets whether multiple files can be selected in the file selector. This is only relevant if the action is set to be `GTK_FILE_CHOOSER_ACTION_OPEN` or `GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER`.

    method set-select-multiple ( Bool $select_multiple )

  * $select_multiple; `True` if multiple files can be selected.

set-show-hidden
---------------

Sets whether hidden files and folders are displayed in the file selector.

    method set-show-hidden ( Bool $show_hidden )

  * $show_hidden; `True` if hidden files and folders should be displayed.

set-uri
-------

Sets the file referred to by *uri* as the current file for the file chooser, by changing to the URI’s parent folder and actually selecting the URI in the list. If the *chooser* is `GTK_FILE_CHOOSER_ACTION_SAVE` mode, the URI’s base name will also appear in the dialog’s file name entry.

Note that the URI must exist, or nothing will be done except for the directory change.

You should use this function only when implementing a save dialog for which you already have a file name to which the user may save. For example, when the user opens an existing file and then does Save As... to save a copy or a modified version. If you don’t have a file name already — for example, if the user just created a new file and is saving it for the first time, do not call this function. Instead, use something similar to this: |[<!-- language="C" --> if (document_is_new) { // the user just created a new document set_current_name (chooser, "Untitled document"); } else { // the user edited an existing document set_uri (chooser, existing_uri); } ]|

    In the first case, the file chooser will present the user with useful suggestions as to where to save his new file. In the second case, the file’s existing location is already known, so the file chooser will use it.

Returns: Not useful.

    method set-uri ( Str $uri --> Bool )

  * $uri; the URI to set as current

set-use-preview-label
---------------------

Sets whether the file chooser should display a stock label with the name of the file that is being previewed; the default is `True`. Applications that want to draw the whole preview area themselves should set this to `False` and display the name themselves in their preview widget.

See also: `set_preview_widget()`

    method set-use-preview-label ( Bool $use_label )

  * $use_label; whether to display a stock label with the name of the previewed file

unselect-all
------------

Unselects all the files in the current folder of a file chooser.

    method unselect-all ( )

unselect-file
-------------

Unselects the file referred to by *file*. If the file is not in the current directory, does not exist, or is otherwise not currently selected, does nothing.

    method unselect-file ( N-GObject() $file )

  * $file; a **Gnome::Gio::File**

unselect-filename
-----------------

Unselects a currently selected filename. If the filename is not in the current directory, does not exist, or is otherwise not currently selected, does nothing.

    method unselect-filename ( Str $filename )

  * $filename; (type filename): the filename to unselect

unselect-uri
------------

Unselects the file referred to by *uri*. If the file is not in the current directory, does not exist, or is otherwise not currently selected, does nothing.

    method unselect-uri ( Str $uri )

  * $uri; the URI to unselect

Signals
=======

confirm-overwrite
-----------------

This signal gets emitted whenever it is appropriate to present a confirmation dialog when the user has selected a file name that already exists. The signal only gets emitted when the file chooser is in `GTK_FILE_CHOOSER_ACTION_SAVE` mode.

Most applications just need to turn on the *do-overwrite-confirmation* property (or call the `set_do_overwrite_confirmation()` function), and they will automatically get a stock confirmation dialog. Applications which need to customize this behavior should do that, and also connect to the *confirm-overwrite* signal.

A signal handler for this signal must return a **Gnome::Gtk3::FileChooserConfirmation** value, which indicates the action to take. If the handler determines that the user wants to select a different filename, it should return `GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN`. If it determines that the user is satisfied with his choice of file name, it should return `GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME`. On the other hand, if it determines that the stock confirmation dialog should be used, it should return `GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM`. The following example illustrates this.

## Custom confirmation ## {**gtkfilechooser**-confirmation}

|[<!-- language="C" --> static GtkFileChooserConfirmation confirm_overwrite_callback (GtkFileChooser *chooser, gpointer data) { char *uri;

uri = get_uri (chooser);

if (is_uri_read_only (uri)) { if (user_wants_to_replace_read_only_file (uri)) return GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME; else return GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN; } else return GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM; // fall back to the default dialog }

...

chooser = dialog_new (...);

set_do_overwrite_confirmation (GTK_FILE_CHOOSER (dialog), TRUE); g_signal_connect (chooser, "confirm-overwrite", G_CALLBACK (confirm_overwrite_callback), NULL);

if (gtk_dialog_run (chooser) == GTK_RESPONSE_ACCEPT) save_to_file (get_filename (GTK_FILE_CHOOSER (chooser));

gtk_widget_destroy (chooser); ]|

Returns: a **Gnome::Gtk3::FileChooserConfirmation** value that indicates which action to take after emitting the signal.

    method handler (
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options

      --> Unknown type: GTK_TYPE_FILE_CHOOSER_CONFIRMATION
    )

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

current-folder-changed
----------------------

This signal is emitted when the current folder in a **Gnome::Gtk3::FileChooser** changes. This can happen due to the user performing some action that changes folders, such as selecting a bookmark or visiting a folder on the file list. It can also happen as a result of calling a function to explicitly change the current folder in a file chooser.

Normally you do not need to connect to this signal, unless you need to keep track of which folder a file chooser is showing.

See also: `set_current_folder()`, `get_current_folder()`, `set_current_folder_uri()`, `get_current_folder_uri()`.

    method handler (
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

file-activated
--------------

This signal is emitted when the user "activates" a file in the file chooser. This can happen by double-clicking on a file in the file list, or by pressing `Enter`.

Normally you do not need to connect to this signal. It is used internally by **Gnome::Gtk3::FileChooserDialog** to know when to activate the default button in the dialog.

See also: `get_filename()`, `get_filenames()`, `get_uri()`, `get_uris()`.

    method handler (
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

selection-changed
-----------------

This signal is emitted when there is a change in the set of selected files in a **Gnome::Gtk3::FileChooser**. This can happen when the user modifies the selection with the mouse or the keyboard, or when explicitly calling functions to change the selection.

Normally you do not need to connect to this signal, as it is easier to wait for the file chooser to finish running, and then to get the list of selected files using the functions mentioned below.

See also: `select_filename()`, `unselect_filename()`, `get_filename()`, `get_filenames()`, `select_uri()`, `unselect_uri()`, `get_uri()`, `get_uris()`.

    method handler (
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.

  * %user-options; A list of named arguments provided at the `register-signal()` method

update-preview
--------------

This signal is emitted when the preview in a file chooser should be regenerated. For example, this can happen when the currently selected file changes. You should use this signal if you want your file chooser to have a preview widget.

Once you have installed a preview widget with `set_preview_widget()`, you should update it when this signal is emitted. You can use the functions `get_preview_filename()` or `get_preview_uri()` to get the name of the file to preview. Your widget may not be able to preview all kinds of files; your callback must call `set_preview_widget_active()` to inform the file chooser about whether the preview was generated successfully or not.

Please see the example code in [Using a Preview Widget][gtkfilechooser-preview].

See also: `set_preview_widget()`, `set_preview_widget_active()`, `set_use_preview_label()`, `get_preview_filename()`, `get_preview_uri()`.

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

action
------

The type of operation that the file selector is performing

  * **Gnome::GObject::Value** type of this property is G_TYPE_ENUM

  * The type of this G_TYPE_ENUM object is GTK_TYPE_FILE_CHOOSER_ACTION

  * Parameter is readable and writable.

  * Default value is GTK_FILE_CHOOSER_ACTION_OPEN.

create-folders
--------------

Whether a file chooser not in open mode will offer the user to create new folders.

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is TRUE.

do-overwrite-confirmation
-------------------------

Whether a file chooser in save mode will present an overwrite confirmation dialog if necessary.

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is FALSE.

extra-widget
------------

Application supplied widget for extra options.

  * **Gnome::GObject::Value** type of this property is G_TYPE_OBJECT

  * The type of this G_TYPE_OBJECT object is GTK_TYPE_WIDGET

  * Parameter is readable and writable.

filter
------

The current filter for selecting which files are displayed

  * **Gnome::GObject::Value** type of this property is G_TYPE_OBJECT

  * The type of this G_TYPE_OBJECT object is GTK_TYPE_FILE_FILTER

  * Parameter is readable and writable.

local-only
----------

Whether the selected file(s should be limited to local file: URLs)

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is TRUE.

preview-widget
--------------

Application supplied widget for custom previews.

  * **Gnome::GObject::Value** type of this property is G_TYPE_OBJECT

  * The type of this G_TYPE_OBJECT object is GTK_TYPE_WIDGET

  * Parameter is readable and writable.

preview-widget-active
---------------------

Whether the application supplied widget for custom previews should be shown.

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is TRUE.

select-multiple
---------------

Whether to allow multiple files to be selected

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is FALSE.

show-hidden
-----------

Whether the hidden files and folders should be displayed

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is FALSE.

use-preview-label
-----------------

Whether to display a stock label with the name of the previewed file.

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is TRUE.

