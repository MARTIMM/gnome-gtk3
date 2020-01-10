---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Types in GTK+ / glib and (native) types in Raku

Below there is a table showing all kinds of type definitions used in the several layers C, Glib, GTK, Raku and the fundamental types defined in **Gnome::GObject::Type** called GType.

| GTK Type | typedef | GType ③ | Native Raku | Raku Type |
| -------- | ------- | ----------- | ------------ |---------- |
| gboolean | gint    | G_TYPE_BOOLEAN | int32        | Int ① |
| gchar *  | char *  | G_TYPE_STRING | str          | Str        |
|
| gchar    | char    | G_TYPE_CHAR | int8         | Int        |
| gshort   | short   || int16        | Int        |
| glong    | long    | G_TYPE_LONG | int64        | Int        |
| gint8    | char    || int8         | Int        |
| gint16   | short   || int16        | Int        |
| gint32   | int     || int32        | Int        |
| gint64   | long    | G_TYPE_INT64 | int64        | Int        |
| gint     | int     | G_TYPE_INT | int32        | Int        |
|
| guchar   | un. char  | G_TYPE_UCHAR | uint8, byte  | Int      |
| gunichar |           || uint32       | Int
| gushort  | un. short || uint16       | Int      |
| gulong   | un. long  | G_TYPE_ULONG | uint64       | Int      |
| guint8   | un. char  || uint8        | Int      |
| guint16  | un. short || uint16       | Int      |
| guint32  | un. int   || uint32       | Int      |
| guint64  | un. long  | G_TYPE_UINT64 | uint64       | Int      |
| guint    | un. int   | G_TYPE_UINT | uint32       | Int      |
|
| gssize   | long      || int64        | Int      |
| gsize    | un. long  || uint64       | Int      |
| goffset  | gint64    || int64        | Int      |
|
| gfloat   | float     | G_TYPE_FLOAT | num32        | Num      |
| gdouble  | double    | G_TYPE_DOUBLE | num64        | Num      |
|
| GType    | int32
| GQuark   | int32
| GError   |           ||              | N-GError
| GList    |           ||              | N-GList
| GSList   |           ||              | N-GSList
| GValue   |           ||              | N-GValue
|
|          | int32     | G_TYPE_ENUM | int32        | enum ② |
|          | int32     | G_TYPE_FLAGS | int32        | Int        |
|          |           | G_TYPE_POINTER
|          |           | G_TYPE_BOXED
|          |           | G_TYPE_PARAM
|          |           | G_TYPE_OBJECT
|          |           | G_TYPE_VARIANT

① The boolean values can be given to native subs as `True` or `False`. These values are automatically transformed into 1 and 0 resp. when the are stored in a **int32** type. When a native sub returns a boolean value, it cannot be coerced into a **Bool** typed variable automatically. One must call `.Bool()` on it to do so. Most of the time this is not necessary because the test control statements in perl handle `0` and `1` as `False` and `True` perfectly.

② Enumerated values can be given to native subs and Raku will convert them automatically to **int32**. The values are always returned as an **int32** and must also be converted explicitly if you want use the enumerated name of the integer.

③ The fundamental GType names are needed when a sub can handle a scala of value types. For example the **Gnome::Gtk3::TreeStore** and **Gnome::Gtk3::ListStore** can handle columns of different types. The stores are initialized by defining a GType for each column and later a GValue wrapped into the **Gnome::GObject::Value** is used to set a value for a particular column and row.
