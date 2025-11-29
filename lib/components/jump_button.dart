import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class JumpButton extends SpriteComponent
    with HasGameReference<PixelAdventure>, TapCallbacks {
  JumpButton();

  final margin = 100.0;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/JumpButton.png'));
    
    print('Jump button at: (${game.jumpButtonX}, ${game.jumpButtonY}), size: ${game.customButtonSize}');
    
    // Use custom size
    size = Vector2.all(game.customButtonSize);
    
    // Use exact saved position
    position = Vector2(game.jumpButtonX, game.jumpButtonY);
    
    anchor = Anchor.center;
    priority = 999999; // Extremely high priority
    paint = Paint()..color = const Color.fromARGB(200, 255, 255, 255);
    
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}
