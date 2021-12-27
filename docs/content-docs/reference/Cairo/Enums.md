Enumerations
============

enum cairo_antialias_t
----------------------

Specifies the type of antialiasing to do when rendering text or shapes. As it is not necessarily clear from the above what advantages a particular antialias method provides, since 1.12, there is also a set of hints: These make no guarantee on how the backend will perform its rasterisation (if it even rasterises!), nor that they have any differing effect other than to enable some form of antialiasing. In the case of glyph rendering, *CAIRO_ANTIALIAS_FAST* and *CAIRO_ANTIALIAS_GOOD* will be mapped to *CAIRO_ANTIALIAS_GRAY*, with *CAIRO_ANTALIAS_BEST* being equivalent to *CAIRO_ANTIALIAS_SUBPIXEL*. The interpretation of *CAIRO_ANTIALIAS_DEFAULT* is left entirely up to the backend, typically this will be similar to *CAIRO_ANTIALIAS_GOOD*.

  * CAIRO_ANTIALIAS_DEFAULT: Use the default antialiasing for the subsystem and target device, since 1.0

  * CAIRO_ANTIALIAS_NONE: Use a bilevel alpha mask, since 1.0

  * CAIRO_ANTIALIAS_GRAY: Perform single-color antialiasing (using shades of gray for black text on a white background, for example), since 1.0

  * CAIRO_ANTIALIAS_SUBPIXEL: Perform antialiasing by taking advantage of the order of subpixel elements on devices such as LCD panels, since 1.0

  * CAIRO_ANTIALIAS_FAST: Hint that the backend should perform some antialiasing but prefer speed over quality, since 1.12

  * CAIRO_ANTIALIAS_GOOD: The backend should balance quality against performance, since 1.12

  * CAIRO_ANTIALIAS_BEST: Hint that the backend should render at the highest quality, sacrificing speed if necessary, since 1.12

  * CAIRO_ANTIALIAS_FAST: Allow the backend to degrade raster quality for speed

  * CAIRO_ANTIALIAS_GOOD: A balance between speed and quality

  * CAIRO_ANTIALIAS_BEST: A high-fidelity, but potentially slow, raster mode

enum cairo_content_t
--------------------

**cairo_content_t** is used to describe the content that a surface will contain, whether color information, alpha information (translucence vs. opacity), or both.

Note: The large values here are designed to keep **cairo_content_t** values distinct from **cairo_format_t** values so that the implementation can detect the error if users confuse the two types.

  * CAIRO_CONTENT_COLOR: The surface will hold color content only.

  * CAIRO_CONTENT_ALPHA: The surface will hold alpha content only.

  * CAIRO_CONTENT_COLOR_ALPHA: The surface will hold color and alpha content.

enum cairo_device_type_t
------------------------

**cairo_device_type_t** is used to describe the type of a given device. The devices types are also known as "backends" within cairo. The device type can be queried with `cairo_device_get_type()` The various **cairo_device_t** functions can be used with devices of any type, but some backends also provide type-specific functions that must only be called with a device of the appropriate type. These functions have names that begin with <literal>cairo_**type**_device</literal> such as `cairo_xcb_device_debug_cap_xrender_version()`.

The behavior of calling a type-specific function with a device of the wrong type is undefined. New entries may be added in future versions.

  * CAIRO_DEVICE_TYPE_DRM: The device is of type Direct Render Manager

  * CAIRO_DEVICE_TYPE_GL: The device is of type OpenGL

  * CAIRO_DEVICE_TYPE_SCRIPT: The device is of type script

  * CAIRO_DEVICE_TYPE_XCB: The device is of type xcb

  * CAIRO_DEVICE_TYPE_XLIB: The device is of type xlib

  * CAIRO_DEVICE_TYPE_XML: The device is of type XML

  * CAIRO_DEVICE_TYPE_COGL: The device is of type cogl

  * CAIRO_DEVICE_TYPE_WIN32: The device is of type win32

  * CAIRO_DEVICE_TYPE_INVALID: The device is invalid

enum cairo_extend_t
-------------------

