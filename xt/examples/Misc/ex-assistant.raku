#!/usr/bin/env -S raku -Ilib

# Example taken from C-source shown in gtk3-demo

use v6.d;
#use lib '../gnome-glib/lib';

use Gnome::N::N-GObject:api<1>;

use Gnome::Glib::Source:api<1>;
use Gnome::Glib::MainContext:api<1>;

use Gnome::Gtk3::Main:api<1>;
use Gnome::Gtk3::Window:api<1>;
use Gnome::Gtk3::ProgressBar:api<1>;
use Gnome::Gtk3::Assistant:api<1>;
use Gnome::Gtk3::Label:api<1>;
use Gnome::Gtk3::Entry:api<1>;
use Gnome::Gtk3::Grid:api<1>;
use Gnome::Gtk3::CheckButton:api<1>;
use Gnome::Gtk3::Enums:api<1>;
use Gnome::Gtk3::CssProvider:api<1>;
use Gnome::Gtk3::StyleContext:api<1>;
use Gnome::Gtk3::StyleProvider:api<1>;

use Gnome::Gdk3::Screen:api<1>;

use Gnome::N::X:api<1>;
#Gnome::N::debug(:on);


#-------------------------------------------------------------------------------
unit class AssistantDemo;
also is Gnome::Gtk3::Assistant;

# need this to init the native object properly
submethod new ( |c ) {
  # let the Gnome::Gtk3::Assistant class process the options
  self.bless( :GtkAssistant, |c);
}

has Gnome::Gtk3::Main $!main;

#-------------------------------------------------------------------------------
#`{{
static GtkWidget *assistant = NULL;
static GtkWidget *progress_bar = NULL;
}}

#-------------------------------------------------------------------------------
#`{{
static gboolean
apply_changes_gradually (gpointer data)
{
  gdouble fraction;

  /* Work, work, work... */
  fraction = gtk_progress_bar_get_fraction (GTK_PROGRESS_BAR (progress_bar));
  fraction += 0.05;

  if (fraction < 1.0)
    {
      gtk_progress_bar_set_fraction (GTK_PROGRESS_BAR (progress_bar), fraction);
      return G_SOURCE_CONTINUE;
    }
  else
    {
      /* Close automatically once changes are fully applied. */
      gtk_widget_destroy (assistant);
      assistant = NULL;
      return G_SOURCE_REMOVE;
    }
}
}}
use NativeCall;
use Gnome::N::GlibToRakuTypes:api<1>;
use Gnome::N::NativeLib:api<1>;

method apply-changes-gradually (
  Gnome::Gtk3::ProgressBar :$progress-bar
#  --> Bool
  --> gboolean
) {
  # Work, work, work…
  my Num $fraction = $progress-bar.get-fraction;
  $fraction += 5e-2;

  if $fraction < 1e0 {
    $progress-bar.set-fraction($fraction);
    #return True; # continue work
    return 1; # continue work
  }

  else {
    $progress-bar.set-fraction(1e0);

    # we get errors here if we destroy the assistant right here
    # (ex-assistant.raku:122482): Gtk-CRITICAL **: 12:35:58.709:
    # gtk_assistant_set_page_complete: assertion 'GTK_IS_ASSISTANT (assistant)'
    # failed

    # Complete the page first before destroying.
    self.set-page-complete( $progress-bar, True);

    # btw, would be nicer perhaps, to have a close button and a kind of report?
    self.destroy;

    #return False; # done and ready
    return 0; # done and ready
  }
}

#-------------------------------------------------------------------------------
#`{{
static void
on_assistant_apply (GtkWidget *widget, gpointer data)
{
  /* Start a timer to simulate changes taking a few seconds to apply. */
  g_timeout_add (100, apply_changes_gradually, NULL);
}
}}
#`{{
sub g_timeout_add (
  guint $interval, Callable $GSourceFunc ( Pointer $d --> gboolean),
  gpointer $data --> guint
) is native(&glib-lib)
  { * }
}}

