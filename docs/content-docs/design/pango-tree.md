---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---
# Pango modules tree

Below there is a table of the object hierarchy taken from [the developers page](https://developer.gnome.org/pango/stable/pango-hierarchy.html) and is used here to show what is implemented and what is deprecated. Every Raku class is in the Gnome:: name space. Also prefixes and module path names are removed from the Raku modules. So GObject is implemented in **Gnome::GObject::Object** and PangoFont is implemented in **Gnome::Pango::Font**. `├─✗` in front of a Pango module means that it is deprecated or will not be implemented for other reasons.

```
Tree of Pango C structures                            Raku module
----------------------------------------------------- ------------------------
GObject                                               Gnome::GObject::Object
├── PangoFont
│   ╰── PangoFcFont
│       ╰── PangoXftFont
├── PangoFontMap
│   ╰── PangoFcFontMap
│       ├── PangoFT2FontMap
│       ╰── PangoXftFontMap
├── PangoRenderer
│   ╰── PangoXftRenderer
├── PangoContext                                      Context
├── PangoCoverage
├─✗ PangoEngine
│   ├─✗ PangoEngineLang
│   ╰─✗ PangoEngineShape
├── PangoFcDecoder
├── PangoFontFace
├── PangoFontFamily
├── PangoFontset
├── PangoLayout                                       Layout
├─✗ PangoOTInfo
╰─✗ PangoOTRuleset

GInterface                                            Modules are defined as Roles
├── PangoCairoFont
╰── PangoCairoFontMap

GEnum                                                 Gnome::GObject::Enums
├── PangoAlignment
├── PangoAttrType
├── PangoBidiType
├── PangoCoverageLevel
├── PangoDirection
├── PangoEllipsizeMode
├── PangoGravity
├── PangoGravityHint
├── PangoRenderPart
├── PangoScript
├── PangoStretch
├── PangoStyle
├── PangoTabAlign
├── PangoUnderline
├── PangoVariant
├── PangoWeight
╰── PangoWrapMode

GBoxed                                                Gnome::GObject::Boxed
├── PangoAttrIterator
├── PangoAttrList
├── PangoAttribute
├── PangoColor
├── PangoFontDescription
├── PangoFontMetrics
├── PangoGlyphItem
├── PangoGlyphItemIter
├── PangoGlyphString
├── PangoItem                                         Item
├── PangoLanguage
├── PangoLayoutIter
├── PangoLayoutLine
├── PangoMatrix
├── PangoScriptIter
╰── PangoTabArray

GFlags                                                Gnome::GObject::Enums
├── PangoFontMask
├── PangoShapeFlags
╰── PangoShowFlags
```
