---
title: Creating a Separate Assets Project in Eclipse
---
This will walk you through step by step on how to setup a separate project to manage your assets in Eclipse, and is a great solution if you like to keep your assets separate from your code projects. Doing so will allow you to manage them in source control differently or not at all. Additionally, you can have a nice clean separate builder for your assets project should your game be involved enough.\*

The only downside I've found is that unless you modify each project's builder to check for updates to your Assets Project, you will have to refresh (F5) the project before clicking Run, as Eclipse won't auto-detect changes to most files in the separate Assets Project. No big deal.

**Note to Gradle Builders:** This may not work for your build unless you modify the gradle script to pull in the assets.


Lets assume that you have a project named MyGame that was created using the setup tool and the project structures are how they usually are in a bare bones Eclipse scenario.


1. In Eclipse, create a new General Project. (File > New > Project...)
2. Name this project MyGame-Assets or something useful
3. Go to the MyGame-Assets project, and add a new Folder named “assets”
4. Add a new subfolder of assets named “data”
5. In the data folder, I recommend adding subfolders for graphics, sounds etc. Whatever you need.
6. Locate and expand the MyGame-Android project created by the setup tool
7. Locate the “assets” folder and back up any assets someplace else temporarily or move them to MyGame-Assets/assets/data. I recommend right clicking and using Export... if you have the project under source control.
8. Delete the “assets” folder in your MyGame-Android project
9. At the top level of the MyGame-Android project, right click and select New > Folder
10. At the bottom of the “New Folder” dialog, click the “Advanced >>” button
11. Select the “Link to Alternate Location” radio button
12. Copy and paste, without quotes: “WORKSPACE_LOC” into the blank folder path
13. Now finish typing up the path to the newly created assets folder. Ex: /MyGame-Assets/assets
14. Before clicking “OK”, ensure the “Folder Name” in the middle of the dialog is “assets”
15. Double check the full path and click OK.
16. Go to the newly linked assets folder and expand. It should have “data” and all of the subfolders displayed. If not, you made a boo boo, so go delete it and then step back and follow the instructions more carefully.
17. Right click the MyGame-Android project and select Properties
18. Go to the “Java Build Path”, and select the “Source” tab
19. Click the “Add Folder...” button on the right side of the dialog
20. In the tree that comes up, your new “assets” subfolder should be displayed. Check that bad boy and click “OK”.
21. Select the “Order and Export” tab. Ensure that the new assets folder is checked.
22. Click “OK” on the Properties for... window. You'll notice now that the icons for the assets subfolders should have changed from the usual folder icon to the Java package icon.
23. Are you assets in the MyGame-Assets project in the correct folder structure?
24. Click your MyGame-Android project, and press F5. Or clean. Whatever.
25. Run the MyGame-Android project and verify that it builds and your game art is present.
26. If you setup a Desktop or iOS project, repeat the steps to modify each project similarly to use a linked folder named “assets”.
27. Bask in the glow of your new organizational bliss and wonder if the setup tool will do this for you at some point in the future.


My MyGame-Assets projects usually look like the following tree, with organized subfolders in each, depending on what suites the particular game best. If you setup a builder, or have artwork per device... No problem. Organize your MyGame-Assets project and recreate the linked folder.

/assets (where the optimized game binaries are actually stored)
     /data`
          /graphics`
          /maps
          /screens
          /shaders
          /sounds
/assets-workfiles (where source/unoptimized files go, with a matching structure to assets)


\* I wouldn't recommend setting up a builder for just your assets until it makes sense, which is usually at the later stages of a game's development cycle. Keep it simple and real until you're closing in on production ready, determine if you absolutely need it, isolate what works best, and only THEN isolate how to optimize the packaging of your assets. At that point, you'll be able to measure the effects and maximize your effort to results ratio.