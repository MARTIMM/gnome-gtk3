#TL:1:Gnome::Gtk3::Builder:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Builder

Build an interface from an XML UI definition

=head1 Description

=comment add C<gtk_builder_new_from_resource()> when ready

A B<Gnome::Gtk3::Builder> is an auxiliary object that reads textual descriptions of a user interface and instantiates the described objects. To create a B<Gnome::Gtk3::Builder> from a user interface description, call C<.new(:file)>, C<.new(:resource)> or C<.new(:string)>.

In the (unusual) case that you want to add user interface descriptions from multiple sources to the same B<Gnome::Gtk3::Builder> you can call C<.new()> to get an empty builder and populate it by (multiple) calls to C<gtk_builder_add_from_file()>, C<gtk_builder_add_from_resource()> or C<gtk_builder_add_from_string()>.

A B<Gnome::Gtk3::Builder> holds a reference to all objects that it has constructed and drops these references when it is finalized. This finalization can cause the destruction of non-widget objects or widgets which are not contained in a toplevel window. For toplevel windows constructed by a builder, it is the responsibility of the user to call C<gtk_widget_destroy()> to get rid of them and all the widgets they contain.

The function C<gtk_builder_get_object()> can be used to access the widgets in the interface by the names assigned to them (id's) inside the UI description. Toplevel windows returned by these functions will stay around until the user explicitly destroys them with C<gtk_widget_destroy()>. Other widgets will either be part of a larger hierarchy constructed by the builder (in which case you should not have to worry about their lifecycle), or without a parent, in which case they have to be added to some container to make use of them. All widget classes have the ability to be initialized using the named argument C<.new(:build-id)>. This will end up using C<gtk_builder_get_object()>. A builder must be created first and data fed to the builder before you are able to use it.

=comment Non-widget objects need to be reffed with C<g_object_ref()> to keep them beyond the lifespan of the builder.

The function C<gtk_builder_connect_signals_full()> and variants thereof can be used to connect handlers to the named signals defined in a handler table. The signals can also be handled individualy using C<.register-signal()>.

=head2 Gnome::Gtk3::Builder UI Definitions

B<Gnome::Gtk3::Builder> parses textual descriptions of user interfaces which are specified in an XML format which can be roughly described by the RELAX NG schema below. We refer to these descriptions as “B<GtkBuilder> UI definitions” or just “UI definitions” if the context is clear.

It is common to use `.ui` as the filename extension for files containing B<Gnome::Gtk3::Builder> UI definitions.

<!--[RELAX NG Compact Syntax](https://git.gnome.org/browse/gtk+/tree/gtk/gtkbuilder.rnc)-->

The toplevel element is <interface>. It optionally takes a “domain” attribute, which will make the builder look for translated strings using C<dgettext()> in the domain specified. This can also be done by calling C<gtk_builder_set_translation_domain()> on the builder. Objects are described by <object> elements, which can contain <property> elements to set properties, <signal> elements which connect signals to handlers, and <child> elements, which describe child objects (most often widgets inside a container, but also e.g. actions in an action group, or columns in a tree model). A <child> element contains an <object> element which describes the child object. The target toolkit version(s) are described by <requires> elements, the “lib” attribute specifies the widget library in question (currently the only supported value is “gtk+”) and the “version” attribute specifies the target version in the form “<major>.<minor>”. The builder will error out if the version requirements are not met.

Typically, the specific kind of object represented by an <object> element is specified by the “class” attribute. If the type has not been loaded yet, GTK+ tries to find the C<get_type()> function from the class name by applying heuristics. This works in most cases, but if necessary, it is possible to specify the name of the C<get_type()> function explictly with the "type-func" attribute. As a special case, B<Gnome::Gtk3::Builder> allows to use an object that has been constructed by a B<GtkUIManager> in another part of the UI definition by specifying the id of the B<GtkUIManager> in the “constructor” attribute and the name of the object in the “id” attribute.

Objects may be given a name with the “id” attribute, which allows the application to retrieve them from the builder with C<gtk_builder_get_object()> which is also used indirectly when a widget is created using `.new(:$build-id)`. An id is also necessary to use the object as property value in other parts of the UI definition. GTK+ reserves ids starting and ending with ___ (3 underscores) for its own purposes.

Setting properties of objects is pretty straightforward with the <property> element: the “name” attribute specifies the name of the property, and the content of the element specifies the value. If the “translatable” attribute is set to a true value, GTK+ uses C<gettext()> (or C<dgettext()> if the builder has a translation domain set) to find a translation for the value. This happens before the value is parsed, so it can be used for properties of any type, but it is probably most useful for string properties. It is also possible to specify a context to disambiguate short strings, and comments which may help the translators.

B<Gnome::Gtk3::Builder> can parse textual representations for the most common property types: characters, strings, integers, floating-point numbers, booleans (strings like “TRUE”, “t”, “yes”, “y”, “1” are interpreted as C<1>, strings like “FALSE”, “f”, “no”, “n”, “0” are interpreted as C<0>), enumerations (can be specified by their name, nick or integer value), flags (can be specified by their name, nick, integer value, optionally combined with “|”, e.g. “GTK_VISIBLE|GTK_REALIZED”) and colors (in a format understood by C<gdk_rgba_parse()>).

=begin comment
GVariants can be specified in the format understood by C<g_variant_parse()>, and pixbufs can be specified as a filename of an image file to load.
=end comment

Objects can be referred to by their name and by default refer to objects declared in the local xml fragment and objects exposed via C<expose_object()>. In general, B<Gnome::Gtk3::Builder> allows forward references to objects — declared in the local xml; an object doesn’t have to be constructed before it can be referred to. The exception to this rule is that an object has to be constructed before it can be used as the value of a construct-only property.

=begin comment
It is also possible to bind a property value to another object's property value using the attributes "bind-source" to specify the source object of the binding, "bind-property" to specify the source property and optionally "bind-flags" to specify the binding flags Internally builder implement this using GBinding objects. For more information see C<g_object_bind_property()>
=end comment

Signal handlers are set up with the <signal> element. The “name” attribute specifies the name of the signal, and the “handler” attribute specifies the function to connect to the signal. The remaining attributes, “after” and “swapped” attributes are ignored by the Raku modules. The "object" field has a meaning in B<Gnome::Gtk3::Glade>.

=begin comment
By default, GTK+ tries to find the handler using C<g_module_symbol()>, but this can be changed by passing a custom C<builder-connect-func()> to C<connect_signals_full()>. The remaining attributes, “after”, “swapped” and “object”, have the same meaning as the corresponding parameters of the C<g_signal_connect_object()> or C<g_signal_connect_data()> functions. A “last_modification_time” attribute is also allowed, but it does not have a meaning to the builder.
=end comment

Sometimes it is necessary to refer to widgets which have implicitly been constructed by GTK+ as part of a composite widget, to set properties on them or to add further children (e.g. the I<vbox> of a B<Gnome::Gtk3::Dialog>). This can be achieved by setting the “internal-child” propery of the <child> element to a true value. Note that B<Gnome::Gtk3::Builder> still requires an <object> element for the internal child, even if it has already been constructed.

A number of widgets have different places where a child can be added (e.g. tabs vs. page content in notebooks). This can be reflected in a UI definition by specifying the “type” attribute on a <child>. The possible values for the “type” attribute are described in the sections describing the widget-specific portions of UI definitions.

=head2 A Gnome::Gtk3::Builder UI Definition

Note the class names are e.g. GtkDialog, not Gnome::Gtk3::Dialog. This is because those are the c-source class names of the GTK+ objects.

  <interface>
    <object class="GtkDialog>" id="dialog1">
      <child internal-child="vbox">
        <object class="GtkBox>" id="vbox1">
          <property name="border-width">10</property>
          <child internal-child="action_area">
            <object class="GtkButtonBox>" id="hbuttonbox1">
              <property name="border-width">20</property>
              <child>
                <object class="GtkButton>" id="ok_button">
                  <property name="label">gtk-ok</property>
                  <property name="use-stock">TRUE</property>
                  <signal name="clicked" handler="ok_button_clicked"/>
                </object>
              </child>
            </object>
          </child>
        </object>
      </child>
    </object>
  </interface>

To load it and use it do the following (assume above text is in $gui).

  my Gnome::Gtk3::Builder $builder .= new(:string($gui));
  my Gnome::Gtk3::Button $button .= new(:build-id<ok_button>));



=begin comment
Beyond this general structure, several object classes define their own XML DTD fragments for filling in the ANY placeholders in the DTD above. Note that a custom element in a <child> element gets parsed by the custom tag handler of the parent object, while a custom element in an <object> element gets parsed by the custom tag handler of the object.

These XML fragments are explained in the documentation of the respective objects.
=end comment

=begin comment
Additionally, since 3.10 a special <template> tag has been added to the format allowing one to define a widget class’s components. See the [B<Gnome::Gtk3::Widget> documentation](https://developer.gnome.org/gtk3/3.24/GtkWidget.html#composite-templates) for details.
=end comment


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Builder;
  also is Gnome::GObject::Object;


=head2 Uml Diagram

![](plantuml/Builder.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::Builder;

  unit class MyGuiClass;
  also is Gnome::Gtk3::Builder;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::Builder class process the options
    self.bless( :GtkBuilder, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment


=head2 Example

  my Gnome::Gtk3::Builder $builder .= new;
  my Gnome::Glib::Error $e = $builder.add-from-file($ui-file);
  die $e.message if $e.is-valid;

  my Gnome::Gtk3::Button .= new(:build-id<my-glade-button-id>);

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;

use Gnome::Glib::Error;
use Gnome::Glib::SList;

use Gnome::GObject::Object;
use Gnome::GObject::Type;

use Gnome::Gtk3::Application;

#-------------------------------------------------------------------------------
# /usr/include/gtk-3.0/gtk/INCLUDE
# https://developer.gnome.org/WWW
unit class Gnome::Gtk3::Builder:auth<github:MARTIMM>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GtkBuilderError

Error codes that identify various errors that can occur while using
B<Gnome::Gtk3::Builder>.


=item GTK_BUILDER_ERROR_INVALID_TYPE_FUNCTION: A type-func attribute didn’t name a function that returns a C<GType>.
=item GTK_BUILDER_ERROR_UNHANDLED_TAG: The input contained a tag that B<Gnome::Gtk3::Builder> can’t handle.
=item GTK_BUILDER_ERROR_MISSING_ATTRIBUTE: An attribute that is required by B<Gnome::Gtk3::Builder> was missing.
=item GTK_BUILDER_ERROR_INVALID_ATTRIBUTE: B<Gnome::Gtk3::Builder> found an attribute that it doesn’t understand.
=item GTK_BUILDER_ERROR_INVALID_TAG: B<Gnome::Gtk3::Builder> found a tag that it doesn’t understand.
=item GTK_BUILDER_ERROR_MISSING_PROPERTY_VALUE: A required property value was missing.
=item GTK_BUILDER_ERROR_INVALID_VALUE: B<Gnome::Gtk3::Builder> couldn’t parse some attribute value.
=item GTK_BUILDER_ERROR_VERSION_MISMATCH: The input file requires a newer version of GTK+.
=item GTK_BUILDER_ERROR_DUPLICATE_ID: An object id occurred twice.
=item GTK_BUILDER_ERROR_OBJECT_TYPE_REFUSED: A specified object type is of the same type or derived from the type of the composite class being extended with builder XML.
=item GTK_BUILDER_ERROR_TEMPLATE_MISMATCH: The wrong type was specified in a composite class’s template XML
=item GTK_BUILDER_ERROR_INVALID_PROPERTY: The specified property is unknown for the object class.
=item GTK_BUILDER_ERROR_INVALID_SIGNAL: The specified signal is unknown for the object class.
=item GTK_BUILDER_ERROR_INVALID_ID: An object id is unknown


=end pod

#TE:1:GtkBuilderError:
enum GtkBuilderError is export (
  'GTK_BUILDER_ERROR_INVALID_TYPE_FUNCTION',
  'GTK_BUILDER_ERROR_UNHANDLED_TAG',
  'GTK_BUILDER_ERROR_MISSING_ATTRIBUTE',
  'GTK_BUILDER_ERROR_INVALID_ATTRIBUTE',
  'GTK_BUILDER_ERROR_INVALID_TAG',
  'GTK_BUILDER_ERROR_MISSING_PROPERTY_VALUE',
  'GTK_BUILDER_ERROR_INVALID_VALUE',
  'GTK_BUILDER_ERROR_VERSION_MISMATCH',
  'GTK_BUILDER_ERROR_DUPLICATE_ID',
  'GTK_BUILDER_ERROR_OBJECT_TYPE_REFUSED',
  'GTK_BUILDER_ERROR_TEMPLATE_MISMATCH',
  'GTK_BUILDER_ERROR_INVALID_PROPERTY',
  'GTK_BUILDER_ERROR_INVALID_SIGNAL',
  'GTK_BUILDER_ERROR_INVALID_ID'
);

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=end pod

#-------------------------------------------------------------------------------
#`{{
void
(*GtkBuilderConnectFunc) (
  GtkBuilder *builder,
                          GObject *object,
                          const gchar *signal_name,
                          const gchar *handler_name,
                          GObject *connect_object,
                          GConnectFlags flags,
                          gpointer user_data);
}}

#-------------------------------------------------------------------------------
=begin pod
=head2 new
=head3 default, no options

Create an empty builder. This is only useful if you intend to make multiple calls to C<add-from-file()>, C<add-from-resource()> or C<add-from-string()> in order to merge multiple UI descriptions into a single builder.

Most users will probably want to use C<.new(:file)>, C<.new(:resource)> or C<.new(:string)>, particularly when there is only one file, resource or string.

  multi method new ( )


=head3 :file

Create builder object and load gui design. Builds the UI definition from a file. If there is an error opening the file or parsing the description then the program will be aborted. You should only ever attempt to parse user interface descriptions that are shipped as part of your program.

  multi method new ( Str :$file! )


=head3 :string

Same as above but read the design from the string. Builds the user interface described by I<$string> (in the UI definition format). If there is an error parsing I<string> then the program will be aborted. You should not attempt to parse user interface description from untrusted sources.

  multi method new ( Str :$string! )


=head3 :resource

The interface is build using the UI definition from the given resource path. If there is an error locating the resource or parsing the description, then the program will be aborted.

  multi method new ( Str :$resource! )

=head3 :native-object

Create a Builder object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=end pod

#TM:1:new():
#TM:0:new(:filename):
#TM:0:new(:string):
#TM:4:new(:resource):ex-application.pl6
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'Gnome::Gtk3::Builder';

  if self.is-valid { }

  # process all options

  # check if common options are handled by some parent
  elsif %options<native-object>:exists { }

  else {
    my $no;

    if ? %options<file> {
      $no = _gtk_builder_new_from_file(%options<file>);
    }

    elsif ? %options<string> {
      my Str $string = %options<string>;
      $no = _gtk_builder_new_from_string( $string, $string.chars);
    }

    elsif ? %options<resource> {
      $no = _gtk_builder_new_from_resource(%options<resource>);
    }

    # check if there are unknown options
    elsif %options.keys.elems {
      die X::Gnome.new(
        :message('Unsupported, undefined, incomplete or wrongly typed options for ' ~ self.^name ~
                 ': ' ~ %options.keys.join(', ')
                )
      );
    }

    ##`{{ when there are defaults use this instead
    # create default object
    else {
      $no = _gtk_builder_new();
    }
    #}}

    if ?$no {
      self._set-native-object($no);

      # TODO Temporary until version Gtk3 0.48.0 and GObject 0.20.0.
      # after that only call _set-builder()
      if self.^can('_set-builder') {
        self._set-builder(self);
      }

      else {
        self.set-builder(self);
      }
    }
  }

  # only after creating the native-object, the gtype is known
  self._set-class-info('GtkBuilder');
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method _fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::("gtk_builder_$native-sub"); }
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  self._set-class-name-of-sub('GtkBuilder');
  $s = callsame unless ?$s;

  $s;
}

