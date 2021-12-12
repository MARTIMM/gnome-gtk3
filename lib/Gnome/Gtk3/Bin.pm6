#TL:1:Gnome::Gtk3::Bin:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Bin

A container with just one child

=head1 Description

The B<Gnome::Gtk3::Bin> widget is a container with just one child. It is not very useful itself, but it is useful for deriving subclasses, since it provides common code needed for handling a single child widget.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Bin;
  also is Gnome::Gtk3::Container;


=head2 Uml Diagram

![](plantuml/Bin.svg)


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
=head3 :native-object

Create a Grid object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a Grid object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new(:native-object):
#TM:0:new(:build-id):
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  if self.^name eq 'Gnome::Gtk3::Bin' #`{{or %options<GtkBin>}} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    elsif %options.keys.elems {
      die X::Gnome.new(
        :message('Unsupported options for ' ~ self.^name ~
                 ': ' ~ %options.keys.join(', ')
                )
      );
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkBin');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_bin_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

#note "ad $native-sub: ", $s;
  self._set-class-name-of-sub('GtkBin');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:get_child:
#TM:1:get_child-rk:
=begin pod
=head2 get_child, get_child-rk

Gets the child of the B<Gnome::Gtk3::Bin>, or C<Any> if the bin contains no child widget. The returned widget does not have a reference added, so you do not need to unref it.

Returns: The child of the B<Gnome::Gtk3::Bin>;

  method get-child ( --> N-GObject )
  method get-child-rk ( --> Gnome::GObject::Object )

=end pod

method get-child ( --> N-GObject ) {
  gtk_bin_get_child(self.get-native-object-no-reffing);
}

method get-child-rk ( *%options --> Gnome::GObject::Object ) {
  my $o = self._wrap-native-type-from-no(
    gtk_bin_get_child(self.get-native-object-no-reffing),
    |%options
  );

  $o ~~ N-GObject ?? Gnome::GObject::Widget.new(:native-object($o)) !! $o
}

sub gtk_bin_get_child ( N-GObject $bin )
  returns N-GObject
  is native(&gtk-lib)
  { * }
