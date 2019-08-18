[toc]

# Theming
See also [gtk theming tutorial][GtkTheming tut] and at the [gtk developer guides][GtkTheming dev]. The tutorial is old and some links are not working.
* Tool `GtkInspector`.
  Enabling GtkInspector with; `gsettings set org.gtk.Settings.Debug enable-inspector-keybinding true`. Then, after starting your gtk application, launch the inspector by pressing on the keyboard `Control-Shift-I` or `Control-Shift-D`.
* Tool `gtk3-widget-factory`.
* Theme locations. See also `GtkSettings`
  * Path prefixes can be **/usr/share/themes** or **~/.themes**.
  * Path to a gtk3 theme are \<prefix>/**\<theme name>/gtk-3.0/**
  * Files used by the a theme are
    * \<theme prefix>/**gtk.css**
    * \<theme prefix>/**gtk-keys.css**
  * General user gtk3 locations
  * **~/.config/gtk-3.0/gtk.css**
  * **~/.config/gtk-3.0/settings.ini**
* Desktop files. See also [at the free desktop site][freedesktop].
  * `~/.local/share/applications/<app>.desktop`

## Steps
* Make directory for the theme and create theme file. Contents can added later. Call theme `TT1` for test theme 1. Furthermore we use program `gtk3-widget-factory` to test the theme.
```
$ cd $HOME
$ mkdir -p .themes/TT1/gtk-3.0
$ cd .themes/TT1/gtk-3.0
$ touch gtk.css

$ cd ~/.local/share/applications
$ vi gtk3-widget-factory.desktop
$ ln gtk3-widget-factory.desktop ~/Desktop
```
  You should see the icon on the desktop and when clicked on, the `gtk3-widget-factory` should start with the TT1 theme. It starts with a black background and white text because nothing is specified in the `gtk.css` file. Now you can continue to the [developer documents to finish your theme][GtkTheming dev].

An example desktop entry file `gtk3-widget-factory.desktop`.
```
[Desktop Entry]
Type=Application

Name=gtk3-widget-factory
Name[en_US]=gtk3-widget-factory

Exec=env GTK_THEME=TT1 /usr/bin/gtk3-widget-factory
Icon=/path/to/some/icon.png

# to view on desktop make it false
NoDisplay=false

Comment[en_US]=Gtk3 widget factory
Comment=Gtk3 widget factory
```

[//]: # (References)

[GtkTheming tut]: https://gtkthemingguide.now.sh/#/
[GtkTheming dev]: https://developer.gnome.org/gtk3/stable/theming.html
[freedesktop]: https://standards.freedesktop.org/desktop-entry-spec/latest/ar01s06.html
[gtk 2to3 migration]: https://developer.gnome.org/gtk3/stable/gtk-migrating-GtkStyleContext.html
