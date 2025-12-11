import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class Fan extends SpriteAnimationComponent
    with HasGameReference<PixelAdventure>, CollisionCallbacks {
  final bool isVertical;
  final double offNeg;
  final double offPos;

  Fan({
    required super.position,
    required super.size,
    required this.isVertical,
    required this.offNeg,
    required this.offPos,
  });

  static const double fanSpeed = 0.03;
  static const moveSpeed = 50;
  static const tileSize = 16;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;

  @override
  FutureOr<void> onLoad() {
    priority = -1;

    // Calculate movement range
    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

    // Smooth spinning animation - auto-detect frame size
    final image = game.images.fromCache('Traps/Fan/On (24x8).png');
    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: fanSpeed,
        textureSize: Vector2(image.width / 8, image.height.toDouble()),
      ),
    );

    // Add hitbox for wind collision
    add(RectangleHitbox(
      position: Vector2(0, 0),
      size: Vector2(size.x, size.y),
    ));
    
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // Only move if offNeg or offPos is not zero
    if (offNeg != 0 || offPos != 0) {
      if (isVertical) {
        _moveVertically(dt);
      } else {
        _moveHorizontally(dt);
      }
    }
    super.update(dt);
  }

  void _moveVertically(double dt) {
    if (position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      // Fan blades are deadly - trigger game over
      other.collidedwithEnemy();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
