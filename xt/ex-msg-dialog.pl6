use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Box;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Dialog;

my Gnome::Gtk3::Main $m .= new;

use Gnome::N::X;
Gnome::N::debug(:on);


class AppSignalHandlers {

  has Gnome::Gtk3::Window $!top-window;

  submethod BUILD ( Gnome::Gtk3::Window :$!top-window ) { }

  method quick-message ( Str :$message --> Int ) {

    my Gnome::Gtk3::Dialog $dialog .= new(
      :title('Message Dialog'), :parent($!top-window),
      :flags(GTK_DIALOG_DESTROY_WITH_PARENT),
      :button-spec( "Ok", GTK_RESPONSE_NONE)
    );

    my Gnome::Gtk3::Box $content-area .= new(
      :widget($dialog.get-content-area)
    );

    my Gnome::Gtk3::Label $label .= new(:text($message));
    $content-area.gtk_container_add($label());

    # Show the dialog. After return (Ok pressed) the dialog widget
    # is destroyed. show-all() must be called, otherwise the message
    # will not be seen.
    $dialog.show-all;
    $dialog.gtk-dialog-run;
    $dialog.gtk_widget_destroy;

    1
  }

  # Handle window managers 'close app' button
  method exit-program ( --> Int ) {
    $m.gtk-main-quit;

    1
  }
}


my Gnome::Gtk3::Window $top-window .= new(:title('Message dialog'));
#$top-window.set-position(GTK_WIN_POS_MOUSE);

my Gnome::Gtk3::Button $button .= new(:label('Show Dialog'));
$top-window.gtk-container-add($button);

#$w.set-interactive-debugging(1);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new(:$top-window);
$button.register-signal(
  $ash, 'quick-message', 'clicked', :message("\nYou've donnit again, bravo!\n")
);

$top-window.register-signal( $ash, 'exit-program', 'destroy');
$top-window.show-all;

$m.gtk-main;
