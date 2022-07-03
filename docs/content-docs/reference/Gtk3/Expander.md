Gnome::Gtk3::Expander
=====================

A container which can hide its child

Description
===========

A **Gnome::Gtk3::Expander** allows the user to hide or show its child by clicking on an expander triangle similar to the triangles used in a **Gnome::Gtk3::TreeView**.

Normally you use an expander as you would use any other descendant of **Gnome::Gtk3::Bin**; you create the child widget and use `add()` to add it to the expander. When the expander is toggled, it will take care of showing and hiding the child automatically.

**Gnome::Gtk3::Expander** as **Gnome::Gtk3::Buildable**
-------------------------------------------------------

The **Gnome::Gtk3::Expander** implementation of the **Gnome::Gtk3::Buildable** interface supports placing a child in the label position by specifying “label” as the “type” attribute of a <child> element. A normal content child can be specified without specifying a <child> type attribute.

An example of a UI definition fragment with GtkExpander:

    <object class="GtkExpander">
      <child type="label">
        <object class="GtkLabel" id="expander-label"/>
      </child>
      <child>
        <object class="GtkEntry" id="expander-content"/>
      </child>
    </object>

Css Nodes
---------

    expander
    ├── title
    │  ├── arrow
    │  ╰── <label widget>
    ╰── <child>

