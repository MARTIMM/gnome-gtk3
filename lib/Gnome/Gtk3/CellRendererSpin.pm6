#TL:1:Gnome::Gtk3::CellRendererSpin:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellRendererSpin

Renders a spin button in a cell

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::CellRendererSpin> renders text in a cell like B<Gnome::Gtk3::CellRendererText> from which it is derived. But while B<Gnome::Gtk3::CellRendererText> offers a simple entry to edit the text, B<Gnome::Gtk3::CellRendererSpin> offers a B<Gnome::Gtk3::SpinButton> widget. Of course, that means that the text has to be parseable as a floating point number.

The range of the spinbutton is taken from the I<adjustment> property of the cell renderer, which can be set explicitly or mapped to a column in the tree model, like all properties of cell renders. B<Gnome::Gtk3::CellRendererSpin> also has properties for the  I<climb-rate> and the number of  I<digits> to display. Other B<Gnome::Gtk3::SpinButton> properties can be set in a handler for the  I<editing-started> signal.

The B<Gnome::Gtk3::CellRendererSpin> cell renderer was added in GTK+ 2.10.


=head2 See Also

B<Gnome::Gtk3::CellRendererText>, B<Gnome::Gtk3::SpinButton>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRendererSpin;
  also is Gnome::Gtk3::CellRendererText;


=head2 Uml Diagram

![](plantuml/CellRenderer-ea.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::CellRendererSpin;

  unit class MyGuiClass;
  also is Gnome::Gtk3::CellRendererSpin;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::CellRendererSpin class process the options
    self.bless( :GtkCellRendererSpin, |c);
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
use Gnome::Gtk3::CellRendererText;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::CellRendererSpin:auth<github:MARTIMM>;
also is Gnome::Gtk3::CellRendererText;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new CellRendererSpin object.

  multi method new ( )


=head3 :native-object

Create a CellRendererSpin object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a CellRendererSpin object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {
  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::CellRendererSpin' #`{{ or %options<GtkCellRendererSpin> }} {

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
        #$no = _gtk_cell_renderer_spin_new___x___($no);
      }

      ##`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      #}}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_cell_renderer_spin_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkCellRendererSpin');
  }
}

#-------------------------------------------------------------------------------
#TM:1:_gtk_cell_renderer_spin_new:
#`{{
=begin pod
=head2 _gtk_cell_renderer_spin_new

Creates a new B<Gnome::Gtk3::CellRendererSpin>.

Returns: a new B<Gnome::Gtk3::CellRendererSpin>

  method _gtk_cell_renderer_spin_new ( --> N-GObject )

=end pod
}}

sub _gtk_cell_renderer_spin_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_cell_renderer_spin_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:1:adjustment:
=head2 adjustment

The adjustment that holds the value of the spin button

The B<Gnome::GObject::Value> type of property I<adjustment> is C<G_TYPE_OBJECT>.

=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:1:climb-rate:
=head2 climb-rate

The acceleration rate when you hold down a button

The B<Gnome::GObject::Value> type of property I<climb-rate> is C<G_TYPE_DOUBLE>.

=item Parameter is readable and writable.
=item Minimum value is 0.0.
=item Maximum value is G_MAXDOUBLE.
=item Default value is 0.0.


=comment -----------------------------------------------------------------------
=comment #TP:1:digits:
=head2 digits

The number of decimal places to display

The B<Gnome::GObject::Value> type of property I<digits> is C<G_TYPE_UINT>.

=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is 20.
=item Default value is 0.

=end pod
