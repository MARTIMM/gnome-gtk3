TITLE
=====

Gnome::Gtk3::AboutDialog

![](images/aboutdialog.png)

SUBTITLE
========

Display information about an application

Description
===========

The `Gnome::Gtk3::AboutDialog` offers a simple way to display information about a program like its logo, name, copyright, website and license. It is also possible to give credits to the authors, documenters, translators and artists who have worked on the program. An about dialog is typically opened when the user selects the `About` option from the `Help` menu. All parts of the dialog are optional.

About dialogs often contain links and email addresses. `Gnome::Gtk3::AboutDialog` displays these as clickable links. By default, it calls gtk_show_uri() when a user clicks one. The behavior can be overridden with the `activate-link` signal.

To specify a person with an email address, use a string like "Edgar Allan Poe <edgar@poe.com>". To specify a website with a title, use a string like "GTK+ team http://www.gtk.org".

Note that GTK+ sets a default title of `_("About %s")` on the dialog window (where \%s is replaced by the name of the application, but in order to ensure proper translation of the title, applications should set the title property explicitly when constructing a `Gnome::Gtk3::AboutDialog`. It is also possible to show a `Gnome::Gtk3::AboutDialog` like any other `Gnome::Gtk3::Dialog`, e.g. using gtk_dialog_run(). In this case, you might need to know that the “Close” button returns the `GTK_RESPONSE_CANCEL` response id.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gtk3::AboutDialog;
    also is Gnome::Gtk3::Dialog;

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

### multi method new ( Bool :$empty! )

Create a new plain object. The value doesn't have to be True nor False. The name only will suffice.

### multi method new ( N-GObject :$widget! )

Create an object using a native object from elsewhere. See also `Gnome::GObject::Object`.

### multi method new ( Str :$build-id! )

Create an object using a native object from a builder. See also `Gnome::GObject::Object`.

gtk_about_dialog_new
--------------------

Creates a new `Gnome::Gtk3::AboutDialog`.

    method gtk_about_dialog_new ( --> N-GObject  )

Returns N-GObject; a newly created native `GtkAboutDialog`

[gtk_about_dialog_] get_program_name
------------------------------------

Returns the program name displayed in the about dialog.

    method gtk_about_dialog_get_program_name ( --> Str  )

Returns Str; The program name. The string is owned by the about dialog and must not be modified.

[gtk_about_dialog_] set_program_name
------------------------------------

Sets the name to display in the about dialog. If this is not set, it defaults to `g_get_application_name()`.

    method gtk_about_dialog_set_program_name ( Str $name )

  * Str $name; the program name

[gtk_about_dialog_] get_version
-------------------------------

Returns the version string.

    method gtk_about_dialog_get_version ( --> Str  )

Returns Str; The version string. The string is owned by the about dialog and must not be modified.

[gtk_about_dialog_] set_version
-------------------------------

Sets the version string to display in the about dialog.

    method gtk_about_dialog_set_version ( Str $version )

  * Str $version; (allow-none): the version string

[gtk_about_dialog_] get_copyright
---------------------------------

Returns the copyright string.

    method gtk_about_dialog_get_copyright ( --> Str  )

Returns Str; The copyright string. The string is owned by the about dialog and must not be modified.

[gtk_about_dialog_] set_copyright
---------------------------------

Sets the copyright string to display in the about dialog. This should be a short string of one or two lines.

    method gtk_about_dialog_set_copyright ( Str $copyright )

  * Str $copyright; (allow-none): the copyright string

[gtk_about_dialog_] get_comments
--------------------------------

Returns the comments string.

    method gtk_about_dialog_get_comments ( --> Str  )

Returns Str; The comments. The string is owned by the about dialog and must not be modified.

[gtk_about_dialog_] set_comments
--------------------------------

Sets the comments string to display in the about dialog. This should be a short string of one or two lines.

    method gtk_about_dialog_set_comments ( Str $comments )

  * Str $comments; (allow-none): a comments string

[gtk_about_dialog_] get_license
-------------------------------

Returns the license information.

    method gtk_about_dialog_get_license ( --> Str  )

Returns Str; The license information. The string is owned by the about dialog and must not be modified.

[gtk_about_dialog_] set_license
-------------------------------

Sets the license information to be displayed in the secondary license dialog. If *license* is `Any`, the license button is hidden.

    method gtk_about_dialog_set_license ( Str $license )

  * Str $license; (allow-none): the license information or Any

[gtk_about_dialog_] set_license_type
------------------------------------

Sets the license of the application showing the *about* dialog from a list of known licenses.

    method gtk_about_dialog_set_license_type ( GtkLicense $license_type )

  * GtkLicense $license_type; the type of license

[gtk_about_dialog_] get_license_type
------------------------------------

Retrieves the license set using `gtk_about_dialog_set_license_type()`

    method gtk_about_dialog_get_license_type ( --> GtkLicense  )

Returns GtkLicense; a `GtkLicense` enum value

[gtk_about_dialog_] get_wrap_license
------------------------------------

Returns whether the license text in *about* is automatically wrapped.

    method gtk_about_dialog_get_wrap_license ( --> Int  )

Returns Int; `1` if the license text is wrapped

[gtk_about_dialog_] set_wrap_license
------------------------------------

Sets whether the license text in *about* is automatically wrapped.

    method gtk_about_dialog_set_wrap_license ( Int $wrap_license )

  * Int $wrap_license; whether to wrap the license

[gtk_about_dialog_] get_website
-------------------------------

Returns the website URL.

    method gtk_about_dialog_get_website ( --> Str  )

Returns Str; The website URL. The string is owned by the about dialog and must not be modified.

[gtk_about_dialog_] set_website
-------------------------------

Sets the URL to use for the website link.

    method gtk_about_dialog_set_website ( Str $website )

  * Str $website; (allow-none): a URL string starting with "http://"

[gtk_about_dialog_] get_website_label
-------------------------------------

Returns the label used for the website link.

    method gtk_about_dialog_get_website_label ( --> Str  )

Returns Str; The label used for the website link. The string is owned by the about dialog and must not be modified.

[gtk_about_dialog_] set_website_label
-------------------------------------

Sets the label to be used for the website link.

    method gtk_about_dialog_set_website_label ( Str $website_label )

  * Str $website_label; the label used for the website link

[gtk_about_dialog_] get_authors
-------------------------------

Returns the string which are displayed in the authors tab of the secondary credits dialog.

    method gtk_about_dialog_get_authors ( --> CArray[Str]  )

Returns CArray[Str]; A `Any`-terminated string array containing the authors. The array is owned by the about dialog and must not be modified.

[gtk_about_dialog_] set_authors
-------------------------------

Sets the strings which are displayed in the authors tab of the secondary credits dialog.

    method gtk_about_dialog_set_authors ( CArray[Str] $authors )

  * CArray[Str] $authors; (array zero-terminated=1): a `Any`-terminated array of strings

[gtk_about_dialog_] get_documenters
-----------------------------------

Returns the string which are displayed in the documenters tab of the secondary credits dialog.

    method gtk_about_dialog_get_documenters ( --> CArray[Str]  )

Returns CArray[Str]; A `Any`-terminated string array containing the documenters. The array is owned by the about dialog and must not be modified.

[gtk_about_dialog_] set_documenters
-----------------------------------

Sets the strings which are displayed in the documenters tab of the secondary credits dialog.

    method gtk_about_dialog_set_documenters ( CArray[Str] $documenters )

  * CArray[Str] $documenters; (array zero-terminated=1): a `Any`-terminated array of strings

[gtk_about_dialog_] get_artists
-------------------------------

Returns the string which are displayed in the artists tab of the secondary credits dialog.

    method gtk_about_dialog_get_artists ( --> CArray[Str]  )

Returns CArray[Str]; A `Any`-terminated string array containing the artists. The array is owned by the about dialog and must not be modified.

[gtk_about_dialog_] set_artists
-------------------------------

Sets the strings which are displayed in the artists tab of the secondary credits dialog.

    method gtk_about_dialog_set_artists ( CArray[Str] $artists )

  * CArray[Str] $artists; (array zero-terminated=1): a `Any`-terminated array of strings

[gtk_about_dialog_] get_translator_credits
------------------------------------------

Returns the translator credits string which is displayed in the translators tab of the secondary credits dialog.

    method gtk_about_dialog_get_translator_credits ( --> Str  )

Returns Str; The translator credits string. The string is owned by the about dialog and must not be modified.

[gtk_about_dialog_] set_translator_credits
------------------------------------------

Sets the translator credits string which is displayed in the translators tab of the secondary credits dialog.

    method gtk_about_dialog_set_translator_credits ( Str $translator_credits )

  * Str $translator_credits; (allow-none): the translator credits

[gtk_about_dialog_] get_logo
----------------------------

Returns the pixbuf displayed as logo in the about dialog.

    method gtk_about_dialog_get_logo ( --> N-GObject  )

Returns N-GObject; the pixbuf displayed as logo. The pixbuf is owned by the about dialog. If you want to keep a reference to it, you have to call `g_object_ref()` on it.

[gtk_about_dialog_] set_logo
----------------------------

Sets the pixbuf to be displayed as logo in the about dialog. If it is Any, the default window icon set with `gtk_window_set_default_icon()` will be used.

    method gtk_about_dialog_set_logo ( N-GObject $logo )

  * N-GObject $logo; a `Gnome::Gdk3::Pixbuf`, or `Any`

[gtk_about_dialog_] get_logo_icon_name
--------------------------------------

Returns the icon name displayed as logo in the about dialog.

    method gtk_about_dialog_get_logo_icon_name ( --> Str  )

Returns Str; the icon name displayed as logo. The string is owned by the dialog. If you want to keep a reference to it, you have to call `g_strdup()` on it.

[gtk_about_dialog_] set_logo_icon_name
--------------------------------------

Sets the pixbuf to be displayed as logo in the about dialog. If it is Any, the default window icon set with `gtk_window_set_default_icon()` will be used.

    method gtk_about_dialog_set_logo_icon_name ( Str $icon_name )

  * Str $icon_name; (allow-none): an icon name, or `Any`

[gtk_about_dialog_] add_credit_section
--------------------------------------

Creates a new section in the Credits page.

    method gtk_about_dialog_add_credit_section (
      Str $section_name, CArray[Str] $people
    )

  * Str $section_name; The name of the section

  * CArray[Str] $people; (array zero-terminated=1): The people who belong to that section

Properties
==========

An example of using a string type property of a `Gnome::Gtk3::Label` object. This is just showing how to set/read a property, not that it is the best way to do it. This is because a) The class initialization often provides some options to set some of the properties and b) the classes provide many methods to modify just those properties. In the case below one can use **new(:label('my text label'))** or **gtk_label_set_text('my text label')**.

    my Gnome::Gtk3::Label $label .= new(:empty);
    my Gnome::GObject::Value $gv .= new(:init(G_TYPE_STRING));
    $label.g-object-get-property( 'label', $gv);
    $gv.g-value-set-string('my text label');

