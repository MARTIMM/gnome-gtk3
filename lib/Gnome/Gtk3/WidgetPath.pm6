#TL:1:Gnome::Gtk3::WidgetPath

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::WidgetPath

Widget path abstraction

=head1 Description

B<Gnome::Gtk3::WidgetPath> is a boxed type that represents a widget hierarchy from the topmost widget, typically a toplevel, to any child. This widget path abstraction is used in B<Gnome::Gtk3::StyleContext> on behalf of the real widget in order to query style information.

If you are using GTK+ widgets, you probably will not need to use this API directly, as there is C<gtk_widget_get_path()>, and the style context returned by C<gtk_widget_get_style_context()> will be automatically updated on widget hierarchy changes.


=begin comment
=head2 Defining a button within a window
The widget path generation is generally simple

|[<!-- language="C" -->
{
  B<Gnome::Gtk3::WidgetPath> *path;

  path = C<gtk_widget_path_new()>;
  gtk_widget_path_append_type (path, GTK_TYPE_WINDOW);
  gtk_widget_path_append_type (path, GTK_TYPE_BUTTON);
}
]|

Although more complex information, such as widget names, or different classes (property that may be used by other widget types) and intermediate regions may be included:

=head2 Defining the first tab widget in a notebook

|[<!-- language="C" -->
{
  B<Gnome::Gtk3::WidgetPath> *path;
  guint pos;

  path = C<gtk_widget_path_new()>;

  pos = gtk_widget_path_append_type (path, GTK_TYPE_NOTEBOOK);
  gtk_widget_path_iter_add_region (path, pos, "tab", GTK_REGION_EVEN | GTK_REGION_FIRST);

  pos = gtk_widget_path_append_type (path, GTK_TYPE_LABEL);
  gtk_widget_path_iter_set_name (path, pos, "first tab label");
}
]|

All this information will be used to match the style information that applies to the described widget.

=end comment

=head2 See Also

B<Gnome::Gtk3::StyleContext>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::WidgetPath;
  also is Gnome::GObject::Boxed;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Glib::SList;
use Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::WidgetPath:auth<github:MARTIMM>;
also is Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
#TT:-:N-GtkWidgetPath
class N-GtkWidgetPath
  is repr('CPointer')
  is export
  { }

#-------------------------------------------------------------------------------
has Bool $.widgetpath-is-valid = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

  multi method new ( Bool :$empty! )


Create an object using a native object from elsewhere.

  multi method new ( N-GtkWidgetPath :$widgetpath! )

=end pod

