#TL:1:Gnome::Gtk3::SeparatorMenuItem:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::SeparatorMenuItem

A separator used in menus

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gtk3::SeparatorMenuItem> is a separator used to group items within a menu. It displays a horizontal line with a shadow to make it appear sunken into the interface.


=head2 Css Nodes

B<Gnome::Gtk3::SeparatorMenuItem> has a single CSS node with name separator.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::SeparatorMenuItem;
  also is Gnome::Gtk3::MenuItem;


=head2 Uml Diagram

![](plantuml/SeparatorMenuItem.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::SeparatorMenuItem:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::SeparatorMenuItem;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::SeparatorMenuItem class process the options
    self.bless( :GtkSeparatorMenuItem, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;
use Gnome::Gtk3::MenuItem:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::SeparatorMenuItem:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::MenuItem;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new SeparatorMenuItem object.

  multi method new ( )

=head3 :native-object

Create a SeparatorMenuItem object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a SeparatorMenuItem object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::SeparatorMenuItem' #`{{ or %options<GtkSeparatorMenuItem> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        $no = %options<___x___>;
        $no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_separator_menu_item_new___x___($no);
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
        $no = _gtk_separator_menu_item_new();
      }
      #}}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkSeparatorMenuItem');

  }
}

#-------------------------------------------------------------------------------
#TM:1:_gtk_separator_menu_item_new:
#`{{
=begin pod
=head2 _gtk_separator_menu_item_new

Creates a new B<Gnome::Gtk3::SeparatorMenuItem>.

Returns: a new B<Gnome::Gtk3::SeparatorMenuItem>.

  method _gtk_separator_menu_item_new ( --> N-GObject )


=end pod
}}

sub _gtk_separator_menu_item_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_separator_menu_item_new')
  { * }
