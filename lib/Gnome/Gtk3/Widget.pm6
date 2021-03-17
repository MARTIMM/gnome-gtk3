#TL:1:Gnome::Gtk3::Widget

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Widget

Base class for all widgets

=head1 Description

B<Gnome::Gtk3::Widget> is the base class all widgets in this package derive from. It manages the widget lifecycle, states and style.

=head2 Height-for-width Geometry Management

GTK+ uses a height-for-width (and width-for-height) geometry management system. Height-for-width means that a widget can change how much vertical space it needs, depending on the amount of horizontal space that it is given (and similar for width-for-height). The most common example is a label that reflows to fill up the available width, wraps to fewer lines, and therefore needs less height.

Height-for-width geometry management is implemented in GTK+ by way of five virtual methods:

=item C<get_request_mode()>
=item C<get_preferred_width()>
=item C<get_preferred_height()>
=item C<get_preferred_height_for_width()>
=item C<get_preferred_width_for_height()>
=item C<get_preferred_height_and_baseline_for_width()>

There are some important things to keep in mind when implementing height-for-width and when using it in container implementations.

The geometry management system will query a widget hierarchy in only one orientation at a time. When widgets are initially queried for their minimum sizes it is generally done in two initial passes in the C<GtkSizeRequestMode> chosen by the toplevel.

For example, when queried in the normal C<GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH> mode:
=item First, the default minimum and natural width for each widget in the interface will be computed using C<gtk_widget_get_preferred_width()>. Because the preferred widths for each container depend on the preferred widths of their children, this information propagates up the hierarchy, and finally a minimum and natural width is determined for the entire toplevel.
=item Next, the toplevel will use the minimum width to query for the minimum height contextual to that width using C<gtk_widget_get_preferred_height_for_width()>, which will also be a highly recursive operation. The minimum height for the minimum width is normally used to set the minimum size constraint on the toplevel (unless C<gtk_window_set_geometry_hints()> is explicitly used instead).

After the toplevel window has initially requested its size in both dimensions it can go on to allocate itself a reasonable size (or a size previously specified with C<gtk_window_set_default_size()>). During the recursive allocation process it’s important to note that request cycles will be recursively executed while container widgets allocate their children. Each container widget, once allocated a size, will go on to first share the space in one orientation among its children and then request each child's height for its target allocated width or its width for allocated height, depending.

In this way a B<Gnome::Gtk3::Widget> will typically be requested its size a number of times before actually being allocated a size. The size a widget is finally allocated can of course differ from the size it has requested. For this reason, B<Gnome::Gtk3::Widget> caches a  small number of results to avoid re-querying for the same sizes in one allocation cycle.

See [Gnome::Gtk3::Container’s geometry management section](https://developer.gnome.org/gtk3/stable/GtkContainer.html) to learn more about how height-for-width allocations are performed by container widgets.

If a widget does move content around to intelligently use up the allocated size then it must support the request in both C<GtkSizeRequestMode>s even if the widget in question only trades sizes in a single orientation.

For instance, a B<Gnome::Gtk3::Label> that does height-for-width word wrapping will not expect to have C<get_preferred_height()> called because that call is specific to a width-for-height request. In this case the label must return the height required for its own minimum possible width. By following this rule any widget that handles height-for-width or width-for-height requests will always be allocated at least enough space to fit its own content.

=begin comment
Here are some examples of how a C<GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH> widget generally deals with width-for-height requests, for C<get_preferred_height()> it will do (A piece of C-code directly from the docs):

  static void foo_widget_get_preferred_height (
    GtkWidget *widget, gint *min_height, gint *nat_height
  ) {
    if (i_am_in_height_for_width_mode) {
      gint min_width, nat_width;

      GTK_WIDGET_GET_CLASS (widget)->get_preferred_width(
        widget, &min_width, &nat_width
      );

      GTK_WIDGET_GET_CLASS (widget)->get_preferred_height_for_width(
        widget, min_width, min_height, nat_height
      );
    }

    else {
      ... some widgets do both. For instance, if a GtkLabel is
      rotated to 90 degrees it will return the minimum and
      natural height for the rotated label here.
    }
  }

And in C<get_preferred_width_for_height()> it will simply return
the minimum and natural width:

  static void foo_widget_get_preferred_width_for_height(
    GtkWidget *widget, gint for_height, gint *min_width,
    gint *nat_width
  ) {
    if (i_am_in_height_for_width_mode) {
      GTK_WIDGET_GET_CLASS (widget)->get_preferred_width(
        widget, min_width, nat_width
      );
    }

    else {
      ... again if a widget is sometimes operating in
      width-for-height mode (like a rotated GtkLabel) it can go
      ahead and do its real width for height calculation here.
    }
  }
=end comment

=begin comment
Often a widget needs to get its own request during size request or allocation. For example, when computing height it may need to also compute width. Or when deciding how to use an allocation, the widget may need to know its natural size. In these cases, the widget should be careful to call its virtual methods directly, like this:

  GTK_WIDGET_GET_CLASS(widget)->get_preferred_width(
    widget, &min, &natural
  );

It will not work to use the wrapper functions, such as C<gtk_widget_get_preferred_width()> inside your own size request implementation. These return a request adjusted by B<Gnome::Gtk3::SizeGroup> and by the C<adjust_size_request()> virtual method. If a widget used the wrappers inside its virtual method implementations, then the adjustments (such as widget margins) would be applied twice. GTK+ therefore does not allow this and will warn if you try to do it.

Of course if you are getting the size request for another widget, such as a child of a container, you must use the wrapper APIs. Otherwise, you would not properly consider widget margins, B<Gnome::Gtk3::SizeGroup>, and so forth.

=end comment

Since 3.10 GTK+ also supports baseline vertical alignment of widgets. This means that widgets are positioned such that the typographical baseline of widgets in the same row are aligned. This happens if a widget supports baselines, has a vertical alignment of C<GTK_ALIGN_BASELINE>, and is inside a container that supports baselines and has a natural “row” that it aligns to the baseline, or a baseline assigned to it by the grandparent.

Baseline alignment support for a widget is done by the C<get_preferred_height_and_baseline_for_width()> virtual function. It allows you to report a baseline in combination with the minimum and natural height. If there is no baseline you can return -1 to indicate this. The default implementation of this virtual function calls into the C<get_preferred_height()> and C<get_preferred_height_for_width()>, so if baselines are not supported it doesn’t need to be implemented.

If a widget ends up baseline aligned it will be allocated all the space in the parent as if it was C<GTK_ALIGN_FILL>, but the selected baseline can be found via C<gtk_widget_get_allocated_baseline()>. If this has a value other than -1 you need to align the widget such that the baseline appears at the position.

=head2 Style Properties

B<Gnome::Gtk3::Widget> introduces “style properties” - these are basically object properties that are stored not on the object, but in the style object associated to the widget. Style properties are set in gtk resource files. This mechanism is used for configuring such things as the location of the scrollbar arrows through the theme, giving theme authors more control over the look of applications without the need to write a theme engine in C.

Use C<gtk_widget_class_install_style_property()> to install style properties for a widget class, C<gtk_widget_class_find_style_property()> or C<gtk_widget_class_list_style_properties()> to get information about existing style properties and C<gtk_widget_style_get_property()>, C<gtk_widget_style_get()> or C<gtk_widget_style_get_valist()> to obtain the value of a style property.

=head2 Gnome::Gtk3::Widget as Gnome::Gtk3::Buildable

The B<Gnome::Gtk3::Widget> implementation of the B<Gnome::Gtk3::Buildable> interface supports a custom <accelerator> element, which has attributes named ”key”, ”modifiers” and ”signal” and allows to specify accelerators.

An example of a UI definition fragment specifying an accelerator (please note that in this XML the C-Source widget class names must be used; GtkButton instead of Gnome::Gtk3::Button):

  <object class="GtkButton">
    <accelerator key="q" modifiers="GDK_CONTROL_MASK" signal="clicked"/>
  </object>

In addition to accelerators, B<Gnome::Gtk3::Widget> also support a custom <accessible> element, which supports actions and relations. Properties on the accessible implementation of an object can be set by accessing the internal child “accessible” of a B<Gnome::Gtk3::Widget>.

An example of a UI definition fragment specifying an accessible:

  <object class="GtkButton" id="label1"/>
    <property name="label">I am a Label for a Button</property>
  </object>
  <object class="GtkButton" id="button1">
    <accessibility>
      <action action_name="click" translatable="yes">
        Click the button.
      </action>
      <relation target="label1" type="labelled-by"/>
    </accessibility>
    <child internal-child="accessible">
      <object class="AtkObject" id="a11y-button1">
        <property name="accessible-name">
          Clickable Button
        </property>
      </object>
    </child>
  </object>

Finally, B<Gnome::Gtk3::Widget> allows style information such as style classes to be associated with widgets, using the custom <style> element:

  <object class="GtkButton>" id="button1">
    <style>
      <class name="my-special-button-class"/>
      <class name="dark-button"/>
    </style>
  </object>

=begin comment
=head2 Building composite widgets from template XML

B<Gnome::Gtk3::Widget> exposes some facilities to automate the procedure of creating composite widgets using B<Gnome::Gtk3::Builder> interface description language.

To create composite widgets with B<Gnome::Gtk3::Builder> XML, one must associate
the interface description with the widget class at class initialization
time using C<gtk_widget_class_set_template()>.

The interface description semantics expected in composite template descriptions
is slightly different from regular B<Gnome::Gtk3::Builder> XML.

Unlike regular interface descriptions, C<gtk_widget_class_set_template()> will expect a <template> tag as a direct child of the toplevel <interface> tag. The <template> tag must specify the “class” attribute which must be the type name of the widget. Optionally, the “parent” attribute may be specified to specify the direct parent type of the widget type, this is ignored by the B<Gnome::Gtk3::Builder> but required for Glade to introspect what kind of properties and internal children exist for a given type when the actual type does not exist.

The XML which is contained inside the <template> tag behaves as if it were added to the <object> tag defining I<widget> itself. You may set properties on I<widget> by inserting <property> tags into the <template> tag, and also add <child> tags to add children and extend I<widget> in the normal way you would with <object> tags.

Additionally, <object> tags can also be added before and after the initial <template> tag in the normal way, allowing one to define auxiliary objects which might be referenced by other widgets declared as children of the <template> tag.

An example of a B<Gnome::Gtk3::Builder> Template Definition:

  <interface>
    <template class="FooWidget" parent="GtkBox">
      <property name="orientation">GTK_ORIENTATION_HORIZONTAL</property>
      <property name="spacing">4</property>
      <child>
        <object class="GtkButton" id="hello_button">
          <property name="label">Hello World</property>
          <signal name="clicked" handler="hello_button_clicked" object="FooWidget" swapped="yes"/>
        </object>
      </child>
      <child>
        <object class="GtkButton" id="goodbye_button">
          <property name="label">Goodbye World</property>
        </object>
      </child>
    </template>
  </interface>

Typically, you'll place the template fragment into a file that is bundled with your project, using C<GResource>. In order to load the template, you need to call C<gtk_widget_class_set_template_from_resource()> from the class initialization of your B<Gnome::Gtk3::Widget> type:

=comment TODO replace with Raku code

  static void foo_widget_class_init (FooWidgetClass *klass) {
    // ...

    gtk_widget_class_set_template_from_resource (
      GTK_WIDGET_CLASS (klass), "/com/example/ui/foowidget.ui"
    );
  }

You will also need to call C<gtk_widget_init_template()> from the instance
initialization function:

=comment TODO replace with Raku code

  static void foo_widget_init (FooWidget *self) {
    // ...
    gtk_widget_init_template (GTK_WIDGET (self));
  }

You can access widgets defined in the template using the C<gtk_widget_get_template_child()> function, but you will typically declare a pointer in the instance private data structure of your type using the same name as the widget in the template definition, and call C<gtk_widget_class_bind_template_child_private()> with that name, e.g.

  typedef struct {
    B<Gnome::Gtk3::Widget> *hello_button;
    B<Gnome::Gtk3::Widget> *goodbye_button;
  } FooWidgetPrivate;

  G_DEFINE_TYPE_WITH_PRIVATE (FooWidget, foo_widget, GTK_TYPE_BOX)

  static void foo_widget_class_init (FooWidgetClass *klass) {
    // ...
    gtk_widget_class_set_template_from_resource (GTK_WIDGET_CLASS (klass),
                                                 "/com/example/ui/foowidget.ui");
    gtk_widget_class_bind_template_child_private (GTK_WIDGET_CLASS (klass),
                                                  FooWidget, hello_button);
    gtk_widget_class_bind_template_child_private (GTK_WIDGET_CLASS (klass),
                                                  FooWidget, goodbye_button);
  }

You can also use C<gtk_widget_class_bind_template_callback()> to connect a signal callback defined in the template with a function visible in the scope of the class, e.g.

  // the signal handler has the instance and user data swapped
  // because of the swapped="yes" attribute in the template XML
  static void hello_button_clicked (FooWidget *self, GtkButton *button) {
    g_print ("Hello, world!\n");
  }

  static void
  foo_widget_class_init (FooWidgetClass *klass)
  {
    // ...
    gtk_widget_class_set_template_from_resource (
      GTK_WIDGET_CLASS (klass), "/com/example/ui/foowidget.ui"
    );
    gtk_widget_class_bind_template_callback (
      GTK_WIDGET_CLASS (klass), hello_button_clicked
    );
  }

=head2 Implemented Interfaces

Gnome::Gtk3::Widget implements
=comment item Gnome::Atk::ImplementorIface
=item [Gnome::Gtk3::Buildable](Buildable.html)

=end comment


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Widget;
  also is Gnome::GObject::InitiallyUnowned;
  also does Gnome::Gtk3::Buildable;


=head2 Uml Diagram

![](plantuml/Widget.svg)


=head2 Example

  # create a button and set a tooltip
  my Gnome::Gtk3::Button $start-button .= new(:label<Start>);
  $start-button.set-tooltip-text('Nooooo don\'t touch that button!!!!!!!');

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::GObject::InitiallyUnowned;

use Gnome::Glib::List;

use Gnome::Gdk3::Types;
use Gnome::Gdk3::Events;

use Gnome::Gtk3::Enums;
use Gnome::Gtk3::WidgetPath;
use Gnome::Gtk3::Buildable;

use Gnome::Cairo;
use Gnome::Cairo::Enums;
use Gnome::Cairo::Types;
#use Gnome::Cairo::FontOptions;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/gtkwidget.h
# https://developer.gnome.org/gtk3/stable/GtkWidget.html
unit class Gnome::Gtk3::Widget:auth<github:MARTIMM>:ver<0.3.0>;
also is Gnome::GObject::InitiallyUnowned;
also does Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkWidgetHelpType

Kinds of widget-specific help. Used by the ::show-help signal.

=item GTK_WIDGET_HELP_TOOLTIP: Tooltip.
=item GTK_WIDGET_HELP_WHATS_THIS: What’s this.

=end pod

#TE:0:GtkWidgetHelpType:
enum GtkWidgetHelpType is export (
  'GTK_WIDGET_HELP_TOOLTIP',
  'GTK_WIDGET_HELP_WHATS_THIS'
);

#-------------------------------------------------------------------------------
#TODO refactor into Boxed type class
=begin pod
=head2 class N-GtkRequisition

A B<Gnome::Gtk3::Requisition>-struct represents the desired size of a widget. See [B<Gnome::Gtk3::Widget>’s geometry management section][geometry-management] for more information.

=item Int $.width: the widget’s desired width
=item Int $.height: the widget’s desired height

=end pod

#TT:2:N-GtkRequisition:CellRenderer.t
class N-GtkRequisition is export is repr('CStruct') {
  has int32 $.width;
  has int32 $.height;
}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class GtkTickCallback

Callback type for adding a function to update animations. See C<gtk_widget_add_tick_callback()>.

Returns: C<G_SOURCE_CONTINUE> if the tick callback should continue to be called,
C<G_SOURCE_REMOVE> if the tick callback should be removed.



=item ___widget: the widget
=item ___frame_clock: the frame clock for the widget (same as calling C<gtk_widget_get_frame_clock()>)
=item ___user_data: user data passed to C<gtk_widget_add_tick_callback()>.


=end pod

#TT:0:N-GtkTickCallback:
class GtkTickCallback is export is repr('CStruct') {
  has GInitiallyUnowned $.parent_instance;
  has GtkWidgetPrivate $.priv;
}

=end pod
}}


#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkAllocation

A N-GtkAllocation of a widget represents a region which has been allocated to the widget by its parent. It is a subregion of its parents allocation. See GtkWidget’s geometry management section for more information.

=item Int $.x;
=item Int $.y;
=item Int $.width;
=item Int $.height;

=end pod


# use of this statement works but will show the N-GdkRectangle type, not
# the N-GtkAllocation type, so we define like the rectangle
#my constant N-GtkAllocation is export = N-GdkRectangle;

#TT:1:N-GtkAllocation:
class N-GtkAllocation is export is repr('CStruct') {
  has int32 $.x;
  has int32 $.y;
  has int32 $.width;
  has int32 $.height;

  submethod TWEAK ( :$!x = 0, :$!y = 0, :$!width = 1, :$!height = 1 ) { }
}

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

#TM:1:new():inheriting
submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<destroy show hide map unmap realize unrealize style-updated grab-focus delete-event show-help screen-changed>,
    :w1<size-allocate state-flags-changed parent-set hierarchy-changed direction-changed grab-notify child-notify draw mnemonic-activate focus move-focus keynav-failed event event-after button-press-event button-release-event scroll-event motion-notify-event destroy-event key-press-event key-release-event enter-notify-event leave-notify-event configure-event focus-in-event focus-out-event map-event unmap-event property-notify-event selection-clear-event selection-request-event selection-notify-event selection-received proximity-out-event drag-leave drag-end drag-data-delete drag-failed window-state-event damage-event grab-broken-event accel-closures-changed can-activate-accel can-activate-accel>,
    :w2<selection-get drag-begin drag-motion>,
    :w3<proximity-in-event>,
    :w4<drag-drop drag-data-get drag-data-received popup-menu query-tooltip>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
#  return unless self.^name eq 'Gnome::Gtk3::Widget';

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkWidget');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_widget_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  try { $s = self._buildable_interface($native-sub); } unless ?$s;

  self.set-class-name-of-sub('GtkWidget');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:activate:
=begin pod
=head2 activate

For widgets that can be “activated” (buttons, menu items, etc.) this function activates them. Activation is what happens when you press Enter on a widget during key navigation. If I<widget> isn't activatable, the function returns C<False>.

Returns: C<True> if the widget was activatable

  method activate ( --> Bool )


=end pod

