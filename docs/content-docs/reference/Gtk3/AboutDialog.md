Gnome::Gtk3::AboutDialog
========================

Display information about an application

![](images/aboutdialog.png)

Description
===========

The **Gnome::Gtk3::AboutDialog** offers a simple way to display information about a program like its logo, name, copyright, website and license. It is also possible to give credits to the authors, documenters, translators and artists who have worked on the program. An about dialog is typically opened when the user selects the `About` option from the `Help` menu. All parts of the dialog are optional.

About dialogs often contain links and email addresses. **Gnome::Gtk3::AboutDialog** displays these as clickable links. By default, it calls gtk_show_uri() when a user clicks one. The behavior can be overridden with the `activate-link` signal.

To specify a person with an email address, use a string like "Edgar Allan Poe <edgar@poe.com>". To specify a website with a title, use a string like "GTK+ team http://www.gtk.org".

To make constructing a **Gnome::Gtk3::AboutDialog** as convenient as possible, you can use the function `gtk_show_about_dialog()` which constructs and shows a dialog and keeps it around so that it can be shown again.

Note that GTK+ sets a default title of `_("About %s")` on the dialog window (where \%s is replaced by the name of the application, but in order to ensure proper translation of the title, applications should set the title property explicitly when constructing a **Gnome::Gtk3::AboutDialog**.

It is also possible to show a **Gnome::Gtk3::AboutDialog** like any other **Gnome::Gtk3::Dialog**, e.g. using gtk_dialog_run(). In this case, you might need to know that the “Close” button returns the `GTK_RESPONSE_CANCEL` response id.

Implemented Interfaces
----------------------

  * [Gnome::Gtk3::Buildable](Buildable.html)

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::AboutDialog;
    also is Gnome::Gtk3::Dialog;
    also does Gnome::Gtk3::Buildable;

Example
=======

    my Gnome::Gtk3::AboutDialog $about .= new(:empty);

    $about.set-program-name('My-First-GTK-Program');

    # Show the dialog.The status can be tested for which button was pressed
    my Int $return-status = $about.gtk-dialog-run;

    # When dialog buttons are pressed control returns here.
    # Hide the dialog again.
    $about.gtk-widget-hide;

Types
=====

enum GtkLicense
---------------

The type of license for an application. This enumeration can be expanded at later date.

Since: 3.0

  * GTK_LICENSE_UNKNOWN: No license specified

  * GTK_LICENSE_CUSTOM: A license text is going to be specified by the developer

  * GTK_LICENSE_GPL_2_0: The GNU General Public License, version 2.0 or later

  * GTK_LICENSE_GPL_3_0: The GNU General Public License, version 3.0 or later

  * GTK_LICENSE_LGPL_2_1: The GNU Lesser General Public License, version 2.1 or later

  * GTK_LICENSE_LGPL_3_0: The GNU Lesser General Public License, version 3.0 or later

  * GTK_LICENSE_BSD: The BSD standard license

  * GTK_LICENSE_MIT_X11: The MIT/X11 standard license

  * GTK_LICENSE_ARTISTIC: The Artistic License, version 2.0

  * GTK_LICENSE_GPL_2_0_ONLY: The GNU General Public License, version 2.0 only. Since 3.12.

  * GTK_LICENSE_GPL_3_0_ONLY: The GNU General Public License, version 3.0 only. Since 3.12.

  * GTK_LICENSE_LGPL_2_1_ONLY: The GNU Lesser General Public License, version 2.1 only. Since 3.12.

  * GTK_LICENSE_LGPL_3_0_ONLY: The GNU Lesser General Public License, version 3.0 only. Since 3.12.

  * GTK_LICENSE_AGPL_3_0: The GNU Affero General Public License, version 3.0 or later. Since: 3.22.

  * GTK_LICENSE_AGPL_3_0_ONLY: The GNU Affero General Public License, version 3.0 only. Since: 3.22.27.

Methods
=======

new
---

Create a new plain object.

    multi method new ( Bool :empty! )

Create an object using a native object from elsewhere. See also **Gnome::GObject::Object**.

    multi method new ( N-GObject :$widget! )

Create an object using a native object from a builder. See also **Gnome::GObject::Object**.

    multi method new ( Str :$build-id! )

[gtk_] about_dialog_new
-----------------------

Creates a new **Gnome::Gtk3::AboutDialog**.

Returns: a newly created native AboutDialog object.

Since: 2.6

    method gtk_about_dialog_new ( --> N-GObject  )

Returns N-GObject; a newly created native `GtkAboutDialog`

[[gtk_] about_dialog_] get_program_name
---------------------------------------

Returns the program name displayed in the about dialog.

Returns: The program name. The string is owned by the about dialog and must not be modified.

Since: 2.12

    method gtk_about_dialog_get_program_name ( --> Str  )

[[gtk_] about_dialog_] set_program_name
---------------------------------------

Sets the name to display in the about dialog. If this is not set, it defaults to `g_get_application_name()`.

Since: 2.12

    method gtk_about_dialog_set_program_name ( Str $name )

  * Str $name; the program name

[[gtk_] about_dialog_] get_version
----------------------------------

Returns the version string.

Returns: The version string. The string is owned by the about dialog and must not be modified.

Since: 2.6

    method gtk_about_dialog_get_version ( --> Str  )

[[gtk_] about_dialog_] set_version
----------------------------------

Sets the version string to display in the about dialog.

Since: 2.6

    method gtk_about_dialog_set_version ( Str $version )

  * Str $version; (allow-none): the version string

[[gtk_] about_dialog_] get_copyright
------------------------------------

Returns the copyright string.

Returns: The copyright string. The string is owned by the about dialog and must not be modified.

Since: 2.6

    method gtk_about_dialog_get_copyright ( --> Str  )

[[gtk_] about_dialog_] set_copyright
------------------------------------

Sets the copyright string to display in the about dialog. This should be a short string of one or two lines.

Since: 2.6

    method gtk_about_dialog_set_copyright ( Str $copyright )

  * Str $copyright; (allow-none): the copyright string

[[gtk_] about_dialog_] get_comments
-----------------------------------

Returns the comments string.

Returns: The comments. The string is owned by the about dialog and must not be modified.

Since: 2.6

    method gtk_about_dialog_get_comments ( --> Str  )

[[gtk_] about_dialog_] set_comments
-----------------------------------

Sets the comments string to display in the about dialog. This should be a short string of one or two lines.

Since: 2.6

    method gtk_about_dialog_set_comments ( Str $comments )

  * Str $comments; (allow-none): a comments string

[[gtk_] about_dialog_] get_license
----------------------------------

Returns the license information.

Returns: The license information. The string is owned by the about dialog and must not be modified.

Since: 2.6

    method gtk_about_dialog_get_license ( --> Str  )

[[gtk_] about_dialog_] set_license
----------------------------------

Sets the license information to be displayed in the secondary license dialog. If *license* is `Any`, the license button is hidden.

Since: 2.6

    method gtk_about_dialog_set_license ( Str $license )

  * Str $license; (allow-none): the license information or `Any`

[[gtk_] about_dialog_] set_license_type
---------------------------------------

Sets the license of the application showing the *about* dialog from a list of known licenses.

This function overrides the license set using `gtk_about_dialog_set_license()`.

Since: 3.0

    method gtk_about_dialog_set_license_type ( GtkLicense $license_type )

  * GtkLicense $license_type; the type of license

[[gtk_] about_dialog_] get_license_type
---------------------------------------

Retrieves the license set using `gtk_about_dialog_set_license_type()`

Returns: a *Gnome::Gtk3::License* value

Since: 3.0

    method gtk_about_dialog_get_license_type ( --> GtkLicense  )

[[gtk_] about_dialog_] get_wrap_license
---------------------------------------

Returns whether the license text in *about* is automatically wrapped.

Returns: `1` if the license text is wrapped

Since: 2.8

    method gtk_about_dialog_get_wrap_license ( --> Int  )

[[gtk_] about_dialog_] set_wrap_license
---------------------------------------

Sets whether the license text in *about* is automatically wrapped.

Since: 2.8

    method gtk_about_dialog_set_wrap_license ( Int $wrap_license )

  * Int $wrap_license; whether to wrap the license

[[gtk_] about_dialog_] get_website
----------------------------------

Returns the website URL.

Returns: The website URL. The string is owned by the about dialog and must not be modified.

Since: 2.6

    method gtk_about_dialog_get_website ( --> Str  )

[[gtk_] about_dialog_] set_website
----------------------------------

Sets the URL to use for the website link.

Since: 2.6

    method gtk_about_dialog_set_website ( Str $website )

  * Str $website; (allow-none): a URL string starting with "http://"

[[gtk_] about_dialog_] get_website_label
----------------------------------------

Returns the label used for the website link.

Returns: The label used for the website link. The string is owned by the about dialog and must not be modified.

Since: 2.6

    method gtk_about_dialog_get_website_label ( --> Str  )

[[gtk_] about_dialog_] set_website_label
----------------------------------------

Sets the label to be used for the website link.

Since: 2.6

    method gtk_about_dialog_set_website_label ( Str $website_label )

  * Str $website_label; the label used for the website link

[[gtk_] about_dialog_] get_authors
----------------------------------

Returns the string which are displayed in the authors tab of the secondary credits dialog.

Returns: (array zero-terminated=1) (transfer none): A `Any`-terminated string array containing the authors. The array is owned by the about dialog and must not be modified.

Since: 2.6

    method gtk_about_dialog_get_authors ( --> CArray[Str]  )

[[gtk_] about_dialog_] set_authors
----------------------------------

Sets the strings which are displayed in the authors tab of the secondary credits dialog.

Since: 2.6

    method gtk_about_dialog_set_authors ( CArray[Str] $authors )

  * CArray[Str] $authors; (array zero-terminated=1): a `Any`-terminated array of strings

[[gtk_] about_dialog_] get_documenters
--------------------------------------

Returns the string which are displayed in the documenters tab of the secondary credits dialog.

Returns: (array zero-terminated=1) (transfer none): A `Any`-terminated string array containing the documenters. The array is owned by the about dialog and must not be modified.

Since: 2.6

    method gtk_about_dialog_get_documenters ( --> CArray[Str]  )

[[gtk_] about_dialog_] set_documenters
--------------------------------------

Sets the strings which are displayed in the documenters tab of the secondary credits dialog.

Since: 2.6

    method gtk_about_dialog_set_documenters ( CArray[Str] $documenters )

  * CArray[Str] $documenters; (array zero-terminated=1): a `Any`-terminated array of strings

[[gtk_] about_dialog_] get_artists
----------------------------------

Returns the string which are displayed in the artists tab of the secondary credits dialog.

Returns: (array zero-terminated=1) (transfer none): A `Any`-terminated string array containing the artists. The array is owned by the about dialog and must not be modified.

Since: 2.6

    method gtk_about_dialog_get_artists ( --> CArray[Str]  )

[[gtk_] about_dialog_] set_artists
----------------------------------

Sets the strings which are displayed in the artists tab of the secondary credits dialog.

Since: 2.6

    method gtk_about_dialog_set_artists ( CArray[Str] $artists )

  * CArray[Str] $artists; (array zero-terminated=1): a `Any`-terminated array of strings

[[gtk_] about_dialog_] get_translator_credits
---------------------------------------------

Returns the translator credits string which is displayed in the translators tab of the secondary credits dialog.

Returns: The translator credits string. The string is owned by the about dialog and must not be modified.

Since: 2.6

    method gtk_about_dialog_get_translator_credits ( --> Str  )

[[gtk_] about_dialog_] set_translator_credits
---------------------------------------------

Sets the translator credits string which is displayed in the translators tab of the secondary credits dialog.

The intended use for this string is to display the translator of the language which is currently used in the user interface. Using `gettext()`, a simple way to achieve that is to mark the string for translation:

    $about-dialog.set-translator-credits("translator-credits");

It is a good idea to use the customary msgid “translator-credits” for this purpose, since translators will already know the purpose of that msgid, and since *Gnome::Gtk3::AboutDialog* will detect if “translator-credits” is untranslated and hide the tab.

Since: 2.6

    method gtk_about_dialog_set_translator_credits ( Str $translator_credits )

  * Str $translator_credits; (allow-none): the translator credits

[[gtk_] about_dialog_] get_logo
-------------------------------

Returns the pixbuf displayed as logo in the about dialog.

Returns: (transfer none): the pixbuf displayed as logo. The pixbuf is owned by the about dialog. If you want to keep a reference to it, you have to call `g_object_ref()` on it.

Since: 2.6

    method gtk_about_dialog_get_logo ( --> N-GObject  )

[[gtk_] about_dialog_] set_logo
-------------------------------

Sets the pixbuf to be displayed as logo in the about dialog. If it is `Any`, the default window icon set with `gtk_window_set_default_icon()` will be used.

Since: 2.6

    method gtk_about_dialog_set_logo ( N-GObject $logo )

  * N-GObject $logo; (allow-none): a *Gnome::Gdk3::Pixbuf*, or `Any`

[[gtk_] about_dialog_] get_logo_icon_name
-----------------------------------------

Returns the icon name displayed as logo in the about dialog.

Returns: the icon name displayed as logo. The string is owned by the dialog. If you want to keep a reference to it, you have to call `g_strdup()` on it.

Since: 2.6

    method gtk_about_dialog_get_logo_icon_name ( --> Str )

[[gtk_] about_dialog_] set_logo_icon_name
-----------------------------------------

Sets the pixbuf to be displayed as logo in the about dialog. If it is `Any`, the default window icon set with `gtk_window_set_default_icon()` will be used.

Since: 2.6

    method gtk_about_dialog_set_logo_icon_name ( Str $icon_name )

  * Str $icon_name; (allow-none): an icon name, or `Any`

[[gtk_] about_dialog_] add_credit_section
-----------------------------------------

Creates a new section in the Credits page.

Since: 3.4

    method gtk_about_dialog_add_credit_section ( Str $section_name, CArray[Str] $people )

  * Str $section_name; The name of the section

  * CArray[Str] $people; (array zero-terminated=1): The people who belong to that section

Properties
==========

An example of using a string type property of a **Gnome::Gtk3::Label** object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

### Program name

The name of the program. If this is not set, it defaults to `g_get_application_name()`.

Since: 2.12

The **Gnome::GObject::Value** type of property *program-name* is `G_TYPE_STRING`.

### Program version

The version of the program.

Since: 2.6

The **Gnome::GObject::Value** type of property *version* is `G_TYPE_STRING`.

### Copyright string

Copyright information for the program.

Since: 2.6

The **Gnome::GObject::Value** type of property *copyright* is `G_TYPE_STRING`.

### Comments string

Comments about the program. This string is displayed in a label in the main dialog, thus it should be a short explanation of the main purpose of the program, not a detailed list of features.

Since: 2.6

The **Gnome::GObject::Value** type of property *comments* is `G_TYPE_STRING`.

### License

The license of the program. This string is displayed in a text view in a secondary dialog, therefore it is fine to use a long multi-paragraph text. Note that the text is only wrapped in the text view if the "wrap-license" property is set to `1`; otherwise the text itself must contain the intended linebreaks. When setting this property to a non-`Any` value, the sig *license-type* property is set to `GTK_LICENSE_CUSTOM` as a side effect.

Since: 2.6

The **Gnome::GObject::Value** type of property *license* is `G_TYPE_STRING`.

### License Type

The license of the program, as a value of the `GtkLicense` enumeration.

The *Gnome::Gtk3::AboutDialog* will automatically fill out a standard disclaimer and link the user to the appropriate online resource for the license text.

If `GTK_LICENSE_UNKNOWN` is used, the link used will be the same specified in the sig *website* property.

If `GTK_LICENSE_CUSTOM` is used, the current contents of the sig *license* property are used.

For any other *Gnome::Gtk3::License* value, the contents of the sig *license* property are also set by this property as a side effect.

Since: 3.0

Widget type: GTK_TYPE_LICENSE

The **Gnome::GObject::Value** type of property *license-type* is `G_TYPE_ENUM`.

### Website URL

The URL for the link to the website of the program. This should be a string starting with "http://.

Since: 2.6

The **Gnome::GObject::Value** type of property *website* is `G_TYPE_STRING`.

### Website label

The label for the link to the website of the program.

Since: 2.6

The **Gnome::GObject::Value** type of property *website-label* is `G_TYPE_STRING`.

### Logo Icon Name

A named icon to use as the logo for the about box. This property overrides the sig *logo* property.

Since: 2.6

The **Gnome::GObject::Value** type of property *logo-icon-name* is `G_TYPE_STRING`.

### Wrap license

Whether to wrap the text in the license dialog.

Since: 2.8

The **Gnome::GObject::Value** type of property *wrap-license* is `G_TYPE_BOOLEAN`.

Signals
=======

There are two ways to connect to a signal. The first option you have is to use `register-signal()` from **Gnome::GObject::Object**. The second option is to use `g_signal_connect_object()` directly from **Gnome::GObject::Signal**.

First method
------------

The positional arguments of the signal handler are all obligatory as well as their types. The named attributes `:$widget` and user data are optional.

    # handler method
    method mouse-event ( GdkEvent $event, :$widget ) { ... }

    # connect a signal on window object
    my Gnome::Gtk3::Window $w .= new( ... );
    $w.register-signal( self, 'mouse-event', 'button-press-event');

The register method is defined as;

    my Bool $is-registered = $widget.register-signal (
      $handler-object, $handler-name, $signal-name,
      :$user-option1, ..., :$user-optionN
    )

Where

  * $handler-object; A Raku object holding the handler method =*self*

  * $handler-name; The handler method =*mouse-event*

  * $signal-name; The signal to connect to =*button-press-event*

  * $user-option*; User options are given to the user unchanged as named arguments. The name 'widget' is reserved.

Second method
-------------

    my Gnome::Gtk3::Window $w .= new( ... );
    my Callable $handler = sub (
      N-GObject $native, GdkEvent $event, OpaquePointer $data
    ) {
      ...
    }

    $w.connect-object( 'button-press-event', $handler);

Also here, the types of positional arguments in the signal handler are important. This is because both methods `register-signal()` and `g_signal_connect_object()` are using the signatures of the handler routines to setup the native call interface.

Supported signals
-----------------

activate-link
-------------

The signal which gets emitted to activate a URI. Applications may connect to it to override the default behaviour, which is to call `gtk_show_uri()`.

Returns: `1` if the link has been activated.

    method handler (
      Str $uri,
      Gnome::GObject::Object :$widget,
      *%user-options
      --> Int
    );

  * $widget; The object on which the signal was emitted.

  * $uri; the URI that is activated.