#`{{
#-------------------------------------------------------------------------------
#TM:0:add-callback-symbol:
=begin pod
=head2 add-callback-symbol

Adds the I<callback-symbol> to the scope of I<builder> under the given I<callback-name>.

Using this function overrides the behavior of C<connect-signals()> for any callback symbols that are added. Using this method allows for better encapsulation as it does not require that callback symbols be declared in the global namespace.

  method add-callback-symbol ( Str $callback_name, GCallback $callback_symbol )

=item $callback_name; The name of the callback, as expected in the XML
=item $callback_symbol; (scope async): The callback pointer
=end pod

method add-callback-symbol ( Str $callback_name, GCallback $callback_symbol ) {

  gtk_builder_add_callback_symbol(
    self._get-native-object-no-reffing, $callback_name, $callback_symbol
  );
}

sub gtk_builder_add_callback_symbol (
  N-GObject $builder, gchar-ptr $callback_name, GCallback $callback_symbol
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:add-callback-symbols:
=begin pod
=head2 add-callback-symbols

A convenience function to add many callbacks instead of calling C<add-callback-symbol()> for each symbol.

  method add-callback-symbols ( Str $first_callback_name, GCallback $first_callback_symbol )

=item $first_callback_name; The name of the callback, as expected in the XML
=item $first_callback_symbol; (scope async): The callback pointer @...: A list of callback name and callback symbol pairs terminated with C<undefined>
=end pod

method add-callback-symbols ( Str $first_callback_name, GCallback $first_callback_symbol ) {

  gtk_builder_add_callback_symbols(
    self._get-native-object-no-reffing, $first_callback_name, $first_callback_symbol
  );
}

sub gtk_builder_add_callback_symbols (
  N-GObject $builder, gchar-ptr $first_callback_name, GCallback $first_callback_symbol, Any $any = Any
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:add-from-file:
=begin pod
=head2 add-from-file

Parses a file containing a [GtkBuilder UI definition][BUILDER-UI] and merges it with the current contents of I<builder>.

Most users will probably want to use C<new-from-file()>.

If an error occurs, 0 will be returned and I<error> will be assigned a B<Gnome::Gtk3::Error> from the B<Gnome::Gtk3::TK-BUILDER-ERROR>, B<Gnome::Gtk3::-MARKUP-ERROR> or B<Gnome::Gtk3::-FILE-ERROR> domain.

It’s not really reasonable to attempt to handle failures of this call. You should not use this function with untrusted files (ie: files that are not part of your application). Broken B<Gnome::Gtk3::Builder> files can easily crash your program, and it’s possible that memory was leaked leading up to the reported failure.

Returns: An invalid error object on success, Otherwise call C<.message()> on the error object to find out what went wrong.

  method add-from-file ( Str $filename --> Gnome::Glib::Error )

=item $filename; the name of the file to parse
=end pod

method add-from-file ( Str $filename --> Gnome::Glib::Error ) {
  my CArray[N-GError] $error .= new(N-GError);

  gtk_builder_add_from_file(
    self._get-native-object-no-reffing, $filename, $error
  );

  Gnome::Glib::Error.new(:native-object($error[0]))
}

sub gtk_builder_add_from_file (
  N-GObject $builder, gchar-ptr $filename, CArray[N-GError] $error --> guint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:add-from-resource:
=begin pod
=head2 add-from-resource

Parses a resource file containing a [GtkBuilder UI definition][BUILDER-UI] and merges it with the current contents of I<builder>.

Most users will probably want to use C<new-from-resource()>.

If an error occurs, 0 will be returned and I<error> will be assigned a B<Gnome::Gtk3::Error> from the B<Gnome::Gtk3::TK-BUILDER-ERROR>, B<Gnome::Gtk3::-MARKUP-ERROR> or B<Gnome::Gtk3::-RESOURCE-ERROR> domain.

It’s not really reasonable to attempt to handle failures of this call. The only reasonable thing to do when an error is detected is to call C<g-error()>.

Returns: An invalid error object on success, Otherwise call C<.message()> on the error object to find out what went wrong.

  method add-from-resource ( Str $resource_path --> Gnome::Glib::Error )

=item $resource_path; the path of the resource file to parse
=end pod

method add-from-resource ( Str $resource_path --> UInt ) {
  my CArray[N-GError] $error .= new(N-GError);

  gtk_builder_add_from_resource(
    self._get-native-object-no-reffing, $resource_path, $error
  );

  Gnome::Glib::Error.new(:native-object($error[0]))
}

sub gtk_builder_add_from_resource (
  N-GObject $builder, gchar-ptr $resource_path, CArray[N-GError] $error --> guint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:add-from-string:
=begin pod
=head2 add-from-string

Parses a string containing a [GtkBuilder UI definition][BUILDER-UI] and merges it with the current contents of I<builder>.

Most users will probably want to use C<new-from-string()>.

Upon errors 0 will be returned and I<error> will be assigned a B<Gnome::Gtk3::Error> from the B<Gnome::Gtk3::TK-BUILDER-ERROR>, B<Gnome::Gtk3::-MARKUP-ERROR> or B<Gnome::Gtk3::-VARIANT-PARSE-ERROR> domain.

It’s not really reasonable to attempt to handle failures of this call. The only reasonable thing to do when an error is detected is to call C<g-error()>.

Returns: An invalid error object on success, Otherwise call C<.message()> on the error object to find out what went wrong.

  method add-from-string ( Str $buffer --> Gnome::Glib::Error )

=item $buffer; the string to parse
=end pod

method add-from-string ( Str $buffer --> Gnome::Glib::Error ) {
  my CArray[N-GError] $error .= new(N-GError);

  gtk_builder_add_from_string(
    self._get-native-object-no-reffing, $buffer, $buffer.chars, $error
  );

  Gnome::Glib::Error.new(:native-object($error[0]))
}

sub gtk_builder_add_from_string (
  N-GObject $builder, gchar-ptr $buffer, gsize $length, CArray[N-GError] $error --> guint
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:add-objects-from-file:
=begin pod
=head2 add-objects-from-file

Parses a file containing a [GtkBuilder UI definition][BUILDER-UI] building only the requested objects and merges them with the current contents of I<builder>.

Upon errors 0 will be returned and I<error> will be assigned a B<Gnome::Gtk3::Error> from the B<Gnome::Gtk3::TK-BUILDER-ERROR>, B<Gnome::Gtk3::-MARKUP-ERROR> or B<Gnome::Gtk3::-FILE-ERROR> domain.

If you are adding an object that depends on an object that is not its child (for instance a B<Gnome::Gtk3::TreeView> that depends on its B<Gnome::Gtk3::TreeModel>), you have to explicitly list all of them in I<object-ids>.

Returns: A positive value on success, 0 if an error occurred

  method add-objects-from-file (
    Str $filename, CArray[Str] $object_ids, N-GError $error --> UInt )

=item $filename; the name of the file to parse
=item $object_ids;  (element-type utf8): nul-terminated array of objects to build
=item $error; return location for an error, or C<undefined>
=end pod

method add-objects-from-file (
  Str $filename, CArray[Str] $object_ids, $error --> UInt ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;

  gtk_builder_add_objects_from_file(
    self._get-native-object-no-reffing, $filename, $object_ids, $error
  )
}

sub gtk_builder_add_objects_from_file (
  N-GObject $builder, gchar-ptr $filename, gchar-pptr $object_ids, N-GError $error --> guint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-objects-from-resource:
=begin pod
=head2 add-objects-from-resource

Parses a resource file containing a [GtkBuilder UI definition][BUILDER-UI] building only the requested objects and merges them with the current contents of I<builder>.

Upon errors 0 will be returned and I<error> will be assigned a B<Gnome::Gtk3::Error> from the B<Gnome::Gtk3::TK-BUILDER-ERROR>, B<Gnome::Gtk3::-MARKUP-ERROR> or B<Gnome::Gtk3::-RESOURCE-ERROR> domain.

If you are adding an object that depends on an object that is not its child (for instance a B<Gnome::Gtk3::TreeView> that depends on its B<Gnome::Gtk3::TreeModel>), you have to explicitly list all of them in I<object-ids>.

Returns: A positive value on success, 0 if an error occurred

  method add-objects-from-resource (
    Str $resource_path, CArray[Str] $object_ids, N-GError $error
    --> UInt
  )

=item $resource_path; the path of the resource file to parse
=item $object_ids;  (element-type utf8): nul-terminated array of objects to build
=item $error; return location for an error, or C<undefined>
=end pod

method add-objects-from-resource ( Str $resource_path, CArray[Str] $object_ids, $error is copy --> UInt ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;

  gtk_builder_add_objects_from_resource(
    self._get-native-object-no-reffing, $resource_path, $object_ids, $error
  )
}

sub gtk_builder_add_objects_from_resource (
  N-GObject $builder, gchar-ptr $resource_path, gchar-pptr $object_ids, N-GError $error --> guint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:add-objects-from-string:
=begin pod
=head2 add-objects-from-string

Parses a string containing a [GtkBuilder UI definition][BUILDER-UI] building only the requested objects and merges them with the current contents of I<builder>.

Upon errors 0 will be returned and I<error> will be assigned a B<Gnome::Gtk3::Error> from the B<Gnome::Gtk3::TK-BUILDER-ERROR> or B<Gnome::Gtk3::-MARKUP-ERROR> domain.

If you are adding an object that depends on an object that is not its child (for instance a B<Gnome::Gtk3::TreeView> that depends on its B<Gnome::Gtk3::TreeModel>), you have to explicitly list all of them in I<object-ids>.

Returns: A positive value on success, 0 if an error occurred

  method add-objects-from-string ( Str $buffer, UInt $length, CArray[Str] $object_ids, N-GError $error --> UInt )

=item $buffer; the string to parse
=item $length; the length of I<buffer> (may be -1 if I<buffer> is nul-terminated)
=item $object_ids;  (element-type utf8): nul-terminated array of objects to build
=item $error; return location for an error, or C<undefined>
=end pod

method add-objects-from-string ( Str $buffer, UInt $length, CArray[Str] $object_ids, $error is copy --> UInt ) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;

  gtk_builder_add_objects_from_string(
    self._get-native-object-no-reffing, $buffer, $length, $object_ids, $error
  )
}

sub gtk_builder_add_objects_from_string (
  N-GObject $builder, gchar-ptr $buffer, gsize $length, gchar-pptr $object_ids, N-GError $error --> guint
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:connect-signals:
=begin pod
=head2 connect-signals

This method is a simpler variation of C<connect-signals-full()>. It uses symbols explicitly added to I<builder> with prior calls to C<gtk-builder-add-callback-symbol()>. In the case that symbols are not explicitly added; it uses B<Gnome::Gtk3::Module>’s introspective features (by opening the module C<undefined>) to look at the application’s symbol table. From here it tries to match the signal handler names given in the interface description with symbols in the application and connects the signals. Note that this function can only be called once, subsequent calls will do nothing.

Note that unless C<gtk-builder-add-callback-symbol()> is called for all signal callbacks which are referenced by the loaded XML, this function will require that B<Gnome::Gtk3::Module> be supported on the platform.

If you rely on B<Gnome::Gtk3::Module> support to lookup callbacks in the symbol table, the following details should be noted:

When compiling applications for Windows, you must declare signal callbacks with B<Gnome::Gtk3::-MODULE-EXPORT>, or they will not be put in the symbol table. On Linux and Unices, this is not necessary; applications should instead be compiled with the -Wl,--export-dynamic CFLAGS, and linked against gmodule-export-2.0.

  method connect-signals ( Pointer $user_data )

=item $user_data; user data to pass back with all signals
=end pod

method connect-signals ( Pointer $user_data ) {

  gtk_builder_connect_signals(
    self._get-native-object-no-reffing, $user_data
  );
}

sub gtk_builder_connect_signals (
  N-GObject $builder, gpointer $user_data
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:connect-signals-full:
=begin pod
=head2 connect-signals-full

This method will process the signal elements from the loaded XML and with the help of the provided $handlers table register each handler to a signal.

  method gtk_builder_connect_signals_full ( Hash $handlers )

=item $handlers; a table used to register handlers to process a signal. Each entry in this table has a key which is the name of the handler method. The value is a list of which the first element is the object wherin the method is defined. The rest of the list are optional named attributes and are provided to the method. See also C<register-signal()> in B<Gnome::GObject::Object>.

An example where a gui is described in XML. It has a Window with a Button, both having a signal description;

  my Str $ui = q:to/EOUI/;
      <?xml version="1.0" encoding="UTF-8"?>
      <interface>
        <requires lib="gtk+" version="3.20"/>

        <object class="GtkWindow" id="top">
          <property name="title">top window</property>
          <signal name="destroy" handler="window-quit"/>
          <child>
            <object class="GtkButton" id="help">
              <property name="label">Help</property>
              <signal name="clicked" handler="button-click"/>
            </object>
          </child>
        </object>
      </interface>
      EOUI

  # First handler class
  class X {
    method window-quit ( :$o1, :$o2 ) {
      # ... do something with options $o1 and $o2 ...

      Gnome::Gtk3::Main.new.gtk-main-quit;
    }
  }

  # Second handler class
  class Y {
    method button-click ( :$o3, :$o4 ) {
      # ... do something with options $o3 and $o4 ...
    }
  }

  # Load the user interface description
  my Gnome::Gtk3::Builder $builder .= new(:string($ui));
  my Gnome::Gtk3::Window $w .= new(:build-id<top>);

  # It is possible to devide the works over more than one class
  my X $x .= new;
  my Y $y .= new;

  # Create the handlers table
  my Hash $handlers = %(
    :window-quit( $x, :o1<o1>, :o2<o2>),
    :button-click( $y, :o3<o3>, :o4<o4>)
  );

  # Register all signals
  $builder.connect-signals-full($handlers);


=end pod

method connect-signals-full ( Hash $handlers ) {
  my $builder = self._get-native-object-no-reffing;
  gtk_builder_connect_signals_full(
    $builder,
    sub (
      N-GObject $builder, N-GObject $object, Str $signal-name,
      Str $handler-name, N-GObject $ignore-d0, int32 $ignore-d1,
      OpaquePointer $ignore-d2
    ) {
      my Str $oname = Gnome::GObject::Type.g_type_name_from_instance($object);
      if $oname ~~ /^ Gtk / and $handlers{$handler-name}:exists {
        $oname ~~ s/^ Gtk /Gnome::Gtk3::/;
        my $handler-object = $handlers{$handler-name}[0];
        my %options = %(|$handlers{$handler-name}[1..*-1]);

        require ::($oname);
        my $gtk-object = ::($oname).new(:native-object($object));
        note "Connect $oname, $handler-name for signal $signal-name"
          if $Gnome::N::x-debug;

        if $handler-object.^can("$handler-name") {
          $gtk-object.register-signal(
            $handler-object, $handler-name, $signal-name, |%options
          );
        }

        else {
          note "Signalhandler $handler-name for signal $signal-name not available" if $Gnome::N::x-debug;
        }
      }

      else {
        note "Cannot handle $oname typed objects. Signalhandler for signal $signal-name not activated" if $Gnome::N::x-debug;
      }
    },
    OpaquePointer
  )
}

sub gtk_builder_connect_signals_full (
  N-GObject $builder,
  Callable $func (
    N-GObject $b, N-GObject $object,
    Str $signal_name, Str $handler_name,
    N-GObject $connect_object, int32 $flags,
    OpaquePointer $d
  ),
  Pointer $user_data
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:error-quark:
=begin pod
=head2 error-quark

Return the domain code of the builder error domain.

  method error-quark ( --> UInt )

The following example shows the fields of a returned error when a faulty string is provided in the call.

  my Gnome::Glib::Quark $quark .= new;
  my Gnome::Glib::Error $e = $builder.add-from-string($text);
  is $e.domain, $builder.gtk_builder_error_quark(),
     "domain code: $e.domain()";
  is $quark.to-string($e.domain), 'gtk-builder-error-quark',
     "error domain: $quark.to-string($e.domain())";

=end pod

method error-quark ( --> UInt ) {
  gtk_builder_error_quark()
}

sub gtk_builder_error_quark (
   --> GQuark
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:expose-object:
=begin pod
=head2 expose-object

Add I<object> to the I<builder> object pool so it can be referenced just like any other object built by builder.

  method expose-object ( Str $name, N-GObject() $object )

=item $name; the name of the object exposed to the builder
=item $object; the object to expose
=end pod

method expose-object ( Str $name, N-GObject() $object ) {
  gtk_builder_expose_object(
    self._get-native-object-no-reffing, $name, $object
  );
}

sub gtk_builder_expose_object (
  N-GObject $builder, gchar-ptr $name, N-GObject $object
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:extend-with-template:
=begin pod
=head2 extend-with-template

Main private entry point for building composite container components from template XML.

This is exported purely to let gtk-builder-tool validate templates, applications have no need to call this function.

Returns: A positive value on success, 0 if an error occurred

  method extend-with-template (
    N-GObject() $widget, N-GObject() $template_type,
    Str $buffer, UInt $length, N-GError $error
    --> UInt
  )

=item $widget; the widget that is being extended
=item $template_type; the type that the template is for
=item $buffer; the string to parse
=item $length; the length of I<buffer> (may be -1 if I<buffer> is nul-terminated)
=item $error; return location for an error, or C<undefined>
=end pod

method extend-with-template (
  N-GObject() $widget, N-GObject() $template_type, Str $buffer, UInt $length,
  $error is copy --> UInt
) {
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;

  gtk_builder_extend_with_template(
    self._get-native-object-no-reffing, $widget, $template_type, $buffer,
    $length, $error
  )
}

sub gtk_builder_extend_with_template (
  N-GObject $builder, N-GObject $widget, N-GObject $template_type, gchar-ptr $buffer, gsize $length, N-GError $error --> guint
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:get-application:
=begin pod
=head2 get-application

Gets the B<Gnome::Gtk3::Application> associated with the builder.

The B<Gnome::Gtk3::Application> is used for creating action proxies as requested from XML that the builder is loading.

By default, the builder uses the default application: the one from C<g-application-get-default()>. If you want to use another application for constructing proxies, use C<set-application()>.

Returns: the application being used by the builder, or C<undefined>

  method get-application ( --> N-GObject )

=end pod

method get-application ( --> N-GObject ) {
  gtk_builder_get_application(self._get-native-object-no-reffing)
}

method get-application-rk ( --> Gnome::Gtk3::Application ) {
  Gnome::N::deprecate(
    'get-application-rk', 'coercing from get-application',
    '0.47.2', '0.50.0'
  );

  Gnome::Gtk3::Application.new(
    :native-object(
      gtk_builder_get_application(self._get-native-object-no-reffing)
    )
  )
}

sub gtk_builder_get_application (
  N-GObject $builder --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:get-object:
=begin pod
=head2 get-object

Gets the object named I<$name>. Note that this function does not increment the reference count of the returned object.

Returns: the object named I<$name> or C<undefined> if it could not be found in the object tree.

  method get-object ( Str $name --> N-GObject )

=item $name; name of object to get
=end pod

method get-object ( Str $name --> N-GObject ) {
  gtk_builder_get_object( self._get-native-object-no-reffing, $name)
}

method get-object-rk ( Str $name --> Any ) {
  Gnome::N::deprecate(
    'get-object-rk', 'coercing from get-object',
    '0.47.2', '0.50.0'
  );

  my N-GObject $no = gtk_builder_get_object(
    self._get-native-object-no-reffing, $name
  );

  self._wrap-native-type-from-no($no)
}

sub gtk_builder_get_object (
  N-GObject $builder, gchar-ptr $name --> N-GObject
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:get-objects:
=begin pod
=head2 get-objects

Gets all objects that have been constructed by I<builder>. Note that this function does not increment the reference counts of the returned objects.

Returns: (element-type GObject) (transfer container): a newly-allocated B<Gnome::Gtk3::SList> containing all the objects constructed by the B<Gnome::Gtk3::Builder> instance. It should be freed by C<g-slist-free()>

  method get-objects ( --> Gnome::Glib::SList )

=end pod

method get-objects ( --> Gnome::Glib::SList ) {
  Gnome::Glib::SList.new(:native-object(
      gtk_builder_get_objects(self._get-native-object-no-reffing)
    )
  )
}

sub gtk_builder_get_objects (
  N-GObject $builder --> N-GSList
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:get-translation-domain:
=begin pod
=head2 get-translation-domain

Gets the translation domain of I<builder>.

Returns: the translation domain. This string is owned by the builder object and must not be modified or freed.

  method get-translation-domain ( --> Str )

=end pod

method get-translation-domain ( --> Str ) {

  gtk_builder_get_translation_domain(
    self._get-native-object-no-reffing,
  )
}

sub gtk_builder_get_translation_domain (
  N-GObject $builder --> gchar-ptr
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:get-type-from-name:
=begin pod
=head2 get-type-from-name

Looks up a type by name, using the virtual function that B<Gnome::Gtk3::Builder> has for that purpose. This is mainly used when implementing the B<Gnome::Gtk3::Buildable> interface on a type.

Returns: the B<Gnome::Gtk3::Type> found for I<$type-name> or B<Gnome::Gtk3::-TYPE-INVALID> if no type was found

  method get-type-from-name ( Str $type-name --> UInt )

=item $type_name; type name to lookup
=end pod

method get-type-from-name ( Str $type-name --> UInt ) {
  gtk_builder_get_type_from_name(
    self._get-native-object-no-reffing, $type-name
  )
}

sub gtk_builder_get_type_from_name (
  N-GObject $builder, gchar-ptr $type-name --> GType
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:lookup-callback-symbol:
=begin pod
=head2 lookup-callback-symbol

Fetches a symbol previously added to I<builder> with C<add-callback-symbols()>

This function is intended for possible use in language bindings or for any case that one might be cusomizing signal connections using C<gtk-builder-connect-signals-full()>

Returns: The callback symbol in I<builder> for I<callback-name>, or C<undefined>

  method lookup-callback-symbol ( Str $callback_name --> GCallback )

=item $callback_name; The name of the callback
=end pod

method lookup-callback-symbol ( Str $callback_name --> GCallback ) {

  gtk_builder_lookup_callback_symbol(
    self._get-native-object-no-reffing, $callback_name
  )
}

sub gtk_builder_lookup_callback_symbol (
  N-GObject $builder, gchar-ptr $callback_name --> GCallback
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#`{{ A piece of C code to add id to objects
static inline void
object_set_name (GObject     *object,
                 const gchar *name)
{
  if (GTK_IS_BUILDABLE (object))
    gtk_buildable_set_name (GTK_BUILDABLE (object), name);
  else
    g_object_set_data_full (object, "gtk-builder-name", g_strdup (name), g_free);
}
}}

method object-set-name ( $object is copy, Str:D $name ) {

  my $rk-object;
  if $object ~~ N-GObject {
    $rk-object = self._wrap-native-type-from-no($object);
  }

  else {
    $rk-object = $object;
    $object .= _get-native-object-no-reffing;
  }

  my Gnome::GObject::Type $t .= new;
  my Int $buildable-type = $t.from-name('GtkBuildable');
  if $t.check-instance-is-a( $object, $buildable-type) {
    $rk-object.buildable-set-name($name);
  }

  else {
    my $rk-object = self._wrap-native-type-from-no($object);
    $rk-object.set-data( 'gtk-builder-name', $name);
  }
#  _gtk_builder_add_object( self._get-native-object-no-reffing, $name, $object);
}
#`{{
sub _gtk_builder_add_object (
  N-GObject $builder, Str $id, N-GObject $object
) is native(&gtk-lib)
  { * }
}}
}}

#-------------------------------------------------------------------------------
#TM:0:set-application:
=begin pod
=head2 set-application

Sets the application associated with I<builder>.

You only need this function if there is more than one B<Gnome::Gtk3::Application> in your process. I<$application> cannot be C<undefined>.

  method set-application ( N-GObject() $application )

=item $application; a B<Gnome::Gtk3::Application>
=end pod

method set-application ( N-GObject() $application ) {
  gtk_builder_set_application(
    self._get-native-object-no-reffing, $application
  );
}

sub gtk_builder_set_application (
  N-GObject $builder, N-GObject $application
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-translation-domain:
=begin pod
=head2 set-translation-domain

Sets the translation domain of I<builder>. See  I<translation-domain>.

  method set-translation-domain ( Str $domain )

=item $domain; the translation domain or C<undefined>
=end pod

method set-translation-domain ( Str $domain ) {
  gtk_builder_set_translation_domain(
    self._get-native-object-no-reffing, $domain
  );
}

sub gtk_builder_set_translation_domain (
  N-GObject $builder, gchar-ptr $domain
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
#TM:0:value-from-string:
=begin pod
=head2 value-from-string

This function demarshals a value from a string. This function calls C<g-value-init()> on the I<value> argument, so it need not be initialised beforehand.

This function can handle char, uchar, boolean, int, uint, long, ulong, enum, flags, float, double, string, B<Gnome::Gtk3::Color>, B<Gnome::Gtk3::RGBA> and B<Gnome::Gtk3::Adjustment> type values. Support for B<Gnome::Gtk3::Widget> type values is still to come.

Upon errors C<False> will be returned and I<error> will be assigned a B<Gnome::Gtk3::Error> from the B<Gnome::Gtk3::TK-BUILDER-ERROR> domain.

Returns: C<True> on success

  method value-from-string ( GParamSpec $pspec, Str $string, N-GObject $value, N-GError $error --> Bool )

=item $pspec; the B<Gnome::Gtk3::ParamSpec> for the property
=item $string; the string representation of the value
=item $value; the B<Gnome::Gtk3::Value> to store the result in
=item $error; return location for an error, or C<undefined>
=end pod

method value-from-string ( GParamSpec $pspec, Str $string, $value is copy, $error is copy --> Bool ) {
  $value .= _get-native-object-no-reffing unless $value ~~ N-GObject;
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;

  gtk_builder_value_from_string(
    self._get-native-object-no-reffing, $pspec, $string, $value, $error
  ).Bool
}

sub gtk_builder_value_from_string (
  N-GObject $builder, GParamSpec $pspec, gchar-ptr $string, N-GObject $value, N-GError $error --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:value-from-string-type:
=begin pod
=head2 value-from-string-type

Like C<value-from-string()>, this function demarshals a value from a string, but takes a B<Gnome::Gtk3::Type> instead of B<Gnome::Gtk3::ParamSpec>. This function calls C<g-value-init()> on the I<value> argument, so it need not be initialised beforehand.

Upon errors C<False> will be returned and I<error> will be assigned a B<Gnome::Gtk3::Error> from the B<Gnome::Gtk3::TK-BUILDER-ERROR> domain.

Returns: C<True> on success

  method value-from-string-type ( N-GObject $type, Str $string, N-GObject $value, N-GError $error --> Bool )

=item $type; the B<Gnome::Gtk3::Type> of the value
=item $string; the string representation of the value
=item $value; the B<Gnome::Gtk3::Value> to store the result in
=item $error; return location for an error, or C<undefined>
=end pod

method value-from-string-type ( $type is copy, Str $string, $value is copy, $error is copy --> Bool ) {
  $type .= _get-native-object-no-reffing unless $type ~~ N-GObject;
  $value .= _get-native-object-no-reffing unless $value ~~ N-GObject;
  $error .= _get-native-object-no-reffing unless $error ~~ N-GError;

  gtk_builder_value_from_string_type(
    self._get-native-object-no-reffing, $type, $string, $value, $error
  ).Bool
}

sub gtk_builder_value_from_string_type (
  N-GObject $builder, N-GObject $type, gchar-ptr $string, N-GObject $value, N-GError $error --> gboolean
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_builder_new:
#`{{
=begin pod
=head2 _gtk_builder_new

Creates a new empty builder object.

This function is only useful if you intend to make multiple calls to C<add-from-file()>, C<gtk-builder-add-from-resource()> or C<gtk-builder-add-from-string()> in order to merge multiple UI descriptions into a single builder.

Most users will probably want to use C<gtk-builder-new-from-file()>, C<gtk-builder-new-from-resource()> or C<gtk-builder-new-from-string()>.

Returns: a new (empty) B<Gnome::Gtk3::Builder> object

  method _gtk_builder_new ( --> N-GObject )

=end pod
}}

sub _gtk_builder_new ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_builder_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_builder_new_from_file:
#`{{
=begin pod
=head2 _gtk_builder_new_from_file

Builds the [GtkBuilder UI definition][BUILDER-UI] in the file I<filename>.

If there is an error opening the file or parsing the description then the program will be aborted. You should only ever attempt to parse user interface descriptions that are shipped as part of your program.

Returns: a B<Gnome::Gtk3::Builder> containing the described interface

  method _gtk_builder_new_from_file ( Str $filename --> N-GObject )

=item $filename; filename of user interface description file
=end pod
}}

sub _gtk_builder_new_from_file ( gchar-ptr $filename --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_builder_new_from_file')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_builder_new_from_resource:
#`{{
=begin pod
=head2 _gtk_builder_new_from_resource

Builds the [GtkBuilder UI definition][BUILDER-UI] at I<resource-path>.

If there is an error locating the resource or parsing the description, then the program will be aborted.

Returns: a B<Gnome::Gtk3::Builder> containing the described interface

  method _gtk_builder_new_from_resource ( Str $resource_path --> N-GObject )

=item $resource_path; a B<Gnome::Gtk3::Resource> resource path
=end pod
}}

sub _gtk_builder_new_from_resource ( gchar-ptr $resource_path --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_builder_new_from_resource')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_builder_new_from_string:
#`{{
=begin pod
=head2 _gtk_builder_new_from_string

Builds the user interface described by I<string> (in the [GtkBuilder UI definition][BUILDER-UI] format).

If I<string> is C<undefined>-terminated, then I<length> should be -1. If I<length> is not -1, then it is the length of I<string>.

If there is an error parsing I<string> then the program will be aborted. You should not attempt to parse user interface description from untrusted sources.

Returns: a B<Gnome::Gtk3::Builder> containing the interface described by I<string>

  method _gtk_builder_new_from_string ( Str $string, Int() $length --> N-GObject )

=item $string; a user interface (XML) description
=item $length; the length of I<string>, or -1
=end pod
}}

sub _gtk_builder_new_from_string ( gchar-ptr $string, gssize $length --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_builder_new_from_string')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<.set-text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.get-property( 'label', $gv);
  $gv.set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:0:translation-domain:
=head3 Translation Domain: translation-domain

The translation domain used when translating property values that have been marked as translatable in interface descriptions. If the translation domain is C<undefined>, B<Gnome::Gtk3::Builder> uses C<gettext()>, otherwise C<g-dgettext()>.

The B<Gnome::GObject::Value> type of property I<translation-domain> is C<G_TYPE_STRING>.
=end pod








=finish
#-------------------------------------------------------------------------------
#TM:1:gtk_builder_error_quark:
=begin pod
=head2 [[gtk_] builder_] error_quark

Return the domain code of the builder error domain.

  method gtk_builder_error_quark ( --> Int )

The following example shows the fields of a returned error when a faulty string is provided in the call.

  my Gnome::Glib::Quark $quark .= new;
  my Gnome::Glib::Error $e = $builder.add-from-string($text);
  is $e.domain, $builder.gtk_builder_error_quark(),
     "domain code: $e.domain()";
  is $quark.to-string($e.domain), 'gtk-builder-error-quark',
     "error domain: $quark.to-string($e.domain())";

=end pod

sub gtk_builder_error_quark (  )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:_gtk_builder_new:new()
#`{{
=begin pod
=head2 [gtk_] builder_new

Creates a new empty builder object.

This function is only useful if you intend to make multiple calls to C<gtk_builder_add_from_file()>, C<gtk_builder_add_from_resource()> or C<gtk_builder_add_from_string()> in order to merge multiple UI descriptions into a single builder.

Most users will probably want to use C<gtk_builder_new_from_file()>, C<gtk_builder_new_from_resource()> or C<gtk_builder_new_from_string()>.

Returns: a new (empty) B<Gnome::Gtk3::Builder> object

  method gtk_builder_new ( --> N-GObject  )

=end pod
}}
sub _gtk_builder_new (  )
  returns N-GObject
  is native(&gtk-lib)
  is symbol('gtk_builder_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:gtk_builder_add_from_file:
=begin pod
=head2 [[gtk_] builder_] add_from_file

Parses a file containing a UI definition and merges it with the current contents of I<builder>.

Most users will probably want to use C<.new(:file)>.

If an error occurs, a valid Gnome::Glib::Error object is returned with an error domain of C<GTK_BUILDER_ERROR>, C<G_MARKUP_ERROR> or C<G_FILE_ERROR>.

You should not use this function with untrusted files (ie: files that are not part of your application). Broken B<Gnome::Gtk3::Builder> files can easily crash your program, and it’s possible that memory was leaked leading up to the reported failure. The only reasonable thing to do when an error is detected is to throw an Exception when necessary.

Returns: Gnome::Glib::Error. Test C<.is-valid()> of that object to see if there was an error.

  method gtk_builder_add_from_file (
    Str $filename, N-GObject $error
    --> Gnome::Glib::Error
  )

=item $filename; the name of the file to parse

=end pod

sub gtk_builder_add_from_file (
  N-GObject $builder, Str $filename
  --> Gnome::Glib::Error
) {
  my CArray[N-GError] $ga .= new(N-GError);
  _gtk_builder_add_from_file( $builder, $filename, $ga);
  Gnome::Glib::Error.new(:native-object($ga[0]))
}

sub _gtk_builder_add_from_file (
  N-GObject $builder, Str $filename, CArray[N-GError] $error
) returns uint32
  is native(&gtk-lib)
  is symbol('gtk_builder_add_from_file')
  { * }

#-------------------------------------------------------------------------------
#TM:4:gtk_builder_add_from_resource:ex-application.pl6
=begin pod
=head2 [[gtk_] builder_] add_from_resource

Parses a resource file containing a UI definition and merges it with the current contents of I<builder>.

Most users will probably want to use C<.new(:resource)>.

If an error occurs, a valid Gnome::Glib::Error object is returned with an error domain of C<GTK_BUILDER_ERROR>, C<G_MARKUP_ERROR> or C<G_FILE_ERROR>. The only reasonable thing to do when an error is detected is to throw an Exception when necessary.

Returns: Gnome::Glib::Error. Test C<.is-valid()> to see if there was an error.

  method gtk_builder_add_from_resource (
    Str $resource_path
    --> Gnome::Glib::Error
  )

=item $resource_path; the path of the resource file to parse
=item $error; (allow-none): return location for an error, or C<Any>

=end pod

sub gtk_builder_add_from_resource (
  N-GObject $builder, Str $path
  --> Gnome::Glib::Error
) {
  my CArray[N-GError] $ga .= new(N-GError);
  _gtk_builder_add_from_resource( $builder, $path, $ga);
  Gnome::Glib::Error.new(:native-object($ga[0]))
}

sub _gtk_builder_add_from_resource (
  N-GObject $builder, Str $resource_path, CArray[N-GError] $error
  --> int32
) is native(&gtk-lib)
  is symbol('gtk_builder_add_from_resource')
  { * }


#-------------------------------------------------------------------------------
#TM:1:gtk_builder_add_from_string:
=begin pod
=head2 [[gtk_] builder_] add_from_string

Parses a string containing a UI definition and merges it with the current contents of I<builder>.

Most users will probably want to use C<.new(:string)>.

If an error occurs, a valid Gnome::Glib::Error object is returned with an error domain of C<GTK_BUILDER_ERROR>, C<G_MARKUP_ERROR> or C<G_FILE_ERROR>. The only reasonable thing to do when an error is detected is to throw an Exception when necessary.

Returns: Gnome::Glib::Error. Test C<.is-valid()> to see if there was an error.

  method gtk_builder_add_from_string ( Str $buffer --> N-GObject $error )

=item $buffer; the string to parse

=end pod

sub gtk_builder_add_from_string (
  N-GObject $builder, Str $buffer
  --> Gnome::Glib::Error
) {
  my CArray[N-GError] $ga .= new(N-GError);
  _gtk_builder_add_from_string(
    $builder, $buffer, $buffer.encode.bytes #`{{$buffer.chars}}, $ga
  );
  Gnome::Glib::Error.new(:native-object($ga[0]));
}

sub _gtk_builder_add_from_string (
  N-GObject $builder, Str $buffer, int64 $length, CArray[N-GError] $error
) returns uint32
  is native(&gtk-lib)
  is symbol('gtk_builder_add_from_string')
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] builder_] add_objects_from_file

Parses a file containing a [B<Gnome::Gtk3::Builder> UI definition]
building only the requested objects and merges
them with the current contents of I<builder>.

If you are adding an object that depends on an object that is not
its child (for instance a B<Gnome::Gtk3::TreeView> that depends on its
B<Gnome::Gtk3::TreeModel>), you have to explicitly list all of them in I<object_ids>.

If an error occurs, a valid Gnome::Glib::Error object is returned with an error domain of C<GTK_BUILDER_ERROR>, C<G_MARKUP_ERROR> or C<G_FILE_ERROR>. The only reasonable thing to do when an error is detected is to throw an Exception when necessary.

Returns: Gnome::Glib::Error. Test C<.is-valid()> flag to see if there was an error.

  method gtk_builder_add_objects_from_file ( Str $filename, CArray[Str] $object_ids, N-GObject $error --> UInt  )

=item $filename; the name of the file to parse
=item $object_ids; (array zero-terminated=1) (element-type utf8): nul-terminated array of objects to build
=item $error; (allow-none): return location for an error, or C<Any>

=end pod

sub gtk_builder_add_objects_from_file ( N-GObject $builder, Str $filename, CArray[Str] $object_ids, N-GObject $error )
  returns uint32
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] builder_] add_objects_from_resource

Parses a resource file containing a [B<Gnome::Gtk3::Builder> UI definition](https://developer.gnome.org/gtk3/3.24/GtkBuilder.html#BUILDER-UI)
building only the requested objects and merges
them with the current contents of I<builder>.

Upon errors 0 will be returned and I<error> will be assigned a
C<GError> from the C<GTK_BUILDER_ERROR>, C<G_MARKUP_ERROR> or C<G_RESOURCE_ERROR>
domain.

If you are adding an object that depends on an object that is not
its child (for instance a B<Gnome::Gtk3::TreeView> that depends on its
B<Gnome::Gtk3::TreeModel>), you have to explicitly list all of them in I<object_ids>.

Returns: A positive value on success, 0 if an error occurred

  method gtk_builder_add_objects_from_resource ( Str $resource_path, CArray[Str] $object_ids, N-GObject $error --> UInt  )

=item $resource_path; the path of the resource file to parse
=item $object_ids; (array zero-terminated=1) (element-type utf8): nul-terminated array of objects to build
=item $error; (allow-none): return location for an error, or C<Any>

=end pod

sub gtk_builder_add_objects_from_resource ( N-GObject $builder, Str $resource_path, CArray[Str] $object_ids, N-GObject $error )
  returns uint32
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] builder_] add_objects_from_string

Parses a string containing a [B<Gnome::Gtk3::Builder> UI definition](https://developer.gnome.org/gtk3/3.24/GtkBuilder.html#BUILDER-UI)
building only the requested objects and merges
them with the current contents of I<builder>.

Upon errors 0 will be returned and I<error> will be assigned a
C<GError> from the C<GTK_BUILDER_ERROR> or C<G_MARKUP_ERROR> domain.

If you are adding an object that depends on an object that is not
its child (for instance a B<Gnome::Gtk3::TreeView> that depends on its
B<Gnome::Gtk3::TreeModel>), you have to explicitly list all of them in I<object_ids>.

Returns: A positive value on success, 0 if an error occurred

  method gtk_builder_add_objects_from_string ( Str $buffer, UInt $length, CArray[Str] $object_ids, N-GObject $error --> UInt  )

=item $buffer; the string to parse
=item $length; the length of I<buffer> (may be -1 if I<buffer> is nul-terminated)
=item $object_ids; (array zero-terminated=1) (element-type utf8): nul-terminated array of objects to build
=item $error; (allow-none): return location for an error, or C<Any>

=end pod

sub gtk_builder_add_objects_from_string ( N-GObject $builder, Str $buffer, uint64 $length, CArray[Str] $object_ids, N-GObject $error )
  returns uint32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:3:gtk_builder_get_object:
=begin pod
=head2 [[gtk_] builder_] get_object

Gets the object named I<$name>. Note that this function does not increment the reference count of the returned object.

Returns: the object named I<$name> or undefined if it could not be found in the object tree.

  method gtk_builder_get_object ( Str $name --> N-GObject  )

=item $name; name of object to get

=end pod

sub gtk_builder_get_object ( N-GObject $builder, Str $name )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] builder_] get_objects

Gets all objects that have been constructed by I<builder>. Note that
this function does not increment the reference counts of the returned
objects.

Returns: (element-type GObject) (transfer container): a newly-allocated C<GSList> containing all the objects
constructed by the B<Gnome::Gtk3::Builder> instance. It should be freed by
C<g_slist_free()>

  method gtk_builder_get_objects ( --> N-GObject  )


=end pod

sub gtk_builder_get_objects ( N-GObject $builder )
  returns N-GObject
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] builder_] expose_object

Add I<object> to the I<builder> object pool so it can be referenced just like any
other object built by builder.

  method gtk_builder_expose_object ( Str $name, N-GObject $object )

=item $name; the name of the object exposed to the builder
=item $object; the object to expose

=end pod

sub gtk_builder_expose_object ( N-GObject $builder, Str $name, N-GObject $object )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] builder_] connect_signals

