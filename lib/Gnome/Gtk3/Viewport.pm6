#TL:1:Gnome::Gtk3::Viewport:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Viewport

An adapter which makes widgets scrollable

=comment ![](images/X.png)

=head1 Description


The B<Gnome::Gtk3::Viewport> widget acts as an adaptor class, implementing scrollability for child widgets that lack their own scrolling capabilities. Use GtkViewport to scroll child widgets such as B<Gnome::Gtk3::Grid>, B<Gnome::Gtk3::Box>, and so on.

If a widget has native scrolling abilities, such as B<Gnome::Gtk3::TextView>, B<Gnome::Gtk3::TreeView> or B<Gnome::Gtk3::IconView>, it can be added to a B<Gnome::Gtk3::ScrolledWindow> with C<gtk-container-add()>. If a widget does not, you must first add the widget to a B<Gnome::Gtk3::Viewport>, then add the viewport to the scrolled window. C<gtk-container-add()> does this automatically if a child that does not implement B<Gnome::Gtk3::Scrollable> is added to a B<Gnome::Gtk3::ScrolledWindow>, so you can ignore the presence of the viewport.

The GtkViewport will start scrolling content only if allocated less than the child widget’s minimum size in a given orientation.


=head2 Css Nodes

The B<Gnome::Gtk3::Viewport> has a single CSS node with name viewport.


=head2 See Also

B<Gnome::Gtk3::ScrolledWindow>, B<Gnome::Gtk3::Adjustment>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Viewport;
  also is Gnome::Gtk3::Bin;
  also does Gnome::Gtk3::Scrollable;


=head2 Uml Diagram

![](plantuml/Viewport.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Viewport;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Viewport;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Viewport class process the options
    self.bless( :GtkViewport, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::Bin;
use Gnome::Gtk3::Enums;
use Gnome::Gtk3::Scrollable;

use Gnome::Gdk3::Window;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Viewport:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::Gtk3::Bin;
also does Gnome::Gtk3::Scrollable;

#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 :hadjustment, :vadjustment

Create a new Viewport object using horizontal and vertical adjustments. The adjustment is of type B<Gnome::Gtk3::Adjustment>.

  multi method new ( N-GObject $hadjustment!, N-GObject $vadjustment! )


=head3 :native-object

Create a Viewport object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a Viewport object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod
#TM:1:new():inheriting
#TM:1:new(:hadjustment,:vadjustment):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Viewport' or %options<GtkViewport> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<hadjustment> and ? %options<vadjustment> {
        my $no-h = %options<hadjustment>;
        $no-h .= get-native-object-no-reffing unless $no-h ~~ N-GObject;
        my $no-v = %options<vadjustment>;
        $no-v .= get-native-object-no-reffing unless $no-v ~~ N-GObject;
        $no = _gtk_viewport_new( $no-h, $no-v);
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
        $no = _gtk_viewport_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkViewport');
  }
}


#-------------------------------------------------------------------------------
#TM:1:get-bin-window:
#TM:1:get-bin-window-rk:
=begin pod
=head2 get-bin-window, get-bin-window-rk

Gets the bin window of the B<Gnome::Gtk3::Viewport>.

  method get-bin-window ( --> N-GObject )
  method get-bin-window-rk ( --> Gnome::Gdk3::Window )

=end pod

method get-bin-window ( --> N-GObject ) {
  gtk_viewport_get_bin_window(self.get-native-object-no-reffing)
}

method get-bin-window-rk ( --> Gnome::Gdk3::Window ) {
  Gnome::Gdk3::Window.new(
    :native-object(
      gtk_viewport_get_bin_window(self.get-native-object-no-reffing)
    )
  )
}

sub gtk_viewport_get_bin_window (
  N-GObject $viewport --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-shadow-type:
=begin pod
=head2 get-shadow-type

Gets the shadow type of the B<Gnome::Gtk3::Viewport>. See C<set-shadow-type()>.

  method get-shadow-type ( --> GtkShadowType )

=end pod

method get-shadow-type ( --> GtkShadowType ) {
  GtkShadowType(
    gtk_viewport_get_shadow_type(self.get-native-object-no-reffing)
  )
}

sub gtk_viewport_get_shadow_type (
  N-GObject $viewport --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-view-window:
#TM:1:get-view-window-rk:
=begin pod
=head2 get-view-window, get-view-window-rk

Gets the view window of the B<Gnome::Gtk3::Viewport>.

  method get-view-window ( --> N-GObject )
  method get-view-window-rk ( --> Gnome::Gdk3::Window )

=end pod

method get-view-window ( --> N-GObject ) {
  gtk_viewport_get_view_window(self.get-native-object-no-reffing)
}

method get-view-window-rk ( --> Gnome::Gdk3::Window ) {
  Gnome::Gdk3::Window.new(
    :native-object(
      gtk_viewport_get_view_window(self.get-native-object-no-reffing)
    )
  )
}

sub gtk_viewport_get_view_window (
  N-GObject $viewport --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-shadow-type:
=begin pod
=head2 set-shadow-type

Sets the shadow type of the viewport.

  method set-shadow-type ( GtkShadowType $type )

=item GtkShadowType $type; the new shadow type.
=end pod

method set-shadow-type ( GtkShadowType $type ) {
  gtk_viewport_set_shadow_type(
    self.get-native-object-no-reffing, $type
  );
}

sub gtk_viewport_set_shadow_type (
  N-GObject $viewport, GEnum $type
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_viewport_new:
#`{{
=begin pod
=head2 _gtk_viewport_new

Creates a new B<Gnome::Gtk3::Viewport> with the given adjustments, or with default adjustments if none are given.

Returns: a new B<Gnome::Gtk3::Viewport>

  method _gtk_viewport_new ( N-GObject $hadjustment, N-GObject $vadjustment --> N-GObject )

=item N-GObject $hadjustment; horizontal adjustment
=item N-GObject $vadjustment; vertical adjustment
=end pod
}}

sub _gtk_viewport_new ( N-GObject $hadjustment, N-GObject $vadjustment --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_viewport_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:0:shadow-type:
=head3 Shadow type: shadow-type

Determines how the shadowed box around the viewport is drawn
Default value: False

The B<Gnome::GObject::Value> type of property I<shadow-type> is C<G_TYPE_ENUM>.
=end pod
