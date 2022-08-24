Gnome::Gtk3::EntryCompletion
============================

Completion functionality for GtkEntry

Description
===========

**Gnome::Gtk3::EntryCompletion** is an auxiliary object to be used in conjunction with **Gnome::Gtk3::Entry** to provide the completion functionality. It implements the **Gnome::Gtk3::CellLayout** interface, to allow the user to add extra cells to the **Gnome::Gtk3::TreeView** with completion matches.

“Completion functionality” means that when the user modifies the text in the entry, **Gnome::Gtk3::EntryCompletion** checks which rows in the model match the current content of the entry, and displays a list of matches. By default, the matching is done by comparing the entry text case-insensitively against the text column of the model (see `set-text-column()`), but this can be overridden with a custom match function (see `gtk-entry-completion-set-match-func()`).

When the user selects a completion, the content of the entry is updated. By default, the content of the entry is replaced by the text column of the model, but this can be overridden by connecting to the *match-selected* signal and updating the entry in the signal handler. Note that you should return `True` from the signal handler to suppress the default behaviour.

To add completion functionality to an entry, use `set-completion()` from **Gnome::Gtk3::Entry**.

In addition to regular completion matches, which will be inserted into the entry when they are selected, **Gnome::Gtk3::EntryCompletion** also allows to display “actions” in the popup window. Their appearance is similar to menuitems, to differentiate them clearly from completion strings. When an action is selected, the *action-activated* signal is emitted.

**Gnome::Gtk3::EntryCompletion** uses a **Gnome::Gtk3::TreeModelFilter** model to represent the subset of the entire model that is currently matching. While the GtkEntryCompletion signals *match-selected* and *cursor-on-match* take the original model and an iter pointing to that model as arguments, other callbacks and signals (such as **Gnome::Gtk3::CellLayoutDataFuncs** or *apply-attributes*) will generally take the filter model as argument. As long as you are only calling `gtk-tree-model-get()`, this will make no difference to you. If for some reason, you need the original model, use `gtk-tree-model-filter-get-model()`. Don’t forget to use `convert-iter-to-child-iter()` in **Gnome::Gtk3::TreeModelFilter** to obtain a matching iter.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::EntryCompletion;
    also is Gnome::GObject::Object;
    also does Gnome::Gtk3::CellLayout;

Methods
=======

new
---

### default, no options

Create a new EntryCompletion object.

    multi method new ( )

### :area

Creates a new **Gnome::Gtk3::EntryCompletion** object using the specified *$area* to layout cells in the underlying **Gnome::Gtk3::TreeViewColumn** for the drop-down menu.

    multi method new ( N-GObject :$area! )

### :native-object

Create an EntryCompletion object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

complete
--------

Requests a completion operation, or in other words a refiltering of the current list with completions, using the current key. The completion list view will be updated accordingly.

    method complete ( )

compute-prefix
--------------

Computes the common prefix that is shared by all rows in in this entry completion that start with *$key*. If no row matches *$key*, `undefined` will be returned. Note that a text column must have been set for this function to work, see `set-text-column()` for details.

Returns: The common prefix all rows starting with *$key* or `undefined` if no row matches *$key*.

    method compute-prefix ( Str $key --> Str )

  * Str $key; The text to complete for

delete-action
-------------

Deletes the action at *$index* from in this entry completion’s action list.

Note that *$index* is a relative position and the position of an action may have changed since it was inserted.

    method delete-action ( Int $index )

  * Int $index; the index of the item to delete

get-completion-prefix
---------------------

Get the original text entered by the user that triggered the completion or `undefined` if there’s no completion ongoing.

Returns: the prefix for the current completion

    method get-completion-prefix ( --> Str )

get-entry
---------

Gets the entry in this entry completion has been attached to.

Returns: The entry in this entry completion has been attached to

    method get-entry ( --> Gnome::Gtk3::Entry )

get-inline-completion
---------------------

Returns whether the common prefix of the possible completions should be automatically inserted in the entry.

Returns: `True` if inline completion is turned on

    method get-inline-completion ( --> Bool )

get-inline-selection
--------------------

Returns `True` if inline-selection mode is turned on.

Returns: `True` if inline-selection mode is on

    method get-inline-selection ( --> Bool )

get-minimum-key-length
----------------------