This method is a simpler variation of C<gtk_builder_connect_signals_full()>.
It uses symbols explicitly added to I<builder> with prior calls to
C<gtk_builder_add_callback_symbol()>. In the case that symbols are not
explicitly added; it uses C<GModule>’s introspective features (by opening the module C<Any>)
to look at the application’s symbol table. From here it tries to match
the signal handler names given in the interface description with
symbols in the application and connects the signals. Note that this
function can only be called once, subsequent calls will do nothing.

Note that unless C<gtk_builder_add_callback_symbol()> is called for
all signal callbacks which are referenced by the loaded XML, this
function will require that C<GModule> be supported on the platform.

If you rely on C<GModule> support to lookup callbacks in the symbol table,
the following details should be noted:

When compiling applications for Windows, you must declare signal callbacks
with C<G_MODULE_EXPORT>, or they will not be put in the symbol table.
On Linux and Unices, this is not necessary; applications should instead
be compiled with the -Wl,--export-dynamic CFLAGS, and linked against
gmodule-export-2.0.

  method gtk_builder_connect_signals ( Pointer $user_data )

=item $user_data; user data to pass back with all signals

=end pod

sub gtk_builder_connect_signals ( N-GObject $builder, Pointer $user_data )
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_builder_connect_signals_full:
=begin pod
=head2 [[gtk_] builder_] connect_signals_full

