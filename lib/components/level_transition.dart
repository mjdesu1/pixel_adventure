import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class LevelTransition extends PositionComponent with HasGameReference<PixelAdventure> {
  late SpriteComponent transitionSprite;
  
  LevelTransition({
    super.position,
    super.size,
  });

  @override
  FutureOr<void> onLoad() async {
    priority = 1000000;
    
    transitionSprite = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Other/Transition.png')),
      size: size,
      anchor: Anchor.center,
      position: size / 2,
    );
    
    add(transitionSprite);
    
    transitionSprite.opacity = 0;
    transitionSprite.scale = Vector2.all(1.5);
    
    return super.onLoad();
  }

  Future<void> playTransition() async {
    final fadeInEffect = OpacityEffect.to(
      1.0,
      EffectController(
        duration: 0.6,
        curve: Curves.easeInOutCubic,
      ),
    );
    
    final scaleInEffect = ScaleEffect.to(
      Vector2.all(1.0),
      EffectController(
        duration: 0.6,
        curve: Curves.easeOutCubic,
      ),
    );
    
    transitionSprite.add(fadeInEffect);
    transitionSprite.add(scaleInEffect);
    
    await fadeInEffect.completed;
    
    await Future.delayed(Duration(milliseconds: 300));
    
    final fadeOutEffect = OpacityEffect.to(
      0.0,
      EffectController(
        duration: 0.5,
        curve: Curves.easeInCubic,
      ),
    );
    
    final scaleOutEffect = ScaleEffect.to(
      Vector2.all(0.8),
      EffectController(
        duration: 0.5,
        curve: Curves.easeInCubic,
      ),
    );
    
    transitionSprite.add(fadeOutEffect);
    transitionSprite.add(scaleOutEffect);
    
    await fadeOutEffect.completed;
  }
}
