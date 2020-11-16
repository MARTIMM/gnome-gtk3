Gnome::Gtk3::Adjustment
=======================

A representation of an adjustable bounded value

Description
===========

The **Gnome::Gtk3::Adjustment** object represents a value which has an associated lower and upper bound, together with step and page increments, and a page size. It is used within several GTK+ widgets, including **Gnome::Gtk3::SpinButton**, **Gnome::Gtk3::Viewport**, and **Gnome::Gtk3::Range** (which is a base class for **Gnome::Gtk3::Scrollbar** and **Gnome::Gtk3::Scale**).

The **Gnome::Gtk3::Adjustment** object does not update the value itself. Instead it is left up to the owner of the **Gnome::Gtk3::Adjustment** to control the value.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Adjustment;
    also is Gnome::GObject::InitiallyUnowned;

Uml Diagram
-----------

![](plantuml/SpinButton.svg)

Methods
=======

new
---

new( :value, :lower, :upper, :step-increment, :page-increment, :page-size)
--------------------------------------------------------------------------

Create a new Adjustment object.

    multi method new (
      num64 $value!, num64 $lower!, num64 $upper!, num64 $step-increment!,
      num64 $page-increment!, num64 $page-size!
    )

  * Num $value; the initial value.

  * Num $lower; the minimum value.

  * Num $upper; the maximum value

  * Num $step_increment; the step increment

  * Num $page_increment; the page increment

  * Num $page_size; the page size

[gtk_adjustment_] clamp_page
----------------------------

Updates the *value* property to ensure that the range between *lower* and *upper* is in the current page (i.e. between *value* and *value* + *page-size*). If the range is larger than the page size, then only the start of it will be in the current page.

A *value-changed* signal will be emitted if the value is changed.

    method gtk_adjustment_clamp_page ( Num $lower, Num $upper )

  * Num $lower; the lower value

  * Num $upper; the upper value

[gtk_adjustment_] get_value
---------------------------

Gets the current value of the adjustment. See `gtk_adjustment_set_value()`.

Returns: The current value of the adjustment

    method gtk_adjustment_get_value ( --> Num )

[gtk_adjustment_] set_value
---------------------------

Sets the **Gnome::Gtk3::Adjustment** value. The value is clamped to lie between *lower* and *upper*.

Note that for adjustments which are used in a **Gnome::Gtk3::Scrollbar**, the effective range of allowed values goes from *lower* to *upper* - *page-size*.

    method gtk_adjustment_set_value ( Num $value )

  * Num $value; the new value

[gtk_adjustment_] get_lower
---------------------------

Retrieves the minimum value of the adjustment.

Returns: The current minimum value of the adjustment

    method gtk_adjustment_get_lower ( --> Num )

[gtk_adjustment_] set_lower
---------------------------

Sets the minimum value of the adjustment.

When setting multiple adjustment properties via their individual setters, multiple *changed* signals will be emitted. However, since the emission of the *changed* signal is tied to the emission of the *notify* signals of the changed properties, it’s possible to compress the *changed* signals into one by calling `g_object_freeze_notify()` and `g_object_thaw_notify()` around the calls to the individual setters.

Alternatively, using a single `g_object_set()` for all the properties to change, or using `gtk_adjustment_configure()` has the same effect of compressing *changed* emissions.

    method gtk_adjustment_set_lower ( Num $lower )

  * Num $lower; the new minimum value

[gtk_adjustment_] get_upper
---------------------------

Retrieves the maximum value of the adjustment.

    method gtk_adjustment_get_upper ( --> Num )

[gtk_adjustment_] set_upper
---------------------------

Sets the maximum value of the adjustment. Note that values will be restricted by `upper - page-size` if the page-size property is nonzero.

See `gtk_adjustment_set_lower()` about how to compress multiple emissions of the *changed* signal when setting multiple adjustment properties.

    method gtk_adjustment_set_upper ( Num $upper )

  * Num $upper; the new maximum value

[gtk_adjustment_] get_step_increment
------------------------------------

Retrieves the step increment of the adjustment.

    method gtk_adjustment_get_step_increment ( --> Num )

[gtk_adjustment_] set_step_increment
------------------------------------

Sets the step increment of the adjustment.

