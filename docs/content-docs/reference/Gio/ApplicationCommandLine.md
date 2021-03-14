Gnome::Gio::ApplicationCommandLine
==================================

A command-line invocation of an application

Description
===========

**Gnome::Gio::ApplicationCommandLine** represents a command-line invocation of an application. It is created by **Gnome::Gio::Application** and emitted in the *command-line* signal and virtual function.

The class contains the list of arguments that the program was invoked with. It is also possible to query if the commandline invocation was local (ie: the current process is running in direct response to the invocation) or remote (ie: some other process forwarded the commandline to this process).

The **Gnome::Gio::ApplicationCommandLine** object can provide the *argc* and *argv* parameters for use with the **Gnome::Gio::OptionContext** command-line parsing API, with the `get-arguments()` function. See [gapplication-example-cmdline3.c][gapplication-example-cmdline3] for an example.

The exit status of the originally-invoked process may be set and messages can be printed to stdout or stderr of that process. The lifecycle of the originally-invoked process is tied to the lifecycle of this object (ie: the process exits when the last reference is dropped).

The main use for **Gnome::Gio::ApplicationCommandLine** (and the *command-line* signal) is 'Emacs server' like use cases: You can set the `EDITOR` environment variable to have e.g. git use your favourite editor to edit commit messages, and if you already have an instance of the editor running, the editing will happen in the running instance, instead of opening a new one. An important aspect of this use case is that the process that gets started by git does not return until the editing is done.

Normally, the commandline is completely handled in the *command-line* handler. The launching instance exits once the signal handler in the primary instance has returned, and the return value of the signal handler becomes the exit status of the launching instance.

See Also
--------

**Gnome::Gio::Application**

Synopsis
========

Declaration
-----------

    unit class Gnome::Gio::ApplicationCommandLine;
    also is Gnome::Gobject::Object;

Methods
=======

new
---

### :native-object

Create a ApplicationCommandLine object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

get-arguments
-------------

Gets the list of arguments that was passed on the command line.

The strings in the array may contain non-UTF-8 data on UNIX (such as filenames or arguments given in the system locale) but are always in UTF-8 on Windows.

Returns: an array of strings containing the arguments

    method get-arguments ( --> Array[Str] )

get-cwd
-------

Gets the working directory of the command line invocation. The string may contain non-utf8 data.

It is possible that the remote application did not send a working directory, so this may be `undefined`.

The return value should not be modified or freed and is valid for as long as *cmdline* exists.

Returns: the current directory, or `undefined`

    method get-cwd ( --> Str )

get-environ
-----------

Gets the contents of the 'environ' variable of the command line invocation, as would be returned by `g-get-environ()`, ie as a `undefined`-terminated list of strings in the form 'NAME=VALUE'. The strings may contain non-utf8 data.

The remote application usually does not send an environment. Use `G-APPLICATION-SEND-ENVIRONMENT` to affect that. Even with this flag set it is possible that the environment is still not available (due to invocation messages from other applications).

The return value should not be modified or freed and is valid for as long as *cmdline* exists.

See `getenv()` if you are only interested in the value of a single environment variable.

Returns: the environment strings, or `undefined` if they were not sent

    method get-environ ( --> CArray[Str] )

get-exit-status
---------------

Gets the exit status of *cmdline*. See `set-exit-status()` for more information.

Returns: the exit status

    method get-exit-status ( --> Int )

get-is-remote
-------------

Determines if *cmdline* represents a remote invocation.

Returns: `True` if the invocation was remote

    method get-is-remote ( --> Bool )

print
-----

Prints message using the stdout print handler in the invoking process.

    method print ( Str $message )

  * Str $message; a message string

printerr
--------

Formats a message and prints it using the stderr print handler in the invoking process.

    method printerr ( Str $message )

  * Str $message; a message string

set-exit-status
---------------

Sets the exit status that will be used when the invoking process exits.

The return value of the *command-line* signal is passed to this function when the handler returns. This is the usual way of setting the exit status.

In the event that you want the remote invocation to continue running and want to decide on the exit status in the future, you can use this call. For the case of a remote invocation, the remote process will typically exit when the last reference is dropped on *cmdline*. The exit status of the remote process will be equal to the last value that was set with this function.

In the case that the commandline invocation is local, the situation is slightly more complicated. If the commandline invocation results in the mainloop running (ie: because the use-count of the application increased to a non-zero value) then the application is considered to have been 'successful' in a certain sense, and the exit status is always zero. If the application use count is zero, though, the exit status of the local **Gnome::Gio::ApplicationCommandLine** is used.

    method set-exit-status ( Int $exit_status )

  * Int $exit_status; the exit status

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **.set-text('my text label')**.

    my Gnome::Gtk3::Label $label .= new;
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.get-property( 'label', $gv);
    $gv.set-string('my text label');

Supported properties
--------------------

### Commandline arguments: arguments

The **Gnome::GObject::Value** type of property *arguments* is `G_TYPE_VARIANT`.

### Is remote: is-remote

TRUE if this is a remote commandline Default value: False

The **Gnome::GObject::Value** type of property *is-remote* is `G_TYPE_BOOLEAN`.

### Options: options

The **Gnome::GObject::Value** type of property *options* is `G_TYPE_VARIANT`.

### Platform data: platform-data

The **Gnome::GObject::Value** type of property *platform-data* is `G_TYPE_VARIANT`.

