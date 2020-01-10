---
title: Handlers Module
#nav_title: Window
nav_menu: example-nav
sidebar_menu: example-todo-viewer-sidebar
layout: sidebar
---

# The Gui Handlers

{% highlight raku linenos %}
{% include example-code/todo-viewer/lib/GuiHandlers.pm6 %}
{% endhighlight %}

### The classes

The first class is called **GuiHandlers::Application** and is used to handle program specific signals [16-28]. There is only one handler defined `exit-todo-viewer()` to exit the main loop and return to the main program. It returns 1 to show that all is handled by the sub.

The second class, **GuiHandlers::ListView**, is used to handle events from the two tree views and to modify the markers table. There is a method `select-list-entry()` [36-75] to handle the double click on the files table and another method `select-marker-entry()` [78-100] to handle the double click on the markers table.

### select-list-entry

When the `row-activated` signal is emitted, it will call a handler which must have the following api;
```
  method handler (
    N-GtkTreePath $path, N-GObject $column,
    Gnome::GObject::Object :widget($tree_view),
    *%user-options
  );
```
The first two arguments, `$n-tree-path` and `$n-treeview-column` [37], are obligatory, even when you do not need them. For instance, we do not need the `$n-treeview-column` variable in this case. Also, the types are needed by the library to make a proper connection and cannot be left out. The named attributes are always optional and here we left out `:$widget` here. The user options are those extra named attributes given to the `register-signal()` method.

Before we insert the data, we clear the table first [46-52]. We start at the top row indicated by a path `0` [47]. This path is input to the iterator initialization [48]. In a while-loop we remove the row after which a new iterator is returned now pointing to the next row [51]. The path however is still `0` because the rows move up in the table. `$iter.tree-iter-is-valid()` turns `False` when there are no rows left.

The argument `$n-tree-path` given to the handler, holds the row where the user has clicked on and we need to make an iterator from it [55,56]. From this row we get the key into the data hash (`$data`) from the hidden column (`$data-col`) in the files table (`$files`). All these values are provided to the handler [57-61].

Finally, the data pointed by the data key in the data hash is inserted in the markers table [67-70].

The data key is the absolute path to the filename and is stored in an attribute for later use [72].

### select-marker-entry

This is the same type of handler as described above. This time we needed less named arguments, only a markers table [80].

Convert the provided path into an iterator [84,85] and get the line number from the second column [87-90]. The filename was already saved in the above signal handler `select-list-entry()` in `$!filename`.

Here we use it to start the github atom editor and provide the file and line number [93].
