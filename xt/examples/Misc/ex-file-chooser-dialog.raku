use v6;

use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::Button:api<1>;
use Gnome::Gtk3::Window:api<1>;
use Gnome::Gtk3::Dialog:api<1>;
use Gnome::Gtk3::FileChooser:api<1>;
use Gnome::Gtk3::FileChooserDialog:api<1>;

my Gnome::Gtk3::Main $m .= new;

#use Gnome::N::X:api<1>;
#Gnome::N::debug(:on);


class AppSignalHandlers {

  enum MyOwnCodes <EatThemAllUp Destroy KillTheBastard Eliminate>;

  has Gnome::Gtk3::Window $!top-window;

  submethod BUILD ( Gnome::Gtk3::Window :$!top-window ) { }

  # Show dialog
  method show-dialog ( --> Int ) {
    my Gnome::Gtk3::FileChooserDialog $dialog .= new(
      :title("Open File"), :parent($!top-window),
      :action(GTK_FILE_CHOOSER_ACTION_SAVE),
      :button-spec( [
          "_Ok", KillTheBastard,                      # using my own code
          "_Cancel", GTK_RESPONSE_CANCEL,
          "_Open", GTK_RESPONSE_ACCEPT
        ]
      )
    );

    my $response = $dialog.gtk-dialog-run;
    note "Diag return: $response";
    if $response ~~ GTK_RESPONSE_ACCEPT {
      my Str $file = $dialog.get-filename;
      note "Opening file $file";
#Todo g_free (filename);
    }

    $dialog.gtk-widget-hide;

    1
  }

  # Handle window managers 'close app' button
  method exit-program ( --> Int ) {
    $m.gtk-main-quit;

    1
  }
}



my Gnome::Gtk3::Window $top-window .= new(:title('File chooser dialog'));
#$top-window.set-position(GTK_WIN_POS_MOUSE);

my Gnome::Gtk3::Button $button .= new(:label('Show Dialog'));
$top-window.add($button);

#$w.set-interactive-debugging(1);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new(:$top-window);
$button.register-signal( $ash, 'show-dialog', 'clicked');

$top-window.register-signal( $ash, 'exit-program', 'destroy');
$top-window.show-all;

$m.gtk-main;
