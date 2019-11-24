#TL:1:Gnome::Gtk3::Buildable:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Buildable

Interface for objects that can be built by B<Gnome::Gtk3::Builder>

=head1 Description

B<Gnome::Gtk3::Buildable> allows objects to extend and customize their deserialization from B<Gnome::Gtk3::Builder> UI descriptions. The interface includes methods for setting names and properties of objects, parsing custom tags and constructing child objects.

The B<Gnome::Gtk3::Buildable> interface is implemented by all widgets and many of the non-widget objects that are provided by GTK+. The main user of this interface is B<Gnome::Gtk3::Builder>. There should be very little need for applications to call any of these functions directly. An object only needs to implement this interface if it needs to extend the B<Gnome::Gtk3::Builder> format or run any extra routines at deserialization time.

=head2 Known implementations

As stated above Gnome::Gtk3::Buildable is implemented by all widgets and many of the non-widget objects that are provided by GTK+.

=head1 Synopsis
=head2 Declaration

  unit role Gnome::Gtk3::Buildable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;

#-------------------------------------------------------------------------------
unit role Gnome::Gtk3::Buildable;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

#-------------------------------------------------------------------------------
#TM:1:new():interfacing
# interfaces are not instantiated
submethod BUILD ( *%options ) { }

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
# Hook for modules using this interface. Same principle as _fallback but
# does not need callsame. Also this method must be usable without
# an instated object
method _buildable_interface ( Str $native-sub --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_buildable_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::("$native-sub"); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s
}

#-------------------------------------------------------------------------------
#TM:1:gtk_buildable_set_name:
=begin pod
=head2 [gtk_buildable_] set_name

Sets the name of the I<buildable> object.

Since: 2.12

  method gtk_buildable_set_name ( Str $name )

=item Str $name; name to set

=end pod

sub gtk_buildable_set_name ( N-GObject $buildable, Str $name )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_buildable_get_name:
=begin pod
=head2 [gtk_buildable_] get_name

Gets the name of the I<buildable> object.

B<Gnome::Gtk3::Builder> sets the name based on the
[B<Gnome::Gtk3::Builder> UI definition][BUILDER-UI]
used to construct the I<buildable>.

Returns: the name set with C<gtk_buildable_set_name()>

Since: 2.12

  method gtk_buildable_get_name ( --> Str  )


=end pod

sub gtk_buildable_get_name ( N-GObject $buildable )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_add_child:
=begin pod
=head2 [gtk_buildable_] add_child

Adds a child to I<buildable>. I<type> is an optional string
describing how the child should be added.

Since: 2.12

  method gtk_buildable_add_child ( N-GObject $builder, N-GObject $child, Str $type )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>
=item N-GObject $child; child to add
=item Str $type; (allow-none): kind of child or C<Any>

=end pod

sub gtk_buildable_add_child ( N-GObject $buildable, N-GObject $builder, N-GObject $child, Str $type )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_set_buildable_property:
=begin pod
=head2 [gtk_buildable_] set_buildable_property

Sets the property name I<name> to I<value> on the I<buildable> object.

Since: 2.12

  method gtk_buildable_set_buildable_property ( N-GObject $builder, Str $name, N-GObject $value )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>
=item Str $name; name of property
=item N-GObject $value; value of property

=end pod

sub gtk_buildable_set_buildable_property ( N-GObject $buildable, N-GObject $builder, Str $name, N-GObject $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_construct_child:
=begin pod
=head2 [gtk_buildable_] construct_child

Constructs a child of I<buildable> with the name I<name>.

B<Gnome::Gtk3::Builder> calls this function if a “constructor” has been
specified in the UI definition.

Returns: (transfer full): the constructed child

Since: 2.12

  method gtk_buildable_construct_child ( N-GObject $builder, Str $name --> N-GObject  )

=item N-GObject $builder; B<Gnome::Gtk3::Builder> used to construct this object
=item Str $name; name of child to construct

=end pod

sub gtk_buildable_construct_child ( N-GObject $buildable, N-GObject $builder, Str $name )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_custom_tag_start:
=begin pod
=head2 [gtk_buildable_] custom_tag_start

This is called for each unknown element under <child>.

Returns: C<1> if a object has a custom implementation, C<0>
if it doesn't.

Since: 2.12

  method gtk_buildable_custom_tag_start ( N-GObject $builder, N-GObject $child, Str $tagname, GMarkupParser $parser, Pointer $data --> Int  )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder> used to construct this object
=item N-GObject $child; (allow-none): child object or C<Any> for non-child tags
=item Str $tagname; name of tag
=item GMarkupParser $parser; (out): a B<GMarkupParser> to fill in
=item Pointer $data; (out): return location for user data that will be passed in  to parser functions

=end pod

sub gtk_buildable_custom_tag_start ( N-GObject $buildable, N-GObject $builder, N-GObject $child, Str $tagname, GMarkupParser $parser, Pointer $data )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_custom_tag_end:
=begin pod
=head2 [gtk_buildable_] custom_tag_end

This is called at the end of each custom element handled by
the buildable.

Since: 2.12

  method gtk_buildable_custom_tag_end ( N-GObject $builder, N-GObject $child, Str $tagname, Pointer $data )

=item N-GObject $builder; B<Gnome::Gtk3::Builder> used to construct this object
=item N-GObject $child; (allow-none): child object or C<Any> for non-child tags
=item Str $tagname; name of tag
=item Pointer $data; (type gpointer): user data that will be passed in to parser functions

=end pod

sub gtk_buildable_custom_tag_end ( N-GObject $buildable, N-GObject $builder, N-GObject $child, Str $tagname, Pointer $data )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_custom_finished:
=begin pod
=head2 [gtk_buildable_] custom_finished

This is similar to C<gtk_buildable_parser_finished()> but is
called once for each custom tag handled by the I<buildable>.

Since: 2.12

  method gtk_buildable_custom_finished ( N-GObject $builder, N-GObject $child, Str $tagname, Pointer $data )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>
=item N-GObject $child; (allow-none): child object or C<Any> for non-child tags
=item Str $tagname; the name of the tag
=item Pointer $data; user data created in custom_tag_start

=end pod

sub gtk_buildable_custom_finished ( N-GObject $buildable, N-GObject $builder, N-GObject $child, Str $tagname, Pointer $data )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_parser_finished:
=begin pod
=head2 [gtk_buildable_] parser_finished

Called when the builder finishes the parsing of a
[B<Gnome::Gtk3::Builder> UI definition][BUILDER-UI].
Note that this will be called once for each time
C<gtk_builder_add_from_file()> or C<gtk_builder_add_from_string()>
is called on a builder.

Since: 2.12

  method gtk_buildable_parser_finished ( N-GObject $builder )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>

=end pod

sub gtk_buildable_parser_finished ( N-GObject $buildable, N-GObject $builder )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_buildable_get_internal_child:
=begin pod
=head2 [gtk_buildable_] get_internal_child

Get the internal child called I<childname> of the I<buildable> object.

Returns: (transfer none): the internal child of the buildable object

Since: 2.12

  method gtk_buildable_get_internal_child ( N-GObject $builder, Str $childname --> N-GObject  )

=item N-GObject $builder; a B<Gnome::Gtk3::Builder>
=item Str $childname; name of child

=end pod

sub gtk_buildable_get_internal_child ( N-GObject $buildable, N-GObject $builder, Str $childname )
  returns N-GObject
  is native(&gtk-lib)
  { * }
