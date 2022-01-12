---
title: Logging
---
The `Application` interface provides simple logging facilities that give granular control.

A message can be a normal info message, an error message with an optional exception or a debug message:

```java
Gdx.app.log("MyTag", "my informative message");
Gdx.app.error("MyTag", "my error message", exception);
Gdx.app.debug("MyTag", "my debug message");
```

Depending on the platform, the messages are logged to the console (desktop), LogCat (Android) or a GWT `TextArea` provided in the `GwtApplicationConfiguration` or created automatically (html5).

Logging can be limited to a specific logging level:

```java
Gdx.app.setLogLevel(logLevel);
```

where `logLevel` can be one of the following values:

  * Application.LOG_NONE: mutes all logging.
  * Application.LOG_DEBUG: logs all messages.
  * Application.LOG_ERROR: logs only error messages.
  * Application.LOG_INFO: logs error and normal messages.

[Prev](/wiki/app/querying) | [Next](/wiki/app/threading)