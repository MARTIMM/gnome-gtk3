#TL:1:Gnome::Gio::Settings:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gio::Settings

High-level API for application settings

=comment ![](images/X.png)

=head1 Description

The B<Gnome::Gio::Settings> class provides a convenient API for storing and retrieving application settings.

Reads and writes can be considered to be non-blocking.  Reading settings with B<Gnome::Gio::Settings> is typically extremely fast.  Writing settings is also extremely fast in terms of time to return to your application, but can be extremely expensive for other threads and other processes.  Many settings backends (including dconf) have lazy initialisation which means in the common case of the user using their computer without modifying any settings a lot of work can be avoided.  For dconf, the D-Bus service doesn't even need to be started in this case.  For this reason, you should only ever modify B<Gnome::Gio::Settings> keys in response to explicit user action. Particular care should be paid to ensure that modifications are not made during startup -- for example, when setting the initial value of preferences widgets.  The built-in C<bind()> functionality is careful not to write settings in response to notify signals as a result of modifications that it makes to widgets.

When creating a B<Gnome::Gio::Settings> instance, you have to specify a schema that describes the keys in your settings and their types and default values, as well as some other information.

Normally, a schema has a fixed path that determines where the settings are stored in the conceptual global tree of settings. However, schemas can also be relocatable, i.e. not equipped with a fixed path. This is useful e.g. when the schema describes an 'account', and you want to be able to store an arbitrary number of accounts.

Paths must start and end with a forward slash character ('/') and must not contain two sequential slash characters.  Paths should be chosen based on a domain name associated with the program or library to which the settings belong.  Examples of paths are "/org/gtk/settings/file-chooser/" and "/ca/desrt/dconf-editor/". Paths should not start with "/apps/", "/desktop/" or "/system/" as they often did in GConf (note: An older deprecated method).

Unlike other configuration systems (like GConf), GSettings does not restrict keys to basic types like strings and numbers. GSettings stores values as B<GVariant>, and allows any B<GVariantType> for keys. Key names are restricted to lowercase characters, numbers and '-'. Furthermore, the names must begin with a lowercase character, must not end with a '-', and must not contain consecutive dashes.

Similar to GConf, the default values in GSettings schemas can be
localized, but the localized values are stored in gettext catalogs
and looked up with the domain that is specified in the
`gettext-domain` attribute of the <schemalist> or <schema>
elements and the category that is specified in the `l10n` attribute of
the <default> element. The string which is translated includes all text in
the <default> element, including any surrounding quotation marks.

