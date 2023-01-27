#TL:1:Gnome::Gtk3::IconTheme:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::IconTheme

Looking up icons by name

=comment ![](images/X.png)

=head1 Description

B<Gnome::Gtk3::IconTheme> provides a facility for looking up icons by name and size. The main reason for using a name rather than simply providing a filename is to allow different icons to be used depending on what “icon theme” is selected by the user. The operation of icon themes on Linux and Unix follows the [Icon Theme Specification](http://www.freedesktop.org/Standards/icon-theme-spec) There is a fallback icon theme, named `hicolor`, where applications should install their icons, but additional icon themes can be installed as operating system vendors and users choose.

The B<Gnome::Gtk3::IconTheme> object acts as a database of all the icons in the current theme. You can create new B<Gnome::Gtk3::IconTheme> objects, but it’s much more efficient to use the standard icon theme for the B<Gnome::Gdk3::Screen> so that the icon information is shared with other people looking up icons.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::IconTheme;
  also is Gnome::GObject::Object;


=head2 Uml Diagram

![](plantuml/IconTheme.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::IconTheme;

  unit class MyGuiClass;
  also is Gnome::Gtk3::IconTheme;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::IconTheme class process the options
    self.bless( :GtkIconTheme, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment

=head2 Example

This example shows how to load an icon and check for errors

  my Gnome::Gtk3::IconTheme $icon-theme .= new(:default);
  my Gnome::Gdk3::Pixbuf() $pixbuf = $icon-theme.load-icon(
    'server-database',    # an icon name
    48,                   # icon size
    0,                    # flags
  );

  unless $pixbuf.is-valid {
    die "Couldn’t load icon: " ~ $icon-theme.last-error.message;
  }

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Glib::Error;
use Gnome::Glib::List;

use Gnome::GObject::Object;

#use Gnome::Cairo::Types;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::IconTheme:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

has Gnome::Glib::Error() $.last-error .= new(:native-object(N-GError));

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkIconLookupFlags

Used to specify options for C<.lookup-icon()>

=item GTK_ICON_LOOKUP_NO_SVG: Never get SVG icons, even if gdk-pixbuf supports them. Cannot be used together with C<GTK_ICON_LOOKUP_FORCE_SVG>.
=item GTK_ICON_LOOKUP_FORCE_SVG: Get SVG icons, even if gdk-pixbuf doesn’t support them. Cannot be used together with C<GTK_ICON_LOOKUP_NO_SVG>.
=item GTK_ICON_LOOKUP_USE_BUILTIN: When passed to C<.lookup-icon()> includes builtin icons as well as files. For a builtin icon, C<Gnome::Gtk3::IconInfo.get-filename()> is C<Any> and you need to call C<Gnome::Gtk3::IconInfo.get-builtin-pixbuf()>.
=item GTK_ICON_LOOKUP_GENERIC_FALLBACK: Try to shorten icon name at '-' characters before looking at inherited themes. This flag is only supported in functions that take a single icon name. For more general fallback, see C<.choose-icon()>.
=item GTK_ICON_LOOKUP_FORCE_SIZE: Always get the icon scaled to the requested size.
=item GTK_ICON_LOOKUP_FORCE_REGULAR: Try to always load regular icons, even when symbolic icon names are given.
=item GTK_ICON_LOOKUP_FORCE_SYMBOLIC: Try to always load symbolic icons, even when regular icon names are given.
=item GTK_ICON_LOOKUP_DIR_LTR: Try to load a variant of the icon for left-to-right text direction.
=item GTK_ICON_LOOKUP_DIR_RTL: Try to load a variant of the icon for right-to-left text direction.


=end pod

#TE:0:GtkIconLookupFlags:
enum GtkIconLookupFlags is export (
  'GTK_ICON_LOOKUP_NO_SVG'           => 1 +< 0,
  'GTK_ICON_LOOKUP_FORCE_SVG'        => 1 +< 1,
  'GTK_ICON_LOOKUP_USE_BUILTIN'      => 1 +< 2,
  'GTK_ICON_LOOKUP_GENERIC_FALLBACK' => 1 +< 3,
  'GTK_ICON_LOOKUP_FORCE_SIZE'       => 1 +< 4,
  'GTK_ICON_LOOKUP_FORCE_REGULAR'    => 1 +< 5,
  'GTK_ICON_LOOKUP_FORCE_SYMBOLIC'   => 1 +< 6,
  'GTK_ICON_LOOKUP_DIR_LTR'          => 1 +< 7,
  'GTK_ICON_LOOKUP_DIR_RTL'          => 1 +< 8
);

#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkIconThemeError

Error codes for B<Gnome::Gtk3::IconTheme> operations.

=item GTK_ICON_THEME_NOT_FOUND: The icon specified does not exist in the theme
=item GTK_ICON_THEME_FAILED: An unspecified error occurred.


=end pod

#TE:0:GtkIconThemeError:
enum GtkIconThemeError is export (
  'GTK_ICON_THEME_NOT_FOUND',
  'GTK_ICON_THEME_FAILED'
);


#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkIconTheme

Acts as a database of information about an icon theme. Normally, you retrieve the icon theme for a particular screen using C<.get-for-screen()> and it will contain information about current icon theme for that screen, but you can also create a new B<Gnome::Gtk3::IconTheme> object and set the icon theme name explicitly using C<.set-custom-theme()>.

=end pod

# TT:0:N-GtkIconTheme:
#`{{
class N-GtkIconTheme is export is repr('CStruct') {
  has N-GObject $.parent_instance;
  has GtkIconThemePrivate $.priv;
}
}}
class N-GtkIconTheme
  is repr('CPointer')
  is export
  { }

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkIconInfo

Contains information found when looking up an icon in an icon theme.
=end pod

# TT:0::N-GtkIconInfo
class N-GtkIconInfo
  is repr('CPointer')
  is export
  { }
}}

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Creates a new icon theme object. Icon theme objects are used to lookup up an icon by name in a particular icon theme. Usually, you’ll want to use C<.new(:default)> or C<.new(:screen)> rather than creating a new icon theme object from scratch.

  multi method new ( )


