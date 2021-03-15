---
title: Tutorial - Application Commandline
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# Extending the Application

Our first attempt to build an application went well but to make it more useful we need to add a few things. There are more initialization flags to consider besides the one we met before; `G_APPLICATION_NON_UNIQUE`.


## Handling Command Line Arguments

In Raku we are used to have `@*ARGS` which is interpreted by subroutine `MAIN()`. The `@*ARGS` variable is important and is available globally. When calling `.run()`, the array is fed to the application with an extra argument added. In C, it is common to have the program name as its first argument in this list. To keep things te same for these libraries and prevent unpleasant surprises, that value is inserted at the first position.

The **Gnome::Gio::Application** class handles the arguments at two different locations in your program. There is a part that handles local arguments and a part that handles remote arguments. The local part is accessed using a signal `handle-local-options`. So, if you want to process arguments for which a primary is not needed, you must register a handler for this signal.

### Local Argument Processing

The `handle-local-options` handler is accessed with a native Variant dictonary holding the options registered previously using calls in the Application class. Here, I've taken a design decision to not support the argument processing of Gio and friends. The reason for this is that the Variant structures are quite combersome to read and modify. Indispensable for the C-programmer but in Raku however, we have `@*ARGS` 😄. Using one of the freely available modules one can peel off and select the options you need.

The handler must also return an integer which will determine the next step of the application. Values of 0 and higher are taken as exit values with 0 mostly as successfull and > 0 some kind of failure. This value becomes the return value of the `.run()` method.
When -1 is returned, it is taken as a sign to continue and not to return to the commandline.

So adding the following will give us a way to process arguments. I've taken the freedom to choose the **Getopt::Long** module of Leon Timmermans to process the arguments.

```
use Getopt::Long;                                                   # ①
use Gnome::Glib::N-GVariantDict;
…
unit class UserAppClass is Gnome::Gtk3::Application;
…
submethod BUILD ( ) {
  …
  self.register-signal( self, 'local-options', 'handle-local-options');
                                                                    # ②
  …
}
…
method local-options (
  N-GVariantDict $n-vd, UserAppClass :_widget($app) --> Int         # ③
) {
  my Int $exit-code = -1;                                           # ④

  CATCH { default { .message.note; $exit-code = 1; return $exit-code; }
                                                                    # ⑤
  my $o = get-options('version');                                   # ⑥
  if $o<version> {
    say "Version of UserAppClass is 0.2.0";
    $exit-code = 0;
  }

  $exit-code
}
```
① We need **Getopt::Long** and **Gnome::Glib::N-GVariantDict**. The N-GVariantDict class is only used to define the handler interface.

② Register the handler for the `handle-local-options` signal.

③ Positional arguments must always be defined when declaring a handler method. It is necessary because of the way the registration of signals works. The named arguments like `:_widget` and the users provided options may always be left out if not used in the method.

④ Specify the exit code such that the application continues. Change it when an error occurs or when the task is done.

⑤ When there are unrecognized arguments and options, the `get-options()` routine will blow up in your face. Define a CATCH to prevent a stack dump and show the message only.

⑥ Process an option. It is a boolean variable `version` which, when found, the application will show a version and then decides to return a success value after which the application will stop.

When no arguments are given, the program continues and shows a window. Each invocation without arguments adds a new window. You might introduce a boolean variable which is set after building the GUI. A second attempt to build can be prevented after checking this value.

Lets try it;
```
# raku sceleton-application-v2.raku --version
Unknown option --version
```
*What!!!!* I wanted to see a version! Not an error! 😦. It has something to do with my design decision to not support the argument processing of Gio. It seems that we must do more to get rid of the automatic checking of the Application.


### Remote Argument Processing

To get this to work we must turn on another signal and we must also add an initialization flag to our `.new()` method. Below is the total of added code.