The `l10n` attribute must be set to `messages` or `time`, and sets the
[locale category for
translation](https://www.gnu.org/software/gettext/manual/html-node/Aspects.htmlB<index>-locale-categories-1).
The `messages` category should be used by default; use `time` for
translatable date or time formats. A translation comment can be added as an
XML comment immediately above the <default> element — it is recommended to
add these comments to aid translators understand the meaning and
implications of the default value. An optional translation `context`
attribute can be set on the <default> element to disambiguate multiple
defaults which use the same string.

For example:
|[
 <!-- Translators: A list of words which are not allowed to be typed, in
      GVariant serialization syntax.
      See: https://developer.gnome.org/glib/stable/gvariant-text.html -->
 <default l10n='messages' context='Banned words'>['bad', 'words']</default>
]|

Translations of default values must remain syntactically valid serialized
B<GVariants> (e.g. retaining any surrounding quotation marks) or runtime
errors will occur.

GSettings uses schemas in a compact binary form that is created
by the [glib-compile-schemas][glib-compile-schemas]
utility. The input is a schema description in an XML format.

A DTD for the gschema XML format can be found here:
[gschema.dtd](https://git.gnome.org/browse/glib/tree/gio/gschema.dtd)

The [glib-compile-schemas][glib-compile-schemas] tool expects schema
files to have the extension `.gschema.xml`.

At runtime, schemas are identified by their id (as specified in the
id attribute of the <schema> element). The convention for schema
ids is to use a dotted name, similar in style to a D-Bus bus name,
e.g. "org.gnome.SessionManager". In particular, if the settings are
for a specific service that owns a D-Bus bus name, the D-Bus bus name
and schema id should match. For schemas which deal with settings not
associated with one named application, the id should not use
StudlyCaps, e.g. "org.gnome.font-rendering".

In addition to B<GVariant> types, keys can have types that have
enumerated types. These can be described by a <choice>,
<enum> or <flags> element, as seen in the
[example][schema-enumerated]. The underlying type of such a key
is string, but you can use [[g-settings-get-enum]], [[g-settings-set-enum]],
[[g-settings-get-flags]], [[g-settings-set-flags]] access the numeric values
corresponding to the string value of enum and flags keys.

An example for default value:
|[
<schemalist>
  <schema id="org.gtk.Test" path="/org/gtk/Test/" gettext-domain="test">

    <key name="greeting" type="s">
      <default l10n="messages">"Hello, earthlings"</default>
      <summary>A greeting</summary>
      <description>
        Greeting of the invading martians
      </description>
    </key>

    <key name="box" type="(ii)">
      <default>(20,30)</default>
    </key>

    <key name="empty-string" type="s">
      <default>""</default>
      <summary>Empty strings have to be provided in GVariant form</summary>
    </key>

  </schema>
</schemalist>
]|

An example for ranges, choices and enumerated types:
|[
<schemalist>

  <enum id="org.gtk.Test.myenum">
    <value nick="first" value="1"/>
    <value nick="second" value="2"/>
  </enum>

  <flags id="org.gtk.Test.myflags">
    <value nick="flag1" value="1"/>
    <value nick="flag2" value="2"/>
    <value nick="flag3" value="4"/>
  </flags>

  <schema id="org.gtk.Test">

    <key name="key-with-range" type="i">
      <range min="1" max="100"/>
      <default>10</default>
    </key>

    <key name="key-with-choices" type="s">
      <choices>
        <choice value='Elisabeth'/>
        <choice value='Annabeth'/>
        <choice value='Joe'/>
      </choices>
      <aliases>
        <alias value='Anna' target='Annabeth'/>
        <alias value='Beth' target='Elisabeth'/>
      </aliases>
      <default>'Joe'</default>
    </key>

    <key name='enumerated-key' enum='org.gtk.Test.myenum'>
      <default>'first'</default>
    </key>

    <key name='flags-key' flags='org.gtk.Test.myflags'>
      <default>["flag1","flag2"]</default>
    </key>
  </schema>
</schemalist>
]|

## Vendor overrides

Default values are defined in the schemas that get installed by
an application. Sometimes, it is necessary for a vendor or distributor
to adjust these defaults. Since patching the XML source for the schema
is inconvenient and error-prone,
[glib-compile-schemas][glib-compile-schemas] reads so-called vendor
override' files. These are keyfiles in the same directory as the XML
schema sources which can override default values. The schema id serves
as the group name in the key file, and the values are expected in
serialized GVariant form, as in the following example:
|[
    [org.gtk.Example]
    key1='string'
    key2=1.5
]|

glib-compile-schemas expects schema files to have the extension
`.gschema.override`.

## Binding

A very convenient feature of GSettings lets you bind B<GObject> properties
directly to settings, using [[g-settings-bind]]. Once a GObject property
has been bound to a setting, changes on either side are automatically
propagated to the other side. GSettings handles details like mapping
between GObject and GVariant types, and preventing infinite cycles.

This makes it very easy to hook up a preferences dialog to the
underlying settings. To make this even more convenient, GSettings
looks for a boolean property with the name "sensitivity" and
automatically binds it to the writability of the bound setting.
If this 'magic' gets in the way, it can be suppressed with the
B<G-SETTINGS-BIND-NO-SENSITIVITY> flag.

## Relocatable schemas # {B<Gnome::Gio::Settings>-relocatable}

A relocatable schema is one with no `path` attribute specified on its
<schema> element. By using [[g-settings-new-with-path]], a B<Gnome::Gio::Settings> object
can be instantiated for a relocatable schema, assigning a path to the
instance. Paths passed to [[g-settings-new-with-path]] will typically be
constructed dynamically from a constant prefix plus some form of instance
identifier; but they must still be valid GSettings paths. Paths could also
be constant and used with a globally installed schema originating from a
dependency library.

For example, a relocatable schema could be used to store geometry information
for different windows in an application. If the schema ID was
`org.foo.MyApp.Window`, it could be instantiated for paths
`/org/foo/MyApp/main/`, `/org/foo/MyApp/document-1/`,
`/org/foo/MyApp/document-2/`, etc. If any of the paths are well-known
they can be specified as <child> elements in the parent schema, e.g.:
|[
<schema id="org.foo.MyApp" path="/org/foo/MyApp/">
  <child name="main" schema="org.foo.MyApp.Window"/>
</schema>
]|

## Build system integration # {B<Gnome::Gio::Settings>-build-system}

GSettings comes with autotools integration to simplify compiling and
installing schemas. To add GSettings support to an application, add the
following to your `configure.ac`:
|[
GLIB-GSETTINGS
]|

In the appropriate `Makefile.am`, use the following snippet to compile and
install the named schema:
|[
gsettings-SCHEMAS = org.foo.MyApp.gschema.xml
EXTRA-DIST = $(gsettings-SCHEMAS)

I<GSETTINGS-RULES>@
]|

No changes are needed to the build system to mark a schema XML file for
translation. Assuming it sets the `gettext-domain` attribute, a schema may
be marked for translation by adding it to `POTFILES.in`, assuming gettext
0.19 is in use (the preferred method for translation):
|[
data/org.foo.MyApp.gschema.xml
]|

Alternatively, if intltool 0.50.1 is in use:
|[
[type: gettext/gsettings]data/org.foo.MyApp.gschema.xml
]|

GSettings will use gettext to look up translations for the <summary> and
<description> elements, and also any <default> elements which have a `l10n`
attribute set. Translations must not be included in the `.gschema.xml` file
by the build system, for example by using intltool XML rules with a
`.gschema.xml.in` template.

If an enumerated type defined in a C header file is to be used in a GSettings
schema, it can either be defined manually using an <enum> element in the
schema XML, or it can be extracted automatically from the C header. This
approach is preferred, as it ensures the two representations are always
synchronised. To do so, add the following to the relevant `Makefile.am`:
|[
gsettings-ENUM-NAMESPACE = org.foo.MyApp
gsettings-ENUM-FILES = my-app-enums.h my-app-misc.h
]|

`gsettings-ENUM-NAMESPACE` specifies the schema namespace for the enum files,
which are specified in `gsettings-ENUM-FILES`. This will generate a
`org.foo.MyApp.enums.xml` file containing the extracted enums, which will be
automatically included in the schema compilation, install and uninstall
rules. It should not be committed to version control or included in
 * `EXTRA-DIST`.



=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gio::Settings;



=comment head2 Uml Diagram

=comment ![](plantuml/.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gio::Settings;

  unit class MyGuiClass;
  also is Gnome::Gio::Settings;

  submethod new ( |c ) {
    # let the Gnome::Gio::Settings class process the options
    self.bless( :GSettings, |c);
  }

  submethod BUILD ( ... ) {
    ...
  }

=end comment
=comment head2 Example

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#use Gnome::N::X;
use Gnome::N::NativeLib;
use Gnome::N::N-GObject;
use Gnome::N::GlibToRakuTypes;


#-------------------------------------------------------------------------------
unit class Gnome::Gio::Settings:auth<github:MARTIMM>:ver<0.1.0>;


#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=end pod
#-------------------------------------------------------------------------------
=begin pod
=head2 enum GSettingsBindFlags

Flags used when creating a binding. These flags determine in which
direction the binding works. The default is to synchronize in both
directions.


=item G-SETTINGS-BIND-DEFAULT: Equivalent to `G-SETTINGS-BIND-GET|G-SETTINGS-BIND-SET`
=item G-SETTINGS-BIND-GET: Update the B<GObject> property when the setting changes. It is an error to use this flag if the property is not writable.
=item G-SETTINGS-BIND-SET: Update the setting when the B<GObject> property changes. It is an error to use this flag if the property is not readable.
=item G-SETTINGS-BIND-NO-SENSITIVITY: Do not try to bind a "sensitivity" property to the writability of the setting
=item G-SETTINGS-BIND-GET-NO-CHANGES: When set in addition to B<G-SETTINGS-BIND-GET>, set the B<GObject> property value initially from the setting, but do not listen for changes of the setting
=item G-SETTINGS-BIND-INVERT-BOOLEAN: When passed to C<bind()>, uses a pair of mapping functions that invert the boolean value when mapping between the setting and the property.  The setting and property must both be booleans.  You cannot pass this flag to [[g-settings-bind-with-mapping]].


=end pod

#TE:0:GSettingsBindFlags:
enum GSettingsBindFlags is export (
  'G_SETTINGS_BIND_DEFAULT',
  'G_SETTINGS_BIND_GET'            => (1+<0),
  'G_SETTINGS_BIND_SET'            => (1+<1),
  'G_SETTINGS_BIND_NO_SENSITIVITY' => (1+<2),
  'G_SETTINGS_BIND_GET_NO_CHANGES' => (1+<3),
  'G_SETTINGS_BIND_INVERT_BOOLEAN' => (1+<4)
);

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------

=begin pod
=head1 Methods
=head2 new

=head3 default, no options

Create a new Settings object.

  multi method new ( )

=head3 :native-object

Create a Settings object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a Settings object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end pod

#TM:0:new():inheriting
#TM:1:new():
#TM:4:new(:native-object):Gnome::N::TopLevelClassSupport
#TM:4:new(:build-id):Gnome::GObject::Object

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w1<changed writable-changed writable-change-event>, :w2<change-event>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }


  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gio::Settings' #`{{ or %options<GSettings> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists or %options<widget>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        $no = %options<___x___>;
        $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _g_settings_new___x___($no);
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
        $no = _g_settings_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self.set-class-info('GSettings');

  }
}


#-------------------------------------------------------------------------------
#TM:0:apply:
=begin pod
=head2 apply


Applies any changes that have been made to the settings.  This
function does nothing unless I<settings> is in 'delay-apply' mode;
see C<delay()>.  In the normal case settings are always
applied immediately.

  method apply ( )


=end pod

