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

=head2 See Also

B<Gnome::Gtk3::CheckMenuItem>, B<Gnome::Gtk3::Button>, B<Gnome::Gtk3::ToggleButton>, B<Gnome::Gtk3::RadioButton>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CheckButton;
  also is Gnome::Gtk3::ToggleButton;

=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::CheckButton;

  unit class MyGuiClass;
  also is Gnome::Gtk3::CheckButton;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::CheckButton class process the options
    self.bless( :GtkCheckButton, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

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

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcheckbutton.h
# https://developer.gnome.org/gtk3/stable/GtkCheckButton.html
unit class Gnome::Gtk3::CheckButton:auth<github:MARTIMM>;
also is Gnome::Gtk3::ToggleButton;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create GtkCheckButton object with a label.

  multi method new ( Str :$label!, Bool :$mnemonic = False )

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
#TM:4:new(:native-object):TopLevelClass
#TM:4:new(:build-id):Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::CheckButton' or ? %options<GtkCheckButton> {

    # check if native object is set by other parent class BUILDers
    if self.is-valid { }

    # process all named arguments
    elsif %options<native-object>:exists or %options<widget>:exists or
      %options<build-id>:exists { }

    else {
      my $no;
      my Bool $mnemonic = %options<mnemonic> // False;

      if %options<label>.defined {
        if $mnemonic {
          $no = _gtk_check_button_new_with_mnemonic(%options<label>);
        }

        else {
          $no = _gtk_check_button_new_with_label(%options<label>);
        }
      }

      else {
        $no = _gtk_check_button_new();
      }

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkCheckButton');
  }
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_check_button_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkCheckButton');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:2:_gtk_check_button_new:new()
#`{{
=begin pod
=head2 [gtk_] check_button_new

Creates a new B<Gnome::Gtk3::CheckButton>.

Returns: a B<Gnome::Gtk3::Widget>.

  method gtk_check_button_new ( --> N-GObject )

=end pod
}}

sub _gtk_check_button_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_check_button_new')
  { * }

#-------------------------------------------------------------------------------
#TM:3:_gtk_check_button_new_with_label:new(:label)
#`{{
=begin pod
=head2 [[gtk_] check_button_] new_with_label

Creates a new B<Gnome::Gtk3::CheckButton> with a B<Gnome::Gtk3::Label> to the right of it.

Returns: a B<Gnome::Gtk3::Widget>.

  method gtk_check_button_new_with_label ( Str $label --> N-GObject )

=item Str $label; the text for the check button.

=end pod
}}

sub _gtk_check_button_new_with_label ( Str $label --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_check_button_new_with_label')
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gtk_check_button_new_with_mnemonic:new(:mnemonic)
#`{{
=begin pod
=head2 [[gtk_] check_button_] new_with_mnemonic

Creates a new B<Gnome::Gtk3::CheckButton> containing a label. The label
will be created using C<gtk_label_new_with_mnemonic()>, so underscores
in I<label> indicate the mnemonic for the check button.

Returns: a new B<Gnome::Gtk3::CheckButton>

  method gtk_check_button_new_with_mnemonic ( Str $label --> N-GObject  )

=item Str $label; The text of the button, with an underscore in front of the mnemonic character

=end pod
}}

sub _gtk_check_button_new_with_mnemonic ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  is symbol('gtk_check_button_new_with_mnemonic')
  { * }
