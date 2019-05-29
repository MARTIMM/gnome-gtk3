use v6;
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::GObject::Interface;
use Gnome::Glib::SList;
#use Gnome::Gtk3::FileFilter;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkfilechooser.h
# https://developer.gnome.org/gtk3/stable/GtkFileChooser.html
unit class Gnome::Gtk3::FileChooser:auth<github:MARTIMM>;
also is Gnome::GObject::Interface;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<current-folder-changed file-activated selection-changed
            update-preview
           >,
    :notsupported<confirm-overwrite>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::FileChooser';

  if ? %options<widget> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_file_chooser_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TODO notes free lists

sub gtk_file_chooser_set_action (
  N-GObject $chooser, int32 $file-chooser-action
) is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_action ( N-GObject $chooser )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_local_only (
  N-GObject $chooser, int32 $local_only
) is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_local_only ( N-GObject $chooser )
  returns int32 # Bool
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_select_multiple (
  N-GObject $chooser, int32 $select_multiple
) is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_select_multiple ( N-GObject $chooser )
  returns int32 # Bool
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_show_hidden ( N-GObject $chooser, int32 $show_hidden )
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_show_hidden ( N-GObject $chooser )
  returns int32 # Bool
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_do_overwrite_confirmation (
  N-GObject $chooser, int32 $do_overwrite_confirmation
) is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_do_overwrite_confirmation ( N-GObject $chooser )
  returns int32 # Bool
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_create_folders (
  N-GObject $chooser, int32 $create_folders
) is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_create_folders ( N-GObject $chooser )
  returns int32 # Bool
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_current_name ( N-GObject $chooser, Str $name )
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_current_name ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_filename ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_filename ( N-GObject $chooser, Str $filename )
  returns int32 # not useful
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_select_filename ( N-GObject $chooser, Str $filename )
  returns int32 # not useful
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_unselect_filename ( N-GObject $chooser, Str $filename )
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_select_all ( N-GObject $chooser )
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_unselect_all ( N-GObject $chooser )
  is native(&gtk-lib)
  { * }

# g_free and g_slist_free
sub gtk_file_chooser_get_filenames ( N-GObject $chooser )
  returns N-GSList
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_current_folder ( N-GObject $chooser, Str $filename )
  returns int32 # not useful
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_current_folder ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_uri ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_uri ( N-GObject $chooser, Str $uri )
  returns int32 # not useful
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_select_uri ( N-GObject $chooser, Str $uri )
  returns int32 # not useful
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_unselect_uri ( N-GObject $chooser, Str $uri )
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_uris ( N-GObject $chooser )
  returns N-GSList
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_current_folder_uri ( N-GObject $chooser, Str $uri )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_current_folder_uri ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_preview_widget (
  N-GObject $chooser, N-GObject $preview_widget
) is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_preview_widget ( N-GObject $chooser )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_preview_widget_active (
  N-GObject $chooser, int32 $active
) is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_preview_widget_active ( N-GObject $chooser )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_use_preview_label (
  N-GObject $chooser, int32 $use_label
) is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_use_preview_label ( N-GObject $chooser )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_preview_filename ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_preview_uri ( N-GObject $chooser )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_extra_widget (
  N-GObject $chooser, N-GObject $extra_widget
) is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_extra_widget ( N-GObject $chooser )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_add_filter ( N-GObject $chooser, N-GObject $filefilter )
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_remove_filter ( N-GObject $chooser, N-GObject $filefilter)
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_list_filters ( N-GObject $chooser )
  returns N-GSList
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_filter ( N-GObject $chooser, N-GObject $filter )
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_filter ( N-GObject $chooser )
  returns N-GObject # GtkFileFilter
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_add_shortcut_folder (
  N-GObject $chooser, Str $folder, OpaquePointer
) returns int32
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_remove_shortcut_folder (
  N-GObject $chooser, Str $folder, OpaquePointer
) returns int32
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_list_shortcut_folders ( N-GObject $chooser )
  returns N-GSList
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_add_shortcut_folder_uri (
   N-GObject $chooser, Str $uri, OpaquePointer
) returns int32
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_remove_shortcut_folder_uri (
  N-GObject $chooser, Str $uri, OpaquePointer
) returns int32
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_list_shortcut_folder_uris ( N-GObject $chooser )
  returns N-GSList
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_current_folder_file ( N-GObject $chooser )
  returns N-GObject # GFile
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_file ( N-GObject $chooser )
  returns N-GObject # GFile
  is native(&gtk-lib)
  { * }

# GObject::g_object_unref
# SList::g_slist_free
sub gtk_file_chooser_get_files (  N-GObject $chooser )
  returns N-GSList
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_get_preview_file ( N-GObject $chooser )
  returns N-GObject # GFile
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_select_file (
  N-GObject $chooser, N-GObject $file, OpaquePointer
) returns int32
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_current_folder_file (
  N-GObject $chooser, N-GObject $file, OpaquePointer
) returns int32
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_set_file (
  N-GObject $chooser, N-GObject $file, OpaquePointer
) returns int32
  is native(&gtk-lib)
  { * }

sub gtk_file_chooser_unselect_file ( N-GObject $chooser, N-GObject $file )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2 ...

...
=item ...

=end pod

enum GtkFileChooserAction is export <
  GTK_FILE_CHOOSER_ACTION_OPEN
  GTK_FILE_CHOOSER_ACTION_SAVE
  GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER
  GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER
>;

#-------------------------------------------------------------------------------
=begin pod
=head2 ...

...
=item ...

=end pod

enum GtkFileChooserConfirmation is export <
  GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM
  GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME
  GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN
>;

#-------------------------------------------------------------------------------
=begin pod
=head2 ...

...
=item ...

=end pod

enum GtkFileChooserError <
  GTK_FILE_CHOOSER_ERROR_NONEXISTENT
  GTK_FILE_CHOOSER_ERROR_BAD_FILENAME
  GTK_FILE_CHOOSER_ERROR_ALREADY_EXISTS
  GTK_FILE_CHOOSER_ERROR_INCOMPLETE_HOSTNAME
>;
