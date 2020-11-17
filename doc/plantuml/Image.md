```plantuml
@startuml
'scale 0.9
skinparam packageStyle rectangle
skinparam stereotypeCBackgroundColor #80ffff
set namespaceSeparator ::
hide members


class Gnome::N::TopLevelClassSupport < Catch all class >
Gnome::N::TopLevelClassSupport <|-- Gnome::GObject::Object

Interface Gnome::GObject::Signal <Interface>
class Gnome::GObject::Signal <<(R,#80ffff)>>

Interface Gnome::Gtk3::Buildable <Interface>
class Gnome::Gtk3::Buildable <<(R,#80ffff)>>


Gnome::GObject::Object <|-- Gnome::GObject::InitialyUnowned
Gnome::GObject::Signal <|. Gnome::GObject::Object

Gnome::GObject::InitialyUnowned <|-- Gnome::Gtk3::Widget
Gnome::Gtk3::Buildable <|. Gnome::Gtk3::Widget 

Gnome::Gtk3::Misc <|- Gnome::Gtk3::Image
Gnome::Gtk3::Widget <|- Gnome::Gtk3::Misc
@enduml

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