Returns the minimum key length as set for in this entry completion.

    method get-minimum-key-length ( --> Int )

get-model
---------

Returns the model the **Gnome::Gtk3::EntryCompletion** is using as data source. Returns `undefined` if the model is unset.

Returns: A **Gnome::Gtk3::TreeModel**, or `undefined` if none is currently being used. The model can be any of TreeStore or ListStore.

    method get-model ( --> N-GObject )

get-popup-completion
--------------------

Returns whether the completions should be presented in a popup window.

Returns: `True` if popup completion is turned on

    method get-popup-completion ( --> Bool )

get-popup-set-width
-------------------

Returns whether the completion popup window will be resized to the width of the entry.

Returns: `True` if the popup window will be resized to the width of the entry

    method get-popup-set-width ( --> Bool )

get-popup-single-match
----------------------

Returns whether the completion popup window will appear even if there is only a single match.

Returns: `True` if the popup window will appear regardless of the number of matches

    method get-popup-single-match ( --> Bool )

get-text-column
---------------

Returns the column in the model of in this entry completion to get strings from. Returns -1 if no column is set.

    method get-text-column ( --> Int )

insert-action-markup
--------------------

Inserts an action in in this entry completion’s action item list at position *$index* with markup *$markup*.

    method insert-action-markup ( Int $index, Str $markup )

  * Int $index; the index of the item to insert

  * Str $markup; markup of the item to insert

insert-action-text
------------------

Inserts an action in in this entry completion’s action item list at position *index* with text *text*. If you want the action item to have markup, use `insert-action-markup()`.

Note that *index* is a relative position in the list of actions and the position of an action can change when deleting a different action.

    method insert-action-text ( Int $index, Str $text )

  * Int $index; the index of the item to insert

  * Str $text; text of the item to insert

insert-prefix
-------------

Requests a prefix insertion.

    method insert-prefix ( )

set-inline-completion
---------------------

Sets whether the common prefix of the possible completions should be automatically inserted in the entry.

    method set-inline-completion ( Bool $inline_completion )

  * Bool $inline_completion; `True` to do inline completion

set-inline-selection
--------------------

Sets whether it is possible to cycle through the possible completions inside the entry.

    method set-inline-selection ( Bool $inline_selection )

  * Bool $inline_selection; `True` to do inline selection

set-minimum-key-length
----------------------

Requires the length of the search key for in this entry completion to be at least *length*. This is useful for long lists, where completing using a small key takes a lot of time and will come up with meaningless results anyway (ie, a too large dataset).

    method set-minimum-key-length ( Int $length )

  * Int $length; the minimum length of the key in order to start completing

set-model
---------

Sets the model for a **Gnome::Gtk3::EntryCompletion**. If in this entry completion already has a model set, it will remove it before setting the new model. If model is `undefined`, then it will unset the model.

    method set-model ( N-GObject $model )

  * N-GObject $model; the **Gnome::Gtk3::TreeModel**

set-popup-completion
--------------------

Sets whether the completions should be presented in a popup window.

    method set-popup-completion ( Bool $popup_completion )

  * Bool $popup_completion; `True` to do popup completion

set-popup-set-width
-------------------

Sets whether the completion popup window will be resized to be the same width as the entry.

    method set-popup-set-width ( Bool $popup_set_width )

  * Bool $popup_set_width; `True` to make the width of the popup the same as the entry

set-popup-single-match
----------------------

Sets whether the completion popup window will appear even if there is only a single match. You may want to set this to `False` if you are using inline completion.

    method set-popup-single-match ( Bool $popup_single_match )

  * Bool $popup_single_match; `True` if the popup should appear even for a single match

set-text-column
---------------

Convenience function for setting up the most used case of this code: a completion list with just strings. This function will set up in this entry completion to have a list displaying all (and just) strings in the completion list, and to get those strings from *column* in the model of in this entry completion.