**Gnome::Gtk3::Expander** has three CSS nodes, the main node with the name expander, a subnode with name title and node below it with name arrow. The arrow of an expander that is showing its child gets the :checked pseudoclass added to it.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Expander;
    also is Gnome::Gtk3::Bin;

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::Expander;

    unit class MyGuiClass;
    also is Gnome::Gtk3::Expander;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::Expander class process the options
      self.bless( :GtkExpander, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Types
=====

Methods
=======

new
---

### :label

Create a new Expander object using *label* as the text of the label.

    multi method new ( Str :$label! )

### :mnemonic

Creates a new expander using *label* as the text of the label. If characters in *label* are preceded by an underscore, they are underlined. If you need a literal underscore character in a label, use “__” (two underscores). The first underlined character represents a keyboard accelerator called a mnemonic. Pressing Alt and that key activates the button.

    multi method new ( Str :$mnemonic! )

### :native-object

Create a Expander object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a Expander object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

get-expanded
------------

Queries a **Gnome::Gtk3::Expander** and returns its current state. Returns `True` if the child widget is revealed.

See `set_expanded()`.

Returns: the current state of the expander

    method get-expanded ( --> Bool )

get-label
---------

Fetches the text from a label widget including any embedded underlines indicating mnemonics and Pango markup, as set by `set_label()`. If the label text has not been set the return value will be `undefined`. This will be the case if you create an empty button with `gtk_button_new()` to use as a container.

Note that this function behaved differently in versions prior to 2.14 and used to return the label text stripped of embedded underlines indicating mnemonics and Pango markup. This problem can be avoided by fetching the label text directly from the label widget.

Returns: The text of the label widget. This string is owned by the widget and must not be modified or freed.

    method get-label ( --> Str )

get-label-fill
--------------

Returns whether the label widget will fill all available horizontal space allocated to this expander.

Returns: `True` if the label widget will fill all available horizontal space

    method get-label-fill ( --> Bool )

get-label-widget
----------------

Retrieves the label widget for the frame. See `set_label_widget()`.

Returns: the label widget, or `undefined` if there is none

    method get-label-widget ( --> N-GObject )

get-resize-toplevel
-------------------

Returns whether the expander will resize the toplevel widget containing the expander upon resizing and collpasing.

Returns: the “resize toplevel” setting.

    method get-resize-toplevel ( --> Bool )

get-spacing
-----------

Gets the value set by `set_spacing()`.

Returns: spacing between the expander and child

Deprecated: 3.20: Use margins on the child instead.

    method get-spacing ( --> Int )

get-use-markup
--------------

Returns whether the label’s text is interpreted as marked up with the [Pango text markup language][PangoMarkupFormat]. See `set_use_markup()`.

Returns: `True` if the label’s text will be parsed for markup

    method get-use-markup ( --> Bool )

get-use-underline
-----------------

Returns whether an embedded underline in the expander label indicates a mnemonic. See `set_use_underline()`.

Returns: `True` if an embedded underline in the expander label indicates the mnemonic accelerator keys

    method get-use-underline ( --> Bool )

set-expanded
------------

Sets the state of the expander. Set to `True`, if you want the child widget to be revealed, and `False` if you want the child widget to be hidden.

    method set-expanded ( Bool $expanded )

  * $expanded; whether the child widget is revealed

set-label
---------

Sets the text of the label of the expander to *label*.

This will also clear any previously set labels.

    method set-label ( Str $label )

  * $label; a string

set-label-fill
--------------

Sets whether the label widget should fill all available horizontal space allocated to *expander*.

Note that this function has no effect since 3.20.

    method set-label-fill ( Bool $label_fill )

  * $label_fill; `True` if the label should should fill all available horizontal space

set-label-widget
----------------

Set the label widget for the expander. This is the widget that will appear embedded alongside the expander arrow.

    method set-label-widget ( N-GObject() $label_widget )

  * $label_widget; the new label widget

set-resize-toplevel
-------------------

Sets whether the expander will resize the toplevel widget containing the expander upon resizing and collpasing.

    method set-resize-toplevel ( Bool $resize_toplevel )

  * $resize_toplevel; whether to resize the toplevel

set-spacing
-----------

Sets the spacing field of *expander*, which is the number of pixels to place between expander and the child.

Deprecated: 3.20: Use margins on the child instead.

    method set-spacing ( Int() $spacing )

  * $spacing; distance between the expander and child in pixels

set-use-markup
--------------

Sets whether the text of the label contains markup in [Pango’s text markup language][PangoMarkupFormat]. See `gtk_label_set_markup()`.

    method set-use-markup ( Bool $use_markup )

  * $use_markup; `True` if the label’s text should be parsed for markup

set-use-underline
-----------------

If true, an underline in the text of the expander label indicates the next character should be used for the mnemonic accelerator key.

    method set-use-underline ( Bool $use_underline )

  * $use_underline; `True` if underlines in the text indicate mnemonics

Signals
=======

activate
--------

    method handler (
      Gnome::Gtk3::Expander :_widget($expander),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )

  * $expander; The instance which registered the signal

  * $_handler-id; The handler id which is returned from the registration

  * $_native-object; The native object provided by the caller wrapped in the Raku object.

  * %user-options; A list of named arguments provided at the `register-signal()` method

Properties
==========

expanded
--------

Whether the expander has been opened to reveal the child widget

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Parameter is set on construction of object.

  * Default value is FALSE.

label
-----

Text of the expander's label

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is readable and writable.

  * Parameter is set on construction of object.

  * Default value is undefined.

label-fill
----------

Whether the label widget should fill all available horizontal space

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Parameter is set on construction of object.

  * Default value is FALSE.

label-widget
------------

A widget to display in place of the usual expander label

  * **Gnome::GObject::Value** type of this property is G_TYPE_OBJECT

  * The type of this G_TYPE_OBJECT object is GTK_TYPE_WIDGET

  * Parameter is readable and writable.

resize-toplevel
---------------

Whether the expander will resize the toplevel window upon expanding and collapsing

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Default value is FALSE.

use-markup
----------

The text of the label includes XML markup. See `pango_parse_markup()`

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Parameter is set on construction of object.

  * Default value is FALSE.

use-underline
-------------

If set, an underline in the text indicates the next character should be used for the mnemonic accelerator key

  * **Gnome::GObject::Value** type of this property is G_TYPE_BOOLEAN

  * Parameter is readable and writable.

  * Parameter is set on construction of object.

  * Default value is FALSE.

