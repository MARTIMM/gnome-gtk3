#TL:1:Gnome::Gtk3::Container:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Container

Base class for widgets which contain other widgets

=head1 Description

A GTK+ user interface is constructed by nesting widgets inside widgets. Container widgets are the inner nodes in the resulting tree of widgets: they contain other widgets. So, for example, you might have a B<Gnome::Gtk3::Window> containing a B<Gnome::Gtk3::Frame> containing a B<Gnome::Gtk3::Label>. If you wanted an image instead of a textual label inside the frame, you might replace the B<Gnome::Gtk3::Label> widget with a B<Gnome::Gtk3::Image> widget.

There are two major kinds of container widgets in GTK+. Both are subclasses of the abstract B<Gnome::Gtk3::Container> base class.

The first type of container widget has a single child widget and derives from B<Gnome::Gtk3::Bin>. These containers are decorators, which add some kind of functionality to the child. For example, a B<Gnome::Gtk3::Button> makes its child into a clickable button; a B<Gnome::Gtk3::Frame> draws a frame around its child and a B<Gnome::Gtk3::Window> places its child widget inside a top-level window.

The second type of container can have more than one child; its purpose is to manage layout. This means that these containers assign sizes and positions to their children. For example, a B<Gnome::Gtk3::HBox> arranges its children in a horizontal row, and a B<Gnome::Gtk3::Grid> arranges the widgets it contains in a two-dimensional grid.

For implementations of B<Gnome::Gtk3::Container> the virtual method B<Gnome::Gtk3::ContainerClass>.C<forall()> is always required, since it's used for drawing and other internal operations on the children. If the B<Gnome::Gtk3::Container> implementation expect to have non internal children it's needed to implement both B<Gnome::Gtk3::ContainerClass>.C<add()> and B<Gnome::Gtk3::ContainerClass>.C<remove()>. If the B<Gnome::Gtk3::Container> implementation has internal children, they should be added with C<gtk_widget_set_parent()> on C<init()> and removed with C<gtk_widget_unparent()> in the B<Gnome::Gtk3::WidgetClass>.C<destroy()> implementation. See more about implementing custom widgets at https://wiki.gnome.org/HowDoI/CustomWidgets

=head2 Height for width geometry management

GTK+ uses a height-for-width (and width-for-height) geometry management system. Height-for-width means that a widget can change how much vertical space it needs, depending on the amount of horizontal space that it is given (and similar for width-for-height).

There are some things to keep in mind when implementing container widgets that make use of GTK+’s height for width geometry management system. First, it’s important to note that a container must prioritize one of its dimensions, that is to say that a widget or container can only have a B<Gnome::Gtk3::SizeRequestMode> that is C<GTK_SIZE_REQUEST_HEIGHT_FOR_WIDTH> or C<GTK_SIZE_REQUEST_WIDTH_FOR_HEIGHT>. However, every widget and container must be able to respond to the APIs for both dimensions, i.e. even if a widget has a request mode that is height-for-width, it is possible that its parent will request its sizes using the width-for-height APIs.

To ensure that everything works properly, here are some guidelines to follow when implementing height-for-width (or width-for-height) containers.

Each request mode involves 2 virtual methods. Height-for-width apis run through C<gtk_widget_get_preferred_width()> and then through C<gtk_widget_get_preferred_height_for_width()>. When handling requests in the opposite B<Gnome::Gtk3::SizeRequestMode> it is important that every widget request at least enough space to display all of its content at all times.

When C<gtk_widget_get_preferred_height()> is called on a container that is height-for-width, the container must return the height for its minimum width. This is easily achieved by simply calling the reverse apis implemented for itself.

=begin comment
as follows:

static void
foo_container_get_preferred_height (B<Gnome::Gtk3::Widget> *widget,
                                    gint *min_height,
                                    gint *nat_height)
{
   if (i_am_in_height_for_width_mode)
     {
       gint min_width;

       GTK_WIDGET_GET_CLASS (widget)->get_preferred_width (widget,
                                                           &min_width,
                                                           NULL);
       GTK_WIDGET_GET_CLASS (widget)->get_preferred_height_for_width
                                                          (widget,
                                                           min_width,
                                                           min_height,
                                                           nat_height);
     }
   else
     {
       ... many containers support both request modes, execute the
       real width-for-height request here by returning the
       collective heights of all widgets that are stacked
       vertically (or whatever is appropriate for this container)
       ...
     }
}
=end comment

Similarly, when C<gtk_widget_get_preferred_width_for_height()> is called for a container or widget that is height-for-width, it then only needs to return the base minimum width

=begin comment
like so:

static void
foo_container_get_preferred_width_for_height (B<Gnome::Gtk3::Widget> *widget,
                                              gint for_height,
                                              gint *min_width,
                                              gint *nat_width)
{
   if (i_am_in_height_for_width_mode)
     {
       GTK_WIDGET_GET_CLASS (widget)->get_preferred_width (widget,
                                                           min_width,
                                                           nat_width);
     }
   else
     {
       ... execute the real width-for-height request here based on
       the required width of the children collectively if the
       container were to be allocated the said height ...
     }
}

