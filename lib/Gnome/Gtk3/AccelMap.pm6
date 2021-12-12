#TL:1:Gnome::Gtk3::AccelMap:

use v6;
#-------------------------------------------------------------------------------
=begin pod

=head1 Gnome::Gtk3::AccelMap

Loadable keyboard accelerator specifications


=comment ![](images/X.png)


=head1 Description

Accelerator maps are used to define runtime configurable accelerators. Functions for manipulating them are usually used by higher level convenience mechanisms like B<Gnome::Gtk3::Builder> and are thus considered “low-level”. You’ll want to use them if you’re manually creating menus that should have user-configurable accelerators.

An accelerator is uniquely defined by:
=item accelerator path
=item accelerator key
=item accelerator modifiers

The U<accelerator path> must consist of C<I<“<WINDOWTYPE>/Category1/Category2/.../Action”>>, where C<WINDOWTYPE> should be a unique application-specific identifier that corresponds to the kind of window the accelerator is being used in, e.g. “Gimp-Image”, “Abiword-Document” or “Gnumeric-Settings”.
The C<“Category1/.../Action”> portion is most appropriately chosen by the action the accelerator triggers, i.e. for accelerators on menu items, choose the item’s menu path, e.g. C<“File/Save As”>, C<“Image/View/Zoom”> or C<“Edit/Select All”>. So a full valid accelerator path may look like: “<Gimp-Toolbox>/File/Dialogs/Tool Options...”.

All accelerators are stored inside one global B<Gnome::Gtk3::AccelMap> that can be obtained using C<get()>.
=comment See [Monitoring changes][monitoring-changes] for additional details.


=head2 Manipulating accelerators

New accelerators can be added using C<add-entry()>. To search for specific accelerator, use C<lookup-entry()>. Modifications of existing accelerators should be done using C<change-entry()>.

In order to avoid having some accelerators changed, they can be locked using C<lock-path()>. Unlocking is done using C<unlock-path()>.


=head2 Saving and loading accelerator maps

Accelerator maps can be saved to and loaded from some external resource. For simple saving and loading from file, C<save()> and C<load()> are provided.
=comment Saving and loading can also be done by providing a file descriptor to C<save-fd()> and C<load-fd()>.


=head2 Monitoring changes

B<Gnome::Gtk3::AccelMap> object is only useful for monitoring changes of accelerators. By connecting to I<changed> signal, one can monitor changes of all accelerators. It is also possible to monitor only single accelerator path by using it as a detail of  the  I<changed> signal.


=head2 See Also

B<Gnome::Gtk3::AccelGroup>, C<Gnome::Gtk3::Widget.set-accel-path()>, C<Gnome::Gtk3::MenuItem-set-accel-path()>

=comment B<Gnome::Gtk3::AccelKey>, B<Gnome::Gtk3::UIManager>


=head1 Synopsis
=head2 Declaration

  unit class Gnome::Gtk3::AccelMap;
  also is Gnome::GObject::Object;


=head2 Uml Diagram

![](plantuml/AccelMap-Group.svg)


=begin comment
=head2 Inheriting this class

