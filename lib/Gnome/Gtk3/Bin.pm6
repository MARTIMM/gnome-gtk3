use v6;
# ==============================================================================
=begin pod

=TITLE Gnome::Gtk3::Bin

=SUBTITLE A container with just one child

=head1 Description

The C<Gnome::Gtk3::Bin> widget is a container with just one child.
It is not very useful itself, but it is useful for deriving subclasses,
since it provides common code needed for handling a single child widget.

Many GTK+ widgets are subclasses of C<Gnome::Gtk3::Bin>, including C<Gnome::Gtk3::Window>,
C<Gnome::Gtk3::Button>, C<Gnome::Gtk3::Frame>, C<Gnome::Gtk3::HandleBox> or C<Gnome::Gtk3::ScrolledWindow>.


=head1 Synopsis
=head2 Declaration

unit class Gnome::Gtk3::Bin;
also is Gnome::Gtk3::Container;

=head2 Example

An example using a C<Gnome::Gtk3::Button> which is a direct descendant of C<Gnome::Gtk3::Bin>. Here it is shown that a button is also a kind of a container which in principle can hold anything but by default it holds a label. The method C<gtk-container-add()> comes from C<Gnome::Gtk3::Container> and C<get-child()> comes from C<Gnome::Gtk3::Bin>.

  my Gnome::Gtk3::Label $label .= new(:label<pqr>);
  my Gnome::Gtk3::Button $button .= new(:empty);
  $button.gtk-container-add($label);

Of course, it is much easier to do the next

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

#-------------------------------------------------------------------------------
#my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

  multi method new ( Gnome::GObject::Object :$widget! )

Create an object using a native object from elsewhere. See also C<Gnome::GObject::Object>.

=begin comment
  multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also C<Gnome::GObject::Object>.
=end comment
=end pod

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  #$signals-added = self.add-signal-types( $?CLASS.^name,
  #  # ... :type<signame>
  #) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Bin';

  # process all named arguments
  if ? %options<widget> { # || %options<build-id> {
    # provided in Gnome::GObject::Object
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
  try { $s = &::("gtk_bin_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod

=head2 [gtk_bin_] get_child

Gets the child of the C<Gnome::Gtk3::Bin>, or C<Any> if the bin contains
no child widget. The returned widget does not have a reference
added, so you do not need to unref it.

Returns: (transfer none): pointer to child of the C<Gnome::Gtk3::Bin>

  method gtk_bin_get_child ( --> N-GObject )
=end pod

sub gtk_bin_get_child ( N-GObject $bin )
  returns N-GObject
  is native(&gtk-lib)
  { * }
