---
title: Tutorial - Getting Started
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# The Application classes

## A Sceleton Application

The basic class we need is the **Gnome::Gio::Application** class. Fortunately, Gnome has made a **Gnome::Gtk3::Application** class which inherits directly from the Application defined in Gio. The second class we need is a kind of toplevel window. This class will be **Gnome::Gtk3::ApplicationWindow**. Now you can build your GUI by placing them in the ApplicationWindow.

|Basic setup of an application  |
|-------------------------------|
|![diagram](images/sceleton.svg)|


The **UserAppClass** is a class which can handle all of the generated signals produced by the several initialization stages.

We can make it a bit more flexible;


|Slightly extended version          |
|-----------------------------------|
|![diagram](images/sceleton-alt.svg)|

Here the **UserWindowClass** can be used to handle the basic steps building the GUI.