=head3 new(:default)

Gets the icon theme for the default screen. See C<.get-for-screen()>. This icon theme is associated with the screen and can be used as long as the screen is open. Do not ref or unref it.
  Use of named attribute is enough to select this action.

  multi method new ( Bool :$default )


=head3 new(:screen)

Gets the icon theme object associated with I<$screen>; if this function has not previously been called for the given screen, a new icon theme object will be created and associated with the screen. Icon theme objects are fairly expensive to create, so using this function is usually a better choice than calling C<.new()> and setting the screen yourself; by using this function a single icon theme object will be shared between users. This icon theme is associated with the screen and can be used as long as the screen is open.
=comment #TODO; Do not ref or unref it.

  multi method new ( N-GObject :$screen )

=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:1:new(:default):
#TM:1:new(:screen):
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object
submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w0<changed>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::IconTheme' #`{{ or %options<GtkIconTheme> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # process all options

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    else {
      my $no;
      if %options<default>:exists {
        $no = _gtk_icon_theme_get_default();
      }

      elsif %options<screen>:exists {
        $no = %options<screen>;
        $no .= _get-native-object-no-reffing
          if $no.^can('_get-native-object-no-reffing');
        $no = _gtk_icon_theme_get_for_screen($no);
      }

#      #`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
#      }}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

#      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_icon_theme_new();
      }
#      }}

      self._set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkIconTheme');

  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Str $new-patt = $native-sub.subst( '_', '-', :g);

  my Callable $s;
  try { $s = &::("gtk_icon_theme_$native-sub"); };
  if ?$s {
    Gnome::N::deprecate(
      "gtk_icon_theme_$native-sub", $new-patt, '0.48.15', '0.50.0'
    );
  }

  else {
    try { $s = &::("gtk_$native-sub"); } unless ?$s;
    if ?$s {
      Gnome::N::deprecate(
        "gtk_$native-sub", $new-patt.subst('icon-theme-'),
        '0.48.15', '0.50.0'
      );
    }

    else {
      try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;
      if ?$s {
        Gnome::N::deprecate(
          "$native-sub", $new-patt.subst('gtk-icon-theme-'),
          '0.48.15', '0.50.0'
        );
      }
    }
  }

  self._set-class-name-of-sub('GtkIconTheme');
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
#TM:0:error-quark:
=begin pod
=head2 error-quark

Get the error code for icon theme errors

  method error-quark ( --> Int )

=end pod

method error-quark ( --> UInt ) {
  gtk_icon_theme_error_quark( self._get-native-object-no-reffing)
}

