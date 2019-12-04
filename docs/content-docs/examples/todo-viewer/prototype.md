---
title: Prototype
#nav_title: Window
nav_menu: example-nav
sidebar_menu: example-todo-viewer-sidebar
layout: sidebar
---

# The Prototype

Lets start with creating an environment, i.e. make some directories. We need a `lib` and a `bin` directory. The program will go to `bin` and any module will go to `lib`.

There will be a `MAIN()` in the program to get some arguments from the commandline. Also the main program will load some modules to handle the file I/O and building the graphical user interface (GUI). Also, we need a module to handle the the signals. This will be loaded by the GUI module.

Lets call the program `todo-viewer.pl6` and de modules `Gui.pm6`, `SkimFile.pm6` and `GuiHandlers.pm6`.

Also we need a test file with some TODO comments in it and call it `my-test.pl6`.
Lets start with the main program;

{% highlight raku linenos %}
{% include example-code/todo-viewer/bin/todo-viewer.pl6 %}
{% endhighlight %}

{% highlight raku linenos %}
{% include example-code/todo-viewer/lib/SkimFile.pm6 %}
{% endhighlight %}

{% highlight raku linenos %}
{% include example-code/todo-viewer/lib/Gui.pm6 %}
{% endhighlight %}

{% highlight raku linenos %}
{% include example-code/todo-viewer/lib/GuiHandlers.pm6 %}
{% endhighlight %}








<!-- ... for later, maybe a zip at content-docs/examples/todo-viewer
{% assign url1 = site.baseurl | append: "_includes/example-code/todo-viewer/bin/todo-viewer.pl6" %}
<a href="{{url1}}" download>file download</a>
-->
