debug
-----

There are many situations when exceptions are retrown within code of a callback method, Perl6 is sometimes not able to display the error properly. In those cases you need another way to display errors and show extra messages leading up to it. For instance turn debugging on.

    sub Gnome::N::debug ( Bool :$on, Bool :$off )

  * :on; turn debugging on

  * :!on; turn debugging off

  * :off; turn debugging off

  * :!off; turn debugging on

When both arguments are used, :on has preverence over :off. When no arguments are provided, the debugging is turned off.

The state is saved in `$Gnome::N::x-debug` and can be accessed directly to get its state.
