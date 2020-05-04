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

Normally the window decoration would be something like the following;
![window deco](images/window-deco1.png)
You see in the upper left corner a default icon. This one is from an X11 window manager used on Fedora Linux. We are going to replace it with ![icon](images/icons8-invoice-100.png) using the following piece of code. The width and height is automatically scaled to its proper size.

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




  * [ ] Window details
    * [ ] Window decoration, title and icon
    * [ ] Window size
    * [ ] Centering with position
    * [ ] Destroy signal
    * [ ] Some Container methods
    * [ ] Some Widget methods
