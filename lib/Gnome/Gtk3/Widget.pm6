use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::Widget

=SUBTITLE Base class for all widgets

=head1 Description


C<Gnome::Gtk3::Widget> is the base class all widgets in this package derive from. It manages the widget lifecycle, states and style.

=head2 Height-for-width Geometry Management

GTK+ uses a height-for-width (and width-for-height) geometry management
system. Height-for-width means that a widget can change how much
vertical space it needs, depending on the amount of horizontal space
that it is given (and similar for width-for-height). The most common
example is a label that reflows to fill up the available width, wraps
to fewer lines, and therefore needs less height.

Height-for-width geometry management is implemented in GTK+ by way
of five virtual methods:

=item C<get_request_mode()>
=item C<get_preferred_width()>
=item C<get_preferred_height()>
=item C<get_preferred_height_for_width()>
=item C<get_preferred_width_for_height()>
=item C<get_preferred_height_and_baseline_for_width()>

There are some important things to keep in mind when implementing
height-for-width and when using it in container implementations.

The geometry management system will query a widget hierarchy in
only one orientation at a time. When widgets are initially queried
for their minimum sizes it is generally done in two initial passes
in the C<GtkSizeRequestMode> chosen by the toplevel.

For example, when queried in the normal
C<GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH> mode:
First, the default minimum and natural width for each widget
in the interface will be computed using C<gtk_widget_get_preferred_width()>.
Because the preferred widths for each container depend on the preferred
widths of their children, this information propagates up the hierarchy,
and finally a minimum and natural width is determined for the entire
toplevel. Next, the toplevel will use the minimum width to query for the
minimum height contextual to that width using
C<gtk_widget_get_preferred_height_for_width()>, which will also be a highly
recursive operation. The minimum height for the minimum width is normally
used to set the minimum size constraint on the toplevel
(unless C<gtk_window_set_geometry_hints()> is explicitly used instead).

After the toplevel window has initially requested its size in both
dimensions it can go on to allocate itself a reasonable size (or a size
previously specified with C<gtk_window_set_default_size()>). During the
recursive allocation process it’s important to note that request cycles
will be recursively executed while container widgets allocate their children.
Each container widget, once allocated a size, will go on to first share the
space in one orientation among its children and then request each child's
height for its target allocated width or its width for allocated height,
depending. In this way a C<Gnome::Gtk3::Widget> will typically be requested its size
a number of times before actually being allocated a size. The size a
widget is finally allocated can of course differ from the size it has
requested. For this reason, C<Gnome::Gtk3::Widget> caches a  small number of results
to avoid re-querying for the same sizes in one allocation cycle.

See
[C<Gnome::Gtk3::Container>’s geometry management section](https://developer.gnome.org/gtk3/stable/GtkContainer.html)
to learn more about how height-for-width allocations are performed
by container widgets.

If a widget does move content around to intelligently use up the
allocated size then it must support the request in both
C<GtkSizeRequestMode>s even if the widget in question only
trades sizes in a single orientation.

For instance, a C<Gnome::Gtk3::Label> that does height-for-width word wrapping
will not expect to have C<get_preferred_height()> called
because that call is specific to a width-for-height request. In this
case the label must return the height required for its own minimum
possible width. By following this rule any widget that handles
height-for-width or width-for-height requests will always be allocated
at least enough space to fit its own content.

Here are some examples of how a C<GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH> widget
generally deals with width-for-height requests, for C<get_preferred_height()>
it will do (A piece of C-code directly from the docs):

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

Often a widget needs to get its own request during size request or
allocation. For example, when computing height it may need to also
compute width. Or when deciding how to use an allocation, the widget
may need to know its natural size. In these cases, the widget should
be careful to call its virtual methods directly, like this:

  GTK_WIDGET_GET_CLASS(widget)->get_preferred_width(
    widget, &min, &natural
  );

It will not work to use the wrapper functions, such as
C<gtk_widget_get_preferred_width()> inside your own size request
implementation. These return a request adjusted by C<Gnome::Gtk3::SizeGroup>
and by the C<adjust_size_request()> virtual method. If a
widget used the wrappers inside its virtual method implementations,
then the adjustments (such as widget margins) would be applied
twice. GTK+ therefore does not allow this and will warn if you try
to do it.

Of course if you are getting the size request for
another widget, such as a child of a
container, you must use the wrapper APIs.
Otherwise, you would not properly consider widget margins,
C<Gnome::Gtk3::SizeGroup>, and so forth.

Since 3.10 GTK+ also supports baseline vertical alignment of widgets. This
means that widgets are positioned such that the typographical baseline of
widgets in the same row are aligned. This happens if a widget supports baselines,
has a vertical alignment of C<GTK_ALIGN_BASELINE>, and is inside a container
that supports baselines and has a natural “row” that it aligns to the baseline,
or a baseline assigned to it by the grandparent.

Baseline alignment support for a widget is done by the C<get_preferred_height_and_baseline_for_width()> virtual function. It allows you to report a baseline in combination with the minimum and natural height. If there is no baseline you can return -1 to indicate this. The default implementation of this virtual function calls into the C<get_preferred_height()> and C<get_preferred_height_for_width()>, so if baselines are not supported it doesn’t need to be implemented.

If a widget ends up baseline aligned it will be allocated all the space in the parent as if it was C<GTK_ALIGN_FILL>, but the selected baseline can be found via C<gtk_widget_get_allocated_baseline()>. If this has a value other than -1 you need to align the widget such that the baseline appears at the position.

=head2 Style Properties

C<Gnome::Gtk3::Widget> introduces “style properties” - these are basically object properties that are stored not on the object, but in the style object associated to the widget. Style properties are set in gtk resource files. This mechanism is used for configuring such things as the location of the scrollbar arrows through the theme, giving theme authors more control over the look of applications without the need to write a theme engine in C.

Use C<gtk_widget_class_install_style_property()> to install style properties for
a widget class, C<gtk_widget_class_find_style_property()> or C<gtk_widget_class_list_style_properties()> to get information about existing style properties and C<gtk_widget_style_get_property()>, C<gtk_widget_style_get()> or C<gtk_widget_style_get_valist()> to obtain the value of a style property.

=head2 Gnome::Gtk3::Widget as Gnome::Gtk3::Buildable

The C<Gnome::Gtk3::Widget> implementation of the C<Gnome::Gtk3::Buildable> interface supports a custom <accelerator> element, which has attributes named ”key”, ”modifiers” and ”signal” and allows to specify accelerators.

An example of a UI definition fragment specifying an accelerator (please note that in this XML the C-Source widget class names must be used; GtkButton instead of Gnome::Gtk3::Button):

  <object class="GtkButton">
    <accelerator key="q" modifiers="GDK_CONTROL_MASK" signal="clicked"/>
  </object>

In addition to accelerators, C<Gnome::Gtk3::Widget> also support a custom <accessible> element, which supports actions and relations. Properties on the accessible implementation of an object can be set by accessing the internal child “accessible” of a C<Gnome::Gtk3::Widget>.

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

Finally, C<Gnome::Gtk3::Widget> allows style information such as style classes to be associated with widgets, using the custom <style> element:

  <object class="GtkButton>" id="button1">
    <style>
      <class name="my-special-button-class"/>
      <class name="dark-button"/>
    </style>
  </object>

=begin comment
=head2 Building composite widgets from template XML

C<Gnome::Gtk3::Widget> exposes some facilities to automate the procedure of creating composite widgets using C<Gnome::Gtk3::Builder> interface description language.

To create composite widgets with C<Gnome::Gtk3::Builder> XML, one must associate
the interface description with the widget class at class initialization
time using C<gtk_widget_class_set_template()>.

The interface description semantics expected in composite template descriptions
is slightly different from regular C<Gnome::Gtk3::Builder> XML.

Unlike regular interface descriptions, C<gtk_widget_class_set_template()> will expect a <template> tag as a direct child of the toplevel <interface> tag. The <template> tag must specify the “class” attribute which must be the type name of the widget. Optionally, the “parent” attribute may be specified to specify the direct parent type of the widget type, this is ignored by the C<Gnome::Gtk3::Builder> but required for Glade to introspect what kind of properties and internal children exist for a given type when the actual type does not exist.

The XML which is contained inside the <template> tag behaves as if it were added to the <object> tag defining I<widget> itself. You may set properties on I<widget> by inserting <property> tags into the <template> tag, and also add <child> tags to add children and extend I<widget> in the normal way you would with <object> tags.

Additionally, <object> tags can also be added before and after the initial <template> tag in the normal way, allowing one to define auxiliary objects which might be referenced by other widgets declared as children of the <template> tag.

An example of a C<Gnome::Gtk3::Builder> Template Definition:

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

Typically, you'll place the template fragment into a file that is bundled with your project, using C<GResource>. In order to load the template, you need to call C<gtk_widget_class_set_template_from_resource()> from the class initialization of your C<Gnome::Gtk3::Widget> type:

=comment TODO replace with perl6 code

  static void foo_widget_class_init (FooWidgetClass *klass) {
    // ...

    gtk_widget_class_set_template_from_resource (
      GTK_WIDGET_CLASS (klass), "/com/example/ui/foowidget.ui"
    );
  }

You will also need to call C<gtk_widget_init_template()> from the instance
initialization function:

=comment TODO replace with perl6 code

  static void foo_widget_init (FooWidget *self) {
    // ...
    gtk_widget_init_template (GTK_WIDGET (self));
  }

You can access widgets defined in the template using the C<gtk_widget_get_template_child()> function, but you will typically declare a pointer in the instance private data structure of your type using the same name as the widget in the template definition, and call C<gtk_widget_class_bind_template_child_private()> with that name, e.g.

  typedef struct {
    C<Gnome::Gtk3::Widget> *hello_button;
    C<Gnome::Gtk3::Widget> *goodbye_button;
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

=end comment

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Widget;
  also is Gnome::GObject::InitiallyUnowned;


=head2 Example

  # create a button and set a tooltip
  my Gnome::Gtk3::Button $start-button .= new(:label<Start>);
  $start-button.set-tooltip-text('Nooooo don\'t touch that button!!!!!!!');

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::InitiallyUnowned;
use Gnome::Gdk3::Types;
use Gnome::Gdk3::Events;
use Gnome::Gtk3::Enums;

subset GtkAllocation of GdkRectangle;
#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/gtkwidget.h
# https://developer.gnome.org/gtk3/stable/GtkWidget.html
unit class Gnome::Gtk3::Widget:auth<github:MARTIMM>;
also is Gnome::GObject::InitiallyUnowned;

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

enum GtkWidgetHelpType is export (
  'GTK_WIDGET_HELP_TOOLTIP',
  'GTK_WIDGET_HELP_WHATS_THIS'
);

#-------------------------------------------------------------------------------
=begin pod
=head2 class GtkRequisition

A C<Gnome::Gtk3::Requisition>-struct represents the desired size of a widget. See
[C<Gnome::Gtk3::Widget>’s geometry management section][geometry-management] for
more information.


=item Int $.width: the widget’s desired width
=item Int $.height: the widget’s desired height

=end pod

class GtkRequisition is export is repr('CStruct') {
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

Since: 3.8


=item ___widget: the widget
=item ___frame_clock: the frame clock for the widget (same as calling C<gtk_widget_get_frame_clock()>)
=item ___user_data: user data passed to C<gtk_widget_add_tick_callback()>.


=end pod

class GtkTickCallback is export is repr('CStruct') {
  has GInitiallyUnowned $.parent_instance;
  has GtkWidgetPrivate $.priv;
}

=end pod
}}

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod
#=head2 new

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<accel-closures-changed destroy grab-focus hide map popup-menu
            realize show style-updated unmap unrealize
           >,
    :event<button-press-event button-release-event configure-event
           damage-event delete-event destroy-event enter-notify-event
           event-after focus-in-event grab-broken-event key-press-event
           key-release-event leave-notify-event map-event motion-notify-event
           property-notify-event proximity-in-event proximity-out-event
           scroll-event selection-clear-event selection-notify-event
           selection-request-event touch-event unmap-event window-state-event
          >,
    :deprecated<composited-changed state-changed style-set
                visibility-notify-event
               >,
    :nativewidget<drag-begin drag-data-delete drag-end hierarchy-changed
                  parent-set screen-changed size-allocate
                 >,
    :uint<can-activate-accel>,
    :GParamSpec<child-notify>,
    :enum<direction-changed focus keynav-failed move-focus show-help
          state-flags-changed
         >,
    :dragdatauint2<drag-data-get>,
    :dragint2datauint2<drag-data-received>,
    :dragint2uint<drag-drop drag-motion>,
    :drag2<drag-failed>,
    :draguint<drag-leave>,
    :notsupported<draw>,
    :bool<grab-notify mnemonic-activate>,
    :int2boolnw<query-tooltip>,
    :seluint2<selection-get>,
    :seluint<selection-received>,
  ) unless $signals-added;

  # prevent creating wrong widgets
#  return unless self.^name eq 'Gnome::Gtk3::Widget';

  # only after creating the widget, the gtype is known
#  self.set-class-info('GtkWidget');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_widget_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  self.set-class-name-of-sub('GtkWidget');
  $s = callsame unless ?$s;

  $s;
}

#`{{
#TODO No widget new creation because of unknown id. Can be retrieved but
# is a bit complex
#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_new

This is a convenience function for creating a widget and setting
its properties in one go. For example you might write:
`gtk_widget_new (GTK_TYPE_LABEL, "label", "Hello World", "xalign",
0.0, NULL)` to create a left-aligned label. Equivalent to
C<g_object_new()>, but returns a widget so you don’t have to
cast the object yourself.

Returns: a new native C<GtkWidget> of type I<widget_type>

  method gtk_widget_new ( N-GObject $type, Str $first_property_name --> N-GObject  )

=item N-GObject $type; type ID of the widget to create
=item Str $first_property_name; name of first property to set @...: value of first property, followed by more properties, C<Any>-terminated

=end pod

sub gtk_widget_new ( N-GObject $type, Str $first_property_name, Any $any = Any )
  returns N-GObject
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_destroy

Destroys a widget.

When a widget is destroyed all references it holds on other objects
will be released:

- if the widget is inside a container, it will be removed from its
parent
- if the widget is a container, all its children will be destroyed,
recursively
- if the widget is a top level, it will be removed from the list
of top level widgets that GTK+ maintains internally

It's expected that all references held on the widget will also
be released; you should connect to the sig C<destroy> signal
if you hold a reference to I<widget> and you wish to remove it when
this function is called. It is not necessary to do so if you are
implementing a C<Gnome::Gtk3::Container>, as you'll be able to use the
C<Gnome::Gtk3::ContainerClass>.C<remove()> virtual function for that.

It's important to notice that C<gtk_widget_destroy()> will only cause
the I<widget> to be finalized if no additional references, acquired
using C<g_object_ref()>, are held on it. In case additional references
are in place, the I<widget> will be in an "inert" state after calling
this function; I<widget> will still point to valid memory, allowing you
to release the references you hold, but you may not query the widget's
own state.

You should typically call this function on top level widgets, and
rarely on child widgets.

See also: C<gtk_container_remove()>

  method gtk_widget_destroy ( )


=end pod

sub gtk_widget_destroy ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_destroyed

This function sets *I<widget_pointer> to C<Any> if I<widget_pointer> !=
C<Any>.  It’s intended to be used as a callback connected to the
“destroy” signal of a widget. You connect C<gtk_widget_destroyed()>
as a signal handler, and pass the address of your widget variable
as user data. Then when the widget is destroyed, the variable will
be set to C<Any>. Useful for example to avoid multiple copies
of the same dialog.

  method gtk_widget_destroyed ( N-GObject $widget_pointer )

=item N-GObject $widget_pointer; (inout) (transfer none): address of a variable that contains I<widget>

=end pod

sub gtk_widget_destroyed ( N-GObject $widget, N-GObject $widget_pointer )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_unparent

This function is only for use in widget implementations.
Should be called by implementations of the remove method
on C<Gnome::Gtk3::Container>, to dissociate a child from the container.

  method gtk_widget_unparent ( )


=end pod

sub gtk_widget_unparent ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_show

Flags a widget to be displayed. Any widget that isn’t shown will
not appear on the screen. If you want to show all the widgets in a
container, it’s easier to call C<gtk_widget_show_all()> on the
container, instead of individually showing the widgets.

Remember that you have to show the containers containing a widget,
in addition to the widget itself, before it will appear onscreen.

When a toplevel container is shown, it is immediately realized and
mapped; other shown widgets are realized and mapped when their
toplevel container is realized and mapped.

  method gtk_widget_show ( )


=end pod

sub gtk_widget_show ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_hide

Reverses the effects of C<gtk_widget_show()>, causing the widget to be
hidden (invisible to the user).

  method gtk_widget_hide ( )


=end pod

sub gtk_widget_hide ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] show_now

Shows a widget. If the widget is an unmapped toplevel widget
(i.e. a C<Gnome::Gtk3::Window> that has not yet been shown), enter the main
loop and wait for the window to actually be mapped. Be careful;
because the main loop is running, anything can happen during
this function.

  method gtk_widget_show_now ( )


=end pod

sub gtk_widget_show_now ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] show_all

Recursively shows a widget, and any child widgets (if the widget is
a container).

  method gtk_widget_show_all ( )


=end pod

sub gtk_widget_show_all ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_no_show_all

Sets the prop C<no-show-all> property, which determines whether
calls to C<gtk_widget_show_all()> will affect this widget.

This is mostly for use in constructing widget hierarchies with externally
controlled visibility, see C<Gnome::Gtk3::UIManager>.

Since: 2.4

  method gtk_widget_set_no_show_all ( Int $no_show_all )

=item Int $no_show_all; the new value for the “no-show-all” property

=end pod

sub gtk_widget_set_no_show_all ( N-GObject $widget, int32 $no_show_all )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_no_show_all

Returns the current value of the prop C<no-show-all> property,
which determines whether calls to C<gtk_widget_show_all()>
will affect this widget.

Returns: the current value of the “no-show-all” property.

Since: 2.4

  method gtk_widget_get_no_show_all ( --> Int  )


=end pod

sub gtk_widget_get_no_show_all ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_map

This function is only for use in widget implementations. Causes
a widget to be mapped if it isn’t already.

  method gtk_widget_map ( )


=end pod

sub gtk_widget_map ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_unmap

This function is only for use in widget implementations. Causes
a widget to be unmapped if it’s currently mapped.

  method gtk_widget_unmap ( )


=end pod

sub gtk_widget_unmap ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_realize

Creates the GDK (windowing system) resources associated with a
widget.  For example, I<widget>->window will be created when a widget
is realized.  Normally realization happens implicitly; if you show
a widget and all its parent containers, then the widget will be
realized and mapped automatically.

Realizing a widget requires all
the widget’s parent widgets to be realized; calling
C<gtk_widget_realize()> realizes the widget’s parents in addition to
I<widget> itself. If a widget is not yet inside a toplevel window
when you realize it, bad things will happen.

This function is primarily used in widget implementations, and
isn’t very useful otherwise. Many times when you think you might
need it, a better approach is to connect to a signal that will be
called after the widget is realized automatically, such as
sig C<draw>. Or simply C<g_signal_connect()> to the
sig C<realize> signal.

  method gtk_widget_realize ( )


=end pod

sub gtk_widget_realize ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_unrealize

This function is only useful in widget implementations.
Causes a widget to be unrealized (frees all GDK resources
associated with the widget, such as I<widget>->window).

  method gtk_widget_unrealize ( )


=end pod

sub gtk_widget_unrealize ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_draw

Draws I<widget> to I<cr>. The top left corner of the widget will be
drawn to the currently set origin point of I<cr>.

You should pass a cairo context as I<cr> argument that is in an
original state. Otherwise the resulting drawing is undefined. For
example changing the operator using C<cairo_set_operator()> or the
line width using C<cairo_set_line_width()> might have unwanted side
effects.
You may however change the context’s transform matrix - like with
C<cairo_scale()>, C<cairo_translate()> or C<cairo_set_matrix()> and clip
region with C<cairo_clip()> prior to calling this function. Also, it
is fine to modify the context with C<cairo_save()> and
C<cairo_push_group()> prior to calling this function.

Note that special-purpose widgets may contain special code for
rendering to the screen and might appear differently on screen
and when rendered using C<gtk_widget_draw()>.

Since: 3.0

  method gtk_widget_draw ( cairo_t $cr )

=item cairo_t $cr; a cairo context to draw to

=end pod

sub gtk_widget_draw ( N-GObject $widget, cairo_t $cr )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] queue_draw

Equivalent to calling C<gtk_widget_queue_draw_area()> for the
entire area of a widget.

  method gtk_widget_queue_draw ( )


=end pod

sub gtk_widget_queue_draw ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] queue_draw_area

Convenience function that calls C<gtk_widget_queue_draw_region()> on
the region created from the given coordinates.

The region here is specified in widget coordinates.
Widget coordinates are a bit odd; for historical reasons, they are
defined as I<widget>->window coordinates for widgets that return C<1> for
C<gtk_widget_get_has_window()>, and are relative to I<widget>->allocation.x,
I<widget>->allocation.y otherwise.

I<width> or I<height> may be 0, in this case this function does
nothing. Negative values for I<width> and I<height> are not allowed.

  method gtk_widget_queue_draw_area ( Int $x, Int $y, Int $width, Int $height )

=item Int $x; x coordinate of upper-left corner of rectangle to redraw
=item Int $y; y coordinate of upper-left corner of rectangle to redraw
=item Int $width; width of region to draw
=item Int $height; height of region to draw

=end pod

sub gtk_widget_queue_draw_area ( N-GObject $widget, int32 $x, int32 $y, int32 $width, int32 $height )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] queue_draw_region

Invalidates the area of I<widget> defined by I<region> by calling
C<gdk_window_invalidate_region()> on the widget’s window and all its
child windows. Once the main loop becomes idle (after the current
batch of events has been processed, roughly), the window will
receive expose events for the union of all regions that have been
invalidated.

Normally you would only use this function in widget
implementations. You might also use it to schedule a redraw of a
C<Gnome::Gtk3::DrawingArea> or some portion thereof.

Since: 3.0

  method gtk_widget_queue_draw_region ( cairo_region_t $region )

=item cairo_region_t $region; region to draw

=end pod

sub gtk_widget_queue_draw_region ( N-GObject $widget, cairo_region_t $region )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] queue_resize

