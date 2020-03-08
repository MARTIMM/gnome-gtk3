Gnome::Glib::Option
===================

parses commandline options

Description
===========

The GOption commandline parser is intended to be a simpler replacement for the popt library. It supports short and long commandline options, as shown in the following example:

`testtreemodel -r 1 --max-size 20 --rand --display=:1.0 -vb -- file1 file2`

The example demonstrates a number of features of the GOption commandline parser:

  * Options can be single letters, prefixed by a single dash.

  * Multiple short options can be grouped behind a single dash.

  * Long options are prefixed by two consecutive dashes.

  * Options can have an extra argument, which can be a number, a string or a filename. For long options, the extra argument can be appended with an equals sign after the option name, which is useful if the extra argument starts with a dash, which would otherwise cause it to be interpreted as another option.

  * Non-option arguments are returned to the application as rest arguments.

  * An argument consisting solely of two dashes turns off further parsing, any remaining arguments (even those starting with a dash) are returned to the application as rest arguments.

Another important feature of GOption is that it can automatically generate nicely formatted help output. Unless it is explicitly turned off with `g_option_context_set_help_enabled()`, GOption will recognize the `--help`, `-?`, `--help-all` and `--help-groupname` options (where `groupname` is the name of a **N-GOptionGroup**) and write a text similar to the one shown in the following example to stdout.

    Usage:
      testtreemodel [OPTION...] - test tree model performance

    Help Options:
      -h, --help               Show help options
      --help-all               Show all help options
      --help-gtk               Show GTK+ Options

    Application Options:
      -r, --repeats=N          Average over N repetitions
      -m, --max-size=M         Test up to 2^M items
      --display=DISPLAY        X display to use
      -v, --verbose            Be verbose
      -b, --beep               Beep when done
      --rand                   Randomize the data

GOption groups options in **N-GOptionGroups**, which makes it easy to incorporate options from multiple sources. The intended use for this is to let applications collect option groups from the libraries it uses, add them to their **N-GOptionContext**, and parse all options by a single call to `g_option_context_parse()`. See `gtk_get_option_group()` for an example.

If an option is declared to be of type string or filename, GOption takes care of converting it to the right encoding; strings are returned in UTF-8, filenames are returned in the GLib filename encoding. Note that this only works if `setlocale()` has been called before `g_option_context_parse()`.

On UNIX systems, the argv that is passed to `main()` has no particular encoding, even to the extent that different parts of it may have different encodings. In general, normal arguments and flags will be in the current locale and filenames should be considered to be opaque byte strings. Proper use of `G_OPTION_ARG_FILENAME` vs `G_OPTION_ARG_STRING` is therefore important.

Note that on Windows, filenames do have an encoding, but using **N-GOptionContext** with the argv as passed to `main()` will result in a program that can only accept commandline arguments with characters from the system codepage. This can cause problems when attempting to deal with filenames containing Unicode characters that fall outside of the codepage.

A solution to this is to use `g_win32_get_command_line()` and `g_option_context_parse_strv()` which will properly handle full Unicode filenames. If you are using **Gnome::Gio::Application**, this is done automatically for you.

Synopsis
========

Declaration
-----------

    unit class Gnome::Glib::Option;

Types
=====

enum GOptionFlags
-----------------

Flags which modify individual options.

  * G_OPTION_FLAG_NONE: No flags. Since: 2.42.

  * G_OPTION_FLAG_HIDDEN: The option doesn't appear in `--help` output.

  * G_OPTION_FLAG_IN_MAIN: The option appears in the main section of the `--help` output, even if it is defined in a group.

  * G_OPTION_FLAG_REVERSE: For options of the `G_OPTION_ARG_NONE` kind, this flag indicates that the sense of the option is reversed.

  * G_OPTION_FLAG_NO_ARG: For options of the `G_OPTION_ARG_CALLBACK` kind, this flag indicates that the callback does not take any argument (like a `G_OPTION_ARG_NONE` option). Since 2.8

  * G_OPTION_FLAG_FILENAME: For options of the `G_OPTION_ARG_CALLBACK` kind, this flag indicates that the argument should be passed to the callback in the GLib filename encoding rather than UTF-8. Since 2.8

  * G_OPTION_FLAG_OPTIONAL_ARG: For options of the `G_OPTION_ARG_CALLBACK` kind, this flag indicates that the argument supply is optional. If no argument is given then data of `N-GOptionParseFunc` will be set to NULL. Since 2.8

  * G_OPTION_FLAG_NOALIAS: This flag turns off the automatic conflict resolution which prefixes long option names with `groupname-` if there is a conflict. This option should only be used in situations where aliasing is necessary to model some legacy commandline interface. It is not safe to use this option, unless all option groups are under your direct control. Since 2.8.

enum GOptionArg
---------------

