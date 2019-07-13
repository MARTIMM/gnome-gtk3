
###TODO trying to get defines into perl code

```
#define GTK_IS_CONTAINER(obj)           (G_TYPE_CHECK_INSTANCE_TYPE ((obj), GTK_TYPE_CONTAINER))

#define G_TYPE_CHECK_INSTANCE_TYPE(instance, g_type)            (_G_TYPE_CIT ((instance), (g_type)))

#define _G_TYPE_CIT(ip, gt)             (G_GNUC_EXTENSION ({ \

  GTypeInstance *__inst = (GTypeInstance*) ip;
  GType __t = gt;
  gboolean __r;

  if ( !__inst )
    __r = FALSE;
  else if ( __inst->g_class && __inst->g_class->g_type == __t )
    __r = TRUE;
  else
    __r = g_type_check_instance_is_a (__inst, __t);
  __r;

}))

```