method apply ( ) {

  g_settings_apply(
    self._f('GSettings'),
  );
}

sub g_settings_apply ( GSettings $settings  )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:bind:
=begin pod
=head2 bind


Create a binding between the I<key> in the I<settings> object
and the property I<property> of I<object>.

The binding uses the default GIO mapping functions to map
between the settings and property values. These functions
handle booleans, numeric types and string types in a
straightforward way. Use [[bind-with-mapping]] if
you need a custom mapping, or map between types that are not
supported by the default mapping functions.

Unless the I<flags> include C<G-SETTINGS-BIND-NO-SENSITIVITY>, this
function also establishes a binding between the writability of
I<key> and the "sensitive" property of I<object> (if I<object> has
a boolean property by that name). See [[g-settings-bind-writable]]
for more details about writable bindings.

Note that the lifecycle of the binding is tied to I<object>,
and that you can have only one binding per object property.
If you bind the same property twice on the same object, the second
binding overrides the first one.



  method bind ( Str $key, Pointer $object, Str $property, GSettingsBindFlags $flags )

=item Str $key; the key to bind
=item Pointer $object; (type GObject.Object): a B<GObject>
=item Str $property; the name of the property to bind
=item GSettingsBindFlags $flags; flags for the binding

=end pod

method bind ( Str $key, Pointer $object, Str $property, GSettingsBindFlags $flags ) {

  g_settings_bind(
    self._f('GSettings'), $key, $object, $property, $flags
  );
}

sub g_settings_bind ( GSettings $settings, gchar-ptr $key, gpointer $object, gchar-ptr $property, GSettingsBindFlags $flags  )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:bind-with-mapping:
=begin pod
=head2 bind-with-mapping


Create a binding between the I<key> in the I<settings> object
and the property I<property> of I<object>.

The binding uses the provided mapping functions to map between
settings and property values.

Note that the lifecycle of the binding is tied to I<object>,
and that you can have only one binding per object property.
If you bind the same property twice on the same object, the second
binding overrides the first one.



  method bind-with-mapping ( Str $key, Pointer $object, Str $property, GSettingsBindFlags $flags, GSettingsBindGetMapping $get_mapping, GSettingsBindSetMapping $set_mapping, Pointer $user_data, GDestroyNotify $destroy )

=item Str $key; the key to bind
=item Pointer $object; (type GObject.Object): a B<GObject>
=item Str $property; the name of the property to bind
=item GSettingsBindFlags $flags; flags for the binding
=item GSettingsBindGetMapping $get_mapping; a function that gets called to convert values from I<settings> to I<object>, or C<undefined> to use the default GIO mapping
=item GSettingsBindSetMapping $set_mapping; a function that gets called to convert values from I<object> to I<settings>, or C<undefined> to use the default GIO mapping
=item Pointer $user_data; data that gets passed to I<get-mapping> and I<set-mapping>
=item GDestroyNotify $destroy; B<GDestroyNotify> function for I<user-data>

=end pod

method bind-with-mapping ( Str $key, Pointer $object, Str $property, GSettingsBindFlags $flags, GSettingsBindGetMapping $get_mapping, GSettingsBindSetMapping $set_mapping, Pointer $user_data, GDestroyNotify $destroy ) {

  g_settings_bind_with_mapping(
    self._f('GSettings'), $key, $object, $property, $flags, $get_mapping, $set_mapping, $user_data, $destroy
  );
}

sub g_settings_bind_with_mapping ( GSettings $settings, gchar-ptr $key, gpointer $object, gchar-ptr $property, GSettingsBindFlags $flags, GSettingsBindGetMapping $get_mapping, GSettingsBindSetMapping $set_mapping, gpointer $user_data, GDestroyNotify $destroy  )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:bind-writable:
=begin pod
=head2 bind-writable


Create a binding between the writability of I<key> in the
I<settings> object and the property I<property> of I<object>.
The property must be boolean; "sensitive" or "visible"
properties of widgets are the most likely candidates.

Writable bindings are always uni-directional; changes of the
writability of the setting will be propagated to the object
property, not the other way.

When the I<inverted> argument is C<True>, the binding inverts the
value as it passes from the setting to the object, i.e. I<property>
will be set to C<True> if the key is not writable.

Note that the lifecycle of the binding is tied to I<object>,
and that you can have only one binding per object property.
If you bind the same property twice on the same object, the second
binding overrides the first one.



  method bind-writable ( Str $key, Pointer $object, Str $property, Int $inverted )

=item Str $key; the key to bind
=item Pointer $object; (type GObject.Object):a B<GObject>
=item Str $property; the name of a boolean property to bind
=item Int $inverted; whether to 'invert' the value

=end pod

method bind-writable ( Str $key, Pointer $object, Str $property, Int $inverted ) {

  g_settings_bind_writable(
    self._f('GSettings'), $key, $object, $property, $inverted
  );
}

sub g_settings_bind_writable ( GSettings $settings, gchar-ptr $key, gpointer $object, gchar-ptr $property, gboolean $inverted  )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:create-action:
=begin pod
=head2 create-action


Creates a B<GAction> corresponding to a given B<Gnome::Gio::Settings> key.

The action has the same name as the key.

The value of the key becomes the state of the action and the action
is enabled when the key is writable.  Changing the state of the
action results in the key being written to.  Changes to the value or
writability of the key cause appropriate change notifications to be
emitted for the action.

For boolean-valued keys, action activations take no parameter and
result in the toggling of the value.  For all other types,
activations take the new value for the key (which must have the
correct type).

Returns: (transfer full): a new B<GAction>



  method create-action ( Str $key --> GAction )

=item Str $key; the name of a key in I<settings>

=end pod

method create-action ( Str $key --> GAction ) {

  g_settings_create_action(
    self._f('GSettings'), $key
  );
}

sub g_settings_create_action ( GSettings $settings, gchar-ptr $key --> GAction )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:delay:
=begin pod
=head2 delay


Changes the B<Gnome::Gio::Settings> object into 'delay-apply' mode. In this
mode, changes to I<settings> are not immediately propagated to the
backend, but kept locally until C<apply()> is called.



  method delay ( )


=end pod

method delay ( ) {

  g_settings_delay(
    self._f('GSettings'),
  );
}

sub g_settings_delay ( GSettings $settings  )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get:
=begin pod
=head2 get


Gets the value that is stored at I<key> in I<settings>.

A convenience function that combines [[get-value]] with
[[g-variant-get]].

It is a programmer error to give a I<key> that isn't contained in the
schema for I<settings> or for the B<GVariantType> of I<format> to mismatch
the type given in the schema.



  method get ( Str $key, Str $format )

=item Str $key; the key to get the value for
=item Str $format; a B<GVariant> format string @...: arguments as per I<format>

=end pod

method get ( Str $key, Str $format ) {

  g_settings_get(
    self._f('GSettings'), $key, $format
  );
}

sub g_settings_get ( GSettings $settings, gchar-ptr $key, gchar-ptr $format, Any $any = Any  )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-boolean:
=begin pod
=head2 get-boolean


Gets the value that is stored at I<key> in I<settings>.

A convenience variant of C<get()> for booleans.

