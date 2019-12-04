Gnome::Glib::List
=================

linked lists that can be iterated over in both directions

Description
===========

The **Gnome::Glib::List** structure and its associated functions provide a standard doubly-linked list data structure.

Each element in the list contains a piece of data, together with pointers which link to the previous and next elements in the list. Using these pointers it is possible to move through the list in both directions (unlike the singly-linked list, which only allows movement through the list in the forward direction).

The double linked list does not keep track of the number of items and does not keep track of both the start and end of the list.

The data contained in each element can be either integer values,

Note that most of the list functions expect to be passed a pointer to the first element in the list. The functions which insert elements return the new start of the list, which may have changed.

To create an empty jast list call `.new(:empty)`.

To remove elements, use `g_list_remove()`.

To navigate in a list, use `g_list_first()`, `g_list_last()`, `g_list_next()`, `g_list_previous()`.

To find elements in the list use `g_list_nth()`, `g_list_nth_data()`, `g_list_find()` and `g_list_find_custom()`.

To find the index of an element use `g_list_position()` and `g_list_index()`.

To free the entire list, use `clear-list()` which invalidates the list after freeing the memory.

Most of the time there is no need to manipulate the list because many of the GTK+ functions will return a list of e.g. children in a container which only need to be examined.

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::List;

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :empty! )

Create a new list object using an other native list object.

    multi method new ( N-GError :$glist! )

list-is-valid
-------------

Returns True if native list object is valid, otherwise `False`.

    method list-is-valid ( --> Bool )

clear-error
-----------

Clear the list and data. The list object is not valid after this call and list-is-valid() will return `False`.

    method clear-list ()

[g_] list_copy
--------------

Copies a **N-GList**.

Note that this is a "shallow" copy. If the list elements consist of pointers to data, the pointers are copied but the actual data is not. See `g_list_copy_deep()` if you need to copy the data as well.

Returns: the start of the new list that holds the same data as this list.

    method g_list_copy ( --> Gnome::Glib::List )

[g_] list_nth
-------------

Gets the element at the given position in a **Gnome::Glib::List**.

This iterates over the list until it reaches the *n*-th position. If you intend to iterate over every element, it is better to use a for-loop as described in the **Gnome::Glib::List** introduction.

Returns: the element, or `Any` if the position is off the end of the **Gnome::Glib::List**

    method g_list_nth ( guInt $n --> N-GList  )

  * guInt $n; the position of the element, counting from 0

[g_] list_last
--------------

Gets the last element in a **Gnome::Glib::List**, or `Any` if the **Gnome::Glib::List** has no elements.

    method g_list_last ( --> N-GList  )

[g_] list_first
---------------

Gets the first element in a **Gnome::Glib::List**, or `Any` if the **Gnome::Glib::List** has no elements

    method g_list_first ( --> N-GList  )

[g_] list_length
----------------

Gets the number of elements in a **Gnome::Glib::List**.

This function iterates over the whole list to count its elements.

Returns: the number of elements in the **Gnome::Glib::List**

    method g_list_length ( --> UInt  )

[g_] list_foreach
-----------------

Calls a function for each element of a **Gnome::Glib::List**.

It is safe for *$func* to remove the element from the list, but it must not modify any part of the list after that element.

    method g_list_foreach ( Callable $func, Pointer $user_data )

  * Callable $func; the function to call with each element's data

  * Pointer $user_data; user data to pass to the function

[[g_] list_] nth_data
---------------------

Gets the data of the element at the given position.

This iterates over the list until it reaches the *n*-th position. If you intend to iterate over every element, it is better to use a for-loop as described in the **Gnome::Glib::List** introduction.

Returns: the element's data, or `Any` if the position is off the end of the **Gnome::Glib::List**

    method g_list_nth_data ( UInt $n --> Pointer  )

  * UInt $n; the position of the element