# g_timeout_add() is not (yet) implemented. We need to start a thread to
# do the processing and show the results simultaniously.
method on-assistant-apply ( Gnome::Gtk3::ProgressBar :$progress-bar ) {

  my Gnome::Glib::Source $s .= new(:timeout(100));
  $s.set-callback( self, 'apply-changes-gradually', :$progress-bar);
  $s.attach(Gnome::Glib::MainContext.new(:default));

#  g_timeout_add(
#  $s.timeout_add(
#    100, -> gpointer $d { self.apply-changes-gradually($progress-bar); },
#    100, self, 'apply-changes-gradually', :$progress-bar
#  );
}

#-------------------------------------------------------------------------------
#`{{
static void
on_assistant_close_cancel (GtkWidget *widget, gpointer data)
{
  GtkWidget **assistant = (GtkWidget **) data;

  gtk_widget_destroy (*assistant);
  *assistant = NULL;
}
}}

method on-assistant-close-cancel (
#  Gnome::Gtk3::Assistant :_widget($assistant)
) {
  self.destroy;
}

#-------------------------------------------------------------------------------
#`{{
static void
on_assistant_prepare (GtkWidget *widget, GtkWidget *page, gpointer data)
{
  gint current_page, n_pages;
  gchar *title;

  current_page = gtk_assistant_get_current_page (GTK_ASSISTANT (widget));
  n_pages = gtk_assistant_get_n_pages (GTK_ASSISTANT (widget));

  title = g_strdup_printf ("Sample assistant (%d of %d)", current_page + 1, n_pages);
  gtk_window_set_title (GTK_WINDOW (widget), title);
  g_free (title);

  /* The fourth page (counting from zero) is the progress page.  The
  * user clicked Apply to get here so we tell the assistant to commit,
  * which means the changes up to this point are permanent and cannot
  * be cancelled or revisited. */
  if (current_page == 3)
      gtk_assistant_commit (GTK_ASSISTANT (widget));
}
}}

method on-assistant-prepare (
  N-GObject $page, # unused
#  Gnome::Gtk3::Assistant :_widget($assistant)
) {
  my Int $current-page = self.get-current-page;
  my Int $n-pages = self.get-n-pages;

  # next does not set the title, also not in the original C example
  self.set-title("Sample assistant ({$current-page + 1} of $n-pages)");
note "Sample assistant ({$current-page + 1} of $n-pages)";

  # The fourth page (counting from zero) is the progress page.  The
  # user clicked Apply to get here so we tell the assistant to commit,
  # which means the changes up to this point are permanent and cannot
  # be cancelled or revisited.
  self.commit if $current-page == 3;
}

#-------------------------------------------------------------------------------
#`{{
static void
on_entry_changed (GtkWidget *widget, gpointer data)
{
  GtkAssistant *assistant = GTK_ASSISTANT (data);
  GtkWidget *current_page;
  gint page_number;
  const gchar *text;

  page_number = gtk_assistant_get_current_page (assistant);
  current_page = gtk_assistant_get_nth_page (assistant, page_number);
  text = gtk_entry_get_text (GTK_ENTRY (widget));

  if (text && *text)
    gtk_assistant_set_page_complete (assistant, current_page, TRUE);
  else
    gtk_assistant_set_page_complete (assistant, current_page, FALSE);
}
}}

method on-entry-changed ( Gnome::Gtk3::Entry :_widget($entry) ) {
  # get text and test if not empty and not filled with only whitespace
  my Str $text = $entry.get-text;
  my Bool $text-ok = (?$text and $text !~~ m/^ \s+ $/);
  self.set-page-complete(
    self.get-nth-page(self.get-current-page), $text-ok
  );
}

#-------------------------------------------------------------------------------
#`{{
static void
create_page1 (GtkWidget *assistant)
{
  GtkWidget *box, *label, *entry;

  box = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 12);
  gtk_container_set_border_width (GTK_CONTAINER (box), 12);

  label = gtk_label_new ("You must fill out this entry to continue:");
  gtk_box_pack_start (GTK_BOX (box), label, FALSE, FALSE, 0);

  entry = gtk_entry_new ();
  gtk_entry_set_activates_default (GTK_ENTRY (entry), TRUE);
  gtk_widget_set_valign (entry, GTK_ALIGN_CENTER);
  gtk_box_pack_start (GTK_BOX (box), entry, TRUE, TRUE, 0);
  g_signal_connect (G_OBJECT (entry), "changed",
                    G_CALLBACK (on_entry_changed), assistant);

  gtk_widget_show_all (box);
  gtk_assistant_append_page (GTK_ASSISTANT (assistant), box);
  gtk_assistant_set_page_title (GTK_ASSISTANT (assistant), box, "Page 1");
  gtk_assistant_set_page_type (GTK_ASSISTANT (assistant), box, GTK_ASSISTANT_PAGE_INTRO);
}
}}

