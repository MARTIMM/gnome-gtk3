#TL:1:Gnome::Gtk3::TreeStore:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::TreeStore

A tree-like data structure that can be used with the B<Gnome::Gtk3::TreeView>

=head1 Description

The B<Gnome::Gtk3::TreeStore> object is a list model for use with a B<Gnome::Gtk3::TreeView> widget.  It implements the B<Gnome::Gtk3::TreeModel> interface, and consequentially, can use all of the methods available there.  It also implements the B<Gnome::Gtk3::TreeSortable> interface so it can be sorted by the view.  Finally, it also implements the tree drag and drop interfaces.

=head2 Gnome::Gtk3::TreeStore as Gnome::Gtk3::Buildable

The B<Gnome::Gtk3::TreeStore> implementation of the B<Gnome::Gtk3::Buildable> interface allows to specify the model columns with a <columns> element that may contain multiple <column> elements, each specifying one model column. The “type” attribute specifies the data type for the column.

An example of a UI Definition fragment for a tree store:

  <object class="GtkTreeStore">
    <columns>
      <column type="gchararray"/>
      <column type="gchararray"/>
      <column type="gint"/>
    </columns>
  </object>

=head2 Implemented Interfaces

Gnome::Gtk3::TreeStore implements
=item [Gnome::Gtk3::Buildable](Buildable.html)
=item [Gnome::Gtk3::TreeModel](TreeModel.html)
=item Gnome::Gtk3::TreeDragSource
=item Gnome::Gtk3::TreeDragDest
=item Gnome::Gtk3::TreeSortable

=head2 See Also

B<Gnome::Gtk3::TreeModel>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::TreeStore;
  also is Gnome::GObject::Object;
  also does Gnome::Gtk3::Buildable;
  also does Gnome::Gtk3::TreeModel;
=comment  also does Gnome::Gtk3::TreeDragSource;
=comment  also does Gnome::Gtk3::TreeDragDest;
=comment  also does Gnome::Gtk3::TreeSortable;

=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::GObject::Object;
use Gnome::GObject::Type;
use Gnome::GObject::Value;
use Gnome::Gtk3::TreeIter;

use Gnome::Gtk3::Buildable;
use Gnome::Gtk3::TreeModel;
#use Gnome::Gtk3::TreeDragSource;
#use Gnome::Gtk3::TreeDragDest;
#use Gnome::Gtk3::TreeSortable;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::TreeStore:auth<github:MARTIMM>;
also is Gnome::GObject::Object;
also does Gnome::Gtk3::Buildable;
also does Gnome::Gtk3::TreeModel;
#also does Gnome::Gtk3::TreeDragSource;
#also does Gnome::Gtk3::TreeDragDest;
#also does Gnome::Gtk3::TreeSortable;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a new TreeStore object with the given field types.

  multi method new ( Bool :@field-types! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$native-object! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:field-types):
