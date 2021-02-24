---
title: Tutorial - Getting Started
nav_menu: default-nav
sidebar_menu: tutorial-sidebar
layout: sidebar
---
# The Application classes

## A Sceleton Application

The basic class we need is the **Gnome::Gio::Application** class. Fortunately, Gnome has made a **Gnome::Gtk3::Application** class which inherits directly from the Application defined in Gio. The second class we need is a kind of toplevel window. This class will be **Gnome::Gtk3::ApplicationWindow**. This is now the class where you build your GUI into instead of **Gnome::Gtk3::Window**.

|Basic setup of an application  |
|-------------------------------|
|![diagram](images/sceleton.svg)|


The **UserAppClass** is a class which can handle all of the generated signals produced by the several initialization stages.

We can make it a bit more flexible;


|Slightly extended version          |
|-----------------------------------|
|![diagram](images/sceleton-alt.svg)|

Here the **UserWindowClass** is used to separate the GUI buildup from the communication between the main Application and external events.

The rest of the tutorial will follow the first diagram.

## The UserApplication

In Raku, it is important that the main program is kept small. This is because all code, program and modules are parsed and compiled into an intermediate code which will be executed by a virtual machine. Most of the time that will be MoarVM but there is also a JVM and later possibly others. Anyways, before running, the compiled modules are saved into .precomp directories but not the program. This means that the program always get parsed and compiled before running and that is the reason to keep it small.

```
use v6;

use UserAppClass;

my UserAppClass $user-app .= new;                                     # ①
exit($user-app.run);                                                  # ②
```

① Your UserAppClass inherits from the Application class, so you may decide to have some options for it in this call to `.new()` instead of having everything specified in the UserAppClass. For example you could specify the application id here as well as some initialization flags conrolling some behaviour of the application.

② Then when all is ready, call `.run()` to start the application. When finished, it returns an exit code where you may finish your program with. The options and arguments to the application provided on the commandline are processed in the call to `.run()`.

Well, you can't get smaller than this …, or maybe this one-liner; `exit(UserAppClass.new.run)`.

The rest of the code is defined in the **UserAppClass**.


## The UserAppClass

The class is a bit larger than this if it has to do something.

```
use v6.d;

use NativeCall;

use Gnome::Gtk3::Application;
use Gnome::Gtk3::ApplicationWindow;


unit class UserAppClass is Gnome::Gtk3::Application;

constant APP-ID = 'io.github.martimm.tutorial.sceleton';              # ①
has Gnome::Gtk3::ApplicationWindow $!app-window;


submethod new ( |c ) {
  self.bless( :GtkApplication, :app-id(APP-ID), |c);                  # ②
}

submethod BUILD ( ) {

  self.register-signal( self, 'app-startup', 'startup');              # ③
  self.register-signal( self, 'app-activate', 'activate');
  self.register-signal( self, 'app-shutdown', 'shutdown');

  my Gnome::Glib::Error $e = self.register;                           # ④
  die $e.message if $e.is-valid;
}

method app-startup ( Gnome::Gtk3::Application :widget($app) ) {       # ⑤
  …
}

method app-activate ( Gnome::Gtk3::Application :widget($app) ) {      # ⑥

  given $!app-window .= new(:application(self)) {
    .set-size-request( 400, 200);
    .set-title('Application Window Test');
    .set-border-width(20);
    .register-signal( self, 'exit-program', 'destroy');
    .show-all;
  }

  note "\nInfo:\n  Registered: ", self.get-is-registered;
  note '  app id: ', self.get-application-id;
}

method exit-program ( --> Int ) {
  self.quit;

  1
}

method app-shutdown ( Gnome::Gtk3::Application :widget($app) ) {      # ⑦
  …
}
```

① The application id is defined as a constant here because it will not change for the life of the application. There is a [nice document](https://developer.gnome.org/ChooseApplicationID/) about how to specify such a string. In short, it represents a "reversed DNS" style. The next list shows where it is used for (taken from that page);

* by **Gnome::Gio::Application** as a method of identifying your application to the system, for ensuring that only one instance of your application is running at a given time, and as a way of passing messages to your application (such as an instruction to open a file)

* by D-Bus, to name your application on the message bus. This is the primary means of communicating between applications and is visible via the gdbus commandline tool or the d-feet graphical D-Bus browser.

* as the name of the ".desktop file" for your application. This file is how you describe your application to the system (so that it can be displayed in and launched by gnome-shell).

* as the base name of any GSettings schemas that your application may install. These names are visible via the gsettings commandline tool or the dconf-editor graphical editor.

* as a way for the system to remember state information about your applications (for example, which notifications it has requested to be shown to the user) and as a way for it to control settings about your application (for example, if its notifications have been blocked by the user)

* as a way for the system to use your application to extend itself (for example, by way of search providers)

* as the bundle name for application bundles


② The application id is applied to the initialization of the Applications native object.

③ To control several phases of the initialization, a few signal handlers need to be set up;
* `startup`: sets up the application when it first starts. It is fired right after the call to `.register()`.
* `activate`: shows the default first window of the application. This corresponds to the application being launched by the desktop environment.
* `shutdown`: performs shutdown tasks after the main loop is exited.

④ Then, the application registers itself.

⑤

⑥

⑦
