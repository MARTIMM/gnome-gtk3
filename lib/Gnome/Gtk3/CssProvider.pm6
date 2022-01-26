#TL:1:Gnome::Gtk3::CssProvider

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CssProvider

CSS-like styling for widgets

=head1 Description

B<Gnome::Gtk3::CssProvider> is an object implementing the B<Gnome::Gtk3::StyleProvider> interface. It is able to parse [CSS-like](https://developer-old.gnome.org/gtk3/3.24/chap-css-overview.html#css-overview) input in order to style widgets.

An application can make GTK+ parse a specific CSS style sheet by calling C<load_from_file()> or C<load_from_resource()> and adding the provider with C<Gnome::Gtk3::StyleContext.add_provider()> or C<Gnome::Gtk3::StyleContext.add_provider_for_screen()>.

In addition, certain files will be read when GTK+ is initialized. First, the file C<$XDG_CONFIG_HOME/gtk-3.0/gtk.css> is loaded if it exists. Then, GTK+ loads the first existing file among C<$XDG_DATA_HOME/themes/theme-name/gtk-VERSION/gtk.css>, C<$HOME/.themes/theme-name/gtk-VERSION/gtk.css>, C<$XDG_DATA_DIRS/themes/theme-name/gtk-VERSION/gtk.css> and C<DATADIR/share/themes/THEME/gtk-VERSION/gtk.css>, where `THEME` is the name of the current theme (see the prop L<gtk-theme-name|https://developer-old.gnome.org/gtk3/stable/GtkSettings.html#GtkSettings--gtk-theme-name> setting), `DATADIR` is the prefix configured when GTK+ was compiled (unless overridden by the `GTK_DATA_PREFIX` environment variable), and `VERSION` is the GTK+ version number. If no file is found for the current version, GTK+ tries older versions all the way back to 3.0.

In the same way, GTK+ tries to load a C<gtk-keys.css> file for the current key theme, as defined by prop L<gtk-key-theme-name|https://developer-old.gnome.org/gtk3/stable/GtkSettings.html#GtkSettings--gtk-key-theme-name> setting.


=head2 See Also

B<Gnome::Gtk3::StyleContext>, B<Gnome::Gtk3::StyleProvider>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CssProvider;
  also is Gnome::GObject::Object;
  also does Gnome::Gtk3::StyleProvider;


=head2 Uml Diagram

![](plantuml/CssProvider.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::CssProvider;

  unit class MyGuiClass;
  also is Gnome::Gtk3::CssProvider;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::CssProvider class process the options
    self.bless( :GtkCssProvider, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment


=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::N::GlibToRakuTypes;

use Gnome::Glib::Error;

use Gnome::GObject::Object;

use Gnome::Gtk3::StyleProvider;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcssprovider.h
# https://developer.gnome.org/gtk3/stable/GtkCssProvider.html
unit class Gnome::Gtk3::CssProvider:auth<github:MARTIMM>;
also is Gnome::GObject::Object;
also does Gnome::Gtk3::StyleProvider;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkCssProviderError

Error codes for C<GTK_CSS_PROVIDER_ERROR>.

=item GTK_CSS_PROVIDER_ERROR_FAILED: Failed.
=item GTK_CSS_PROVIDER_ERROR_SYNTAX: Syntax error.
=item GTK_CSS_PROVIDER_ERROR_IMPORT: Import error.
=item GTK_CSS_PROVIDER_ERROR_NAME: Name error.
=item GTK_CSS_PROVIDER_ERROR_DEPRECATED: Deprecation error.
=item GTK_CSS_PROVIDER_ERROR_UNKNOWN_VALUE: Unknown value.

=end pod

#TE:1:GtkCssProviderError:
enum GtkCssProviderError is export (
  'GTK_CSS_PROVIDER_ERROR_FAILED',
  'GTK_CSS_PROVIDER_ERROR_SYNTAX',
  'GTK_CSS_PROVIDER_ERROR_IMPORT',
  'GTK_CSS_PROVIDER_ERROR_NAME',
  'GTK_CSS_PROVIDER_ERROR_DEPRECATED',
  'GTK_CSS_PROVIDER_ERROR_UNKNOWN_VALUE'
);

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new CssProvider object.

  multi method new ( )


=head3 :named

Loads a theme from the usual theme paths

Creates a CssProvider> with the theme loaded. This memory is owned by GTK+, and you must not free it.

  method new( Str :$named!, Str :$variant )

=item $named; A theme name like 'Breeze' or 'Oxygen'.
=item $variant; variant to load, for example, 'dark'. Use C<undefined> to get the default.


=head3 :native-object

Create a CssProvider object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a CssProvider object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )


=end pod

#TM:1:new():
#TM:1:new(:named,:variant):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w2<parsing-error>,
  ) unless $signals-added;

#`{{
  # prevent creating wrong native-objects
  return unless self.^name eq 'Gnome::Gtk3::CssProvider';

  if ? %options<native-object> || ? %options<widget> || ? %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  else {#if ? %options<empty> {
    self._set-native-object(gtk_css_provider_new());
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkCssProvider');
}}

  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::CssProvider' #`{{ or %options<GtkCssProvider> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<named> {
        $no = _gtk_css_provider_get_named(
          %options<named>, %options<variant> // Str
        );
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

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      ##`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_css_provider_new();
      }
      #}}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkCssProvider');
  }
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_css_provider_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._style_provider_interface($native-sub) unless ?$s;

  self._set-class-name-of-sub('GtkCssProvider');
  $s = callsame unless ?$s;

  $s
}


