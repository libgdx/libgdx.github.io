---
title: Local LibGDX package use with GWT
# Not listed in ToC
---
# Building for GWT with a package created from source
When working with libGDX source and creating a custom package (see [working with source](/dev/from-source/)), sometimes one wants to add a new file to LibGDX.
For each new file added to LibGDX, it is necessary to add a new entry for the new file to the gdx/src/com/badlogic/gdx.gwt.xml in order for the package to be used successfully when compiling for GWT.
See for example [this PR](https://github.com/libgdx/libgdx/pull/5018/files#diff-13b547f0d1b0872d60d67db4ca0b266d).
If the new file isn't added to `gdx/src/com/badlogic/gdx.gwt.xml`, an error similar to

```
    [ERROR] Errors in 'jar:file:<...>'
          [ERROR] Line <line num>: No source code is available for type com.badlogic.gdx.graphics.g3d.environment.PointShadowLight; did you forget to inherit a required module?
    [ERROR] Aborting compile due to errors in some input files
``` 

may be seen.
