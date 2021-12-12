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

=begin comment
  GError *error = NULL;
  B<Gnome::Gtk3::IconTheme> *icon_theme;
  B<Gnome::Gdk3::Pixbuf> *pixbuf;

  icon_theme = C<gtk_icon_theme_get_default()>;
  pixbuf = gtk_icon_theme_load_icon (icon_theme,
                                     "my-icon-name", // icon name
                                     48, // icon size
                                     0,  // flags
                                     &error);
  if (!pixbuf)
    {
      g_warning ("Couldn’t load icon: C<s>", error->message);
      g_error_free (error);
    }
  else
    {
      // Use the pixbuf
      g_object_unref (pixbuf);
    }

=end comment

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
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::Glib::Error;
use Gnome::Glib::List;
use Gnome::GObject::Object;
use Gnome::Cairo::Types;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::IconTheme:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkIconLookupFlags

Used to specify options for C<gtk_icon_theme_lookup_icon()>

=item GTK_ICON_LOOKUP_NO_SVG: Never get SVG icons, even if gdk-pixbuf supports them. Cannot be used together with C<GTK_ICON_LOOKUP_FORCE_SVG>.
=item GTK_ICON_LOOKUP_FORCE_SVG: Get SVG icons, even if gdk-pixbuf doesn’t support them. Cannot be used together with C<GTK_ICON_LOOKUP_NO_SVG>.
=item GTK_ICON_LOOKUP_USE_BUILTIN: When passed to C<gtk_icon_theme_lookup_icon()> includes builtin icons as well as files. For a builtin icon, C<gtk_icon_info_get_filename()> is C<Any> and you need to call C<gtk_icon_info_get_builtin_pixbuf()>.
=item GTK_ICON_LOOKUP_GENERIC_FALLBACK: Try to shorten icon name at '-' characters before looking at inherited themes. This flag is only supported in functions that take a single icon name. For more general fallback, see C<gtk_icon_theme_choose_icon()>. Since 2.12.
=item GTK_ICON_LOOKUP_FORCE_SIZE: Always get the icon scaled to the requested size. Since 2.14.
=item GTK_ICON_LOOKUP_FORCE_REGULAR: Try to always load regular icons, even when symbolic icon names are given. Since 3.14.
=item GTK_ICON_LOOKUP_FORCE_SYMBOLIC: Try to always load symbolic icons, even when regular icon names are given. Since 3.14.
=item GTK_ICON_LOOKUP_DIR_LTR: Try to load a variant of the icon for left-to-right text direction. Since 3.14.
=item GTK_ICON_LOOKUP_DIR_RTL: Try to load a variant of the icon for right-to-left text direction. Since 3.14.


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

#-------------------------------------------------------------------------------
=begin pod
=head2 class N-GtkIconTheme

Acts as a database of information about an icon theme. Normally, you retrieve the icon theme for a particular screen using C<gtk_icon_theme_get_for_screen()> and it will contain information about current icon theme for that screen, but you can also create a new B<Gnome::Gtk3::IconTheme> object and set the icon theme name explicitly using C<gtk_icon_theme_set_custom_theme()>.

=end pod

#TT:0:N-GtkIconTheme:
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

#TT:0::N-GtkIconInfo
class N-GtkIconInfo
  is repr('CPointer')
  is export
  { }
#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 new()

Creates a new icon theme object. Icon theme objects are used to lookup up an icon by name in a particular icon theme. Usually, you’ll want to use C<gtk_icon_theme_get_default()> or C<gtk_icon_theme_get_for_screen()> rather than creating a new icon theme object from scratch.

  multi method new ( )

=head3 new(:default)

Gets the icon theme for the default screen. See C<gtk_icon_theme_get_for_screen()>. This icon theme is associated with the screen and can be used as long as the screen is open. Do not ref or unref it.
  Use of named attribute is enough to select this action.

  multi method new ( Bool :$default )

=head3 new(:screen)

Gets the icon theme object associated with I<$screen>; if this function has not previously been called for the given screen, a new icon theme object will be created and associated with the screen. Icon theme objects are fairly expensive to create, so using this function is usually a better choice than calling than C<gtk_icon_theme_new()> and setting the screen yourself; by using this function a single icon theme object will be shared between users.  Returns: (transfer none): A unique B<Gnome::Gtk3::IconTheme> associated with the given screen. This icon theme is associated with the screen and can be used as long as the screen is open. Do not ref or unref it.

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
        $no .= get-native-object-no-reffing
          if $no.^can('get-native-object-no-reffing');
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

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkIconTheme');

  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_icon_theme_$native-sub"); };
# check for gtk_, gdk_, g_, pango_, cairo_ !!!
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkIconTheme');
  $s = callsame unless ?$s;

  $s;
}


#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_error_quark:
=begin pod
=head2 [[gtk_] icon_theme_] error_quark

  method gtk_icon_theme_error_quark ( --> Int )

=end pod

sub gtk_icon_theme_error_quark ( --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_icon_theme_new:
#`{{
=begin pod
=head2 [gtk_] icon_theme_new

Creates a new icon theme object. Icon theme objects are used to lookup up an icon by name in a particular icon theme. Usually, you’ll want to use C<gtk_icon_theme_get_default()> or C<gtk_icon_theme_get_for_screen()> rather than creating a new icon theme object for scratch.  Returns: the newly created B<Gnome::Gtk3::IconTheme> object.

  method gtk_icon_theme_new ( --> N-GObject )


=end pod
}}

