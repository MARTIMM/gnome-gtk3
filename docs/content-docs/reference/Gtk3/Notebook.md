Gnome::Gtk3::Notebook
=====================

A tabbed notebook container

![](images/notebook.png)

Description
===========

The **Gnome::Gtk3::Notebook** widget is a **Gnome::Gtk3::Container** whose children are pages that can be switched between using tab labels along one edge.

There are many configuration options for **Gnome::Gtk3::Notebook**. Among other things, you can choose on which edge the tabs appear (see `gtk_notebook_set_tab_pos()`), whether, if there are too many tabs to fit the notebook should be made bigger or scrolling arrows added (see `gtk_notebook_set_scrollable()`), and whether there will be a popup menu allowing the users to switch pages. (see `gtk_notebook_popup_enable()`, `gtk_notebook_popup_disable()`)

**Gnome::Gtk3::Notebook** as **Gnome::Gtk3::Buildable**
-------------------------------------------------------

The **Gnome::Gtk3::Notebook** implementation of the **Gnome::Gtk3::Buildable** interface supports placing children into tabs by specifying “tab” as the “type” attribute of a <child> element. Note that the content of the tab must be created before the tab can be filled. A tab child can be specified without specifying a <child> type attribute.

To add a child widget in the notebooks action area, specify "action-start" or “action-end” as the “type” attribute of the <child> element.

An example of a UI definition fragment with **Gnome::Gtk3::Notebook**:

    <object class="GtkNotebook">
      <child>
        <object class="GtkLabel" id="notebook-content">
          <property name="label">Content</property>
        </object>
      </child>
      <child type="tab">
        <object class="GtkLabel" id="notebook-tab">
          <property name="label">Tab</property>
        </object>
      </child>
    </object>

Css Nodes
---------

    notebook
    ├── header.top
    │   ├── [<action widget>]
    │   ├── tabs
    │   │   ├── [arrow]
    │   │   ├── tab
    │   │   │   ╰── <tab label>
    ┊   ┊   ┊
    │   │   ├── tab[.reorderable-page]
    │   │   │   ╰── <tab label>
    │   │   ╰── [arrow]
    │   ╰── [<action widget>]
    │
    ╰── stack
        ├── <child>
        ┊
        ╰── <child>

**Gnome::Gtk3::Notebook** has a main CSS node with name notebook, a subnode with name header and below that a subnode with name tabs which contains one subnode per tab with name tab.

If action widgets are present, their CSS nodes are placed next to the tabs node. If the notebook is scrollable, CSS nodes with name arrow are placed as first and last child of the tabs node.

The main node gets the .frame style class when the notebook has a border (see `gtk_notebook_set_show_border()`).

The header node gets one of the style class .top, .bottom, .left or .right, depending on where the tabs are placed. For reorderable pages, the tab node gets the .reorderable-page class.

A tab node gets the .dnd style class while it is moved with drag-and-drop.

The nodes are always arranged from left-to-right, regardless of text direction.

See Also
--------

**Gnome::Gtk3::Container**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::Notebook;
    also is Gnome::Gtk3::Container;

Uml Diagram
-----------

![](plantuml/Notebook.svg)

Inheriting this class
---------------------

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

    use Gnome::Gtk3::Notebook;

    unit class MyGuiClass;
    also is Gnome::Gtk3::Notebook;

    submethod new ( |c ) {
      # let the Gnome::Gtk3::Notebook class process the options
      self.bless( :GtkNotebook, |c);
    }

    submethod BUILD ( ... ) {
      ...
    }

Methods
=======

new
---

### default, no options

Create a new Notebook object.

    multi method new ( )

### :native-object

Create a Notebook object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$native-object! )

### :build-id

Create a Notebook object using a native object returned from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

append-page
-----------

Appends a page to *notebook*.

Returns: the index (starting from 0) of the appended page in the notebook, or -1 if function fails

    method append-page (
      N-GObject $child, N-GObject $tab_label --> Int
    )

  * N-GObject $child; the **Gnome::Gtk3::Widget** to use as the contents of the page

  * N-GObject $tab_label; the **Gnome::Gtk3::Widget** to be used as the label for the page, or `undefined` to use the default label, “page N”

append-page-menu
----------------

Appends a page to *notebook*, specifying the widget to use as the label in the popup menu.