This function is only for use in widget implementations.
Flags a widget to have its size renegotiated; should
be called when a widget for some reason has a new size request.
For example, when you change the text in a C<Gnome::Gtk3::Label>, C<Gnome::Gtk3::Label>
queues a resize to ensure there’s enough space for the new text.

Note that you cannot call C<gtk_widget_queue_resize()> on a widget
from inside its implementation of the C<Gnome::Gtk3::WidgetClass>::size_allocate
virtual method. Calls to C<gtk_widget_queue_resize()> from inside
C<Gnome::Gtk3::WidgetClass>::size_allocate will be silently ignored.

  method gtk_widget_queue_resize ( )


=end pod

sub gtk_widget_queue_resize ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] queue_resize_no_redraw

This function works like C<gtk_widget_queue_resize()>,
except that the widget is not invalidated.

Since: 2.4

  method gtk_widget_queue_resize_no_redraw ( )


=end pod

sub gtk_widget_queue_resize_no_redraw ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] queue_allocate

This function is only for use in widget implementations.

Flags the widget for a rerun of the C<Gnome::Gtk3::WidgetClass>::size_allocate
function. Use this function instead of C<gtk_widget_queue_resize()>
when the I<widget>'s size request didn't change but it wants to
reposition its contents.

An example user of this function is C<gtk_widget_set_halign()>.

Since: 3.20

  method gtk_widget_queue_allocate ( )


=end pod

sub gtk_widget_queue_allocate ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_frame_clock

Obtains the frame clock for a widget. The frame clock is a global
“ticker” that can be used to drive animations and repaints.  The
most common reason to get the frame clock is to call
C<gdk_frame_clock_get_frame_time()>, in order to get a time to use for
animating. For example you might record the start of the animation
with an initial value from C<gdk_frame_clock_get_frame_time()>, and
then update the animation by calling
C<gdk_frame_clock_get_frame_time()> again during each repaint.

C<gdk_frame_clock_request_phase()> will result in a new frame on the
clock, but won’t necessarily repaint any widgets. To repaint a
widget, you have to use C<gtk_widget_queue_draw()> which invalidates
the widget (thus scheduling it to receive a draw on the next
frame). C<gtk_widget_queue_draw()> will also end up requesting a frame
on the appropriate frame clock.

A widget’s frame clock will not change while the widget is
mapped. Reparenting a widget (which implies a temporary unmap) can
change the widget’s frame clock.

Unrealized widgets do not have a frame clock.

Returns: (nullable) (transfer none): a C<Gnome::Gdk3::FrameClock>,
or C<NULL> if widget is unrealized

Since: 3.8

  method gtk_widget_get_frame_clock ( --> N-GObject  )


=end pod

sub gtk_widget_get_frame_clock ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] size_allocate



  method gtk_widget_size_allocate ( GtkAllocation $allocation )

=item GtkAllocation $allocation;

=end pod

sub gtk_widget_size_allocate ( N-GObject $widget, GtkAllocation $allocation )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] size_allocate_with_baseline

This function is only used by C<Gnome::Gtk3::Container> subclasses, to assign a size,
position and (optionally) baseline to their child widgets.

In this function, the allocation and baseline may be adjusted. It
will be forced to a 1x1 minimum size, and the
adjust_size_allocation virtual and adjust_baseline_allocation
methods on the child will be used to adjust the allocation and
baseline. Standard adjustments include removing the widget's
margins, and applying the widget’s prop C<halign> and
prop C<valign> properties.

If the child widget does not have a valign of C<GTK_ALIGN_BASELINE> the
baseline argument is ignored and -1 is used instead.

Since: 3.10

  method gtk_widget_size_allocate_with_baseline ( GtkAllocation $allocation, Int $baseline )

=item GtkAllocation $allocation; position and size to be allocated to I<widget>
=item Int $baseline; The baseline of the child, or -1

=end pod

sub gtk_widget_size_allocate_with_baseline ( N-GObject $widget, GtkAllocation $allocation, int32 $baseline )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_request_mode



  method gtk_widget_get_request_mode ( --> GtkSizeRequestMode  )


=end pod

sub gtk_widget_get_request_mode ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_preferred_width



  method gtk_widget_get_preferred_width ( Int $minimum_width, Int $natural_width )

=item Int $minimum_width;
=item Int $natural_width;

=end pod

sub gtk_widget_get_preferred_width ( N-GObject $widget, int32 $minimum_width, int32 $natural_width )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_preferred_height_for_width



  method gtk_widget_get_preferred_height_for_width ( Int $width, Int $minimum_height, Int $natural_height )

=item Int $width;
=item Int $minimum_height;
=item Int $natural_height;

=end pod

sub gtk_widget_get_preferred_height_for_width ( N-GObject $widget, int32 $width, int32 $minimum_height, int32 $natural_height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_preferred_height



  method gtk_widget_get_preferred_height ( Int $minimum_height, Int $natural_height )

=item Int $minimum_height;
=item Int $natural_height;

=end pod

sub gtk_widget_get_preferred_height ( N-GObject $widget, int32 $minimum_height, int32 $natural_height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_preferred_width_for_height



  method gtk_widget_get_preferred_width_for_height ( Int $height, Int $minimum_width, Int $natural_width )

=item Int $height;
=item Int $minimum_width;
=item Int $natural_width;

=end pod

sub gtk_widget_get_preferred_width_for_height ( N-GObject $widget, int32 $height, int32 $minimum_width, int32 $natural_width )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_preferred_height_and_baseline_for_width



  method gtk_widget_get_preferred_height_and_baseline_for_width ( Int $width, Int $minimum_height, Int $natural_height, Int $minimum_baseline, Int $natural_baseline )

=item Int $width;
=item Int $minimum_height;
=item Int $natural_height;
=item Int $minimum_baseline;
=item Int $natural_baseline;

=end pod

sub gtk_widget_get_preferred_height_and_baseline_for_width ( N-GObject $widget, int32 $width, int32 $minimum_height, int32 $natural_height, int32 $minimum_baseline, int32 $natural_baseline )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_preferred_size



  method gtk_widget_get_preferred_size ( GtkRequisition $minimum_size, GtkRequisition $natural_size )

=item GtkRequisition $minimum_size;
=item GtkRequisition $natural_size;

=end pod

sub gtk_widget_get_preferred_size ( N-GObject $widget, GtkRequisition $minimum_size, GtkRequisition $natural_size )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] add_accelerator

Installs an accelerator for this I<widget> in I<accel_group> that causes
I<accel_signal> to be emitted if the accelerator is activated.
The I<accel_group> needs to be added to the widget’s toplevel via
C<gtk_window_add_accel_group()>, and the signal must be of type C<G_SIGNAL_ACTION>.
Accelerators added through this function are not user changeable during
runtime. If you want to support accelerators that can be changed by the
user, use C<gtk_accel_map_add_entry()> and C<gtk_widget_set_accel_path()> or
C<gtk_menu_item_set_accel_path()> instead.

  method gtk_widget_add_accelerator ( Str $accel_signal, N-GObject $accel_group, UInt $accel_key, GdkModifierType $accel_mods, GtkAccelFlags $accel_flags )

=item Str $accel_signal; widget signal to emit on accelerator activation
=item N-GObject $accel_group; accel group for this widget, added to its toplevel
=item UInt $accel_key; GDK keyval of the accelerator
=item GdkModifierType $accel_mods; modifier key combination of the accelerator
=item GtkAccelFlags $accel_flags; flag accelerators, e.g. C<GTK_ACCEL_VISIBLE>

=end pod

sub gtk_widget_add_accelerator ( N-GObject $widget, Str $accel_signal, N-GObject $accel_group, uint32 $accel_key, int32 $accel_mods, GtkAccelFlags $accel_flags )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] remove_accelerator

Removes an accelerator from I<widget>, previously installed with
C<gtk_widget_add_accelerator()>.

Returns: whether an accelerator was installed and could be removed

  method gtk_widget_remove_accelerator ( N-GObject $accel_group, UInt $accel_key, GdkModifierType $accel_mods --> Int  )

=item N-GObject $accel_group; accel group for this widget
=item UInt $accel_key; GDK keyval of the accelerator
=item GdkModifierType $accel_mods; modifier key combination of the accelerator

=end pod

sub gtk_widget_remove_accelerator ( N-GObject $widget, N-GObject $accel_group, uint32 $accel_key, int32 $accel_mods )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_accel_path

Given an accelerator group, I<accel_group>, and an accelerator path,
I<accel_path>, sets up an accelerator in I<accel_group> so whenever the
key binding that is defined for I<accel_path> is pressed, I<widget>
will be activated.  This removes any accelerators (for any
accelerator group) installed by previous calls to
C<gtk_widget_set_accel_path()>. Associating accelerators with
paths allows them to be modified by the user and the modifications
to be saved for future use. (See C<gtk_accel_map_save()>.)

This function is a low level function that would most likely
be used by a menu creation system like C<Gnome::Gtk3::UIManager>. If you
use C<Gnome::Gtk3::UIManager>, setting up accelerator paths will be done
automatically.

Even when you you aren’t using C<Gnome::Gtk3::UIManager>, if you only want to
set up accelerators on menu items C<gtk_menu_item_set_accel_path()>
provides a somewhat more convenient interface.

Note that I<accel_path> string will be stored in a C<GQuark>. Therefore, if you
pass a static string, you can save some memory by interning it first with
C<g_intern_static_string()>.

  method gtk_widget_set_accel_path ( Str $accel_path, N-GObject $accel_group )

=item Str $accel_path; (allow-none): path used to look up the accelerator
=item N-GObject $accel_group; (allow-none): a C<Gnome::Gtk3::AccelGroup>.

=end pod

sub gtk_widget_set_accel_path ( N-GObject $widget, Str $accel_path, N-GObject $accel_group )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] list_accel_closures

Lists the closures used by I<widget> for accelerator group connections
with C<gtk_accel_group_connect_by_path()> or C<gtk_accel_group_connect()>.
The closures can be used to monitor accelerator changes on I<widget>,
by connecting to the I<C><Gnome::Gtk3::AccelGroup>::accel-changed signal of the
C<Gnome::Gtk3::AccelGroup> of a closure which can be found out with
C<gtk_accel_group_from_accel_closure()>.

Returns: (transfer container) (element-type GClosure):
a newly allocated C<GList> of closures

  method gtk_widget_list_accel_closures ( --> N-GObject  )


=end pod

sub gtk_widget_list_accel_closures ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] can_activate_accel

Determines whether an accelerator that activates the signal
identified by I<signal_id> can currently be activated.
This is done by emitting the sig C<can-activate-accel>
signal on I<widget>; if the signal isn’t overridden by a
handler or in a derived widget, then the default check is
that the widget must be sensitive, and the widget and all
its ancestors mapped.

Returns: C<1> if the accelerator can be activated.

Since: 2.4

  method gtk_widget_can_activate_accel ( UInt $signal_id --> Int  )

=item UInt $signal_id; the ID of a signal installed on I<widget>

=end pod

sub gtk_widget_can_activate_accel ( N-GObject $widget, uint32 $signal_id )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] mnemonic_activate

Emits the sig C<mnemonic-activate> signal.

The default handler for this signal activates the I<widget> if
I<group_cycling> is C<0>, and just grabs the focus if I<group_cycling>
is C<1>.

Returns: C<1> if the signal has been handled

  method gtk_widget_mnemonic_activate ( Int $group_cycling --> Int  )

=item Int $group_cycling; C<1> if there are other widgets with the same mnemonic

=end pod

sub gtk_widget_mnemonic_activate ( N-GObject $widget, int32 $group_cycling )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_event

Rarely-used function. This function is used to emit
the event signals on a widget (those signals should never
be emitted without using this function to do so).
If you want to synthesize an event though, don’t use this function;
instead, use C<gtk_main_do_event()> so the event will behave as if
it were in the event queue. Don’t synthesize expose events; instead,
use C<gdk_window_invalidate_rect()> to invalidate a region of the
window.

Returns: return from the event signal emission (C<1> if
the event was handled)

  method gtk_widget_event ( GdkEvent $event --> Int  )

=item GdkEvent $event; a C<Gnome::Gdk3::Event>

=end pod

sub gtk_widget_event ( N-GObject $widget, GdkEvent $event )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] send_focus_change

Sends the focus change I<event> to I<widget>

This function is not meant to be used by applications. The only time it
should be used is when it is necessary for a C<Gnome::Gtk3::Widget> to assign focus
to a widget that is semantically owned by the first widget even though
it’s not a direct child - for instance, a search entry in a floating
window similar to the quick search in C<Gnome::Gtk3::TreeView>.

An example of its usage is:

|[<!-- language="C" -->
C<Gnome::Gdk3::Event> *fevent = gdk_event_new (GDK_FOCUS_CHANGE);

fevent->focus_change.type = GDK_FOCUS_CHANGE;
fevent->focus_change.in = TRUE;
fevent->focus_change.window = _gtk_widget_get_window (widget);
if (fevent->focus_change.window != NULL)
g_object_ref (fevent->focus_change.window);

gtk_widget_send_focus_change (widget, fevent);

gdk_event_free (event);
]|

Returns: the return value from the event signal emission: C<1>
if the event was handled, and C<0> otherwise

Since: 2.20

  method gtk_widget_send_focus_change ( GdkEvent $event --> Int  )

=item GdkEvent $event; a C<Gnome::Gdk3::Event> of type GDK_FOCUS_CHANGE

=end pod

sub gtk_widget_send_focus_change ( N-GObject $widget, GdkEvent $event )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_activate

For widgets that can be “activated” (buttons, menu items, etc.)
this function activates them. Activation is what happens when you
press Enter on a widget during key navigation. If I<widget> isn't
activatable, the function returns C<0>.

Returns: C<1> if the widget was activatable

  method gtk_widget_activate ( --> Int  )


=end pod

sub gtk_widget_activate ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_intersect

Computes the intersection of a I<widget>’s area and I<area>, storing
the intersection in I<intersection>, and returns C<1> if there was
an intersection.  I<intersection> may be C<Any> if you’re only
interested in whether there was an intersection.

Returns: C<1> if there was an intersection

  method gtk_widget_intersect ( N-GObject $area, N-GObject $intersection --> Int  )

=item N-GObject $area; a rectangle
=item N-GObject $intersection; (nullable): rectangle to store intersection of I<widget> and I<area>

=end pod

sub gtk_widget_intersect ( N-GObject $widget, N-GObject $area, N-GObject $intersection )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] freeze_child_notify

Stops emission of sig C<child-notify> signals on I<widget>. The
signals are queued until C<gtk_widget_thaw_child_notify()> is called
on I<widget>.

This is the analogue of C<g_object_freeze_notify()> for child properties.

  method gtk_widget_freeze_child_notify ( )


=end pod

sub gtk_widget_freeze_child_notify ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] child_notify

Emits a sig C<child-notify> signal for the
[child property][child-properties] I<child_property>
on I<widget>.

This is the analogue of C<g_object_notify()> for child properties.

Also see C<gtk_container_child_notify()>.

  method gtk_widget_child_notify ( Str $child_property )

=item Str $child_property; the name of a child property installed on the class of I<widget>’s parent

=end pod

sub gtk_widget_child_notify ( N-GObject $widget, Str $child_property )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] thaw_child_notify

Reverts the effect of a previous call to C<gtk_widget_freeze_child_notify()>.
This causes all queued sig C<child-notify> signals on I<widget> to be
emitted.

  method gtk_widget_thaw_child_notify ( )


=end pod

sub gtk_widget_thaw_child_notify ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_can_focus

Specifies whether I<widget> can own the input focus. See
C<gtk_widget_grab_focus()> for actually setting the input focus on a
widget.

Since: 2.18

  method gtk_widget_set_can_focus ( Int $can_focus )

=item Int $can_focus; whether or not I<widget> can own the input focus.

=end pod

sub gtk_widget_set_can_focus ( N-GObject $widget, int32 $can_focus )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_can_focus

Determines whether I<widget> can own the input focus. See
C<gtk_widget_set_can_focus()>.

Returns: C<1> if I<widget> can own the input focus, C<0> otherwise

Since: 2.18

  method gtk_widget_get_can_focus ( --> Int  )


=end pod

sub gtk_widget_get_can_focus ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] has_focus

Determines if the widget has the global input focus. See
C<gtk_widget_is_focus()> for the difference between having the global
input focus, and only having the focus within a toplevel.

Returns: C<1> if the widget has the global input focus.

Since: 2.18

  method gtk_widget_has_focus ( --> Int  )


=end pod

sub gtk_widget_has_focus ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] is_focus

Determines if the widget is the focus widget within its
toplevel. (This does not mean that the prop C<has-focus> property is
necessarily set; prop C<has-focus> will only be set if the
toplevel widget additionally has the global input focus.)

Returns: C<1> if the widget is the focus widget.

  method gtk_widget_is_focus ( --> Int  )


=end pod

sub gtk_widget_is_focus ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] has_visible_focus

Determines if the widget should show a visible indication that
it has the global input focus. This is a convenience function for
use in ::draw handlers that takes into account whether focus
indication should currently be shown in the toplevel window of
I<widget>. See C<gtk_window_get_focus_visible()> for more information
about focus indication.

To find out if the widget has the global input focus, use
C<gtk_widget_has_focus()>.

Returns: C<1> if the widget should display a “focus rectangle”

Since: 3.2

  method gtk_widget_has_visible_focus ( --> Int  )


=end pod

sub gtk_widget_has_visible_focus ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] grab_focus

Causes I<widget> to have the keyboard focus for the C<Gnome::Gtk3::Window> it's
inside. I<widget> must be a focusable widget, such as a C<Gnome::Gtk3::Entry>;
something like C<Gnome::Gtk3::Frame> won’t work.

More precisely, it must have the C<GTK_CAN_FOCUS> flag set. Use
C<gtk_widget_set_can_focus()> to modify that flag.

The widget also needs to be realized and mapped. This is indicated by the
related signals. Grabbing the focus immediately after creating the widget
will likely fail and cause critical warnings.

  method gtk_widget_grab_focus ( )


=end pod

sub gtk_widget_grab_focus ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_focus_on_click

Sets whether the widget should grab focus when it is clicked with the mouse.
Making mouse clicks not grab focus is useful in places like toolbars where
you don’t want the keyboard focus removed from the main area of the
application.

Since: 3.20

  method gtk_widget_set_focus_on_click ( Int $focus_on_click )

=item Int $focus_on_click; whether the widget should grab focus when clicked with the mouse

=end pod

sub gtk_widget_set_focus_on_click ( N-GObject $widget, int32 $focus_on_click )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_focus_on_click

Returns whether the widget should grab focus when it is clicked with the mouse.
See C<gtk_widget_set_focus_on_click()>.

Returns: C<1> if the widget should grab focus when it is clicked with
the mouse.

Since: 3.20

  method gtk_widget_get_focus_on_click ( --> Int  )


=end pod

sub gtk_widget_get_focus_on_click ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_can_default

Specifies whether I<widget> can be a default widget. See
C<gtk_widget_grab_default()> for details about the meaning of
“default”.

Since: 2.18

  method gtk_widget_set_can_default ( Int $can_default )

=item Int $can_default; whether or not I<widget> can be a default widget.

=end pod

sub gtk_widget_set_can_default ( N-GObject $widget, int32 $can_default )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_can_default

Determines whether I<widget> can be a default widget. See
C<gtk_widget_set_can_default()>.

Returns: C<1> if I<widget> can be a default widget, C<0> otherwise

Since: 2.18

  method gtk_widget_get_can_default ( --> Int  )


=end pod

sub gtk_widget_get_can_default ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] has_default

Determines whether I<widget> is the current default widget within its
toplevel. See C<gtk_widget_set_can_default()>.

Returns: C<1> if I<widget> is the current default widget within
its toplevel, C<0> otherwise

Since: 2.18

  method gtk_widget_has_default ( --> Int  )


=end pod

sub gtk_widget_has_default ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] grab_default

Causes I<widget> to become the default widget. I<widget> must be able to be
a default widget; typically you would ensure this yourself
by calling C<gtk_widget_set_can_default()> with a C<1> value.
The default widget is activated when
the user presses Enter in a window. Default widgets must be
activatable, that is, C<gtk_widget_activate()> should affect them. Note
that C<Gnome::Gtk3::Entry> widgets require the “activates-default” property
set to C<1> before they activate the default widget when Enter
is pressed and the C<Gnome::Gtk3::Entry> is focused.

  method gtk_widget_grab_default ( )


=end pod

sub gtk_widget_grab_default ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_receives_default

Specifies whether I<widget> will be treated as the default widget
within its toplevel when it has the focus, even if another widget
is the default.

See C<gtk_widget_grab_default()> for details about the meaning of
“default”.

Since: 2.18

  method gtk_widget_set_receives_default ( Int $receives_default )

=item Int $receives_default; whether or not I<widget> can be a default widget.

=end pod

sub gtk_widget_set_receives_default ( N-GObject $widget, int32 $receives_default )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_receives_default

Determines whether I<widget> is always treated as the default widget
within its toplevel when it has the focus, even if another widget
is the default.

See C<gtk_widget_set_receives_default()>.

Returns: C<1> if I<widget> acts as the default widget when focused,
C<0> otherwise

Since: 2.18

  method gtk_widget_get_receives_default ( --> Int  )


=end pod

sub gtk_widget_get_receives_default ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] has_grab

Determines whether the widget is currently grabbing events, so it
is the only widget receiving input events (keyboard and mouse).

See also C<gtk_grab_add()>.

Returns: C<1> if the widget is in the grab_widgets stack

Since: 2.18

  method gtk_widget_has_grab ( --> Int  )


=end pod

sub gtk_widget_has_grab ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] device_is_shadowed

Returns C<1> if I<device> has been shadowed by a GTK+
device grab on another widget, so it would stop sending
events to I<widget>. This may be used in the
sig C<grab-notify> signal to check for specific
devices. See C<gtk_device_grab_add()>.

Returns: C<1> if there is an ongoing grab on I<device>
by another C<Gnome::Gtk3::Widget> than I<widget>.

Since: 3.0

  method gtk_widget_device_is_shadowed ( N-GObject $device --> Int  )

=item N-GObject $device; a C<Gnome::Gdk3::Device>

=end pod

sub gtk_widget_device_is_shadowed ( N-GObject $widget, N-GObject $device )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_name

