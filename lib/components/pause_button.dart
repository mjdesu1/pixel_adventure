import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/components/pause_menu.dart';

class PauseButton extends SpriteComponent
    with HasGameReference<PixelAdventure>, TapCallbacks {
  PauseButton({super.position});

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('Menu/Buttons/Settings.png'));
    size = Vector2.all(40);
    position = Vector2(600, 10);
    anchor = Anchor.topRight;
    priority = 1000;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Pause the game
    game.pauseEngine();
    
    // Show pause menu
    final pauseMenu = PauseMenu();
    game.cam.viewport.add(pauseMenu);
    
    super.onTapDown(event);
  }
}
