import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class ScoreDisplay extends PositionComponent
    with HasGameReference<PixelAdventure> {
  ScoreDisplay({
    super.position,
  });

  late TextComponent scoreText;

  @override
  FutureOr<void> onLoad() {
    priority = 1000; // Always on top

    // Score text - moved down and smaller
    scoreText = TextComponent(
      text: 'Score: 0',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(10, 25),
      anchor: Anchor.topLeft,
    );
    add(scoreText);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // Update score display every frame
    scoreText.text = 'Score: ${game.score}';
    super.update(dt);
  }
}
