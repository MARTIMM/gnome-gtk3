#TL:1:Gnome::Gtk3::ActionBar:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ActionBar

A full width bar for presenting contextual actions


![](images/action-bar.png)


=head1 Description

B<Gnome::Gtk3::ActionBar> is designed to present contextual actions. It is expected to be displayed below the content and expand horizontally to fill the area.

It allows placing children at the start or the end. In addition, it contains an internal centered box which is centered with respect to the full width of the box, even if the children at either side take up different amounts of space.


=head2 Css Nodes B<Gnome::Gtk3::ActionBar> has a single CSS node with name actionbar.


=head2 See Also

B<Gnome::Gtk3::Box>


=head1 Synopsis

=head2 Declaration

  unit class Gnome::Gtk3::ActionBar;
  also is Gnome::Gtk3::Bin;


=head2 Uml Diagram

![](plantuml/ActionBar.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::ActionBar:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::ActionBar;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::ActionBar class process the options
    self.bless( :GtkActionBar, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;
use Gnome::Gtk3::Bin:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::ActionBar:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Bin;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new ActionBar object.

  multi method new ( )

=head3 :native-object

Create a ActionBar object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a ActionBar object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ActionBar' or %options<GtkActionBar> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_action_bar_new___x___($no);
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
        $no = _gtk_action_bar_new();
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkActionBar');
  }
}


#-------------------------------------------------------------------------------
#TM:1:get-center-widget:
=begin pod
=head2 get-center-widget

Retrieves the center bar widget of the bar or C<undefined>.

  method get-center-widget ( --> N-GObject )

=end pod

method get-center-widget ( --> N-GObject ) {
  gtk_action_bar_get_center_widget(self._get-native-object-no-reffing)
}

method get-center-widget-rk ( --> Any ) {
  Gnome::N::deprecate(
    'get-center-widget-rk', 'coercing from get-center-widget',
    '0.47.2', '0.50.0'
  );

  my $no = gtk_action_bar_get_center_widget(self._get-native-object-no-reffing);
  if ?$no {
    self._wrap-native-type-from-no($no)
  }

  else {
    Gnome::Gtk3::Widget.new(:native-object(N-GObject))
  }
}

sub gtk_action_bar_get_center_widget (
  N-GObject $action_bar --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:pack-end:
=begin pod
=head2 pack-end

Adds I<child> to I<action-bar>, packed with reference to the end of the I<action-bar>.

  method pack-end ( N-GObject() $child )

=item $child; the B<Gnome::Gtk3::Widget> to be added to I<action-bar>
=end pod

method pack-end ( N-GObject() $child ) {
  gtk_action_bar_pack_end( self._get-native-object-no-reffing, $child);
}

sub gtk_action_bar_pack_end (
  N-GObject $action_bar, N-GObject $child
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:pack-start:
=begin pod
=head2 pack-start

Adds I<child> to I<action-bar>, packed with reference to the start of the I<action-bar>.

  method pack-start ( N-GObject() $child )

=item $child; the B<Gnome::Gtk3::Widget> to be added to I<action-bar>
=end pod

method pack-start ( N-GObject() $child ) {
  gtk_action_bar_pack_start( self._get-native-object-no-reffing, $child);
}

sub gtk_action_bar_pack_start (
  N-GObject $action_bar, N-GObject $child
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-center-widget:
=begin pod
=head2 set-center-widget

Sets the center widget for the B<Gnome::Gtk3::ActionBar>.

  method set-center-widget ( N-GObject() $center_widget )

=item $center_widget; a widget to use for the center
=end pod

method set-center-widget ( N-GObject() $center_widget ) {
  gtk_action_bar_set_center_widget(
    self._get-native-object-no-reffing, $center_widget
  );
}

sub gtk_action_bar_set_center_widget (
  N-GObject $action_bar, N-GObject $center_widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_action_bar_new:
#`{{
=begin pod
=head2 _gtk_action_bar_new

Creates a new B<Gnome::Gtk3::ActionBar> widget.

Returns: a new B<Gnome::Gtk3::ActionBar>

  method _gtk_action_bar_new ( --> N-GObject )

=end pod
}}

sub _gtk_action_bar_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_action_bar_new')
  { * }
