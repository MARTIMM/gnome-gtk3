TITLE
=====

Gnome::Gtk3::Orientable

SUBTITLE
========

Orientable — An interface for flippable widgets

    unit class Gnome::Gtk3::Orientable;
    also is Gnome::Glib::GInterface;

Synopsis
========

    my Gnome::Gtk3::LevelBar $level-bar .= new(:empty);
    my Gnome::Gtk3::Orientable $o .= new(:widget($level-bar));
    $o.set-orientation(GTK_ORIENTATION_VERTICAL);

Methods
=======

new
---

Create an orientable object.

    multi method new ( :$widget )

Create an orientable object using a native object from elsewhere. See also Gnome::GObject::Object.

[gtk_orientable_] set_orientation
---------------------------------

    method gtk_orientable_get_orientation ( GtkOrientation )

Sets the orientation of the orientable. This is a GtkOrientation enum type defined in GtkEnums.

[gtk_orientable_] get_orientation
---------------------------------

    method gtk_orientable_get_orientation ( --> GtkOrientation $orientation )

Set the orientation of the orientable. This is a GtkOrientation enum type defined in GtkEnums.