The **GOptionArg** enum values determine which type of extra argument the options expect to find. If an option expects an extra argument, it can be specified in several ways; with a short option: `-x arg`, with a long option: `--name arg` or combined in a single argument: `--name=arg`.

  * G_OPTION_ARG_NONE: No extra argument. This is useful for simple flags.

  * G_OPTION_ARG_STRING: The option takes a string argument.

  * G_OPTION_ARG_INT: The option takes an integer argument.

  * G_OPTION_ARG_CALLBACK: The option provides a callback (of type **N-GOptionArgFunc**) to parse the extra argument.

  * G_OPTION_ARG_FILENAME: The option takes a filename as argument.

  * G_OPTION_ARG_STRING_ARRAY: The option takes a string argument, multiple uses of the option are collected into an array of strings.

  * G_OPTION_ARG_FILENAME_ARRAY: The option takes a filename as argument, multiple uses of the option are collected into an array of strings.

  * G_OPTION_ARG_DOUBLE: The option takes a double argument. The argument can be formatted either for the user's locale or for the "C" locale. Since 2.12

  * G_OPTION_ARG_INT64: The option takes a 64-bit integer. Like `G_OPTION_ARG_INT` but for larger numbers. The number can be in decimal base, or in hexadecimal (when prefixed with `0x`, for example, `0xffffffff`). Since 2.12

enum GOptionError
-----------------

Error codes returned by option parsing.

  * G_OPTION_ERROR_UNKNOWN_OPTION: An option was not known to the parser. This error will only be reported, if the parser hasn't been instructed to ignore unknown options, see `g_option_context_set_ignore_unknown_options()`.

  * G_OPTION_ERROR_BAD_VALUE: A value couldn't be parsed.

  * G_OPTION_ERROR_FAILED: A **N-GOptionArgFunc** callback failed.

class N-GOptionEntry
--------------------

A N-GOptionEntry struct defines a single option. To have an effect, they must be added to a **N-GOptionGroup** with `g_option_context_add_main_entries()` or `g_option_group_add_entries()`.

  * Str $.long_name: The long name of an option can be used to specify it in a commandline as `--long_name`. Every option must have a long name. To resolve conflicts if multiple option groups contain the same long name, it is also possible to specify the option as `--groupname-long_name`.

  * Int $.short_name: If an option has a short name, it can be specified `-short_name` in a commandline. *short_name* must be a printable ASCII character different from '-', or zero if the option has no short name.

  * Int $.flags: Flags from **GOptionFlags**

  * GOptionArg $.arg: The type of the option, as a **GOptionArg**

  * Pointer $.arg_data: If the *arg* type is `G_OPTION_ARG_CALLBACK`, then *arg_data* must point to a **N-GOptionArgFunc** callback function, which will be called to handle the extra argument. Otherwise, *arg_data* is a pointer to a location to store the value, the required type of the location depends on the *arg* type:

    * `G_OPTION_ARG_NONE`: `Int` ( 0 or 1 (= C type boolean) )

    * `G_OPTION_ARG_STRING`: `Str`

    * `G_OPTION_ARG_INT`: `Int`

    * `G_OPTION_ARG_FILENAME`: `Str`

    * `G_OPTION_ARG_STRING_ARRAY`: `CArray[Str]`

    * `G_OPTION_ARG_FILENAME_ARRAY`: `CArray[Str]`

    * `G_OPTION_ARG_DOUBLE`: `Num` If *arg* type is `G_OPTION_ARG_STRING` or `G_OPTION_ARG_FILENAME`, the location will contain a newly allocated string if the option was given. That string needs to be freed by the callee using `g_free()`. Likewise if *arg* type is `G_OPTION_ARG_STRING_ARRAY` or `G_OPTION_ARG_FILENAME_ARRAY`, the data should be freed using `g_strfreev()`.

  * Str $.description: the description for the option in `--help` output. The *description* is translated using the *translate_func* of the group, see `g_option_group_set_translation_domain()`.

  * Str $.arg_description: The placeholder to use for the extra argument parsed by the option in `--help` output. The *arg_description* is translated using the *translate_func* of the group, see `g_option_group_set_translation_domain()`.

Methods
=======

new
---

Create a new option context object. The string is a parameter string. See also `g_option_context_new()`.

    multi method new ( Str :pstring! )

Create an object using a native option context object from elsewhere.

    multi method new ( N-GOptionContext :$context! )

is-valid
--------

Returns True if native option context object is valid, otherwise `False`.

    method is-valid ( --> Bool )




Clear the error and return data to memory to pool. The option context object is not valid after this call and .is-valid() will return `False`.

    method clear-option-context ()

[[g_] option_] error_quark
--------------------------

    method g_option_error_quark ( --> int32  )

[[g_] option_] context_new
--------------------------

