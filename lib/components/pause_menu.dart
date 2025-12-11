import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class PauseMenu extends PositionComponent
    with HasGameReference<PixelAdventure>, TapCallbacks {
  PauseMenu();

  @override
  int get priority => 10000;

  late RectangleComponent darkOverlay;
  late TextComponent pausedText;
  late SpriteComponent resumeButton;
  late SpriteComponent menuButton;
  late TextComponent resumeText;
  late TextComponent menuText;

  @override
  FutureOr<void> onLoad() {
    position = Vector2.zero();
    size = Vector2(640, 360);

    // Dark overlay
    darkOverlay = RectangleComponent(
      size: Vector2(640, 360),
      position: Vector2.zero(),
      paint: Paint()..color = const Color(0xDD000000),
    );
    add(darkOverlay);

    // Paused Text
    pausedText = TextComponent(
      text: 'PAUSED',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(320, 100),
      anchor: Anchor.center,
    );
    add(pausedText);

    // Resume Button
    resumeButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Play.png')),
      size: Vector2(64, 64),
      position: Vector2(320, 180),
      anchor: Anchor.center,
    );
    add(resumeButton);

    resumeText = TextComponent(
      text: 'Resume',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
        ),
      ),
      position: Vector2(320, 220),
      anchor: Anchor.center,
    );
    add(resumeText);

    // Menu Button
    menuButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Close.png')),
      size: Vector2(64, 64),
      position: Vector2(320, 260),
      anchor: Anchor.center,
    );
    add(menuButton);

    menuText = TextComponent(
      text: 'Main Menu',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
        ),
      ),
      position: Vector2(320, 300),
      anchor: Anchor.center,
    );
    add(menuText);

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    final tapPosition = event.localPosition;

    // Resume Button
    if (_isPointInButton(tapPosition, resumeButton)) {
      removeFromParent();
      game.resumeEngine();
    }
    // Menu Button
    else if (_isPointInButton(tapPosition, menuButton)) {
      removeFromParent();
      game.resumeEngine();
      game.goToMainMenu();
    }

    super.onTapDown(event);
  }

  bool _isPointInButton(Vector2 point, SpriteComponent button) {
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
