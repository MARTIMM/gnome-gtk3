#TL:1:Gnome::Gtk3::CheckButton:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CheckButton

widgets with a discrete toggle button

![](images/check-button.png)

=head1 Description

A B<Gnome::Gtk3::CheckButton> places a discrete B<Gnome::Gtk3::ToggleButton> next to a widget, (usually a B<Gnome::Gtk3::Label>). See the section on B<Gnome::Gtk3::ToggleButton> widgets for more information about toggle/check buttons.

The important signal ( sig C<toggled> ) is also inherited from
B<Gnome::Gtk3::ToggleButton>.

=head2 Css Nodes

  checkbutton
  ├── check
  ╰── <child>

A B<Gnome::Gtk3::CheckButton> with indicator (see C<gtk_toggle_button_set_mode()>) has a main CSS node with name checkbutton and a subnode with name check.

  button.check
  ├── check
  ╰── <child>

A B<Gnome::Gtk3::CheckButton> without indicator changes the name of its main node to button and adds a .check style class to it. The subnode is invisible in this case.

=head2 Implemented Interfaces
=item [Gnome::Gtk3::Buildable](Buildable.html)
=item Gnome::Gtk3::Actionable
=item Gnome::Gtk3::Activatable

=head2 See Also

B<Gnome::Gtk3::CheckMenuItem>, B<Gnome::Gtk3::Button>, B<Gnome::Gtk3::ToggleButton>, B<Gnome::Gtk3::RadioButton>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CheckButton;
  also is Gnome::Gtk3::ToggleButton;
  also does Gnome::Gtk3::Buildable;

=head2 Example

  my Gnome::Gtk3::CheckButton $bold-option .= new(:label<Bold>);

  # later ... check state
  if $bold-option.get-active {
    # Insert text in bold
  }

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::Gtk3::ToggleButton;

use Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcheckbutton.h
# https://developer.gnome.org/gtk3/stable/GtkCheckButton.html
unit class Gnome::Gtk3::CheckButton:auth<github:MARTIMM>;
also is Gnome::Gtk3::ToggleButton;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create GtkCheckButton object with a label.

  multi method new ( Str :$label! )

Create a new plain object.

  multi method new ( )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new(:label):
#TM:1:new():
#TM:1:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::CheckButton';

  if %options<label>.defined {
    self.set-native-object(gtk_check_button_new_with_label(%options<label>));
  }

  elsif ? %options<empty> {
    Gnome::N::deprecate( '.new(:empty)', '.new()', '0.21.3', '0.24.0');
    self.set-native-object(gtk_check_button_new());
  }

  elsif ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  else { #elsif ? %options<empty> {
    self.set-native-object(gtk_check_button_new());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkCheckButton');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_check_button_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkCheckButton');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:gtk_check_button_new:new()
=begin pod
=head2 [gtk_] check_button_new

Creates a new B<Gnome::Gtk3::CheckButton>.

Returns: a B<Gnome::Gtk3::Widget>.

  method gtk_check_button_new ( --> N-GObject  )

=end pod

sub gtk_check_button_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:3:gtk_check_button_new_with_label:net(:label)
=begin pod
=head2 [[gtk_] check_button_] new_with_label

Creates a new B<Gnome::Gtk3::CheckButton> with a B<Gnome::Gtk3::Label> to the right of it.

Returns: a B<Gnome::Gtk3::Widget>.

  method gtk_check_button_new_with_label ( Str $label --> N-GObject  )

=item Str $label; the text for the check button.

=end pod

sub gtk_check_button_new_with_label ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_check_button_new_with_mnemonic:
=begin pod
=head2 [[gtk_] check_button_] new_with_mnemonic

Creates a new B<Gnome::Gtk3::CheckButton> containing a label. The label
will be created using C<gtk_label_new_with_mnemonic()>, so underscores
in I<label> indicate the mnemonic for the check button.

Returns: a new B<Gnome::Gtk3::CheckButton>

  method gtk_check_button_new_with_mnemonic ( Str $label --> N-GObject  )

=item Str $label; The text of the button, with an underscore in front of the mnemonic character

=end pod

sub gtk_check_button_new_with_mnemonic ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }
