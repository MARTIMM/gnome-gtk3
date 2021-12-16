#TL:1:Gnome::Gtk3::Targets:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Targets

=comment ![](images/X.png)

=head1 Description

This module is mainly used to check out targets for its capabilities.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Targets;

=comment head2 Uml Diagram

=comment ![](plantuml/.svg)

=head2 Example

  my Gnome::Gtk3::Targets $t .= new;
  my Array $targets = [
    Gnome::Gdk3::Atom.new(:intern<text/plain>),
    Gnome::Gdk3::Atom.new(:intern<image/bmp>),
  ];

  if $t.include-image( $targets, True) {
    … we can handle an image …
  }

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Targets:auth<github:MARTIMM>:ver<0.1.0>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new Targets object.

  multi method new ( )

=end pod

#TM:1:new():

#-------------------------------------------------------------------------------
#TM:1:include-image:
=begin pod
=head2 include-image

Determines if any of the targets in I<targets> can be used to provide a B<Gnome::Gtk3::Pixbuf>.

Returns: C<True> if I<targets> include a suitable target for images, otherwise C<False>.

  method include-image ( Array $targets, Bool $writable --> Bool )

=item Array $targets; an array of B<Gnome::Gtk3::Atoms>
=item Bool $writable; whether to accept only targets for which GTK+ knows how to convert a pixbuf into the format
=end pod

method include-image ( Array $targets, Bool $writable --> Bool ) {

  my $tes = CArray[N-GObject].new;
  my Int $i = 0;
  for @$targets -> $t {
    $tes[$i++] = $t ~~ N-GObject ?? $t !! $t._get-native-object-no-reffing;
  }

  gtk_targets_include_image( $tes, $targets.elems, $writable).Bool
}

sub gtk_targets_include_image (
  CArray[N-GObject] $targets, gint $n_targets, gboolean $writable --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:include-rich-text:
=begin pod
=head2 include-rich-text

Determines if any of the targets in I<$targets> can be used to provide rich text.

Returns: C<True> if I<targets> include a suitable target for rich text, otherwise C<False>.

  method include-rich-text ( Array $targets, N-GObject $buffer --> Bool )

=item Array $targets; an array of B<Gnome::Gtk3::Atoms>
=item N-GObject $buffer; a B<Gnome::Gtk3::TextBuffer>
=end pod

method include-rich-text ( Array $targets, $buffer is copy --> Bool ) {
  $buffer .= _get-native-object-no-reffing unless $buffer ~~ N-GObject;

  my $tes = CArray[N-GObject].new;
  my Int $i = 0;
  for @$targets -> $t {
    $tes[$i++] = $t ~~ N-GObject ?? $t !! $t._get-native-object-no-reffing;
  }

  gtk_targets_include_rich_text( $tes, $targets.elems, $buffer).Bool
}

sub gtk_targets_include_rich_text (
  CArray[N-GObject] $targets, gint $n_targets, N-GObject $buffer --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:include-text:
=begin pod
=head2 include-text

Determines if any of the targets in I<targets> can be used to provide text.

Returns: C<True> if I<targets> include a suitable target for text, otherwise C<False>.

  method include-text ( Array $targets --> Bool )

=item Array $targets; an array of B<Gnome::Gtk3::Atoms>
=end pod

method include-text ( Array $targets --> Bool ) {

  my $tes = CArray[N-GObject].new;
  my Int $i = 0;
  for @$targets -> $t {
    $tes[$i++] = $t ~~ N-GObject ?? $t !! $t._get-native-object-no-reffing;
  }

  gtk_targets_include_text( $tes, $targets.elems).Bool
}

sub gtk_targets_include_text (
  CArray[N-GObject] $targets, gint $n_targets --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:include-uri:
=begin pod
=head2 include-uri

Determines if any of the targets in I<targets> can be used to provide an uri list.

Returns: C<True> if I<targets> include a suitable target for uri lists, otherwise C<False>.

  method include-uri ( Array $targets --> Bool )

=item Array $targets; an array of B<Gnome::Gtk3::Atoms>
=end pod

method include-uri ( Array $targets --> Bool ) {

  my $tes = CArray[N-GObject].new;
  my Int $i = 0;
  for @$targets -> $t {
    $tes[$i++] = $t ~~ N-GObject ?? $t !! $t._get-native-object-no-reffing;
  }

  gtk_targets_include_uri( $tes, $targets.elems).Bool
}

sub gtk_targets_include_uri (
  CArray[N-GObject] $targets, gint $n_targets --> gboolean
) is native(&gtk-lib)
  { * }