sub gtk_icon_theme_error_quark ( --> GQuark )
   is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:last-error:
=begin pod
=head2 

Get the last error code for icon theme errors

  method last-error ( --> Gnome::Glib::Error )

=end pod

#method last-error ( --> Gnome::Glib::Error) {
#  $!last-error;
#}

#-------------------------------------------------------------------------------
#TM:0:add-resource-path:
=begin pod
=head2 add-resource-path

Adds a resource path that will be looked at when looking for icons, similar to search paths.

This function should be used to make application-specific icons available as part of the icon theme.

The resources are considered as part of the hicolor icon theme and must be located in subdirectories that are defined in the hicolor icon theme, such as `I<path>/16x16/actions/run.png`. Icons that are directly placed in the resource path instead of a subdirectory are also considered as ultimate fallback.

  method add-resource-path ( Str $path )

=item $path; a resource path
=end pod

method add-resource-path ( Str $path ) {
  gtk_icon_theme_add_resource_path( self._get-native-object-no-reffing, $path);
}

sub gtk_icon_theme_add_resource_path (
  N-GObject $icon_theme, gchar-ptr $path 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:append-search-path:
=begin pod
=head2 append-search-path

Appends a directory to the search path. See C<.set-search-path()>.

  method append-search-path ( Str $path )

=item $path; (type filename): directory name to append to the icon path
=end pod

method append-search-path ( Str $path ) {
  gtk_icon_theme_append_search_path( self._get-native-object-no-reffing, $path);
}

sub gtk_icon_theme_append_search_path (
  N-GObject $icon_theme, gchar-ptr $path 
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:choose-icon:
=begin pod
=head2 choose-icon

Looks up a named icon and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using C<Gnome::Gtk3::IconInfo.load-icon()>. (C<.load-icon()> combines these two steps if all you need is the pixbuf.)

If I<icon_names> contains more than one name, this function tries them all in the given order before falling back to inherited icon themes.

Returns: a B<Gnome::Gtk3::IconInfo> object containing information about the icon, or undefined if the icon wasn’t found.

  method choose-icon (  $const gchar *icon_names[], Int() $size, GtkIconLookupFlags $flags --> GtkIconInfo )

=item $const gchar *icon_names[]; C<undefined>-terminated array of icon names to lookup
=item $size; desired icon size
=item $flags; flags modifying the behavior of the icon lookup
=end pod

method choose-icon (
  Array $icon_names, Int() $size, GtkIconLookupFlags $flags
  --> GtkIconInfo
) {
  gtk_icon_theme_choose_icon(
    self._get-native-object-no-reffing,
    $const gchar *icon_names[], $size, $flags
  )
}

sub gtk_icon_theme_choose_icon (
  N-GObject $icon_theme,  $const gchar *icon_names[], gint $size, GEnum $flags --> GtkIconInfo
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:choose-icon-for-scale:
=begin pod
=head2 choose-icon-for-scale

Looks up a named icon for a particular window scale and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using C<Gnome::Gtk3::IconInfo.load-icon()>. (C<.load-icon()> combines these two steps if all you need is the pixbuf.)

If I<icon_names> contains more than one name, this function tries them all in the given order before falling back to inherited icon themes.

Returns: a B<Gnome::Gtk3::IconInfo> object containing information about the icon, or C<undefined> if the icon wasn’t found.

  method choose-icon-for-scale (  $const gchar *icon_names[], Int() $size, Int() $scale, GtkIconLookupFlags $flags --> GtkIconInfo )

=item $const gchar *icon_names[]; (0 terminated) an array of icon names to lookup
=item $size; desired icon size
=item $scale; desired scale
=item $flags; flags modifying the behavior of the icon lookup
=end pod

method choose-icon-for-scale (  $const gchar *icon_names[], Int() $size, Int() $scale, GtkIconLookupFlags $flags --> GtkIconInfo ) {
  gtk_icon_theme_choose_icon_for_scale( self._get-native-object-no-reffing, $const gchar *icon_names[], $size, $scale, $flags)
}

sub gtk_icon_theme_choose_icon_for_scale (
  N-GObject $icon_theme,  $const gchar *icon_names[], gint $size, gint $scale, GEnum $flags --> GtkIconInfo
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_icon_theme_get_default:
#`{{
  =begin pod
=head2 get-default

Gets the icon theme for the default screen. See C<.get-for-screen()>.

Returns: A unique B<Gnome::Gtk3::IconTheme> associated with the default screen. This icon theme is associated with the screen and can be used as long as the screen is open. Do not ref or unref it.

  method get-default ( --> N-GObject )

=end pod

method get-default ( --> N-GObject ) {
  gtk_icon_theme_get_default( self._get-native-object-no-reffing)
}
}}

sub _gtk_icon_theme_get_default (
   --> N-GObject
) is native(&gtk-lib)
  is symbol('gtk_icon_theme_get_default')
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-example-icon-name:
=begin pod
=head2 get-example-icon-name

Gets the name of an icon that is representative of the current theme (for instance, to use when presenting a list of themes to the user.)

Returns: the name of an example icon or undefined.

  method get-example-icon-name ( --> Str )

=end pod

method get-example-icon-name ( --> Str ) {
  gtk_icon_theme_get_example_icon_name( self._get-native-object-no-reffing)
}

sub gtk_icon_theme_get_example_icon_name (
  N-GObject $icon_theme --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_icon_theme_get_for_screen:
#`{{
=begin pod
=head2 get-for-screen

Gets the icon theme object associated with I<screen>; if this function has not previously been called for the given screen, a new icon theme object will be created and associated with the screen. Icon theme objects are fairly expensive to create, so using this function is usually a better choice than calling than C<new()> and setting the screen yourself; by using this function a single icon theme object will be shared between users.

Returns: A unique B<Gnome::Gtk3::IconTheme> associated with the given screen. This icon theme is associated with the screen and can be used as long as the screen is open. Do not ref or unref it.

  method get-for-screen ( N-GObject() $screen --> N-GObject )

=item $screen; a B<Gnome::Gdk3::Screen>
=end pod

method get-for-screen ( N-GObject() $screen --> N-GObject ) {
  gtk_icon_theme_get_for_screen( self._get-native-object-no-reffing, $screen)
}
}}

sub _gtk_icon_theme_get_for_screen (
  N-GObject $screen --> N-GObject
) is native(&gtk-lib)
  is symbol('gtk_icon_theme_get_for_screen')
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-icon-sizes:
=begin pod
=head2 get-icon-sizes

Returns an array of integers describing the sizes at which the icon is available without scaling. A size of -1 means that the icon is available in a scalable format. The array is zero-terminated.

Returns: An newly allocated array describing the sizes at which the icon is available.
=comment The array should be freed with C<g-free()> when it is no longer needed.

  method get-icon-sizes ( Str $icon_name --> Int-ptr )

=item $icon_name; the name of an icon
=end pod

method get-icon-sizes ( Str $icon_name --> Int-ptr ) {
  gtk_icon_theme_get_icon_sizes( self._get-native-object-no-reffing, $icon_name)
}

sub gtk_icon_theme_get_icon_sizes (
  N-GObject $icon_theme, gchar-ptr $icon_name --> gint-ptr
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-search-path:
=begin pod
=head2 get-search-path

Gets the current search path. See C<set-search-path()>.

  method get-search-path (  $gchar **path[] )

=item $gchar **path[];  (array length=n_elements) (element-type filename) : location to store a list of icon theme path directories or C<undefined>.
=comment The stored value should be freed with C<g-strfreev()>.
=item $n_elements; location to store number of elements in I<path>, or C<undefined>
=end pod

method get-search-path ( $gchar **path[] ) {
  gtk_icon_theme_get_search_path( self._get-native-object-no-reffing, $gchar **path[], my gint $n_elements);
}

sub gtk_icon_theme_get_search_path (
  N-GObject $icon_theme,  $gchar **path[], gint $n_elements is rw 
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:has-icon:
=begin pod
=head2 has-icon

Checks whether an icon theme includes an icon for a particular name.

Returns: C<True> if I<icon_theme> includes an icon for I<icon-name>.

  method has-icon ( Str $icon_name --> Bool )

=item $icon_name; the name of an icon
=end pod

method has-icon ( Str $icon_name --> Bool ) {
  gtk_icon_theme_has_icon( self._get-native-object-no-reffing, $icon_name).Bool
}

sub gtk_icon_theme_has_icon (
  N-GObject $icon_theme, gchar-ptr $icon_name --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:list-contexts:
=begin pod
=head2 list-contexts

Gets the list of contexts available within the current hierarchy of icon themes. See C<list-icons()> for details about contexts.

Returns: (element-type utf8) : a B<Gnome::Gio::List> list holding the names of all the contexts in the theme.
=comment You must first free each element in the list with C<g-free()>, then free the list itself with C<g-list-free()>.

  method list-contexts ( --> N-GList )

=end pod

method list-contexts ( --> N-GList ) {
  gtk_icon_theme_list_contexts( self._get-native-object-no-reffing)
}

sub gtk_icon_theme_list_contexts (
  N-GObject $icon_theme --> N-GList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:list-icons:
=begin pod
=head2 list-icons

Lists the icons in the current icon theme. Only a subset of the icons can be listed by providing a context string. The set of values for the context string is system dependent, but will typically include such values as “Applications” and “MimeTypes”. Contexts are explained in the [Icon Theme Specification](http://www.freedesktop.org/wiki/Specifications/icon-theme-spec). The standard contexts are listed in the [Icon Naming Specification](http://www.freedesktop.org/wiki/Specifications/icon-naming-spec). Also see C<list-contexts()>.

Returns: (element-type utf8) : a B<Gnome::Gio::List> list holding the names of all the icons in the theme.
=comment You must first free each element in the list with C<g-free()>, then free the list itself with C<g-list-free()>.

  method list-icons ( Str $context --> N-GList )

=item $context; a string identifying a particular type of icon, or C<undefined> to list all icons.
=end pod

method list-icons ( Str $context --> N-GList ) {
  gtk_icon_theme_list_icons( self._get-native-object-no-reffing, $context)
}

sub gtk_icon_theme_list_icons (
  N-GObject $icon_theme, gchar-ptr $context --> N-GList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:load-icon:icon.raku
=begin pod
=head2 load-icon

Looks up an icon in an icon theme, scales it to the given size and renders it into a pixbuf. This is a convenience function; if more details about the icon are needed, use C<lookup-icon()> followed by C<Gnome::Gtk3::Info.load-icon()>.

Note that you probably want to listen for icon theme changes and update the icon. This is usually done by connecting to the style-set signal defined in B<Gnome::Gtk3::Widget>.
=comment If for some reason you do not want to update the icon when the icon theme changes, you should consider using C<Ggdk-pixbuf-copy()> to make a private copy of the pixbuf returned by this function. Otherwise GTK+ may need to keep the old icon theme loaded, which would be a waste of memory.

Returns: the rendered icon (a native B<Gnome::Gdk3::Pixbuf>); this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Returns an undefined object if the icon isn’t found.

  method load-icon (
    Str $icon_name, Int() $size, UInt $flags
    --> N-GObject
  )

=item $icon_name; the name of the icon to lookup
=item $size; the desired icon size. The resulting icon may not be exactly this size; see C<Gnome::Gtk3::IconInfo.load-icon()>.
=item $flags; flags from GtkIconLookupFlags modifying the behavior of the icon lookup

When an error occurs, check the last error attribute;

=head3 Example

  my Gnome::Gdk3::Pixbuf() $pixbuf;
  $pixbuf = $icon-theme.load-icon( 'server-database', 32, 0);
  unless $pixbuf.is-valid {
    die "Couldn’t load icon: " ~ $icon-theme.last-error.message;
  }


=end pod

method load-icon (
  Str $icon_name, Int() $size, GFlag $flags --> N-GObject
) {
  my $error = CArray[N-GError].new(N-GError);
  my N-GObject $no = gtk_icon_theme_load_icon(
    self._get-native-object-no-reffing, $icon_name, $size,
    $flags, $error
  );

  if $error[0].defined {
    $!last-error = $error[0];
    $no = N-GObject;
  }

  else {
    $!last-error = N-GError;
  }

  $no;
}

sub gtk_icon_theme_load_icon (
  N-GObject $icon_theme, gchar-ptr $icon_name, gint $size, GEnum $flags,
  CArray[N-GError] $error --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:load-icon-for-scale:icon.raku
=begin pod
=head2 load-icon-for-scale

Looks up an icon in an icon theme for a particular window scale, scales it to the given size and renders it into a pixbuf. This is a convenience function; if more details about the icon are needed, use C<lookup-icon()> followed by C<Gnome::Gtk3::Info.load-icon()>.

Note that you probably want to listen for icon theme changes and update the icon. This is usually done by connecting to the GtkWidget::style-set signal.
=comment If for some reason you do not want to update the icon when the icon theme changes, you should consider using C<gdk-pixbuf-copy()> to make a private copy of the pixbuf returned by this function. Otherwise GTK+ may need to keep the old icon theme loaded, which would be a waste of memory.

Returns: the rendered icon (a native B<Gnome::Gdk3::Pixbuf>); this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Returns an undefined object if the icon isn’t found.

  method load-icon-for-scale (
    Str $icon-name, Int() $size, Int() $scale, UInt $flags
    --> N-GObject
  )

=item $icon-name; the name of the icon to lookup
=item $size; the desired icon size. The resulting icon may not be exactly this size; see C<Gnome::Gtk3::Info.load-icon()>.
=item $scale; desired scale
=item $flags; flags modifying the behavior of the icon lookup
=end pod

method load-icon-for-scale (
  Str $icon_name, Int() $size, Int() $scale, GFlag $flags
  --> N-GObject
) {
  my $error = CArray[N-GError].new(N-GError);
  my $no = gtk_icon_theme_load_icon_for_scale(
    self._get-native-object-no-reffing, $icon_name, $size, $scale,
    $flags, $error
  );

  if $error[0].defined {
    $!last-error = $error[0];
    $no = N-GObject;
  }

  else {
    $!last-error = N-GError;
  }

  $no;
}

sub gtk_icon_theme_load_icon_for_scale (
  N-GObject $icon_theme, gchar-ptr $icon_name, gint $size, gint $scale,
  GFlag $flags, CArray[N-GError] $error
  --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-surface:
=begin pod
=head2 load-surface

Looks up an icon in an icon theme for a particular window scale, scales it to the given size and renders it into a cairo surface. This is a convenience function; if more details about the icon are needed, use C<lookup-icon()> followed by C<Gnome::Gtk3::Info.load-surface()>.

Note that you probably want to listen for icon theme changes and update the icon. This is usually done by connecting to the GtkWidget::style-set signal.

Returns: the rendered icon (a cairo surface_t); this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<cairo-surface-destroy()> to release your reference to the icon. C<undefined> if the icon isn’t found.

  method load-surface (
    Str $icon_name, Int() $size, Int() $scale,
    N-GObject() $for-window, UInt $flags
    --> cairo_surface_t
  )

=item $icon_name; the name of the icon to lookup
=item $size; the desired icon size. The resulting icon may not be exactly this size; see C<Gnome::Gtk3::Info.load-icon()>.
=item $scale; desired scale
=item $for-window; B<Gnome::Gdk3::Window> to optimize drawing for, or C<undefined>
=item $flags; flags modifying the behavior of the icon lookup
=end pod

method load-surface (
  Str $icon_name, Int() $size, Int() $scale, N-GObject() $for_window,
  GFlag $flags
  --> N-GObject
) {
  my $error = CArray[N-GError].new(N-GError);
  my $no = gtk_icon_theme_load_surface(
    self._get-native-object-no-reffing, $icon_name, $size,
    $scale, $for_window, $flags, $error
  );

  if $error[0].defined {
    $!last-error = $error[0];
    $no = N-GObject;
  }

  else {
    $!last-error = N-GError;
  }

  $no;
}

sub gtk_icon_theme_load_surface (
  N-GObject $icon_theme, gchar-ptr $icon_name, gint $size,
  gint $scale, N-GObject $for_window, GFlag $flags,
  CArray[N-GError] $error --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:lookup-by-gicon:
=begin pod
=head2 lookup-by-gicon

Looks up an icon and returns a native B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using C<Gnome::Gtk3::IconInfo.load-icon()>.

When rendering on displays with high pixel densities you should not use a I<size> multiplied by the scaling factor returned by functions like C<gdk-window-get-scale-factor()>. Instead, you should use C<lookup-by-gicon-for-scale()>, as the assets loaded for a given scaling factor may be different.

Returns: a native B<Gnome::Gtk3::IconInfo> containing information about the icon, or C<undefined> if the icon wasn’t found.
=comment Unref with C<g-object-unref()>

  method lookup-by-gicon (
    N-GObject() $icon, Int() $size, UInt() $flags
    --> N-GObject
  )

=item $icon; the B<Gnome::Gio::Icon> to look up
=item $size; desired icon size
=item $flags; flags from GtkIconLookupFlags modifying the behavior of the icon lookup
=end pod

method lookup-by-gicon (
  N-GObject() $icon, Int() $size, GFlag $flags
  --> N-GObject
) {
  gtk_icon_theme_lookup_by_gicon(
    self._get-native-object-no-reffing, $icon, $size, $flags
  )
}

sub gtk_icon_theme_lookup_by_gicon (
  N-GObject $icon_theme, N-GObject $icon, gint $size, GFlag $flags --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:lookup-by-gicon-for-scale:
=begin pod
=head2 lookup-by-gicon-for-scale

Looks up an icon and returns a native B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using C<Gnome::Gtk3::IconInfo.load-icon()>.

Returns: a native B<Gnome::Gtk3::IconInfo> containing information about the icon, or C<undefined> if the icon wasn’t found.
=comment Unref with C<g-object-unref()>

  method lookup-by-gicon-for-scale (
    N-GObject() $icon, Int() $size, Int() $scale, UInt $flags
    --> N-GObject
  )

=item $icon; the B<Gnome::Gio::Icon> to look up
=item $size; desired icon size
=item $scale; the desired scale
=item $flags; flags modifying the behavior of the icon lookup
=end pod

method lookup-by-gicon-for-scale (
  N-GObject() $icon, Int() $size, Int() $scale, GtkIconLookupFlags $flags
  --> N-GObject
) {
  gtk_icon_theme_lookup_by_gicon_for_scale( self._get-native-object-no-reffing, $icon, $size, $scale, $flags)
}

sub gtk_icon_theme_lookup_by_gicon_for_scale (
  N-GObject $icon_theme, N-GObject $icon, gint $size, gint $scale, GEnum $flags --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:lookup-icon:
=begin pod
=head2 lookup-icon

Looks up a named icon and returns a native B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using C<Gnome::Gtk3::IconInfo.load-icon()>. (C<.load-icon()> combines these two steps if all you need is the pixbuf.)

When rendering on displays with high pixel densities you should not use a I<size> multiplied by the scaling factor returned by functions like C<Gnome::Gdk3::Window.get-scale-factor()>. Instead, you should use C<.lookup-icon-for-scale()>, as the assets loaded for a given scaling factor may be different.

Returns: a native B<Gnome::Gtk3::IconInfo> object containing information about the icon, or C<undefined> if the icon wasn’t found.

  method lookup-icon (
    Str $icon-name, Int() $size, UInt $flags --> N-GObject
  )

=item $icon_name; the name of the icon to lookup
=item $size; desired icon size
=item $flags; flags from GtkIconLookupFlags modifying the behavior of the icon lookup
=end pod

method lookup-icon (
  Str $icon_name, Int() $size, GFlag $flags
  --> N-GObject
) {
  gtk_icon_theme_lookup_icon(
    self._get-native-object-no-reffing, $icon_name, $size, $flags
  )
}

sub gtk_icon_theme_lookup_icon (
  N-GObject $icon_theme, gchar-ptr $icon_name, gint $size, GFlag $flags
  --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:lookup-icon-for-scale:
=begin pod
=head2 lookup-icon-for-scale

Looks up a named icon for a particular window scale and returns a native B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using C<Gnome::Gtk3::IconInfo.load-icon()>. (C<Gnome::Gtk3::IconInfo.load-icon()> combines these two steps if all you need is the pixbuf.)

Returns: a native  B<Gnome::Gtk3::IconInfo> object containing information about the icon, or C<undefined> if the icon wasn’t found.

  method lookup-icon-for-scale (
    Str $icon_name, Int() $size, Int() $scale, UInt $flags
    --> N-GObject
  )

=item $icon_name; the name of the icon to lookup
=item $size; desired icon size
=item $scale; the desired scale
=item $flags; flags from GtkIconLookupFlags modifying the behavior of the icon lookup
=end pod

method lookup-icon-for-scale (
  Str $icon_name, Int() $size, Int() $scale, GFlag $flags --> N-GObject
) {
  gtk_icon_theme_lookup_icon_for_scale(
    self._get-native-object-no-reffing, $icon_name, $size, $scale, $flags
  )
}

sub gtk_icon_theme_lookup_icon_for_scale (
  N-GObject $icon_theme, gchar-ptr $icon_name, gint $size,
  gint $scale, GFlag $flags
  --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:prepend-search-path:
=begin pod
=head2 prepend-search-path

Prepends a directory to the search path. See C<set-search-path()>.

  method prepend-search-path ( Str $path )

=item $path; (type filename): directory name to prepend to the icon path
=end pod

method prepend-search-path ( Str $path ) {
  gtk_icon_theme_prepend_search_path(
    self._get-native-object-no-reffing, $path
  );
}

sub gtk_icon_theme_prepend_search_path (
  N-GObject $icon_theme, gchar-ptr $path 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:rescan-if-needed:
=begin pod
=head2 rescan-if-needed

Checks to see if the icon theme has changed; if it has, any currently cached information is discarded and will be reloaded next time I<icon_theme> is accessed.

Returns: C<True> if the icon theme has changed and needed to be reloaded.

  method rescan-if-needed ( --> Bool )

=end pod

method rescan-if-needed ( --> Bool ) {
  gtk_icon_theme_rescan_if_needed( self._get-native-object-no-reffing).Bool
}

sub gtk_icon_theme_rescan_if_needed (
  N-GObject $icon_theme --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-custom-theme:
=begin pod
=head2 set-custom-theme

Sets the name of the icon theme that the B<Gnome::Gtk3::IconTheme> object uses overriding system configuration. This function cannot be called on the icon theme objects returned from C<get-default()> and C<get-for-screen()>.

  method set-custom-theme ( Str $theme_name )

=item $theme_name; name of icon theme to use instead of configured theme, or C<undefined> to unset a previously set custom theme
=end pod

method set-custom-theme ( Str $theme_name ) {
  gtk_icon_theme_set_custom_theme( self._get-native-object-no-reffing, $theme_name);
}

sub gtk_icon_theme_set_custom_theme (
  N-GObject $icon_theme, gchar-ptr $theme_name 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-screen:
=begin pod
=head2 set-screen

Sets the screen for an icon theme; the screen is used to track the user’s currently configured icon theme, which might be different for different screens.

  method set-screen ( N-GObject() $screen )

=item $screen; a B<Gnome::Gdk3::Screen>
=end pod

method set-screen ( N-GObject() $screen ) {
  gtk_icon_theme_set_screen( self._get-native-object-no-reffing, $screen);
}

sub gtk_icon_theme_set_screen (
  N-GObject $icon_theme, N-GObject $screen 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-search-path:
=begin pod
=head2 set-search-path

Sets the search path for the icon theme object. When looking for an icon theme, GTK+ will search for a subdirectory of one or more of the directories in I<path> with the same name as the icon theme containing an index.theme file. (Themes from multiple of the path elements are combined to allow themes to be extended by adding icons in the user’s home directory.)

In addition if an icon found isn’t found either in the current icon theme or the default icon theme, and an image file with the right name is found directly in one of the elements of I<path>, then that image will be used for the icon name. (This is legacy feature, and new icons should be put into the fallback icon theme, which is called hicolor, rather than directly on the icon path.)

  method set-search-path (  $const gchar *path[], Int() $n_elements )

=item $const gchar *path[]; (array length=n_elements) (element-type filename): array of directories that are searched for icon themes
=item $n_elements; number of elements in I<path>.
=end pod

method set-search-path ( Str $path, Int() $n_elements ) {
  gtk_icon_theme_set_search_path(
    self._get-native-object-no-reffing, $path, $n_elements
  );
}

sub gtk_icon_theme_set_search_path (
  N-GObject $icon_theme, Str $path, gint $n_elements 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_icon_theme_new:
#`{{
=begin pod
=head2 _gtk_icon_theme_new

Creates a new icon theme object. Icon theme objects are used to lookup up an icon by name in a particular icon theme. Usually, you’ll want to use C<get-default()> or C<get-for-screen()> rather than creating a new icon theme object for scratch.

Returns: the newly created B<Gnome::Gtk3::IconTheme> object.

  method _gtk_icon_theme_new ( --> N-GObject )

=end pod
}}

sub _gtk_icon_theme_new (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_icon_theme_new')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals


=comment -----------------------------------------------------------------------
=comment #TS:0:changed:
=head2 changed

Emitted when the current icon theme is switched or GTK+ detects
that a change has occurred in the contents of the current
icon theme.

  method handler (
    Int :$_handler-id,
    N-GObject :$_native-object,
    *%user-options
  )

=item $_handler-id; The handler id which is returned from the registration
=item $_native-object; The native object provided by the caller wrapped in the Raku object which registered the signal.
=item %user-options; A list of named arguments provided at the C<register-signal()> method

=end pod
