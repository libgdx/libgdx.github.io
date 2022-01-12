---
title: Interfacing with platform specific code
---
Here's a [forum discussion](https://web.archive.org/web/20200427014652/https://www.badlogicgames.com/forum/viewtopic.php?f=11&t=9072&p=41323#p41323) on the matter, also mentioning iOS specific things.

Sometimes it is necessary to access platform specific APIs, e.g., adding advertisement services or leaderboard functionality provided by frameworks such as [Swarm](http://swarmconnect.com/).

This can be achieved by allowing specific implementation to be defined through a common API interface; so called interface class.

The following example is pure fiction and assumes we want to use a very simple leaderboard API that is only available on Android. For other targets we simply want to log invocations or provide mock return values.

The Android API looks like this:

```java
/** Let's assume this is the API provided by Swarm **/
public class LeaderboardServiceApi {
   public void submitScore(String user, int score) { ... }
}
```

The first step is to create an abstraction of the API in form of an interface.

The interface is put into the core project:

```java
public interface Leaderboard {
   public void submitScore(String user, int score);
}
```

Next we create concrete implementations for each platform and put these into their respective projects.

The following would go into the Android project:

```java
/** Android implementation, can access LeaderboardServiceApi directly **/
public class AndroidLeaderboard implements Leaderboard {
   private final LeaderboardServiceApi service;

   public AndroidLeaderboard() {
      // Assuming we can instantiate it like this
      service = new LeaderboardServiceApi();
   }

   public void submitScore(String user, int score) {
      service.submitScore(user, score);
   }
}
```

The following would go into the desktop project:

```java
/** Desktop implementation, we simply log invocations **/
public class DesktopLeaderboard implements Leaderboard {
   public void submitScore(String user, int score) {
      Gdx.app.log("DesktopLeaderboard", "would have submitted score for user " + user + ": " + score);
   }
}
```

The following would go into the HTML5 project:

```java
/** Html5 implementation, same as DesktopLeaderboard **/
public class Html5Leaderboard implements Leaderboard {
   public void submitScore(String user, int score) {
      Gdx.app.log("Html5Leaderboard", "would have submitted score for user " + user + ": " + score);
   }
}
```

Next, the `ApplicationListener` gets a constructor to which we can pass the concrete Leaderboard implementation:

```java
public class MyGame implements ApplicationListener {
   private final Leaderboard leaderboard;

   public MyGame(Leaderboard leaderboard) {
      this.leaderboard = leaderboard;
   }

   // rest omitted for clarity
}
```

In each [starter class](/wiki/app/starter-classes-and-configuration) we then simply instantiate `MyGame`, passing the corresponding Leaderboard implementation as an argument, e.g., on the desktop:

```java
public static void main(String[] argv) {
   LwjglApplicationConfiguration config = new LwjglApplicationConfiguration();
   new LwjglApplication(new MyGame(new DesktopLeaderboard()), config);
}
```