#TM:0:new():
#TM:0:new(:native-object):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  #$signals-added = self.add-signal-types( $?CLASS.^name,
  #  # ... :type<signame>
  #) unless $signals-added;

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::WidgetPath';

  # process all named arguments
  if ? %options<empty> {
    Gnome::N::deprecate( '.new(:empty)', '.new()', '0.21.3', '0.30.0');
    _gtk_widget_path_free(self.get-native-object) if $!widgetpath-is-valid;
    self.set-native-object(gtk_widget_path_new());
    $!widgetpath-is-valid = True;
  }

  #TODO widgetpath is a native-object
  elsif ? %options<widgetpath> {
    Gnome::N::deprecate(
      '.new(:widgetpath())', '.new(:native-object())', '0.21.3', '0.30.0'
    );
    _gtk_widget_path_free(self.get-native-object) if $!widgetpath-is-valid;
    self.set-native-object(%options<widgetpath>);
    $!widgetpath-is-valid = %options<widgetpath>.defined;
  }

  elsif ? %options<native-object> {
    _gtk_widget_path_free(self.get-native-object) if $!widgetpath-is-valid;
    self.set-native-object(%options<native-object>);
    $!widgetpath-is-valid = %options<native-object>.defined;
  }

  elsif %options.keys.elems {
    # must clear because exception can be captured!
    _gtk_widget_path_free(self.get-native-object) if $!widgetpath-is-valid;
    $!widgetpath-is-valid = False;

    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  else {#if ? %options<empty> {
    _gtk_widget_path_free(self.get-native-object) if $!widgetpath-is-valid;
    self.set-native-object(gtk_widget_path_new());
    $!widgetpath-is-valid = True;
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkWidgetPath');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_widget_path_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkWidgetPath');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:1:clear-widgetpath
=begin pod
=head2 clear-widget-path

Clear the widget path and return native object to memory.

  method clear-widget-path ( )

=end pod

method clear-widget-path ( ) {
  _gtk_widget_path_free(self.get-native-object);
  $!widgetpath-is-valid = False;
}

#-------------------------------------------------------------------------------
#TM:1:widgetpath-is-valid
=begin pod
=head2 widgetpath-is-valid

Returns True if native object is valid, otherwise False.

  method widgetpath-is-valid ( --> Bool )

=end pod
# getter defined implicitly above

#-------------------------------------------------------------------------------
#TM:1:gtk_widget_path_new
=begin pod
=head2 [gtk_] widget_path_new

Returns an empty native widget path object.

Since: 3.0

  method gtk_widget_path_new ( --> N-GtkWidgetPath  )

=end pod

sub gtk_widget_path_new (  )
  returns N-GtkWidgetPath
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_widget_path_copy
=begin pod
=head2 [gtk_] widget_path_copy

Returns a copy of the native object

Since: 3.0

  method gtk_widget_path_copy ( --> N-GtkWidgetPath  )

=end pod

sub gtk_widget_path_copy ( N-GtkWidgetPath $path )
  returns N-GtkWidgetPath
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_ref
=begin pod
=head2 [gtk_] widget_path_ref

Increments the reference count on I<path>.

Returns: I<path> itself.

Since: 3.2

  method gtk_widget_path_ref ( --> N-GtkWidgetPath  )

=end pod

sub gtk_widget_path_ref ( N-GtkWidgetPath $path )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_unref
=begin pod
=head2 [gtk_] widget_path_unref

Decrements the reference count on I<path>, freeing the structure if the reference count reaches 0.

Since: 3.2

  method gtk_widget_path_unref ( )

=end pod

sub gtk_widget_path_unref ( N-GtkWidgetPath $path )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_free
#`{{
No pod info. user must use clear-widgetpath()
}}
sub _gtk_widget_path_free ( N-GtkWidgetPath $path )
  is native(&gtk-lib)
  is symbol('gtk_widget_path_free')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_widget_path_to_string
=begin pod
=head2 [[gtk_] widget_path_] to_string

Dumps the widget path into a string representation. It tries to match the CSS style as closely as possible (Note that there might be paths that cannot be represented in CSS).

The main use of this code is for debugging purposes.

Returns: A new string describing the path.

Since: 3.2

  method gtk_widget_path_to_string ( --> Str )

=end pod

sub gtk_widget_path_to_string ( N-GtkWidgetPath $path )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_widget_path_length
=begin pod
=head2 [gtk_] widget_path_length

Returns the number of widget B<GTypes> between the represented widget and its topmost container.

Returns: the number of elements in the path

Since: 3.0

  method gtk_widget_path_length ( --> Int )

=end pod

sub gtk_widget_path_length ( N-GtkWidgetPath $path )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_append_type
=begin pod
=head2 [[gtk_] widget_path_] append_type

Appends a widget type to the widget hierarchy represented by the path.

Returns: the position where the element was inserted

Since: 3.0

  method gtk_widget_path_append_type ( Int $type --> Int  )

=item Int $type; widget type to append

=end pod

sub gtk_widget_path_append_type ( N-GtkWidgetPath $path, int32 $type )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_prepend_type
=begin pod
=head2 [[gtk_] widget_path_] prepend_type

Prepends a widget type to the widget hierachy represented by the path.

Since: 3.0

  method gtk_widget_path_prepend_type ( Int $type )

=item N-GObject $type; widget type to prepend

=end pod