#TM:0:new(:native-object):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  # add signal info in the form of group<signal-name>.
  # groups are e.g. signal, event, nativeobject etc
  unless $signals-added {
    # no signals of its own
    $signals-added = True;

    # signals from interfaces
    self._add_tree_model_signal_types($?CLASS.^name);
  }

  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::TreeStore';

  # process all named arguments
  if ? %options<field-types> {
    self.set-native-object(gtk_tree_store_new(|%options<field-types>));
  }

  elsif ? %options<native-object> || ? %options<widget> || %options<build-id> {
    # provided in Gnome::GObject::Object
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the native-object, the gtype is known
  self.set-class-info('GtkTreeStore');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_tree_store_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._buildable_interface($native-sub) unless ?$s;
  $s = self._tree_model_interface($native-sub) unless ?$s;
#  $s = self._tree_drag_store_interface($native-sub) unless ?$s;
#  $s = self._tree_drag_dest_interface($native-sub) unless ?$s;
#  $s = self._tree_sortable_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkTreeStore');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:2:gtk_tree_store_new:new(:field-types)
=begin pod
=head2 [gtk_] tree_store_new

Creates a new tree store as with columns each of the types passed in.  Note that only types derived from standard GObject fundamental types are supported.

=comment As an example, C<$ts.gtk_tree_store_new( 3, G_TYPE_INT, G_TYPE_STRING, GDK_TYPE_PIXBUF);> will create a new B<Gnome::Gtk3::TreeStore> with three columns, of type int, string and B<Gnome::Gdk3::Pixbuf> respectively.

As an example, C<$ts.gtk_tree_store_new( G_TYPE_INT, G_TYPE_STRING, G_TYPE_STRING);> will create a new B<Gnome::Gtk3::TreeStore> with three columns, of type int, and two of type string respectively.

Returns: a new B<Gnome::Gtk3::TreeStore>

  method gtk_tree_store_new ( Int $column-type, ... --> N-GObject  )

=item Int $column-type; all B<GType> types for the columns, from first to last

=end pod

sub gtk_tree_store_new ( *@column-types --> N-GObject ) {

  # arg list starts with n_columns
  my @parameter-list = (
    Parameter.new(type => int32)
  );

  # then n column-types
  for @column-types -> Int $i {
    # all types are int
    @parameter-list.push(Parameter.new(type => uint64));
  }

  # create signature
  my Signature $signature .= new(
    :params(|@parameter-list),
    :returns(N-GObject)
  );

  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal( &gtk-lib, 'gtk_tree_store_new', Pointer);
  my Callable $f = nativecast( $signature, $ptr);

  $f( @column-types.elems, |@column-types)
}

#`{{
#-------------------------------------------------------------------------------
#TM:FF:gtk_tree_store_newv:
=begin pod
=head2 [gtk_] tree_store_newv

Non vararg creation function.  Used primarily by language bindings.

Returns: (transfer full): a new B<Gnome::Gtk3::TreeStore>

  method gtk_tree_store_newv ( Int $n_columns, UInt $types --> N-GObject  )

=item Int $n_columns; number of columns in the tree store
=item UInt $types; (array length=n_columns): an array of B<GType> types for the columns, from first to last

=end pod

sub gtk_tree_store_newv ( int32 $n_columns, uint64 $types )
  returns N-GObject
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:FF:gtk_tree_store_set_column_types:
=begin pod
=head2 [[gtk_] tree_store_] set_column_types

This function is meant primarily for B<GObjects> that inherit from
B<Gnome::Gtk3::TreeStore>, and should only be used when constructing a new
B<Gnome::Gtk3::TreeStore>.  It will not function after a row has been added,
or a method on the B<Gnome::Gtk3::TreeModel> interface is called.

  method gtk_tree_store_set_column_types ( Int $n_columns, UInt $types )

=item Int $n_columns; Number of columns for the tree store
=item UInt $types; (array length=n_columns): An array of B<GType> types, one for each column

=end pod

sub gtk_tree_store_set_column_types ( N-GObject $tree_store, int32 $n_columns, uint64 $types )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_store_set_value:
=begin pod
=head2 [[gtk_] tree_store_] set_value

Sets the data in the cell specified by I<$iter> and I<$column>. The type of I<$value> must be convertible to the type of the column.

  method gtk_tree_store_set_value (
    Gnome::Gtk3::TreeIter $iter, Int $column, Any $value
  )

=item Gnome::Gtk3::TreeIter $iter; A valid iterator for the row being modified
=item Int $column; column number to modify
=item Any $value; new value for the cell

=end pod

sub gtk_tree_store_set_value (
  N-GObject $tree_store, N-GtkTreeIter $iter, Int $column, Any $value
) {

  my Gnome::GObject::Type $t .= new;
  my @parameter-list = (
    Parameter.new(type => N-GObject),
    Parameter.new(type => N-GtkTreeIter),
    Parameter.new(type => int32),
    Parameter.new(type => N-GValue)
  );

  my Gnome::GObject::Value $v;
  my $type = gtk_tree_model_get_column_type( $tree_store, $column);
  given $type {
    when G_TYPE_OBJECT {
      $v .= new( :$type, :value($value.get-native-object));
    }

    when G_TYPE_BOXED {
      $v .=  new( :$type, :value($value.get-native-object));
    }

#    when G_TYPE_POINTER { $p .= new(type => ); }
#    when G_TYPE_PARAM { $p .= new(type => ); }
#    when G_TYPE_VARIANT {$p .= new(type => ); }

    default {
      $v .= new( :$type, :$value);
    }
  }

  # create signature
  my Signature $signature .= new(
    :params(|@parameter-list),
    :returns(int32)
  );

  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal( &gtk-lib, 'gtk_tree_store_set_value', Pointer);
  my Callable $f = nativecast( $signature, $ptr);

  $f(
    $tree_store, $iter, $column, $v.get-native-object
  );
}

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_store_set:
=begin pod
=head2 [gtk_] tree_store_set

Sets the value of one or more cells in the row referenced by I<$iter>. The variable argument list should contain integer column numbers, each column number followed by the value to be set. For example, to set column 0 with type C<G_TYPE_STRING> to “Foo”, you would write C<$ts.gtk_tree_store_set( $iter, 0, "Foo")>.

The value will be referenced by the store if it is a C<G_TYPE_OBJECT>, and it will be copied if it is a C<G_TYPE_STRING> or C<G_TYPE_BOXED>.

  method gtk_tree_store_set ( Gnome::Gtk3::TreeIter $iter, $col, $val, ... )

=item Gnome::Gtk3::TreeIter $iter; A valid row iterator for the row being modified
=item $col, $val; pairs of column number and value

=end pod

sub gtk_tree_store_set (
  N-GObject $tree_store, N-GtkTreeIter $iter, *@column-value-list
) {

  die X::Gnome.new(:message('Odd number of items in list: colno, val, ...'))
    unless @column-value-list %% 2;

  my @parameter-list = (
    Parameter.new(type => N-GObject),         # $list_store
    Parameter.new(type => N-GtkTreeIter),     # returned iterator
  );

  my Gnome::GObject::Type $t .= new;
  my @column-values = ();
  my Gnome::GObject::Value $v;
  for @column-value-list -> $c, $value {
    my $type = gtk_tree_model_get_column_type( $tree_store, $c);

    @column-values.push: $c;
    given $type {
      when G_TYPE_OBJECT { @column-values.push: $value.get-native-object; }
      when G_TYPE_BOXED { @column-values.push: $value.get-native-object; }

  #    when G_TYPE_POINTER { $p .= new(type => ); }
  #    when G_TYPE_PARAM { $p .= new(type => ); }
  #    when G_TYPE_VARIANT {$p .= new(type => ); }

      default {
        @column-values.push: $value;
      }
    }

    @parameter-list.push: Parameter.new(type => int32);
    @parameter-list.push: $t.get-parameter( $type, :otype($value));
  }

  # to finish the list with -1
  @parameter-list.push: Parameter.new(type => int32);

  # create signature
  my Signature $signature .= new(
    :params( |@parameter-list),
    :returns(int32)
  );

  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal( &gtk-lib, 'gtk_tree_store_set', Pointer);
  my Callable $f = nativecast( $signature, $ptr);

  $f( $tree_store, $iter, |@column-values, -1)
}

#`{{
#-------------------------------------------------------------------------------
#TM:FF:gtk_tree_store_set_valuesv:
=begin pod
=head2 [[gtk_] tree_store_] set_valuesv

A variant of C<gtk_tree_store_set_valist()> which takes
the columns and values as two arrays, instead of varargs.  This
function is mainly intended for language bindings or in case
the number of columns to change is not known until run-time.

Since: 2.12

  method gtk_tree_store_set_valuesv ( Gnome::Gtk3::TreeIter $iter, Int $columns, N-GObject $values, Int $n_values )

=item Gnome::Gtk3::TreeIter $iter; A valid B<Gnome::Gtk3::TreeIter> for the row being modified
=item Int $columns; (array length=n_values): an array of column numbers
=item N-GObject $values; (array length=n_values): an array of GValues
=item Int $n_values; the length of the I<columns> and I<values> arrays

=end pod

sub gtk_tree_store_set_valuesv ( N-GObject $tree_store, N-GtkTreeIter $iter, int32 $columns, N-GObject $values, int32 $n_values )
  is native(&gtk-lib)
  { * }
}}
#`{{
#-------------------------------------------------------------------------------
#TM:FF:gtk_tree_store_set_valist:
=begin pod
=head2 [[gtk_] tree_store_] set_valist

