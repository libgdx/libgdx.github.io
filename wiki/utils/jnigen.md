---
title: jnigen
---
jnigen is a small library that can be used with or without libGDX which allows C/C++ code to be written inline with Java source code. This increases the locality of code that conceptually belongs together (the Java native class methods and the actual implementation) and makes refactoring a lot easier compared to the usual [JNI](https://en.wikipedia.org/wiki/Java_Native_Interface) workflow. Arrays and direct buffers are converted for you, further reducing boilerplate. Building the natives for Windows, Linux, OS X, and Android is handled for you. jnigen also provides a mechanism for loading native libraries from a JAR at runtime, which avoids "java.library.path" troubles.

## Setup

You will need MinGW for both 32 and 64 bit. After installation, be sure the `bin` directory is on your path.

Note that gdx-jnigen is a Java project. It has a blank AndroidManifest.xml because the Android NDK requires it, but it is not an Android project.

### Windows

  * **MinGW 32 bit** Run [mingw-get-setup.exe](https://sourceforge.net/projects/mingw/files/Installer/), install with the GUI, choose `mingw32-base` and `mingw32-gcc-g++` under "Basic Setup", then Installation -> Apply Changes.
  * **MinGW 64 bit** Download the [MinGW 64 bit](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/4.8.2/threads-win32/seh/x86_64-4.8.2-release-win32-seh-rt_v3-rev1.7z/download) binaries and unzip.

### Linux

  * Ubuntu and other Debian-based systems (unverified)

```bash
sudo apt-get install g++-mingw-w64-i686 g++-mingw-w64-x86-64
```

  * Arch Linux (this installs a compiler for both 32-bit and 64-bit; [read more](https://wiki.archlinux.org/index.php/MinGW_package_guidelines))

```bash
sudo pacman -S mingw-w64-gcc
```

  * Fedora, CentOS and RHEL-based systems

```bash
sudo dnf install mingw32-gcc-c++ mingw64-gcc-c++ mingw32-winpthreads-static mingw64-winpthreads-static
```

## Quickstart

Here is a barebones example, first the Java source with inline native code:

```
public class Example {
	// @off

	static public native int add (int a, int b); /*
		return a + b;
	*/

	public static void main (String[] args) throws Exception {
		new SharedLibraryLoader().load("my-native-lib");
		System.out.println(add(1, 2));
	}
}
```

The `@off` comment turns off the Eclipse source formatter for the rest of the file. This prevents it from ruining the formatting of our native code in the comments. This feature has to be turned "on" in Eclipse preferences: Java > Code Style > Formatter. Click on "Edit" button, "Off/On Tags", check off "Enable Off/On tags".

Next, a native method is defined. Normally for JNI you would need to run [javah](https://docs.oracle.com/javase/7/docs/technotes/tools/windows/javah.html) to generate stub source files which you would edit and need to keep up to date with the Java source. With jnigen, you just use a multi-line comment immediately after the native method which contains your native code. The parameters for the native method are available to your native code.

Lastly, a main method is defined. The `SharedLibraryLoader` extracts the appropriate native library from the classpath and loads it. This allows you to distribute your native libraries inside your JARs and you will never have problems with `java.library.path`.

## How it works

jnigen has two parts:

  * Inspect Java source files in a specific folder, detect native methods and the attached C++ implementation, and spit out a C++ source file and header, similar to what you'd create manually with JNI.
  * Provide a generator for Ant build scripts that build the native source for every platform.

### Native code generation

Here's an example of Java/C++ mixed in a single Java source file as understood by jnigen (taken from [BufferUtils](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/utils/BufferUtils.java)):

```java
private static native ByteBuffer newDisposableByteBuffer (int numBytes); /*
   char* ptr = (char*)malloc(numBytes);
   return env->NewDirectByteBuffer(ptr, numBytes);
*/

private native static void copyJni (float[] src, Buffer dst, int numFloats, int offset); /*
   memcpy(dst, src + offset, numFloats << 2 );
*/
```

The C++ code is contained in a block comment after the Java native method declaration. Java side input parameters will be available to the C++ code by their Java names, and, if possible marshalled for a limited subset of types. The following marshalling takes place:

  * Primitive types are passed as is, using jint, jshort, jboolean, etc as their types.
  * One dimensional primitive type arrays are converted to typed pointers you can directly access. The arrays are automatically locked and unlocked for you via JNIEnv::GetPrimitiveArrayCritical and JNIEnv::ReleasePrimitiveArrayCritical.
  * Direct buffers are converted to unsigned char`*` pointers via JNIEnv::GetDirectBufferAddress. Note that the position of the buffer is not taken into account!
  * Any other type will be passed with its respective JNI type, eg normal Java objects will be passed as jobject.

The above two jnigen native methods would translate to the following C++ source (there would be a corresponding header file as well):

```cpp
JNIEXPORT jobject JNICALL Java_com_badlogic_gdx_utils_BufferUtils_newDisposableByteBuffer(JNIEnv* env, jclass clazz, jint numBytes) {
//@line:334
   char* ptr = (char*)malloc(numBytes);
   return env->NewDirectByteBuffer(ptr, numBytes);
}

JNIEXPORT void JNICALL Java_com_badlogic_gdx_utils_BufferUtils_copyJni___3FLjava_nio_Buffer_2II(JNIEnv* env, jclass clazz, jfloatArray obj_src, jobject obj_dst, jint numFloats, jint offset) {
   unsigned char* dst = (unsigned char*)env->GetDirectBufferAddress(obj_dst);
   float* src = (float*)env->GetPrimitiveArrayCritical(obj_src, 0);

//@line:348
   memcpy(dst, src + offset, numFloats << 2 );

   env->ReleasePrimitiveArrayCritical(obj_src, src, 0);
}
```

As you can see, the marshalling is inserted at the top and bottom of the method automatically in `copyJni()`. If you return from your JNI method in place other than the end of your method, jnigen will wrap your function with a second function that does all the marshalling,.

jnigen outputs the Java line numbers in the generated native code, telling us where in the original Java source file the C++ appeared. This is helpful when building jnigen generated C++ code, as the Ant script will spit out errors with Java line numbers to which we can jump to by clicking on the line in the console.

### How to use

The recommended way to use jnigen is through the gradle plugin, even though it is not requiered.  
First of all, you need to apply the jnigen plugin:  
```groovy
// Add buildscript dependency
buildscript {
    dependencies {
        classpath "com.badlogicgames.gdx:gdx-jnigen-gradle:2.X.X"
    }
}

// Apply jnigen plugin
apply plugin: "com.badlogicgames.gdx.gdx-jnigen"
```

Then you can configure the build actions in a `jnigen {}` block.  
You can add new targets with `add(<platform>, <bitness>, <architectur>)`.  
Platforms: `Windows`, `Linux`, `MacOsX`, `IOS`, `Android`  
Architecture: `x86`(default), `ARM`  
Bitness: `32`(default), `64`, `128`  

Note: iOS and Android don't accept Architecture or Bitness and will only generate one task.  

Every new target will create a new gradle task in the pattern `jnigenBuild<platform><architectur><bitness>`, however default values will be ignored in the task name.  

Executing these tasks will build the native library for the specified platform.  

Note: For building android natives you need `NDK_HOME` set and pointing to a valid NDK. iOS and MacOS can only be compiled on MacOS.  

For distribution the `jnigenJarNatives<destintation>` tasks exist. They will pack the generated natives in a jar, so that they can be loaded by the `SharedLibraryLoader`. These jars should be distributed.  

Destintation: `Desktop`, `Àndroid`, `IOS`  

Every taget can also be configured with additional linker flags and other configuration, if needed.  
For a complete documentation of all options and how to apply them, please take a look at the jnigen [documentation](https://github.com/libgdx/gdx-jnigen#gdx-jnigen-gradle-quickstart).  


### More

Here are a number of jnigen builds that can serve as examples of varying complexity:

* [gdx](https://github.com/libgdx/libgdx/blob/master/gdx/build.gradle)
* [gdx-freetype](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-freetype/build.gradle)
* [gdx-bullet](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-bullet/build.gradle)
* [gdx-video-desktop](https://github.com/libgdx/gdx-video/blob/master/gdx-video-desktop/build.gradle)
* [Jamepad](https://github.com/libgdx/Jamepad/blob/master/build.gradle)

### ccache
Using [ccache](https://ccache.dev/) is highly recommended if you build for all platforms (Linux, Windows, Mac OS X, Android, iOS, arm arm-v7, x86, x64 and all permutations). For libgdx, we use a very simple setup. On our build server, we have an `/opt/ccache` directory that houses a bunch of shell scripts, one for each compiler binary:

```
jenkins@badlogic:~/workspace/libgdx/gdx/jni$ ls -lah /opt/ccache/
-rwxr-xr-x  1 jenkins  www-data   44 Apr  6 13:14 g++
-rwxr-xr-x  1 jenkins  www-data   44 Apr  6 13:14 gcc
-rwxr-xr-x  1 jenkins  www-data   78 Apr  6 13:15 i686-w64-mingw32-g++
-rwxr-xr-x  1 jenkins  www-data   78 Apr  6 13:15 i686-w64-mingw32-gcc
-rwxr-xr-x  1 jenkins  www-data   82 Apr  6 13:15 x86_64-w64-mingw32-g++
-rwxr-xr-x  1 jenkins  www-data   82 Apr  6 13:15 x86_64-w64-mingw32-gcc
```

Each of these scripts looks like this (with a modified executable name of course):

```
echo "g++ ccache!"
ccache /usr/bin/g++ "$@"
```

To make ccache work, just make sure the `/opt/ccache` directory is first in your PATH:

```
export PATH=/opt/ccache:$PATH
```

Any time one of the compilers is invoked, the shell scripts redirect to ccache.

For Android it is sufficient to set NDK_CCACHE

```
export NDK_CCACHE=ccache
```
