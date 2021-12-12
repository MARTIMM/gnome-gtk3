#TL:1:Gnome::Gtk3::Fixed:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Fixed

A container which allows you to position widgets at fixed coordinates

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gtk3::Fixed> widget is a container which can place child widgets  at fixed positions and with fixed sizes, given in pixels. B<Gnome::Gtk3::Fixed> performs no automatic layout management.

For most applications, you should not use this container! It keeps you from having to learn about the other GTK+ containers, but it results in broken applications.  With B<Gnome::Gtk3::Fixed>, the following things will result in truncated text, overlapping widgets, and other display bugs:

=item Themes, which may change widget sizes. *
=item Fonts other than the one you used to write the app will of course *   change the size of widgets containing text; keep in mind that users may use a larger font because of difficulty reading the   default, or they may be using a different OS that provides different fonts.

=item Translation of text into other languages changes its size. Also, *   display of non-English text will use a different font in many cases.

In addition, B<Gnome::Gtk3::Fixed> does not pay attention to text direction and thus may produce unwanted results if your app is run under right-to-left languages such as Hebrew or Arabic. That is: normally GTK+ will order containers appropriately for the text direction, e.g. to put labels to the right of the thing they label when using an RTL language, but it can’t do that with B<Gnome::Gtk3::Fixed>. So if you need to reorder widgets depending on the text direction, you would need to manually detect it and adjust child positions accordingly.

Finally, fixed positioning makes it kind of annoying to add/remove GUI elements, since you have to reposition all the other elements. This is a long-term maintenance problem for your application.

If you know none of these things are an issue for your application, and prefer the simplicity of B<Gnome::Gtk3::Fixed>, by all means use the widget. But you should be aware of the tradeoffs.

See also B<Gnome::Gtk3::Layout>, which shares the ability to perform fixed positioning of child widgets and additionally adds custom drawing and scrollability.


=head2 See Also

B<Gnome::Gtk3::Layout>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Fixed;
  also is Gnome::Gtk3::Container;


=head2 Uml Diagram

![](plantuml/Fixed.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Fixed;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Fixed;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Fixed class process the options
    self.bless( :GtkFixed, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::Gtk3::Container;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Fixed:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::Gtk3::Container;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new Fixed object.

  multi method new ( )

=head3 :native-object

Create a Fixed object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a Fixed object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Fixed' or %options<GtkFixed> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_fixed_new___x___($no);
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

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_fixed_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkFixed');
  }
}

#`{{
#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_fixed_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkFixed');
  $s = callsame unless ?$s;

  $s;
}
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_fixed_new:
#`{{
=begin pod
=head2 _gtk_fixed_new

Creates a new B<Gnome::Gtk3::Fixed>.

Returns: a new B<Gnome::Gtk3::Fixed>.

  method _gtk_fixed_new ( --> N-GObject )

=end pod
}}

sub _gtk_fixed_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_fixed_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:move:
=begin pod
=head2 move

Moves a child of a B<Gnome::Gtk3::Fixed> container to the given position.

  method move ( N-GObject $widget, Int $x, Int $y )

=item N-GObject $widget; the child widget.
=item Int $x; the horizontal position to move the widget to.
=item Int $y; the vertical position to move the widget to.

=end pod

method move ( $widget, Int $x, Int $y ) {
  my $no = $widget;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
  gtk_fixed_move( self.get-native-object-no-reffing, $no, $x, $y);
}

sub gtk_fixed_move ( N-GObject $fixed, N-GObject $widget, gint $x, gint $y  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:put:
=begin pod
=head2 put

Adds a widget to a B<Gnome::Gtk3::Fixed> container at the given position.

  method put ( N-GObject $widget, Int $x, Int $y )

=item N-GObject $widget; the widget to add.
=item Int $x; the horizontal position to place the widget at.
=item Int $y; the vertical position to place the widget at.

=end pod

method put ( $widget, Int $x, Int $y ) {
  my $no = $widget;
  $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
  gtk_fixed_put( self.get-native-object-no-reffing, $no, $x, $y);
}

sub gtk_fixed_put ( N-GObject $fixed, N-GObject $widget, gint $x, gint $y  )
  is native(&gtk-lib)
  { * }
