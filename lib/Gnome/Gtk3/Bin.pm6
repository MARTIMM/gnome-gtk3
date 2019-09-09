#TL:1:Gnome::Gtk3::Bin:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::Bin

=head1 Description

The B<Gnome::Gtk3::Bin> widget is a container with just one child.
It is not very useful itself, but it is useful for deriving subclasses,
since it provides common code needed for handling a single child widget.

Many GTK+ widgets are subclasses of B<Gnome::Gtk3::Bin>, including B<Gnome::Gtk3::Window>,
B<Gnome::Gtk3::Button>, B<Gnome::Gtk3::Frame>, B<Gnome::Gtk3::HandleBox> or B<Gnome::Gtk3::ScrolledWindow>.

=head2 Implemented Interfaces
=comment item AtkImplementorIface
=item Gnome::Gtk3::Buildable

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Bin;
  also is Gnome::Gtk3::Container;

=head2 Example

An example using a B<Gnome::Gtk3::Button> which is a direct descendant of B<Gnome::Gtk3::Bin>. Here it is shown that a button is also a kind of a container which in principle can hold anything but by default it holds a label. The widget's name is by default set to its class name. So, a Button has 'GtkButton' and a Label has 'GtkLabel'.

  my Gnome::Gtk3::Button $button .= new(:label('xyz'));
  my Gnome::Gtk3::Widget $w .= new(:widget($button.get-child));
  say $w.get-name; # 'GtkLabel'

=end pod
#-------------------------------------------------------------------------------

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
=begin pod
=head1 Methods
=head2 new

=head3 multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

=begin comment
=head3 multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.
=end comment
=end pod

#TM:1:new():inheriting
#TM:0:new(:widget):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

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

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkBin');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_bin_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  self.set-class-name-of-sub('GtkBin');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:gtk_bin_get_child:
=begin pod
=head2 [gtk_bin_] get_child

Gets the child of the B<Gnome::Gtk3::Bin>, or C<Any> if the bin contains
no child widget. The returned widget does not have a reference
added, so you do not need to unref it.

Returns: (transfer none): pointer to child of the B<Gnome::Gtk3::Bin>

  method gtk_bin_get_child ( --> N-GObject )

=end pod

sub gtk_bin_get_child ( N-GObject $bin )
  returns N-GObject
  is native(&gtk-lib)
  { * }
