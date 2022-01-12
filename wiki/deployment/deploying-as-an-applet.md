---
title: Deploying as an Applet
# Not listed in ToC
---
# Deploying as an Applet #

**NOTICE:** This page is outdated. Java applets are no longer supported by any major web browser other than Internet Explorer.

## Rationale ##

When you are ready to start distributing your game on PC, you will inevitably hit the first problem that many game devs face:  getting users to convert from seeing a trailer or Let's Play of your game to actually playing it themselves.  Particularly for free / free-to-play games, it can be surprisingly challenging to convince users to download an installer.  Our goal is to make it as easy as possible for users to try our game.

Ultimately, it is good to have both a downloadable installer build of your game as well as a web version of your game.  The web SKU is good because it allows players to try the game easily if they have a JRE installed.  Getting a JRE installed can be a major headache, but still about 90% of users do have a valid JRE.  If they don't, a downloadable installer can be used which bundles a JRE appropriate to their platform.  It is also quite common for us to see users who discover our game via our applet edition and then later want the downloadable edition so they have an easy desktop shortcut.

In this article, we will explore using applets to embed our game in a web page, however there are [multiple alternatives](http://blog.gemserk.com/2011/02/09/ways-to-deploy-a-java-game/):

* GWT - My (very limited) understanding of GWT is it performs some magic to convert your Java code to Javascript.  The upside is that the end user wouldn't need a JRE installed.  However, you also don't have access to many core Java libraries or reflection support.  I'm also not sure how performant the final code is for complex 3D scenes, how stable such dramatic full codebase changes are, or how protected it is from deobfuscation techniques.  However, it is certainly an interesting new technique with a lot of promise.

* [Getdown](https://github.com/threerings/getdown) - Allows you to deploy in a way similar to Java Web Start.  It is being used successfully for several MMO titles including Spiral Knights.  As far as I know, this does not allow you to run your game inside an iframe, but instead requires its own popup window.  Distributors generally don't like this, so you may not be able to get on as many portals with this route.

## Getting a code signing cert ##

You will need a code signing certificate in order to run your Java applet.  You _might_ be able to get away just a self-signed cert for testing, but your applet will probably get blocked by every end user's browser.  I generally get my certs at Tucows Author Resource Center, which resells Comodo certs for ~$75/year (plus occasional sales).

TODO:  How to create a java key store and add certificate to it.

## Project Setup ##

### Gradle Setup ###

TODO

### Custom Build Setup (ant) ###

I'm not currently using Gradle, but instead using my own ant build scripts, so I'll detail how you can replicate my setup if you're feeling particularly brave/foolish:

You can get started by following [Thotep's steps](http://www.thesecretpie.com/2011/05/being-like-minecraft-or-how-to-run-your.html) -- skip the html & signing bits, we'll customize the build script to do this for us instead.

#### Obfuscation (if using) ####

First, when obfuscating in proguard, be sure your entry point is accessible:

```xml
<keep name="util.MyGDXApplet"></keep>
```

Of course, I recommend while first getting applets working at all, don't obfuscate.  Once you have it up and running you can start tuning Proguard.

#### Signing/Manifest ####

Second, each jar file will need to be 1) signed, 2) manifest'ed, 3) packed (we'll worry about packing later)

First, where will your application be distributed from?  We will define this at the top of our build.xml:

```xml
<property name="websource" value="*.mywebsite.net https://s3.amazonaws.com/mystorage/ file:// 127.0.0.1" />
```

When we're done testing, we should probably remove file:// and 127.0.0.1 from this list and rebuild.

Now let's create a task that can update the manifest and sign an arbitrary JAR:

```xml
	<target name="packandsign-specificfile">
    	 <jar destfile="bin\\applet\\${tosign}" update="true">
    	    <manifest>
            	<attribute name="Permissions" 								value="all-permissions" />
        		<attribute name="Application-Name" 							value="Your Application Name" />
        		<attribute name="Codebase" 									value="${websource}" />
        		<attribute name="Application-Library-Allowable-Codebase"	value="${websource}" />
        	</manifest>
    	</jar>

    	<exec command="&quot;C:\\javapath\\jdk1.7.0_25\\bin\\jarsigner&quot; -storepass PASSWORD -storetype pkcs12
			-keystore &quot;C:\certificatepath\cert.p12&quot; bin\\applet\\${tosign}
			&quot;certificate name in store&quot;" />
    </target>
```

Neat!  Now at the end of our build, lets sign/manifest each jar:

