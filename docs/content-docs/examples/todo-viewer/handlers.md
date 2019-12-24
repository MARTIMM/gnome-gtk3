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


### select-marker-entry
