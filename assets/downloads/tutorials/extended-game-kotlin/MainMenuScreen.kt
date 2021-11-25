package drop

import com.badlogic.gdx.Gdx
import com.badlogic.gdx.Screen
import com.badlogic.gdx.graphics.OrthographicCamera
import com.badlogic.gdx.utils.ScreenUtils

class MainMenuScreen(private val game: Drop): Screen {

    private var camera = OrthographicCamera().apply {
        setToOrtho(false, 800f, 480f)
    }

    override fun render(delta: Float) {
        ScreenUtils.clear(0f, 0f, 0.2f, 1f);

        camera.update();
        with (game.batch) {
            projectionMatrix = camera.combined;

            begin();
            game.font.draw(this, "Welcome to Drop!!! ", 100f, 150f);
            game.font.draw(this, "Tap anywhere to begin!", 100f, 100f);
            end();
        }

        if (Gdx.input.isTouched) {
            game.screen = GameScreen(game);
            dispose();
        }
    }

    override fun show() {

    }

    override fun resize(width: Int, height: Int) {
        
    }

    override fun pause() {
        
    }

    override fun resume() {
        
    }

    override fun hide() {
        
    }

    override fun dispose() {
        
    }
}
