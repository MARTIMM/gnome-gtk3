TITLE
=====

Gnome::GObject::Param

SUBTITLE
========

Metadata for parameter specifications

Description
===========

*N-GParamSpec* is an object structure that encapsulates the metadata required to specify parameters, such as e.g. *GObject* properties.

Parameter names
---------------

Parameter names need to start with a letter (a-z or A-Z). Subsequent characters can be letters, numbers or a '-'. All other characters are replaced by a '-' during construction. The result of this replacement is called the canonical name of the parameter.

See Also
--------

`g_object_class_install_property()`, `g_object_set()`,

Synopsis
========

Declaration
-----------

    unit class Gnome::GObject::Param;

Example
-------

Types
=====

enum GParamFlags
----------------

Through the *GParamFlags* flag values, certain aspects of parameters can be configured. See also *G_PARAM_STATIC_STRINGS*.

  * G_PARAM_READABLE: the parameter is readable

  * G_PARAM_WRITABLE: the parameter is writable

  * G_PARAM_READWRITE: alias for `G_PARAM_READABLE` | `G_PARAM_WRITABLE`

  * G_PARAM_CONSTRUCT: the parameter will be set upon object construction

  * G_PARAM_CONSTRUCT_ONLY: the parameter can only be set upon object construction

  * G_PARAM_LAX_VALIDATION: upon parameter conversion (see `g_param_value_convert()`) strict validation is not required

  * G_PARAM_STATIC_NAME: the string used as name when constructing the parameter is guaranteed to remain valid and unmodified for the lifetime of the parameter. Since 2.8

  * G_PARAM_STATIC_NICK: the string used as nick when constructing the parameter is guaranteed to remain valid and unmmodified for the lifetime of the parameter. Since 2.8

  * G_PARAM_STATIC_BLURB: the string used as blurb when constructing the parameter is guaranteed to remain valid and unmodified for the lifetime of the parameter. Since 2.8

  * G_PARAM_EXPLICIT_NOTIFY: calls to `g_object_set_property()` for this property will not automatically result in a "notify" signal being emitted: the implementation must call `g_object_notify()` themselves in case the property actually changes. Since: 2.42.

  * G_PARAM_PRIVATE: internal

  * G_PARAM_DEPRECATED: the parameter is deprecated and will be removed in a future version. A warning will be generated if it is used while running with G_ENABLE_DIAGNOSTIC=1. Since 2.26

class N-GParamSpec
------------------

All other fields of the N-GParamSpec struct are private and should not be used directly.

  * $.name: name of this parameter.

  * GParamFlags $.flags: Flags for this parameter

  * $.value_type: the *GValue* type for this parameter

  * $.owner_type: *GType* type that uses (introduces) this parameter

Methods
=======

new
---

### multi method new ( N-GParamSpec :$gparam! )

Create a N-GParamSpec using a native object from elsewhere.

[[g_] param_] spec_ref
----------------------

Increments the reference count of *pspec*.

Returns: the *N-GParamSpec* that was passed into this function

    method g_param_spec_ref ( N-GParamSpec $pspec --> N-GParamSpec  )

  * N-GParamSpec $pspec; a valid *N-GParamSpec*

[[g_] param_] spec_unref
------------------------

Decrements the reference count of a *pspec*.

    method g_param_spec_unref ( N-GParamSpec $pspec )

  * N-GParamSpec $pspec; a valid *N-GParamSpec*

[[g_] param_] spec_sink
-----------------------

The initial reference count of a newly created *N-GParamSpec* is 1, even though no one has explicitly called `g_param_spec_ref()` on it yet. So the initial reference count is flagged as "floating", until someone calls `g_param_spec_ref(pspec)` and `g_param_spec_sink(pspec)` in sequence on it, taking over the initial reference count (thus ending up with a *pspec* that has a reference count of 1 still, but is not flagged "floating" anymore).

    method g_param_spec_sink ( N-GParamSpec $pspec )

  * N-GParamSpec $pspec; a valid *N-GParamSpec*

[[g_] param_] spec_ref_sink
---------------------------

Convenience function to ref and sink a *N-GParamSpec*.

Since: 2.10 Returns: the *N-GParamSpec* that was passed into this function

    method g_param_spec_ref_sink ( N-GParamSpec $pspec --> N-GParamSpec  )

  * N-GParamSpec $pspec; a valid *N-GParamSpec*

[[g_] param_] spec_get_qdata
----------------------------

Gets back user data pointers stored via `g_param_spec_set_qdata()`.

Returns: (transfer none): the user data pointer set, or `Any`

    method g_param_spec_get_qdata ( N-GParamSpec $pspec, N-GObject $quark --> Pointer  )

  * N-GParamSpec $pspec; a valid *N-GParamSpec*

  * N-GObject $quark; a *GQuark*, naming the user data pointer