See C<gtk_tree_store_set()>; this version takes a va_list for
use by language bindings.


  method gtk_tree_store_set_valist ( Gnome::Gtk3::TreeIter $iter, va_list $var_args )

=item Gnome::Gtk3::TreeIter $iter; A valid B<Gnome::Gtk3::TreeIter> for the row being modified
=item va_list $var_args; va_list of column/value pairs

=end pod

sub gtk_tree_store_set_valist ( N-GObject $tree_store, N-GtkTreeIter $iter, va_list $var_args )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_store_remove:
=begin pod
=head2 [gtk_] tree_store_remove

Removes the given row from the tree store. After being removed, the returned iterator is set to the next valid row at that level, or invalidated if it previously pointed to the last one.

  method gtk_tree_store_remove (
    Gnome::Gtk3::TreeIter $iter
    --> Gnome::Gtk3::TreeIter
  )

=item Gnome::Gtk3::TreeIter $iter; The iterator pointing to the row which must be removed

=end pod

sub gtk_tree_store_remove (
  N-GObject $tree_store, N-GtkTreeIter $iter
  --> Gnome::Gtk3::TreeIter
) {
  if _gtk_tree_store_remove( $tree_store, $iter) {
    Gnome::Gtk3::TreeIter.new(:native-object($iter))
  }

  else {
    Gnome::Gtk3::TreeIter.new(:native-object(N-GtkTreeIter));
  }
}

