```plantuml
scale 0.9
skinparam packageStyle rectangle
set namespaceSeparator ::
hide members


class Gnome::N::TopLevelClassSupport < Catch all class >
Gnome::N::TopLevelClassSupport <|-- Gnome::GObject::Object

Gnome::GObject::Object <|-- Gnome::GObject::InitialyUnowned
Gnome::GObject::Object *-> Gnome::GObject::Signal

```


<!--
│   │   │   │   ├── GtkButton                   ♥ Button
│   │   │   │   │   ├── GtkToggleButton         ToggleButton
│   │   │   │   │   │   ├── GtkCheckButton      ♥ CheckButton
│   │   │   │   │   │   │   ╰── GtkRadioButton  ♥ RadioButton
│   │   │   │   │   │   ╰── GtkMenuButton       MenuButton
│   │   │   │   │   ├── GtkColorButton          ColorButton
│   │   │   │   │   ├── GtkFontButton
│   │   │   │   │   ├── GtkLinkButton
│   │   │   │   │   ├── GtkLockButton
│   │   │   │   │   ├── GtkModelButton
│   │   │   │   │   ╰── GtkScaleButton
│   │   │   │   │       ╰── GtkVolumeButton

│   │   │   │   ├── GtkButton                         b,ac
│   │   │   │   │   ├── GtkToggleButton               b,ac
│   │   │   │   │   │   ├── GtkCheckButton            b,ac
│   │   │   │   │   │   │   ╰── GtkRadioButton        b,ac
│   │   │   │   │   │   ╰── GtkMenuButton             b,ac
│   │   │   │   │   ├── GtkColorButton                b,ac,cc
│   │   │   │   │   ├── GtkFontButton                 b,ac,foc
│   │   │   │   │   ├── GtkLinkButton                 b,ac
│   │   │   │   │   ├── GtkLockButton                 b,ac
│   │   │   │   │   ├── GtkModelButton                b,ac
│   │   │   │   │   ╰── GtkScaleButton                b,o,ac
│   │   │   │   │       ╰── GtkVolumeButton           b,o,ac

├── GtkBuildable                                      b
├── GtkActionable                                     ac
├── GtkOrientable                                     o
├── GtkColorChooser                                   cc
├── GtkFontChooser                                    foc
-->