Supported properties
--------------------

### program-name

The `Gnome::GObject::Value` type of property *program-name* is `G_TYPE_STRING`.

The name of the program. If this is not set, it defaults to `g_get_application_name()`.

### version

The `Gnome::GObject::Value` type of property *version* is `G_TYPE_STRING`.

The version of the program.

### copyright

The `Gnome::GObject::Value` type of property *copyright* is `G_TYPE_STRING`.

Copyright information for the program.

### comments

The `Gnome::GObject::Value` type of property *comments* is `G_TYPE_STRING`.

Comments about the program. This string is displayed in a label in the main dialog, thus it should be a short explanation of the main purpose of the program, not a detailed list of features.

### license

The `Gnome::GObject::Value` type of property *license* is `G_TYPE_STRING`.

The license of the program. This string is displayed in a text view in a secondary dialog, therefore it is fine to use a long multi-paragraph text. Note that the text is only wrapped in the text view if the "wrap-license" property is set to `1`; otherwise the text itself must contain the intended linebreaks. When setting this property to a non-`Any` value, the `license`-type property is set to `GTK_LICENSE_CUSTOM` as a side effect.

### license-type

The `Gnome::GObject::Value` type of property *license-type* is `G_TYPE_ENUM`.

The license of the program, as a value of the `GtkLicense` enumeration.

