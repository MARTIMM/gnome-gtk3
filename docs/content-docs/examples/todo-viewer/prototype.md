---
title: Prototype
#nav_title: Window
nav_menu: example-nav
sidebar_menu: example-todo-viewer-sidebar
layout: sidebar
---

# The Prototype

At first we do not create a full fledged application with all flags and whistles. Extensions to this program can easily be done by looking into other examples or tutorials to add e.g. a menu or dialogs. **_Note that you can download the source code from the [introduction page](todo-viewer.html)_**.

Lets make a list first of what we want to accomplish for our prototype;
* Start the program with a filename given on the command line of the program.
* The program should read the file line by line and gather the marker comments along with its line number.
* The markers are stored within comments. The following comment starters are checked;
  * **#**: Comment starter used in several languages
  * **#\`{**, **#\`{\{**, **#\`[**, **#\`[[**: Comment blocks used in Raku
  * **=comment**: Pod comment used in Raku
  * **/\***, **//**: Comments used in C, C++, Javascript or Qml
  * **\<!--**: XML, html and other markup languages
* Check for the following markers on those lines; `TODO`, `DOING`, `DONE`, `PLANNING`, `FIXME`, `ARCHIVE`, `HACK`, `CHANGED`, `XXX`, `IDEA`, `NOTE` and `REVIEW`. You see that this program will handle more than only 'todo' lines!
* Store the results in an array of arrays. Each entry is an array holding the following marker information: `[ <marker-name>, <line-number>, <marker-text> ]`;

* Show the name of the file and the number of todo texts in a **Gnome::Gtk3::TreeView**.

* When the line is (double) clicked, a list of todo texts and the line numbers where the text is found, appears in another list next to the TreeView.

* In turn, when a todo text is (double) clicked on, an editor is fired up, the file should then be visible and the cursor should go to the line where the text is found.


Now that we have set our goals, we need to set up the working directory amongst other things;
* Create an environment and set up some directories. We make this project installable so we can share this program and modules.
  The project directory will be `todo-viewer`. In that directory we create the directories `bin`, `lib` and `t`. The program will go to `bin` and any module will go to `lib`. The program is named `todo-viewer.pl6` and the modules `Gui.pm6`, `SkimFile.pm6` and `GuiHandlers.pm6`.
* There will be a `MAIN()` in the program to get some arguments from the commandline. Also the main program will load some modules to handle the file I/O and building the graphical user interface (GUI). Also, we need a module to handle the the signals. This will be loaded by the GUI module.
* We need a test file with some TODO and other marker comments in it and call it `my-test.pl6`. This file is placed in `t/data`.
