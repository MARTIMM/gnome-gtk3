use v6;

use Gnome::Gtk3::Main;
use Gnome::Gtk3::Button;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Dialog;
use Gnome::Gtk3::FileChooser;
use Gnome::Gtk3::FileChooserDialog;

my Gnome::Gtk3::Main $m .= new;

use Gnome::N::X;
Gnome::N::debug(:on);


class AppSignalHandlers {

  has Gnome::Gtk3::Window $!top-window;

  submethod BUILD (
    Gnome::Gtk3::Window :$!top-window,
  ) { }

  # Show dialog
  method show-dialog ( ) {
    my Gnome::Gtk3::FileChooserDialog $dialog .= new(
      :title("Open File"), :parent($!top-window),
      :action(GTK_FILE_CHOOSER_ACTION_OPEN),
      :button-spec( [
          "Ok", GTK_RESPONSE_OK,
          "Cancel", GTK_RESPONSE_CANCEL,
          "_Open", GTK_RESPONSE_ACCEPT
        ]
      )
    );

    my $response = $dialog.gtk-dialog-run;
  }

  # Handle window managers 'close app' button
  method exit-program ( ) {
    $m.gtk-main-quit;
  }
}



my Gnome::Gtk3::Window $top-window .= new(:title('File chooser dialog'));
$top-window.set-position(GTK_WIN_POS_MOUSE);

my Gnome::Gtk3::Button $button .= new(:label('Show Dialog'));
$top-window.gtk-container-add($button);

#$w.set-interactive-debugging(1);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new(:$top-window);
$button.register-signal( $ash, 'show-dialog', 'clicked');

$top-window.register-signal( $ash, 'exit-program', 'destroy');
$top-window.show-all;

$m.gtk-main;
