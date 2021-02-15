#TL:1:Gnome::Gtk3::RecentChooserWidget:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::RecentChooserWidget

Displays recently used files

=comment ![](images/X.png)

=head1 Description


B<Gnome::Gtk3::RecentChooserWidget> is a widget suitable for selecting recently used files.  It is the main building block of a B<Gnome::Gtk3::RecentChooserDialog>.  Most applications will only need to use the latter; you can use B<Gnome::Gtk3::RecentChooserWidget> as part of a larger window if you have special needs.

Note that B<Gnome::Gtk3::RecentChooserWidget> does not have any methods of its own. Instead, you can use the functions added by the interface B<Gnome::Gtk3::RecentChooser>.


=head2 See Also

B<Gnome::Gtk3::RecentChooser>, B<Gnome::Gtk3::RecentChooserDialog>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::RecentChooserWidget;
  also is Gnome::Gtk3::Box;
  also does Gnome::Gtk3::RecentChooser;

=head2 Uml Diagram

![](plantuml/RecentChooserWidget.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::RecentChooserWidget;

  unit class MyGuiClass;
  also is Gnome::Gtk3::RecentChooserWidget;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::RecentChooserWidget class process the options
    self.bless( :GtkRecentChooserWidget, |c);
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
use Gnome::N::GlibToRakuTypes;
use Gnome::Gtk3::Box;
use Gnome::Gtk3::RecentChooser;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::RecentChooserWidget:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::Gtk3::Box;
also does Gnome::Gtk3::RecentChooser;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new RecentChooserWidget object.

  multi method new ( )

=head3 :manager

Creates a object with a specified recent manager.  This is useful if you have implemented your own recent manager, or if you have a customized instance of a B<Gnome::Gtk3::RecentManager> object.

  multi method new ( N-GObject :$manager! )

=head3 :native-object

Create a RecentChooserWidget object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a RecentChooserWidget object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:1:new():
#TM:1:new(:manager)
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::RecentChooserWidget' #`{{ or %options<GtkRecentChooserWidget> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<manager> {
        $no = %options<manager>;
        $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        $no = _gtk_recent_chooser_widget_new_for_manager($no);
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
        $no = _gtk_recent_chooser_widget_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GtkRecentChooserWidget');

  }
}


#-------------------------------------------------------------------------------
#TM:1:_gtk_recent_chooser_widget_new:
#`{{
=begin pod
=head2 _gtk_recent_chooser_widget_new

Creates a new B<Gnome::Gtk3::RecentChooserWidget> object.  This is an embeddable widget used to access the recently used resources list.

Returns: a new B<Gnome::Gtk3::RecentChooserWidget>

  method _gtk_recent_chooser_widget_new ( --> N-GObject )


=end pod
}}

sub _gtk_recent_chooser_widget_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_recent_chooser_widget_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_recent_chooser_widget_new_for_manager:
#`{{
=begin pod
=head2 _gtk_recent_chooser_widget_new_for_manager

Creates a new B<Gnome::Gtk3::RecentChooserWidget> with a specified recent manager.  This is useful if you have implemented your own recent manager, or if you have a customized instance of a B<Gnome::Gtk3::RecentManager> object.

Returns: a new B<Gnome::Gtk3::RecentChooserWidget>

  method _gtk_recent_chooser_widget_new_for_manager ( N-GObject $manager --> N-GObject )

=item N-GObject $manager; a B<Gnome::Gtk3::RecentManager>

=end pod
}}

sub _gtk_recent_chooser_widget_new_for_manager ( N-GObject $manager --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_recent_chooser_widget_new_for_manager')
  { * }
