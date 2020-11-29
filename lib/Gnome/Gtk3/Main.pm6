#TL:1:Gnome::Gtk3::Main:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::Main

Library initialization, main event loop, and events

=head1 Description

Before using GTK+, you need to initialize it; initialization connects to the window system display, and parses some standard command line arguments. The C<gtk_init()> macro initializes GTK+. C<gtk_init()> exits the application if errors occur; to avoid this, use C<gtk_init_check()>. C<gtk_init_check()> allows you to recover from a failed GTK+ initialization - you might start up your application in text mode instead.

However, in these Gnome packages the initialization takes place automatically as soon as possible. It happens when an object is created which has B<Gnome::GObject::Object> as its parent. It calls C<gtk_init_check()> to initialize GTK+. If other actions are needed before using GTK, it is necessary to initialize by hand. This will be as easy as instantiating this class;

  my Gnome::Gtk3::Main .= new;

Like all GUI toolkits, GTK+ uses an event-driven programming model. When the user is doing nothing, GTK+ sits in the “main loop” and waits for input. If the user performs some action - say, a mouse click - then the main loop “wakes up” and delivers an event to GTK+. GTK+ forwards the event to one or more widgets.

When widgets receive an event, they frequently emit one or more “signals”. Signals notify your program that "something interesting happened" by invoking functions you’ve connected to the signal with C<register-signal()> from B<Gnome::GObject::Object>. Functions connected to a signal are often termed “callbacks”.

When your callbacks are invoked, you would typically take some action - for example, when an Open button is clicked you might display a B<Gnome::Gtk3::FileChooserDialog>. After a callback finishes, GTK+ will return to the main loop and await more user input.

=head2 Typical MAIN function for a GTK+ application

  # Set up signal handlers
  class SigHandlers {
    ...
  }

  sub MAIN ( ... ) {
    my Gnome::Gtk3::Window $top-window .= new;
    $top-window.set-title('My Application Window');

    # Set up GUI elements
    ...

    # Register signal handlers
    ...

    # Show all of the Gui and start event loop
    $top-window.show-all;
    Gnome::Gtk3::Main.new.gtk-main;

    # Event loop finished, exit program
  }

=begin comment
=head2 See Also

See the GLib manual, especially B<GMainLoop> and signal-related
https://developer.gnome.org/gtk3/stable/gtk3-General.html
https://developer.gnome.org/glib/stable/glib-The-Main-Event-Loop.html
=end comment

=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::Main;

=head2 Example

  # Setup user interface
  ...
  # Start main loop
  Gnome::Gtk3::Main.new.gtk-main;

  # Elsewhere in some exit handler
  method exit ( ) {
    Gnome::Gtk3::Main.new.gtk-main-quit;
  }

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;
use Gnome::N::GlibToRakuTypes;
use Gnome::Glib::OptionContext;
use Gnome::Gdk3::Events;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkmain.h
# https://developer.gnome.org/gtk3/stable/gtk3-General.html
unit class Gnome::Gtk3::Main:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
my Bool $gui-initialized = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a GtkMain object. Initialization of GTK is automatically executed if not already done. Arguments from the command line are provided to this process and GTK specific options are removed. See also L<Running GTK+ Applications|https://developer.gnome.org/gtk3/stable/gtk-running.html>

  submethod BUILD ( Bool :$check = False )

=item $check; Use checked initialization. Program will not fail when commandline arguments do not parse properly.

=end pod

#TM:1:new(:check):

