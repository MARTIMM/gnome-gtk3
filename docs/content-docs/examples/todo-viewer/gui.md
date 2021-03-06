---
title: Gui Module
#nav_title: Window
nav_menu: example-nav
sidebar_menu: example-todo-viewer-sidebar
layout: sidebar
---

# The Graphical User Interface

{% highlight raku linenos %}
{% include example-code/todo-viewer/lib/Gui.pm6 %}
{% endhighlight %}

## Initialization

The graphical user interface needs more explanation. First a lot more modules are needed [5-16].
* **Main** [7] is for the main loop control and stopping the program. Initialization is also done there but is hidden.
* **Window** [8] is the window where all widgets are placed in.
* **Grid** [9] The grid is where the tables will be.
* **TreeView** [10] is for displaying the tables.
* **ListStore** [12] and **TreeStore** [13] are used to store the values. These modules are models used by the **TreeView**.
* A **CellRendererText** [14] is also used by **TreeView** to render the values retrieved from the **ListStore** and **TreeStore**.
* **TreePath** [15] and **TreeIter** [16] are used to add, get or delete rows in the store modules.
* The **Type** [5] and **Value** [6] modules are needed to provide a way to get the values out of the store locations for comparison or other operations.

Then the **GuiHandlers** module is loaded which is needed to handle signals.

The tables have column numbers starting from 0. It is therefore useful to enumerate them to have more meaningful names [21,22]. `FileListColumns` is for the first table where we want to show filenames and the number of marker entries. The third column will be invisible and holds a key into a hash table which can be retrieved later when the row is clicked on. `MarkerListColumns` is for the second table which shows the marker word, a line number and its text. The second table is filled in when a row from the first table is clicked (double click action!).

## The BUILD submethod

The `BUILD()` submethod is responsible for setting up the interface. It starts with the creation of a window [37] and a grid [38] which is added to the window. Then a file list table is created [43] and inserted in the grid in the upper left corner [44]. The marker table is then generated [46] and also added in the upper right corner [47].

After all this we have to register some signals to get some action in our interface. First the handler classes must be initialized, **GuiHandlers::ListView** handler at [49] and **GuiHandlers::Application** on [60].
We register the sub `select-list-entry()` to handle the `row-activated` signal emitted from the files table when an entry was double clicked [50-54]. We provide some more information to the handler sub such as the data hash with all marker data, the column in the table to find the key into the data hash and the marker and files table.
We also register `select-marker-entry()` to also handle a `row-activated` signal but this time on the marker table object [56-58]. The extra data provided is the marker data table.
At last we make the user interface visible by calling `$w.show-all()` [63].

## Method create-file-table

The first table is created in method `create-file-table()` [80-111]. `$!files` is a **Gnome::Gtk3::TreeStore** object. This means the the first column in those tables can be tree like display. Tree- and ListStores are models holding data. The store will have rows of three columns which are all of type string [81]. `$!fs-table` is a **Gnome::Gtk3::TreeView** object which is responsible to display the data. When initialized, it receives a model which, in this case, is the TreeStore `$!files` [82].

All columns must be rendered by a renderer. Here, in all cases this will be the **Gnome::Gtk3::CellRendererText** class [87]. We are changing the way text is displayed by setting a color. Blue for text and red for numbers. I've chosen to display the number of markers, an integer, to be displayed as a string because the entry will show 0 by default. Directory names are on their own row and cannot have marker information. It is ugly to show 0 on those rows. With a string type an empty string can be displayed.
Then a **Gnome::Gtk3::TreeViewColumn** is created with a title for the column and the renderer for the column is added [90-92]. Then a link must be layed between the tree view and the renderer by pointing to a property in the text renderer `text` and specifying the column in the tree view [93]. Finally add the tree view column to the tree view.

The second column is for the number of markers found [96-103].

The last column in the **Gnome::Gtk3::TreeStore** `$!files` is the data key column. There is no need to setup a renderer for this column because we do not wish to see that column.

Here, it is important to note that not only you can decide to hide a column in a model, but that you can also show columns in other **Gnome::Gtk3::TreeView** widgets or even multiple widgets. Also, it is not necessary to show the same order of columns as they are in the model except that you want a hierarchical kind of value for the first column in a tree view whatever column it is in a tree store.

## Method create-markers-table

The other table is setup by method `create-markers-table()` [107-142]. There we have 3 columns of which the middle one is an integer. The integer can still be displayed as a string and displayed in red.

## Methods add-file-data and insert-in-table

The user of the interface calls `add-file-data()` [67-71] to add new data to the files table. It calls `insert-in-table()` [145-243] if there are any entries in the users data.
That method splits the path to the file in parts which needs to be inserted one by one in the table. For this process, an anonymous subroutine is created which can be called recursively. The subroutine compares each part with existing entries on each level and decides to insert the part before the entry when the part is alphabetically higher, to go a level deeper with the next part if the entry is found or to try the next entry when the part is not yet found. When arrived at the end of a level, it appends the part as a new entry and then go a level deeper with the next part.

A path to a row in the model is a series of integers, a number for each level. When represented as a string the numbers are separated with a colon ':'. For example '0' points to the first entry in the table, '2:1' points to the third entry of the top level and the second entry on the next level.
These paths are stored in **Gnome::Gtk3::Path**. To keep track on the path it is easier to manipulate when the integers are stored in an Array `$ts-iter-path`. The path is then used by an iterator **Gnome::Gtk3::Iter** which is used in turn by the viewer to manipulate the rows.
