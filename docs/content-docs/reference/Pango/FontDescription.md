Gnome::Pango::FontDescription
=============================

Description
===========

A PangoFontDescription describes a font in an implementation-independent manner.

PangoFontDescription structures are used both to list what fonts are available on the system and also for specifying the characteristics of a font to load.

Synopsis
========

Declaration
-----------

    unit class Gnome::Pango::FontDescription;
    also is Gnome::GObject::Boxed;

Types
=====

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

Methods
=======

new
---

### default, no options

Creates a new font description structure with all fields unset.

    multi method new ( )

### :string

Creates a new font description from a string representation.

The string must have the form "[FAMILY-LIST] [STYLE-OPTIONS] [SIZE] [VARIATIONS]",

where FAMILY-LIST is a comma-separated list of families optionally terminated by a comma, STYLE_OPTIONS is a whitespace-separated list of words where each word describes one of style, variant, weight, stretch, or gravity, and SIZE is a decimal number (size in points) or optionally followed by the unit modifier “px” for absolute size. VARIATIONS is a comma-separated list of font variation specifications of the form “`axis`=value” (the = sign is optional).

The following words are understood as styles: “Normal”, “Roman”, “Oblique”, “Italic”.

The following words are understood as variants: “Small-Caps”, “All-Small-Caps”, “Petite-Caps”, “All-Petite-Caps”, “Unicase”, “Title-Caps”.

The following words are understood as weights: “Thin”, “Ultra-Light”, “Extra-Light”, “Light”, “Semi-Light”, “Demi-Light”, “Book”, “Regular”, “Medium”, “Semi-Bold”, “Demi-Bold”, “Bold”, “Ultra-Bold”, “Extra-Bold”, “Heavy”, “Black”, “Ultra-Black”, “Extra-Black”.

The following words are understood as stretch values: “Ultra-Condensed”, “Extra-Condensed”, “Condensed”, “Semi-Condensed”, “Semi-Expanded”, “Expanded”, “Extra-Expanded”, “Ultra-Expanded”.

The following words are understood as gravity values: “Not-Rotated”, “South”, “Upside-Down”, “North”, “Rotated-Left”, “East”, “Rotated-Right”, “West”.

Any one of the options may be absent. If FAMILY-LIST is absent, then the family_name field of the resulting font description will be initialized to NULL. If STYLE-OPTIONS is missing, then all style options will be set to the default values. If SIZE is missing, the size in the resulting font description will be set to 0.

    multi method new(:$string!)

A typical example string:

    "Cantarell Italic Light 15 \`wght`=200"

### :copy

Make a copy of a PangoFontDescription.

    multi method new(:$copy!)

### :native-object

Create a FontDescription object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

better-match
------------

Determines if the style attributes of new_match are a closer match for desc than those of old_match are, or if old_match is NULL, determines if new_match is a match at all.

Approximate matching is done for weight and style; other style attributes must match exactly. Style attributes are all attributes other than family and size-related attributes. Approximate matching for style considers PANGO_STYLE_OBLIQUE and PANGO_STYLE_ITALIC as matches, but not as good a match as when the styles are equal.

Note that old_match must match desc.

    method better-match (
      N-GObject() $old_match, N-GObject() $new_match --> Bool
    )

  * $old_match; 

  * $new_match; 

equal
-----

Compares this font description with given one for equality.

    method equal ( N-GObject() $desc --> Bool )

  * $desc; Another PangoFontDescription

get-family
----------

Gets the family name field of a font description.

Returns the family name field for the font description, or NULL if not previously set. This has the same life-time as the font description itself.

    method get-family ( --> Str )

get-gravity
-----------

Gets the gravity field of a font description.

Returns the gravity field for the font description. Use `.get-set-fields()` to find out if the field was explicitly set or not.

    method get-gravity ( --> PangoGravity )

get-set-fields
--------------

Determines which fields in a font description have been set.

Returns a bitmask with bits set corresponding to the fields in desc that have been set.

    method get-set-fields ( --> UInt )

get-size
--------

Gets the size field of a font description.

Returns the size field for the font description in points or device units. You must call `.get-size-is-absolute()` to find out which is the case. Returns 0 if the size field has not previously been set or it has been set to 0 explicitly. Use `.get-set-fields()` to find out if the field was explicitly set or not.

    method get-size ( --> Int )

