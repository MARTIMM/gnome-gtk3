Gnome::Gtk3::TreeIter
=====================

Description
===========

A struct that specifies a TreeIter.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TreeIter;
    also is Gnome::GObject::Boxed;

Types
=====

class N-GtkTreeIter
-------------------

The **Gnome::Gtk3::TreeIter** is the primary structure for accessing a **Gnome::Gtk3::TreeModel**. Models are expected to put a unique integer in the *stamp* member, and put model-specific data in the three *user_data* members.

  * Int $.stamp: a unique stamp to catch invalid iterators

  * Pointer $.user_data: model-specific data

  * Pointer $.user_data2: model-specific data

  * Pointer $.user_data3: model-specific data

Methods
=======

new
---

Create an object taking the native object from elsewhere. `.tree-iter-is-valid()` will return True or False depending on the state of the provided object.

    multi method new ( Gnome::Gtk3::TreeIter :$tree-iter! )

tree-iter-is-valid
------------------

Method to test if the native object is valid.

    method tree-iter-is-valid ( --> Bool )

clear-tree-iter
---------------

Frees a `N-GtkTreeIter` struct and after that, tree-iter-is-valid() returns False.

    method clear-tree-iter ( )

[gtk_] tree_iter_copy
---------------------

Creates a dynamically allocated tree iterator as a copy of *iter*.

This function is not intended for use in applications, because you can just copy the structs by value like so;

    Gnome::Gtk3::TreeIter $new_iter .= new(:widget($iter.get-native-object()));

You must free this iter with `clear-tree-iter()`.

Returns: a newly-allocated copy of *iter*

    method gtk_tree_iter_copy ( --> N-GtkTreeIter  )

  * N-GtkTreeIter $iter; a **Gnome::Gtk3::TreeIter**-struct