Creates a new option context.

The *parameter_string* can serve multiple purposes. It can be used to add descriptions for "rest" arguments, which are not parsed by the **N-GOptionContext**, typically something like "FILES" or "FILE1 FILE2...". If you are using **G_OPTION_REMAINING** for collecting "rest" arguments, GLib handles this automatically by using the *arg_description* of the corresponding **N-GOptionEntry** in the usage summary.

Another usage is to give a short summary of the program functionality, like " - frob the strings", which will be displayed in the same line as the usage. For a longer description of the program functionality that should be displayed as a paragraph below the usage line, use `g_option_context_set_summary()`.

Note that the *parameter_string* is translated using the function set with `g_option_context_set_translate_func()`, so it should normally be passed untranslated.

Returns: a newly created **N-GOptionContext**, which must be freed with `g_option_context_free()` after use.

Since: 2.6

    method g_option_context_new ( Str $parameter_string --> N-GOptionContext  )

  * Str $parameter_string; (nullable): a string which is displayed in the first line of `--help` output, after the usage summary `programname [OPTION...]`

[[g_] option_] context_set_summary
----------------------------------

Adds a string to be displayed in `--help` output before the list of options. This is typically a summary of the program functionality.

Note that the summary is translated (see `g_option_context_set_translate_func()` and `g_option_context_set_translation_domain()`).

Since: 2.12

    method g_option_context_set_summary ( Str $summary )

  * Str $summary; a string to be shown in `--help` output before the list of options, or `Any`.

[[g_] option_] context_get_summary
----------------------------------

Returns the summary. See `g_option_context_set_summary()`.

Returns: the summary

Since: 2.12

    method g_option_context_get_summary ( --> Str  )

[[g_] option_] context_set_description
--------------------------------------

Adds a string to be displayed in `--help` output after the list of options. This text often includes a bug reporting address.

Note that the summary is translated (see `g_option_context_set_translate_func()`).

Since: 2.12

    method g_option_context_set_description ( Str $description )

  * Str $description; (nullable): a string to be shown in `--help` output after the list of options, or `Any`

[[g_] option_] context_get_description
--------------------------------------

Returns the description. See `g_option_context_set_description()`.

Returns: the description

Since: 2.12

    method g_option_context_get_description ( --> Str  )

[[g_] option_] context_set_help_enabled
---------------------------------------

Enables or disables automatic generation of `--help` output. By default, `g_option_context_parse()` recognizes `--help`, `-h`, `-?`, `--help-all` and `--help-groupname` and creates suitable output to stdout.

Since: 2.6

    method g_option_context_set_help_enabled ( Int $help_enabled )

  * Int $help_enabled; `1` to enable `--help`, `0` to disable it

[[g_] option_] context_get_help_enabled
---------------------------------------

Returns whether automatic `--help` generation is turned on for *context*. See `g_option_context_set_help_enabled()`.

Returns: `1` if automatic help generation is turned on.

Since: 2.6

    method g_option_context_get_help_enabled ( --> Int )

[[g_] option_] context_set_ignore_unknown_options
-------------------------------------------------

Sets whether to ignore unknown options or not. If an argument is ignored, it is left in the *argv* array after parsing. By default, `g_option_context_parse()` treats unknown options as error.

