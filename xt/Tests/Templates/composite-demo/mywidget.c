#include "mywidget.h"


static void my_widget_button_clicked (MyWidget  *widget, GtkButton *button);
static void my_widget_entry_changed  (MyWidget  *widget, GtkButton *button);

struct _MyWidgetPrivate
{
  /* This is the entry defined in the GtkBuilder xml */
  GtkWidget *entry;
};

enum {
  PROP_0,
  PROP_TEXT
};

G_DEFINE_TYPE (MyWidget, my_widget, GTK_TYPE_BOX);

static void
my_widget_set_property (GObject         *object,
                         guint            prop_id,
                         const GValue    *value,
                         GParamSpec      *pspec)
{
  MyWidget *widget = MY_WIDGET (object);

  switch (prop_id)
    {
    case PROP_TEXT:
      my_widget_set_text (widget, g_value_get_string (value));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
    }
}

static void
my_widget_get_property (GObject         *object,
			guint            prop_id,
			GValue          *value,
			GParamSpec      *pspec)
{
  MyWidget *widget = MY_WIDGET (object);

  switch (prop_id)
    {
    case PROP_TEXT:
      g_value_set_string (value, my_widget_get_text (widget));
      break;
    default:
      G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
      break;
    }
}

static void
my_widget_class_init (MyWidgetClass *klass)
{
  GObjectClass *gobject_class;
  GtkWidgetClass *widget_class;

  gobject_class = G_OBJECT_CLASS (klass);
  widget_class = GTK_WIDGET_CLASS (klass);

  gobject_class->set_property = my_widget_set_property;
  gobject_class->get_property = my_widget_get_property;

  /* Install a property, this is actually just a proxy for the internal GtkEntry text */
  g_object_class_install_property (gobject_class,
                                   PROP_TEXT,
                                   g_param_spec_string ("text", "Text",
                                                        "The text in the entry",
                                                        NULL,
                                                        G_PARAM_READWRITE));

  /* Setup the template GtkBuilder xml for this class
   */
  gtk_widget_class_set_template_from_resource (widget_class, "/org/foo/my/mywidget.ui");

  /* Define the relationship of the private entry and the entry defined in the xml
   */
  gtk_widget_class_bind_child (widget_class, MyWidgetPrivate, entry);

  /* Declare the callback ports that this widget class exposes, to bind with <signal>
   * connections defined in the GtkBuilder xml
   */
  gtk_widget_class_bind_callback (widget_class, my_widget_button_clicked);
  gtk_widget_class_bind_callback (widget_class, my_widget_entry_changed);

  g_type_class_add_private (gobject_class, sizeof (MyWidgetPrivate));
}

static void
my_widget_init (MyWidget *widget)
{
  widget->priv = G_TYPE_INSTANCE_GET_PRIVATE (widget,
                                              MY_TYPE_WIDGET,
                                              MyWidgetPrivate);

  gtk_widget_init_template (GTK_WIDGET (widget));
}

/***********************************************************
 *                       Callbacks                         *
 ***********************************************************/
static void
my_widget_button_clicked (MyWidget  *widget,
			  GtkButton *button)
{
  g_print ("The button was clicked with entry text: %s\n",
	   gtk_entry_get_text (GTK_ENTRY (widget->priv->entry)));
}

static void
my_widget_entry_changed (MyWidget  *widget,
			 GtkButton *button)
{
  g_print ("The entry text changed: %s\n",
	   gtk_entry_get_text (GTK_ENTRY (widget->priv->entry)));

  /* Notify property change */
  g_object_notify (G_OBJECT (widget), "text");
}

/***********************************************************
 *                            API                          *
 ***********************************************************/
GtkWidget *
my_widget_new (const gchar *text)
{
  return g_object_new (MY_TYPE_WIDGET, "text", text, NULL);
}

void
my_widget_set_text (MyWidget    *widget,
		    const gchar *text)
{
  g_return_if_fail (MY_IS_WIDGET (widget));

  gtk_entry_set_text (GTK_ENTRY (widget->priv->entry), text);
}

const gchar *
my_widget_get_text (MyWidget *widget)
{
  g_return_val_if_fail (MY_IS_WIDGET (widget), NULL);

  return gtk_entry_get_text (GTK_ENTRY (widget->priv->entry));
}