sub _gtk_icon_theme_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_icon_theme_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_icon_theme_get_default:
#`{{
=begin pod
=head2 [[gtk_] icon_theme_] get_default

Gets the icon theme for the default screen. See C<gtk_icon_theme_get_for_screen()>.  Returns: (transfer none): A unique B<Gnome::Gtk3::IconTheme> associated with the default screen. This icon theme is associated with the screen and can be used as long as the screen is open. Do not ref or unref it.

  method gtk_icon_theme_get_default ( --> N-GObject )


=end pod
}}
sub _gtk_icon_theme_get_default (  --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_icon_theme_get_default')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_icon_theme_get_for_screen:
#`{{
=begin pod
=head2 [[gtk_] icon_theme_] get_for_screen

Gets the icon theme object associated with I<screen>; if this function has not previously been called for the given screen, a new icon theme object will be created and associated with the screen. Icon theme objects are fairly expensive to create, so using this function is usually a better choice than calling than C<gtk_icon_theme_new()> and setting the screen yourself; by using this function a single icon theme object will be shared between users.  Returns: (transfer none): A unique B<Gnome::Gtk3::IconTheme> associated with the given screen. This icon theme is associated with the screen and can be used as long as the screen is open. Do not ref or unref it.

  method gtk_icon_theme_get_for_screen ( N-GObject $screen --> N-GObject )

=item N-GObject $screen; a B<Gnome::Gdk3::Screen>

=end pod
}}
sub _gtk_icon_theme_get_for_screen ( N-GObject $screen --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_icon_theme_get_for_screen')
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_set_screen:
=begin pod
=head2 [[gtk_] icon_theme_] set_screen

Sets the screen for an icon theme; the screen is used to track the user’s currently configured icon theme, which might be different for different screens.

  method gtk_icon_theme_set_screen ( N-GObject $screen )

=item N-GObject $screen; a B<Gnome::Gdk3::Screen>

=end pod

sub gtk_icon_theme_set_screen ( N-GObject $icon_theme, N-GObject $screen  )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_set_search_path:
=begin pod
=head2 [[gtk_] icon_theme_] set_search_path

Sets the search path for the icon theme object. When looking for an icon theme, GTK+ will search for a subdirectory of one or more of the directories in I<path> with the same name as the icon theme containing an index.theme file. (Themes from multiple of the path elements are combined to allow themes to be extended by adding icons in the user’s home directory.)  In addition if an icon found isn’t found either in the current icon theme or the default icon theme, and an image file with the right name is found directly in one of the elements of I<path>, then that image will be used for the icon name. (This is legacy feature, and new icons should be put into the fallback icon theme, which is called hicolor, rather than directly on the icon path.)

  method gtk_icon_theme_set_search_path (
    $const gchar *path[], Int $n_elements
  )

=item  $const gchar *path[]; (array length=n_elements) (element-type filename): array of directories that are searched for icon themes
=item Int $n_elements; number of elements in I<path>.

=end pod

sub gtk_icon_theme_set_search_path ( N-GObject $icon_theme,  $const gchar *path[], int32 $n_elements  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_get_search_path:
=begin pod
=head2 [[gtk_] icon_theme_] get_search_path

Gets the current search path. See C<gtk_icon_theme_set_search_path()>.

  method gtk_icon_theme_get_search_path (  $gchar **path[], Int $n_elements )

=item  $gchar **path[]; (allow-none) (array length=n_elements) (element-type filename) (out): location to store a list of icon theme path directories or C<Any>. The stored value should be freed with C<g_strfreev()>.
=item Int $n_elements; location to store number of elements in I<path>, or C<Any>

=end pod

sub gtk_icon_theme_get_search_path ( N-GObject $icon_theme,  $gchar **path[], int32 $n_elements  )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_append_search_path:
=begin pod
=head2 [[gtk_] icon_theme_] append_search_path

Appends a directory to the search path.  See C<gtk_icon_theme_set_search_path()>.

  method gtk_icon_theme_append_search_path ( Str $path )

=item Str $path; (type filename): directory name to append to the icon path

=end pod

sub gtk_icon_theme_append_search_path ( N-GObject $icon_theme, Str $path  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_prepend_search_path:
=begin pod
=head2 [[gtk_] icon_theme_] prepend_search_path

Prepends a directory to the search path.  See C<gtk_icon_theme_set_search_path()>.

  method gtk_icon_theme_prepend_search_path ( Str $path )

=item Str $path; (type filename): directory name to prepend to the icon path

=end pod

sub gtk_icon_theme_prepend_search_path ( N-GObject $icon_theme, Str $path  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_add_resource_path:
=begin pod
=head2 [[gtk_] icon_theme_] add_resource_path

Adds a resource path that will be looked at when looking for icons, similar to search paths.  This function should be used to make application-specific icons available as part of the icon theme.  The resources are considered as part of the hicolor icon theme and must be located in subdirectories that are defined in the hicolor icon theme, such as `I<path>/16x16/actions/run.png`. Icons that are directly placed in the resource path instead of a subdirectory are also considered as ultimate fallback.

  method gtk_icon_theme_add_resource_path ( Str $path )

=item Str $path; a resource path

=end pod

sub gtk_icon_theme_add_resource_path ( N-GObject $icon_theme, Str $path  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_set_custom_theme:
=begin pod
=head2 [[gtk_] icon_theme_] set_custom_theme

Sets the name of the icon theme that the B<Gnome::Gtk3::IconTheme> object uses overriding system configuration. This function cannot be called on the icon theme objects returned from C<gtk_icon_theme_get_default()> and C<gtk_icon_theme_get_for_screen()>.

  method gtk_icon_theme_set_custom_theme ( Str $theme_name )

=item Str $theme_name; (allow-none): name of icon theme to use instead of configured theme, or C<Any> to unset a previously set custom theme

=end pod

sub gtk_icon_theme_set_custom_theme ( N-GObject $icon_theme, Str $theme_name  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_has_icon:
=begin pod
=head2 [[gtk_] icon_theme_] has_icon

Checks whether an icon theme includes an icon for a particular name.  Returns: C<1> if I<icon_theme> includes an icon for I<icon_name>.

  method gtk_icon_theme_has_icon ( Str $icon_name --> Int )

=item Str $icon_name; the name of an icon

=end pod

sub gtk_icon_theme_has_icon ( N-GObject $icon_theme, Str $icon_name --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_get_icon_sizes:
=begin pod
=head2 [[gtk_] icon_theme_] get_icon_sizes

Returns an array of integers describing the sizes at which the icon is available without scaling. A size of -1 means  that the icon is available in a scalable format. The array  is zero-terminated.  Returns: (array zero-terminated=1) (transfer full): An newly allocated array describing the sizes at which the icon is available. The array should be freed with C<g_free()> when it is no longer needed.

  method gtk_icon_theme_get_icon_sizes ( Str $icon_name --> Int )

=item Str $icon_name; the name of an icon

=end pod

sub gtk_icon_theme_get_icon_sizes ( N-GObject $icon_theme, Str $icon_name --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_lookup_icon:
=begin pod
=head2 [[gtk_] icon_theme_] lookup_icon

Looks up a named icon and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using C<gtk_icon_info_load_icon()>. (C<gtk_icon_theme_load_icon()> combines these two steps if all you need is the pixbuf.)  When rendering on displays with high pixel densities you should not use a I<size> multiplied by the scaling factor returned by functions like C<gdk_window_get_scale_factor()>. Instead, you should use C<gtk_icon_theme_lookup_icon_for_scale()>, as the assets loaded for a given scaling factor may be different.  Returns: (nullable) (transfer full): a B<Gnome::Gtk3::IconInfo> object containing information about the icon, or C<Any> if the icon wasn’t found.

  method gtk_icon_theme_lookup_icon ( Str $icon_name, Int $size, GtkIconLookupFlags $flags --> N-GtkIconInfo )

=item Str $icon_name; the name of the icon to lookup
=item Int $size; desired icon size
=item GtkIconLookupFlags $flags; flags modifying the behavior of the icon lookup

=end pod

sub gtk_icon_theme_lookup_icon ( N-GObject $icon_theme, Str $icon_name, int32 $size, int32 $flags --> N-GtkIconInfo )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_lookup_icon_for_scale:
=begin pod
=head2 [[gtk_] icon_theme_] lookup_icon_for_scale

Looks up a named icon for a particular window scale and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using C<gtk_icon_info_load_icon()>. (C<gtk_icon_theme_load_icon()> combines these two steps if all you need is the pixbuf.)  Returns: (nullable) (transfer full): a B<Gnome::Gtk3::IconInfo> object containing information about the icon, or C<Any> if the icon wasn’t found.

  method gtk_icon_theme_lookup_icon_for_scale ( Str $icon_name, Int $size, Int $scale, GtkIconLookupFlags $flags --> N-GtkIconInfo )

=item Str $icon_name; the name of the icon to lookup
=item Int $size; desired icon size
=item Int $scale; the desired scale
=item GtkIconLookupFlags $flags; flags modifying the behavior of the icon lookup

=end pod

sub gtk_icon_theme_lookup_icon_for_scale ( N-GObject $icon_theme, Str $icon_name, int32 $size, int32 $scale, int32 $flags --> N-GtkIconInfo )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_choose_icon:
=begin pod
=head2 [[gtk_] icon_theme_] choose_icon

Looks up a named icon and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using C<gtk_icon_info_load_icon()>. (C<gtk_icon_theme_load_icon()> combines these two steps if all you need is the pixbuf.)  If I<icon_names> contains more than one name, this function  tries them all in the given order before falling back to  inherited icon themes.  Returns: (nullable) (transfer full): a B<Gnome::Gtk3::IconInfo> object containing information about the icon, or C<Any> if the icon wasn’t found.

  method gtk_icon_theme_choose_icon (  $const gchar *icon_names[], Int $size, GtkIconLookupFlags $flags --> N-GtkIconInfo )

=item  $const gchar *icon_names[]; (array zero-terminated=1): C<Any>-terminated array of icon names to lookup
=item Int $size; desired icon size
=item GtkIconLookupFlags $flags; flags modifying the behavior of the icon lookup

=end pod

sub gtk_icon_theme_choose_icon ( N-GObject $icon_theme,  $const gchar *icon_names[], int32 $size, int32 $flags --> N-GtkIconInfo )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_choose_icon_for_scale:
=begin pod
=head2 [[gtk_] icon_theme_] choose_icon_for_scale

Looks up a named icon for a particular window scale and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using C<gtk_icon_info_load_icon()>. (C<gtk_icon_theme_load_icon()> combines these two steps if all you need is the pixbuf.)  If I<icon_names> contains more than one name, this function  tries them all in the given order before falling back to  inherited icon themes.  Returns: (nullable) (transfer full): a B<Gnome::Gtk3::IconInfo> object containing information about the icon, or C<Any> if the icon wasn’t found.

  method gtk_icon_theme_choose_icon_for_scale (  $const gchar *icon_names[], Int $size, Int $scale, GtkIconLookupFlags $flags --> N-GtkIconInfo )

=item  $const gchar *icon_names[]; (array zero-terminated=1): C<Any>-terminated array of icon names to lookup
=item Int $size; desired icon size
=item Int $scale; desired scale
=item GtkIconLookupFlags $flags; flags modifying the behavior of the icon lookup

=end pod

sub gtk_icon_theme_choose_icon_for_scale ( N-GObject $icon_theme,  $const gchar *icon_names[], int32 $size, int32 $scale, int32 $flags --> N-GtkIconInfo )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_load_icon:
=begin pod
=head2 [[gtk_] icon_theme_] load_icon

Looks up an icon in an icon theme, scales it to the given size and renders it into a pixbuf. This is a convenience function; if more details about the icon are needed, use C<gtk_icon_theme_lookup_icon()> followed by C<gtk_icon_info_load_icon()>.  Note that you probably want to listen for icon theme changes and update the icon. This is usually done by connecting to the B<Gnome::Gtk3::Widget>::style-set signal. If for some reason you do not want to update the icon when the icon theme changes, you should consider using C<gdk_pixbuf_copy()> to make a private copy of the pixbuf returned by this function. Otherwise GTK+ may need to keep the old icon theme loaded, which would be a waste of memory.  Returns: (nullable) (transfer full): the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<g_object_unref()> to release your reference to the icon. C<Any> if the icon isn’t found.

  method gtk_icon_theme_load_icon ( Str $icon_name, Int $size, GtkIconLookupFlags $flags, N-GError $error --> N-GObject )

=item Str $icon_name; the name of the icon to lookup
=item Int $size; the desired icon size. The resulting icon may not be exactly this size; see C<gtk_icon_info_load_icon()>.
=item GtkIconLookupFlags $flags; flags modifying the behavior of the icon lookup
=item N-GError $error; (allow-none): Location to store error information on failure, or C<Any>.

=end pod

sub gtk_icon_theme_load_icon ( N-GObject $icon_theme, Str $icon_name, int32 $size, int32 $flags, N-GError $error --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_load_icon_for_scale:
=begin pod
=head2 [[gtk_] icon_theme_] load_icon_for_scale

Looks up an icon in an icon theme for a particular window scale, scales it to the given size and renders it into a pixbuf. This is a convenience function; if more details about the icon are needed, use C<gtk_icon_theme_lookup_icon()> followed by C<gtk_icon_info_load_icon()>.  Note that you probably want to listen for icon theme changes and update the icon. This is usually done by connecting to the B<Gnome::Gtk3::Widget>::style-set signal. If for some reason you do not want to update the icon when the icon theme changes, you should consider using C<gdk_pixbuf_copy()> to make a private copy of the pixbuf returned by this function. Otherwise GTK+ may need to keep the old icon theme loaded, which would be a waste of memory.  Returns: (nullable) (transfer full): the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<g_object_unref()> to release your reference to the icon. C<Any> if the icon isn’t found.

  method gtk_icon_theme_load_icon_for_scale ( Str $icon_name, Int $size, Int $scale, GtkIconLookupFlags $flags, N-GError $error --> N-GObject )

=item Str $icon_name; the name of the icon to lookup
=item Int $size; the desired icon size. The resulting icon may not be exactly this size; see C<gtk_icon_info_load_icon()>.
=item Int $scale; desired scale
=item GtkIconLookupFlags $flags; flags modifying the behavior of the icon lookup
=item N-GError $error; (allow-none): Location to store error information on failure, or C<Any>.

=end pod

sub gtk_icon_theme_load_icon_for_scale ( N-GObject $icon_theme, Str $icon_name, int32 $size, int32 $scale, int32 $flags, N-GError $error --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_load_surface:
=begin pod
=head2 [[gtk_] icon_theme_] load_surface

Looks up an icon in an icon theme for a particular window scale, scales it to the given size and renders it into a cairo surface. This is a convenience function; if more details about the icon are needed, use C<gtk_icon_theme_lookup_icon()> followed by C<gtk_icon_info_load_surface()>.  Note that you probably want to listen for icon theme changes and update the icon. This is usually done by connecting to the B<Gnome::Gtk3::Widget>::style-set signal.  Returns: (nullable) (transfer full): the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<cairo_surface_destroy()> to release your reference to the icon. C<Any> if the icon isn’t found.

  method gtk_icon_theme_load_surface ( Str $icon_name, Int $size, Int $scale, N-GObject $for_window, GtkIconLookupFlags $flags, N-GError $error --> cairo_surface_t )

=item Str $icon_name; the name of the icon to lookup
=item Int $size; the desired icon size. The resulting icon may not be exactly this size; see C<gtk_icon_info_load_icon()>.
=item Int $scale; desired scale
=item N-GObject $for_window; (allow-none): B<Gnome::Gdk3::Window> to optimize drawing for, or C<Any>
=item GtkIconLookupFlags $flags; flags modifying the behavior of the icon lookup
=item N-GError $error; (allow-none): Location to store error information on failure, or C<Any>.

=end pod

sub gtk_icon_theme_load_surface ( N-GObject $icon_theme, Str $icon_name, int32 $size, int32 $scale, N-GObject $for_window, int32 $flags, N-GError $error --> cairo_surface_t )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_lookup_by_gicon:
=begin pod
=head2 [[gtk_] icon_theme_] lookup_by_gicon

Looks up an icon and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using C<gtk_icon_info_load_icon()>.  When rendering on displays with high pixel densities you should not use a I<size> multiplied by the scaling factor returned by functions like C<gdk_window_get_scale_factor()>. Instead, you should use C<gtk_icon_theme_lookup_by_gicon_for_scale()>, as the assets loaded for a given scaling factor may be different.  Returns: (nullable) (transfer full): a B<Gnome::Gtk3::IconInfo> containing information about the icon, or C<Any> if the icon wasn’t found. Unref with C<g_object_unref()>

  method gtk_icon_theme_lookup_by_gicon ( GIcon $icon, Int $size, GtkIconLookupFlags $flags --> N-GtkIconInfo )

=item GIcon $icon; the B<GIcon> to look up
=item Int $size; desired icon size
=item GtkIconLookupFlags $flags; flags modifying the behavior of the icon lookup

=end pod

sub gtk_icon_theme_lookup_by_gicon ( N-GObject $icon_theme, GIcon $icon, int32 $size, int32 $flags --> N-GtkIconInfo )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_lookup_by_gicon_for_scale:
=begin pod
=head2 [[gtk_] icon_theme_] lookup_by_gicon_for_scale

Looks up an icon and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using C<gtk_icon_info_load_icon()>.  Returns: (nullable) (transfer full): a B<Gnome::Gtk3::IconInfo> containing information about the icon, or C<Any> if the icon wasn’t found. Unref with C<g_object_unref()>

  method gtk_icon_theme_lookup_by_gicon_for_scale ( GIcon $icon, Int $size, Int $scale, GtkIconLookupFlags $flags --> N-GtkIconInfo )

=item GIcon $icon; the B<GIcon> to look up
=item Int $size; desired icon size
=item Int $scale; the desired scale
=item GtkIconLookupFlags $flags; flags modifying the behavior of the icon lookup

=end pod

sub gtk_icon_theme_lookup_by_gicon_for_scale ( N-GObject $icon_theme, GIcon $icon, int32 $size, int32 $scale, int32 $flags --> N-GtkIconInfo )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_icon_theme_list_icons:
=begin pod
=head2 [[gtk_] icon_theme_] list_icons

Lists the icons in the current icon theme. Only a subset of the icons can be listed by providing a context string. The set of values for the context string is system dependent, but will typically include such values as “Applications” and “MimeTypes”. Contexts are explained in the [Icon Theme Specification](http://www.freedesktop.org/wiki/Specifications/icon-theme-spec). The standard contexts are listed in the [Icon Naming Specification](http://www.freedesktop.org/wiki/Specifications/icon-naming-spec). Also see C<gtk_icon_theme_list_contexts()>.

Returns: a B<GList> list holding the names of all the icons in the theme. You must first free each element in the list with C<g_free()>, then free the list itself with C<g_list_free()>.

  method gtk_icon_theme_list_icons ( Str $context --> N-GList )

=item Str $context; (allow-none): a string identifying a particular type of icon, or C<Any> to list all icons.

=end pod

sub gtk_icon_theme_list_icons ( N-GObject $icon_theme, Str $context --> N-GList )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_icon_theme_list_contexts:
=begin pod
=head2 [[gtk_] icon_theme_] list_contexts

Gets the list of contexts available within the current hierarchy of icon themes. See C<gtk_icon_theme_list_icons()> for details about contexts.

Returns: a B<GList> list holding the names of all the contexts in the theme. You must first free each element in the list with C<g_free()>, then free the list itself with C<g_list_free()>.

  method gtk_icon_theme_list_contexts ( --> N-GList )


=end pod

sub gtk_icon_theme_list_contexts ( N-GObject $icon_theme --> N-GList )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_icon_theme_get_example_icon_name:
=begin pod
=head2 [[gtk_] icon_theme_] get_example_icon_name

Gets the name of an icon that is representative of the current theme (for instance, to use when presenting a list of themes to the user.)

Returns: the name of an example icon or C<Any>. Free with C<g_free()>.

  method gtk_icon_theme_get_example_icon_name ( --> Str )


=end pod

sub gtk_icon_theme_get_example_icon_name ( N-GObject $icon_theme --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_theme_rescan_if_needed:
=begin pod
=head2 [[gtk_] icon_theme_] rescan_if_needed

Checks to see if the icon theme has changed; if it has, any currently cached information is discarded and will be reloaded next time I<icon_theme> is accessed.  Returns: C<1> if the icon theme has changed and needed to be reloaded.

  method gtk_icon_theme_rescan_if_needed ( --> Int )


=end pod

sub gtk_icon_theme_rescan_if_needed ( N-GObject $icon_theme --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_new_for_pixbuf:
=begin pod
=head2 [gtk_] icon_info_new_for_pixbuf

Creates a B<Gnome::Gtk3::IconInfo> for a B<Gnome::Gdk3::Pixbuf>.  Returns: (transfer full): a B<Gnome::Gtk3::IconInfo>

  method gtk_icon_info_new_for_pixbuf ( N-GObject $pixbuf --> N-GtkIconInfo )

=item N-GObject $pixbuf; the pixbuf to wrap in a B<Gnome::Gtk3::IconInfo>

=end pod

sub gtk_icon_info_new_for_pixbuf ( N-GObject $icon_theme, N-GObject $pixbuf --> N-GtkIconInfo )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_get_base_size:
=begin pod
=head2 [gtk_] icon_info_get_base_size

Gets the base size for the icon. The base size is a size for the icon that was specified by the icon theme creator. This may be different than the actual size of image; an example of this is small emblem icons that can be attached to a larger icon. These icons will be given the same base size as the larger icons to which they are attached.  Note that for scaled icons the base size does not include the base scale.  Returns: the base size, or 0, if no base size is known for the icon.

  method gtk_icon_info_get_base_size ( N-GtkIconInfo $icon_info --> Int )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo>

=end pod

sub gtk_icon_info_get_base_size ( N-GtkIconInfo $icon_info --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_get_base_scale:
=begin pod
=head2 [gtk_] icon_info_get_base_scale

Gets the base scale for the icon. The base scale is a scale for the icon that was specified by the icon theme creator. For instance an icon drawn for a high-dpi screen with window scale 2 for a base size of 32 will be 64 pixels tall and have a base scale of 2.  Returns: the base scale

  method gtk_icon_info_get_base_scale ( N-GtkIconInfo $icon_info --> Int )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo>

=end pod

sub gtk_icon_info_get_base_scale ( N-GtkIconInfo $icon_info --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_get_filename:
=begin pod
=head2 [gtk_] icon_info_get_filename

Gets the filename for the icon. If the C<GTK_ICON_LOOKUP_USE_BUILTIN> flag was passed to C<gtk_icon_theme_lookup_icon()>, there may be no filename if a builtin icon is returned; in this case, you should use C<gtk_icon_info_get_builtin_pixbuf()>.  Returns: (nullable) (type filename): the filename for the icon, or C<Any> if C<gtk_icon_info_get_builtin_pixbuf()> should be used instead. The return value is owned by GTK+ and should not be modified or freed.

  method gtk_icon_info_get_filename ( N-GtkIconInfo $icon_info --> Str )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo>

=end pod

sub gtk_icon_info_get_filename ( N-GtkIconInfo $icon_info --> Str )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_is_symbolic:
=begin pod
=head2 [gtk_] icon_info_is_symbolic

Checks if the icon is symbolic or not. This currently uses only the file name and not the file contents for determining this. This behaviour may change in the future.  Returns: C<1> if the icon is symbolic, C<0> otherwise

  method gtk_icon_info_is_symbolic ( N-GtkIconInfo $icon_info --> Int )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo>

=end pod

sub gtk_icon_info_is_symbolic ( N-GtkIconInfo $icon_info --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_load_icon:
=begin pod
=head2 [gtk_] icon_info_load_icon

Renders an icon previously looked up in an icon theme using C<gtk_icon_theme_lookup_icon()>; the size will be based on the size passed to C<gtk_icon_theme_lookup_icon()>. Note that the resulting pixbuf may not be exactly this size; an icon theme may have icons that differ slightly from their nominal sizes, and in addition GTK+ will avoid scaling icons that it considers sufficiently close to the requested size or for which the source image would have to be scaled up too far. (This maintains sharpness.). This behaviour can be changed by passing the C<GTK_ICON_LOOKUP_FORCE_SIZE> flag when obtaining the B<Gnome::Gtk3::IconInfo>. If this flag has been specified, the pixbuf returned by this function will be scaled to the exact size.  Returns: (transfer full): the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<g_object_unref()> to release your reference to the icon.

  method gtk_icon_info_load_icon ( N-GtkIconInfo $icon_info, N-GError $error --> N-GObject )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo> from C<gtk_icon_theme_lookup_icon()>
=item N-GError $error; (allow-none): location to store error information on failure, or C<Any>.

=end pod

sub gtk_icon_info_load_icon ( N-GtkIconInfo $icon_info, N-GError $error --> N-GObject )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_load_surface:
=begin pod
=head2 [gtk_] icon_info_load_surface

Renders an icon previously looked up in an icon theme using C<gtk_icon_theme_lookup_icon()>; the size will be based on the size passed to C<gtk_icon_theme_lookup_icon()>. Note that the resulting surface may not be exactly this size; an icon theme may have icons that differ slightly from their nominal sizes, and in addition GTK+ will avoid scaling icons that it considers sufficiently close to the requested size or for which the source image would have to be scaled up too far. (This maintains sharpness.). This behaviour can be changed by passing the C<GTK_ICON_LOOKUP_FORCE_SIZE> flag when obtaining the B<Gnome::Gtk3::IconInfo>. If this flag has been specified, the pixbuf returned by this function will be scaled to the exact size.  Returns: (transfer full): the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<cairo_surface_destroy()> to release your reference to the icon.

  method gtk_icon_info_load_surface ( N-GtkIconInfo $icon_info, N-GObject $for_window, N-GError $error --> cairo_surface_t )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo> from C<gtk_icon_theme_lookup_icon()>
=item N-GObject $for_window; (allow-none): B<Gnome::Gdk3::Window> to optimize drawing for, or C<Any>
=item N-GError $error; (allow-none): location for error information on failure, or C<Any>

=end pod

sub gtk_icon_info_load_surface ( N-GtkIconInfo $icon_info, N-GObject $for_window, N-GError $error --> cairo_surface_t )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_load_icon_async:
=begin pod
=head2 [gtk_] icon_info_load_icon_async

Asynchronously load, render and scale an icon previously looked up from the icon theme using C<gtk_icon_theme_lookup_icon()>.  For more details, see C<gtk_icon_info_load_icon()> which is the synchronous version of this call.

  method gtk_icon_info_load_icon_async ( N-GtkIconInfo $icon_info, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo> from C<gtk_icon_theme_lookup_icon()>
=item GCancellable $cancellable; (allow-none): optional B<GCancellable> object, C<Any> to ignore
=item GAsyncReadyCallback $callback; (scope async): a B<GAsyncReadyCallback> to call when the request is satisfied
=item Pointer $user_data; (closure): the data to pass to callback function

=end pod

sub gtk_icon_info_load_icon_async ( N-GtkIconInfo $icon_info, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_load_icon_finish:
=begin pod
=head2 [gtk_] icon_info_load_icon_finish

Finishes an async icon load, see C<gtk_icon_info_load_icon_async()>.  Returns: (transfer full): the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<g_object_unref()> to release your reference to the icon.

  method gtk_icon_info_load_icon_finish ( N-GtkIconInfo $icon_info, GAsyncResult $res, N-GError $error --> N-GObject )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo> from C<gtk_icon_theme_lookup_icon()>
=item GAsyncResult $res; a B<GAsyncResult>
=item N-GError $error; (allow-none): location to store error information on failure, or C<Any>.

=end pod

sub gtk_icon_info_load_icon_finish ( N-GtkIconInfo $icon_info, GAsyncResult $res, N-GError $error --> N-GObject )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_load_symbolic:
=begin pod
=head2 [gtk_] icon_info_load_symbolic

Loads an icon, modifying it to match the system colours for the foreground, success, warning and error colors provided. If the icon is not a symbolic one, the function will return the result from C<gtk_icon_info_load_icon()>.  This allows loading symbolic icons that will match the system theme.  Unless you are implementing a widget, you will want to use C<g_themed_icon_new_with_default_fallbacks()> to load the icon.  As implementation details, the icon loaded needs to be of SVG type, contain the “symbolic” term as the last component of the icon name, and use the “fg”, “success”, “warning” and “error” CSS styles in the SVG file itself.  See the [Symbolic Icons Specification](http://www.freedesktop.org/wiki/SymbolicIcons) for more information about symbolic icons.  Returns: (transfer full): a B<Gnome::Gdk3::Pixbuf> representing the loaded icon

  method gtk_icon_info_load_symbolic ( N-GtkIconInfo $icon_info, N-GObject $fg, N-GObject $success_color, N-GObject $warning_color, N-GObject $error_color, Int $was_symbolic, N-GError $error --> N-GObject )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo>
=item N-GObject $fg; a B<Gnome::Gdk3::RGBA> representing the foreground color of the icon
=item N-GObject $success_color; (allow-none): a B<Gnome::Gdk3::RGBA> representing the warning color of the icon or C<Any> to use the default color
=item N-GObject $warning_color; (allow-none): a B<Gnome::Gdk3::RGBA> representing the warning color of the icon or C<Any> to use the default color
=item N-GObject $error_color; (allow-none): a B<Gnome::Gdk3::RGBA> representing the error color of the icon or C<Any> to use the default color (allow-none)
=item Int $was_symbolic; (out) (allow-none): a B<gboolean>, returns whether the loaded icon was a symbolic one and whether the I<fg> color was applied to it.
=item N-GError $error; (allow-none): location to store error information on failure, or C<Any>.

=end pod

sub gtk_icon_info_load_symbolic ( N-GtkIconInfo $icon_info, N-GObject $fg, N-GObject $success_color, N-GObject $warning_color, N-GObject $error_color, int32 $was_symbolic, N-GError $error --> N-GObject )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_load_symbolic_async:
=begin pod
=head2 [gtk_] icon_info_load_symbolic_async

Asynchronously load, render and scale a symbolic icon previously looked up from the icon theme using C<gtk_icon_theme_lookup_icon()>.  For more details, see C<gtk_icon_info_load_symbolic()> which is the synchronous version of this call.

  method gtk_icon_info_load_symbolic_async ( N-GtkIconInfo $icon_info, N-GObject $fg, N-GObject $success_color, N-GObject $warning_color, N-GObject $error_color, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo> from C<gtk_icon_theme_lookup_icon()>
=item N-GObject $fg; a B<Gnome::Gdk3::RGBA> representing the foreground color of the icon
=item N-GObject $success_color; (allow-none): a B<Gnome::Gdk3::RGBA> representing the warning color of the icon or C<Any> to use the default color
=item N-GObject $warning_color; (allow-none): a B<Gnome::Gdk3::RGBA> representing the warning color of the icon or C<Any> to use the default color
=item N-GObject $error_color; (allow-none): a B<Gnome::Gdk3::RGBA> representing the error color of the icon or C<Any> to use the default color (allow-none)
=item GCancellable $cancellable; (allow-none): optional B<GCancellable> object, C<Any> to ignore
=item GAsyncReadyCallback $callback; (scope async): a B<GAsyncReadyCallback> to call when the request is satisfied
=item Pointer $user_data; (closure): the data to pass to callback function

=end pod

sub gtk_icon_info_load_symbolic_async ( N-GtkIconInfo $icon_info, N-GObject $fg, N-GObject $success_color, N-GObject $warning_color, N-GObject $error_color, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_load_symbolic_finish:
=begin pod
=head2 [gtk_] icon_info_load_symbolic_finish

Finishes an async icon load, see C<gtk_icon_info_load_symbolic_async()>.  Returns: (transfer full): the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<g_object_unref()> to release your reference to the icon.

  method gtk_icon_info_load_symbolic_finish ( N-GtkIconInfo $icon_info, GAsyncResult $res, Int $was_symbolic, N-GError $error --> N-GObject )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo> from C<gtk_icon_theme_lookup_icon()>
=item GAsyncResult $res; a B<GAsyncResult>
=item Int $was_symbolic; (out) (allow-none): a B<gboolean>, returns whether the loaded icon was a symbolic one and whether the I<fg> color was applied to it.
=item N-GError $error; (allow-none): location to store error information on failure, or C<Any>.

=end pod

sub gtk_icon_info_load_symbolic_finish ( N-GtkIconInfo $icon_info, GAsyncResult $res, int32 $was_symbolic, N-GError $error --> N-GObject )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_load_symbolic_for_context:
=begin pod
=head2 [gtk_] icon_info_load_symbolic_for_context

Loads an icon, modifying it to match the system colors for the foreground, success, warning and error colors provided. If the icon is not a symbolic one, the function will return the result from C<gtk_icon_info_load_icon()>. This function uses the regular foreground color and the symbolic colors with the names “success_color”, “warning_color” and “error_color” from the context.  This allows loading symbolic icons that will match the system theme.  See C<gtk_icon_info_load_symbolic()> for more details.  Returns: (transfer full): a B<Gnome::Gdk3::Pixbuf> representing the loaded icon

  method gtk_icon_info_load_symbolic_for_context ( N-GtkIconInfo $icon_info, N-GObject $context, Int $was_symbolic, N-GError $error --> N-GObject )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo>
=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item Int $was_symbolic; (out) (allow-none): a B<gboolean>, returns whether the loaded icon was a symbolic one and whether the I<fg> color was applied to it.
=item N-GError $error; (allow-none): location to store error information on failure, or C<Any>.

=end pod

sub gtk_icon_info_load_symbolic_for_context ( N-GtkIconInfo $icon_info, N-GObject $context, int32 $was_symbolic, N-GError $error --> N-GObject )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_load_symbolic_for_context_async:
=begin pod
=head2 [gtk_] icon_info_load_symbolic_for_context_async

Asynchronously load, render and scale a symbolic icon previously looked up from the icon theme using C<gtk_icon_theme_lookup_icon()>.  For more details, see C<gtk_icon_info_load_symbolic_for_context()> which is the synchronous version of this call.

  method gtk_icon_info_load_symbolic_for_context_async ( N-GtkIconInfo $icon_info, N-GObject $context, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo> from C<gtk_icon_theme_lookup_icon()>
=item N-GObject $context; a B<Gnome::Gtk3::StyleContext>
=item GCancellable $cancellable; (allow-none): optional B<GCancellable> object, C<Any> to ignore
=item GAsyncReadyCallback $callback; (scope async): a B<GAsyncReadyCallback> to call when the request is satisfied
=item Pointer $user_data; (closure): the data to pass to callback function

=end pod

sub gtk_icon_info_load_symbolic_for_context_async ( N-GtkIconInfo $icon_info, N-GObject $context, GCancellable $cancellable, GAsyncReadyCallback $callback, Pointer $user_data  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_icon_info_load_symbolic_for_context_finish:
=begin pod
=head2 [gtk_] icon_info_load_symbolic_for_context_finish

Finishes an async icon load, see C<gtk_icon_info_load_symbolic_for_context_async()>.  Returns: (transfer full): the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<g_object_unref()> to release your reference to the icon.

  method gtk_icon_info_load_symbolic_for_context_finish ( N-GtkIconInfo $icon_info, GAsyncResult $res, Int $was_symbolic, N-GError $error --> N-GObject )

=item N-GtkIconInfo $icon_info; a B<Gnome::Gtk3::IconInfo> from C<gtk_icon_theme_lookup_icon()>
=item GAsyncResult $res; a B<GAsyncResult>
=item Int $was_symbolic; (out) (allow-none): a B<gboolean>, returns whether the loaded icon was a symbolic one and whether the I<fg> color was applied to it.
=item N-GError $error; (allow-none): location to store error information on failure, or C<Any>.

=end pod

sub gtk_icon_info_load_symbolic_for_context_finish ( N-GtkIconInfo $icon_info, GAsyncResult $res, int32 $was_symbolic, N-GError $error --> N-GObject )
  is native(&gtk-lib)
  { * }
}}

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


=comment #TS:0:changed:
=head3 changed

Emitted when the current icon theme is switched or GTK+ detects
that a change has occurred in the contents of the current
icon theme.

  method handler (
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($icon_theme),
    *%user-options
  );

=item $icon_theme; the icon theme


=end pod
