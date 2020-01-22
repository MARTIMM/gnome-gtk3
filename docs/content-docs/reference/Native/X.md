Gnome::N::debug
---------------

There are many situations when exceptions are retrown within code of a callback method, Raku is sometimes not able to display the error properly. In those cases you need another way to display errors and show extra messages leading up to it. For instance turn debugging on.

    sub Gnome::N::debug ( Bool :$on, Bool :$off )

  * :on; turn debugging on

  * :!on; turn debugging off

  * :off; turn debugging off

  * :!off; turn debugging on

When both arguments are used, :on has preverence over :off. When no arguments are provided, the debugging is turned off.

The state is saved in `$Gnome::N::x-debug` and can be accessed directly to get its state.

Gnome::N::deprecate
-------------------

Set a deprecation message when the trait DEPRECATED on classes and methods is not sufficient enaugh. Like those, a message is generated when the X module ends, i.e. when your application exits (hopefully ;-).

    sub Gnome::N::deprecate (
      Str $old-method, Str $new-method,
      Str $since-version, Str $remove-version
    )

  * $old-method; Method as it was used.

  * $new-method; New method or way to use.

  * $since-version; When it was deprecated. Version is from package wherein the module/class and method is defined.

  * $remove-version; Version of package when the method will be removed.