sub _gtk_tree_store_remove ( N-GObject $tree_store, N-GtkTreeIter $iter )
  returns int32
  is native(&gtk-lib)
  is symbol('gtk_tree_store_remove')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_store_insert:
=begin pod
=head2 [gtk_] tree_store_insert

Creates a new row at I<$position>. If parent is non-C<Any>, then the row will be made a child of I<$parent>.  Otherwise, the row will be created at the toplevel. If I<$position> is -1 or is larger than the number of rows at that level, then the new row will be inserted to the end of the list. I<$iter> will be changed to point to this new row.  The row will be empty after this function is called.  To fill in values, you need to call C<gtk_tree_store_set()> or C<gtk_tree_store_set_value()>.

  method gtk_tree_store_insert (
    Gnome::Gtk3::TreeIter $parent, Int $position
    --> Gnome::Gtk3::TreeIter
  )

=item Gnome::Gtk3::TreeIter $parent; A valid iterator, or C<Any>
=item Int $position; position to insert the new row, or -1 for last

=end pod

sub gtk_tree_store_insert (
  N-GObject $tree_store, $parent, Int $position
  --> Gnome::Gtk3::TreeIter
) {
  my N-GtkTreeIter $iter .= new;
  _gtk_tree_store_insert( $tree_store, $iter, $parent, $position);
  Gnome::Gtk3::TreeIter.new(:native-object($iter))
}

sub _gtk_tree_store_insert (
  N-GObject $tree_store, N-GtkTreeIter $iter is rw, N-GtkTreeIter $parent,
  int32 $position
) is native(&gtk-lib)
  is symbol('gtk_tree_store_insert')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_store_insert_before:
=begin pod
=head2 [[gtk_] tree_store_] insert_before

Inserts a new row before I<$sibling>.  If I<$sibling> is C<Any>, then the row will be appended to I<$parent> ’s children.  If I<$parent> and I<$sibling> are C<Any>, then the row will be appended to the toplevel.  If both I<$sibling> and I<$parent> are set, then I<$parent> must be the parent of I<$sibling>.  When I<$sibling> is set, I<$parent> is optional.

