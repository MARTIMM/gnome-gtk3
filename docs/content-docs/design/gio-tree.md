---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Class hierargy

Below there is a table of the object hierarchy taken from [the developers page](https://developer.gnome.org/gio/stable/gio-hierarchy.html) and is used here to show what is implemented and what is deprecated in Gio. Module path names are removed from the Raku modules when in Gnome::Gio. E.g. Application is implemented as **Gnome::Gio::Application**. `├─✗` in front of a Gio module means that it is deprecated or will not be implemented for other reasons. Many of these will not be implemented because Raku has a lot of I/O routines that it is not needed. Modules made inheritable are noted with ♥. Inheritance is a bit more complex than normal, info will be given in due time. Modules in under construction are marked with ⛏. Modules that will change a lot and even that it can be removed are marked with ⛔. The symbol 🗸 means that the module is tested, unneeded subs are removed, documentation done etc. (that will show up almost nowhere :- ).

```
Tree of Gtk C structures                  Raku module
----------------------------------------  ------------------------------------
TopLevelClassSupport                      Gnome::N::TopLevelClassSupport
│
GObject                                   Gnome::GObject::Object
├── GAppInfoMonitor
├── GAppLaunchContext
├── GApplicationCommandLine
├── GApplication                          Application
├── GInputStream
│   ├── GFilterInputStream
│   │   ├── GBufferedInputStream
│   │   │   ╰── GDataInputStream
│   │   ╰── GConverterInputStream
│   ├── GFileInputStream
│   ├── GMemoryInputStream
│   ╰── GUnixInputStream
├── GOutputStream
│   ├── GFilterOutputStream
│   │   ├── GBufferedOutputStream
│   │   ├── GConverterOutputStream
│   │   ╰── GDataOutputStream
│   ├── GFileOutputStream
│   ├── GMemoryOutputStream
│   ╰── GUnixOutputStream
├── GBytesIcon
├── GCancellable
├── GCharsetConverter
├── GCredentials
├── GDBusActionGroup
├── GDBusAuthObserver
├── GDBusConnection
├── GDBusInterfaceSkeleton
├─✗ GMenuModel                            Use Gnome::Gtk3::Menu*
│   ├─✗ GDBusMenuModel
│   ╰─✗ GMenu                             See also https://developer.gnome.org/GMenu/
├── GDBusMessage
├── GDBusMethodInvocation
├── GDBusObjectManagerClient
├── GDBusObjectManagerServer
├── GDBusObjectProxy
├── GDBusObjectSkeleton
├── GDBusProxy
├── GDBusServer
├── GDesktopAppInfo
├── GEmblem
├── GEmblemedIcon
├── GFileEnumerator
├── GFileIcon
├── GFileInfo
├── GIOStream
│   ├── GFileIOStream
│   ├── GSimpleIOStream
│   ├── GSocketConnection
│   │   ├── GTcpConnection
│   │   │   ╰── GTcpWrapperConnection
│   │   ╰── GUnixConnection
│   ╰── GTlsConnection
├── GFileMonitor
├── GFilenameCompleter
├── GInetAddress
├── GInetAddressMask
├── GSocketAddress
│   ├── GInetSocketAddress
│   │   ╰── GProxyAddress
│   ├── GNativeSocketAddress
│   ╰── GUnixSocketAddress
├── GTypeModule
│   ╰── GIOModule
├── GListStore
├── GMenuAttributeIter
├── GMenuItem
├── GMenuLinkIter
├── GMountOperation
├── GNetworkAddress
├── GNetworkService
├── GNotification
├── GPermission
│   ╰── GSimplePermission
├── GPropertyAction
├── GSocketAddressEnumerator
│   ╰── GProxyAddressEnumerator
├── GResolver
├── GSettingsBackend
├── GSettings
├── GSimpleAction                         SimpleAction (not needed ?) ⛔
├── GSimpleActionGroup
├── GSimpleAsyncResult
├── GSimpleProxyResolver
├── GSocketClient
├── GSocketControlMessage
│   ├── GUnixCredentialsMessage
│   ╰── GUnixFDMessage
├── GSocket
├── GSocketListener
│   ╰── GSocketService
│       ╰── GThreadedSocketService
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
├── GAction                               Action (not needed ?) ⛔
├── GActionGroup
├── GActionMap                            ActionMap (not needed ?) ⛔
├── GAppInfo
├── GAsyncInitable
├── GAsyncResult
├── GSeekable
├── GIcon
├── GLoadableIcon
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
├── GFile                               File
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
