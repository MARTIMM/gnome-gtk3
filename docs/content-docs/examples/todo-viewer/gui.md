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

The `BUILD()` submethod is responsible for setting up the interface. It starts with the creation of a window [37] and a grid [38] which is added to the window. Then a file list table is created [43] and inserted in the grid in the upper left corner [44]. The marker table is then generated [46] and also added in the upper right corner [47].

After all this we have to register some signals to get some action in our interface. First the handler classes must be initialized, **GuiHandlers::ListView** handler at [49] and **GuiHandlers::Application** on [60].
We register the sub `select-list-entry()` to handle the `row-activated` signal emitted from the files table when an entry was double clicked [50-54]. We provide some more information to the handler sub such as the data hash with all marker data, the column in the table to find the key into the data hash and the marker and files table.
We also register `select-marker-entry()` to also handle a `row-activated` signal but this time on the marker table object [56-58]. The extra data provided is the marker data table.
At last we make the user interface visible by calling `$w.show-all()` [63].

The first table is created in method `create-file-list-view()` [80-111]. `$!files` is a **Gnome::Gtk3::TreeStore** object. This means the the first column in those tables can be tree like display. Tree- and ListStores are models holding data. The store will have rows of three columns which are all of type string [81]. `$!fs-table` is a **Gnome::Gtk3::TreeView** object which is responsible to display the data. When initialized, it receives a model which, in this case, is the TreeStore `$!files` [82].

All columns must be rendered by a renderer. In the all cases this will be the **Gnome::Gtk3::CellRendererText** class [87]. We are changing the way text is displayed by setting a color. Blue for text and red for numbers. I've chosen to display the number of markers, an integer, to be displayed as a string because the entry will show 0 by default. Directory names are on their own row and cannot have marker information. It is ugly to show 0 on those rows. With a string type an empty string can be displayed.
Then a **Gnome::Gtk3::TreeViewColumn** is created with a title for the column and the renderer for the column is added [90-92]. Then a link must be layed between the tree view and the renderer by pointing to a property in the text renderer `text` and specifying the column in the tree view [93]. Finally add the tree view column to the tree view.

The second column is for the number of markers found [96-103].

The last column is the data key column [105-110] and is made invisible [107].