The returned iterator will point to this new row.  The row will be empty after this function is called.  To fill in values, you need to call C<gtk_tree_store_set()> or C<gtk_tree_store_set_value()>.

  method gtk_tree_store_insert_before (
    Gnome::Gtk3::TreeIter $parent, Gnome::Gtk3::TreeIter $sibling
    --> Gnome::Gtk3::TreeIter
  )

=item Gnome::Gtk3::TreeIter $parent; A valid iterator or C<Any>
=item Gnome::Gtk3::TreeIter $sibling; A valid iterator or C<Any>

=end pod

sub gtk_tree_store_insert_before (
  N-GObject $tree_store, $parent, $sibling
  --> Gnome::Gtk3::TreeIter
) {
  my N-GtkTreeIter $iter .= new;
  _gtk_tree_store_insert_before( $tree_store, $iter, $parent, $sibling);
  Gnome::Gtk3::TreeIter.new(:native-object($iter))
}

sub _gtk_tree_store_insert_before (
  N-GObject $tree_store, N-GtkTreeIter $iter is rw, N-GtkTreeIter $parent,
  N-GtkTreeIter $sibling
) is native(&gtk-lib)
  is symbol('gtk_tree_store_insert_before')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_store_insert_after:
=begin pod
=head2 [[gtk_] tree_store_] insert_after

Inserts a new row after I<$sibling>.  If I<$sibling> is C<+>, then the row will be prepended to I<$parent> ’s children.  If I<$parent> and I<$sibling> are C<Any>, then the row will be prepended to the toplevel.  If both I<$sibling> and I<$parent> are set, then I<$parent> must be the parent of I<$sibling>.  When I<$sibling> is set, I<$parent> is optional.

The returned iterator will to point to this new row.  The row will be empty after this function is called.  To fill in values, you need to call C<gtk_tree_store_set()> or C<gtk_tree_store_set_value()>.

  method gtk_tree_store_insert_after (
    Gnome::Gtk3::TreeIter $parent, Gnome::Gtk3::TreeIter $sibling
    --> Gnome::Gtk3::TreeIter
  )

=item Gnome::Gtk3::TreeIter $parent; A valid iterator or C<Any>
=item Gnome::Gtk3::TreeIter $sibling; A valid iterator or C<Any>

=end pod

sub gtk_tree_store_insert_after (
  N-GObject $tree_store, $parent, $sibling
  --> Gnome::Gtk3::TreeIter
) {
  my N-GtkTreeIter $iter .= new;
  _gtk_tree_store_insert_after( $tree_store, $iter, $parent, $sibling);
  Gnome::Gtk3::TreeIter.new(:native-object($iter))
}

sub _gtk_tree_store_insert_after (
  N-GObject $tree_store, N-GtkTreeIter $iter is rw, N-GtkTreeIter $parent,
  N-GtkTreeIter $sibling
) is native(&gtk-lib)
  is symbol('gtk_tree_store_insert_after')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_store_insert_with_values:
=begin pod
=head2 [[gtk_] tree_store_] insert_with_values

Creates a new row at I<position>. I<iter> will be changed to point to this new row. If I<position> is -1, or larger than the number of rows on the list, then the new row will be appended to the list. The row will be filled with the values given to this function.

Calling C<$ts.gtk_tree_store_insert_with_values(...)> has the same effect as calling;

  $iter = $ts.gtk_tree_store_insert( $parent-iter, $position);
  $ts.gtk_tree_store_set( $iter, ...);

with the difference that the former will only emit a I<row-inserted> signal, while the latter will emit I<row-inserted>, I<row-changed> and if the tree store is sorted, I<rows-reordered>.  Since emitting the C<rows-reordered> signal repeatedly can affect the performance of the program, C<gtk_tree_store_insert_with_values()> should generally be preferred when inserting rows in a sorted tree store.

Since: 2.10

  method gtk_tree_store_insert_with_values (
    Gnome::Gtk3::TreeIter $parent, Int $position, Int $column, $value, ...
    --> Gnome::Gtk3::TreeIter
  )

