Gnome::Gtk3::Frame
==================

A bin with a decorative frame and optional label

![](images/frame.png)

Description
===========

The frame widget is a bin that surrounds its child with a decorative frame and an optional label. If present, the label is drawn in a gap in the top side of the frame. The position of the label can be controlled with `gtk_frame_set_label_align()`.

**Gnome::Gtk3::Frame** as **Gnome::Gtk3::Buildable**
----------------------------------------------------

The **Gnome::Gtk3::Frame** implementation of the **Gnome::Gtk3::Buildable** interface supports placing a child in the label position by specifying “label” as the “type” attribute of a <child> element. A normal content child can be specified without specifying a <child> type attribute.

An example of a UI definition fragment with **Gnome::Gtk3::Frame**:

    <object class="GtkFrame">
      <child type="label">
        <object class="GtkLabel" id="frame-label"/>
      </child>
      <child>
        <object class="GtkEntry" id="frame-content"/>
      </child>
    </object>

Css Nodes
---------

    frame
    ├── border[.flat]
    ├── <label widget>
    ╰── <child>

**Gnome::Gtk3::Frame** has a main CSS node named “frame” and a subnode named “border”. The “border” node is used to draw the visible border. You can set the appearance of the border using CSS properties like “border-style” on the “border” node.

The border node can be given the style class “.flat”, which is used by themes to disable drawing of the border. To do this from code, call `gtk_frame_set_shadow_type()` with `GTK_SHADOW_NONE` to add the “.flat” class or any other shadow type to remove it.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Frame;
    also is Gnome::Gtk3::Bin;

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::Frame:api<1>;

    unit class MyGuiClass;
    also is Gnome::Gtk3::Frame;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::Frame class process the options
      self.bless( :GtkFrame, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Methods
=======

new
---

### default, no options

Create a new default Frame.

    multi method new ( )

### :label

Create a new Frame with a label.

    multi method new ( :label! )

### :native-object

Create a Frame object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a Frame object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

get-label
---------

If the frame’s label widget is a **Gnome::Gtk3::Label**, returns the text in the label widget. (The frame will have a **Gnome::Gtk3::Label** for the label widget if a non-`undefined` argument was passed to `new()`.)

Returns: the text in the label, or `undefined` if there was no label widget or the lable widget was not a **Gnome::Gtk3::Label**. This string is owned by GTK+ and must not be modified or freed.

    method get-label ( --> Str )

get-label-align
---------------

Retrieves the X and Y alignment of the frame’s label. See `set_label_align()`.

    method get-label-align ( --> List )

The list has the following items

  * $xalign; X alignment of frame’s label, or `undefined`

  * $yalign; Y alignment of frame’s label, or `undefined`

get-label-widget
----------------

Retrieves the label widget for the frame. See `set_label_widget()`.

Returns: the label widget, or `undefined` if there is none.

    method get-label-widget ( --> N-GObject )

get-shadow-type
---------------

Retrieves the shadow type of the frame. See `set_shadow_type()`.

Returns: the current shadow type of the frame.

    method get-shadow-type ( --> GtkShadowType )

set-label
---------

Removes the current *label-widget*. If *label* is not `undefined`, creates a new **Gnome::Gtk3::Label** with that text and adds it as the *label-widget*.

    method set-label ( Str $label )

  * $label; the text to use as the label of the frame

set-label-align
---------------

Sets the alignment of the frame widget’s label. The default values for a newly created frame are 0.0 and 0.5.

    method set-label-align ( Num() $xalign, Num() $yalign )

  * $xalign; The position of the label along the top edge of the widget. A value of 0.0 represents left alignment; 1.0 represents right alignment.

  * $yalign; The y alignment of the label. A value of 0.0 aligns under the frame; 1.0 aligns above the frame. If the values are exactly 0.0 or 1.0 the gap in the frame won’t be painted because the label will be completely above or below the frame.

set-label-widget
----------------

Sets the *label-widget* for the frame. This is the widget that will appear embedded in the top edge of the frame as a title.

    method set-label-widget ( N-GObject() $label_widget )

  * $label_widget; the new label widget

set-shadow-type
---------------

Sets the *shadow-type* for *frame*, i.e. whether it is drawn without (`GTK_SHADOW_NONE`) or with (other values) a visible border. Values other than `GTK_SHADOW_NONE` are treated identically by GtkFrame. The chosen type is applied by removing or adding the .flat class to the CSS node named border.

    method set-shadow-type ( GtkShadowType $type )

  * $type; the new **Gnome::Gtk3::ShadowType**

Properties
==========

label
-----

Text of the frame's label

  * **Gnome::GObject::Value** type of this property is G_TYPE_STRING

  * Parameter is readable and writable.

  * Default value is undefined.

label-widget
------------

A widget to display in place of the usual frame label

  * **Gnome::GObject::Value** type of this property is G_TYPE_OBJECT

  * The type of this G_TYPE_OBJECT object is GTK_TYPE_WIDGET

  * Parameter is readable and writable.

label-xalign
------------

The horizontal alignment of the label

  * **Gnome::GObject::Value** type of this property is G_TYPE_FLOAT

  * Parameter is readable and writable.

  * Minimum value is 0.0.

  * Maximum value is 1.0.

  * Default value is 0.0.

label-yalign
------------

The vertical alignment of the label

  * **Gnome::GObject::Value** type of this property is G_TYPE_FLOAT

  * Parameter is readable and writable.

  * Minimum value is 0.0.

  * Maximum value is 1.0.

  * Default value is 0.5.

shadow-type
-----------

Appearance of the frame border

  * **Gnome::GObject::Value** type of this property is G_TYPE_ENUM

  * The type of this G_TYPE_ENUM object is GTK_TYPE_SHADOW_TYPE

  * Parameter is readable and writable.

  * Default value is GTK_SHADOW_ETCHED_IN.

