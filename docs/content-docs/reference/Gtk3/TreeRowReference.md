Gnome::Gtk3::TreeRowReference
=============================

Description
===========

A class that keeps a reference to a row in a list or tree. When set, this reference will keep pointing to the node, as long as it exists. Any changes that occur on the list or tree model are propagated, and the path is updated appropriately.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::TreeRowReference;
    also is Gnome::GObject::Boxed;

Types
=====

class N-GtkTreeRowReference
---------------------------

Methods
=======

new
---

Create an object taking the native object from elsewhere.

    multi method new ( N-GtkTreeRowReference :tree-row-reference! )

tree-row-reference-is-valid
---------------------------

Method to test if the native object is valid.

    method tree-row-reference-is-valid ( --> Bool )

clear-tree-row-reference
------------------------

Frees the native `N-GtkTreeRowReference` object and after that, tree-row-reference-is-valid() returns False.

    method clear-tree-row-reference ( )

gtk_tree_row_reference_get_path
-------------------------------

Returns a path that the row reference currently points to, or `Any` if the path pointed to is no longer valid.

    method gtk_tree_row_reference_get_path ( --> Gnome::Gtk3::TreePath )

gtk_tree_row_reference_get_model
--------------------------------

Returns the model that the row reference is monitoring.

Since: 2.8

    method gtk_tree_row_reference_get_model ( --> N-GObject  )

gtk_tree_row_reference_copy
---------------------------

Copies a **Gnome::Gtk3::TreeRowReference**.

Since: 2.2

    method gtk_tree_row_reference_copy ( --> N-GtkTreeRowReference  )