=item Gnome::Gtk3::TreeIter $parent; A valid iterator, or C<Any>.
=item Int $position; position to insert the new row, or -1 to append after existing rows
=item Int $column, $value, ...; the rest are pairs of column number and value

=end pod

sub gtk_tree_store_insert_with_values (
  N-GObject $tree_store, $parent,
  int32 $position, *@column-value-list
  --> Gnome::Gtk3::TreeIter
) {

  die X::Gnome.new(:message('Odd number of items in list: colno, val, ...'))
    unless @column-value-list %% 2;

  my @parameter-list = (
    Parameter.new(type => N-GObject),         # $tree_store
    Parameter.new(type => N-GtkTreeIter),     # returned iterator
    Parameter.new(type => N-GtkTreeIter),     # parent iterator
    Parameter.new(type => int32),             # $position
  );

  my Gnome::GObject::Value $v;
  my Gnome::GObject::Type $t .= new;
  my @column-values = ();
  my Int $n-columns = gtk_tree_model_get_n_columns($tree_store);

  for @column-value-list -> $c, $value {
    die X::Gnome.new(:message(
      "Column nbr out of range: [0 .. {$n-columns - 1}]")
    ) unless $c < $n-columns;

    # column number
    @column-values.push: $c;

    # column value
    my $type = gtk_tree_model_get_column_type( $tree_store, $c);
    given $type {
      when G_TYPE_OBJECT { @column-values.push: $value.get-native-object; }
      when G_TYPE_BOXED { @column-values.push: $value.get-native-object; }

  #    when G_TYPE_POINTER { $p .= new(type => ); }
  #    when G_TYPE_PARAM { $p .= new(type => ); }
  #    when G_TYPE_VARIANT {$p .= new(type => ); }

      default {
        @column-values.push: $value;
      }
    }

    @parameter-list.push: Parameter.new(type => int32);
    @parameter-list.push: $t.get-parameter( $type, :otype($value));
  }

  # to finish the list with -1
  @parameter-list.push: Parameter.new(type => int32);

  # create signature
  my Signature $signature .= new(
    :params( |@parameter-list),
    :returns(int32)
  );

  # get a pointer to the sub, then cast it to a sub with the proper
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal( &gtk-lib, 'gtk_tree_store_insert_with_values', Pointer);
  my Callable $f = nativecast( $signature, $ptr);

  my N-GtkTreeIter $ni .= new;
  $f( $tree_store, $ni, $parent, $position, |@column-values, -1);

  Gnome::Gtk3::TreeIter.new(:native-object($ni))
}

#sub gtk_tree_store_insert_with_values ( N-GObject $tree_store, N-GtkTreeIter $iter, N-GtkTreeIter $parent, int32 $position, Any $any = Any )
#  is native(&gtk-lib)
#  { * }


#`{{
#-------------------------------------------------------------------------------
#TM:FF:gtk_tree_store_insert_with_valuesv:
=begin pod
=head2 [[gtk_] tree_store_] insert_with_valuesv

A variant of C<gtk_tree_store_insert_with_values()> which takes
the columns and values as two arrays, instead of varargs.  This
function is mainly intended for language bindings.

Since: 2.10

  method gtk_tree_store_insert_with_valuesv ( Gnome::Gtk3::TreeIter $iter, Gnome::Gtk3::TreeIter $parent, Int $position, Int $columns, N-GObject $values, Int $n_values )

=item Gnome::Gtk3::TreeIter $iter; (out) (allow-none): An unset B<Gnome::Gtk3::TreeIter> to set the new row, or C<Any>.
=item Gnome::Gtk3::TreeIter $parent; (allow-none): A valid B<Gnome::Gtk3::TreeIter>, or C<Any>
=item Int $position; position to insert the new row, or -1 for last
=item Int $columns; (array length=n_values): an array of column numbers
=item N-GObject $values; (array length=n_values): an array of GValues
=item Int $n_values; the length of the I<columns> and I<values> arrays

=end pod

