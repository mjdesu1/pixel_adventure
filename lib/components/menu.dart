import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class PlayButton extends RectangleComponent with TapCallbacks, HasGameReference<PixelAdventure> {
  PlayButton({required Vector2 position, required Vector2 size})
      : super(
          position: position,
          size: size,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFF4CAF50),
        );

  @override
  void onTapDown(TapDownEvent event) {
    paint.color = const Color(0xFF45A049);
  }

  @override
  void onTapUp(TapUpEvent event) {
    paint.color = const Color(0xFF4CAF50);
    game.startGame();
    parent?.removeFromParent();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    paint.color = const Color(0xFF4CAF50);
  }
}

class Menu extends PositionComponent with HasGameReference<PixelAdventure> {
  Menu();

  @override
  FutureOr<void> onLoad() async {
    position = Vector2.zero();
    size = game.size;
    priority = 1000;

    // Add colored background
    final bg = RectangleComponent(
      size: game.size,
      paint: Paint()..color = const Color(0xFF211F30),
      priority: 0,
    );
    add(bg);

    // Add title text
    final title = TextComponent(
      text: 'PIXEL ADVENTURE',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 40,
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(game.size.x / 2, 100),
      anchor: Anchor.center,
      priority: 2,
    );
    add(title);

    // Add play button with tap detection
    const buttonWidth = 250.0;
    const buttonHeight = 80.0;
    
    final playButton = PlayButton(
      position: Vector2(game.size.x / 2, game.size.y / 2),
      size: Vector2(buttonWidth, buttonHeight),
    );
    playButton.priority = 3;
    add(playButton);

    final playText = TextComponent(
      text: 'TAP TO PLAY',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 28,
          color: Color(0xFFFFFFFF),
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(game.size.x / 2, game.size.y / 2),
      anchor: Anchor.center,
      priority: 4,
    );
    add(playText);

    return super.onLoad();
  }
}
