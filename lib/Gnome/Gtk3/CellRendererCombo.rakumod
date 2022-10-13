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


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CellRendererCombo;
  also is Gnome::Gtk3::CellRendererText;


=head2 Uml Diagram

![](plantuml/.svg)


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

=head3 default, no options

Create a new CellRendererCombo object.

  multi method new ( )


=head3 :native-object

Create a CellRendererCombo object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a CellRendererCombo object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w2<changed>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::CellRendererCombo' #`{{ or %options<GtkCellRendererCombo> }} {

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
        #$no = _gtk_cell_renderer_combo_new___x___($no);
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
        $no = _gtk_cell_renderer_combo_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkCellRendererCombo');
  }

#`{{
  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::CellRendererCombo';

  # process all named arguments
  if ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  else { #if ? %options<empty> {
    self._set-native-object(gtk_cell_renderer_combo_new());
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkCellRendererCombo');
}}
}

#-------------------------------------------------------------------------------
#TM:1:_gtk_cell_renderer_combo_new:
#`{{
=begin pod
=head2 _gtk_cell_renderer_combo_new

Creates a new B<Gnome::Gtk3::CellRendererCombo>. Adjust how text is drawn using object properties. Object properties can be set globally (with C<g_object_set()>). Also, with B<Gnome::Gtk3::TreeViewColumn>, you can bind a property to a value in a B<Gnome::Gtk3::TreeModel>. For example, you can bind the “text” property on the cell renderer to a string value in the model, thus rendering a different string in each row of the B<Gnome::Gtk3::TreeView>.

Returns: the new cell renderer

  method _gtk_cell_renderer_combo_new ( --> N-GObject )

=end pod
}}

sub _gtk_cell_renderer_combo_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_cell_renderer_combo_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:changed:
=head2 changed

This signal is emitted each time after the user selected an item in
the combo box, either by using the mouse or the arrow keys.  Contrary
to GtkComboBox, GtkCellRendererCombo::changed is not emitted for
changes made to a selected item in the entry.  The argument I<new_iter>
corresponds to the newly selected item in the combo box and it is relative
to the GtkTreeModel set via the model property on GtkCellRendererCombo.

Note that as soon as you change the model displayed in the tree view,
the tree view will immediately cease the editing operating.  This
means that you most probably want to refrain from changing the model
until the combo cell renderer emits the edited or editing_canceled signal.

  method handler (
    Str $path_string,
    N-GtkTreeIter $new_iter,
    Gnome::Gtk3::CellRendererCombo :_widget($combo),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $path_string; a string of the path identifying the edited cell (relative to the tree view model)
=item $new_iter; the new iter selected in the combo box (relative to the combo box model)
=item $combo; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:1:has-entry:
=head2 has-entry

If FALSE, don't allow to enter strings other than the chosen ones

The B<Gnome::GObject::Value> type of property I<has-entry> is C<G_TYPE_BOOLEAN>.

=item Parameter is readable and writable.
=item Default value is TRUE.


=comment -----------------------------------------------------------------------
=comment #TP:0:model:
=head2 model

The model containing the possible values for the combo box

The B<Gnome::GObject::Value> type of property I<model> is C<G_TYPE_OBJECT>.

=item Parameter is readable and writable.


=comment -----------------------------------------------------------------------
=comment #TP:1:text-column:
=head2 text-column

A column in the data source model to get the strings from

The B<Gnome::GObject::Value> type of property I<text-column> is C<G_TYPE_INT>.

=item Parameter is readable and writable.
=item Minimum value is -1.
=item Maximum value is G_MAXINT.
=item Default value is -1.

=end pod





=finish
#-------------------------------------------------------------------------------
#TM:2:_gtk_cell_renderer_combo_new:new()
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
  method mouse-event ( N-GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, N-GdkEvent $event, OpaquePointer $data
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
    N-GtkTreeIter $new_iter,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($combo),
    *%user-options
  );

=item $combo; the object on which the signal is emitted

=item $path_string; a string of the path identifying the edited cell (relative to the tree view model)
=item $new_iter; the new iterator selected in the combo box (relative to the combo box model)

=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
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
