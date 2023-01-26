#!/usr/bin/env rakudo

my Hash $map = %();
my Str $root = "/home/marcel/Languages/Raku/Projects/gnome-";
set-map( $root, 'Gtk3', 'gtk');
set-map( $root, 'Gdk3', 'gdk');
set-map( $root, 'Glib', 'g');
set-map( $root, 'GObject', 'g');
set-map( $root, 'Gio', 'g');
set-map( $root, 'Pango', 'pango');
set-map( $root, 'Cairo', 'cairo');

add-deprecated-classes;

# temp for new module in the make
$map<gtk_icon_info> = 'Gnome::Gtk3::IconInfo';

# other references which probably never make it into rakudo
$map<g_async> = 'Not implemented Gnome::Glib::Async';
$map<g_cancellable> = 'Not implemented Gnome::Gio::Cancellable';
#$map<> = 'Not implemented';
#$map<> = 'Not implemented';

my Str $content = '';
for $map.keys.sort -> $k {
  $content ~= "\n$k: $map{$k}";
}

$content ~~ s/^ \n //;
'Design-docs/gnome-names-map.txt'.IO.spurt($content);

#-------------------------------------------------------------------------------
sub set-map ( Str $root, Str $m-part, Str $g-part ) {
  for "{$root}{$m-part.lc}/lib/Gnome/$m-part".IO.dir -> $f {
    next unless $f.Str ~~ m/\.rakumod/;

    my Str $m = "Gnome::{$m-part}::" ~ $f.basename;
    $m ~~ s/\.rakumod//;
    my $g = $m;
    $g ~~ s/ 'Gnome::' $m-part '::' /$g-part/;
    if $g ~~ /RGBA/ {
      $g ~~ s/$g-part/{$g-part}_/;
      $g .= lc;
    }

    elsif $g ~~ /SList/ {
      $g ~~ s/$g-part/{$g-part}_/;
      $g .= lc;
    }

    else {
      $g ~~ s:g/ (<[A..Z]>) /_$0.lc()/;
    }

    $map{$g} = $m;
  }
}

#-------------------------------------------------------------------------------
sub add-deprecated-classes ( ) {
  $map<pango_engine_lang> = 'Deprecated';
  $map<pango_engine_shape> = 'Deprecated';

  $map<gtk_symbolic_color> = 'Deprecated';
  $map<gtk_gradient> = 'Deprecated';
  $map<gtk_hstyle> = 'Deprecated';
  $map<gtk_vstyle> = 'Deprecated';
  $map<gtk_tearoff_menu_item> = 'Deprecated';
  $map<gtk_color_selection> = 'Deprecated';
  $map<gtk_color_selection_dialog> = 'Deprecated';
  $map<gtk_hsv> = 'Deprecated';
  $map<gtk_font_selection> = 'Deprecated';
  $map<gtk_font_selection_dialog> = 'Deprecated';
  $map<gtk_hbox> = 'Deprecated';
  $map<gtk_vbox> = 'Deprecated';
  $map<gtk_hbutton_box> = 'Deprecated';
  $map<gtk_vbutton_box> = 'Deprecated';
  $map<gtk_hpaned> = 'Deprecated';
  $map<gtk_vpaned> = 'Deprecated';
  $map<gtk_table> = 'Deprecated';
  $map<gtk_hseparator> = 'Deprecated';
  $map<gtk_vseparator> = 'Deprecated';
  $map<gtk_hscrollbar> = 'Deprecated';
  $map<gtk_vscrollbar> = 'Deprecated';
  $map<gtk_uimanager> = 'Deprecated';
  $map<gtk_action_group> = 'Deprecated';
  $map<gtk_action> = 'Deprecated';
  $map<gtk_toggle_action> = 'Deprecated';
  $map<gtk_radio_action> = 'Deprecated';
  $map<gtk_recent_action> = 'Deprecated';
  $map<gtk_activatable> = 'Deprecated';
  $map<gtk_image_menu_item> = 'Deprecated';
  $map<gtk_misc> = 'Deprecated';
  $map<gtk_numerable_icon> = 'Deprecated';
  $map<gtk_arrow> = 'Deprecated';
  $map<gtk_status_icon> = 'Deprecated';
  $map<gtk_theming_engine> = 'Deprecated';
  $map<gtk_alignment> = 'Deprecated';
  
  $map<gtk_icon_source> = 'Deprecated';
  $map<gtk_icon_factory> = 'Deprecated';
  $map<gtk_icon_set> = 'Deprecated';
  $map<gtk_icon_size> = 'Deprecated';

#  $map<gtk_> = 'Deprecated';
}