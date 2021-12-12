#TL:1:Gnome::Gtk3::AccelLabel:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::AccelLabel

A label which displays an accelerator key on the right of the text


![](images/Label.png)


=head1 Description


The B<Gnome::Gtk3::AccelLabel> widget is a subclass of B<Gnome::Gtk3::Label> that also displays an accelerator key on the right of the label text, e.g. “Ctrl+S”. It is commonly used in menus to show the keyboard short-cuts for commands.

The accelerator key to display is typically not set explicitly (although it can be, with C<set-accel()>). Instead, the B<Gnome::Gtk3::AccelLabel> displays the accelerators which have been added to a particular widget. This widget is set by calling C<set-accel-widget()>.

For example, a B<Gnome::Gtk3::MenuItem> widget may have an accelerator added to emit the “activate” signal when the “Ctrl+S” key combination is pressed. A B<Gnome::Gtk3::AccelLabel> is created and added to the B<Gnome::Gtk3::MenuItem>, and C<set-accel-widget()> is called with the B<Gnome::Gtk3::MenuItem> as the second argument. The B<Gnome::Gtk3::AccelLabel> will now display “Ctrl+S” after its label.

Note that creating a B<Gnome::Gtk3::MenuItem> with C<Gnome::Gtk3::MenuItem.new(:$label)> (or one of the similar functions for B<Gnome::Gtk3::CheckMenuItem> and B<Gnome::Gtk3::RadioMenuItem>) automatically adds a B<Gnome::Gtk3::AccelLabel> to the B<Gnome::Gtk3::MenuItem> and calls C<set-accel-widget()> to set it up for you.

A B<Gnome::Gtk3::AccelLabel> will only display accelerators which have C<GTK-ACCEL-VISIBLE> set (see C<GtkAccelFlags> from B<Gnome::Gtk3::AccelGroup>).
A B<Gnome::Gtk3::AccelLabel> can display multiple accelerators and even signal names, though it is almost always used to display just one accelerator key.


=begin comment
=head2 Creating a simple menu item with an accelerator key.

|[<!-- language="C" -->
  GtkWidget *window = gtk-window-new (GTK-WINDOW-TOPLEVEL);
  GtkWidget *menu = C<gtk-menu-new()>;
  GtkWidget *save-item;
  GtkAccelGroup *accel-group;

  // Create a GtkAccelGroup and add it to the window.
  accel-group = C<gtk-accel-group-new()>;
  gtk-window-add-accel-group (GTK-WINDOW (window), accel-group);

  // Create the menu item using the convenience function.
  save-item = gtk-menu-item-new-with-label ("Save");
  gtk-widget-show (save-item);
  gtk-container-add (GTK-CONTAINER (menu), save-item);

  // Now add the accelerator to the GtkMenuItem. Note that since we
  // called C<gtk-menu-item-new-with-label()> to create the GtkMenuItem
  // the GtkAccelLabel is automatically set up to display the
  // GtkMenuItem accelerators. We just need to make sure we use
  // GTK-ACCEL-VISIBLE here.
  gtk-widget-add-accelerator (save-item, "activate", accel-group,
                              GDK-KEY-s, GDK-CONTROL-MASK, GTK-ACCEL-VISIBLE);
]|
=end comment


=head2 Css Nodes

Like B<Gnome::Gtk3::Label>, B<Gnome::Gtk3::AccelLabel> has a main CSS node with the name label.  It adds a subnode with name accelerator.

  label
  ╰── accelerator


=head2 See Also

B<Gnome::Gtk3::AccelGroup>


=head1 Synopsis

=head2 Declaration

  unit class Gnome::Gtk3::AccelLabel;
  also is Gnome::Gtk3::Label;


=head2 Uml Diagram

![](plantuml/AccelLabel.svg)


=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::AccelLabel;

  unit class MyGuiClass;
  also is Gnome::Gtk3::AccelLabel;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::AccelLabel class process the options
    self.bless( :GtkAccelLabel, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::GObject::Closure;

use Gnome::Gtk3::Label;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::AccelLabel:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::Gtk3::Label;

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkAccelLabel

The B<Gnome::Gtk3::AccelLabel>-struct contains private data only, and
should be accessed using the functions below.

=end pod

# TT:0:N-GtkAccelLabel:
class N-GtkAccelLabel is export is repr('CStruct') {
  has N-GObject $.label;
  has GtkAccelLabelPrivate $.priv;
}
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :text

Create a new AccelLabel object with the label from C<$text>.

  multi method new ( :$text! )


=head3 :native-object

Create a AccelLabel object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a AccelLabel object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new():inheriting
#TM:1:new(:text):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::AccelLabel' or %options<GtkAccelLabel> {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<text> {
        $no = _gtk_accel_label_new(%options<text>);
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

      ##`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      #}}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_accel_label_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkAccelLabel');
  }
}

#-------------------------------------------------------------------------------
#TM:0:get-accel:
=begin pod
=head2 get-accel

Gets the keyval and modifier mask set with C<set-accel()>.

  method get-accel ( List )

The returned Lis contains
=item UInt $accelerator-key; the keyval
=item UInt $accelerator-mods; the modifier mask, a mask with GdkModifierType bits.
=end pod

method get-accel ( --> List ) {
  my guint $accelerator-key;
  my guint $accelerator-mods;
  gtk_accel_label_get_accel(
    self.get-native-object-no-reffing, $accelerator-key, $accelerator-mods
  );

  ( $accelerator-key, $accelerator-mods)
}

