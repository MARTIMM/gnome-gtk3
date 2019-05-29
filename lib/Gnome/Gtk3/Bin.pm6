use v6;
# ==============================================================================
=begin pod

=TITLE Gnome::Gtk3::Bin

=SUBTITLE

  unit class Gnome::Gtk3::Bin;
  also is Gnome::Gtk3::Container;

=head2 Bin — A container with just one child

=head1 Synopsis

The module GtkBin is not used directly but its methods can be used by its child modules. Below is an example using a C<GtkButton> which is a direct descendant of C<GtkBin>. Here it is also clear that a button is also a container which in principle can hold anything but by default it holds a label. The method C<gtk-container-add()> comes from C<GtkContainer> and C<get-child()> comes from C<GtkBin>.

  my Gnome::Gtk3::Label $label .= new(:label<pqr>);
  my Gnome::Gtk3::Button $button .= new(:empty);
  $button.gtk-container-add($label);

  $l($button2.get-child);
  is $l.get-text, 'pqr', 'text label from button 2';

Of course, it is easier to do the next

  my Gnome::Gtk3::Button $button .= new(:label<pqr>);

=end pod
# ==============================================================================

use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
#use Gnome::GObject::Object;
use Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkbin.h
# https://developer.gnome.org/gtk3/stable/GtkBin.html
unit class Gnome::Gtk3::Bin:auth<github:MARTIMM>;
also is Gnome::Gtk3::Container;

# ==============================================================================
=begin pod

=head1 Methods

=head2 [gtk_bin_] get_child

  method gtk_bin_get_child ( --> N-GObject )

Gets the child of the GtkBin, or C<Any> if the bin contains no child widget.
=end pod
sub gtk_bin_get_child ( N-GObject $bin )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Bin';

  if ? %options<widget> || %options<build-id> {
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
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_bin_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
