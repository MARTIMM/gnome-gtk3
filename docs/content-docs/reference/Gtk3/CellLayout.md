Gnome::Gtk3::CellLayout
=======================

An interface for packing cells

Description
===========

**Gnome::Gtk3::CellLayout** is an interface to be implemented by all objects which want to provide a **Gnome::Gtk3::TreeViewColumn** like API for packing cells, setting attributes and data funcs.

One of the notable features provided by implementations of GtkCellLayout are attributes. Attributes let you set the properties in flexible ways. They can just be set to constant values like regular properties. But they can also be mapped to a column of the underlying tree model with `set-attributes()`, which means that the value of the attribute can change from cell to cell as they are rendered by the cell renderer. Finally, it is possible to specify a function with `gtk-cell-layout-set-cell-data-func()` that is called to determine the value of the attribute for each cell that is rendered.

GtkCellLayouts as GtkBuildable
------------------------------

Implementations of GtkCellLayout which also implement the GtkBuildable interface (**Gnome::Gtk3::CellView**, **Gnome::Gtk3::IconView**, **Gnome::Gtk3::ComboBox**, **Gnome::Gtk3::EntryCompletion**, **Gnome::Gtk3::TreeViewColumn**) accept GtkCellRenderer objects as <child> elements in UI definitions. They support a custom <attributes> element for their children, which can contain multiple <attribute> elements. Each <attribute> element has a name attribute which specifies a property of the cell renderer; the content of the element is the attribute value.

This is an example of a UI definition fragment specifying attributes:

    <object class="GtkCellView">
      <child>
        <object class="GtkCellRendererText"/>
        <attributes>
          <attribute name="text">0</attribute>
        </attributes>
      </child>"
    </object>

Furthermore for implementations of GtkCellLayout that use a **Gnome::Gtk3::CellArea** to lay out cells (all GtkCellLayouts in GTK+ use a GtkCellArea) [cell properties][cell-properties] can also be defined in the format by specifying the custom <cell-packing> attribute which can contain multiple <property> elements defined in the normal way.

Here is a UI definition fragment specifying cell properties:

    <object class="GtkTreeViewColumn">
      <child>
        <object class="GtkCellRendererText"/>
        <cell-packing>
          <property name="align">True</property>
          <property name="expand">False</property>
        </cell-packing>
      </child>"
    </object>

Synopsis
========

Declaration
-----------

    unit role Gnome::Gtk3::CellLayout;

Methods
=======

add-attribute
-------------

Adds an attribute mapping to the list in *cell-layout*.

The *column* is the column of the model to get a value from, and the *attribute* is the parameter on *cell* to be set from the value. So for example if column 2 of the model contains strings, you could have the “text” attribute of a **Gnome::Gtk3::CellRendererText** get its values from column 2.

    method add-attribute ( N-GObject() $cell, Str $attribute, Int $column )

  * $cell; a **Gnome::Gtk3::CellRenderer**

  * $attribute; an attribute on the renderer

  * $column; the column position on the model to get the attribute from

clear
-----

Unsets all the mappings on all renderers on *cell-layout* and removes all renderers from *cell-layout*.

    method clear ( )

clear-attributes
----------------

Clears all existing attributes previously set with `set-attributes()`.

    method clear-attributes ( N-GObject() $cell )

  * $cell; a **Gnome::Gtk3::CellRenderer** to clear the attribute mapping on

get-area
--------

Returns the underlying **Gnome::Gtk3::CellArea** which might be *cell-layout* if called on a **Gnome::Gtk3::CellArea** or might be `undefined` if no **Gnome::Gtk3::CellArea** is used by *cell-layout*.

Returns: the cell area used by *cell-layout*, or `undefined` in case no cell area is used.

    method get-area ( --> N-GObject )

get-cells
---------

Returns the cell renderers which have been added to *cell-layout*.

Returns: a list of cell renderers. The list, but not the renderers has been newly allocated and should be freed with `g-list-free()` when no longer needed.

    method get-cells ( --> Gnome::Glib::List )

pack-end
--------

Adds the *cell* to the end of *cell-layout*. If *expand* is `False`, then the *cell* is allocated no more space than it needs. Any unused space is divided evenly between cells for which *expand* is `True`.

Note that reusing the same cell renderer is not supported.

    method pack-end ( N-GObject() $cell, Bool $expand )

  * $cell; a **Gnome::Gtk3::CellRenderer**

  * $expand; `True` if *cell* is to be given extra space allocated to *cell-layout*

pack-start
----------

Packs the *cell* into the beginning of *cell-layout*. If *expand* is `False`, then the *cell* is allocated no more space than it needs. Any unused space is divided evenly between cells for which *expand* is `True`.

Note that reusing the same cell renderer is not supported.

    method pack-start ( N-GObject() $cell, Bool $expand )

  * $cell; a **Gnome::Gtk3::CellRenderer**

  * $expand; `True` if *cell* is to be given extra space allocated to *cell-layout*

reorder
-------

Re-inserts *cell* at *position*.

Note that *cell* has already to be packed into *cell-layout* for this to function properly.

    method reorder ( N-GObject() $cell, Int $position )

  * $cell; a **Gnome::Gtk3::CellRenderer** to reorder

  * $position; new position to insert *cell* at