Returns: the index (starting from 0) of the appended page in the notebook, or -1 if function fails

    method append-page-menu (
      N-GObject $child, N-GObject $tab_label, N-GObject $menu_label
      --> Int
    )

  * N-GObject $child; the **Gnome::Gtk3::Widget** to use as the contents of the page

  * N-GObject $tab_label; the **Gnome::Gtk3::Widget** to be used as the label for the page, or `undefined` to use the default label, “page N”

  * N-GObject $menu_label; the widget to use as a label for the page-switch menu, if that is enabled. If `undefined`, and *$tab-label* is a **Gnome::Gtk3::Label** or `undefined`, then the menu label will be a newly created label with the same text as *$tab-label*; if *$tab-label* is not a **Gnome::Gtk3::Label**, *$menu-label* must be specified if the page-switch menu is to be used.

detach-tab
----------

Removes the child from the notebook.

This function is very similar to `Gnome::Gtk3::Container.remove()`, but additionally informs the notebook that the removal is happening as part of a tab DND operation, which should not be cancelled.

    method detach-tab ( N-GObject $child )

  * N-GObject $child; a child

get-action-widget, get-action-widget-rk
---------------------------------------

Gets one of the action widgets. See `set-action-widget()`.

Returns: The action widget with the given *$pack-type* or `undefined` when this action widget has not been set

    method get-action-widget ( GtkPackType $pack_type --> N-GObject )

    method get-action-widget-rk (
      GtkPackType $pack_type --> Gnome::GObject::Object
    )

  * GtkPackType $pack_type; pack type of the action widget to receive

get-current-page
----------------

Returns the page number of the current page.

Returns: the index (starting from 0) of the current page in the notebook. If the notebook has no pages, then -1 will be returned.

    method get-current-page ( --> Int )

get-group-name
--------------

Gets the current group name for *notebook*.

Returns: the group name, or `undefined` if none is set

    method get-group-name ( --> Str )

get-menu-label, get-menu-label-rk
---------------------------------

Retrieves the menu label widget of the page containing *$child*.

Returns: the menu label, or `undefined` if the notebook page does not have a menu label other than the default (the tab label).

    method get-menu-label ( N-GObject $child --> N-GObject )
    method get-menu-label-rk ( N-GObject $child --> Gnome::GObject::Object )

  * N-GObject $child; a widget contained in a page of *notebook*

get-menu-label-text
-------------------

Retrieves the text of the menu label for the page containing *$child*.

Returns: the text of the tab label, or `undefined` if the widget does not have a menu label other than the default menu label, or the menu label widget is not a **Gnome::Gtk3::Label**. The string is owned by the widget and must not be freed.

    method get-menu-label-text ( N-GObject $child --> Str )

  * N-GObject $child; the child widget of a page of the notebook.

get-n-pages
-----------

Gets the number of pages in a notebook.

Returns: the number of pages in the notebook

    method get-n-pages ( --> Int )

get-nth-page, get-nth-page-rk
-----------------------------

Returns the child widget contained in page number *$page-num*.

Returns: the child widget, or `undefined` if *$page-num* is out of bounds

    method get-nth-page ( Int() $page_num --> N-GObject )
    method get-nth-page-rk ( Int() $page_num --> Gnome::GObject::Object )

  * Int() $page_num; the index of a page in the notebook, or -1 to get the last page

get-scrollable
--------------

Returns whether the tab label area has arrows for scrolling. See `set-scrollable()`.

Returns: `True` if arrows for scrolling are present

    method get-scrollable ( --> Bool )

get-show-border
---------------

Returns whether a bevel will be drawn around the notebook pages. See `set-show-border()`.

Returns: `True` if the bevel is drawn

    method get-show-border ( --> Bool )

get-show-tabs
-------------

Returns whether the tabs of the notebook are shown. See `set-show-tabs()`.

Returns: `True` if the tabs are shown

    method get-show-tabs ( --> Bool )

get-tab-detachable
------------------

Returns whether the tab contents can be detached from *notebook*.

Returns: `True` if the tab is detachable.

    method get-tab-detachable ( N-GObject $child --> Bool )

  * N-GObject $child; a child **Gnome::Gtk3::Widget**

get-tab-label, get-tab-label-rk
-------------------------------

Returns the tab label widget for the page *$$child*. `undefined` is returned if *$$child* is not in *notebook* or if no tab label has specifically been set for *$$child*.

Returns: the tab label

    method get-tab-label ( N-GObject $child --> N-GObject )
    method get-tab-label-rk ( N-GObject $child --> Gnome::GObject::Object )

  * N-GObject $child; the page

get-tab-label-text
------------------

Retrieves the text of the tab label for the page containing *$child*.

