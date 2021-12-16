Gnome::N::TopLevelClassSupport
==============================

Top most class providing internally used methods and subroutines.

Description
===========

The **Gnome::N::TopLevelClassSupport** is the class at the top of the food chain. Most, if not all, are inheriting from this class. Its purpose is to provide convenience methods, processing and storing native objects, etcetera.

Synopsis
========

Declaration
-----------

    unit class Gnome::N::TopLevelClassSupport;

Methods
=======

new
---

Please note that this class is mostly not instantiated directly but is used indirectly when child classes are instantiated.

### :native-object

Create a Raku object using a native object from elsewhere. $native-object can be a N-GObject or a Raku object like `Gnome::Gtk3::Button`.

    method new ( :$native-object! )

### Example

    # Some set of radio buttons grouped together
    my Gnome::Gtk3::RadioButton $rb1 .= new(:label('Download everything'));
    my Gnome::Gtk3::RadioButton $rb2 .= new(
      :group-from($rb1), :label('Download core only')
    );

    # Get all radio buttons in the group of button $rb2
    my Gnome::GObject::SList $rb-list .= new(:native-object($rb2.get-group));
    loop ( Int $i = 0; $i < $rb-list.g_slist_length; $i++ ) {
      # Get button from the list
      my Gnome::Gtk3::RadioButton $rb .= new(
        :native-object(native-cast( N-GObject, $rb-list.nth($i)))
      );

      # If radio button is selected (=active) ...
      if $rb.get-active {
        ...

        last;
      }
    }

get-class-gtype
---------------

Get type code of this native object which is set when object was created.

    method get-class-gtype ( --> GType )

get-class-name
--------------

Return native class name.

    method get-class-name ( --> Str )

native-object-ref
-----------------

Absolute method needed to be defined in all child classes to do reference count administration.

    method native-object-ref ( $n-native-object ) { !!! }

native-object-unref
-------------------

Absolute method needed to be defined in all child classes to do reference count administration.

    method native-object-unref ( $n-native-object ) { !!! }

is-valid
--------

Returns True if native object is valid. When `False`, the native object is undefined and errors will occur when this instance is used.

    method is-valid ( --> Bool )

clear-object
------------

Clear the error and return data to memory pool. The error object is not valid after this call and `is-valid()` will return `False`.

    method clear-object ()

Internally used methods
=======================

_get-native-object
------------------

Get the native object with reference counting by default. When $ref is `False`, reference counting is not done. When False, it is the same as calling `_get-native-object-no-reffing()`.

    method _get-native-object ( Bool :$ref = True )

_get-native-object-no-reffing
-----------------------------

Get the native object without reference counting.

    method _get-native-object-no-reffing ( )

_set-native-object
------------------

Set the native object. This happens mostly when a native object is created.

    method _set-native-object ( $native-object )

_set-builder
------------

Used by **Gnome::Gtk3::Builder** to register itself. Its purpose is twofold

  * Used by **Gnome::GObject::Object** to process option `.new(:build-id)`.

  * Used to insert objects into a builder when test mode is turned on.

    method _set-builder ( Gnome::Gtk3::Builder$builder )

_get-builders
-------------

Used by **Gnome::GObject::Object** to search for an object id.

    method _get-builders ( --> Array )

_set-test-mode
--------------

Used to turn test mode on or off. This is done by **Gnome::T**. When turned on, an event loop can not be started by calling `Gnome::Gtk3::Main.new.main()` and can only be started by **Gnome::T**.

    method _set-test-mode ( Bool $mode )

_get-test-mode
--------------

Get current state.

    method _get-test-mode ( --> Bool )

_wrap-native-type
-----------------

Used by many classes to create a Raku instance with the native object wrapped in

    method _wrap-native-type (
      Str:D $type where ?$type, N-GObject:D $no
      --> Any
    )

_wrap-native-type-from-no
-------------------------

As with `_wrap-native-type()` this method is used by many classes to create a Raku instance with the native object wrapped in.

    method _wrap-native-type-from-no (
      N-GObject $no, Str:D $match = '', Str:D $replace = '', :child-type?
      --> Any
    ) {

### _set-class-info

Get and store the GType of the provided class name

    method _set-class-info ( Str:D $!class-name )

    _set-class-info ( Str:D $!class-name )

### _set-class-name-of-sub

Set the name of the class of a subroutine. This method will disappear if all native subs have there method counterpart and that the FALLBACK system is not needed anymore.

    _set-class-name-of-sub ( Str:D $!class-name-of-sub )

### _get-class-name-of-sub

Return the classname of the subroutine. As `_set-class-name-of-sub()`, this method will disappear too.

    _get-class-name-of-sub ( --> Str )

### _set_invalid

Purpose to invalidate an object after some operation such as .destroy().

    _set_invalid ( )

### _f

This method is called from classes which are not leaf classes and may need to cast the native object into another type before calling the method at hand.

    method _f ( Str $sub-class? --> Any )

