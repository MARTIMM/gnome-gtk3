---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Types in GTK+ / glib and (native) types in Raku

Below there is a table showing all kinds of type definitions used in the several layers C, Glib, GTK, Raku and the fundamental types defined in **Gnome::GObject::Type** called GType.

For sizes defined for C see also [here](https://www.tutorialspoint.com/cprogramming/c_data_types.htm). The next piece of C code from a glib file `gtype.h` shows te definition of a `GType` type. The Raku modules use the C libraries of Glib so we must use the `gsize` type.
```
/**
 * GType:
 *
 * A numerical value which represents the unique identifier of a registered
 * type.
 */
#if GLIB_SIZEOF_SIZE_T != GLIB_SIZEOF_LONG || !defined __cplusplus
typedef gsize                           GType;
#else   /* for historic reasons, C++ links against gulong GTypes */
typedef gulong                          GType;
#endif
```

So the table becomes like shown below;

| Glib Type      | GType ①         | C             | Native Raku   | Raku Type
| -------------- | --------------- | ------------- | ------------- | ---------
| gpointer       |                 | void *        | Pointer[void] |
| gconstpointer  |                 | const void *  | Pointer[void] |
| gboolean, gint | G_TYPE_BOOLEAN  | int           | int           | Int ②③
| gchar          | G_TYPE_CHAR     | char          | int8          | Int ⑦
| guchar         | G_TYPE_UCHAR    | unsigned char | uint8, byte   | UInt
| gint           | G_TYPE_INT      | int           | int           | Int
| guint          | G_TYPE_UINT     | unsigned int  | uint          | UInt
| gshort         |                 | short         | int16         | Int
| gushort        |                 | unsigned short | uint16       | UInt
| glong          | G_TYPE_LONG     | long          | long ⑥        | Int
| gulong         | G_TYPE_ULONG    | unsigned long | uint64        | UInt
| gint8          |                 | char          | int8          | Int
| guint8         |                 | unsigned char | uint8         | UInt
| gint16         |                 | short         | int16         | Int
| guint16        |                 | unsigned short | uint16       | UInt
| gint32         |                 | int           | int32 ④       | Int
| guint32        |                 | unsigned int  | uint32        | UInt
| gint64         | G_TYPE_INT64    | long          | int64         | Int
| guint64        | G_TYPE_UINT64   | unsigned long | uint64        | UInt
| gfloat         | G_TYPE_FLOAT    | float         | num32         | Num
| gdouble        | G_TYPE_DOUBLE   | double        | num64         | Num
| gsize          |                 | unsigned long | ulong         | UInt
| gssize         |                 | long          | long          | Int
| goffset        |                 |               | int64         | Int
| gchar *        | G_TYPE_STRING   | char *        | str           | Str
| gunichar       |                 |               | uint32        | UInt
| GType, gsize   | G_TYPE_GTYPE    | unsigned long | ulong         | Int
| GQuark, guint32 |                |               | uint32        | UInt
| GError         |                 |               |               | N-GError
| GList          |                 |               |               | N-GList
| GObject        | G_TYPE_OBJECT   |               |               | N-GObject
| GSList         |                 |               |               | N-GSList
| GValue         |                 |               |               | N-GValue
|
|                | G_TYPE_ENUM     |               |               | enum ⑤
|                | G_TYPE_FLAGS    |               |               | Int
|
|                | G_TYPE_POINTER
|                | G_TYPE_BOXED
|                | G_TYPE_PARAM
|                | G_TYPE_VARIANT
|                | G_TYPE_CHECKSUM

<br/>

① The fundamental GType names are needed when a sub can handle a scala of value types. For example the **Gnome::Gtk3::TreeStore** and **Gnome::Gtk3::ListStore** can handle columns of different types. The stores are initialized by defining a GType for each column and later a GValue wrapped into the **Gnome::GObject::Value** is used to set a value for a particular column and row.

② The boolean values can be given to native subs as `True` or `False`. These values are automatically unboxed into native integers when they are stored in a `int32` type. When a native sub returns a boolean value, it cannot be coerced into a `Bool` typed variable automatically. One must call `.Bool()` on it to do so. Most of the time this is not necessary because the test control statements in perl handle `0` and `!0` as `False` and `True` perfectly.

③ Raku sees an `int` as 64 bits when processor uses 64, 32 bits otherwise. However, in C the `int` is defined as a 32 bit type. Explanations on the internet varies here and there. This is confusing, so a decision is made to generate a type mapping in **Gnome::N::GlibToRakuTypes** distilled indirectly from the `limits.h` C include file, which takes these types into account and maps it to the Raku fixed ones. So `gsize` is mapped to `uint64` and `gint` is mapped to `int32`. This also means that `long` and `ulong` are not used. See point ⑥.

  Below is a type `GEnum` used from this mapping.
  ```
  sub gtk_window_set_gravity ( N-GObject $window, GEnum $gravity )
    is native(&gtk-lib)
    { * }
  ```

④ `gint32`/`guint32` and `gint64`/`guint64`, although typedef'ed to int and long, are guaranteed to be 32 and 64 bits long according to the docs [here](https://developer.gnome.org/glib/stable/glib-Basic-Types.html#glong).

⑤ Most enumerated values are generated automatically starting from 0. Sometimes these are flags, but still integer. When these are literal integer, the values are of type `int`. Raku will convert a enumeration name automatically to its integer value. The values are always returned as an `int` and must also be converted explicitly if you want to use the enumerated name of the integer. By the way, floating literals are `double` (`num64`), not `float`(`num32`)! Other types are not used in the GNOME libraries (I think).

⑥ Raku native types `long`, `ulong` are specific types of the Rakudo implementation.

⑦ Raku `Int` types can hold very large numbers. When used to set a smaller native integer, they are truncated to modulo the size of the type. For instance `int8` is set modulo 256.

<!--

Some sizes
| Glib defined     | C         | Note
|------------------|-----------|-------------
| G_MININT INT_MIN | INT_MIN   | Minimum value which can be held in a gint
| G_MAXINT         | INT_MAX   | maximum value which can be held in a gint
| G_MAXUINT | UINT_MAX | The maximum value which can be held in a guint
| G_MINSHORT | SHRT_MIN | minimum value which can be held in a gshort
| G_MAXSHORT | SHRT_MAX | maximum value which can be held in a gshort
| G_MAXUSHORT | USHRT_MAX | maximum value which can be held in a gushort
| G_MINLONG | LONG_MIN | minimum value which can be held in a glong
| G_MAXLONG | LONG_MAX | maximum value which can be held in a glong
| G_MAXULONG | ULONG_MAX | maximum value which can be held in a gulong

-->
