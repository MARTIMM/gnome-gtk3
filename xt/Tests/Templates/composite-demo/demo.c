#include <gtk/gtk.h>
#include "mywidget.h"

gint
main (gint argc, gchar *argv[])
{
  GtkWidget *window;
  GtkWidget *widget;

  gtk_init (&argc, &argv);

  window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
  g_signal_connect (G_OBJECT (window), "destroy", G_CALLBACK (gtk_main_quit), NULL);

  widget = my_widget_new ("The entry text !");

  gtk_container_add (GTK_CONTAINER (window), widget);
  gtk_widget_show_all (window);

  gtk_main ();

  return 0;
}
