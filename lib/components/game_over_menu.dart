import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class GameOverMenu extends PositionComponent
    with HasGameReference<PixelAdventure>, TapCallbacks {
  GameOverMenu() {
    // Make sure this component is not affected by pause
    debugMode = false;
  }
  
  @override
  int get priority => 1000; // Always render on top

  late RectangleComponent darkOverlay;
  late TextComponent gameOverText;
  late SpriteComponent yesButton;
  late SpriteComponent noButton;
  late TextComponent yesText;
  late TextComponent noText;

  @override
  FutureOr<void> onLoad() {
    // Position at camera/screen coordinates (0,0)
    position = Vector2.zero();
    size = Vector2(640, 360);

    // Dark semi-transparent overlay
    darkOverlay = RectangleComponent(
      size: Vector2(640, 360),
      position: Vector2.zero(),
      paint: Paint()..color = const Color(0xCC000000), // Semi-transparent black
    );
    add(darkOverlay);

    // Game Over Text
    gameOverText = TextComponent(
      text: 'GAME OVER',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFF0000),
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(320, 120),
      anchor: Anchor.center,
    );
    add(gameOverText);

    // Yes Button - Play Again (Restart Level-01)
    yesButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Play.png')),
      size: Vector2(64, 64),
      position: Vector2(240, 200),
      anchor: Anchor.center,
    );
    add(yesButton);

    // Yes Text
    yesText = TextComponent(
      text: 'Play Again',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 16,
        ),
      ),
      position: Vector2(240, 240),
      anchor: Anchor.center,
    );
    add(yesText);

    // No Button - Back to Main Menu
    noButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Close.png')),
      size: Vector2(64, 64),
      position: Vector2(400, 200),
      anchor: Anchor.center,
    );
    add(noButton);

    // No Text
    noText = TextComponent(
      text: 'Main Menu',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 16,
        ),
      ),
      position: Vector2(400, 240),
      anchor: Anchor.center,
    );
    add(noText);

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    final tapPosition = event.localPosition;

    // Check if Yes button was tapped
    if (_isPointInButton(tapPosition, yesButton)) {
      // Restart from Level-01
      removeFromParent();
      game.restartGame();
    }
    // Check if No button was tapped
    else if (_isPointInButton(tapPosition, noButton)) {
      // Go back to main menu
      removeFromParent();
      game.goToMainMenu();
    }

    super.onTapDown(event);
  }

  bool _isPointInButton(Vector2 point, SpriteComponent button) {
    // Button has anchor.center, so calculate bounds from center
    final left = button.position.x - button.size.x / 2;
    final right = button.position.x + button.size.x / 2;
    final top = button.position.y - button.size.y / 2;
    final bottom = button.position.y + button.size.y / 2;
    
    return point.x >= left &&
        point.x <= right &&
        point.y >= top &&
        point.y <= bottom;
  }
}
