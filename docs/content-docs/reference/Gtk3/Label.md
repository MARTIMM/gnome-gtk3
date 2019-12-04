Gnome::Gtk3::Label
==================

A widget that displays a small to medium amount of text

![](images/label.png)

Description
===========

The **Gnome::Gtk3::Label** widget displays a small amount of text. As the name implies, most labels are used to label another widget such as a **Gnome::Gtk3::Button**, a **Gnome::Gtk3::MenuItem**, or a **Gnome::Gtk3::ComboBox**.

Css Nodes
---------

    label
    ├── [selection]
    ├── [link]
    ┊
    ╰── [link]

**Gnome::Gtk3::Label** has a single CSS node with the name label. A wide variety of style classes may be applied to labels, such as .title, .subtitle, .dim-label, etc. In the **Gnome::Gtk3::ShortcutsWindow**, labels are used wth the .keycap style class.

If the label has a selection, it gets a subnode with name selection.

If the label has links, there is one subnode per link. These subnodes carry the link or visited state depending on whether they have been visited.

The start and end attributes specify the range of characters to which the Pango attribute applies. If start and end are not specified, the attribute is applied to the whole text. Note that specifying ranges does not make much sense with translatable attributes. Use markup embedded in the translatable content instead.

Mnemonics
---------

Labels may contain “mnemonics”. Mnemonics are underlined characters in the label, used for keyboard navigation. Mnemonics are created by providing a string with an underscore before the mnemonic character, such as `"_File"`, to the functions `gtk_label_new_with_mnemonic()` or `gtk_label_set_text_with_mnemonic()`.

Mnemonics automatically activate any activatable widget the label is inside, such as a **Gnome::Gtk3::Button**; if the label is not inside the mnemonic’s target widget, you have to tell the label about the target using `.new(:mnemonic())`. Here’s a simple example where the label is inside a button:

    # Pressing Alt+H will activate this button
    my Gnome::Gtk3::Button $b .= new(:empty);
    my Gnome::Gtk3::Label $l .= new(:mnemonic<_Hello>);
    $b.gtk-container-add($l);

There’s a convenience function to create buttons with a mnemonic label already inside:

    # Pressing Alt+H will activate this button
    my Gnome::Gtk3::Button $b .= new(:mnemonic<_Hello>);

To create a mnemonic for a widget alongside the label, such as a **Gnome::Gtk3::Entry**, you have to point the label at the entry with `gtk_label_set_mnemonic_widget()`:

    # Pressing Alt+H will focus the entry
    my Gnome::Gtk3::Entry $e .= new(:empty);
    my Gnome::Gtk3::Label $l .= new(:mnemonic<_Hello>);
    $l.set-mnemonic-widget($e);

Selectable labels
-----------------

Labels can be made selectable with `gtk_label_set_selectable()`. Selectable labels allow the user to copy the label contents to the clipboard. Only labels that contain useful-to-copy information — such as error messages — should be made selectable.

Links
-----

Since 2.18, GTK+ supports markup for clickable hyperlinks in addition to regular Pango markup. The markup for links is borrowed from HTML, using the `<a>` with “href“ and “title“ attributes. GTK+ renders links similar to the way they appear in web browsers, with colored, underlined text. The “title“ attribute is displayed as a tooltip on the link.

An example looks like this:

    my Str $text = [+] "Go to the",
      "<a href=\"http://www.gtk.org title="&lt;i&gt;Our&lt;/i&gt; website\">",
      "GTK+ website</a> for more...";
    my Gnome::Gtk3::Label $l .= new(:empty);
    $l.set-markup($text);

It is possible to implement custom handling for links and their tooltips with the *activate-link* signal and the `gtk_label_get_current_uri()` function.

Implemented Interfaces
----------------------

Gnome::Gtk3::Label implements

  * [Gnome::Gtk3::Buildable](Buildable.html)

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Label;
    also is Gnome::Gtk3::Misc;
    also does Gnome::Gtk3::Buildable;

