---
title: References to the Pango package modules
nav_menu: references-nav
sidebar_menu: references-pango-sidebar
layout: sidebar
---
# Gnome::Pango Reference

The modules are all generated from the C source code and the documentation refers specifically to operations in C. Most of it is converted on the fly into Raku types or Raku native types. Sometimes, however, there is a mention of an operation like for instance, referencing or un-referencing objects. Those parts must be investigated still to see what the impact exactly is in Raku.

Each entry in the sidebar shows the name of a module with two icons, one icon to show the state of documentation and one for the state of testing. When hoovering over the icons a tool tip appears with a message about its state.

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

## Deprecated classes in Pango

The following modules will not be implemented in this Raku package because they are deprecated in the Pango libraries. There is no reason to have people use old stuff which is going to disappear.

* OpenType Font Handling — Obtaining information from OpenType tables
* Engines — Language-specific and rendering-system-specific processing
* PangoEngineLang — Rendering-system independent script engines
* PangoEngineShape — Rendering-system dependent script engines
