#TL:1:Gnome::Gtk3::CellRendererCombo:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CellRendererCombo

Renders a combobox in a cell

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::CellRendererCombo> renders text in a cell like B<Gnome::Gtk3::CellRendererText> from which it is derived. But while B<Gnome::Gtk3::CellRendererText> offers a simple entry to edit the text, B<Gnome::Gtk3::CellRendererCombo> offers a B<Gnome::Gtk3::ComboBox> widget to edit the text. The values to display in the combo box are taken from the tree model specified in the  I<model> property.

The combo cell renderer takes care of adding a text cell renderer to the combo box and sets it to display the column specified by its I<text-column> property. Further properties of the combo box can be set in a handler for the  I<editing-started> signal.

The B<Gnome::Gtk3::CellRendererCombo> cell renderer was added in GTK+ 2.6.

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRendererCombo;
  also is Gnome::Gtk3::CellRendererText;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::CellRendererText;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::CellRendererCombo:auth<github:MARTIMM>;
also is Gnome::Gtk3::CellRendererText;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

Create a new plain object.

  multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new(:empty):
#TM:0:new(:widget):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w2<changed>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::CellRendererCombo';

  # process all named arguments
  if ? %options<empty> {
    self.native-gobject(gtk_cell_renderer_combo_new());
  }

  elsif ? %options<widget> || %options<build-id> {
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
  self.set-class-info('GtkCellRendererCombo');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_cell_renderer_combo_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkCellRendererCombo');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_cell_renderer_combo_new:new(:empty)
=begin pod
=head2 gtk_cell_renderer_combo_new

Creates a new B<Gnome::Gtk3::CellRendererCombo>. Adjust how text is drawn using object properties. Object properties can be set globally (with C<g_object_set()>). Also, with B<Gnome::Gtk3::TreeViewColumn>, you can bind a property to a value in a B<Gnome::Gtk3::TreeModel>. For example, you can bind the “text” property on the cell renderer to a string value in the model, thus rendering a different string in each row of the B<Gnome::Gtk3::TreeView>.

Returns: the new cell renderer

Since: 2.6

  method gtk_cell_renderer_combo_new ( --> N-GObject  )

=end pod

sub gtk_cell_renderer_combo_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<g_signal_connect_object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<g_signal_connect_object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment #TS:0:changed:
=head3 changed

This signal is emitted each time after the user selected an item in
the combo box, either by using the mouse or the arrow keys.  Contrary
to B<Gnome::Gtk3::ComboBox>, B<Gnome::Gtk3::CellRendererCombo>::changed is not emitted for
changes made to a selected item in the entry.  The argument I<new_iter>
corresponds to the newly selected item in the combo box and it is relative
to the B<Gnome::Gtk3::TreeModel> set via the model property on B<Gnome::Gtk3::CellRendererCombo>.

Note that as soon as you change the model displayed in the tree view,
the tree view will immediately cease the editing operating.  This
means that you most probably want to refrain from changing the model
until the combo cell renderer emits the edited or editing_canceled signal.

Since: 2.14

  method handler (
    Str $path_string,
    Unknown type GTK_TYPE_TREE_ITER $new_iter,
    Gnome::GObject::Object :widget($combo),
    *%user-options
  );

=item $combo; the object on which the signal is emitted

=item $path_string; a string of the path identifying the edited cell
(relative to the tree view model)
=item $new_iter; the new iter selected in the combo box
(relative to the combo box model)

=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment #TP:0:model:
=head3 Model


Holds a tree model containing the possible values for the combo box.
Use the I<text_column> property to specify the column holding the values.
Since: 2.6
Widget type: GTK_TYPE_TREE_MODEL

The B<Gnome::GObject::Value> type of property I<model> is C<G_TYPE_OBJECT>.

=comment #TP:0:text-column:
=head3 Text Column


Specifies the model column which holds the possible values for the
combo box.
Note that this refers to the model specified in the model property,
not the model backing the tree view to which
this cell renderer is attached.
B<Gnome::Gtk3::CellRendererCombo> automatically adds a text cell renderer for
this column to its combo box.
Since: 2.6

The B<Gnome::GObject::Value> type of property I<text-column> is C<G_TYPE_INT>.

=comment #TP:0:has-entry:
=head3 Has Entry


If C<1>, the cell renderer will include an entry and allow to enter
values other than the ones in the popup list.
Since: 2.6

The B<Gnome::GObject::Value> type of property I<has-entry> is C<G_TYPE_BOOLEAN>.
=end pod
