Gnome::T
========

Main entry of test framework

Description
===========

**Gnome::T** class is the top level of the user interface test framework. To use tne class run your program like so;

    raku -MGnome::T my-gui-program.raku --Ttest-protocol.yaml

where

  * `-MGnome::T`; loads the module where this class resides. `-M` is a Raku option.

  * `my-gui-program.raku`; is the gui program to test

  * `--Ttest-protocol.yaml`; test the gui using this test protocol. `--T` is the modules option.

