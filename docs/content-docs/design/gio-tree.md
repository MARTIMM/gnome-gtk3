---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Class hierargy

Below there is a table of the object hierarchy taken from [the developers page](https://developer.gnome.org/gio/stable/gio-hierarchy.html) and is used here to show what is implemented and what is deprecated in Gio. Module path names are removed from the Raku modules when in Gnome::Gio. E.g. Application is implemented as **Gnome::Gio::Application**. `├─✗` in front of a Gio module means that it is deprecated or will not be implemented for other reasons. Many of these will not be implemented ⛔ because Raku has a lot of I/O routines that it is not needed.

```
Tree of Gtk C structures                  Raku module
----------------------------------------  ------------------------------------
TopLevelClassSupport                      Gnome::N::TopLevelClassSupport
│
GObject                                   Gnome::GObject::Object
├── GAppInfoMonitor                       AppInfoMonitor
├── GAppLaunchContext                     AppLaunchContext
├── GApplicationCommandLine               ApplicationCommandLine
├── GApplication                          Application
├── GInputStream                          ⛔
│   ├── GFilterInputStream                ⛔
│   │   ├── GBufferedInputStream          ⛔
│   │   │   ╰── GDataInputStream          ⛔
│   │   ╰── GConverterInputStream         ⛔
│   ├── GFileInputStream                  ⛔
│   ├── GMemoryInputStream                ⛔
│   ╰── GUnixInputStream                  ⛔
├── GOutputStream                         ⛔
│   ├── GFilterOutputStream               ⛔
│   │   ├── GBufferedOutputStream         ⛔
│   │   ├── GConverterOutputStream        ⛔
│   │   ╰── GDataOutputStream             ⛔
│   ├── GFileOutputStream                 ⛔
│   ├── GMemoryOutputStream               ⛔
│   ╰── GUnixOutputStream                 ⛔
├── GBytesIcon
├── GCancellable
├── GCharsetConverter
├── GCredentials
├── GDBusActionGroup
├── GDBusAuthObserver
├── GDBusConnection
├── GDBusInterfaceSkeleton
├── GMenuModel                            MenuModel
│   ├── GDBusMenuModel
│   ╰── GMenu                             Menu
├── GDBusMessage
├── GDBusMethodInvocation
├── GDBusObjectManagerClient
├── GDBusObjectManagerServer
├── GDBusObjectProxy
├── GDBusObjectSkeleton
├── GDBusProxy
├── GDBusServer
├── GDesktopAppInfo
├── GEmblem                               Emblem
├── GEmblemedIcon                         EmblemedIcon
├── GFileEnumerator
├── GFileIcon                             FileIcon
├── GFileInfo                             ⛔FileInfo, Raku does it properly
├── GIOStream                             ⛔
│   ├── GFileIOStream                     ⛔
│   ├── GSimpleIOStream                   ⛔
│   ├── GSocketConnection                 ⛔
│   │   ├── GTcpConnection                ⛔
│   │   │   ╰── GTcpWrapperConnection     ⛔
│   │   ╰── GUnixConnection               ⛔
│   ╰── GTlsConnection                    ⛔
├── GFileMonitor
├── GFilenameCompleter
├── GInetAddress
├── GInetAddressMask
├── GSocketAddress                        ⛔
│   ├── GInetSocketAddress                ⛔
│   │   ╰── GProxyAddress                 ⛔
│   ├── GNativeSocketAddress              ⛔
│   ╰── GUnixSocketAddress                ⛔
├── GTypeModule
│   ╰── GIOModule
├── GListStore
├── GMenuAttributeIter                    MenuAttributeIter
├── GMenuItem                             MenuItem
├── GMenuLinkIter                         MenuLinkIter
├── GMountOperation
├── GNetworkAddress
├── GNetworkService
├── GNotification                         Notification
├── GPermission
│   ╰── GSimplePermission
├── GPropertyAction
├── GSocketAddressEnumerator
│   ╰── GProxyAddressEnumerator
├── GResolver
├── GSettingsBackend
├── GSettings
├── GSimpleAction                         SimpleAction
├── GSimpleActionGroup                    SimpleActionGroup
├── GSimpleAsyncResult
├── GSimpleProxyResolver
├── GSocketClient
├── GSocketControlMessage
│   ├── GUnixCredentialsMessage
│   ╰── GUnixFDMessage
├── GSocket                               ⛔
├── GSocketListener                       ⛔
│   ╰── GSocketService                    ⛔
│       ╰── GThreadedSocketService        ⛔
├── GSubprocess
├── GSubprocessLauncher
├── GTask
├── GTestDBus
├── GThemedIcon
├── GTlsCertificate
├── GTlsDatabase
├── GTlsInteraction
├── GTlsPassword
├── GUnixFDList
├── GUnixMountMonitor
├── GVfs
├── GVolumeMonitor
├── GZlibCompressor
╰── GZlibDecompressor

GInterface
├── GAction                               Action
├── GActionGroup                          ActionGroup
├── GActionMap                            ActionMap
├── GAppInfo                              AppInfo implemented as a class
├── GAsyncInitable
├── GAsyncResult
├── GSeekable
├── GIcon                                 Icon
├── GLoadableIcon                         ⛔LoadableIcon
├── GConverter
├── GInitable
├── GPollableInputStream
├── GPollableOutputStream
├── GDatagramBased
├── GRemoteActionGroup
├── GDBusInterface
├── GDBusObject
├── GDBusObjectManager
├── GDesktopAppInfoLookup
├── GDrive
├── GDtlsClientConnection
├── GDtlsConnection
├── GDtlsServerConnection
├── GFileDescriptorBased
├── GFile                                 File implemented as a class
├── GSocketConnectable
├── GListModel
├── GMount
├── GNetworkMonitor
├── GProxy
├── GProxyResolver
├── GTlsBackend
├── GTlsClientConnection
├── GTlsFileDatabase
├── GTlsServerConnection
╰── GVolume

GFlags                                    Enums. GFlags and Enums are defined
GEnum                                            in one file

GBoxed
├── GDBusAnnotationInfo
├── GDBusArgInfo
├── GDBusInterfaceInfo
├── GDBusMethodInfo
├── GDBusNodeInfo
├── GDBusPropertyInfo
├── GDBusSignalInfo
├── GFileAttributeInfoList
├── GFileAttributeMatcher
├── GResource                             Resource
├── GSettingsSchema
├── GSettingsSchemaKey
├── GSettingsSchemaSource
├── GSrvTarget
├── GUnixMountEntry
╰── GUnixMountPoint

```
