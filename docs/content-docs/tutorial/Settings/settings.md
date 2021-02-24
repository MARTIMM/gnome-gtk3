https://unix.stackexchange.com/questions/524796/gtk3-gsettings-usage

Short answer

(as I understand this):

dconf is database system which keeps settings (GVariants) in database files and it is on the bottom layer.

dconf schemas are the files which contain structure of these database files.

gsettings is an API and a toolkit to store and retrieve this settings from and to database.
Long answer

(as explained in Wikipedia): https://en.wikipedia.org/wiki/Dconf

* dconf is a low-level configuration system and settings management tool. Its main purpose is to provide a back end to GSettings on platforms that don't already have configuration storage systems. It depends on GLib. It is part of GNOME 3 and is a replacement for GConf.

* dconf database: One dconf database consists of a single file in binary format, i.e. it is not a text-file. The format is defined as gvdb (GVariant Database file). It is a simple database file format that stores a mapping from strings to GVariant values in a way that is extremely efficient for lookups.

* GVariant: GVariant is a strongly typed value datatype. GVariant is a variant datatype; it can contain one or more values along with information about the type of the values.  A GVariant may contain simple types, like integers, or boolean values; or complex types, like an array of two strings, or a dictionary of key value pairs. A GVariant is also immutable: once it's been created, neither its type nor its content can be modified further. GVariant is useful whenever data needs to be serialized, for example when sending method parameters in DBus, or when saving settings using GSettings.    GVariant is part of GLib.

* GSettings: The GSettings class provides a high-level API for application for storing and retrieving their own settings. The utility program /usr/bin/gsettings is contained in libglib2.0-bin. GSettings is part of GIO which is part of GLib (libglib2.0-0).


https://blog.gtk.org/2017/05/01/first-steps-with-gsettings/