Methods
=======

new
---

Create a new object with text.

    multi method new ( Str :text! )

Create a new object with mnemonic.

    multi method new ( Str :mnemonic! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_] label_new
----------------

Creates a new label with the given text inside it. You can pass `Any` to get an empty label widget.

Returns: the new **Gnome::Gtk3::Label**

    method gtk_label_new ( Str $str --> N-GObject  )

  * Str $str; (allow-none): The text of the label

[[gtk_] label_] new_with_mnemonic
---------------------------------

Creates a new **Gnome::Gtk3::Label**, containing the text in *str*.

If characters in *str* are preceded by an underscore, they are underlined. If you need a literal underscore character in a label, use '__' (two underscores). The first underlined character represents a keyboard accelerator called a mnemonic. The mnemonic key can be used to activate another widget, chosen automatically, or explicitly using `gtk_label_set_mnemonic_widget()`.

If `gtk_label_set_mnemonic_widget()` is not called, then the first activatable ancestor of the **Gnome::Gtk3::Label** will be chosen as the mnemonic widget. For instance, if the label is inside a button or menu item, the button or menu item will automatically become the mnemonic widget and be activated by the mnemonic.

Returns: the new **Gnome::Gtk3::Label**

    method gtk_label_new_with_mnemonic ( Str $str --> N-GObject  )

  * Str $str; (allow-none): The text of the label, with an underscore in front of the mnemonic character

[[gtk_] label_] set_text
------------------------

Sets the text within the **Gnome::Gtk3::Label** widget. It overwrites any text that was there before.

This function will clear any previously set mnemonic accelerators, and set the *use-underline* property to `0` as a side effect.

This function will set the *use-markup* property to `0` as a side effect.

See also: `gtk_label_set_markup()`

    method gtk_label_set_text ( Str $str )

  * Str $str; The text you want to set

[[gtk_] label_] get_text
------------------------

Fetches the text from a label widget, as displayed on the screen. This does not include any embedded underlines indicating mnemonics or Pango markup. (See `gtk_label_get_label()`)

Returns: the text in the label widget. This is the internal string used by the label, and must not be modified.

    method gtk_label_get_text ( --> Str  )

[[gtk_] label_] set_label
-------------------------

Sets the text of the label. The label is interpreted as including embedded underlines and/or Pango markup depending on the values of the *use-underline* and *use-markup* properties.

    method gtk_label_set_label ( Str $str )

  * Str $str; the new text to set for the label

[[gtk_] label_] get_label
-------------------------

Fetches the text from a label widget including any embedded underlines indicating mnemonics and Pango markup. (See `gtk_label_get_text()`).

Returns: the text of the label widget. This string is owned by the widget and must not be modified or freed.

    method gtk_label_get_label ( --> Str  )

[[gtk_] label_] set_use_markup
------------------------------

