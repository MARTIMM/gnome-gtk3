#TL:1:Gnome::Gtk3::StackSidebar:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::StackSidebar

An automatic sidebar widget

![](images/sidebar.png)

=head1 Description


A B<Gnome::Gtk3::StackSidebar> enables you to quickly and easily provide a consistent "sidebar" object for your user interface.

In order to use a B<Gnome::Gtk3::StackSidebar>, you simply use a B<Gnome::Gtk3::Stack> to organize your UI flow, and add the sidebar to your sidebar area. You can use C<gtk_stack_sidebar_set_stack()> to connect the B<Gnome::Gtk3::StackSidebar> to the B<Gnome::Gtk3::Stack>.

=head2 Css Nodes

B<Gnome::Gtk3::StackSidebar> has a single CSS node with name stacksidebar and style class .sidebar.

When circumstances require it, B<Gnome::Gtk3::StackSidebar> adds the .needs-attention style class to the widgets representing the stack pages.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::StackSidebar;
  also is Gnome::Gtk3::Bin;


=head2 Uml Diagram
![](plantuml/StackSidebar.svg)


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::StackSidebar:auth<github:MARTIMM>;
also is Gnome::Gtk3::Bin;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 new()

Create a new StackSidebar object.

  multi method new ( )

=begin comment
Create a StackSidebar object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create a StackSidebar object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )
=end comment

=end pod

#TM:1:new():
#TM:1:new(:native-object):
#TM:0:new(:build-id):
submethod BUILD ( *%options ) {

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::StackSidebar';

  # process all named arguments
  if ? %options<widget> || ? %options<native-object> ||
     ? %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message(
        'Unsupported, undefined, incomplete or wrongly typed options for ' ~
        self.^name ~ ': ' ~ %options.keys.join(', ')
      )
    );
  }

  # create default object
  else {
    self.set-native-object(_gtk_stack_sidebar_new());
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkStackSidebar');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_stack_sidebar_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self.set-class-name-of-sub('GtkStackSidebar');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:1:_gtk_stack_sidebar_new:
#`{{
=begin pod
=head2 [gtk_] stack_sidebar_new

Creates a new sidebar.

Returns: the new B<Gnome::Gtk3::StackSidebar>

  method gtk_stack_sidebar_new ( --> N-GObject )


=end pod
}}

sub _gtk_stack_sidebar_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_stack_sidebar_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_sidebar_set_stack:
=begin pod
=head2 [[gtk_] stack_sidebar_] set_stack

Set the B<Gnome::Gtk3::Stack> associated with this B<Gnome::Gtk3::StackSidebar>.

The sidebar widget will automatically update according to the order (packing) and items within the given B<Gnome::Gtk3::Stack>.

  method gtk_stack_sidebar_set_stack ( N-GObject $stack )

=item N-GObject $stack; a B<Gnome::Gtk3::Stack>

=end pod

sub gtk_stack_sidebar_set_stack ( N-GObject $sidebar, N-GObject $stack  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_stack_sidebar_get_stack:
=begin pod
=head2 [[gtk_] stack_sidebar_] get_stack

Retrieves the stack.
See C<gtk_stack_sidebar_set_stack()>.

Returns: the associated B<Gnome::Gtk3::Stack> or C<Any> if none has been set explicitly

  method gtk_stack_sidebar_get_stack ( --> N-GObject )

=end pod

sub gtk_stack_sidebar_get_stack ( N-GObject $sidebar --> N-GObject )
  is native(&gtk-lib)
  { * }