**cairo_extend_t** is used to describe how pattern color/alpha will be determined for areas "outside" the pattern's natural area, (for example, outside the surface bounds or outside the gradient geometry). Mesh patterns are not affected by the extend mode. The default extend mode is `CAIRO_EXTEND_NONE` for surface patterns and `CAIRO_EXTEND_PAD` for gradient patterns. New entries may be added in future versions.

  * CAIRO_EXTEND_NONE: pixels outside of the source pattern are fully transparent (Since 1.0)

  * CAIRO_EXTEND_REPEAT: the pattern is tiled by repeating (Since 1.0)

  * CAIRO_EXTEND_REFLECT: the pattern is tiled by reflecting at the edges (Since 1.0; but only implemented for surface patterns since 1.6)

  * CAIRO_EXTEND_PAD: pixels outside of the pattern copy the closest pixel from the source (Since 1.2; but only implemented for surface patterns since 1.6)

enum cairo_fill_rule_t
----------------------

**cairo_fill_rule_t** is used to select how paths are filled. For both fill rules, whether or not a point is included in the fill is determined by taking a ray from that point to infinity and looking at intersections with the path. The ray can be in any direction, as long as it doesn't pass through the end point of a segment or have a tricky intersection such as intersecting tangent to the path. (Note that filling is not actually implemented in this way. This is just a description of the rule that is applied.) The default fill rule is `CAIRO_FILL_RULE_WINDING`. New entries may be added in future versions.

  * CAIRO_FILL_RULE_WINDING: If the path crosses the ray from left-to-right, counts +1. If the path crosses the ray from right to left, counts -1. (Left and right are determined from the perspective of looking along the ray from the starting point.) If the total count is non-zero, the point will be filled. (Since 1.0)

  * CAIRO_FILL_RULE_EVEN_ODD: Counts the total number of intersections, without regard to the orientation of the contour. If the total number of intersections is odd, the point will be filled. (Since 1.0)

enum cairo_filter_t
-------------------

**cairo_filter_t** is used to indicate what filtering should be applied when reading pixel values from patterns. See `cairo_pattern_set_filter()` for indicating the desired filter to be used with a particular pattern.

  * CAIRO_FILTER_FAST: A high-performance filter, with quality similar to `CAIRO_FILTER_NEAREST` (Since 1.0)

  * CAIRO_FILTER_GOOD: A reasonable-performance filter, with quality similar to `CAIRO_FILTER_BILINEAR` (Since 1.0)

  * CAIRO_FILTER_BEST: The highest-quality available, performance may not be suitable for interactive use. (Since 1.0)

  * CAIRO_FILTER_NEAREST: Nearest-neighbor filtering (Since 1.0)

  * CAIRO_FILTER_BILINEAR: Linear interpolation in two dimensions (Since 1.0)

  * CAIRO_FILTER_GAUSSIAN: This filter value is currently unimplemented, and should not be used in current code. (Since 1.0)

enum cairo_font_slant_t
-----------------------

Specifies variants of a font face based on their slant.

  * CAIRO_FONT_SLANT_NORMAL: Upright font style, since 1.0

  * CAIRO_FONT_SLANT_ITALIC: Italic font style, since 1.0

  * CAIRO_FONT_SLANT_OBLIQUE: Oblique font style, since 1.0

enum cairo_font_type_t
----------------------

**cairo_font_type_t** is used to describe the type of a given font face or scaled font. The font types are also known as "font backends" within cairo. The type of a font face is determined by the function used to create it, which will generally be of the form `cairo_B<type>_font_face_create( )`. The font face type can be queried with `cairo_font_face_get_type()` The various **cairo_font_face_t** functions can be used with a font face of any type. The type of a scaled font is determined by the type of the font face passed to `cairo_scaled_font_create()`. The scaled font type can be queried with `cairo_scaled_font_get_type()` The various **cairo_scaled_font_t** functions can be used with scaled fonts of any type, but some font backends also provide type-specific functions that must only be called with a scaled font of the appropriate type. These functions have names that begin with `cairo_B<type>_scaled_font( )` such as `cairo_ft_scaled_font_lock_face()`. The behavior of calling a type-specific function with a scaled font of the wrong type is undefined. New entries may be added in future versions.

  * CAIRO_FONT_TYPE_TOY: The font was created using cairo's toy font api (Since: 1.2)

  * CAIRO_FONT_TYPE_FT: The font is of type FreeType (Since: 1.2)

  * CAIRO_FONT_TYPE_WIN32: The font is of type Win32 (Since: 1.2)

  * CAIRO_FONT_TYPE_QUARTZ: The font is of type Quartz (Since: 1.6, in 1.2 and 1.4 it was named CAIRO_FONT_TYPE_ATSUI)

  * CAIRO_FONT_TYPE_USER: The font was create using cairo's user font api (Since: 1.8)

