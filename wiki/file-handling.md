---
title: File handling
---
* [Introduction](#introduction)
* [Platform Filesystems](#platform-filesystems)
* [File (Storage) Types](#file-storage-types)
* [Checking Storage availability and paths](#checking-storage-availability-and-paths)
* [Obtaining FileHandles](#obtaining-filehandles)
* [Listing and Checking Properties of Files](#listing-and-checking-properties-of-files)
* [Error Handling](#error-handling)
* [Reading from a File](#reading-from-a-file)
* [Writing to a File](#writing-to-a-file)
* [Deleting, Copying, Renaming and Moving Files/Directories](#deleting-copying-renaming-and-moving-filesdirectories)


## Introduction
libGDX applications run on four different platforms: desktop systems (Windows, Linux, macOS, headless), Android, iOS, and JavaScript/WebGL capable browsers. Each of these platforms handles file I/O a little differently. libGDX's [Files](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/Files.html) [(code)](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/Files.java) module provides a common interface for all these platforms with the ability to:

  * Read from a file
  * Write to a file
  * Copy a file
  * Move a file
  * Delete a file
  * List files and directories
  * Check whether a file/directory exists

Before diving into the specifics of libGDX's file handling, users should be aware of certain differences between the filesystems for all supported platforms:

## Platform Filesystems
### Desktop (Windows, Linux, Mac OS X, Headless)
On a desktop OS, the filesystem is one big chunk of memory. Files can be referenced with paths relative to the current working directory (the directory the application was executed in) or absolute paths. Ignoring file permissions, files and directories are usually readable and writable by all applications.

### Android
On Android the situation is a little bit more complex. Files can be stored inside the application's [APK](https://en.wikipedia.org/wiki/APK_(file_format)) either as resources or as assets. These files are read-only. libGDX only uses the [assets mechanism](https://developer.android.com/reference/android/content/res/AssetManager), as it provides raw access to the byte streams and more closely resembles a traditional filesystem. [Resources](https://developer.android.com/guide/topics/resources/providing-resources) better lend themselves to normal Android applications but introduce problems when used in games. Android manipulates them at load time, e.g. it automatically resizes images.

Assets are stored in your project's `assets` directory and will be packaged with your APK automatically when you deploy your application. They are accessible via `Gdx.files.internal`, a read-only directory not to be confused with what the Android documentation refers to as "internal". No other application on the Android system can access these files.

Files can also be stored on what the Android documentation refers to as [internal storage](https://developer.android.com/training/data-storage) (accessible via `Gdx.files.local` in LibGDX), where they are readable and writable. Each installed application has a dedicated internal storage directory. This directory is again only accessible by that application. One can think of this storage as a private working area for the application.

Finally, files can be stored on the external storage, accessible via `Gdx.files.external` in LibGDX. The behaviour regarding external files was changed in Android over the times, hence in LibGDX:

* libGDX up to 1.9.11 uses the Android external storage directory. That is up to Android 4.3 the sd card directory, which might not always be available, and a virtual emulated sd card directory on later versions. For accessing these files, you need to add a permission to your AndroidManifest.xml file, see [Permissions](/wiki/app/starter-classes-and-configuration#permissions). From Android 6 on, even a runtime permission is needed to use the directory and starting from Android 11, access is forbidden completely for normal apps (if you want to publish on the Play Store).
* libGDX 1.9.12 or later uses the App external storage directory. This directory (located at Android/data/data/your_package_id/) is readable and writable from your app without any further permission and changes. Other apps (like file managers) can access the files up to Android 10, from Android 11 on the directory is only accessible via USB access. Note: If the user uninstalls the app, the data saved here will be deleted if not copied to another location before by the user.

The App external storage is initialized at game start for you to use, therefore Android creates an empty directory. If you don't use external files and want to suppress this behaviour, you can do so by overriding the instantiation of `AndroidFiles` in `AndroidApplication#createFiles` (1.9.14 and up):

```java
	protected AndroidFiles createFiles() {
		this.getFilesDir(); // workaround for Android bug #10515463
		return new DefaultAndroidFiles(this.getAssets(), this, false);
	}
```

### iOS
On iOS all file types are available.

### Javascript/WebGL
A raw Javascript/WebGL application doesn't have a traditional filesystem concept. Instead, assets like images are referenced by URLs pointing to files on one or more servers. Modern browsers also support [Local Storage](http://diveintohtml5.info/storage.html) which comes close to a traditional read/write filesystem. The problem with local storage is that the storage amount available by default is fairly small, not standardized, and there no (good) way to accurately query the quota. For this reason, the preferences API is currently the only way to write local data persistently on the JS platform.

libGDX does some magic under the hood to provide you with a read-only filesystem abstraction.

## File (Storage) Types
A file in libGDX is represented by an instance of the [FileHandle](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/files/FileHandle.java) class. A FileHandle has a type which defines where the file is located. The following table illustrates the availability and location of each file type for each platform.

| *Type* | *Description, file path and features* | *Desktop* | *Android* | *HTML5* | *iOS* |
|:------:|:--------------------------------------|:---------:|:---------:|:-------:|:-----:|
| Classpath | Classpath files are directly stored in your source folders. These get packaged with your jars and are always *read-only*. They have their purpose, but should be avoided if possible. | Yes | Yes | No | Yes |
| Internal | Internal files are relative to the application’s *root* or *working* directory on desktops, relative to the *assets* directory on Android, and relative to the `core/assets/` directory of your GWT project. These files are *read-only*. If a file can't be found on the internal storage, the file module falls back to searching the file on the classpath. This is necessary if one uses the asset folder linking mechanism of Eclipse, see [Project Setup](/wiki/start/project-generation) | Yes | Yes | Yes | Yes |
| Local | Local files are stored relative to the application's *root* or *working* directory on desktops and relative to the internal (private) storage of the application on Android. Note that Local and internal are mostly the same on the desktop. | Yes | Yes | No | Yes |
| External| External files paths are relative to the [home directory](https://www.roseindia.net/java/beginners/UserHomeExample.shtml) of the current user on desktop systems. On Android, the app-specific external storage is used. | Yes | Yes | No | Yes |
| Absolute | Absolute files need to have their fully qualified paths specified. <br/>*Note*: For the sake of portability, this option must be used only when absolutely necessary | Yes | Yes | No | Yes |

Absolute and classpath files are mostly used for tools such as desktop editors, that have more complex file i/o requirements. For games these can be safely ignored. The order in which you should use the types is as follows:

  * **Internal Files**: all the assets (images, audio files, etc.) that are packaged with your application are internal files. If you use the Setup UI, just drop them in your Android project's `assets` folder.
  * **Local Files**: if you need to write small files, e.g. save a game state, use local files. These are in general private to your application. If you want a key/value store instead, you can also look into [Preferences](/wiki/preferences).
    Note that Android's app-specific cache can be accessed using '../cache'. Files stored there can be cleared by the user via the 'clear cache' button found in the app's settings.
  * **External Files**: if you need to write big files, e.g. screenshots, or download files from the web, they could go on the external storage. Note that the external storage is volatile, a user can remove it or delete the files you wrote. Because they are not cleaned up and volatile, it is usually simpler to use local file storage.

## Checking Storage availability and paths
The different storage types might not be available depending on the platform your application runs on. You can query this kind of information via the Files module:

```java
boolean isExtAvailable = Gdx.files.isExternalStorageAvailable();
boolean isLocAvailable = Gdx.files.isLocalStorageAvailable();
```

You can also query the root paths for external and local storage:

```java
String extRoot = Gdx.files.getExternalStoragePath();
String locRoot = Gdx.files.getLocalStoragePath();
```

## Obtaining FileHandles
A `FileHandle` is obtained by using one of the aforementioned types directly from the *Files* module.
The following code obtains a handle for the internal `myfile.txt file`.

```java
FileHandle handle = Gdx.files.internal("data/myfile.txt");
```

If you used the [gdx-setup tool](/wiki/start/project-generation), this file will be contained in your project's `assets` folder, `/assets/data` to be specific. Your desktop and html projects link to this folder in Eclipse, and will pick it up automatically when executed from within Eclipse.

```java
FileHandle handle = Gdx.files.classpath("myfile.txt");
```

The `myfile.txt` file is located in the directory where the compiled classes reside or the included jar files.

```java
FileHandle handle = Gdx.files.external("myfile.txt");
```

In this case, `myfile.txt` needs to be in the users’ [home directory](https://en.wikipedia.org/wiki/Home_directory) (`/home/<user>/myfile.txt` on Linux, `/Users/<user>/myfile.txt` on macOS and `C:\Users\<user>\myfile.txt` on Windows) on desktop, and in the root of the SD card on Android.

```java
FileHandle handle = Gdx.files.absolute("/some_dir/subdir/myfile.txt");
```

In the case of absolute file handle, the file has to be exactly where the full path points. In `/some_dir/subdir/` of the current drive on Windows or the exact path on linux, macOS and Android.

FileHandle instances are passed to methods of classes they are responsible for reading and writing data. E.g. a FileHandle needs to be specified when loading an image via the Texture class, or when loading an audio file via the Audio module.

## Listing and Checking Properties of Files
Sometimes it is necessary to check for the existence of a specific file or list the contents of a directory. FileHandle provides methods to do just that in a concise way.

Here's an example that checks whether a specific file exists and whether a file is actually a directory or not.

```java
boolean exists = Gdx.files.external("doitexist.txt").exists();
boolean isDirectory = Gdx.files.external("test/").isDirectory();
```

Listing a directory is equally simple:

```java
FileHandle[] files = Gdx.files.local("mylocaldir/").list();
for(FileHandle file: files) {
   // do something interesting here
}
```

**WARNING**: If you don't specify a folder the list will be empty.

**Note**: Listing of internal directories is not supported on Desktop. To work around this problem, you can [generate a list of files before deployment](https://lyze.dev/2021/04/29/libGDX-Internal-Assets-List/).

We can also ask for the parent directory of a file or create a FileHandle for a file in a directory (aka "child").

```java
FileHandle parent = Gdx.files.internal("data/graphics/myimage.png").parent();
FileHandle child = Gdx.files.internal("data/sounds/").child("myaudiofile.mp3");
```

`parent` would point to `"data/graphics/"`, child would point to `data/sounds/myaudiofile.mp3"`.

There are many more methods in FileHandle that let you check for specific attributes of a file. Please refer to the Javadocs for detail.

**Note**: These functions are mostly unimplemented in the HTML5 back-end at the moment. Try not to rely on them too much if HTML5 will be a target of your application.

## Error Handling
Some operations on FileHandles can fail. We adopted `RuntimeExceptions` to signal errors instead of checked Exceptions. Our reasoning goes like this: 90% of the time we will access files that we know exist and are readable (e.g. internal files packaged with our application).

## Reading from a File
After obtaining a FileHandle, we can either pass it to a class that knows how to load content from the file (e.g. an image), or read it ourselves. The latter is done through any of the input methods in the FileHandle class. The following example illustrates how to load text from an internal file:

```java
FileHandle file = Gdx.files.internal("myfile.txt");
String text = file.readString();
```

If you have binary data, you can easily load the file into a byte array:

```java
FileHandle file = Gdx.files.internal("myblob.bin");
byte[] bytes = file.readBytes();
```

The FileHandle class has many more read methods. Check the [Javadocs](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/files/FileHandle.html) for more information.

## Writing to a File
Similarly to reading files, FileHandle also provides methods to write to a file. Note that only the local, external and absolute file types support writing to a file. Writing a string to a file works as follows:

```java
FileHandle file = Gdx.files.local("myfile.txt");
file.writeString("My god, it's full of stars", false);
```

The second parameter of `FileHandle#writeString` specifies if the content should be appended to the file. If set to false, the current content of the file will be overwritten.

One can of course also write binary data to a file:

```java
FileHandle file = Gdx.files.local("myblob.bin");
file.writeBytes(new byte[] { 20, 3, -2, 10 }, false);
```

There are many more methods in FileHandle that facilitate writing in different ways, e.g. using `OutputStream`. Again, refer to the Javadocs for details.

## Deleting, Copying, Renaming and Moving Files/Directories
These operations are again only possible for writable file types (local, external, absolute). Note however, that the source for a copying operation can also be a read only FileHandle. A few examples:

```java
FileHandle from = Gdx.files.internal("myresource.txt");
from.copyTo(Gdx.files.external("myexternalcopy.txt"));

Gdx.files.external("myexternalcopy.txt").rename("mycopy.txt");
Gdx.files.external("mycopy.txt").moveTo(Gdx.files.local("mylocalcopy.txt"));

Gdx.files.local("mylocalcopy.txt").delete();
```

Note that source and target can be files or directories.

For more information on available methods, check the [FileHandle Javadocs](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/files/FileHandle.html).