[[g_] param_] spec_set_qdata
----------------------------

Sets an opaque, named pointer on a *N-GParamSpec*. The name is specified through a *GQuark* (retrieved e.g. via `g_quark_from_static_string()`), and the pointer can be gotten back from the *pspec* with `g_param_spec_get_qdata()`. Setting a previously set user data pointer, overrides (frees) the old pointer set, using `Any` as pointer essentially removes the data stored.

    method g_param_spec_set_qdata ( N-GParamSpec $pspec, N-GObject $quark, Pointer $data )

  * N-GParamSpec $pspec; the *N-GParamSpec* to set store a user data pointer

  * N-GObject $quark; a *GQuark*, naming the user data pointer

  * Pointer $data; an opaque user data pointer

[[g_] param_] spec_steal_qdata
------------------------------

Gets back user data pointers stored via `g_param_spec_set_qdata()` and removes the *data* from *pspec* without invoking its `destroy()` function (if any was set). Usually, calling this function is only required to update user data pointers with a destroy notifier.

Returns: (transfer none): the user data pointer set, or `Any`

    method g_param_spec_steal_qdata ( N-GParamSpec $pspec, N-GObject $quark --> Pointer  )

  * N-GParamSpec $pspec; the *N-GParamSpec* to get a stored user data pointer from

  * N-GObject $quark; a *GQuark*, naming the user data pointer

[[g_] param_] spec_get_redirect_target
--------------------------------------

If the paramspec redirects operations to another paramspec, returns that paramspec. Redirect is used typically for providing a new implementation of a property in a derived type while preserving all the properties from the parent type. Redirection is established by creating a property of type *N-GParamSpecOverride*. See `g_object_class_override_property()` for an example of the use of this capability.

Since: 2.4

Returns: (transfer none): paramspec to which requests on this paramspec should be redirected, or `Any` if none.

    method g_param_spec_get_redirect_target ( N-GParamSpec $pspec --> N-GParamSpec  )

  * N-GParamSpec $pspec; a *N-GParamSpec*

[[g_] param_] value_set_default
-------------------------------

Sets *value* to its default value as specified in *pspec*.

    method g_param_value_set_default ( N-GParamSpec $pspec, N-GObject $value )

  * N-GParamSpec $pspec; a valid *N-GParamSpec*

  * N-GObject $value; a *GValue* of correct type for *pspec*

[[g_] param_] value_defaults
----------------------------

Checks whether *value* contains the default value as specified in *pspec*.

Returns: whether *value* contains the canonical default for this *pspec*

    method g_param_value_defaults ( N-GParamSpec $pspec, N-GObject $value --> Int  )

  * N-GParamSpec $pspec; a valid *N-GParamSpec*

  * N-GObject $value; a *GValue* of correct type for *pspec*

[[g_] param_] value_validate
----------------------------

Ensures that the contents of *value* comply with the specifications set out by *pspec*. For example, a *N-GParamSpecInt* might require that integers stored in *value* may not be smaller than -42 and not be greater than +42. If *value* contains an integer outside of this range, it is modified accordingly, so the resulting value will fit into the range -42 .. +42.

Returns: whether modifying *value* was necessary to ensure validity

    method g_param_value_validate ( N-GParamSpec $pspec, N-GObject $value --> Int  )

  * N-GParamSpec $pspec; a valid *N-GParamSpec*

  * N-GObject $value; a *GValue* of correct type for *pspec*

[[g_] param_] value_convert
---------------------------

Transforms *src_value* into *dest_value* if possible, and then validates *dest_value*, in order for it to conform to *pspec*. If *strict_validation* is `1` this function will only succeed if the transformed *dest_value* complied to *pspec* without modifications.

See also `g_value_type_transformable()`, `g_value_transform()` and `g_param_value_validate()`.

Returns: `1` if transformation and validation were successful, `0` otherwise and *dest_value* is left untouched.

    method g_param_value_convert ( N-GParamSpec $pspec, N-GObject $src_value, N-GObject $dest_value, Int $strict_validation --> Int  )

  * N-GParamSpec $pspec; a valid *N-GParamSpec*

  * N-GObject $src_value; souce *GValue*

  * N-GObject $dest_value; destination *GValue* of correct type for *pspec*

  * Int $strict_validation; `1` requires *dest_value* to conform to *pspec* without modifications

[[g_] param_] values_cmp
------------------------

Compares *value1* with *value2* according to *pspec*, and return -1, 0 or +1, if *value1* is found to be less than, equal to or greater than *value2*, respectively.

