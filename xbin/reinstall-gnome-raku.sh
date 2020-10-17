#!/usr/bin/env sh

# added to remove error messages about 'Could not obtain desktop path or name'
# this happens when testing using VPN.
#
export NO_AT_BRIDGE=1

# added to test while using another speaking language to see if there are tests
# made on english messages which should not be done like that.
#
export LC_ALL=fr_FR.UTF-8

zef uninstall Gnome::Gtk3::Glade
zef uninstall Gnome::Gtk3
zef uninstall Gnome::Gdk3
zef uninstall Gnome::Gio
zef uninstall Gnome::Cairo
zef uninstall Gnome::Pango
zef uninstall Gnome::GObject
zef uninstall Gnome::Glib
zef uninstall Gnome::N

/usr/bin/time -v zef -a -o xt/data/Gnome-Install-Times.txt --update install Gnome::Gtk3::Gtk3