The `Gnome::Gtk3::AboutDialog` will automatically fill out a standard disclaimer and link the user to the appropriate online resource for the license text.

If `GTK_LICENSE_UNKNOWN` is used, the link used will be the same specified in the `website` property.

If `GTK_LICENSE_CUSTOM` is used, the current contents of the `license` property are used.

For any other `Gnome::Gtk3::License` value, the contents of the `license` property are also set by this property as a side effect.

### website

The `Gnome::GObject::Value` type of property *website* is `G_TYPE_STRING`.

The URL for the link to the website of the program. This should be a string starting with "http://.

### website-label

The `Gnome::GObject::Value` type of property *website-label* is `G_TYPE_STRING`.

The label for the link to the website of the program.

### translator-credits

The `Gnome::GObject::Value` type of property *translator-credits* is `G_TYPE_STRING`.

Credits to the translators. This string should be marked as translatable. The string may contain email addresses and URLs, which will be displayed as links, see the introduction for more details.

### logo-icon-name

The `Gnome::GObject::Value` type of property *logo-icon-name* is `G_TYPE_STRING`.

A named icon to use as the logo for the about box. This property overrides the `logo` property.

### wrap-license

The `Gnome::GObject::Value` type of property *wrap-license* is `G_TYPE_BOOLEAN`.

