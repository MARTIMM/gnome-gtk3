```
<?xml version="1.0" encoding="UTF-8"?>
<!-- Generated with glade 3.22.1 -->
<interface>
  <requires lib="gtk+" version="3.20"/>
  <object class="GtkApplicationWindow" id="window">
    <property name="can_focus">False</property>
    <child>
      <placeholder/>
    </child>
    <child>
      <object class="GtkLabel">
        <property name="visible">True</property>
        <property name="can_focus">False</property>
        <property name="label" translatable="yes">&lt;span size='xx-large'&gt;Hello world!&lt;/span&gt;</property>
        <property name="use_markup">True</property>
      </object>
    </child>
  </object>
</interface>
```
```
<?xml version='1.0' encoding='utf-8' ?>
<interface>
  <requires lib='gtk+' version='3.4'/>
  <object class='GtkToolbar' id='toolbar'>
    <property name='visible'>True</property>
    <property name='can_focus'>False</property>
    <child>
      <object class='GtkToolButton' id='toolbutton_new'>
        <property name='visible'>True</property>
        <property name='can_focus'>False</property>
        <property name='tooltip_text' translatable='yes'>New Standard</property>
        <property name='action_name'>app.newstandard</property>
        <property name='icon_name'>document-new</property>
      </object>
      <packing>
        <property name='expand'>False</property>
        <property name='homogeneous'>True</property>
      </packing>
    </child>
    <child>
      <object class='GtkToolButton' id='toolbutton_quit'>
        <property name='visible'>True</property>
        <property name='can_focus'>False</property>
        <property name='tooltip_text' translatable='yes'>Quit</property>
        <property name='action_name'>app.quit</property>
        <property name='icon_name'>application-exit</property>
      </object>
      <packing>
        <property name='expand'>False</property>
        <property name='homogeneous'>True</property>
      </packing>
    </child>
  </object>
</interface>
```