This method will process the signal elements from the loaded XML and with the help of the provided $handlers table register each handler to a signal.

  method gtk_builder_connect_signals_full ( Hash $handlers )

=item $handlers; a table used to register handlers to process a signal. Each entry in this table has a key which is the name of the handler method. The value is a list of which the first element is the object wherin the method is defined. The rest of the list are optional named attributes and are provided to the method. See also C<register-signal()> in B<Gnome::GObject::Object>.

An example where a gui is described in XML. It has a Window with a Button, both having a signal description;

  my Str $ui = q:to/EOUI/;
      <?xml version="1.0" encoding="UTF-8"?>
      <interface>
        <requires lib="gtk+" version="3.20"/>

        <object class="GtkWindow" id="top">
          <property name="title">top window</property>
          <signal name="destroy" handler="window-quit"/>
          <child>
            <object class="GtkButton" id="help">
              <property name="label">Help</property>
              <signal name="clicked" handler="button-click"/>
            </object>
          </child>
        </object>
      </interface>
      EOUI

  # First handler class
  class X {
    method window-quit ( :$o1, :$o2 ) {
      # ... do something with options $o1 and $o2 ...

      Gnome::Gtk3::Main.new.gtk-main-quit;
    }
  }

  # Second handler class
  class Y {
    method button-click ( :$o3, :$o4 ) {
      # ... do something with options $o3 and $o4 ...
    }
  }

  # Load the user interface description
  my Gnome::Gtk3::Builder $builder .= new(:string($ui));
  my Gnome::Gtk3::Window $w .= new(:build-id<top>);

  # It is possible to devide the works over more than one class
  my X $x .= new;
  my Y $y .= new;

  # Create the handlers table
  my Hash $handlers = %(
    :window-quit( $x, :o1<o1>, :o2<o2>),
    :button-click( $y, :o3<o3>, :o4<o4>)
  );

  # Register all signals
  $builder.connect-signals-full($handlers);