method create-page1 ( ) {

  my Gnome::Gtk3::Label $label .= new(
    :text("You must fill out this entry to continue:")
  );

  given my Gnome::Gtk3::Entry $entry .= new {
    .set-activates-default(True);
    .set-valign(GTK_ALIGN_CENTER);
    .register-signal( self, 'on-entry-changed', 'changed');
  }

  given my Gnome::Gtk3::Grid $grid .= new {
    .set-column-spacing(12);
    .set-border-width(12);
    .attach( $label, 0, 0, 1, 1);
    .attach( $entry, 1, 0, 1, 1);
    .show_all;
  }

  self.append-page($grid);
  self.set-page-title( $grid, "Page 1");
  self.set_page_type( $grid, GTK_ASSISTANT_PAGE_INTRO);
}

#-------------------------------------------------------------------------------
#`{{
static void
create_page2 (GtkWidget *assistant)
{
  GtkWidget *box, *checkbutton;

  box = gtk_box_new (GTK_ORIENTATION_VERTICAL, 12);
  gtk_container_set_border_width (GTK_CONTAINER (box), 12);

  checkbutton = gtk_check_button_new_with_label ("This is optional data, you may continue "
                                                 "even if you do not check this");
  gtk_box_pack_start (GTK_BOX (box), checkbutton, FALSE, FALSE, 0);

  gtk_widget_show_all (box);
  gtk_assistant_append_page (GTK_ASSISTANT (assistant), box);
  gtk_assistant_set_page_complete (GTK_ASSISTANT (assistant), box, TRUE);
  gtk_assistant_set_page_title (GTK_ASSISTANT (assistant), box, "Page 2");
}
}}

method create-page2 ( ) {

  my Gnome::Gtk3::CheckButton $checkbutton .= new( :label(
      "This is optional data, you may continue even if you do not check this"
  ) );

  given my Gnome::Gtk3::Grid $grid .= new {
    .set-column-spacing(12);
    .set-border-width(12);
    .attach( $checkbutton, 0, 0, 1, 1);
    .show_all;
  }

  self.append-page($grid);
  self.set-page-complete( $grid, True);
  self.set-page-title( $grid, "Page 2");
}

#-------------------------------------------------------------------------------
#`{{
static void
create_page3 (GtkWidget *assistant)
{
  GtkWidget *label;

  label = gtk_label_new ("This is a confirmation page, press 'Apply' to apply changes");

  gtk_widget_show (label);
  gtk_assistant_append_page (GTK_ASSISTANT (assistant), label);
  gtk_assistant_set_page_type (GTK_ASSISTANT (assistant), label, GTK_ASSISTANT_PAGE_CONFIRM);
  gtk_assistant_set_page_complete (GTK_ASSISTANT (assistant), label, TRUE);
  gtk_assistant_set_page_title (GTK_ASSISTANT (assistant), label, "Confirmation");
}
}}

method create-page3 ( ) {

  my Gnome::Gtk3::Label $label .= new(
    :text("This is a confirmation page, press 'Apply' to apply changes")
  );
  $label.show;

  self.append-page($label);
  self.set_page_type( $label, GTK_ASSISTANT_PAGE_CONFIRM);
  self.set-page-complete( $label, True);
  self.set-page-title( $label, "Confirmation");
}

#-------------------------------------------------------------------------------
#`{{
static void
create_page4 (GtkWidget *assistant)
{
  progress_bar = gtk_progress_bar_new ();
  gtk_widget_set_halign (progress_bar, GTK_ALIGN_CENTER);
  gtk_widget_set_valign (progress_bar, GTK_ALIGN_CENTER);

  gtk_widget_show (progress_bar);
  gtk_assistant_append_page (GTK_ASSISTANT (assistant), progress_bar);
  gtk_assistant_set_page_type (GTK_ASSISTANT (assistant), progress_bar, GTK_ASSISTANT_PAGE_PROGRESS);
  gtk_assistant_set_page_title (GTK_ASSISTANT (assistant), progress_bar, "Applying changes");

  /* This prevents the assistant window from being
   * closed while we're "busy" applying changes.
   */
  gtk_assistant_set_page_complete (GTK_ASSISTANT (assistant), progress_bar, FALSE);
}
}}