#-------------------------------------------------------------------------------
#TM:1:error-quark:
=begin pod
=head2 error-quark

Return the domain code of the builder error domain.

  method error-quark ( --> UInt )

=end pod

method error-quark ( --> UInt ) {
  gtk_css_provider_error_quark
}

sub gtk_css_provider_error_quark (
   --> GQuark
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-named:
#`{{
=begin pod
=head2 get-named

Loads a theme from the usual theme paths

Returns: a B<Gnome::Gtk3::CssProvider> with the theme loaded. This memory is owned by GTK+, and you must not free it.

  method get-named ( Str $name, Str $variant --> N-GObject )

=item Str $name; A theme name
=item Str $variant; variant to load, for example, "dark", or C<undefined> for the default
=end pod

method get-named ( Str $name, Str $variant --> N-GObject ) {
  gtk_css_provider_get_named(
    self._get-native-object-no-reffing, $name, $variant
  )
}
}}

sub _gtk_css_provider_get_named (
  gchar-ptr $name, gchar-ptr $variant --> N-GObject
) is native(&gtk-lib)
  is symbol('gtk_css_provider_get_named')
  { * }

#-------------------------------------------------------------------------------
#TM:1:load-from-data:
=begin pod
=head2 load-from-data

Loads I<data> into I<css-provider>, and by doing so clears any previously loaded information.

Returns: Gnome::Glib::Error. Test `.is-valid()` of that object to see if there was an error.

A way to track errors while loading CSS is to connect to the sig C<parsing-error> signal.

  method load-from-data ( Str $data --> Gnome::Glib::Error )

=item $data; CSS data loaded in memory
=end pod

method load-from-data ( Str $data --> Gnome::Glib::Error ) {
  my CArray[N-GError] $ga .= new(N-GError);
  gtk_css_provider_load_from_data(
    self._get-native-object-no-reffing, $data, $data.encode.bytes, $ga
  );

  Gnome::Glib::Error.new(:native-object($ga[0]));
}

