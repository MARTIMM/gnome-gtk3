```plantuml
scale 0.8

set namespaceSeparator ::

package Gnome::N << Rectangle >> {
}

package Gnome::GObject << Rectangle >> {
}

package Gnome::Gtk3 << Rectangle >> {
}

Gnome::Gtk3::Dialog <|- Gnome::Gtk3::AboutDialog
Gnome::Gtk3::Dialog <|-- Gnome::Gtk3::ColorChooserDialog
Gnome::Gtk3::Dialog <|-- Gnome::Gtk3::FileChooserDialog
Gnome::Gtk3::Dialog <|-- Gnome::Gtk3::MessageDialog
'Gnome::Gtk3::Dialog <|--- Gnome::Gtk3::AppChooserDialog
'Gnome::Gtk3::Dialog <|--- Gnome::Gtk3::FontChooserDialog
'Gnome::Gtk3::Dialog <|--- Gnome::Gtk3::RecentChooserDialog

Gnome::Gtk3::Window <|- Gnome::Gtk3::Dialog
Gnome::Gtk3::Bin <|- Gnome::Gtk3::Window
Gnome::Gtk3::Container <|- Gnome::Gtk3::Bin
Gnome::Gtk3::Widget <|- Gnome::Gtk3::Container

Interface Gnome::Gtk3::Buildable <Interface>
Gnome::Gtk3::Buildable <|-- Gnome::Gtk3::Widget
Gnome::GObject::InitialyUnowned <|--- Gnome::Gtk3::Widget


Gnome::GObject <--[hidden]- Gnome::Gtk3


class Gnome::GObject::InitialyUnowned
class Gnome::GObject::Object
Gnome::GObject::Object <|-- Gnome::GObject::InitialyUnowned

class Gnome::N::TopLevelClassSupport < Catch all class >
Gnome::N::TopLevelClassSupport <|-- Gnome::GObject::Object
```
