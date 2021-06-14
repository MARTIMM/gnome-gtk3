---
title: A Todo Viewer
nav_menu: example-nav
sidebar_menu: example-todo-viewer-sidebar
layout: sidebar
---
# A Todo Viewer Example

This program will read files and shows the todo remarks in a list. At first, we keep the business simple and create one test file to work on. Later, it can be extended to more files or worse.

## Download and Install

{% assign downloadzip = site.baseurl | append: '/content-docs/images/zip-icon.png' %}
{% assign downloadtar = site.baseurl | append: '/content-docs/images/tar-gz-icon.png' %}


Download the archive files of your choice from below and unpack them in a directory.
* Click the icon on the right to download a zip archive: <a href="todo-viewer.zip" download> <img src="{{ downloadzip }}" alt="zip file" height="30"> </a>
* Click the icon on the right to download a tar archive: <a href="todo-viewer.tgz" download> <img src="{{ downloadtar }}" alt="tar file" height="30"> </a>

Go into the todo-viewer directory and run `zef install .` to install the package. After testing and installing, the command `todo-viewer.pl6` should be available.

## Run

* Start program with: `todo-viewer.pl6 t/data/my-test.pl6`
* Double click on the `my-test.pl6` entry

When done with the above mentioned sample file from the test data directory you should see the following display

![todo-viewer.png](images/todo-viewer.png)
