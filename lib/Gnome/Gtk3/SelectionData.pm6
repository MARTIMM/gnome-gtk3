#TL:1:Gnome::Gtk3::Selection:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::SelectionData

Functions for handling inter-process communication via selections

=comment ![](images/X.png)

=head1 Description

The selection mechanism provides the basis for different types of communication between processes. In particular, drag and drop and B<Gnome::Gtk3::Clipboard> work via selections. You will very seldom or never need to use most of the functions in this section directly; B<Gnome::Gtk3::Clipboard> provides a nicer interface to the same functionality.

If an application is expected to exchange image data and work on Windows, it is highly advised to support at least "image/bmp" target for the widest possible compatibility with third-party applications. B<Gnome::Gtk3::Clipboard> already does that by using C<gtk-target-list-add-image-targets()> and C<set-pixbuf()> or C<get-pixbuf()>, which is one of the reasons why it is advised to use B<Gnome::Gtk3::Clipboard>.

Some of the datatypes defined this section are used in the B<Gnome::Gtk3::Clipboard> and drag-and-drop API’s as well. The
=comment B<Gnome::Gtk3::TargetEntry> and
B<Gnome::Gtk3::TargetList> object represent lists of data types that are supported when sending or receiving data. The B<Gnome::Gtk3::SelectionData> object is used to store a chunk of data along with the data type and other associated information.


=head2 See Also

B<Gnome::Gtk3::Widget> - Much of the operation of selections happens via signals for B<Gnome::Gtk3::Widget>. In particular, if you are using the functions in this section, you may need to pay attention to I<selection-get>, I<selection-received> and I<selection-clear-event> signals.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::SelectionData;
  also is Gnome::GObject::Boxed;


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;
use Gnome::N::TopLevelClassSupport;

use Gnome::GObject::Boxed;

use Gnome::Gdk3::Atom;
use Gnome::Gdk3::Pixbuf;

#use Gnome::Gtk3::TargetEntry;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::SelectionData:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::GObject::Boxed;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :native-object

Create a SelectionData object using a native object from elsewhere. This data is mostly provided to signal handlers

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
submethod BUILD ( *%options ) {
  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::SelectionData' {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_selection_new___x___($no);
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
        $no = _gtk_selection_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkSelectionData');
  }
}

#-------------------------------------------------------------------------------
method native-object-ref ( $n-native-object ) {
  $n-native-object
}

#-------------------------------------------------------------------------------
method native-object-unref ( $n-native-object ) {
  $n-native-object
}

#-------------------------------------------------------------------------------
#TM:0:add-target:
=begin pod
=head2 add-target

Appends a specified target to the list of supported targets for a given widget and selection.

  method add-target (
    N-GObject $widget, Gnome::Gdk3::Atom $selection,
    Gnome::Gdk3::Atom $target, UInt $info
  )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item Gnome::Gdk3::Atom $selection; the selection
=item Gnome::Gdk3::Atom $target; target to add.
=item UInt $info; A unsigned integer which will be passed back to the application.
=end pod

method add-target (
  $widget is copy, Gnome::Gdk3::Atom $selection, Gnome::Gdk3::Atom $target,
  UInt $info
) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;
  gtk_selection_add_target( $widget, $selection, $target, $info);
}

