---
title: Tutorial - Transformations
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---

# Working with Transforms

Transforms have three major uses.
* First they allow you to set up a coordinate system that's easy to think in and work in, yet have the output be of any size.
* Second they allow you to make helper functions that work at or around a (0, 0) but can be applied anywhere in the output image.
* Thirdly they let you deform the image, turning a circular arc into an elliptical arc, etc.

Transforms are a way of setting up a relation between two coordinate systems. The device-space coordinate system is tied to the surface, and cannot change. The user-space coordinate system matches that space by default, but can be changed for the above reasons. The helper functions `user-to-device()` and `user-to-device-distance()` tell you what the device-coordinates are for a user-coordinates position or distance. Correspondingly `device-to-user()` and `device-to-user-distance()` tell you user-coordinates for a device-coordinates position or distance. Remember to send positions through the non-distance variant, and relative moves or other distances through the distance variant.

<!--
I leverage all of these reasons to draw the diagrams in this document. Whether I'm drawing 120 x 120 or 600 x 600, I use `scale()` to give me a 1.0 x 1.0 workspace. To place the results along the right column, such as in the discussion of cairo's drawing model, I use `translate()`. And to add the perspective view for the overlapping layers, I set up an arbitrary deformation with `transform()` on a **cairo_matrix_t**.
-->

To understand your transforms, read them bottom to top, applying them to the point you're drawing. To figure out which transforms to create, think through this process in reverse. For example if I want my 1.0 x 1.0 workspace to be 100 x 100 pixels in the middle of a 120 x 120 pixel surface, I can set it up one of three ways:
```
$cairo.translate( 10, 10);
$cairo.scale( 100, 100);
```
or
```
$cairo.scale( 100, 100);
$cairo.translate( 0.1, 0.1);
```
or
```
my Gnome::Cairo::Matrix $mat .= new;
$mat.matrix-init( 100, 0, 0, 100, 10, 10);
$cairo.transform($mat);
```

Use the first two when relevant because it is often the most readable; use the third when necessary to access additional control not available with the primary functions.


The data used to draw in the original document was like below, working in a workspace of 1.0 x 1.0. This tutorial however, has started to use the device coordinates of 120 x 120 to show direct results. Code with the original data;
```
with my Gnome::Cairo $context .= new(:$surface) {
  .set-line-width(0.1);
  .set-source-rgb( 0, 0, 0);
  .rectangle( 0.25, 0.25, 0.5, 0.5);
  .stroke;
}
```
Now we know about transformations, we can add the few lines to the code to use the original code lines with the same results. Here is a more complete example with transformations (note that I also have changed the use of color but that's not important);

<img class="tutorial-image" src="Example-code/stroke-orig.png" width="120" />

<pre class='highlight'><code>
my Gnome::Cairo::ImageSurface $surface .= new(
  :format(CAIRO_FORMAT_ARGB32),
  :width(120), :height(120)
);

with my Gnome::Cairo $context .= new(:$surface) {
  .translate( 10, 10);
  .scale( 100, 100);

  .set-line-width(0.1);
  .set-source-rgb( 0, 0, 0);
  .rectangle( 0.25, 0.25, 0.5, 0.5);
  .stroke;
}
</code></pre>
<p style="clear:both;"/>

Be careful when trying to draw lines while under transform. Even if you set your line width while the scale factor was 1, the line width setting is always in user-coordinates and isn't modified by setting the scale. While you're operating under a scale, the width of your line is multiplied by that scale. To specify a width of a line in pixels, use `.device-to_user-distance()` to turn a (1, 1) device-space distance into, for example, a (0.01, 0.01) user-space distance. Note that if your transform deforms the image there isn't necessarily a way to specify a line with a uniform width.