sub gtk_tree_store_insert_with_valuesv ( N-GObject $tree_store, N-GtkTreeIter $iter, N-GtkTreeIter $parent, int32 $position, int32 $columns, N-GObject $values, int32 $n_values )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_store_prepend:
=begin pod
=head2 [gtk_] tree_store_prepend

Prepends a new row to the tree_store.  If I<$parent> is non-C<Any>, then it will prepend the new row before the first child of I<$parent>, otherwise it will prepend a row to the top level.  The returned iterator will point to this new row.  The row will be empty after this function is called.  To fill in values, you need to call C<gtk_tree_store_set()> or C<gtk_tree_store_set_value()>.

  method gtk_tree_store_prepend (
    Gnome::Gtk3::TreeIter $parent
    --> Gnome::Gtk3::TreeIter
  )

=item Gnome::Gtk3::TreeIter $parent; A valid iterator, or C<Any>

=end pod

sub gtk_tree_store_prepend (
  N-GObject $list_store, N-GtkTreeIter $parent
  --> Gnome::Gtk3::TreeIter
) {
  my N-GtkTreeIter $iter .= new;
  _gtk_tree_store_prepend( $list_store, $iter, $parent);
  Gnome::Gtk3::TreeIter.new(:native-object($iter))
}

sub _gtk_tree_store_prepend (
  N-GObject $tree_store, N-GtkTreeIter $iter is rw, N-GtkTreeIter $parent
) is native(&gtk-lib)
  is symbol('gtk_tree_store_prepend')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_store_append:
=begin pod
=head2 [gtk_] tree_store_append

Appends a new row to $list_store.  If I<parent> is non-C<Any>, then it will append the new row after the last child of I<parent>, otherwise it will append a row to the top level.  I<iter> will be changed to point to this new row.  The row will be empty after this function is called.  To fill in values, you need to call C<gtk_tree_store_set()> or C<gtk_tree_store_set_value()>.

  method gtk_tree_store_append (
    Gnome::Gtk3::TreeIter $parent
    --> Gnome::Gtk3::TreeIter
  )

=item Gnome::Gtk3::TreeIter $parent; A valid iterator, or C<Any>

=end pod

sub gtk_tree_store_append (
  N-GObject $tree_store, $parent
  --> Gnome::Gtk3::TreeIter
) {

  my N-GtkTreeIter $iter .= new;
  _gtk_tree_store_append( $tree_store, $iter, $parent);

  Gnome::Gtk3::TreeIter.new(:native-object($iter))
}

sub _gtk_tree_store_append (
  N-GObject $tree_store, N-GtkTreeIter $iter is rw, N-GtkTreeIter $parent
) is native(&gtk-lib)
  is symbol('gtk_tree_store_append')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_store_is_ancestor:
=begin pod
=head2 [[gtk_] tree_store_] is_ancestor

Returns C<1> if I<$iter> is an ancestor of I<$descendant>.  That is, I<$iter> is the parent (or grandparent or great-grandparent) of I<$descendant>.

  method gtk_tree_store_is_ancestor (
    Gnome::Gtk3::TreeIter $iter, Gnome::Gtk3::TreeIter $descendant
    --> Int
  )

=item Gnome::Gtk3::TreeIter $iter; A valid iterator
=item Gnome::Gtk3::TreeIter $descendant; A valid iterator

=end pod

sub gtk_tree_store_is_ancestor (
  N-GObject $tree_store, N-GtkTreeIter $iter, N-GtkTreeIter $descendant
) returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_store_iter_depth:
=begin pod
=head2 [[gtk_] tree_store_] iter_depth

Returns the depth of I<$iter>.  This will be 0 for anything on the root level, 1 for anything down a level, etc.

  method gtk_tree_store_iter_depth ( Gnome::Gtk3::TreeIter $iter --> Int  )

=item Gnome::Gtk3::TreeIter $iter; A valid iterator

=end pod