get-size-is-absolute
--------------------

Determines whether the size of the font is in points (not absolute) or device units (absolute).

Returns whether the size for the font description is in points or device units. Use `.get-set-fields()` to find out if the size field of the font description was explicitly set or not.

    method get-size-is-absolute ( --> Bool )

get-stretch
-----------

Gets the stretch field of a font description.

Returns the stretch field for the font description. Use `.get-set-fields()` to find out if the field was explicitly set or not.

    method get-stretch ( --> PangoStretch )

get-style
---------

Gets the style field of a font description.

    method get-style ( --> PangoStyle )

get-variant
-----------

Gets the variant field of a font description.

    method get-variant ( --> PangoVariant )

get-variations
--------------

Gets the variations field of a font description, or NULL if not previously set.

    method get-variations ( --> Str )

get-weight
----------

Gets the weight field of a font description.

    method get-weight ( --> PangoWeight )

merge
-----

Merges the fields that are set in `$desc_to_merge` into the fields of this description.

    method merge ( N-GObject() $desc_to_merge, Bool $replace_existing )

  * $desc_to_merge; The PangoFontDescription to merge from.

  * $replace_existing; If TRUE, replace fields in desc with the corresponding values from desc_to_merge, even if they are already exist.

set-absolute-size
-----------------

Sets the size field of a font description, in device units.

    method set-absolute-size ( Num() $size )

  * $size; 

set-family
----------

Sets the family name field of a font description.

The family name represents a family of related font styles, and will resolve to a particular PangoFontFamily. In some uses of PangoFontDescription, it is also possible to use a comma separated list of family names for this field.

    method set-family ( Str $family )

  * $family; A string representing the family name.

set-gravity
-----------

Sets the gravity field of a font description.

    method set-gravity ( PangoGravity $gravity )

  * $gravity; The gravity for the font description.

set-size
--------

Sets the size field of a font description in fractional points.

    method set-size ( Int() $size )

  * $size; The size of the font in points, scaled by PANGO_SCALE. (That is, a size value of 10 * PANGO_SCALE is a 10 point font. The conversion factor between points and device units depends on system configuration and the output device. For screen display, a logical DPI of 96 is common, in which case a 10 point font corresponds to a 10 * (96 / 72) = 13.3 pixel font. Use pango_font_description_set_absolute_size() if you need a particular size in device units.

set-stretch
-----------

Sets the stretch field of a font description.

    method set-stretch ( PangoStretch $stretch )

  * $stretch; The stretch for the font description.

set-style
---------

Sets the style field of a PangoFontDescription.

    method set-style ( PangoStyle $style )

  * $style; The style for the font description.

set-variant
-----------

Sets the variant field of a font description.

    method set-variant ( PangoVariant $variant )

  * $variant; The variant type for the font description.

set-variations
--------------

Sets the variations field of a font description.

OpenType font variations allow to select a font instance by specifying values for a number of axes, such as width or weight.

The format of the variations string is 'AXIS1=VALUE,AXIS2=VALUE...'

with each AXIS a 4 character tag that identifies a font axis, and each VALUE a floating point number. Unknown axes are ignored, and values are clamped to their allowed range.

Pango does not currently have a way to find supported axes of a font. Both harfbuzz and freetype have API for this. See for example hb_ot_var_get_axis_infos.

    method set-variations ( Str $variations )

  * $variations; A string representing the variations. The argument can be NULL.

set-weight
----------

Sets the weight field of a font description.

The weight field specifies how bold or light the font should be. In addition to the values of the PangoWeight enumeration, other intermediate numeric values are possible.

    method set-weight ( PangoWeight $weight )

  * $weight; The weight for the font description.

to-filename
-----------

Creates a filename representation of a font description.

    method to-filename ( --> Str )

to-string
---------

Creates a string representation of a font description.

    method to-string ( --> Str )

unset-fields
------------

Unsets some of the fields in a PangoFontDescription.

The unset fields will get back to their default values.

    method unset-fields ( UInt $to_unset )

  * $to_unset; Bitmask of fields in the desc to unset.