# commandline args: https://www.systutorials.com/docs/linux/man/7-gtk-options/
# or https://developer.gnome.org/gtk3/stable/gtk-running.html
#TODO rewrite? because init is done now in Object using pinched sub from here
submethod BUILD ( Bool :$check = False ) {

  if not $gui-initialized {
    # Must setup gtk otherwise Raku will crash
    my $argc = int-ptr.new;
    $argc[0] = 1 + @*ARGS.elems;

    my $arg_arr = char-pptr.new;
    my Int $arg-count = 0;
    $arg_arr[$arg-count++] = $*PROGRAM.Str;
    for @*ARGS -> $arg {
      $arg_arr[$arg-count++] = $arg;
    }

    my $argv = char-ppptr.new;
    $argv[0] = $arg_arr;

    $check ?? gtk_init_check( $argc, $argv) !! gtk_init( $argc, $argv);
    $gui-initialized = True;

    @*ARGS = ();
    for ^$argc[0] -> $i {
      # skip first argument == programname
      next unless $i;
      @*ARGS.push: $argv[0][$i];
    }
  }
}

#-------------------------------------------------------------------------------
method FALLBACK ( $native-sub is copy, |c ) {

  CATCH { .note; die; }

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');
#  die X::Gnome.new(:message(
#      "Native sub name '$native-sub' made too short. Keep at least one '-' or '_'."
#    )
#  ) unless $native-sub.index('_') >= 0;

  my Callable $s;
  try { $s = &::("gtk_main_$native-sub"); };
  try { $s = &::("gtk_$native-sub"); } unless ?$s;
  try { $s = &::($native-sub); } if !$s and $native-sub ~~ m/^ 'gtk_' /;

  $s(|c)
}

#-------------------------------------------------------------------------------
#TM:1:gtk_check_version:
=begin pod
=head2 [gtk_] check_version

Checks that the GTK+ library in use is compatible with the given version. Generally you would pass in the constants B<GTK_MAJOR_VERSION>, B<GTK_MINOR_VERSION>, B<GTK_MICRO_VERSION> as the three arguments to this function; that produces a check that the library in use is compatible with the version of GTK+ the application or module was compiled against.

Compatibility is defined by two things: first, the version of the running library is newer than the version I<$required_major>.I<$required_minor>.I<$required_micro>. Second, the running library must be binary compatible with the version I<$required_major>.I<$required_minor>.I<$required_micro> (same major version).

This function is primarily for GTK+ modules; the module can call this function to check that it wasn’t loaded into an incompatible version of GTK+. However, such a check isn’t completely reliable, since the module may be linked against an old version of GTK+ and calling the old version of C<gtk_check_version()>, but still get loaded into an application using a newer version of GTK+.

Returns: C<undefined> if the GTK+ library is compatible with the given version, or a string describing the version mismatch. The returned string is owned by GTK+ and should not be modified or freed.

  method gtk_check_version (
    UInt $required_major, UInt $required_minor,
    UInt $required_micro
    --> Str
  )

=item UInt $required_major; the required major version
=item UInt $required_minor; the required minor version
=item UInt $required_micro; the required micro version

=end pod