sub gtk_widget_path_prepend_type ( N-GtkWidgetPath $path, int32 $type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_append_with_siblings
=begin pod
=head2 [[gtk_] widget_path_] append_with_siblings

Appends a widget type with all its siblings to the widget hierarchy
represented by I<path>. Using this function instead of
C<gtk_widget_path_append_type()> will allow the CSS theming to use
sibling matches in selectors and apply prop C<nth-child>() pseudo classes.
In turn, it requires a lot more care in widget implementations as
widgets need to make sure to call C<gtk_widget_reset_style()> on all
involved widgets when the I<siblings> path changes.

Returns: the position where the element was inserted.

Since: 3.2

  method gtk_widget_path_append_with_siblings ( N-GObject $siblings, UInt $sibling_index --> Int  )

=item N-GtkWidgetPath $siblings; a widget path describing a list of siblings. This path may not contain any siblings itself and it must not be modified afterwards.
=item UInt $sibling_index; index into I<siblings> for where the added element is positioned.

=end pod

sub gtk_widget_path_append_with_siblings ( N-GtkWidgetPath $path, N-GtkWidgetPath $siblings, uint32 $sibling_index )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_append_for_widget
=begin pod
=head2 [[gtk_] widget_path_] append_for_widget

  method gtk_widget_path_append_for_widget ( N-GObject $widget --> Int  )

=item N-GObject $widget;

=end pod

sub gtk_widget_path_append_for_widget ( N-GtkWidgetPath $path, N-GObject $widget )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_iter_get_object_type
=begin pod
=head2 [[gtk_] widget_path_] iter_get_object_type

Returns the object C<GType> that is at position I<pos> in the widget hierarchy defined in I<path>.

Returns: a widget type

Since: 3.0

  method gtk_widget_path_iter_get_object_type ( Int $pos --> N-GObject  )

=item Int $pos; position to get the object type for, -1 for the path head

=end pod

sub gtk_widget_path_iter_get_object_type ( N-GtkWidgetPath $path, int32 $pos )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] widget_path_] iter_set_object_type

Sets the object type for a given position in the widget hierarchy defined by I<path>.

Since: 3.0

  method gtk_widget_path_iter_set_object_type ( Int $pos, N-GObject $type )

=item Int $pos; position to modify, -1 for the path head
=item N-GObject $type; object type to set

=end pod