enum cairo_font_weight_t
------------------------

Specifies variants of a font face based on their weight.

  * CAIRO_FONT_WEIGHT_NORMAL: Normal font weight, since 1.0

  * CAIRO_FONT_WEIGHT_BOLD: Bold font weight, since 1.0

enum cairo_format_t
-------------------

**cairo_format_t** is used to identify the memory format of image data. New entries may be added in future versions.

  * CAIRO_FORMAT_INVALID: no such format exists or is supported.

  * CAIRO_FORMAT_ARGB32: each pixel is a 32-bit quantity, with alpha in the upper 8 bits, then red, then green, then blue. The 32-bit quantities are stored native-endian. Pre-multiplied alpha is used. (That is, 50% transparent red is 0x80800000, not 0x80ff0000.) (Since 1.0)

  * CAIRO_FORMAT_RGB24: each pixel is a 32-bit quantity, with the upper 8 bits unused. Red, Green, and Blue are stored in the remaining 24 bits in that order. (Since 1.0)

  * CAIRO_FORMAT_A8: each pixel is a 8-bit quantity holding an alpha value. (Since 1.0)

  * CAIRO_FORMAT_A1: each pixel is a 1-bit quantity holding an alpha value. Pixels are packed together into 32-bit quantities. The ordering of the bits matches the endianness of the platform. On a big-endian machine, the first pixel is in the uppermost bit, on a little-endian machine the first pixel is in the least-significant bit. (Since 1.0)

  * CAIRO_FORMAT_RGB16_565: each pixel is a 16-bit quantity with red in the upper 5 bits, then green in the middle 6 bits, and blue in the lower 5 bits. (Since 1.2)

  * CAIRO_FORMAT_RGB30: like RGB24 but with 10bpc. (Since 1.12)

enum cairo_hint_metrics_t
-------------------------

Specifies whether to hint font metrics; hinting font metrics means quantizing them so that they are integer values in device space. Doing this improves the consistency of letter and line spacing, however it also means that text will be laid out differently at different zoom factors.

  * CAIRO_HINT_METRICS_DEFAULT: Hint metrics in the default manner for the font backend and target device, since 1.0

  * CAIRO_HINT_METRICS_OFF: Do not hint font metrics, since 1.0

  * CAIRO_HINT_METRICS_ON: Hint font metrics, since 1.0

enum cairo_hint_style_t
-----------------------

Specifies the type of hinting to do on font outlines. Hinting is the process of fitting outlines to the pixel grid in order to improve the appearance of the result. Since hinting outlines involves distorting them, it also reduces the faithfulness to the original outline shapes. Not all of the outline hinting styles are supported by all font backends. New entries may be added in future versions.

  * CAIRO_HINT_STYLE_DEFAULT: Use the default hint style for font backend and target device, since 1.0

  * CAIRO_HINT_STYLE_NONE: Do not hint outlines, since 1.0

  * CAIRO_HINT_STYLE_SLIGHT: Hint outlines slightly to improve contrast while retaining good fidelity to the original shapes, since 1.0

  * CAIRO_HINT_STYLE_MEDIUM: Hint outlines with medium strength giving a compromise between fidelity to the original shapes and contrast, since 1.0

  * CAIRO_HINT_STYLE_FULL: Hint outlines to maximize contrast, since 1.0

enum cairo_line_cap_t
---------------------

Specifies how to render the endpoints of the path when stroking. The default line cap style is `CAIRO_LINE_CAP_BUTT`.

  * CAIRO_LINE_CAP_BUTT: start(stop) the line exactly at the start(end) point (Since 1.0)

  * CAIRO_LINE_CAP_ROUND: use a round ending, the center of the circle is the end point (Since 1.0)

  * CAIRO_LINE_CAP_SQUARE: use squared ending, the center of the square is the end point (Since 1.0)

enum cairo_line_join_t
----------------------

Specifies how to render the junction of two lines when stroking. The default line join style is `CAIRO_LINE_JOIN_MITER`.

  * CAIRO_LINE_JOIN_MITER: use a sharp (angled) corner, see `cairo_set_miter_limit()` (Since 1.0)

  * CAIRO_LINE_JOIN_ROUND: use a rounded join, the center of the circle is the joint point (Since 1.0)

  * CAIRO_LINE_JOIN_BEVEL: use a cut-off join, the join is cut off at half the line width from the joint point (Since 1.0)