method create-page4 ( --> Gnome::Gtk3::ProgressBar ) {

  given my Gnome::Gtk3::ProgressBar $progress-bar .= new {
    .set-halign(GTK_ALIGN_CENTER);
    .set-valign(GTK_ALIGN_CENTER);
    .show;
  }

  self.append-page($progress-bar);
  self.set-page-type( $progress-bar, GTK_ASSISTANT_PAGE_PROGRESS);
  self.set-page-title( $progress-bar, "Applying changes");

  # This prevents the assistant window from being
  # closed while we're "busy" applying changes.
  self.set-page-complete( $progress-bar, False);

  $progress-bar
}

#-------------------------------------------------------------------------------
#`{{
GtkWidget*
do_assistant (GtkWidget *do_widget)
{
  if (!assistant)
    {
      assistant = gtk_assistant_new ();

      gtk_window_set_default_size (GTK_WINDOW (assistant), -1, 300);

      gtk_window_set_screen (GTK_WINDOW (assistant),
                             gtk_widget_get_screen (do_widget));

      create_page1 (assistant);
      create_page2 (assistant);
      create_page3 (assistant);
      create_page4 (assistant);

      g_signal_connect (G_OBJECT (assistant), "cancel",
                        G_CALLBACK (on_assistant_close_cancel), &assistant);
      g_signal_connect (G_OBJECT (assistant), "close",
                        G_CALLBACK (on_assistant_close_cancel), &assistant);
      g_signal_connect (G_OBJECT (assistant), "apply",
                        G_CALLBACK (on_assistant_apply), NULL);
      g_signal_connect (G_OBJECT (assistant), "prepare",
                        G_CALLBACK (on_assistant_prepare), NULL);
    }

  if (!gtk_widget_get_visible (assistant))
    gtk_widget_show (assistant);
  else
    {
      gtk_widget_destroy (assistant);
      assistant = NULL;
    }

  return assistant;
}
}}

submethod BUILD ( ) {
  $!main .= new;

  self.set-default-size( -1, 300);
  self.set-assistant-style;

  self.create-page1;
  self.create-page2;
  self.create-page3;
  my Gnome::Gtk3::ProgressBar $progress-bar = self.create-page4;

  self.register-signal( self, 'on-assistant-close-cancel', 'cancel');
  self.register-signal( self, 'on-assistant-close-cancel', 'close');
  self.register-signal( self, 'on-assistant-prepare', 'prepare');
  self.register-signal( self, 'on-assistant-apply', 'apply', :$progress-bar);

  # add an extra handler to cope with window manager signal to kill app.
  # we need this too when 'self.destroy;' is called in one of the
  # handler methods above.
  self.register-signal( self, 'on-destroy', 'destroy');
  self.show-all;
}

#-------------------------------------------------------------------------------
method on-destroy ( ) {
  $!main.quit;
}

#-------------------------------------------------------------------------------
# on my machine the current chosen style for my desktop is making a mess of
# the assistant colors so this is added to get a readable assistant
method set-assistant-style ( ) {

  # read the style definitions into the css provider and style context
  my Gnome::Gtk3::CssProvider $css-provider .= new;
  $css-provider.load-from-data(Q:q:to/EOCSS/);
    box.sidebar {
      background-color: #cfcfcf;
      color: #181818;
    }

    box.sidebar label {
      background-color: #cfcfcf;
      color: #181818;
    }

    box.sidebar label.highlight {
      background-color: #dfdfdf;
      color: #181818;
    }

    EOCSS

  my Gnome::Gtk3::StyleContext $style-context .= new;
  $style-context.add_provider_for_screen(
    Gnome::Gdk3::Screen.new, $css-provider, GTK_STYLE_PROVIDER_PRIORITY_USER
  );
}

#-------------------------------------------------------------------------------
my AssistantDemo $ad .= new;

Gnome::Gtk3::Main.new.main;
