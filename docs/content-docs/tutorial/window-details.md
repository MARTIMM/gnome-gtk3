---
title: Tutorial - Window details
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# Window details

We will dive a little deeper with what we can do with the Gnome::Gtk3::Window. W've seen that it can hold one widget. We could do a little bit more with this window such as placement of the window on screen or replace the default icon in the decoration. Let's start!

## Changing icon in decoration

<p>
<img src="images/window-deco1.png" width="108" style="float:left; margin-right:8px"/>
Normally the window decoration would be something like the one you see in the upper left corner of an application. This one is a default icon from the Gtk ApplicationWindow class (very dark, almost invisible).
</p>
<br/>
<p>
<img src="images/icons8-invoice-100.png" width="108" style="float:left; margin-right:8px"/>
We are going to replace it with this icon shown on the left using the following piece of code. The width and height is automatically scaled to its proper size. The icon can be found <a href="https://icons8.com" target="\_blank">here at icons8</a>.
</p>
<br/>
<br/>
<br/>

{% highlight raku linenos %}
use Gnome::Gtk3::Window;
use Gnome::Glib::Error;
use Gnome::Gdk3::Pixbuf;

my Gnome::Gtk3::Window $window .= new(:title<Window>);
my Gnome::Gdk3::Pixbuf $win-icon .= new(:file<icons8-invoice-100.png>);

my Gnome::Glib::Error $e = $win-icon.last-error;
if $e.is-valid {
  die "Error icon file: $e.message()";
}

else {
  $window.set-icon($win-icon);
}
{% endhighlight %}

We need an Error class from Glib and a Pixbuf class from Gdk3 [2,3]. Next the window is created and the image loaded in a Pixbuf [5,6]. When there is an error, e.g. file is not found, an error is set and a default broken image is loaded in the Pixbuf instead. You can check the error by calling `.last-error()` [26]. If the error is valid an error occurred [27]. If not, the icon can be set [32] with the following result;

![new icon](images/window-deco2.png)

## Window sizing and resizing

To set a size of the window at the start of the program one can use several methods. `$window.gtk-window-set-default-size()` sets an existing window to that size or larger. This 'larger' depends on what is placed in the window which need at least the sum of natural sizes of the containing widgets. The user is still able to shrink the window if the natural sizes of the widgets within permits.

There is another method to set the size. `$window.gtk_widget_set_size_request()` which is a size method for any widget. When called on a window, it cannot be made smaller by the user.

Also a resize method is available as `$window.gtk_window_resize()` <!--[`$window.gtk_window_resize()`](../reference/Gtk3/Window.html#wow101).-->

The information about current sizes is retrieved by calling `$window.gtk_get_size()`.
