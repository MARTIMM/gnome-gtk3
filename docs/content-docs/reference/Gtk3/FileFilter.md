Gnome::Gtk3::FileFilter
=======================

A filter for selecting a file subset

Description
===========

A **Gnome::Gtk3::FileFilter** can be used to restrict the files being shown in a **Gnome::Gtk3::FileChooser**. Files can be filtered based on their name (with `gtk_file_filter_add_pattern()`), on their mime type (with `gtk_file_filter_add_mime_type()`), or by a custom filter function (with `gtk_file_filter_add_custom()`).

Filtering by mime types handles aliasing and subclassing of mime types; e.g. a filter for text/plain also matches a file with mime type application/rtf, since application/rtf is a subclass of text/plain. Note that **Gnome::Gtk3::FileFilter** allows wildcards for the subtype of a mime type, so you can e.g. filter for image/\*.

Normally, filters are used by adding them to a **Gnome::Gtk3::FileChooser**, see `gtk_file_chooser_add_filter()`, but it is also possible to manually use a filter on a file with `gtk_file_filter_filter()`.

**Gnome::Gtk3::FileFilter** as **Gnome::Gtk3::Buildable**
---------------------------------------------------------

The **Gnome::Gtk3::FileFilter** implementation of the **Gnome::Gtk3::Buildable** interface supports adding rules using the <mime-types>, <patterns> and <applications> elements and listing the rules within. Specifying a <mime-type> or <pattern> has the same effect as calling `gtk_file_filter_add_mime_type()` or `gtk_file_filter_add_pattern()`.

An example of a UI definition fragment specifying **Gnome::Gtk3::FileFilter** rules:

    <object class="GtkFileFilter>">
      <mime-types>
        <mime-type>text/plain</mime-type>
        <mime-type>image/ *</mime-type>
      </mime-types>
      <patterns>
        <pattern>*.txt</pattern>
        <pattern>*.png</pattern>
      </patterns>
    </object>

Implemented Interfaces
----------------------

Gnome::Gtk3::FileFilter implements

  * [Gnome::Gtk3::Buildable](Buildable.html)

See Also
--------

**Gnome::Gtk3::FileChooser**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::FileFilter;
    also does Gnome::Gtk3::Buildable;

Types
=====

enum GtkFileFilterFlags
-----------------------

These flags indicate what parts of a **Gnome::Gtk3::FileFilterInfo** struct are filled or need to be filled.

  * GTK_FILE_FILTER_FILENAME: the filename of the file being tested

  * GTK_FILE_FILTER_URI: the URI for the file being tested

  * GTK_FILE_FILTER_DISPLAY_NAME: the string that will be used to display the file in the file chooser

  * GTK_FILE_FILTER_MIME_TYPE: the mime type of the file

class N-GtkFileFilterInfo
-------------------------

A **Gnome::Gtk3::FileFilterInfo**-struct is used to pass information about the tested file to `gtk_file_filter_filter()`.

  * **Gnome::Gtk3::FileFilterFlags** $.contains: Flags indicating which of the following fields need are filled

  * Str $.filename: the filename of the file being tested

  * Str $.uri: the URI for the file being tested

  * Str $.display_name: the string that will be used to display the file in the file chooser

  * Str $.mime_type: the mime type of the file

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_] file_filter_new
----------------------

Creates a new **Gnome::Gtk3::FileFilter** with no rules added to it. Such a filter doesn’t accept any files, so is not particularly useful until you add rules with `gtk_file_filter_add_mime_type()`, `gtk_file_filter_add_pattern()`, or `gtk_file_filter_add_custom()`. To create a filter that accepts any file, use:

    my Gnome::Gtk3::FileFilter $filter .= new(:empty);
    $filter.add-pattern("*");

Returns: a new **Gnome::Gtk3::FileFilter**

Since: 2.4

    method gtk_file_filter_new ( --> N-GObject  )

[[gtk_] file_filter_] set_name
------------------------------

Sets the human-readable name of the filter; this is the string that will be displayed in the file selector user interface if there is a selectable list of filters.

Since: 2.4

    method gtk_file_filter_set_name ( Str $name )

  * Str $name; (allow-none): the human-readable-name for the filter, or `Any` to remove any existing name.

[[gtk_] file_filter_] get_name
------------------------------

Gets the human-readable name for the filter. See `gtk_file_filter_set_name()`.

Returns: (nullable): The human-readable name of the filter, or `Any`. This value is owned by GTK+ and must not be modified or freed.

Since: 2.4

    method gtk_file_filter_get_name ( --> Str  )

[[gtk_] file_filter_] add_mime_type
-----------------------------------

Adds a rule allowing a given mime type to *filter*.

Since: 2.4

    method gtk_file_filter_add_mime_type ( Str $mime_type )

  * Str $mime_type; name of a MIME type

[[gtk_] file_filter_] add_pattern
---------------------------------

Adds a rule allowing a shell style glob to a filter.

Since: 2.4

    method gtk_file_filter_add_pattern ( Str $pattern )

  * Str $pattern; a shell style glob

[[gtk_] file_filter_] add_pixbuf_formats
----------------------------------------

Adds a rule allowing image files in the formats supported by **Gnome::Gdk3::Pixbuf**.

Since: 2.6

    method gtk_file_filter_add_pixbuf_formats ( )

[[gtk_] file_filter_] get_needed
--------------------------------

Gets the fields that need to be filled in for the **Gnome::Gtk3::FileFilterInfo** passed to `gtk_file_filter_filter()`

This function will not typically be used by applications; it is intended principally for use in the implementation of **Gnome::Gtk3::FileChooser**.

Returns: bitfield of flags indicating needed fields when calling `gtk_file_filter_filter()`

Since: 2.4

    method gtk_file_filter_get_needed ( --> GtkFileFilterFlags  )

[gtk_] file_filter_filter
-------------------------

Tests whether a file should be displayed according to *filter*. The **Gnome::Gtk3::FileFilterInfo** *filter_info* should include the fields returned from `gtk_file_filter_get_needed()`.

This function will not typically be used by applications; it is intended principally for use in the implementation of **Gnome::Gtk3::FileChooser**.

Returns: `1` if the file should be displayed

Since: 2.4

    method gtk_file_filter_filter ( GtkFileFilterInfo $filter_info --> Int  )

  * GtkFileFilterInfo $filter_info; a **Gnome::Gtk3::FileFilterInfo** containing information about a file.

