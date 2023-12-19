---
title: Logging
---
The `Application` interface provides simple logging facilities that give granular control over which messages should be logged.

A message can be a normal **info message**, an **error message** with an optional exception or a **debug message**:

```java
Gdx.app.log("MyTag", "my informative message");
Gdx.app.error("MyTag", "my error message", exception);
Gdx.app.debug("MyTag", "my debug message");
```

On desktop, the messages are logged to the console; on Android to LogCat; and on GWT they are logged either to the browser console or to a `TextArea` provided in the `GwtApplicationConfiguration`.

Logging can be limited to a specific logging level:

```java
Gdx.app.setLogLevel(logLevel);
```

where `logLevel` can be one of the following values:

  * `Application.LOG_DEBUG`: logs all messages.
  * `Application.LOG_INFO`: logs error and normal messages.
  * `Application.LOG_ERROR`: logs only error messages.
  * `Application.LOG_NONE`: mutes all logging.