sub gtk_check_version (
  uint32 $required_major, uint32 $required_minor, uint32 $required_micro
  --> Str
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_parse_args:
=begin pod
=head2 [gtk_] parse_args

Parses command line arguments, and initializes global attributes of GTK+, but does not actually open a connection to a display. (See C<gdk_display_open()>, C<gdk_get_display_arg_name()>)

Any arguments used by GTK+ or GDK are removed from the array and I<$argc> and I<$argv> are updated accordingly.

There is no need to call this function explicitly if you are using C<gtk_init()>, or C<gtk_init_check()>.

Note that many aspects of GTK+ require a display connection to function, so this way of initializing GTK+ is really only useful for specialized use cases.

Returns: C<1> if initialization succeeded, otherwise C<0>

  method gtk_parse_args ( int32 $argc, CArray[CArray[Str]] $argv --> Int  )

=item int32 $argc; (inout): a pointer to the number of command line arguments
=item CArray[CArray[Str]] $argv; (array length=argc) (inout): a pointer to the array of command line arguments

=end pod

sub gtk_parse_args ( int32 $argc, CArray[CArray[Str]] $argv --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_init:
=begin pod
=head2 [gtk_] init

Call this function before using any other GTK+ functions in your GUI applications.  It will initialize everything needed to operate the toolkit and parses some standard command line options.

Although you are expected to pass the I<$argc>, I<$argv> parameters from C<main()> to this function, it is possible to pass undefined if I<$argv> is not available or commandline handling is not required.

I<$argc> and I<$argv> are adjusted accordingly so your own code will never see those standard arguments.

Note that there are some alternative ways to initialize GTK+: if you are calling C<gtk_parse_args()>, C<gtk_init_check()>, C<gtk_init_with_args()> or C<g_option_context_parse()> with the option group returned by C<gtk_get_option_group()>, you don’t have to call C<gtk_init()>.

And if you are using B<Gnome::Gtk3::Application>, you don't have to call any of the initialization functions either; the  I<startup> handler does it for you.

This function will terminate your program if it was unable to initialize the windowing system for some reason. If you want your program to fall back to a textual interface you want to call C<gtk_init_check()> instead.

Since 2.18, GTK+ calls `signal (SIGPIPE, SIG_IGN)` during initialization, to ignore SIGPIPE signals, since these are almost never wanted in graphical applications. If you do need to handle SIGPIPE for some reason, reset the handler after C<gtk_init()>, but notice that other libraries (e.g. libdbus or gvfs) might do similar things.

  method gtk_init ( CArray[int32] $argc, CArray[CArray[Str]] $argv )

=item CArray[int32] $argc; (inout): Address of the `argc` parameter of your C<main()> function (or 0 if I<argv> is C<Any>). This will be changed if  any arguments were handled.
=item CArray[CArray[Str]] $argv; (array length=argc) (inout) (allow-none): Address of the `argv` parameter of C<main()>, or C<Any>. Any options understood by GTK+ are stripped before return.

=end pod

sub gtk_init ( CArray[int32] $argc, CArray[CArray[Str]] $argv )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:2:gtk_init_check:new(:check)
=begin pod
=head2 [gtk_] init_check

This function does the same work as C<gtk_init()> with only a single
change: It does not terminate the program if the windowing system
can’t be initialized. Instead it returns C<0> on failure.

This way the application can fall back to some other means of
communication with the user - for example a curses or command line
interface.

Returns: C<1> if the windowing system has been successfully
initialized, C<0> otherwise

  method gtk_init_check (
    CArray[int32] $argc, CArray[CArray[Str]] $argv --> Int
  )

=item CArray[int32] $argc; (inout): Address of the `argc` parameter of your C<main()> function (or 0 if I<argv> is C<Any>). This will be changed if  any arguments were handled.
=item CArray[CArray[Str]] $argv; (array length=argc) (inout) (allow-none): Address of the `argv` parameter of C<main()>, or C<Any>. Any options understood by GTK+ are stripped before return.

=end pod

sub gtk_init_check ( CArray[int32] $argc, CArray[CArray[Str]] $argv --> int32 )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
NOTE: not supported because
  - arguments can be changed easily in Raku before defining MAIN()
  - help info can can be shown easily using USAGE()

# TM:0:gtk_init_with_args:
=begin pod
=head2 [gtk_] init_with_args

This function does the same work as C<gtk_init_check()>.
Additionally, it allows you to add your own commandline options,
and it automatically generates nicely formatted
`--help` output. Note that your program will
be terminated after writing out the help output.

Returns: C<1> if the windowing system has been successfully
initialized, C<0> otherwise


  method gtk_init_with_args ( Int $argc, CArray[Str] $argv, Str $parameter_string, GOptionEntry $entries, Str $translation_domain, N-GError $error --> Int  )

=item Int $argc; (inout): Address of the `argc` parameter of your C<main()> function (or 0 if I<argv> is C<Any>). This will be changed if  any arguments were handled.
=item CArray[Str] $argv; (array length=argc) (inout) (allow-none): Address of the `argv` parameter of C<main()>, or C<Any>. Any options understood by GTK+ are stripped before return.
=item Str $parameter_string; (allow-none): a string which is displayed in the first line of `--help` output, after `programname [OPTION...]`
=item GOptionEntry $entries; (array zero-terminated=1): a C<Any>-terminated array of B<GOptionEntrys> describing the options of your program
=item Str $translation_domain; (nullable): a translation domain to use for translating the `--help` output for the options in I<entries> and the I<parameter_string> with C<gettext()>, or C<Any>
=item N-GError $error; a return location for errors

=end pod

sub gtk_init_with_args ( int32 $argc, CArray[Str] $argv, Str $parameter_string, GOptionEntry $entries, Str $translation_domain, N-GError $error )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:0:gtk_get_option_group:
=begin pod
=head2 [gtk_] get_option_group

Returns a B<N-GOptionGroup> for the commandline arguments recognized by GTK+ and GDK.

You should add this group to your B<N-GOptionContext> with C<g_option_context_add_group()>, if you are using C<g_option_context_parse()> to parse your commandline arguments.

Returns: a B<N-GOptionGroup> for the commandline arguments recognized by GTK+


  method gtk_get_option_group ( Int $open_default_display --> N-GOptionGroup  )

=item Int $open_default_display; whether to open the default display when parsing the commandline arguments

=end pod

sub gtk_get_option_group ( int32 $open_default_display --> N-GOptionGroup )
  is native(&gtk-lib)
  { * }


#`{{
#-------------------------------------------------------------------------------
NOTE: not supported because there is no info about its use

# TM:0:gtk_init_abi_check:
=begin pod
=head2 [gtk_] init_abi_check



  method gtk_init_abi_check ( int32 $argc, CArray[Str] $argv, int32 $num_checks, size_t $sizeof_GtkWindow, size_t $sizeof_GtkBox )

=item int32 $argc;
=item CArray[Str] $argv;
=item int32 $num_checks;
=item size_t $sizeof_GtkWindow;
=item size_t $sizeof_GtkBox;

=end pod

sub gtk_init_abi_check ( int32 $argc, CArray[Str] $argv, int32 $num_checks, size_t $sizeof_GtkWindow, size_t $sizeof_GtkBox )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
NOTE: not supported because there is no info about its use

# TM:0:gtk_init_check_abi_check:
=begin pod
=head2 [gtk_] init_check_abi_check



  method gtk_init_check_abi_check ( int32 $argc, CArray[Str] $argv, int32 $num_checks, size_t $sizeof_GtkWindow, size_t $sizeof_GtkBox --> Int  )

=item int32 $argc;
=item CArray[Str] $argv;
=item int32 $num_checks;
=item size_t $sizeof_GtkWindow;
=item size_t $sizeof_GtkBox;

=end pod

sub gtk_init_check_abi_check ( int32 $argc, CArray[Str] $argv, int32 $num_checks, size_t $sizeof_GtkWindow, size_t $sizeof_GtkBox )
  returns int32
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
NOTE: not supported because we are in a modern world

# TM:0:gtk_disable_setlocale:
=begin pod
=head2 [gtk_] disable_setlocale

Prevents C<gtk_init()>, C<gtk_init_check()>, C<gtk_init_with_args()> and
C<gtk_parse_args()> from automatically
calling `setlocale (LC_ALL, "")`. You would
want to use this function if you wanted to set the locale for
your program to something other than the user’s locale, or if
you wanted to set different values for different locale categories.

Most programs should not need to call this function.

  method gtk_disable_setlocale ( )


=end pod

sub gtk_disable_setlocale (  )
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
#TM:0:gtk_get_default_language:
=begin pod
=head2 [gtk_] get_default_language

Returns the B<PangoLanguage> for the default language currently in effect. (Note that this can change over the life of an application.) The default language is derived from the current locale. It determines, for example, whether GTK+ uses the right-to-left or left-to-right text direction.

This function is equivalent to C<pango_language_get_default()>. See that function for details.

Returns: the default language as a B<PangoLanguage>, must not be freed

  method gtk_get_default_language ( --> PangoLanguage  )

=end pod

sub gtk_get_default_language (  )
  returns PangoLanguage
  is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:gtk_get_locale_direction:
=begin pod
=head2 [gtk_] get_locale_direction

Get the direction of the current locale. This is the expected reading direction for text and UI.

This function depends on the current locale being set with C<setlocale()> and will default to setting the C<GTK_TEXT_DIR_LTR> direction otherwise. C<GTK_TEXT_DIR_NONE> will never be returned.

GTK+ sets the default text direction according to the locale during C<gtk_init()>, and you should normally use C<gtk_widget_get_direction()> or C<gtk_widget_get_default_direction()> to obtain the current direction.

This function is only needed in rare cases when the locale is changed after GTK+ has already been initialized. In this case, you can use it to update the default text direction as follows:

=begin comment
setlocale( LC_ALL, new_locale);
direction = C<gtk_get_locale_direction()>;
gtk_widget_set_default_direction (direction);
=end comment

Returns: the B<TextDirection> enumeration type of the current locale

  method gtk_get_locale_direction ( --> GtkTextDirection  )

=end pod

sub gtk_get_locale_direction ( --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:gtk_events_pending:other tests
=begin pod
=head2 [gtk_] events_pending

Checks if any events are pending. This can be used to update the UI and invoke timeouts etc. while doing some time intensive computation.

=head3 Example Updating the UI during a long computation

  # computation going on...

  while ( $main.events-pending() ) {
    $main.main-iteration;
  }

  # ...computation continued


Returns: C<1> if any events are pending, C<0> otherwise

  method gtk_events_pending ( --> Int  )


=end pod

sub gtk_events_pending ( --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_main_do_event:
=begin pod
=head2 [[gtk_] main_] do_event

Processes a single GDK event. This is public only to allow filtering of events between GDK and GTK+. You will not usually need to call this function directly.

While you should not call this function directly, you might want to know how exactly events are handled. So here is what this function does with the event:

=item Compress enter/leave notify events. If the event passed build an enter/leave pair together with the next event (peeked from GDK), both events are thrown away. This is to avoid a backlog of (de-)highlighting widgets crossed by the pointer.

=item Find the widget which got the event. If the widget can’t be determined the event is thrown away unless it belongs to a INCR transaction.

=item Then the event is pushed onto a stack so you can query the currently handled event with C<gtk_get_current_event()>.

=item The event is sent to a widget. If a grab is active all events for widgets that are not in the contained in the grab widget are sent to the latter with a few exceptions;
=item 2 Deletion and destruction events are still sent to the event widget for obvious reasons.
=item 2 Events which directly relate to the visual representation of the event widget.
=item 2 Leave events are delivered to the event widget if there was an enter event delivered to it before without the paired leave event.
=item 2 Drag events are not redirected because it is unclear what the semantics of that would be. Another point of interest might be that all key events are first passed through the key snooper functions if there are any. Read the description of C<gtk_key_snooper_install()> if you need this feature.

=item After finishing the delivery the event is popped from the event stack.

  method gtk_main_do_event ( N-GdkEvent $event )

=item N-GdkEvent $event; An event to process (normally passed by GDK)

=end pod

sub gtk_main_do_event ( N-GdkEvent $event )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:gtk_main:all programs
=begin pod
=head2 [[gtk_] main_] gtk_main

Runs the main loop until C<gtk_main_quit()> is called. You can nest calls to C<gtk_main()>. In that case C<gtk_main_quit()> will make the innermost invocation of the main loop return.

  method gtk_main ( )

=end pod

sub gtk_main (  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:gtk_main_level:several tests
=begin pod
=head2 [gtk_] main_level

Asks for the current nesting level of the main loop.

Returns: the nesting level of the current invocation of the main loop

  method gtk_main_level ( --> UInt  )


=end pod

sub gtk_main_level ( --> uint32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:gtk_main_quit:all programs
=begin pod
=head2 [gtk_] main_quit

Makes the innermost invocation of the main loop return when it regains control.

  method gtk_main_quit ( )

=end pod

sub gtk_main_quit (  )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:gtk_main_iteration:several tests
=begin pod
=head2 [gtk_] main_iteration

Runs a single iteration of the mainloop.

If no events are waiting to be processed GTK+ will block until the next event is noticed. If you don’t want to block look at C<gtk_main_iteration_do()> or check if any events are pending with C<gtk_events_pending()> first.

Returns: C<1> if C<gtk_main_quit()> has been called for the innermost mainloop

  method gtk_main_iteration ( --> Int )

=end pod

sub gtk_main_iteration ( --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:4:gtk_main_iteration_do:several tests
=begin pod
=head2 [[gtk_] main_] iteration_do

Runs a single iteration of the mainloop. If no events are available either return or block depending on the value of I<$blocking>.

Returns: C<1> if C<gtk_main_quit()> has been called for the innermost mainloop

  method gtk_main_iteration_do ( Bool $blocking --> Int  )

=item Bool $blocking; C<True> if you want GTK+ to block if no events are pending

=end pod

sub gtk_main_iteration_do ( int32 $blocking --> int32 )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_grab_add:
=begin pod
=head2 [gtk_] grab_add

Makes I<$widget> the current grabbed widget.

This means that interaction with other widgets in the same application is blocked and mouse as well as keyboard events are delivered to this widget.

If I<$widget> is not sensitive, it is not set as the current grabbed widget and this function does nothing.

  method gtk_grab_add ( N-GObject $widget )

=item N-GObject $widget; The widget that grabs keyboard and pointer events

=end pod

sub gtk_grab_add ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_grab_get_current:
=begin pod
=head2 [gtk_] grab_get_current

Queries the current grab of the default window group.

Returns: The widget which currently has the grab or C<undefined> if no grab is active.

  method gtk_grab_get_current ( --> N-GObject  )


=end pod

sub gtk_grab_get_current (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_grab_remove:
=begin pod
=head2 [gtk_] grab_remove

Removes the grab from the given widget.

You have to pair calls to C<gtk_grab_add()> and C<gtk_grab_remove()>.

If I<$widget> does not have the grab, this function does nothing.

  method gtk_grab_remove ( N-GObject $widget )

=item N-GObject $widget; The widget which gives up the grab

=end pod

sub gtk_grab_remove ( N-GObject $widget )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_device_grab_add:
=begin pod
=head2 [gtk_] device_grab_add

Adds a GTK+ grab on I<$device>, so all the events on I<$device> and its associated pointer or keyboard (if any) are delivered to I<$widget>. If the I<$block_others> parameter is C<1>, any other devices will be unable to interact with I<$widget> during the grab.

  method gtk_device_grab_add (
    N-GObject $widget, N-GObject $device, Int $block_others
  )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item N-GObject $device; a B<Gnome::Gdk3::Device> to grab on.
=item Int $block_others; C<1> to prevent other devices to interact with I<$widget>.

=end pod

sub gtk_device_grab_add ( N-GObject $widget, N-GObject $device, int32 $block_others )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:0:gtk_device_grab_remove:
=begin pod
=head2 [gtk_] device_grab_remove

Removes a device grab from the given widget.

You have to pair calls to C<gtk_device_grab_add()> and C<gtk_device_grab_remove()>.

  method gtk_device_grab_remove ( N-GObject $widget, N-GObject $device )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item N-GObject $device; a B<Gnome::Gdk3::Device>

=end pod

sub gtk_device_grab_remove ( N-GObject $widget, N-GObject $device )
  is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
NOTE: no support for gdk_event_free()

# TM:0:gtk_get_current_event:
=begin pod
=head2 [gtk_] get_current_event

Obtains a copy of the event currently being processed by GTK+.

For example, if you are handling a I<clicked> signal, the current event will be the B<Gnome::Gdk3::EventButton> that triggered the I<clicked> signal.

Returns: a copy of the current event, or C<undefined> if there is no current event. The returned event must be freed with C<gdk_event_free()>.

  method gtk_get_current_event ( --> N-GdkEvent  )

=end pod

sub gtk_get_current_event (  )
  returns N-GdkEvent
  is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
NOTE: no use for it this kind of event handling?

# TM:0:gtk_get_current_event_time:
=begin pod
=head2 [gtk_] get_current_event_time

If there is a current event and it has a timestamp,
return that timestamp, otherwise return C<GDK_CURRENT_TIME>.

Returns: the timestamp from the current event,
or C<GDK_CURRENT_TIME>.

  method gtk_get_current_event_time ( --> UInt  )


=end pod

sub gtk_get_current_event_time (  )
  returns uint32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# TM:0:gtk_get_current_event_state:
=begin pod
=head2 [gtk_] get_current_event_state

If there is a current event and it has a state field, place
that state field in I<state> and return C<1>, otherwise return
C<0>.

Returns: C<1> if there was a current event and it
had a state field

  method gtk_get_current_event_state ( GdkModifierType $state --> Int  )

=item GdkModifierType $state; (out): a location to store the state of the current event

=end pod

sub gtk_get_current_event_state ( int32 $state )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# TM:0:gtk_get_current_event_device:
=begin pod
=head2 [gtk_] get_current_event_device

If there is a current event and it has a device, return that
device, otherwise return C<Any>.

Returns: (transfer none) (nullable): a B<Gnome::Gdk3::Device>, or C<Any>

  method gtk_get_current_event_device ( --> N-GObject  )


=end pod

sub gtk_get_current_event_device (  )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# TM:0:gtk_get_event_widget:
=begin pod
=head2 [gtk_] get_event_widget

If I<event> is C<Any> or the event was not associated with any widget,
returns C<Any>, otherwise returns the widget that received the event
originally.

Returns: (transfer none) (nullable): the widget that originally
received I<event>, or C<Any>

  method gtk_get_event_widget ( N-GdkEvent $event --> N-GObject  )

=item N-GdkEvent $event; a B<Gnome::Gdk3::Event>

=end pod

sub gtk_get_event_widget ( N-GdkEvent $event )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# TM:0:gtk_propagate_event:
=begin pod
=head2 [gtk_] propagate_event

Sends an event to a widget, propagating the event to parent widgets
if the event remains unhandled.

Events received by GTK+ from GDK normally begin in C<gtk_main_do_event()>.
Depending on the type of event, existence of modal dialogs, grabs, etc.,
the event may be propagated; if so, this function is used.

C<gtk_propagate_event()> calls C<gtk_widget_event()> on each widget it
decides to send the event to. So C<gtk_widget_event()> is the lowest-level
function; it simply emits the  I<event> and possibly an
event-specific signal on a widget. C<gtk_propagate_event()> is a bit
higher-level, and C<gtk_main_do_event()> is the highest level.

All that said, you most likely don’t want to use any of these
functions; synthesizing events is rarely needed. There are almost
certainly better ways to achieve your goals. For example, use
C<gdk_window_invalidate_rect()> or C<gtk_widget_queue_draw()> instead
of making up expose events.

  method gtk_propagate_event ( N-GObject $widget, N-GdkEvent $event )

=item N-GObject $widget; a B<Gnome::Gtk3::Widget>
=item N-GdkEvent $event; an event

=end pod

sub gtk_propagate_event ( N-GObject $widget, N-GdkEvent $event )
  is native(&gtk-lib)
  { * }
}}