sub gtk_selection_add_target (
  N-GObject $widget, N-GObject $selection, N-GObject $target, guint $info
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:4:add-targets:xt/dnd-01.raku
=begin pod
=head2 add-targets

Prepends a table of targets to the list of supported targets for a given widget and selection.

  method add-targets (
    N-GObject $widget, Gnome::Gdk3::Atom $selection,
    Array[Gnome::Gtk3::TargetEntry] $targets
  )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item Gnome::Gdk3::Atom $selection; the selection
=item $targets; an array of Gnome::Gtk3::TargetEntry targets to add
=end pod

method add-targets (
  $widget is copy, Gnome::Gdk3::Atom $selection is copy, Array $targets
) {
  my $tes = CArray[N-GObject].new;
  my Int $i = 0;
  for @$targets -> $t {
    $tes[$i++] = $t.get-native-object-no-reffing;
  }

  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;
  $selection .= get-native-object-no-reffing unless $selection ~~ N-GObject;
  gtk_selection_add_targets( $widget, $selection, $tes, $targets.elems);
}

sub gtk_selection_add_targets (
  N-GObject $widget, N-GObject $selection, N-GObject $targets, guint $ntargets
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# TM:0:clear-targets:
=begin pod
=head2 clear-targets

Remove all targets registered for the given selection for the widget.

  method clear-targets ( N-GObject $widget, Gnome::Gdk3::Atom $selection )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item Gnome::Gdk3::Atom $selection; an atom representing a selection
=end pod

method clear-targets ( $widget is copy, Gnome::Gdk3::Atom $selection ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;
  gtk_selection_clear_targets( $widget, $selection);
}

sub gtk_selection_clear_targets (
  N-GObject $widget, N-GObject $selection
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:convert:
=begin pod
=head2 convert

Requests the contents of a selection. When received, a “selection-received” signal will be generated.

Returns: C<True> if requested succeeded. C<False> if we could not process request. (e.g., there was already a request in process for this widget).

  method convert (
    N-GObject $widget, Gnome::Gdk3::Atom $selection,
    Gnome::Gdk3::Atom $target, UInt $time --> Bool
  )

=item N-GObject $widget; The widget which acts as requestor
=item Gnome::Gdk3::Atom $selection; Which selection to get
=item Gnome::Gdk3::Atom $target; Form of information desired (e.g., STRING)
=item UInt $time; Time of request (usually of triggering event)
=end pod

method convert (
  $widget is copy, Gnome::Gdk3::Atom $selection,
  Gnome::Gdk3::Atom $target, UInt $time --> Bool
) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;
  gtk_selection_convert( $widget, $selection, $target, $time).Bool
}

sub gtk_selection_convert (
  N-GObject $widget, N-GObject $selection, N-GObject $target, guint32 $time --> gboolean
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:copy:
=begin pod
=head2 copy

Makes a copy of a B<Gnome::Gtk3::SelectionData>-struct and its data.

Returns: a pointer to a copy of I<data>.

  method copy ( N-GObject $data --> N-GObject )

=item N-GObject $data; a pointer to a B<Gnome::Gtk3::SelectionData>-struct.
=end pod

method copy ( N-GObject $data --> N-GObject ) {

  gtk_selection_data_copy(
    self.get-native-object-no-reffing, $data
  )
}

sub gtk_selection_data_copy (
  N-GObject $data --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:free:
=begin pod
=head2 free

Frees a B<Gnome::Gtk3::SelectionData>-struct returned from C<copy()>.

  method free ( N-GObject $data )

=item N-GObject $data; a pointer to a B<Gnome::Gtk3::SelectionData>-struct.
=end pod

method free ( N-GObject $data ) {

  gtk_selection_data_free(
    self.get-native-object-no-reffing, $data
  );
}

sub gtk_selection_data_free (
  N-GObject $data
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
# TM:2:get:xt/dnd-01.raku
=begin pod
=head2 get

Raku convenience routine to get data.

  method get (
    :$data-type! where * ~~ any(Int,Num,Rat,Str,Buf) = Int
    --> Any
  )

=item $data-type; a raku data type which is used to retrieve the data from the selection data structure.

=begin table
Data type   | nbr items | Return value
======================================
Int         | 1         | integer value
Int         | > 1       | an array of integer values
Num or Rat  | 1         | num value
Num or Rat  | > 1       | an array of num values
Str         | n         | string
Buf         | n         | buffer array
*           | 0         | undefined
=end table

=end pod

method get (
  :$data-type where * ~~ any(Int,Num,Rat,Str,Buf) = Int
  --> Any
) {
  my Int $length = self.get-length;
  my Int $format = self.get-format;
  my Int $items = (self.get-length / ( self.get-format / 8 ).Int ).Int;
#note "get data: $length, $format, $items";

  return Any if $length <= 0 or $format == 0;

  my $data;
  my $format-type;

  my $n-data = self.get-data;
  given $data-type {
    when Int {
      if $format == 8     { $format-type = int8; }
      elsif $format == 16 { $format-type = int16; }
      elsif $format == 32 { $format-type = int32; }

      my $d = nativecast( CArray[$format-type], $n-data);
      if $items > 1 {
        $data = [];
        for ^$items -> $i { $data.push: $d[$i].Int; }
      }

      else {
        $data = $d[0].Int;
      }
    }

    when any( Num, Rat) {
      my $d = nativecast( CArray[num32], $n-data);
      if $items > 1 {
        $data = [];
        for ^$items -> $i { $data.push: $d[$i].Num; }
      }

      else {
        $data = $d[0].Num;
      }
    }

    when Str {
      my $d1 = nativecast( CArray[uint8], $n-data);
      my Buf $d2 .= new;
      my Int $i = 0;
      while $d1[$i] {
        $d2[$i] = $d1[$i];
        $i++;
      }

      $data = $d2.decode;
    }

    when Buf {
      $data = nativecast( CArray[uint8], $n-data);
    }
  }

  $data
}

#-------------------------------------------------------------------------------
#TM:2:get-data:xt/dnd-01.raku
=begin pod
=head2 get-data

Retrieves the raw data of the selection.

Returns: the raw data of the selection.

  method get-data ( --> Pointer )

=end pod

method get-data ( --> Pointer ) {
  gtk_selection_data_get_data(self.get-native-object-no-reffing);
}

sub gtk_selection_data_get_data (
  N-GObject $selection_data --> Pointer
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-data-type:xt/dnd-01.raku
=begin pod
=head2 get-data-type

Retrieves the data type of the selection.

Returns: the data type of the selection.

  method get-data-type ( --> Gnome::Gdk3::Atom )

=end pod

method get-data-type ( --> Gnome::Gdk3::Atom ) {
  Gnome::Gdk3::Atom.new(
    :native-object(
      gtk_selection_data_get_data_type(self.get-native-object-no-reffing)
    )
  )
}

sub gtk_selection_data_get_data_type (
  N-GObject $selection_data --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-data-with-length:xt/dnd-01.raku
=begin pod
=head2 get-data-with-length

Retrieves the raw data of the selection along with its length.

  method get-data-with-length ( --> List )

Returns a List;
=item Pointer to the raw data of the selection
=item Int length of the data
=end pod

method get-data-with-length ( --> List ) {
  my Pointer[void] $p = gtk_selection_data_get_data_with_length(
    self.get-native-object-no-reffing, my gint $length
  );
  ( $p, $length)
}

sub gtk_selection_data_get_data_with_length (
  N-GObject $selection_data, gint $length is rw --> Pointer[void]
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-display:
=begin pod
=head2 get-display

Retrieves the display of the selection.

Returns: the display of the selection.

  method get-display ( --> N-GObject )

=end pod

method get-display ( --> N-GObject ) {
  gtk_selection_data_get_display(self.get-native-object-no-reffing)
}

sub gtk_selection_data_get_display (
  N-GObject $selection_data --> N-GObject
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:2:get-format:xt/dnd-01.raku
=begin pod
=head2 get-format

Retrieves the format of the selection.

Returns: the format of the selection.

  method get-format ( --> Int )

=end pod

method get-format ( --> Int ) {
  gtk_selection_data_get_format(self.get-native-object-no-reffing)
}

sub gtk_selection_data_get_format (
  N-GObject $selection_data --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-length:xt/dnd-01.raku
=begin pod
=head2 get-length

Retrieves the length of the raw data of the selection.

  method get-length ( --> Int )

=end pod

method get-length ( --> Int ) {
  gtk_selection_data_get_length(self.get-native-object-no-reffing)
}

sub gtk_selection_data_get_length (
  N-GObject $selection_data --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-pixbuf:
=begin pod
=head2 get-pixbuf

Gets the contents of the selection data as a B<Gnome::Gdk3::Pixbuf>.

Returns: if the selection data contained a recognized image type and it could be converted to a B<Gnome::Gdk3::Pixbuf>, a newly allocated pixbuf is returned, otherwise C<undefined>. If the result is non-C<undefined> it must be freed with C<g-object-unref()>.

  method get-pixbuf ( --> Gnome::Gdk3::Pixbuf )

=end pod

method get-pixbuf ( --> Gnome::Gdk3::Pixbuf ) {
  Gnome::Gdk3::Pixbuf.new(
    :native-object(
      gtk_selection_data_get_pixbuf(self.get-native-object-no-reffing)
    )
  )
}

sub gtk_selection_data_get_pixbuf (
  N-GObject $selection_data --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-selection:
=begin pod
=head2 get-selection

Retrieves the selection B<Gnome::Gtk3::Atom> of the selection data.

  method get-selection ( --> Gnome::Gdk3::Atom )

=end pod

method get-selection ( --> Gnome::Gdk3::Atom ) {
  Gnome::Gdk3::Atom.new(
    :native-object(
      gtk_selection_data_get_selection(self.get-native-object-no-reffing)
    )
  )
}

sub gtk_selection_data_get_selection (
  N-GObject $selection_data --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:get-target:xt/dnd-01.raku
=begin pod
=head2 get-target

Retrieves the target of the selection.

  method get-target ( --> Gnome::Gdk3::Atom )

=end pod

method get-target ( --> Gnome::Gdk3::Atom ) {
  Gnome::Gdk3::Atom.new(
    :native-object(
      gtk_selection_data_get_target(self.get-native-object-no-reffing)
    )
  )
}

sub gtk_selection_data_get_target (
  N-GObject $selection_data --> N-GObject
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-targets:
=begin pod
=head2 get-targets

Gets the contents of I<selection-data> as an array of targets. This can be used to interpret the results of getting the standard TARGETS target that is always supplied for any selection.

Returns: C<True> if I<selection-data> contains a valid array of targets, otherwise C<False>.

  method get-targets (, Gnome::Gdk3::Atom $targets --> Bool )

=item Gnome::Gdk3::Atom $targets;  (array length=n-atoms) (transfer container): location to store an array of targets. The result stored here must be freed with C<g-free()>.
=item Int $n_atoms; location to store number of items in I<targets>.
=end pod

method get-targets (, Gnome::Gdk3::Atom $targets --> Bool ) {
  gtk_selection_data_get_targets(
    self.get-native-object-no-reffing, $targets, my gint $n_atoms
  ).Bool
}

sub gtk_selection_data_get_targets (
  N-GObject $selection_data, N-GObject $targets, gint $n_atoms is rw --> gboolean
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:get-text:
=begin pod
=head2 get-text

Gets the contents of the selection data as a UTF-8 string.

Returns: if the selection data contained a recognized text type and it could be converted to UTF-8, a newly allocated string containing the converted text, otherwise C<undefined>.

  method get-text ( --> Str )

=end pod

method get-text ( --> Str ) {
  gtk_selection_data_get_text(self.get-native-object-no-reffing)
}

sub gtk_selection_data_get_text (
  N-GObject $selection_data --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-uris:
=begin pod
=head2 get-uris

Gets the contents of the selection data as array of URIs.

Returns: an B<Array> if the selection data contains a list of URIs, otherwise empty.

  method get-uris ( --> Array )

=end pod

method get-uris ( --> Array ) {
  my CArray[Str] $ca = gtk_selection_data_get_uris(
    self.get-native-object-no-reffing
  );

  my Array $uris = [];
  my Int $i = 0;
  if ?$ca {
    while $ca[$i] {
      $uris.push: $ca[$i];
      $i++;
    }
  }

  $uris
}

sub gtk_selection_data_get_uris (
  N-GObject $selection_data --> gchar-pptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:set:xt/dnd-01.raku
=begin pod
=head2 set

Stores new data into a B<Gnome::Gtk3::SelectionData> object. Should only be called from a selection handler callback.

  method set (
    N-GObject $type, $data, Int :$format where * ~~ any(8,16,32) = 32
  )

=item N-GObject $type; the type of selection data. A Gnome::Gdk3::Atom
=item $data; data which can be of type Int, Num, Rat, Array[ Int, Num or Rat], Str or Buf.
=item Int() $format; format (number of bits per value). Default set to 32 for numbers and 8 for strings. Only usefull to set to 8 or 16 when integers are small. Num and Rat are always set to 32.

=head3 Example

  # the method to handle a drag-data-get signal on the source widget
  method get (
    N-GObject $context, N-GObject $selection-data, UInt $info, UInt $time,
    :_widget($widget)
  ) {
    my Gnome::Gtk3::SelectionData $sd .= new(:native-object($selection-data));

    # check for target name to decide what to provide
    my Gnome::Gdk3::Atom $atom .= new(:native-object($sd.get-target));
    if $atom.name eq 'number' {
      # we provide a 16 bit integer
      $sd.set( $!targets<number>, $number, :format(16));
    }
    …
  }


  # the method to handle a drag-data-received signal on the
  # destination widget
  method received (
    N-GObject $context, Int $x, Int $y,
    N-GObject $data, UInt $info, UInt $time, :_widget($widget)
  ) {
    my Gnome::Gtk3::SelectionData $sd .= new(:native-object($data));
    my Gnome::Gdk3::Atom $atom .= new(:native-object($sd.get-target));
    if $atom.name eq 'number' and (my $num = $sd.get).defined {
        …
    }
    …
  }


=end pod

#`{{
multi method set ( $type is copy, Str $data ) {
  $type .= get-native-object-no-reffing unless $type ~~ N-GObject;
  my $tes = CArray[Str].new($data.encode);
  gtk_selection_data_set(
    self.get-native-object-no-reffing, $type, 1, $tes, $data.encode.elems
  );
}
}}

method set (
  $type is copy, $data, Int :$format is copy where * ~~ any(8,16,32) = 32,
#  $length is copy where * > 0;
) {
#note "set: $type.name(), $format, $data.gist()";

  $type .= get-native-object-no-reffing unless $type ~~ N-GObject;

#  gtk_selection_data_set(
#    self.get-native-object-no-reffing, $type, $format, $data, $length
#  );

#note 'dtype: ', $data.^name;
  # format, data argument and length

  my Int $length;
  my $n-data;
  my $format-type;
  given $data {
    when Int {
      if $format == 8     { $format-type = int8; }
      elsif $format == 16 { $format-type = int16; }
      elsif $format == 32 { $format-type = int32; }

      $n-data = CArray[$format-type].new($data);        # data
      $length = ($format / 8).Int;                      # length in bytes
    }

    when any( Num, Rat) {
      $format = 32;                                     # force to 32 bit units
      $format-type = num32;
      $length = ($format / 8).Int;                      # length in bytes
      $n-data = CArray[$format-type].new($data);        # data
    }

    when Array and $data[0] ~~ Int {
      if $format == 8     { $format-type = int8; }
      elsif $format == 16 { $format-type = int16; }
      elsif $format == 32 { $format-type = int32; }

      $length = ($format / 8).Int * $data.elems;        # length in bytes
      $n-data = CArray[$format-type].new(|@$data);      # data
    }

    when Array and $data[0] ~~ any( Num, Rat) {
      $format = 32;                                     # force to 32 bit units
      $format-type = num32;                             # force type
      $length = ($format / 8).Int * $data.elems;        # length in bytes
      $n-data = CArray[$format-type].new(|@$data);      # data
    }

    when Str {
      my $es = $data.encode;                            # support utf8
      $format = 8;                                      # force to 8 bit units
      $format-type = uint8;                             # force type
      $length = $es.elems;                              # length in bytes
      $n-data = CArray[$format-type].new($es);          # data
    }

    when Buf {
      $format = 8;                                      # force to 8 bit units
      $format-type = uint8;                             # force type
      $length = $data.elems;                            # length in bytes
      $n-data = CArray[$format-type].new($data);        # data
    }
  }

  # Parameter list
  my @parameterList = (
    Parameter.new(type => N-GObject),                   # selection data type
    Parameter.new(type => N-GObject),                   # native atom type
    Parameter.new(type => gint),                        # format type
    Parameter.new(type => CArray[$format-type]),        # data type
    Parameter.new(type => gint),                        # length type
  );

  # argument list
  my @arguments = (
    self.get-native-object-no-reffing,                  # selection data
    $type,                                              # type
    $format,                                            # 8, 16 or 32 bit unit
    $n-data,                                            # CArray of data
    $length,                                            # length in bytes
  );

  # add the length type, same for all
#note 'format type: ', $format-type;
#  @parameterList.push: Parameter.new(type => CArray[$format-type]);
#  @parameterList.push: Parameter.new(type => gint);     # length

#  @arguments.push: $length;                             # nbr items


  # create signature for call to gtk_selection_data_set
  my Signature $signature .= new(
    :params( |@parameterList ), :returns(Pointer)
  );

  # get a pointer to the sub, then cast it to a sub with the created
  # signature. after that, the sub can be called, returning a value.
  state $ptr = cglobal( gtk-lib(), 'gtk_selection_data_set', Pointer);

  my Callable $f = nativecast( $signature, $ptr);

#note 'gtk_selection_data_set: ', @arguments.join(', ');
  $f(|@arguments)

}

#`{{
sub gtk_selection_data_set (
  N-GObject $selection_data, N-GObject $type, gint $format,
  Pointer[void] $data, gint $length
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:set-pixbuf:
=begin pod
=head2 set-pixbuf

Sets the contents of the selection from a B<Gnome::Gtk3::Pixbuf> The pixbuf is converted to the form determined by selection data target.

Returns: C<True> if the selection was successfully set, otherwise C<False>.

  method set-pixbuf ( N-GObject $pixbuf --> Bool )

=item N-GObject $pixbuf; a B<Gnome::Gtk3::Pixbuf>
=end pod

method set-pixbuf ( $pixbuf is copy --> Bool ) {
  $pixbuf .= get-native-object-no-reffing unless $pixbuf ~~ N-GObject;

  gtk_selection_data_set_pixbuf(
    self.get-native-object-no-reffing, $pixbuf
  ).Bool
}

sub gtk_selection_data_set_pixbuf (
  N-GObject $selection_data, N-GObject $pixbuf --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-text:
=begin pod
=head2 set-text

Sets the contents of the selection from a UTF-8 encoded string. The string is converted to the form determined by I<selection-data> target.

Returns: C<True> if the selection was successfully set, otherwise C<False>.

  method set-text ( Str $str --> Bool )

=item Str $str; a UTF-8 string
=item Int() $len; the length of I<str>, or -1 if I<str> is nul-terminated.
=end pod

method set-text ( Str $str --> Bool ) {
  gtk_selection_data_set_text(
    self.get-native-object-no-reffing, $str, $str.len
  ).Bool
}

sub gtk_selection_data_set_text (
  N-GObject $selection_data, gchar-ptr $str, gint $len --> gboolean
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:set-uris:
=begin pod
=head2 set-uris

Sets the contents of the selection from a list of URIs. The string is converted to the form determined by I<selection-data>->target.

Returns: C<True> if the selection was successfully set, otherwise C<False>.

  method set-uris (, CArray[Str] $uris --> Bool )

=item CArray[Str] $uris; a C<undefined>-terminated array of strings holding URIs
=end pod

method set-uris (, CArray[Str] $uris --> Bool ) {
  gtk_selection_data_set_uris( self.get-native-object-no-reffing, $uris).Bool
}

sub gtk_selection_data_set_uris (
  N-GObject $selection_data, gchar-pptr $uris --> gboolean
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:owner-set:
=begin pod
=head2 owner-set

Claims ownership of a given selection for a particular widget, or, if I<widget> is C<undefined>, release ownership of the selection.

Returns: C<True> if the operation succeeded

  method owner-set (
    N-GObject $widget, Gnome::Gdk3::Atom $selection, UInt $time
    --> Bool
  )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>, or C<undefined>.
=item Gnome::Gdk3::Atom $selection; an interned atom representing the selection to claim
=item UInt $time; timestamp with which to claim the selection
=end pod

method owner-set (
  $widget is copy, Gnome::Gdk3::Atom $selection, UInt $time --> Bool
) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_selection_owner_set( $widget, $selection, $time).Bool
}

sub gtk_selection_owner_set (
  N-GObject $widget, N-GObject $selection, guint32 $time --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:owner-set-for-display:
=begin pod
=head2 owner-set-for-display

Claim ownership of a given selection for a particular widget, or, if I<widget> is C<undefined>, release ownership of the selection.

Returns: TRUE if the operation succeeded

  method owner-set-for-display ( N-GObject $display, N-GObject $widget, Gnome::Gdk3::Atom $selection, UInt $time --> Bool )

=item N-GObject $display; the B<Gnome::Gtk3::Display> where the selection is set
=item N-GObject $widget; new selection owner (a B<Gnome::Gtk3::Widget>), or C<undefined>.
=item Gnome::Gdk3::Atom $selection; an interned atom representing the selection to claim.
=item UInt $time; timestamp with which to claim the selection
=end pod

method owner-set-for-display (
  $display is copy, $widget is copy, Gnome::Gdk3::Atom $selection,
  UInt $time --> Bool
) {
  $display .= get-native-object-no-reffing unless $display ~~ N-GObject;
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_selection_owner_set_for_display(
    $display, $widget, $selection, $time
  ).Bool
}

sub gtk_selection_owner_set_for_display (
  N-GObject $display, N-GObject $widget, N-GObject $selection, guint32 $time --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:remove-all:
=begin pod
=head2 remove-all

Removes all handlers and unsets ownership of all selections for a widget. Called when widget is being destroyed. This function will not generally be called by applications.

  method remove-all ( N-GObject $widget )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=end pod

method remove-all ( $widget is copy ) {
  $widget .= get-native-object-no-reffing unless $widget ~~ N-GObject;

  gtk_selection_remove_all(
    self.get-native-object-no-reffing, $widget
  );
}

sub gtk_selection_remove_all (
  N-GObject $widget
) is native(&gtk-lib)
  { * }