Widgets can be named, which allows you to refer to them from a
CSS file. You can apply a style to widgets with a particular name
in the CSS file. See the documentation for the CSS syntax (on the
same page as the docs for C<Gnome::Gtk3::StyleContext>).

Note that the CSS syntax has certain special characters to delimit
and represent elements in a selector (period, #, >, *...), so using
these will make your widget impossible to match by name. Any combination
of alphanumeric symbols, dashes and underscores will suffice.

  method gtk_widget_set_name ( Str $name )

=item Str $name; name for the widget

=end pod

sub gtk_widget_set_name ( N-GObject $widget, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_name

Retrieves the name of a widget. See C<gtk_widget_set_name()> for the
significance of widget names.

Returns: name of the widget. This string is owned by GTK+ and
should not be modified or freed

  method gtk_widget_get_name ( --> Str  )


=end pod

sub gtk_widget_get_name ( N-GObject $widget )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_state_flags

This function is for use in widget implementations. Turns on flag
values in the current widget state (insensitive, prelighted, etc.).

This function accepts the values C<GTK_STATE_FLAG_DIR_LTR> and
C<GTK_STATE_FLAG_DIR_RTL> but ignores them. If you want to set the widget's
direction, use C<gtk_widget_set_direction()>.

It is worth mentioning that any other state than C<GTK_STATE_FLAG_INSENSITIVE>,
will be propagated down to all non-internal children if I<widget> is a
C<Gnome::Gtk3::Container>, while C<GTK_STATE_FLAG_INSENSITIVE> itself will be propagated
down to all C<Gnome::Gtk3::Container> children by different means than turning on the
state flag down the hierarchy, both C<gtk_widget_get_state_flags()> and
C<gtk_widget_is_sensitive()> will make use of these.

Since: 3.0

  method gtk_widget_set_state_flags ( GtkStateFlags $flags, Int $clear )

=item GtkStateFlags $flags; State flags to turn on
=item Int $clear; Whether to clear state before turning on I<flags>

=end pod

sub gtk_widget_set_state_flags ( N-GObject $widget, int32 $flags, int32 $clear )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] unset_state_flags

This function is for use in widget implementations. Turns off flag
values for the current widget state (insensitive, prelighted, etc.).
See C<gtk_widget_set_state_flags()>.

Since: 3.0

  method gtk_widget_unset_state_flags ( GtkStateFlags $flags )

=item GtkStateFlags $flags; State flags to turn off

=end pod

sub gtk_widget_unset_state_flags ( N-GObject $widget, int32 $flags )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_state_flags

Returns the widget state as a flag set. It is worth mentioning
that the effective C<GTK_STATE_FLAG_INSENSITIVE> state will be
returned, that is, also based on parent insensitivity, even if
I<widget> itself is sensitive.

Also note that if you are looking for a way to obtain the
C<Gnome::Gtk3::StateFlags> to pass to a C<Gnome::Gtk3::StyleContext> method, you
should look at C<gtk_style_context_get_state()>.

Returns: The state flags for widget

Since: 3.0

  method gtk_widget_get_state_flags ( --> GtkStateFlags  )


=end pod

sub gtk_widget_get_state_flags ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_sensitive

Sets the sensitivity of a widget. A widget is sensitive if the user
can interact with it. Insensitive widgets are “grayed out” and the
user can’t interact with them. Insensitive widgets are known as
“inactive”, “disabled”, or “ghosted” in some other toolkits.

  method gtk_widget_set_sensitive ( Int $sensitive )

=item Int $sensitive; C<1> to make the widget sensitive

=end pod

sub gtk_widget_set_sensitive ( N-GObject $widget, int32 $sensitive )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_sensitive

Returns the widget’s sensitivity (in the sense of returning
the value that has been set using C<gtk_widget_set_sensitive()>).

The effective sensitivity of a widget is however determined by both its
own and its parent widget’s sensitivity. See C<gtk_widget_is_sensitive()>.

Returns: C<1> if the widget is sensitive

Since: 2.18

  method gtk_widget_get_sensitive ( --> Int  )


=end pod

sub gtk_widget_get_sensitive ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] is_sensitive

Returns the widget’s effective sensitivity, which means
it is sensitive itself and also its parent widget is sensitive

Returns: C<1> if the widget is effectively sensitive

Since: 2.18

  method gtk_widget_is_sensitive ( --> Int  )


=end pod

sub gtk_widget_is_sensitive ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_visible

Sets the visibility state of I<widget>. Note that setting this to
C<1> doesn’t mean the widget is actually viewable, see
C<gtk_widget_get_visible()>.

This function simply calls C<gtk_widget_show()> or C<gtk_widget_hide()>
but is nicer to use when the visibility of the widget depends on
some condition.

Since: 2.18

  method gtk_widget_set_visible ( Int $visible )

=item Int $visible; whether the widget should be shown or not

=end pod

sub gtk_widget_set_visible ( N-GObject $widget, int32 $visible )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_visible

Determines whether the widget is visible. If you want to
take into account whether the widget’s parent is also marked as
visible, use C<gtk_widget_is_visible()> instead.

This function does not check if the widget is obscured in any way.

See C<gtk_widget_set_visible()>.

Returns: C<1> if the widget is visible

Since: 2.18

  method gtk_widget_get_visible ( --> Int  )


=end pod

sub gtk_widget_get_visible ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] is_visible

Determines whether the widget and all its parents are marked as
visible.

This function does not check if the widget is obscured in any way.

See also C<gtk_widget_get_visible()> and C<gtk_widget_set_visible()>

Returns: C<1> if the widget and all its parents are visible

Since: 3.8

  method gtk_widget_is_visible ( --> Int  )


=end pod

sub gtk_widget_is_visible ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_has_window

Specifies whether I<widget> has a C<Gnome::Gdk3::Window> of its own. Note that
all realized widgets have a non-C<Any> “window” pointer
(C<gtk_widget_get_window()> never returns a C<Any> window when a widget
is realized), but for many of them it’s actually the C<Gnome::Gdk3::Window> of
one of its parent widgets. Widgets that do not create a C<window> for
themselves in sig C<realize> must announce this by
calling this function with I<has_window> = C<0>.

This function should only be called by widget implementations,
and they should call it in their C<init()> function.

Since: 2.18

  method gtk_widget_set_has_window ( Int $has_window )

=item Int $has_window; whether or not I<widget> has a window.

=end pod

sub gtk_widget_set_has_window ( N-GObject $widget, int32 $has_window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_has_window

Determines whether I<widget> has a C<Gnome::Gdk3::Window> of its own. See
C<gtk_widget_set_has_window()>.

Returns: C<1> if I<widget> has a window, C<0> otherwise

Since: 2.18

  method gtk_widget_get_has_window ( --> Int  )


=end pod

sub gtk_widget_get_has_window ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] is_toplevel

Determines whether I<widget> is a toplevel widget.

Currently only C<Gnome::Gtk3::Window> and C<Gnome::Gtk3::Invisible> (and out-of-process
C<Gnome::Gtk3::Plugs>) are toplevel widgets. Toplevel widgets have no parent
widget.

Returns: C<1> if I<widget> is a toplevel, C<0> otherwise

Since: 2.18

  method gtk_widget_is_toplevel ( --> Int  )


=end pod

sub gtk_widget_is_toplevel ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] is_drawable

Determines whether I<widget> can be drawn to. A widget can be drawn
to if it is mapped and visible.

Returns: C<1> if I<widget> is drawable, C<0> otherwise

Since: 2.18

  method gtk_widget_is_drawable ( --> Int  )


=end pod

sub gtk_widget_is_drawable ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_realized

Marks the widget as being realized. This function must only be
called after all C<Gnome::Gdk3::Windows> for the I<widget> have been created
and registered.

This function should only ever be called in a derived widget's
“realize” or “unrealize” implementation.

Since: 2.20

  method gtk_widget_set_realized ( Int $realized )

=item Int $realized; C<1> to mark the widget as realized

=end pod

sub gtk_widget_set_realized ( N-GObject $widget, int32 $realized )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_realized

Determines whether I<widget> is realized.

Returns: C<1> if I<widget> is realized, C<0> otherwise

Since: 2.20

  method gtk_widget_get_realized ( --> Int  )


=end pod

sub gtk_widget_get_realized ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_mapped

Marks the widget as being realized.

This function should only ever be called in a derived widget's
“map” or “unmap” implementation.

Since: 2.20

  method gtk_widget_set_mapped ( Int $mapped )

=item Int $mapped; C<1> to mark the widget as mapped

=end pod

sub gtk_widget_set_mapped ( N-GObject $widget, int32 $mapped )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_mapped

Whether the widget is mapped.

Returns: C<1> if the widget is mapped, C<0> otherwise.

Since: 2.20

  method gtk_widget_get_mapped ( --> Int  )


=end pod

sub gtk_widget_get_mapped ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_app_paintable

Sets whether the application intends to draw on the widget in
an sig C<draw> handler.

This is a hint to the widget and does not affect the behavior of
the GTK+ core; many widgets ignore this flag entirely. For widgets
that do pay attention to the flag, such as C<Gnome::Gtk3::EventBox> and C<Gnome::Gtk3::Window>,
the effect is to suppress default themed drawing of the widget's
background. (Children of the widget will still be drawn.) The application
is then entirely responsible for drawing the widget background.

Note that the background is still drawn when the widget is mapped.

  method gtk_widget_set_app_paintable ( Int $app_paintable )

=item Int $app_paintable; C<1> if the application will paint on the widget

=end pod

sub gtk_widget_set_app_paintable ( N-GObject $widget, int32 $app_paintable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_app_paintable

Determines whether the application intends to draw on the widget in
an sig C<draw> handler.

See C<gtk_widget_set_app_paintable()>

Returns: C<1> if the widget is app paintable

Since: 2.18

  method gtk_widget_get_app_paintable ( --> Int  )


=end pod

sub gtk_widget_get_app_paintable ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_redraw_on_allocate

Sets whether the entire widget is queued for drawing when its size
allocation changes. By default, this setting is C<1> and
the entire widget is redrawn on every size change. If your widget
leaves the upper left unchanged when made bigger, turning this
setting off will improve performance.
Note that for widgets where C<gtk_widget_get_has_window()> is C<0>
setting this flag to C<0> turns off all allocation on resizing:
the widget will not even redraw if its position changes; this is to
allow containers that don’t draw anything to avoid excess
invalidations. If you set this flag on a widget with no window that
does draw on I<widget>->window, you are
responsible for invalidating both the old and new allocation of the
widget when the widget is moved and responsible for invalidating
regions newly when the widget increases size.

  method gtk_widget_set_redraw_on_allocate ( Int $redraw_on_allocate )

=item Int $redraw_on_allocate; if C<1>, the entire widget will be redrawn when it is allocated to a new size. Otherwise, only the new portion of the widget will be redrawn.

=end pod

sub gtk_widget_set_redraw_on_allocate ( N-GObject $widget, int32 $redraw_on_allocate )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_parent

This function is useful only when implementing subclasses of
C<Gnome::Gtk3::Container>.
Sets the container as the parent of I<widget>, and takes care of
some details such as updating the state and style of the child
to reflect its new location. The opposite function is
C<gtk_widget_unparent()>.

  method gtk_widget_set_parent ( N-GObject $parent )

=item N-GObject $parent; parent container

=end pod

sub gtk_widget_set_parent ( N-GObject $widget, N-GObject $parent )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_parent

Returns the parent container of I<widget>.

Returns: (transfer none) (nullable): the parent container of I<widget>, or C<Any>

  method gtk_widget_get_parent ( --> N-GObject  )


=end pod

sub gtk_widget_get_parent ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_parent_window

Sets a non default parent window for I<widget>.

For C<Gnome::Gtk3::Window> classes, setting a I<parent_window> effects whether
the window is a toplevel window or can be embedded into other
widgets.

For C<Gnome::Gtk3::Window> classes, this needs to be called before the
window is realized.

  method gtk_widget_set_parent_window ( N-GObject $parent_window )

=item N-GObject $parent_window; the new parent window.

=end pod

sub gtk_widget_set_parent_window ( N-GObject $widget, N-GObject $parent_window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_parent_window

Gets I<widget>’s parent window.

Returns: (transfer none): the parent window of I<widget>.

  method gtk_widget_get_parent_window ( --> N-GObject  )


=end pod

sub gtk_widget_get_parent_window ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_child_visible

Sets whether I<widget> should be mapped along with its when its parent
is mapped and I<widget> has been shown with C<gtk_widget_show()>.

The child visibility can be set for widget before it is added to
a container with C<gtk_widget_set_parent()>, to avoid mapping
children unnecessary before immediately unmapping them. However
it will be reset to its default state of C<1> when the widget
is removed from a container.

Note that changing the child visibility of a widget does not
queue a resize on the widget. Most of the time, the size of
a widget is computed from all visible children, whether or
not they are mapped. If this is not the case, the container
can queue a resize itself.

This function is only useful for container implementations and
never should be called by an application.

  method gtk_widget_set_child_visible ( Int $is_visible )

=item Int $is_visible; if C<1>, I<widget> should be mapped along with its parent.

=end pod

sub gtk_widget_set_child_visible ( N-GObject $widget, int32 $is_visible )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_child_visible

Gets the value set with C<gtk_widget_set_child_visible()>.
If you feel a need to use this function, your code probably
needs reorganization.

This function is only useful for container implementations and
never should be called by an application.

Returns: C<1> if the widget is mapped with the parent.

  method gtk_widget_get_child_visible ( --> Int  )


=end pod

sub gtk_widget_get_child_visible ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_window

Sets a widget’s window. This function should only be used in a
widget’s sig C<realize> implementation. The C<window> passed is
usually either new window created with C<gdk_window_new()>, or the
window of its parent widget as returned by
C<gtk_widget_get_parent_window()>.

Widgets must indicate whether they will create their own C<Gnome::Gdk3::Window>
by calling C<gtk_widget_set_has_window()>. This is usually done in the
widget’s C<init()> function.

Note that this function does not add any reference to I<window>.

Since: 2.18

  method gtk_widget_set_window ( N-GObject $window )

=item N-GObject $window; (transfer full): a C<Gnome::Gdk3::Window>

=end pod

sub gtk_widget_set_window ( N-GObject $widget, N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_window

Returns the widget’s window if it is realized, C<Any> otherwise

Returns: (transfer none) (nullable): I<widget>’s window.

Since: 2.14

  method gtk_widget_get_window ( --> N-GObject  )


=end pod

sub gtk_widget_get_window ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] register_window

Registers a C<Gnome::Gdk3::Window> with the widget and sets it up so that
the widget receives events for it. Call C<gtk_widget_unregister_window()>
when destroying the window.

Before 3.8 you needed to call C<gdk_window_set_user_data()> directly to set
this up. This is now deprecated and you should use C<gtk_widget_register_window()>
instead. Old code will keep working as is, although some new features like
transparency might not work perfectly.

Since: 3.8

  method gtk_widget_register_window ( N-GObject $window )

=item N-GObject $window; a C<Gnome::Gdk3::Window>

=end pod

sub gtk_widget_register_window ( N-GObject $widget, N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] unregister_window

Unregisters a C<Gnome::Gdk3::Window> from the widget that was previously set up with
C<gtk_widget_register_window()>. You need to call this when the window is
no longer used by the widget, such as when you destroy it.

Since: 3.8

  method gtk_widget_unregister_window ( N-GObject $window )

=item N-GObject $window; a C<Gnome::Gdk3::Window>

=end pod

sub gtk_widget_unregister_window ( N-GObject $widget, N-GObject $window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_allocated_width

Returns the width that has currently been allocated to I<widget>.
This function is intended to be used when implementing handlers
for the sig C<draw> function.

Returns: the width of the I<widget>

  method gtk_widget_get_allocated_width ( --> int32  )


=end pod

sub gtk_widget_get_allocated_width ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_allocated_height

Returns the height that has currently been allocated to I<widget>.
This function is intended to be used when implementing handlers
for the sig C<draw> function.

Returns: the height of the I<widget>

  method gtk_widget_get_allocated_height ( --> int32  )


=end pod

sub gtk_widget_get_allocated_height ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_allocated_baseline

Returns the baseline that has currently been allocated to I<widget>.
This function is intended to be used when implementing handlers
for the sig C<draw> function, and when allocating child
widgets in sig C<size_allocate>.

Returns: the baseline of the I<widget>, or -1 if none

Since: 3.10

  method gtk_widget_get_allocated_baseline ( --> int32  )


=end pod

sub gtk_widget_get_allocated_baseline ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_allocated_size

Retrieves the widget’s allocated size.

This function returns the last values passed to
C<gtk_widget_size_allocate_with_baseline()>. The value differs from
the size returned in C<gtk_widget_get_allocation()> in that functions
like C<gtk_widget_set_halign()> can adjust the allocation, but not
the value returned by this function.

If a widget is not visible, its allocated size is 0.

Since: 3.20

  method gtk_widget_get_allocated_size ( GtkAllocation $allocation, int32 $baseline )

=item GtkAllocation $allocation; (out): a pointer to a C<Gnome::Gtk3::Allocation> to copy to
=item int32 $baseline; (out) (allow-none): a pointer to an integer to copy to

=end pod

sub gtk_widget_get_allocated_size ( N-GObject $widget, GtkAllocation $allocation, int32 $baseline )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_allocation

Retrieves the widget’s allocation.

Note, when implementing a C<Gnome::Gtk3::Container>: a widget’s allocation will
be its “adjusted” allocation, that is, the widget’s parent
container typically calls C<gtk_widget_size_allocate()> with an
allocation, and that allocation is then adjusted (to handle margin
and alignment for example) before assignment to the widget.
C<gtk_widget_get_allocation()> returns the adjusted allocation that
was actually assigned to the widget. The adjusted allocation is
guaranteed to be completely contained within the
C<gtk_widget_size_allocate()> allocation, however. So a C<Gnome::Gtk3::Container>
is guaranteed that its children stay inside the assigned bounds,
but not that they have exactly the bounds the container assigned.
There is no way to get the original allocation assigned by
C<gtk_widget_size_allocate()>, since it isn’t stored; if a container
implementation needs that information it will have to track it itself.

Since: 2.18

  method gtk_widget_get_allocation ( GtkAllocation $allocation )

=item GtkAllocation $allocation; (out): a pointer to a C<Gnome::Gtk3::Allocation> to copy to

=end pod

sub gtk_widget_get_allocation ( N-GObject $widget, GtkAllocation $allocation )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_allocation

Sets the widget’s allocation.  This should not be used
directly, but from within a widget’s size_allocate method.

The allocation set should be the “adjusted” or actual
allocation. If you’re implementing a C<Gnome::Gtk3::Container>, you want to use
C<gtk_widget_size_allocate()> instead of C<gtk_widget_set_allocation()>.
The C<Gnome::Gtk3::WidgetClass>::adjust_size_allocation virtual method adjusts the
allocation inside C<gtk_widget_size_allocate()> to create an adjusted
allocation.

Since: 2.18

  method gtk_widget_set_allocation ( GtkAllocation $allocation )

=item GtkAllocation $allocation; a pointer to a C<Gnome::Gtk3::Allocation> to copy from

=end pod

sub gtk_widget_set_allocation ( N-GObject $widget, GtkAllocation $allocation )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_clip

Sets the widget’s clip.  This must not be used directly,
but from within a widget’s size_allocate method.
It must be called after C<gtk_widget_set_allocation()> (or after chaining up
to the parent class), because that function resets the clip.

The clip set should be the area that I<widget> draws on. If I<widget> is a
C<Gnome::Gtk3::Container>, the area must contain all children's clips.

If this function is not called by I<widget> during a ::size-allocate handler,
the clip will be set to I<widget>'s allocation.

Since: 3.14

  method gtk_widget_set_clip ( GtkAllocation $clip )

=item GtkAllocation $clip; a pointer to a C<Gnome::Gtk3::Allocation> to copy from

=end pod

sub gtk_widget_set_clip ( N-GObject $widget, GtkAllocation $clip )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_clip

Retrieves the widget’s clip area.

The clip area is the area in which all of I<widget>'s drawing will
happen. Other toolkits call it the bounding box.

Historically, in GTK+ the clip area has been equal to the allocation
retrieved via C<gtk_widget_get_allocation()>.

Since: 3.14

  method gtk_widget_get_clip ( GtkAllocation $clip )

=item GtkAllocation $clip; (out): a pointer to a C<Gnome::Gtk3::Allocation> to copy to

=end pod

sub gtk_widget_get_clip ( N-GObject $widget, GtkAllocation $clip )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] child_focus

This function is used by custom widget implementations; if you're
writing an app, you’d use C<gtk_widget_grab_focus()> to move the focus
to a particular widget, and C<gtk_container_set_focus_chain()> to
change the focus tab order. So you may want to investigate those
functions instead.

C<gtk_widget_child_focus()> is called by containers as the user moves
around the window using keyboard shortcuts. I<direction> indicates
what kind of motion is taking place (up, down, left, right, tab
forward, tab backward). C<gtk_widget_child_focus()> emits the
sig C<focus> signal; widgets override the default handler
for this signal in order to implement appropriate focus behavior.

The default ::focus handler for a widget should return C<1> if
moving in I<direction> left the focus on a focusable location inside
that widget, and C<0> if moving in I<direction> moved the focus
outside the widget. If returning C<1>, widgets normally
call C<gtk_widget_grab_focus()> to place the focus accordingly;
if returning C<0>, they don’t modify the current focus location.

Returns: C<1> if focus ended up inside I<widget>

  method gtk_widget_child_focus ( GtkDirectionType $direction --> Int  )

=item GtkDirectionType $direction; direction of focus movement

=end pod

sub gtk_widget_child_focus ( N-GObject $widget, int32 $direction )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] keynav_failed

This function should be called whenever keyboard navigation within
a single widget hits a boundary. The function emits the
sig C<keynav-failed> signal on the widget and its return
value should be interpreted in a way similar to the return value of
C<gtk_widget_child_focus()>:

When C<1> is returned, stay in the widget, the failed keyboard
navigation is OK and/or there is nowhere we can/should move the
focus to.

When C<0> is returned, the caller should continue with keyboard
navigation outside the widget, e.g. by calling
C<gtk_widget_child_focus()> on the widget’s toplevel.

The default ::keynav-failed handler returns C<1> for
C<GTK_DIR_TAB_FORWARD> and C<GTK_DIR_TAB_BACKWARD>. For the other
values of C<Gnome::Gtk3::DirectionType> it returns C<0>.

Whenever the default handler returns C<1>, it also calls
C<gtk_widget_error_bell()> to notify the user of the failed keyboard
navigation.

A use case for providing an own implementation of ::keynav-failed
(either by connecting to it or by overriding it) would be a row of
C<Gnome::Gtk3::Entry> widgets where the user should be able to navigate the
entire row with the cursor keys, as e.g. known from user interfaces
that require entering license keys.

Returns: C<1> if stopping keyboard navigation is fine, C<0>
if the emitting widget should try to handle the keyboard
navigation attempt in its parent container(s).

Since: 2.12

  method gtk_widget_keynav_failed ( GtkDirectionType $direction --> Int  )

=item GtkDirectionType $direction; direction of focus movement

=end pod

sub gtk_widget_keynav_failed ( N-GObject $widget, int32 $direction )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] error_bell

