#TL:1:Gnome::Gtk3::ShortcutsShortcut:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::ShortcutsShortcut

Represents a keyboard shortcut in a GtkShortcutsWindow


=comment ![](images/X.png)


=head1 Description

A B<Gnome::Gtk3::ShortcutsShortcut> represents a single keyboard shortcut or gesture  with a short text. This widget is only meant to be used with B<Gnome::Gtk3::ShortcutsWindow>.


=head1 Synopsis

=head2 Declaration

  unit class Gnome::Gtk3::ShortcutsShortcut;
  also is Gnome::Gtk3::Box;


=comment head2 Uml Diagram

=comment ![](plantuml/ShortcutsShortcut.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::ShortcutsShortcut;

  unit class MyGuiClass;
  also is Gnome::Gtk3::ShortcutsShortcut;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::ShortcutsShortcut class process the options
    self.bless( :GtkShortcutsShortcut, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Gtk3::Box;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::ShortcutsShortcut:auth<github:MARTIMM>;
also is Gnome::Gtk3::Box;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkShortcutType

GtkShortcutType specifies the kind of shortcut that is being described. More values may be added to this enumeration over time.

=item GTK_SHORTCUT_ACCELERATOR: The shortcut is a keyboard accelerator. The  I<accelerator> property will be used.
=item GTK_SHORTCUT_GESTURE_PINCH: The shortcut is a pinch gesture. GTK+ provides an icon and subtitle.
=item GTK_SHORTCUT_GESTURE_STRETCH: The shortcut is a stretch gesture. GTK+ provides an icon and subtitle.
=item GTK_SHORTCUT_GESTURE_ROTATE_CLOCKWISE: The shortcut is a clockwise rotation gesture. GTK+ provides an icon and subtitle.
=item GTK_SHORTCUT_GESTURE_ROTATE_COUNTERCLOCKWISE: The shortcut is a counterclockwise rotation gesture. GTK+ provides an icon and subtitle.
=item GTK_SHORTCUT_GESTURE_TWO_FINGER_SWIPE_LEFT: The shortcut is a two-finger swipe gesture. GTK+ provides an icon and subtitle.
=item GTK_SHORTCUT_GESTURE_TWO_FINGER_SWIPE_RIGHT: The shortcut is a two-finger swipe gesture. GTK+ provides an icon and subtitle.
=item GTK_SHORTCUT_GESTURE: The shortcut is a gesture. The  I<icon> property will be used.


=end pod

#TE:0:GtkShortcutType:
enum GtkShortcutType is export (
  'GTK_SHORTCUT_ACCELERATOR',
  'GTK_SHORTCUT_GESTURE_PINCH',
  'GTK_SHORTCUT_GESTURE_STRETCH',
  'GTK_SHORTCUT_GESTURE_ROTATE_CLOCKWISE',
  'GTK_SHORTCUT_GESTURE_ROTATE_COUNTERCLOCKWISE',
  'GTK_SHORTCUT_GESTURE_TWO_FINGER_SWIPE_LEFT',
  'GTK_SHORTCUT_GESTURE_TWO_FINGER_SWIPE_RIGHT',
  'GTK_SHORTCUT_GESTURE'
);

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :native-object

Create a ShortcutsShortcut object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a ShortcutsShortcut object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

# TM:0:new():inheriting
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::ShortcutsShortcut' #`{{ or %options<GtkShortcutsShortcut> }} {

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
        #$no = _gtk_shortcuts_shortcut_new___x___($no);
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
        $no = _gtk_shortcuts_shortcut_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkShortcutsShortcut');
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

The size group for the accelerator portion of this shortcut. This is used internally by GTK+, and must not be modified by applications. Widget type: GTK_TYPE_SIZE_GROUP

The B<Gnome::GObject::Value> type of property I<accel-size-group> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:accelerator:
=head3 Accelerator: accelerator

The accelerator(s) represented by this object. This property is used if  I<shortcut-type> is set to B<Gnome::Gtk3::TK_SHORTCUT_ACCELERATOR>.

The syntax of this property is (an extension of) the syntax understood by C<gtk_accelerator_parse()>. Multiple accelerators can be specified by separating them with a space, but keep in mind that the available width is limited. It is also possible to specify ranges of shortcuts, using ... between the keys. Sequences of keys can be specified using a + or & between the keys.

Examples:
=item A single shortcut: <ctl><alt>delete
=item Two alternative shortcuts: <shift>a Home
=item A range of shortcuts: <alt>1...<alt>9
=item Several keys pressed together: Control_L&Control_R
=item A sequence of shortcuts or keys: <ctl>c+<ctl>x

Use + instead of & when the keys may (or have to be) pressed sequentially (e.g
use t+t for 'press the t key twice').

Note that <, > and & need to be escaped as &lt;, &gt; and &amp; when used in .ui files.

The B<Gnome::GObject::Value> type of property I<accelerator> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:action-name:
=head3 Action Name: action-name

A detailed action name. If this is set for a shortcut of type C<GTK_SHORTCUT_ACCELERATOR>, then GTK+ will use the accelerators that are associated with the action via C<Gnome::Gtk3::Application.set-accels-for-action()>, and setting I<accelerator> is not necessary.

The B<Gnome::GObject::Value> type of property I<action-name> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:1:direction:
=head3 Direction: direction

The text direction for which this shortcut is active. If the shortcut is used regardless of the text direction, set this property to  C<GTK_TEXT_DIR_NONE>. Widget enum type: C<GtkTextDirection>

The B<Gnome::GObject::Value> type of property I<direction> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:0:icon:
=head3 Icon: icon

An icon to represent the shortcut or gesture. This property is used if I<shortcut-type> is set to B<Gnome::Gtk3::TK_SHORTCUT_GESTURE>. For the other predefined gesture types, GTK+ provides an icon on its own.Widget type: G_TYPE_ICON

The B<Gnome::GObject::Value> type of property I<icon> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:1:icon-set:
=head3 Icon Set: icon-set

C<True> if an icon has been set.

The B<Gnome::GObject::Value> type of property I<icon-set> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:shortcut-type:
=head3 Shortcut Type: shortcut-type

The type of shortcut that is represented.Widget type: GTK_TYPE_SHORTCUT_TYPE

The B<Gnome::GObject::Value> type of property I<shortcut-type> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:1:subtitle:
=head3 Subtitle: subtitle

The subtitle for the shortcut or gesture.

This is typically used for gestures and should be a short, one-line text that describes the gesture itself. For the predefined gesture types, GTK+ provides a subtitle on its own.

The B<Gnome::GObject::Value> type of property I<subtitle> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:subtitle-set:
=head3 Subtitle Set: subtitle-set

C<True> if a subtitle has been set.

The B<Gnome::GObject::Value> type of property I<subtitle-set> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:title:
=head3 Title: title

The textual description for the shortcut or gesture represented by this object. This should be a short string that can fit in a single line.

The B<Gnome::GObject::Value> type of property I<title> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:title-size-group:
=head3 Title Size Group: title-size-group

The size group for the textual portion of this shortcut. This is used internally by GTK+, and must not be modified by applications. Widget type: GTK_TYPE_SIZE_GROUP

The B<Gnome::GObject::Value> type of property I<title-size-group> is C<G_TYPE_OBJECT>.
=end pod
