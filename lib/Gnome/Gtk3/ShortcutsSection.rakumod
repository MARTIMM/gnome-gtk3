#TL:1:Gnome::Gtk3::ShortcutsSection:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ShortcutsSection

Represents an application mode in a GtkShortcutsWindow


=comment ![](images/X.png)


=head1 Description

A B<Gnome::Gtk3::ShortcutsSection> collects all the keyboard shortcuts and gestures for a major application mode. If your application needs multiple sections, you should give each section a unique I<section-name> and a I<title> that can be shown in the section selector of the B<Gnome::Gtk3::ShortcutsWindow>.

The I<max-height> property can be used to influence how the groups in the section are distributed over pages and columns. This widget is only meant to be used with B<Gnome::Gtk3::ShortcutsWindow>.


=head1 Synopsis

=head2 Declaration

  unit class Gnome::Gtk3::ShortcutsSection;
  also is Gnome::Gtk3::Box;


=head2 Uml Diagram

![](plantuml/ShortcutsSection.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::ShortcutsSection:api<1>;

  unit class MyGuiClass;
  also is Gnome::Gtk3::ShortcutsSection;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::ShortcutsSection class process the options
    self.bless( :GtkShortcutsSection, |c);
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
unit class Gnome::Gtk3::ShortcutsSection:auth<github:MARTIMM>:api<1>;
also is Gnome::Gtk3::Box;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new


=head3 :native-object

Create a ShortcutsSection object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a ShortcutsSection object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w1<change-current-page>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ShortcutsSection' #`{{ or %options<GtkShortcutsSection> }} {

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
        #$no = _gtk_shortcuts_section_new___x___($no);
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
        $no = _gtk_shortcuts_section_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkShortcutsSection');
  }
}


#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<connect-object()> directly from B<Gnome::GObject::Signal>.

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

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<connect-object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment -----------------------------------------------------------------------
=comment #TS:0:change-current-page:
=head3 change-current-page

  method handler (
    Int $arg1,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($shortcutssection)
    N-GObject :$_native-object,
    *%user-options
    --> Int
  );

=item $arg1; ? page number ?
=item $_handler-id; The handler id which is returned from the registration
=item $_widget; The instance which registered the signal
=item $_native-object; The native object provided by the caller wrapped in the Raku object.

=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:1:max-height:
=head3 Maximum Height: max-height

The maximum number of lines to allow per column. This property can be used to influence how the groups in this section are distributed across pages and columns. The default value of 15 should work in most cases.

The B<Gnome::GObject::Value> type of property I<max-height> is C<G_TYPE_UINT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:section-name:
=head3 Section Name: section-name

A unique name to identify this section among the sections added to the GtkShortcutsWindow. Setting the  I<section-name> property to this string will make this section shown in the B<Gnome::Gtk3::ShortcutsWindow>.

The B<Gnome::GObject::Value> type of property I<section-name> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:title:
=head3 Title: title

The string to show in the section selector of the GtkShortcutsWindow for this section. If there is only one section, you don't need to set a title, since the section selector will not be shown in this case.

The B<Gnome::GObject::Value> type of property I<title> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:view-name:
=head3 View Name: view-name

A view name to filter the groups in this section by. See  I<view>. Applications are expected to use the  I<view-name> property for this purpose.

The B<Gnome::GObject::Value> type of property I<view-name> is C<G_TYPE_STRING>.
=end pod