enum cairo_operator_t
---------------------

**cairo_operator_t** is used to set the compositing operator for all cairo drawing operations. The default operator is `CAIRO_OPERATOR_OVER`. The operators marked as *unbounded* modify their destination even outside of the mask layer (that is, their effect is not bound by the mask layer). However, their effect can still be limited by way of clipping. To keep things simple, the operator descriptions here document the behavior for when both source and destination are either fully transparent or fully opaque. The actual implementation works for translucent layers too. For a more detailed explanation of the effects of each operator, including the mathematical definitions, see <ulink url="https://cairographics.org/operators/">https://cairographics.org/operators/</ulink>.

  * CAIRO_OPERATOR_CLEAR: clear destination layer (bounded) (Since 1.0)

  * CAIRO_OPERATOR_SOURCE: replace destination layer (bounded) (Since 1.0)

  * CAIRO_OPERATOR_OVER: draw source layer on top of destination layer (bounded) (Since 1.0)

  * CAIRO_OPERATOR_IN: draw source where there was destination content (unbounded) (Since 1.0)

  * CAIRO_OPERATOR_OUT: draw source where there was no destination content (unbounded) (Since 1.0)

  * CAIRO_OPERATOR_ATOP: draw source on top of destination content and only there (Since 1.0)

  * CAIRO_OPERATOR_DEST: ignore the source (Since 1.0)

  * CAIRO_OPERATOR_DEST_OVER: draw destination on top of source (Since 1.0)

  * CAIRO_OPERATOR_DEST_IN: leave destination only where there was source content (unbounded) (Since 1.0)

  * CAIRO_OPERATOR_DEST_OUT: leave destination only where there was no source content (Since 1.0)

  * CAIRO_OPERATOR_DEST_ATOP: leave destination on top of source content and only there (unbounded) (Since 1.0)

  * CAIRO_OPERATOR_XOR: source and destination are shown where there is only one of them (Since 1.0)

  * CAIRO_OPERATOR_ADD: source and destination layers are accumulated (Since 1.0)

  * CAIRO_OPERATOR_SATURATE: like over, but assuming source and dest are disjoint geometries (Since 1.0)

  * CAIRO_OPERATOR_MULTIPLY: source and destination layers are multiplied. This causes the result to be at least as dark as the darker inputs. (Since 1.10)

  * CAIRO_OPERATOR_SCREEN: source and destination are complemented and multiplied. This causes the result to be at least as light as the lighter inputs. (Since 1.10)

  * CAIRO_OPERATOR_OVERLAY: multiplies or screens, depending on the lightness of the destination color. (Since 1.10)

  * CAIRO_OPERATOR_DARKEN: replaces the destination with the source if it is darker, otherwise keeps the source. (Since 1.10)

  * CAIRO_OPERATOR_LIGHTEN: replaces the destination with the source if it is lighter, otherwise keeps the source. (Since 1.10)

  * CAIRO_OPERATOR_COLOR_DODGE: brightens the destination color to reflect the source color. (Since 1.10)

  * CAIRO_OPERATOR_COLOR_BURN: darkens the destination color to reflect the source color. (Since 1.10)

  * CAIRO_OPERATOR_HARD_LIGHT: Multiplies or screens, dependent on source color. (Since 1.10)

  * CAIRO_OPERATOR_SOFT_LIGHT: Darkens or lightens, dependent on source color. (Since 1.10)

  * CAIRO_OPERATOR_DIFFERENCE: Takes the difference of the source and destination color. (Since 1.10)

  * CAIRO_OPERATOR_EXCLUSION: Produces an effect similar to difference, but with lower contrast. (Since 1.10)

  * CAIRO_OPERATOR_HSL_HUE: Creates a color with the hue of the source and the saturation and luminosity of the target. (Since 1.10)

  * CAIRO_OPERATOR_HSL_SATURATION: Creates a color with the saturation of the source and the hue and luminosity of the target. Painting with this mode onto a gray area produces no change. (Since 1.10)

  * CAIRO_OPERATOR_HSL_COLOR: Creates a color with the hue and saturation of the source and the luminosity of the target. This preserves the gray levels of the target and is useful for coloring monochrome images or tinting color images. (Since 1.10)

  * CAIRO_OPERATOR_HSL_LUMINOSITY: Creates a color with the luminosity of the source and the hue and saturation of the target. This produces an inverse effect to *CAIRO_OPERATOR_HSL_COLOR*. (Since 1.10)

