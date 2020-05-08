Gnome::Gtk3::Spinner
====================

Show a spinner animation

![](images/spinner.png)

Description
===========

A **Gnome::Gtk3::Spinner** widget displays an icon-size spinning animation. It is often used as an alternative to a **Gnome::Gtk3::ProgressBar** for displaying indefinite activity, instead of actual progress.

To start the animation, use `gtk_spinner_start()`, to stop it use `gtk_spinner_stop()`.

Css Nodes
---------

**Gnome::Gtk3::Spinner** has a single CSS node with the name spinner. When the animation is active, the *checked* pseudoclass is added to this node.

See Also
--------

**Gnome::Gtk3::CellRendererSpinner**, **Gnome::Gtk3::ProgressBar**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Spinner;
    also is Gnome::Gtk3::Widget;

Methods
=======

new
---

Create a new default object.

    multi method new ( )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

gtk_spinner_new
---------------

Returns a new spinner widget. Not yet started.

Returns: a new **Gnome::Gtk3::Spinner**

Since: 2.20

    method gtk_spinner_new ( --> N-GObject )

gtk_spinner_start
-----------------

Starts the animation of the spinner.

Since: 2.20

    method gtk_spinner_start ( )

gtk_spinner_stop
----------------

Stops the animation of the spinner.

Since: 2.20

    method gtk_spinner_stop ( )

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### Active

Whether the spinner is active Default value: False

The **Gnome::GObject::Value** type of property *active* is `G_TYPE_BOOLEAN`.

