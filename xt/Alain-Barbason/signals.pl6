#!/usr/bin/env perl6

use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Window;

my Gnome::Gtk3::Main $m .= new;

use Gnome::N::X;

class AppSignalHandlers {

  method quick-message ( :widget($button), Str :$message --> Int ) {
    say "click $message";

    # unregister before second registration (not implemented!!!)
#    $button.unregister( self, 'quick-message', 'clicked')
    $button.register-signal(
       self, 'quick-message', 'clicked', :message("\nSecond message\n")
    );

    1
  }

  # Handle window managers 'close app' button
  method exit-program ( --> Int ) {
    $m.gtk-main-quit;

    1
  }
}


my Gnome::Gtk3::Window $top-window .= new(:title('Message dialog'));
my Gnome::Gtk3::Button $button .= new(:label('Show Dialog'));
$top-window.gtk-container-add($button);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new(:$top-window);

$button.register-signal(
  $ash, 'quick-message', 'clicked', :message("\nYou've donnit again, bravo!\n")
);

$top-window.register-signal( $ash, 'exit-program', 'destroy');
$top-window.show-all;

$m.gtk-main;