sub gtk_css_provider_load_from_data (
  N-GObject $css_provider, gchar-ptr $data, gssize $length,
  CArray[N-GError] $error --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:load-from-file:
=begin pod
=head2 load-from-file

Loads the data contained in I<file> into I<css-provider>, making it clear any previously loaded information.

Returns: Gnome::Glib::Error. Test `.is-valid()` of that object to see if there was an error.

  method load-from-file ( N-GObject $file --> Gnome::Glib::Error )

=item $file; a B<Gnome::Gio::File> pointing to a file to load
=end pod

method load-from-file ( $file is copy --> Gnome::Glib::Error ) {
  $file .= _get-native-object-no-reffing unless $file ~~ N-GObject;
  my CArray[N-GError] $ga .= new(N-GError);

  gtk_css_provider_load_from_file(
    self._get-native-object-no-reffing, $file, $ga
  );

  Gnome::Glib::Error.new(:native-object($ga[0]));
}

sub gtk_css_provider_load_from_file (
  N-GObject $css_provider, N-GObject $file, CArray[N-GError] $error --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:load-from-path:
=begin pod
=head2 load-from-path

Loads the data contained in I<path> into I<css-provider>, making it clear any previously loaded information.

Returns: Gnome::Glib::Error. Test `.is-valid()` of that object to see if there was an error.

  method load-from-path ( Str $path --> Gnome::Glib::Error )

=item $path; the path of a filename to load, in the GLib filename encoding
=end pod

method load-from-path ( Str $path --> Gnome::Glib::Error ) {
  my CArray[N-GError] $ga .= new(N-GError);

  gtk_css_provider_load_from_path(
    self._get-native-object-no-reffing, $path, $ga
  );

  Gnome::Glib::Error.new(:native-object($ga[0]));
}

sub gtk_css_provider_load_from_path (
  N-GObject $css_provider, gchar-ptr $path, CArray[N-GError] $error --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-from-resource:
=begin pod
=head2 load-from-resource

Loads the data contained in the resource at I<resource-path> into the B<Gnome::Gtk3::CssProvider>, clearing any previously loaded information.

To track errors while loading CSS, connect to the  I<parsing-error> signal.

  method load-from-resource ( Str $resource_path )

=item $resource_path; a B<Gnome::Gtk3::Resource> resource path
=end pod

method load-from-resource ( Str $resource_path ) {

  gtk_css_provider_load_from_resource(
    self._get-native-object-no-reffing, $resource_path
  );
}

sub gtk_css_provider_load_from_resource (
  N-GObject $css_provider, gchar-ptr $resource_path
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:to-string:
=begin pod
=head2 to-string

Converts the I<provider> into a string representation in CSS format.

Using C<load-from-data()> with the return value from this function on a new provider created with C<new()> will basically create a duplicate of this I<provider>.

Returns: a new string representing the I<provider>.

  method to-string ( --> Str )

=end pod

method to-string ( --> Str ) {
  gtk_css_provider_to_string( self._get-native-object-no-reffing)
}

sub gtk_css_provider_to_string (
  N-GObject $provider --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_css_provider_new:
#`{{
=begin pod
=head2 _gtk_css_provider_new

Returns a newly created B<Gnome::Gtk3::CssProvider>.

Returns: A new B<Gnome::Gtk3::CssProvider>

  method _gtk_css_provider_new ( --> N-GObject )

=end pod
}}

sub _gtk_css_provider_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_css_provider_new')
  { * }

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
=comment #TS:1:parsing-error:
=head3 parsing-error

Signals that a parsing error occurred. the I<path>, I<line> and I<position>
describe the actual location of the error as accurately as possible.

Parsing errors are never fatal, so the parsing will resume after
the error. Errors may however cause parts of the given
data or even all of it to not be parsed at all. So it is a useful idea
to check that the parsing succeeds by connecting to this signal.

Note that this signal may be emitted at any time as the css provider
may opt to defer parsing parts or all of the input to a later time
than when a loading function was called.

  method handler (
    N-GObject $section,
    N-GError $error,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($provider),
    *%user-options
  );

=item $provider; the provider that had a parsing error.
=item $section; section the error happened in, a native B<Gnome::Gtk3::Section>.
=item $error; the parsing error.
=item $_handle_id; the registered event handler id.
=item $_widget: the widget on which the event was registered .

=end pod
























=finish
#-------------------------------------------------------------------------------
#TM:1:gtk_css_provider_error_quark:
=begin pod
=head2 [[gtk_] css_provider_] error_quark

Return the domain code of the builder error domain.

  method gtk_css_provider_error_quark ( --> Int )

=end pod

sub gtk_css_provider_error_quark (  )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_css_provider_new:
=begin pod
=head2 [gtk_] css_provider_new

Returns a newly created B<Gnome::Gtk3::CssProvider>.

  method gtk_css_provider_new ( --> N-GObject )

=end pod

sub gtk_css_provider_new (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_css_provider_to_string:
=begin pod
=head2 [[gtk_] css_provider_] to_string

Converts the provider into a string representation in CSS
format.

Using C<gtk_css_provider_load_from_data()> with the return value
from this function on a new provider created with
C<gtk_css_provider_new()> will basically create a duplicate of
the provider.

Returns: a new string representing the I<provider>.
  method gtk_css_provider_to_string ( --> char  )

=end pod

sub gtk_css_provider_to_string ( N-GObject $provider )
  returns Str
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_css_provider_load_from_data:
=begin pod
=head2 [[gtk_] css_provider_] load_from_data

Loads I<$data> into the provider, and by doing so clears any previously loaded information.

Returns: Gnome::Glib::Error. Test `.is-valid()` of that object to see if there was an error.

A way to track errors while loading CSS is to connect to the sig C<parsing-error> signal.

  method gtk_css_provider_load_from_data (
    Str $data
    --> Gnome::Glib::Error
  )

=item Str $data; (array length=length) (element-type guint8): CSS data loaded in memory

=end pod

sub gtk_css_provider_load_from_data (
  N-GObject $css_provider, Str $data
  --> Gnome::Glib::Error
) {
  my CArray[N-GError] $ga .= new(N-GError);
  _gtk_css_provider_load_from_data(
    $css_provider, $data, $data.encode.bytes #`{{$data.chars}}, $ga
  );
  Gnome::Glib::Error.new(:native-object($ga[0]));
}

sub _gtk_css_provider_load_from_data (
  N-GObject $css_provider, Str $data, int64 $length, CArray[N-GError] $error
  --> int32
) is native(&gtk-lib)
  is symbol('gtk_css_provider_load_from_data')
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_css_provider_load_from_file:
=begin pod
=head2 [[gtk_] css_provider_] load_from_file

Loads the data contained in I<$file> into I<css_provider>, making it
clear any previously loaded information.

Returns: C<1>. The return value is deprecated and C<0> will only be
returned for backwards compatibility reasons if an I<error> is not
C<Any> and a loading error occurred. To track errors while loading
CSS, connect to the sig C<parsing-error> signal.

  method gtk_css_provider_load_from_file ( N-GObject $file, N-GObject $error --> Int  )

=item N-GObject $file; C<GFile> pointing to a file to load
=item N-GObject $error; (out) (allow-none): return location for a C<GError>, or C<Any>

=end pod

sub gtk_css_provider_load_from_file ( N-GObject $css_provider, N-GObject $file, N-GObject $error )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_css_provider_load_from_path:
=begin pod
=head2 [[gtk_] css_provider_] load_from_path

Loads the data contained in I<$path> into the provider, clearing any previously loaded information.

Returns: Gnome::Glib::Error. Test `.is-valid() of that object to see if there was an error.

A way to track errors while loading CSS is to connect to the sig C<parsing-error> signal.

  method gtk_css_provider_load_from_path ( Str $path --> Gnome::Glib::Error )

=item Str $path; the path of a filename to load, in the GLib filename encoding

=end pod

sub gtk_css_provider_load_from_path (
  N-GObject $css_provider, Str $path
  --> Gnome::Glib::Error
) {
  my CArray[N-GError] $ga .= new(N-GError);
  _gtk_css_provider_load_from_path( $css_provider, $path, $ga);
  Gnome::Glib::Error.new(:native-object($ga[0]));
}

sub _gtk_css_provider_load_from_path (
  N-GObject $css_provider, Str $path, CArray[N-GError] $error
  --> int32 )
  is native(&gtk-lib)
  is symbol('gtk_css_provider_load_from_path')
  { * }

#-------------------------------------------------------------------------------
#TM:4:gtk_css_provider_load_from_resource:QAManager package
=begin pod
=head2 [[gtk_] css_provider_] load_from_resource

Loads the data contained in the resource at I<$resource_path> into
the B<Gnome::Gtk3::CssProvider>, clearing any previously loaded information.

To track errors while loading CSS, connect to the sig C<parsing-error> signal.
  method gtk_css_provider_load_from_resource ( Str $resource_path )

=item Str $resource_path; a C<GResource> resource path

=end pod

sub gtk_css_provider_load_from_resource (
  N-GObject $css_provider, Str $resource_path
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_css_provider_get_named:
=begin pod
=head2 [[gtk_] css_provider_] get_named

Loads a theme from the usual theme paths

Returns: (transfer none): a B<Gnome::Gtk3::CssProvider> with the theme loaded.
This memory is owned by GTK+, and you must not free it.

  method gtk_css_provider_get_named ( Str $name, Str $variant --> N-GObject  )

=item Str $name; A theme name
=item Str $variant; (allow-none): variant to load, for example, "dark", or C<Any> for the default

=end pod

sub gtk_css_provider_get_named ( Str $name, Str $variant )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

There are two ways to connect to a signal. The first option you have is to use C<register-signal()> from B<Gnome::GObject::Object>. The second option is to use C<g_signal_connect_object()> directly from B<Gnome::GObject::Signal>.

=head2 First method

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes C<:$widget> and user data are optional.

  # handler method
  method mouse-event ( N-GdkEvent $event, :$widget ) { ... }

  # connect a signal on window object
  my Gnome::Gtk3::Window $w .= new( ... );
  $w.register-signal( self, 'mouse-event', 'button-press-event');

=head2 Second method

  my Gnome::Gtk3::Window $w .= new( ... );
  my Callable $handler = sub (
    N-GObject $native, N-GdkEvent $event, OpaquePointer $data
  ) {
    ...
  }

  $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods C<register-signal()> and C<g_signal_connect_object()> are using the signatures of the handler routines to setup the native call interface.

=head2 Supported signals


=comment #TS:1:parsing-error:
=head3 parsing-error

Signals that a parsing error occurred. the I<path>, I<line> and I<position>
describe the actual location of the error as accurately as possible.

Parsing errors are never fatal, so the parsing will resume after
the error. Errors may however cause parts of the given
data or even all of it to not be parsed at all. So it is a useful idea
to check that the parsing succeeds by connecting to this signal.

Note that this signal may be emitted at any time as the css provider
may opt to defer parsing parts or all of the input to a later time
than when a loading function was called.

  method handler (
    N-GObject $section,
    N-GError $error,
    Int :$_handler_id,
    Gnome::GObject::Object :_widget($provider),
    *%user-options
  );

=item $provider; the provider that had a parsing error

=item $section; a native (GtkCssSection) section the error happened in

=item $error; The parsing error


=end pod
