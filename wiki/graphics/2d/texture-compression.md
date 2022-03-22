---
title: Texture Compression
---
If you need texture compression, offline mipmap generation, or cubemaps, the default texture formats like PNG won't be sufficient. Luckily libGDX provides 2 options for this ETC1 files and KTX/ZKTX textures.

Note that for the **GWT** backend ETC1 and KTX/ZKTX is currently **not supported**.

Before going into details, there are 2 types of compression to be aware of ;
- compression used to store the texture on disk (zip, png, jpg,...), which is useful to reduce the size of your package,
- compression used to store the texture in memory (ETC1, ETC2, S3TC,...), which improves your game performance and minimizes the memory footprint of your application at runtime (hence reducing the risk that Android performs an App restart on resume).

OpenGL ES 2.0 has only one mandatory texture compression format on Android: ETC1 (this format is not available on iOS). It allows to decrease the size of any RGB8 image by a 6x factor. The main drawback is that it is a lossy compression format. The other is that it is limited to RGB8. To support alpha channel, you have to to store alpha separately :
- either in another texture which can be ETC1 compressed as well,
- or in the same texture, putting the color part of your image in the top, and the alpha part in the bottom.

The video memory savings will then drops from 6x to 4x, but are still worth the effort. An example is given in [KTXTest](https://github.com/libgdx/libgdx/blob/master/tests/gdx-tests/src/com/badlogic/gdx/tests/KTXTest.java).

## ETC1 File Format

ETC1 file format is a very simple format specific to libGDX (see [this blog post](https://web.archive.org/web/20200924172136/https://www.badlogicgames.com/wordpress/?p=2104)). It gives a straight forward way to support 2D texture ETC1 compressed. The drawback is that it won't give you the ability to use mipmaps or cubemaps.

### Compression
Compressing a Pixmap loaded from a file and writing it to our custom ETC1 file format is pretty simple:
```java
Pixmap pixmap = new Pixmap(Gdx.files.absolute("image.png"));
ETC1.encodeImagePKM(pixmap).write(Gdx.files.absolute("image.etc1"));
```    
You can also use the ETC1Compressor tool in the gdx-tools project which can convert entire directory hierarchies.

### Loading
Once you have your ETC1 compressed image in a file, you can easily load it like any other image file:
```java
Texture texture = new Texture(Gdx.files.internal("image.etc1"));
```    

## KTX/ZKTX Format

KTX file format is a [standard](https://www.khronos.org/opengles/sdk/tools/KTX/file_format_spec/) dedicated to storing OpenGL textures. Its main advantage is that it supports most features of OpenGL Textures (all compression formats, with or without mipmaps, cubemaps, texture arrays,...).

The ZKTX format is just a zipped KTX to limit the size of the file on disk.

### Preparing your file
The KTXProcessor tool in the gdx-tools project provides a simple way to prepare your textures:
```
usage : KTXProcessor input_file output_file [-etc1|-etc1a] [-mipmaps]
  input_file  is the texture file to include in the output KTX or ZKTX file.
              for cube map, just provide 6 input files corresponding to the faces in the following order : X+, X-, Y+, Y-, Z+, Z-
  output_file is the path to the output file, its type is based on the extension which must be either KTX or ZKTX

  options:
    -etc1    input file will be packed using ETC1 compression, dropping the alpha channel
    -etc1a   input file will be packed using ETC1 compression, doubling the height and placing the alpha channel in the bottom half
    -mipmaps input file will be processed to generate mipmaps

  examples:
    KTXProcessor in.png out.ktx                                        Create a KTX file with the provided 2D texture
    KTXProcessor in.png out.zktx                                       Create a Zipped KTX file with the provided 2D texture
    KTXProcessor in.png out.zktx -mipmaps                              Create a Zipped KTX file with the provided 2D texture, generating all mipmap levels
    KTXProcessor px.ktx nx.ktx py.ktx ny.ktx pz.ktx nz.ktx out.zktx    Create a Zipped KTX file with the provided cubemap textures
    KTXProcessor in.ktx out.zktx                                       Convert a KTX file to a Zipped KTX file
```

There are also lots of third party tools to prepare KTX texture files:
- [The OpenGL SDK](https://www.khronos.org/opengles/sdk/tools/KTX/) provides tools to create KTX file,
- [The Mali SDK](https://developer.arm.com/products/software-development-tools/graphics-development-tools/mali-texture-compression-tool) provides tools to create KTX file including alpha channel processing.

### Loading
Once you have your KTX or ZKTX compressed image in a file, you can easily load it like any other image file:

```java
Texture texture = new Texture(Gdx.files.internal("image.zktx"));
```