Inheriting is done in a special way in that it needs a call from new() to get the native object created by the class you are inheriting from.

  use Gnome::Gtk3::AccelMap;

  unit class MyGuiClass;
  also is Gnome::Gtk3::AccelMap;

  submethod new ( |c ) {
    # let the Gnome::Gtk3::AccelMap class process the options
    self.bless( :GtkAccelMap, |c);
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

use Gnome::GObject::Object;

use Gnome::Gtk3::AccelGroup;

#-------------------------------------------------------------------------------
unit class Gnome::Gtk3::AccelMap:auth<github:MARTIMM>:ver<0.1.0>;
also is Gnome::GObject::Object;

#-------------------------------------------------------------------------------
my Gnome::Gtk3::AccelMap $instance;
my Bool $signals-added = False;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

This module is a singleton. The modules C<new()> method throws an exeption. To get an object of this class use the method C<instance()>.

=begin comment
=head3 default, no options

Create a new AccelMap object.

  multi method new ( )


=head3 :native-object

Create a AccelMap object using a native object from elsewhere. See also B<Gnome::N::TopLevelClassSupport>.

  multi method new ( N-GObject :$native-object! )

=head3 :build-id

Create a AccelMap object using a native object returned from a builder. See also B<Gnome::GObject::Object>.

  multi method new ( Str :$build-id! )

=end comment
=end pod

#TM:1:new():
#TM:1:instance():
method new ( ) { !!! }

method instance ( --> Gnome::Gtk3::AccelMap ) {
  $instance //= self.bless
}

submethod BUILD ( *%options ) {

  # add signal info in the form of w*<signal-name>.
  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name,
      :w3<changed>,
    );

    # signals from interfaces
    #_add_..._signal_types($?CLASS.^name);
  }

  # get the global singleton object
  my $no = _gtk_accel_map_get();
  self.set-native-object($no);
  self._set-class-info('GtkAccelMap');

#`{{
  # prevent creating wrong native-objects
  if self.^name eq 'Gnome::Gtk3::AccelMap' #`{{ or %options<GtkAccelMap> }} {

    # check if native object is set by a parent class
    if self.is-valid { }

    # check if common options are handled by some parent
    elsif %options<native-object>:exists { }
    elsif %options<build-id>:exists { }

    # process all other options
    else {
      my $no;
      if ? %options<___x___> {
        $no = %options<___x___>;
        $no .= get-native-object-no-reffing unless $no ~~ N-GObject;
        #$no = _gtk_accel_map_new___x___($no);
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
        $no = _gtk_accel_map_new();
      }
      }}

      self.set-native-object($no);
    }

    # only after creating the native-object, the gtype is known
    self._set-class-info('GtkAccelMap');
  }
}}
}


#-------------------------------------------------------------------------------
#TM:1:add-entry:
=begin pod
=head2 add-entry

Registers a new accelerator with the global accelerator map. This function should only be called once per I<a$ccel-path> with the canonical I<$accel-key> and I<$accel-mods> for this path. To change the accelerator during runtime programatically, use C<change-entry()>.

Set I<$accel-key> and I<$accel-mods> to 0 to request a removal of the accelerator.

=comment Note that I<$accel-path> string will be stored in a B<Gnome::Glib::Quark>. Therefore, if you pass a static string, you can save some memory by interning it first with C<g-intern-static-string()>.

  method add-entry (
    Str $accel-path, UInt $accel-key, UInt $accel-mods
  )

=item Str $accel-path; valid accelerator path
=item UInt $accel-key; the accelerator key
=item UInt $accel-mods; the accelerator modifiers mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.
=end pod

method add-entry (
  Str $accel-path, UInt $accel-key, UInt $accel-mods
) {
  gtk_accel_map_add_entry( $accel-path, $accel-key, $accel-mods);
}