enum cairo_path_data_type_t
---------------------------

**cairo_path_data_t** is used to describe the type of one portion of a path when represented as a **cairo_path_t**. See **cairo_path_data_t** for details.

  * CAIRO_PATH_MOVE_TO: A move-to operation, since 1.0

  * CAIRO_PATH_LINE_TO: A line-to operation, since 1.0

  * CAIRO_PATH_CURVE_TO: A curve-to operation, since 1.0

  * CAIRO_PATH_CLOSE_PATH: A close-path operation, since 1.0

enum cairo_pattern_type_t
-------------------------

**cairo_pattern_type_t** is used to describe the type of a given pattern. The type of a pattern is determined by the function used to create it. The `cairo_pattern_create_rgb()` and `cairo_pattern_create_rgba()` functions create SOLID patterns. The remaining cairo_pattern_create functions map to pattern types in obvious ways. The pattern type can be queried with `cairo_pattern_get_type()` Most **cairo_pattern_t** functions can be called with a pattern of any type, (though trying to change the extend or filter for a solid pattern will have no effect). A notable exception is `cairo_pattern_add_color_stop_rgb()` and `cairo_pattern_add_color_stop_rgba()` which must only be called with gradient patterns (either LINEAR or RADIAL). Otherwise the pattern will be shutdown and put into an error state. New entries may be added in future versions.

  * CAIRO_PATTERN_TYPE_SOLID: The pattern is a solid (uniform) color. It may be opaque or translucent, since 1.2.

  * CAIRO_PATTERN_TYPE_SURFACE: The pattern is a based on a surface (an image), since 1.2.

  * CAIRO_PATTERN_TYPE_LINEAR: The pattern is a linear gradient, since 1.2.

  * CAIRO_PATTERN_TYPE_RADIAL: The pattern is a radial gradient, since 1.2.

  * CAIRO_PATTERN_TYPE_MESH: The pattern is a mesh, since 1.12.

  * CAIRO_PATTERN_TYPE_RASTER_SOURCE: The pattern is a user pattern providing raster data, since 1.12.

enum cairo_region_overlap_t
---------------------------

Used as the return value for `cairo_region_contains_rectangle()`.

  * CAIRO_REGION_OVERLAP_IN: The contents are entirely inside the region. (Since 1.10)

  * CAIRO_REGION_OVERLAP_OUT: The contents are entirely outside the region. (Since 1.10)

  * CAIRO_REGION_OVERLAP_PART: The contents are partially inside and partially outside the region. (Since 1.10)

enum cairo_status_t
-------------------