method activate ( --> Bool ) {

  gtk_widget_activate(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_activate (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:add-accelerator:
=begin pod
=head2 add-accelerator

Installs an accelerator for this I<widget> in I<accel-group> that causes I<accel-signal> to be emitted if the accelerator is activated. The I<accel-group> needs to be added to the widget’s toplevel via C<gtk-window-add-accel-group()>, and the signal must be of type C<G-SIGNAL-ACTION>. Accelerators added through this function are not user changeable during runtime. If you want to support accelerators that can be changed by the user, use C<gtk-accel-map-add-entry()> and C<set-accel-path()> or C<gtk-menu-item-set-accel-path()> instead.

  method add-accelerator ( Str $accel_signal, N-GObject $accel_group, UInt $accel_key, GdkModifierType $accel_mods, GtkAccelFlags $accel_flags )

=item Str $accel_signal; widget signal to emit on accelerator activation
=item N-GObject $accel_group; accel group for this widget, added to its toplevel
=item UInt $accel_key; GDK keyval of the accelerator
=item GdkModifierType $accel_mods; modifier key combination of the accelerator
=item GtkAccelFlags $accel_flags; flag accelerators, e.g. C<GTK-ACCEL-VISIBLE>

=end pod

method add-accelerator ( Str $accel_signal, $accel_group is copy, UInt $accel_key, GdkModifierType $accel_mods, GtkAccelFlags $accel_flags ) {
  $accel_group .= get-native-object-no-reffing unless $accel_group ~~ N-GObject;

  gtk_widget_add_accelerator(
    self._f('GtkWidget'), $accel_signal, $accel_group, $accel_key, $accel_mods, $accel_flags
  );
}

sub gtk_widget_add_accelerator (
  N-GObject $widget, gchar-ptr $accel_signal, N-GObject $accel_group, guint $accel_key, GEnum $accel_mods, GtkAccelFlags $accel_flags
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:add-device-events:
=begin pod
=head2 add-device-events

Adds the device events in the bitfield I<events> to the event mask for I<widget>. See C<set-device-events()> for details.

  method add-device-events ( N-GObject $device, N-GdkEventMask $events )

=item N-GObject $device; a B<Gnome::Gtk3::Device>
=item N-GdkEventMask $events; an event mask, see B<Gnome::Gtk3::EventMask>

=end pod

method add-device-events ( $device is copy, N-GdkEventMask $events ) {
  $device .= get-native-object-no-reffing unless $device ~~ N-GObject;

  gtk_widget_add_device_events(
    self._f('GtkWidget'), $device, $events
  );
}

sub gtk_widget_add_device_events (
  N-GObject $widget, N-GObject $device, GEnum $events
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-events:
=begin pod
=head2 add-events

Adds the events in the bitfield I<events> to the event mask for I<widget>. See C<set-events()> and the [input handling overview][event-masks] for details.

  method add-events ( Int $events )

=item Int $events; an event mask, see B<Gnome::Gtk3::EventMask>

=end pod

method add-events ( Int $events ) {

  gtk_widget_add_events(
    self._f('GtkWidget'), $events
  );
}

sub gtk_widget_add_events (
  N-GObject $widget, gint $events
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-mnemonic-label:
=begin pod
=head2 add-mnemonic-label

Adds a widget to the list of mnemonic labels for this widget. (See C<list-mnemonic-labels()>). Note the list of mnemonic labels for the widget is cleared when the widget is destroyed, so the caller must make sure to update its internal state at this point as well, by using a connection to the  I<destroy> signal or a weak notifier.

  method add-mnemonic-label ( N-GObject $label )

=item N-GObject $label; a B<Gnome::Gtk3::Widget> that acts as a mnemonic label for I<widget>

=end pod

method add-mnemonic-label ( $label is copy ) {
  $label .= get-native-object-no-reffing unless $label ~~ N-GObject;

  gtk_widget_add_mnemonic_label(
    self._f('GtkWidget'), $label
  );
}

sub gtk_widget_add_mnemonic_label (
  N-GObject $widget, N-GObject $label
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:add-tick-callback:
=begin pod
=head2 add-tick-callback

Queues an animation frame update and adds a callback to be called before each frame. Until the tick callback is removed, it will be called frequently (usually at the frame rate of the output device or as quickly as the application can be repainted, whichever is slower). For this reason, is most suitable for handling graphics that change every frame or every few frames. The tick callback does not automatically imply a relayout or repaint. If you want a repaint or relayout, and aren’t changing widget properties that would trigger that (for example, changing the text of a B<Gnome::Gtk3::Label>), then you will have to call C<queue-resize()> or C<queue-draw-area()> yourself.

C<gdk-frame-clock-get-frame-time()> should generally be used for timing continuous animations and C<gdk-frame-timings-get-predicted-presentation-time()> if you are trying to display isolated frames at particular times.

This is a more convenient alternative to connecting directly to the  I<update> signal of B<Gnome::Gtk3::FrameClock>, since you don't have to worry about when a B<Gnome::Gtk3::FrameClock> is assigned to a widget.

Returns: an id for the connection of this callback. Remove the callback by passing it to C<remove-tick-callback()>

  method add-tick-callback ( GtkTickCallback $callback, Pointer $user_data, GDestroyNotify $notify --> UInt )

=item GtkTickCallback $callback; function to call for updating animations
=item Pointer $user_data; data to pass to I<callback>
=item GDestroyNotify $notify; function to call to free I<user-data> when the callback is removed.

=end pod

method add-tick-callback ( GtkTickCallback $callback, Pointer $user_data, GDestroyNotify $notify --> UInt ) {

  gtk_widget_add_tick_callback(
    self._f('GtkWidget'), $callback, $user_data, $notify
  )
}

sub gtk_widget_add_tick_callback (
  N-GObject $widget, GtkTickCallback $callback, gpointer $user_data, GDestroyNotify $notify --> guint
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:can-activate-accel:
=begin pod
=head2 can-activate-accel

Determines whether an accelerator that activates the signal identified by I<signal-id> can currently be activated. This is done by emitting the  I<can-activate-accel> signal on I<widget>; if the signal isn’t overridden by a handler or in a derived widget, then the default check is that the widget must be sensitive, and the widget and all its ancestors mapped.

Returns: C<True> if the accelerator can be activated.

  method can-activate-accel ( UInt $signal_id --> Bool )

=item UInt $signal_id; the ID of a signal installed on I<widget>

=end pod

method can-activate-accel ( UInt $signal_id --> Bool ) {

  gtk_widget_can_activate_accel(
    self._f('GtkWidget'), $signal_id
  ).Bool
}

sub gtk_widget_can_activate_accel (
  N-GObject $widget, guint $signal_id --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:child-focus:
=begin pod
=head2 child-focus

This function is used by custom widget implementations; if you're writing an app, you’d use C<grab-focus()> to move the focus to a particular widget, and C<gtk-container-set-focus-chain()> to change the focus tab order. So you may want to investigate those functions instead.

C<child-focus()> is called by containers as the user moves around the window using keyboard shortcuts. I<direction> indicates what kind of motion is taking place (up, down, left, right, tab forward, tab backward). C<child-focus()> emits the  I<focus> signal; widgets override the default handler for this signal in order to implement appropriate focus behavior.

The default I<focus> handler for a widget should return C<True> if moving in I<direction> left the focus on a focusable location inside that widget, and C<False> if moving in I<direction> moved the focus outside the widget. If returning C<True>, widgets normally call C<grab-focus()> to place the focus accordingly; if returning C<False>, they don’t modify the current focus location.

Returns: C<True> if focus ended up inside I<widget>

  method child-focus ( GtkDirectionType $direction --> Bool )

=item GtkDirectionType $direction; direction of focus movement

=end pod

method child-focus ( GtkDirectionType $direction --> Bool ) {

  gtk_widget_child_focus(
    self._f('GtkWidget'), $direction
  ).Bool
}

sub gtk_widget_child_focus (
  N-GObject $widget, GEnum $direction --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:child-notify:
=begin pod
=head2 child-notify

Emits a  I<child-notify> signal for the [child property][child-properties] I<child-property> on I<widget>.

This is the analogue of C<g-object-notify()> for child properties.

Also see C<gtk-container-child-notify()>.

  method child-notify ( Str $child_property )

=item Str $child_property; the name of a child property installed on the class of I<widget>’s parent

=end pod

method child-notify ( Str $child_property ) {

  gtk_widget_child_notify(
    self._f('GtkWidget'), $child_property
  );
}

sub gtk_widget_child_notify (
  N-GObject $widget, gchar-ptr $child_property
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:class-bind-template-callback-full:
=begin pod
=head2 class-bind-template-callback-full

Declares a I<callback-symbol> to handle I<callback-name> from the template XML defined for I<widget-type>. See C<gtk-builder-add-callback-symbol()>.

Note that this must be called from a composite widget classes class initializer after calling C<class-set-template()>.

  method class-bind-template-callback-full ( GtkWidgetClass $widget_class, Str $callback_name, GCallback $callback_symbol )

=item GtkWidgetClass $widget_class; A B<Gnome::Gtk3::WidgetClass>
=item Str $callback_name; The name of the callback as expected in the template XML
=item GCallback $callback_symbol; (scope async): The callback symbol

=end pod

method class-bind-template-callback-full ( GtkWidgetClass $widget_class, Str $callback_name, GCallback $callback_symbol ) {

  gtk_widget_class_bind_template_callback_full(
    self._f('GtkWidget'), $widget_class, $callback_name, $callback_symbol
  );
}

sub gtk_widget_class_bind_template_callback_full (
  GtkWidgetClass $widget_class, gchar-ptr $callback_name, GCallback $callback_symbol
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:class-bind-template-child-full:
=begin pod
=head2 class-bind-template-child-full

Automatically assign an object declared in the class template XML to be set to a location on a freshly built instance’s private data, or alternatively accessible via C<get-template-child()>.

The struct can point either into the public instance, then you should use G-STRUCT-OFFSET(WidgetType, member) for I<struct-offset>, or in the private struct, then you should use G-PRIVATE-OFFSET(WidgetType, member).

An explicit strong reference will be held automatically for the duration of your instance’s life cycle, it will be released automatically when B<Gnome::Gtk3::ObjectClass>.C<dispose()> runs on your instance and if a I<struct-offset> that is != 0 is specified, then the automatic location in your instance public or private data will be set to C<undefined>. You can however access an automated child pointer the first time your classes B<Gnome::Gtk3::ObjectClass>.C<dispose()> runs, or alternatively in B<Gnome::Gtk3::WidgetClass>.C<destroy()>.

If I<internal-child> is specified, B<Gnome::Gtk3::BuildableIface>.C<get-internal-child()> will be automatically implemented by the B<Gnome::Gtk3::Widget> class so there is no need to implement it manually.

The wrapper macros C<class-bind-template-child()>, C<class-bind-template-child-internal()>, C<class-bind-template-child-private()> and C<class-bind-template-child-internal-private()> might be more convenient to use.

Note that this must be called from a composite widget classes class initializer after calling C<class-set-template()>.

  method class-bind-template-child-full ( GtkWidgetClass $widget_class, Str $name, Bool $internal_child, Int $struct_offset )

=item GtkWidgetClass $widget_class; A B<Gnome::Gtk3::WidgetClass>
=item Str $name; The “id” of the child defined in the template XML
=item Bool $internal_child; Whether the child should be accessible as an “internal-child” when this class is used in GtkBuilder XML
=item Int $struct_offset; The structure offset into the composite widget’s instance public or private structure where the automated child pointer should be set, or 0 to not assign the pointer.

=end pod

method class-bind-template-child-full ( GtkWidgetClass $widget_class, Str $name, Bool $internal_child, Int $struct_offset ) {

  gtk_widget_class_bind_template_child_full(
    self._f('GtkWidget'), $widget_class, $name, $internal_child, $struct_offset
  );
}

sub gtk_widget_class_bind_template_child_full (
  GtkWidgetClass $widget_class, gchar-ptr $name, gboolean $internal_child, gssize $struct_offset
) is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
#TM:0:class-find-style-property:
=begin pod
=head2 class-find-style-property

Finds a style property of a widget class by name.

Returns: : the B<Gnome::Gtk3::ParamSpec> of the style property or C<undefined> if I<class> has no style property with that name.

  method class-find-style-property ( GtkWidgetClass $klass, Str $property_name --> GParamSpec )

=item GtkWidgetClass $klass; a B<Gnome::Gtk3::WidgetClass>
=item Str $property_name; the name of the style property to find

=end pod

method class-find-style-property ( GtkWidgetClass $klass, Str $property_name --> GParamSpec ) {

  gtk_widget_class_find_style_property(
    self._f('GtkWidget'), $klass, $property_name
  )
}

sub gtk_widget_class_find_style_property (
  GtkWidgetClass $klass, gchar-ptr $property_name --> GParamSpec
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:class-get-css-name:
=begin pod
=head2 class-get-css-name

Gets the name used by this class for matching in CSS code. See C<class-set-css-name()> for details.

Returns: the CSS name of the given class

  method class-get-css-name ( GtkWidgetClass $widget_class --> Str )

=item GtkWidgetClass $widget_class; class to set the name on

=end pod

method class-get-css-name ( GtkWidgetClass $widget_class --> Str ) {

  gtk_widget_class_get_css_name(
    self._f('GtkWidget'), $widget_class
  )
}

sub gtk_widget_class_get_css_name (
  GtkWidgetClass $widget_class --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:class-install-style-property:
=begin pod
=head2 class-install-style-property

Installs a style property on a widget class. The parser for the style property is determined by the value type of I<pspec>.

  method class-install-style-property ( GtkWidgetClass $klass, GParamSpec $pspec )

=item GtkWidgetClass $klass; a B<Gnome::Gtk3::WidgetClass>
=item GParamSpec $pspec; the B<Gnome::Gtk3::ParamSpec> for the property

=end pod

method class-install-style-property ( GtkWidgetClass $klass, GParamSpec $pspec ) {

  gtk_widget_class_install_style_property(
    self._f('GtkWidget'), $klass, $pspec
  );
}

sub gtk_widget_class_install_style_property (
  GtkWidgetClass $klass, GParamSpec $pspec
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:class-install-style-property-parser:
=begin pod
=head2 class-install-style-property-parser

Installs a style property on a widget class.

  method class-install-style-property-parser ( GtkWidgetClass $klass, GParamSpec $pspec, GtkRcPropertyParser $parser )

=item GtkWidgetClass $klass; a B<Gnome::Gtk3::WidgetClass>
=item GParamSpec $pspec; the B<Gnome::Gtk3::ParamSpec> for the style property
=item GtkRcPropertyParser $parser; the parser for the style property

=end pod

method class-install-style-property-parser ( GtkWidgetClass $klass, GParamSpec $pspec, GtkRcPropertyParser $parser ) {

  gtk_widget_class_install_style_property_parser(
    self._f('GtkWidget'), $klass, $pspec, $parser
  );
}

sub gtk_widget_class_install_style_property_parser (
  GtkWidgetClass $klass, GParamSpec $pspec, GtkRcPropertyParser $parser
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:class-list-style-properties:
=begin pod
=head2 class-list-style-properties

Returns all style properties of a widget class.

Returns: (array length=n-properties) (transfer container): a newly allocated array of B<Gnome::Gtk3::ParamSpec>*. The array must be freed with C<g-free()>.

  method class-list-style-properties ( GtkWidgetClass $klass, guint $n_properties --> GParamSpec )

=item GtkWidgetClass $klass; a B<Gnome::Gtk3::WidgetClass>
=item guInt-ptr $n_properties; location to return the number of style properties found

=end pod

method class-list-style-properties ( GtkWidgetClass $klass, guInt-ptr $n_properties --> GParamSpec ) {

  gtk_widget_class_list_style_properties(
    self._f('GtkWidget'), $klass, $n_properties
  )
}

sub gtk_widget_class_list_style_properties (
  GtkWidgetClass $klass, gugint-ptr $n_properties --> GParamSpec
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:class-set-accessible-role:
=begin pod
=head2 class-set-accessible-role

Sets the default B<AtkRole> to be set on accessibles created for widgets of I<widget-class>. Accessibles may decide to not honor this setting if their role reporting is more refined. Calls to C<class-set-accessible-type()> will reset this value.

In cases where you want more fine-grained control over the role of accessibles created for I<widget-class>, you should provide your own accessible type and use C<class-set-accessible-type()> instead.

If I<role> is B<ATK-ROLE-INVALID>, the default role will not be changed and the accessible’s default role will be used instead.

This function should only be called from class init functions of widgets.

  method class-set-accessible-role ( GtkWidgetClass $widget_class, AtkRole $role )

=item GtkWidgetClass $widget_class; class to set the accessible role for
=item AtkRole $role; The role to use for accessibles created for I<widget-class>

=end pod

method class-set-accessible-role ( GtkWidgetClass $widget_class, AtkRole $role ) {

  gtk_widget_class_set_accessible_role(
    self._f('GtkWidget'), $widget_class, $role
  );
}

sub gtk_widget_class_set_accessible_role (
  GtkWidgetClass $widget_class, AtkRole $role
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:class-set-accessible-type:
=begin pod
=head2 class-set-accessible-type

Sets the type to be used for creating accessibles for widgets of I<widget-class>. The given I<type> must be a subtype of the type used for accessibles of the parent class.

This function should only be called from class init functions of widgets.

  method class-set-accessible-type ( GtkWidgetClass $widget_class, N-GObject $type )

=item GtkWidgetClass $widget_class; class to set the accessible type for
=item N-GObject $type; The object type that implements the accessible for I<widget-class>

=end pod

method class-set-accessible-type ( GtkWidgetClass $widget_class, $type is copy ) {
  $type .= get-native-object-no-reffing unless $type ~~ N-GObject;

  gtk_widget_class_set_accessible_type(
    self._f('GtkWidget'), $widget_class, $type
  );
}

sub gtk_widget_class_set_accessible_type (
  GtkWidgetClass $widget_class, N-GObject $type
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:class-set-connect-func:
=begin pod
=head2 class-set-connect-func

For use in language bindings, this will override the default B<Gnome::Gtk3::BuilderConnectFunc> to be used when parsing GtkBuilder XML from this class’s template data.

Note that this must be called from a composite widget classes class initializer after calling C<class-set-template()>.

  method class-set-connect-func ( GtkWidgetClass $widget_class, GtkBuilderConnectFunc $connect_func, Pointer $connect_data, GDestroyNotify $connect_data_destroy )

=item GtkWidgetClass $widget_class; A B<Gnome::Gtk3::WidgetClass>
=item GtkBuilderConnectFunc $connect_func; The B<Gnome::Gtk3::BuilderConnectFunc> to use when connecting signals in the class template
=item Pointer $connect_data; The data to pass to I<connect-func>
=item GDestroyNotify $connect_data_destroy; The B<Gnome::Gtk3::DestroyNotify> to free I<connect-data>, this will only be used at class finalization time, when no classes of type I<widget-type> are in use anymore.

=end pod

method class-set-connect-func ( GtkWidgetClass $widget_class, GtkBuilderConnectFunc $connect_func, Pointer $connect_data, GDestroyNotify $connect_data_destroy ) {

  gtk_widget_class_set_connect_func(
    self._f('GtkWidget'), $widget_class, $connect_func, $connect_data, $connect_data_destroy
  );
}

sub gtk_widget_class_set_connect_func (
  GtkWidgetClass $widget_class, GtkBuilderConnectFunc $connect_func, gpointer $connect_data, GDestroyNotify $connect_data_destroy
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:class-set-css-name:
=begin pod
=head2 class-set-css-name

Sets the name to be used for CSS matching of widgets.

If this function is not called for a given class, the name of the parent class is used.

  method class-set-css-name ( GtkWidgetClass $widget_class, Str $name )

=item GtkWidgetClass $widget_class; class to set the name on
=item Str $name; name to use

=end pod

method class-set-css-name ( GtkWidgetClass $widget_class, Str $name ) {

  gtk_widget_class_set_css_name(
    self._f('GtkWidget'), $widget_class, $name
  );
}

sub gtk_widget_class_set_css_name (
  GtkWidgetClass $widget_class, gchar-ptr $name
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:class-set-template:
=begin pod
=head2 class-set-template

This should be called at class initialization time to specify the GtkBuilder XML to be used to extend a widget.

For convenience, C<class-set-template-from-resource()> is also provided.

Note that any class that installs templates must call C<init-template()> in the widget’s instance initializer.

  method class-set-template ( GtkWidgetClass $widget_class, N-GObject $template_bytes )

=item GtkWidgetClass $widget_class; A B<Gnome::Gtk3::WidgetClass>
=item N-GObject $template_bytes; A B<Gnome::Gtk3::Bytes> holding the B<Gnome::Gtk3::Builder> XML

=end pod

method class-set-template ( GtkWidgetClass $widget_class, $template_bytes is copy ) {
  $template_bytes .= get-native-object-no-reffing unless $template_bytes ~~ N-GObject;

  gtk_widget_class_set_template(
    self._f('GtkWidget'), $widget_class, $template_bytes
  );
}

sub gtk_widget_class_set_template (
  GtkWidgetClass $widget_class, N-GObject $template_bytes
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:class-set-template-from-resource:
=begin pod
=head2 class-set-template-from-resource

A convenience function to call C<class-set-template()>.

Note that any class that installs templates must call C<init-template()> in the widget’s instance initializer.

  method class-set-template-from-resource ( GtkWidgetClass $widget_class, Str $resource_name )

=item GtkWidgetClass $widget_class; A B<Gnome::Gtk3::WidgetClass>
=item Str $resource_name; The name of the resource to load the template from

=end pod

method class-set-template-from-resource ( GtkWidgetClass $widget_class, Str $resource_name ) {

  gtk_widget_class_set_template_from_resource(
    self._f('GtkWidget'), $widget_class, $resource_name
  );
}

sub gtk_widget_class_set_template_from_resource (
  GtkWidgetClass $widget_class, gchar-ptr $resource_name
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:compute-expand:
=begin pod
=head2 compute-expand

Computes whether a container should give this widget extra space when possible. Containers should check this, rather than looking at C<get-hexpand()> or C<get-vexpand()>.

This function already checks whether the widget is visible, so visibility does not need to be checked separately. Non-visible widgets are not expanded.

The computed expand value uses either the expand setting explicitly set on the widget itself, or, if none has been explicitly set, the widget may expand if some of its children do.

Returns: whether widget tree rooted here should be expanded

  method compute-expand ( GtkOrientation $orientation --> Bool )

=item GtkOrientation $orientation; expand direction

=end pod

method compute-expand ( GtkOrientation $orientation --> Bool ) {

  gtk_widget_compute_expand(
    self._f('GtkWidget'), $orientation
  ).Bool
}

sub gtk_widget_compute_expand (
  N-GObject $widget, GEnum $orientation --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:create-pango-context:
=begin pod
=head2 create-pango-context

Creates a new B<PangoContext> with the appropriate font map, font options, font description, and base direction for drawing text for this widget. See also C<get-pango-context()>.

Returns: : the new B<PangoContext>

  method create-pango-context ( --> N-GObject )


=end pod

method create-pango-context ( --> N-GObject ) {

  gtk_widget_create_pango_context(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_create_pango_context (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:create-pango-layout:
=begin pod
=head2 create-pango-layout

Creates a new B<PangoLayout> with the appropriate font map, font description, and base direction for drawing text for this widget.

If you keep a B<PangoLayout> created in this way around, you need to re-create it when the widget B<PangoContext> is replaced. This can be tracked by using the  I<screen-changed> signal on the widget.

Returns: : the new B<PangoLayout>

  method create-pango-layout ( Str $text --> N-GObject )

=item Str $text; text to set on the layout (can be C<undefined>)

=end pod

method create-pango-layout ( Str $text --> N-GObject ) {

  gtk_widget_create_pango_layout(
    self._f('GtkWidget'), $text
  )
}

sub gtk_widget_create_pango_layout (
  N-GObject $widget, gchar-ptr $text --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:destroy:
=begin pod
=head2 destroy

Destroys a widget.

When a widget is destroyed all references it holds on other objects will be released:

- if the widget is inside a container, it will be removed from its parent - if the widget is a container, all its children will be destroyed, recursively - if the widget is a top level, it will be removed from the list of top level widgets that GTK+ maintains internally

It's expected that all references held on the widget will also be released; you should connect to the  I<destroy> signal if you hold a reference to I<widget> and you wish to remove it when this function is called. It is not necessary to do so if you are implementing a B<Gnome::Gtk3::Container>, as you'll be able to use the B<Gnome::Gtk3::ContainerClass>.C<remove()> virtual function for that.

It's important to notice that C<destroy()> will only cause the I<widget> to be finalized if no additional references, acquired using C<g-object-ref()>, are held on it. In case additional references are in place, the I<widget> will be in an "inert" state after calling this function; I<widget> will still point to valid memory, allowing you to release the references you hold, but you may not query the widget's own state.

You should typically call this function on top level widgets, and rarely on child widgets.

See also: C<gtk-container-remove()>

  method destroy ( )


=end pod

method destroy ( ) {

  gtk_widget_destroy(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_destroy (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:destroyed:
=begin pod
=head2 destroyed

This function sets *I<widget-pointer> to C<undefined> if I<widget-pointer> != C<undefined>. It’s intended to be used as a callback connected to the “destroy” signal of a widget. You connect C<destroyed()> as a signal handler, and pass the address of your widget variable as user data. Then when the widget is destroyed, the variable will be set to C<undefined>. Useful for example to avoid multiple copies of the same dialog.

  method destroyed ( N-GObject $widget_pointer )

=item N-GObject $widget_pointer;  : address of a variable that contains I<widget>

=end pod

method destroyed ( $widget_pointer is copy ) {
  $widget_pointer .= get-native-object-no-reffing unless $widget_pointer ~~ N-GObject;

  gtk_widget_destroyed(
    self._f('GtkWidget'), $widget_pointer
  );
}

sub gtk_widget_destroyed (
  N-GObject $widget, N-GObject $widget_pointer
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:device-is-shadowed:
=begin pod
=head2 device-is-shadowed

Returns C<True> if I<device> has been shadowed by a GTK+ device grab on another widget, so it would stop sending events to I<widget>. This may be used in the  I<grab-notify> signal to check for specific devices. See C<gtk-device-grab-add()>.

Returns: C<True> if there is an ongoing grab on I<device> by another B<Gnome::Gtk3::Widget> than I<widget>.

  method device-is-shadowed ( N-GObject $device --> Bool )

=item N-GObject $device; a B<Gnome::Gtk3::Device>

=end pod

method device-is-shadowed ( $device is copy --> Bool ) {
  $device .= get-native-object-no-reffing unless $device ~~ N-GObject;

  gtk_widget_device_is_shadowed(
    self._f('GtkWidget'), $device
  ).Bool
}

sub gtk_widget_device_is_shadowed (
  N-GObject $widget, N-GObject $device --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:draw:
=begin pod
=head2 draw

Draws I<widget> to I<cr>. The top left corner of the widget will be drawn to the currently set origin point of I<cr>.

You should pass a cairo context as I<cr> argument that is in an original state. Otherwise the resulting drawing is undefined. For example changing the operator using C<cairo-set-operator()> or the line width using C<cairo-set-line-width()> might have unwanted side effects. You may however change the context’s transform matrix - like with C<cairo-scale()>, C<cairo-translate()> or C<cairo-set-matrix()> and clip region with C<cairo-clip()> prior to calling this function. Also, it is fine to modify the context with C<cairo-save()> and C<cairo-push-group()> prior to calling this function.

Note that special-purpose widgets may contain special code for rendering to the screen and might appear differently on screen and when rendered using C<draw()>.

  method draw ( cairo_t $cr )

=item cairo_t $cr; a cairo context to draw to

=end pod

method draw ( cairo_t $cr ) {

  gtk_widget_draw(
    self._f('GtkWidget'), $cr
  );
}

sub gtk_widget_draw (
  N-GObject $widget, cairo_t $cr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:error-bell:
=begin pod
=head2 error-bell

Notifies the user about an input-related error on this widget. If the  I<gtk-error-bell> setting is C<True>, it calls C<gdk-window-beep()>, otherwise it does nothing.

Note that the effect of C<gdk-window-beep()> can be configured in many ways, depending on the windowing backend and the desktop environment or window manager that is used.

  method error-bell ( )


=end pod

method error-bell ( ) {

  gtk_widget_error_bell(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_error_bell (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:event:
=begin pod
=head2 event

Rarely-used function. This function is used to emit the event signals on a widget (those signals should never be emitted without using this function to do so). If you want to synthesize an event though, don’t use this function; instead, use C<gtk-main-do-event()> so the event will behave as if it were in the event queue. Don’t synthesize expose events; instead, use C<gdk-window-invalidate-rect()> to invalidate a region of the window.

Returns: return from the event signal emission (C<True> if the event was handled)

  method event ( GdkEvent $event --> Bool )

=item GdkEvent $event; a B<Gnome::Gtk3::Event>

=end pod

method event ( GdkEvent $event --> Bool ) {

  gtk_widget_event(
    self._f('GtkWidget'), $event
  ).Bool
}

sub gtk_widget_event (
  N-GObject $widget, GdkEvent $event --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:freeze-child-notify:
=begin pod
=head2 freeze-child-notify

Stops emission of  I<child-notify> signals on I<widget>. The signals are queued until C<thaw-child-notify()> is called on I<widget>.

This is the analogue of C<g-object-freeze-notify()> for child properties.

  method freeze-child-notify ( )


=end pod

method freeze-child-notify ( ) {

  gtk_widget_freeze_child_notify(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_freeze_child_notify (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-accessible:
=begin pod
=head2 get-accessible

Returns the accessible object that describes the widget to an assistive technology.

If accessibility support is not available, this B<AtkObject> instance may be a no-op. Likewise, if no class-specific B<AtkObject> implementation is available for the widget instance in question, it will inherit an B<AtkObject> implementation from the first ancestor class for which such an implementation is defined.

The documentation of the [ATK](http://developer.gnome.org/atk/stable/) library contains more information about accessible objects and their uses.

Returns: : the B<AtkObject> associated with I<widget>

  method get-accessible ( --> AtkObject )


=end pod

method get-accessible ( --> AtkObject ) {

  gtk_widget_get_accessible(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_accessible (
  N-GObject $widget --> AtkObject
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:get-action-group:
=begin pod
=head2 get-action-group

Retrieves the B<Gnome::Gtk3::ActionGroup> that was registered using I<prefix>. The resulting B<Gnome::Gtk3::ActionGroup> may have been registered to I<widget> or any B<Gnome::Gtk3::Widget> in its ancestry.

If no action group was found matching I<prefix>, then C<undefined> is returned.

Returns: A B<Gnome::Gtk3::ActionGroup> based object or C<undefined>.

  method get-action-group ( Str $prefix --> N-GObject )

=item Str $prefix; The “prefix” of the action group.

=end pod

method get-action-group ( Str $prefix --> N-GObject ) {
  gtk_widget_get_action_group( self._f('GtkWidget'), $prefix)
}

sub gtk_widget_get_action_group (
  N-GObject $widget, gchar-ptr $prefix --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-allocated-baseline:
=begin pod
=head2 get-allocated-baseline

Returns the baseline that has currently been allocated to I<widget>. This function is intended to be used when implementing handlers for the  I<draw> function, and when allocating child widgets in  I<size-allocate>.

Returns: the baseline of the I<widget>, or -1 if none

  method get-allocated-baseline ( --> Int )


=end pod

method get-allocated-baseline ( --> Int ) {

  gtk_widget_get_allocated_baseline(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_allocated_baseline (
  N-GObject $widget --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-allocated-height:
=begin pod
=head2 get-allocated-height

Returns the height that has currently been allocated to I<widget>. This function is intended to be used when implementing handlers for the  I<draw> function.

Returns: the height of the I<widget>

  method get-allocated-height ( --> Int )


=end pod

method get-allocated-height ( --> Int ) {

  gtk_widget_get_allocated_height(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_allocated_height (
  N-GObject $widget --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-allocated-size:
=begin pod
=head2 get-allocated-size

Retrieves the widget’s allocated size.

This function returns the last values passed to C<size-allocate-with-baseline()>. The value differs from the size returned in C<get-allocation()> in that functions like C<set-halign()> can adjust the allocation, but not the value returned by this function.

If a widget is not visible, its allocated size is 0.

  method get-allocated-size ( --> List )

returns a List with
=item N-GtkAllocation
=item int32 $baseline

=end pod

method get-allocated-size ( --> List ) {
  my N-GtkAllocation $a .= new;
  my gint32 $b;
  gtk_widget_get_allocated_size(
    self._f('GtkWidget'), $a, $b
  );

  ( $a, $b)
}

#`{{
sub gtk_widget_get_allocated_size ( N-GObject $widget --> List ) {
   my N-GtkAllocation $a .= new;
   my int32 $b;
   _gtk_widget_get_allocated_size( $widget, $a, $b);

  ( $a, $b)
}
}}

sub gtk_widget_get_allocated_size (
  N-GObject $widget, N-GtkAllocation $allocation, gint $baseline is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-allocated-width:
=begin pod
=head2 get-allocated-width

Returns the width that has currently been allocated to I<widget>. This function is intended to be used when implementing handlers for the  I<draw> function.

Returns: the width of the I<widget>

  method get-allocated-width ( --> Int )


=end pod

method get-allocated-width ( --> Int ) {

  gtk_widget_get_allocated_width(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_allocated_width (
  N-GObject $widget --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-allocation:
=begin pod
=head2 get-allocation

Retrieves the widget’s allocation.

Note, when implementing a B<Gnome::Gtk3::Container>: a widget’s allocation will be its “adjusted” allocation, that is, the widget’s parent container typically calls C<size-allocate()> with an allocation, and that allocation is then adjusted (to handle margin and alignment for example) before assignment to the widget. C<get-allocation()> returns the adjusted allocation that was actually assigned to the widget. The adjusted allocation is guaranteed to be completely contained within the C<size-allocate()> allocation, however. So a B<Gnome::Gtk3::Container> is guaranteed that its children stay inside the assigned bounds, but not that they have exactly the bounds the container assigned. There is no way to get the original allocation assigned by C<size-allocate()>, since it isn’t stored; if a container implementation needs that information it will have to track it itself.

  method get-allocation ( --> N-GtkAllocation )

Returns a N-GtkAllocation

=end pod

method get-allocation ( --> N-GtkAllocation ) {
  my N-GtkAllocation $allocation .= new;
  gtk_widget_get_allocation( self._f('GtkWidget'), $allocation);
  $allocation
}

sub gtk_widget_get_allocation (
  N-GObject $widget, N-GtkAllocation $allocation
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-ancestor:
=begin pod
=head2 get-ancestor

Gets the first ancestor of I<widget> with type I<widget-type>. For example, `get-ancestor (widget, GTK-TYPE-BOX)` gets the first B<Gnome::Gtk3::Box> that’s an ancestor of I<widget>. No reference will be added to the returned widget; it should not be unreferenced. See note about checking for a toplevel B<Gnome::Gtk3::Window> in the docs for C<get-toplevel()>.

Note that unlike C<is-ancestor()>, C<get-ancestor()> considers I<widget> to be an ancestor of itself.

Returns: the ancestor widget, or C<undefined> if not found

  method get-ancestor ( N-GObject $widget_type --> N-GObject )

=item N-GObject $widget_type; ancestor type

=end pod

method get-ancestor ( $widget_type is copy --> N-GObject ) {
  $widget_type .= get-native-object-no-reffing unless $widget_type ~~ N-GObject;

  gtk_widget_get_ancestor(
    self._f('GtkWidget'), $widget_type
  )
}

sub gtk_widget_get_ancestor (
  N-GObject $widget, N-GObject $widget_type --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-app-paintable:
=begin pod
=head2 get-app-paintable

Determines whether the application intends to draw on the widget in an  I<draw> handler.

See C<set-app-paintable()>

Returns: C<True> if the widget is app paintable

  method get-app-paintable ( --> Bool )


=end pod

method get-app-paintable ( --> Bool ) {

  gtk_widget_get_app_paintable(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_app_paintable (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-can-default:
=begin pod
=head2 get-can-default

Determines whether I<widget> can be a default widget. See C<set-can-default()>.

Returns: C<True> if I<widget> can be a default widget, C<False> otherwise

  method get-can-default ( --> Bool )


=end pod

method get-can-default ( --> Bool ) {

  gtk_widget_get_can_default(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_can_default (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-can-focus:
=begin pod
=head2 get-can-focus

Determines whether I<widget> can own the input focus. See C<set-can-focus()>.

Returns: C<True> if I<widget> can own the input focus, C<False> otherwise

  method get-can-focus ( --> Bool )


=end pod

method get-can-focus ( --> Bool ) {

  gtk_widget_get_can_focus(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_can_focus (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-child-visible:
=begin pod
=head2 get-child-visible

Gets the value set with C<set-child-visible()>. If you feel a need to use this function, your code probably needs reorganization.

This function is only useful for container implementations and never should be called by an application.

Returns: C<True> if the widget is mapped with the parent.

  method get-child-visible ( --> Bool )


=end pod

method get-child-visible ( --> Bool ) {

  gtk_widget_get_child_visible(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_child_visible (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-clip:
=begin pod
=head2 get-clip

Retrieves the widget’s clip area.

The clip area is the area in which all of I<widget>'s drawing will happen. Other toolkits call it the bounding box.

Historically, in GTK+ the clip area has been equal to the allocation retrieved via C<get-allocation()>.

  method get-clip ( --> N-GtkAllocation )

Returns a N-GtkAllocation clip

=end pod

method get-clip ( --> N-GtkAllocation ) {
  my N-GtkAllocation $clip .= new;
  gtk_widget_get_clip( self._f('GtkWidget'), $clip);
  $clip
}

sub gtk_widget_get_clip (
  N-GObject $widget, N-GtkAllocation $clip
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-clipboard:
=begin pod
=head2 get-clipboard

Returns the clipboard object for the given selection to be used with I<widget>. I<widget> must have a B<Gnome::Gtk3::Display> associated with it, so must be attached to a toplevel window.

Returns: : the appropriate clipboard object. If no clipboard already exists, a new one will be created. Once a clipboard object has been created, it is persistent for all time.

  method get-clipboard ( GdkAtom $selection --> N-GObject )

=item GdkAtom $selection; a B<Gnome::Gtk3::Atom> which identifies the clipboard to use. C<GDK-SELECTION-CLIPBOARD> gives the default clipboard. Another common value is C<GDK-SELECTION-PRIMARY>, which gives the primary X selection.

=end pod

method get-clipboard ( GdkAtom $selection --> N-GObject ) {

  gtk_widget_get_clipboard(
    self._f('GtkWidget'), $selection
  )
}

sub gtk_widget_get_clipboard (
  N-GObject $widget, GdkAtom $selection --> N-GObject
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:get-default-direction:
=begin pod
=head2 get-default-direction

Obtains the current default reading direction. See C<set-default-direction()>.

Returns: the current default direction.

  method get-default-direction ( --> GtkTextDirection )

=end pod

method get-default-direction ( --> GtkTextDirection ) {
  GtkTextDirection(gtk_widget_get_default_direction())
}

sub gtk_widget_get_default_direction ( --> GEnum )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-device-enabled:
=begin pod
=head2 get-device-enabled

Returns whether I<device> can interact with I<widget> and its children. See C<set-device-enabled()>.

Returns: C<True> is I<device> is enabled for I<widget>

  method get-device-enabled ( N-GObject $device --> Bool )

=item N-GObject $device; a B<Gnome::Gtk3::Device>

=end pod

method get-device-enabled ( $device is copy --> Bool ) {
  $device .= get-native-object-no-reffing unless $device ~~ N-GObject;

  gtk_widget_get_device_enabled(
    self._f('GtkWidget'), $device
  ).Bool
}

sub gtk_widget_get_device_enabled (
  N-GObject $widget, N-GObject $device --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-device-events:
=begin pod
=head2 get-device-events

Returns the events mask for the widget corresponding to an specific device. These are the events that the widget will receive when I<device> operates on it. Flags in this mask are from C<N-GdkEventMask>.

Returns: device event mask for I<widget>

  method get-device-events ( N-GObject $device --> Int )

=item N-GObject $device; a B<Gnome::Gtk3::Device>

=end pod

method get-device-events ( $device is copy --> Int ) {
  $device .= get-native-object-no-reffing unless $device ~~ N-GObject;
  gtk_widget_get_device_events( self._f('GtkWidget'), $device)
}

sub gtk_widget_get_device_events (
  N-GObject $widget, N-GObject $device --> GFlag
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-direction:
=begin pod
=head2 get-direction

Gets the reading direction for a particular widget. See C<set-direction()>.

Returns: the reading direction for the widget.

  method get-direction ( --> GtkTextDirection )


=end pod

method get-direction ( --> GtkTextDirection ) {
  GtkTextDirection(gtk_widget_get_direction(self._f('GtkWidget')))
}

sub gtk_widget_get_direction (
  N-GObject $widget --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-display:
=begin pod
=head2 get-display

Get the B<Gnome::Gtk3::Display> for the toplevel window associated with this widget. This function can only be called after the widget has been added to a widget hierarchy with a B<Gnome::Gtk3::Window> at the top.

In general, you should only create display specific resources when a widget has been realized, and you should free those resources when the widget is unrealized.

Returns: : the B<Gnome::Gtk3::Display> for the toplevel for this widget.

  method get-display ( --> N-GObject )


=end pod

method get-display ( --> N-GObject ) {

  gtk_widget_get_display(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_display (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-events:
=begin pod
=head2 get-events

Returns the event mask (see B<Gnome::Gtk3::EventMask>) for the widget. These are the events that the widget will receive.

Note: Internally, the widget event mask will be the logical OR of the event mask set through C<set-events()> or C<add-events()>, and the event mask necessary to cater for every B<Gnome::Gtk3::EventController> created for the widget.

Returns: event mask for I<widget>

  method get-events ( --> Int )


=end pod

method get-events ( --> Int ) {

  gtk_widget_get_events(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_events (
  N-GObject $widget --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-focus-on-click:
=begin pod
=head2 get-focus-on-click

Returns whether the widget should grab focus when it is clicked with the mouse. See C<set-focus-on-click()>.

Returns: C<True> if the widget should grab focus when it is clicked with the mouse.

  method get-focus-on-click ( --> Bool )


=end pod

method get-focus-on-click ( --> Bool ) {

  gtk_widget_get_focus_on_click(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_focus_on_click (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-font-map:
=begin pod
=head2 get-font-map

Gets the font map that has been set with C<set-font-map()>.

Returns: A B<PangoFontMap>, or C<undefined>

  method get-font-map ( --> N-GObject )


=end pod

method get-font-map ( --> N-GObject ) {

  gtk_widget_get_font_map(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_font_map (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-font-options:
=begin pod
=head2 get-font-options

Returns the B<cairo-font-options-t> used for Pango rendering. When not set, the defaults font options for the B<Gnome::Gtk3::Screen> will be used.

Returns: the B<cairo-font-options-t> or C<undefined> if not set

  method get-font-options ( --> cairo_font_options_t )


=end pod

method get-font-options ( --> cairo_font_options_t ) {

  gtk_widget_get_font_options(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_font_options (
  N-GObject $widget --> cairo_font_options_t
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-frame-clock:
=begin pod
=head2 get-frame-clock

Obtains the frame clock for a widget. The frame clock is a global “ticker” that can be used to drive animations and repaints. The most common reason to get the frame clock is to call C<gdk-frame-clock-get-frame-time()>, in order to get a time to use for animating. For example you might record the start of the animation with an initial value from C<gdk-frame-clock-get-frame-time()>, and then update the animation by calling C<gdk-frame-clock-get-frame-time()> again during each repaint.

C<gdk-frame-clock-request-phase()> will result in a new frame on the clock, but won’t necessarily repaint any widgets. To repaint a widget, you have to use C<queue-draw()> which invalidates the widget (thus scheduling it to receive a draw on the next frame). C<queue-draw()> will also end up requesting a frame on the appropriate frame clock.

A widget’s frame clock will not change while the widget is mapped. Reparenting a widget (which implies a temporary unmap) can change the widget’s frame clock.

Unrealized widgets do not have a frame clock.

Returns: a B<Gnome::Gtk3::FrameClock>, or C<undefined> if widget is unrealized

  method get-frame-clock ( --> N-GObject )


=end pod

method get-frame-clock ( --> N-GObject ) {

  gtk_widget_get_frame_clock(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_frame_clock (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-halign:
=begin pod
=head2 get-halign

Gets the value of the  I<halign> property.

For backwards compatibility reasons this method will never return C<GTK-ALIGN-BASELINE>, but instead it will convert it to C<GTK-ALIGN-FILL>. Baselines are not supported for horizontal alignment.

Returns: the horizontal alignment of I<widget>

  method get-halign ( --> GtkAlign )


=end pod

method get-halign ( --> GtkAlign ) {
  GtkAlign(gtk_widget_get_halign(self._f('GtkWidget')))
}

sub gtk_widget_get_halign (
  N-GObject $widget --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-has-tooltip:
=begin pod
=head2 get-has-tooltip

Returns the current value of the has-tooltip property. See  I<has-tooltip> for more information.

Returns: current value of has-tooltip on I<widget>.

  method get-has-tooltip ( --> Bool )


=end pod

method get-has-tooltip ( --> Bool ) {

  gtk_widget_get_has_tooltip(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_has_tooltip (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-has-window:
=begin pod
=head2 get-has-window

Determines whether I<widget> has a B<Gnome::Gtk3::Window> of its own. See C<set-has-window()>.

Returns: C<True> if I<widget> has a window, C<False> otherwise

  method get-has-window ( --> Bool )


=end pod

method get-has-window ( --> Bool ) {

  gtk_widget_get_has_window(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_has_window (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-hexpand:
=begin pod
=head2 get-hexpand

Gets whether the widget would like any available extra horizontal space. When a user resizes a B<Gnome::Gtk3::Window>, widgets with expand=TRUE generally receive the extra space. For example, a list or scrollable area or document in your window would often be set to expand.

Containers should use C<compute-expand()> rather than this function, to see whether a widget, or any of its children, has the expand flag set. If any child of a widget wants to expand, the parent may ask to expand also.

This function only looks at the widget’s own hexpand flag, rather than computing whether the entire widget tree rooted at this widget wants to expand.

Returns: whether hexpand flag is set

  method get-hexpand ( --> Bool )


=end pod

method get-hexpand ( --> Bool ) {

  gtk_widget_get_hexpand(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_hexpand (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-hexpand-set:
=begin pod
=head2 get-hexpand-set

Gets whether C<set-hexpand()> has been used to explicitly set the expand flag on this widget.

If hexpand is set, then it overrides any computed expand value based on child widgets. If hexpand is not set, then the expand value depends on whether any children of the widget would like to expand.

There are few reasons to use this function, but it’s here for completeness and consistency.

Returns: whether hexpand has been explicitly set

  method get-hexpand-set ( --> Bool )


=end pod

method get-hexpand-set ( --> Bool ) {

  gtk_widget_get_hexpand_set(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_hexpand_set (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-mapped:
=begin pod
=head2 get-mapped

Whether the widget is mapped.

Returns: C<True> if the widget is mapped, C<False> otherwise.

  method get-mapped ( --> Bool )


=end pod

method get-mapped ( --> Bool ) {

  gtk_widget_get_mapped(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_mapped (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-margin-bottom:
=begin pod
=head2 get-margin-bottom

Gets the value of the  I<margin-bottom> property.

Returns: The bottom margin of I<widget>

  method get-margin-bottom ( --> Int )


=end pod

method get-margin-bottom ( --> Int ) {

  gtk_widget_get_margin_bottom(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_margin_bottom (
  N-GObject $widget --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-margin-end:
=begin pod
=head2 get-margin-end

Gets the value of the  I<margin-end> property.

Returns: The end margin of I<widget>

  method get-margin-end ( --> Int )


=end pod

method get-margin-end ( --> Int ) {

  gtk_widget_get_margin_end(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_margin_end (
  N-GObject $widget --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-margin-start:
=begin pod
=head2 get-margin-start

Gets the value of the  I<margin-start> property.

Returns: The start margin of I<widget>

  method get-margin-start ( --> Int )


=end pod

method get-margin-start ( --> Int ) {

  gtk_widget_get_margin_start(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_margin_start (
  N-GObject $widget --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-margin-top:
=begin pod
=head2 get-margin-top

Gets the value of the  I<margin-top> property.

Returns: The top margin of I<widget>

  method get-margin-top ( --> Int )


=end pod

method get-margin-top ( --> Int ) {

  gtk_widget_get_margin_top(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_margin_top (
  N-GObject $widget --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-modifier-mask:
=begin pod
=head2 get-modifier-mask

Returns the modifier mask the I<widget>’s windowing system backend uses for a particular purpose.

See C<gdk-keymap-get-modifier-mask()>.

Returns: the modifier mask used for I<intent>.

  method get-modifier-mask ( GdkModifierIntent $intent --> GdkModifierType )

=item GdkModifierIntent $intent; the use case for the modifier mask

=end pod

method get-modifier-mask ( GdkModifierIntent $intent --> GdkModifierType ) {
  GdkModifierType(gtk_widget_get_modifier_mask(self._f('GtkWidget'), $intent))
}

sub gtk_widget_get_modifier_mask (
  N-GObject $widget, GEnum $intent --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-name:
=begin pod
=head2 get-name

Retrieves the name of a widget. See C<set-name()> for the significance of widget names.

Returns: name of the widget. This string is owned by GTK+ and should not be modified or freed

  method get-name ( --> Str )


=end pod

method get-name ( --> Str ) {

  gtk_widget_get_name(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_name (
  N-GObject $widget --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-no-show-all:
=begin pod
=head2 get-no-show-all

Returns the current value of the  I<no-show-all> property, which determines whether calls to C<show-all()> will affect this widget.

Returns: the current value of the “no-show-all” property.

  method get-no-show-all ( --> Bool )


=end pod

method get-no-show-all ( --> Bool ) {

  gtk_widget_get_no_show_all(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_no_show_all (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-opacity:
=begin pod
=head2 get-opacity

Fetches the requested opacity for this widget. See C<set-opacity()>.

Returns: the requested opacity for this widget.

  method get-opacity ( --> Num )

=end pod

method get-opacity ( --> Num ) {
  gtk_widget_get_opacity(self._f('GtkWidget'))
}

sub gtk_widget_get_opacity (
  N-GObject $widget --> gdouble
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-pango-context:
=begin pod
=head2 get-pango-context

Gets a B<PangoContext> with the appropriate font map, font description, and base direction for this widget. Unlike the context returned by C<create-pango-context()>, this context is owned by the widget (it can be used until the screen for the widget changes or the widget is removed from its toplevel), and will be updated to match any changes to the widget’s attributes. This can be tracked by using the  I<screen-changed> signal on the widget.

Returns: : the B<PangoContext> for the widget.

  method get-pango-context ( --> N-GObject )


=end pod

method get-pango-context ( --> N-GObject ) {

  gtk_widget_get_pango_context(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_pango_context (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-parent:
=begin pod
=head2 get-parent

Returns the parent container of I<widget> or C<undefined>.

  method get-parent ( --> N-GObject )

=end pod

method get-parent ( --> N-GObject ) {
  gtk_widget_get_parent(self._f('GtkWidget'))
}

sub gtk_widget_get_parent (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-parent-window:
=begin pod
=head2 get-parent-window

Gets I<widget>’s parent window, or C<undefined> if it does not have one.

Returns: the parent window of I<widget>, or C<undefined> if it does not have a parent window.

  method get-parent-window ( --> N-GObject )

=end pod

method get-parent-window ( --> N-GObject ) {
  gtk_widget_get_parent_window(self._f('GtkWidget'))
}

sub gtk_widget_get_parent_window (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-path:
=begin pod
=head2 get-path

Returns the B<Gnome::Gtk3::WidgetPath> representing I<widget>, if the widget is not connected to a toplevel widget, a partial path will be created.

Returns: The B<Gnome::Gtk3::WidgetPath> representing I<widget>

  method get-path ( --> N-GObject )

=end pod

method get-path ( --> N-GObject ) {
  gtk_widget_get_path(self._f('GtkWidget'))
}

sub gtk_widget_get_path (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-preferred-height:
=begin pod
=head2 get-preferred-height

Retrieves a widget’s initial minimum and natural height.

This call is specific to width-for-height requests.

The returned request will be modified by the GtkWidgetClass::adjust_size_request virtual method and by any GtkSizeGroups that have been applied. That is, the returned request is the one that should be used for layout, not necessarily the one returned by the widget itself.

  method get-preferred-height ( --> List )

Returns a List with
=item Int minimum_height;
=item Int natural_height;

=end pod

method get-preferred-height ( --> List ) {
  my int $minimum;
  my int $natural;

  gtk_widget_get_preferred_height( self._f('GtkWidget'), $minimum, $natural);
  ( $minimum, $natural)
}

sub gtk_widget_get_preferred_height (
  N-GObject $widget, gint $minimum_height is rw, gint $natural_height is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-preferred-height-and-baseline-for-width:
=begin pod
=head2 get-preferred-height-and-baseline-for-width

Retrieves a widget’s minimum and natural height and the corresponding baselines if it would be given the specified width , or the default height if width is -1. The baselines may be -1 which means that no baseline is requested for this widget.

The returned request will be modified by the GtkWidgetClass::adjust_size_request and GtkWidgetClass::adjust_baseline_request virtual methods and by any GtkSizeGroups that have been applied. That is, the returned request is the one that should be used for layout, not necessarily the one returned by the widget itself.

  method get-preferred-height-and-baseline-for-width (
    Int $width --> List
  )

=item Int $width;

Returns a List containing;
=item Int minimum_height;
=item Int natural_height;
=item Int minimum_baseline;
=item Int natural_baseline;

=end pod

method get-preferred-height-and-baseline-for-width ( Int $width --> List ) {
  my gint $minimum_height;
  my gint $natural_height;
  my gint $minimum_baseline;
  my gint $natural_baseline;

  gtk_widget_get_preferred_height_and_baseline_for_width(
    self._f('GtkWidget'), $width, $minimum_height, $natural_height, $minimum_baseline, $natural_baseline
  );

  ( $minimum_height, $natural_height, $minimum_baseline, $natural_baseline)
}

sub gtk_widget_get_preferred_height_and_baseline_for_width (
  N-GObject $widget, gint $width, gint $minimum_height is rw,
  gint $natural_height is rw, gint $minimum_baseline is rw,
  gint $natural_baseline is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-preferred-height-for-width:
=begin pod
=head2 get-preferred-height-for-width

Retrieves a widget’s minimum and natural height if it would be given the specified width .

=comment The returned request will be modified by the GtkWidgetClass::adjust_size_request virtual method and by any GtkSizeGroups that have been applied. That is, the returned request is the one that should be used for layout, not necessarily the one returned by the widget itself.

  method get-preferred-height-for-width ( Int $width --> List )

=item Int $width;

Returning a List with
=item Int minimum_height;
=item Int natural_height;

=end pod

method get-preferred-height-for-width ( Int $width --> List ) {
  my gint $minimum_height;
  my gint $natural_height;

  gtk_widget_get_preferred_height_for_width(
    self._f('GtkWidget'), $width, $minimum_height, $natural_height
  );

  ( $minimum_height, $natural_height)
}

sub gtk_widget_get_preferred_height_for_width (
  N-GObject $widget, gint $width, gint $minimum_height is rw, gint $natural_height is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-preferred-size:
=begin pod
=head2 get-preferred-size

Retrieves the minimum and natural size of a widget, taking into account the widget’s preference for height-for-width management.

This is used to retrieve a suitable size by container widgets which do not impose any restrictions on the child placement. It can be used to deduce toplevel window and menu sizes as well as child widgets in free-form containers such as GtkLayout.

Handle with care. Note that the natural height of a height-for-width widget will generally be a smaller size than the minimum height, since the required height for the natural width is generally smaller than the required height for the minimum width.

Use gtk_widget_get_preferred_height_and_baseline_for_width() if you want to support baseline alignment.

  method get-preferred-size ( --> List )

The returned list holds
=item N-GtkRequisition $minimum_size;
=item N-GtkRequisition $natural_size;

=end pod

method get-preferred-size ( --> List ) {
  my N-GtkRequisition $minimum .= new;
  my N-GtkRequisition $natural .= new;

  gtk_widget_get_preferred_size( self._f('GtkWidget'), $minimum, $natural);
  ( $minimum, $natural)
}

sub gtk_widget_get_preferred_size (
  N-GObject $widget, N-GtkRequisition $minimum_size, N-GtkRequisition $natural_size
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-preferred-width:
=begin pod
=head2 get-preferred-width

Retrieves a widget’s initial minimum and natural width.

This call is specific to height-for-width requests.

The returned request will be modified by the GtkWidgetClass::adjust_size_request virtual method and by any GtkSizeGroups that have been applied. That is, the returned request is the one that should be used for layout, not necessarily the one returned by the widget itself.

  method get-preferred-width ( --> List )

Returned List holds;
=item Int minimum_width;
=item Int natural_width;

=end pod

method get-preferred-width ( --> List ) {
  my gint $minimum_width;
  my gint $natural_width;

  gtk_widget_get_preferred_width(
    self._f('GtkWidget'), $minimum_width, $natural_width
  );

  ( $minimum_width, $natural_width)
}

sub gtk_widget_get_preferred_width (
  N-GObject $widget, gint $minimum_width is rw, gint $natural_width is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-preferred-width-for-height:
=begin pod
=head2 get-preferred-width-for-height

Retrieves a widget’s minimum and natural width if it would be given the specified height .

The returned request will be modified by the GtkWidgetClass::adjust_size_request virtual method and by any GtkSizeGroups that have been applied. That is, the returned request is the one that should be used for layout, not necessarily the one returned by the widget itself.

  method get-preferred-width-for-height ( Int $height --> List )

=item Int $height;

The returned List holds
=item Int minimum_width;
=item Int natural_width;

=end pod

method get-preferred-width-for-height ( Int $height--> List ) {
  my gint $minimum_width;
  my gint $natural_width;

  gtk_widget_get_preferred_width_for_height(
    self._f('GtkWidget'), $height, $minimum_width, $natural_width
  );

  ( $minimum_width, $natural_width)
}

sub gtk_widget_get_preferred_width_for_height (
  N-GObject $widget, gint $height, gint $minimum_width is rw, gint $natural_width is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-realized:
=begin pod
=head2 get-realized

Determines whether I<widget> is realized.

Returns: C<True> if I<widget> is realized, C<False> otherwise

  method get-realized ( --> Bool )


=end pod

method get-realized ( --> Bool ) {

  gtk_widget_get_realized(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_realized (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-receives-default:
=begin pod
=head2 get-receives-default

Determines whether I<widget> is always treated as the default widget within its toplevel when it has the focus, even if another widget is the default.

See C<set-receives-default()>.

Returns: C<True> if I<widget> acts as the default widget when focused, C<False> otherwise

  method get-receives-default ( --> Bool )


=end pod

method get-receives-default ( --> Bool ) {

  gtk_widget_get_receives_default(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_receives_default (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-request-mode:
=begin pod
=head2 get-request-mode

Gets whether the widget prefers a height-for-width layout or a width-for-height layout.

GtkBin widgets generally propagate the preference of their child, container widgets need to request something either in context of their children or in context of their allocation capabilities.

  method get-request-mode ( --> GtkSizeRequestMode )

=end pod

method get-request-mode ( --> GtkSizeRequestMode ) {
  GtkSizeRequestMode(gtk_widget_get_request_mode(self._f('GtkWidget')))
}

sub gtk_widget_get_request_mode (
  N-GObject $widget --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-scale-factor:
=begin pod
=head2 get-scale-factor

Retrieves the internal scale factor that maps from window coordinates to the actual device pixels. On traditional systems this is 1, on high density outputs, it can be a higher value (typically 2).

See C<gdk-window-get-scale-factor()>.

Returns: the scale factor for I<widget>

  method get-scale-factor ( --> Int )


=end pod

method get-scale-factor ( --> Int ) {

  gtk_widget_get_scale_factor(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_scale_factor (
  N-GObject $widget --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-screen:
=begin pod
=head2 get-screen

Get the B<Gnome::Gtk3::Screen> from the toplevel window associated with this widget. This function can only be called after the widget has been added to a widget hierarchy with a B<Gnome::Gtk3::Window> at the top.

In general, you should only create screen specific resources when a widget has been realized, and you should free those resources when the widget is unrealized.

Returns: : the B<Gnome::Gtk3::Screen> for the toplevel for this widget.

  method get-screen ( --> N-GObject )


=end pod

method get-screen ( --> N-GObject ) {

  gtk_widget_get_screen(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_screen (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-sensitive:
=begin pod
=head2 get-sensitive

Returns the widget’s sensitivity (in the sense of returning the value that has been set using C<set-sensitive()>).

The effective sensitivity of a widget is however determined by both its own and its parent widget’s sensitivity. See C<is-sensitive()>.

Returns: C<True> if the widget is sensitive

  method get-sensitive ( --> Bool )


=end pod

method get-sensitive ( --> Bool ) {

  gtk_widget_get_sensitive(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_sensitive (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-settings:
=begin pod
=head2 get-settings

Gets the settings object holding the settings used for this widget.

Note that this function can only be called when the B<Gnome::Gtk3::Widget> is attached to a toplevel, since the settings object is specific to a particular B<Gnome::Gtk3::Screen>.

Returns: : the relevant B<Gnome::Gtk3::Settings> object

  method get-settings ( --> N-GObject )


=end pod

method get-settings ( --> N-GObject ) {

  gtk_widget_get_settings(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_settings (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-size-request:
=begin pod
=head2 get-size-request

Gets the size request that was explicitly set for the widget using C<set-size-request()>. A value of -1 stored in I<width> or I<height> indicates that that dimension has not been set explicitly and the natural requisition of the widget will be used instead. See C<set-size-request()>. To get the size a widget will actually request, call C<get-preferred-size()> instead of this function.

  method get-size-request ( --> List )

Returned List holds;
=item Int width; return location for width, or C<undefined>
=item Int height; return location for height, or C<undefined>

=end pod

method get-size-request ( --> List ) {
  my gint $width;
  my gint $height;
  gtk_widget_get_size_request(self._f('GtkWidget'), $width, $height);
  ( $width, $height)
}

sub gtk_widget_get_size_request (
  N-GObject $widget, gint $width is rw, gint $height is rw
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-state-flags:
=begin pod
=head2 get-state-flags

Returns the widget state as a flag set. It is worth mentioning that the effective C<GTK-STATE-FLAG-INSENSITIVE> state will be returned, that is, also based on parent insensitivity, even if I<widget> itself is sensitive.

Also note that if you are looking for a way to obtain the B<Gnome::Gtk3::StateFlags> to pass to a B<Gnome::Gtk3::StyleContext> method, you should look at C<gtk-style-context-get-state()>.

Returns: The state flags for widget

  method get-state-flags ( --> GtkStateFlags )


=end pod

method get-state-flags ( --> GtkStateFlags ) {
  GtkStateFlags(gtk_widget_get_state_flags(self._f('GtkWidget')))
}

sub gtk_widget_get_state_flags (
  N-GObject $widget --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-style-context:
=begin pod
=head2 get-style-context

Returns the style context associated to I<widget>. The returned object is guaranteed to be the same for the lifetime of I<widget>.

Returns: : a B<Gnome::Gtk3::StyleContext>. This memory is owned by I<widget> and must not be freed.

  method get-style-context ( --> N-GObject )


=end pod

method get-style-context ( --> N-GObject ) {

  gtk_widget_get_style_context(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_style_context (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-support-multidevice:
=begin pod
=head2 get-support-multidevice

Returns C<True> if I<widget> is multiple pointer aware. See C<set-support-multidevice()> for more information.

Returns: C<True> if I<widget> is multidevice aware.

  method get-support-multidevice ( --> Bool )


=end pod

method get-support-multidevice ( --> Bool ) {

  gtk_widget_get_support_multidevice(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_support_multidevice (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-template-child:
=begin pod
=head2 get-template-child

Fetch an object build from the template XML for I<widget-type> in this I<widget> instance.

This will only report children which were previously declared with C<class-bind-template-child-full()> or one of its variants.

This function is only meant to be called for code which is private to the I<widget-type> which declared the child and is meant for language bindings which cannot easily make use of the GObject structure offsets.

Returns: : The object built in the template XML with the id I<name>

  method get-template-child ( N-GObject $widget_type, Str $name --> N-GObject )

=item N-GObject $widget_type; The B<Gnome::Gtk3::Type> to get a template child for
=item Str $name; The “id” of the child defined in the template XML

=end pod

method get-template-child ( $widget_type is copy, Str $name --> N-GObject ) {
  $widget_type .= get-native-object-no-reffing unless $widget_type ~~ N-GObject;

  gtk_widget_get_template_child(
    self._f('GtkWidget'), $widget_type, $name
  )
}

sub gtk_widget_get_template_child (
  N-GObject $widget, N-GObject $widget_type, gchar-ptr $name --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-tooltip-markup:
=begin pod
=head2 get-tooltip-markup

Gets the contents of the tooltip for I<widget>.

Returns: : the tooltip text, or C<undefined>. You should free the returned string with C<g-free()> when done.

  method get-tooltip-markup ( --> Str )


=end pod

method get-tooltip-markup ( --> Str ) {

  gtk_widget_get_tooltip_markup(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_tooltip_markup (
  N-GObject $widget --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-tooltip-text:
=begin pod
=head2 get-tooltip-text

Gets the contents of the tooltip for I<widget>.

Returns: : the tooltip text, or C<undefined>. You should free the returned string with C<g-free()> when done.

  method get-tooltip-text ( --> Str )


=end pod

method get-tooltip-text ( --> Str ) {

  gtk_widget_get_tooltip_text(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_tooltip_text (
  N-GObject $widget --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-tooltip-window:
=begin pod
=head2 get-tooltip-window

Returns the B<Gnome::Gtk3::Window> of the current tooltip. This can be the GtkWindow created by default, or the custom tooltip window set using C<set-tooltip-window()>.

Returns: : The B<Gnome::Gtk3::Window> of the current tooltip.

  method get-tooltip-window ( --> N-GObject )


=end pod

method get-tooltip-window ( --> N-GObject ) {

  gtk_widget_get_tooltip_window(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_tooltip_window (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-toplevel:
=begin pod
=head2 get-toplevel

This function returns the topmost widget in the container hierarchy I<widget> is a part of. If I<widget> has no parent widgets, it will be returned as the topmost widget. No reference will be added to the returned widget; it should not be unreferenced.

Note the difference in behavior vs. C<get-ancestor()>; `gtk-widget-get-ancestor (widget, GTK-TYPE-WINDOW)` would return C<undefined> if I<widget> wasn’t inside a toplevel window, and if the window was inside a B<Gnome::Gtk3::Window>-derived widget which was in turn inside the toplevel B<Gnome::Gtk3::Window>. While the second case may seem unlikely, it actually happens when a B<Gnome::Gtk3::Plug> is embedded inside a B<Gnome::Gtk3::Socket> within the same application.

To reliably find the toplevel B<Gnome::Gtk3::Window>, use C<get-toplevel()> and call C<GTK-IS-WINDOW()> on the result. For instance, to get the title of a widget's toplevel window, one might use: |[<!-- language="C" --> static const char * get-widget-toplevel-title (GtkWidget *widget) { GtkWidget *toplevel = gtk-widget-get-toplevel (widget); if (GTK-IS-WINDOW (toplevel)) { return gtk-window-get-title (GTK-WINDOW (toplevel)); }

return NULL; } ]|

Returns: : the topmost ancestor of I<widget>, or I<widget> itself if there’s no ancestor.

  method get-toplevel ( --> N-GObject )


=end pod

method get-toplevel ( --> N-GObject ) {

  gtk_widget_get_toplevel(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_toplevel (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-valign:
=begin pod
=head2 get-valign

Gets the value of the  I<valign> property.

For backwards compatibility reasons this method will never return C<GTK-ALIGN-BASELINE>, but instead it will convert it to C<GTK-ALIGN-FILL>. If your widget want to support baseline aligned children it must use C<get-valign-with-baseline()>, or `g-object-get (widget, "valign", &value, NULL)`, which will also report the true value.

Returns: the vertical alignment of I<widget>, ignoring baseline alignment

  method get-valign ( --> GtkAlign )

=end pod

method get-valign ( --> GtkAlign ) {
  GtkAlign(gtk_widget_get_valign(self._f('GtkWidget')))
}

sub gtk_widget_get_valign (
  N-GObject $widget --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-valign-with-baseline:
=begin pod
=head2 get-valign-with-baseline

Gets the value of the  I<valign> property, including C<GTK-ALIGN-BASELINE>.

Returns: the vertical alignment of I<widget>

  method get-valign-with-baseline ( --> GtkAlign )

=end pod

method get-valign-with-baseline ( --> GtkAlign ) {
  GtkAlign(gtk_widget_get_valign_with_baseline(self._f('GtkWidget')))
}

sub gtk_widget_get_valign_with_baseline (
  N-GObject $widget --> GEnum
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-vexpand:
=begin pod
=head2 get-vexpand

Gets whether the widget would like any available extra vertical space.

See C<get-hexpand()> for more detail.

Returns: whether vexpand flag is set

  method get-vexpand ( --> Bool )


=end pod

method get-vexpand ( --> Bool ) {

  gtk_widget_get_vexpand(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_vexpand (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-vexpand-set:
=begin pod
=head2 get-vexpand-set

Gets whether C<set-vexpand()> has been used to explicitly set the expand flag on this widget.

See C<get-hexpand-set()> for more detail.

Returns: whether vexpand has been explicitly set

  method get-vexpand-set ( --> Bool )


=end pod

method get-vexpand-set ( --> Bool ) {

  gtk_widget_get_vexpand_set(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_vexpand_set (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-visible:
=begin pod
=head2 get-visible

Determines whether the widget is visible. If you want to take into account whether the widget’s parent is also marked as visible, use C<is-visible()> instead.

This function does not check if the widget is obscured in any way.

See C<set-visible()>.

Returns: C<True> if the widget is visible

  method get-visible ( --> Bool )


=end pod

method get-visible ( --> Bool ) {

  gtk_widget_get_visible(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_get_visible (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-visual:
=begin pod
=head2 get-visual

Gets the visual that will be used to render I<widget>.

Returns: : the visual for I<widget>

  method get-visual ( --> N-GObject )


=end pod

method get-visual ( --> N-GObject ) {

  gtk_widget_get_visual(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_visual (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-window:
=begin pod
=head2 get-window

Returns the widget’s window if it is realized, C<undefined> otherwise

Returns: I<widget>’s window.

  method get-window ( --> N-GObject )


=end pod

method get-window ( --> N-GObject ) {

  gtk_widget_get_window(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_get_window (
  N-GObject $widget --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:grab-default:
=begin pod
=head2 grab-default

Causes I<widget> to become the default widget. I<widget> must be able to be a default widget; typically you would ensure this yourself by calling C<set-can-default()> with a C<True> value. The default widget is activated when the user presses Enter in a window. Default widgets must be activatable, that is, C<activate()> should affect them. Note that B<Gnome::Gtk3::Entry> widgets require the “activates-default” property set to C<True> before they activate the default widget when Enter is pressed and the B<Gnome::Gtk3::Entry> is focused.

  method grab-default ( )


=end pod

method grab-default ( ) {

  gtk_widget_grab_default(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_grab_default (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:grab-focus:
=begin pod
=head2 grab-focus

Causes I<widget> to have the keyboard focus for the B<Gnome::Gtk3::Window> it's inside. I<widget> must be a focusable widget, such as a B<Gnome::Gtk3::Entry>; something like B<Gnome::Gtk3::Frame> won’t work.

More precisely, it must have the C<GTK-CAN-FOCUS> flag set. Use C<set-can-focus()> to modify that flag.

The widget also needs to be realized and mapped. This is indicated by the related signals. Grabbing the focus immediately after creating the widget will likely fail and cause critical warnings.

  method grab-focus ( )


=end pod

method grab-focus ( ) {

  gtk_widget_grab_focus(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_grab_focus (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-cairo-should-draw-window:
=begin pod
=head2 gtk-cairo-should-draw-window

This function is supposed to be called in  I<draw> implementations for widgets that support multiple windows. I<cr> must be untransformed from invoking of the draw function. This function will return C<True> if the contents of the given I<window> are supposed to be drawn and C<False> otherwise. Note that when the drawing was not initiated by the windowing system this function will return C<True> for all windows, so you need to draw the bottommost window first. Also, do not use “else if” statements to check which window should be drawn.

Returns: C<True> if I<window> should be drawn

  method gtk-cairo-should-draw-window ( cairo_t $cr, N-GObject $window --> Bool )

=item cairo_t $cr; a cairo context
=item N-GObject $window; the window to check. I<window> may not be an input-only window.

=end pod

method gtk-cairo-should-draw-window ( cairo_t $cr, $window is copy --> Bool ) {
  $window .= get-native-object-no-reffing unless $window ~~ N-GObject;

  gtk_cairo_should_draw_window(
    self._f('GtkWidget'), $cr, $window
  ).Bool
}

sub gtk_cairo_should_draw_window (
  cairo_t $cr, N-GObject $window --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-cairo-transform-to-window:
=begin pod
=head2 gtk-cairo-transform-to-window

Transforms the given cairo context I<cr> that from I<widget>-relative coordinates to I<window>-relative coordinates. If the I<widget>’s window is not an ancestor of I<window>, no modification will be applied.

This is the inverse to the transformation GTK applies when preparing an expose event to be emitted with the  I<draw> signal. It is intended to help porting multiwindow widgets from GTK+ 2 to the rendering architecture of GTK+ 3.

  method gtk-cairo-transform-to-window ( cairo_t $cr, N-GObject $widget, N-GObject $window )

=item cairo_t $cr; the cairo context to transform
=item N-GObject $widget; the widget the context is currently centered for
=item N-GObject $window; the window to transform the context to

=end pod

method gtk-cairo-transform-to-window ( cairo_t $cr, $widget is copy, $window is copy ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;
  $window .= get-native-object-no-reffing unless $window ~~ N-GObject;

  gtk_cairo_transform_to_window(
    self._f('GtkWidget'), $cr, $widget, $window
  );
}

sub gtk_cairo_transform_to_window (
  cairo_t $cr, N-GObject $widget, N-GObject $window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-requisition-copy:
=begin pod
=head2 gtk-requisition-copy

Copies a B<Gnome::Gtk3::Requisition>.

Returns: a copy of I<requisition>

  method gtk-requisition-copy (
    N-GtkRequisition $requisition --> N-GtkRequisition
  )

=item N-GtkRequisition $requisition; a B<Gnome::Gtk3::Requisition>

=end pod

method gtk-requisition-copy (
  N-GtkRequisition $requisition --> N-GtkRequisition
) {
  gtk_requisition_copy(self._f('GtkWidget'), $requisition)
}

sub gtk_requisition_copy (
  N-GtkRequisition $requisition --> N-GtkRequisition
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-requisition-free:
=begin pod
=head2 gtk-requisition-free

Frees a B<Gnome::Gtk3::Requisition>.

  method gtk-requisition-free ( N-GtkRequisition $requisition )

=item N-GtkRequisition $requisition; a B<Gnome::Gtk3::Requisition>

=end pod

method gtk-requisition-free ( N-GtkRequisition $requisition ) {

  gtk_requisition_free(
    self._f('GtkWidget'), $requisition
  );
}

sub gtk_requisition_free (
  N-GtkRequisition $requisition
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:0:gtk-requisition-new:
=begin pod
=head2 gtk-requisition-new

Allocates a new B<Gnome::Gtk3::Requisition>-struct and initializes its elements to zero.

Returns: a new empty B<Gnome::Gtk3::Requisition>. The newly allocated B<Gnome::Gtk3::Requisition> should be freed with C<gtk-requisition-free()>.

  method gtk-requisition-new ( G_GNUC_MALLO $C --> N-GtkRequisition )

=item G_GNUC_MALLO $C;

=end pod

method gtk-requisition-new ( G_GNUC_MALLO $C --> N-GtkRequisition ) {

  gtk_requisition_new(
    self._f('GtkWidget'), $C
  )
}

sub gtk_requisition_new (
  G_GNUC_MALLO $C --> N-GtkRequisition
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:has-default:
=begin pod
=head2 has-default

Determines whether I<widget> is the current default widget within its toplevel. See C<set-can-default()>.

Returns: C<True> if I<widget> is the current default widget within its toplevel, C<False> otherwise

  method has-default ( --> Bool )


=end pod

method has-default ( --> Bool ) {

  gtk_widget_has_default(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_has_default (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:has-focus:
=begin pod
=head2 has-focus

Determines if the widget has the global input focus. See C<is-focus()> for the difference between having the global input focus, and only having the focus within a toplevel.

Returns: C<True> if the widget has the global input focus.

  method has-focus ( --> Bool )


=end pod

method has-focus ( --> Bool ) {

  gtk_widget_has_focus(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_has_focus (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:has-grab:
=begin pod
=head2 has-grab

Determines whether the widget is currently grabbing events, so it is the only widget receiving input events (keyboard and mouse).

See also C<gtk-grab-add()>.

Returns: C<True> if the widget is in the grab-widgets stack

  method has-grab ( --> Bool )


=end pod

method has-grab ( --> Bool ) {

  gtk_widget_has_grab(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_has_grab (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:has-screen:
=begin pod
=head2 has-screen

Checks whether there is a B<Gnome::Gtk3::Screen> is associated with this widget. All toplevel widgets have an associated screen, and all widgets added into a hierarchy with a toplevel window at the top.

Returns: C<True> if there is a B<Gnome::Gtk3::Screen> associated with the widget.

  method has-screen ( --> Bool )


=end pod

method has-screen ( --> Bool ) {

  gtk_widget_has_screen(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_has_screen (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:has-visible-focus:
=begin pod
=head2 has-visible-focus

Determines if the widget should show a visible indication that it has the global input focus. This is a convenience function for use in I<draw> handlers that takes into account whether focus indication should currently be shown in the toplevel window of I<widget>. See C<gtk-window-get-focus-visible()> for more information about focus indication.

To find out if the widget has the global input focus, use C<has-focus()>.

Returns: C<True> if the widget should display a “focus rectangle”

  method has-visible-focus ( --> Bool )


=end pod

method has-visible-focus ( --> Bool ) {

  gtk_widget_has_visible_focus(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_has_visible_focus (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:hide:
=begin pod
=head2 hide

Reverses the effects of C<show()>, causing the widget to be hidden (invisible to the user).

  method hide ( )

=end pod

method hide ( ) {

  gtk_widget_hide(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_hide (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:hide-on-delete:
=begin pod
=head2 hide-on-delete

Utility function; intended to be connected to the  I<delete-event> signal on a B<Gnome::Gtk3::Window>. The function calls C<hide()> on its argument, then returns C<True>. If connected to I<delete-event>, the result is that clicking the close button for a window (on the window frame, top right corner usually) will hide but not destroy the window. By default, GTK+ destroys windows when I<delete-event> is received.

Returns: C<True>

  method hide-on-delete ( --> Bool )


=end pod

method hide-on-delete ( --> Bool ) {

  gtk_widget_hide_on_delete(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_hide_on_delete (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:in-destruction:
=begin pod
=head2 in-destruction

Returns whether the widget is currently being destroyed. This information can sometimes be used to avoid doing unnecessary work.

Returns: C<True> if I<widget> is being destroyed

  method in-destruction ( --> Bool )


=end pod

method in-destruction ( --> Bool ) {

  gtk_widget_in_destruction(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_in_destruction (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:init-template:
=begin pod
=head2 init-template

Creates and initializes child widgets defined in templates. This function must be called in the instance initializer for any class which assigned itself a template using C<class-set-template()>

It is important to call this function in the instance initializer of a B<Gnome::Gtk3::Widget> subclass and not in B<Gnome::Gtk3::Object>.C<constructed()> or B<Gnome::Gtk3::Object>.C<constructor()> for two reasons.

One reason is that generally derived widgets will assume that parent class composite widgets have been created in their instance initializers.

Another reason is that when calling C<g-object-new()> on a widget with composite templates, it’s important to build the composite widgets before the construct properties are set. Properties passed to C<g-object-new()> should take precedence over properties set in the private template XML.

  method init-template ( )


=end pod

method init-template ( ) {

  gtk_widget_init_template(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_init_template (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:input-shape-combine-region:
=begin pod
=head2 input-shape-combine-region

Sets an input shape for this widget’s GDK window. This allows for windows which react to mouse click in a nonrectangular region, see C<gdk-window-input-shape-combine-region()> for more information.

  method input-shape-combine-region ( cairo_region_t $region )

=item cairo_region_t $region; shape to be added, or C<undefined> to remove an existing shape

=end pod

method input-shape-combine-region ( cairo_region_t $region ) {

  gtk_widget_input_shape_combine_region(
    self._f('GtkWidget'), $region
  );
}

sub gtk_widget_input_shape_combine_region (
  N-GObject $widget, cairo_region_t $region
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:insert-action-group:
=begin pod
=head2 insert-action-group

Inserts I<group> into I<widget>. Children of I<widget> that implement B<Gnome::Gtk3::Actionable> can then be associated with actions in I<group> by setting their “action-name” to I<prefix>.`action-name`.

If I<group> is C<undefined>, a previously inserted group for I<name> is removed from I<widget>.

  method insert-action-group ( Str $name, N-GObject $group )

=item Str $name; the prefix for actions in I<group>
=item N-GObject $group; a B<Gnome::Gtk3::ActionGroup>, or C<undefined>

=end pod

method insert-action-group ( Str $name, N-GObject $group ) {

  gtk_widget_insert_action_group(
    self._f('GtkWidget'), $name, $group
  );
}

sub gtk_widget_insert_action_group (
  N-GObject $widget, gchar-ptr $name, N-GObject $group
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:intersect:
=begin pod
=head2 intersect

Computes the intersection of a I<widget>’s area and I<area>, storing the intersection in I<intersection>, and returns C<True> if there was an intersection. I<intersection> may be C<undefined> if you’re only interested in whether there was an intersection.

Returns: C<True> if there was an intersection

  method intersect ( N-GObject $area, N-GObject $intersection --> Bool )

=item N-GObject $area; a rectangle
=item N-GObject $intersection; (out caller-allocates) : rectangle to store intersection of I<widget> and I<area>

=end pod

method intersect ( $area is copy, $intersection is copy --> Bool ) {
  $area .= get-native-object-no-reffing unless $area ~~ N-GObject;
  $intersection .= get-native-object-no-reffing unless $intersection ~~ N-GObject;

  gtk_widget_intersect(
    self._f('GtkWidget'), $area, $intersection
  ).Bool
}

sub gtk_widget_intersect (
  N-GObject $widget, N-GObject $area, N-GObject $intersection --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:is-ancestor:
=begin pod
=head2 is-ancestor

Determines whether I<widget> is somewhere inside I<ancestor>, possibly with intermediate containers.

Returns: C<True> if I<ancestor> contains I<widget> as a child, grandchild, great grandchild, etc.

  method is-ancestor ( N-GObject $ancestor --> Bool )

=item N-GObject $ancestor; another B<Gnome::Gtk3::Widget>

=end pod

method is-ancestor ( $ancestor is copy --> Bool ) {
  $ancestor .= get-native-object-no-reffing unless $ancestor ~~ N-GObject;

  gtk_widget_is_ancestor(
    self._f('GtkWidget'), $ancestor
  ).Bool
}

sub gtk_widget_is_ancestor (
  N-GObject $widget, N-GObject $ancestor --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:is-drawable:
=begin pod
=head2 is-drawable

Determines whether I<widget> can be drawn to. A widget can be drawn to if it is mapped and visible.

Returns: C<True> if I<widget> is drawable, C<False> otherwise

  method is-drawable ( --> Bool )


=end pod

method is-drawable ( --> Bool ) {

  gtk_widget_is_drawable(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_is_drawable (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:is-focus:
=begin pod
=head2 is-focus

Determines if the widget is the focus widget within its toplevel. (This does not mean that the  I<has-focus> property is necessarily set;  I<has-focus> will only be set if the toplevel widget additionally has the global input focus.)

Returns: C<True> if the widget is the focus widget.

  method is-focus ( --> Bool )


=end pod

method is-focus ( --> Bool ) {

  gtk_widget_is_focus(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_is_focus (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:is-sensitive:
=begin pod
=head2 is-sensitive

Returns the widget’s effective sensitivity, which means it is sensitive itself and also its parent widget is sensitive

Returns: C<True> if the widget is effectively sensitive

  method is-sensitive ( --> Bool )


=end pod

method is-sensitive ( --> Bool ) {

  gtk_widget_is_sensitive(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_is_sensitive (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:is-toplevel:
=begin pod
=head2 is-toplevel

Determines whether I<widget> is a toplevel widget.

Currently only B<Gnome::Gtk3::Window> and B<Gnome::Gtk3::Invisible> (and out-of-process B<Gnome::Gtk3::Plugs>) are toplevel widgets. Toplevel widgets have no parent widget.

Returns: C<True> if I<widget> is a toplevel, C<False> otherwise

  method is-toplevel ( --> Bool )


=end pod

method is-toplevel ( --> Bool ) {

  gtk_widget_is_toplevel(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_is_toplevel (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:is-visible:
=begin pod
=head2 is-visible

Determines whether the widget and all its parents are marked as visible.

This function does not check if the widget is obscured in any way.

See also C<get-visible()> and C<set-visible()>

Returns: C<True> if the widget and all its parents are visible

  method is-visible ( --> Bool )


=end pod

method is-visible ( --> Bool ) {

  gtk_widget_is_visible(
    self._f('GtkWidget'),
  ).Bool
}

sub gtk_widget_is_visible (
  N-GObject $widget --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:keynav-failed:
=begin pod
=head2 keynav-failed

This function should be called whenever keyboard navigation within a single widget hits a boundary. The function emits the  I<keynav-failed> signal on the widget and its return value should be interpreted in a way similar to the return value of C<child-focus()>:

When C<True> is returned, stay in the widget, the failed keyboard navigation is OK and/or there is nowhere we can/should move the focus to.

When C<False> is returned, the caller should continue with keyboard navigation outside the widget, e.g. by calling C<child-focus()> on the widget’s toplevel.

The default I<keynav-failed> handler returns C<False> for C<GTK-DIR-TAB-FORWARD> and C<GTK-DIR-TAB-BACKWARD>. For the other values of B<Gnome::Gtk3::DirectionType> it returns C<True>.

Whenever the default handler returns C<True>, it also calls C<error-bell()> to notify the user of the failed keyboard navigation.

A use case for providing an own implementation of I<keynav-failed> (either by connecting to it or by overriding it) would be a row of B<Gnome::Gtk3::Entry> widgets where the user should be able to navigate the entire row with the cursor keys, as e.g. known from user interfaces that require entering license keys.

Returns: C<True> if stopping keyboard navigation is fine, C<False> if the emitting widget should try to handle the keyboard navigation attempt in its parent container(s).

  method keynav-failed ( GtkDirectionType $direction --> Bool )

=item GtkDirectionType $direction; direction of focus movement

=end pod

method keynav-failed ( GtkDirectionType $direction --> Bool ) {

  gtk_widget_keynav_failed(
    self._f('GtkWidget'), $direction
  ).Bool
}

sub gtk_widget_keynav_failed (
  N-GObject $widget, GEnum $direction --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:list-accel-closures:
=begin pod
=head2 list-accel-closures

Lists the closures used by I<widget> for accelerator group connections with C<gtk-accel-group-connect-by-path()> or C<gtk-accel-group-connect()>. The closures can be used to monitor accelerator changes on I<widget>, by connecting to the I<GtkAccelGroup>::accel-changed signal of the B<Gnome::Gtk3::AccelGroup> of a closure which can be found out with C<gtk-accel-group-from-accel-closure()>.

Returns: (transfer container) (element-type GClosure): a newly allocated B<Gnome::Gtk3::List> of closures

  method list-accel-closures ( --> N-GList )


=end pod

method list-accel-closures ( --> N-GList ) {

  gtk_widget_list_accel_closures(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_list_accel_closures (
  N-GObject $widget --> N-GList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:list-action-prefixes:
=begin pod
=head2 list-action-prefixes

Retrieves a C<undefined>-terminated array of strings containing the prefixes of B<Gnome::Gtk3::ActionGroup>'s available to I<widget>.

Returns: (transfer container): a C<undefined>-terminated array of strings.

  method list-action-prefixes ( --> CArray[Str] )


=end pod

method list-action-prefixes ( --> CArray[Str] ) {

  gtk_widget_list_action_prefixes(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_list_action_prefixes (
  N-GObject $widget --> gchar-pptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:list-mnemonic-labels:
=begin pod
=head2 list-mnemonic-labels

Returns a newly allocated list of the widgets, normally labels, for which this widget is the target of a mnemonic (see for example, C<gtk-label-set-mnemonic-widget()>). The widgets in the list are not individually referenced. If you want to iterate through the list and perform actions involving callbacks that might destroy the widgets, you must call `g-list-foreach (result, (GFunc)g-object-ref, NULL)` first, and then unref all the widgets afterwards.

Returns: (element-type GtkWidget) (transfer container): the list of mnemonic labels; free this list with C<g-list-free()> when you are done with it.

  method list-mnemonic-labels ( --> N-GList )


=end pod

method list-mnemonic-labels ( --> N-GList ) {

  gtk_widget_list_mnemonic_labels(
    self._f('GtkWidget'),
  )
}

sub gtk_widget_list_mnemonic_labels (
  N-GObject $widget --> N-GList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:map:
=begin pod
=head2 map

This function is only for use in widget implementations. Causes a widget to be mapped if it isn’t already.

  method map ( )


=end pod

method map ( ) {

  gtk_widget_map(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_map (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:mnemonic-activate:
=begin pod
=head2 mnemonic-activate

Emits the  I<mnemonic-activate> signal.

Returns: C<True> if the signal has been handled

  method mnemonic-activate ( Bool $group_cycling --> Bool )

=item Bool $group_cycling; C<True> if there are other widgets with the same mnemonic

=end pod

method mnemonic-activate ( Bool $group_cycling --> Bool ) {

  gtk_widget_mnemonic_activate(
    self._f('GtkWidget'), $group_cycling
  ).Bool
}

sub gtk_widget_mnemonic_activate (
  N-GObject $widget, gboolean $group_cycling --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:queue-allocate:
=begin pod
=head2 queue-allocate

This function is only for use in widget implementations.

Flags the widget for a rerun of the GtkWidgetClass::size-allocate function. Use this function instead of C<queue-resize()> when the I<widget>'s size request didn't change but it wants to reposition its contents.

An example user of this function is C<set-halign()>.

  method queue-allocate ( )


=end pod

method queue-allocate ( ) {

  gtk_widget_queue_allocate(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_queue_allocate (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:queue-compute-expand:
=begin pod
=head2 queue-compute-expand

Mark I<widget> as needing to recompute its expand flags. Call this function when setting legacy expand child properties on the child of a container.

See C<compute-expand()>.

  method queue-compute-expand ( )


=end pod

method queue-compute-expand ( ) {

  gtk_widget_queue_compute_expand(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_queue_compute_expand (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:queue-draw:
=begin pod
=head2 queue-draw

Equivalent to calling C<queue-draw-area()> for the entire area of a widget.

  method queue-draw ( )


=end pod

method queue-draw ( ) {

  gtk_widget_queue_draw(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_queue_draw (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:queue-draw-area:
=begin pod
=head2 queue-draw-area

Convenience function that calls C<queue-draw-region()> on the region created from the given coordinates.

The region here is specified in widget coordinates. Widget coordinates are a bit odd; for historical reasons, they are defined as I<widget>->window coordinates for widgets that return C<True> for C<get-has-window()>, and are relative to I<widget>->allocation.x, I<widget>->allocation.y otherwise.

I<width> or I<height> may be 0, in this case this function does nothing. Negative values for I<width> and I<height> are not allowed.

  method queue-draw-area ( Int $x, Int $y, Int $width, Int $height )

=item Int $x; x coordinate of upper-left corner of rectangle to redraw
=item Int $y; y coordinate of upper-left corner of rectangle to redraw
=item Int $width; width of region to draw
=item Int $height; height of region to draw

=end pod

method queue-draw-area ( Int $x, Int $y, Int $width, Int $height ) {

  gtk_widget_queue_draw_area(
    self._f('GtkWidget'), $x, $y, $width, $height
  );
}

sub gtk_widget_queue_draw_area (
  N-GObject $widget, gint $x, gint $y, gint $width, gint $height
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:queue-draw-region:
=begin pod
=head2 queue-draw-region

Invalidates the area of I<widget> defined by I<region> by calling C<gdk-window-invalidate-region()> on the widget’s window and all its child windows. Once the main loop becomes idle (after the current batch of events has been processed, roughly), the window will receive expose events for the union of all regions that have been invalidated.

Normally you would only use this function in widget implementations. You might also use it to schedule a redraw of a B<Gnome::Gtk3::DrawingArea> or some portion thereof.

  method queue-draw-region ( cairo_region_t $region )

=item cairo_region_t $region; region to draw

=end pod

method queue-draw-region ( cairo_region_t $region ) {

  gtk_widget_queue_draw_region(
    self._f('GtkWidget'), $region
  );
}

sub gtk_widget_queue_draw_region (
  N-GObject $widget, cairo_region_t $region
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:queue-resize:
=begin pod
=head2 queue-resize

This function is only for use in widget implementations. Flags a widget to have its size renegotiated; should be called when a widget for some reason has a new size request. For example, when you change the text in a B<Gnome::Gtk3::Label>, B<Gnome::Gtk3::Label> queues a resize to ensure there’s enough space for the new text.

Note that you cannot call C<queue-resize()> on a widget from inside its implementation of the GtkWidgetClass::size-allocate virtual method. Calls to C<queue-resize()> from inside GtkWidgetClass::size-allocate will be silently ignored.

  method queue-resize ( )


=end pod

method queue-resize ( ) {

  gtk_widget_queue_resize(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_queue_resize (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:queue-resize-no-redraw:
=begin pod
=head2 queue-resize-no-redraw

This function works like C<queue-resize()>, except that the widget is not invalidated.

  method queue-resize-no-redraw ( )


=end pod

method queue-resize-no-redraw ( ) {

  gtk_widget_queue_resize_no_redraw(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_queue_resize_no_redraw (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:realize:
=begin pod
=head2 realize

Creates the GDK (windowing system) resources associated with a widget. For example, I<widget>->window will be created when a widget is realized. Normally realization happens implicitly; if you show a widget and all its parent containers, then the widget will be realized and mapped automatically.

Realizing a widget requires all the widget’s parent widgets to be realized; calling C<realize()> realizes the widget’s parents in addition to I<widget> itself. If a widget is not yet inside a toplevel window when you realize it, bad things will happen.

This function is primarily used in widget implementations, and isn’t very useful otherwise. Many times when you think you might need it, a better approach is to connect to a signal that will be called after the widget is realized automatically, such as  I<draw>. Or simply C<g-signal-connect()> to the  I<realize> signal.

  method realize ( )


=end pod

method realize ( ) {

  gtk_widget_realize(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_realize (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:register-window:
=begin pod
=head2 register-window

Registers a B<Gnome::Gtk3::Window> with the widget and sets it up so that the widget receives events for it. Call C<unregister-window()> when destroying the window.

Before 3.8 you needed to call C<gdk-window-set-user-data()> directly to set this up. This is now deprecated and you should use C<register-window()> instead. Old code will keep working as is, although some new features like transparency might not work perfectly.

  method register-window ( N-GObject $window )

=item N-GObject $window; a B<Gnome::Gtk3::Window>

=end pod

method register-window ( $window is copy ) {
  $window .= get-native-object-no-reffing unless $window ~~ N-GObject;

  gtk_widget_register_window(
    self._f('GtkWidget'), $window
  );
}

sub gtk_widget_register_window (
  N-GObject $widget, N-GObject $window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:remove-accelerator:
=begin pod
=head2 remove-accelerator

Removes an accelerator from I<widget>, previously installed with C<add-accelerator()>.

Returns: whether an accelerator was installed and could be removed

  method remove-accelerator ( N-GObject $accel_group, UInt $accel_key, GdkModifierType $accel_mods --> Bool )

=item N-GObject $accel_group; accel group for this widget
=item UInt $accel_key; GDK keyval of the accelerator
=item GdkModifierType $accel_mods; modifier key combination of the accelerator

=end pod

method remove-accelerator ( $accel_group is copy, UInt $accel_key, GdkModifierType $accel_mods --> Bool ) {
  $accel_group .= get-native-object-no-reffing unless $accel_group ~~ N-GObject;

  gtk_widget_remove_accelerator(
    self._f('GtkWidget'), $accel_group, $accel_key, $accel_mods
  ).Bool
}

sub gtk_widget_remove_accelerator (
  N-GObject $widget, N-GObject $accel_group, guint $accel_key, GEnum $accel_mods --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:remove-mnemonic-label:
=begin pod
=head2 remove-mnemonic-label

Removes a widget from the list of mnemonic labels for this widget. (See C<list-mnemonic-labels()>). The widget must have previously been added to the list with C<add-mnemonic-label()>.

  method remove-mnemonic-label ( N-GObject $label )

=item N-GObject $label; a B<Gnome::Gtk3::Widget> that was previously set as a mnemonic label for I<widget> with C<add-mnemonic-label()>.

=end pod

method remove-mnemonic-label ( $label is copy ) {
  $label .= get-native-object-no-reffing unless $label ~~ N-GObject;

  gtk_widget_remove_mnemonic_label(
    self._f('GtkWidget'), $label
  );
}

sub gtk_widget_remove_mnemonic_label (
  N-GObject $widget, N-GObject $label
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:remove-tick-callback:
=begin pod
=head2 remove-tick-callback

Removes a tick callback previously registered with C<add-tick-callback()>.

  method remove-tick-callback ( UInt $id )

=item UInt $id; an id returned by C<add-tick-callback()>

=end pod

method remove-tick-callback ( UInt $id ) {

  gtk_widget_remove_tick_callback(
    self._f('GtkWidget'), $id
  );
}

sub gtk_widget_remove_tick_callback (
  N-GObject $widget, guint $id
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:reset-style:
=begin pod
=head2 reset-style

Updates the style context of I<widget> and all descendants by updating its widget path. B<Gnome::Gtk3::Containers> may want to use this on a child when reordering it in a way that a different style might apply to it. See also C<gtk-container-get-path-for-child()>.

  method reset-style ( )


=end pod

method reset-style ( ) {

  gtk_widget_reset_style(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_reset_style (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:send-focus-change:
=begin pod
=head2 send-focus-change

Sends the focus change I<event> to I<widget>

This function is not meant to be used by applications. The only time it should be used is when it is necessary for a B<Gnome::Gtk3::Widget> to assign focus to a widget that is semantically owned by the first widget even though it’s not a direct child - for instance, a search entry in a floating window similar to the quick search in B<Gnome::Gtk3::TreeView>.

An example of its usage is:

|[<!-- language="C" --> GdkEvent *fevent = gdk-event-new (GDK-FOCUS-CHANGE);

fevent->focus-change.type = GDK-FOCUS-CHANGE; fevent->focus-change.in = TRUE; fevent->focus-change.window = -get-window (widget); if (fevent->focus-change.window != NULL) g-object-ref (fevent->focus-change.window);

gtk-widget-send-focus-change (widget, fevent);

gdk-event-free (event); ]|

Returns: the return value from the event signal emission: C<True> if the event was handled, and C<False> otherwise

  method send-focus-change ( GdkEvent $event --> Bool )

=item GdkEvent $event; a B<Gnome::Gtk3::Event> of type GDK-FOCUS-CHANGE

=end pod

method send-focus-change ( GdkEvent $event --> Bool ) {

  gtk_widget_send_focus_change(
    self._f('GtkWidget'), $event
  ).Bool
}

sub gtk_widget_send_focus_change (
  N-GObject $widget, GdkEvent $event --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-accel-path:
=begin pod
=head2 set-accel-path

Given an accelerator group, I<accel-group>, and an accelerator path, I<accel-path>, sets up an accelerator in I<accel-group> so whenever the key binding that is defined for I<accel-path> is pressed, I<widget> will be activated. This removes any accelerators (for any accelerator group) installed by previous calls to C<set-accel-path()>. Associating accelerators with paths allows them to be modified by the user and the modifications to be saved for future use. (See C<gtk-accel-map-save()>.)

This function is a low level function that would most likely be used by a menu creation system like B<Gnome::Gtk3::UIManager>. If you use B<Gnome::Gtk3::UIManager>, setting up accelerator paths will be done automatically.

Even when you you aren’t using B<Gnome::Gtk3::UIManager>, if you only want to set up accelerators on menu items C<gtk-menu-item-set-accel-path()> provides a somewhat more convenient interface.

Note that I<accel-path> string will be stored in a B<Gnome::Gtk3::Quark>. Therefore, if you pass a static string, you can save some memory by interning it first with C<g-intern-static-string()>.

  method set-accel-path ( Str $accel_path, N-GObject $accel_group )

=item Str $accel_path; path used to look up the accelerator
=item N-GObject $accel_group; a B<Gnome::Gtk3::AccelGroup>.

=end pod

method set-accel-path ( Str $accel_path, $accel_group is copy ) {
  $accel_group .= get-native-object-no-reffing unless $accel_group ~~ N-GObject;

  gtk_widget_set_accel_path(
    self._f('GtkWidget'), $accel_path, $accel_group
  );
}

sub gtk_widget_set_accel_path (
  N-GObject $widget, gchar-ptr $accel_path, N-GObject $accel_group
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-allocation:
=begin pod
=head2 set-allocation

Sets the widget’s allocation. This should not be used directly, but from within a widget’s size-allocate method.

The allocation set should be the “adjusted” or actual allocation. If you’re implementing a B<Gnome::Gtk3::Container>, you want to use C<size-allocate()> instead of C<set-allocation()>. The GtkWidgetClass::adjust-size-allocation virtual method adjusts the allocation inside C<size-allocate()> to create an adjusted allocation.

  method set-allocation ( N-GtkAllocation $allocation )

=item N-GtkAllocation $allocation; a pointer to a B<Gnome::Gtk3::Allocation> to copy from

=end pod

method set-allocation ( N-GtkAllocation $allocation ) {

  gtk_widget_set_allocation(
    self._f('GtkWidget'), $allocation
  );
}

sub gtk_widget_set_allocation (
  N-GObject $widget, N-GtkAllocation $allocation
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-app-paintable:
=begin pod
=head2 set-app-paintable

Sets whether the application intends to draw on the widget in an  I<draw> handler.

This is a hint to the widget and does not affect the behavior of the GTK+ core; many widgets ignore this flag entirely. For widgets that do pay attention to the flag, such as B<Gnome::Gtk3::EventBox> and B<Gnome::Gtk3::Window>, the effect is to suppress default themed drawing of the widget's background. (Children of the widget will still be drawn.) The application is then entirely responsible for drawing the widget background.

Note that the background is still drawn when the widget is mapped.

  method set-app-paintable ( Bool $app_paintable )

=item Bool $app_paintable; C<True> if the application will paint on the widget

=end pod

method set-app-paintable ( Bool $app_paintable ) {

  gtk_widget_set_app_paintable(
    self._f('GtkWidget'), $app_paintable
  );
}

sub gtk_widget_set_app_paintable (
  N-GObject $widget, gboolean $app_paintable
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-can-default:
=begin pod
=head2 set-can-default

Specifies whether I<widget> can be a default widget. See C<grab-default()> for details about the meaning of “default”.

  method set-can-default ( Bool $can_default )

=item Bool $can_default; whether or not I<widget> can be a default widget.

=end pod

method set-can-default ( Bool $can_default ) {

  gtk_widget_set_can_default(
    self._f('GtkWidget'), $can_default
  );
}

sub gtk_widget_set_can_default (
  N-GObject $widget, gboolean $can_default
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-can-focus:
=begin pod
=head2 set-can-focus

Specifies whether I<widget> can own the input focus. See C<grab-focus()> for actually setting the input focus on a widget.

  method set-can-focus ( Bool $can_focus )

=item Bool $can_focus; whether or not I<widget> can own the input focus.

=end pod

method set-can-focus ( Bool $can_focus ) {

  gtk_widget_set_can_focus(
    self._f('GtkWidget'), $can_focus
  );
}

sub gtk_widget_set_can_focus (
  N-GObject $widget, gboolean $can_focus
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-child-visible:
=begin pod
=head2 set-child-visible

Sets whether I<widget> should be mapped along with its when its parent is mapped and I<widget> has been shown with C<show()>.

The child visibility can be set for widget before it is added to a container with C<set-parent()>, to avoid mapping children unnecessary before immediately unmapping them. However it will be reset to its default state of C<True> when the widget is removed from a container.

Note that changing the child visibility of a widget does not queue a resize on the widget. Most of the time, the size of a widget is computed from all visible children, whether or not they are mapped. If this is not the case, the container can queue a resize itself.

This function is only useful for container implementations and never should be called by an application.

  method set-child-visible ( Bool $is_visible )

=item Bool $is_visible; if C<True>, I<widget> should be mapped along with its parent.

=end pod

method set-child-visible ( Bool $is_visible ) {

  gtk_widget_set_child_visible(
    self._f('GtkWidget'), $is_visible
  );
}

sub gtk_widget_set_child_visible (
  N-GObject $widget, gboolean $is_visible
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-clip:
=begin pod
=head2 set-clip

Sets the widget’s clip. This must not be used directly, but from within a widget’s size-allocate method. It must be called after C<set-allocation()> (or after chaining up to the parent class), because that function resets the clip.

The clip set should be the area that I<widget> draws on. If I<widget> is a B<Gnome::Gtk3::Container>, the area must contain all children's clips.

If this function is not called by I<widget> during a I<size-allocate> handler, the clip will be set to I<widget>'s allocation.

  method set-clip ( N-GtkAllocation $clip )

=item N-GtkAllocation $clip; a pointer to a B<Gnome::Gtk3::Allocation> to copy from

=end pod

method set-clip ( N-GtkAllocation $clip ) {

  gtk_widget_set_clip(
    self._f('GtkWidget'), $clip
  );
}

sub gtk_widget_set_clip (
  N-GObject $widget, N-GtkAllocation $clip
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-default-direction:
=begin pod
=head2 set-default-direction

Sets the default reading direction for widgets where the direction has not been explicitly set by C<set-direction()>.

  method set-default-direction ( GtkTextDirection $dir )

=item GtkTextDirection $dir; the new default direction. This cannot be C<GTK-TEXT-DIR-NONE>.

=end pod

method set-default-direction ( GtkTextDirection $dir ) {

  gtk_widget_set_default_direction($dir);
}

sub gtk_widget_set_default_direction ( GEnum $dir )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-device-enabled:
=begin pod
=head2 set-device-enabled

Enables or disables a B<Gnome::Gtk3::Device> to interact with I<widget> and all its children.

It does so by descending through the B<Gnome::Gtk3::Window> hierarchy and enabling the same mask that is has for core events (i.e. the one that C<gdk-window-get-events()> returns).

  method set-device-enabled ( N-GObject $device, Bool $enabled )

=item N-GObject $device; a B<Gnome::Gtk3::Device>
=item Bool $enabled; whether to enable the device

=end pod

method set-device-enabled ( $device is copy, Bool $enabled ) {
  $device .= get-native-object-no-reffing unless $device ~~ N-GObject;

  gtk_widget_set_device_enabled(
    self._f('GtkWidget'), $device, $enabled
  );
}

sub gtk_widget_set_device_enabled (
  N-GObject $widget, N-GObject $device, gboolean $enabled
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-device-events:
=begin pod
=head2 set-device-events

Sets the device event mask (see B<Gnome::Gtk3::EventMask>) for a widget. The event mask determines which events a widget will receive from I<device>. Keep in mind that different widgets have different default event masks, and by changing the event mask you may disrupt a widget’s functionality, so be careful. This function must be called while a widget is unrealized. Consider C<add-device-events()> for widgets that are already realized, or if you want to preserve the existing event mask. This function can’t be used with windowless widgets (which return C<False> from C<get-has-window()>); to get events on those widgets, place them inside a B<Gnome::Gtk3::EventBox> and receive events on the event box.

  method set-device-events ( N-GObject $device, Int $events )

=item N-GObject $device; a B<Gnome::Gtk3::Device>
=item Int $events; event mask with N-GdkEventMask flag values

=end pod

method set-device-events ( $device is copy, Int $events ) {
  $device .= get-native-object-no-reffing unless $device ~~ N-GObject;
  gtk_widget_set_device_events( self._f('GtkWidget'), $device, $events);
}

sub gtk_widget_set_device_events (
  N-GObject $widget, N-GObject $device, GFlag $events
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-direction:
=begin pod
=head2 set-direction

Sets the reading direction on a particular widget. This direction controls the primary direction for widgets containing text, and also the direction in which the children of a container are packed. The ability to set the direction is present in order so that correct localization into languages with right-to-left reading directions can be done. Generally, applications will let the default reading direction present, except for containers where the containers are arranged in an order that is explicitly visual rather than logical (such as buttons for text justification).

If the direction is set to C<GTK-TEXT-DIR-NONE>, then the value set by C<set-default-direction()> will be used.

  method set-direction ( GtkTextDirection $dir )

=item GtkTextDirection $dir; the new direction

=end pod

method set-direction ( GtkTextDirection $dir ) {

  gtk_widget_set_direction(
    self._f('GtkWidget'), $dir
  );
}

sub gtk_widget_set_direction (
  N-GObject $widget, GEnum $dir
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-events:
=begin pod
=head2 set-events

Sets the event mask (see B<Gnome::Gtk3::EventMask>) for a widget. The event mask determines which events a widget will receive. Keep in mind that different widgets have different default event masks, and by changing the event mask you may disrupt a widget’s functionality, so be careful. This function must be called while a widget is unrealized. Consider C<add-events()> for widgets that are already realized, or if you want to preserve the existing event mask. This function can’t be used with widgets that have no window. (See C<get-has-window()>). To get events on those widgets, place them inside a B<Gnome::Gtk3::EventBox> and receive events on the event box.

  method set-events ( Int $events )

=item Int $events; event mask

=end pod

method set-events ( Int $events ) {

  gtk_widget_set_events(
    self._f('GtkWidget'), $events
  );
}

sub gtk_widget_set_events (
  N-GObject $widget, gint $events
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-focus-on-click:
=begin pod
=head2 set-focus-on-click

Sets whether the widget should grab focus when it is clicked with the mouse. Making mouse clicks not grab focus is useful in places like toolbars where you don’t want the keyboard focus removed from the main area of the application.

  method set-focus-on-click ( Bool $focus_on_click )

=item Bool $focus_on_click; whether the widget should grab focus when clicked with the mouse

=end pod

method set-focus-on-click ( Bool $focus_on_click ) {

  gtk_widget_set_focus_on_click(
    self._f('GtkWidget'), $focus_on_click
  );
}

sub gtk_widget_set_focus_on_click (
  N-GObject $widget, gboolean $focus_on_click
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-font-map:
=begin pod
=head2 set-font-map

Sets the font map to use for Pango rendering. When not set, the widget will inherit the font map from its parent.

  method set-font-map ( N-GObject $font_map )

=item N-GObject $font_map; a B<PangoFontMap>, or C<undefined> to unset any previously set font map

=end pod

method set-font-map ( $font_map is copy ) {
  $font_map .= get-native-object-no-reffing unless $font_map ~~ N-GObject;

  gtk_widget_set_font_map(
    self._f('GtkWidget'), $font_map
  );
}

sub gtk_widget_set_font_map (
  N-GObject $widget, N-GObject $font_map
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-font-options:
=begin pod
=head2 set-font-options

Sets the B<cairo-font-options-t> used for Pango rendering in this widget. When not set, the default font options for the B<Gnome::Gtk3::Screen> will be used.

  method set-font-options ( cairo_font_options_t $options )

=item cairo_font_options_t $options; a B<cairo-font-options-t>, or C<undefined> to unset any previously set default font options.

=end pod

method set-font-options ( cairo_font_options_t $options ) {

  gtk_widget_set_font_options(
    self._f('GtkWidget'), $options
  );
}

sub gtk_widget_set_font_options (
  N-GObject $widget, cairo_font_options_t $options
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-halign:
=begin pod
=head2 set-halign

Sets the horizontal alignment of I<widget>. See the  I<halign> property.

  method set-halign ( GtkAlign $align )

=item GtkAlign $align; the horizontal alignment

=end pod

method set-halign ( GtkAlign $align ) {

  gtk_widget_set_halign(
    self._f('GtkWidget'), $align
  );
}

sub gtk_widget_set_halign (
  N-GObject $widget, GEnum $align
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-has-tooltip:
=begin pod
=head2 set-has-tooltip

Sets the has-tooltip property on I<widget> to I<has-tooltip>. See  I<has-tooltip> for more information.

  method set-has-tooltip ( Bool $has_tooltip )

=item Bool $has_tooltip; whether or not I<widget> has a tooltip.

=end pod

method set-has-tooltip ( Bool $has_tooltip ) {

  gtk_widget_set_has_tooltip(
    self._f('GtkWidget'), $has_tooltip
  );
}

sub gtk_widget_set_has_tooltip (
  N-GObject $widget, gboolean $has_tooltip
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-has-window:
=begin pod
=head2 set-has-window

Specifies whether I<widget> has a B<Gnome::Gtk3::Window> of its own. Note that all realized widgets have a non-C<undefined> “window” pointer (C<get-window()> never returns a C<undefined> window when a widget is realized), but for many of them it’s actually the B<Gnome::Gtk3::Window> of one of its parent widgets. Widgets that do not create a C<window> for themselves in  I<realize> must announce this by calling this function with I<has-window> = C<False>.

This function should only be called by widget implementations, and they should call it in their C<init()> function.

  method set-has-window ( Bool $has_window )

=item Bool $has_window; whether or not I<widget> has a window.

=end pod

method set-has-window ( Bool $has_window ) {

  gtk_widget_set_has_window(
    self._f('GtkWidget'), $has_window
  );
}

sub gtk_widget_set_has_window (
  N-GObject $widget, gboolean $has_window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-hexpand:
=begin pod
=head2 set-hexpand

Sets whether the widget would like any available extra horizontal space. When a user resizes a B<Gnome::Gtk3::Window>, widgets with expand=TRUE generally receive the extra space. For example, a list or scrollable area or document in your window would often be set to expand.

Call this function to set the expand flag if you would like your widget to become larger horizontally when the window has extra room.

By default, widgets automatically expand if any of their children want to expand. (To see if a widget will automatically expand given its current children and state, call C<compute-expand()>. A container can decide how the expandability of children affects the expansion of the container by overriding the compute-expand virtual method on B<Gnome::Gtk3::Widget>.).

Setting hexpand explicitly with this function will override the automatic expand behavior.

This function forces the widget to expand or not to expand, regardless of children. The override occurs because C<set-hexpand()> sets the hexpand-set property (see C<set-hexpand-set()>) which causes the widget’s hexpand value to be used, rather than looking at children and widget state.

  method set-hexpand ( Bool $expand )

=item Bool $expand; whether to expand

=end pod

method set-hexpand ( Bool $expand ) {

  gtk_widget_set_hexpand(
    self._f('GtkWidget'), $expand
  );
}

sub gtk_widget_set_hexpand (
  N-GObject $widget, gboolean $expand
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-hexpand-set:
=begin pod
=head2 set-hexpand-set

Sets whether the hexpand flag (see C<get-hexpand()>) will be used.

The hexpand-set property will be set automatically when you call C<set-hexpand()> to set hexpand, so the most likely reason to use this function would be to unset an explicit expand flag.

If hexpand is set, then it overrides any computed expand value based on child widgets. If hexpand is not set, then the expand value depends on whether any children of the widget would like to expand.

There are few reasons to use this function, but it’s here for completeness and consistency.

  method set-hexpand-set ( Bool $set )

=item Bool $set; value for hexpand-set property

=end pod

method set-hexpand-set ( Bool $set ) {

  gtk_widget_set_hexpand_set(
    self._f('GtkWidget'), $set
  );
}

sub gtk_widget_set_hexpand_set (
  N-GObject $widget, gboolean $set
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-mapped:
=begin pod
=head2 set-mapped

Marks the widget as being mapped.

This function should only ever be called in a derived widget's “map” or “unmap” implementation.

  method set-mapped ( Bool $mapped )

=item Bool $mapped; C<True> to mark the widget as mapped

=end pod

method set-mapped ( Bool $mapped ) {

  gtk_widget_set_mapped(
    self._f('GtkWidget'), $mapped
  );
}

sub gtk_widget_set_mapped (
  N-GObject $widget, gboolean $mapped
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-margin-bottom:
=begin pod
=head2 set-margin-bottom

Sets the bottom margin of I<widget>. See the  I<margin-bottom> property.

  method set-margin-bottom ( Int $margin )

=item Int $margin; the bottom margin

=end pod

method set-margin-bottom ( Int $margin ) {

  gtk_widget_set_margin_bottom(
    self._f('GtkWidget'), $margin
  );
}

sub gtk_widget_set_margin_bottom (
  N-GObject $widget, gint $margin
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-margin-end:
=begin pod
=head2 set-margin-end

Sets the end margin of I<widget>. See the  I<margin-end> property.

  method set-margin-end ( Int $margin )

=item Int $margin; the end margin

=end pod

method set-margin-end ( Int $margin ) {

  gtk_widget_set_margin_end(
    self._f('GtkWidget'), $margin
  );
}

sub gtk_widget_set_margin_end (
  N-GObject $widget, gint $margin
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-margin-start:
=begin pod
=head2 set-margin-start

Sets the start margin of I<widget>. See the  I<margin-start> property.

  method set-margin-start ( Int $margin )

=item Int $margin; the start margin

=end pod

method set-margin-start ( Int $margin ) {

  gtk_widget_set_margin_start(
    self._f('GtkWidget'), $margin
  );
}

sub gtk_widget_set_margin_start (
  N-GObject $widget, gint $margin
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-margin-top:
=begin pod
=head2 set-margin-top

Sets the top margin of I<widget>. See the  I<margin-top> property.

  method set-margin-top ( Int $margin )

=item Int $margin; the top margin

=end pod

method set-margin-top ( Int $margin ) {

  gtk_widget_set_margin_top(
    self._f('GtkWidget'), $margin
  );
}

sub gtk_widget_set_margin_top (
  N-GObject $widget, gint $margin
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-name:
=begin pod
=head2 set-name

Widgets can be named, which allows you to refer to them from a CSS file. You can apply a style to widgets with a particular name in the CSS file. See the documentation for the CSS syntax (on the same page as the docs for B<Gnome::Gtk3::StyleContext>).

Note that the CSS syntax has certain special characters to delimit and represent elements in a selector (period, #, >, *...), so using these will make your widget impossible to match by name. Any combination of alphanumeric symbols, dashes and underscores will suffice.

  method set-name ( Str $name )

=item Str $name; name for the widget

=end pod

method set-name ( Str $name ) {

  gtk_widget_set_name(
    self._f('GtkWidget'), $name
  );
}

sub gtk_widget_set_name (
  N-GObject $widget, gchar-ptr $name
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-no-show-all:
=begin pod
=head2 set-no-show-all

Sets the  I<no-show-all> property, which determines whether calls to C<show-all()> will affect this widget.

This is mostly for use in constructing widget hierarchies with externally controlled visibility, see B<Gnome::Gtk3::UIManager>.

  method set-no-show-all ( Bool $no_show_all )

=item Bool $no_show_all; the new value for the “no-show-all” property

=end pod

method set-no-show-all ( Bool $no_show_all ) {

  gtk_widget_set_no_show_all(
    self._f('GtkWidget'), $no_show_all
  );
}

sub gtk_widget_set_no_show_all (
  N-GObject $widget, gboolean $no_show_all
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-opacity:
=begin pod
=head2 set-opacity

Request the I<widget> to be rendered partially transparent, with opacity 0 being fully transparent and 1 fully opaque. (Opacity values are clamped to the [0,1] range.). This works on both toplevel widget, and child widgets, although there are some limitations:

For toplevel widgets this depends on the capabilities of the windowing system. On X11 this has any effect only on X screens with a compositing manager running. See C<is-composited()>. On Windows it should work always, although setting a window’s opacity after the window has been shown causes it to flicker once on Windows.

For child widgets it doesn’t work if any affected widget has a native window, or disables double buffering.

  method set-opacity ( Num $opacity )

=item Num $opacity; desired opacity, between 0 and 1

=end pod

method set-opacity ( $opacity ) {
  gtk_widget_set_opacity( self._f('GtkWidget'), $opacity.Num);
}

sub gtk_widget_set_opacity (
  N-GObject $widget, gdouble $opacity
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-parent:
=begin pod
=head2 set-parent

This function is useful only when implementing subclasses of B<Gnome::Gtk3::Container>. Sets the container as the parent of I<widget>, and takes care of some details such as updating the state and style of the child to reflect its new location. The opposite function is C<unparent()>.

  method set-parent ( N-GObject $parent )

=item N-GObject $parent; parent container

=end pod

method set-parent ( $parent is copy ) {
  $parent .= get-native-object-no-reffing unless $parent ~~ N-GObject;

  gtk_widget_set_parent(
    self._f('GtkWidget'), $parent
  );
}

sub gtk_widget_set_parent (
  N-GObject $widget, N-GObject $parent
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-parent-window:
=begin pod
=head2 set-parent-window

Sets a non default parent window for I<widget>.

For B<Gnome::Gtk3::Window> classes, setting a I<parent-window> effects whether the window is a toplevel window or can be embedded into other widgets.

For B<Gnome::Gtk3::Window> classes, this needs to be called before the window is realized.

  method set-parent-window ( N-GObject $parent_window )

=item N-GObject $parent_window; the new parent window.

=end pod

method set-parent-window ( $parent_window is copy ) {
  $parent_window .= get-native-object-no-reffing unless $parent_window ~~ N-GObject;

  gtk_widget_set_parent_window(
    self._f('GtkWidget'), $parent_window
  );
}

sub gtk_widget_set_parent_window (
  N-GObject $widget, N-GObject $parent_window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-realized:
=begin pod
=head2 set-realized

Marks the widget as being realized. This function must only be called after all B<Gnome::Gtk3::Windows> for the I<widget> have been created and registered.

This function should only ever be called in a derived widget's “realize” or “unrealize” implementation.

  method set-realized ( Bool $realized )

=item Bool $realized; C<True> to mark the widget as realized

=end pod

method set-realized ( Bool $realized ) {

  gtk_widget_set_realized(
    self._f('GtkWidget'), $realized
  );
}

sub gtk_widget_set_realized (
  N-GObject $widget, gboolean $realized
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-receives-default:
=begin pod
=head2 set-receives-default

Specifies whether I<widget> will be treated as the default widget within its toplevel when it has the focus, even if another widget is the default.

See C<grab-default()> for details about the meaning of “default”.

  method set-receives-default ( Bool $receives_default )

=item Bool $receives_default; whether or not I<widget> can be a default widget.

=end pod

method set-receives-default ( Bool $receives_default ) {

  gtk_widget_set_receives_default(
    self._f('GtkWidget'), $receives_default
  );
}

sub gtk_widget_set_receives_default (
  N-GObject $widget, gboolean $receives_default
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-redraw-on-allocate:
=begin pod
=head2 set-redraw-on-allocate

Sets whether the entire widget is queued for drawing when its size allocation changes. By default, this setting is C<True> and the entire widget is redrawn on every size change. If your widget leaves the upper left unchanged when made bigger, turning this setting off will improve performance. Note that for widgets where C<get-has-window()> is C<False> setting this flag to C<False> turns off all allocation on resizing: the widget will not even redraw if its position changes; this is to allow containers that don’t draw anything to avoid excess invalidations. If you set this flag on a widget with no window that does draw on I<widget>->window, you are responsible for invalidating both the old and new allocation of the widget when the widget is moved and responsible for invalidating regions newly when the widget increases size.

  method set-redraw-on-allocate ( Bool $redraw_on_allocate )

=item Bool $redraw_on_allocate; if C<True>, the entire widget will be redrawn when it is allocated to a new size. Otherwise, only the new portion of the widget will be redrawn.

=end pod

method set-redraw-on-allocate ( Bool $redraw_on_allocate ) {

  gtk_widget_set_redraw_on_allocate(
    self._f('GtkWidget'), $redraw_on_allocate
  );
}

sub gtk_widget_set_redraw_on_allocate (
  N-GObject $widget, gboolean $redraw_on_allocate
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-sensitive:
=begin pod
=head2 set-sensitive

Sets the sensitivity of a widget. A widget is sensitive if the user can interact with it. Insensitive widgets are “grayed out” and the user can’t interact with them. Insensitive widgets are known as “inactive”, “disabled”, or “ghosted” in some other toolkits.

  method set-sensitive ( Bool $sensitive )

=item Bool $sensitive; C<True> to make the widget sensitive

=end pod

method set-sensitive ( Bool $sensitive ) {

  gtk_widget_set_sensitive(
    self._f('GtkWidget'), $sensitive
  );
}

sub gtk_widget_set_sensitive (
  N-GObject $widget, gboolean $sensitive
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-size-request:
=begin pod
=head2 set-size-request

Sets the minimum size of a widget; that is, the widget’s size request will be at least I<width> by I<height>. You can use this function to force a widget to be larger than it normally would be.

In most cases, C<gtk-window-set-default-size()> is a better choice for toplevel windows than this function; setting the default size will still allow users to shrink the window. Setting the size request will force them to leave the window at least as large as the size request. When dealing with window sizes, C<gtk-window-set-geometry-hints()> can be a useful function as well.

Note the inherent danger of setting any fixed size - themes, translations into other languages, different fonts, and user action can all change the appropriate size for a given widget. So, it's basically impossible to hardcode a size that will always be correct.

The size request of a widget is the smallest size a widget can accept while still functioning well and drawing itself correctly. However in some strange cases a widget may be allocated less than its requested size, and in many cases a widget may be allocated more space than it requested.

If the size request in a given direction is -1 (unset), then the “natural” size request of the widget will be used instead.

The size request set here does not include any margin from the B<Gnome::Gtk3::Widget> properties margin-left, margin-right, margin-top, and margin-bottom, but it does include pretty much all other padding or border properties set by any subclass of B<Gnome::Gtk3::Widget>.

  method set-size-request ( Int $width, Int $height )

=item Int $width; width I<widget> should request, or -1 to unset
=item Int $height; height I<widget> should request, or -1 to unset

=end pod

method set-size-request ( Int $width, Int $height ) {

  gtk_widget_set_size_request(
    self._f('GtkWidget'), $width, $height
  );
}

sub gtk_widget_set_size_request (
  N-GObject $widget, gint $width, gint $height
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-state-flags:
=begin pod
=head2 set-state-flags

This function is for use in widget implementations. Turns on flag values in the current widget state (insensitive, prelighted, etc.).

This function accepts the values C<GTK-STATE-FLAG-DIR-LTR> and C<GTK-STATE-FLAG-DIR-RTL> but ignores them. If you want to set the widget's direction, use C<set-direction()>.

It is worth mentioning that any other state than C<GTK-STATE-FLAG-INSENSITIVE>, will be propagated down to all non-internal children if I<widget> is a B<Gnome::Gtk3::Container>, while C<GTK-STATE-FLAG-INSENSITIVE> itself will be propagated down to all B<Gnome::Gtk3::Container> children by different means than turning on the state flag down the hierarchy, both C<get-state-flags()> and C<is-sensitive()> will make use of these.

  method set-state-flags ( GtkStateFlags $flags, Bool $clear )

=item GtkStateFlags $flags; State flags to turn on
=item Bool $clear; Whether to clear state before turning on I<flags>

=end pod

method set-state-flags ( GtkStateFlags $flags, Bool $clear ) {

  gtk_widget_set_state_flags(
    self._f('GtkWidget'), $flags, $clear
  );
}

sub gtk_widget_set_state_flags (
  N-GObject $widget, GEnum $flags, gboolean $clear
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-support-multidevice:
=begin pod
=head2 set-support-multidevice

Enables or disables multiple pointer awareness. If this setting is C<True>, I<widget> will start receiving multiple, per device enter/leave events. Note that if custom B<Gnome::Gtk3::Windows> are created in  I<realize>, C<gdk-window-set-support-multidevice()> will have to be called manually on them.

  method set-support-multidevice ( Bool $support_multidevice )

=item Bool $support_multidevice; C<True> to support input from multiple devices.

=end pod

method set-support-multidevice ( Bool $support_multidevice ) {

  gtk_widget_set_support_multidevice(
    self._f('GtkWidget'), $support_multidevice
  );
}

sub gtk_widget_set_support_multidevice (
  N-GObject $widget, gboolean $support_multidevice
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-tooltip-markup:
=begin pod
=head2 set-tooltip-markup

Sets I<markup> as the contents of the tooltip, which is marked up with the [Pango text markup language][PangoMarkupFormat].

This function will take care of setting  I<has-tooltip> to C<True> and of the default handler for the  I<query-tooltip> signal.

See also the  I<tooltip-markup> property and C<gtk-tooltip-set-markup()>.

  method set-tooltip-markup ( Str $markup )

=item Str $markup; the contents of the tooltip for I<widget>, or C<undefined>

=end pod

method set-tooltip-markup ( Str $markup ) {

  gtk_widget_set_tooltip_markup(
    self._f('GtkWidget'), $markup
  );
}

sub gtk_widget_set_tooltip_markup (
  N-GObject $widget, gchar-ptr $markup
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-tooltip-text:
=begin pod
=head2 set-tooltip-text

Sets I<text> as the contents of the tooltip. This function will take care of setting  I<has-tooltip> to C<True> and of the default handler for the  I<query-tooltip> signal.

See also the  I<tooltip-text> property and C<gtk-tooltip-set-text()>.

  method set-tooltip-text ( Str $text )

=item Str $text; the contents of the tooltip for I<widget>

=end pod

method set-tooltip-text ( Str $text ) {

  gtk_widget_set_tooltip_text(
    self._f('GtkWidget'), $text
  );
}

sub gtk_widget_set_tooltip_text (
  N-GObject $widget, gchar-ptr $text
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-tooltip-window:
=begin pod
=head2 set-tooltip-window

Replaces the default window used for displaying tooltips with I<custom-window>. GTK+ will take care of showing and hiding I<custom-window> at the right moment, to behave likewise as the default tooltip window. If I<custom-window> is C<undefined>, the default tooltip window will be used.

  method set-tooltip-window ( N-GObject $custom_window )

=item N-GObject $custom_window; a B<Gnome::Gtk3::Window>, or C<undefined>

=end pod

method set-tooltip-window ( $custom_window is copy ) {
  $custom_window .= get-native-object-no-reffing unless $custom_window ~~ N-GObject;

  gtk_widget_set_tooltip_window(
    self._f('GtkWidget'), $custom_window
  );
}

sub gtk_widget_set_tooltip_window (
  N-GObject $widget, N-GObject $custom_window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-valign:
=begin pod
=head2 set-valign

Sets the vertical alignment of I<widget>. See the  I<valign> property.

  method set-valign ( GtkAlign $align )

=item GtkAlign $align; the vertical alignment

=end pod

method set-valign ( GtkAlign $align ) {

  gtk_widget_set_valign(
    self._f('GtkWidget'), $align
  );
}

sub gtk_widget_set_valign (
  N-GObject $widget, GEnum $align
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-vexpand:
=begin pod
=head2 set-vexpand

Sets whether the widget would like any available extra vertical space.

See C<set-hexpand()> for more detail.

  method set-vexpand ( Bool $expand )

=item Bool $expand; whether to expand

=end pod

method set-vexpand ( Bool $expand ) {

  gtk_widget_set_vexpand(
    self._f('GtkWidget'), $expand
  );
}

sub gtk_widget_set_vexpand (
  N-GObject $widget, gboolean $expand
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-vexpand-set:
=begin pod
=head2 set-vexpand-set

Sets whether the vexpand flag (see C<get-vexpand()>) will be used.

See C<set-hexpand-set()> for more detail.

  method set-vexpand-set ( Bool $set )

=item Bool $set; value for vexpand-set property

=end pod

method set-vexpand-set ( Bool $set ) {

  gtk_widget_set_vexpand_set(
    self._f('GtkWidget'), $set
  );
}

sub gtk_widget_set_vexpand_set (
  N-GObject $widget, gboolean $set
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-visible:
=begin pod
=head2 set-visible

Sets the visibility state of I<widget>. Note that setting this to C<True> doesn’t mean the widget is actually viewable, see C<get-visible()>.

This function simply calls C<show()> or C<hide()> but is nicer to use when the visibility of the widget depends on some condition.

  method set-visible ( Bool $visible )

=item Bool $visible; whether the widget should be shown or not

=end pod

method set-visible ( Bool $visible ) {

  gtk_widget_set_visible(
    self._f('GtkWidget'), $visible
  );
}

sub gtk_widget_set_visible (
  N-GObject $widget, gboolean $visible
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-visual:
=begin pod
=head2 set-visual

Sets the visual that should be used for by widget and its children for creating B<Gnome::Gtk3::Windows>. The visual must be on the same B<Gnome::Gtk3::Screen> as returned by C<get-screen()>, so handling the  I<screen-changed> signal is necessary.

Setting a new I<visual> will not cause I<widget> to recreate its windows, so you should call this function before I<widget> is realized.

  method set-visual ( N-GObject $visual )

=item N-GObject $visual; visual to be used or C<undefined> to unset a previous one

=end pod

method set-visual ( $visual is copy ) {
  $visual .= get-native-object-no-reffing unless $visual ~~ N-GObject;

  gtk_widget_set_visual(
    self._f('GtkWidget'), $visual
  );
}

sub gtk_widget_set_visual (
  N-GObject $widget, N-GObject $visual
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-window:
=begin pod
=head2 set-window

Sets a widget’s window. This function should only be used in a widget’s  I<realize> implementation. The C<window> passed is usually either new window created with C<gdk-window-new()>, or the window of its parent widget as returned by C<get-parent-window()>.

Widgets must indicate whether they will create their own B<Gnome::Gtk3::Window> by calling C<set-has-window()>. This is usually done in the widget’s C<init()> function.

Note that this function does not add any reference to I<window>.

  method set-window ( N-GObject $window )

=item N-GObject $window; a B<Gnome::Gtk3::Window>

=end pod

method set-window ( $window is copy ) {
  $window .= get-native-object-no-reffing unless $window ~~ N-GObject;

  gtk_widget_set_window(
    self._f('GtkWidget'), $window
  );
}

sub gtk_widget_set_window (
  N-GObject $widget, N-GObject $window
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:shape-combine-region:
=begin pod
=head2 shape-combine-region

Sets a shape for this widget’s GDK window. This allows for transparent windows etc., see C<gdk-window-shape-combine-region()> for more information.

  method shape-combine-region ( cairo_region_t $region )

=item cairo_region_t $region; shape to be added, or C<undefined> to remove an existing shape

=end pod

method shape-combine-region ( cairo_region_t $region ) {

  gtk_widget_shape_combine_region(
    self._f('GtkWidget'), $region
  );
}

sub gtk_widget_shape_combine_region (
  N-GObject $widget, cairo_region_t $region
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:show:
=begin pod
=head2 show

Flags a widget to be displayed. Any widget that isn’t shown will not appear on the screen. If you want to show all the widgets in a container, it’s easier to call C<show-all()> on the container, instead of individually showing the widgets.

Remember that you have to show the containers containing a widget, in addition to the widget itself, before it will appear onscreen.

When a toplevel container is shown, it is immediately realized and mapped; other shown widgets are realized and mapped when their toplevel container is realized and mapped.

  method show ( )


=end pod

method show ( ) {

  gtk_widget_show(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_show (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:show-all:
=begin pod
=head2 show-all

Recursively shows a widget, and any child widgets (if the widget is a container).

  method show-all ( )


=end pod

method show-all ( ) {

  gtk_widget_show_all(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_show_all (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:show-now:
=begin pod
=head2 show-now

Shows a widget. If the widget is an unmapped toplevel widget (i.e. a B<Gnome::Gtk3::Window> that has not yet been shown), enter the main loop and wait for the window to actually be mapped. Be careful; because the main loop is running, anything can happen during this function.

  method show-now ( )


=end pod

method show-now ( ) {

  gtk_widget_show_now(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_show_now (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:size-allocate:
=begin pod
=head2 size-allocate

This function is only used by B<Gnome::Gtk3::Container> subclasses, to assign a size and position to their child widgets.

In this function, the allocation may be adjusted. It will be forced to a 1x1 minimum size, and the adjust-size-allocation virtual method on the child will be used to adjust the allocation. Standard adjustments include removing the widget’s margins, and applying the widget’s  I<halign> and  I<valign> properties.

For baseline support in containers you need to use C<size-allocate-with-baseline()> instead.

  method size-allocate ( N-GtkAllocation $allocation )

=item N-GtkAllocation $allocation; position and size to be allocated to I<widget>

=end pod

method size-allocate ( N-GtkAllocation $allocation ) {

  gtk_widget_size_allocate(
    self._f('GtkWidget'), $allocation
  );
}

sub gtk_widget_size_allocate (
  N-GObject $widget, N-GtkAllocation $allocation
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:size-allocate-with-baseline:
=begin pod
=head2 size-allocate-with-baseline

This function is only used by B<Gnome::Gtk3::Container> subclasses, to assign a size, position and (optionally) baseline to their child widgets.

In this function, the allocation and baseline may be adjusted. It will be forced to a 1x1 minimum size, and the adjust-size-allocation virtual and adjust-baseline-allocation methods on the child will be used to adjust the allocation and baseline. Standard adjustments include removing the widget's margins, and applying the widget’s  I<halign> and  I<valign> properties.

If the child widget does not have a valign of C<GTK-ALIGN-BASELINE> the baseline argument is ignored and -1 is used instead.

  method size-allocate-with-baseline ( N-GtkAllocation $allocation, Int $baseline )

=item N-GtkAllocation $allocation; position and size to be allocated to I<widget>
=item Int $baseline; The baseline of the child, or -1

=end pod

method size-allocate-with-baseline ( N-GtkAllocation $allocation, Int $baseline ) {

  gtk_widget_size_allocate_with_baseline(
    self._f('GtkWidget'), $allocation, $baseline
  );
}

sub gtk_widget_size_allocate_with_baseline (
  N-GObject $widget, N-GtkAllocation $allocation, gint $baseline
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:style-get:
=begin pod
=head2 style-get

Gets the values of a multiple style properties of I<widget>.

  method style-get ( Str $first_property_name )

=item Str $first_property_name; the name of the first property to get @...: pairs of property names and locations to return the property values, starting with the location for I<first-property-name>, terminated by C<undefined>.

=end pod

method style-get ( Str $first_property_name ) {

  gtk_widget_style_get(
    self._f('GtkWidget'), $first_property_name
  );
}

sub gtk_widget_style_get (
  N-GObject $widget, gchar-ptr $first_property_name, Any $any = Any
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:style-get-property:
=begin pod
=head2 style-get-property

Gets the value of a style property of I<widget>.

  method style-get-property ( Str $property_name, N-GObject $value )

=item Str $property_name; the name of a style property
=item N-GObject $value; location to return the property value

=end pod

method style-get-property ( Str $property_name, $value is copy ) {
  $value .= get-native-object-no-reffing unless $value ~~ N-GObject;

  gtk_widget_style_get_property(
    self._f('GtkWidget'), $property_name, $value
  );
}

sub gtk_widget_style_get_property (
  N-GObject $widget, gchar-ptr $property_name, N-GObject $value
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:0:style-get-valist:
=begin pod
=head2 style-get-valist

Non-vararg variant of C<style-get()>. Used primarily by language bindings.

  method style-get-valist ( Str $first_property_name, va_list $var_args )

=item Str $first_property_name; the name of the first property to get
=item va_list $var_args; a va-list of pairs of property names and locations to return the property values, starting with the location for I<first-property-name>.

=end pod

method style-get-valist ( Str $first_property_name, va_list $var_args ) {

  gtk_widget_style_get_valist(
    self._f('GtkWidget'), $first_property_name, $var_args
  );
}

sub gtk_widget_style_get_valist (
  N-GObject $widget, gchar-ptr $first_property_name, va_list $var_args
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:thaw-child-notify:
=begin pod
=head2 thaw-child-notify

Reverts the effect of a previous call to C<freeze-child-notify()>. This causes all queued  I<child-notify> signals on I<widget> to be emitted.

  method thaw-child-notify ( )


=end pod

method thaw-child-notify ( ) {

  gtk_widget_thaw_child_notify(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_thaw_child_notify (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:translate-coordinates:
=begin pod
=head2 translate-coordinates

Translate coordinates relative to I<src-widget>’s allocation to coordinates relative to I<dest-widget>’s allocations. In order to perform this operation, both widgets must be realized, and must share a common toplevel.


  method translate-coordinates (
    N-GObject $dest_widget, Int $src_x, Int $src_y --> List
  )

=item N-GObject $dest_widget; a B<Gnome::Gtk3::Widget>
=item Int $src_x; X position relative to I<src-widget>
=item Int $src_y; Y position relative to I<src-widget>

Returns a List which holds;
=item Bool result; <False> if either widget was not realized, or there was no common ancestor. In this case, the next values are undefined. Otherwise C<True> and the next values are defined Int.
=item Int dest_x; X position relative to I<$dest-widget>
=item Int dest_y; Y position relative to I<$dest-widget>

=end pod

method translate-coordinates (
  $dest_widget is copy, Int $src_x, Int $src_y --> List
) {
  $dest_widget .= get-native-object-no-reffing unless $dest_widget ~~ N-GObject;
  my gint $dest_x;
  my gint $dest_y;
  my Bool $r = gtk_widget_translate_coordinates(
    self._f('GtkWidget'), $dest_widget, $src_x, $src_y, $dest_x, $dest_y
  );

  ( $r, $dest_x, $dest_y);
}

sub gtk_widget_translate_coordinates (
  N-GObject $src_widget, N-GObject $dest_widget, gint $src_x, gint $src_y,
  gint $dest_x is rw, gint $dest_y is rw --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:trigger-tooltip-query:
=begin pod
=head2 trigger-tooltip-query

Triggers a tooltip query on the display where the toplevel of I<widget> is located. See C<gtk-tooltip-trigger-tooltip-query()> for more information.

  method trigger-tooltip-query ( )


=end pod

method trigger-tooltip-query ( ) {

  gtk_widget_trigger_tooltip_query(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_trigger_tooltip_query (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unmap:
=begin pod
=head2 unmap

This function is only for use in widget implementations. Causes a widget to be unmapped if it’s currently mapped.

  method unmap ( )


=end pod

method unmap ( ) {

  gtk_widget_unmap(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_unmap (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unparent:
=begin pod
=head2 unparent

This function is only for use in widget implementations. Should be called by implementations of the remove method on B<Gnome::Gtk3::Container>, to dissociate a child from the container.

  method unparent ( )


=end pod

method unparent ( ) {

  gtk_widget_unparent(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_unparent (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unrealize:
=begin pod
=head2 unrealize

This function is only useful in widget implementations. Causes a widget to be unrealized (frees all GDK resources associated with the widget, such as I<widget>->window).

  method unrealize ( )


=end pod

method unrealize ( ) {

  gtk_widget_unrealize(
    self._f('GtkWidget'),
  );
}

sub gtk_widget_unrealize (
  N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:unregister-window:
=begin pod
=head2 unregister-window

Unregisters a B<Gnome::Gtk3::Window> from the widget that was previously set up with C<register-window()>. You need to call this when the window is no longer used by the widget, such as when you destroy it.

  method unregister-window ( N-GObject $window )

=item N-GObject $window; a B<Gnome::Gtk3::Window>

=end pod

method unregister-window ( $window is copy ) {
  $window .= get-native-object-no-reffing unless $window ~~ N-GObject;

  gtk_widget_unregister_window(
    self._f('GtkWidget'), $window
  );
}

sub gtk_widget_unregister_window (
  N-GObject $widget, N-GObject $window
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unset-state-flags:
=begin pod
=head2 unset-state-flags

This function is for use in widget implementations. Turns off flag values for the current widget state (insensitive, prelighted, etc.). See C<set-state-flags()>.

  method unset-state-flags ( GtkStateFlags $flags )

=item GtkStateFlags $flags; State flags to turn off

=end pod

method unset-state-flags ( GtkStateFlags $flags ) {

  gtk_widget_unset_state_flags(
    self._f('GtkWidget'), $flags
  );
}

sub gtk_widget_unset_state_flags (
  N-GObject $widget, GEnum $flags
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:1:_gtk_widget_new:
#`{{
=begin pod
=head2 _gtk_widget_new

This is a convenience function for creating a widget and setting its properties in one go. For example you might write: `new (GTK-TYPE-LABEL, "label", "Hello World", "xalign", 0.0, NULL)` to create a left-aligned label. Equivalent to C<g-object-new()>, but returns a widget so you don’t have to cast the object yourself.

Returns: a new B<Gnome::Gtk3::Widget> of type I<widget-type>

  method _gtk_widget_new ( N-GObject $type, Str $first_property_name --> N-GObject )

=item N-GObject $type; type ID of the widget to create
=item Str $first_property_name; name of first property to set @...: value of first property, followed by more properties, C<undefined>-terminated

=end pod
}}

sub _gtk_widget_new ( N-GObject $type, gchar-ptr $first_property_name, Any $any = Any --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_widget_new')
  { * }
}}

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
=comment #TS:0:accel-closures-changed:
=head3 accel-closures-changed

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.


=comment -----------------------------------------------------------------------
=comment #TS:0:button-press-event:
=head3 button-press-event

The I<button-press-event> signal will be emitted when a button
(typically from a mouse) is pressed.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the
widget needs to enable the B<Gnome::Gtk3::DK-BUTTON-PRESS-MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.

=item $event; (type Gdk.EventButton): the B<Gnome::Gtk3::EventButton> which triggered
this signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:button-release-event:
=head3 button-release-event

The I<button-release-event> signal will be emitted when a button
(typically from a mouse) is released.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the
widget needs to enable the B<Gnome::Gtk3::DK-BUTTON-RELEASE-MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.

=item $event; (type Gdk.EventButton): the B<Gnome::Gtk3::EventButton> which triggered
this signal.

=begin comment
=comment -----------------------------------------------------------------------
=comment #TS:0:can-activate-accel:
=head3 can-activate-accel

  method handler (
    guint $signal-id,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget;
=item $signal-id;
=end comment

=begin comment
=comment -----------------------------------------------------------------------
=comment # TS:0:child-notify:
=head3 child-notify

The I<child-notify> signal is emitted for each child property that has changed on an object. The signal's detail holds the property name.

  method handler (
    ?? $child_property,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $child_property; the B<Gnome::Gtk3::ParamSpec> of the changed child property
=end comment


=comment -----------------------------------------------------------------------
=comment #TS:0:configure-event:
=head3 configure-event

The I<configure-event> signal will be emitted when the size, position or
stacking of the I<widget>'s window has changed.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-STRUCTURE-MASK> mask. GDK will enable this mask
automatically for all new windows.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventConfigure): the B<Gnome::Gtk3::EventConfigure> which triggered
this signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:damage-event:
=head3 damage-event

Emitted when a redirected window belonging to I<widget> gets drawn into.
The region/area members of the event shows what area of the redirected
drawable was drawn into.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.


  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventExpose): the B<Gnome::Gtk3::EventExpose> event


=comment -----------------------------------------------------------------------
=comment #TS:0:delete-event:
=head3 delete-event

The I<delete-event> signal is emitted if a user requests that
a toplevel window is closed. The default handler for this signal
destroys the window. Connecting C<hide-on-delete()> to
this signal will cause the window to be hidden instead, so that
it can later be shown again without reconstructing it.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    - $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $event; the event which triggered this signal


=comment -----------------------------------------------------------------------
=comment #TS:0:destroy:
=head3 destroy

Signals that all holders of a reference to the widget should release
the reference that they hold. May result in finalization of the widget
if all references are released.

This signal is not suitable for saving widget state.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($object),
    *%user-options
  );

=item $object; the object which received the signal


=comment -----------------------------------------------------------------------
=comment #TS:0:destroy-event:
=head3 destroy-event

The I<destroy-event> signal is emitted when a B<Gnome::Gtk3::Window> is destroyed.
You rarely get this signal, because most widgets disconnect themselves
from their window before they destroy it, so no widget owns the
window at destroy time.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-STRUCTURE-MASK> mask. GDK will enable this mask
automatically for all new windows.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.

=item $event; the event which triggered this signal


=comment -----------------------------------------------------------------------
=comment #TS:0:direction-changed:
=head3 direction-changed

The I<direction-changed> signal is emitted when the text direction
of a widget changes.

  method handler (
    GEnum $previous_direction,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object on which the signal is emitted
=item $previous_direction; the previous text direction of I<widget> as a GTK_TYPE_TEXT_DIRECTION enum

=begin comment
=comment -----------------------------------------------------------------------
=comment #TS:0:drag-begin:
=head3 drag-begin

The I<drag-begin> signal is emitted on the drag source when a drag is
started. A typical reason to connect to this signal is to set up a
custom drag icon with e.g. C<gtk-drag-source-set-icon-pixbuf()>.

Note that some widgets set up a drag icon in the default handler of
this signal, so you may have to use C<g-signal-connect-after()> to
override what the default handler did.

  method handler (
    Unknown type GDK_TYPE_DRAG_CONTEXT $context,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $context; the drag context


=comment -----------------------------------------------------------------------
=comment #TS:0:drag-data-delete:
=head3 drag-data-delete

The I<drag-data-delete> signal is emitted on the drag source when a drag
with the action C<GDK-ACTION-MOVE> is successfully completed. The signal
handler is responsible for deleting the data that has been dropped. What
"delete" means depends on the context of the drag operation.

  method handler (
    Unknown type GDK_TYPE_DRAG_CONTEXT $context,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $context; the drag context


=comment -----------------------------------------------------------------------
=comment #TS:0:drag-data-get:
=head3 drag-data-get

The I<drag-data-get> signal is emitted on the drag source when the drop
site requests the data which is dragged. It is the responsibility of
the signal handler to fill I<data> with the data in the format which
is indicated by I<info>. See C<gtk-selection-data-set()> and
C<gtk-selection-data-set-text()>.

  method handler (
    Unknown type GDK_TYPE_DRAG_CONTEXT $context,
    Int $data,
    Int $info,
     $time,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $context; the drag context

=item $data; the B<Gnome::Gtk3::SelectionData> to be filled with the dragged data

=item $info; the info that has been registered with the target in the
B<Gnome::Gtk3::TargetList>
=item $time; the timestamp at which the data was requested


=comment -----------------------------------------------------------------------
=comment #TS:0:drag-data-received:
=head3 drag-data-received

The I<drag-data-received> signal is emitted on the drop site when the
dragged data has been received. If the data was received in order to
determine whether the drop will be accepted, the handler is expected
to call C<gdk-drag-status()> and not finish the drag.
If the data was received in response to a  I<drag-drop> signal
(and this is the last target to be received), the handler for this
signal is expected to process the received data and then call
C<gtk-drag-finish()>, setting the I<success> parameter depending on
whether the data was processed successfully.

Applications must create some means to determine why the signal was emitted
and therefore whether to call C<gdk-drag-status()> or C<gtk-drag-finish()>.

The handler may inspect the selected action with
C<gdk-drag-context-get-selected-action()> before calling
C<gtk-drag-finish()>, e.g. to implement C<GDK-ACTION-ASK> as
shown in the following example:
|[<!-- language="C" -->
void
drag-data-received (GtkWidget          *widget,
GdkDragContext     *context,
gint                x,
gint                y,
GtkSelectionData   *data,
guint               info,
guint               time)
{
if ((data->length >= 0) && (data->format == 8))
{
GdkDragAction action;

// handle data here

action = gdk-drag-context-get-selected-action (context);
if (action == GDK-ACTION-ASK)
{
GtkWidget *dialog;
gint response;

dialog = gtk-message-dialog-new (NULL,
GTK-DIALOG-MODAL |
GTK-DIALOG-DESTROY-WITH-PARENT,
GTK-MESSAGE-INFO,
GTK-BUTTONS-YES-NO,
"Move the data ?\n");
response = gtk-dialog-run (GTK-DIALOG (dialog));
destroy (dialog);

if (response == GTK-RESPONSE-YES)
action = GDK-ACTION-MOVE;
else
action = GDK-ACTION-COPY;
}

gtk-drag-finish (context, TRUE, action == GDK-ACTION-MOVE, time);
}
else
gtk-drag-finish (context, FALSE, FALSE, time);
}
]|

  method handler (
    Unknown type GDK_TYPE_DRAG_CONTEXT $context,
    Unknown type GTK_TYPE_SELECTION_DATA | G_SIGNAL_TYPE_STATIC_SCOPE $x,
     $y,
     $data,
    - $info,
    - $time,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $context; the drag context

=item $x; where the drop happened

=item $y; where the drop happened

=item $data; the received data

=item $info; the info that has been registered with the target in the
B<Gnome::Gtk3::TargetList>
=item $time; the timestamp at which the data was received


=comment -----------------------------------------------------------------------
=comment #TS:0:drag-drop:
=head3 drag-drop

The I<drag-drop> signal is emitted on the drop site when the user drops
the data onto the widget. The signal handler must determine whether
the cursor position is in a drop zone or not. If it is not in a drop
zone, it returns C<False> and no further processing is necessary.
Otherwise, the handler returns C<True>. In this case, the handler must
ensure that C<gtk-drag-finish()> is called to let the source know that
the drop is done. The call to C<gtk-drag-finish()> can be done either
directly or in a  I<drag-data-received> handler which gets
triggered by calling C<gtk-drag-get-data()> to receive the data for one
or more of the supported targets.

Returns: whether the cursor position is in a drop zone

  method handler (
    Unknown type GDK_TYPE_DRAG_CONTEXT $context,
    Int $x,
    Int $y,
     $time,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $context; the drag context

=item $x; the x coordinate of the current cursor position

=item $y; the y coordinate of the current cursor position

=item $time; the timestamp of the motion event


=comment -----------------------------------------------------------------------
=comment #TS:0:drag-end:
=head3 drag-end

The I<drag-end> signal is emitted on the drag source when a drag is
finished.  A typical reason to connect to this signal is to undo
things done in  I<drag-begin>.

  method handler (
    Unknown type GDK_TYPE_DRAG_CONTEXT $context,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $context; the drag context


=comment -----------------------------------------------------------------------
=comment #TS:0:drag-failed:
=head3 drag-failed

The I<drag-failed> signal is emitted on the drag source when a drag has
failed. The signal handler may hook custom code to handle a failed DnD
operation based on the type of error, it returns C<True> is the failure has
been already handled (not showing the default "drag operation failed"
animation), otherwise it returns C<False>.

Returns: C<True> if the failed drag operation has been already handled.


  method handler (
    Unknown type GDK_TYPE_DRAG_CONTEXT $context,
    - $result,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $context; the drag context

=item $result; the result of the drag operation


=comment -----------------------------------------------------------------------
=comment #TS:0:drag-leave:
=head3 drag-leave

The I<drag-leave> signal is emitted on the drop site when the cursor
leaves the widget. A typical reason to connect to this signal is to
undo things done in  I<drag-motion>, e.g. undo highlighting
with C<gtk-drag-unhighlight()>.


Likewise, the  I<drag-leave> signal is also emitted before the  I<drag-drop> signal, for instance to allow cleaning up of a preview item
created in the  I<drag-motion> signal handler.

  method handler (
    Unknown type GDK_TYPE_EVENT | G_SIGNAL_TYPE_STATIC_SCOPE $context,
    - $time,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.

=item $context; the drag context

=item $time; the timestamp of the motion event

=comment -----------------------------------------------------------------------
=comment # TS:0:drag-motion:
=head3 drag-motion

The I<drag-motion> signal is emitted on the drop site when the user
moves the cursor over the widget during a drag. The signal handler
must determine whether the cursor position is in a drop zone or not.
If it is not in a drop zone, it returns C<False> and no further processing
is necessary. Otherwise, the handler returns C<True>. In this case, the
handler is responsible for providing the necessary information for
displaying feedback to the user, by calling C<gdk-drag-status()>.

If the decision whether the drop will be accepted or rejected can't be
made based solely on the cursor position and the type of the data, the
handler may inspect the dragged data by calling C<gtk-drag-get-data()> and
defer the C<gdk-drag-status()> call to the  I<drag-data-received>
handler. Note that you must pass B<Gnome::Gtk3::TK-DEST-DEFAULT-DROP>,
B<Gnome::Gtk3::TK-DEST-DEFAULT-MOTION> or B<Gnome::Gtk3::TK-DEST-DEFAULT-ALL> to C<gtk-drag-dest-set()>
when using the drag-motion signal that way.

Also note that there is no drag-enter signal. The drag receiver has to
keep track of whether he has received any drag-motion signals since the
last  I<drag-leave> and if not, treat the drag-motion signal as
an "enter" signal. Upon an "enter", the handler will typically highlight
the drop site with C<gtk-drag-highlight()>.
|[<!-- language="C" -->
static void
drag-motion (GtkWidget      *widget,
GdkDragContext *context,
gint            x,
gint            y,
guint           time)
{
GdkAtom target;

PrivateData *private-data = GET-PRIVATE-DATA (widget);

if (!private-data->drag-highlight)
{
private-data->drag-highlight = 1;
gtk-drag-highlight (widget);
}

target = gtk-drag-dest-find-target (widget, context, NULL);
if (target == GDK-NONE)
gdk-drag-status (context, 0, time);
else
{
private-data->pending-status
= gdk-drag-context-get-suggested-action (context);
gtk-drag-get-data (widget, context, target, time);
}

return TRUE;
}

static void
drag-data-received (GtkWidget        *widget,
GdkDragContext   *context,
gint              x,
gint              y,
GtkSelectionData *selection-data,
guint             info,
guint             time)
{
PrivateData *private-data = GET-PRIVATE-DATA (widget);

if (private-data->suggested-action)
{
private-data->suggested-action = 0;

// We are getting this data due to a request in drag-motion,
// rather than due to a request in drag-drop, so we are just
// supposed to call C<gdk-drag-status()>, not actually paste in
// the data.

str = gtk-selection-data-get-text (selection-data);
if (!data-is-acceptable (str))
gdk-drag-status (context, 0, time);
else
gdk-drag-status (context,
private-data->suggested-action,
time);
}
else
{
// accept the drop
}
}
]|

Returns: whether the cursor position is in a drop zone

  method handler (
    Unknown type GDK_TYPE_DRAG_CONTEXT $context,
    Unknown type GTK_TYPE_DRAG_RESULT $x,
    - $y,
    - $time,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $context; the drag context

=item $x; the x coordinate of the current cursor position

=item $y; the y coordinate of the current cursor position

=item $time; the timestamp of the motion event
=end comment

=begin comment
=comment -----------------------------------------------------------------------
=comment #TS:0:draw:
=head3 draw

This signal is emitted when a widget is supposed to render itself.
The I<widget>'s top left corner must be painted at the origin of
the passed in context and be sized to the values returned by
C<get-allocated-width()> and
C<get-allocated-height()>.

Signal handlers connected to this signal can modify the cairo
context passed as I<cr> in any way they like and don't need to
restore it. The signal emission takes care of calling C<cairo-save()>
before and C<cairo-restore()> after invoking the handler.

The signal handler will get a I<cr> with a clip region already set to the
widget's dirty region, i.e. to the area that needs repainting.  Complicated
widgets that want to avoid redrawing themselves completely can get the full
extents of the clip region with C<gdk-cairo-get-clip-rectangle()>, or they can
get a finer-grained representation of the dirty region with
C<cairo-copy-clip-rectangle-list()>.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.


  method handler (
    Unknown type CAIRO_GOBJECT_TYPE_CONTEXT $cr,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $cr; the cairo context to draw to
=end comment


=comment -----------------------------------------------------------------------
=comment #TS:0:enter-notify-event:
=head3 enter-notify-event

The I<enter-notify-event> will be emitted when the pointer enters
the I<widget>'s window.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-ENTER-NOTIFY-MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventCrossing): the B<Gnome::Gtk3::EventCrossing> which triggered
this signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:event:
=head3 event

The GTK+ main loop will emit three signals for each GDK event delivered
to a widget: one generic I<event> signal, another, more specific,
signal that matches the type of event delivered (e.g.
 I<key-press-event>) and finally a generic
 I<event-after> signal.

Returns: C<True> to stop other handlers from being invoked for the event
and to cancel the emission of the second specific I<event> signal.
C<False> to propagate the event further and to allow the emission of
the second signal. The I<event-after> signal is emitted regardless of
the return value.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.

=item $event; the B<Gnome::Gtk3::Event> which triggered this signal


=comment -----------------------------------------------------------------------
=comment #TS:0:event-after:
=head3 event-after

After the emission of the  I<event> signal and (optionally)
the second more specific signal, I<event-after> will be emitted
regardless of the previous two signals handlers return values.


  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.

=item $event; the B<Gnome::Gtk3::Event> which triggered this signal


=comment -----------------------------------------------------------------------
=comment #TS:0:focus:
=head3 focus

Returns: C<True> to stop other handlers from being invoked for the event. C<False> to propagate the event further.

  method handler (
    Unknown type GTK_TYPE_DIRECTION_TYPE $direction,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.

=item $direction;


=comment -----------------------------------------------------------------------
=comment #TS:0:focus-in-event:
=head3 focus-in-event

The I<focus-in-event> signal will be emitted when the keyboard focus
enters the I<widget>'s window.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-FOCUS-CHANGE-MASK> mask.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventFocus): the B<Gnome::Gtk3::EventFocus> which triggered
this signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:focus-out-event:
=head3 focus-out-event

The I<focus-out-event> signal will be emitted when the keyboard focus
leaves the I<widget>'s window.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-FOCUS-CHANGE-MASK> mask.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventFocus): the B<Gnome::Gtk3::EventFocus> which triggered this
signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:grab-broken-event:
=head3 grab-broken-event

Emitted when a pointer or keyboard grab on a window belonging
to I<widget> gets broken.

On X11, this happens when the grab window becomes unviewable
(i.e. it or one of its ancestors is unmapped), or if the same
application grabs the pointer or keyboard again.

Returns: C<True> to stop other handlers from being invoked for
the event. C<False> to propagate the event further.


  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventGrabBroken): the B<Gnome::Gtk3::EventGrabBroken> event


=comment -----------------------------------------------------------------------
=comment #TS:0:grab-focus:
=head3 grab-focus

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.


=comment -----------------------------------------------------------------------
=comment #TS:0:grab-notify:
=head3 grab-notify

The I<grab-notify> signal is emitted when a widget becomes
shadowed by a GTK+ grab (not a pointer or keyboard grab) on
another widget, or when it becomes unshadowed due to a grab
being removed.

A widget is shadowed by a C<gtk-grab-add()> when the topmost
grab widget in the grab stack of its window group is not
its ancestor.

  method handler (
    Int $was_grabbed,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal

=item $was_grabbed; C<False> if the widget becomes shadowed, C<True>
if it becomes unshadowed

=comment -----------------------------------------------------------------------
=comment #TS:0:hide:
=head3 hide

The I<hide> signal is emitted when I<widget> is hidden, for example with
C<hide()>.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.


=comment -----------------------------------------------------------------------
=comment #TS:0:hierarchy-changed:
=head3 hierarchy-changed

The I<hierarchy-changed> signal is emitted when the
anchored state of a widget changes. A widget is
“anchored” when its toplevel
ancestor is a B<Gnome::Gtk3::Window>. This signal is emitted when
a widget changes from un-anchored to anchored or vice-versa.

  method handler (
    N-GObject #`{ is widget } $previous_toplevel,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object on which the signal is emitted

=item $previous_toplevel; (allow-none): the previous toplevel ancestor, or C<undefined>
if the widget was previously unanchored

=comment -----------------------------------------------------------------------
=comment #TS:0:key-press-event:
=head3 key-press-event

The I<key-press-event> signal is emitted when a key is pressed. The signal
emission will reoccur at the key-repeat rate when the key is kept pressed.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-KEY-PRESS-MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventKey): the B<Gnome::Gtk3::EventKey> which triggered this signal.


=comment -----------------------------------------------------------------------
=comment #TS:0:key-release-event:
=head3 key-release-event

The I<key-release-event> signal is emitted when a key is released.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-KEY-RELEASE-MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventKey): the B<Gnome::Gtk3::EventKey> which triggered this signal.


=comment -----------------------------------------------------------------------
=comment #TS:0:keynav-failed:
=head3 keynav-failed

Gets emitted if keyboard navigation fails.
See C<keynav-failed()> for details.

Returns: C<True> if stopping keyboard navigation is fine, C<False>
if the emitting widget should try to handle the keyboard
navigation attempt in its parent container(s).


  method handler (
    Unknown type GTK_TYPE_DIRECTION_TYPE $direction,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $direction; the direction of movement


=comment -----------------------------------------------------------------------
=comment #TS:0:leave-notify-event:
=head3 leave-notify-event

The I<leave-notify-event> will be emitted when the pointer leaves
the I<widget>'s window.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-LEAVE-NOTIFY-MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventCrossing): the B<Gnome::Gtk3::EventCrossing> which triggered
this signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:map:
=head3 map

The I<map> signal is emitted when I<widget> is going to be mapped, that is
when the widget is visible (which is controlled with
C<set-visible()>) and all its parents up to the toplevel widget
are also visible. Once the map has occurred,  I<map-event> will
be emitted.

The I<map> signal can be used to determine whether a widget will be drawn,
for instance it can resume an animation that was stopped during the
emission of  I<unmap>.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.


=comment -----------------------------------------------------------------------
=comment #TS:0:map-event:
=head3 map-event

The I<map-event> signal will be emitted when the I<widget>'s window is
mapped. A window is mapped when it becomes visible on the screen.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-STRUCTURE-MASK> mask. GDK will enable this mask
automatically for all new windows.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventAny): the B<Gnome::Gtk3::EventAny> which triggered this signal.


=comment -----------------------------------------------------------------------
=comment #TS:0:mnemonic-activate:
=head3 mnemonic-activate

The default handler for this signal activates I<widget> if I<group-cycling>
is C<False>, or just makes I<widget> grab focus if I<group-cycling> is C<True>.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    Int $group_cycling,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.

=item $group_cycling; C<True> if there are other widgets with the same mnemonic


=comment -----------------------------------------------------------------------
=comment #TS:0:motion-notify-event:
=head3 motion-notify-event

The I<motion-notify-event> signal is emitted when the pointer moves
over the widget's B<Gnome::Gtk3::Window>.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the widget
needs to enable the B<Gnome::Gtk3::DK-POINTER-MOTION-MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.

=item $event; (type Gdk.EventMotion): the B<Gnome::Gtk3::EventMotion> which triggered
this signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:move-focus:
=head3 move-focus

  method handler (
    Unknown type GTK_TYPE_DIRECTION_TYPE $direction,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.

=item $direction;


=comment -----------------------------------------------------------------------
=comment #TS:0:parent-set:
=head3 parent-set

The I<parent-set> signal is emitted when a new parent
has been set on a widget.

  method handler (
    N-GObject #`{ is widget } $old_parent,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object on which the signal is emitted

=item $old_parent; (allow-none): the previous parent, or C<undefined> if the widget
just got its initial parent.

=comment -----------------------------------------------------------------------
=comment #TS:0:popup-menu:
=head3 popup-menu

This signal gets emitted whenever a widget should pop up a context
menu. This usually happens through the standard key binding mechanism;
by pressing a certain key while a widget is focused, the user can cause
the widget to pop up a menu.  For example, the B<Gnome::Gtk3::Entry> widget creates
a menu with clipboard commands. See the
[Popup Menu Migration Checklist][checklist-popup-menu]
for an example of how to use this signal.

Returns: C<True> if a menu was activated

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal


=comment -----------------------------------------------------------------------
=comment #TS:0:property-notify-event:
=head3 property-notify-event

The I<property-notify-event> signal will be emitted when a property on
the I<widget>'s window has been changed or deleted.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-PROPERTY-CHANGE-MASK> mask.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventProperty): the B<Gnome::Gtk3::EventProperty> which triggered
this signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:proximity-in-event:
=head3 proximity-in-event

To receive this signal the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-PROXIMITY-IN-MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    Unknown type GTK_TYPE_SELECTION_DATA | G_SIGNAL_TYPE_STATIC_SCOPE $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventProximity): the B<Gnome::Gtk3::EventProximity> which triggered
this signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:proximity-out-event:
=head3 proximity-out-event

To receive this signal the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-PROXIMITY-OUT-MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventProximity): the B<Gnome::Gtk3::EventProximity> which triggered
this signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:query-tooltip:
=head3 query-tooltip

Emitted when  I<has-tooltip> is C<True> and the hover timeout
has expired with the cursor hovering "above" I<widget>; or emitted when I<widget> got
focus in keyboard mode.

Using the given coordinates, the signal handler should determine
whether a tooltip should be shown for I<widget>. If this is the case
C<True> should be returned, C<False> otherwise.  Note that if
I<keyboard-mode> is C<True>, the values of I<x> and I<y> are undefined and
should not be used.

The signal handler is free to manipulate I<tooltip> with the therefore
destined function calls.

Returns: C<True> if I<tooltip> should be shown right now, C<False> otherwise.


  method handler (
    Unknown type GDK_TYPE_EVENT | G_SIGNAL_TYPE_STATIC_SCOPE $x,
    - $y,
    - $keyboard_mode,
    - $tooltip,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $x; the x coordinate of the cursor position where the request has
been emitted, relative to I<widget>'s left side
=item $y; the y coordinate of the cursor position where the request has
been emitted, relative to I<widget>'s top
=item $keyboard_mode; C<True> if the tooltip was triggered using the keyboard

=item $tooltip; a B<Gnome::Gtk3::Tooltip>


=comment -----------------------------------------------------------------------
=comment #TS:0:realize:
=head3 realize

The I<realize> signal is emitted when I<widget> is associated with a
B<Gnome::Gtk3::Window>, which means that C<realize()> has been called or the
widget has been mapped (that is, it is going to be drawn).

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.


=comment -----------------------------------------------------------------------
=comment #TS:0:screen-changed:
=head3 screen-changed

The I<screen-changed> signal gets emitted when the
screen of a widget has changed.

  method handler (
    - $previous_screen,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object on which the signal is emitted

=item $previous_screen; (allow-none): the previous screen, or C<undefined> if the
widget was not associated with a screen before

=comment -----------------------------------------------------------------------
=comment #TS:0:scroll-event:
=head3 scroll-event

The I<scroll-event> signal is emitted when a button in the 4 to 7
range is pressed. Wheel mice are usually configured to generate
button press events for buttons 4 and 5 when the wheel is turned.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-SCROLL-MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.

=item $event; (type Gdk.EventScroll): the B<Gnome::Gtk3::EventScroll> which triggered
this signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:selection-clear-event:
=head3 selection-clear-event

The I<selection-clear-event> signal will be emitted when the
the I<widget>'s window has lost ownership of a selection.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventSelection): the B<Gnome::Gtk3::EventSelection> which triggered
this signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:selection-get:
=head3 selection-get

  method handler (
    Unknown type GTK_TYPE_SELECTION_DATA | G_SIGNAL_TYPE_STATIC_SCOPE $data,
     $info,
    - $time,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.

=item $data;

=item $info;

=item $time;


=comment -----------------------------------------------------------------------
=comment #TS:0:selection-notify-event:
=head3 selection-notify-event

Returns: C<True> to stop other handlers from being invoked for the event. C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.

=item $event; (type Gdk.EventSelection):


=comment -----------------------------------------------------------------------
=comment #TS:0:selection-received:
=head3 selection-received

  method handler (
    Unknown type GDK_TYPE_EVENT | G_SIGNAL_TYPE_STATIC_SCOPE $data,
    - $time,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.

=item $data;

=item $time;


=comment -----------------------------------------------------------------------
=comment #TS:0:selection-request-event:
=head3 selection-request-event

The I<selection-request-event> signal will be emitted when
another client requests ownership of the selection owned by
the I<widget>'s window.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventSelection): the B<Gnome::Gtk3::EventSelection> which triggered
this signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:show:
=head3 show

The I<show> signal is emitted when I<widget> is shown, for example with
C<show()>.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.


=comment -----------------------------------------------------------------------
=comment #TS:0:show-help:
=head3 show-help

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    - $help_type,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal.

=item $help_type;


=comment -----------------------------------------------------------------------
=comment #TS:0:size-allocate:
=head3 size-allocate

  method handler (
    Unknown type GDK_TYPE_RECTANGLE | G_SIGNAL_TYPE_STATIC_SCOPE $allocation,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.

=item $allocation; (type Gtk.Allocation): the region which has been
allocated to the widget.

=comment -----------------------------------------------------------------------
=comment #TS:0:state-changed:
=head3 state-changed

The I<state-changed> signal is emitted when the widget state changes.
See C<get-state()>.

Deprecated: 3.0: Use  I<state-flags-changed> instead.

  method handler (
    Unknown type GTK_TYPE_STATE_TYPE $state,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.

=item $state; the previous state


=comment -----------------------------------------------------------------------
=comment #TS:0:state-flags-changed:
=head3 state-flags-changed

The I<state-flags-changed> signal is emitted when the widget state
changes, see C<get-state-flags()>.


  method handler (
    Unknown type GTK_TYPE_STATE_FLAGS $flags,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.

=item $flags; The previous state flags.


=comment -----------------------------------------------------------------------
=comment #TS:0:style-set:
=head3 style-set

The I<style-set> signal is emitted when a new style has been set
on a widget. Note that style-modifying functions like
C<modify-base()> also cause this signal to be emitted.

Note that this signal is emitted for changes to the deprecated
B<Gnome::Gtk3::Style>. To track changes to the B<Gnome::Gtk3::StyleContext> associated
with a widget, use the  I<style-updated> signal.

Deprecated:3.0: Use the  I<style-updated> signal

  method handler (
    Unknown type GTK_TYPE_STYLE $previous_style,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object on which the signal is emitted

=item $previous_style; (allow-none): the previous style, or C<undefined> if the widget
just got its initial style

=comment -----------------------------------------------------------------------
=comment #TS:0:style-updated:
=head3 style-updated

The I<style-updated> signal is a convenience signal that is emitted when the
 I<changed> signal is emitted on the I<widget>'s associated
B<Gnome::Gtk3::StyleContext> as returned by C<get-style-context()>.

Note that style-modifying functions like C<override-color()> also
cause this signal to be emitted.


  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object on which the signal is emitted


=comment -----------------------------------------------------------------------
=comment #TS:0:unmap:
=head3 unmap

The I<unmap> signal is emitted when I<widget> is going to be unmapped, which
means that either it or any of its parents up to the toplevel widget have
been set as hidden.

As I<unmap> indicates that a widget will not be shown any longer, it can be
used to, for example, stop an animation on the widget.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.


=comment -----------------------------------------------------------------------
=comment #TS:0:unmap-event:
=head3 unmap-event

The I<unmap-event> signal will be emitted when the I<widget>'s window is
unmapped. A window is unmapped when it becomes invisible on the screen.

To receive this signal, the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-STRUCTURE-MASK> mask. GDK will enable this mask
automatically for all new windows.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventAny): the B<Gnome::Gtk3::EventAny> which triggered this signal


=comment -----------------------------------------------------------------------
=comment #TS:0:unrealize:
=head3 unrealize

The I<unrealize> signal is emitted when the B<Gnome::Gtk3::Window> associated with
I<widget> is destroyed, which means that C<unrealize()> has been
called or the widget has been unmapped (that is, it is going to be
hidden).

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
  );

=item $widget; the object which received the signal.


=comment -----------------------------------------------------------------------
=comment #TS:0:visibility-notify-event:
=head3 visibility-notify-event

The I<visibility-notify-event> will be emitted when the I<widget>'s
window is obscured or unobscured.

To receive this signal the B<Gnome::Gtk3::Window> associated to the widget needs
to enable the B<Gnome::Gtk3::DK-VISIBILITY-NOTIFY-MASK> mask.

Returns: C<True> to stop other handlers from being invoked for the event.
C<False> to propagate the event further.

Deprecated: 3.12: Modern composited windowing systems with pervasive
transparency make it impossible to track the visibility of a window
reliably, so this signal can not be guaranteed to provide useful
information.

  method handler (
    Unknown type GDK_TYPE_DRAG_CONTEXT $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventVisibility): the B<Gnome::Gtk3::EventVisibility> which
triggered this signal.

=comment -----------------------------------------------------------------------
=comment #TS:0:window-state-event:
=head3 window-state-event

The I<window-state-event> will be emitted when the state of the
toplevel window associated to the I<widget> changes.

To receive this signal the B<Gnome::Gtk3::Window> associated to the widget
needs to enable the B<Gnome::Gtk3::DK-STRUCTURE-MASK> mask. GDK will enable
this mask automatically for all new windows.

Returns: C<True> to stop other handlers from being invoked for the
event. C<False> to propagate the event further.

  method handler (
    N-GdkEvent $event,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($widget),
    *%user-options
    --> Int
  );

=item $widget; the object which received the signal

=item $event; (type Gdk.EventWindowState): the B<Gnome::Gtk3::EventWindowState> which
triggered this signal.

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
=comment #TP:1:app-paintable:
=head3 Application paintable: app-paintable

Whether the application will paint directly on the widget
Default value: False

The B<Gnome::GObject::Value> type of property I<app-paintable> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:can-default:
=head3 Can default: can-default

Whether the widget can be the default widget
Default value: False

The B<Gnome::GObject::Value> type of property I<can-default> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:can-focus:
=head3 Can focus: can-focus

Whether the widget can accept the input focus
Default value: False

The B<Gnome::GObject::Value> type of property I<can-focus> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:composite-child:
=head3 Composite child: composite-child

Whether the widget is part of a composite widget
Default value: False

The B<Gnome::GObject::Value> type of property I<composite-child> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:events:
=head3 Events: events

The event mask that decides what kind of GdkEvents this widget gets.

The B<Gnome::GObject::Value> type of property I<events> is C<G_TYPE_FLAGS>.

=comment -----------------------------------------------------------------------
=comment #TP:1:expand:
=head3 Expand Both: expand

Whether to expand in both directions. Setting this sets both  I<hexpand> and  I<vexpand>

The B<Gnome::GObject::Value> type of property I<expand> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:1:focus-on-click:
=head3 Focus on click: focus-on-click

Whether the widget should grab focus when it is clicked with the mouse.

This property is only relevant for widgets that can take focus.

Before 3.20, several widgets (GtkButton, GtkFileChooserButton,
GtkComboBox) implemented this property individually.

The B<Gnome::GObject::Value> type of property I<focus-on-click> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:halign:
=head3 Horizontal Alignment: halign

How to distribute horizontal space if widget gets extra space, see B<Gnome::Gtk3::Align>

The B<Gnome::GObject::Value> type of property I<halign> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:0:has-default:
=head3 Has default: has-default

Whether the widget is the default widget
Default value: False

The B<Gnome::GObject::Value> type of property I<has-default> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:has-focus:
=head3 Has focus: has-focus

Whether the widget has the input focus
Default value: False

The B<Gnome::GObject::Value> type of property I<has-focus> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:has-tooltip:
=head3 Has tooltip: has-tooltip


Enables or disables the emission of  I<query-tooltip> on I<widget>.
A value of C<True> indicates that I<widget> can have a tooltip, in this case
the widget will be queried using  I<query-tooltip> to determine
whether it will provide a tooltip or not.

Note that setting this property to C<True> for the first time will change
the event masks of the GdkWindows of this widget to include leave-notify
and motion-notify events.  This cannot and will not be undone when the
property is set to C<False> again.

 *
The B<Gnome::GObject::Value> type of property I<has-tooltip> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:height-request:
=head3 Height request: height-request


The B<Gnome::GObject::Value> type of property I<height-request> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:hexpand:
=head3 Horizontal Expand: hexpand


Whether to expand horizontally. See C<set-hexpand()>.

   *
The B<Gnome::GObject::Value> type of property I<hexpand> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:hexpand-set:
=head3 Horizontal Expand Set: hexpand-set


Whether to use the  I<hexpand> property. See C<get-hexpand-set()>.

   *
The B<Gnome::GObject::Value> type of property I<hexpand-set> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:is-focus:
=head3 Is focus: is-focus

Whether the widget is the focus widget within the toplevel
Default value: False

The B<Gnome::GObject::Value> type of property I<is-focus> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:margin:
=head3 All Margins: margin


Sets all four sides' margin at once. If read, returns max
margin on any side.

   *
The B<Gnome::GObject::Value> type of property I<margin> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:margin-bottom:
=head3 Margin on Bottom: margin-bottom


Margin on bottom side of widget.

This property adds margin outside of the widget's normal size
request, the margin will be added in addition to the size from
C<set-size-request()> for example.

   *
The B<Gnome::GObject::Value> type of property I<margin-bottom> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:margin-end:
=head3 Margin on End: margin-end


Margin on end of widget, horizontally. This property supports
left-to-right and right-to-left text directions.

This property adds margin outside of the widget's normal size
request, the margin will be added in addition to the size from
C<set-size-request()> for example.

   *
The B<Gnome::GObject::Value> type of property I<margin-end> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:margin-start:
=head3 Margin on Start: margin-start


Margin on start of widget, horizontally. This property supports
left-to-right and right-to-left text directions.

This property adds margin outside of the widget's normal size
request, the margin will be added in addition to the size from
C<set-size-request()> for example.

   *
The B<Gnome::GObject::Value> type of property I<margin-start> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:margin-top:
=head3 Margin on Top: margin-top


Margin on top side of widget.

This property adds margin outside of the widget's normal size
request, the margin will be added in addition to the size from
C<set-size-request()> for example.

   *
The B<Gnome::GObject::Value> type of property I<margin-top> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:name:
=head3 Widget name: name

The name of the widget
Default value: Any

The B<Gnome::GObject::Value> type of property I<name> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:no-show-all:
=head3 No show all: no-show-all

Whether show-all( should not affect this widget)
Default value: False

The B<Gnome::GObject::Value> type of property I<no-show-all> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:opacity:
=head3 Opacity for Widget: opacity


The requested opacity of the widget. See C<set-opacity()> for
more details about window opacity.

Before 3.8 this was only available in GtkWindow

   *
The B<Gnome::GObject::Value> type of property I<opacity> is C<G_TYPE_DOUBLE>.

=comment -----------------------------------------------------------------------
=comment #TP:0:parent:
=head3 Parent widget: parent

The parent widget of this widget. Must be a Container widget
Widget type: GTK-TYPE-CONTAINER

The B<Gnome::GObject::Value> type of property I<parent> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:receives-default:
=head3 Receives default: receives-default

If TRUE, the widget will receive the default action when it is focused
Default value: False

The B<Gnome::GObject::Value> type of property I<receives-default> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:scale-factor:
=head3 Scale factor: scale-factor


The scale factor of the widget. See C<get-scale-factor()> for
more details about widget scaling.

   *
The B<Gnome::GObject::Value> type of property I<scale-factor> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:sensitive:
=head3 Sensitive: sensitive

Whether the widget responds to input
Default value: True

The B<Gnome::GObject::Value> type of property I<sensitive> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:tooltip-markup:
=head3 Tooltip markup: tooltip-markup


Sets the text of tooltip to be the given string, which is marked up
with the [Pango text markup language][PangoMarkupFormat].
Also see C<gtk-tooltip-set-markup()>.

This is a convenience property which will take care of getting the
tooltip shown if the given string is not C<undefined>:  I<has-tooltip>
will automatically be set to C<True> and there will be taken care of
 I<query-tooltip> in the default signal handler.

Note that if both  I<tooltip-text> and  I<tooltip-markup>
are set, the last one wins.

   *
The B<Gnome::GObject::Value> type of property I<tooltip-markup> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:tooltip-text:
=head3 Tooltip Text: tooltip-text


Sets the text of tooltip to be the given string.

Also see C<gtk-tooltip-set-text()>.

This is a convenience property which will take care of getting the
tooltip shown if the given string is not C<undefined>:  I<has-tooltip>
will automatically be set to C<True> and there will be taken care of
 I<query-tooltip> in the default signal handler.

Note that if both  I<tooltip-text> and  I<tooltip-markup>
are set, the last one wins.

   *
The B<Gnome::GObject::Value> type of property I<tooltip-text> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:valign:
=head3 Vertical Alignment: valign


How to distribute vertical space if widget gets extra space, see B<Gnome::Gtk3::Align>

   * Widget type: GTK_TYPE_ALIGN

The B<Gnome::GObject::Value> type of property I<valign> is C<G_TYPE_ENUM>.

=comment -----------------------------------------------------------------------
=comment #TP:0:vexpand:
=head3 Vertical Expand: vexpand


Whether to expand vertically. See C<set-vexpand()>.

   *
The B<Gnome::GObject::Value> type of property I<vexpand> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:vexpand-set:
=head3 Vertical Expand Set: vexpand-set


Whether to use the  I<vexpand> property. See C<get-vexpand-set()>.

   *
The B<Gnome::GObject::Value> type of property I<vexpand-set> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:visible:
=head3 Visible: visible

Whether the widget is visible
Default value: False

The B<Gnome::GObject::Value> type of property I<visible> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:width-request:
=head3 Width request: width-request


The B<Gnome::GObject::Value> type of property I<width-request> is C<G_TYPE_INT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:window:
=head3 Window: window


The widget's window if it is realized, C<undefined> otherwise.

   * Widget type: GDK_TYPE_WINDOW

The B<Gnome::GObject::Value> type of property I<window> is C<G_TYPE_OBJECT>.
=end pod
