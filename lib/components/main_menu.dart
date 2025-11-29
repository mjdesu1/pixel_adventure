import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/utils/high_score_manager.dart';
import 'package:pixel_adventure/components/settings_menu.dart';

class MainMenu extends PositionComponent
    with HasGameReference<PixelAdventure>, TapCallbacks {
  MainMenu();

  @override
  int get priority => 1000;

  late RectangleComponent background;
  late TextComponent titleText;
  late SpriteComponent playButton;
  late SpriteComponent howToPlayButton;
  late SpriteComponent aboutButton;
  late SpriteComponent highScoresButton;
  late SpriteComponent settingsButton;
  late TextComponent playText;
  late TextComponent howToPlayText;
  late TextComponent aboutText;
  late TextComponent highScoresText;
  late TextComponent settingsText;
  
  // Character selection
  late TextComponent characterLabel;
  SpriteAnimationComponent? characterPreview; // Animated character preview
  late SpriteComponent prevButton;
  late SpriteComponent nextButton;
  
  final List<String> characters = [
    'Mask Dude',
    'Ninja Frog',
    'Pink Man',
    'Virtual Guy',
  ];
  int selectedCharacterIndex = 0;

  @override
  FutureOr<void> onLoad() {
    position = Vector2.zero();
    size = Vector2(640, 360);

    // Background
    background = RectangleComponent(
      size: Vector2(640, 360),
      position: Vector2.zero(),
      paint: Paint()..color = const Color(0xFF211F30),
    );
    add(background);

    // Title
    titleText = TextComponent(
      text: 'PIXEL ADVENTURE',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 42,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(320, 50),
      anchor: Anchor.center,
    );
    add(titleText);

    // Play Button
    playButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Play.png')),
      size: Vector2(64, 64),
      position: Vector2(320, 130),
      anchor: Anchor.center,
    );
    add(playButton);

    playText = TextComponent(
      text: 'Play Now',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
        ),
      ),
      position: Vector2(320, 170),
      anchor: Anchor.center,
    );
    add(playText);

    // How to Play Button
    howToPlayButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Achievements.png')),
      size: Vector2(42, 42),
      position: Vector2(200, 220),
      anchor: Anchor.center,
    );
    add(howToPlayButton);

    howToPlayText = TextComponent(
      text: 'How to Play',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 12,
        ),
      ),
      position: Vector2(200, 250),
      anchor: Anchor.center,
    );
    add(howToPlayText);

    // High Scores Button
    highScoresButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Achievements.png')),
      size: Vector2(42, 42),
      position: Vector2(320, 220),
      anchor: Anchor.center,
    );
    add(highScoresButton);

    highScoresText = TextComponent(
      text: 'High Scores',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 12,
        ),
      ),
      position: Vector2(320, 250),
      anchor: Anchor.center,
    );
    add(highScoresText);

    // About Button
    aboutButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Settings.png')),
      size: Vector2(42, 42),
      position: Vector2(440, 220),
      anchor: Anchor.center,
    );
    add(aboutButton);

    aboutText = TextComponent(
      text: 'About',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 12,
        ),
      ),
      position: Vector2(440, 250),
      anchor: Anchor.center,
    );
    add(aboutText);

    // Settings Button
    settingsButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Settings.png')),
      size: Vector2(42, 42),
      position: Vector2(520, 220),
      anchor: Anchor.center,
    );
    add(settingsButton);

    settingsText = TextComponent(
      text: 'Settings',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 12,
        ),
      ),
      position: Vector2(520, 250),
      anchor: Anchor.center,
    );
    add(settingsText);

    // Character Selection Label
    characterLabel = TextComponent(
      text: 'Select Character:',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 16,
        ),
      ),
      position: Vector2(320, 285),
      anchor: Anchor.center,
    );
    add(characterLabel);

    // Previous Character Button
    prevButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Previous.png')),
      size: Vector2(32, 32),
      position: Vector2(230, 325),
      anchor: Anchor.center,
    );
    add(prevButton);

    // Character Preview (idle animation)
    _loadCharacterPreview();

    // Next Character Button
    nextButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Next.png')),
      size: Vector2(32, 32),
      position: Vector2(410, 325),
      anchor: Anchor.center,
    );
    add(nextButton);

    return super.onLoad();
  }

  void _loadCharacterPreview() {
    // Remove old preview if exists
    if (characterPreview != null) {
      characterPreview!.removeFromParent();
    }

    // Load character idle animation
    final characterName = characters[selectedCharacterIndex];
    characterPreview = SpriteAnimationComponent(
      animation: SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$characterName/Idle (32x32).png'),
        SpriteAnimationData.sequenced(
          amount: 11,
          stepTime: 0.05,
          textureSize: Vector2.all(32),
        ),
      ),
      size: Vector2(64, 64),
      position: Vector2(320, 325),
      anchor: Anchor.center,
    );
    add(characterPreview!);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final tapPosition = event.localPosition;
    
    print('Main Menu tap at: $tapPosition');
    print('Play button at: ${playButton.position}, size: ${playButton.size}');

    // Play Button
    if (_isPointInButton(tapPosition, playButton)) {
      print('Play button clicked!');
      // Set character
      game.player.character = characters[selectedCharacterIndex];
      removeFromParent();
      game.startGame();
    }
    // How to Play Button
    else if (_isPointInButton(tapPosition, howToPlayButton)) {
      _showHowToPlay();
    }
    // High Scores Button
    else if (_isPointInButton(tapPosition, highScoresButton)) {
      _showHighScores();
    }
    // About Button
    else if (_isPointInButton(tapPosition, aboutButton)) {
      _showAbout();
    }
    // Settings Button
    else if (_isPointInButton(tapPosition, settingsButton)) {
      _showSettings();
    }
    // Previous Character Button
    else if (_isPointInButton(tapPosition, prevButton)) {
      selectedCharacterIndex = (selectedCharacterIndex - 1) % characters.length;
      if (selectedCharacterIndex < 0) selectedCharacterIndex = characters.length - 1;
      _loadCharacterPreview();
    }
    // Next Character Button
    else if (_isPointInButton(tapPosition, nextButton)) {
      selectedCharacterIndex = (selectedCharacterIndex + 1) % characters.length;
      _loadCharacterPreview();
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

  void _showHowToPlay() {
    // Create How to Play overlay
    final howToPlay = HowToPlayOverlay();
    game.add(howToPlay);
  }

  void _showAbout() {
    // Create About overlay
    final about = AboutOverlay();
    game.add(about);
  }

  void _showHighScores() {
    // Create High Scores overlay
    final highScores = HighScoresOverlay();
    game.add(highScores);
  }

  void _showSettings() {
    // Create Settings overlay
    final settings = SettingsMenu();
    game.add(settings);
  }

}

