use Gnome::Gtk3::Main;
use Gnome::Gtk3::Window;
use Gnome::Gtk3::Widget;
use Gnome::Gtk3::Label;
use Gnome::Gtk3::Notebook;

my Gnome::Gtk3::Main $m .= new;
my Gnome::Gtk3::Window $w .= new;
my Gnome::Gtk3::Notebook $nb .= new;

class ObjectRegistration {
  my ObjectRegistration $instance;
  has Hash $registrations;

  method new ( ) { !!! } # prevent using new()

  submethod BUILD ( :$some-option ) {
    $registrations = %();
    # rest of inits
  }

  method instance ( |c --> ObjectRegistration ) {
    $instance //= self.bless(|c);
    $instance
  }

  method set ( Str $key, $obj ) {
    $registrations{$key} = $obj;     # overwriting possible!
  }

  method get ( Str $key --> Any ) {
    $registrations{$key}                  # wrong ones possible
  }

  method clear ( Str $key ) {
    $registrations{$key}:delete;
  }
}

class ExtendedLabel is Gnome::Gtk3::Label {
	has Str $.custom-data;
	submethod new (|c) {
		self.bless( :GtkLabel, |c );
	}
}

class Handlers {
	method on-close {
		$m.quit;
	}
}

my ExtendedLabel $label .= new(
  :custom-data('some data contents'), :text('words')
);
$label.set-name('myNotebookPage');
ObjectRegistration.instance.set( 'myNotebookPage', $label);
my Handlers $handler .= new;

$w.add($nb);
$nb.append-page($label, Gnome::Gtk3::Label.new(:text('title')));

$w.show-all;
$w.register-signal($handler, 'on-close', 'destroy');


# ... later in the program ...
# should return 'some data contents'
my Gnome::Gtk3::Widget $wdgt .= new(:native-object($nb.get-nth-page(0)));
my ExtendedLabel $label-somewhere-else = ObjectRegistration.instance.get(
  $wdgt.get-name
);
$wdgt.clear-object;
say $label-somewhere-else.custom-data;

$m.main;
