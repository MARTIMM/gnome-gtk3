---
title: About Gtk3 Release Notes
nav_menu: default-nav
sidebar_menu: about-sidebar
layout: sidebar
---
# Release notes
* 2022-11-14 0.48.13
  * Added method `child-get-property()` in **Gnome::Gtk3::Container** to get child properties of widgets added to the container.
  * Checked **Gnome::Gtk3::Fixed**. Added two child properties. Check other modules for child properties; **Gnome::Gtk3::Box** has 5.
  * Checked **Gnome::Gtk3::Frame**.


* 2022-10-23 0.48.12
  * Checked **Gnome::Gtk3::FileFilter**.

* 2022-10-10 0.48.11
  * Bugfix in **Gnome::Gtk3::FileChooserWidget**. Also cleanup of pod doc.
  * File extensions renamed.

* 2022-08-31 0.48.10
  * Revisited modules **Gnome::Gtk3::EntryCompletion**, **Gnome::Gtk3::EventBox**, **Gnome::Gtk3::FileChooser**, **Gnome::Gtk3::FileChooserButton**.

* 2022-08-28 0.48.9
  * Revisited module **Gnome::Gtk3::Entry**.

* 2022-07-26 0.48.8
  * Changed **Gnome::Gtk3::ListBox**
  * Removed dependencies on :_widget in test files

* 2022-07-15 0.48.7
  * Revisited modules from the Gnome::Glib distribution. Quite a few bugs are removed from **Gnome::Glib::Error**, many method return types are changed to native types instead of the Raku classes conform the latest ideas. Again very unfortunate that for these I cannot install deprecation code because the dispatch of multi methods are not looking at return types.
    An example from the **Gnome::Glib::List** module;
    ```
    # next line
    my Gnome::Glib::List $l .= new(:native-object($my-grid.get-children));

    # or like this

    my Gnome::Glib::List $l = $w.get-children-rk;

    would become

    my Gnome::Glib::List() $l = $w.get-children;
    ```

    Also the methods in that List module are modified, so the use of e.g. `append()` would become;
    ```
    my Gnome::Glib::List() $integer-list;         # note the '()' !!
    my $int-pointer = CArray[gint].new;
    $int-pointer[0] = 42;
    $integer-list .= append(nativecast( gpointer, $int-pointer));
    $int-pointer[0] = 43;
    $integer-list .= append(nativecast( gpointer, $int-pointer));
    ```

  * Changed **Gnome::Gtk3::Container**. Missed a few `…-rk()` deprecations.

  * **NOTE 1: All these changes regarding the `…-rk()` can be changed before the deprecation messages are installed. This will save you for some irritating changes occurring later on when I am able to change the methods.**

  * **NOTE 2: What came to mind is the use of `:$_widget` in event callbacks. This can easily be replaced by `:$_native_object` (already defined). The latter is always defined while the first might be destroyed by the user to free memory.**
    An example to show the use of `:$_native_object` with the `add` signal callback handler from **Gnome::Gtk3::Container**. The handler is defined as;
    ```
    method handler (
      N-GObject $n-widget,
      Gnome::Gtk3::Container :_widget($container),
      Int :$_handler-id,
      N-GObject :$_native-object,
      *%user-options
    )
    ```
    This could be implemented as
    ```
    method add-event (
      N-GObject $added-widget,
      Gnome::Gtk3::Container() :_native-object($container)
    ) { … }
    ```
    From this, it follows that the named argument `:$_widget` is not useful anymore. Therefore, this named argument is deprecated too.

  * Changed docs here and there to remove old uses of deprecated arguments and methods in example code.
  * Added `COERCE()` routine in **Gnome::Gtk3::TreeIter** to coerce from `N-GObject` to `N-GtkTreeIter`. Also done in **Gnome::Glib::Error**.
  * Method

* 2022-07-16 0.48.6
  * Revisited the **Gnome::Gtk3::Dialog** module. all `…-rk()` are obsoleted. E.g. use `my Gnome::Gtk3::Box() $content-area = $dialog.get-content-area;` instead of `my Gnome::Gtk3::Box $content-area = $dialog.get-content-area-rk;` or `my Gnome::Gtk3::Box $content-area .= new(:native-object($dialog.get-content-area));`
  * Revisited the **Gnome::Gtk3::Editable** module.

* 2022-07-2 0.48.5
  * New module **Gnome::Gtk3::Expander**.