// How to Play Overlay
class HowToPlayOverlay extends PositionComponent with TapCallbacks {
  @override
  int get priority => 2000;

  @override
  FutureOr<void> onLoad() {
    position = Vector2.zero();
    size = Vector2(640, 360);

    // Dark overlay
    final overlay = RectangleComponent(
      size: Vector2(640, 360),
      paint: Paint()..color = const Color(0xDD000000),
    );
    add(overlay);

    // Title
    final title = TextComponent(
      text: 'HOW TO PLAY',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(320, 40),
      anchor: Anchor.center,
    );
    add(title);

    // Instructions
    final instructions = [
      'Arrow Keys / WASD - Move',
      'Space - Jump',
      'Collect Fruits - Earn Points',
      'Avoid Enemies & Traps',
      'Reach Checkpoint to Win',
    ];

    double yPos = 100;
    for (final instruction in instructions) {
      final text = TextComponent(
        text: instruction,
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 18,
          ),
        ),
        position: Vector2(320, yPos),
        anchor: Anchor.center,
      );
      add(text);
      yPos += 35;
    }

    // Close text
    final closeText = TextComponent(
      text: 'Tap anywhere to close',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFAAAAAA),
          fontSize: 16,
        ),
      ),
      position: Vector2(320, 320),
      anchor: Anchor.center,
    );
    add(closeText);

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    removeFromParent();
    super.onTapDown(event);
  }
}

// About Overlay
class AboutOverlay extends PositionComponent with TapCallbacks {
  @override
  int get priority => 2000;

  @override
  FutureOr<void> onLoad() {
    position = Vector2.zero();
    size = Vector2(640, 360);

    // Dark overlay
    final overlay = RectangleComponent(
      size: Vector2(640, 360),
      paint: Paint()..color = const Color(0xDD000000),
    );
    add(overlay);

    // Title
    final title = TextComponent(
      text: 'ABOUT',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(320, 60),
      anchor: Anchor.center,
    );
    add(title);

    // About text
    final aboutLines = [
      'Pixel Adventure',
      '',
      'A fun platformer game',
      'Collect fruits, avoid enemies,',
      'and reach the checkpoint!',
      '',
      'Made with Flutter & Flame',
    ];

    double yPos = 130;
    for (final line in aboutLines) {
      final text = TextComponent(
        text: line,
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 18,
          ),
        ),
        position: Vector2(320, yPos),
        anchor: Anchor.center,
      );
      add(text);
      yPos += 30;
    }

    // Close text
    final closeText = TextComponent(
      text: 'Tap anywhere to close',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFAAAAAA),
          fontSize: 16,
        ),
      ),
      position: Vector2(320, 320),
      anchor: Anchor.center,
    );
    add(closeText);

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    removeFromParent();
    super.onTapDown(event);
  }
}

// High Scores Overlay
class HighScoresOverlay extends PositionComponent with TapCallbacks {
  @override
  int get priority => 2000;

  @override
  FutureOr<void> onLoad() async {
    position = Vector2.zero();
    size = Vector2(640, 360);

    // Dark overlay
    final overlay = RectangleComponent(
      size: Vector2(640, 360),
      paint: Paint()..color = const Color(0xDD000000),
    );
    add(overlay);

    // Title
    final title = TextComponent(
      text: 'HIGH SCORES',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(320, 40),
      anchor: Anchor.center,
    );
    add(title);

    // Load high scores
    final scores = await HighScoreManager.getHighScores();

    if (scores.isEmpty) {
      final noScoresText = TextComponent(
        text: 'No high scores yet!',
        textRenderer: TextPaint(
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 18,
          ),
        ),
        position: Vector2(320, 180),
        anchor: Anchor.center,
      );
      add(noScoresText);
    } else {
      double yPos = 90;
      for (int i = 0; i < scores.length && i < 10; i++) {
        final entry = scores[i];
        final rank = i + 1;
        
        final scoreText = TextComponent(
          text: '$rank. ${entry.playerName} - ${entry.score}',
          textRenderer: TextPaint(
            style: TextStyle(
              color: rank <= 3 ? Color(0xFFFFD700) : Color(0xFFFFFFFF),
              fontSize: rank <= 3 ? 18 : 16,
              fontWeight: rank <= 3 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          position: Vector2(320, yPos),
          anchor: Anchor.center,
        );
        add(scoreText);
        yPos += 25;
      }
    }

    // Close text
    final closeText = TextComponent(
      text: 'Tap anywhere to close',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFAAAAAA),
          fontSize: 16,
        ),
      ),
      position: Vector2(320, 330),
      anchor: Anchor.center,
    );
    add(closeText);

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    removeFromParent();
    super.onTapDown(event);
  }
}