**cairo_status_t** is used to indicate errors that can occur when using Cairo. In some cases it is returned directly by functions. but when using **cairo_t**, the last error, if any, is stored in the context and can be retrieved with `cairo_status()`. New entries may be added in future versions. Use `cairo_status_to_string()` to get a human-readable representation of an error message.

  * CAIRO_STATUS_SUCCESS: no error has occurred (Since 1.0)

  * CAIRO_STATUS_NO_MEMORY: out of memory (Since 1.0)

  * CAIRO_STATUS_INVALID_RESTORE: `cairo_restore()` called without matching `cairo_save()` (Since 1.0)

  * CAIRO_STATUS_INVALID_POP_GROUP: no saved group to pop, i.e. `cairo_pop_group()` without matching `cairo_push_group()` (Since 1.0)

  * CAIRO_STATUS_NO_CURRENT_POINT: no current point defined (Since 1.0)

  * CAIRO_STATUS_INVALID_MATRIX: invalid matrix (not invertible) (Since 1.0)

  * CAIRO_STATUS_INVALID_STATUS: invalid value for an input **cairo_status_t** (Since 1.0)

  * CAIRO_STATUS_NULL_POINTER: `Any` pointer (Since 1.0)

  * CAIRO_STATUS_INVALID_STRING: input string not valid UTF-8 (Since 1.0)

  * CAIRO_STATUS_INVALID_PATH_DATA: input path data not valid (Since 1.0)

  * CAIRO_STATUS_READ_ERROR: error while reading from input stream (Since 1.0)

  * CAIRO_STATUS_WRITE_ERROR: error while writing to output stream (Since 1.0)

  * CAIRO_STATUS_SURFACE_FINISHED: target surface has been finished (Since 1.0)

  * CAIRO_STATUS_SURFACE_TYPE_MISMATCH: the surface type is not appropriate for the operation (Since 1.0)

  * CAIRO_STATUS_PATTERN_TYPE_MISMATCH: the pattern type is not appropriate for the operation (Since 1.0)

  * CAIRO_STATUS_INVALID_CONTENT: invalid value for an input **cairo_content_t** (Since 1.0)

  * CAIRO_STATUS_INVALID_FORMAT: invalid value for an input **cairo_format_t** (Since 1.0)

  * CAIRO_STATUS_INVALID_VISUAL: invalid value for an input Visual* (Since 1.0)

  * CAIRO_STATUS_FILE_NOT_FOUND: file not found (Since 1.0)

  * CAIRO_STATUS_INVALID_DASH: invalid value for a dash setting (Since 1.0)

  * CAIRO_STATUS_INVALID_DSC_COMMENT: invalid value for a DSC comment (Since 1.2)

  * CAIRO_STATUS_INVALID_INDEX: invalid index passed to getter (Since 1.4)

  * CAIRO_STATUS_CLIP_NOT_REPRESENTABLE: clip region not representable in desired format (Since 1.4)

  * CAIRO_STATUS_TEMP_FILE_ERROR: error creating or writing to a temporary file (Since 1.6)

  * CAIRO_STATUS_INVALID_STRIDE: invalid value for stride (Since 1.6)

  * CAIRO_STATUS_FONT_TYPE_MISMATCH: the font type is not appropriate for the operation (Since 1.8)

  * CAIRO_STATUS_USER_FONT_IMMUTABLE: the user-font is immutable (Since 1.8)

  * CAIRO_STATUS_USER_FONT_ERROR: error occurred in a user-font callback function (Since 1.8)

  * CAIRO_STATUS_NEGATIVE_COUNT: negative number used where it is not allowed (Since 1.8)

  * CAIRO_STATUS_INVALID_CLUSTERS: input clusters do not represent the accompanying text and glyph array (Since 1.8)

  * CAIRO_STATUS_INVALID_SLANT: invalid value for an input **cairo_font_slant_t** (Since 1.8)

  * CAIRO_STATUS_INVALID_WEIGHT: invalid value for an input **cairo_font_weight_t** (Since 1.8)

  * CAIRO_STATUS_INVALID_SIZE: invalid value (typically too big) for the size of the input (surface, pattern, etc.) (Since 1.10)

  * CAIRO_STATUS_USER_FONT_NOT_IMPLEMENTED: user-font method not implemented (Since 1.10)

  * CAIRO_STATUS_DEVICE_TYPE_MISMATCH: the device type is not appropriate for the operation (Since 1.10)

  * CAIRO_STATUS_DEVICE_ERROR: an operation to the device caused an unspecified error (Since 1.10)

  * CAIRO_STATUS_INVALID_MESH_CONSTRUCTION: a mesh pattern construction operation was used outside of a `cairo_mesh_pattern_begin_patch()`/`cairo_mesh_pattern_end_patch()` pair (Since 1.12)

  * CAIRO_STATUS_DEVICE_FINISHED: target device has been finished (Since 1.12)

  * CAIRO_STATUS_JBIG2_GLOBAL_MISSING: `CAIRO_MIME_TYPE_JBIG2_GLOBAL_ID` has been used on at least one image but no image provided `CAIRO_MIME_TYPE_JBIG2_GLOBAL` (Since 1.14)

  * CAIRO_STATUS_PNG_ERROR: error occurred in libpng while reading from or writing to a PNG file (Since 1.16)

  * CAIRO_STATUS_FREETYPE_ERROR: error occurred in libfreetype (Since 1.16)

  * CAIRO_STATUS_WIN32_GDI_ERROR: error occurred in the Windows Graphics Device Interface (Since 1.16)

  * CAIRO_STATUS_TAG_ERROR: invalid tag name, attributes, or nesting (Since 1.16)

  * CAIRO_STATUS_LAST_STATUS: this is a special value indicating the number of status values defined in this enumeration. When using this value, note that the version of cairo at run-time may have additional status values defined than the value of this symbol at compile-time. (Since 1.10)

enum cairo_subpixel_order_t
---------------------------

