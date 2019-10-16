use v6;
use NativeCall;
use Test;

diag "load";
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

my Gnome::Gtk3::FileChooser $fc .= new(:widget($fcd));

#-------------------------------------------------------------------------------
subtest 'ISA test', {

  diag '.new(:widget)';
  $fc .= new(:widget($fcd));
  isa-ok $fc, Gnome::Gtk3::FileChooser;
}

#-------------------------------------------------------------------------------
subtest 'Manipulations', {
  diag '.set-action / .get-action';
  $fc.set-action(GTK_FILE_CHOOSER_ACTION_SAVE);
  is $fc.get-action, GTK_FILE_CHOOSER_ACTION_SAVE.value,
     'GtkFileChooserAction save';
  $fc.set-action(GTK_FILE_CHOOSER_ACTION_OPEN);
  is $fc.get-action, GTK_FILE_CHOOSER_ACTION_OPEN.value,
     'GtkFileChooserAction open';
  $fc.set-action(GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER);
  is GtkFileChooserAction($fc.get-action),
     GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER,
     'GtkFileChooserAction select folder';
  $fc.set-action(GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER);
  is GtkFileChooserAction($fc.get-action),
     GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER,
     'GtkFileChooserAction create folder';

  diag '.set-local-only / .get-local-only';
  $fc.set-local-only(1);
  ok ?$fc.get-local-only, 'local only';
  $fc.set-local-only(0);
  ok !$fc.get-local-only, 'not local only';
}

#-------------------------------------------------------------------------------
done-testing;
