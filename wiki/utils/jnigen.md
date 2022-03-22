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

Lastly, a main method is defined. The `SharedLibraryLoader` extracts the appropriate native library from the classpath and loads it. This allows you to distribute your native libraries inside your JARs and you will never have problems with `java.library.path`. If using jnigen without libgdx, you can use `JniGenSharedLibraryLoader` instead which does the same thing. `JniGenSharedLibraryLoader` is the only class from jnigen that is needed at runtime, if you choose to use it.

Here is the build for the native library above:

```
public class ExampleBuild {
	static public void main (String[] args) throws Exception {
		NativeCodeGenerator jnigen = new NativeCodeGenerator();
		jnigen.generate("src", "bin", "jni", new String[] {"**/Example.java"}, null);

		BuildTarget win32 = BuildTarget.newDefaultTarget(TargetOs.Windows, false);
		win32.compilerPrefix = "mingw32-";
		BuildTarget win64 = BuildTarget.newDefaultTarget(TargetOs.Windows, true);
		BuildTarget linux32 = BuildTarget.newDefaultTarget(TargetOs.Linux, false);
		BuildTarget linux64 = BuildTarget.newDefaultTarget(TargetOs.Linux, true);
		BuildTarget mac = BuildTarget.newDefaultTarget(TargetOs.MacOsX, true);

		new AntScriptGenerator().generate(new BuildConfig("my-native-lib"), win32, win64);
		BuildExecutor.executeAnt("jni/build-windows32.xml", "-v", "-Drelease=true", "clean", "postcompile");
		BuildExecutor.executeAnt("jni/build-windows64.xml", "-v", "-Drelease=true", "clean", "postcompile");
		// BuildExecutor.executeAnt("jni/build-linux32.xml", "-v", "-Drelease=true", "clean", "postcompile");
		// BuildExecutor.executeAnt("jni/build-linux64.xml", "-v", "-Drelease=true", "clean", "postcompile");
		// BuildExecutor.executeAnt("jni/build-macosx32.xml", "-v", "-Drelease=true", "clean", "postcompile");
		BuildExecutor.executeAnt("jni/build.xml", "-v", "pack-natives");
	}
}
```
You have to download [JNI-GEN.JAR](https://jar-download.com/?detail_search=g%3A%22com.badlogicgames.gdx%22+AND+a%3A%22gdx-jnigen%22+AND+v%3A%221.9.8%22&a=gdx-jnigen) and add it as dependency in your Android Studio.

First, `NativeCodeGenerator` is used to generate the native source from the Java source. It needs to be told where to find the Java source, the class files for that source, the directory to output the native source, a list of glob patterns for what Java source files to process, and a list of glob patterns for what source files to exclude.

Next, build targets are defined for each platform. `BuildTarget.newDefaultTarget` is used to provide reasonable defaults for each target. This build is meant to be built on Windows, so the Windows 32 bit default `compilerPrefix` of "i686-w64-mingw32-" (which is good for building on Linux) needs to be changed to "mingw32-". There are other fields on `BuildTarget` that can be customized, such as source files to include/exclude, header directories, C/C++ flags, linker flags, linked libraries, etc.

Next, `AntScriptGenerator` is used to output the Ant build scripts. The `BuildConfig` specifies global build settings, such as the name of the native library ("my-native-lib" here), input and output directories, etc.

Lastly, the Ant scripts are run to build the actual native libraries and pack them into a JAR. To run the main method from the example above, the JAR just needs to be on the classpath.

## How it works

jnigen has two parts:

  * Inspect Java source files in a specific folder, detect native methods and the attached C++ implementation, and spit out a C++ source file and header, similar to what you'd create manually with JNI.
  * Provide a generator for Ant build scripts that build the native source for every platform.

### Native code generation

Here's an example of Java/C++ mixed in a single Java source file as understood by jnigen (taken from [BufferUtils](https://github.com/libgdx/libgdx/blob/master/backends/gdx-backends-gwt/src/com/badlogic/gdx/backends/gwt/emu/com/badlogic/gdx/utils/BufferUtils.java)):

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

As you can see, the marshalling is inserted at the top and bottom of the method automatically in `copyJni()`. If you return from your JNI method in place other than the end of your method, jnigen will wrap your function with a second function that does all the marshalling, like here: [Java source](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-freetype/src/com/badlogic/gdx/graphics/g2d/freetype/FreeType.java#L584) and the [C++ translation](https://web.archive.org/web/*/https://github.com/libgdx/libgdx/blob/master/extensions/gdx-freetype/jni/com.badlogic.gdx.graphics.g2d.freetype.FreeType.cpp).

jnigen outputs the Java line numbers in the generated native code, telling us where in the original Java source file the C++ appeared. This is helpful when building jnigen generated C++ code, as the Ant script will spit out errors with Java line numbers to which we can jump to by clicking on the line in the console.

To let jnigen go through your source code and generated C/C++ header and source files, you do the following:

```java
new NativeCodeGenerator().generate("src", "bin", "jni", new String[] {"**/*"}, null);
```

You specify the source folder, the folder containing the compiled .class files of your Java classes, the Java files to include (using Ant path patterns) and the files you want to exclude. See the source of [NativeCodeGenerator](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-jnigen/src/com/badlogic/gdx/jnigen/NativeCodeGenerator.java) for more info.

#### Build script generation

Once the native code files have been generated, we also want to create build scripts for all supported platforms. This currently includes Windows (32-/64-bit), Linux (32-/64-bit), Mac OS X (x86, 32-/64-bit), Android (arm6/arm7) and iOS (i386, arm7). The build script generator of jnigen has template Ant script files that can be parametrized for each platform. The parameters are specified via a [BuildTarget](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-jnigen/src/com/badlogic/gdx/jnigen/BuildTarget.java). You can create a BuildTarget for a specific platform like this:

```java
BuildTarget linux32 = BuildTarget.newDefaultTarget(TargetOS.Linux, false);
```

This creates a default build target for Linux 32-bit. You can then add additional, platform specific settings to the BuildTarget. Repeat the process for other targets.

Once all targets are configured, you pull them together in a [BuildConfig](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-jnigen/src/com/badlogic/gdx/jnigen/BuildConfig.java). You specify the name of the shared/static library, eg "gdx" which will end up as gdx.dll on Windows, libgdx.so on Linux and Android, libgdx.dylib on Mac OS X and libgdx.a on iOS. You can also specify there the build files should be output to, etc. The easiest way of using the config looks like this:

```java
BuildConfig config = new BuildConfig("gdx");
```

One the targets and config are in place, it's time to generate the Ant scripts via the [AntScriptGenerator](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-jnigen/src/com/badlogic/gdx/jnigen/AntScriptGenerator.java):

```java
new AntScriptGenerator().generate(config, linux32, linux64, windows32, windows64, macosx, android, ios)
```

The generated Ant build scripts will compile the native libraries and package them in a JAR. They can be executed from the command line, or from Java:

```java
// Build natives:
BuildExecutor.executeAnt("jni/build-windows32.xml", "-v", "-Drelease=true", "clean", "postcompile");
BuildExecutor.executeAnt("jni/build-windows64.xml", "-v", "-Drelease=true", "clean", "postcompile");
// etc
// JAR natives:
BuildExecutor.executeAnt("jni/build.xml", "-v", "pack-natives");
```

### More

A video of Mario showing off jnigen:

[![images/lxCnueL.png](/assets/wiki/images/lxCnueL.png)](https://www.youtube.com/watch?v=N2EE_jlDfrM)

[Jglfw](https://github.com/badlogic/jglfw/blob/master/jglfw/src/com/badlogic/jglfw/Glfw.java#L268) makes extensive use of jnigen and shows how easy it can be to wrap a native API for use in Java. Note the `/*JNI` comment is used to define includes, statics, and functions.

Here are a number of jnigen builds that can serve as examples of varying complexity:

  * [Jglfw's build](https://github.com/badlogic/jglfw/blob/master/jglfw/src/com/badlogic/jglfw/GlfwBuild.java#L35)
  * [AudioBuild](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-audio/src/com/badlogic/gdx/audio/AudioBuild.java#L31)
  * [BulletBuild](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-bullet/src/com/badlogic/gdx/physics/bullet/BulletBuild.java#L26)
  * [DesktopControllersBuild](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-controllers/gdx-controllers-desktop/src/com/badlogic/gdx/controllers/desktop/DesktopControllersBuild.java#L25)
  * [FreetypeBuild](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-freetype/src/com/badlogic/gdx/graphics/g2d/freetype/FreetypeBuild.java#L26)
  * [ImageBuild](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-image/src/com/badlogic/gdx/graphics/g2d/ImageBuild.java#L26)

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
