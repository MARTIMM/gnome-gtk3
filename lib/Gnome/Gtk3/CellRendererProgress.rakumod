#TL:1:Gnome::Gtk3::CellRendererProgress:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellRendererProgress

Renders numbers as progress bars


=head1 Description

B<Gnome::Gtk3::CellRendererProgress> renders a numeric value as a progress par in a cell. Additionally, it can display a text on top of the progress bar.

The B<Gnome::Gtk3::CellRendererProgress> cell renderer was added in GTK+ 2.6.


=head2 Implemented Interfaces

Gnome::Gtk3::CellRendererProgress implements
=comment item [Gnome::Gtk3::Orientable](Orientable.html)


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRendererProgress;
  also is Gnome::Gtk3::CellRenderer;
  also does Gnome::Gtk3::Orientable;


=head2 Uml Diagram

![](plantuml/CellRenderer-ea.svg)

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::Gtk3::CellRenderer:api<1>;
use Gnome::Gtk3::Orientable:api<1>;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::CellRendererProgress:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::CellRenderer;
also does Gnome::Gtk3::Orientable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new CellRendererProgress object.

  multi method new ( )


=head3 :native-object

Create a CellRendererProgress object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a CellRendererProgress object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {
  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::CellRendererProgress' #`{{ or %options<GtkCellRendererProgress> }} {

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
        #$no = _gtk_cell_renderer_progress_new___x___($no);
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
        $no = _gtk_cell_renderer_progress_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkCellRendererProgress');
  }
}


#-------------------------------------------------------------------------------
#TM:1:_gtk_cell_renderer_progress_new:
#`{{
=begin pod
=head2 _gtk_cell_renderer_progress_new

Creates a new B<Gnome::Gtk3::CellRendererProgress>.

Returns: the new cell renderer

  method _gtk_cell_renderer_progress_new ( --> N-GObject )

=end pod
}}

sub _gtk_cell_renderer_progress_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_cell_renderer_progress_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:1:inverted:
=head2 inverted

Invert the direction in which the progress bar grows

The B<Gnome::GObject::Value> type of property I<inverted> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is FALSE.


=comment -----------------------------------------------------------------------
=comment #TP:1:pulse:
=head2 pulse

Set this to positive values to indicate that some progress is made, but you don't know how much.

The B<Gnome::GObject::Value> type of property I<pulse> is C<G_TYPE_INT>.

=item Parameter is readable and writable.
=item Minimum value is -1.
=item Maximum value is G_MAXINT.
=item Default value is -1.


=comment -----------------------------------------------------------------------
=comment #TP:1:text:
=head2 text

Text on the progress bar

The B<Gnome::GObject::Value> type of property I<text> is C<G_TYPE_STRING>.

=item Parameter is readable and writable.
=item Default value is undefined.


=comment -----------------------------------------------------------------------
=comment #TP:1:text-xalign:
=head2 text-xalign

The horizontal text alignment, from 0 (left to 1 (right). Reversed for RTL layouts.)

The B<Gnome::GObject::Value> type of property I<text-xalign> is C<G_TYPE_FLOAT>.

=item Parameter is readable and writable.
=item Minimum value is 0.0.
=item Maximum value is 1.0.
=item Default value is 0.5.


=comment -----------------------------------------------------------------------
=comment #TP:1:text-yalign:
=head2 text-yalign

The vertical text alignment, from 0 (top to 1 (bottom).)

The B<Gnome::GObject::Value> type of property I<text-yalign> is C<G_TYPE_FLOAT>.

=item Parameter is readable and writable.
=item Minimum value is 0.0.
=item Maximum value is 1.0.
=item Default value is 0.5.


=comment -----------------------------------------------------------------------
=comment #TP:1:value:
=head2 value

Value of the progress bar

The B<Gnome::GObject::Value> type of property I<value> is C<G_TYPE_INT>.

=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is 100.
=item Default value is 0.

=end pod
