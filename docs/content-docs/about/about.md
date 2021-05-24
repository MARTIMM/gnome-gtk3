---
title: About the Program
nav_menu: default-nav
sidebar_menu: about-sidebar
layout: sidebar
---

# About The Project

This project is language binding of Raku to the Gnome libraries where GTK+ libraries has version 3.\*.

<!--
  _**Note: Need to look at this more closely regarding the GTK licenses!**_
-->

## Attribution
* First of all, I would like to thank the developers of the **GTK::Simple** project because of the information I got while reading the code. The examples in that project are also useful to compare code with each other and to see what is or is not possible.
* The inventors of Raku, formerly Perl6, of course and the writers of the documentation which helps me out every time again and again. Also the people replying to questions on several mailing-lists were a great help.
* The builders of the GTK+ libraries and the documentation for it have helped me a lot too to see how things work. Their source code is also very helpful in the way that I could write a program to generate Raku source code from it. After that, only some fiddling a bit to get the modules to load, and a bit more to adjust some of the subroutines. Also, many images used in their documentation are reused here in the reference guides.
* <img src="../images/gtk-perl6.png" style="float:left; margin-right:4px;" width="100" /> The icon used for these packages is build up from that of GTK+ and the Raku Camelia, the butterfly. Camelia is **™** to **Larry Wall**. Other icon sources used in the documentation are from **icons8.com**.
<br/>
<br/>
* Many diagrams are made using the [Plantuml program](https://plantuml.com/). A big thank you for this tool!
* [Prof Stewart Weiss](http://www.compsci.hunter.cuny.edu/~sweiss/index.php). On his site are numerous documents under which many about GTK+. I have used parts from these to explain many aspects of the user interface system.

## Author and Copyright
**ⓒ 2019 .. ∞ Marcel Timmerman.** known as **MARTIMM** on **github** and **CPAN** / **Pause**

## Licenses
* GTK is entirely open-source using the `LGPL license`.
* Raku code and pod documentation: `Artistic License 2.0`.
* Use of Gnome reference documentation: `GNU Free Documentation License Version 1.3`.
* Documentation from other external sources used in tutorials: `Creative Commons Attribution-ShareAlike 4.0 International Public License`.

## Release notes

A note about the versions used in the release notes. It is based on the Semantic Versioning which can be [looked up here](http://semver.org/). In short ;

Given a version number `MAJOR.MINOR.PATCH`, increment the:
* `MAJOR version` when you make incompatible API changes,
* `MINOR version` when you add functionality in a backwards compatible manner, and
* `PATCH version` when you make backwards compatible bug fixes.

Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.
* Here a fourth number is sometimes used. This number is never used to make a release notes entry. It is used to make site document updates, travis or appveyor script updates etcetera.

Please note point 4. on that page: **_Major version zero (0.y.z) is for initial development. Anything may change at any time. The public API should not be considered stable._**
