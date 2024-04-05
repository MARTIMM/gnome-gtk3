#TL:1:Gnome::Gtk3::ShortcutsGroup:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ShortcutsGroup

Represents a group of shortcuts in a GtkShortcutsWindow


=comment ![](images/X.png)


=head1 Description

A GtkShortcutsGroup represents a group of related keyboard shortcuts or gestures. The group has a title. It may optionally be associated with a view of the application, which can be used to show only relevant shortcuts depending on the application context.

This widget is only meant to be used with B<Gnome::Gtk3::ShortcutsWindow>.


=head1 Synopsis

=head2 Declaration

  unit class Gnome::Gtk3::ShortcutsGroup;
  also is Gnome::Gtk3::Box;


=comment head2 Uml Diagram

=comment ![](plantuml/ShortcutsGroup.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::ShortcutsGroup:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::ShortcutsGroup;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::ShortcutsGroup class process the options
    self.bless( :GtkShortcutsGroup, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Gtk3::Box:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::ShortcutsGroup:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Box;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 :native-object

Create a ShortcutsGroup object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a ShortcutsGroup object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ShortcutsGroup' #`{{ or %options<GtkShortcutsGroup> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        $no = %options<___x___>;
        $no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_shortcuts_group_new___x___($no);
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

      ##`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      #}}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_shortcuts_group_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkShortcutsGroup');
  }
}


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use C<new(:label('my text label'))> or C<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:0:accel-size-group:
=head3 Accelerator Size Group: accel-size-group

The size group for the accelerator portion of shortcuts in this group. This is used internally by GTK+, and must not be modified by applications.Widget type: GTK_TYPE_SIZE_GROUP

The B<Gnome::GObject::Value> type of property I<accel-size-group> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:height:
=head3 Height: height

A rough measure for the number of lines in this group. This is used internally by GTK+, and is not useful for applications.

The B<Gnome::GObject::Value> type of property I<height> is C<G_TYPE_UINT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:title:
=head3 Title: title

The title for this group of shortcuts.

The B<Gnome::GObject::Value> type of property I<title> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:title-size-group:
=head3 Title Size Group: title-size-group

The size group for the textual portion of shortcuts in this group. This is used internally by GTK+, and must not be modified by applications. Widget type: GTK_TYPE_SIZE_GROUP

The B<Gnome::GObject::Value> type of property I<title-size-group> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:view:
=head3 View: view

An optional view that the shortcuts in this group are relevant for. The group will be hidden if the  I<view-name> property does not match the view of this group. Set this to C<undefined> to make the group always visible.

The B<Gnome::GObject::Value> type of property I<view> is C<G_TYPE_STRING>.
=end pod
