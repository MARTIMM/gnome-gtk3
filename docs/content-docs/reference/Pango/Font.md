Gnome::Pango::Font
==================

Declaration
-----------

    unit class Gnome::Pango::Font;
    also is Gnome::GObject::Object;

Types
=====

enum PangoFontMask
------------------

The bits in a `PangoFontMask` correspond to the set fields in a `PangoFontDescription`.

  * PANGO_FONT_MASK_FAMILY: the font family is specified.

  * PANGO_FONT_MASK_STYLE: the font style is specified.

  * PANGO_FONT_MASK_VARIANT: the font variant is specified.

  * PANGO_FONT_MASK_WEIGHT: the font weight is specified.

  * PANGO_FONT_MASK_STRETCH: the font stretch is specified.

  * PANGO_FONT_MASK_SIZE: the font size is specified.

  * PANGO_FONT_MASK_GRAVITY: the font gravity is specified (Since: 1.16.)

  * PANGO_FONT_MASK_VARIATIONS: OpenType font variations are specified (Since: 1.42)

enum PangoStretch
-----------------

An enumeration specifying the width of the font relative to other designs within a family.

  * PANGO_STRETCH_ULTRA_CONDENSED: ultra condensed width

  * PANGO_STRETCH_EXTRA_CONDENSED: extra condensed width

  * PANGO_STRETCH_CONDENSED: condensed width

  * PANGO_STRETCH_SEMI_CONDENSED: semi condensed width

  * PANGO_STRETCH_NORMAL: the normal width

  * PANGO_STRETCH_SEMI_EXPANDED: semi expanded width

  * PANGO_STRETCH_EXPANDED: expanded width

  * PANGO_STRETCH_EXTRA_EXPANDED: extra expanded width

  * PANGO_STRETCH_ULTRA_EXPANDED: ultra expanded width

enum PangoStyle
---------------

An enumeration specifying the various slant styles possible for a font.

  * PANGO_STYLE_NORMAL: the font is upright.

  * PANGO_STYLE_OBLIQUE: the font is slanted, but in a roman style.

  * PANGO_STYLE_ITALIC: the font is slanted in an italic style.

enum PangoVariant
-----------------

An enumeration specifying capitalization variant of the font.

  * PANGO_VARIANT_NORMAL: A normal font.

  * PANGO_VARIANT_SMALL_CAPS: A font with the lower case characters replaced by smaller variants of the capital characters.

  * PANGO_VARIANT_ALL_SMALL_CAPS: A font with all characters replaced by smaller variants of the capital characters. Since: 1.50

  * PANGO_VARIANT_PETITE_CAPS: A font with the lower case characters replaced by smaller variants of the capital characters. Petite Caps can be even smaller than Small Caps. Since: 1.50

  * PANGO_VARIANT_ALL_PETITE_CAPS: A font with all characters replaced by smaller variants of the capital characters. Petite Caps can be even smaller than Small Caps. Since: 1.50

  * PANGO_VARIANT_UNICASE: A font with the upper case characters replaced by smaller variants of the capital letters. Since: 1.50

  * PANGO_VARIANT_TITLE_CAPS: A font with capital letters that are more suitable for all-uppercase titles. Since: 1.50

enum PangoWeight
----------------

An enumeration specifying the weight (boldness) of a font.

Weight is specified as a numeric value ranging from 100 to 1000. This enumeration simply provides some common, predefined values.

  * PANGO_WEIGHT_THIN: the thin weight (= 100) Since: 1.24

  * PANGO_WEIGHT_ULTRALIGHT: the ultralight weight (= 200)

  * PANGO_WEIGHT_LIGHT: the light weight (= 300)

  * PANGO_WEIGHT_SEMILIGHT: the semilight weight (= 350) Since: 1.36.7

  * PANGO_WEIGHT_BOOK: the book weight (= 380) Since: 1.24)

  * PANGO_WEIGHT_NORMAL: the default weight (= 400)

  * PANGO_WEIGHT_MEDIUM: the normal weight (= 500) Since: 1.24

  * PANGO_WEIGHT_SEMIBOLD: the semibold weight (= 600)

  * PANGO_WEIGHT_BOLD: the bold weight (= 700)

  * PANGO_WEIGHT_ULTRABOLD: the ultrabold weight (= 800)

  * PANGO_WEIGHT_HEAVY: the heavy weight (= 900)

  * PANGO_WEIGHT_ULTRAHEAVY: the ultraheavy weight (= 1000) Since: 1.24

enum PangoScale
---------------

CSS scale factors (1.2 factor between each size)

  * PANGO_SCALE_XX_SMALL: The scale factor for three shrinking steps (1 / (1.2 * 1.2 * 1.2)

  * PANGO_SCALE_X_SMALL: The scale factor for two shrinking steps (1 / (1.2 * 1.2)).

  * PANGO_SCALE_SMALL: The scale factor for one shrinking step (1 / 1.2).

  * PANGO_SCALE_MEDIUM: The scale factor for normal size (1.0).

  * PANGO_SCALE_LARGE: The scale factor for one magnification step (1.2).

  * PANGO_SCALE_X_LARGE: The scale factor for two magnification steps (1.2 * 1.2).

  * PANGO_SCALE_XX_LARGE: The scale factor for three magnification steps (1.2 * 1.2 * 1.2).

Methods
=======

new
---

### default, no options

Create a new Font object.

    multi method new ( )

### :native-object

Create a Font object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

describe
--------

Returns a description of the font, with font size set in points.

    method describe ( --> N-GObject )

describe-with-absolute-size
---------------------------

Returns a description of the font, with absolute font size set in device units.

    method describe-with-absolute-size ( --> N-GObject )

get-coverage
------------

Computes the coverage map for a given font and language tag.

    method get-coverage ( N-GObject() $language --> N-GObject )

  * $language; 

get-face
--------

Gets the native object of **Gnome::Pango::FontFace** to which font belongs.

    method get-face ( --> N-GObject )

Example

    my Gnome::Pango::FontFace() $face = $font.get-face;

get-font-map
------------

Gets the font map for which the font was created.

Note that the font maintains a weak reference to the font map, so if all references to font map are dropped, the font map will be finalized even if there are fonts created with the font map that are still alive. In that case this function will return NULL.

It is the responsibility of the user to ensure that the font map is kept alive. In most uses this is not an issue as a PangoContext holds a reference to the font map.

    method get-font-map ( --> N-GObject )

get-languages
-------------

Returns the languages that are supported by font.

If the font backend does not provide this information, NULL is returned. For the fontconfig backend, this corresponds to the FC_LANG member of the FcPattern.

The returned array is only valid as long as the font and its fontmap are valid.

    method get-languages ( --> N-GObject )

has-char
--------

Returns whether the font provides a glyph for this character.

    method has-char ( gunichar $wc --> Bool )

  * $wc; 

