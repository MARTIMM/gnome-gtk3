Gnome::Gtk3::TargetTable
========================

Description
===========

Convenience class to create and handle TargetTable structures.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TargetTable;

Methods
=======

new
---

### :list

Create a new TargetTable object using data from **Gnome::Gtk3::TargetList**.

    multi method new ( N-GObject :list! )

### :array

Create a new TargetTable object using data from **Array[Gnome::Gtk3::TargetEntry]**.

    multi method new ( Array :array! )

get-array
---------

Get an array of **N-GtkTargetEntry** or **Gnome::Gtk3::TargetEntry**.

    method get-array ( --> Array[N-GtkTargetEntry] )