Notifies the user about an input-related error on this widget.
If the prop C<gtk-error-bell> setting is C<1>, it calls
C<gdk_window_beep()>, otherwise it does nothing.

Note that the effect of C<gdk_window_beep()> can be configured in many
ways, depending on the windowing backend and the desktop environment
or window manager that is used.

Since: 2.12

  method gtk_widget_error_bell ( )


=end pod

sub gtk_widget_error_bell ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_size_request

Sets the minimum size of a widget; that is, the widget’s size
request will be at least I<width> by I<height>. You can use this
function to force a widget to be larger than it normally would be.

In most cases, C<gtk_window_set_default_size()> is a better choice for
toplevel windows than this function; setting the default size will
still allow users to shrink the window. Setting the size request
will force them to leave the window at least as large as the size
request. When dealing with window sizes,
C<gtk_window_set_geometry_hints()> can be a useful function as well.

Note the inherent danger of setting any fixed size - themes,
translations into other languages, different fonts, and user action
can all change the appropriate size for a given widget. So, it's
basically impossible to hardcode a size that will always be
correct.

The size request of a widget is the smallest size a widget can
accept while still functioning well and drawing itself correctly.
However in some strange cases a widget may be allocated less than
its requested size, and in many cases a widget may be allocated more
space than it requested.

If the size request in a given direction is -1 (unset), then
the “natural” size request of the widget will be used instead.

The size request set here does not include any margin from the
C<Gnome::Gtk3::Widget> properties margin-left, margin-right, margin-top, and
margin-bottom, but it does include pretty much all other padding
or border properties set by any subclass of C<Gnome::Gtk3::Widget>.

  method gtk_widget_set_size_request ( Int $width, Int $height )

=item Int $width; width I<widget> should request, or -1 to unset
=item Int $height; height I<widget> should request, or -1 to unset

=end pod

sub gtk_widget_set_size_request ( N-GObject $widget, int32 $width, int32 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_size_request

Gets the size request that was explicitly set for the widget using
C<gtk_widget_set_size_request()>. A value of -1 stored in I<width> or
I<height> indicates that that dimension has not been set explicitly
and the natural requisition of the widget will be used instead. See
C<gtk_widget_set_size_request()>. To get the size a widget will
actually request, call C<gtk_widget_get_preferred_size()> instead of
this function.

  method gtk_widget_get_size_request ( Int $width, Int $height )

=item Int $width; (out) (allow-none): return location for width, or C<Any>
=item Int $height; (out) (allow-none): return location for height, or C<Any>

=end pod

sub gtk_widget_get_size_request ( N-GObject $widget, int32 $width, int32 $height )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_events

Sets the event mask (see C<Gnome::Gdk3::EventMask>) for a widget. The event
mask determines which events a widget will receive. Keep in mind
that different widgets have different default event masks, and by
changing the event mask you may disrupt a widget’s functionality,
so be careful. This function must be called while a widget is
unrealized. Consider C<gtk_widget_add_events()> for widgets that are
already realized, or if you want to preserve the existing event
mask. This function can’t be used with widgets that have no window.
(See C<gtk_widget_get_has_window()>).  To get events on those widgets,
place them inside a C<Gnome::Gtk3::EventBox> and receive events on the event
box.

  method gtk_widget_set_events ( Int $events )

=item Int $events; event mask

=end pod

sub gtk_widget_set_events ( N-GObject $widget, int32 $events )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] add_events

Adds the events in the bitfield I<events> to the event mask for
I<widget>. See C<gtk_widget_set_events()> and the
[input handling overview][event-masks] for details.

  method gtk_widget_add_events ( Int $events )

=item Int $events; an event mask, see C<Gnome::Gdk3::EventMask>

=end pod

sub gtk_widget_add_events ( N-GObject $widget, int32 $events )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_device_events

Sets the device event mask (see C<Gnome::Gdk3::EventMask>) for a widget. The event
mask determines which events a widget will receive from I<device>. Keep
in mind that different widgets have different default event masks, and by
changing the event mask you may disrupt a widget’s functionality,
so be careful. This function must be called while a widget is
unrealized. Consider C<gtk_widget_add_device_events()> for widgets that are
already realized, or if you want to preserve the existing event
mask. This function can’t be used with windowless widgets (which return
C<0> from C<gtk_widget_get_has_window()>);
to get events on those widgets, place them inside a C<Gnome::Gtk3::EventBox>
and receive events on the event box.

Since: 3.0

  method gtk_widget_set_device_events ( N-GObject $device, GdkEventMask $events )

=item N-GObject $device; a C<Gnome::Gdk3::Device>
=item GdkEventMask $events; event mask

=end pod

sub gtk_widget_set_device_events ( N-GObject $widget, N-GObject $device, GdkEventMask $events )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] add_device_events

Adds the device events in the bitfield I<events> to the event mask for
I<widget>. See C<gtk_widget_set_device_events()> for details.

Since: 3.0

  method gtk_widget_add_device_events ( N-GObject $device, GdkEventMask $events )

=item N-GObject $device; a C<Gnome::Gdk3::Device>
=item GdkEventMask $events; an event mask, see C<Gnome::Gdk3::EventMask>

=end pod

sub gtk_widget_add_device_events ( N-GObject $widget, N-GObject $device, GdkEventMask $events )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_opacity

Request the I<widget> to be rendered partially transparent,
with opacity 0 being fully transparent and 1 fully opaque. (Opacity values
are clamped to the [0,1] range.).
This works on both toplevel widget, and child widgets, although there
are some limitations:

For toplevel widgets this depends on the capabilities of the windowing
system. On X11 this has any effect only on X screens with a compositing manager
running. See C<gtk_widget_is_composited()>. On Windows it should work
always, although setting a window’s opacity after the window has been
shown causes it to flicker once on Windows.

For child widgets it doesn’t work if any affected widget has a native window, or
disables double buffering.

Since: 3.8

  method gtk_widget_set_opacity ( Num $opacity )

=item Num $opacity; desired opacity, between 0 and 1

=end pod

sub gtk_widget_set_opacity ( N-GObject $widget, num64 $opacity )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_opacity

Fetches the requested opacity for this widget.
See C<gtk_widget_set_opacity()>.

Returns: the requested opacity for this widget.

Since: 3.8

  method gtk_widget_get_opacity ( --> Num  )


=end pod

sub gtk_widget_get_opacity ( N-GObject $widget )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_device_enabled

Enables or disables a C<Gnome::Gdk3::Device> to interact with I<widget>
and all its children.

It does so by descending through the C<Gnome::Gdk3::Window> hierarchy
and enabling the same mask that is has for core events
(i.e. the one that C<gdk_window_get_events()> returns).

Since: 3.0

  method gtk_widget_set_device_enabled ( N-GObject $device, Int $enabled )

=item N-GObject $device; a C<Gnome::Gdk3::Device>
=item Int $enabled; whether to enable the device

=end pod

sub gtk_widget_set_device_enabled ( N-GObject $widget, N-GObject $device, int32 $enabled )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_device_enabled

Returns whether I<device> can interact with I<widget> and its
children. See C<gtk_widget_set_device_enabled()>.

Returns: C<1> is I<device> is enabled for I<widget>

Since: 3.0

  method gtk_widget_get_device_enabled ( N-GObject $device --> Int  )

=item N-GObject $device; a C<Gnome::Gdk3::Device>

=end pod

sub gtk_widget_get_device_enabled ( N-GObject $widget, N-GObject $device )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_toplevel

This function returns the topmost widget in the container hierarchy
I<widget> is a part of. If I<widget> has no parent widgets, it will be
returned as the topmost widget. No reference will be added to the
returned widget; it should not be unreferenced.

Note the difference in behavior vs. C<gtk_widget_get_ancestor()>;
`gtk_widget_get_ancestor (widget, GTK_TYPE_WINDOW)`
would return
C<Any> if I<widget> wasn’t inside a toplevel window, and if the
window was inside a C<Gnome::Gtk3::Window>-derived widget which was in turn
inside the toplevel C<Gnome::Gtk3::Window>. While the second case may
seem unlikely, it actually happens when a C<Gnome::Gtk3::Plug> is embedded
inside a C<Gnome::Gtk3::Socket> within the same application.

To reliably find the toplevel C<Gnome::Gtk3::Window>, use
C<gtk_widget_get_toplevel()> and call C<gtk_widget_is_toplevel()>
on the result.
|[<!-- language="C" -->
C<Gnome::Gtk3::Widget> *toplevel = gtk_widget_get_toplevel (widget);
if (gtk_widget_is_toplevel (toplevel))
{
// Perform action on toplevel.
}
]|

Returns: (transfer none): the topmost ancestor of I<widget>, or I<widget> itself
if there’s no ancestor.

  method gtk_widget_get_toplevel ( --> N-GObject  )


=end pod

sub gtk_widget_get_toplevel ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_ancestor

Gets the first ancestor of I<widget> with type I<widget_type>. For example,
`gtk_widget_get_ancestor (widget, GTK_TYPE_BOX)` gets
the first C<Gnome::Gtk3::Box> that’s an ancestor of I<widget>. No reference will be
added to the returned widget; it should not be unreferenced. See note
about checking for a toplevel C<Gnome::Gtk3::Window> in the docs for
C<gtk_widget_get_toplevel()>.

Note that unlike C<gtk_widget_is_ancestor()>, C<gtk_widget_get_ancestor()>
considers I<widget> to be an ancestor of itself.

Returns: (transfer none) (nullable): the ancestor widget, or C<Any> if not found

  method gtk_widget_get_ancestor ( N-GObject $widget_type --> N-GObject  )

=item N-GObject $widget_type; ancestor type

=end pod

sub gtk_widget_get_ancestor ( N-GObject $widget, N-GObject $widget_type )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_visual

Gets the visual that will be used to render I<widget>.

Returns: (transfer none): the visual for I<widget>

  method gtk_widget_get_visual ( --> N-GObject  )


=end pod

sub gtk_widget_get_visual ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_visual

Sets the visual that should be used for by widget and its children for
creating C<Gnome::Gdk3::Windows>. The visual must be on the same C<Gnome::Gdk3::Screen> as
returned by C<gtk_widget_get_screen()>, so handling the
sig C<screen-changed> signal is necessary.

Setting a new I<visual> will not cause I<widget> to recreate its windows,
so you should call this function before I<widget> is realized.

  method gtk_widget_set_visual ( N-GObject $visual )

=item N-GObject $visual; (allow-none): visual to be used or C<Any> to unset a previous one

=end pod

sub gtk_widget_set_visual ( N-GObject $widget, N-GObject $visual )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_screen

Get the C<Gnome::Gdk3::Screen> from the toplevel window associated with
this widget. This function can only be called after the widget
has been added to a widget hierarchy with a C<Gnome::Gtk3::Window>
at the top.

In general, you should only create screen specific
resources when a widget has been realized, and you should
free those resources when the widget is unrealized.

Returns: (transfer none): the C<Gnome::Gdk3::Screen> for the toplevel for this widget.

Since: 2.2

  method gtk_widget_get_screen ( --> N-GObject  )


=end pod

sub gtk_widget_get_screen ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] has_screen

Checks whether there is a C<Gnome::Gdk3::Screen> is associated with
this widget. All toplevel widgets have an associated
screen, and all widgets added into a hierarchy with a toplevel
window at the top.

Returns: C<1> if there is a C<Gnome::Gdk3::Screen> associated
with the widget.

Since: 2.2

  method gtk_widget_has_screen ( --> Int  )


=end pod

sub gtk_widget_has_screen ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_scale_factor

Retrieves the internal scale factor that maps from window coordinates
to the actual device pixels. On traditional systems this is 1, on
high density outputs, it can be a higher value (typically 2).

See C<gdk_window_get_scale_factor()>.

Returns: the scale factor for I<widget>

Since: 3.10

  method gtk_widget_get_scale_factor ( --> Int  )


=end pod

sub gtk_widget_get_scale_factor ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_display

Get the C<Gnome::Gdk3::Display> for the toplevel window associated with
this widget. This function can only be called after the widget
has been added to a widget hierarchy with a C<Gnome::Gtk3::Window> at the top.

In general, you should only create display specific
resources when a widget has been realized, and you should
free those resources when the widget is unrealized.

Returns: (transfer none): the C<Gnome::Gdk3::Display> for the toplevel for this widget.

Since: 2.2

  method gtk_widget_get_display ( --> N-GObject  )


=end pod

sub gtk_widget_get_display ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_settings

Gets the settings object holding the settings used for this widget.

Note that this function can only be called when the C<Gnome::Gtk3::Widget>
is attached to a toplevel, since the settings object is specific
to a particular C<Gnome::Gdk3::Screen>.

Returns: (transfer none): the relevant C<Gnome::Gtk3::Settings> object

  method gtk_widget_get_settings ( --> N-GObject  )


=end pod

sub gtk_widget_get_settings ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_clipboard

Returns the clipboard object for the given selection to
be used with I<widget>. I<widget> must have a C<Gnome::Gdk3::Display>
associated with it, so must be attached to a toplevel
window.

Returns: (transfer none): the appropriate clipboard object. If no
clipboard already exists, a new one will
be created. Once a clipboard object has
been created, it is persistent for all time.

Since: 2.2

  method gtk_widget_get_clipboard ( GdkAtom $selection --> N-GObject  )

=item GdkAtom $selection; a C<Gnome::Gdk3::Atom> which identifies the clipboard to use. C<GDK_SELECTION_CLIPBOARD> gives the default clipboard. Another common value is C<GDK_SELECTION_PRIMARY>, which gives the primary X selection.

=end pod

sub gtk_widget_get_clipboard ( N-GObject $widget, GdkAtom $selection )
  returns N-GObject
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_hexpand

Gets whether the widget would like any available extra horizontal
space. When a user resizes a C<Gnome::Gtk3::Window>, widgets with expand=TRUE
generally receive the extra space. For example, a list or
scrollable area or document in your window would often be set to
expand.

Containers should use C<gtk_widget_compute_expand()> rather than
this function, to see whether a widget, or any of its children,
has the expand flag set. If any child of a widget wants to
expand, the parent may ask to expand also.

This function only looks at the widget’s own hexpand flag, rather
than computing whether the entire widget tree rooted at this widget
wants to expand.

Returns: whether hexpand flag is set

  method gtk_widget_get_hexpand ( --> Int  )


=end pod

sub gtk_widget_get_hexpand ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_hexpand

Sets whether the widget would like any available extra horizontal
space. When a user resizes a C<Gnome::Gtk3::Window>, widgets with expand=TRUE
generally receive the extra space. For example, a list or
scrollable area or document in your window would often be set to
expand.

Call this function to set the expand flag if you would like your
widget to become larger horizontally when the window has extra
room.

By default, widgets automatically expand if any of their children
want to expand. (To see if a widget will automatically expand given
its current children and state, call C<gtk_widget_compute_expand()>. A
container can decide how the expandability of children affects the
expansion of the container by overriding the compute_expand virtual
method on C<Gnome::Gtk3::Widget>.).

Setting hexpand explicitly with this function will override the
automatic expand behavior.

This function forces the widget to expand or not to expand,
regardless of children.  The override occurs because
C<gtk_widget_set_hexpand()> sets the hexpand-set property (see
C<gtk_widget_set_hexpand_set()>) which causes the widget’s hexpand
value to be used, rather than looking at children and widget state.

  method gtk_widget_set_hexpand ( Int $expand )

=item Int $expand; whether to expand

=end pod

sub gtk_widget_set_hexpand ( N-GObject $widget, int32 $expand )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_hexpand_set

Gets whether C<gtk_widget_set_hexpand()> has been used to
explicitly set the expand flag on this widget.

If hexpand is set, then it overrides any computed
expand value based on child widgets. If hexpand is not
set, then the expand value depends on whether any
children of the widget would like to expand.

There are few reasons to use this function, but it’s here
for completeness and consistency.

Returns: whether hexpand has been explicitly set

  method gtk_widget_get_hexpand_set ( --> Int  )


=end pod

sub gtk_widget_get_hexpand_set ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_hexpand_set

Sets whether the hexpand flag (see C<gtk_widget_get_hexpand()>) will
be used.

The hexpand-set property will be set automatically when you call
C<gtk_widget_set_hexpand()> to set hexpand, so the most likely
reason to use this function would be to unset an explicit expand
flag.

If hexpand is set, then it overrides any computed
expand value based on child widgets. If hexpand is not
set, then the expand value depends on whether any
children of the widget would like to expand.

There are few reasons to use this function, but it’s here
for completeness and consistency.

  method gtk_widget_set_hexpand_set ( Int $set )

=item Int $set; value for hexpand-set property

=end pod

sub gtk_widget_set_hexpand_set ( N-GObject $widget, int32 $set )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_vexpand

Gets whether the widget would like any available extra vertical
space.

See C<gtk_widget_get_hexpand()> for more detail.

Returns: whether vexpand flag is set

  method gtk_widget_get_vexpand ( --> Int  )


=end pod

sub gtk_widget_get_vexpand ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_vexpand

Sets whether the widget would like any available extra vertical
space.

See C<gtk_widget_set_hexpand()> for more detail.

  method gtk_widget_set_vexpand ( Int $expand )

=item Int $expand; whether to expand

=end pod

sub gtk_widget_set_vexpand ( N-GObject $widget, int32 $expand )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_vexpand_set

Gets whether C<gtk_widget_set_vexpand()> has been used to
explicitly set the expand flag on this widget.

See C<gtk_widget_get_hexpand_set()> for more detail.

Returns: whether vexpand has been explicitly set

  method gtk_widget_get_vexpand_set ( --> Int  )


=end pod

sub gtk_widget_get_vexpand_set ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_vexpand_set

Sets whether the vexpand flag (see C<gtk_widget_get_vexpand()>) will
be used.

See C<gtk_widget_set_hexpand_set()> for more detail.

  method gtk_widget_set_vexpand_set ( Int $set )

=item Int $set; value for vexpand-set property

=end pod

sub gtk_widget_set_vexpand_set ( N-GObject $widget, int32 $set )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] queue_compute_expand

Mark I<widget> as needing to recompute its expand flags. Call
this function when setting legacy expand child properties
on the child of a container.

See C<gtk_widget_compute_expand()>.

  method gtk_widget_queue_compute_expand ( )


=end pod

sub gtk_widget_queue_compute_expand ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] compute_expand

Computes whether a container should give this widget extra space
when possible. Containers should check this, rather than
looking at C<gtk_widget_get_hexpand()> or C<gtk_widget_get_vexpand()>.

This function already checks whether the widget is visible, so
visibility does not need to be checked separately. Non-visible
widgets are not expanded.

The computed expand value uses either the expand setting explicitly
set on the widget itself, or, if none has been explicitly set,
the widget may expand if some of its children do.

Returns: whether widget tree rooted here should be expanded

  method gtk_widget_compute_expand ( GtkOrientation $orientation --> Int  )

=item GtkOrientation $orientation; expand direction

=end pod

sub gtk_widget_compute_expand ( N-GObject $widget, int32 $orientation )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_support_multidevice

Returns C<1> if I<widget> is multiple pointer aware. See
C<gtk_widget_set_support_multidevice()> for more information.

Returns: C<1> if I<widget> is multidevice aware.

  method gtk_widget_get_support_multidevice ( --> Int  )


=end pod

sub gtk_widget_get_support_multidevice ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_support_multidevice

Enables or disables multiple pointer awareness. If this setting is C<1>,
I<widget> will start receiving multiple, per device enter/leave events. Note
that if custom C<Gnome::Gdk3::Windows> are created in sig C<realize>,
C<gdk_window_set_support_multidevice()> will have to be called manually on them.

Since: 3.0

  method gtk_widget_set_support_multidevice ( Int $support_multidevice )

=item Int $support_multidevice; C<1> to support input from multiple devices.

=end pod

sub gtk_widget_set_support_multidevice ( N-GObject $widget, int32 $support_multidevice )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] class_set_accessible_type

Sets the type to be used for creating accessibles for widgets of
I<widget_class>. The given I<type> must be a subtype of the type used for
accessibles of the parent class.

This function should only be called from class init functions of widgets.

Since: 3.2

  method gtk_widget_class_set_accessible_type ( GtkWidgetClass $widget_class, N-GObject $type )

=item GtkWidgetClass $widget_class; class to set the accessible type for
=item N-GObject $type; The object type that implements the accessible for I<widget_class>

=end pod

sub gtk_widget_class_set_accessible_type ( GtkWidgetClass $widget_class, N-GObject $type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] class_set_accessible_role

Sets the default C<AtkRole> to be set on accessibles created for
widgets of I<widget_class>. Accessibles may decide to not honor this
setting if their role reporting is more refined. Calls to
C<gtk_widget_class_set_accessible_type()> will reset this value.

In cases where you want more fine-grained control over the role of
accessibles created for I<widget_class>, you should provide your own
accessible type and use C<gtk_widget_class_set_accessible_type()>
instead.

If I<role> is C<ATK_ROLE_INVALID>, the default role will not be changed
and the accessible’s default role will be used instead.

This function should only be called from class init functions of widgets.

Since: 3.2

  method gtk_widget_class_set_accessible_role ( GtkWidgetClass $widget_class, AtkRole $role )

=item GtkWidgetClass $widget_class; class to set the accessible role for
=item AtkRole $role; The role to use for accessibles created for I<widget_class>

=end pod