Sets whether the text of the label contains markup in [Pango’s text markup language](https://developer.gnome.org/pygtk/stable/pango-markup-language.html). See `gtk_label_set_markup()`.

    method gtk_label_set_use_markup ( Int $setting )

  * Int $setting; `1` if the label’s text should be parsed for markup.

[[gtk_] label_] get_use_markup
------------------------------

Returns whether the label’s text is interpreted as marked up with the [Pango text markup language][PangoMarkupFormat]. See `gtk_label_set_use_markup()`.

Returns: `1` if the label’s text will be parsed for markup.

    method gtk_label_get_use_markup ( --> Int  )

[[gtk_] label_] set_use_underline
---------------------------------

If true, an underline in the text indicates the next character should be used for the mnemonic accelerator key.

    method gtk_label_set_use_underline ( Int $setting )

  * Int $setting; `1` if underlines in the text indicate mnemonics

[[gtk_] label_] get_use_underline
---------------------------------

Returns whether an embedded underline in the label indicates a mnemonic. See `gtk_label_set_use_underline()`.

Returns: `1` whether an embedded underline in the label indicates the mnemonic accelerator keys.

    method gtk_label_get_use_underline ( --> Int  )

[[gtk_] label_] set_markup_with_mnemonic
----------------------------------------

Parses *str* which is marked up with the [Pango text markup language](https://developer.gnome.org/pygtk/stable/pango-markup-language.html), setting the label’s text and attribute list based on the parse results. If characters in *str* are preceded by an underscore, they are underlined indicating that they represent a keyboard accelerator called a mnemonic.

The mnemonic key can be used to activate another widget, chosen automatically, or explicitly using `gtk_label_set_mnemonic_widget()`.

    method gtk_label_set_markup_with_mnemonic ( Str $str )

  * Str $str; a markup string (see [Pango markup format][PangoMarkupFormat])

[[gtk_] label_] get_mnemonic_keyval
-----------------------------------

If the label has been set so that it has an mnemonic key this function returns the keyval used for the mnemonic accelerator. If there is no mnemonic set up it returns **GDK_KEY_VoidSymbol**.

Returns: GDK keyval usable for accelerators, or **GDK_KEY_VoidSymbol**

    method gtk_label_get_mnemonic_keyval ( --> UInt  )

[[gtk_] label_] set_mnemonic_widget
-----------------------------------

If the label has been set so that it has an mnemonic key (using i.e. `gtk_label_set_markup_with_mnemonic()`, `gtk_label_set_text_with_mnemonic()`, `gtk_label_new_with_mnemonic()` or the “use_underline” property) the label can be associated with a widget that is the target of the mnemonic. When the label is inside a widget (like a **Gnome::Gtk3::Button** or a **Gnome::Gtk3::Notebook** tab) it is automatically associated with the correct widget, but sometimes (i.e. when the target is a **Gnome::Gtk3::Entry** next to the label) you need to set it explicitly using this function.

The target widget will be accelerated by emitting the **Gnome::Gtk3::Widget**::mnemonic-activate signal on it. The default handler for this signal will activate the widget if there are no mnemonic collisions and toggle focus between the colliding widgets otherwise.

    method gtk_label_set_mnemonic_widget ( N-GObject $widget )

  * N-GObject $widget; (allow-none): the target **Gnome::Gtk3::Widget**

[[gtk_] label_] get_mnemonic_widget
-----------------------------------

Retrieves the target of the mnemonic (keyboard shortcut) of this label. See `gtk_label_set_mnemonic_widget()`.

Returns: (nullable) (transfer none): the target of the label’s mnemonic, or `Any` if none has been set and the default algorithm will be used.

    method gtk_label_get_mnemonic_widget ( --> N-GObject  )

[[gtk_] label_] set_text_with_mnemonic
--------------------------------------

Sets the label’s text from the string *str*. If characters in *str* are preceded by an underscore, they are underlined indicating that they represent a keyboard accelerator called a mnemonic. The mnemonic key can be used to activate another widget, chosen automatically, or explicitly using `gtk_label_set_mnemonic_widget()`.

    method gtk_label_set_text_with_mnemonic ( Str $str )

  * Str $str; a string

[[gtk_] label_] set_justify
---------------------------

Sets the alignment of the lines in the text of the label relative to each other. `GTK_JUSTIFY_LEFT` is the default value when the widget is first created with `gtk_label_new()`. If you instead want to set the alignment of the label as a whole, use `gtk_widget_set_halign()` instead. `gtk_label_set_justify()` has no effect on labels containing only a single line.

    method gtk_label_set_justify ( GtkJustification $jtype )

  * GtkJustification $jtype; a **Gnome::Gtk3::Justification**

[[gtk_] label_] get_justify
---------------------------

Returns the justification of the label. See `gtk_label_set_justify()`.

Returns: **Gnome::Gtk3::Justification**

    method gtk_label_get_justify ( --> GtkJustification  )

[[gtk_] label_] set_width_chars
-------------------------------

Sets the desired width in characters of *label* to *n_chars*.

Since: 2.6

    method gtk_label_set_width_chars ( Int $n_chars )

  * Int $n_chars; the new desired width, in characters.

[[gtk_] label_] get_width_chars
-------------------------------

Retrieves the desired width of *label*, in characters. See `gtk_label_set_width_chars()`.

Returns: the width of the label in characters.

Since: 2.6

    method gtk_label_get_width_chars ( --> Int  )

[[gtk_] label_] set_max_width_chars
-----------------------------------

Sets the desired maximum width in characters of *label* to *n_chars*.

Since: 2.6

    method gtk_label_set_max_width_chars ( Int $n_chars )

  * Int $n_chars; the new desired maximum width, in characters.

[[gtk_] label_] get_max_width_chars
-----------------------------------

Retrieves the desired maximum width of *label*, in characters. See `gtk_label_set_width_chars()`.

Returns: the maximum width of the label in characters.

Since: 2.6

    method gtk_label_get_max_width_chars ( --> Int  )

[[gtk_] label_] set_lines
-------------------------

Sets the number of lines to which an ellipsized, wrapping label should be limited. This has no effect if the label is not wrapping or ellipsized. Set this to -1 if you don’t want to limit the number of lines.

Since: 3.10

    method gtk_label_set_lines ( Int $lines )

  * Int $lines; the desired number of lines, or -1

[[gtk_] label_] get_lines
-------------------------

Gets the number of lines to which an ellipsized, wrapping label should be limited. See `gtk_label_set_lines()`.

Returns: The number of lines

Since: 3.10

    method gtk_label_get_lines ( --> Int  )

[[gtk_] label_] set_pattern
---------------------------

The pattern of underlines you want under the existing text within the **Gnome::Gtk3::Label** widget. For example if the current text of the label says “FooBarBaz” passing a pattern of “___ ___” will underline “Foo” and “Baz” but not “Bar”.

    method gtk_label_set_pattern ( Str $pattern )

  * Str $pattern; The pattern as described above.

[[gtk_] label_] set_line_wrap
-----------------------------

Toggles line wrapping within the **Gnome::Gtk3::Label** widget. `1` makes it break lines if text exceeds the widget’s size. `0` lets the text get cut off by the edge of the widget if it exceeds the widget size.

Note that setting line wrapping to `1` does not make the label wrap at its parent container’s width, because GTK+ widgets conceptually can’t make their requisition depend on the parent container’s size. For a label that wraps at a specific position, set the label’s width using `gtk_widget_set_size_request()`.

    method gtk_label_set_line_wrap ( Int $wrap )

  * Int $wrap; the setting

[[gtk_] label_] get_line_wrap
-----------------------------

Returns whether lines in the label are automatically wrapped. See `gtk_label_set_line_wrap()`.

Returns: `1` if the lines of the label are automatically wrapped.

    method gtk_label_get_line_wrap ( --> Int  )

[[gtk_] label_] set_selectable
------------------------------

Selectable labels allow the user to select text from the label, for copy-and-paste.

    method gtk_label_set_selectable ( Int $setting )

  * Int $setting; `1` to allow selecting text in the label

[[gtk_] label_] get_selectable
------------------------------

Gets the value set by `gtk_label_set_selectable()`.

Returns: `1` if the user can copy text from the label

    method gtk_label_get_selectable ( --> Int  )

[[gtk_] label_] set_angle
-------------------------

Sets the angle of rotation for the label. An angle of 90 reads from from bottom to top, an angle of 270, from top to bottom. The angle setting for the label is ignored if the label is selectable, wrapped, or ellipsized.

Since: 2.6

    method gtk_label_set_angle ( Num $angle )

  * Num $angle; the angle that the baseline of the label makes with the horizontal, in degrees, measured counterclockwise

[[gtk_] label_] get_angle
-------------------------

Gets the angle of rotation for the label. See `gtk_label_set_angle()`.

Returns: the angle of rotation for the label

Since: 2.6

    method gtk_label_get_angle ( --> Num  )

[[gtk_] label_] select_region
-----------------------------

Selects a range of characters in the label, if the label is selectable. See `gtk_label_set_selectable()`. If the label is not selectable, this function has no effect. If *start_offset* or *end_offset* are -1, then the end of the label will be substituted.

    method gtk_label_select_region ( Int $start_offset, Int $end_offset )

  * Int $start_offset; start offset (in characters not bytes)

  * Int $end_offset; end offset (in characters not bytes)

[[gtk_] label_] get_selection_bounds
------------------------------------

Gets the selected range of characters in the label, returning `1` if there’s a selection.

Returns: `1` if selection is non-empty

    method gtk_label_get_selection_bounds ( Int $start, Int $end --> Int  )

  * Int $start; (out): return location for start of selection, as a character offset

  * Int $end; (out): return location for end of selection, as a character offset

[[gtk_] label_] set_single_line_mode
------------------------------------

Sets whether the label is in single line mode.

Since: 2.6

    method gtk_label_set_single_line_mode ( Int $single_line_mode )

  * Int $single_line_mode; `1` if the label should be in single line mode

[[gtk_] label_] get_single_line_mode
------------------------------------

Returns whether the label is in single line mode.

Returns: `1` when the label is in single line mode.

Since: 2.6

    method gtk_label_get_single_line_mode ( --> Int  )

[[gtk_] label_] get_current_uri
-------------------------------

Returns the URI for the currently active link in the label. The active link is the one under the mouse pointer or, in a selectable label, the link in which the text cursor is currently positioned.

This function is intended for use in a *activate-link* handler or for use in a *query-tooltip* handler.

Returns: the currently active URI. The string is owned by GTK+ and must not be freed or modified.

Since: 2.18

    method gtk_label_get_current_uri ( --> Str  )

[[gtk_] label_] set_track_visited_links
---------------------------------------

Sets whether the label should keep track of clicked links (and use a different color for them).

Since: 2.18

    method gtk_label_set_track_visited_links ( Int $track_links )

  * Int $track_links; `1` to track visited links

[[gtk_] label_] get_track_visited_links
---------------------------------------

Returns whether the label is currently keeping track of clicked links.

Returns: `1` if clicked links are remembered

Since: 2.18

    method gtk_label_get_track_visited_links ( --> Int  )

[[gtk_] label_] set_xalign
--------------------------

Sets the *xalign* property for *label*.

Since: 3.16

    method gtk_label_set_xalign ( Num $xalign )

  * Num $xalign; the new xalign value, between 0 and 1

[[gtk_] label_] get_xalign
--------------------------

Gets the *xalign* property for *label*.

Returns: the xalign property

Since: 3.16

    method gtk_label_get_xalign ( --> Num  )

[[gtk_] label_] set_yalign
--------------------------

Sets the *yalign* property for *label*.

Since: 3.16

    method gtk_label_set_yalign ( Num $yalign )

  * Num $yalign; the new yalign value, between 0 and 1

[[gtk_] label_] get_yalign
--------------------------

Gets the *yalign* property for *label*.

Returns: the yalign property

Since: 3.16

    method gtk_label_get_yalign ( --> Num  )

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

### move-cursor

The *move-cursor* signal is a keybinding signal (GtkBindingSignal) which gets emitted when the user initiates a cursor movement. If the cursor is not visible in *entry*, this signal causes the viewport to be moved instead.

Applications should not connect to it, but may emit it with `g_signal_emit_by_name()` if they need to control the cursor programmatically.

The default bindings for this signal come in two variants, the variant with the Shift modifier extends the selection, the variant without the Shift modifer does not. There are too many key combinations to list them all here. - Arrow keys move by individual characters/lines - Ctrl-arrow key combinations move by words/paragraphs - Home/End keys move to the ends of the buffer

    method handler (
      Unknown type GTK_TYPE_MOVEMENT_STEP $step,
      Int $count,
      Int $extend_selection,
      Gnome::GObject::Object :widget($entry),
      *%user-options
    );

  * $entry; the object which received the signal

  * $step; the granularity of the move, as a **Gnome::Gtk3::MovementStep**

  * $count; the number of *step* units to move

  * $extend_selection; `1` if the move should extend the selection

### copy-clipboard

The *copy-clipboard* signal is a [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted to copy the selection to the clipboard.

The default binding for this signal is Ctrl-c.

    method handler (
      Gnome::GObject::Object :widget($label),
      *%user-options
    );

  * $label; the object which received the signal

### populate-popup

The *populate-popup* signal gets emitted before showing the context menu of the label. Note that only selectable labels have context menus.

If you need to add items to the context menu, connect to this signal and append your menuitems to the *menu*.

    method handler (
      Unknown type GTK_TYPE_MENU $menu,
      Gnome::GObject::Object :widget($label),
      *%user-options
    );

  * $label; The label on which the signal is emitted

  * $menu; the menu that is being populated

### activate-current-link

A [keybinding signal][**Gnome::Gtk3::BindingSignal**] which gets emitted when the user activates a link in the label.

Applications may also emit the signal with `g_signal_emit_by_name()` if they need to control activation of URIs programmatically.

The default bindings for this signal are all forms of the Enter key.

Since: 2.18

    method handler (
      Gnome::GObject::Object :widget($label),
      *%user-options
    );

  * $label; The label on which the signal was emitted

### activate-link

The signal which gets emitted to activate a URI. Applications may connect to it to override the default behaviour, which is to call `gtk_show_uri()`.

Returns: `1` if the link has been activated

Since: 2.18

    method handler (
      Str $uri,
      Gnome::GObject::Object :widget($label),
      *%user-options
      --> Int
    );

  * $label; The label on which the signal was emitted

  * $uri; the URI that is activated

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Label

The contents of the label. If the string contains [Pango XML markup][PangoMarkupFormat], you will have to set the *use-markup* property to `1` in order for the label to display the markup attributes. See also `gtk_label_set_markup()` for a convenience function that sets both this property and the *use-markup* property at the same time. If the string contains underlines acting as mnemonics, you will have to set the *use-underline* property to `1` in order for the label to display them.

The **Gnome::GObject::Value** type of property *label* is `G_TYPE_STRING`.

### Attributes

The **Gnome::GObject::Value** type of property *attributes* is `G_TYPE_BOXED`.

### Use markup

The text of the label includes XML markup. See `pango_parse_markup()` Default value: False

The **Gnome::GObject::Value** type of property *use-markup* is `G_TYPE_BOOLEAN`.

### Use underline

If set, an underline in the text indicates the next character should be used for the mnemonic accelerator key Default value: False

The **Gnome::GObject::Value** type of property *use-underline* is `G_TYPE_BOOLEAN`.

### Justification

The alignment of the lines in the text of the label relative to each other. This does NOT affect the alignment of the label within its allocation. See **Gnome::Gtk3::Label**:xalign for that Default value: False

The **Gnome::GObject::Value** type of property *justify* is `G_TYPE_ENUM`.

### X align

The xalign property determines the horizontal aligment of the label text inside the labels size allocation. Compare this to *halign*, which determines how the labels size allocation is positioned in the space available for the label. Since: 3.16

The **Gnome::GObject::Value** type of property *xalign* is `G_TYPE_FLOAT`.

### Y align

The yalign property determines the vertical aligment of the label text inside the labels size allocation. Compare this to *valign*, which determines how the labels size allocation is positioned in the space available for the label. Since: 3.16

The **Gnome::GObject::Value** type of property *yalign* is `G_TYPE_FLOAT`.

### Pattern

A string with _ characters in positions correspond to characters in the text to underline Default value: Any

The **Gnome::GObject::Value** type of property *pattern* is `G_TYPE_STRING`.

### Line wrap

If set, wrap lines if the text becomes too wide Default value: False

The **Gnome::GObject::Value** type of property *wrap* is `G_TYPE_BOOLEAN`.

### Line wrap mode

If line wrapping is on (see the *wrap* property) this controls how the line wrapping is done. The default is `PANGO_WRAP_WORD`, which means wrap on word boundaries. Since: 2.10 Widget type: PANGO_TYPE_WRAP_MODE

The **Gnome::GObject::Value** type of property *wrap-mode* is `G_TYPE_ENUM`.

### Selectable

Whether the label text can be selected with the mouse Default value: False

The **Gnome::GObject::Value** type of property *selectable* is `G_TYPE_BOOLEAN`.

### Mnemonic key

The **Gnome::GObject::Value** type of property *mnemonic-keyval* is `G_TYPE_UINT`.

### Mnemonic widget

The widget to be activated when the label's mnemonic key is pressed Widget type: GTK_TYPE_WIDGET

The **Gnome::GObject::Value** type of property *mnemonic-widget* is `G_TYPE_OBJECT`.

### Cursor Position

The **Gnome::GObject::Value** type of property *cursor-position* is `G_TYPE_INT`.

### Selection Bound

The **Gnome::GObject::Value** type of property *selection-bound* is `G_TYPE_INT`.

### Ellipsize

The preferred place to ellipsize the string, if the label does not have enough room to display the entire string, specified as a **PangoEllipsizeMode**. Note that setting this property to a value other than `PANGO_ELLIPSIZE_NONE` has the side-effect that the label requests only enough space to display the ellipsis "...". In particular, this means that ellipsizing labels do not work well in notebook tabs, unless the **Gnome::Gtk3::Notebook** tab-expand child property is set to `1`. Other ways to set a label's width are `gtk_widget_set_size_request()` and `gtk_label_set_width_chars()`. Since: 2.6 Widget type: PANGO_TYPE_ELLIPSIZE_MODE

The **Gnome::GObject::Value** type of property *ellipsize* is `G_TYPE_ENUM`.

### Width In Characters

The desired width of the label, in characters. If this property is set to -1, the width will be calculated automatically. See the section on [text layout][label-text-layout] for details of how *width-chars* and *max-width-chars* determine the width of ellipsized and wrapped labels. Since: 2.6

The **Gnome::GObject::Value** type of property *width-chars* is `G_TYPE_INT`.

### Single Line Mode

Whether the label is in single line mode. In single line mode, the height of the label does not depend on the actual text, it is always set to ascent + descent of the font. This can be an advantage in situations where resizing the label because of text changes would be distracting, e.g. in a statusbar. Since: 2.6

The **Gnome::GObject::Value** type of property *single-line-mode* is `G_TYPE_BOOLEAN`.

### Angle

The angle that the baseline of the label makes with the horizontal, in degrees, measured counterclockwise. An angle of 90 reads from from bottom to top, an angle of 270, from top to bottom. Ignored if the label is selectable. Since: 2.6

The **Gnome::GObject::Value** type of property *angle* is `G_TYPE_DOUBLE`.

### Maximum Width In Characters

The desired maximum width of the label, in characters. If this property is set to -1, the width will be calculated automatically. See the section on [text layout][label-text-layout] for details of how *width-chars* and *max-width-chars* determine the width of ellipsized and wrapped labels. Since: 2.6

The **Gnome::GObject::Value** type of property *max-width-chars* is `G_TYPE_INT`.

### Track visited links

Set this property to `1` to make the label track which links have been visited. It will then apply the **GTK_STATE_FLAG_VISITED** when rendering this link, in addition to **GTK_STATE_FLAG_LINK**. Since: 2.18

The **Gnome::GObject::Value** type of property *track-visited-links* is `G_TYPE_BOOLEAN`.

### Number of lines

The number of lines to which an ellipsized, wrapping label should be limited. This property has no effect if the label is not wrapping or ellipsized. Set this property to -1 if you don't want to limit the number of lines. Since: 3.10

The **Gnome::GObject::Value** type of property *lines* is `G_TYPE_INT`.

