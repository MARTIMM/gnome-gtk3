---
title: Raku GTK+ Design
#nav_title: Examples
nav_menu: default-nav
sidebar_menu: design-sidebar
layout: sidebar
---

## Class hierargy

Below there is a table of the object hierarchy taken from [the developers page](https://developer.gnome.org/gio/stable/gio-hierarchy.html) and is used here to show what is implemented and what is deprecated in Gtk. Module path names are removed from the Raku modules when in Gnome::Gio. E.g. Application is implemented as **Gnome::Gio::Application**. `├─✗` in front of a Gio module means that it is deprecated or will not be implemented for other reasons. Many of these will not be implemented because Raku has a lot of I/O routines that it is not needed.
```
Tree of Gtk C structures                  Raku module
----------------------------------------  ------------------------
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
├── GMenuModel                            MenuModel
│   ├── GDBusMenuModel
│   ╰── GMenu
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
├── GSimpleAction
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
├── GAction
├── GActionGroup
├── GActionMap
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
├── GFile
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
GFlags                                    Enums. Where defined in one file
├── GAppInfoCreateFlags
├── GApplicationFlags
├── GAskPasswordFlags
├── GBusNameOwnerFlags
├── GBusNameWatcherFlags
├── GConverterFlags
├── GDBusCallFlags
├── GDBusCapabilityFlags
├── GDBusConnectionFlags
├── GDBusInterfaceSkeletonFlags
├── GDBusMessageFlags
├── GDBusObjectManagerClientFlags
├── GDBusPropertyInfoFlags
├── GDBusProxyFlags
├── GDBusSendMessageFlags
├── GDBusServerFlags
├── GDBusSignalFlags
├── GDBusSubtreeFlags
├── GDriveStartFlags
├── GFileAttributeInfoFlags
├── GFileCopyFlags
├── GFileCreateFlags
├── GFileMeasureFlags
├── GFileMonitorFlags
├── GFileQueryInfoFlags
├── GIOStreamSpliceFlags
├── GMountMountFlags
├── GMountUnmountFlags
├── GOutputStreamSpliceFlags
├── GResolverNameLookupFlags
├── GResourceFlags
├── GResourceLookupFlags
├── GSettingsBindFlags
├── GSocketMsgFlags
├── GSubprocessFlags
├── GTestDBusFlags
├── GTlsCertificateFlags
├── GTlsDatabaseVerifyFlags
╰── GTlsPasswordFlags
GEnum                                     Enums. Together with GFlags
├── GBusType
├── GConverterResult
├── GCredentialsType
├── GDataStreamByteOrder
├── GDataStreamNewlineType
├── GDBusError
├── GDBusMessageByteOrder
├── GDBusMessageHeaderField
├── GDBusMessageType
├── GDriveStartStopType
├── GEmblemOrigin
├── GFileAttributeStatus
├── GFileAttributeType
├── GFileMonitorEvent
├── GFileType
├── GFilesystemPreviewType
├── GIOErrorEnum
├── GIOModuleScopeFlags
├── GMountOperationResult
├── GNetworkConnectivity
├── GNotificationPriority
├── GPasswordSave
├── GPollableReturn
├── GResolverError
├── GResolverRecordType
├── GResourceError
├── GSocketClientEvent
├── GSocketFamily
├── GSocketType
├── GSocketProtocol
├── GSocketListenerEvent
├── GTlsAuthenticationMode
├── GTlsCertificateRequestFlags
├── GTlsDatabaseLookupFlags
├── GTlsError
├── GTlsInteractionResult
├── GTlsRehandshakeMode
├── GUnixSocketAddressType
╰── GZlibCompressorFormat
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
├── GResource
├── GSettingsSchema
├── GSettingsSchemaKey
├── GSettingsSchemaSource
├── GSrvTarget
├── GUnixMountEntry
╰── GUnixMountPoint

```