sub gtk_widget_class_set_accessible_role ( GtkWidgetClass $widget_class, AtkRole $role )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_accessible

Returns the accessible object that describes the widget to an
assistive technology.

If accessibility support is not available, this C<AtkObject>
instance may be a no-op. Likewise, if no class-specific C<AtkObject>
implementation is available for the widget instance in question,
it will inherit an C<AtkObject> implementation from the first ancestor
class for which such an implementation is defined.

The documentation of the
[ATK](http://developer.gnome.org/atk/stable/)
library contains more information about accessible objects and their uses.

Returns: (transfer none): the C<AtkObject> associated with I<widget>

  method gtk_widget_get_accessible ( --> AtkObject  )


=end pod

sub gtk_widget_get_accessible ( N-GObject $widget )
  returns AtkObject
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_halign

Gets the value of the prop C<halign> property.

For backwards compatibility reasons this method will never return
C<GTK_ALIGN_BASELINE>, but instead it will convert it to
C<GTK_ALIGN_FILL>. Baselines are not supported for horizontal
alignment.

Returns: the horizontal alignment of I<widget>

  method gtk_widget_get_halign ( --> GtkAlign  )


=end pod

sub gtk_widget_get_halign ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_halign

Sets the horizontal alignment of I<widget>.
See the prop C<halign> property.

  method gtk_widget_set_halign ( GtkAlign $align )

=item GtkAlign $align; the horizontal alignment

=end pod

sub gtk_widget_set_halign ( N-GObject $widget, int32 $align )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_valign

Gets the value of the prop C<valign> property.

For backwards compatibility reasons this method will never return
C<GTK_ALIGN_BASELINE>, but instead it will convert it to
C<GTK_ALIGN_FILL>. If your widget want to support baseline aligned
children it must use C<gtk_widget_get_valign_with_baseline()>, or
`g_object_get (widget, "valign", &value, NULL)`, which will
also report the true value.

Returns: the vertical alignment of I<widget>, ignoring baseline alignment

  method gtk_widget_get_valign ( --> GtkAlign  )


=end pod

sub gtk_widget_get_valign ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_valign_with_baseline

Gets the value of the prop C<valign> property, including
C<GTK_ALIGN_BASELINE>.

Returns: the vertical alignment of I<widget>

Since: 3.10

  method gtk_widget_get_valign_with_baseline ( --> GtkAlign  )


=end pod

sub gtk_widget_get_valign_with_baseline ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_valign

Sets the vertical alignment of I<widget>.
See the prop C<valign> property.

  method gtk_widget_set_valign ( GtkAlign $align )

=item GtkAlign $align; the vertical alignment

=end pod

sub gtk_widget_set_valign ( N-GObject $widget, int32 $align )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_margin_start

Gets the value of the prop C<margin-start> property.

Returns: The start margin of I<widget>

Since: 3.12

  method gtk_widget_get_margin_start ( --> Int  )


=end pod

sub gtk_widget_get_margin_start ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_margin_start

Sets the start margin of I<widget>.
See the prop C<margin-start> property.

Since: 3.12

  method gtk_widget_set_margin_start ( Int $margin )

=item Int $margin; the start margin

=end pod

sub gtk_widget_set_margin_start ( N-GObject $widget, int32 $margin )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_margin_end

Gets the value of the prop C<margin-end> property.

Returns: The end margin of I<widget>

Since: 3.12

  method gtk_widget_get_margin_end ( --> Int  )


=end pod

sub gtk_widget_get_margin_end ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_margin_end

Sets the end margin of I<widget>.
See the prop C<margin-end> property.

Since: 3.12

  method gtk_widget_set_margin_end ( Int $margin )

=item Int $margin; the end margin

=end pod

sub gtk_widget_set_margin_end ( N-GObject $widget, int32 $margin )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_margin_top

Gets the value of the prop C<margin-top> property.

Returns: The top margin of I<widget>

Since: 3.0

  method gtk_widget_get_margin_top ( --> Int  )


=end pod

sub gtk_widget_get_margin_top ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_margin_top

Sets the top margin of I<widget>.
See the prop C<margin-top> property.

Since: 3.0

  method gtk_widget_set_margin_top ( Int $margin )

=item Int $margin; the top margin

=end pod

sub gtk_widget_set_margin_top ( N-GObject $widget, int32 $margin )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_margin_bottom

Gets the value of the prop C<margin-bottom> property.

Returns: The bottom margin of I<widget>

Since: 3.0

  method gtk_widget_get_margin_bottom ( --> Int  )


=end pod

sub gtk_widget_get_margin_bottom ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_margin_bottom

Sets the bottom margin of I<widget>.
See the prop C<margin-bottom> property.

Since: 3.0

  method gtk_widget_set_margin_bottom ( Int $margin )

=item Int $margin; the bottom margin

=end pod

sub gtk_widget_set_margin_bottom ( N-GObject $widget, int32 $margin )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_events

Returns the event mask (see C<Gnome::Gdk3::EventMask>) for the widget. These are the
events that the widget will receive.

Note: Internally, the widget event mask will be the logical OR of the event
mask set through C<gtk_widget_set_events()> or C<gtk_widget_add_events()>, and the
event mask necessary to cater for every C<Gnome::Gtk3::EventController> created for the
widget.

Returns: event mask for I<widget>

  method gtk_widget_get_events ( --> Int  )


=end pod

sub gtk_widget_get_events ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_device_events

Returns the events mask for the widget corresponding to an specific device. These
are the events that the widget will receive when I<device> operates on it.

Returns: device event mask for I<widget>

Since: 3.0

  method gtk_widget_get_device_events ( N-GObject $device --> GdkEventMask  )

=item N-GObject $device; a C<Gnome::Gdk3::Device>

=end pod

sub gtk_widget_get_device_events ( N-GObject $widget, N-GObject $device )
  returns GdkEventMask
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] is_ancestor

Determines whether I<widget> is somewhere inside I<ancestor>, possibly with
intermediate containers.

Returns: C<1> if I<ancestor> contains I<widget> as a child,
grandchild, great grandchild, etc.

  method gtk_widget_is_ancestor ( N-GObject $ancestor --> Int  )

=item N-GObject $ancestor; another C<Gnome::Gtk3::Widget>

=end pod

sub gtk_widget_is_ancestor ( N-GObject $widget, N-GObject $ancestor )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] translate_coordinates

Translate coordinates relative to I<src_widget>’s allocation to coordinates
relative to I<dest_widget>’s allocations. In order to perform this
operation, both widgets must be realized, and must share a common
toplevel.

Returns: C<0> if either widget was not realized, or there
was no common ancestor. In this case, nothing is stored in
*I<dest_x> and *I<dest_y>. Otherwise C<1>.

  method gtk_widget_translate_coordinates ( N-GObject $dest_widget, Int $src_x, Int $src_y, Int $dest_x, Int $dest_y --> Int  )

=item N-GObject $dest_widget; a C<Gnome::Gtk3::Widget>
=item Int $src_x; X position relative to I<src_widget>
=item Int $src_y; Y position relative to I<src_widget>
=item Int $dest_x; (out) (optional): location to store X position relative to I<dest_widget>
=item Int $dest_y; (out) (optional): location to store Y position relative to I<dest_widget>

=end pod

sub gtk_widget_translate_coordinates ( N-GObject $src_widget, N-GObject $dest_widget, int32 $src_x, int32 $src_y, int32 $dest_x, int32 $dest_y )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] hide_on_delete

Utility function; intended to be connected to the sig C<delete-event>
signal on a C<Gnome::Gtk3::Window>. The function calls C<gtk_widget_hide()> on its
argument, then returns C<1>. If connected to ::delete-event, the
result is that clicking the close button for a window (on the
window frame, top right corner usually) will hide but not destroy
the window. By default, GTK+ destroys windows when ::delete-event
is received.

Returns: C<1>

  method gtk_widget_hide_on_delete ( --> Int  )


=end pod

sub gtk_widget_hide_on_delete ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] reset_style

Updates the style context of I<widget> and all descendants
by updating its widget path. C<Gnome::Gtk3::Containers> may want
to use this on a child when reordering it in a way that a different
style might apply to it. See also C<gtk_container_get_path_for_child()>.

Since: 3.0

  method gtk_widget_reset_style ( )


=end pod

sub gtk_widget_reset_style ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] create_pango_context

Creates a new C<PangoContext> with the appropriate font map,
font options, font description, and base direction for drawing
text for this widget. See also C<gtk_widget_get_pango_context()>.

Returns: (transfer full): the new C<PangoContext>

  method gtk_widget_create_pango_context ( --> PangoContext  )

=end pod

sub gtk_widget_create_pango_context ( N-GObject $widget )
  returns PangoContext
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_pango_context

Gets a C<PangoContext> with the appropriate font map, font description,
and base direction for this widget. Unlike the context returned
by C<gtk_widget_create_pango_context()>, this context is owned by
the widget (it can be used until the screen for the widget changes
or the widget is removed from its toplevel), and will be updated to
match any changes to the widget’s attributes. This can be tracked
by using the sig C<screen-changed> signal on the widget.

Returns: (transfer none): the C<PangoContext> for the widget.

  method gtk_widget_get_pango_context ( --> PangoContext  )


=end pod

sub gtk_widget_get_pango_context ( N-GObject $widget )
  returns PangoContext
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_font_options

Sets the C<cairo_font_options_t> used for Pango rendering in this widget.
When not set, the default font options for the C<Gnome::Gdk3::Screen> will be used.

Since: 3.18

  method gtk_widget_set_font_options ( cairo_font_options_t $options )

=item cairo_font_options_t $options; (allow-none): a C<cairo_font_options_t>, or C<Any> to unset any previously set default font options.

=end pod

sub gtk_widget_set_font_options ( N-GObject $widget, cairo_font_options_t $options )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 cairo_font_options_t



  method cairo_font_options_t (  $*gtk_widget_get_font_options GtkWidget *widget )

=item  $*gtk_widget_get_font_options GtkWidget *widget;

=end pod

sub cairo_font_options_t (  $*gtk_widget_get_font_options GtkWidget *widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] create_pango_layout

Creates a new C<PangoLayout> with the appropriate font map,
font description, and base direction for drawing text for
this widget.

If you keep a C<PangoLayout> created in this way around, you need
to re-create it when the widget C<PangoContext> is replaced.
This can be tracked by using the sig C<screen-changed> signal
on the widget.

Returns: (transfer full): the new C<PangoLayout>

  method gtk_widget_create_pango_layout ( Str $text --> PangoLayout  )

=item Str $text; (nullable): text to set on the layout (can be C<Any>)

=end pod

sub gtk_widget_create_pango_layout ( N-GObject $widget, Str $text )
  returns PangoLayout
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] class_install_style_property

Installs a style property on a widget class. The parser for the
style property is determined by the value type of I<pspec>.

  method gtk_widget_class_install_style_property ( GtkWidgetClass $klass, GParamSpec $pspec )

=item GtkWidgetClass $klass; a C<Gnome::Gtk3::WidgetClass>
=item GParamSpec $pspec; the C<GParamSpec> for the property

=end pod

sub gtk_widget_class_install_style_property ( GtkWidgetClass $klass, GParamSpec $pspec )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] class_install_style_property_parser

Installs a style property on a widget class.

  method gtk_widget_class_install_style_property_parser ( GtkWidgetClass $klass, GParamSpec $pspec, GtkRcPropertyParser $parser )

=item GtkWidgetClass $klass; a C<Gnome::Gtk3::WidgetClass>
=item GParamSpec $pspec; the C<GParamSpec> for the style property
=item GtkRcPropertyParser $parser; the parser for the style property

=end pod

sub gtk_widget_class_install_style_property_parser ( GtkWidgetClass $klass, GParamSpec $pspec, GtkRcPropertyParser $parser )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] class_find_style_property

Finds a style property of a widget class by name.

Returns: (transfer none): the C<GParamSpec> of the style property or
C<Any> if I<class> has no style property with that name.

Since: 2.2

  method gtk_widget_class_find_style_property ( GtkWidgetClass $klass, Str $property_name --> GParamSpec  )

=item GtkWidgetClass $klass; a C<Gnome::Gtk3::WidgetClass>
=item Str $property_name; the name of the style property to find

=end pod

sub gtk_widget_class_find_style_property ( GtkWidgetClass $klass, Str $property_name )
  returns GParamSpec
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] class_list_style_properties

Returns all style properties of a widget class.

Returns: (array length=n_properties) (transfer container): a
newly allocated array of C<GParamSpec>*. The array must be
freed with C<g_free()>.

Since: 2.2

  method gtk_widget_class_list_style_properties ( GtkWidgetClass $klass, UInt $n_properties --> GParamSpec  )

=item GtkWidgetClass $klass; a C<Gnome::Gtk3::WidgetClass>
=item UInt $n_properties; (out): location to return the number of style properties found

=end pod

sub gtk_widget_class_list_style_properties ( GtkWidgetClass $klass, uint32 $n_properties )
  returns GParamSpec
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] style_get_property

Gets the value of a style property of I<widget>.

  method gtk_widget_style_get_property ( Str $property_name, N-GObject $value )

=item Str $property_name; the name of a style property
=item N-GObject $value; location to return the property value

=end pod

sub gtk_widget_style_get_property ( N-GObject $widget, Str $property_name, N-GObject $value )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] style_get_valist

Non-vararg variant of C<gtk_widget_style_get()>. Used primarily by language
bindings.

  method gtk_widget_style_get_valist ( Str $first_property_name, va_list $var_args )

=item Str $first_property_name; the name of the first property to get
=item va_list $var_args; a va_list of pairs of property names and locations to return the property values, starting with the location for I<first_property_name>.

=end pod

sub gtk_widget_style_get_valist ( N-GObject $widget, Str $first_property_name, va_list $var_args )
  is native(&gtk-lib)
  { * }
}}
#`[[
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] style_get

Gets the values of a multiple style properties of I<widget>.

  method gtk_widget_style_get ( Str $first_property_name )

=item Str $first_property_name; the name of the first property to get @...: pairs of property names and locations to return the property values, starting with the location for I<first_property_name>, terminated by C<Any>.

=end pod

sub gtk_widget_style_get ( N-GObject $widget, Str $first_property_name, Any $any = Any )
  is native(&gtk-lib)
  { * }
]]

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_direction

Sets the reading direction on a particular widget. This direction
controls the primary direction for widgets containing text,
and also the direction in which the children of a container are
packed. The ability to set the direction is present in order
so that correct localization into languages with right-to-left
reading directions can be done. Generally, applications will
let the default reading direction present, except for containers
where the containers are arranged in an order that is explicitly
visual rather than logical (such as buttons for text justification).

If the direction is set to C<GTK_TEXT_DIR_NONE>, then the value
set by C<gtk_widget_set_default_direction()> will be used.

  method gtk_widget_set_direction ( GtkTextDirection $dir )

=item GtkTextDirection $dir; the new direction

=end pod

sub gtk_widget_set_direction ( N-GObject $widget, int32 $dir )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_direction

Gets the reading direction for a particular widget. See
C<gtk_widget_set_direction()>.

Returns: the reading direction for the widget.

  method gtk_widget_get_direction ( --> GtkTextDirection  )


=end pod

sub gtk_widget_get_direction ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_default_direction

Sets the default reading direction for widgets where the
direction has not been explicitly set by C<gtk_widget_set_direction()>.

  method gtk_widget_set_default_direction ( GtkTextDirection $dir )

=item GtkTextDirection $dir; the new default direction. This cannot be C<GTK_TEXT_DIR_NONE>.

=end pod

sub gtk_widget_set_default_direction ( int32 $dir )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_default_direction

Obtains the current default reading direction. See
C<gtk_widget_set_default_direction()>.

Returns: the current default direction.

  method gtk_widget_get_default_direction ( --> GtkTextDirection  )


=end pod

sub gtk_widget_get_default_direction (  )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] shape_combine_region

Sets a shape for this widget’s GDK window. This allows for
transparent windows etc., see C<gdk_window_shape_combine_region()>
for more information.

Since: 3.0

  method gtk_widget_shape_combine_region ( cairo_region_t $region )

=item cairo_region_t $region; (allow-none): shape to be added, or C<Any> to remove an existing shape

=end pod

sub gtk_widget_shape_combine_region ( N-GObject $widget, cairo_region_t $region )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] input_shape_combine_region

Sets an input shape for this widget’s GDK window. This allows for
windows which react to mouse click in a nonrectangular region, see
C<gdk_window_input_shape_combine_region()> for more information.

Since: 3.0

  method gtk_widget_input_shape_combine_region ( cairo_region_t $region )

=item cairo_region_t $region; (allow-none): shape to be added, or C<Any> to remove an existing shape

=end pod

sub gtk_widget_input_shape_combine_region ( N-GObject $widget, cairo_region_t $region )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TODO check return type CArray?
=begin pod
=head2 [gtk_widget_] list_mnemonic_labels

Returns a newly allocated list of the widgets, normally labels, for
which this widget is the target of a mnemonic (see for example,
C<gtk_label_set_mnemonic_widget()>).
The widgets in the list are not individually referenced. If you
want to iterate through the list and perform actions involving
callbacks that might destroy the widgets, you
must call `g_list_foreach (result,
(GFunc)g_object_ref, NULL)` first, and then unref all the
widgets afterwards.
Returns: (element-type C<Gnome::Gtk3::Widget>) (transfer container): the list of
mnemonic labels; free this list
with C<g_list_free()> when you are done with it.

Since: 2.4

  method gtk_widget_list_mnemonic_labels ( --> N-GObject  )


=end pod

sub gtk_widget_list_mnemonic_labels ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] add_mnemonic_label

Adds a widget to the list of mnemonic labels for
this widget. (See C<gtk_widget_list_mnemonic_labels()>). Note the
list of mnemonic labels for the widget is cleared when the
widget is destroyed, so the caller must make sure to update
its internal state at this point as well, by using a connection
to the sig C<destroy> signal or a weak notifier.

Since: 2.4

  method gtk_widget_add_mnemonic_label ( N-GObject $label )

=item N-GObject $label; a C<Gnome::Gtk3::Widget> that acts as a mnemonic label for I<widget>

=end pod

sub gtk_widget_add_mnemonic_label ( N-GObject $widget, N-GObject $label )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] remove_mnemonic_label

Removes a widget from the list of mnemonic labels for
this widget. (See C<gtk_widget_list_mnemonic_labels()>). The widget
must have previously been added to the list with
C<gtk_widget_add_mnemonic_label()>.

Since: 2.4

  method gtk_widget_remove_mnemonic_label ( N-GObject $label )

=item N-GObject $label; a C<Gnome::Gtk3::Widget> that was previously set as a mnemonic label for I<widget> with C<gtk_widget_add_mnemonic_label()>.

=end pod

sub gtk_widget_remove_mnemonic_label ( N-GObject $widget, N-GObject $label )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_tooltip_window

Replaces the default, usually yellow, window used for displaying
tooltips with I<custom_window>. GTK+ will take care of showing and
hiding I<custom_window> at the right moment, to behave likewise as
the default tooltip window. If I<custom_window> is C<Any>, the default
tooltip window will be used.

If the custom window should have the default theming it needs to
have the name “gtk-tooltip”, see C<gtk_widget_set_name()>.

Since: 2.12

  method gtk_widget_set_tooltip_window ( N-GObject $custom_window )

=item N-GObject $custom_window; (allow-none): a C<Gnome::Gtk3::Window>, or C<Any>

=end pod

sub gtk_widget_set_tooltip_window ( N-GObject $widget, N-GObject $custom_window )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_tooltip_window

Returns the C<Gnome::Gtk3::Window> of the current tooltip. This can be the
C<Gnome::Gtk3::Window> created by default, or the custom tooltip window set
using C<gtk_widget_set_tooltip_window()>.

Returns: (transfer none): The C<Gnome::Gtk3::Window> of the current tooltip.

Since: 2.12

  method gtk_widget_get_tooltip_window ( --> N-GObject  )


=end pod

sub gtk_widget_get_tooltip_window ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] trigger_tooltip_query

Triggers a tooltip query on the display where the toplevel of I<widget>
is located. See C<gtk_tooltip_trigger_tooltip_query()> for more
information.

Since: 2.12

  method gtk_widget_trigger_tooltip_query ( )


=end pod

sub gtk_widget_trigger_tooltip_query ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_tooltip_text

Sets I<text> as the contents of the tooltip. This function will take
care of setting prop C<has-tooltip> to C<1> and of the default
handler for the sig C<query-tooltip> signal.

See also the prop C<tooltip-text> property and C<gtk_tooltip_set_text()>.

Since: 2.12

  method gtk_widget_set_tooltip_text ( Str $text )

=item Str $text; (allow-none): the contents of the tooltip for I<widget>

=end pod