sub gtk_tree_store_iter_depth ( N-GObject $tree_store, N-GtkTreeIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_store_clear:
=begin pod
=head2 [gtk_] tree_store_clear

Removes all rows from $list_store

  method gtk_tree_store_clear ( )

=end pod

sub gtk_tree_store_clear ( N-GObject $tree_store )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_tree_store_iter_is_valid:
=begin pod
=head2 [[gtk_] tree_store_] iter_is_valid

WARNING: This function is slow. Only use it for debugging and/or testing purposes.

Checks if the given I<$iter> is a valid iter for this tree store.

Returns: C<1> if the I<$iter> is valid, C<0> if the iter is invalid.

Since: 2.2

  method gtk_tree_store_iter_is_valid ( Gnome::Gtk3::TreeIter $iter --> Int  )

=item Gnome::Gtk3::TreeIter $iter; A B<Gnome::Gtk3::TreeIter>.

=end pod

sub gtk_tree_store_iter_is_valid ( N-GObject $tree_store, N-GtkTreeIter $iter )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_store_reorder:
=begin pod
=head2 [gtk_] tree_store_reorder

Reorders the children of I<parent> in $list_store to follow the order indicated by I<new_order>. Note that this function only works with unsorted stores.

Since: 2.2

  method gtk_tree_store_reorder (
    Gnome::Gtk3::TreeIter $parent, Int $new_order
  )

=item Gnome::Gtk3::TreeIter $parent; (nullable): An iterator, or C<Any>
=item Int $new_order; (array): an array of integers mapping the new position of each child to its old position before the re-ordering, i.e. I<new_order>`[newpos] = oldpos`.

=end pod

sub gtk_tree_store_reorder (
  N-GObject $tree_store, N-GtkTreeIter $parent, int32 $new_order
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_store_swap:
=begin pod
=head2 [gtk_] tree_store_swap

Swaps I<$a> and I<$b> in the same level of $list_store. Note that this function only works with unsorted stores.

Since: 2.2

  method gtk_tree_store_swap (
    Gnome::Gtk3::TreeIter $a, Gnome::Gtk3::TreeIter $b
  )

=item Gnome::Gtk3::TreeIter $a; An iterator.
=item Gnome::Gtk3::TreeIter $b; Another iterator.

=end pod

sub gtk_tree_store_swap ( N-GObject $tree_store, N-GtkTreeIter $a, N-GtkTreeIter $b )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_store_move_before:
=begin pod
=head2 [[gtk_] tree_store_] move_before

Moves I<$iter> in $list_store to the position before I<$position>. I<$iter> and I<$position> should be in the same level. Note that this function only works with unsorted stores. If I<$position> is C<Any>, I<$iter> will be moved to the end of the level.

Since: 2.2

  method gtk_tree_store_move_before (
    Gnome::Gtk3::TreeIter $iter, Gnome::Gtk3::TreeIter $position
  )

=item Gnome::Gtk3::TreeIter $iter; An iterator.
=item Gnome::Gtk3::TreeIter $position; (allow-none): An iterator or C<Any>.

=end pod

sub gtk_tree_store_move_before ( N-GObject $tree_store, N-GtkTreeIter $iter, N-GtkTreeIter $position )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_tree_store_move_after:
=begin pod
=head2 [[gtk_] tree_store_] move_after

Moves I<$iter> in $list_store to the position after I<$position>. I<$iter> and I<position> should be in the same level. Note that this function only works with unsorted stores. If I<$position> is C<Any>, I<$iter> will be moved to the start of the level.

Since: 2.2

  method gtk_tree_store_move_after (
    Gnome::Gtk3::TreeIter $iter, Gnome::Gtk3::TreeIter $position
  )

=item Gnome::Gtk3::TreeIter $iter; A B<Gnome::Gtk3::TreeIter>.
=item Gnome::Gtk3::TreeIter $position; (allow-none): A B<Gnome::Gtk3::TreeIter>.

=end pod

sub gtk_tree_store_move_after ( N-GObject $tree_store, N-GtkTreeIter $iter, N-GtkTreeIter $position )
  is native(&gtk-lib)
  { * }