=end pod

sub gtk_builder_connect_signals_full ( N-GObject $builder, Hash $handlers ) {
  _gtk_builder_connect_signals_full(
    $builder,
    sub (
      N-GObject $builder, N-GObject $object, Str $signal-name,
      Str $handler-name, N-GObject $ignore-d0, int32 $ignore-d1,
      OpaquePointer $ignore-d2
    ) {
      my Str $oname = Gnome::GObject::Type.g_type_name_from_instance($object);
      if $oname ~~ /^ Gtk / and $handlers{$handler-name}:exists {
        $oname ~~ s/^ Gtk /Gnome::Gtk3::/;
        my $handler-object = $handlers{$handler-name}[0];
        my %options = %(|$handlers{$handler-name}[1..*-1]);

        require ::($oname);
        my $gtk-object = ::($oname).new(:native-object($object));
        note "Connect $oname, $handler-name for signal $signal-name"
          if $Gnome::N::x-debug;

        if $handler-object.^can("$handler-name") {
          $gtk-object.register-signal(
            $handler-object, $handler-name, $signal-name, |%options
          );
        }

        else {
          note "Signalhandler $handler-name for signal $signal-name not available" if $Gnome::N::x-debug;
        }
      }

      else {
        note "Cannot handle $oname typed objects. Signalhandler for signal $signal-name not activated" if $Gnome::N::x-debug;
      }
    },
    OpaquePointer
  )
}

