---
title: Tutorial - Getting Started
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# Inheriting Widget Classes

## Introduction

There are situations in your projects that a widget gets dressed up the same way all the time and stray away from the defaults of a widget. For instance, you might want several labels to change a font and make it bold. So you repeat the steps all the time you create a label. For example the below label has a smaller font and printed bold. Also rotated for 90 degrees (useful in a grid to make columns small, e.g. showing checkboxes or small numbers);

```
$text = "<b><small>$text</small></b>";
my Gnome::Gtk3::Label $label .= new(:$text);
$label.set-use-markup;
$label.set-angle(90);
```

Of course, make a method to do it is easy enough but it can be more beautiful.


## Inheriting

Inheriting a widget class can make things nicer because a class name can describe the label better. So how do we make a class like that?

We must create our class by defining a `new()` method for it. This method creates the object by providing the necessary options if there are any but most importantly, it must provide a special option `:GtkLabel` to let the label build routine know that it must process the options to create a native label object.

Then the `BUILD()` must do the additional steps to let the label be what it should be. This time rotating a smaller angle.

The code for it could look like the example below;
```
use Gnome::Gtk3::Label;

unit class VerticalHeaderLabel is Gnome::Gtk3::Label;

submethod new ( |c ) {
  self.bless( :GtkLabel, |c);
}

submethod BUILD ( ) {
  my Str $text = '<b><small>' ~ self.get-text ~ '</small></b>';
  self.set-text($text);
  self.set-use-markup(True);
  self.set-line-wrap(False);
  self.set-width-chars(16);
  self.set-angle(80);
}
```

Example use;
```
my Gnome::Gtk3::Grid $grid .= new;
my Int $col = 1;
for ('success tests', 'failed tests', 'skipped tests', 'total') -> $hdr {
  my VerticalHeaderLabel $v .= new(:text($hdr)); # ①
  $grid.attach( $v, $col++, 0, 1, 1);
}

my $data = [
  ( 'foo', 10, 5, 2, 17),
  ( 'bar', 1, 12, 3, 16),
  ( 'baz', 2, 2, 1, 5),
];

my Int $row = 1;
for @$data -> @d {
  my Int $col = 0;
  for @d -> $col-data {
    my Str $text = $col-data ~~ Str
        ?? $col-data.fmt('%5s')
        !! $col-data.fmt('%3d');

    $grid.attach(
      Gnome::Gtk3::Label.new(:$text), $col++, $row, 1, 1
    );
  }
  $row++;
}
```

Taraaa ... the result!<br/>
![](images/inheriting-example.png)


## Inheriting another level

It is possible to inherit the `VerticalHeaderLabel` too to make further adjustments. The new method however, must be repeated in the newer class. This is because Raku only runs the `new()` method of the class mentioned in the declaration.
