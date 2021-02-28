https://zetcode.com/gui/gtksharp/menus/
http://www.holmes4.com/wda/MyBooks/PythonGTK/PyGTK_Development-Menus_And_Toolbars-DynamicMenu.html

https://developer.gnome.org/GMenu/
https://developer.gnome.org/gnome-devel-demos/stable/menubar.py.html.en

<!-- uses set-app-menu -->
https://developer.gnome.org/gnome-devel-demos/stable/gmenu.py.html.en

# GNOME Human Interface Guidelines 2.2.3
https://developer.gnome.org/hig-book/3.12/index.html.en
https://developer.gnome.org/hig-book/3.12/menus-standard.html.en

# Examples
```
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <menu id="menubar">
    <submenu>
      <attribute name="label">File</attribute>
    </submenu>
    <submenu>
      <attribute name="label">Edit</attribute>
    </submenu>
    <submenu>
      <attribute name="label">Choices</attribute>
    </submenu>
    <submenu>
      <attribute name="label">Help</attribute>
    </submenu>
  </menu>
</interface>
```

```
<interface>
  <menu id="menu">
    <section>
      <item>
        <attribute name="label" translatable="yes">Incendio</attribute>
        <attribute name="action">app.incendio</attribute>
      </item>
    </section>
    <section>
      <attribute name="label" translatable="yes">Defensive Charms</attribute>
      <item>
        <attribute name="label" translatable="yes">Expelliarmus</attribute>
        <attribute name="action">app.expelliarmus</attribute>
        <attribute name="icon">/usr/share/my-app/poof!.png</attribute>
      </item>
    </section>
  </menu>
</interface>
```
```
GMenu *menu, *section;

menu = g_menu_new ();
section = g_menu_new ();
g_menu_append (section, "Incendio", "app.incendio");
g_menu_append_section (menu, "Offensive Spells", section);
g_object_unref (section);

section = g_menu_new ();
item = g_menu_item_new ("Expelliarmus", "app.expelliarmus");
g_menu_item_set_icon (item, defensive_icon);
g_menu_append_item (section, item);
g_menu_append_section (menu, "Defensive Charms", section);
g_object_unref (section);
```

```
<menu id='edit-menu'>
  <section>
    <item label='Undo'/>
    <item label='Redo'/>
  </section>
  <section>
    <item label='Cut'/>
    <item label='Copy'/>
    <item label='Paste'/>
  </section>
</menu>
```
```
<menu id='edit-menu'>
  <item>
      <link name='section'>
      <item label='Undo'/>
      <item label='Redo'/>
    </link>
  </item>
  <item>
    <link name='section'>
      <item label='Cut'/>
      <item label='Copy'/>
      <item label='Paste'/>
    </link>
  </item>
</menu>
```
```
<?xml version='1.0' encoding='utf-8' ?>
<interface>
  <menu id="app-menu">
    <section>
        <item>
            <attribute name="label">About</attribute>
            <attribute name="action">app.about</attribute>
        </item>
        <item>
            <attribute name="label">Quit</attribute>
            <attribute name="action">app.quit</attribute>
        </item>
    </section>
  </menu>
</interface>
```