sub gtk_accel_label_get_accel (
  N-GObject $accel_label, guint $accelerator-key is rw,
  GFlag $accelerator-mods is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-accel-widget:
#TM:1:get-accel-widget-rk:
=begin pod
=head2 get-accel-widget

Fetches the widget monitored by this accelerator label, or C<undefined>. See C<set-accel-widget()>.

  method get-accel-widget ( --> N-GObject )
  method get-accel-widget-rk ( --> Gnome::Gtk3::Widget )

=end pod

method get-accel-widget ( --> N-GObject ) {
  gtk_accel_label_get_accel_widget(self.get-native-object-no-reffing)
}

method get-accel-widget-rk ( --> Any ) {
  self._wrap-native-type-from-no(
    gtk_accel_label_get_accel_widget(self.get-native-object-no-reffing)
  )
}

sub gtk_accel_label_get_accel_widget (
  N-GObject $accel_label --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-accel-width:
=begin pod
=head2 get-accel-width

Returns the width needed to display the accelerator key(s). This is used by menus to align all of the B<Gnome::Gtk3::MenuItem> widgets, and shouldn't be needed by applications.

Returns: the width needed to display the accelerator key(s).

  method get-accel-width ( --> UInt )

=end pod

method get-accel-width ( --> UInt ) {
  gtk_accel_label_get_accel_width(self.get-native-object-no-reffing)
}

sub gtk_accel_label_get_accel_width (
  N-GObject $accel_label --> guint
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:refetch:
=begin pod
=head2 refetch

Recreates the string representing the accelerator keys. This should not be needed since the string is automatically updated whenever accelerators are added or removed from the associated widget.

Returns: always returns C<False>.

  method refetch ( --> Bool )

=end pod

method refetch ( --> Bool ) {

  gtk_accel_label_refetch(
    self.get-native-object-no-reffing,
  ).Bool
}

sub gtk_accel_label_refetch (
  N-GObject $accel_label --> gboolean
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:set-accel:
=begin pod
=head2 set-accel

Manually sets a keyval and modifier mask as the accelerator rendered by I<accel-label>.

If a keyval and modifier are explicitly set then these values are used regardless of any associated accel closure or widget.

Providing an I<$accelerator-key> of 0 removes the manual setting.

  method set-accel ( UInt $accelerator-key, UInt $accelerator-mods )

=item UInt $accelerator-key; a keyval, or 0
=item UInt $accelerator-mods; the modifier mask for the accel, a mask with bits from GdkModifierType.
=end pod

method set-accel ( UInt $accelerator-key, UInt $accelerator-mods ) {
  gtk_accel_label_set_accel(
    self.get-native-object-no-reffing, $accelerator-key, $accelerator-mods
  );
}

sub gtk_accel_label_set_accel (
  N-GObject $accel_label, guint $accelerator-key, GFlag $accelerator-mods
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-accel-closure:
=begin pod
=head2 set-accel-closure

Sets the closure to be monitored by this accelerator label. The closure must be connected to an accelerator group; see C<Gnome::Gtk3::AccelGroup.connect()>. Passing C<undefined> for I<$accel-closure> will dissociate the I<accel-label> from its current closure, if any.

  method set-accel-closure ( N-GClosure $accel_closure )

=item N-GClosure $accel_closure; the closure to monitor for accelerator changes, or C<undefined>
=end pod

method set-accel-closure ( $accel_closure is copy ) {
  $accel_closure .= get-native-object-no-reffing unless $accel_closure ~~ N-GClosure;

  gtk_accel_label_set_accel_closure(
    self.get-native-object-no-reffing, $accel_closure
  );
}

sub gtk_accel_label_set_accel_closure (
  N-GObject $accel_label, N-GClosure $accel_closure
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-accel-widget:
=begin pod
=head2 set-accel-widget

Sets the widget to be monitored by this accelerator label. Passing C<undefined> for I<accel-widget> will dissociate I<accel-label> from its current widget, if any.

  method set-accel-widget ( N-GObject $accel_widget )

=item N-GObject $accel_widget; the widget to be monitored, or C<undefined>
=end pod

method set-accel-widget ( $accel_widget is copy ) {
  $accel_widget .= get-native-object-no-reffing unless $accel_widget ~~ N-GObject;

  gtk_accel_label_set_accel_widget(
    self.get-native-object-no-reffing, $accel_widget
  );
}

sub gtk_accel_label_set_accel_widget (
  N-GObject $accel_label, N-GObject $accel_widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_accel_label_new:
#`{{
=begin pod
=head2 _gtk_accel_label_new

Creates a new B<Gnome::Gtk3::AccelLabel>.

Returns: a new B<Gnome::Gtk3::AccelLabel>.

  method _gtk_accel_label_new ( Str $string --> N-GObject )

=item Str $string; the label string. Must be non-C<undefined>.
=end pod
}}

sub _gtk_accel_label_new ( gchar-ptr $string --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_accel_label_new')
  { * }

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
=comment #TP:0:accel-closure:
=head3 Accelerator Closure: accel-closure

The B<Gnome::GObject::Value> type of property I<accel-closure> is C<G_TYPE_BOXED>.

=comment -----------------------------------------------------------------------
=comment #TP:1:accel-widget:
=head3 Accelerator Widget: accel-widget

The widget to be monitored for accelerator changes
Widget type: GTK-TYPE-WIDGET

The B<Gnome::GObject::Value> type of property I<accel-widget> is C<G_TYPE_OBJECT>.
=end pod
