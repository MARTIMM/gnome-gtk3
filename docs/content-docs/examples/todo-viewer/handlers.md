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

The first class is called **GuiHandlers::Application** and is used to handle program specific signals [16-28]. There is only one handler defined `exit-todo-viewer()` to exit the main loop and return to the main program. It returns 1 to show that all is handled by the sub.

The second class is used to handle events from the two tree views. There is a method `select-list-entry()` [36-75] to handle the double click on the files table and another method `select-marker-entry()` [78-100] to handle the double click on the markers table.

### select-list-entry

The `row-activated` signal is emitted, it wiil call a handler with the following api;
```
  method handler (
    N-GtkTreePath $path, N-GObject $column,
    Gnome::GObject::Object :widget($tree_view),
    *%user-options
  );
```
The first two arguments are obligatory, even when you do not need them. The named attributes are always optional. The user options are those extra named attributes given to the `register-signal()` method. We do not need the `$n-treeview-column` variable but we must declare it with the proper type.

### select-marker-entry