The subpixel order specifies the order of color elements within each pixel on the display device when rendering with an antialiasing mode of `CAIRO_ANTIALIAS_SUBPIXEL`.

  * CAIRO_SUBPIXEL_ORDER_DEFAULT: Use the default subpixel order for for the target device, since 1.0

  * CAIRO_SUBPIXEL_ORDER_RGB: Subpixel elements are arranged horizontally with red at the left, since 1.0

  * CAIRO_SUBPIXEL_ORDER_BGR: Subpixel elements are arranged horizontally with blue at the left, since 1.0

  * CAIRO_SUBPIXEL_ORDER_VRGB: Subpixel elements are arranged vertically with red at the top, since 1.0

  * CAIRO_SUBPIXEL_ORDER_VBGR: Subpixel elements are arranged vertically with blue at the top, since 1.0

enum cairo_surface_observer_mode_t
----------------------------------

Whether operations should be recorded.

  * CAIRO_SURFACE_OBSERVER_NORMAL: no recording is done

  * CAIRO_SURFACE_OBSERVER_RECORD_OPERATIONS: operations are recorded

enum cairo_surface_type_t
-------------------------

**cairo_surface_type_t** is used to describe the type of a given surface. The surface types are also known as "backends" or "surface backends" within cairo. The type of a surface is determined by the function used to create it, which will generally be of the form `cairo_B<type>_surface_create( )`, (though see `cairo_surface_create_similar()` as well). The surface type can be queried with `cairo_surface_get_type()` The various **cairo_surface_t** functions can be used with surfaces of any type, but some backends also provide type-specific functions that must only be called with a surface of the appropriate type. These functions have names that begin with <literal>cairo_**type**_surface</literal> such as `cairo_image_surface_get_width()`. The behavior of calling a type-specific function with a surface of the wrong type is undefined. New entries may be added in future versions.

  * CAIRO_SURFACE_TYPE_IMAGE: The surface is of type image, since 1.2

  * CAIRO_SURFACE_TYPE_PDF: The surface is of type pdf, since 1.2

  * CAIRO_SURFACE_TYPE_PS: The surface is of type ps, since 1.2

  * CAIRO_SURFACE_TYPE_XLIB: The surface is of type xlib, since 1.2

  * CAIRO_SURFACE_TYPE_XCB: The surface is of type xcb, since 1.2

  * CAIRO_SURFACE_TYPE_GLITZ: The surface is of type glitz, since 1.2

  * CAIRO_SURFACE_TYPE_QUARTZ: The surface is of type quartz, since 1.2

  * CAIRO_SURFACE_TYPE_WIN32: The surface is of type win32, since 1.2

  * CAIRO_SURFACE_TYPE_BEOS: The surface is of type beos, since 1.2

  * CAIRO_SURFACE_TYPE_DIRECTFB: The surface is of type directfb, since 1.2

  * CAIRO_SURFACE_TYPE_SVG: The surface is of type svg, since 1.2

  * CAIRO_SURFACE_TYPE_OS2: The surface is of type os2, since 1.4

  * CAIRO_SURFACE_TYPE_WIN32_PRINTING: The surface is a win32 printing surface, since 1.6

  * CAIRO_SURFACE_TYPE_QUARTZ_IMAGE: The surface is of type quartz_image, since 1.6

  * CAIRO_SURFACE_TYPE_SCRIPT: The surface is of type script, since 1.10

  * CAIRO_SURFACE_TYPE_QT: The surface is of type Qt, since 1.10

  * CAIRO_SURFACE_TYPE_RECORDING: The surface is of type recording, since 1.10

  * CAIRO_SURFACE_TYPE_VG: The surface is a OpenVG surface, since 1.10

  * CAIRO_SURFACE_TYPE_GL: The surface is of type OpenGL, since 1.10

  * CAIRO_SURFACE_TYPE_DRM: The surface is of type Direct Render Manager, since 1.10

  * CAIRO_SURFACE_TYPE_TEE: The surface is of type 'tee' (a multiplexing surface), since 1.10

  * CAIRO_SURFACE_TYPE_XML: The surface is of type XML (for debugging), since 1.10

  * CAIRO_SURFACE_TYPE_SUBSURFACE: The surface is a subsurface created with `cairo_surface_create_for_rectangle()`, since 1.10

  * CAIRO_SURFACE_TYPE_COGL: This surface is of type Cogl, since 1.12

enum cairo_text_cluster_flags_t
-------------------------------

Specifies properties of a text cluster mapping.

  * CAIRO_TEXT_CLUSTER_FLAG_BACKWARD: The clusters in the cluster array map to glyphs in the glyph array from end to start. (Since 1.8)