sub _gtk_builder_connect_signals_full (
  N-GObject $builder,
  Callable $func (
    N-GObject $b, N-GObject $object,
    Str $signal_name, Str $handler_name,
    N-GObject $connect_object, int32 $flags,
    OpaquePointer $d
  ),
  Pointer $user_data
) is symbol('gtk_builder_connect_signals_full')
  is native(&gtk-lib)
  { * }
#}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] builder_] set_translation_domain

Sets the translation domain of I<builder>.
See prop C<translation-domain>.

  method gtk_builder_set_translation_domain ( Str $domain )

=item $domain; (allow-none): the translation domain or C<Any>

=end pod

sub gtk_builder_set_translation_domain ( N-GObject $builder, Str $domain )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] builder_] get_translation_domain

Gets the translation domain of I<builder>.

Returns: the translation domain. This string is owned
by the builder object and must not be modified or freed.

  method gtk_builder_get_translation_domain ( --> Str  )


=end pod

sub gtk_builder_get_translation_domain ( N-GObject $builder )
  returns Str
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_builder_get_type_from_name:
=begin pod
=head2 [[gtk_] builder_] get_type_from_name

Looks up a type by name, using the virtual function that
B<Gnome::Gtk3::Builder> has for that purpose. This is mainly used when
implementing the B<Gnome::Gtk3::Buildable> interface on a type.

