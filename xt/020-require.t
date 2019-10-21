use v6;
use Test;

diag "\n";
use Gnome::Gtk3::AboutDialog;
use Gnome::Gtk3::CheckButton;


diag "V3: " ~ GTK::V3::.keys;
diag "Gtk: " ~ GTK::V3::Gtk::.keys;
diag "Glib: " ~ GTK::V3::Glib::.keys;

ok GTK::V3::Gtk::<GtkWindow>:exists, 'GtkWindow loaded';

require ::("Gnome::Gtk3::Entry");

diag "V3: " ~ GTK::V3::.keys;
diag "Gtk: " ~ GTK::V3::Gtk::.keys;
diag "Glib: " ~ GTK::V3::Glib::.keys;

#-------------------------------------------------------------------------------
done-testing;
