#TL:1:Gnome::Gtk3::CssProvider

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::CssProvider

CSS-like styling for widgets

=head1 Description

B<Gnome::Gtk3::CssProvider> is an object implementing the B<Gnome::Gtk3::StyleProvider> interface. It is able to parse [CSS-like](https://developer.gnome.org/gtk3/3.24/chap-css-overview.html#css-overview) input in order to style widgets.

An application can make GTK+ parse a specific CSS style sheet by calling C<gtk_css_provider_load_from_file()> or C<gtk_css_provider_load_from_resource()> and adding the provider with C<gtk_style_context_add_provider()> or C<gtk_style_context_add_provider_for_screen()>. In addition, certain files will be read when GTK+ is initialized. First, the file `$XDG_CONFIG_HOME/gtk-3.0/gtk.css` is loaded if it exists. Then, GTK+ loads the first existing file among `XDG_DATA_HOME/themes/theme-name/gtk-VERSION/gtk.css`, `$HOME/.themes/theme-name/gtk-VERSION/gtk.css`, `$XDG_DATA_DIRS/themes/theme-name/gtk-VERSION/gtk.css` and `DATADIR/share/themes/THEME/gtk-VERSION/gtk.css`, where `THEME` is the name of the current theme (see the prop C<gtk-theme-name> setting), `DATADIR` is the prefix configured when GTK+ was compiled (unless overridden by the `GTK_DATA_PREFIX` environment variable), and `VERSION` is the GTK+ version number. If no file is found for the current version, GTK+ tries older versions all the way back to 3.0.

In the same way, GTK+ tries to load a gtk-keys.css file for the current key theme, as defined by prop C<gtk-key-theme-name>.

=head2 Implemented Interfaces

Gnome::Gtk3::CssProvider implements

=item [Gnome::Gtk3::StyleProvider](StyleProvider.html)
=item Gnome::Gtk3::StyleProviderPrivate

=head2 See Also

B<Gnome::Gtk3::StyleContext>, B<Gnome::Gtk3::StyleProvider>

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::CssProvider;
  also is Gnome::GObject::Object;
  also does Gnome::Gtk3::StyleProvider;

=head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
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

Create a new plain object.

  multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also B<Gnome::GObject::Object>.

  multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:1:new(:empty):
#TM:0:new(:widget):
#TM:0:new(:build-id):

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :w2<parsing-error>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::CssProvider';

  if ? %options<empty> {
    self.native-gobject(gtk_css_provider_new());
  }

  elsif ? %options<widget> || ? %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::Gnome.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }

  # only after creating the widget, the gtype is known
  self.set-class-info('GtkCssProvider');
}

#-------------------------------------------------------------------------------
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_css_provider_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
  $s = self._style_provider_interface($native-sub) unless ?$s;

  self.set-class-name-of-sub('GtkCssProvider');
  $s = callsame unless ?$s;

  $s
}


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

Since: 3.2

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

Returns: Gnome::Glib::Error. Test the error-is-valid flag of that object to see if there was an error.

A way to track errors while loading CSS is to connect to the sig C<parsing-error> signal.

  method gtk_css_provider_load_from_data (
    Str $data, Int $length
    --> Gnome::Glib::Error
  )

=item Str $data; (array length=length) (element-type guint8): CSS data loaded in memory
=item Int $length; the length of I<data> in bytes, or -1 for NUL terminated strings. If I<length> is not -1, the code will assume it is not NUL terminated and will potentially do a copy.

=end pod

proto gtk_css_provider_load_from_data (
  N-GObject $css_provider, Str $data, |
) { * }

multi sub gtk_css_provider_load_from_data (
  N-GObject $css_provider, Str $data, Int $length, Any $error
  --> uint32
) is DEPRECATED('other multi version of gtk_css_provider_load_from_data') {
#  DEPRECATED(
#    'other multi version of gtk_css_provider_load_from_data',
#    '0.17.12', '0.22.0'
#  );

  my CArray[N-GError] $ga .= new(N-GError);
  _gtk_css_provider_load_from_data( $css_provider, $data, $length, $ga)
}

multi sub gtk_css_provider_load_from_data (
  N-GObject $css_provider, Str $data
  --> Gnome::Glib::Error
) {
  my CArray[N-GError] $ga .= new(N-GError);
  _gtk_css_provider_load_from_data( $css_provider, $data, $data.chars, $ga);
  Gnome::Glib::Error.new(:gerror($ga[0]));
}

sub _gtk_css_provider_load_from_data ( N-GObject $css_provider, Str $data, int64 $length, CArray[N-GError] $error )
  returns int32
  is native(&gtk-lib)
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

Returns: Gnome::Glib::Error. Test the error-is-valid flag of that object to see if there was an error.

A way to track errors while loading CSS is to connect to the sig C<parsing-error> signal.

  method gtk_css_provider_load_from_path ( Str $path --> Gnome::Glib::Error )

=item Str $path; the path of a filename to load, in the GLib filename encoding

=end pod

proto gtk_css_provider_load_from_path (
  N-GObject $css_provider, Str $path, |
) { * }

multi sub gtk_css_provider_load_from_path (
  N-GObject $css_provider, Str $path, Any $error
  --> int32
) is DEPRECATED('other multi version of gtk_css_provider_load_from_path') {

  _gtk_css_provider_load_from_path( $css_provider, $path, Any);
}

multi sub gtk_css_provider_load_from_path (
  N-GObject $css_provider, Str $path
  --> Gnome::Glib::Error
) {
  my CArray[N-GError] $ga .= new(N-GError);
  _gtk_css_provider_load_from_path( $css_provider, $path, $ga);
  Gnome::Glib::Error.new(:gerror($ga[0]));
}

sub _gtk_css_provider_load_from_path (
  N-GObject $css_provider, Str $path, CArray[N-GError] $error
) returns int32
  is native(&gtk-lib)
  is symbol('gtk_css_provider_load_from_path')
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_css_provider_load_from_resource:
=begin pod
=head2 [[gtk_] css_provider_] load_from_resource

Loads the data contained in the resource at I<resource_path> into
the B<Gnome::Gtk3::CssProvider>, clearing any previously loaded information.

To track errors while loading CSS, connect to the
sig C<parsing-error> signal.

Since: 3.16

  method gtk_css_provider_load_from_resource ( Str $resource_path )

=item Str $resource_path; a C<GResource> resource path

=end pod

sub gtk_css_provider_load_from_resource ( N-GObject $css_provider, Str $resource_path )
  is native(&gtk-lib)
  { * }
}}

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
    Gnome::GObject::Object :widget($provider),
    *%user-options
  );

=item $provider; the provider that had a parsing error

=item $section; a native (GtkCssSection) section the error happened in

=item $error; The parsing error


=end pod















=finish
#-------------------------------------------------------------------------------
sub gtk_css_provider_new ( )
  returns N-GObject       # GtkCssProvider
  is native(&gtk-lib)
  { * }

sub gtk_css_provider_get_named ( Str $name, Str $variant )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_css_provider_load_from_path (
  N-GObject $css_provider, Str $css-file, OpaquePointer
) is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :parseerr<parsing-error>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::CssProvider';

  if ? %options<empty> {
    self.native-gobject(gtk_css_provider_new());
  }

  elsif ? %options<widget> || ? %options<build-id> {
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
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_css_provider_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