See `gtk_adjustment_set_lower()` about how to compress multiple emissions of the *changed* signal when setting multiple adjustment properties.

    method gtk_adjustment_set_step_increment ( Num $step_increment )

  * Num $step_increment; the new step increment

[gtk_adjustment_] get_page_increment
------------------------------------

Retrieves the page increment of the adjustment.

    method gtk_adjustment_get_page_increment ( --> Num )

[gtk_adjustment_] set_page_increment
------------------------------------

Sets the page increment of the adjustment. See `gtk_adjustment_set_lower()` about how to compress multiple emissions of the *changed* signal when setting multiple adjustment properties.

    method gtk_adjustment_set_page_increment ( Num $page_increment )

  * Num $page_increment; the new page increment

[gtk_adjustment_] get_page_size
-------------------------------

Retrieves the page size of the adjustment.

    method gtk_adjustment_get_page_size ( --> Num )

[gtk_adjustment_] set_page_size
-------------------------------

Sets the page size of the adjustment. See `gtk_adjustment_set_lower()` about how to compress multiple emissions of the **Gnome::Gtk3::Adjustment**::changed signal when setting multiple adjustment properties.

    method gtk_adjustment_set_page_size ( Num $page_size )

  * Num $page_size; the new page size

gtk_adjustment_configure
------------------------

Sets all properties of the adjustment at once. Use this function to avoid multiple emissions of the *changed* signal. See `gtk_adjustment_set_lower()` for an alternative way of compressing multiple emissions of *changed* into one.

    method gtk_adjustment_configure ( Num $value, Num $lower, Num $upper, Num $step_increment, Num $page_increment, Num $page_size )

  * Num $value; the new value

  * Num $lower; the new minimum value

  * Num $upper; the new maximum value

  * Num $step_increment; the new step increment

  * Num $page_increment; the new page increment

  * Num $page_size; the new page size

[gtk_adjustment_] get_minimum_increment
---------------------------------------

Gets the smaller of step increment and page increment.

    method gtk_adjustment_get_minimum_increment ( --> Num )

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `g_signal_connect_object()` directly from **Gnome::GObject::Signal**.

First method
------------

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes `:$widget` and user data are optional.

    # handler method
    method mouse-event ( N-GdkEvent $event, :$widget ) { ... }

    # connect a signal on window object
    my Gnome::Gtk3::Window $w .= new( ... );
    $w.register-signal( self, 'mouse-event', 'button-press-event');

Second method
-------------

    my Gnome::Gtk3::Window $w .= new( ... );
    my Callable $handler = sub (
      N-GObject $native, N-GdkEvent $event, OpaquePointer $data
    ) {
      ...
    }

    $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `g_signal_connect_object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### changed

Emitted when one or more of the **Gnome::Gtk3::Adjustment** properties have been changed, other than the *value* property.

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($adjustment),
      *%user-options
    );

  * $adjustment; the object which received the signal

### value-changed

Emitted when the *value* property has been changed.

    method handler (
      Int :$_handler_id,
      Gnome::GObject::Object :_widget($adjustment),
      *%user-options
    );

  * $adjustment; the object which received the signal

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Value

The value of the adjustment.

The **Gnome::GObject::Value** type of property *value* is `G_TYPE_DOUBLE`.

### Minimum Value

The minimum value of the adjustment.

The **Gnome::GObject::Value** type of property *lower* is `G_TYPE_DOUBLE`.

### Maximum Value

The maximum value of the adjustment. Note that values will be restricted by `upper - page-size` if the page-size property is nonzero.

The **Gnome::GObject::Value** type of property *upper* is `G_TYPE_DOUBLE`.

### Step Increment

The step increment of the adjustment.

The **Gnome::GObject::Value** type of property *step-increment* is `G_TYPE_DOUBLE`.

### Page Increment

The page increment of the adjustment.

The **Gnome::GObject::Value** type of property *page-increment* is `G_TYPE_DOUBLE`.

### Page Size

The page size of the adjustment. Note that the page-size is irrelevant and should be set to zero if the adjustment is used for a simple scalar value, e.g. in a **Gnome::Gtk3::SpinButton**.

The **Gnome::GObject::Value** type of property *page-size* is `G_TYPE_DOUBLE`.