* 2022-06-12 0.48.4
  * Changed docs.
  * Missing docs for **Gnome::Gtk3::DragDest** and **Gnome::Gtk3::DragSource**.
  * Previously, the method `find-target()` from **Gnome::Gtk3::DragDest** returned a **Gnome::Gdk3::Atom**. To be in line with latest ideas about coercing, the routine now returns a native object. To cope with the change, write the following instead, for example;
    ```
    my Gnome::Gdk3::Atom() $target-atom = $!destination.find-target(…);
    ```
    Note the `()` tacked on the **Gnome::Gdk3::Atom** type! Sorry that I cannot give a deprecation warning because of multis not looking for return types. (lucky that the module docs weren't generated yet 😃😃😃😃).
    Unfortunately, this will happen once in a while when things evolve. You may recognize those functions returning Gnome::* objects and prepare for the change just by tacking those brackets on the type like shown in the example above.
  * Added a module **Gnome::Gtk3::Drag** with methods from DragSource and DragDest. This is more inline with the C-files and the routines defined there.
    * Methods from DragDest; finish, get-data, get-source-widget, highlight and unhighlight.
    * Methods from DragSource; cancel
  * Site doc changes

* 2022-05-13 0.48.3
  * More modules converted and more routines deprecated.

* 2022-04-06 0.48.2
  * More modules converted and more routines deprecated.

* 2022-03-19 0.48.1
  * Removed the named argument `:$widget` to event handlers. Now only `:$_widget` is available together with `:$_handler-id` and `:$_native-object`.

* 2022-03-19 0.48.0
  * Add modules **Gnome::Gtk3::ShortcutsWindow**, **Gnome::Gtk3::ShortcutsSection**, **Gnome::Gtk3::ShortcutsGroup**, **Gnome::Gtk3::ShortcutsShortcut**.
  * More modules converted and more routines deprecated.
  * Bugfix in **Gnome::Gtk3::Application** method `get-actions-for-accel()` and `get-accels-for-action()`. In some cases, native routines return `CArray[Str]` while the newer methods return `Array`. This can produce errors like `Don't know how many elements a C array returned from a library` if you want the number of elements to traverse the array. The methods, which return an `Array` do not pose this problem.

* 2022-03-13 0.47.4
  * Structure `GdkRGBA` from **Gnome::Gdk3::RGBA** is renamed into `N-GdkRGBA`. Unfortunately, it was not possible to set deprecation messages first because of the large overhead of extra software coping with coercion. Also `N-GdkRGBA` structure will be used internally only and casted to `N-GObject` before returning to the user.
    This is going to happen to all native pointers and structures and the meaning of `N-GObject` is changed. In the past the purpose of that structure was _a native object wrapped into **Gnome::GObject::Object** and used by its descendents_ to _a common native object for all classes_. We can see the name therefore as _a Native Gnome Object_.

  * **Gnome::Gtk3::ColorChooserDialog** changed documentation and tests.
  * A few other modules using **Gnome::Gdk3::RGBA** needed small changes.

* 2022-02-04 0.47.3
  * New tests show that the `-rk()` methods are not needed anymore. Code is added to **Gnome::N::TopLevelClassSupport** to coerce to and from a native object stored in a N-GObject type object. This operation will take several versions to get it all out again 😦.

  ```
  my Gnome::Gtk3::Window $w .= new;
  my N-GObject() $no = $w;        # to get the native object
  $no = $w.N-GObject;             # or

  # instead of
  $no = $w.get-native-object;

  # and from native to Raku object
  my Gnome::Gtk3::Window() $w2 = $no;

  # instead of
  my Gnome::Gtk3::Window $w2 .= new(:native-object($no));
  ```
  So all `-rk()` methods will be deprecated and removed after some version. This means that the code base will become smaller and perhaps faster to compile.

  * `GdkGeometry` structure from Gnome::Gdk3 is renamed to `N-GdkGeometry`.

  * `GdkWindowAttr` structure from Gnome::Gdk3 is renamed to `N-GdkWindowAttr`.

* 2022-02-04 0.47.2
  * **Gnome::Gtk3::Window** had errors in that it used the wrong name for a `N-GdkEventKey` structure and should have thrown compiler errors after changing **Gnome::Gdk3::Events** module.
  * Bugfix caused by newer Raku; native type and Raku type for unsigned integers are treated differently.

* 2022-02-02 0.47.1
  * Add `do-event()` to **Gnome::Gtk3::Main**.

* 2022-01-27 0.47.0
  * Add **Gnome::Gtk3::CssSection**. I don't think there is much use for it, no examples found anywhere... Maybe later.

* 2022-01-26 0.46.4
  * Documentation changes; **Gnome::Gtk3::CssProvider**.

* 2021-12-29 0.46.5
  * Documentation changes from **Gnome::Cairo** package.
  * Tutorial for using cairo.
  * Bugfixes in **Gnome::Gtk3::StyleContext**.

* 2021-12-12 0.46.4
  * Changes for renamed methods in **Gnome::N::TopLevelClassSupport**.

* 2021-12-08 0.46.3
  * Add methods `.get-objects()` and `.expose-object()` to Builder module.
  * Inhibit start of eventloop if **Gnome::T** is active.

* 2021-12-05 0.46.2
  * Doc and test update of modules **Gnome::Gtk3::RadioButton**, **Gnome::Gtk3::ColorButton**, and **Gnome::Gtk3::ToggleButton**.

* 2021-11-28 0.46.1
  * Doc and tutorial updates

* 2021-11-10 0.46.0:
  * Add **Gnome::Gtk3::AccelGroup**, **Gnome::Gtk3::AccelMap**, **Gnome::Gtk3::AccelLabel**.

* 2021-10-27 0.45.0:
  * Add **Gnome::Gtk3::AppChooser**, **Gnome::Gtk3::AppChooserButton**, **Gnome::Gtk3::AppChooserDialog**, **Gnome::Gtk3::AppChooserWidget**.

* 2021-10-11 0.44.3:
  * Rewrite pod doc and method ordering of **Gnome::Gtk3::Assistant**, **Gnome::Gtk3::Bin**, **Gnome::Gtk3::Border**, **Gnome::Gtk3::Box**, **Gnome::Gtk3::Builder**, **Gnome::Gtk3::Button**. Also added methods returning Raku objects.

* 2021-09-26 0.44.2:
  * Rewite pod doc and method ordering of **Gnome::Gtk3::Dialog** **Gnome::Gtk3::Application** and **Gnome::Gtk3::ApplicationWindow**. Also added methods returning Raku objects next to the original methods returning native objects.
  * Bugfix in **Gnome::Gtk3::ComboBoxText**. Method `new()` did not recognize the `:native-object` option.

* 2021-09-24 0.44.1:
  * Methods ending in `…-rk()` have `:child-type` added where it is possible to inherit from the returned object type.

* 2021-07-20 0.44.0:
  * Add modules **Gnome::Gtk3::Layout**, **Gnome::Gtk3::ActionBar** and **Gnome::Gtk3::HeaderBar**.

* 2021-07-11 0.43.1:
  * Typos and code changes in tutorials and example code.
  * Due to some changes in **Gnome::GObject::Value**, the `.get-boolean()` method returns `True` or `False` instead of `1` or `0`. `.set-boolean()` is unchanged because Raku could coerse `True` and `False` to integer automatically.

* 2021-07-08 0.43.0:
  * Add module **Gnome::Gtk3::OffscreenWindow**.

* 2021-06-29 0.42.0:
  * Add module **Gnome::Gtk3::ButtonBox**, **Gnome::Gtk3::Scrollable** and **Gnome::Gtk3::Viewport**.
  * **Gnome::Gtk3::Scrollable** role is added to the already existing modules **Gnome::Gtk3::IconView**, **Gnome::Gtk3::TreeView** and **Gnome::Gtk3::TextView**.

* 2021-06-22 0.41.1:
  * bugfix; removed a sub by accident.

* 2021-06-20 0.41.0:
  * Add module **Gnome::Gtk3::FileChooserWidget**.
  * Bugfixes in **Gnome::Gtk3::FileFilter**. Defined wrong type for **GtkFileFilterInfo**. Changed to **N-GtkFileFilterInfo**.
  * Improved doc and tests of **Gnome::Gtk3::Statusbar**, **Gnome::Gtk3::DrawinfArea**, **Gnome::Gtk3::StyleContext**, **Gnome::Gtk3::Image** and , **Gnome::Gtk3::Label**.

* 2021-06-15 0.40.1:
  * Module **Gnome::Gtk3::Statusbar** docs are improved, methods are added and more tests done.
  * Drag and drop tutorial finished.

* 2021-06-14 0.40.0:
  * Added support for drag and drop. Modules added;
  * Gnome::Gdk3: Atom and DragContext
  * Gnome::Gtk3: Targets, TargetList, TargetEntry, SelectionData, DragDest and DragSource.
  * Bugfixes; in Widget, a lot of signals were in wrong categories. Discovered after using drag and drop. At the same time, docs about signals are improved for this module.

* 2021-05-08 0.39.4:
  * Modules **Gnome::Gtk3::Adjustment** and **Gnome::Gtk3::Notebook** docs are improved, methods are added and more tests done.

* 2021-04-29 0.39.3:
  * Some test failures. The tests are adjusted.
  * Bugfixes in **Gnome::Glib::List**. Objects were not initialized properly and therefore could not be tested for its validity.

* 2021-04-29 0.39.2:
  * Improve docs of Grid, Container and Fixed. Added some tests for Container.
  * Container; add a method `get-child-at-rk()` to return a raku object. `get-child-at()` returns a native object.
  * Now that it is possible to return raku widget objects I've started experimenting with callbacks too. Normally they will always get native objects which need to be imported into a raku object to be able to call any methods. In the **Gnome::Gtk3::Container** module there is this `foreach()` method which in turn calls a callback routine for each widget in its container. The widget in the argument is provided as a **N-GObject**. The experiment now is as follows; providing a callback method will as normal get a native object except when the name of the callback ends in `-rk`. In that case it returns a raku widget object. The next test taken from `t/Container.t` shows the differences.
  ```
  class X {
    method cb ( N-GObject $no, :$label ) {
      my Gnome::Gtk3::Widget $w .= new(:native-object($no));
      is $w.get-name(), 'GtkLabel', '.foreach(): callback()';
      my Gnome::Gtk3::Label $l .= new(:native-object($no));
      is $l.get-text, $label, 'label text';
    }

    # In this case we only expect a Label!
    method cb-rk ( Gnome::Gtk3::Label $rk, :$label ) {
      is $rk.get-name, 'GtkLabel', '.foreach(): callback-rk()';
      is $rk.get-text, $label, 'label text';
    }
  }

  # The button has a Bin and a Container as its parent and grandparent.
  # The label is a widget contained in the button.
  my Gnome::Gtk3::Button $b $b .= new(:label<some-text>);
  $b.foreach( X.new, 'cb', :label<some-text>);
  $b.foreach( X.new, 'cb-rk', :label<some-text>);
  ```
  This is maybe a nice solution and in line with the remarks in previous entries about methods with the `-rk` extentions. Another experiment is by using a named argument `:give-raku-objects`. This might prove a better solution because this argument is also given to the callback method. The callback routine just checks for its truthiness to decide what object it has got. The caller can than also turn the flag to `False` if it is not able to create a raku object.
  * Bugfixes in **Gnome::Gtk3::Widget**; The `delete-event` signal was wrongly defined.

* 2021-04-25 0.39.1:
  * It hounts me at night that I break code `sigh…` :sleeping:. Even that I am allowed to do it (version < 1.0.0) I have slept restles. So, might have to make a change so that code will not break. The following will be done to remedy my sleepless nights :smile:
  * Methods returning native objects are kept as it is, i.e. no `-no` added to the method name.
  * Methods returning raku objects get the `-rk` added to the method name.
  * In newly generated modules, raku objects are returned when possible. Otherwise native objects.
    These methods will not have the `-rk` extension on the method name because there is no history. And also because several are already created some time ago, it would break that code if I change that :bomb:. I might deprecate that later and become more consequent in all modules and add the `-rk` methods first.
    If the method is made returning a native object and later on I might find a way to create and return a raku object, the newer method will get the `-rk` added the the method name.
  * Changed the following modules for the above remarks;
  * **Gnome::Gdk3::Screen**
  * **Gnome::Gdk3::Visual**
  * **Gnome::Gtk3::Widget**

  This means for the previous mentioned methods
  `.get-display-rk(… --> Gnome::Gdk3::Display)`
  `.get-display(… --> N-GObject)`

* 2021-04-15 0.39.0:
  * Improve **Gnome::Gtk3::Widget** docs and tests. Changes are
  * `.get-display(… --> Gnome::Gdk3::Display)`.
  * `.get-path(… --> Gnome::Gtk3::WidgetPath)`.
  * Improved **Gnome::Gdk3::Screen** because of some bugfix. I am experimenting with an extra method when originally a native object was returned but the new method now returns a raku object. To support the older method I have added methods like `.xyz-no( … --> N-GObject)` next to `.xyz( … --> Gnome::Gxyz::Xyz)`. Changes are;
  * `.get-display ( --> Gnome::Gdk3::Display )`.
  * `.get-rgba-visual ( --> Gnome::Gdk3::Visual )`.
  * `.get-root-window ( --> Gnome::Gdk3::Window )`.
  * `.get-system-visual ( --> Gnome::Gdk3::Visual )`.

  With the above remark there is e.g. `.get-display-no( --> N-GObject )` too.
  * Added  **Gnome::Gdk3::Visual** to support a method in **Gnome::Gdk3::Screen**
  * New experiment which I did already before the rather difficult way. Suppose I've a method with a `Num` typed argument `$x`. I used to get the variable in untyped and then converted it using `$x.Num`. This helps the user to provide the number as `0.4`, `4e-1`, `⅖` and `'0.4'`. After so many years it finally  dawned to me that writing the argument type as `Num()` just does that. I have seen it in numerous examples but didn't knew the meaning of it.
  * Another experiment is to use `require ::($type)` a bit more. It solves a few problems I have been facing;
  * Circular dependencies. This happens when one type can produce another type while that second type can in turn produce the first one. This happens for example between classes **Gnome::Gdk3::Screen** and **Gnome::Gdk3::Visual**
  * Many methods are not always needed and a module needed to create an object would be loaded unnecessarely. The call will postpone the loading until needed.

  With all this, there is still a rakudo bug issue [#3075](https://github.com/rakudo/rakudo/issues/3075) unsolved. It states that sometimes the loading of symbols while using `require` goes wrong sometimes. Related issues are [#3722](https://github.com/rakudo/rakudo/issues/3722). So, when you run into such a problem, you can then use the `xyz-no( … --> N-GObject)` type of routine which will not use the `require` call and you can create the object using `my Gnome::Xyz::Abc $abc .= new(:native-object(xyz-no(…))`

  * New module **Gnome::Gtk3::EventBox**.

* 2021-04-05 0.38.0:
  * Add role **Gnome::Gtk3::CellLayout**. Added this role to **Gnome::Gtk3::ComboBox**, **Gnome::Gtk3::IconView** and, **Gnome::Gtk3::TreeViewColumn**. TreeViewColumn had problems in that there where methods defined which were also made available in CellLayout. Therefore I have removed those from TreeViewColumn. There is a change however in some of those methods.
  * `.pack-start()` and `.pack-end()`; The `$expand` arguments are now a real boolean accepting only `True` and `False`.
  * Add module **Gnome::Gtk3::EntryCompletion**.
  * bugfix; found out that **Gnome::Gtk3::RecentFilter did not inherited **Gnome::Gtk3::Buildable.

* 2021-03-26 0.37.0:
  * Add module **Gnome::Gtk3::Editable** which is a role needed by the input widgets like **Gnome::Gtk3::Entry**.
  * Module **Gnome::Glib::List** rewritten and extended.

* 2021-03-26 0.36.6:
  * `Gnome::Gtk3::Widget.get-screen()` now returns a **Gnome::Gdk3::Screen** instead of the native object. Also document updates where Gnome::Gtk3::Screen where mentioned; changed into Gnome::Gdk3::Screen.
  * All **Gnome::Glib::N-…** _modules_ describing native objects are removed and replaced by **Gnome::N::N-GObject**. These are **Gnome::Glib::N-GVariant**, **Gnome::Glib::N-GVariantDict**, **Gnome::Glib::N-GVariantType**, **Gnome::Glib::N-GMainLoop** and **Gnome::Glib::GMainContext**.
  This might be an errors generating issue. Check your code for the use of these structure references and replace them by `N-GObject`, import **Gnome::N::N-GObject** to get that type. Hopefully it does not have a great impact because those modules are mostly for lower level handling of things.
  * Bugfixed in **Gnome::Gtk3::Widget**.
  * Enumerated type `N-GdkEventMask` has a wrong name and is renamed to `GdkEventMask`. All enumerated types are without the leading N-. The N- prefix is used for native structures and classes like `N-GObject`, `N-GError`, `N-GdkRectangle`, etcetera. It won't break anything because it is not used as a type on parameters. It is mainly used for its members which are or'ed into a mask and sent/received as an `Int`.

* 2021-03-22 0.36.5:
  * Improve docs of **Gnome::Gtk3::Window** and tests.
  * Bugfixed; method `Gnome::Gtk3::Window.set-icon()` called the native sub without the icon argument.

* 2021-03-18 0.36.4:
  * Improve documentation of **Gnome::Gtk3::Widget** and  **Gnome::Gtk3::MenuButton**. Also methods are added and new tests.

* 2021-03-02 0.36.3:
  * Removed dependency on **Gnome::Glib::OptionContext**. All classes needed to process commandline arguments, like this one, are removed or not implemented until I am realy sure that it will add more functionality than we already have using `MAIN()`, `USAGE()` and `@*ARGS`. Besides that, a lot of option processing modules are available. Take for example **Getopt::***, there are _**11**_ modules!.

* 2021-03-02 0.36.2:
Please note that in this version a few API modifications are made to some of the methods, e.g. in **Gnome::Gtk3::ColorChooser**. In the future more of this kind of changes will take place because of the implementation of real methods as opposed to the search methods starting in a FALLBACK().
Implementation of methods alongside each native subroutine was started because it made the access to the native subroutines faster.
Because those methods are then implemented in the same module, it is also clear, most of the time, what type of object is returned. It is then also possible to return the raku object instead of the native object.
Other changes are also applied. For instance, `gboolean` values become truly `Bool` instead of the `Int` returned from the native sub. Also enumerated values can be correctly returned through the use of the method.

For example originally the call to `gtk_color_chooser_get_rgba()` defined in **Gnome::Gtk3::ColorChooser**, you had to do;
```
my Gnome::Gdk3::RGBA $r .= new(:native-object($ccd.get-rgba));
```
while now you can
```
my Gnome::Gdk3::RGBA $r = $ccd.get-rgba;
```
My sincere apologies for breaking code 😐. It is however not possible, to my knowledge, to create multi's based on return types. For the moment, the calls to any of the routines `gtk_color_chooser_get_rgba()` and `get_rgba()`still work, though not documented anymore. At a later date, a deprecation warning will be given and after some while later, all the undocumented routines are removed.

* 2021-02-17 0.36.1:
  * Adjusted **Gnome::Gtk3::Application**. It inherits from **Gnome::Gio::Application** so it was not necessary to implement the role **Gnome::Gio::ActionMap** because **Gnome::Gio::Application** already does that.
  * Remove calls to `_orientable_interface()` and method in **Gnome::Gtk3::Orientable**.
  * Updated docs and tests of **Gnome::Gtk3::Buildable** and **Gnome::Gtk3::Main**.
  * Initializing **Gnome::Gtk3::Main** is now without calling `.init-check()`, option `:check` to `.new()` has no function anymore. Call `.init-check()` explicitly if need be. Most of the time working with any class inheriting from **Gnome::GObject::Object** has this part covered.
  * Added new interface **Gnome::Gtk3::Actionable**.
  * Updated docs and tests of **Gnome::Gtk3::ColorChooser**. Also found bugs in modules using ColorChooser. Those modules did not correctly found the signal `color-activated` from the interface.

  * There are some changes `Gnome::Gio`;
  * Added and improved are Action, SimpleAction, ActionGroup and SimpleActionGroup.
  * The MenuModel is split up in MenuModel, MenuAttributeIter and MenuLinkIter.
  * Add new module **Gnome::Gio::Menu**. Directly split into Menu and MenuIter.

  * Also Some changes in `Gnome::GObject`;
  * Added a new named argument to the call to a signal handler. Besides `:$_widget` and `:_handlder-id` the argument `:_native-object` is added. Usable when the value in `$_widget` is invalid.

* 2021-01-21 0.36.0:
  * New role **Gnome::Gtk3::RecentChooser**. This module is now used in an older module **Gnome::Gtk3::RecentChooserMenu**.
  * Building up the rest of the recently used files modules with **Gnome::Gtk3::RecentManager**, **Gnome::Gtk3::RecentInfo**, **Gnome::Gtk3::RecentFilter**, **Gnome::Gtk3::RecentChooserWidget** and **Gnome::Gtk3::RecentChooserDialog**.

* 2021-01-18 0.35.1:
  * New module **Gnome::Gtk3::CheckMenuItem**, **Gnome::Gtk3::SeparatorMenuItem** and **Gnome::Gtk3::RadioMenuItem**.
  * Document fixes of MessageDialog module.

* 2021-01-11 0.35.0:
  * Grid and Orientable speedup with new methods. Tests and benchmarking added and docs improved.
  * New module **Gnome::Gtk3::Fixed**

* 2021-01-11 0.34.9:
  * Test cut off by check of `raku_test_all` env variable to shorten total test time.

* 2021-01-07 0.34.8:
  * Document fixes of Scale module and add UML diagram.

* 2021-01-06 0.34.7:
  * Scale speedup with new methods. Tests and benchmarking added and docs improved.

* 2021-01-03 0.34.6:
  * **Gnome::Gtk3::Label** speedup with new methods. Tests and benchmarking added and docs improved.
  * Bugfix in TreeModel. Caused by changes in helper function `_f()` in **Gnome::N::TopLevelClassSuppert**.

* 2020-12-29 0.34.5:
  * Bugfixes in **Gnome::Gtk3::AboutDialog**.

* 2020-12-21 0.34.4:
  * Speeding up **Gnome::Gtk3::Assistant** and modify documents. Also make Assistant inheritable.

* 2020-12-21 0.34.3:
  * **Gnome::Gtk3::AboutDialog** speedup by adding methods for many native subroutines. Speedup is about 8 times faster. Documentation is modified to show the most useful call. Also **Gnome::Gtk3::Widget** has a few methods added which gives a speedup of about 2.5 times.
  * Testing of some modules is shortened. The idea is to do it with all test scripts. Setting an environment variable `raku_test_all` will then run through all tests. This will make the testing phase shorter. However, installing will still take much time.

* 2020-11-24 0.34.2:
  * Bugfixes in tests

* 2020-11-24 0.34.1:
  * Doc changes;
  - using **Gnome::N::GlibTorakuTypes**, types are replaced with types from that module giving a benefit of central coordination of glib types while keeping the native subs as closely as they are described.
  * AboutDialog; changed some native subs to get rid of the use of CArray[] looking from the users side.
  * Bug fix in TreeModel. `.gtk_tree_model_get_column_type()` should return uint32 instead of int32 because returned type is unsigned. This will be replaced by GType from GlibTorakuTypes mentioned above.

* 2020-11-15 0.34.0:
  * Add module **Gnome::Gtk3::Tooltip**.
  * Bugfixes in the TreeView set of modules.
  * Also added methods and docs added with tests.
  * Bugfixes in **Gnome::GObject::Object** and **Gnome::GObject::Signal**. The return value of a signal handler set using `.register-signal()` was processed wrong and was always thrown away.

* 2020-11-15 0.33.0:
  * Add module **Gnome::Gtk3::SpinButton**.
  * Some bugs removed from **Gnome::Gtk3::Adjustment**. Also completed testing and documenting.
  * Removed deprecations due since version 0.30.0
  * Added init options :png and :icon-name to `.new()` of **Gnome::Gtk3::Image**. Also added tests. Needed to extend **Gnome::Cairo::ImageSurface** with new options.
  * Changed gtk_image_get_storage_type in Image to return GtkImageType type as the documentation says
  * Added and tested a few other methods to Image.

* 2020-10-24 0.32.0:
  * Add module **Gnome::Gtk3::FileChooserButton**.
  * A warning: In the coming versions many obsoleted implementations are due to be removed.

* 2020-10-15 0.31.0:
  * Add module **Gnome::Gtk3::StatusBar**.

* 2020-10-04 0.30.1:
  * Made Label inheritable.

* 2020-10-04 0.30.0:
  * Add modules Gnome::Gtk3::IconTheme and Gnome::Gtk3::IconView.
  * Made UML diagrams more consistent with other diagrams from other modules.

* 2020-09-22 0.29.3:
  * Completed documentation and tests for Gnome::Gtk3::Stack

* 2020-08-27 0.29.2:
  * Add class Revealer to Gnome::Gtk3

* 2020-07-09 0.29.1:
  * Extending window tutorial.
  * Added Signal tutorial.
  * Repaired an accidently removed navigation file from the doc site.
  * Changes in Gnome::Gtk3::Widget;
  * Dropped .gtk_widget_init_template(), .gtk_widget_get_template_child() and several other template methods
  * Modified the structure types of `GdkEvent*` into `N-GdkEvent*` in Gnome::Gdk3::Events. The older types are deprecated and are removed in version 0.20.0 of the Gnome::Gdk3 package.

* 2020-07-09 0.29.0:
  * Changes in Gnome::Gtk3::Widget;
  * Add .destroy(), .show(), .hide(), .draw()  methods to minimize function name size. E.g. draw() calls gtk_widget_draw() which could only be shortened to widget_draw().
  * Add .gtk_widget_set_no_show_all(), .gtk_widget_get_no_show_all() subs.
  * Dropped .gtk_widget_queue_resize(), .gtk_widget_queue_resize_no_redraw() .gtk_widget_queue_allocate(), .gtk_widget_event(), .gtk_widget_send_focus_change(), .gtk_widget_set_has_window(), .gtk_widget_set_realized(), .gtk_widget_set_mapped(), .gtk_widget_set_parent(), .gtk_widget_set_parent_window(), .gtk_widget_set_child_visible(), .gtk_widget_get_child_visible(), .gtk_widget_set_allocation(), .gtk_widget_set_clip()
  * Renamed GtkAllocation to N-GtkAllocation.
  * Tests are added for subs and properties.
  * Cleaning up documentation.

* 2020-06-09 0.28.7:
  * Gnome::Gtk3::Widget module work;
  * Documentation improved
  * Add more tests
  * Dropped methods gtk_widget_destroyed, gtk_widget_unparent

* 2020-06-09 0.28.6:
  * Add Gnome::Gtk3::DrawingArea. First experiments to use Cairo.
  * It is a pitty that I cannot use the raku Cairo package of Timo because I cannot fit it into the calls of the existing Gnome packages. An entire new project is created called Gnome::Cairo. Need to mention that Cairo is not a Gnome product but named here this way because the way to access the classes and methods are about the same as with the other Gnome projects of mine.
  * Added gtk_widget_draw() to Gnome::Gtk3::Widget and tested the draw signal.
  * Added gdk_window_create_similar_surface() and gdk_window_create_similar_image_surface() to Gnome::Gdk3::Window.
  * Modified convert-to-natives() in Gnome::N::TopLevelClassSupport that it checks for destination argument type. When it detects num32 or num64 all source values are coerced using .Num(). This means that next examples are now valid for Num arguments; 10, 1/2, 0e2, '2.3' (these are Int, Rat, Num and Str resp).

* 2020-05-21 0.28.5:
  * 'Changes for issue #11'

* 2020-05-15 0.28.4:
  * Several parts in Gnome::GObject and Gnome::N are improved.
  * Started to cleanup documentation of Gnome::Gtk3::Window.

* 2020-05-04 0.28.3:
  * Modules using interfaces are rewritten in such a way that the interface is only mixed in the top most class where the interface is used.

* 2020-04-28 0.28.2:
  * Some improvements to start-thread() in Gnome::GObject::Object.
  * Method register-signal() now returns an integer instead of a boolean. This integer is a handler-id which can be used to disconnect the signal with g_signal_handler_disconnect(). When handler is 0, the registration failed. The other method to connect a signal is g_signal_connect_object() which will also return a handler id.
  * Added .new(:icon-name) to Gnome::Gtk3::Button and made the class inheritable.
  * Added a Uml diagram to AboutDialog and Button.

* 2020-04-17 0.28.1:
  * Made Gnome::Gtk3::CheckButton, Gnome::Gtk3::Scale, Gnome::Gtk3::Image, Gnome::Gtk3::Entry and Gnome::Gtk3::RadioButton inheritable.
  * Added a few multi to submethod BUILD to create an image from pixbufs and resources.

* 2020-04-17 0.28.0:
  * Added modules Gnome::Gtk3::TreeSelection, Gnome::Gtk3::Popover, Gnome::Gtk3::PopoverMenu and Gnome::Gtk3::Separator.
  * Add 'CATCH { default { .message.note; .backtrace.concise.note } }' to callback code in modules Gnome::GObject::Object and Container, ListBox, TextTagTable and TreeModel in Gnome::Gtk3. This prevents the situation that a moarvm panic occurs without a stackdump to follow. This improves the search for errors and typos very much.
  * Enabled gtk_tree_view_expand_to_path(), gtk_tree_view_row_expanded(), gtk_tree_view_expand_row() and gtk_tree_view_collapse_row() in Gnome::Gtk3::TreeView.
  * $str.chars() changed into $str.encode.bytes in a few places. This is the correct lenght, thanks Alain Barbason.

* 2020-04-11 0.27.5:
  * Enabled method gtk_tree_view_get_cell_area(), gtk_tree_view_get_selection() in Gnome::Gtk3::TreeView
  * Enabled method gtk_menu_popup-at-widget(), gtk_menu_popup_at_rect() in Gnome::Gtk3::Menu.
  * Cleanup and some modifications in Gnome::Gtk3::TreeStore.
  * Added `gdk_pixbuf_get_type()` in Gnome::Gdk3::Pixbuf to support a missing type GDK_TYPE_PIXBUF. This cannot be encoded because it is not a fundamental type like G_TYPE_INT.
  * Made classes ApplicationWindow, Application, Dialog, AboutDialog, MessageDialog, Grid, RecentChooserMenu, Notebook, TreeView and TreeStore in Gnome::Gtk3 inheritable.

* 2020-04-06 0.27.4:
  * Enabled method gtk_label_set_markup() in Gnome::Gtk3::Label.
  * Enabled method gtk_builder_connect_signals_full in Gnome::Gtk3::Builder.
  * Modified gtk_builder_new_from_string( $text, $text.chars), so that the length can be left out and the argument is now deprecated.

* 2020-04-06 0.27.3:
  * Enabled method g_type_name_from_instance() to Gnom::GObject::Type.

* 2020-04-05 0.27.2:
  * Removed a level of exception handling to get a stackdump when an error is encountered. Somehow this stack dump is unavailable in some situations.

* 2020-04-04 0.27.1:
  * Many changes in example programs for deprecated code.

* 2020-03-24 0.27.0:
  * Add modules Adjustment, ScrolledWindow, PlacesSidebar, RecentChooserMenu, and ScrolledWindow in Gnome::Gtk3.
  * Gnome::N::TopLevelClassSupport is implemented in Gnome::Glib and Gnome::GObject. Gnome::Gio must still be checked.

* 2020-03-23 0.26.3:
  * Provide gtk_css_provider_to_string() method to the CssProvider class.

* 2020-03-15 0.26.2:
  * Developed a top level support class Gnome::N::TopLevelClassSupport to be used by all Gnome classes living at the top of the foodchain. Example classes which will use this class are Gnome::GObject::Object, Gnome::Glib::Error, etc. These changes should be invisible to the user.

* 2020-03-09 0.26.1:
  * bugfixes in tests. Tests are skipped because of dependencies on language and other implementation details of GTK+.

* 2020-03-08 0.26.0:
  * Add modules GAction, GSimpleAction to Gnome::Gio
  * Add modules GVariantType, GVariant to Gnome::Glib
  * Many changes and bugfixes under the hood in all packages

* 2020-02-29 0.25.3:
  * Add gtk_builder_new_from_resource(), gtk_builder_add_from_resource() and .new(:resource) to Gnome::Gtk::Builder.

* 2020-02-25 0.25.2:
  * Bugfixes in the Application module in Gio and Gtk.

* 2020-02-25 0.25.1:
  * add-gui() from Gnome::Gtk3::Builder is removed in favor of gtk_builder_add_from_file() and gtk_builder_add_from_string().
  * Old version of gtk_builder_add_from_file() and gtk_builder_add_from_string() is removed.
  * Removed .new(:label) in favor of .new(:text) in Gnome::Gtk3::Label.
  * Bugfixed in ApplicationWindow module

* 2020-02-25 0.25.0:
  * Add Assistant module in Gnome::Gtk3.
  * Bugfixes and document updates.
  * Many deprecated parts in Gnome::Gtk3 would be removed at version 0.24.0 but will be postponed until 0.30.0.

* 2020-02-23 0.24.0:
  * Add modules Application and ApplicationWindow in Gnome::Gtk3. This introduced the Gnome::Gio package with the modules Application, Enums and MenuModel.

* 2020-02-17 0.23.3:
  * Bug fixed in ColorButton. Missing implementation of an interface ColorChooser.
  * TextView method `gtk_text_buffer_set_text()` is improved. The length of a string is no longer needed.

* 2020-02-05 0.23.2:
  * Add gtk_container_foreach to Container
  * Add gtk_list_box_selected_foreach to ListBox
  * Add gtk_text_tag_table_foreach to TextTagTable
  * Modified gtk_tree_model_foreach in TreeModel

* 2020-02-05 0.23.1:
  * Adjust **Gnome::Gtk3::Widget** method `gtk_widget_get_allocation()`
  * Add module ToolItem, ToolButon

* 2020-02-01 0.23.0:
  * Add module Stack, StackSwitcher, StackSidebar, Notebook in Gnome::Gtk3

* 2020-01-22 0.22.0:
  * Add module Frame, AspectFrame, Spinner, Switch, ProgressBar, MessageDialog in Gnome::Gtk3

* 2020-01-18 0.21.3:
  * renaming calls to `*native-gobject()` and `*native-gboxed()`.
  * rename `:widget` to `:native-object`.
  * remove `:empty` and use empty options hash instead

* 2020-01-10 0.21.2:
  * Repo renaming. All perl6-gnome-* packages renamed to 'gnome-*'.
  * All texts Perl\s*6 or p6 is renamed to raku or raku depending on use.
  * Some image files wit perl6 in the name are renamed.
  * Remaining tasks of renaming process comes at a later phase when v6.e or even v6.f.
  - Change of extensions
  - Change of methods '.perl()' and variables '$*PERL'

* 2019-12-16 0.21.1:
  * Bugfixes in gtk_list_store_remove() in ListStore and TreeStore.

* 2019-12-07 0.21.0:
  * Added new modules CellRendererCombo, CellRendererSpinner, CellRendererAccel, CellRendererSpin, CellRendererPixbuf
  * Small changes in Gnome::Gtk3::TreeStore gtk_tree_store_set_value().

* 2019-12-02 0.20.0:
  * New modules CellRendererToggle, CellRendererProgress
  * Method names can now be used in several ways. Please take a look at the design notes.

* 2019-11-23 0.19.4:
  * Changes in tests caused by Gnome::Glib
  * New module TreeStore. Needs more tests

* 2019-11-23 0.19.3:
  * Bugfix: calling .get-text() on a Label could call get the sub from Entry if that one is used before. This is caused by the caching mechanism which did not save the sub address along with the module where it came from.
  * Modified _fallback routines to change order of tests

* 2019-11-06 0.19.2:
  * Add modules ListStore, TreeView, TreeIter, TreePath, TreeViewColumn, TreeModel in Gnome::Gtk3

* 2019-10-27 0.19.1:
  * Rewrite of classes to handle interface roles differently. This caused some changes in the interface modules, the classes which use the interfaces and the Interface module from Gnome::GObject was removed.

* 2019-10-21 0.19.0:
  * New classes added in Gnome::Gtk3; Buildable.

* 2019-08-08 0.18.5:
  * The handler arguments list is changed when register-signal() from Gnome::GObject::Object is used. Some positional arguments, which were named arguments before, are oblegatory as well as their types. Most of them are unchanged because they did not receive extra data. For example the 'clicked' signal for a Button. Others like event processing are changed. E.g. 'button-press-event' on a window was returned on the :$event named argument. Now this has become the first positional argument with a type 'GdkEvent'.

  * One can connect also directly using g_signal_connect_object() from Gnome::GObject::Signal. Also here, the handler must provide all arguments and types and some more.

  * Added a method in Gnome::GObject::Object for interface using modules to query the interface modules for native subs. For example, the module Gnome::Gtk3::Button implements Gnome::Gtk3::Buildable. This means that subs defined there can be used by the Button module. Not all interfaces are implemented however, but the unimplemeted modules are silently ignored until a method is not found which will throw an exception.

  * The new() method in module Label of Gnome::Gtk3 is modified. The named attribute :$label is renamed into :$text. :$label is deprecated.

* 2019-08-29 0.18.4:
  * Experimenting with variable argument list in module FileChooserDialog to get buttons on the dialog.
  * Extended, documented and tested FileChooserDialog.

* 2019-08-27 0.18.3:
  * Extend FileChooser in Gnome::Gtk3. Added also some tests and pod doc.
  * Extend Type in Gnome::GObject and added doc and tests.

* 2019-08-04 0.18.2:
  * Removed an accidentaly created module `ImageMenuItem` which was deprecated by Gtk since version 3.10.
  * Gnome::GObject::Object modified to better check for undefined values before casting.
  * Added module Gnome::GObject::Param to handle N-GParamSpec native objects.
  * fallback() methods renamed to _fallback()

* 2019-08-04 0.18.1:
  * Completed doc and tests of ColorChooser in Gnome::Gtk3.

* 2019-08-04 0.18.0:
  * Extended, tested and documented CssProvider and StyleContext in Gnome::Gtk3.
  * Added StyleProvider to Gnome::Gtk3, altough it is a very empty shell :-\.
  * Added GtkBorder and GtkWidgetPath to Gnome::Gtk3.
  * Small change in TextIter in Gnome::Gtk3. It needs :empty named argument now when creating.

* 2019-08-04 0.17.12:
  * Builder pod doc
  * Builder tests using Gnome::Glib::Error

* 2019-08-04 0.17.11:
  * Modified Builder in Gnome::Gtk3 to handle returned errors properly.

* 2019-07-29 0.17.10:
  * Extended, tested and documented Container in Gnome::Gtk3.
  * Extended Error in Gnome::Glib
  * Added Quark in Gnome::Glib

* 2019-07-29 0.17.9:
  * Extended, tested and documented TextTagTable in Gnome::Gtk3.
  * Added class TextTag to Gnome::Gtk3.

* 2019-07-28 0.17.8:
  * Meta file bugfix

* 2019-07-28 0.17.7:
  * Bug fixed in TextIter. Many N-GObject types converted to N-GTextIter.
  * Extended, tested and documented ListBox.
  * Added ListBoxRow.

* 2019-07-25 0.17.6:
  * Extended, tested and documented TextBuffer, TextIter in Gnome::Gtk3.

* 2019-07-24 0.17.5:
  * Declaration of event signal sub moved from Gnome::GObject::Signal to Gnome::Gtk3::Widget to remove dependency of Gnome::GObject on Gnome::Gdk3.

* 2019-07-22 0.17.4:
  * Extended, tested and documented ColorChooserWidget, ComboBox, ComboBoxText

* 2019-07-20 0.17.3:
  * Documented Gnome::Gtk3::CheckButton and add test.
  * Extended, tested and documented Button, ColorButton, ColorChooser, ColorChooserDialog in Gnome::Gtk3.

* 2019-07-20 0.17.2:
  * Extended Gnome::Gtk3::Builder.
  * Added pod doc and tests.

* 2019-07-05 0.17.1:
  * Extended Gnome::Gtk3::Window, Gnome::Gtk3::Widget.
  * Added pod doc and tests.

* 2019-07-04 0.17.0:
  * Add MenuButton, Menu, MenuShell, MenuBar to Gnome::Gtk3.
  * Regenerated and adapted Gnome::Gdk3::Window.

* 2019-06-09 0.16.1:
  * Created a website at https://martimm.github.io/perl6-gnome-gtk3/. Long from finished.

* 2019-06-08 0.16.0:
  * Added new enums GtkAlign

* 2019-06-07 0.15.0:
  * Added Gnome::Gtk3::ColorChooserDialog, Gnome::Gtk3::ColorChooser, Gnome::Gtk3::ColorChooserWidget, Gnome::Gtk3::Box.
  * Added new enums GtkBaselinePosition, GtkPackType

* 2019-06-06 0.14.0:
  * Added Gnome::Gtk3::ColorButton

* 2019-05-28 0.13.2:
  * Updating docs

* 2019-05-29 0.13.1:
  * Refactored from project GTK::V3 at version 0.13.1
  * Modified class names by removing the first 'G' from the name. E.g. GBoxed becomes Boxed.
