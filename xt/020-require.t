use v6;
use Test;

diag "\n";
use GTK::V3::Gtk::GtkAboutDialog;
use GTK::V3::Gtk::GtkCheckButton;


diag "V3: " ~ GTK::V3::.keys;
diag "Gtk: " ~ GTK::V3::Gtk::.keys;
diag "Glib: " ~ GTK::V3::Glib::.keys;

ok GTK::V3::Gtk::<GtkWindow>:exists, 'GtkWindow loaded';

require ::("GTK::V3::Gtk::GtkEntry");

diag "V3: " ~ GTK::V3::.keys;
diag "Gtk: " ~ GTK::V3::Gtk::.keys;
diag "Glib: " ~ GTK::V3::Glib::.keys;

#-------------------------------------------------------------------------------
done-testing;