sub gtk_widget_set_tooltip_text ( N-GObject $widget, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_tooltip_text

Gets the contents of the tooltip for I<widget>.

Returns: (nullable): the tooltip text, or C<Any>. You should free the
returned string with C<g_free()> when done.

Since: 2.12

  method gtk_widget_get_tooltip_text ( --> Str  )


=end pod

sub gtk_widget_get_tooltip_text ( N-GObject $widget )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_tooltip_markup

Sets I<markup> as the contents of the tooltip, which is marked up with
the [Pango text markup language](https://developer.gnome.org/pango/stable/PangoMarkupFormat.html).

This function will take care of setting prop C<has-tooltip> to C<1>
and of the default handler for the sig C<query-tooltip> signal.

See also the prop C<tooltip-markup> property and
C<gtk_tooltip_set_markup()>.

Since: 2.12

  method gtk_widget_set_tooltip_markup ( Str $markup )

=item Str $markup; (allow-none): the contents of the tooltip for I<widget>, or C<Any>

=end pod

sub gtk_widget_set_tooltip_markup ( N-GObject $widget, Str $markup )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_tooltip_markup

Gets the contents of the tooltip for I<widget>.

Returns: (nullable): the tooltip text, or C<Any>. You should free the
returned string with C<g_free()> when done.

Since: 2.12

  method gtk_widget_get_tooltip_markup ( --> Str  )


=end pod

sub gtk_widget_get_tooltip_markup ( N-GObject $widget )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_has_tooltip

Sets the has-tooltip property on I<widget> to I<has_tooltip>.  See
prop C<has-tooltip> for more information.

Since: 2.12

  method gtk_widget_set_has_tooltip ( Int $has_tooltip )

=item Int $has_tooltip; whether or not I<widget> has a tooltip.

=end pod

sub gtk_widget_set_has_tooltip ( N-GObject $widget, int32 $has_tooltip )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_has_tooltip

Returns the current value of the has-tooltip property.  See
prop C<has-tooltip> for more information.

Returns: current value of has-tooltip on I<widget>.

Since: 2.12

  method gtk_widget_get_has_tooltip ( --> Int  )


=end pod

sub gtk_widget_get_has_tooltip ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_cairo_should_draw_window

This function is supposed to be called in sig C<draw>
implementations for widgets that support multiple windows.
I<cr> must be untransformed from invoking of the draw function.
This function will return C<1> if the contents of the given
I<window> are supposed to be drawn and C<0> otherwise. Note
that when the drawing was not initiated by the windowing
system this function will return C<1> for all windows, so
you need to draw the bottommost window first. Also, do not
use “else if” statements to check which window should be drawn.

Returns: C<1> if I<window> should be drawn

Since: 3.0

  method gtk_cairo_should_draw_window ( cairo_t $cr, N-GObject $window --> Int  )

=item cairo_t $cr; a cairo context
=item N-GObject $window; the window to check. I<window> may not be an input-only window.

=end pod

sub gtk_cairo_should_draw_window ( cairo_t $cr, N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_cairo_transform_to_window

Transforms the given cairo context I<cr> that from I<widget>-relative
coordinates to I<window>-relative coordinates.
If the I<widget>’s window is not an ancestor of I<window>, no
modification will be applied.

This is the inverse to the transformation GTK applies when
preparing an expose event to be emitted with the sig C<draw>
signal. It is intended to help porting multiwindow widgets from
GTK+ 2 to the rendering architecture of GTK+ 3.

Since: 3.0

  method gtk_cairo_transform_to_window ( cairo_t $cr, N-GObject $widget, N-GObject $window )

=item cairo_t $cr; the cairo context to transform
=item N-GObject $widget; the widget the context is currently centered for
=item N-GObject $window; the window to transform the context to

=end pod

sub gtk_cairo_transform_to_window ( cairo_t $cr, N-GObject $widget, N-GObject $window )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_requisition_new

Allocates a new C<Gnome::Gtk3::Requisition>-struct and initializes its elements to zero.

Returns: a new empty C<Gnome::Gtk3::Requisition>. The newly allocated C<Gnome::Gtk3::Requisition> should
be freed with C<gtk_requisition_free()>.

Since: 3.0

  method gtk_requisition_new ( --> GtkRequisition  )

=item G_GNUC_MALLO $C;

=end pod

sub gtk_requisition_new ( )
  returns GtkRequisition
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_requisition_copy

Copies a C<Gnome::Gtk3::Requisition>.

Returns: a copy of I<requisition>

  method gtk_requisition_copy ( GtkRequisition $requisition --> GtkRequisition  )

=item GtkRequisition $requisition; a C<Gnome::Gtk3::Requisition>

=end pod

sub gtk_requisition_copy ( GtkRequisition $requisition )
  returns GtkRequisition
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_requisition_free

Frees a C<Gnome::Gtk3::Requisition>.

  method gtk_requisition_free ( GtkRequisition $requisition )

=item GtkRequisition $requisition; a C<Gnome::Gtk3::Requisition>

=end pod

sub gtk_requisition_free ( GtkRequisition $requisition )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] in_destruction

Returns whether the widget is currently being destroyed.
This information can sometimes be used to avoid doing
unnecessary work.

Returns: C<1> if I<widget> is being destroyed

  method gtk_widget_in_destruction ( --> Int  )


=end pod

sub gtk_widget_in_destruction ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_style_context

Returns the style context associated to I<widget>. The returned object is
guaranteed to be the same for the lifetime of I<widget>.

Returns: (transfer none): a C<Gnome::Gtk3::StyleContext>. This memory is owned by I<widget> and
must not be freed.

  method gtk_widget_get_style_context ( --> N-GObject  )


=end pod

sub gtk_widget_get_style_context ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_path

Returns the C<Gnome::Gtk3::WidgetPath> representing I<widget>, if the widget
is not connected to a toplevel widget, a partial path will be
created.

Returns: (transfer none): The C<Gnome::Gtk3::WidgetPath> representing I<widget>

  method gtk_widget_get_path ( --> N-GObject  )


=end pod

sub gtk_widget_get_path ( N-GObject $widget )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] class_set_css_name

Sets the name to be used for CSS matching of widgets.

If this function is not called for a given class, the name
of the parent class is used.

Since: 3.20

  method gtk_widget_class_set_css_name ( GtkWidgetClass $widget_class, char $name )

=item GtkWidgetClass $widget_class; class to set the name on
=item char $name; name to use

=end pod

sub gtk_widget_class_set_css_name ( GtkWidgetClass $widget_class, char $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 char



  method char (  $* gtk_widget_class_get_css_name GtkWidgetClass *widget_class )

=item  $* gtk_widget_class_get_css_name GtkWidgetClass *widget_class;

=end pod

sub char (  $* gtk_widget_class_get_css_name GtkWidgetClass *widget_class )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_modifier_mask

Returns the modifier mask the I<widget>’s windowing system backend
uses for a particular purpose.

See C<gdk_keymap_get_modifier_mask()>.

Returns: the modifier mask used for I<intent>.

Since: 3.4

  method gtk_widget_get_modifier_mask ( GdkModifierIntent $intent --> GdkModifierType  )

=item GdkModifierIntent $intent; the use case for the modifier mask

=end pod

sub gtk_widget_get_modifier_mask ( N-GObject $widget, GdkModifierIntent $intent )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] insert_action_group

Inserts I<group> into I<widget>. Children of I<widget> that implement
C<Gnome::Gtk3::Actionable> can then be associated with actions in I<group> by
setting their “action-name” to
I<prefix>.`action-name`.

If I<group> is C<Any>, a previously inserted group for I<name> is removed
from I<widget>.

Since: 3.6

  method gtk_widget_insert_action_group ( Str $name, N-GObject $group )

=item Str $name; the prefix for actions in I<group>
=item N-GObject $group; (allow-none): a C<GActionGroup>, or C<Any>

=end pod

sub gtk_widget_insert_action_group ( N-GObject $widget, Str $name, N-GObject $group )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] add_tick_callback

Queues an animation frame update and adds a callback to be called
before each frame. Until the tick callback is removed, it will be
called frequently (usually at the frame rate of the output device
or as quickly as the application can be repainted, whichever is
slower). For this reason, is most suitable for handling graphics
that change every frame or every few frames. The tick callback does
not automatically imply a relayout or repaint. If you want a
repaint or relayout, and aren’t changing widget properties that
would trigger that (for example, changing the text of a C<Gnome::Gtk3::Label>),
then you will have to call C<gtk_widget_queue_resize()> or
C<gtk_widget_queue_draw_area()> yourself.

C<gdk_frame_clock_get_frame_time()> should generally be used for timing
continuous animations and
C<gdk_frame_timings_get_predicted_presentation_time()> if you are
trying to display isolated frames at particular times.

This is a more convenient alternative to connecting directly to the
sig C<update> signal of C<Gnome::Gdk3::FrameClock>, since you don't
have to worry about when a C<Gnome::Gdk3::FrameClock> is assigned to a widget.

Returns: an id for the connection of this callback. Remove the callback
by passing it to C<gtk_widget_remove_tick_callback()>

Since: 3.8

  method gtk_widget_add_tick_callback ( GtkTickCallback $callback, Pointer $user_data, GDestroyNotify $notify --> UInt  )

=item GtkTickCallback $callback; function to call for updating animations
=item Pointer $user_data; data to pass to I<callback>
=item GDestroyNotify $notify; function to call to free I<user_data> when the callback is removed.

=end pod

sub gtk_widget_add_tick_callback ( N-GObject $widget, GtkTickCallback $callback, Pointer $user_data, GDestroyNotify $notify )
  returns uint32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] remove_tick_callback

Removes a tick callback previously registered with
C<gtk_widget_add_tick_callback()>.

Since: 3.8

  method gtk_widget_remove_tick_callback ( UInt $id )

=item UInt $id; an id returned by C<gtk_widget_add_tick_callback()>

=end pod

sub gtk_widget_remove_tick_callback ( N-GObject $widget, uint32 $id )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] init_template

Creates and initializes child widgets defined in templates. This
function must be called in the instance initializer for any
class which assigned itself a template using C<gtk_widget_class_set_template()>

It is important to call this function in the instance initializer
of a C<Gnome::Gtk3::Widget> subclass and not in C<GObject>.C<constructed()> or
C<GObject>.C<constructor()> for two reasons.

One reason is that generally derived widgets will assume that parent
class composite widgets have been created in their instance
initializers.

Another reason is that when calling C<g_object_new()> on a widget with
composite templates, it’s important to build the composite widgets
before the construct properties are set. Properties passed to C<g_object_new()>
should take precedence over properties set in the private template XML.

Since: 3.10

  method gtk_widget_init_template ( )


=end pod

sub gtk_widget_init_template ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_template_child

Fetch an object build from the template XML for I<widget_type> in this I<widget> instance.

This will only report children which were previously declared with
C<gtk_widget_class_bind_template_child_full()> or one of its
variants.

This function is only meant to be called for code which is private to the I<widget_type> which
declared the child and is meant for language bindings which cannot easily make use
of the GObject structure offsets.

Returns: (transfer none): The object built in the template XML with the id I<name>

  method gtk_widget_get_template_child ( N-GObject $widget_type, Str $name --> N-GObject  )

=item N-GObject $widget_type; The C<GType> to get a template child for
=item Str $name; The “id” of the child defined in the template XML

=end pod

sub gtk_widget_get_template_child ( N-GObject $widget, N-GObject $widget_type, Str $name )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] class_set_template

This should be called at class initialization time to specify
the C<Gnome::Gtk3::Builder> XML to be used to extend a widget.

For convenience, C<gtk_widget_class_set_template_from_resource()> is also provided.

Note that any class that installs templates must call C<gtk_widget_init_template()>
in the widget’s instance initializer.

Since: 3.10

  method gtk_widget_class_set_template ( GtkWidgetClass $widget_class, N-GObject $template_bytes )

=item GtkWidgetClass $widget_class; A C<Gnome::Gtk3::WidgetClass>
=item N-GObject $template_bytes; A C<GBytes> holding the C<Gnome::Gtk3::Builder> XML

=end pod

sub gtk_widget_class_set_template ( GtkWidgetClass $widget_class, N-GObject $template_bytes )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] class_set_template_from_resource

A convenience function to call C<gtk_widget_class_set_template()>.

Note that any class that installs templates must call C<gtk_widget_init_template()>
in the widget’s instance initializer.

Since: 3.10

  method gtk_widget_class_set_template_from_resource ( GtkWidgetClass $widget_class, Str $resource_name )

=item GtkWidgetClass $widget_class; A C<Gnome::Gtk3::WidgetClass>
=item Str $resource_name; The name of the resource to load the template from

=end pod

sub gtk_widget_class_set_template_from_resource ( GtkWidgetClass $widget_class, Str $resource_name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] class_bind_template_callback_full

Declares a I<callback_symbol> to handle I<callback_name> from the template XML
defined for I<widget_type>. See C<gtk_builder_add_callback_symbol()>.

Note that this must be called from a composite widget classes class
initializer after calling C<gtk_widget_class_set_template()>.

Since: 3.10

  method gtk_widget_class_bind_template_callback_full ( GtkWidgetClass $widget_class, Str $callback_name, GCallback $callback_symbol )

=item GtkWidgetClass $widget_class; A C<Gnome::Gtk3::WidgetClass>
=item Str $callback_name; The name of the callback as expected in the template XML
=item GCallback $callback_symbol; (scope async): The callback symbol

=end pod

sub gtk_widget_class_bind_template_callback_full ( GtkWidgetClass $widget_class, Str $callback_name, GCallback $callback_symbol )
  is native(&gtk-lib)
  { * }


#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] class_set_connect_func

For use in language bindings, this will override the default C<Gnome::Gtk3::BuilderConnectFunc> to be
used when parsing C<Gnome::Gtk3::Builder> XML from this class’s template data.

Note that this must be called from a composite widget classes class
initializer after calling C<gtk_widget_class_set_template()>.

Since: 3.10

  method gtk_widget_class_set_connect_func ( GtkWidgetClass $widget_class, GtkBuilderConnectFunc $connect_func, Pointer $connect_data, GDestroyNotify $connect_data_destroy )

=item GtkWidgetClass $widget_class; A C<Gnome::Gtk3::WidgetClass>
=item GtkBuilderConnectFunc $connect_func; The C<Gnome::Gtk3::BuilderConnectFunc> to use when connecting signals in the class template
=item Pointer $connect_data; The data to pass to I<connect_func>
=item GDestroyNotify $connect_data_destroy; The C<GDestroyNotify> to free I<connect_data>, this will only be used at class finalization time, when no classes of type I<widget_type> are in use anymore.

=end pod

sub gtk_widget_class_set_connect_func ( GtkWidgetClass $widget_class, GtkBuilderConnectFunc $connect_func, Pointer $connect_data, GDestroyNotify $connect_data_destroy )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] class_bind_template_child_full

Automatically assign an object declared in the class template XML to be set to a location
on a freshly built instance’s private data, or alternatively accessible via C<gtk_widget_get_template_child()>.

The struct can point either into the public instance, then you should use G_STRUCT_OFFSET(WidgetType, member)
for I<struct_offset>,  or in the private struct, then you should use G_PRIVATE_OFFSET(WidgetType, member).

An explicit strong reference will be held automatically for the duration of your
instance’s life cycle, it will be released automatically when C<GObjectClass>.C<dispose()> runs
on your instance and if a I<struct_offset> that is != 0 is specified, then the automatic location
in your instance public or private data will be set to C<Any>. You can however access an automated child
pointer the first time your classes C<GObjectClass>.C<dispose()> runs, or alternatively in
C<Gnome::Gtk3::WidgetClass>.C<destroy()>.

If I<internal_child> is specified, C<Gnome::Gtk3::BuildableIface>.C<get_internal_child()> will be automatically
implemented by the C<Gnome::Gtk3::Widget> class so there is no need to implement it manually.

The wrapper macros C<gtk_widget_class_bind_template_child()>, C<gtk_widget_class_bind_template_child_internal()>,
C<gtk_widget_class_bind_template_child_private()> and C<gtk_widget_class_bind_template_child_internal_private()>
might be more convenient to use.

Note that this must be called from a composite widget classes class
initializer after calling C<gtk_widget_class_set_template()>.

Since: 3.10

  method gtk_widget_class_bind_template_child_full ( GtkWidgetClass $widget_class, Str $name, Int $internal_child, Int $struct_offset )

=item GtkWidgetClass $widget_class; A C<Gnome::Gtk3::WidgetClass>
=item Str $name; The “id” of the child defined in the template XML
=item Int $internal_child; Whether the child should be accessible as an “internal-child” when this class is used in C<Gnome::Gtk3::Builder> XML
=item Int $struct_offset; The structure offset into the composite widget’s instance public or private structure where the automated child pointer should be set, or 0 to not assign the pointer.

=end pod

sub gtk_widget_class_bind_template_child_full ( GtkWidgetClass $widget_class, Str $name, int32 $internal_child, int64 $struct_offset )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_action_group

Retrieves the C<GActionGroup> that was registered using I<prefix>. The resulting
C<GActionGroup> may have been registered to I<widget> or any C<Gnome::Gtk3::Widget> in its
ancestry.

If no action group was found matching I<prefix>, then C<Any> is returned.

Returns: (transfer none) (nullable): A C<GActionGroup> or C<Any>.

Since: 3.16

  method gtk_widget_get_action_group ( Str $prefix --> N-GObject  )

=item Str $prefix; The “prefix” of the action group.

=end pod

sub gtk_widget_get_action_group ( N-GObject $widget, Str $prefix )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] list_action_prefixes

Retrieves a %NULL-terminated array of strings containing the prefixes of
 * #GActionGroup's available to @widget.


  method gtk_widget_list_action_prefixes( --> Array[Str] )

Returns: a C<Any> terminated array of strings.

Since: 3.16

=end pod

sub gtk_widget_list_action_prefixes( N-GObject $widget )
  returns CArray[Str]
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_font_map

Sets the font map to use for Pango rendering. When not set, the widget
will inherit the font map from its parent.

Since: 3.18

  method gtk_widget_set_font_map ( PangoFontMap $font_map )

=item PangoFontMap $font_map; (allow-none): a C<PangoFontMap>, or C<Any> to unset any previously set font map

=end pod

sub gtk_widget_set_font_map ( N-GObject $widget, PangoFontMap $font_map )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_font_map

Gets the font map that has been set with C<gtk_widget_set_font_map()>.

Returns: (transfer none) (nullable): A C<PangoFontMap>, or C<Any>

Since: 3.18

  method gtk_widget_get_font_map ( --> PangoFontMap  )


=end pod

sub gtk_widget_get_font_map ( N-GObject $widget )
  returns PangoFontMap
  is native(&gtk-lib)
  { * }

}}

#-------------------------------------------------------------------------------
=begin pod
=head1 List of deprecated (not implemented!) methods

=head2 Since 3.0
=head3 method gtk_widget_size_request ( GtkRequisition $requisition )
=head3 method gtk_widget_get_child_requisition ( GtkRequisition $requisition )
=head3 method gtk_widget_set_state ( GtkStateType $state )
=head3 method gtk_widget_get_state ( --> GtkStateType  )
=head3 method void (  $
gtk_widget_get_requisition        GtkWidget     *widget, GtkRequisition $requisition )

=head2 Since 3.4
=head3 method gtk_widget_get_pointer ( Int $x, Int $y )

=head2 Since 3.10
=head3 method gtk_widget_render_icon_pixbuf ( Str $stock_id, GtkIconSize $size --> N-GObject  )
=head3 method gtk_widget_set_composite_name ( Str $name )
=head3 method gtk_widget_get_composite_name ( --> Str  )
=head3 method gtk_widget_push_composite_child ( )
=head3 method gtk_widget_pop_composite_child ( )

=head2 Since 3.12
=head3 method gtk_widget_get_root_window ( --> N-GObject  )
=head3 method gtk_widget_get_margin_left ( --> Int  )
=head3 method gtk_widget_set_margin_left ( Int $margin )
=head3 method gtk_widget_get_margin_right ( --> Int  )
=head3 method gtk_widget_set_margin_right ( Int $margin )

=head2 Since 3.14
=head3 method gtk_widget_reparent ( N-GObject $new_parent )
=head3 method gtk_widget_region_intersect ( cairo_region_t $region --> cairo_region_t  )
=head3 method gtk_widget_set_double_buffered ( Int $double_buffered )
=head3 method gtk_widget_get_double_buffered ( --> Int  )

=head2 Since 3.16
=head3 method gtk_widget_override_color ( GtkStateFlags $state, N-GObject $color )
=head3 method gtk_widget_override_background_color ( GtkStateFlags $state, N-GObject $color )
=head3 method gtk_widget_override_font ( PangoFontDescription $font_desc )
=head3 method gtk_widget_override_symbolic_color ( Str $name, N-GObject $color )
=head3 method gtk_widget_override_cursor ( N-GObject $cursor, N-GObject $secondary_cursor )

=head2 Since 3.22
=head3 method gtk_widget_send_expose ( GdkEvent $event --> Int  )
=head3 method gtk_widget_is_composited ( --> Int  )
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 List of not yet implemented methods and classes

=head3 class GtkTickCallback

=head3 method gtk_widget_new (...)
=head3 method gtk_widget_draw (...)
=head3 method gtk_widget_queue_draw_region (...)
=head3 method gtk_widget_set_font_options (...)
=head3 method cairo_font_options_t (...)
=head3 method gtk_widget_create_pango_layout (...)
=head3 method gtk_widget_class_install_style_property (...)
=head3 method gtk_widget_class_install_style_property_parser (...)
=head3 method gtk_widget_class_find_style_property (...)
=head3 method gtk_widget_class_list_style_properties (...)
=head3 method gtk_widget_style_get_property (...)
=head3 method gtk_widget_shape_combine_region (...)
=head3 method gtk_widget_input_shape_combine_region (...)
=head3 method gtk_cairo_should_draw_window (...)
=head3 method gtk_cairo_transform_to_window (...)
=head3 method gtk_widget_create_pango_context (...)
=head3 method gtk_widget_get_pango_context (...)
=head3 method gtk_widget_set_font_map (...)
=head3 method gtk_widget_get_font_map (...)
=head3 gtk_widget_add_accelerator (...)
gtk_widget_set_device_events
gtk_widget_add_device_events
gtk_widget_get_device_events
gtk_widget_get_clipboard
gtk_widget_class_set_accessible_type
gtk_widget_class_set_accessible_role
gtk_widget_class_set_css_name
gtk_widget_class_get_css_name
gtk_widget_class_set_template
gtk_widget_class_set_template_from_resource
gtk_widget_class_bind_template_callback_full
gtk_widget_class_set_connect_func
gtk_widget_class_bind_template_child_full
gtk_widget_get_accessible
gtk_widget_style_get_valist
gtk_requisition_new
gtk_requisition_copy
gtk_requisition_free
gtk_widget_get_modifier_mask
gtk_widget_add_tick_callback

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Register any signal as follows. See also C<Gnome::GObject::Object>.

  my Bool $is-registered = $my-widget.register-signal (
    $handler-object, $handler-name, $signal-name,
    :$user-option1, ..., :$user-optionN
  )

=head2 Supported signals

