---
title: Networking
---
libGDX includes some classes for cross-platform network operations. These classes are more commonly known as [Gdx.net](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/Net.html) [(source)](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/Net.java)

# Features

* Cross-platform HTTP requests
* Multi-platform TCP client and server socket support (excludes GWT) with configurable settings
* Optimized  TCP client and server settings aiming for low-latency
* Cross-platform browser access. (ex: You can create a link to your website in game and it will open the browser on all platforms.)

## Implementation
Class Explanation:
* [Net.java](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/Net.java) is an interface used for the cross-platform networking. This is where you can get the objects needed to communicate with the network.
* [Socket.java](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/net/Socket.java) is an interface that provides you with the remote socket address, connection state, and a java.io.InputStream and java.io.OutputStream to work with the socket.
* [SocketHints.java](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/net/SocketHints.java) is a class used to configure TCP client sockets
* [ServerSocket.java](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/net/ServerSocket.java) is an interface used to create TCP server sockets. It provides the standard accept() method to get a TCP client that connected.
* [ServerSocketHints.java](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/net/ServerSocketHints.java) is a class used to configure TCP server sockets.
* [HttpStatus.java](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/net/HttpStatus.java) is a class used to give an easy way to see what the status code returned is.
* [HttpParameterUtils.java](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/net/HttpParametersUtils.java) is a class used to provide utility methods for HTTP requests.
* [HttpRequestBuilder](https://github.com/libgdx/libgdx/blob/master/gdx/src/com/badlogic/gdx/net/HttpRequestBuilder.java) is a class to help with creating `HttpRequests`.

To create a TCP client socket use this little piece of code:
```java
Socket socket = Gdx.net.newClientSocket(Protocol protocol, String host, int port, SocketHints hints);
```

To create a TCP server socket use this:
```
ServerSocket server = Gdx.net.newServerSocket(Protocol protocol, int port, ServerSocketHints hints);
```

To send an HTTP Request use this:
```java
HttpRequestBuilder requestBuilder = new HttpRequestBuilder();
HttpRequest httpRequest = requestBuilder.newRequest().method(HttpMethods.GET).url("http://www.google.de").build();
Gdx.net.sendHttpRequest(httpRequest, httpResponseListener);
```

To send a GET HTTP Request with arguments use this:
```java
HttpRequestBuilder requestBuilder = new HttpRequestBuilder();
HttpRequest httpRequest = requestBuilder.newRequest().method(HttpMethods.GET).url("http://www.google.de").content("q=libgdx&example=example").build();
Gdx.net.sendHttpRequest(httpRequest, httpResponseListener);
```
To open the system browser use this:
```java
Gdx.net.openURI(String URI)
```

## Receiving Response

There are different technique to flexibly receive response back from HTTP request as shown above. Example in Kotlin as follows.

1. Via class which implemented [HttpResponseListener](https://libgdx.badlogicgames.com/nightlies/docs/api/com/badlogic/gdx/Net.HttpResponseListener.html)

   For this, you have to create a class and implements `HTTPResponseListener`, then supply a method parameter with instance of such class.

   ```kotlin
   class MyReceiverOfResult : HttpResponseListener {
      override fun cancelled() {
          // do something when request gets cancelled
      }

      override fun failed(t: Throwable?) {
          // do something when it fails
      }

      override fun handleHttpResponse(httpResponse: Net.HttpResponse) {
          // do something when gets result back
      }
   }

   ...

   // assume you hold instance of such class as variable namely `receiver`.
   // then you just pass it to `sendHttpRequest()` method
   Gdx.net.sendHttpRequest(req, receiver)
   ```
2. Anonymous object
   ```kotlin
   Gdx.net.sendHttpRequest(req, object: Net.HttpResponseListener {
         override fun cancelled() {
             // do something when request gets cancelled
         }

         override fun failed(t: Throwable?) {
             // do something when it fails
         }

         override fun handleHttpResponse(httpResponse: Net.HttpResponse) {
             // do something when gets result back
         }
      })
   ```
Depends on your use case and which way you find it more flexible to do so.

### Notes
There are various notes needed when working with networking on different platforms.

1. TCP client and server sockets do **not** work on GWT. This is due to java.net not being supported on GWT and there is not a viable alternative at this point other than websockets.
2. Opening the browser is not supported on the headless backend, Android Daydreams, or Android Live Wallpapers. This is due to the limitations with the implementation and/or platform.
3. On Android: You must have the following permission declared in the AndroidManifest.xml file to access the network: `<uses-permission android:name="android.permission.INTERNET" /> `
4. On Android: You **cannot** access the network on the main thread without disabling strict mode. This is done to prevent network operations from hanging the main thread. See [here](https://developer.android.com/reference/android/os/StrictMode)
5. When targeting mobile devices: Be careful about how you implement networking. The wireless radios themselves are a big power drain when on. Also be careful about data limits that could be imposed on a 1G/2G/3G/4G LTE network. libGDX has configuration optimizations done to allow low-latency, but still have the benefits of TCP.
6. Supported networking configurations vary between backend and java implementation.
7. Battery drain is more common when data is being sent and received due to the power needed by the radios.
8. Be sure to set the `Content-Type` header for `POST` requests. Not all backends default to the same value (due to differences in the underlying implementations). The most common value for this header is `application/x-www-form-urlencoded`; however, depending on the type of data you are sending, you may need a different value (such as `application/xml` or `application/json`).

**See Also**

Great articles about mobile data battery efficiency [here](https://developer.android.com/training/efficient-downloads/index.html)

Source code for Gdx.net classes [here](https://github.com/libgdx/libgdx/tree/master/gdx/src/com/badlogic/gdx/net)