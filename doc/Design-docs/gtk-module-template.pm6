use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::LIBRARY::MODULE

=SUBTITLE

  unit class Gnome::LIBRARY::MODULE;
  also is Gnome::LIBRARY::PARENT;

=head1 Synopsis


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::X;
use Gnome::N::NativeLib;
#use Gnome::N::N-GObject;
#use Gnome::Glib::GObject;
use Gnome::LIBRARY::PARENT;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::LIBRARY::MODULE:auth<github:MARTIMM>;
also is Gnome::LIBRARY::PARENT;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

...

  multi method new ( :$widget! )

Create an object using a native object from elsewhere. See also Gtk::V3::Glib::GObject.

  multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also Gtk::V3::Glib::GObject.

=end pod

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    ... :type<signame>
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::LIBRARY::MODULE';

  if ? %options<empty> {
    # ... self.native-gobject(gtk__dialog_new());
  }

  elsif ? %options<widget> || %options<build-id> {
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
  # ... try { $s = &::("gtk__dialog_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk__new

Creates a new native ...

  method gtk__new ( --> N-GObject )

Returns a native widget. It is not advised to use it. The new()/BUILD() method can handle this better and easier.

=end pod

sub gtk__new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2

  method  (  -->  )

=item

Returns

=end pod

sub  ( N-GObject   )
  returns
  is native(&gtk-lib)
  { * }

#`{{
sub  ( N-GObject )
  returns
  is native(&gdk-lib)
  { * }

sub  ( N-GObject )
  returns
  is native(&g-lib)
  { * }



  is symbol('')
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2

=item

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

=head2 Supported signals
=head3

=head2 Unsupported signals
=head3


=head2 Not yet supported signals
=head3




=head4 Signal Handler Signature

  method handler (
    Gnome::Glib::GObject :$widget, :$user-option1, ..., $user-optionN
  )

=head4 Event Handler Signature

  method handler (
    Gnome::Glib::GObject :$widget, GdkEvent :$event,
    :$user-option1, ..., $user-optionN
  )

=head4 Native Object Handler Signature

  method handler (
    Gnome::Glib::GObject :$widget, N-GObject :$nativewidget,
    :$user-option1, ..., :$user-optionN
  )

=head2 Handler Method Arguments
=item $widget; This can be any perl6 widget with C<Gnome::Glib::GObject> as the top parent class e.g. C<Gnome::Gtk::GtkButton>.
=item $event; A structure defined in C<Gnome::Gdk::GdkEventTypes>.
=item $nativewidget; A native widget which can be turned into a perl6 widget using C<.new(:widget())> on the appropriate class.
=item $user-option*; Any extra options given by the user when registering the signal.



=end pod