sub gtk_accel_map_add_entry (
  gchar-ptr $accel-path, guint $accel-key, GFlag $accel-mods
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:add-filter:
=begin pod
=head2 add-filter

Adds a filter to the global list of accel path filters.

Accel map entries whose accel path matches one of the filters are skipped by C<foreach()>.

This function is intended for GTK+ modules that create their own menus, but don’t want them to be saved into the applications accelerator map dump.

  method add-filter ( Str $filter_pattern )

=item Str $filter_pattern; a pattern (see B<Gnome::Gtk3::PatternSpec>)
=end pod

method add-filter ( Str $filter_pattern ) {
  gtk_accel_map_add_filter($filter_pattern);
}

sub gtk_accel_map_add_filter (
  gchar-ptr $filter_pattern
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:change-entry:
=begin pod
=head2 change-entry

Changes the I<$accel-key> and I<$accel-mods> currently associated with I<accel-path>. Due to conflicts with other accelerators, a change may not always be possible, I<$replace> indicates whether other accelerators may be deleted to resolve such conflicts. A change will only occur if all conflicts could be resolved (which might not be the case if conflicting accelerators are locked). Successful changes are indicated by a C<True> return value.

=comment Note that I<$accel-path> string will be stored in a B<Gnome::Gtk3::Quark>. Therefore, if you pass a static string, you can save some memory by interning it first with C<g-intern-static-string()>.

Returns: C<True> if the accelerator could be changed, C<False> otherwise

  method change-entry (
    Str $accel-path, UInt $accel-key,
    UInt $accel-mods, Bool $replace
    --> Bool
  )

=item Str $accel-path; a valid accelerator path
=item UInt $accel-key; the new accelerator key
=item UInt $accel-mods; the new accelerator modifier mask from GdkModifierType to be found in B<Gnome::Gdk3::Types>.
=item Bool $replace; C<True> if other accelerators may be deleted upon conflicts
=end pod

method change-entry (
  Str $accel-path, UInt $accel-key, UInt $accel-mods, Bool $replace --> Bool
) {

  gtk_accel_map_change_entry(
    $accel-path, $accel-key, $accel-mods, $replace
  ).Bool
}

sub gtk_accel_map_change_entry (
  gchar-ptr $accel-path, guint $accel-key, GEnum $accel-mods, gboolean $replace --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:foreach:
=begin pod
=head2 foreach

Loops over the entries in the accelerator map whose accel path doesn’t match any of the filters added with C<add-filter()>, and execute the method in the provided object on each.

  method foreach (
    Any:D $handler-object, Str:D $handler-name, *%options
  )

=item $handler-object; the object wherein the metod is defined
=item $handler-name; method to be executed for each accel map entry which is not filtered out.
=item %options; Optional data passed to the method.

The method receives the following arguments;
=item Str $accel-path; a valid accelerator path
=item UInt $accel-key; the new accelerator key
=item GdkModifierType $accel-mods; the new accelerator modifier mask found in B<Gnome::Gdk3::Types>.
=item Bool $changed; Changed flag of the accelerator (if TRUE, accelerator has changed during runtime and would need to be saved during an accelerator dump).
=item any options provided at the foreach call

=item2
=end pod

method foreach ( Any:D $handler-object, Str:D $handler-name, *%options ) {
  CONTROL { when CX::Warn {  note .gist; .resume; } }
  CATCH { default { .message.note; .backtrace.concise.note } }

  die X::Gnome.new(
    :message("Method '$handler-name' not found in user provided object")
  ) unless $handler-object.^can($handler-name);

  gtk_accel_map_foreach(
    gpointer,
    ->  gpointer $d, Str $accel-path, guint $accel-key, guint $accel-mods,
        gboolean $changed {
          CONTROL { when CX::Warn {  note .gist; .resume; } }
          CATCH { default { .message.note; .backtrace.concise.note } }

          $handler-object."$handler-name"(
            $accel-path, $accel-key, $accel-mods, $changed.Bool, |%options
          );
        }
  );
}

sub gtk_accel_map_foreach (
  gpointer $data,
  Callable $foreach-func (
    gpointer $d, Str $accel-path, guint $accel-key,
    guint $accel-mods, gboolean $changed
  )
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:foreach-unfiltered:
=begin pod
=head2 foreach-unfiltered

Loops over all entries in the accelerator map, and execute I<foreach-func> on each. The signature of I<foreach-func> is that of B<Gnome::Gtk3::AccelMapForeach>, the I<changed> parameter indicates whether this accelerator was changed during runtime (thus, would need saving during an accelerator map dump).

  method foreach-unfiltered (
    Any:D $handler-object, Str:D $handler-name, *%options
  )

=item $handler-object; the object wherein the metod is defined
=item $handler-name; method to be executed for each accel map entry which is not filtered out.
=item %options; Optional data passed to the method.

The method receives the following arguments;
=item Str $accel-path; a valid accelerator path
=item UInt $accel-key; the new accelerator key
=item GdkModifierType $accel-mods; the new accelerator modifier mask found in B<Gnome::Gdk3::Types>.
=item Bool $changed; Changed flag of the accelerator (if TRUE, accelerator has changed during runtime and would need to be saved during an accelerator dump).
=item any options provided at the foreach call

=end pod

method foreach-unfiltered (
  Any:D $handler-object, Str:D $handler-name, *%options
) {
  CONTROL { when CX::Warn {  note .gist; .resume; } }
  CATCH { default { .message.note; .backtrace.concise.note } }

  die X::Gnome.new(
    :message("Method '$handler-name' not found in user provided object")
  ) unless $handler-object.^can($handler-name);

  gtk_accel_map_foreach_unfiltered(
    gpointer,
    ->  gpointer $d, Str $accel-path, guint $accel-key, guint $accel-mods,
        gboolean $changed {
          CONTROL { when CX::Warn {  note .gist; .resume; } }
          CATCH { default { .message.note; .backtrace.concise.note } }

          $handler-object."$handler-name"(
            $accel-path, $accel-key, $accel-mods, $changed.Bool, |%options
          );
        }
  );
}

sub gtk_accel_map_foreach_unfiltered (
  gpointer $data,
  Callable $foreach-func (
    gpointer $d, Str $accel-path, guint $accel-key,
    guint $accel-mods, gboolean $changed
  )
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:_gtk_accel_map_get:
#`{{
=begin pod
=head2 get

Gets the singleton global B<Gnome::Gtk3::AccelMap> object. This object is useful only for notification of changes to the accelerator map via the I<changed> signal; it isn’t a parameter to the other accelerator map functions.

Returns: the global B<Gnome::Gtk3::AccelMap> object

  method get ( --> N-GObject )

=end pod

method get ( --> N-GObject ) {

  gtk_accel_map_get(
    self.get-native-object-no-reffing,
  )
}
}}

sub _gtk_accel_map_get ( --> N-GObject )
  is native(&gtk-lib)
  is symbol('gtk_accel_map_get')
  { * }

#-------------------------------------------------------------------------------
#TM:1:load:
=begin pod
=head2 load

Parses a file previously saved with C<save()> for accelerator specifications, and propagates them accordingly.

  method load ( Str $file_name )

=item Str $file_name; (type filename): a file containing accelerator specifications, in the GLib file name encoding
=end pod

method load ( Str $file_name ) {
  gtk_accel_map_load($file_name);
}

sub gtk_accel_map_load (
  gchar-ptr $file_name
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:0:load-fd:
=begin pod
=head2 load-fd

Filedescriptor variant of C<load()>.

Note that the file descriptor will not be closed by this function.

  method load-fd ( Int() $fd )

=item Int() $fd; a valid readable file descriptor
=end pod

method load-fd ( Int() $fd ) {

  gtk_accel_map_load_fd(
    self.get-native-object-no-reffing, $fd
  );
}

sub gtk_accel_map_load_fd (
  gint $fd
) is native(&gtk-lib)
  { * }
}}

#`{{
#-------------------------------------------------------------------------------
# TM:0:load-scanner:
=begin pod
=head2 load-scanner

B<Gnome::Gio::Scanner> variant of C<load()>.

  method load-scanner ( N-GObject $scanner )

=item N-GObject $scanner; a B<Gnome::Gtk3::Scanner> which has already been provided with an input file
=end pod

method load-scanner ( $scanner is copy ) {
  $scanner .= get-native-object-no-reffing unless $scanner ~~ N-GObject;

  gtk_accel_map_load_scanner(
    self.get-native-object-no-reffing, $scanner
  );
}

sub gtk_accel_map_load_scanner (
  N-GObject $scanner
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:lock-path:
=begin pod
=head2 lock-path

Locks the given accelerator path. If the accelerator map doesn’t yet contain an entry for I<$accel-path>, a new one is created.

Locking an accelerator path prevents its accelerator from being changed during runtime. A locked accelerator path can be unlocked by C<unlock-path()>. Refer to C<gtk-accel-map-change-entry()> for information about runtime accelerator changes.

If called more than once, I<$accel-path> remains locked until C<unlock-path()> has been called an equivalent number of times.

Note that locking of individual accelerator paths is independent from locking the B<Gnome::Gtk3::AccelGroup> containing them. For runtime accelerator changes to be possible, both the accelerator path and its B<Gnome::Gtk3::AccelGroup> have to be unlocked.

  method lock-path ( Str $accel-path )

=item Str $accel-path; a valid accelerator path
=end pod

method lock-path ( Str $accel-path ) {
  gtk_accel_map_lock_path($accel-path);
}

sub gtk_accel_map_lock_path (
  gchar-ptr $accel-path
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:lookup-entry:
=begin pod
=head2 lookup-entry

Looks up the accelerator entry for I<$accel-path> and returns a C<N-GtkAccelKey> structure.

Returns: A defined C<N-GtkAccelKey> structure if I<$accel-path> is known, undefined otherwise

  method lookup-entry ( Str $accel-path --> N-GtkAccelKey )

=item Str $accel-path; a valid accelerator path
=item N-GtkAccelKey $key; the accelerator key to be filled in
=end pod

method lookup-entry ( Str $accel-path --> N-GtkAccelKey ) {
  my N-GtkAccelKey $ak .= new;
  my Bool $r = gtk_accel_map_lookup_entry( $accel-path, $ak).Bool;
  $ak
}

sub gtk_accel_map_lookup_entry (
  gchar-ptr $accel-path, N-GtkAccelKey $key --> gboolean
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
#TM:1:save:
=begin pod
=head2 save

Saves current accelerator specifications (accelerator path, key and modifiers) to I<file-name>. The file is written in a format suitable to be read back in by C<load()>.

  method save ( Str $file_name )

=item Str $file_name; (type filename): the name of the file to contain accelerator specifications, in the GLib file name encoding
=end pod

method save ( Str $file_name ) {
  gtk_accel_map_save($file_name);
}

sub gtk_accel_map_save (
  gchar-ptr $file_name
) is native(&gtk-lib)
  { * }

#`{{
#-------------------------------------------------------------------------------
# TM:0:save-fd:
=begin pod
=head2 save-fd

Filedescriptor variant of C<save()>.

Note that the file descriptor will not be closed by this function.

  method save-fd ( Int() $fd )

=item Int() $fd; a valid writable file descriptor
=end pod

method save-fd ( Int() $fd ) {

  gtk_accel_map_save_fd(
    self.get-native-object-no-reffing, $fd
  );
}

sub gtk_accel_map_save_fd (
  gint $fd
) is native(&gtk-lib)
  { * }
}}

#-------------------------------------------------------------------------------
#TM:1:unlock-path:
=begin pod
=head2 unlock-path

Undoes the last call to C<lock-path()> on this I<accel-path>. Refer to C<gtk-accel-map-lock-path()> for information about accelerator path locking.

  method unlock-path ( Str $accel-path )

=item Str $accel-path; a valid accelerator path
=end pod

method unlock-path ( Str $accel-path ) {
  gtk_accel_map_unlock_path($accel-path);
}

sub gtk_accel_map_unlock_path (
  gchar-ptr $accel-path
) is native(&gtk-lib)
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
=comment #TS:0:changed:
=head3 changed

Notifies of a change in the global accelerator map. The path is also used as the detail for the signal, so it is possible to connect to changed::`accel-path`.

  method handler (
    Str $accel-path,
    UInt $accel-key,
    UInt $accel-mods,
    Int :$_handle_id,
    Gnome::GObject::Object :_widget($object),
    *%user-options
    --> Int
  );

=item $object; the global accel map object
=item $accel-path; the path of the accelerator that changed
=item $accel-key; the key value for the new accelerator
=item $accel-mods; the modifier mask for the new accelerator. A GdkModifierType mask from Gnome::Gdk3::Types
=item $_handle_id; the registered event handler id

=end pod
