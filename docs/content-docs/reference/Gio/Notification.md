Gnome::Gio::Notification
========================

User Notifications (pop up messages)

Description
===========

**Gnome::Gio::Notification** is a mechanism for creating a notification to be shown to the user -- typically as a pop-up notification presented by the desktop environment shell.

The key difference between **Gnome::Gio::Notification** and other similar APIs is that, if supported by the desktop environment, notifications sent with **Gnome::Gio::Notification** will persist after the application has exited, and even across system reboots.

Since the user may click on a notification while the application is not running, applications using **Gnome::Gio::Notification** should be able to be started as a D-Bus service, using **Gnome::Gio::Application**.

User interaction with a notification (either the default action, or buttons) must be associated with actions on the application (ie: "app." actions). It is not possible to route user interaction through the notification itself, because the object will not exist if the application is autostarted as a result of a notification being clicked.

A notification can be sent with `g-application-send-notification()`.

Synopsis
========

Declaration
-----------

    unit class Gnome::Gio::Notification;
    also is Gnome::GObject::Object;

Methods
=======

new
---

### :title

Creates a new **Gnome::Gio::Notification** with *$title* as its title.

After populating the notification with more details, it can be sent to the desktop shell with `Gnome::Gio::Application.send-notification()`. Changing any properties after this call will not have any effect until resending the notification.

    multi method new ( Str :$title! )

### :native-object

Create a Notification object using a native object from elsewhere. See also **Gnome::N::TopLevelClassSupport**.

    multi method new ( N-GObject :$native-object! )

add-button
----------

Adds a button to the notification that activates the action in *$detailed-action* when clicked. That action must be an application-wide action (starting with "app."). If *detailed-action* contains a target, the action will be activated with that target as its parameter.

See `Gnome::Gio::Action.parse-detailed-name()` for a description of the format for *$detailed-action*.

    method add-button ( Str $label, Str $detailed_action )

  * Str $label; label of the button

  * Str $detailed_action; a detailed action name

add-button-with-target-value
----------------------------

Adds a button to the notification that activates *action* when clicked. *action* must be an application-wide action (it must start with "app.").

If *target* is non-`undefined`, *action* will be activated with *target* as its parameter.

    method add-button-with-target-value ( Str $label, Str $action, N-GVariant $target )

  * Str $label; label of the button

  * Str $action; an action name

  * N-GVariant $target; a **Gnome::Gio::Variant** to use as *action*'s parameter, or `undefined`

set-body
--------

Sets the body of the notification to *body*.

    method set-body ( Str $body )

  * Str $body; the new body for the notification, or `undefined`

set-default-action
------------------

Sets the default action of the notification to *detailed-action*. This action is activated when the notification is clicked on.

The action in *detailed-action* must be an application-wide action (it must start with "app."). If *detailed-action* contains a target, the given action will be activated with that target as its parameter. See `g-action-parse-detailed-name()` for a description of the format for *detailed-action*.

When no default action is set, the application that the notification was sent on is activated.

    method set-default-action ( Str $detailed_action )

  * Str $detailed_action; a detailed action name

set-default-action-and-target-value
-----------------------------------

Sets the default action of the notification to *action*. This action is activated when the notification is clicked on. It must be an application-wide action (start with "app.").

If *target* is non-`undefined`, *action* will be activated with *target* as its parameter.

When no default action is set, the application that the notification was sent on is activated.

    method set-default-action-and-target-value ( Str $action, N-GVariant $target )

  * Str $action; an action name

  * N-GVariant $target; a **Gnome::Gio::Variant** to use as *action*'s parameter, or `undefined`

set-priority
------------

Sets the priority of the notification to *priority*. See **Gnome::Gio::NotificationPriority** for possible values.

    method set-priority ( GNotificationPriority $priority )

  * GNotificationPriority $priority; a **Gnome::Gio::NotificationPriority**

set-title
---------

Sets the title of the notification to *title*.

    method set-title ( Str $title )

  * Str $title; the new title for the notification