Returns: the text of the tab label, or `undefined` if the tab label widget is not a **Gnome::Gtk3::Label**. The string is owned by the widget and must not be freed.

    method get-tab-label-text ( N-GObject $child --> Str )

  * N-GObject $child; a widget contained in a page of *notebook*

get-tab-pos
-----------

Gets the edge at which the tabs for switching pages in the notebook are drawn.

Returns: the edge at which the tabs are drawn

    method get-tab-pos ( --> GtkPositionType )

get-tab-reorderable
-------------------

Gets whether the tab can be reordered via drag and drop or not.

Returns: `True` if the tab is reorderable.

    method get-tab-reorderable ( N-GObject $child --> Bool )

  * N-GObject $child; a child **Gnome::Gtk3::Widget**

insert-page
-----------

Insert a page into *notebook* at the given position.

Returns: the index (starting from 0) of the inserted page in the notebook, or -1 if function fails

    method insert-page (
      N-GObject $child, N-GObject $tab_label, Int() $position
      --> Int
    )

  * N-GObject $child; the **Gnome::Gtk3::Widget** to use as the contents of the page

  * N-GObject $tab_label; the **Gnome::Gtk3::Widget** to be used as the label for the page, or `undefined` to use the default label, “page N”

  * Int() $position; the index (starting at 0) at which to insert the page, or -1 to append the page after all other pages

insert-page-menu
----------------

Insert a page into *notebook* at the given position, specifying the widget to use as the label in the popup menu.

Returns: the index (starting from 0) of the inserted page in the notebook

    method insert-page-menu (
      N-GObject $child, N-GObject $tab_label,
      N-GObject $menu_label, Int() $position
      --> Int
    )

  * N-GObject $child; the **Gnome::Gtk3::Widget** to use as the contents of the page

  * N-GObject $tab_label; the **Gnome::Gtk3::Widget** to be used as the label for the page, or `undefined` to use the default label, “page N”

  * N-GObject $menu_label; the widget to use as a label for the page-switch menu, if that is enabled. If `undefined`, and *$tab-label* is a **Gnome::Gtk3::Label** or `undefined`, then the menu label will be a newly created label with the same text as *$tab-label*; if *$tab-label* is not a **Gnome::Gtk3::Label**, *$menu-label* must be specified if the page-switch menu is to be used.

  * Int() $position; the index (starting at 0) at which to insert the page, or -1 to append the page after all other pages.

next-page
---------

Switches to the next page. Nothing happens if the current page is the last page.

    method next-page ( )

page-num
--------

Finds the index of the page which contains the given child widget.

Returns: the index of the page containing *$child*, or -1 if *$child* is not in the notebook

    method page-num ( N-GObject $child --> Int )

  * N-GObject $child; a **Gnome::Gtk3::Widget**

popup-disable
-------------

Disables the popup menu.

    method popup-disable ( )

popup-enable
------------

Enables the popup menu: if the user clicks with the right mouse button on the tab labels, a menu with all the pages will be popped up.

    method popup-enable ( )

prepend-page
------------

Prepends a page to *notebook*.

Returns: the index (starting from 0) of the prepended page in the notebook, or -1 if function fails

    method prepend-page ( N-GObject $child, N-GObject $tab_label --> Int )

  * N-GObject $child; the **Gnome::Gtk3::Widget** to use as the contents of the page

  * N-GObject $tab_label; the **Gnome::Gtk3::Widget** to be used as the label for the page, or `undefined` to use the default label, “page N”

prepend-page-menu
-----------------

Prepends a page to *notebook*, specifying the widget to use as the label in the popup menu.

Returns: the index (starting from 0) of the prepended page in the notebook, or -1 if function fails

    method prepend-page-menu ( N-GObject $child, N-GObject $tab_label, N-GObject $menu_label --> Int )

  * N-GObject $child; the **Gnome::Gtk3::Widget** to use as the contents of the page

  * N-GObject $tab_label; the **Gnome::Gtk3::Widget** to be used as the label for the page, or `undefined` to use the default label, “page N”

  * N-GObject $menu_label; the widget to use as a label for the page-switch menu, if that is enabled. If `undefined`, and *$tab-label* is a **Gnome::Gtk3::Label** or `undefined`, then the menu label will be a newly created label with the same text as *$tab-label*; if *$tab-label* is not a **Gnome::Gtk3::Label**, *$menu-label* must be specified if the page-switch menu is to be used.

prev-page
---------

Switches to the previous page. Nothing happens if the current page is the first page.

    method prev-page ( )

