---
title: References to the Cairo package modules
nav_menu: references-nav
sidebar_menu: references-cairo-sidebar
layout: sidebar
---
# Gnome::Cairo Reference

The modules are all generated from the C source code and the documentation refers specifically to operations in C. Most of it is converted on the fly into Raku types or Raku native types. Sometimes, however, there is a mention of an operation like for instance, referencing or un-referencing objects. Those parts must be investigated still to see what the impact exactly is in Raku.

Each entry in the sidebar shows the name of a module with two icons, one icon to show the state of documentation and one for the state of testing. When hoovering over the icons a tool tip appears with a message about its state.

## Color coding of the entries in the sidebar
* <strong style="color:#e58080;">Toplevel classes</strong> are classes who inherit directly from **Gnome::N::TopLevelClassSupport**. Examples of such classes are **Gnome::GObject::Object** and **Gnome::Glib::Error**.
* <strong style="color:#a04500;">Object classes</strong> are classes which inherit directly or indirectly from **Gnome::GObject::Object**.
* <strong style="color:#bf00bf;">Interface classes</strong>. Most types in an application will be classes — in the normal object-oriented sense of the word — derived directly or indirectly from the root class, **Gnome::GObject::Object**. There are also interfaces, which can contain implemented methods. These are mixed in in the appropriate class. E.g. the interface **Gnome::Gtk3::Buildable** is mixed into the **Gnome::Gtk3::Widget** class. <!--Interfaces can thus be described as mixins.-->
* <strong style="color:#00afaf;">Boxed classes</strong>. Some data structures that are too simple to be made full-fledged class types. <!-- (with all the overhead incurred) may still need to be registered with the type system. --> An example is **Gnome::Gdk3::RGBA** which holds only a few numbers representing the RGB colors and Alpha channel. It would be too much to let it inherit from **Gnome::GObject::Object**. <!--For example, we might have a class to which we want to add a background-color property, whose values should be instances of a structure that looks like struct color { int r, g, b; }. To avoid having to subclass GObject, we can create a boxed type to represent this structure, and provide functions for copying and freeing. GObject ships with a handful of boxed types wrapping simple GLib data types. Another use for boxed types is as a way to wrap foreign objects in a tagged container that the type system can identify and will know how to copy and free.-->
* <strong style="color:#80bf00;">Standalone classes</strong> are classes which do not inherit from other classes. Most of the time they even do not have a native object to work with. An example is **Gnome::Glib::Quark**.

<!-- * <strong style="color:#f54045;">Widget classes</strong> are also indirectly inheriting from **Gnome::GObject::Object** but made a special category here to easily find a user interface class.
-->

<!--
The documentation icons are
* 📔 There is no documentation. Older modules were made by hand and did not have documentation. Now, with the help of a Raku program C-source files are skimmed to get the subroutines and types along with their documentation. The entry will not be active.
* 🕮 Documentation generated. Documentation is only generated. Needs a rewrite to change c-code examples etc. Also subroutines are commented out when there are unsupported (for now) dependencies or that subroutines do not have any use in the Raku environment.
* 📖 Documentation rewritten. This means that the documentation is reread and changed to show a more Raku attitude.
* 🗸 Documentation has examples. There are examples in the documentation added.

The test icons are
* 🗒 No tests for this module.
* 🗇 Module parses ok (module load). This means that the `use module-name;` statement as well as the `.new()` call, succeeds.
* 🗊 Module subs and methods are tested.
* 🗲 Signals are tested when available, otherwise it is skipped.
* ⌺ Styling is tested when available, otherwise it is skipped.
* 🗸 All that is available is tested.
-->

## Deprecated classes in Cairo

The following modules will not be implemented in this Raku package because they are deprecated in the Cairo libraries. There is no reason to have people use old stuff which is going to disappear.

* 
