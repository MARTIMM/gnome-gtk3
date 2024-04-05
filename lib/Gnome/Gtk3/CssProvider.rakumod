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

  use Gnome::Gtk3::CssProvider:api<1>;

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

use Gnome::N::X:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::Glib::Error:api<1>;

use Gnome::GObject::Object:api<1>;

use Gnome::Gtk3::StyleProvider:api<1>;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcssprovider.h
# https://developer.gnome.org/gtk3/stable/GtkCssProvider.html
unit class Gnome::Gtk3::CssProvider:auth<github:MARTIMM>:api<1>;
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

  method new( Str :$name!, Str :$variant? )

=item $name; A theme name like 'Breeze' or 'Oxygen'.
=item $variant; variant to load, for example, 'dark'.


=head3 :native-object

Create a CssProvider object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a CssProvider object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )


=end pod

#TM:1:new():
#TM:1:new(:name,:variant):
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
      if ? %options<named> or ? %options<name> {
        Gnome::N::deprecate(
          'option :named', 'option :name', '0.48.3', '0.50.0'
        ) if ? %options<named>;

        $no = _gtk_css_provider_get_named(
          %options<name> // %options<named>, %options<variant> // Str
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

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_css_provider_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_css_provider_$native-sub", $new-patt, '0.47.4', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('css-provider-'),
        '0.47.4', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-css-provider-'),
          '0.47.4', '0.50.0'
        );
      }
    }
  }

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
#NOTE: called from .new( :name, :variant)
#TM:1:get-named:
#`{{
=begin pod
=head2 get-named

Loads a theme from the usual theme paths

Returns: a B<Gnome::Gtk3::CssProvider> with the theme loaded. This memory is owned by GTK+, and you must not free it.

  method get-named ( Str $name, Str $variant --> N-GObject )

=item $name; A theme name
=item $variant; variant to load, for example, "dark", or C<undefined> for the default
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

  _gtk_css_provider_load_from_data(
    self._get-native-object-no-reffing, $data, $data.chars, $ga
  );

  Gnome::Glib::Error.new(:native-object($ga[0]))
}

#TODO; temporary sub to cope with $length when using old type routines
# remove after version 0.50.0, rename _gtk_css_provider_load_from_data
# above also!!

sub gtk_css_provider_load_from_data (
  N-GObject $css_provider, gchar-ptr $data --> Gnome::Glib::Error
) {
  my CArray[N-GError] $ga .= new(N-GError);
  _gtk_css_provider_load_from_data( $css_provider, $data, $data.chars, $ga);
  note $?LINE, ', ', $ga[0].defined;
  Gnome::Glib::Error.new(:native-object($ga[0]))
}

sub _gtk_css_provider_load_from_data (
  N-GObject $css_provider, gchar-ptr $data, gssize $length,
  CArray[N-GError] $error --> gboolean
) is native(&gtk-lib)
  is symbol('gtk_css_provider_load_from_data')
  { * }

#-------------------------------------------------------------------------------
#TM:1:load-from-file:
=begin pod
=head2 load-from-file

Loads the data contained in I<file> into I<css-provider>, making it clear any previously loaded information.

Returns: Gnome::Glib::Error. Test `.is-valid()` of that object to see if there was an error.

  method load-from-file ( N-GObject() $file --> Gnome::Glib::Error )

=item $file; a B<Gnome::Gio::File> pointing to a file to load
=end pod

method load-from-file ( N-GObject() $file --> Gnome::Glib::Error ) {
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

=item $section; section the error happened in, a native B<Gnome::Gtk3::Section>.
=item $error; the parsing error.
=item $provider; the provider that had a parsing error.
=item $_handle_id; the registered event handler id.
=item $_native-object; The native object provided by the caller wrapped in the Raku object.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod
