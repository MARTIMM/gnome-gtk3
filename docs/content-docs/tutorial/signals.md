---
title: Tutorial - Sinals and Events
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# Sinals and Events

We are going to see a bit more about signals. First some repetition. We define our signal handler methods in a class of its own. The purpose of that is to separate the handling of signals from the main code. This class can be setup around some object with all information it needs. An example could be the handling of a group of radio-buttons. Below a slight different approach where you can see that the class has its business with the top leven window.

Such a class can be defined in a separate module which is `use`'d at the start of the program.

```
class Gui::TopWindow {
  has Gnome::Gtk3::Window $.top-window;

  submethod BUILD ( ) {
    given $!top-window .= new {
      .title('my top level window');
      .register-signal( self, 'exit-program', 'destroy');
    }
  }

  method exit-program ( ) { $m.gtk-main-quit; }
}

...
my Gui::TopWindow $w .= new;

my Gnome::Gtk3::Grid $grid .= new;
$w.top-window.container-add($grid);
...
```
## Declaration of the Registration Method

```
method register-signal (
  $handler-object, Str:D $handler-name,
  Str:D $signal-name, *%user-options
  --> Int
)
```

We have used the first few arguments `$handler-object` and `$handler-name` before and the use of it should be clear as well as the argument `$signal-name`. With these three arguments you can handle any signal you wish to handle.

Now, I want to tell a bit more about the `*%user-options`. This is an accumulation of all named attributes given in the argument list to `.register-signal()`. The user is free to use any named attribute name. Unfortunately however, in the early setup of the routine I claimed the name 'widget' to provide the Raku object on which the signal was fired. This is changed now into '\_widget' and the older form will be deprecated and free to be used by the developer later after version 0.30.0. From now on all names starting with an underscore ('\_') are reserved.

```
my Gnome::Gtk3::DrawingArea $da .= new;
my Gnome::Gtk3::Button $draw-bttn .= new(:label<Draw>);
my Int $handler-id = $draw-bttn.register-signal(
  HandlerObject.new, 'draw-picture', 'clicked',
  :draw-area($da)
);
```

All of the `*%user-options` are provided to the signal handler so that the handler can process the signal with access to other variables which might be needed. In the example above, `:$draw-area` will be passed to the handler.
Together with the user named attributes the `:$_widget` and `:$_handler-id` are also provided.

The handler id is also returned from the call to `.register-signal()`. More on this in the next section.

## Unregistering signals

There are times that you want to get rid of a signal when your program gets into another phase. For instance in the example above, the drawing area can be replaced with something else or removed altogether and the button may get another function. You could remove the button too and create a new one and register a new handler but there could be reasons that it wouldn't be easy to do so, for instance you have the button object but don't know in which container it is placed in. Here the handler id comes in because you need it to remove the handler.

```
has Int $!handler-id;
has Gnome::Gtk3::Button $!bttn;
...

$!bttn .= new(:label<Draw>);
$!handler-id = $draw-bttn.register-signal(
  HandlerObject.new, 'draw-picture', 'clicked',
  :draw-area($da)
);
...

# After some time we want to change the 'clicked' signal handling
$!bttn.handler-disconnect($!handler-id);
...
```
So, that was easy 😉.

## Other signals
