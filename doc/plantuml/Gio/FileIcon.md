```plantuml
@startuml

skinparam packageStyle rectangle
skinparam stereotypeCBackgroundColor #80ffff
set namespaceSeparator ::
hide empty members

'Classes and interfaces
class Gnome::N::TopLevelClassSupport < Catch all class >

Interface Gnome::GObject::Signal <Interface>
class Gnome::GObject::Signal <<(R,#80ffff)>>

Interface Gnome::Gio::Icon <Interface>
class Gnome::Gio::Icon <<(R,#80ffff)>>

Interface Gnome::Gio::LoadableIcon <Interface>
class Gnome::Gio::LoadableIcon <<(R,#80ffff)>> #ffa0a0
note "this class is not\n implemented" as NLI
Gnome::Gio::LoadableIcon .down. NLI

'Class connections
Gnome::N::TopLevelClassSupport <|-- Gnome::GObject::Object
Gnome::GObject::Signal <|. Gnome::GObject::Object

Gnome::Gio::Icon <|. Gnome::Gio::LoadableIcon
Gnome::Gio::LoadableIcon <|. Gnome::Gio::FileIcon
Gnome::GObject::Object <|-- Gnome::Gio::FileIcon

@enduml
```