Returns: -1, 0 or +1, for a less than, equal to or greater than result

    method g_param_values_cmp ( N-GParamSpec $pspec, N-GObject $value1, N-GObject $value2 --> Int  )

  * N-GParamSpec $pspec; a valid *N-GParamSpec*

  * N-GObject $value1; a *GValue* of correct type for *pspec*

  * N-GObject $value2; a *GValue* of correct type for *pspec*

[[g_] param_] spec_get_name
---------------------------

Get the name of a *N-GParamSpec*.

The name is always an "interned" string (as per `g_intern_string()`). This allows for pointer-value comparisons.

Returns: the name of *pspec*.

    method g_param_spec_get_name ( N-GParamSpec $pspec --> Str  )

  * N-GParamSpec $pspec; a valid *N-GParamSpec*

[[g_] param_] spec_get_nick
---------------------------

Get the nickname of a *N-GParamSpec*.

Returns: the nickname of *pspec*.

    method g_param_spec_get_nick ( N-GParamSpec $pspec --> Str  )

  * N-GParamSpec $pspec; a valid *N-GParamSpec*

[[g_] param_] spec_get_blurb
----------------------------

Get the short description of a *N-GParamSpec*.

Returns: the short description of *pspec*.

    method g_param_spec_get_blurb ( N-GParamSpec $pspec --> Str  )

  * N-GParamSpec $pspec; a valid *N-GParamSpec*

[g_] value_set_param
--------------------

Set the contents of a `G_TYPE_PARAM` *GValue* to *param*.

    method g_value_set_param ( N-GObject $value, N-GParamSpec $param )

  * N-GObject $value; a valid *GValue* of type `G_TYPE_PARAM`

  * N-GParamSpec $param; (nullable): the *N-GParamSpec* to be set

[g_] value_get_param
--------------------

Get the contents of a `G_TYPE_PARAM` *GValue*.

Returns: (transfer none): *N-GParamSpec* content of *value*

    method g_value_get_param ( N-GObject $value --> N-GParamSpec  )

  * N-GObject $value; a valid *GValue* whose type is derived from `G_TYPE_PARAM`

[g_] value_dup_param
--------------------

Get the contents of a `G_TYPE_PARAM` *GValue*, increasing its reference count.

Returns: *N-GParamSpec* content of *value*, should be unreferenced when no longer needed.

    method g_value_dup_param ( N-GObject $value --> N-GParamSpec  )

  * N-GObject $value; a valid *GValue* whose type is derived from `G_TYPE_PARAM`

[g_] value_take_param
---------------------

Sets the contents of a `G_TYPE_PARAM` *GValue* to *param* and takes over the ownership of the callers reference to *param*; the caller doesn't have to unref it any more.

Since: 2.4

    method g_value_take_param ( N-GObject $value, N-GParamSpec $param )

  * N-GObject $value; a valid *GValue* of type `G_TYPE_PARAM`

  * N-GParamSpec $param; (nullable): the *N-GParamSpec* to be set

[[g_] param_] spec_get_default_value
------------------------------------

Gets the default value of *pspec* as a pointer to a *GValue*.

The *GValue* will remain valid for the life of *pspec*.

Returns: a pointer to a *GValue* which must not be modified

Since: 2.38

    method g_param_spec_get_default_value ( N-GParamSpec $pspec --> N-GObject  )

  * N-GParamSpec $pspec; a *N-GParamSpec*

[[g_] param_] spec_get_name_quark
---------------------------------

Gets the GQuark for the name.

Returns: the GQuark for *pspec*->name.

Since: 2.46

    method g_param_spec_get_name_quark ( N-GParamSpec $pspec --> N-GObject  )

  * N-GParamSpec $pspec; a *N-GParamSpec*

[[g_] param_] spec_internal
---------------------------

Creates a new *N-GParamSpec* instance.

A property name consists of segments consisting of ASCII letters and digits, separated by either the '-' or '_' character. The first character of a property name must be a letter. Names which violate these rules lead to undefined behaviour.

When creating and looking up a *N-GParamSpec*, either separator can be used, but they cannot be mixed. Using '-' is considerably more efficient and in fact required when using property names as detail strings for signals.

Beyond the name, *N-GParamSpecs* have two more descriptive strings associated with them, the *nick*, which should be suitable for use as a label for the property in a property editor, and the *blurb*, which should be a somewhat longer description, suitable for e.g. a tooltip. The *nick* and *blurb* should ideally be localized.

Returns: (type GObject.ParamSpec): a newly allocated *N-GParamSpec* instance

    method g_param_spec_internal ( N-GObject $param_type, Str $name, Str $nick, Str $blurb, GParamFlags $flags --> Pointer  )

  * N-GObject $param_type; the *GType* for the property; must be derived from *G_TYPE_PARAM*

  * Str $name; the canonical name of the property

  * Str $nick; the nickname of the property

  * Str $blurb; a short description of the property

  * GParamFlags $flags; a combination of *GParamFlags*