remove-page
-----------

Removes a page from the notebook given its index in the notebook.

    method remove-page ( Int() $page_num )

  * Int() $page_num; the index of a notebook page, starting from 0. If -1, the last page will be removed.

reorder-child
-------------

Reorders the page containing *$child*, so that it appears in position *$position*. If *$position* is greater than or equal to the number of children in the list or negative, *$child* will be moved to the end of the list.

    method reorder-child ( N-GObject $child, Int() $position )

  * N-GObject $child; the child to move

  * Int() $position; the new position, or -1 to move to the end

set-action-widget
-----------------

Sets *$widget* as one of the action widgets. Depending on the pack type the widget will be placed before or after the tabs. You can use a **Gnome::Gtk3::Box** if you need to pack more than one widget on the same side.

Note that action widgets are “internal” children of the notebook and thus not included in the list returned from `gtk-container-foreach()`.

    method set-action-widget ( N-GObject $widget, GtkPackType $pack_type )

  * N-GObject $widget; a **Gnome::Gtk3::Widget**

  * GtkPackType $pack_type; pack type of the action widget

set-current-page
----------------

Switches to the page number *$page-num*.

Note that due to historical reasons, GtkNotebook refuses to switch to a page unless the child widget is visible. Therefore, it is recommended to show child widgets before adding them to a notebook.

    method set-current-page ( Int() $page_num )

  * Int() $page_num; index of the page to switch to, starting from 0. If negative, the last page will be used. If greater than the number of pages in the notebook, nothing will be done.

set-group-name
--------------

Sets a group name for *notebook*.

Notebooks with the same name will be able to exchange tabs via drag and drop. A notebook with a `undefined` group name will not be able to exchange tabs with any other notebook.

    method set-group-name ( Str $group_name )

  * Str $group_name; the name of the notebook group, or `undefined` to unset it

set-menu-label
--------------

Changes the menu label for the page containing *$child*.

    method set-menu-label ( N-GObject $child, N-GObject $menu_label )

  * N-GObject $child; the child widget

  * N-GObject $menu_label; the menu label, or `undefined` for default

set-menu-label-text
-------------------

Creates a new label and sets it as the menu label of *$child*.

    method set-menu-label-text ( N-GObject $child, Str $menu_text )

  * N-GObject $child; the child widget

  * Str $menu_text; the label text

set-scrollable
--------------

Sets whether the tab label area will have arrows for scrolling if there are too many tabs to fit in the area.

    method set-scrollable ( Bool $scrollable )

  * Bool $scrollable; `True` if scroll arrows should be added

set-show-border
---------------

Sets whether a bevel will be drawn around the notebook pages. This only has a visual effect when the tabs are not shown. See `set-show-tabs()`.

    method set-show-border ( Bool $show_border )

  * Bool $show_border; `True` if a bevel should be drawn around the notebook

set-show-tabs
-------------

Sets whether to show the tabs for the notebook or not.

    method set-show-tabs ( Bool $show_tabs )

  * Bool $show_tabs; `True` if the tabs should be shown

set-tab-detachable
------------------

Sets whether the tab can be detached from *notebook* to another notebook or widget.

Note that 2 notebooks must share a common group identificator (see `set-group-name()`) to allow automatic tabs interchange between them.

If you want a widget to interact with a notebook through DnD (i.e.: accept dragged tabs from it) it must be set as a drop destination and accept the target “GTK-NOTEBOOK-TAB”. The notebook will fill the selection with a GtkWidget** pointing to the child widget that corresponds to the dropped tab.

Note that you should use `detach-tab()` instead of `Gnome::Gtk3::Container.remove()` if you want to remove the tab from the source notebook as part of accepting a drop. Otherwise, the source notebook will think that the dragged tab was removed from underneath the ongoing drag operation, and will initiate a drag cancel animation.

If you want a notebook to accept drags from other widgets, you will have to set your own DnD code to do it.

    method set-tab-detachable ( N-GObject $child, Bool $detachable )

  * N-GObject $child; a child **Gnome::Gtk3::Widget**

  * Bool $detachable; whether the tab is detachable or not

set-tab-label
-------------

Changes the tab label for *$child*. If `undefined` is specified for *$tab-label*, then the page will have the label “page N”.

    method set-tab-label ( N-GObject $child, N-GObject $tab_label )

  * N-GObject $child; the page

  * N-GObject $tab_label; the tab label widget to use, or `undefined` for default tab label

set-tab-label-text
------------------