sub gtk_widget_path_iter_set_object_type ( N-GtkWidgetPath $path, int32 $pos, int32 $type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_iter_get_object_name
=begin pod
=head2 [[gtk_] widget_path_] iter_get_object_name

Returns the object name that is at position pos in the widget hierarchy defined in path

  method gtk_widget_path_iter_get_object_name ( Int $pos --> Str )

=item gtk_widget_path_iter_get_object_name const GtkWidgetPath *path;
=item Int $pos;

=end pod

sub gtk_widget_path_iter_get_object_name ( N-GtkWidgetPath $path, int32 $pos )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_iter_set_object_name
=begin pod
=head2 [[gtk_] widget_path_] iter_set_object_name

Sets the object name for a given position in the widget hierarchy defined by I<path>.

When set, the object name overrides the object type when matching
CSS.

Since: 3.20

  method gtk_widget_path_iter_set_object_name ( Int $pos, Str $name )

=item Int $pos; position to modify, -1 for the path head
=item char $name; (allow-none): object name to set or C<Any> to unset

=end pod

sub gtk_widget_path_iter_set_object_name ( N-GtkWidgetPath $path, int32 $pos, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_iter_get_siblings
=begin pod
=head2 [[gtk_] widget_path_] iter_get_siblings

Returns the list of siblings for the element at I<pos>. If the element was not added with siblings, C<Any> is returned.

Returns: C<Any> or the list of siblings for the element at I<pos>.

  method gtk_widget_path_iter_get_siblings ( Int $pos --> N-GObject  )

=item Int $pos; position to get the siblings for, -1 for the path head

=end pod

sub gtk_widget_path_iter_get_siblings ( N-GtkWidgetPath $path, int32 $pos )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_iter_get_sibling_index
=begin pod
=head2 [[gtk_] widget_path_] iter_get_sibling_index

Returns the index into the list of siblings for the element at I<pos> as returned by C<gtk_widget_path_iter_get_siblings()>. If that function would return C<Any> because the element at I<pos> has no siblings, this function will return 0.

Returns: 0 or the index into the list of siblings for the element at I<pos>.

  method gtk_widget_path_iter_get_sibling_index ( Int $pos --> UInt  )

=item Int $pos; position to get the sibling index for, -1 for the path head

=end pod

sub gtk_widget_path_iter_get_sibling_index ( N-GtkWidgetPath $path, int32 $pos )
  returns uint32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_widget_path_iter_get_name
=begin pod
=head2 [[gtk_] widget_path_] iter_get_name

Returns the name corresponding to the widget found at the position I<$pos> in the widget hierarchy. This name can be set using C<$widget.gtk_widget_set_name('...')>.

Returns: The widget name, or C<Str> if none was set.

  method gtk_widget_path_iter_get_name ( Int $pos --> Str  )

=item Int $pos; position to get the widget name for, -1 for the path head

=end pod

sub gtk_widget_path_iter_get_name ( N-GtkWidgetPath $path, int32 $pos )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_widget_path_iter_set_name
=begin pod
=head2 [[gtk_] widget_path_] iter_set_name

Sets the widget name for the widget found at position I<$pos> in the widget hierarchy.

Since: 3.0

  method gtk_widget_path_iter_set_name ( Int $pos, Str $name )

=item Int $pos; position to modify, -1 for the path head
=item Str $name; widget name

=end pod

sub gtk_widget_path_iter_set_name ( N-GtkWidgetPath $path, int32 $pos, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_widget_path_iter_has_name
=begin pod
=head2 [[gtk_] widget_path_] iter_has_name

Returns C<1> if the widget at position I<$pos> has the name I<name>, C<0> otherwise.

Since: 3.0

  method gtk_widget_path_iter_has_name ( Int $pos, Str $name --> Int  )

=item Int $pos; position to query, -1 for the path head
=item Str $name; a widget name

=end pod

sub gtk_widget_path_iter_has_name ( N-GtkWidgetPath $path, int32 $pos, Str $name )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_iter_has_qname
=begin pod
=head2 [[gtk_] widget_path_] iter_has_qname

See C<gtk_widget_path_iter_has_name()>. This is a version that operates on C<GQuarks>.

Returns: C<1> if the widget at I<pos> has this name

Since: 3.0

  method gtk_widget_path_iter_has_qname ( Int $pos, Int $qname --> Int  )

=item Int $pos; position to query, -1 for the path head
=item Int $qname; widget name as a C<GQuark>

=end pod

sub gtk_widget_path_iter_has_qname (
  N-GtkWidgetPath $path, int32 $pos, int32 $qname
) returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_widget_path_iter_get_state
=begin pod
=head2 [[gtk_] widget_path_] iter_get_state

Returns the state flags corresponding to the widget found at the position I<$pos> in the widget hierarchy.

Returns: The state flags

Since: 3.14

  method gtk_widget_path_iter_get_state ( Int $pos --> GtkStateFlags  )

=item Int $pos; position to get the state for, -1 for the path head

=end pod

sub gtk_widget_path_iter_get_state ( N-GtkWidgetPath $path, int32 $pos )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_widget_path_iter_set_state
=begin pod
=head2 [[gtk_] widget_path_] iter_set_state

Sets the widget name for the widget found at position I<$pos> in the widget hierarchy.

If you want to update just a single state flag, you need to do this manually, as this function updates all state flags.

Example setting a flag on 3rd item in the widget path

  my Int $new-state = $wp.iter-get-state(2) +| GTK_STATE_FLAG_INSENSITIVE.value;
  $wp.iter-set-state( 2, $new-state);

And unsetting a flag

  my Int $drop-flag = GTK_STATE_FLAG_INSENSITIVE.value +^ 0xFFFFFFFF;
  my Int $new-state = $wp.iter-get-state(2) +& $drop-flag;
  $wp.iter-set-state( 2, $new-state);

Since: 3.14

  method gtk_widget_path_iter_set_state ( Int $pos, GtkStateFlags $state )

=item Int $pos; position to modify, -1 for the path head
=item GtkStateFlags $state; state flags

=end pod

sub gtk_widget_path_iter_set_state ( N-GtkWidgetPath $path, int32 $pos, int32 $state )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_iter_add_class
=begin pod
=head2 [[gtk_] widget_path_] iter_add_class

Adds the class I<name> to the widget at position I<pos> in the hierarchy defined in I<path>. See C<gtk_style_context_add_class()>.

Since: 3.0

  method gtk_widget_path_iter_add_class ( Int $pos, Str $name )

=item Int $pos; position to modify, -1 for the path head
=item Str $name; a class name

=end pod

sub gtk_widget_path_iter_add_class ( N-GtkWidgetPath $path, int32 $pos, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_iter_remove_class
=begin pod
=head2 [[gtk_] widget_path_] iter_remove_class

Removes the class I<name> from the widget at position I<pos> in the hierarchy defined in I<path>.

Since: 3.0

  method gtk_widget_path_iter_remove_class ( Int $pos, Str $name )

=item Int $pos; position to modify, -1 for the path head
=item Str $name; class name

=end pod

sub gtk_widget_path_iter_remove_class ( N-GtkWidgetPath $path, int32 $pos, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_iter_clear_classes
=begin pod
=head2 [[gtk_] widget_path_] iter_clear_classes

Removes all classes from the widget at position I<pos> in the hierarchy defined in I<path>.

Since: 3.0

  method gtk_widget_path_iter_clear_classes ( Int $pos )

=item Int $pos; position to modify, -1 for the path head

=end pod

sub gtk_widget_path_iter_clear_classes ( N-GtkWidgetPath $path, int32 $pos )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_widget_path_iter_list_classes
=begin pod
=head2 [[gtk_] widget_path_] iter_list_classes

Returns a list with all the class names defined for the widget at position I<pos> in the hierarchy defined in I<path>.

Returns: The list of classes, This is a list of strings, the C<GSList> contents are owned by GTK+, but you should use C<g_slist_free()> to free the list itself.

Since: 3.0

  method gtk_widget_path_iter_list_classes ( Int $pos --> N-GSList )

=item Int $pos; position to query, -1 for the path head

=end pod

sub gtk_widget_path_iter_list_classes ( N-GtkWidgetPath $path, int32 $pos )
  returns N-GSList
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_widget_path_iter_has_class
=begin pod
=head2 [[gtk_] widget_path_] iter_has_class

Returns C<1> if the widget at position I<pos> has the class I<name>
defined, C<0> otherwise.

Returns: C<1> if the class I<name> is defined for the widget at I<pos>

Since: 3.0

  method gtk_widget_path_iter_has_class ( Int $pos, Str $name --> Int  )

=item Int $pos; position to query, -1 for the path head
=item Str $name; class name

=end pod

sub gtk_widget_path_iter_has_class ( N-GtkWidgetPath $path, int32 $pos, Str $name )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_widget_path_iter_has_qclass
=begin pod
=head2 [[gtk_] widget_path_] iter_has_qclass

See C<gtk_widget_path_iter_has_class()>. This is a version that operates
with GQuarks.

Returns: C<1> if the widget at I<pos> has the class defined.

Since: 3.0

  method gtk_widget_path_iter_has_qclass ( Int $pos, N-GtkWidgetPath $qname --> Int  )

=item Int $pos; position to query, -1 for the path head
=item int32 $qname; class name as a C<GQuark>

=end pod

sub gtk_widget_path_iter_has_qclass ( N-GtkWidgetPath $path, int32 $pos, int32 $qname )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] widget_path_] get_object_type

Returns the topmost object type, that is, the object type this path
is representing.

Returns: The object type

Since: 3.0

  method gtk_widget_path_get_object_type ( --> int32 )


=end pod

sub gtk_widget_path_get_object_type ( N-GtkWidgetPath $path )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] widget_path_] is_type

Returns C<1> if the widget type represented by this path
is I<type>, or a subtype of it.

Returns: C<1> if the widget represented by I<path> is of type I<type>

Since: 3.0

  method gtk_widget_path_is_type ( Int $type --> Int  )

=item Int $type; widget type to match

=end pod

sub gtk_widget_path_is_type ( N-GtkWidgetPath $path, int32 $type )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:
=begin pod
=head2 [[gtk_] widget_path_] has_parent

Returns C<1> if any of the parents of the widget represented
in I<path> is of type I<type>, or any subtype of it.

Returns: C<1> if any parent is of type I<type>

Since: 3.0

  method gtk_widget_path_has_parent ( Int $type --> Int  )

=item Int $type; widget type to check in parents

=end pod

sub gtk_widget_path_has_parent ( N-GtkWidgetPath $path, int32 $type )
  returns int32
  is native(&gtk-lib)
  { * }