=head3 accel-closures-changed

  method handler (
    Gnome::GObject::Object :widget($widget),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=head3 destroy

Signals that all holders of a reference to the widget should release
the reference that they hold. May result in finalization of the widget
if all references are released.

This signal is not suitable for saving widget state.

  method handler (
    Gnome::GObject::Object :widget($object),
    :$user-option1, ..., :$user-optionN
  );

=item $object; the object which received the signal

=head3 grab-focus

  method handler (
    Gnome::GObject::Object :widget($widget),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=head3 hide

The ::hide signal is emitted when I<widget> is hidden, for example with
C<gtk_widget_hide()>.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=head3 map

The ::map signal is emitted when I<widget> is going to be mapped, that is
when the widget is visible (which is controlled with
C<gtk_widget_set_visible()>) and all its parents up to the toplevel widget
are also visible. Once the map has occurred, sig C<map-event> will
be emitted.

The ::map signal can be used to determine whether a widget will be drawn,
for instance it can resume an animation that was stopped during the
emission of sig C<unmap>.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.


=head3 popup-menu

This signal gets emitted whenever a widget should pop up a context
menu. This usually happens through the standard key binding mechanism;
by pressing a certain key while a widget is focused, the user can cause
the widget to pop up a menu.  For example, the C<Gnome::Gtk3::Entry> widget creates
a menu with clipboard commands. See the
[Popup Menu Migration Checklist][checklist-popup-menu]
for an example of how to use this signal.

Returns: C<1> if a menu was activated

  method handler (
    Gnome::GObject::Object :widget($widget),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal


=head3 realize

The ::realize signal is emitted when I<widget> is associated with a
C<Gnome::Gdk3::Window>, which means that C<gtk_widget_realize()> has been called or the
widget has been mapped (that is, it is going to be drawn).

  method handler (
    Gnome::GObject::Object :widget($widget),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=head3 show

The ::show signal is emitted when I<widget> is shown, for example with
C<gtk_widget_show()>.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=head3 style-updated

The ::style-updated signal is a convenience signal that is emitted when the
sig C<changed> signal is emitted on the I<widget>'s associated
C<Gnome::Gtk3::StyleContext> as returned by C<gtk_widget_get_style_context()>.

Note that style-modifying functions like C<gtk_widget_override_color()> also
cause this signal to be emitted.

Since: 3.0

  method handler (
    Gnome::GObject::Object :widget($widget),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object on which the signal is emitted

=head3 unmap

The ::unmap signal is emitted when I<widget> is going to be unmapped, which
means that either it or any of its parents up to the toplevel widget have
been set as hidden.

As ::unmap indicates that a widget will not be shown any longer, it can be
used to, for example, stop an animation on the widget.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=head3 unrealize

The ::unrealize signal is emitted when the C<Gnome::Gdk3::Window> associated with
I<widget> is destroyed, which means that C<gtk_widget_unrealize()> has been
called or the widget has been unmapped (that is, it is going to be
hidden).

  method handler (
    Gnome::GObject::Object :widget($widget),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.



=head2 Not yet supported signals

=head3 size-allocate

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($allocation),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $allocation; (type C<Gnome::Gtk3::.Allocation>): the region which has been
allocated to the widget.



=head3 state-flags-changed

The ::state-flags-changed signal is emitted when the widget state
changes, see C<gtk_widget_get_state_flags()>.

Since: 3.0

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($flags),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $flags; The previous state flags.


=head3 parent-set

The ::parent-set signal is emitted when a new parent
has been set on a widget.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($old_parent),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object on which the signal is emitted

=item $old_parent; (allow-none): the previous parent, or C<Any> if the widget
just got its initial parent.


=head3 hierarchy-changed

The ::hierarchy-changed signal is emitted when the
anchored state of a widget changes. A widget is
“anchored” when its toplevel
ancestor is a C<Gnome::Gtk3::Window>. This signal is emitted when
a widget changes from un-anchored to anchored or vice-versa.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($previous_toplevel),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object on which the signal is emitted

=item $previous_toplevel; (allow-none): the previous toplevel ancestor, or C<Any>
if the widget was previously unanchored



=head3 direction-changed

The ::direction-changed signal is emitted when the text direction
of a widget changes.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($previous_direction),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object on which the signal is emitted

=item $previous_direction; the previous text direction of I<widget>


=head3 grab-notify

The ::grab-notify signal is emitted when a widget becomes
shadowed by a GTK+ grab (not a pointer or keyboard grab) on
another widget, or when it becomes unshadowed due to a grab
being removed.

A widget is shadowed by a C<gtk_grab_add()> when the topmost
grab widget in the grab stack of its window group is not
its ancestor.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($was_grabbed),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $was_grabbed; C<0> if the widget becomes shadowed, C<1>
if it becomes unshadowed


=head3 child-notify

The ::child-notify signal is emitted for each
[child property][child-properties]  that has
changed on an object. The signal's detail holds the property name.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($child_property),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $child_property; the C<GParamSpec> of the changed child property


=head3 draw

This signal is emitted when a widget is supposed to render itself.
The I<widget>'s top left corner must be painted at the origin of
the passed in context and be sized to the values returned by
C<gtk_widget_get_allocated_width()> and
C<gtk_widget_get_allocated_height()>.

Signal handlers connected to this signal can modify the cairo
context passed as I<cr> in any way they like and don't need to
restore it. The signal emission takes care of calling C<cairo_save()>
before and C<cairo_restore()> after invoking the handler.

The signal handler will get a I<cr> with a clip region already set to the
widget's dirty region, i.e. to the area that needs repainting.  Complicated
widgets that want to avoid redrawing themselves completely can get the full
extents of the clip region with C<gdk_cairo_get_clip_rectangle()>, or they can
get a finer-grained representation of the dirty region with
C<cairo_copy_clip_rectangle_list()>.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

Since: 3.0

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($cr),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $cr; the cairo context to draw to


=head3 mnemonic-activate

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($arg1),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $arg1;



=head3 focus

Returns: C<1> to stop other handlers from being invoked for the event. C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($direction),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $direction;


=head3 move-focus

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($direction),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $direction;


=head3 keynav-failed

Gets emitted if keyboard navigation fails.
See C<gtk_widget_keynav_failed()> for details.

Returns: C<1> if stopping keyboard navigation is fine, C<0>
if the emitting widget should try to handle the keyboard
navigation attempt in its parent container(s).

Since: 2.12

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($direction),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $direction; the direction of movement


=head3 event

The GTK+ main loop will emit three signals for each GDK event delivered
to a widget: one generic ::event signal, another, more specific,
signal that matches the type of event delivered (e.g.
sig C<key-press-event>) and finally a generic
sig C<event-after> signal.

Returns: C<1> to stop other handlers from being invoked for the event
and to cancel the emission of the second specific ::event signal.
C<0> to propagate the event further and to allow the emission of
the second signal. The ::event-after signal is emitted regardless of
the return value.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $event; the C<Gnome::Gdk3::Event> which triggered this signal


=head3 event-after

After the emission of the sig C<event> signal and (optionally)
the second more specific signal, ::event-after will be emitted
regardless of the previous two signals handlers return values.


  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $event; the C<Gnome::Gdk3::Event> which triggered this signal


=head3 button-press-event

The ::button-press-event signal will be emitted when a button
(typically from a mouse) is pressed.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the
widget needs to enable the C<GDK_BUTTON_PRESS_MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $event; (type C<Gnome::Gdk3::.EventButton>): the C<Gnome::Gdk3::EventButton> which triggered
this signal.


=head3 button-release-event

The ::button-release-event signal will be emitted when a button
(typically from a mouse) is released.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the
widget needs to enable the C<GDK_BUTTON_RELEASE_MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $event; (type C<Gnome::Gdk3::.EventButton>): the C<Gnome::Gdk3::EventButton> which triggered
this signal.


=head3 scroll-event

The ::scroll-event signal is emitted when a button in the 4 to 7
range is pressed. Wheel mice are usually configured to generate
button press events for buttons 4 and 5 when the wheel is turned.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_SCROLL_MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $event; (type C<Gnome::Gdk3::.EventScroll>): the C<Gnome::Gdk3::EventScroll> which triggered
this signal.


=head3 motion-notify-event

The ::motion-notify-event signal is emitted when the pointer moves
over the widget's C<Gnome::Gdk3::Window>.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the widget
needs to enable the C<GDK_POINTER_MOTION_MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $event; (type C<Gnome::Gdk3::.EventMotion>): the C<Gnome::Gdk3::EventMotion> which triggered
this signal.



=head3 delete-event

The ::delete-event signal is emitted if a user requests that
a toplevel window is closed. The default handler for this signal
destroys the window. Connecting C<gtk_widget_hide_on_delete()> to
this signal will cause the window to be hidden instead, so that
it can later be shown again without reconstructing it.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; the event which triggered this signal


=head3 destroy-event

The ::destroy-event signal is emitted when a C<Gnome::Gdk3::Window> is destroyed.
You rarely get this signal, because most widgets disconnect themselves
from their window before they destroy it, so no widget owns the
window at destroy time.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_STRUCTURE_MASK> mask. GDK will enable this mask
automatically for all new windows.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $event; the event which triggered this signal


=head3 key-press-event

The ::key-press-event signal is emitted when a key is pressed. The signal
emission will reoccur at the key-repeat rate when the key is kept pressed.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_KEY_PRESS_MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventKey>): the C<Gnome::Gdk3::EventKey> which triggered this signal.


=head3 key-release-event

The ::key-release-event signal is emitted when a key is released.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_KEY_RELEASE_MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventKey>): the C<Gnome::Gdk3::EventKey> which triggered this signal.


=head3 enter-notify-event

The ::enter-notify-event will be emitted when the pointer enters
the I<widget>'s window.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_ENTER_NOTIFY_MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventCrossing>): the C<Gnome::Gdk3::EventCrossing> which triggered
this signal.


=head3 leave-notify-event

The ::leave-notify-event will be emitted when the pointer leaves
the I<widget>'s window.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_LEAVE_NOTIFY_MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventCrossing>): the C<Gnome::Gdk3::EventCrossing> which triggered
this signal.


=head3 configure-event

The ::configure-event signal will be emitted when the size, position or
stacking of the I<widget>'s window has changed.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_STRUCTURE_MASK> mask. GDK will enable this mask
automatically for all new windows.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventConfigure>): the C<Gnome::Gdk3::EventConfigure> which triggered
this signal.


=head3 focus-in-event

The ::focus-in-event signal will be emitted when the keyboard focus
enters the I<widget>'s window.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_FOCUS_CHANGE_MASK> mask.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventFocus>): the C<Gnome::Gdk3::EventFocus> which triggered
this signal.


=head3 focus-out-event

The ::focus-out-event signal will be emitted when the keyboard focus
leaves the I<widget>'s window.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_FOCUS_CHANGE_MASK> mask.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventFocus>): the C<Gnome::Gdk3::EventFocus> which triggered this
signal.


=head3 map-event

The ::map-event signal will be emitted when the I<widget>'s window is
mapped. A window is mapped when it becomes visible on the screen.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_STRUCTURE_MASK> mask. GDK will enable this mask
automatically for all new windows.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventAny>): the C<Gnome::Gdk3::EventAny> which triggered this signal.


=head3 unmap-event

The ::unmap-event signal will be emitted when the I<widget>'s window is
unmapped. A window is unmapped when it becomes invisible on the screen.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_STRUCTURE_MASK> mask. GDK will enable this mask
automatically for all new windows.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventAny>): the C<Gnome::Gdk3::EventAny> which triggered this signal


=head3 property-notify-event

The ::property-notify-event signal will be emitted when a property on
the I<widget>'s window has been changed or deleted.

To receive this signal, the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_PROPERTY_CHANGE_MASK> mask.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventProperty>): the C<Gnome::Gdk3::EventProperty> which triggered
this signal.


=head3 selection-clear-event

The ::selection-clear-event signal will be emitted when the
the I<widget>'s window has lost ownership of a selection.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventSelection>): the C<Gnome::Gdk3::EventSelection> which triggered
this signal.


=head3 selection-request-event

The ::selection-request-event signal will be emitted when
another client requests ownership of the selection owned by
the I<widget>'s window.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventSelection>): the C<Gnome::Gdk3::EventSelection> which triggered
this signal.


=head3 selection-notify-event

Returns: C<1> to stop other handlers from being invoked for the event. C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $event; (type C<Gnome::Gdk3::.EventSelection>):


=head3 selection-received

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($data),
    :handle-arg1($time),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $data;

=item $time;


=head3 selection-get

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($data),
    :handle-arg1($info),
    :handle-arg2($time),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $data;

=item $info;

=item $time;


=head3 proximity-in-event

To receive this signal the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_PROXIMITY_IN_MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventProximity>): the C<Gnome::Gdk3::EventProximity> which triggered
this signal.


=head3 proximity-out-event

To receive this signal the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_PROXIMITY_OUT_MASK> mask.

This signal will be sent to the grab widget if there is one.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventProximity>): the C<Gnome::Gdk3::EventProximity> which triggered
this signal.


=head3 drag-leave

The ::drag-leave signal is emitted on the drop site when the cursor
leaves the widget. A typical reason to connect to this signal is to
undo things done in sig C<drag-motion>, e.g. undo highlighting
with C<gtk_drag_unhighlight()>.


Likewise, the sig C<drag-leave> signal is also emitted before the
::drag-drop signal, for instance to allow cleaning up of a preview item
created in the sig C<drag-motion> signal handler.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($context),
    :handle-arg1($time),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $context; the drag context

=item $time; the timestamp of the motion event


=head3 drag-begin

The ::drag-begin signal is emitted on the drag source when a drag is
started. A typical reason to connect to this signal is to set up a
custom drag icon with e.g. C<gtk_drag_source_set_icon_pixbuf()>.

Note that some widgets set up a drag icon in the default handler of
this signal, so you may have to use C<g_signal_connect_after()> to
override what the default handler did.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($context),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $context; the drag context


=head3 drag-end

The ::drag-end signal is emitted on the drag source when a drag is
finished.  A typical reason to connect to this signal is to undo
things done in sig C<drag-begin>.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($context),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $context; the drag context


=head3 drag-data-delete

The ::drag-data-delete signal is emitted on the drag source when a drag
with the action C<GDK_ACTION_MOVE> is successfully completed. The signal
handler is responsible for deleting the data that has been dropped. What
"delete" means depends on the context of the drag operation.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($context),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $context; the drag context


=head3 drag-failed

The ::drag-failed signal is emitted on the drag source when a drag has
failed. The signal handler may hook custom code to handle a failed DnD
operation based on the type of error, it returns C<1> is the failure has
been already handled (not showing the default "drag operation failed"
animation), otherwise it returns C<0>.

Returns: C<1> if the failed drag operation has been already handled.

Since: 2.12

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($context),
    :handle-arg1($result),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $context; the drag context

=item $result; the result of the drag operation


=head3 drag-motion

The ::drag-motion signal is emitted on the drop site when the user
moves the cursor over the widget during a drag. The signal handler
must determine whether the cursor position is in a drop zone or not.
If it is not in a drop zone, it returns C<0> and no further processing
is necessary. Otherwise, the handler returns C<1>. In this case, the
handler is responsible for providing the necessary information for
displaying feedback to the user, by calling C<gdk_drag_status()>.

If the decision whether the drop will be accepted or rejected can't be
made based solely on the cursor position and the type of the data, the
handler may inspect the dragged data by calling C<gtk_drag_get_data()> and
defer the C<gdk_drag_status()> call to the sig C<drag-data-received>
handler. Note that you must pass C<GTK_DEST_DEFAULT_DROP>,
C<GTK_DEST_DEFAULT_MOTION> or C<GTK_DEST_DEFAULT_ALL> to C<gtk_drag_dest_set()>
when using the drag-motion signal that way.

Also note that there is no drag-enter signal. The drag receiver has to
keep track of whether he has received any drag-motion signals since the
last sig C<drag-leave> and if not, treat the drag-motion signal as
an "enter" signal. Upon an "enter", the handler will typically highlight
the drop site with C<gtk_drag_highlight()>.
|[<!-- language="C" -->
static void
drag_motion (C<Gnome::Gtk3::Widget>      *widget,
C<Gnome::Gdk3::DragContext> *context,
gint            x,
gint            y,
guint           time)
{
C<Gnome::Gdk3::Atom> target;

PrivateData *private_data = GET_PRIVATE_DATA (widget);

if (!private_data->drag_highlight)
{
private_data->drag_highlight = 1;
gtk_drag_highlight (widget);
}

target = gtk_drag_dest_find_target (widget, context, NULL);
if (target == GDK_NONE)
gdk_drag_status (context, 0, time);
else
{
private_data->pending_status
= gdk_drag_context_get_suggested_action (context);
gtk_drag_get_data (widget, context, target, time);
}

return TRUE;
}

static void
drag_data_received (C<Gnome::Gtk3::Widget>        *widget,
C<Gnome::Gdk3::DragContext>   *context,
gint              x,
gint              y,
C<Gnome::Gtk3::SelectionData> *selection_data,
guint             info,
guint             time)
{
PrivateData *private_data = GET_PRIVATE_DATA (widget);

if (private_data->suggested_action)
{
private_data->suggested_action = 0;

// We are getting this data due to a request in drag_motion,
// rather than due to a request in drag_drop, so we are just
// supposed to call C<gdk_drag_status()>, not actually paste in
// the data.

str = gtk_selection_data_get_text (selection_data);
if (!data_is_acceptable (str))
gdk_drag_status (context, 0, time);
else
gdk_drag_status (context,
private_data->suggested_action,
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
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($context),
    :handle-arg1($x),
    :handle-arg2($y),
    :handle-arg3($time),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $context; the drag context

=item $x; the x coordinate of the current cursor position

=item $y; the y coordinate of the current cursor position

=item $time; the timestamp of the motion event


=head3 drag-drop

The ::drag-drop signal is emitted on the drop site when the user drops
the data onto the widget. The signal handler must determine whether
the cursor position is in a drop zone or not. If it is not in a drop
zone, it returns C<0> and no further processing is necessary.
Otherwise, the handler returns C<1>. In this case, the handler must
ensure that C<gtk_drag_finish()> is called to let the source know that
the drop is done. The call to C<gtk_drag_finish()> can be done either
directly or in a sig C<drag-data-received> handler which gets
triggered by calling C<gtk_drag_get_data()> to receive the data for one
or more of the supported targets.

Returns: whether the cursor position is in a drop zone

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($context),
    :handle-arg1($x),
    :handle-arg2($y),
    :handle-arg3($time),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $context; the drag context

=item $x; the x coordinate of the current cursor position

=item $y; the y coordinate of the current cursor position

=item $time; the timestamp of the motion event


=head3 drag-data-get

The ::drag-data-get signal is emitted on the drag source when the drop
site requests the data which is dragged. It is the responsibility of
the signal handler to fill I<data> with the data in the format which
is indicated by I<info>. See C<gtk_selection_data_set()> and
C<gtk_selection_data_set_text()>.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($context),
    :handle-arg1($data),
    :handle-arg2($info),
    :handle-arg3($time),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $context; the drag context

=item $data; the C<Gnome::Gtk3::SelectionData> to be filled with the dragged data

=item $info; the info that has been registered with the target in the
C<Gnome::Gtk3::TargetList>

=item $time; the timestamp at which the data was requested


=head3 drag-data-received

The ::drag-data-received signal is emitted on the drop site when the
dragged data has been received. If the data was received in order to
determine whether the drop will be accepted, the handler is expected
to call C<gdk_drag_status()> and not finish the drag.
If the data was received in response to a sig C<drag-drop> signal
(and this is the last target to be received), the handler for this
signal is expected to process the received data and then call
C<gtk_drag_finish()>, setting the I<success> parameter depending on
whether the data was processed successfully.

Applications must create some means to determine why the signal was emitted
and therefore whether to call C<gdk_drag_status()> or C<gtk_drag_finish()>.

The handler may inspect the selected action with
C<gdk_drag_context_get_selected_action()> before calling
C<gtk_drag_finish()>, e.g. to implement C<GDK_ACTION_ASK> as
shown in the following example:
|[<!-- language="C" -->
void
drag_data_received (C<Gnome::Gtk3::Widget>          *widget,
C<Gnome::Gdk3::DragContext>     *context,
gint                x,
gint                y,
C<Gnome::Gtk3::SelectionData>   *data,
guint               info,
guint               time)
{
if ((data->length >= 0) && (data->format == 8))
{
C<Gnome::Gdk3::DragAction> action;

// handle data here

action = gdk_drag_context_get_selected_action (context);
if (action == GDK_ACTION_ASK)
{
C<Gnome::Gtk3::Widget> *dialog;
gint response;

dialog = gtk_message_dialog_new (NULL,
GTK_DIALOG_MODAL |
GTK_DIALOG_DESTROY_WITH_PARENT,
GTK_MESSAGE_INFO,
GTK_BUTTONS_YES_NO,
"Move the data ?\n");
response = gtk_dialog_run (GTK_DIALOG (dialog));
gtk_widget_destroy (dialog);

if (response == GTK_RESPONSE_YES)
action = GDK_ACTION_MOVE;
else
action = GDK_ACTION_COPY;
}

gtk_drag_finish (context, TRUE, action == GDK_ACTION_MOVE, time);
}
else
gtk_drag_finish (context, FALSE, FALSE, time);
}
]|

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($context),
    :handle-arg1($x),
    :handle-arg2($y),
    :handle-arg3($data),
    :handle-arg4($info),
    :handle-arg5($time),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $context; the drag context

=item $x; where the drop happened

=item $y; where the drop happened

=item $data; the received data

=item $info; the info that has been registered with the target in the
C<Gnome::Gtk3::TargetList>

=item $time; the timestamp at which the data was received



=head3 window-state-event

The ::window-state-event will be emitted when the state of the
toplevel window associated to the I<widget> changes.

To receive this signal the C<Gnome::Gdk3::Window> associated to the widget
needs to enable the C<GDK_STRUCTURE_MASK> mask. GDK will enable
this mask automatically for all new windows.

Returns: C<1> to stop other handlers from being invoked for the
event. C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventWindowState>): the C<Gnome::Gdk3::EventWindowState> which
triggered this signal.


=head3 damage-event

Emitted when a redirected window belonging to I<widget> gets drawn into.
The region/area members of the event shows what area of the redirected
drawable was drawn into.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

Since: 2.14

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventExpose>): the C<Gnome::Gdk3::EventExpose> event


=head3 grab-broken-event

Emitted when a pointer or keyboard grab on a window belonging
to I<widget> gets broken.

On X11, this happens when the grab window becomes unviewable
(i.e. it or one of its ancestors is unmapped), or if the same
application grabs the pointer or keyboard again.

Returns: C<1> to stop other handlers from being invoked for
the event. C<0> to propagate the event further.

Since: 2.8

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventGrabBroken>): the C<Gnome::Gdk3::EventGrabBroken> event


=head3 query-tooltip

Emitted when prop C<has-tooltip> is C<1> and the hover timeout
has expired with the cursor hovering "above" I<widget>; or emitted when I<widget> got
focus in keyboard mode.

Using the given coordinates, the signal handler should determine
whether a tooltip should be shown for I<widget>. If this is the case
C<1> should be returned, C<0> otherwise.  Note that if
I<keyboard_mode> is C<1>, the values of I<x> and I<y> are undefined and
should not be used.

The signal handler is free to manipulate I<tooltip> with the therefore
destined function calls.

Returns: C<1> if I<tooltip> should be shown right now, C<0> otherwise.

Since: 2.12

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($x),
    :handle-arg1($y),
    :handle-arg2($keyboard_mode),
    :handle-arg3($tooltip),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $x; the x coordinate of the cursor position where the request has
been emitted, relative to I<widget>'s left side

=item $y; the y coordinate of the cursor position where the request has
been emitted, relative to I<widget>'s top

=item $keyboard_mode; C<1> if the tooltip was triggered using the keyboard

=item $tooltip; a C<Gnome::Gtk3::Tooltip>


=head3 show-help

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($help_type),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $help_type;



=head3 screen-changed

The ::screen-changed signal gets emitted when the
screen of a widget has changed.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($previous_screen),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object on which the signal is emitted

=item $previous_screen; (allow-none): the previous screen, or C<Any> if the
widget was not associated with a screen before


=head3 can-activate-accel

Determines whether an accelerator that activates the signal
identified by I<signal_id> can currently be activated.
This signal is present to allow applications and derived
widgets to override the default C<Gnome::Gtk3::Widget> handling
for determining whether an accelerator can be activated.

Returns: C<1> if the signal can be activated.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($signal_id),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $signal_id; the ID of a signal installed on I<widget>




=head2 Deprecated or unsupported signals

=head3 composited-changed
=head3 state-changed
=head3 style-set
=head3 visibility-notify-event

=end pod

#`{{
=head3 composited-changed

The ::composited-changed signal is emitted when the composited
status of I<widgets> screen changes.
See C<gdk_screen_is_composited()>.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object on which the signal is emitted

=head3 state-changed

The ::state-changed signal is emitted when the widget state changes.
See C<gtk_widget_get_state()>.

Deprecated: 3.0: Use sig C<state-flags-changed> instead.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($state),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal.

=item $state; the previous state

=head3 style-set

The ::style-set signal is emitted when a new style has been set
on a widget. Note that style-modifying functions like
C<gtk_widget_modify_base()> also cause this signal to be emitted.

Note that this signal is emitted for changes to the deprecated
C<Gnome::Gtk3::Style>. To track changes to the C<Gnome::Gtk3::StyleContext> associated
with a widget, use the sig C<style-updated> signal.

Deprecated:3.0: Use the sig C<style-updated> signal

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($previous_style),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object on which the signal is emitted

=item $previous_style; (allow-none): the previous style, or C<Any> if the widget
just got its initial style

=head3 visibility-notify-event

The ::visibility-notify-event will be emitted when the I<widget>'s
window is obscured or unobscured.

To receive this signal the C<Gnome::Gdk3::Window> associated to the widget needs
to enable the C<GDK_VISIBILITY_NOTIFY_MASK> mask.

Returns: C<1> to stop other handlers from being invoked for the event.
C<0> to propagate the event further.

Deprecated: 3.12: Modern composited windowing systems with pervasive
transparency make it impossible to track the visibility of a window
reliably, so this signal can not be guaranteed to provide useful
information.

  method handler (
    Gnome::GObject::Object :widget($widget),
    :handle-arg0($event),
    :$user-option1, ..., :$user-optionN
  );

=item $widget; the object which received the signal

=item $event; (type C<Gnome::Gdk3::.EventVisibility>): the C<Gnome::Gdk3::EventVisibility> which triggered this signal.
}}


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a C<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new(:empty);
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=begin comment