Creates a new label and sets it as the tab label for the page containing *$child*.

    method set-tab-label-text ( N-GObject $child, Str $tab_text )

  * N-GObject $child; the page

  * Str $tab_text; the label text

set-tab-pos
-----------

Sets the edge at which the tabs for switching pages in the notebook are drawn.

    method set-tab-pos ( GtkPositionType $pos )

  * GtkPositionType $pos; the edge to draw the tabs at

set-tab-reorderable
-------------------

Sets whether the notebook tab can be reordered via drag and drop or not.

    method set-tab-reorderable ( N-GObject $child, Bool $reorderable )

  * N-GObject $child; a child **Gnome::Gtk3::Widget**

  * Bool $reorderable; whether the tab is reorderable or not

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `connect-object()` directly from **Gnome::GObject::Signal**.

First method
------------

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes `:$widget` and user data are optional.

    # handler method
    method mouse-event ( GdkEvent $event, :$widget ) { ... }

    # connect a signal on window object
    my Gnome::Gtk3::Window $w .= new( ... );
    $w.register-signal( self, 'mouse-event', 'button-press-event');

Second method
-------------

    my Gnome::Gtk3::Window $w .= new( ... );
    my Callable $handler = sub (
      N-GObject $native, GdkEvent $event, OpaquePointer $data
    ) {
      ...
    }

    $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `connect-object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

### create-window

    method handler (
      N-GObject #`{ is widget } $n-gobject #`{ is widget },
      Int $int,
      Int $int,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($notebook),
      *%user-options
      --> Unknown type GTK_TYPE_NOTEBOOK
    );

  * $notebook;

  * $n-gobject #`{ is widget };

  * $int;

  * $int;

  * $_handle_id; the registered event handler id

### page-added

    method handler (
      N-GObject #`{ is widget } $n-gobject #`{ is widget },
       $,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($notebook),
      *%user-options
      --> Int
    );

  * $notebook;

  * $n-gobject #`{ is widget };

  * $;

  * $_handle_id; the registered event handler id

### page-removed

    method handler (
      N-GObject #`{ is widget } $n-gobject #`{ is widget },
       $,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($notebook),
      *%user-options
      --> Int
    );

  * $notebook;

  * $n-gobject #`{ is widget };

  * $;

  * $_handle_id; the registered event handler id

### page-reordered

    method handler (
      N-GObject #`{ is widget } $n-gobject #`{ is widget },
       $,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($notebook),
      *%user-options
      --> Int
    );

  * $notebook;

  * $n-gobject #`{ is widget };

  * $;

  * $_handle_id; the registered event handler id

### reorder-tab

    method handler (
      Unknown type GTK_TYPE_DIRECTION_TYPE $unknown type gtk_type_direction_type,
      Int $int,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($notebook),
      *%user-options
      --> Int
    );

  * $notebook;

  * $unknown type gtk_type_direction_type;

  * $int;

  * $_handle_id; the registered event handler id

### switch-page

Emitted when the user or a function changes the current page.

    method handler (
      N-GObject #`{ is widget } $page,
       $page_num,
      Int :$_handle_id,
      Gnome::GObject::Object :_widget($notebook),
      *%user-options
      --> Int
    );

  * $notebook; the object which received the signal.

  * $page; the new current page

  * $page_num; the index of the page

  * $_handle_id; the registered event handler id

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **.set-text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.get-property( 'label', $gv);
    $gv.set-string('my text label');

Supported properties
--------------------

### Enable Popup: enable-popup

If TRUE, pressing the right mouse button on the notebook pops up a menu that you can use to go to a page

Default value: False

The **Gnome::GObject::Value** type of property *enable-popup* is `G_TYPE_BOOLEAN`.

### Group Name: group-name

    Group name for tab drag and drop.

The **Gnome::GObject::Value** type of property *group-name* is `G_TYPE_STRING`.

### Page: page

The **Gnome::GObject::Value** type of property *page* is `G_TYPE_INT`.

### Scrollable: scrollable

If TRUE, scroll arrows are added if there are too many tabs to fit Default value: False

The **Gnome::GObject::Value** type of property *scrollable* is `G_TYPE_BOOLEAN`.

### Show Border: show-border

Whether the border should be shown Default value: True

The **Gnome::GObject::Value** type of property *show-border* is `G_TYPE_BOOLEAN`.

### Show Tabs: show-tabs

Whether tabs should be shown Default value: True

The **Gnome::GObject::Value** type of property *show-tabs* is `G_TYPE_BOOLEAN`.

