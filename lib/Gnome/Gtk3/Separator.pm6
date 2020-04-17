#TL:1:Gnome::Gtk3::Separator:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Separator

A separator widget

![](images/separator.png)

=head1 Description

B<Gnome::Gtk3::Separator> is a horizontal or vertical separator widget, depending on the value of the  I<orientation> property, used to group the widgets within a window. It displays a line with a shadow to make it appear sunken into the interface.

=head2 Css Nodes

B<Gnome::Gtk3::Separator> has a single CSS node with name separator. The node
gets one of the .horizontal or .vertical style classes.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Separator;
  also is Gnome::Gtk3::Widget;

=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Separator;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Separator;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Separator class process the options
    self.bless( :GtkSeparator, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Widget;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Separator:auth<github:MARTIMM>;
also is Gnome::Gtk3::Widget;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new Separator object.

  multi method new ( GtkOrientation :$orientation! )

Create a Separator object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

Create a Separator object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new(:orientation):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Separator' #`{{ or %options<GtkSeparator> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;
      if ? %options<orientation> {
        $no = _gtk_separator_new(%options<orientation>);
      }

      #`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      }}

      ##`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      #}}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = gtk_separator_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkSeparator');
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_separator_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkSeparator');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:1:_gtk_separator_new:new()
#`{{
=begin pod
=head2 gtk_separator_new

Creates a new B<Gnome::Gtk3::Separator> with the given orientation.

Returns: a new B<Gnome::Gtk3::Separator>.

Since: 3.0

  method gtk_separator_new ( GtkOrientation $orientation --> N-GObject )

=item GtkOrientation $orientation; the separator’s orientation.

=end pod
}}

sub _gtk_separator_new ( int32 $orientation --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_separator_new')
  { * }
