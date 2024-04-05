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
  also is Gnome::GObject::Object;


=head2 Uml Diagram

![](plantuml/IconInfo.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::IconInfo:api<1>;

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

#use Gnome::N::X:api<1>;
use Gnome::N::NativeLib:api<1>;
use Gnome::N::N-GObject:api<1>;
use Gnome::N::GlibToRakuTypes:api<1>;

use Gnome::GObject::Object:api<1>;

use Gnome::Glib::Error:api<1>;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::IconInfo:auth<github:MARTIMM>:api<1>;
also is Gnome::GObject::Object;

has Gnome::Glib::Error() $.last-error .= new(:native-object(N-GError));

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

=head3 :pixbuf, :theme

Create a new B<Gnome::Gtk3::IconInfo> object using a B<Gnome::Gdk3::Pixbuf>.

  multi method new (
    Gnome::Gdk3::Pixbuf :$pixbuf!,
    Gnome::Gtk3::IconTheme :$theme!
  )

=item $pixbuf; The pixbuf to wrap in
=item $theme; An icon theme


=head3 :native-object

Create a IconInfo object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:1:new(:pixbuf)
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
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
      my N-GObject() ( $no, $pb, $th);
      if ? %options<pixbuf> and ? %options<theme> {
        $pb = %options<pixbuf>;
        $th = %options<theme>;
        $no = _gtk_icon_info_new_for_pixbuf( $th, $pb);
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
#TM:1:last-error:
=begin pod
=head2 

Get the last error code for icon info errors

  method last-error ( --> Gnome::Glib::Error )

=end pod

#method last-error ( --> Gnome::Glib::Error) {
#  $!last-error;
#}

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
  N-GObject $icon_info --> gint
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
  N-GObject $icon_info --> gint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-filename:
=begin pod
=head2 get-filename

Gets the filename for the icon. If the C<GTK_ICON_LOOKUP_USE_BUILTIN> flag was passed to C<Gnome::Gtk3::IconTheme.lookup_icon()>, there may be no filename if a builtin icon is returned; in this case, you should use C<Gnome::Gtk3::IconInfo.get-builtin-pixbuf()>.

Returns:  (type filename): the filename for the icon, or C<undefined> if C<Gnome::Gtk3::IconInfo.get-builtin-pixbuf()> should be used instead. The return value is owned by GTK+ and should not be modified or freed.

  method get-filename ( --> Str )

=end pod

method get-filename ( --> Str ) {
  gtk_icon_info_get_filename( self._get-native-object-no-reffing)
}

sub gtk_icon_info_get_filename (
  N-GObject $icon_info --> gchar-ptr
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
  N-GObject $icon_info --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-icon:
=begin pod
=head2 load-icon

Renders an icon previously looked up in an icon theme using C<Gnome::Gtk3::IconTheme.lookup_icon()>; the size will be based on the size passed to C<Gnome::Gtk3::IconTheme.lookup_icon()>. Note that the resulting pixbuf may not be exactly this size; an icon theme may have icons that differ slightly from their nominal sizes, and in addition GTK+ will avoid scaling icons that it considers sufficiently close to the requested size or for which the source image would have to be scaled up too far. (This maintains sharpness.). This behaviour can be changed by passing the C<GTK_ICON_LOOKUP_FORCE_SIZE> flag when obtaining the B<Gnome::Gtk3::IconInfo>. If this flag has been specified, the pixbuf returned by this function will be scaled to the exact size.

Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<Gnome::GObject::Object.unref()> to release your reference to the icon.

  method load-icon ( --> N-GObject )

When an error occurs, check the last error attribute;

Example

  my Gnome::Gtk3::IconTheme $icon-theme .= new(:default);
  my Gnome::Gtk3::IconInfo $ii = $icon-theme.lookup-icon('server-database');
  my Gnome::Gdk3::Pixbuf() $pixbuf = $ii.load-icon;
  unless $pixbuf.is-valid {
    die "Couldn’t load icon: " ~ $ii.last-error.message;
  }

=end pod

method load-icon ( --> N-GObject ) {
  my $error = CArray[N-GError].new(N-GError);
  my N-GObject $no = gtk_icon_info_load_icon(
    self._get-native-object-no-reffing, $error
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

sub gtk_icon_info_load_icon (
  N-GObject $icon_info, CArray[N-GError] $error --> N-GObject
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:load-icon-async:
=begin pod
=head2 load-icon-async

Asynchronously load, render and scale an icon previously looked up from the icon theme using C<Gnome::Gtk3::IconTheme.lookup_icon()>.

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
  N-GObject $icon_info, N-GObject $cancellable, GAsyncReadyCallback $callback, gpointer $user_data 
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
  N-GObject $icon_info, N-GObject $res, N-GError $error --> N-GObject
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:load-surface:
=begin pod
=head2 load-surface

Renders an icon previously looked up in an icon theme using C<Gnome::Gtk3::IconTheme.lookup_icon()>; the size will be based on the size passed to C<Gnome::Gtk3::IconTheme.lookup_icon()>. Note that the resulting surface may not be exactly this size; an icon theme may have icons that differ slightly from their nominal sizes, and in addition GTK+ will avoid scaling icons that it considers sufficiently close to the requested size or for which the source image would have to be scaled up too far. (This maintains sharpness.). This behaviour can be changed by passing the C<GTK_ICON_LOOKUP_FORCE_SIZE> flag when obtaining the B<Gnome::Gtk3::IconInfo>. If this flag has been specified, the pixbuf returned by this function will be scaled to the exact size.

Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use C<Gnome::Cairo::Surface.destroy()> to release your reference to the icon.

  method load-surface ( N-GObject() $for_window --> cairo_surface_t )

=item $for_window; B<Gnome::Gdk3::Window> to optimize drawing for, or C<undefined>

When an error occurs, check the last error attribute;

=end pod

method load-surface ( N-GObject() $for_window --> N-GObject ) {
  my $error = CArray[N-GError].new(N-GError);
  my N-GObject $no = gtk_icon_info_load_surface(
    self._get-native-object-no-reffing, $for_window, $error
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

sub gtk_icon_info_load_surface (
  N-GObject $icon_info, N-GObject $for_window, CArray[N-GError] $error
  --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-symbolic:
=begin pod
=head2 load-symbolic

Loads an icon, modifying it to match the system colours for the foreground, success, warning and error colors provided. If the icon is not a symbolic one, the function will return the result from C<.load_icon()>.

This allows loading symbolic icons that will match the system theme.

=comment #TODO; Unless you are implementing a widget, you will want to use C<Gnome::Gio::ThemedIcon.new-with-default-fallbacks()> to load the icon.

As implementation details, the icon loaded needs to be of SVG type, contain the “symbolic” term as the last component of the icon name, and use the “fg”, “success”, “warning” and “error” CSS styles in the SVG file itself.

See the L<Symbolic Icons Specification|http://www.freedesktop.org/wiki/SymbolicIcons> for more information about symbolic icons.

Returns: a B<Gnome::Gdk3::Pixbuf> representing the loaded icon

  method load-symbolic (
    N-GObject() $fg, N-GObject() $success_color,
    N-GObject() $warning_color, N-GObject() $error_color,
    Bool $was_symbolic
    --> N-GObject )

=item $fg; a B<Gnome::Gdk3::RGBA> representing the foreground color of the icon
=item $success_color; a B<Gnome::Gdk3::RGBA> representing the warning color of the icon or C<undefined> to use the default color
=item $warning_color; a B<Gnome::Gdk3::RGBA> representing the warning color of the icon or C<undefined> to use the default color
=item $error_color; a B<Gnome::Gdk3::RGBA> representing the error color of the icon or C<undefined> to use the default color 
=item $was_symbolic; a B<gboolean>, returns whether the loaded icon was a symbolic one and whether the I<fg> color was applied to it.
=item $error; location to store error information on failure, or C<undefined>.

When an error occurs, check the last error attribute;
=end pod

method load-symbolic (
  N-GObject() $fg, N-GObject() $success_color, N-GObject() $warning_color, 
  N-GObject() $error_color, Bool $was_symbolic
  --> N-GObject
) {
  my $error = CArray[N-GError].new(N-GError);
  my N-GObject $no = gtk_icon_info_load_symbolic(
    self._get-native-object-no-reffing, $fg, $success_color, $warning_color,
    $error_color, $was_symbolic, $error
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

sub gtk_icon_info_load_symbolic (
  N-GObject $icon_info, N-GObject $fg, N-GObject $success_color, N-GObject $warning_color, N-GObject $error_color, gboolean $was_symbolic, CArray[N-GError] $error --> N-GObject
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:load-symbolic-async:
=begin pod
=head2 load-symbolic-async

Asynchronously load, render and scale a symbolic icon previously looked up from the icon theme using C<Gnome::Gtk3::IconTheme.lookup_icon()>.

For more details, see C<Gnome::Gtk3::IconInfo.load-symbolic()> which is the synchronous version of this call.

  method load-symbolic-async ( N-GObject() $fg, N-GObject() $success_color, N-GObject() $warning_color, N-GObject() $error_color, N-GObject() $cancellable, GAsyncReadyCallback $callback, Pointer $user_data )

=item $fg; a B<Gnome::Gdk3::RGBA> representing the foreground color of the icon
=item $success_color; a B<Gnome::Gdk3::RGBA> representing the warning color of the icon or C<undefined> to use the default color
=item $warning_color; a B<Gnome::Gdk3::RGBA> representing the warning color of the icon or C<undefined> to use the default color
=item $error_color; a B<Gnome::Gdk3::RGBA> representing the error color of the icon or C<undefined> to use the default color 
=item $cancellable; optional B<Not implemented Gnome::Gio::Cancellable> object, C<undefined> to ignore
=item $callback; (scope async): a B<Not implemented Gnome::Glib::Async> to call when the request is satisfied
=item $user_data; (closure): the data to pass to callback function
=end pod

method load-symbolic-async ( N-GObject() $fg, N-GObject() $success_color, N-GObject() $warning_color, N-GObject() $error_color, N-GObject() $cancellable, GAsyncReadyCallback $callback, Pointer $user_data ) {
  gtk_icon_info_load_symbolic_async( self._get-native-object-no-reffing, $fg, $success_color, $warning_color, $error_color, $cancellable, $callback, $user_data);
}

sub gtk_icon_info_load_symbolic_async (
  N-GObject $icon_info, N-GObject $fg, N-GObject $success_color, N-GObject $warning_color, N-GObject $error_color, N-GObject $cancellable, GAsyncReadyCallback $callback, gpointer $user_data 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-symbolic-finish:
=begin pod
=head2 load-symbolic-finish

Finishes an async icon load, see C<.load_symbolic_async()>.

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
  N-GObject $icon_info, N-GObject $res, gboolean $was_symbolic, N-GError $error --> N-GObject
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:load-symbolic-for-context:
=begin pod
=head2 load-symbolic-for-context

Loads an icon, modifying it to match the system colors for the foreground, success, warning and error colors provided. If the icon is not a symbolic one, the function will return the result from C<.load_icon()>. This function uses the regular foreground color and the symbolic colors with the names “success_color”, “warning_color” and “error_color” from the context.

This allows loading symbolic icons that will match the system theme.

See C<.load-symbolic()> for more details.

Returns: a B<Gnome::Gdk3::Pixbuf> representing the loaded icon

  method load-symbolic-for-context (
    N-GObject() $context, Bool $was_symbolic
    --> N-GObject
  )

=item $context; a B<Gnome::Gtk3::StyleContext>
=item $was_symbolic; a B<gboolean>, returns whether the loaded icon was a symbolic one and whether the I<fg> color was applied to it.
=item $error; location to store error information on failure, or C<undefined>.

When an error occurs, check the last error attribute;
=end pod

method load-symbolic-for-context (
  N-GObject() $context, Bool $was_symbolic, --> N-GObject
) {
  my $error = CArray[N-GError].new(N-GError);
  my N-GObject $no = gtk_icon_info_load_symbolic_for_context(
    self._get-native-object-no-reffing, $context, $was_symbolic, $error
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

sub gtk_icon_info_load_symbolic_for_context (
  N-GObject $icon_info, N-GObject $context, gboolean $was_symbolic,
  CArray[N-GError] $error --> N-GObject
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:load-symbolic-for-context-async:
=begin pod
=head2 load-symbolic-for-context-async

Asynchronously load, render and scale a symbolic icon previously looked up from the icon theme using C<Gnome::Gtk3::IconTheme.lookup_icon()>.

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
  N-GObject $icon_info, N-GObject $context, N-GObject $cancellable, GAsyncReadyCallback $callback, gpointer $user_data 
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:load-symbolic-for-context-finish:
=begin pod
=head2 load-symbolic-for-context-finish

Finishes an async icon load, see C<.load_symbolic_for_context_async()>.

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
  N-GObject $icon_info, N-GObject $res, gboolean $was_symbolic, N-GError $error --> N-GObject
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_icon_info_new_for_pixbuf:
#`{{
=begin pod
=head2 _gtk_icon_info_new_for_pixbuf

Creates a B<Gnome::Gtk3::IconInfo> for a B<Gnome::Gdk3::Pixbuf>.

Returns: a B<Gnome::Gtk3::IconInfo>

  method _gtk_icon_info_new_for_pixbuf ( N-GObject() $icon_theme, N-GObject() $pixbuf --> N-GObject )

=item $icon_theme; a B<Gnome::Gtk3::IconTheme>
=item $pixbuf; the pixbuf to wrap in a B<Gnome::Gtk3::IconInfo>
=end pod
}}

sub _gtk_icon_info_new_for_pixbuf (
  N-GObject $icon_theme, N-GObject $pixbuf --> N-GObject
) is native(&gtk-lib)
  is symbol('gtk_icon_info_new_for_pixbuf')
  { * }
