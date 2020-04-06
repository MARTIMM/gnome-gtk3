Methods
=======

new
---

Please note that this class is mostly not instantiated directly but is used indirectly when child classes are instantiated.

### multi method new ( :$native-object! )

Create a Raku object using a native object from elsewhere. $native-object can be a N-GObject or a Raku object like `Gnome::Gtk3::Button`.

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
        :native-object($rb-list.nth-data-gobject($i))
      );

      # If radio button is selected (=active) ...
      if $rb.get-active == 1 {
        ...

        last;
      }
    }

get-class-gtype
---------------

Return class's type code after registration. this is like calling Gnome::GObject::Type.new().g_type_from_name(GTK+ class type name).

    method get-class-gtype ( --> Int )

get-class-name
--------------

Return native class name.

    method get-class-name ( --> Str )

is-valid
--------

Returns True if native error object is valid, otherwise `False`.

    method is-valid ( --> Bool )

clear-object
------------

Clear the error and return data to memory pool. The error object is not valid after this call and `is-valid()` will return `False`.

    method clear-object ()

