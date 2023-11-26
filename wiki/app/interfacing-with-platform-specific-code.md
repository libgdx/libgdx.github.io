---
title: Interfacing with platform specific code
---
Oftentimes it can become necessary to access platform specific APIs, e.g., adding advertisement services or a leaderboard functionality which are only available for Android/iOS/desktop. This can be achieved by allowing a specific implementation to be defined through a common API interface.

Take the following example, which tries to use a very simple leaderboard API that is only available on Android. For other targets we simply want to log invocations or provide mock return values.

## The common interface

The first step is to create an abstraction of the API in form of an interface which is put into the **core project**:

```java
public interface Leaderboard {
   public void submitScore(String user, int score);
}
```

Next we create specific implementations for each platform and put these into their respective projects.

## The Android implementation

On Android, we would like our code to call the Google Play API, which provides the method `LeaderboardsClient#submitScore(String leaderboardId, long score);`.

Thus, in the **Android project**, we need to implement our interface `Leaderboard` and call the platform-specific code as follows:

```java
/** Android implementation, can access PlayGames directly **/
public class AndroidLeaderboard implements Leaderboard {

   public void submitScore(String user, int score) {
      // Ignore the user name, because Google Play reports the score for the currently signed-in player
      // See https://developers.google.com/games/services/android/signin for more information on this
      PlayGames.getLeaderboardsClient(activity).submitScore(getString(R.string.leaderboard_id), score);
   }
}
```

## The desktop implementation

The following code would go into the **desktop project**:

```java
/** Desktop implementation, we simply log invocations **/
public class DesktopLeaderboard implements Leaderboard {
   public void submitScore(String user, int score) {
      Gdx.app.log("DesktopLeaderboard", "would have submitted score for user " + user + ": " + score);
   }
}
```

## The GWT implementation
The following code would go into the **HTML5 project**:

```java
/** Html5 implementation, same as DesktopLeaderboard **/
public class Html5Leaderboard implements Leaderboard {
   public void submitScore(String user, int score) {
      Gdx.app.log("Html5Leaderboard", "would have submitted score for user " + user + ": " + score);
   }
}
```

## Obtaining the platform-specific implementation in core
Next, our `ApplicationListener` gets a constructor to which we can pass the concrete Leaderboard implementation:

```java
public class MyGame implements ApplicationListener {
   private final Leaderboard leaderboard;

   public MyGame(Leaderboard leaderboardImpl) {
      this.leaderboard = leaderboardImpl;
   }

   // rest omitted for clarity
}
```

In each [starter class](/wiki/app/starter-classes-and-configuration) we then simply instantiate `MyGame`, passing the corresponding Leaderboard implementation as an argument, e.g., on the desktop:

```java
public static void main(String[] argv) {
   Lwjgl3ApplicationConfiguration config = new Lwjgl3ApplicationConfiguration();
   new Lwjgl3Application(new MyGame(new DesktopLeaderboard()), config);
}
```

Alternatively, we can obtain the platform-specific implementation via reflection:

```java
if (Gdx.app.getType() == ApplicationType.Desktop || Gdx.app.getType() == ApplicationType.HeadlessDesktop) {
    try {
		    this.leaderboard = (Leaderboard) ClassReflection.newInstance(ClassReflection.forName("com.mygame.desktop.DesktopLeaderboard"));
		} catch (ReflectionException e) {
		    e.printStackTrace();
		}
}
```
