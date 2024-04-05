#TL:1:Gnome::Gtk3::ColorChooserWidget:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ColorChooserWidget

A widget for choosing colors

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gtk3::ColorChooserWidget> widget lets the user select a color. By default, the chooser presents a predefined palette of colors, plus a small number of settable custom colors. It is also possible to select a different color with the single-color editor. To enter the single-color editing mode, use the context menu of any color of the palette, or use the '+' button to add a new custom color.

The chooser automatically remembers the last selection, as well as custom colors.

To change the initially selected color, use C<gtk_color_chooser_set_rgba()>. To get the selected color use C<gtk_color_chooser_get_rgba()>.

The B<Gnome::Gtk3::ColorChooserWidget> is used in the B<Gnome::Gtk3::ColorChooserDialog> to provide a dialog for selecting colors.


=head2 CSS names

B<Gnome::Gtk3::ColorChooserWidget> has a single CSS node with name colorchooser.


=head2 See Also

B<Gnome::Gtk3::ColorChooserDialog>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::ColorChooserWidget;
  also is Gnome::Gtk3::Box;
  also does Gnome::Gtk3::ColorChooser;


=head2 Uml Diagram

![](plantuml/ColorChooserWidget.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::ColorChooserWidget:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::ColorChooserWidget;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::ColorChooserWidget class process the options
    self.bless( :GtkColorChooserWidget, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gtk3::Box:api<1>;
use Gnome::Gtk3::Buildable:api<1>;
use Gnome::Gtk3::Orientable:api<1>;
use Gnome::Gtk3::ColorChooser:api<1>;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::ColorChooserWidget:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Box;
also does Gnome::Gtk3::ColorChooser;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new ColorChooserWidget object.

  multi method new ( )


=head3 :native-object

Create a ColorChooserWidget object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a ColorChooserWidget object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )


=end pod

#TM:1:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  unless $signals-added {
    # no signals of its own
    $signals-added = True;

    # signals from interfaces
    self._add_color_chooser_signal_types($?CLASS.^name);
  }

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ColorChooserWidget' or %options<GtkColorChooserWidget> {

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
        #$no = _gtk_color_chooser_widget_new___x___($no);
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
        $no = _gtk_color_chooser_widget_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkColorChooserWidget');
  }
}

#-------------------------------------------------------------------------------
#TM:1:_gtk_color_chooser_widget_new:
#`{{
=begin pod
=head2 _gtk_color_chooser_widget_new

Creates a new B<Gnome::Gtk3::ColorChooserWidget>.

Returns: a new B<Gnome::Gtk3::ColorChooserWidget>

  method _gtk_color_chooser_widget_new ( --> N-GObject )

=end pod
}}

sub _gtk_color_chooser_widget_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_color_chooser_widget_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:1:show-editor:
=head2 show-editor

Show editor

=item B<Gnome::GObject::Value> type of this property is G_TYPE_BOOLEAN
=item Parameter is readable and writable.
=item Default value is FALSE.

=end pod








=finish
#-------------------------------------------------------------------------------
#TM:2:gtk_color_chooser_widget_new:new()
=begin pod
=head2 [gtk_] color_chooser_widget_new

Creates a new B<Gnome::Gtk3::ColorChooserWidget>.

Returns: a new B<Gnome::Gtk3::ColorChooserWidget>

Since: 3.4

  method gtk_color_chooser_widget_new ( --> N-GObject )

=end pod

sub gtk_color_chooser_widget_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TODO Must add type info
=begin pod
=head1 Properties

An example of using a string type property of a C<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:show-editor:
=head3 Show editor

The I<show-editor> property is C<1> when the color chooser
is showing the single-color editor. It can be set to switch
the color chooser into single-color editing mode.
Since: 3.4

The B<Gnome::GObject::Value> type of property I<show-editor> is C<G_TYPE_BOOLEAN>.

=end pod
