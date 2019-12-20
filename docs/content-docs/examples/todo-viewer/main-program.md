---
title: Main Program
#nav_title: Window
nav_menu: example-nav
sidebar_menu: example-todo-viewer-sidebar
layout: sidebar
---

# The Main Program

{% highlight raku linenos %}
{% include example-code/todo-viewer/bin/todo-viewer.pl6 %}
{% endhighlight %}

The main program is quite simple. It loads only two modules [3,4]. The program can be started with an optional filename where we expect some markers and comments and an option to specify the root of some project which is the current directory by default [6].

If there is a valid path to the filename [10], we instantiate the file skimmer to get the marker information [11]. Then the found data is fed to the user interface to be shown in a table[12].

When done, the user interface is activated, to only return when the interface is destroyed [15].