Returns: the C<GType> found for I<type_name> or C<G_TYPE_INVALID>
if no type was found

  method gtk_builder_get_type_from_name ( Str $type_name --> UInt  )

=item $type_name; type name to lookup

=end pod

sub gtk_builder_get_type_from_name ( N-GObject $builder, Str $type_name )
  returns uint64
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] builder_] value_from_string

This function demarshals a value from a string. This function
calls C<g_value_init()> on the I<value> argument, so it need not be
initialised beforehand.

This function can handle char, uchar, boolean, int, uint, long,
ulong, enum, flags, float, double, string, B<Gnome::Gdk3::Color>, B<Gnome::Gdk3::RGBA> and
B<Gnome::Gtk3::Adjustment> type values. Support for B<Gnome::Gtk3::Widget> type values is
still to come.

Upon errors C<0> will be returned and I<error> will be assigned a
C<GError> from the C<GTK_BUILDER_ERROR> domain.

Returns: C<1> on success

  method gtk_builder_value_from_string ( GParamSpec $pspec, Str $string, N-GObject $value, N-GObject $error --> Int  )

=item $pspec; the C<GParamSpec> for the property
=item $string; the string representation of the value
=item $value; (out): the C<GValue> to store the result in
=item $error; (allow-none): return location for an error, or C<Any>

