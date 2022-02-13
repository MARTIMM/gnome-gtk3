class N-GObject
---------------

Class at the top of many food chains. This native object is stored here to prevent circular dependencies.

Previously I thought this would be an object from everything GObject in glib and child classes. Now, I will use it for everything opaque and call it a *Native Gnome Object*. This object is always stored in the **Gnome::N::TopLevelClassSupport**. It is created in a `.BUILD()` submethod or imported using `:native-object` or `:build-id` named argument to a `.new()` method. There are other objects which are not so opaque like **N-GError** and **N-GdkRGBA**. These objects are defined in their proper places. So, in short, every standalone class has its own native object (or even none like **Gnome::Glib::Quark**), and every class inheriting from **Gnome::N::TopLevelClassSupport**, directly or indirectly, has this opaque object **N-GObject**.

CALL-ME
-------

Wrap this native object in a Raku object given by the `$rk-type` or `$rk-type-name` from the argument.

Example where the native object is a **GtkWindow** type. The Raku type would then be **Gnome::Gtk3::Window**.

    my Gnome::Gtk3::Window $w .= new;
    $w.set-title('N-GObject coercion');
    my N-GObject() $no = $w;

    # CALL-ME is used here. There are 3 ways to use it.
    say $no(Gnome::Gtk3::Window).get-title;     # N-GObject coercion
    say $no('Gnome::Gtk3::Window').get-title;   # N-GObject coercion
    say $no().get-title;                        # N-GObject coercion

In the last example, an exeption is thrown when the native object is not defined because there will be no way to know to which class to convert to. The other types will convert but the objects will be invalid.

Note that when a native object must be coerced into a Raku object while in a chain of calls, you must add a few extra dots, because, the intended coercion will be seen as a call to a method.

    my Gnome::Gdk3::Screen $s .= new;

    # The wrong way: get-rgba-visual() is seen as a call to the
    # get-rgba-visual method.
    $s.get-rgba-visual().get-depth;

    # The right way: Now there is a conversion at this point .(). and after
    # that the call get-depth() works on the Gnome::Gdk3::Visual object
    $s.get-rgba-visual.().get-depth;

    # Nice to write this for the same result and documents your statement
    $s.get-rgba-visual.('Gnome::Gdk3::Visual').get-depth;