```
use Getopt::Long;
use Gnome::Glib::N-GVariantDict;

use Gnome::N::N-GObject;                                            # ①

use Gnome::Gio::Enums;
use Gnome::Gio::ApplicationCommandLine;
…
unit class UserAppClass is Gnome::Gtk3::Application;
…
submethod new ( |c ) {
  self.bless(
    :GtkApplication, :app-id(APP-ID),
    :flags(G_APPLICATION_HANDLES_COMMAND_LINE)                      # ②
    |c
  );
}
…
submethod BUILD ( ) {
  …
  self.register-signal( self, 'local-options', 'handle-local-options');
  self.register-signal( self, 'remote-options', 'command-line');    # ③
  …
}
…
method local-options (
  N-GVariantDict $n-vd, UserAppClass :_widget($app) --> Int
) {
  my Int $exit-code = -1;

  CATCH { default { .message.note; $exit-code = 1; return $exit-code; }
  my $o = get-options( 'version', 'show:s');
  if $o<version> {
    say "Version of UserAppClass is 0.2.0";
    $exit-code = 0;
  }

  $exit-code
}

method remote-options (                                             # ④
  N-GObject $n-cl, UserAppClass :_widget($app) --> Int
) {
  my Int $exit-code = 0;

  my Gnome::Gio::ApplicationCommandLine $cl .= new(                 # ⑤
    :native-object($n-cl)
  );

  my Array $args = $cl.get-arguments;                               # ⑥
  my Capture $o = get-options-from( $args[1..*-1], 'version', 'show:s');
                                                                    # ⑦
  my Str $file-to-show = $o.<show>
    if ($o.<show> // '') and $o.<show>.IO.r;

  self.activate unless $cl.get-is-remote;                           # ⑧

  if ?$file-to-show {
    $cl.print("Show text from $file-to-show\n");
    … show file in window …
  }

  $cl.clear-object;                                                 # ⑨

  $exit-code
}
```
① Again more modules are needed to get the `N-GObject` type, the initialization flag and the commandline class.

② We need the `G_APPLICATION_HANDLES_COMMAND_LINE` to process the commandline arguments remotely.

③ For this to work we must also register a handler for the `command-line` signal.

④ The method `.remote-options()` is called after returning -1 (=continue) from the `.local-options()` method.

⑤ The commandline object `$cl` is initialized with the provided native object `$n-cl`.

⑥ The arguments returned from the call are exactly the same as stored while starting the `.run()` method in the beginning. Because the argument management is not supported, it is also not adjusted by the necessary calls in `.local-options()`.

⑦ Process the options. We must test for the same set as is done in the `.local-options()` to prevent 'option not recognized' errors. Another important thing is that when the tested option set is the same, we do not need a `CATCH {}` to catch unrecognized option errors.

⑧ Now we get the chance to differentiate between actions needed to do by a primary instance by looking if the arguments are coming from the primary or from the secondary instance. If from a primary, this means that there is not yet a window created and thus we call the applications `.activate()` method. It is worth noting that, now the application requested to handle command line arguments, the `activate` signal will not be fired automatically. This is because the primary must also be able to return to the command line in case of troubles.

⑨ One last important step is to destroy the commandline object. Otherwise, when it is kept around, the secondary process will be kept alive by not returning from the call to `.run()`. This is done because the object may be kept around to defer some of the tests for later.

When we test it now, we get far better results. First the --version option which returns immediately;
```
# raku sceleton-application-v3.raku --show some-file.txt
Version of UserAppClass is 0.2.0
```
And assuming that some-file.txt exists, the --show option;
```
# raku sceleton-application-v3.raku --show some-file.txt
Info:
  Registered: True
  app id: io.github.martimm.tutorial
Show text from some-file.txt
```
Also a window is made and primary stays alive. You might repeat this while the primary still runs and see what happens, anyways, no second windows anymore.

Unknown uptions are now returning mentioning a failure
```
# raku sceleton-application-v3.raku --help
Unknown option help
```

There are still some problems left but we can ignore them now for the moment.
