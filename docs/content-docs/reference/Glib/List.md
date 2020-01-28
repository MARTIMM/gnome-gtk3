Gnome::Glib::List
=================

linked lists that can be iterated over in both directions

Description
===========

The **Gnome::Glib::List** structure and its associated functions provide a standard doubly-linked list data structure.

Each element in the list contains a piece of data, together with pointers which link to the previous and next elements in the list. Using these pointers it is possible to move through the list in both directions (unlike the singly-linked list, which only allows movement through the list in the forward direction).

The double linked list does not keep track of the number of items and does not keep track of both the start and end of the list. The data contained in each element can be either simple values like integer or real numbers or pointers to any type of data.

Note that most of the list functions expect to be passed a pointer to the first element in the list.

To create an empty list just call `.new`.

Raku does have plenty ways of its own two handle data for any kind of problem so a doubly linked list is note really needed. This class, however, is provided (partly) to handle returned information from other GTK+ methods. E.g. A Container can return child widgets in a List like this.

To navigate in a list, use `g_list_first()`, `g_list_last()`, `next()`, `previous()`.

To find elements in the list use `g_list_nth()`, `g_list_nth_data()`, `g_list_foreach()` and `g_list_find_custom()`.

To free the entire list, use `clear-object()` which invalidates the list after freeing the memory.

Most of the time there is no need to manipulate the list because many of the GTK+ functions will return a list of e.g. children in a container which only need to be examined.

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::List;

Example 1
---------

To visit all elements in the list, use a loop over the list:

    my Gnome::Glib::List $ll = $list;
    while ?$ll {
      ... do something with data in $ll.data ...
      $ll .= next;
    }

Example 2
---------

To call a function for each element in the list, use `g_list_foreach()`.

    class H {
      method h ( Gnome::Glib::List $hl, Int $hi, Pointer $hd ) {
       ... do something with the list item $hl at index $hi and data $hd ...
      }

      ...
    }

    $list.list-foreach( H.new, 'h');

Methods
=======

new
---

Create a new plain object.

    multi method new ( )

Create a new list object using an other native list object.

    multi method new ( N-GError :$glist! )

is-valid
--------

Returns True if native list object is valid, otherwise `False`.

    method is-valid ( --> Bool )

clear-object
------------

Clear the list and data. The list object is not valid after this call and is-valid() will return `False`.

    method clear-object ()

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

    method g_list_nth ( UInt $n --> N-GList  )

  * UInt $n; the position of the element, counting from 0

[[g_] list_] find_custom
------------------------

Finds an element in a **Gnome::Glib::List**, using a supplied function to find the desired element. It iterates over the list, calling the given function which should return 0 when the desired element is found. The function takes two **Pointer** arguments, the **Gnome::Glib::List** element's data as the first argument and the given user data.

Returns: the found **Gnome::Glib::List** element, or undefined if it is not found

    method g_list_find_custom (
      $func-object, Str $func-name, *%user-data
      --> N-GList
    )

  * Pointer $data; user data passed to the function

  * Callable $func; the function to call for each element. It should return 0 when the desired element is found. When the function returns an undefined value it is assumed that it didn't find a result (=1).

The function must be defined as follows;

    method search-handler ( Pointer $list-data, *%user-data --> Int )

An example where a search is done through a list of widgets returned from, for example, a grid. Such a search could be started after an 'ok' or 'apply' button is clicked on a configuration screen.

    class MySearchEngine {
      method search ( Pointer $list-data, :$widget-name, :$widget-text --> Int ) {

      my Gnome::Gtk3::Widget $w .= new(:native-object($list-data));
      my Str $wname = $w.widget-get-name;

      # stop when specified widget is found
      $wname eq $widget-name ?? 0 !! 1
    }

    # prepare grid
    my Gnome::Gtk3::Grid $g .= new;
    ... a label ...
    ... then an input field ...
    my Gnome::Gtk3::Entry $e .= new;
    $e.set-name('db-username');
    $g.grid-attach( $e, 1, 0, 1, 1);
    ... more fields to specify ...

    # search for an item (in a button click handler)
    my Gnome::Glib::List $list .= new(:native-object($g.get-children));
    if my N-GList $sloc = $list.g_list_find_custom(
      MySearchEngine.new, 'search', :widget-name('db-username')
    ) {
      ... get data from found widget ...
    }

This example might not be the best choice when all fields are searched through this way because most elements are passed multiple times after all tests. To prevent this, one could continue the search from where it returned a defined list. The other option is to use `g_list_foreach()` defined below.

[g_] list_last
--------------

Gets the last element in a **Gnome::Glib::List**, or undefined if the **Gnome::Glib::List** has no elements.

    method g_list_last ( --> Gnome::Glib::List )

[g_] list_first
---------------

Gets the first element in a **Gnome::Glib::List**, or undefined if the **Gnome::Glib::List** has no elements

    method g_list_first ( --> Gnome::Glib::List )

next
----

Gets the next element in a **Gnome::Glib::List**, or undefined if the **Gnome::Glib::List** has no more elements.

    method next ( --> Gnome::Glib::List )

previous
--------

Gets the previous element in a **Gnome::Glib::List**, or undefined if the **Gnome::Glib::List** is at the beginning of the list.

    method previous ( --> Gnome::Glib::List )

data
----

Gets the data from the current **Gnome::Glib::List** position.

    method data ( --> Gnome::Glib::List )

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

