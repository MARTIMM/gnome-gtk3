use v6;

#-------------------------------------------------------------------------------
=begin pod

=TITLE Gnome::Gtk3::Main

=SUBTITLE Main loop and Events — Library initialization, main event loop, and events

  unit class Gnome::Gtk3::Main;

=head1 Synopsis

  my Gnome::Gtk3::Main $main .= new;

  # Setup user interface
  ...
  # Start main loop
  $main.gtk_main;

  # Elsewhere in some exit handler
  method exit ( ) {
    Gnome::Gtk3::Main.new.gtk_main_quit;
  }

=end pod

#-------------------------------------------------------------------------------
use NativeCall;

use Gnome::N::X;
use Gnome::N::N-GObject;
use Gnome::N::NativeLib;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkmain.h
# https://developer.gnome.org/gtk3/stable/gtk3-General.html
unit class Gnome::Gtk3::Main:auth<github:MARTIMM>;

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $gui-initialized = False;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create a GtkMain object. Initialization of GTK is automatically executed if not already done. Arguments from the command line are provided to this process.

  submethod BUILD ( Bool :$check = False )

=item $check; Use checked initialization. Program will not fail when commandline
arguments do not parse properly.

=end pod

submethod BUILD ( Bool :$check = False ) {

  if not $gui-initialized {
    # Must setup gtk otherwise perl6 will crash
    my $argc = CArray[int32].new;
    $argc[0] = 1 + @*ARGS.elems;

    my $arg_arr = CArray[Str].new;
    my Int $arg-count = 0;
    $arg_arr[$arg-count++] = $*PROGRAM.Str;
    for @*ARGS -> $arg {
      $arg_arr[$arg-count++] = $arg;
    }

    my $argv = CArray[CArray[Str]].new;
    $argv[0] = $arg_arr;

    $check ?? gtk_init_check( $argc, $argv) !! gtk_init( $argc, $argv);
    $gui-initialized = True;
  }
}

#-------------------------------------------------------------------------------
method FALLBACK ( $native-sub is copy, |c ) {

  CATCH { test-catch-exception( $_, $native-sub); }

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');
  die X::Gnome.new(:message(
      "Native sub name '$native-sub' made too short. Keep at least one '-' or '_'."
    )
  ) unless $native-sub.index('_') >= 0;

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_main_$native-sub"); }

  #test-call( &$s, Any, |c)
  $s(|c)
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
sub gtk_init ( CArray[int32] $argc, CArray[CArray[Str]] $argv )
    is native(&gtk-lib)
    { * }

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
sub gtk_init_check ( CArray[int32] $argc, CArray[CArray[Str]] $argv )
    returns int32
    is native(&gtk-lib)
    { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_events_pending
Checks if any events are pending.

This can be used to update the UI and invoke timeouts etc. while doing some time intensive computation.

  method gtk_events_pending ( )

Example

  # Computation going on ...

  $main.gtk_main_iteration() while ( $main.gtk_events_pending() );

  # Computation continued ...

=end pod

sub gtk_events_pending ( )
    returns int32
    is native(&gtk-lib)
    { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_main

Runs the main loop until C<gtk_main_quit()> is called. You can nest calls to C<gtk_main()>. In that case C<gtk_main_quit()> will make the innermost invocation of the main loop return.

  method gtk_main ( )

=end pod

sub gtk_main ( )
    is native(&gtk-lib)
    { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_main_level

Returns the current nesting level of the main loop.

  method gtk_main_level ( --> Int )

=end pod

sub gtk_main_level ( )
    returns uint32
    is native(&gtk-lib)
    { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_main_quit

Makes the innermost invocation of the main loop return when it regains control.

  method gtk_main_quit ( )

=end pod

sub gtk_main_quit ( )
    is native(&gtk-lib)
    { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_main_iteration

Runs a single iteration of the mainloop.

If no events are waiting to be processed GTK+ will block until the next event is noticed. If you don’t want to block look at C<gtk_main_iteration_do()> or check if any events are pending with C<gtk_events_pending()> first.

  method gtk_main_iteration ( --> Int )

Returns 1 if C<gtk_main_quit()> has been called for the innermost mainloop

=end pod

sub gtk_main_iteration ( )
    returns int32
    is native(&gtk-lib)
    { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_main_iteration_do

Runs a single iteration of the mainloop. If no events are available either return or block depending on the value of blocking.

  method gtk_main_iteration_do ( Int $blocking --> Int )

=item $blocking; 1 if you want GTK+ to block if no events are pending.

Returns 1 if C<gtk_main_quit()> has been called for the innermost mainloop

=end pod

sub gtk_main_iteration_do ( int32 $blocking )
    returns int32
    is native(&gtk-lib)
    { * }