It is a programmer error to give a I<key> that isn't specified as
having a boolean type in the schema for I<settings>.

Returns: a boolean



  method get-boolean ( Str $key --> Int )

=item Str $key; the key to get the value for

=end pod

method get-boolean ( Str $key --> Int ) {

  g_settings_get_boolean(
    self._f('GSettings'), $key
  );
}

sub g_settings_get_boolean ( GSettings $settings, gchar-ptr $key --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-child:
=begin pod
=head2 get-child


Creates a child settings object which has a base path of
`base-path/I<name>`, where `base-path` is the base path of
I<settings>.

The schema for the child settings object must have been declared
in the schema of I<settings> using a <child> element.

Returns: (transfer full): a 'child' settings object



  method get-child ( Str $name --> GSettings )

=item Str $name; the name of the child schema

=end pod

method get-child ( Str $name --> GSettings ) {

  g_settings_get_child(
    self._f('GSettings'), $name
  );
}

sub g_settings_get_child ( GSettings $settings, gchar-ptr $name --> GSettings )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-default-value:
=begin pod
=head2 get-default-value


Gets the "default value" of a key.

This is the value that would be read if C<reset()> were to be
called on the key.

Note that this may be a different value than returned by
[[g-settings-schema-key-get-default-value]] if the system administrator
has provided a default value.

Comparing the return values of [[g-settings-get-default-value]] and
[[g-settings-get-value]] is not sufficient for determining if a value
has been set because the user may have explicitly set the value to
something that happens to be equal to the default.  The difference
here is that if the default changes in the future, the user's key
will still be set.

This function may be useful for adding an indication to a UI of what
the default value was before the user set it.

It is a programmer error to give a I<key> that isn't contained in the
schema for I<settings>.

Returns: (nullable) (transfer full): the default value



  method get-default-value ( Str $key --> N-GVariant )

=item Str $key; the key to get the default value for

=end pod

method get-default-value ( Str $key --> N-GVariant ) {

  g_settings_get_default_value(
    self._f('GSettings'), $key
  );
}

sub g_settings_get_default_value ( GSettings $settings, gchar-ptr $key --> N-GVariant )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-double:
=begin pod
=head2 get-double


Gets the value that is stored at I<key> in I<settings>.

A convenience variant of C<get()> for doubles.

It is a programmer error to give a I<key> that isn't specified as
having a 'double' type in the schema for I<settings>.

Returns: a double



  method get-double ( Str $key --> Num )

=item Str $key; the key to get the value for

=end pod

method get-double ( Str $key --> Num ) {

  g_settings_get_double(
    self._f('GSettings'), $key
  );
}

sub g_settings_get_double ( GSettings $settings, gchar-ptr $key --> gdouble )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-enum:
=begin pod
=head2 get-enum


Gets the value that is stored in I<settings> for I<key> and converts it
to the enum value that it represents.

In order to use this function the type of the value must be a string
and it must be marked in the schema file as an enumerated type.

It is a programmer error to give a I<key> that isn't contained in the
schema for I<settings> or is not marked as an enumerated type.

If the value stored in the configuration database is not a valid
value for the enumerated type then this function will return the
default value.

Returns: the enum value



  method get-enum ( Str $key --> Int )

=item Str $key; the key to get the value for

=end pod

method get-enum ( Str $key --> Int ) {

  g_settings_get_enum(
    self._f('GSettings'), $key
  );
}

sub g_settings_get_enum ( GSettings $settings, gchar-ptr $key --> gint )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-flags:
=begin pod
=head2 get-flags


Gets the value that is stored in I<settings> for I<key> and converts it
to the flags value that it represents.

In order to use this function the type of the value must be an array
of strings and it must be marked in the schema file as an flags type.

It is a programmer error to give a I<key> that isn't contained in the
schema for I<settings> or is not marked as a flags type.

If the value stored in the configuration database is not a valid
value for the flags type then this function will return the default
value.

Returns: the flags value



  method get-flags ( Str $key --> UInt )

=item Str $key; the key to get the value for

=end pod

method get-flags ( Str $key --> UInt ) {

  g_settings_get_flags(
    self._f('GSettings'), $key
  );
}

sub g_settings_get_flags ( GSettings $settings, gchar-ptr $key --> guint )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-has-unapplied:
=begin pod
=head2 get-has-unapplied


Returns whether the B<Gnome::Gio::Settings> object has any unapplied
changes.  This can only be the case if it is in 'delayed-apply' mode.

Returns: C<True> if I<settings> has unapplied changes



  method get-has-unapplied ( --> Int )


=end pod

method get-has-unapplied ( --> Int ) {

  g_settings_get_has_unapplied(
    self._f('GSettings'),
  );
}

sub g_settings_get_has_unapplied ( GSettings $settings --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-int:
=begin pod
=head2 get-int


Gets the value that is stored at I<key> in I<settings>.

A convenience variant of C<get()> for 32-bit integers.

It is a programmer error to give a I<key> that isn't specified as
having a int32 type in the schema for I<settings>.

Returns: an integer



  method get-int ( Str $key --> Int )

=item Str $key; the key to get the value for

=end pod

method get-int ( Str $key --> Int ) {

  g_settings_get_int(
    self._f('GSettings'), $key
  );
}

sub g_settings_get_int ( GSettings $settings, gchar-ptr $key --> gint )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-int64:
=begin pod
=head2 get-int64


Gets the value that is stored at I<key> in I<settings>.

A convenience variant of C<get()> for 64-bit integers.

It is a programmer error to give a I<key> that isn't specified as
having a int64 type in the schema for I<settings>.

Returns: a 64-bit integer



  method get-int64 ( Str $key --> Int )

=item Str $key; the key to get the value for

=end pod

method get-int64 ( Str $key --> Int ) {

  g_settings_get_int64(
    self._f('GSettings'), $key
  );
}

sub g_settings_get_int64 ( GSettings $settings, gchar-ptr $key --> gint64 )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-mapped:
=begin pod
=head2 get-mapped


Gets the value that is stored at I<key> in I<settings>, subject to
application-level validation/mapping.

You should use this function when the application needs to perform
some processing on the value of the key (for example, parsing).  The
I<mapping> function performs that processing.  If the function
indicates that the processing was unsuccessful (due to a parse error,
for example) then the mapping is tried again with another value.

This allows a robust 'fall back to defaults' behaviour to be
implemented somewhat automatically.

The first value that is tried is the user's setting for the key.  If
the mapping function fails to map this value, other values may be
tried in an unspecified order (system or site defaults, translated
schema default values, untranslated schema default values, etc).

If the mapping function fails for all possible values, one additional
attempt is made: the mapping function is called with a C<undefined> value.
If the mapping function still indicates failure at this point then
the application will be aborted.

The result parameter for the I<mapping> function is pointed to a
B<gpointer> which is initially set to C<undefined>.  The same pointer is given
to each invocation of I<mapping>.  The final value of that B<gpointer> is
what is returned by this function.  C<undefined> is valid; it is returned
just as any other value would be.

Returns: (transfer full): the result, which may be C<undefined>

  method get-mapped ( Str $key, GSettingsGetMapping $mapping, Pointer $user_data --> Pointer )

=item Str $key; the key to get the value for
=item GSettingsGetMapping $mapping; (scope call): the function to map the value in the settings database to the value used by the application
=item Pointer $user_data; user data for I<mapping>

=end pod

method get-mapped ( Str $key, GSettingsGetMapping $mapping, Pointer $user_data --> Pointer ) {

  g_settings_get_mapped(
    self._f('GSettings'), $key, $mapping, $user_data
  );
}

sub g_settings_get_mapped ( GSettings $settings, gchar-ptr $key, GSettingsGetMapping $mapping, gpointer $user_data --> gpointer )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-string:
=begin pod
=head2 get-string


Gets the value that is stored at I<key> in I<settings>.

A convenience variant of C<get()> for strings.

It is a programmer error to give a I<key> that isn't specified as
having a string type in the schema for I<settings>.

Returns: a newly-allocated string



  method get-string ( Str $key --> Str )

=item Str $key; the key to get the value for

=end pod

method get-string ( Str $key --> Str ) {

  g_settings_get_string(
    self._f('GSettings'), $key
  );
}

sub g_settings_get_string ( GSettings $settings, gchar-ptr $key --> gchar-ptr )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-strv:
=begin pod
=head2 get-strv


A convenience variant of C<get()> for string arrays.

It is a programmer error to give a I<key> that isn't specified as
having an array of strings type in the schema for I<settings>.

Returns: (array zero-terminated=1) (transfer full): a
newly-allocated, C<undefined>-terminated array of strings, the value that
is stored at I<key> in I<settings>.



  method get-strv ( Str $key --> CArray[Str] )

=item Str $key; the key to get the value for

=end pod

method get-strv ( Str $key --> CArray[Str] ) {

  g_settings_get_strv(
    self._f('GSettings'), $key
  );
}

sub g_settings_get_strv ( GSettings $settings, gchar-ptr $key --> gchar-pptr )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-type:
=begin pod
=head2 get-type



  method get-type ( --> N-GObject )


=end pod

method get-type ( --> N-GObject ) {

  g_settings_get_type(
    self._f('GSettings'),
  );
}

sub g_settings_get_type (  --> N-GObject )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-uint:
=begin pod
=head2 get-uint


Gets the value that is stored at I<key> in I<settings>.

A convenience variant of C<get()> for 32-bit unsigned
integers.

It is a programmer error to give a I<key> that isn't specified as
having a uint32 type in the schema for I<settings>.

Returns: an unsigned integer



  method get-uint ( Str $key --> UInt )

=item Str $key; the key to get the value for

=end pod

method get-uint ( Str $key --> UInt ) {

  g_settings_get_uint(
    self._f('GSettings'), $key
  );
}

sub g_settings_get_uint ( GSettings $settings, gchar-ptr $key --> guint )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-uint64:
=begin pod
=head2 get-uint64


Gets the value that is stored at I<key> in I<settings>.

A convenience variant of C<get()> for 64-bit unsigned
integers.

It is a programmer error to give a I<key> that isn't specified as
having a uint64 type in the schema for I<settings>.

Returns: a 64-bit unsigned integer



  method get-uint64 ( Str $key --> UInt )

=item Str $key; the key to get the value for

=end pod

method get-uint64 ( Str $key --> UInt ) {

  g_settings_get_uint64(
    self._f('GSettings'), $key
  );
}

sub g_settings_get_uint64 ( GSettings $settings, gchar-ptr $key --> guint64 )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-user-value:
=begin pod
=head2 get-user-value


Checks the "user value" of a key, if there is one.

The user value of a key is the last value that was set by the user.

After calling C<reset()> this function should always return
C<undefined> (assuming something is not wrong with the system
configuration).

It is possible that [[g-settings-get-value]] will return a different
value than this function.  This can happen in the case that the user
set a value for a key that was subsequently locked down by the system
administrator -- this function will return the user's old value.

This function may be useful for adding a "reset" option to a UI or
for providing indication that a particular value has been changed.

It is a programmer error to give a I<key> that isn't contained in the
schema for I<settings>.

Returns: (nullable) (transfer full): the user's value, if set



  method get-user-value ( Str $key --> N-GVariant )

=item Str $key; the key to get the user value for

=end pod

method get-user-value ( Str $key --> N-GVariant ) {

  g_settings_get_user_value(
    self._f('GSettings'), $key
  );
}

sub g_settings_get_user_value ( GSettings $settings, gchar-ptr $key --> N-GVariant )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:get-value:
=begin pod
=head2 get-value


Gets the value that is stored in I<settings> for I<key>.

It is a programmer error to give a I<key> that isn't contained in the
schema for I<settings>.

Returns: a new B<GVariant>



  method get-value ( Str $key --> N-GVariant )

=item Str $key; the key to get the value for

=end pod

method get-value ( Str $key --> N-GVariant ) {

  g_settings_get_value(
    self._f('GSettings'), $key
  );
}

sub g_settings_get_value ( GSettings $settings, gchar-ptr $key --> N-GVariant )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:is-writable:
=begin pod
=head2 is-writable


Finds out if a key can be written or not

Returns: C<True> if the key I<name> is writable



  method is-writable ( Str $name --> Int )

=item Str $name; the name of a key

=end pod

method is-writable ( Str $name --> Int ) {

  g_settings_is_writable(
    self._f('GSettings'), $name
  );
}

sub g_settings_is_writable ( GSettings $settings, gchar-ptr $name --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:list-children:
=begin pod
=head2 list-children


Gets the list of children on I<settings>.

The list is exactly the list of strings for which it is not an error
to call [[get-child]].

There is little reason to call this function from "normal" code, since
you should already know what children are in your schema. This function
may still be useful there for introspection reasons, however.

You should free the return value with [[g-strfreev]] when you are done
with it.

Returns: (transfer full) (element-type utf8): a list of the children on I<settings>

  method list-children ( --> CArray[Str] )


=end pod

method list-children ( --> CArray[Str] ) {

  g_settings_list_children(
    self._f('GSettings'),
  );
}

sub g_settings_list_children ( GSettings $settings --> gchar-pptr )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:reset:
=begin pod
=head2 reset


Resets I<key> to its default value.

This call resets the key, as much as possible, to its default value.
That might the value specified in the schema or the one set by the
administrator.

  method reset ( Str $key )

=item Str $key; the name of a key

=end pod

method reset ( Str $key ) {

  g_settings_reset(
    self._f('GSettings'), $key
  );
}

sub g_settings_reset ( GSettings $settings, gchar-ptr $key  )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:revert:
=begin pod
=head2 revert


Reverts all non-applied changes to the settings.  This function
does nothing unless I<settings> is in 'delay-apply' mode; see
C<delay()>.  In the normal case settings are always applied
immediately.

Change notifications will be emitted for affected keys.

  method revert ( )


=end pod

method revert ( ) {

  g_settings_revert(
    self._f('GSettings'),
  );
}

sub g_settings_revert ( GSettings $settings  )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set:
=begin pod
=head2 set


Sets I<key> in I<settings> to I<value>.

A convenience function that combines [[set-value]] with
[[g-variant-new]].

It is a programmer error to give a I<key> that isn't contained in the
schema for I<settings> or for the B<GVariantType> of I<format> to mismatch
the type given in the schema.

Returns: C<True> if setting the key succeeded,
C<False> if the key was not writable



  method set ( Str $key, Str $format --> Int )

=item Str $key; the name of the key to set
=item Str $format; a B<GVariant> format string @...: arguments as per I<format>

=end pod

method set ( Str $key, Str $format --> Int ) {

  g_settings_set(
    self._f('GSettings'), $key, $format
  );
}

sub g_settings_set ( GSettings $settings, gchar-ptr $key, gchar-ptr $format, Any $any = Any --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-boolean:
=begin pod
=head2 set-boolean


Sets I<key> in I<settings> to I<value>.

A convenience variant of C<set()> for booleans.

It is a programmer error to give a I<key> that isn't specified as
having a boolean type in the schema for I<settings>.

Returns: C<True> if setting the key succeeded,
C<False> if the key was not writable



  method set-boolean ( Str $key, Int $value --> Int )

=item Str $key; the name of the key to set
=item Int $value; the value to set it to

=end pod

method set-boolean ( Str $key, Int $value --> Int ) {

  g_settings_set_boolean(
    self._f('GSettings'), $key, $value
  );
}

sub g_settings_set_boolean ( GSettings $settings, gchar-ptr $key, gboolean $value --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-double:
=begin pod
=head2 set-double


Sets I<key> in I<settings> to I<value>.

A convenience variant of C<set()> for doubles.

It is a programmer error to give a I<key> that isn't specified as
having a 'double' type in the schema for I<settings>.

Returns: C<True> if setting the key succeeded,
C<False> if the key was not writable



  method set-double ( Str $key, Num $value --> Int )

=item Str $key; the name of the key to set
=item Num $value; the value to set it to

=end pod

method set-double ( Str $key, Num $value --> Int ) {

  g_settings_set_double(
    self._f('GSettings'), $key, $value
  );
}

sub g_settings_set_double ( GSettings $settings, gchar-ptr $key, gdouble $value --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-enum:
=begin pod
=head2 set-enum


Looks up the enumerated type nick for I<value> and writes it to I<key>,
within I<settings>.

It is a programmer error to give a I<key> that isn't contained in the
schema for I<settings> or is not marked as an enumerated type, or for
I<value> not to be a valid value for the named type.

After performing the write, accessing I<key> directly with
[[get-string]] will return the 'nick' associated with
I<value>.

Returns: C<True>, if the set succeeds

  method set-enum ( Str $key, Int $value --> Int )

=item Str $key; a key, within I<settings>
=item Int $value; an enumerated value

=end pod

method set-enum ( Str $key, Int $value --> Int ) {

  g_settings_set_enum(
    self._f('GSettings'), $key, $value
  );
}

sub g_settings_set_enum ( GSettings $settings, gchar-ptr $key, gint $value --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-flags:
=begin pod
=head2 set-flags


Looks up the flags type nicks for the bits specified by I<value>, puts
them in an array of strings and writes the array to I<key>, within
I<settings>.

It is a programmer error to give a I<key> that isn't contained in the
schema for I<settings> or is not marked as a flags type, or for I<value>
to contain any bits that are not value for the named type.

After performing the write, accessing I<key> directly with
[[get-strv]] will return an array of 'nicks'; one for each
bit in I<value>.

Returns: C<True>, if the set succeeds

  method set-flags ( Str $key, UInt $value --> Int )

=item Str $key; a key, within I<settings>
=item UInt $value; a flags value

=end pod

method set-flags ( Str $key, UInt $value --> Int ) {

  g_settings_set_flags(
    self._f('GSettings'), $key, $value
  );
}

sub g_settings_set_flags ( GSettings $settings, gchar-ptr $key, guint $value --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-int:
=begin pod
=head2 set-int


Sets I<key> in I<settings> to I<value>.

A convenience variant of C<set()> for 32-bit integers.

It is a programmer error to give a I<key> that isn't specified as
having a int32 type in the schema for I<settings>.

Returns: C<True> if setting the key succeeded,
C<False> if the key was not writable



  method set-int ( Str $key, Int $value --> Int )

=item Str $key; the name of the key to set
=item Int $value; the value to set it to

=end pod

method set-int ( Str $key, Int $value --> Int ) {

  g_settings_set_int(
    self._f('GSettings'), $key, $value
  );
}

sub g_settings_set_int ( GSettings $settings, gchar-ptr $key, gint $value --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-int64:
=begin pod
=head2 set-int64


Sets I<key> in I<settings> to I<value>.

A convenience variant of C<set()> for 64-bit integers.

It is a programmer error to give a I<key> that isn't specified as
having a int64 type in the schema for I<settings>.

Returns: C<True> if setting the key succeeded,
C<False> if the key was not writable



  method set-int64 ( Str $key, Int $value --> Int )

=item Str $key; the name of the key to set
=item Int $value; the value to set it to

=end pod

method set-int64 ( Str $key, Int $value --> Int ) {

  g_settings_set_int64(
    self._f('GSettings'), $key, $value
  );
}

sub g_settings_set_int64 ( GSettings $settings, gchar-ptr $key, gint64 $value --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-string:
=begin pod
=head2 set-string


Sets I<key> in I<settings> to I<value>.

A convenience variant of C<set()> for strings.

It is a programmer error to give a I<key> that isn't specified as
having a string type in the schema for I<settings>.

Returns: C<True> if setting the key succeeded,
C<False> if the key was not writable



  method set-string ( Str $key, Str $value --> Int )

=item Str $key; the name of the key to set
=item Str $value; the value to set it to

=end pod

method set-string ( Str $key, Str $value --> Int ) {

  g_settings_set_string(
    self._f('GSettings'), $key, $value
  );
}

sub g_settings_set_string ( GSettings $settings, gchar-ptr $key, gchar-ptr $value --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-strv:
=begin pod
=head2 set-strv


Sets I<key> in I<settings> to I<value>.

A convenience variant of C<set()> for string arrays.  If
I<value> is C<undefined>, then I<key> is set to be the empty array.

It is a programmer error to give a I<key> that isn't specified as
having an array of strings type in the schema for I<settings>.

Returns: C<True> if setting the key succeeded,
C<False> if the key was not writable



  method set-strv ( Str $key, CArray[Str] $value --> Int )

=item Str $key; the name of the key to set
=item CArray[Str] $value; (nullable) (array zero-terminated=1): the value to set it to, or C<undefined>

=end pod

method set-strv ( Str $key, CArray[Str] $value --> Int ) {

  g_settings_set_strv(
    self._f('GSettings'), $key, $value
  );
}

sub g_settings_set_strv ( GSettings $settings, gchar-ptr $key, gchar-pptr $value --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-uint:
=begin pod
=head2 set-uint


Sets I<key> in I<settings> to I<value>.

A convenience variant of C<set()> for 32-bit unsigned
integers.

It is a programmer error to give a I<key> that isn't specified as
having a uint32 type in the schema for I<settings>.

Returns: C<True> if setting the key succeeded,
C<False> if the key was not writable



  method set-uint ( Str $key, UInt $value --> Int )

=item Str $key; the name of the key to set
=item UInt $value; the value to set it to

=end pod

method set-uint ( Str $key, UInt $value --> Int ) {

  g_settings_set_uint(
    self._f('GSettings'), $key, $value
  );
}

sub g_settings_set_uint ( GSettings $settings, gchar-ptr $key, guint $value --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-uint64:
=begin pod
=head2 set-uint64


Sets I<key> in I<settings> to I<value>.

A convenience variant of C<set()> for 64-bit unsigned
integers.

It is a programmer error to give a I<key> that isn't specified as
having a uint64 type in the schema for I<settings>.

Returns: C<True> if setting the key succeeded,
C<False> if the key was not writable



  method set-uint64 ( Str $key, UInt $value --> Int )

=item Str $key; the name of the key to set
=item UInt $value; the value to set it to

=end pod

method set-uint64 ( Str $key, UInt $value --> Int ) {

  g_settings_set_uint64(
    self._f('GSettings'), $key, $value
  );
}

sub g_settings_set_uint64 ( GSettings $settings, gchar-ptr $key, guint64 $value --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:set-value:
=begin pod
=head2 set-value


Sets I<key> in I<settings> to I<value>.

It is a programmer error to give a I<key> that isn't contained in the
schema for I<settings> or for I<value> to have the incorrect type, per
the schema.

If I<value> is floating then this function consumes the reference.

Returns: C<True> if setting the key succeeded,
C<False> if the key was not writable



  method set-value ( Str $key, N-GVariant $value --> Int )

=item Str $key; the name of the key to set
=item N-GVariant $value; a B<GVariant> of the correct type

=end pod

method set-value ( Str $key, N-GVariant $value --> Int ) {
  my $no = …;
  $no .= get-native-object-no-reffing unless $no ~~ N-GVariant;

  g_settings_set_value(
    self._f('GSettings'), $key, $value
  );
}

sub g_settings_set_value ( GSettings $settings, gchar-ptr $key, N-GVariant $value --> gboolean )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:sync:
=begin pod
=head2 sync


Ensures that all pending operations are complete for the default backend.

Writes made to a B<Gnome::Gio::Settings> are handled asynchronously.  For this
reason, it is very unlikely that the changes have it to disk by the
time C<set()> returns.

This call will block until all of the writes have made it to the
backend.  Since the mainloop is not running, no change notifications
will be dispatched during this call (but some may be queued by the
time the call is done).

  method sync ( )


=end pod

method sync ( ) {

  g_settings_sync(
    self._f('GSettings'),
  );
}

sub g_settings_sync (   )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:unbind:
=begin pod
=head2 unbind


Removes an existing binding for I<property> on I<object>.

Note that bindings are automatically removed when the
object is finalized, so it is rarely necessary to call this
function.



  method unbind ( Pointer $object, Str $property )

=item Pointer $object; (type GObject.Object): the object
=item Str $property; the property whose binding is removed

=end pod

method unbind ( Pointer $object, Str $property ) {

  g_settings_unbind(
    self._f('GSettings'), $object, $property
  );
}

sub g_settings_unbind ( gpointer $object, gchar-ptr $property  )
  is native(&gio-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_g_settings_new:
#`{{
=begin pod
=head2 _g_settings_new


Creates a new B<Gnome::Gio::Settings> object with the schema specified by
I<schema-id>.

Signals on the newly created B<Gnome::Gio::Settings> object will be dispatched
via the thread-default B<GMainContext> in effect at the time of the
call to C<new()>.  The new B<Gnome::Gio::Settings> will hold a reference
on the context.  See [[g-main-context-push-thread-default]].

Returns: a new B<Gnome::Gio::Settings> object



  method _g_settings_new ( Str $schema_id --> GSettings )

=item Str $schema_id; the id of the schema

=end pod
}}

sub _g_settings_new ( gchar-ptr $schema_id --> GSettings )
  is native(&gio-lib)
  is symbol('g_settings_new')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_g_settings_new_full:
#`{{
=begin pod
=head2 _g_settings_new_full


Creates a new B<Gnome::Gio::Settings> object with a given schema, backend and
path.

It should be extremely rare that you ever want to use this function.
It is made available for advanced use-cases (such as plugin systems
that want to provide access to schemas loaded from custom locations,
etc).

At the most basic level, a B<Gnome::Gio::Settings> object is a pure composition of
4 things: a B<GSettingsSchema>, a B<GSettingsBackend>, a path within that
backend, and a B<GMainContext> to which signals are dispatched.

This constructor therefore gives you full control over constructing
B<Gnome::Gio::Settings> instances.  The first 3 parameters are given directly as
I<schema>, I<backend> and I<path>, and the main context is taken from the
thread-default (as per C<new()>).

If I<backend> is C<undefined> then the default backend is used.

If I<path> is C<undefined> then the path from the schema is used.  It is an
error if I<path> is C<undefined> and the schema has no path of its own or if
I<path> is non-C<undefined> and not equal to the path that the schema does
have.

Returns: a new B<Gnome::Gio::Settings> object



  method _g_settings_new_full ( GSettingsSchema $schema, GSettingsBackend $backend, Str $path --> GSettings )

=item GSettingsSchema $schema; a B<GSettingsSchema>
=item GSettingsBackend $backend; (nullable): a B<GSettingsBackend>
=item Str $path; (nullable): the path to use

=end pod
}}

sub _g_settings_new_full ( GSettingsSchema $schema, GSettingsBackend $backend, gchar-ptr $path --> GSettings )
  is native(&gio-lib)
  is symbol('g_settings_new_full')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_g_settings_new_with_backend:
#`{{
=begin pod
=head2 _g_settings_new_with_backend


Creates a new B<Gnome::Gio::Settings> object with the schema specified by
I<schema-id> and a given B<GSettingsBackend>.

Creating a B<Gnome::Gio::Settings> object with a different backend allows accessing
settings from a database other than the usual one. For example, it may make
sense to pass a backend corresponding to the "defaults" settings database on
the system to get a settings object that modifies the system default
settings instead of the settings for this user.

Returns: a new B<Gnome::Gio::Settings> object



  method _g_settings_new_with_backend ( Str $schema_id, GSettingsBackend $backend --> GSettings )

=item Str $schema_id; the id of the schema
=item GSettingsBackend $backend; the B<GSettingsBackend> to use

=end pod
}}

sub _g_settings_new_with_backend ( gchar-ptr $schema_id, GSettingsBackend $backend --> GSettings )
  is native(&gio-lib)
  is symbol('g_settings_new_with_backend')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_g_settings_new_with_backend_and_path:
#`{{
=begin pod
=head2 _g_settings_new_with_backend_and_path


Creates a new B<Gnome::Gio::Settings> object with the schema specified by
I<schema-id> and a given B<GSettingsBackend> and path.

This is a mix of [[new-with-backend]] and
[[g-settings-new-with-path]].

Returns: a new B<Gnome::Gio::Settings> object



  method _g_settings_new_with_backend_and_path ( Str $schema_id, GSettingsBackend $backend, Str $path --> GSettings )

=item Str $schema_id; the id of the schema
=item GSettingsBackend $backend; the B<GSettingsBackend> to use
=item Str $path; the path to use

=end pod
}}

sub _g_settings_new_with_backend_and_path ( gchar-ptr $schema_id, GSettingsBackend $backend, gchar-ptr $path --> GSettings )
  is native(&gio-lib)
  is symbol('g_settings_new_with_backend_and_path')
  { * }

#-------------------------------------------------------------------------------
#TM:1:_g_settings_new_with_path:
#`{{
=begin pod
=head2 _g_settings_new_with_path


Creates a new B<Gnome::Gio::Settings> object with the relocatable schema specified
by I<schema-id> and a given path.

You only need to do this if you want to directly create a settings
object with a schema that doesn't have a specified path of its own.
That's quite rare.

It is a programmer error to call this function for a schema that
has an explicitly specified path.

It is a programmer error if I<path> is not a valid path.  A valid path
begins and ends with '/' and does not contain two consecutive '/'
characters.

Returns: a new B<Gnome::Gio::Settings> object



  method _g_settings_new_with_path ( Str $schema_id, Str $path --> GSettings )

=item Str $schema_id; the id of the schema
=item Str $path; the path to use

=end pod
}}

sub _g_settings_new_with_path ( gchar-ptr $schema_id, gchar-ptr $path --> GSettings )
  is native(&gio-lib)
  is symbol('g_settings_new_with_path')
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
=comment #TS:0:change-event:
=head3 change-event

The "change-event" signal is emitted once per change event that
affects this settings object.  You should connect to this signal
only if you are interested in viewing groups of changes before they
are split out into multiple emissions of the "changed" signal.
For most use cases it is more appropriate to use the "changed" signal.

In the event that the change event applies to one or more specified
keys, I<keys> will be an array of B<GQuark> of length I<n-keys>.  In the
event that the change event applies to the B<Gnome::Gio::Settings> object as a
whole (ie: potentially every key has been changed) then I<keys> will
be C<undefined> and I<n-keys> will be 0.

The default handler for this signal invokes the "changed" signal
for each affected key.  If any other connected handler returns
C<True> then this default functionality will be suppressed.

Returns: C<True> to stop other handlers from being invoked for the
event. FALSE to propagate the event further.

  method handler (
    Unknown type G_TYPE_POINTER $keys,
    Int $n_keys,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($settings),
    *%user-options
    --> Int
  );

=item $settings; the object on which the signal was emitted

=item $keys; (array length=n-keys) (element-type GQuark) (nullable):
an array of B<GQuarks> for the changed keys, or C<undefined>
=item $n_keys; the length of the I<keys> array, or 0


=comment -----------------------------------------------------------------------
=comment #TS:0:changed:
=head3 changed

The "changed" signal is emitted when a key has potentially changed.
You should call one of the C<get()> calls to check the new
value.

This signal supports detailed connections.  You can connect to the
detailed signal "changed::x" in order to only receive callbacks
when key "x" changes.

Note that I<settings> only emits this signal if you have read I<key> at
least once while a signal handler was already connected for I<key>.

  method handler (
    Unknown type G_TYPE_STRING | G_SIGNAL_TYPE_STATIC_SCOPE $key,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($settings),
    *%user-options
  );

=item $settings; the object on which the signal was emitted

=item $key; the name of the key that changed


=comment -----------------------------------------------------------------------
=comment #TS:0:writable-change-event:
=head3 writable-change-event

The "writable-change-event" signal is emitted once per writability
change event that affects this settings object.  You should connect
to this signal if you are interested in viewing groups of changes
before they are split out into multiple emissions of the
"writable-changed" signal.  For most use cases it is more
appropriate to use the "writable-changed" signal.

In the event that the writability change applies only to a single
key, I<key> will be set to the B<GQuark> for that key.  In the event
that the writability change affects the entire settings object,
I<key> will be 0.

The default handler for this signal invokes the "writable-changed"
and "changed" signals for each affected key.  This is done because
changes in writability might also imply changes in value (if for
example, a new mandatory setting is introduced).  If any other
connected handler returns C<True> then this default functionality
will be suppressed.

Returns: C<True> to stop other handlers from being invoked for the
event. FALSE to propagate the event further.

  method handler (
     $key,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($settings),
    *%user-options
    --> Int
  );

=item $settings; the object on which the signal was emitted

=item $key; the quark of the key, or 0


=comment -----------------------------------------------------------------------
=comment #TS:0:writable-changed:
=head3 writable-changed

The "writable-changed" signal is emitted when the writability of a
key has potentially changed.  You should call
[[is-writable]] in order to determine the new status.

This signal supports detailed connections.  You can connect to the
detailed signal "writable-changed::x" in order to only receive
callbacks when the writability of "x" changes.

  method handler (
    Unknown type G_TYPE_STRING | G_SIGNAL_TYPE_STATIC_SCOPE $key,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($settings),
    *%user-options
  );

=item $settings; the object on which the signal was emitted

=item $key; the key


=end pod


#-------------------------------------------------------------------------------
=begin pod
=head1 Properties

An example of using a string type property of a B<Gnome::Gtk3::Label> object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use B<new(:label('my text label'))> or B<gtk_label_set_text('my text label')>.

  my Gnome::Gtk3::Label $label .= new;
  my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
  $label.g-object-get-property( 'label', $gv);
  $gv.g-value-set-string('my text label');

=head2 Supported properties

=comment -----------------------------------------------------------------------
=comment #TP:0:backend:
=head3 GSettingsBackend: backend


   * The name of the context that the settings are stored in.Widget type: G_TYPE_SETTINGS_BACKEND

The B<Gnome::GObject::Value> type of property I<backend> is C<G_TYPE_OBJECT>.

=comment -----------------------------------------------------------------------
=comment #TP:0:delay-apply:
=head3 Delay-apply mode: delay-apply


Whether the B<Gnome::Gio::Settings> object is in 'delay-apply' mode. See
C<delay()> for details.

    *
The B<Gnome::GObject::Value> type of property I<delay-apply> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:has-unapplied:
=head3 Has unapplied changes: has-unapplied


If this property is C<True>, the B<Gnome::Gio::Settings> object has outstanding
    * changes that will be applied when C<apply()> is called.
The B<Gnome::GObject::Value> type of property I<has-unapplied> is C<G_TYPE_BOOLEAN>.

=comment -----------------------------------------------------------------------
=comment #TP:0:path:
=head3 Base path: path


    * The path within the backend where the settings are stored.
The B<Gnome::GObject::Value> type of property I<path> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:schema-id:
=head3 Schema name: schema-id


The name of the schema that describes the types of keys
   * for this B<Gnome::Gio::Settings> object.
The B<Gnome::GObject::Value> type of property I<schema-id> is C<G_TYPE_STRING>.

=comment -----------------------------------------------------------------------
=comment #TP:0:settings-schema:
=head3 schema: settings-schema


The B<GSettingsSchema> describing the types of keys for this
B<Gnome::Gio::Settings> object.

Ideally, this property would be called 'schema'.  B<GSettingsSchema>
has only existed since version 2.32, however, and before then the
'schema' property was used to refer to the ID of the schema rather
   * than the schema itself.  Take care.
The B<Gnome::GObject::Value> type of property I<settings-schema> is C<G_TYPE_BOXED>.
=end pod