=head2 Supported properties

=head2 Unsupported properties

=end comment

=head2 Not yet supported properties


=head3 focus-on-click

The C<Gnome::GObject::Value> type of property I<focus-on-click> is C<G_TYPE_BOOLEAN>.

Whether the widget should grab focus when it is clicked with the mouse.

This property is only relevant for widgets that can take focus.

Before 3.20, several widgets (C<Gnome::Gtk3::Button>, C<Gnome::Gtk3::FileChooserButton>,
C<Gnome::Gtk3::ComboBox>) implemented this property individually.

Since: 3.20



=head3 has-tooltip

The C<Gnome::GObject::Value> type of property I<has-tooltip> is C<G_TYPE_BOOLEAN>.

Enables or disables the emission of sig C<query-tooltip> on I<widget>.
A value of C<1> indicates that I<widget> can have a tooltip, in this case
the widget will be queried using sig C<query-tooltip> to determine
whether it will provide a tooltip or not.

Note that setting this property to C<1> for the first time will change
the event masks of the C<Gnome::Gdk3::Windows> of this widget to include leave-notify
and motion-notify events.  This cannot and will not be undone when the
property is set to C<0> again.

Since: 2.12



=head3 tooltip-text

The C<Gnome::GObject::Value> type of property I<tooltip-text> is C<G_TYPE_STRING>.

Sets the text of tooltip to be the given string.

Also see C<gtk_tooltip_set_text()>.

This is a convenience property which will take care of getting the
tooltip shown if the given string is not C<Any>: prop C<has-tooltip>
will automatically be set to C<1> and there will be taken care of
sig C<query-tooltip> in the default signal handler.

Note that if both prop C<tooltip-text> and prop C<tooltip-markup>
are set, the last one wins.

Since: 2.12



=head3 tooltip-markup

The C<Gnome::GObject::Value> type of property I<tooltip-markup> is C<G_TYPE_STRING>.

Sets the text of tooltip to be the given string, which is marked up
with the [Pango text markup language][PangoMarkupFormat].
Also see C<gtk_tooltip_set_markup()>.

This is a convenience property which will take care of getting the
tooltip shown if the given string is not C<Any>: prop C<has-tooltip>
will automatically be set to C<1> and there will be taken care of
sig C<query-tooltip> in the default signal handler.

Note that if both prop C<tooltip-text> and prop C<tooltip-markup>
are set, the last one wins.

Since: 2.12



=head3 window

The C<Gnome::GObject::Value> type of property I<window> is C<G_TYPE_OBJECT>.

The widget's window if it is realized, C<Any> otherwise.

Since: 2.14



=head3 halign

The C<Gnome::GObject::Value> type of property I<halign> is C<G_TYPE_ENUM>.

How to distribute horizontal space if widget gets extra space, see C<Gnome::Gtk3::Align>

Since: 3.0



=head3 valign

The C<Gnome::GObject::Value> type of property I<valign> is C<G_TYPE_ENUM>.

How to distribute vertical space if widget gets extra space, see C<Gnome::Gtk3::Align>

Since: 3.0



=head3 margin-start

The C<Gnome::GObject::Value> type of property I<margin-start> is C<G_TYPE_INT>.

Margin on start of widget, horizontally. This property supports
left-to-right and right-to-left text directions.

This property adds margin outside of the widget's normal size
request, the margin will be added in addition to the size from
C<gtk_widget_set_size_request()> for example.

Since: 3.12



=head3 margin-end

The C<Gnome::GObject::Value> type of property I<margin-end> is C<G_TYPE_INT>.

Margin on end of widget, horizontally. This property supports
left-to-right and right-to-left text directions.

This property adds margin outside of the widget's normal size
request, the margin will be added in addition to the size from
C<gtk_widget_set_size_request()> for example.

Since: 3.12



=head3 margin-top

The C<Gnome::GObject::Value> type of property I<margin-top> is C<G_TYPE_INT>.

Margin on top side of widget.

This property adds margin outside of the widget's normal size
request, the margin will be added in addition to the size from
C<gtk_widget_set_size_request()> for example.

Since: 3.0



=head3 margin-bottom

The C<Gnome::GObject::Value> type of property I<margin-bottom> is C<G_TYPE_INT>.

Margin on bottom side of widget.

This property adds margin outside of the widget's normal size
request, the margin will be added in addition to the size from
C<gtk_widget_set_size_request()> for example.

Since: 3.0



=head3 margin

The C<Gnome::GObject::Value> type of property I<margin> is C<G_TYPE_INT>.

Sets all four sides' margin at once. If read, returns max
margin on any side.

Since: 3.0



=head3 hexpand

The C<Gnome::GObject::Value> type of property I<hexpand> is C<G_TYPE_BOOLEAN>.

Whether to expand horizontally. See C<gtk_widget_set_hexpand()>.

Since: 3.0



=head3 hexpand-set

The C<Gnome::GObject::Value> type of property I<hexpand-set> is C<G_TYPE_BOOLEAN>.

Whether to use the prop C<hexpand> property. See C<gtk_widget_get_hexpand_set()>.

Since: 3.0



=head3 vexpand

The C<Gnome::GObject::Value> type of property I<vexpand> is C<G_TYPE_BOOLEAN>.

Whether to expand vertically. See C<gtk_widget_set_vexpand()>.

Since: 3.0



=head3 vexpand-set

The C<Gnome::GObject::Value> type of property I<vexpand-set> is C<G_TYPE_BOOLEAN>.

Whether to use the prop C<vexpand> property. See C<gtk_widget_get_vexpand_set()>.

Since: 3.0



=head3 expand

The C<Gnome::GObject::Value> type of property I<expand> is C<G_TYPE_BOOLEAN>.

Whether to expand in both directions. Setting this sets both prop C<hexpand> and prop C<vexpand>

Since: 3.0



=head3 opacity

The C<Gnome::GObject::Value> type of property I<opacity> is C<G_TYPE_DOUBLE>.

The requested opacity of the widget. See C<gtk_widget_set_opacity()> for
more details about window opacity.

Before 3.8 this was only available in C<Gnome::Gtk3::Window>

Since: 3.8



=head3 scale-factor

The C<Gnome::GObject::Value> type of property I<scale-factor> is C<G_TYPE_INT>.

The scale factor of the widget. See C<gtk_widget_get_scale_factor()> for
more details about widget scaling.

Since: 3.10



=head3 scroll-arrow-hlength

The C<Gnome::GObject::Value> type of property I<scroll-arrow-hlength> is C<G_TYPE_INT>.

The "scroll-arrow-hlength" style property defines the length of
horizontal scroll arrows.

Since: 2.10



=head3 scroll-arrow-vlength

The C<Gnome::GObject::Value> type of property I<scroll-arrow-vlength> is C<G_TYPE_INT>.

The "scroll-arrow-vlength" style property defines the length of
vertical scroll arrows.

Since: 2.10


=end pod
























=finish
=head2 gtk_widget_destroy

  method gtk_widget_destroy ( )

Destroys a native widget. When a widget is destroyed all references it holds on other objects will be released:

=item if the widget is inside a container, it will be removed from its parent

=item if the widget is a container, all its children will be destroyed, recursively

=item if the widget is a top level, it will be removed from the list of top level widgets that GTK+ maintains internally

It's expected that all references held on the widget will also be released; you should connect to the “destroy” signal if you hold a reference to widget and you wish to remove it when this function is called. It is not necessary to do so if you are implementing a GtkContainer, as you'll be able to use the GtkContainerClass.remove() virtual function for that.

It's important to notice that gtk_widget_destroy() will only cause the widget to be finalized if no additional references, acquired using g_object_ref(), are held on it. In case additional references are in place, the widget will be in an "inert" state after calling this function; widget will still point to valid memory, allowing you to release the references you hold, but you may not query the widget's own state.

You should typically call this function on top level widgets, and rarely on child widgets.

See also: gtk_container_remove()
=end pod
sub gtk_widget_destroy ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_show

  method gtk_widget_show ( )

Flags a widget to be displayed. Any widget that isn’t shown will not appear on the screen. If you want to show all the widgets in a container, it’s easier to call gtk_widget_show_all() on the container, instead of individually showing the widgets.

Remember that you have to show the containers containing a widget, in addition to the widget itself, before it will appear onscreen.

When a toplevel container is shown, it is immediately realized and mapped; other shown widgets are realized and mapped when their toplevel container is realized and mapped.
=end pod
sub gtk_widget_show ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_widget_hide

  method gtk_widget_hide ( )

Reverses the effects of gtk_widget_show().
=end pod
sub gtk_widget_hide ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] show_all

  method gtk_widget_show_all ( )

Recursively shows a widget, and any child widgets (if the widget is a container).
=end pod
sub gtk_widget_show_all ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_name

  method gtk_widget_set_name ( Str $name )

Widgets can be named, which allows you to refer to them from a CSS file. You can apply a style to widgets with a particular name in the CSS file. See the documentation for the CSS syntax (on the same page as the L<docs for GtkStyleContext|https://developer.gnome.org/gtk3/stable/GtkStyleContext.html>).

Note that the CSS syntax has certain special characters to delimit and represent elements in a selector (period, #, >, *...), so using these will make your widget impossible to match by name. Any combination of alphanumeric symbols, dashes and underscores will suffice.
=end pod
sub gtk_widget_set_name ( N-GObject $widget, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_name

  method gtk_widget_get_name ( )

Retrieves the name of a widget. See gtk_widget_set_name() for the significance of widget names.
=end pod
sub gtk_widget_get_name ( N-GObject $widget )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_sensitive

  method gtk_widget_set_sensitive ( Int $sensitive )

Sets the sensitivity of a widget. A widget is sensitive if the user can interact with it. Insensitive widgets are “grayed out” and the user can’t interact with them. Insensitive widgets are known as “inactive”, “disabled”, or “ghosted” in some other toolkits.
=end pod
sub gtk_widget_set_sensitive ( N-GObject $widget, int32 $sensitive )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_sensitive

  method gtk_widget_get_sensitive ( --> Int )

Returns the widget’s sensitivity (in the sense of returning the value that has been set using gtk_widget_set_sensitive()).

The effective sensitivity of a widget is however determined by both its own and its parent widget’s sensitivity. See gtk_widget_is_sensitive().
=end pod
sub gtk_widget_get_sensitive ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_size_request

  method gtk_widget_set_size_request ( Int $w, Int $h )

Sets the minimum size of a widget; that is, the widget’s size request will be at least width by height . You can use this function to force a widget to be larger than it normally would be.

In most cases, gtk_window_set_default_size() is a better choice for toplevel windows than this function; setting the default size will still allow users to shrink the window. Setting the size request will force them to leave the window at least as large as the size request. When dealing with window sizes, gtk_window_set_geometry_hints() can be a useful function as well.

Note the inherent danger of setting any fixed size - themes, translations into other languages, different fonts, and user action can all change the appropriate size for a given widget. So, it's basically impossible to hardcode a size that will always be correct.

The size request of a widget is the smallest size a widget can accept while still functioning well and drawing itself correctly. However in some strange cases a widget may be allocated less than its requested size, and in many cases a widget may be allocated more space than it requested.

If the size request in a given direction is -1 (unset), then the “natural” size request of the widget will be used instead.

The size request set here does not include any margin from the GtkWidget properties margin-left, margin-right, margin-top, and margin-bottom, but it does include pretty much all other padding or border properties set by any subclass of GtkWidget.
=end pod
sub gtk_widget_set_size_request ( N-GObject $widget, int32 $w, int32 $h )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_no_show_all

  method gtk_widget_set_no_show_all ( Int $no_show_all )

Sets the “no-show-all” property, which determines whether calls to gtk_widget_show_all() will affect this widget.

This is mostly for use in constructing widget hierarchies with externally controlled visibility.
=end pod
#TODO ref to GtkUIManager when implemented.
sub gtk_widget_set_no_show_all ( N-GObject $widget, int32 $no_show_all )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_no_show_all

  method gtk_widget_get_no_show_all ( --> Int )

Returns the current value of the “no-show-all” property, which determines whether calls to gtk_widget_show_all() will affect this widget.
=end pod
sub gtk_widget_get_no_show_all ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_allocated_width

  method gtk_widget_get_allocated_width ( --> Int )

Returns the width that has currently been allocated to widget . This function is intended to be used when implementing handlers for the “draw” function.
=end pod
sub gtk_widget_get_allocated_width ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_allocated_height

  method gtk_widget_get_allocated_height ( --> Int )

Returns the height that has currently been allocated to widget . This function is intended to be used when implementing handlers for the “draw” function.
=end pod
sub gtk_widget_get_allocated_height ( N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] queue_draw

  method gtk_widget_queue_draw ( )

Equivalent to calling gtk_widget_queue_draw_area() for the entire area of a widget.
=end pod
sub gtk_widget_queue_draw ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_display

  method gtk_widget_get_display ( )

Get the GdkDisplay for the toplevel window associated with this widget. This function can only be called after the widget has been added to a widget hierarchy with a GtkWindow at the top.

In general, you should only create display specific resources when a widget has been realized, and you should free those resources when the widget is unrealized.
=end pod
sub gtk_widget_get_display ( N-GObject $widget )
  returns N-GObject       # GdkDisplay
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_direction

Sets the reading direction on a particular widget. This direction controls the primary direction for widgets containing text, and also the direction in which the children of a container are packed. The ability to set the direction is present in order so that correct localization into languages with right-to-left reading directions can be done. Generally, applications will let the default reading direction present, except for containers where the containers are arranged in an order that is explicitly visual rather than logical (such as buttons for text justification).

If the direction is set to C<GTK_TEXT_DIR_NONE>, then the value set by C<gtk_widget_set_default_direction()> will be used.

  method gtk_widget_set_direction ( Int $direction )

=item Int $direction; the new direction. This is a GtkTextDirection enum type defined in GtkEnums.

=end pod
sub gtk_widget_set_direction ( N-GObject $widget, int32  $direction )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_direction

Gets the reading direction for a particular widget.

  method gtk_widget_get_direction ( --> GtkTextDirection )

Returns the current text direction. This is a GtkTextDirection enum type defined in GtkEnums.

=end pod

sub gtk_widget_get_direction ( )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_default_direction

Sets the default reading direction on a particular widget.

  method gtk_widget_set_default_direction ( GtkTextDirection $direction )

=item $direction; the default direction.

=end pod
sub gtk_widget_set_default_direction ( int32  $direction )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_default_direction

Gets the default reading direction for a particular widget.

  method gtk_widget_get_default_direction ( --> GtkTextDirection )

Returns the default text direction.

=end pod

sub gtk_widget_get_default_direction ( )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_tooltip_text

  method gtk_widget_set_tooltip_text ( Str $text )

Sets text as the contents of the tooltip. This function will take care of setting “has-tooltip” to TRUE and of the default handler for the “query-tooltip” signal.
=end pod
sub gtk_widget_set_tooltip_text ( N-GObject $widget, Str $text )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_tooltip_text

  method gtk_widget_get_tooltip_text ( --> Str )

Sets text as the contents of the tooltip. This function will take care of setting “has-tooltip” to TRUE and of the default handler for the “query-tooltip” signal.
=end pod
sub gtk_widget_get_tooltip_text ( N-GObject $widget )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_window

  method gtk_widget_get_window ( --> N-GObject )

Returns the widget’s window (is a GtkWindow) if it is realized, NULL otherwise.

  my Gnome::Gtk::Button $b .= new(:build-id<startButton>);
  my Gnome::Gk::Window $w .= new(:widget($b.get-window));
=end pod
sub gtk_widget_get_window ( N-GObject $widget )
  returns N-GObject         # GdkWindow
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] set_visible

  method gtk_widget_set_visible ( Int $visible )

Sets the visibility state of widget. Note that setting this to TRUE doesn’t mean the widget is actually viewable, see gtk_widget_get_visible().

This function simply calls gtk_widget_show() or gtk_widget_hide() but is nicer to use when the visibility of the widget depends on some condition.
=end pod
sub gtk_widget_set_visible ( N-GObject $widget, int32 $visible)
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_visible

  method gtk_widget_get_visible ( --> Int )

Determines whether the widget is visible. If you want to take into account whether the widget’s parent is also marked as visible, use gtk_widget_is_visible() instead.

This function does not check if the widget is obscured in any way.
=end pod
sub gtk_widget_get_visible ( N-GObject $widget )
  returns int32       # Bool 1=true
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_widget_] get_has_window

  method gtk_widget_get_has_window ( --> Int )

Specifies whether widget has a GdkWindow of its own. Note that all realized widgets have a non-NULL “window” pointer (gtk_widget_get_window() never returns a NULL window when a widget is realized), but for many of them it’s actually the GdkWindow of one of its parent widgets. Widgets that do not create a window for themselves in “realize” must announce this by calling this function with has_window = FALSE.

This function should only be called by widget implementations, and they should call it in their init() function.
=end pod
sub gtk_widget_get_has_window ( N-GObject $window )
  returns int32
  is native(&gtk-lib)
  { * }


#TODO add a few subs more
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<accel-closures-changed destroy grab-focus hide map popup-menu
            realize show style-updated unmap unrealize
           >,
    :event<button-press-event button-release-event configure-event
           damage-event delete-event destroy-event enter-notify-event
           event-after focus-in-event grab-broken-event key-press-event
           key-release-event leave-notify-event map-event motion-notify-event
           property-notify-event proximity-in-event proximity-out-event
           scroll-event selection-clear-event selection-notify-event
           selection-request-event touch-event unmap-event window-state-event
          >,
    :deprecated<composited-changed state-changed style-set
                visibility-notify-event
               >,
    :nativewidget<drag-begin drag-data-delete drag-end hierarchy-changed
                  parent-set screen-changed size-allocate
                 >,
    :uint<can-activate-accel>,
    :GParamSpec<child-notify>,
    :enum<direction-changed focus keynav-failed move-focus show-help
          state-flags-changed
         >,
    :dragdatauint2<drag-data-get>,
    :dragint2datauint2<drag-data-received>,
    :dragint2uint<drag-drop drag-motion>,
    :drag2<drag-failed>,
    :draguint<drag-leave>,
    :notsupported<draw>,
    :bool<grab-notify mnemonic-activate>,
    :int2boolnw<query-tooltip>,
    :seluint2<selection-get>,
    :seluint<selection-received>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Widget';

  if ? %options<widget> || %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
#note "w s0: $native-sub, ", $s;
  try { $s = &::($native-sub); }
#note "w s1: gtk_widget_$native-sub, ", $s unless ?$s;
  try { $s = &::("gtk_widget_$native-sub"); } unless ?$s;
#note "w s2: parent test for $native-sub, ", $s unless ?$s;

  $s = callsame unless ?$s;

  $s
}
