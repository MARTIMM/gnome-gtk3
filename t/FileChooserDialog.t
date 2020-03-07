use v6;
use NativeCall;
use Test;

use Gnome::Gtk3::Dialog;
use Gnome::Gtk3::FileChooser;
use Gnome::Gtk3::FileChooserDialog;

#use Gnome::N::X;
#Gnome::N::debug(:on);

#-------------------------------------------------------------------------------
my Gnome::Gtk3::FileChooserDialog $fcd .= new(
  :action(GTK_FILE_CHOOSER_ACTION_SAVE),
  :button-spec( [
      "_Cancel", GTK_RESPONSE_CANCEL,
      "_Open", GTK_RESPONSE_ACCEPT
    ]
  )
);

#-------------------------------------------------------------------------------
subtest 'ISA test', {

  isa-ok $fcd, Gnome::Gtk3::FileChooserDialog;
}

#-------------------------------------------------------------------------------
subtest 'Interface FileChooser', {
  $fcd.set-action(GTK_FILE_CHOOSER_ACTION_SAVE);
  is $fcd.get-action, GTK_FILE_CHOOSER_ACTION_SAVE.value,
     'GtkFileChooserAction save';
  $fcd.set-action(GTK_FILE_CHOOSER_ACTION_OPEN);
  is $fcd.get-action, GTK_FILE_CHOOSER_ACTION_OPEN.value,
     'GtkFileChooserAction open';
  $fcd.set-action(GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER);
  is GtkFileChooserAction($fcd.get-action),
     GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER,
     'GtkFileChooserAction select folder';
  $fcd.set-action(GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER);
  is GtkFileChooserAction($fcd.get-action),
     GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER,
     'GtkFileChooserAction create folder';

  $fcd.set-local-only(1);
  ok ?$fcd.get-local-only, '.set-local-only / .get-local-only';
}

#-------------------------------------------------------------------------------
done-testing;
