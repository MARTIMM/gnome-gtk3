---
title: Skimming Module
#nav_title: Window
nav_menu: example-nav
sidebar_menu: example-todo-viewer-sidebar
layout: sidebar
---

# The Skimming Process

{% highlight raku linenos %}
{% include example-code/todo-viewer/lib/SkimFile.pm6 %}
{% endhighlight %}

Also this module is far from complex. When the module is BUILD, the search for markers is started by calling `search-texts()`[11].

A method `reread-file()` is added to read the file again after changes [15-17].

The `search-texts()` method is also simple [20]. The file is opened and a loop is started to inspect every line from the file [23]. We keep a count of the lines [24] and check for a marker word after several types of comment characters [26-39].
If a marker is found, the marker, marker text and a line number is stored in an array [41]. The array is readable for the outside world [6].