=end comment

Height for width requests are generally implemented in terms of a virtual allocation of widgets in the input orientation. Assuming an height-for-width request mode, a container would implement the C<get_preferred_height_for_width()> virtual function by first calling C<gtk_widget_get_preferred_width()> for each of its children.

For each potential group of children that are lined up horizontally, the values returned by C<gtk_widget_get_preferred_width()> should be collected in an array of B<Gnome::Gtk3::RequestedSize> structures. Any child spacing should be removed from the input I<for_width> and then the collective size should be allocated using the C<gtk_distribute_natural_allocation()> convenience function.

The container will then move on to request the preferred height for each child by using C<gtk_widget_get_preferred_height_for_width()> and using the sizes stored in the B<Gnome::Gtk3::RequestedSize> array.

To allocate a height-for-width container, it’s again important to consider that a container must prioritize one dimension over the other. So if a container is a height-for-width container it must first allocate all widgets horizontally using a B<Gnome::Gtk3::RequestedSize> array and C<gtk_distribute_natural_allocation()> and then add any extra space (if and where appropriate) for the widget to expand.

After adding all the expand space, the container assumes it was allocated sufficient height to fit all of its content. At this time, the container must use the total horizontal sizes of each widget to request the height-for-width of each of its children and store the requests in a B<Gnome::Gtk3::RequestedSize> array for any widgets that stack vertically (for tabular containers this can be generalized into the heights and widths of rows and columns). The vertical space must then again be distributed using C<gtk_distribute_natural_allocation()> while this time considering the allocated height of the widget minus any vertical spacing that the container adds. Then vertical expand space should be added where appropriate and available and the container should go on to actually allocating the child widgets.

See [B<Gnome::Gtk3::Widget>’s geometry management section](https://developer.gnome.org/gtk3/3.24/GtkWidget.html#geometry-managementgeometry-management) to learn more about implementing height-for-width geometry management for widgets.

=begin comment
=head2 Child properties

B<Gnome::Gtk3::Container> introduces child properties. These are object properties that are not specific to either the container or the contained widget, but rather to their relation. Typical examples of child properties are the position or pack-type of a widget which is contained in a B<Gnome::Gtk3::Box>.

Use C<gtk_container_class_install_child_property()> to install child properties for a container class and C<gtk_container_class_find_child_property()> or C<gtk_container_class_list_child_properties()> to get information about existing child properties.

To set the value of a child property, use C<gtk_container_child_set_property()>, C<gtk_container_child_set()> or C<gtk_container_child_set_valist()>. To obtain the value of a child property, use C<gtk_container_child_get_property()>, C<gtk_container_child_get()> or C<gtk_container_child_get_valist()>. To emit notification about child property changes, use C<gtk_widget_child_notify()>.
=end comment

=head2 Gnome::Gtk3::Container as Gnome::Gtk3::Buildable

The B<Gnome::Gtk3::Container> implementation of the B<Gnome::Gtk3::Buildable> interface supports a <packing> element for children, which can contain multiple <property> elements that specify child properties for the child.

Since 2.16, child properties can also be marked as translatable using the same “translatable”, “comments” and “context” attributes that are usedfor regular properties.

Since 3.16, containers can have a <focus-chain> element containing multiple <widget> elements, one for each child that should be added to the focus chain. The ”name” attribute gives the id of the widget.

An example of these properties in UI definitions:

  <object class="GtkBox>">
    <child>
      <object class="GtkEntry>" id="entry1"/>
      <packing>
        <property name="pack-type">start</property>
      </packing>
    </child>
    <child>
      <object class="GtkEntry>" id="entry2"/>
    </child>
    <focus-chain>
      <widget name="entry1"/>
      <widget name="entry2"/>
    </focus-chain>
  </object>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Container;
  also is Gnome::Gtk3::Widget;


=head2 Uml Diagram

![](plantuml/Container.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Container;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Container;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Container class process the options
    self.bless( :GtkContainer, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment


=comment head2 Example

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::NativeLib;
use Gnome::N::GlibToRakuTypes;
use Gnome::N::N-GObject;

use Gnome::Glib::List;

use Gnome::GObject::Object;
use Gnome::GObject::Value;
use Gnome::GObject::Type;

use Gnome::Gtk3::Widget;
use Gnome::Gtk3::WidgetPath;
use Gnome::Gtk3::Adjustment;

use Gnome::Cairo;
use Gnome::Cairo::Enums;
use Gnome::Cairo::Types;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::Container:auth<github:MARTIMM>;
also is Gnome::Gtk3::Widget;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 multi method new ( N-GObject :$native-object! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

=head3 multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

=end pod

#TM:1:new():inheriting
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w0<check-resize>, :w1<add remove set-focus-child>,
  ) unless $signals-added;

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::Container' #`{{ or %options<GtkContainer> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_container_new___x___($no);
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
        $no = _gtk_container_new();
      }
      }}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkContainer');
  }
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_container_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_container_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('container-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-container-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

  self._set-class-name-of-sub('GtkContainer');
  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
#TM:1:add:
=begin pod
=head2 add

Adds I<$widget> to this container. Typically used for simple containers such as B<Gnome::Gtk3::Window>, B<Gnome::Gtk3::Frame>, or B<Gnome::Gtk3::Button>; for more complicated layout containers such as B<Gnome::Gtk3::Box> or B<Gnome::Gtk3::Grid>, this function will pick default packing parameters that may not be correct. So consider functions such as C<Gnome::Gtk3::Box.pack-start()> and C<Gnome::Gtk3::Grid.attach()> as an alternative to C<add()> in those cases. A widget may be added to only one container at a time; you can’t place the same widget inside two different containers.

Note that some containers, such as B<Gnome::Gtk3::ScrolledWindow> or B<Gnome::Gtk3::ListBox>, may add intermediate children between the added widget and the container.

  method add ( N-GObject() $widget )

=item $widget; a widget to be placed inside this container
=end pod

method add ( N-GObject() $widget ) {
  gtk_container_add( self._f('GtkContainer'), $widget);
}

sub gtk_container_add (
  N-GObject $container, N-GObject $widget
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:add-with-properties:
=begin pod
=head2 add-with-properties

Adds I<widget> to this container, setting child properties at the same time. See C<add()> and C<gtk-container-child-set()> for more details.

  method add-with-properties ( N-GObject() $widget, Str $first_prop_name )

=item $widget; a widget to be placed inside this container
=item $first_prop_name; the name of the first child property to set @...: a C<undefined>-terminated list of property names and values, starting with I<first-prop-name>
=end pod

method add-with-properties ( N-GObject() $widget, Str $first_prop_name ) {
  gtk_container_add_with_properties(
    self._f('GtkContainer'), $widget, $first_prop_name
  );
}

sub gtk_container_add_with_properties (
  N-GObject $container, N-GObject $widget, gchar-ptr $first_prop_name, Any $any = Any
) is native(&gtk-lib)
  { * }
}}