=end pod

sub gtk_builder_value_from_string ( N-GObject $builder, GParamSpec $pspec, Str $string, N-GObject $value, N-GObject $error )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] builder_] value_from_string_type

Like C<gtk_builder_value_from_string()>, this function demarshals
a value from a string, but takes a C<GType> instead of C<GParamSpec>.
This function calls C<g_value_init()> on the I<value> argument, so it
need not be initialised beforehand.

Upon errors C<0> will be returned and I<error> will be assigned a
C<GError> from the C<GTK_BUILDER_ERROR> domain.

Returns: C<1> on success

  method gtk_builder_value_from_string_type ( N-GObject $type, Str $string, N-GObject $value, N-GObject $error --> Int  )

=item $type; the C<GType> of the value
=item $string; the string representation of the value
=item $value; (out): the C<GValue> to store the result in
=item $error; (allow-none): return location for an error, or C<Any>

=end pod

sub gtk_builder_value_from_string_type ( N-GObject $builder, N-GObject $type, Str $string, N-GObject $value, N-GObject $error )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:_gtk_builder_new_from_file:
#`{{
=begin pod
=head2 [[gtk_] builder_] new_from_file

Builds the [B<Gnome::Gtk3::Builder> UI definition](https://developer.gnome.org/gtk3/3.24/GtkBuilder.html#BUILDER-UI) in the file I<filename>.

If there is an error opening the file or parsing the description then
the program will be aborted.  You should only ever attempt to parse
user interface descriptions that are shipped as part of your program.

Returns: a B<Gnome::Gtk3::Builder> containing the described interface

  method gtk_builder_new_from_file ( Str $filename --> N-GObject  )

=item $filename; filename of user interface description file

=end pod
}}
sub _gtk_builder_new_from_file ( Str $filename )
  returns N-GObject
  is symbol('gtk_builder_new_from_file')
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:_gtk_builder_new_from_resource:ex-application.pl6
#`{{
=begin pod
=head2 [[gtk_] builder_] new_from_resource

Builds the [B<Gnome::Gtk3::Builder> UI definition](https://developer.gnome.org/gtk3/3.24/GtkBuilder.html#BUILDER-UI) at I<resource_path>.

If there is an error locating the resource or parsing the description, then the program will be aborted.

Returns: a B<Gnome::Gtk3::Builder> containing the described interface

  method gtk_builder_new_from_resource ( Str $resource_path --> N-GObject )

=item $resource_path; a C<GResource> resource path

=end pod
}}
sub _gtk_builder_new_from_resource ( Str $resource_path )
  returns N-GObject
  is native(&gtk-lib)
  is symbol('gtk_builder_new_from_resource')
  { * }


#-------------------------------------------------------------------------------
#TM:1:_gtk_builder_new_from_string:
#`{{
=begin pod
=head2 [[gtk_] builder_] new_from_string

Builds the user interface described by I<string> (in the [B<Gnome::Gtk3::Builder> UI definition](https://developer.gnome.org/gtk3/3.24/GtkBuilder.html#BUILDER-UI) format).

If I<string> is C<Any>-terminated, then I<length> should be -1.
If I<length> is not -1, then it is the length of I<string>.

If there is an error parsing I<string> then the program will be
aborted. You should not attempt to parse user interface description
from untrusted sources.

Returns: a B<Gnome::Gtk3::Builder> containing the interface described by I<string>

  method gtk_builder_new_from_string ( Str $string, Int $length --> N-GObject  )

=item $string; a user interface (XML) description
=item $length; the length of I<string>, or -1

=end pod
}}

sub _gtk_builder_new_from_string (
  Str $string, Int $length? --> N-GObject
) {

  Gnome::N::deprecate(
    '.gtk_builder_new_from_string( $string, $length)',
    '.gtk_builder_new_from_string($string)', '0.27.4', '0.35.0'
  ) if $length.defined;

  __gtk_builder_new_from_string( $string, $string.chars)
}

sub __gtk_builder_new_from_string ( Str $string, int64 $length --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_builder_new_from_string')
  { * }

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] builder_] add_callback_symbol

Adds the I<callback_symbol> to the scope of I<builder> under the given I<callback_name>.

Using this function overrides the behavior of C<gtk_builder_connect_signals()>
for any callback symbols that are added. Using this method allows for better
encapsulation as it does not require that callback symbols be declared in
the global namespace.

  method gtk_builder_add_callback_symbol ( Str $callback_name, GCallback $callback_symbol )

=item $callback_name; The name of the callback, as expected in the XML
=item $callback_symbol; (scope async): The callback pointer

=end pod

sub gtk_builder_add_callback_symbol ( N-GObject $builder, Str $callback_name, GCallback $callback_symbol )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] builder_] add_callback_symbols

A convenience function to add many callbacks instead of calling
C<gtk_builder_add_callback_symbol()> for each symbol.

  method gtk_builder_add_callback_symbols ( Str $first_callback_name, GCallback $first_callback_symbol )

=item $first_callback_name; The name of the callback, as expected in the XML
=item $first_callback_symbol; (scope async): The callback pointer @...: A list of callback name and callback symbol pairs terminated with C<Any>

=end pod

sub gtk_builder_add_callback_symbols ( N-GObject $builder, Str $first_callback_name, GCallback $first_callback_symbol, Any $any = Any )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
=begin pod
=head2 [[gtk_] builder_] lookup_callback_symbol

Fetches a symbol previously added to I<builder>
with C<gtk_builder_add_callback_symbols()>

This function is intended for possible use in language bindings
or for any case that one might be cusomizing signal connections
using C<gtk_builder_connect_signals_full()>

Returns: (nullable): The callback symbol in I<builder> for I<callback_name>, or C<Any>

  method gtk_builder_lookup_callback_symbol ( Str $callback_name --> GCallback  )

=item $callback_name; The name of the callback

=end pod

sub gtk_builder_lookup_callback_symbol ( N-GObject $builder, Str $callback_name )
  returns GCallback
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_builder_set_application:
=begin pod
=head2 [[gtk_] builder_] set_application

Sets the application associated with I<builder>.

You only need this function if there is more than one C<Application> in your process. I<application> cannot be C<Any>.

  method gtk_builder_set_application ( N-GObject $application )

=item $application; a B<Gnome::Gtk3::Application>

=end pod

sub gtk_builder_set_application ( N-GObject $builder, N-GObject $application )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_builder_get_application:
=begin pod
=head2 [[gtk_] builder_] get_application

Gets the B<Gnome::Gtk3::Application> associated with the builder.

The B<Gnome::Gtk3::Application> is used for creating action proxies as requested
from XML that the builder is loading.

By default, the builder uses the default application: the one from
C<g_application_get_default()>. If you want to use another application
for constructing proxies, use C<gtk_builder_set_application()>.

Returns: (nullable) (transfer none): the application being used by the builder,
or C<Any>

  method gtk_builder_get_application ( --> N-GObject  )


=end pod

sub gtk_builder_get_application ( N-GObject $builder )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#`{{
=begin pod
=head2 [[gtk_] builder_] extend_with_template

Main private entry point for building composite container
components from template XML.

This is exported purely to let gtk-builder-tool validate
templates, applications have no need to call this function.

Returns: A positive value on success, 0 if an error occurred

  method gtk_builder_extend_with_template ( N-GObject $widget, N-GObject $template_type, Str $buffer, UInt $length, N-GObject $error --> UInt  )

=item $widget; the widget that is being extended
=item $template_type; the type that the template is for
=item $buffer; the string to parse
=item $length; the length of I<buffer> (may be -1 if I<buffer> is nul-terminated)
=item $error; (allow-none): return location for an error, or C<Any>

=end pod

sub gtk_builder_extend_with_template ( N-GObject $builder, N-GObject $widget, N-GObject $template_type, Str $buffer, uint64 $length, N-GObject $error )
  returns uint32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=head3 translation-domain

The translation domain used when translating property values that
have been marked as translatable in interface descriptions.
If the translation domain is C<Any>, B<Gnome::Gtk3::Builder> uses C<gettext()>,
otherwise C<g_dgettext()>.

The B<Gnome::GObject::Value> type of property I<translation-domain> is C<G_TYPE_STRING>.

=end pod