Whether to wrap the text in the license dialog.

Not yet supported properties
----------------------------

### authors

The `Gnome::GObject::Value` type of property *authors* is `G_TYPE_BOXED`.

The authors of the program, as a `Any`-terminated array of strings. Each string may contain email addresses and URLs, which will be displayed as links, see the introduction for more details.

### documenters

The `Gnome::GObject::Value` type of property *documenters* is `G_TYPE_BOXED`.

The people documenting the program, as a `Any`-terminated array of strings. Each string may contain email addresses and URLs, which will be displayed as links, see the introduction for more details.

### artists

The `Gnome::GObject::Value` type of property *artists* is `G_TYPE_BOXED`.

The people who contributed artwork to the program, as a `Any`-terminated array of strings. Each string may contain email addresses and URLs, which will be displayed as links, see the introduction for more details.

### logo

The `Gnome::GObject::Value` type of property *logo* is `G_TYPE_OBJECT`.

A logo for the about box. If it is `Any`, the default window icon set with `gtk_window_set_default_icon()` will be used.

Signals
=======

Register any signal as follows. See also `Gnome::GObject::Object`.

    my Bool $is-registered = $my-widget.register-signal (
      $handler-object, $handler-name, $signal-name,
      :$user-option1, ..., $user-optionN
    )

Not yet supported signals
-------------------------

### activate-link

The signal which gets emitted to activate a URI. Applications may connect to it to override the default behaviour, which is to call `gtk_show_uri()`.

Returns: `1` if the link has been activated

    method handler (
      Gnome::GObject::Object :widget($label),
      :handler-arg0($uri),
      :$user-option1, ..., $user-optionN
    );

  * $label; The object on which the signal was emitted

  * $uri; the URI that is activated

