#TL:1:Gnome::Gtk3::IconInfo:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::IconInfo

Looking up icons by name


=comment ![](images/X.png)


=head1 Description

B<Gnome::Gtk3::IconInfo> contains information found when looking up an icon in an icon theme.

B<Gnome::Gtk3::IconTheme> provides a facility for looking up icons by name and size. The main reason for using a name rather than simply providing a filename is to allow different icons to be used depending on what “icon theme” is selected by the user. The operation of icon themes on Linux and Unix follows the [Icon Theme Specification](http://www.freedesktop.org/Standards/icon-theme-spec) There is a fallback icon theme, named `hicolor`, where applications should install their icons, but additional icon themes can be installed as operating system vendors and users choose.

In many cases, named themes are used indirectly, via B<Gnome::Gtk3::Image> or stock items, rather than directly, but looking up icons directly is also simple. The B<Gnome::Gtk3::IconTheme> object acts as a database of all the icons in the current theme. You can create new B<Gnome::Gtk3::IconTheme> objects, but it’s much more efficient to use the standard icon theme for the B<Gnome::Gdk3::Screen> so that the icon information is shared with other people looking up icons.


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::IconInfo;
 


=comment head2 Uml Diagram

=comment ![](plantuml/IconInfo.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::IconInfo;

  unit class MyGuiClass;
  also is Gnome::Gtk3::IconInfo;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::IconInfo class process the options
    self.bless( :GtkIconInfo, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment


=head2 Example

To get information from a theme, do the following;

  my Gnome::Gtk3::IconTheme $icon-theme .= new(:default);
  my Gnome::Gtk3::IconInfo $ii = $icon-theme.lookup-icon('server-database');
  say $ii.get-base-scale;


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;


#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::IconInfo:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new IconInfo object.

  multi method new ( )


=head3 :native-object

Create a IconInfo object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )


=head3 :build-id

Create a IconInfo object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {



  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::IconInfo' #`{{ or %options<GtkIconInfo> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my N-GObject() $no;
      if ? %options<___x___> {
        #$no = %options<___x___>;
        #$no .= _get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_icon_info_new___x___($no);
      }

      #`{{ use this when the module is not made inheritable
      # check if there are unknown options
      elsif %options.elems {
        die X::Gnome.new(
          :message(
            'Unsupported, undefined, incomplete or wrongly typed options for ' ~
            self.^name ~ ': ' ~ %options.keys.join(', ')
          )
        );
      }
      }}

      #`{{ when there are no defaults use this
      # check if there are any options
      elsif %options.elems == 0 {
        die X::Gnome.new(:message('No options specified ' ~ self.^name));
      }
      }}

      #`{{ when there are defaults use this instead
      # create default object
      else {
        $no = _gtk_icon_info_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkIconInfo');
  }
}


#-------------------------------------------------------------------------------
#TM:0:get-base-scale:
=begin pod
=head2 get-base-scale

Gets the base scale for the icon. The base scale is a scale for the icon that was specified by the icon theme creator. For instance an icon drawn for a high-dpi screen with window scale 2 for a base size of 32 will be 64 pixels tall and have a base scale of 2.

Returns: the base scale

  method get-base-scale ( --> Int )

=end pod

method get-base-scale ( --> Int ) {
  gtk_icon_info_get_base_scale( self._get-native-object-no-reffing)
}

