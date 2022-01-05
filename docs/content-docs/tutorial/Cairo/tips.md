---
title: Tutorial - Tips and Tricks
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# Tips and Tricks

In the previous sections you should have built up a firm grasp of the operations cairo uses to create images. In this section I've put together a small handful of snippets, but there may be other better ways to do these things.

## Line Width

When you're working under a uniform scaling transform, you can't just use pixels for the width of your line. However it's easy to translate it with the help of $cairo.device_to_user_distance() (assuming that the pixel width is 1):

```raku
my Num() ( $ux, $uy) = ( 1, 1);
$cairo.device-to-user-distance( $ux, $uy);

# might have different outcomes for x/y directions
# depending on hardware. Take the largest one and use it.
$ux = $uy if $ux < $uy;
$cairo.set-line-width($ux);
```

When you're working under a deforming scale, you may wish to still have line widths that are uniform in device space. For this you should return to a uniform scale before you stroke the path. In the image, the arc on the left is stroked under a deformation, while the arc on the right is stroked under a uniform scale.

<img class="tutorial-image" src="images/tips-ellipse.png" width="120" />

<pre class='highlight'><code>
$cairo.set-line-width(0.1);

$cairo.save;
$cairo.scale( 0.5, 1);
$cairo.arc( 0.5, 0.5, 0.40, 0, 2 * π);
$cairo.stroke;

$cairo.translate( 1, 0);
$cairo.arc( 0.5, 0.5, 0.40, 0, 2 * π);
$cairo.restore;
$cairo.stroke;
</code></pre>

<p style="clear:both;"/>

## Text Alignment

When you try to center text letter by letter at various locations, you have to decide how you want to center it. For exampl,e the following code will actually center letters individually, leading to poor results when your letters are of different sizes. (Unlike most examples, here I assume a 26 x 1 workspace.)

<img class="tutorial-image" src="images/tips-letter.png" />
<p style="clear:both;"/>

```raku
my cairo_text_extents_t $te;
my Str @alphabet = "AbCdEfGhIjKlMnOpQrStUvWxYz".comb;

for @alphabet -> $letter {
  $te = $cairo.text-extents($letter);
  $cairo.move-to(
    $i + 0.5 - $te.x-bearing - $te.width / 2,
    0.5 - $te.y-bearing - $te.height / 2
  );

  $cairo.show-text($letter);
}
```

Instead, the vertical centering must be based on the general size of the font, thus keeping your baseline steady. Note that the exact positioning now depends on the metrics provided by the font itself, so the results are not necessarily the same from font to font.

<img class="tutorial-image" src="images/tips-font.png" />
<p style="clear:both;"/>
```raku
my cairo-font-extents-t $fe;
my cairo-text-extents-t $te;
my Str @alphabet = "AbCdEfGhIjKlMnOpQrStUvWxYz".comb;

$fe = $cairo.font-extents;
for @alphabet -> $letter {
  $te = $cairo.text-extents($letter);
  $cairo.move-to(
    $i + 0.5 - $te.x-bearing - $te.width / 2,
    0.5 - $fe.descent + $fe.height / 2
  );

  $cairo.show-text($letter);
}
```