```xml
	<!--  Sign everything needed for distribution -->
    <target name="packandsign" depends="obfuscate">
        <antcall target="packandsign-specificfile">
            <param name="tosign" value="gdx-backend-lwjgl.jar" />
        </antcall>
        <antcall target="packandsign-specificfile">
            <param name="tosign" value="gdx-backend-lwjgl-natives.jar" />
        </antcall>
        <antcall target="packandsign-specificfile">
            <param name="tosign" value="gdx-backend-lwjgl-sources.jar" />
        </antcall>
        <antcall target="packandsign-specificfile">
            <param name="tosign" value="gdx-natives.jar" />
        </antcall>
        <antcall target="packandsign-specificfile">
            <param name="tosign" value="MyGame.jar" />
        </antcall>
        <antcall target="packandsign-specificfile">
            <param name="tosign" value="lwjgl_util_applet.jar" />
        </antcall>
        <antcall target="packandsign-specificfile">
            <param name="tosign" value="gdx.jar" />
        </antcall>
    </target>
```

Now when we build, we will have correctly signed and manifested JARs.  In my build setup, the same JARs can either be used for applets or for a desktop build.  Convenient!

### Foreward about Applet Caching ###

Note that as we iterate on our applet, Java as an applet in browsers has some interesting behaviors.  One of these is its tendencies to stick around silently, even after closing the tab with the applet in it.  Thus I suggest fully closing the browser anytime you update your JARs so the browser is always pulling the latest build.

Also, statics have been known to persist between page refreshes, so be warned (although I'm not sure if this is true for GDX specifically).

### HTML ###

Let's create a html file that can embed your JARs into a web page.  Thotep's HTML won't work anymore because 'Unable to read file for extraction: gdx.dll'.  Unfortunately this is due to a [libGDX bug](https://github.com/libgdx/libgdx/issues/1165) that was closed because 'Death to applets.'  Sigh.  

Fortunately, there's a workaround, at least for v1.2.0.  If you move your gdx-natives into the jars declaration, then everything will be happy.  Unfortunately that means users downloading gdx libs for platforms they're not on, but at least it runs.

```html
<param name="al_jars" value="MyGame.jar, gdx.jar, gdx-backend-lwjgl.jar, gdx-natives.jar">
<param name="al_windows" value="gdx-backend-lwjgl-natives.jar">
<param name="al_linux" value="gdx-backend-lwjgl-natives.jar">
<param name="al_mac" value="gdx-backend-lwjgl-natives.jar">
```

If you previously tried the other way, don't forget to reset your lwjgl cache or you'll still get that error (as I spent many hours learning the hard way).  On Windows, just delete %TEMP%\lwjglcache\*

### HTML v2 - Resize ###

At this point, your applet should work on Firefox, IE, and Safari.  On Chrome, Chrome's java security warning will cause all sorts of input weirdness unless you click Always Remember For This Site, and then refresh.  You'll also notice the applet does not resize to the size of the page.

Fortunately, these issues both have the same fix.  Let's update our HTML so we use the entirety of the window, and can resize as needed:

```html
<body bgcolor="#484747" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="overflow:hidden" >
	<div id="applet_container" style="position:absolute; top:0; bottom:0; left:0; right:0">
	<applet name="myApplet" code="org.lwjgl.util.applet.AppletLoader" archive="lwjgl_util_applet.jar" codebase="." width="100%" height="100%">
	<param name="al_title" value="MyGame">
	<param name="al_main" value="util.MyGDXApplet">
	<param name="al_logo" value="appletlogo.png">
	<param name="al_progressbar" value="appletprogress.gif">
	<param name="al_bgcolor" value="000000">
	<param name="al_fgcolor" value="ffffff">
	<param name="al_jars" value="MyGame.jar, gdx.jar, gdx-backend-lwjgl.jar, gdx-natives.jar">
	<param name="al_windows" value="gdx-backend-lwjgl-natives.jar">
	<param name="al_linux" value="gdx-backend-lwjgl-natives.jar">
	<param name="al_mac" value="gdx-backend-lwjgl-natives.jar">
	<param name="codebase_lookup" value="false">
	<param name="java_arguments" value="-Dsun.java2d.noddraw=true -Dsun.awt.noerasebackground=true
		-Dsun.java2d.d3d=false -Dsun.java2d.opengl=false -Dsun.java2d.pmoffscreen=false -Xmx800M">
	<param name="lwjgl_arguments" value="-Dorg.lwjgl.input.Mouse.allowNegativeMouseCoords=true">
	<param name="separate_jvm" value="true">
	<param name="codebase_lookup" value="false">
	</applet>
</body>
```

Now, we should be able to run in all major browsers with Resize!

## TODO: Checking JRE to ensure is actually recent & Oracle ##
## TODO: Display an information box if user does not have JRE installed/configured with a link to the downloadable edition of the game ##
## TODO:  Game -> Browser JS communication ##
## TODO:  Browser JS -> Game communication ##
## TODO:  JAR Packing ##
