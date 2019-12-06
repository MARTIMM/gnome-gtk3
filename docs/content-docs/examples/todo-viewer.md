---
title: A Todo Viewer
nav_menu: example-nav
sidebar_menu: example-todo-viewer-sidebar
layout: sidebar
---
# A Todo Viewer Example

This program will read files and shows the todo remarks in a list. At first, we keep the business simple and create one test file to work on. Later, it can be extended to more files or worse.

## The prototype

We will begin with a simple program and what we like to accomplish first is shown in the following list;

* Read a file line by line and make a note of every TODO line. To make sure that we have the proper line, we have to add a character '#' up front to distinguish it from other parts not being a todo comment like it would happen in this very program. So the regular expression would be something like `m/^ \s* '#' \s* TODO $<todo-text>=[<-[\n]>+] $/`.

* Show the name of the file and the number of todo texts in a **Gnome::Gtk3::TreeView**.

* When the line is clicked, a list of todo texts and the line numbers where the text is found, appears in another list next to the TreeView.

* In turn, when a todo text is clicked on, an editor is fired up, the file should then be visible and the cursor should go to the line where the text as found.