This functions creates and adds a **Gnome::Gtk3::CellRendererText** for the selected column. If you need to set the text column, but don't want the cell renderer, use `g-object-set()` to set the *text-column* property directly.

    method set-text-column ( Int $column )

  * Int $column; the column in the model of this entry completion to get strings from

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `connect-object()` directly from **Gnome::GObject::Signal**.

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

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `connect-object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### action-activated

Gets emitted when an action is activated.

    method handler (
      Int $index,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal

  * $index; the index of the activated action

### cursor-on-match

Gets emitted when a match from the cursor is on a match of the list. The default behaviour is to replace the contents of the entry with the contents of the text column in the row pointed to by *iter*.

Note that *model* is the model that was passed to `set-model()`.

Returns: `True` if the signal has been handled

    method handler (
      Unknown type GTK_TYPE_TREE_MODEL $model,
      N-GtkTreeIter #`{ native Gnome::Gtk3::TreeIter } $iter,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $model; the **Gnome::Gtk3::TreeModel** containing the matches

  * $iter; a **Gnome::Gtk3::TreeIter** positioned at the selected match

### insert-prefix

Gets emitted when the inline autocompletion is triggered. The default behaviour is to make the entry display the whole prefix and select the newly inserted part.

Applications may connect to this signal in order to insert only a smaller part of the *prefix* into the entry - e.g. the entry used in the **Gnome::Gtk3::FileChooser** inserts only the part of the prefix up to the next '/'.

Returns: `True` if the signal has been handled

    method handler (
      Str $prefix,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $prefix; the common prefix of all possible completions

### match-selected

Gets emitted when a match from the list is selected. The default behaviour is to replace the contents of the entry with the contents of the text column in the row pointed to by *iter*.

Note that *model* is the model that was passed to `set-model()`.

Returns: `True` if the signal has been handled

    method handler (
      Unknown type GTK_TYPE_TREE_MODEL $model,
      N-GtkTreeIter #`{ native Gnome::Gtk3::TreeIter } $iter,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($widget),
      *%user-options
      --> Int
    );

  * $widget; the object which received the signal

  * $model; the **Gnome::Gtk3::TreeModel** containing the matches

  * $iter; a **Gnome::Gtk3::TreeIter** positioned at the selected match

### no-matches

Gets emitted when the filter model has zero number of rows in completion-complete method. (In other words when GtkEntryCompletion is out of suggestions)

    method handler (
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($widget),
      *%user-options
    );

  * $widget; the object which received the signal

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **.set-text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.get-property( 'label', $gv);
    $gv.set-string('my text label');

Supported properties
--------------------

### Cell Area: cell-area

The **Gnome::Gtk3::CellArea** used to layout cell renderers in the treeview column.

If no area is specified when creating the entry completion with `new-with-area()` a horizontally oriented **Gnome::Gtk3::CellAreaBox** will be used.

    Widget type: GTK_TYPE_CELL_AREA

The **Gnome::GObject::Value** type of property *cell-area* is `G_TYPE_OBJECT`.

### Inline completion: inline-completion

Determines whether the common prefix of the possible completions should be inserted automatically in the entry. Note that this requires text-column to be set, even if you are using a custom match function.

The **Gnome::GObject::Value** type of property *inline-completion* is `G_TYPE_BOOLEAN`.

### Inline selection: inline-selection

Determines whether the possible completions on the popup will appear in the entry as you navigate through them.

The **Gnome::GObject::Value** type of property *inline-selection* is `G_TYPE_BOOLEAN`.

### Minimum Key Length: minimum-key-length

The **Gnome::GObject::Value** type of property *minimum-key-length* is `G_TYPE_INT`.

### Completion Model: model

The model to find matches in Widget type: GTK-TYPE-TREE-MODEL

The **Gnome::GObject::Value** type of property *model* is `G_TYPE_OBJECT`.

### Popup completion: popup-completion

Determines whether the possible completions should be shown in a popup window.

The **Gnome::GObject::Value** type of property *popup-completion* is `G_TYPE_BOOLEAN`.

### Popup set width: popup-set-width

Determines whether the completions popup window will be resized to the width of the entry.

The **Gnome::GObject::Value** type of property *popup-set-width* is `G_TYPE_BOOLEAN`.

### Popup single match: popup-single-match

Determines whether the completions popup window will shown for a single possible completion. You probably want to set this to `False` if you are using [inline completion][GtkEntryCompletion--inline-completion].

The **Gnome::GObject::Value** type of property *popup-single-match* is `G_TYPE_BOOLEAN`.

### Text column: text-column

The column of the model containing the strings. Note that the strings must be UTF-8.

The **Gnome::GObject::Value** type of property *text-column* is `G_TYPE_INT`.

