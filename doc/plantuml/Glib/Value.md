```plantuml
@startuml

skinparam packageStyle rectangle
skinparam stereotypeCBackgroundColor #80ffff
set namespaceSeparator ::
hide members

'Class and interface decorations
class Gnome::N::TopLevelClassSupport < Catch all class >

'Class connections
Gnome::N::TopLevelClassSupport <|-- Gnome::GObject::Boxed
Gnome::GObject::Boxed <|-- Gnome::GObject::Value
@enduml
