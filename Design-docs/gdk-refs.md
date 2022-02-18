# Device Relations

How to get from one class to another. Most classes can be reached except for GdkDevice.

```plantuml
@startmindmap
scale 0.9

* GtkWidget
** GtkWidget (toplevel, ancestor, parent)
** GtkWindow (tooltip)

** GdkDisplay (display)
** GdkScreen (screen)
** GdkVisual (visual)
** GdkWindow (parent, root, window)

@endmindmap
```

```plantuml
@startmindmap
scale 0.9

* GdkDisplay
** GdkMonitor (monitor, primary, at point, at window)
** GdkScreen (get, default)
** GdkWindow (at pointer, default group)

@endmindmap
```

```plantuml
@startmindmap
scale 0.9

* GdkMonitor
** GdkDisplay (display)

@endmindmap
```

```plantuml
@startmindmap
scale 0.9

* GdkVisual
** GdkScreen (screen)
** GdkVisual (system, best, with depth/type/both)

@endmindmap
```

```plantuml
@startmindmap
scale 0.9

* GdkScreen
** GdkDisplay (display)
** GdkVisual (visual, rgba)
** GdkWindow (root, active)

@endmindmap
```

The only way to get a device is from an event originating from a device such as a keyboard or mouse.

```plantuml
@startmindmap
scale 0.9

* GdkDevice
** GdkDevice (associated)
** GdkWindow (at position/double, event)

@endmindmap
```
