#!/usr/bin/env sh

# added to remove error messages about 'Could not obtain desktop path or name'
# this happens when testing using VPN.
#
export NO_AT_BRIDGE=1

zef uninstall Gnome::Gtk3::Glade
zef uninstall Gnome::Gtk3
zef uninstall Gnome::Gdk3
zef uninstall Gnome::Gio
zef uninstall Gnome::Cairo
#zef uninstall Gnome::Pango
zef uninstall Gnome::GObject
zef uninstall Gnome::Glib
zef uninstall Gnome::N

echo '' >> xt/data/Gnome-Install-Times.txt
echo '' >> xt/data/Gnome-Install-Times.txt
date >> xt/data/Gnome-Install-Times.txt
raku -v >> xt/data/Gnome-Install-Times.txt

# added to test while using another speaking language to see if there are tests
# made on english messages which should not be done like that.
export LC_ALL=fr_FR.UTF-8

echo '' >> xt/data/Gnome-Install-Times.txt
echo 'Install Gnome::N Gnome::Glib Gnome::GObject' >> xt/data/Gnome-Install-Times.txt
/usr/bin/time -a -o xt/data/Gnome-Install-Times.txt zef --update install Gnome::N Gnome::Glib Gnome::GObject

echo '' >> xt/data/Gnome-Install-Times.txt
echo 'Install Gnome::Cairo Gnome::Gio Gnome::Gdk3' >> xt/data/Gnome-Install-Times.txt
/usr/bin/time -a -o xt/data/Gnome-Install-Times.txt zef --update install Gnome::Cairo Gnome::Gio Gnome::Gdk3

echo '' >> xt/data/Gnome-Install-Times.txt
echo 'Install Gnome::Gtk3' >> xt/data/Gnome-Install-Times.txt
/usr/bin/time -a -o xt/data/Gnome-Install-Times.txt zef --update install Gnome::Gtk3