sub gtk_icon_info_get_base_scale (
  GtkIconInfo $icon_info --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-base-size:
=begin pod
=head2 get-base-size

Gets the base size for the icon. The base size is a size for the icon that was specified by the icon theme creator. This may be different than the actual size of image; an example of this is small emblem icons that can be attached to a larger icon. These icons will be given the same base size as the larger icons to which they are attached.

Note that for scaled icons the base size does not include the base scale.

Returns: the base size, or 0, if no base size is known for the icon.

  method get-base-size ( --> Int )

=end pod

method get-base-size ( --> Int ) {
  gtk_icon_info_get_base_size( self._get-native-object-no-reffing)
}

sub gtk_icon_info_get_base_size (
  GtkIconInfo $icon_info --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-filename:
=begin pod
=head2 get-filename

Gets the filename for the icon. If the C<GTK_ICON_LOOKUP_USE_BUILTIN> flag was passed to gtk_icon_theme_lookup_icon(), there may be no filename if a builtin icon is returned; in this case, you should use C<Gnome::Gtk3::IconInfo.get-builtin-pixbuf()>.

Returns:  (type filename): the filename for the icon, or C<undefined> if C<Gnome::Gtk3::IconInfo.get-builtin-pixbuf()> should be used instead. The return value is owned by GTK+ and should not be modified or freed.

  method get-filename ( --> Str )

=end pod

method get-filename ( --> Str ) {
  gtk_icon_info_get_filename( self._get-native-object-no-reffing)
}

sub gtk_icon_info_get_filename (
  GtkIconInfo $icon_info --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-add-resource-path:
=begin pod
=head2 gtk-icon-theme-add-resource-path

Adds a resource path that will be looked at when looking for icons, similar to search paths.

This function should be used to make application-specific icons available as part of the icon theme.

The resources are considered as part of the hicolor icon theme and must be located in subdirectories that are defined in the hicolor icon theme, such as `I<path>/16x16/actions/run.png`. Icons that are directly placed in the resource path instead of a subdirectory are also considered as ultimate fallback.

  method gtk-icon-theme-add-resource-path ( N-GObject() $icon_theme, Str $path )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $path; a resource path
=end pod

method gtk-icon-theme-add-resource-path ( N-GObject() $icon_theme, Str $path ) {
  gtk_icon_theme_add_resource_path( self._get-native-object-no-reffing, $icon_theme, $path);
}

sub gtk_icon_theme_add_resource_path (
  N-GObject $icon_theme, gchar-ptr $path 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-append-search-path:
=begin pod
=head2 gtk-icon-theme-append-search-path

Appends a directory to the search path. See gtk_icon_theme_set_search_path().

  method gtk-icon-theme-append-search-path ( N-GObject() $icon_theme, Str $path )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $path; (type filename): directory name to append to the icon path
=end pod

method gtk-icon-theme-append-search-path ( N-GObject() $icon_theme, Str $path ) {
  gtk_icon_theme_append_search_path( self._get-native-object-no-reffing, $icon_theme, $path);
}

sub gtk_icon_theme_append_search_path (
  N-GObject $icon_theme, gchar-ptr $path 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-choose-icon:
=begin pod
=head2 gtk-icon-theme-choose-icon

Looks up a named icon and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using gtk_icon_info_load_icon(). (gtk_icon_theme_load_icon() combines these two steps if all you need is the pixbuf.)

If I<icon_names> contains more than one name, this function tries them all in the given order before falling back to inherited icon themes.

Returns: a B<Gnome::Gtk3::IconInfo> object containing information about the icon, or C<undefined> if the icon wasn’t found.

  method gtk-icon-theme-choose-icon ( N-GObject() $icon_theme,  $const gchar *icon_names[], Int() $size, GtkIconLookupFlags $flags --> GtkIconInfo )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $const gchar *icon_names[]; C<undefined>-terminated array of icon names to lookup
=item $size; desired icon size
=item $flags; flags modifying the behavior of the icon lookup
=end pod

method gtk-icon-theme-choose-icon ( N-GObject() $icon_theme,  $const gchar *icon_names[], Int() $size, GtkIconLookupFlags $flags --> GtkIconInfo ) {
  gtk_icon_theme_choose_icon( self._get-native-object-no-reffing, $icon_theme, $const gchar *icon_names[], $size, $flags)
}

sub gtk_icon_theme_choose_icon (
  N-GObject $icon_theme,  $const gchar *icon_names[], gint $size, GEnum $flags --> GtkIconInfo
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-choose-icon-for-scale:
=begin pod
=head2 gtk-icon-theme-choose-icon-for-scale

Looks up a named icon for a particular window scale and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using gtk_icon_info_load_icon(). (gtk_icon_theme_load_icon() combines these two steps if all you need is the pixbuf.)

If I<icon_names> contains more than one name, this function tries them all in the given order before falling back to inherited icon themes.

Returns: a B<Gnome::Gtk3::IconInfo> object containing information about the icon, or C<undefined> if the icon wasn’t found.

  method gtk-icon-theme-choose-icon-for-scale ( N-GObject() $icon_theme,  $const gchar *icon_names[], Int() $size, Int() $scale, GtkIconLookupFlags $flags --> GtkIconInfo )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $const gchar *icon_names[]; C<undefined>-terminated array of icon names to lookup
=item $size; desired icon size
=item $scale; desired scale
=item $flags; flags modifying the behavior of the icon lookup
=end pod

method gtk-icon-theme-choose-icon-for-scale ( N-GObject() $icon_theme,  $const gchar *icon_names[], Int() $size, Int() $scale, GtkIconLookupFlags $flags --> GtkIconInfo ) {
  gtk_icon_theme_choose_icon_for_scale( self._get-native-object-no-reffing, $icon_theme, $const gchar *icon_names[], $size, $scale, $flags)
}

sub gtk_icon_theme_choose_icon_for_scale (
  N-GObject $icon_theme,  $const gchar *icon_names[], gint $size, gint $scale, GEnum $flags --> GtkIconInfo
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-error-quark:
=begin pod
=head2 gtk-icon-theme-error-quark



  method gtk-icon-theme-error-quark ( --> UInt )

=end pod

method gtk-icon-theme-error-quark ( --> UInt ) {
  gtk_icon_theme_error_quark( self._get-native-object-no-reffing)
}

sub gtk_icon_theme_error_quark (
   --> GQuark
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-get-default:
=begin pod
=head2 gtk-icon-theme-get-default

Gets the icon theme for the default screen. See gtk_icon_theme_get_for_screen().

Returns: A unique B<Gnome::Gtk3::IconTheme> associated with the default screen. This icon theme is associated with the screen and can be used as long as the screen is open. Do not ref or unref it.

  method gtk-icon-theme-get-default ( --> N-GObject )

=end pod

method gtk-icon-theme-get-default ( --> N-GObject ) {
  gtk_icon_theme_get_default( self._get-native-object-no-reffing)
}

sub gtk_icon_theme_get_default (
   --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-get-example-icon-name:
=begin pod
=head2 gtk-icon-theme-get-example-icon-name

Gets the name of an icon that is representative of the current theme (for instance, to use when presenting a list of themes to the user.)

Returns: the name of an example icon or C<undefined>. Free with g_free().

  method gtk-icon-theme-get-example-icon-name ( N-GObject() $icon_theme --> Str )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=end pod

method gtk-icon-theme-get-example-icon-name ( N-GObject() $icon_theme --> Str ) {
  gtk_icon_theme_get_example_icon_name( self._get-native-object-no-reffing, $icon_theme)
}

sub gtk_icon_theme_get_example_icon_name (
  N-GObject $icon_theme --> gchar-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-get-for-screen:
=begin pod
=head2 gtk-icon-theme-get-for-screen

Gets the icon theme object associated with I<screen>; if this function has not previously been called for the given screen, a new icon theme object will be created and associated with the screen. Icon theme objects are fairly expensive to create, so using this function is usually a better choice than calling than C<Gnome::Gtk3::IconTheme.new()> and setting the screen yourself; by using this function a single icon theme object will be shared between users.

Returns: A unique B<Gnome::Gtk3::IconTheme> associated with the given screen. This icon theme is associated with the screen and can be used as long as the screen is open. Do not ref or unref it.

  method gtk-icon-theme-get-for-screen ( N-GObject() $screen --> N-GObject )

=item $screen; a B<Gnome::Gdk3::Screen>
=end pod

method gtk-icon-theme-get-for-screen ( N-GObject() $screen --> N-GObject ) {
  gtk_icon_theme_get_for_screen( self._get-native-object-no-reffing, $screen)
}

sub gtk_icon_theme_get_for_screen (
  N-GObject $screen --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-get-icon-sizes:
=begin pod
=head2 gtk-icon-theme-get-icon-sizes

Returns an array of integers describing the sizes at which the icon is available without scaling. A size of -1 means that the icon is available in a scalable format. The array is zero-terminated.

Returns: An newly allocated array describing the sizes at which the icon is available. The array should be freed with C<g-free()> when it is no longer needed.

  method gtk-icon-theme-get-icon-sizes ( N-GObject() $icon_theme, Str $icon_name --> Int-ptr )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $icon_name; the name of an icon
=end pod

method gtk-icon-theme-get-icon-sizes ( N-GObject() $icon_theme, Str $icon_name --> Int-ptr ) {
  gtk_icon_theme_get_icon_sizes( self._get-native-object-no-reffing, $icon_theme, $icon_name)
}

sub gtk_icon_theme_get_icon_sizes (
  N-GObject $icon_theme, gchar-ptr $icon_name --> gint-ptr
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-get-search-path:
=begin pod
=head2 gtk-icon-theme-get-search-path

Gets the current search path. See gtk_icon_theme_set_search_path().

  method gtk-icon-theme-get-search-path ( N-GObject() $icon_theme,  $gchar **path[] )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $gchar **path[];  (array length=n_elements) (element-type filename) : location to store a list of icon theme path directories or C<undefined>. The stored value should be freed with g_strfreev().
=item $n_elements; location to store number of elements in I<path>, or C<undefined>
=end pod

method gtk-icon-theme-get-search-path ( N-GObject() $icon_theme,  $gchar **path[] ) {
  gtk_icon_theme_get_search_path( self._get-native-object-no-reffing, $icon_theme, $gchar **path[], my gint $n_elements);
}

sub gtk_icon_theme_get_search_path (
  N-GObject $icon_theme,  $gchar **path[], gint $n_elements is rw 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-has-icon:
=begin pod
=head2 gtk-icon-theme-has-icon

Checks whether an icon theme includes an icon for a particular name.

Returns: C<True> if I<icon_theme> includes an icon for I<icon_name>.

  method gtk-icon-theme-has-icon ( N-GObject() $icon_theme, Str $icon_name --> Bool )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $icon_name; the name of an icon
=end pod

method gtk-icon-theme-has-icon ( N-GObject() $icon_theme, Str $icon_name --> Bool ) {
  gtk_icon_theme_has_icon( self._get-native-object-no-reffing, $icon_theme, $icon_name).Bool
}

sub gtk_icon_theme_has_icon (
  N-GObject $icon_theme, gchar-ptr $icon_name --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-list-contexts:
=begin pod
=head2 gtk-icon-theme-list-contexts

Gets the list of contexts available within the current hierarchy of icon themes. See C<Gnome::Gtk3::IconTheme.list-icons()> for details about contexts.

Returns: (element-type utf8) : a B<Gnome::Glib::List> list holding the names of all the contexts in the theme. You must first free each element in the list with g_free(), then free the list itself with g_list_free().

  method gtk-icon-theme-list-contexts ( N-GObject() $icon_theme --> N-GList )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=end pod

method gtk-icon-theme-list-contexts ( N-GObject() $icon_theme --> N-GList ) {
  gtk_icon_theme_list_contexts( self._get-native-object-no-reffing, $icon_theme)
}

sub gtk_icon_theme_list_contexts (
  N-GObject $icon_theme --> N-GList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-list-icons:
=begin pod
=head2 gtk-icon-theme-list-icons

Lists the icons in the current icon theme. Only a subset of the icons can be listed by providing a context string. The set of values for the context string is system dependent, but will typically include such values as “Applications” and “MimeTypes”. Contexts are explained in the [Icon Theme Specification](http://www.freedesktop.org/wiki/Specifications/icon-theme-spec). The standard contexts are listed in the [Icon Naming Specification](http://www.freedesktop.org/wiki/Specifications/icon-naming-spec). Also see gtk_icon_theme_list_contexts().

Returns: (element-type utf8) : a B<Gnome::Glib::List> list holding the names of all the icons in the theme. You must first free each element in the list with g_free(), then free the list itself with g_list_free().

  method gtk-icon-theme-list-icons ( N-GObject() $icon_theme, Str $context --> N-GList )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $context; a string identifying a particular type of icon, or C<undefined> to list all icons.
=end pod

method gtk-icon-theme-list-icons ( N-GObject() $icon_theme, Str $context --> N-GList ) {
  gtk_icon_theme_list_icons( self._get-native-object-no-reffing, $icon_theme, $context)
}

sub gtk_icon_theme_list_icons (
  N-GObject $icon_theme, gchar-ptr $context --> N-GList
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-load-icon:
=begin pod
=head2 gtk-icon-theme-load-icon

Looks up an icon in an icon theme, scales it to the given size and renders it into a pixbuf. This is a convenience function; if more details about the icon are needed, use C<Gnome::Gtk3::IconTheme.lookup-icon()> followed by gtk_icon_info_load_icon().

Note that you probably want to listen for icon theme changes and update the icon. This is usually done by connecting to the GtkWidget::style-set signal. If for some reason you do not want to update the icon when the icon theme changes, you should consider using C<Gnome::Gdk3::Pixbuf.copy()> to make a private copy of the pixbuf returned by this function. Otherwise GTK+ may need to keep the old icon theme loaded, which would be a waste of memory.

Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<Gnome::GObject::Object.unref()> to release your reference to the icon. C<undefined> if the icon isn’t found.

  method gtk-icon-theme-load-icon ( N-GObject() $icon_theme, Str $icon_name, Int() $size, GtkIconLookupFlags $flags, N-GError $error --> N-GObject )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $icon_name; the name of the icon to lookup
=item $size; the desired icon size. The resulting icon may not be exactly this size; see gtk_icon_info_load_icon().
=item $flags; flags modifying the behavior of the icon lookup
=item $error; Location to store error information on failure, or C<undefined>.
=end pod

method gtk-icon-theme-load-icon ( N-GObject() $icon_theme, Str $icon_name, Int() $size, GtkIconLookupFlags $flags, $error is copy --> N-GObject ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_icon_theme_load_icon( self._get-native-object-no-reffing, $icon_theme, $icon_name, $size, $flags, $error)
}

sub gtk_icon_theme_load_icon (
  N-GObject $icon_theme, gchar-ptr $icon_name, gint $size, GEnum $flags, N-GError $error --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-load-icon-for-scale:
=begin pod
=head2 gtk-icon-theme-load-icon-for-scale

Looks up an icon in an icon theme for a particular window scale, scales it to the given size and renders it into a pixbuf. This is a convenience function; if more details about the icon are needed, use C<Gnome::Gtk3::IconTheme.lookup-icon()> followed by gtk_icon_info_load_icon().

Note that you probably want to listen for icon theme changes and update the icon. This is usually done by connecting to the GtkWidget::style-set signal. If for some reason you do not want to update the icon when the icon theme changes, you should consider using C<Gnome::Gdk3::Pixbuf.copy()> to make a private copy of the pixbuf returned by this function. Otherwise GTK+ may need to keep the old icon theme loaded, which would be a waste of memory.

Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<Gnome::GObject::Object.unref()> to release your reference to the icon. C<undefined> if the icon isn’t found.

  method gtk-icon-theme-load-icon-for-scale ( N-GObject() $icon_theme, Str $icon_name, Int() $size, Int() $scale, GtkIconLookupFlags $flags, N-GError $error --> N-GObject )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $icon_name; the name of the icon to lookup
=item $size; the desired icon size. The resulting icon may not be exactly this size; see gtk_icon_info_load_icon().
=item $scale; desired scale
=item $flags; flags modifying the behavior of the icon lookup
=item $error; Location to store error information on failure, or C<undefined>.
=end pod

method gtk-icon-theme-load-icon-for-scale ( N-GObject() $icon_theme, Str $icon_name, Int() $size, Int() $scale, GtkIconLookupFlags $flags, $error is copy --> N-GObject ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_icon_theme_load_icon_for_scale( self._get-native-object-no-reffing, $icon_theme, $icon_name, $size, $scale, $flags, $error)
}

sub gtk_icon_theme_load_icon_for_scale (
  N-GObject $icon_theme, gchar-ptr $icon_name, gint $size, gint $scale, GEnum $flags, N-GError $error --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-load-surface:
=begin pod
=head2 gtk-icon-theme-load-surface

Looks up an icon in an icon theme for a particular window scale, scales it to the given size and renders it into a cairo surface. This is a convenience function; if more details about the icon are needed, use C<Gnome::Gtk3::IconTheme.lookup-icon()> followed by gtk_icon_info_load_surface().

Note that you probably want to listen for icon theme changes and update the icon. This is usually done by connecting to the GtkWidget::style-set signal.

Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<Gnome::Cairo::Surface.destroy()> to release your reference to the icon. C<undefined> if the icon isn’t found.

  method gtk-icon-theme-load-surface ( N-GObject() $icon_theme, Str $icon_name, Int() $size, Int() $scale, N-GObject() $for_window, GtkIconLookupFlags $flags, N-GError $error --> cairo_surface_t )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $icon_name; the name of the icon to lookup
=item $size; the desired icon size. The resulting icon may not be exactly this size; see gtk_icon_info_load_icon().
=item $scale; desired scale
=item $for_window; B<Gnome::Gdk3::Window> to optimize drawing for, or C<undefined>
=item $flags; flags modifying the behavior of the icon lookup
=item $error; Location to store error information on failure, or C<undefined>.
=end pod

method gtk-icon-theme-load-surface ( N-GObject() $icon_theme, Str $icon_name, Int() $size, Int() $scale, N-GObject() $for_window, GtkIconLookupFlags $flags, $error is copy --> cairo_surface_t ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_icon_theme_load_surface( self._get-native-object-no-reffing, $icon_theme, $icon_name, $size, $scale, $for_window, $flags, $error)
}

sub gtk_icon_theme_load_surface (
  N-GObject $icon_theme, gchar-ptr $icon_name, gint $size, gint $scale, N-GObject $for_window, GEnum $flags, N-GError $error --> cairo_surface_t
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-lookup-by-gicon:
=begin pod
=head2 gtk-icon-theme-lookup-by-gicon

Looks up an icon and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using gtk_icon_info_load_icon().

When rendering on displays with high pixel densities you should not use a I<size> multiplied by the scaling factor returned by functions like gdk_window_get_scale_factor(). Instead, you should use gtk_icon_theme_lookup_by_gicon_for_scale(), as the assets loaded for a given scaling factor may be different.

Returns: a B<Gnome::Gtk3::IconInfo> containing information about the icon, or C<undefined> if the icon wasn’t found. Unref with g_object_unref()

  method gtk-icon-theme-lookup-by-gicon ( N-GObject() $icon_theme, N-GObject() $icon, Int() $size, GtkIconLookupFlags $flags --> GtkIconInfo )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $icon; the B<Gnome::Gio::Icon> to look up
=item $size; desired icon size
=item $flags; flags modifying the behavior of the icon lookup
=end pod

method gtk-icon-theme-lookup-by-gicon ( N-GObject() $icon_theme, N-GObject() $icon, Int() $size, GtkIconLookupFlags $flags --> GtkIconInfo ) {
  gtk_icon_theme_lookup_by_gicon( self._get-native-object-no-reffing, $icon_theme, $icon, $size, $flags)
}

sub gtk_icon_theme_lookup_by_gicon (
  N-GObject $icon_theme, N-GObject $icon, gint $size, GEnum $flags --> GtkIconInfo
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-lookup-by-gicon-for-scale:
=begin pod
=head2 gtk-icon-theme-lookup-by-gicon-for-scale

Looks up an icon and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using gtk_icon_info_load_icon().

Returns: a B<Gnome::Gtk3::IconInfo> containing information about the icon, or C<undefined> if the icon wasn’t found. Unref with g_object_unref()

  method gtk-icon-theme-lookup-by-gicon-for-scale ( N-GObject() $icon_theme, N-GObject() $icon, Int() $size, Int() $scale, GtkIconLookupFlags $flags --> GtkIconInfo )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $icon; the B<Gnome::Gio::Icon> to look up
=item $size; desired icon size
=item $scale; the desired scale
=item $flags; flags modifying the behavior of the icon lookup
=end pod

method gtk-icon-theme-lookup-by-gicon-for-scale ( N-GObject() $icon_theme, N-GObject() $icon, Int() $size, Int() $scale, GtkIconLookupFlags $flags --> GtkIconInfo ) {
  gtk_icon_theme_lookup_by_gicon_for_scale( self._get-native-object-no-reffing, $icon_theme, $icon, $size, $scale, $flags)
}

sub gtk_icon_theme_lookup_by_gicon_for_scale (
  N-GObject $icon_theme, N-GObject $icon, gint $size, gint $scale, GEnum $flags --> GtkIconInfo
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-lookup-icon:
=begin pod
=head2 gtk-icon-theme-lookup-icon

Looks up a named icon and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using gtk_icon_info_load_icon(). (gtk_icon_theme_load_icon() combines these two steps if all you need is the pixbuf.)

When rendering on displays with high pixel densities you should not use a I<size> multiplied by the scaling factor returned by functions like gdk_window_get_scale_factor(). Instead, you should use gtk_icon_theme_lookup_icon_for_scale(), as the assets loaded for a given scaling factor may be different.

Returns: a B<Gnome::Gtk3::IconInfo> object containing information about the icon, or C<undefined> if the icon wasn’t found.

  method gtk-icon-theme-lookup-icon ( N-GObject() $icon_theme, Str $icon_name, Int() $size, GtkIconLookupFlags $flags --> GtkIconInfo )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $icon_name; the name of the icon to lookup
=item $size; desired icon size
=item $flags; flags modifying the behavior of the icon lookup
=end pod

method gtk-icon-theme-lookup-icon ( N-GObject() $icon_theme, Str $icon_name, Int() $size, GtkIconLookupFlags $flags --> GtkIconInfo ) {
  gtk_icon_theme_lookup_icon( self._get-native-object-no-reffing, $icon_theme, $icon_name, $size, $flags)
}

sub gtk_icon_theme_lookup_icon (
  N-GObject $icon_theme, gchar-ptr $icon_name, gint $size, GEnum $flags --> GtkIconInfo
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-lookup-icon-for-scale:
=begin pod
=head2 gtk-icon-theme-lookup-icon-for-scale

Looks up a named icon for a particular window scale and returns a B<Gnome::Gtk3::IconInfo> containing information such as the filename of the icon. The icon can then be rendered into a pixbuf using gtk_icon_info_load_icon(). (gtk_icon_theme_load_icon() combines these two steps if all you need is the pixbuf.)

Returns: a B<Gnome::Gtk3::IconInfo> object containing information about the icon, or C<undefined> if the icon wasn’t found.

  method gtk-icon-theme-lookup-icon-for-scale ( N-GObject() $icon_theme, Str $icon_name, Int() $size, Int() $scale, GtkIconLookupFlags $flags --> GtkIconInfo )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $icon_name; the name of the icon to lookup
=item $size; desired icon size
=item $scale; the desired scale
=item $flags; flags modifying the behavior of the icon lookup
=end pod

method gtk-icon-theme-lookup-icon-for-scale ( N-GObject() $icon_theme, Str $icon_name, Int() $size, Int() $scale, GtkIconLookupFlags $flags --> GtkIconInfo ) {
  gtk_icon_theme_lookup_icon_for_scale( self._get-native-object-no-reffing, $icon_theme, $icon_name, $size, $scale, $flags)
}

sub gtk_icon_theme_lookup_icon_for_scale (
  N-GObject $icon_theme, gchar-ptr $icon_name, gint $size, gint $scale, GEnum $flags --> GtkIconInfo
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-new:
=begin pod
=head2 gtk-icon-theme-new

Creates a new icon theme object. Icon theme objects are used to lookup up an icon by name in a particular icon theme. Usually, you’ll want to use C<Gnome::Gtk3::IconTheme.get-default()> or C<Gnome::Gtk3::IconTheme.get-for-screen()> rather than creating a new icon theme object for scratch.

Returns: the newly created B<Gnome::Gtk3::IconTheme> object.

  method gtk-icon-theme-new ( --> N-GObject )

=end pod

method gtk-icon-theme-new ( --> N-GObject ) {
  gtk_icon_theme_new( self._get-native-object-no-reffing)
}

sub gtk_icon_theme_new (
   --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-prepend-search-path:
=begin pod
=head2 gtk-icon-theme-prepend-search-path

Prepends a directory to the search path. See gtk_icon_theme_set_search_path().

  method gtk-icon-theme-prepend-search-path ( N-GObject() $icon_theme, Str $path )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $path; (type filename): directory name to prepend to the icon path
=end pod

method gtk-icon-theme-prepend-search-path ( N-GObject() $icon_theme, Str $path ) {
  gtk_icon_theme_prepend_search_path( self._get-native-object-no-reffing, $icon_theme, $path);
}

sub gtk_icon_theme_prepend_search_path (
  N-GObject $icon_theme, gchar-ptr $path 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-rescan-if-needed:
=begin pod
=head2 gtk-icon-theme-rescan-if-needed

Checks to see if the icon theme has changed; if it has, any currently cached information is discarded and will be reloaded next time I<icon_theme> is accessed.

Returns: C<True> if the icon theme has changed and needed to be reloaded.

  method gtk-icon-theme-rescan-if-needed ( N-GObject() $icon_theme --> Bool )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=end pod

method gtk-icon-theme-rescan-if-needed ( N-GObject() $icon_theme --> Bool ) {
  gtk_icon_theme_rescan_if_needed( self._get-native-object-no-reffing, $icon_theme).Bool
}

sub gtk_icon_theme_rescan_if_needed (
  N-GObject $icon_theme --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-set-custom-theme:
=begin pod
=head2 gtk-icon-theme-set-custom-theme

Sets the name of the icon theme that the B<Gnome::Gtk3::IconTheme> object uses overriding system configuration. This function cannot be called on the icon theme objects returned from C<Gnome::Gtk3::IconTheme.get-default()> and gtk_icon_theme_get_for_screen().

  method gtk-icon-theme-set-custom-theme ( N-GObject() $icon_theme, Str $theme_name )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $theme_name; name of icon theme to use instead of configured theme, or C<undefined> to unset a previously set custom theme
=end pod

method gtk-icon-theme-set-custom-theme ( N-GObject() $icon_theme, Str $theme_name ) {
  gtk_icon_theme_set_custom_theme( self._get-native-object-no-reffing, $icon_theme, $theme_name);
}

sub gtk_icon_theme_set_custom_theme (
  N-GObject $icon_theme, gchar-ptr $theme_name 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-set-screen:
=begin pod
=head2 gtk-icon-theme-set-screen

Sets the screen for an icon theme; the screen is used to track the user’s currently configured icon theme, which might be different for different screens.

  method gtk-icon-theme-set-screen ( N-GObject() $icon_theme, N-GObject() $screen )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $screen; a B<Gnome::Gdk3::Screen>
=end pod

method gtk-icon-theme-set-screen ( N-GObject() $icon_theme, N-GObject() $screen ) {
  gtk_icon_theme_set_screen( self._get-native-object-no-reffing, $icon_theme, $screen);
}

sub gtk_icon_theme_set_screen (
  N-GObject $icon_theme, N-GObject $screen 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk-icon-theme-set-search-path:
=begin pod
=head2 gtk-icon-theme-set-search-path

Sets the search path for the icon theme object. When looking for an icon theme, GTK+ will search for a subdirectory of one or more of the directories in I<path> with the same name as the icon theme containing an index.theme file. (Themes from multiple of the path elements are combined to allow themes to be extended by adding icons in the user’s home directory.)

In addition if an icon found isn’t found either in the current icon theme or the default icon theme, and an image file with the right name is found directly in one of the elements of I<path>, then that image will be used for the icon name. (This is legacy feature, and new icons should be put into the fallback icon theme, which is called hicolor, rather than directly on the icon path.)

  method gtk-icon-theme-set-search-path ( N-GObject() $icon_theme,  $const gchar *path[], Int() $n_elements )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $const gchar *path[]; (array length=n_elements) (element-type filename): array of directories that are searched for icon themes
=item $n_elements; number of elements in I<path>.
=end pod

method gtk-icon-theme-set-search-path ( N-GObject() $icon_theme,  $const gchar *path[], Int() $n_elements ) {
  gtk_icon_theme_set_search_path( self._get-native-object-no-reffing, $icon_theme, $const gchar *path[], $n_elements);
}

sub gtk_icon_theme_set_search_path (
  N-GObject $icon_theme,  $const gchar *path[], gint $n_elements 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:is-symbolic:
=begin pod
=head2 is-symbolic

Checks if the icon is symbolic or not. This currently uses only the file name and not the file contents for determining this. This behaviour may change in the future.

Returns: C<True> if the icon is symbolic, C<False> otherwise

  method is-symbolic ( --> Bool )

=end pod

method is-symbolic ( --> Bool ) {
  gtk_icon_info_is_symbolic( self._get-native-object-no-reffing).Bool
}

sub gtk_icon_info_is_symbolic (
  GtkIconInfo $icon_info --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-icon:
=begin pod
=head2 load-icon

Renders an icon previously looked up in an icon theme using gtk_icon_theme_lookup_icon(); the size will be based on the size passed to gtk_icon_theme_lookup_icon(). Note that the resulting pixbuf may not be exactly this size; an icon theme may have icons that differ slightly from their nominal sizes, and in addition GTK+ will avoid scaling icons that it considers sufficiently close to the requested size or for which the source image would have to be scaled up too far. (This maintains sharpness.). This behaviour can be changed by passing the C<GTK_ICON_LOOKUP_FORCE_SIZE> flag when obtaining the B<Gnome::Gtk3::IconInfo>. If this flag has been specified, the pixbuf returned by this function will be scaled to the exact size.

Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<Gnome::GObject::Object.unref()> to release your reference to the icon.

  method load-icon ( N-GError $error --> N-GObject )

=item $error; location to store error information on failure, or C<undefined>.
=end pod

method load-icon ( $error is copy --> N-GObject ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_icon_info_load_icon( self._get-native-object-no-reffing, $error)
}

sub gtk_icon_info_load_icon (
  GtkIconInfo $icon_info, N-GError $error --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-icon-async:
=begin pod
=head2 load-icon-async

Asynchronously load, render and scale an icon previously looked up from the icon theme using gtk_icon_theme_lookup_icon().

For more details, see C<Gnome::Gtk3::IconInfo.load-icon()> which is the synchronous version of this call.

  method load-icon-async ( N-GObject() $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )

=item $cancellable; optional B<Not implemented Gnome::Gio::Cancellable> object, C<undefined> to ignore
=item $callback; (scope async): a B<Not implemented Gnome::Glib::Async> to call when the request is satisfied
=item $user_data; (closure): the data to pass to callback function
=end pod

method load-icon-async ( N-GObject() $cancellable, GAsyncReadyCallback $callback, Pointer $user_data ) {
  gtk_icon_info_load_icon_async( self._get-native-object-no-reffing, $cancellable, $callback, $user_data);
}

sub gtk_icon_info_load_icon_async (
  GtkIconInfo $icon_info, N-GObject $cancellable, GAsyncReadyCallback $callback, gpointer $user_data 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-icon-finish:
=begin pod
=head2 load-icon-finish

Finishes an async icon load, see gtk_icon_info_load_icon_async().

Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<Gnome::GObject::Object.unref()> to release your reference to the icon.

  method load-icon-finish ( N-GObject() $res, N-GError $error --> N-GObject )

=item $res; a B<Not implemented Gnome::Glib::Async>
=item $error; location to store error information on failure, or C<undefined>.
=end pod

method load-icon-finish ( N-GObject() $res, $error is copy --> N-GObject ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_icon_info_load_icon_finish( self._get-native-object-no-reffing, $res, $error)
}

sub gtk_icon_info_load_icon_finish (
  GtkIconInfo $icon_info, N-GObject $res, N-GError $error --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-surface:
=begin pod
=head2 load-surface

Renders an icon previously looked up in an icon theme using gtk_icon_theme_lookup_icon(); the size will be based on the size passed to gtk_icon_theme_lookup_icon(). Note that the resulting surface may not be exactly this size; an icon theme may have icons that differ slightly from their nominal sizes, and in addition GTK+ will avoid scaling icons that it considers sufficiently close to the requested size or for which the source image would have to be scaled up too far. (This maintains sharpness.). This behaviour can be changed by passing the C<GTK_ICON_LOOKUP_FORCE_SIZE> flag when obtaining the B<Gnome::Gtk3::IconInfo>. If this flag has been specified, the pixbuf returned by this function will be scaled to the exact size.

Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<Gnome::Cairo::Surface.destroy()> to release your reference to the icon.

  method load-surface ( N-GObject() $for_window, N-GError $error --> cairo_surface_t )

=item $for_window; B<Gnome::Gdk3::Window> to optimize drawing for, or C<undefined>
=item $error; location for error information on failure, or C<undefined>
=end pod

method load-surface ( N-GObject() $for_window, $error is copy --> cairo_surface_t ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_icon_info_load_surface( self._get-native-object-no-reffing, $for_window, $error)
}

sub gtk_icon_info_load_surface (
  GtkIconInfo $icon_info, N-GObject $for_window, N-GError $error --> cairo_surface_t
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-symbolic:
=begin pod
=head2 load-symbolic

Loads an icon, modifying it to match the system colours for the foreground, success, warning and error colors provided. If the icon is not a symbolic one, the function will return the result from gtk_icon_info_load_icon().

This allows loading symbolic icons that will match the system theme.

Unless you are implementing a widget, you will want to use C<Gnome::Gio::ThemedIcon.new-with-default-fallbacks()> to load the icon.

As implementation details, the icon loaded needs to be of SVG type, contain the “symbolic” term as the last component of the icon name, and use the “fg”, “success”, “warning” and “error” CSS styles in the SVG file itself.

See the [Symbolic Icons Specification](http://www.freedesktop.org/wiki/SymbolicIcons) for more information about symbolic icons.

Returns: a B<Gnome::Gdk3::Pixbuf> representing the loaded icon

  method load-symbolic ( N-GObject() $fg, N-GObject() $success_color, N-GObject() $warning_color, N-GObject() $error_color, Bool $was_symbolic, N-GError $error --> N-GObject )

=item $fg; a B<gdk_r_g_b_a> representing the foreground color of the icon
=item $success_color; a B<gdk_r_g_b_a> representing the warning color of the icon or C<undefined> to use the default color
=item $warning_color; a B<gdk_r_g_b_a> representing the warning color of the icon or C<undefined> to use the default color
=item $error_color; a B<gdk_r_g_b_a> representing the error color of the icon or C<undefined> to use the default color 
=item $was_symbolic; a B<gboolean>, returns whether the loaded icon was a symbolic one and whether the I<fg> color was applied to it.
=item $error; location to store error information on failure, or C<undefined>.
=end pod

method load-symbolic ( N-GObject() $fg, N-GObject() $success_color, N-GObject() $warning_color, N-GObject() $error_color, Bool $was_symbolic, $error is copy --> N-GObject ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_icon_info_load_symbolic( self._get-native-object-no-reffing, $fg, $success_color, $warning_color, $error_color, $was_symbolic, $error)
}

sub gtk_icon_info_load_symbolic (
  GtkIconInfo $icon_info, N-GObject $fg, N-GObject $success_color, N-GObject $warning_color, N-GObject $error_color, gboolean $was_symbolic, N-GError $error --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-symbolic-async:
=begin pod
=head2 load-symbolic-async

Asynchronously load, render and scale a symbolic icon previously looked up from the icon theme using gtk_icon_theme_lookup_icon().

For more details, see C<Gnome::Gtk3::IconInfo.load-symbolic()> which is the synchronous version of this call.

  method load-symbolic-async ( N-GObject() $fg, N-GObject() $success_color, N-GObject() $warning_color, N-GObject() $error_color, N-GObject() $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )

=item $fg; a B<gdk_r_g_b_a> representing the foreground color of the icon
=item $success_color; a B<gdk_r_g_b_a> representing the warning color of the icon or C<undefined> to use the default color
=item $warning_color; a B<gdk_r_g_b_a> representing the warning color of the icon or C<undefined> to use the default color
=item $error_color; a B<gdk_r_g_b_a> representing the error color of the icon or C<undefined> to use the default color 
=item $cancellable; optional B<Not implemented Gnome::Gio::Cancellable> object, C<undefined> to ignore
=item $callback; (scope async): a B<Not implemented Gnome::Glib::Async> to call when the request is satisfied
=item $user_data; (closure): the data to pass to callback function
=end pod

method load-symbolic-async ( N-GObject() $fg, N-GObject() $success_color, N-GObject() $warning_color, N-GObject() $error_color, N-GObject() $cancellable, GAsyncReadyCallback $callback, Pointer $user_data ) {
  gtk_icon_info_load_symbolic_async( self._get-native-object-no-reffing, $fg, $success_color, $warning_color, $error_color, $cancellable, $callback, $user_data);
}

sub gtk_icon_info_load_symbolic_async (
  GtkIconInfo $icon_info, N-GObject $fg, N-GObject $success_color, N-GObject $warning_color, N-GObject $error_color, N-GObject $cancellable, GAsyncReadyCallback $callback, gpointer $user_data 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-symbolic-finish:
=begin pod
=head2 load-symbolic-finish

Finishes an async icon load, see gtk_icon_info_load_symbolic_async().

Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<Gnome::GObject::Object.unref()> to release your reference to the icon.

  method load-symbolic-finish ( N-GObject() $res, Bool $was_symbolic, N-GError $error --> N-GObject )

=item $res; a B<Not implemented Gnome::Glib::Async>
=item $was_symbolic; a B<gboolean>, returns whether the loaded icon was a symbolic one and whether the I<fg> color was applied to it.
=item $error; location to store error information on failure, or C<undefined>.
=end pod

method load-symbolic-finish ( N-GObject() $res, Bool $was_symbolic, $error is copy --> N-GObject ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_icon_info_load_symbolic_finish( self._get-native-object-no-reffing, $res, $was_symbolic, $error)
}

sub gtk_icon_info_load_symbolic_finish (
  GtkIconInfo $icon_info, N-GObject $res, gboolean $was_symbolic, N-GError $error --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-symbolic-for-context:
=begin pod
=head2 load-symbolic-for-context

Loads an icon, modifying it to match the system colors for the foreground, success, warning and error colors provided. If the icon is not a symbolic one, the function will return the result from gtk_icon_info_load_icon(). This function uses the regular foreground color and the symbolic colors with the names “success_color”, “warning_color” and “error_color” from the context.

This allows loading symbolic icons that will match the system theme.

See C<Gnome::Gtk3::IconInfo.load-symbolic()> for more details.

Returns: a B<Gnome::Gdk3::Pixbuf> representing the loaded icon

  method load-symbolic-for-context ( N-GObject() $context, Bool $was_symbolic, N-GError $error --> N-GObject )

=item $context; a B<Gnome::Gtk3::StyleContext>
=item $was_symbolic; a B<gboolean>, returns whether the loaded icon was a symbolic one and whether the I<fg> color was applied to it.
=item $error; location to store error information on failure, or C<undefined>.
=end pod

method load-symbolic-for-context ( N-GObject() $context, Bool $was_symbolic, $error is copy --> N-GObject ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_icon_info_load_symbolic_for_context( self._get-native-object-no-reffing, $context, $was_symbolic, $error)
}

sub gtk_icon_info_load_symbolic_for_context (
  GtkIconInfo $icon_info, N-GObject $context, gboolean $was_symbolic, N-GError $error --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-symbolic-for-context-async:
=begin pod
=head2 load-symbolic-for-context-async

Asynchronously load, render and scale a symbolic icon previously looked up from the icon theme using gtk_icon_theme_lookup_icon().

For more details, see C<Gnome::Gtk3::IconInfo.load-symbolic-for-context()> which is the synchronous version of this call.

  method load-symbolic-for-context-async ( N-GObject() $context, N-GObject() $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )

=item $context; a B<Gnome::Gtk3::StyleContext>
=item $cancellable; optional B<Not implemented Gnome::Gio::Cancellable> object, C<undefined> to ignore
=item $callback; (scope async): a B<Not implemented Gnome::Glib::Async> to call when the request is satisfied
=item $user_data; (closure): the data to pass to callback function
=end pod

method load-symbolic-for-context-async ( N-GObject() $context, N-GObject() $cancellable, GAsyncReadyCallback $callback, Pointer $user_data ) {
  gtk_icon_info_load_symbolic_for_context_async( self._get-native-object-no-reffing, $context, $cancellable, $callback, $user_data);
}

sub gtk_icon_info_load_symbolic_for_context_async (
  GtkIconInfo $icon_info, N-GObject $context, N-GObject $cancellable, GAsyncReadyCallback $callback, gpointer $user_data 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-symbolic-for-context-finish:
=begin pod
=head2 load-symbolic-for-context-finish

Finishes an async icon load, see gtk_icon_info_load_symbolic_for_context_async().

Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<Gnome::GObject::Object.unref()> to release your reference to the icon.

  method load-symbolic-for-context-finish ( N-GObject() $res, Bool $was_symbolic, N-GError $error --> N-GObject )

=item $res; a B<Not implemented Gnome::Glib::Async>
=item $was_symbolic; a B<gboolean>, returns whether the loaded icon was a symbolic one and whether the I<fg> color was applied to it.
=item $error; location to store error information on failure, or C<undefined>.
=end pod

method load-symbolic-for-context-finish ( N-GObject() $res, Bool $was_symbolic, $error is copy --> N-GObject ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;
  gtk_icon_info_load_symbolic_for_context_finish( self._get-native-object-no-reffing, $res, $was_symbolic, $error)
}

sub gtk_icon_info_load_symbolic_for_context_finish (
  GtkIconInfo $icon_info, N-GObject $res, gboolean $was_symbolic, N-GError $error --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_icon_info_new_for_pixbuf:
#`{{
=begin pod
=head2 _gtk_icon_info_new_for_pixbuf

Creates a B<Gnome::Gtk3::IconInfo> for a B<Gnome::Gdk3::Pixbuf>.

Returns: a B<Gnome::Gtk3::IconInfo>

  method _gtk_icon_info_new_for_pixbuf ( N-GObject() $icon_theme, N-GObject() $pixbuf --> GtkIconInfo )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $pixbuf; the pixbuf to wrap in a B<Gnome::Gtk3::IconInfo>
=end pod
}}

sub _gtk_icon_info_new_for_pixbuf ( N-GObject $icon_theme, N-GObject $pixbuf --> GtkIconInfo )
  is native(&gtk-lib)
  is symbol('gtk_icon_info_new_for_pixbuf')
  { * }
