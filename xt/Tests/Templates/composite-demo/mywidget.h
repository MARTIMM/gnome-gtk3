#ifndef __MY_WIDGET_H__
#define __MY_WIDGET_H__

#include <gtk/gtk.h>

#define GLIB_VERSION_MIN_REQUIRED 2.57

G_BEGIN_DECLS

#define MY_TYPE_WIDGET                 (my_widget_get_type ())
#define MY_WIDGET(obj)                 (G_TYPE_CHECK_INSTANCE_CAST ((obj), MY_TYPE_WIDGET, MyWidget))
#define MY_WIDGET_CLASS(klass)         (G_TYPE_CHECK_CLASS_CAST ((klass), MY_TYPE_WIDGET, MyWidgetClass))
#define MY_IS_WIDGET(obj)              (G_TYPE_CHECK_INSTANCE_TYPE ((obj), MY_TYPE_WIDGET))
#define MY_IS_WIDGET_CLASS(klass)      (G_TYPE_CHECK_CLASS_TYPE ((klass), MY_TYPE_WIDGET))
#define MY_WIDGET_GET_CLASS(obj)       (G_TYPE_INSTANCE_GET_CLASS ((obj), MY_TYPE_WIDGET, MyWidgetClass))

typedef struct _MyWidget             MyWidget;
typedef struct _MyWidgetClass        MyWidgetClass;
typedef struct _MyWidgetPrivate      MyWidgetPrivate;

struct _MyWidget
{
  /*< private >*/
  GtkBox box;

  MyWidgetPrivate *priv;
};

#define MY_WIDGET_GET_PRIVATE(o) \
    ((MyWidgetPrivate *)((MyWidget(o))->priv))

struct _MyWidgetClass
{
  GtkBoxClass parent_class;
};

GtkWidget   *my_widget_new               (const gchar *text);

void         my_widget_set_text          (MyWidget    *widget,
					  const gchar *text);
const gchar *my_widget_get_text          (MyWidget    *widget);

G_END_DECLS

#endif /* __MY_WIDGET_H__ */