This setting does not affect non-option arguments (i.e. arguments which don't start with a dash). But note that GOption cannot reliably determine whether a non-option belongs to a preceding unknown option.

Since: 2.6

    method g_option_context_set_ignore_unknown_options ( Int $ignore_unknown )

  * Int $ignore_unknown; `1` to ignore unknown options, `0` to produce an error when unknown options are met

[[g_] option_] context_get_ignore_unknown_options
-------------------------------------------------

Returns whether unknown options are ignored or not. See `g_option_context_set_ignore_unknown_options()`.

Returns: `1` if unknown options are ignored.

Since: 2.6

    method g_option_context_get_ignore_unknown_options ( N-GOptionContext $context --> Int  )

  * N-GOptionContext $context; a **N-GOptionContext**

[[g_] option_] context_set_strict_posix
---------------------------------------

Sets strict POSIX mode.

By default, this mode is disabled.

In strict POSIX mode, the first non-argument parameter encountered (eg: filename) terminates argument processing. Remaining arguments are treated as non-options and are not attempted to be parsed.

If strict POSIX mode is disabled then parsing is done in the GNU way where option arguments can be freely mixed with non-options.

As an example, consider "ls foo -l". With GNU style parsing, this will list "foo" in long mode. In strict POSIX style, this will list the files named "foo" and "-l".

It may be useful to force strict POSIX mode when creating "verb style" command line tools. For example, the "gsettings" command line tool supports the global option "--schemadir" as well as many subcommands ("get", "set", etc.) which each have their own set of arguments. Using strict POSIX mode will allow parsing the global options up to the verb name while leaving the remaining options to be parsed by the relevant subcommand (which can be determined by examining the verb name, which should be present in argv[1] after parsing).

Since: 2.44

    method g_option_context_set_strict_posix ( Int $strict_posix )

  * Int $strict_posix; the new value

[[g_] option_] context_get_strict_posix
---------------------------------------

Returns whether strict POSIX code is enabled.

See `g_option_context_set_strict_posix()` for more information.

Returns: `1` if strict POSIX is enabled, `0` otherwise.

Since: 2.44

    method g_option_context_get_strict_posix ( --> Int  )

[[g_] option_] context_add_main_entries
---------------------------------------

A convenience function which creates a main group if it doesn't exist, adds the *entries* to it and sets the translation domain.

Since: 2.6

    method g_option_context_add_main_entries (
      CArray[N-GOptionEntry] $entries, Str $translation_domain
    )

  * CArray[N-GOptionEntry] $entries; a `Any`-terminated array of **N-GOptionEntrys**

  * Str $translation_domain; (nullable): a translation domain to use for translating the `--help` output for the options in *entries* with `gettext()`, or `Any`

[[g_] option_] context_parse
----------------------------

Parses the command line arguments, recognizing options which have been added to *context*. A side-effect of calling this function is that `g_set_prgname()` will be called.

If the parsing is successful, any parsed arguments are removed from the array and *argc* and *argv* are updated accordingly. A '--' option is stripped from *argv* unless there are unparsed options before and after it, or some of the options after it start with '-'. In case of an error, *argc* and *argv* are left unmodified.

If automatic `--help` support is enabled (see `g_option_context_set_help_enabled()`), and the *argv* array contains one of the recognized help options, this function will produce help output to stdout and call `exit (0)`.

Note that function depends on the [current locale][setlocale] for automatic character set conversion of string and filename arguments.

Returns: `1` if the parsing was successful, `0` if an error occurred

Since: 2.6

    method g_option_context_parse ( Int $argc, @argv --> List )

  * Int $argc; (inout) (optional): a pointer to the number of command line arguments

  * Array $argv; (inout) (array length=argc) (optional): a pointer to the array of command line arguments

The method returns a list of;

  * Int, the modified argument count

  * Array, the modified argument values

  * a Gnome::Glib::Error if any. Check .is-valid() of this object.

[[g_] option_] context_add_group
--------------------------------

Adds a **N-GOptionGroup** to the *context*, so that parsing with *context* will recognize the options in the group. Note that this will take ownership of the *group* and thus the *group* should not be freed.

Since: 2.6

    method g_option_context_add_group ( N-GOptionGroup $group )

  * N-GOptionGroup $group; the group to add

[[g_] option_] context_set_main_group
-------------------------------------

Sets a **N-GOptionGroup** as main group of the *context*. This has the same effect as calling `g_option_context_add_group()`, the only difference is that the options in the main group are treated differently when generating `--help` output.

Since: 2.6

    method g_option_context_set_main_group ( N-GOptionGroup $group )

  * N-GOptionGroup $group; (transfer full): the group to set as main group

[[g_] option_] context_get_main_group
-------------------------------------

Returns: the main group of *context*, or `Any` if *context* doesn't have a main group. Note that group belongs to *context* and should not be modified or freed.

Since: 2.6

    method g_option_context_get_main_group ( --> N-GOptionGroup  )

[[g_] option_] group_new
------------------------

Creates a new **N-GOptionGroup**.

Returns: a newly created option group. It should be added to a **N-GOptionContext** or freed with `g_option_group_unref()`.

Since: 2.6

    method g_option_group_new (
      Str $name, Str $description, Str $help_description,
      --> N-GOptionGroup
    )

  * Str $name; the name for the option group, this is used to provide help for the options in this group with '--help-*name*'

  * Str $description; a description for this group to be shown in `--help`. This string is translated using the translation domain or translation function of the group

  * Str $help_description; a description for the '--help-*name*' option. This string is translated using the translation domain or translation function of the group #`{{ Pointer $user_data?, N-GDestroyNotify $destroy?

  * Pointer $user_data; user data that will be passed to the pre- and post-parse hooks, the error hook and to callbacks of `G_OPTION_ARG_CALLBACK` options, is optional

  * Callable $destroy; a function that will be called to free *user_data*, is optional }}

[[g_] option_] group_add_entries
--------------------------------

Adds the options specified in *entries* to *group*.

Since: 2.6

    method g_option_group_add_entries ( N-GOptionGroup $group, N-GOptionEntry $entries )

  * N-GOptionGroup $group; a **N-GOptionGroup**

  * N-GOptionEntry $entries; a `Any`-terminated array of **N-GOptionEntry**