#`{{ No doc and GtkResizeMode is deprecated together with 2 routines
#-------------------------------------------------------------------------------
# TM:0:check-resize:
=begin pod
=head2 check-resize

  method check-resize ( )

=end pod

method check-resize ( ) {

  gtk_container_check_resize(
    self._f('GtkContainer'),
  );
}

sub gtk_container_check_resize (
  N-GObject $container
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:child-get:
=begin pod
=head2 child-get

Gets the values of one or more child properties for I<child> and this container.

  method child-get ( N-GObject() $child, Str $first_prop_name )

=item $child; a widget which is a child of this container
=item $first_prop_name; the name of the first property to get @...: return location for the first property, followed optionally by more name/return location pairs, followed by C<undefined>
=end pod

method child-get ( N-GObject() $child, Str $first_prop_name ) {
  gtk_container_child_get( self._f('GtkContainer'), $child, $first_prop_name);
}

sub gtk_container_child_get (
  N-GObject $container, N-GObject $child, gchar-ptr $first_prop_name, Any $any = Any
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:child-get-property:
=begin pod
=head2 child-get-property

Gets the value of a child property for I<child> and this container.

  method child-get-property (
    N-GObject() $child, Str $property-name, :$property-type
    --> Any
  )

=item $child; a widget which is a child of this container
=item $property-name; the name of the property to get
=item The type for the return value. See also C<Gnome::GObject::Object.get-properties>.
=end pod

method child-get-property (
  N-GObject() $child, Str $property-name --> Any
) {
  my N-GValue $value .= new;
  gtk_container_child_get_property(
    self._f('GtkContainer'), $child, $property_name, $value
  );
}

sub gtk_container_child_get_property (
  N-GObject $container, N-GObject $child, gchar-ptr $property_name, N-GObject $value
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
# TM:0:child-get-valist:
=begin pod
=head2 child-get-valist

Gets the values of one or more child properties for I<child> and this container.

  method child-get-valist (
    N-GObject() $child, Str $first_property_name, va_list $var_args
  )

=item $child; a widget which is a child of this container
=item $first_property_name; the name of the first property to get
=item $var_args; return location for the first property, followed optionally by more name/return location pairs, followed by C<undefined>
=end pod

method child-get-valist (
  N-GObject() $child, Str $first_property_name, va_list $var_args
) {
  gtk_container_child_get_valist(
    self._f('GtkContainer'), $child, $first_property_name, $var_args
  );
}

sub gtk_container_child_get_valist (
  N-GObject $container, N-GObject $child, gchar-ptr $first_property_name, va_list $var_args
) is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:child-notify:
=begin pod
=head2 child-notify

Emits a I<child-notify> signal for the child property I<$child-property> on the child.

This is an analogue of C<g-object-notify()> for child properties.

Also see C<gtk-widget-child-notify()>.

  method child-notify ( N-GObject() $child, Str $child-property )

=item $child; the child widget
=item $child-property; the name of a child property installed on the class of this container
=end pod

method child-notify ( N-GObject() $child, Str $child_property ) {
  gtk_container_child_notify(
    self._f('GtkContainer'), $child, $child_property
  );
}

sub gtk_container_child_notify (
  N-GObject $container, N-GObject $child, gchar-ptr $child_property
) is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:child-notify-by-pspec:
=begin pod
=head2 child-notify-by-pspec

Emits a  I<child-notify> signal for the [child property][child-properties] specified by I<pspec> on the child.

This is an analogue of C<g-object-notify-by-pspec()> for child properties.

  method child-notify-by-pspec ( N-GObject() $child, GParamSpec $pspec )

=item $child; the child widget
=item $pspec; the B<Gnome::Gtk3::ParamSpec> of a child property instealled on the class of this container
=end pod

method child-notify-by-pspec ( N-GObject() $child, GParamSpec $pspec ) {
  gtk_container_child_notify_by_pspec( self._f('GtkContainer'), $child, $pspec);
}

sub gtk_container_child_notify_by_pspec (
  N-GObject $container, N-GObject $child, GParamSpec $pspec
) is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:child-set:
=begin pod
=head2 child-set

Sets one or more child properties for I<child> and this container.

  method child-set ( N-GObject() $child, Str $first_prop_name )

=item $child; a widget which is a child of this container
=item $first_prop_name; the name of the first property to set @...: a C<undefined>-terminated list of property names and values, starting with I<first-prop-name>
=end pod

method child-set ( N-GObject() $child, Str $first_prop_name ) {
  gtk_container_child_set( self._f('GtkContainer'), $child, $first_prop_name);
}

sub gtk_container_child_set (
  N-GObject $container, N-GObject $child, gchar-ptr $first_prop_name, Any $any = Any
) is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:child-set-property:
=begin pod
=head2 child-set-property

Sets a child property for I<child> and this container.

  method child-set-property (
    N-GObject() $child, Str $property_name, N-GObject() $value
  )

=item $child; a widget which is a child of this container
=item $property_name; the name of the property to set
=item $value; the value to set the property to
=end pod

method child-set-property (
  N-GObject() $child, Str $property_name, N-GObject() $value
) {
  gtk_container_child_set_property(
    self._f('GtkContainer'), $child, $property_name, $value
  );
}

sub gtk_container_child_set_property (
  N-GObject $container, N-GObject $child, gchar-ptr $property_name, N-GObject $value
) is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
# TM:0:child-set-valist:
=begin pod
=head2 child-set-valist

Sets one or more child properties for I<child> and this container.

  method child-set-valist (
    N-GObject() $child, Str $first_property_name, va_list $var_args
  )

=item $child; a widget which is a child of this container
=item $first_property_name; the name of the first property to set
=item $var_args; a C<undefined>-terminated list of property names and values, starting with I<first-prop-name>
=end pod

method child-set-valist (
  N-GObject() $child, Str $first_property_name, va_list $var_args
) {
  gtk_container_child_set_valist(
    self._f('GtkContainer'), $child, $first_property_name, $var_args
  );
}

sub gtk_container_child_set_valist (
  N-GObject $container, N-GObject $child, gchar-ptr $first_property_name, va_list $var_args
) is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:child-type:
=begin pod
=head2 child-type

Returns the type of the children supported by the container.

Note that this may return C<G-TYPE-NONE> to indicate that no more children can be added, e.g. for a B<Gnome::Gtk3::Paned> which already has two children.

Returns: a B<Gnome::Gtk3::Type>.

  method child-type ( --> N-GObject )

=end pod

method child-type ( --> N-GObject ) {

  gtk_container_child_type(
    self._f('GtkContainer'),
  )
}

sub gtk_container_child_type (
  N-GObject $container --> N-GObject
) is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:class-find-child-property:
=begin pod
=head2 class-find-child-property

Finds a child property of a container class by name.

Returns: the B<Gnome::Gtk3::ParamSpec> of the child property or C<undefined> if I<class> has no child property with that name.

  method class-find-child-property (
    GObjectClass $cclass, Str $property_name --> GParamSpec
  )

=item $cclass; (type GtkContainerClass): a B<Gnome::Gtk3::ContainerClass>
=item $property_name; the name of the child property to find
=end pod

method class-find-child-property ( GObjectClass $cclass, Str $property_name --> GParamSpec ) {

  gtk_container_class_find_child_property(
    self._f('GtkContainer'), $cclass, $property_name
  )
}

sub gtk_container_class_find_child_property (
  GObjectClass $cclass, gchar-ptr $property_name --> GParamSpec
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:class-handle-border-width:
=begin pod
=head2 class-handle-border-width

Modifies a subclass of B<Gnome::Gtk3::ContainerClass> to automatically add and remove the border-width setting on GtkContainer. This allows the subclass to ignore the border width in its size request and allocate methods. The intent is for a subclass to invoke this in its class-init function.

C<class-handle-border-width()> is necessary because it would break API too badly to make this behavior the default. So subclasses must “opt in” to the parent class handling border-width for them.

  method class-handle-border-width ( GtkContainerClass $klass )

=item $klass; the class struct of a B<Gnome::Gtk3::Container> subclass
=end pod

method class-handle-border-width ( GtkContainerClass $klass ) {

  gtk_container_class_handle_border_width(
    self._f('GtkContainer'), $klass
  );
}

sub gtk_container_class_handle_border_width (
  GtkContainerClass $klass
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:class-install-child-properties:
=begin pod
=head2 class-install-child-properties

Installs child properties on a container class.

  method class-install-child-properties (
    GtkContainerClass $cclass, UInt $n_pspecs, GParamSpec $pspecs
  )

=item $cclass; a B<Gnome::Gtk3::ContainerClass>
=item $n_pspecs; the length of the B<Gnome::Gtk3::ParamSpec> array
=item $pspecs; (array length=n-pspecs): the B<Gnome::Gtk3::ParamSpec> array defining the new child properties
=end pod

method class-install-child-properties ( GtkContainerClass $cclass, UInt $n_pspecs, GParamSpec $pspecs ) {

  gtk_container_class_install_child_properties(
    self._f('GtkContainer'), $cclass, $n_pspecs, $pspecs
  );
}

sub gtk_container_class_install_child_properties (
  GtkContainerClass $cclass, guint $n_pspecs, GParamSpec $pspecs
) is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:class-install-child-property:
=begin pod
=head2 class-install-child-property

Installs a child property on a container class.

  method class-install-child-property ( GtkContainerClass $cclass, UInt $property_id, GParamSpec $pspec )

=item $cclass; a B<Gnome::Gtk3::ContainerClass>
=item $property_id; the id for the property
=item $pspec; the B<Gnome::Gtk3::ParamSpec> for the property
=end pod

method class-install-child-property ( GtkContainerClass $cclass, UInt $property_id, GParamSpec $pspec ) {

  gtk_container_class_install_child_property(
    self._f('GtkContainer'), $cclass, $property_id, $pspec
  );
}

sub gtk_container_class_install_child_property (
  GtkContainerClass $cclass, guint $property_id, GParamSpec $pspec
) is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:0:class-list-child-properties:
=begin pod
=head2 class-list-child-properties

Returns all child properties of a container class.

Returns: (array length=n-properties) (transfer container): a newly allocated C<undefined>-terminated array of B<Gnome::Gtk3::ParamSpec>*. The array must be freed with C<g-free()>.

  method class-list-child-properties ( GObjectClass $cclass, guInt-ptr $n_properties --> GParamSpec )

=item $cclass; (type GtkContainerClass): a B<Gnome::Gtk3::ContainerClass>
=item $n_properties; location to return the number of child properties found
=end pod

method class-list-child-properties ( GObjectClass $cclass, guInt-ptr $n_properties --> GParamSpec ) {

  gtk_container_class_list_child_properties(
    self._f('GtkContainer'), $cclass, $n_properties
  )
}

sub gtk_container_class_list_child_properties (
  GObjectClass $cclass, gugint-ptr $n_properties --> GParamSpec
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:forall:
=begin pod
=head2 forall

Invokes I<callback> on each direct child of this container, including children that are considered “internal” (implementation details of the container). “Internal” children generally weren’t added by the user of the container, but were added by the container implementation itself.

Most applications should use C<foreach()>, rather than C<gtk-container-forall()>.

  method forall ( GtkCallback $callback, Pointer $callback_data )

=item $callback; (scope call) (closure callback-data): a callback
=item $callback_data; callback user data
=end pod

method forall ( GtkCallback $callback, Pointer $callback_data ) {

  gtk_container_forall(
    self._f('GtkContainer'), $callback, $callback_data
  );
}

sub gtk_container_forall (
  N-GObject $container, GtkCallback $callback, gpointer $callback_data
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:foreach:use native callback
#TM:1:foreach:use raku callback
=begin pod
=head2 foreach

Invokes a callback method on each non-internal child of this container. See C<forall()> for details on what constitutes an “internal” child. For all practical purposes, this function should iterate over precisely those child widgets that were added to the container by the application with explicit C<add()> calls.

=comment It is permissible to remove the child from the I<callback> handler.

Most applications should use C<foreach()>, rather than C<forall()>.

  method foreach (
    Any:D $callback-object, Str:D $callback-name, *%user-options
  )

=item $callback-object; An object where the callback method is defined
=item $callback-name; method name of the callback. A name ending in C<-rk> gets a raku widget instead of a native object.
=item %user-options; A list of named arguments which are provided to the callback. A special named argumend, C<:give-raku-objects>, is used to provide raku objects instead of the native objects in the same way the extension C<-rk> would do. This might be a better way because one can check the named argument if a raku object is provided or not, see examples below.

=comment B<Note that this is an experiment, It might be that only the named argument name is used or the method name>.

=head3 Example

An example from the C<t/Container.t> test program where both methods are used;

  class X {
    method cb2 ( Gnome::Gtk3::Label() $rk, :$label ) {
      is $rk.get-name, 'GtkLabel', '.foreach(): cb2()';
      is $rk.get-text, $label, 'label text';
    }

    method cb3 ( N-GObject $o, Str :$label ) {
      is $o.().get-name, 'GtkLabel', '.foreach(): cb3()';
      is $o.().get-text, $label, 'label text';
    }
  }

  $b .= new(:label<some-text>);
  $b.foreach( X.new, 'cb2', :label<some-text>);
  $b.foreach( X.new, 'cb3', :label<some-text>);

=end pod

method foreach ( Any:D $func-object, Str:D $func-name, *%user-options ) {
  if $func-object.^can($func-name) {
    _gtk_container_foreach(
      self._f('GtkContainer'),
      -> $no, $d {
        CATCH { default { .message.note; .backtrace.concise.note } }

#`{{
        if $func-name ~~ m/ '-rk' $/ or
           %user-options<give-raku-objects>:exists
        {
          my Gnome::GObject::Object $rk = self._wrap-native-type-from-no($no);
          $func-object."$func-name"( $rk, |%user-options)
        }

        else {
}}
          $func-object."$func-name"( $no, |%user-options)
#        }
      },
      OpaquePointer
    );
  }

  else {
    note "Method $func-name not found in object $func-object.perl()"
      if $Gnome::N::x-debug;
  }
}

sub gtk_container_foreach (
  N-GObject:D $container, Any:D $func-object, Str:D $func-name, *%user-options
) {
  if $func-object.^can($func-name) {
    _gtk_container_foreach(
      $container,
      -> $no, $d {
        CATCH { default { .message.note; .backtrace.concise.note } }
        $func-object."$func-name"( $no, |%user-options)
      },
      OpaquePointer
    );
  }

  else {
    note "Method $func-name not found in object $func-object.perl()"
      if $Gnome::N::x-debug;
  }
}

sub _gtk_container_foreach (
  N-GObject $container,
  Callable $callback ( N-GObject $no, OpaquePointer $d),
  OpaquePointer $user_data
) is native(&gtk-lib)
  is symbol('gtk_container_foreach')
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-border-width:
=begin pod
=head2 get-border-width

Retrieves the border width of the container. See C<set-border-width()>.

Returns: the current border width

  method get-border-width ( --> UInt )

=end pod

method get-border-width ( --> UInt ) {
  gtk_container_get_border_width(self._f('GtkContainer'))
}

sub gtk_container_get_border_width (
  N-GObject $container --> guint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-children:
#TM:1:get-children-rk
=begin pod
=head2 get-children, get-children-rk

Returns the container’s non-internal children. See C<forall()> for details on what constitutes an "internal" child.

Returns: a newly-allocated list of the container’s non-internal children.

  method get-children ( --> N-GList )
  method get-children-rk ( --> Gnome::Glib::List )

=end pod

method get-children ( --> N-GList ) {
  gtk_container_get_children(self._f('GtkContainer'))
}

method get-children-rk ( --> Gnome::Glib::List ) {
  Gnome::Glib::List.new(
    :native-object(gtk_container_get_children(self._f('GtkContainer')))
  )
}

sub gtk_container_get_children (
  N-GObject $container --> N-GList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-focus-child:
=begin pod
=head2 get-focus-child

Returns the current focus child widget inside this container. This is not the currently focused widget. That can be obtained by calling C<Gnome::Gtk3::Window.get-focus()>.

Returns: The child widget which will receive the focus inside this container when the this container is focused, or C<undefined> if none is set.

  method get-focus-child ( --> N-GObject )

=end pod

method get-focus-child ( --> N-GObject ) {
  gtk_container_get_focus_child(self._f('GtkContainer'))
}

method get-focus-child-rk ( --> Any ) {
  Gnome::N::deprecate(
    'get-focus-child-rk', 'coercing from get-focus-child',
    '0.47.4', '0.50.0'
  );

  self._wrap-native-type-from-no(
    gtk_container_get_focus_child(self._f('GtkContainer'))
  )
}

sub gtk_container_get_focus_child (
  N-GObject $container --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-focus-hadjustment:
=begin pod
=head2 get-focus-hadjustment

Retrieves the horizontal focus adjustment for the container. See C<set-focus-hadjustment()>.

Returns: the horizontal focus adjustment, or C<undefined> if none has been set. In the C<-rk> case, an invalid Widget is returned. It is a native object for B<Gnome::Gtk3::Adjustment>.

  method get-focus-hadjustment ( --> N-GObject )

=end pod

method get-focus-hadjustment ( --> N-GObject ) {
  gtk_container_get_focus_hadjustment(self._f('GtkContainer'))
}

method get-focus-hadjustment-rk ( --> Gnome::Gtk3::Adjustment ) {
  Gnome::N::deprecate(
    'get-focus-hadjustment-rk', 'get-focus-hadjustment',
    '0.47.4', '0.50.0'
  );

  Gnome::Gtk3::Adjustment.new(
    :native-object(gtk_container_get_focus_hadjustment(self._f('GtkContainer')))
  )
}

sub gtk_container_get_focus_hadjustment (
  N-GObject $container --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-focus-vadjustment:
=begin pod
=head2 get-focus-vadjustment

Retrieves the vertical focus adjustment for the container. See C<set-focus-vadjustment()>.

Returns: the vertical focus adjustment, or C<undefined> if none has been set. It is a native object for B<Gnome::Gtk3::Adjustment>.

  method get-focus-vadjustment ( --> N-GObject )

=end pod

method get-focus-vadjustment ( --> N-GObject ) {
  gtk_container_get_focus_vadjustment(self._f('GtkContainer'))
}

method get-focus-vadjustment-rk ( --> Gnome::Gtk3::Adjustment ) {
  Gnome::N::deprecate(
    'get-focus-vadjustment-rk', 'get-focus-vadjustment',
    '0.47.4', '0.50.0'
  );

  Gnome::Gtk3::Adjustment.new(
    :native-object(gtk_container_get_focus_vadjustment(self._f('GtkContainer')))
  )
}

sub gtk_container_get_focus_vadjustment (
  N-GObject $container --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-path-for-child:
=begin pod
=head2 get-path-for-child

Returns a newly created widget path representing all the widget hierarchy from the toplevel down to and including I<child>.

Returns: A native object for B<Gnome::Gtk3::WidgetPath>

  method get-path-for-child ( N-GObject() $child --> N-GObject )

=item $child; a child of this container
=end pod

method get-path-for-child ( N-GObject() $child --> N-GObject ) {
  gtk_container_get_path_for_child( self._f('GtkContainer'), $child)
}

method get-path-for-child-rk (
  N-GObject() $child --> Gnome::Gtk3::WidgetPath
) {
  Gnome::N::deprecate(
    'get-path-for-child-rk', 'coercing from get-path-for-child',
    '0.47.4', '0.50.0'
  );

  Gnome::Gtk3::WidgetPath.new(
    :native-object(
      gtk_container_get_path_for_child( self._f('GtkContainer'), $child)
    )
  )
}

sub gtk_container_get_path_for_child (
  N-GObject $container, N-GObject $child --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:propagate-draw:
=begin pod
=head2 propagate-draw

When a container receives a call to the draw function, it must send synthetic  I<draw> calls to all children that don’t have their own B<Gnome::Gtk3::Windows>. This function provides a convenient way of doing this. A container, when it receives a call to its  I<draw> function, calls C<propagate-draw()> once for each child, passing in the I<cr> the container received.

C<gtk-container-propagate-draw()> takes care of translating the origin of I<cr>, and deciding whether the draw needs to be sent to the child. It is a convenient and optimized way of getting the same effect as calling C<gtk-widget-draw()> on the child directly.

In most cases, a container can simply either inherit the  I<draw> implementation from B<Gnome::Gtk3::Container>, or do some drawing and then chain to the I<draw> implementation from B<Gnome::Gtk3::Container>.

  method propagate-draw ( N-GObject() $child, cairo_t $cr )

=item $child; a child of this container
=item $cr; Cairo context as passed to the container. If you want to use I<cr> in container’s draw function, consider using C<cairo-save()> and C<cairo-restore()> before calling this function.
=end pod

method propagate-draw ( N-GObject() $child, cairo_t $cr ) {
  gtk_container_propagate_draw( self._f('GtkContainer'), $child, $cr);
}

sub gtk_container_propagate_draw (
  N-GObject $container, N-GObject $child, cairo_t $cr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:remove:
=begin pod
=head2 remove

Removes I<widget> from this container. I<widget> must be inside this container. Note that this container will own a reference to I<widget>, and that this may be the last reference held; so removing a widget from its container can destroy that widget. If you want to use I<widget> again, you need to add a reference to it before removing it from a container, using C<g-object-ref()>. If you don’t want to use I<widget> again it’s usually more efficient to simply destroy it directly using C<gtk-widget-destroy()> since this will remove it from the container and help break any circular reference count cycles.

  method remove ( N-GObject() $widget )

=item $widget; a current child of this container
=end pod

method remove ( N-GObject() $widget ) {
  gtk_container_remove( self._f('GtkContainer'), $widget);
}

sub gtk_container_remove (
  N-GObject $container, N-GObject $widget
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-border-width:
=begin pod
=head2 set-border-width

Sets the border width of the container.

The border width of a container is the amount of space to leave around the outside of the container. The only exception to this is B<Gnome::Gtk3::Window>; because toplevel windows can’t leave space outside, they leave the space inside. The border is added on all sides of the container. To add space to only one side, use a specific  I<margin> property on the child widget, for example  I<margin-top>.

  method set-border-width ( UInt $border_width )

=item $border_width; amount of blank space to leave outside the container. Valid values are in the range 0-65535 pixels.
=end pod

method set-border-width ( UInt $border_width ) {
  gtk_container_set_border_width( self._f('GtkContainer'), $border_width);
}

sub gtk_container_set_border_width (
  N-GObject $container, guint $border_width
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-focus-child:
=begin pod
=head2 set-focus-child

Sets, or unsets if I<child> is C<undefined>, the focused child of this container.

This function emits the GtkContainer::set-focus-child signal of this container. Implementations of B<Gnome::Gtk3::Container> can override the default behaviour by overriding the class closure of this signal.

This is function is mostly meant to be used by widgets. Applications can use C<gtk-widget-grab-focus()> to manually set the focus to a specific widget.

  method set-focus-child ( N-GObject() $child )

=item $child; a B<Gnome::Gtk3::Widget>, or C<undefined>
=end pod

method set-focus-child ( N-GObject() $child ) {
  gtk_container_set_focus_child( self._f('GtkContainer'), $child);
}

sub gtk_container_set_focus_child (
  N-GObject $container, N-GObject $child
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-focus-hadjustment:
=begin pod
=head2 set-focus-hadjustment

Hooks up an adjustment to focus handling in a container, so when a child of the container is focused, the adjustment is scrolled to show that widget. This function sets the horizontal alignment. See C<gtk-scrolled-window-get-hadjustment()> for a typical way of obtaining the adjustment and C<set-focus-vadjustment()> for setting the vertical adjustment.

The adjustments have to be in pixel units and in the same coordinate system as the allocation for immediate children of the container.

  method set-focus-hadjustment ( N-GObject() $adjustment )

=item $adjustment; an adjustment which should be adjusted when the focus is moved among the descendents of this container
=end pod

method set-focus-hadjustment ( N-GObject() $adjustment ) {
  gtk_container_set_focus_hadjustment( self._f('GtkContainer'), $adjustment);
}

sub gtk_container_set_focus_hadjustment (
  N-GObject $container, N-GObject $adjustment
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:set-focus-vadjustment:
=begin pod
=head2 set-focus-vadjustment

Hooks up an adjustment to focus handling in a container, so when a child of the container is focused, the adjustment is scrolled to show that widget. This function sets the vertical alignment. See C<gtk-scrolled-window-get-vadjustment()> for a typical way of obtaining the adjustment and C<set-focus-hadjustment()> for setting the horizontal adjustment.

The adjustments have to be in pixel units and in the same coordinate system as the allocation for immediate children of the container.

  method set-focus-vadjustment ( N-GObject() $adjustment )

=item $adjustment; an adjustment which should be adjusted when the focus is moved among the descendents of this container
=end pod

method set-focus-vadjustment ( N-GObject() $adjustment ) {
  gtk_container_set_focus_vadjustment( self._f('GtkContainer'), $adjustment);
}

sub gtk_container_set_focus_vadjustment (
  N-GObject $container, N-GObject $adjustment
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:add:
=head2 add

  method handler (
    N-GObject #`{ native widget } $n-widget,
    Gnome::Gtk3::Container :_widget($container),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $n-widget; the added widget
=item $container; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:check-resize:
=head2 check-resize

  method handler (
    Gnome::Gtk3::Container :_widget($container),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $container; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:remove:
=head2 remove

  method handler (
    N-GObject #`{ native widget } $n-widget,
    Gnome::Gtk3::Container :_widget($container),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $n-widget; The removed widget
=item $container; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=comment -----------------------------------------------------------------------
=comment #TS:0:set-focus-child:
=head2 set-focus-child

  method handler (
    N-GObject #`{ native widget } $widget,
    Gnome::Gtk3::Container :_widget($container),
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $widget; The focussed child
=item $container; The instance which registered the signal
=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod



#`{{
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
=comment #TS:1:add:
=head3 add

  method handler (
    N-GObject $n-gobject,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($container),
    *%user-options
  );

=item $container;
=item $n-gobject; is added widget

=begin comment
=comment -----------------------------------------------------------------------
=comment # TS:0:check-resize:
=head3 check-resize

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($container),
    *%user-options
  );

=item $container;
=end comment

=comment -----------------------------------------------------------------------
=comment #TS:1:remove:
=head3 remove

  method handler (
    N-GObject #`{ is widget } $n-gobject #`{ is widget },
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($container),
    *%user-options
  );

=item $container;
=item $n-gobject #`{ is widget };

=comment -----------------------------------------------------------------------
=comment #TS:0:set-focus-child:
=head3 set-focus-child

  method handler (
    N-GObject #`{ is widget } $n-gobject #`{ is widget },
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($container),
    *%user-options
  );

=item $container;
=item $n-gobject #`{ is widget };

=end pod
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

=comment -----------------------------------------------------------------------
=comment #TP:0:border-width:
=head2 border-width

The width of the empty border outside the containers children

=item B<Gnome::GObject::Value> type of this property is G_TYPE_UINT
=item Parameter is readable and writable.
=item Minimum value is 0.
=item Maximum value is 65535.
=item Default value is 0.

=end pod
