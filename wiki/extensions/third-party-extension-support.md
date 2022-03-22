---
title: Third Party Extension Support
---
# Third Party Extension Support in the libGDX setup
---
  
  
The libGDX setup includes a section for 3rd party extensions, these are extensions made by members of the community that aren't managed by the libGDX development team. This gives users an easy way to generate projects that depend on these 3rd party extensions without having to edit build scripts themselves. (Not that that is terribly difficult). 

## How to get your extension in the libGDX setup
### Requirements
* [A living breathing extension](#am-i-an-extension)
* [Approval by the libGDX core development team](#approval)
* [Extension definition in the libGDX setup repository](#extension-definition)
  
----
  
### Am I an extension?
As much as you may try... no you are not (Unless you are an advanced AI extension, in which case, citation needed), but you may be developing one! 

Does your project aim to extend libGDX with a specific goal in mind?  
Is your project useful to libGDX users?  
Is your project well established?  
Is your project being pushed to Maven central?  

Congratulations! It's an extension!

 
### Approval
To get your beautiful extension in the setup, you must sneak past/bribe/bewitch the libGDX developers into thinking that your extension belongs in the setup. To do this, make sure:

* Your project is open source, for security issues
* Your project is well established
* Your project is well maintained, (we will remove it if it becomes unsupported/not maintained!)

### Extension definition
We use a simple xml file in the libGDX core repository to define external extensions. 

The file can be found [here](https://github.com/libgdx/libgdx/blob/master/extensions/gdx-setup/src/com/badlogic/gdx/setup/data/extensions.xml)

An example of this file:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<extensions>
    <extension>
       <name>My Extension</name> <!-- Extension name -->
       <description>What my extension does</description> <!-- Short description of your extension-->
       <package>my.package.cheeky</package> <!-- Package name-->
       <version>0.0.1</version>             <!-- Current release version of your extension-->
       <compatibility>1.5.3</compatibility> <!-- Latest version of libGDX your extension is compatible with-->
       <website>http://mywebsite.com</website>  <!-- Url of your extension, either your extension website/github-->
       <gwtInherits>
              <inherit>cheeky</inherit>     <!-- GWT module of your extension, for the HTML project -->
       </gwtInherits>
       <projects>
           <core>                                 <!-- All dependencies for the core project-->
               <dependency>groupId:artifactId</dependency> <!--A single dependency-->
           </core>
           <desktop>
               <dependency>groupId:artifactId:classifier</dependency> <!--Multiple dependencies -->
               <dependency>groupId:artifactIdTwo:classifierTwo</dependency> <!--Multiple dependencies -->
           </desktop>                                          <!--All dependencies for the desktop project-->
           <android></android>                                <!--All dependencies for the android project-->
           <ios>null</ios>                                    <!--All dependencies for the ios project-->
           <ios-moe>null</ios-moe>                            <!--All dependencies for the ios-moe project-->
           <html>groupId:artifactIdTwo:classifierTwo</html>   <!--All dependencies for the html project-->
       </projects>
    </extension>
</extensions>
```  

### How dependencies are declared in the extensions.xml file
Under the <projects> tag are all the libGDX supported platforms. Core/Desktop/ios/Android/HTML. In each of these project tags, you can include the dependency deceleration/s for each platform. 

----
In the above example, there is a dependency for the core project on the artifact: `groupId:artifactId`
This means that when the project is generated with the extension ticked, we end up with:
```groovy
compile "groupId:artifactId:0.0.1"
```
In our core project dependency section. 

We also have two dependencies for the desktop platform, `groupId:artifactId:classifier` and `groupId:artifactIdTwo:classifierTwo`.
This would result in:
```groovy
compile "groupId:artifactId:0.0.1:classifier"
compile "groupId:artifactIdTwo:0.0.1:classifierTwo"
```
In our desktop project dependency section. 

---

This is the same for all platorms. 
A few notes:

* If you don't support a platform, you must put null like in the __ios__ project above.
* If you don't have any extras dependencies for platform, (as they are inherited from core for example) leave the section clear, like __android__ in the example above.
* Html projects require the source of dependencies! Make sure you push this source artifact and declare it in the extensions.xml!

This provides all the information required to display your extension and add it to user's projects in the setup. 


You __must__ provide all the data shown above, appended to the extensions.xml file and submit your addition as a PR.




