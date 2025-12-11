import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:flame_audio/flame_audio.dart';
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
    'Ninja Frog',
    'Pink Man',
    'Virtual Guy',
  ];
  int selectedCharacterIndex = 0;
  bool musicStarted = false;


  @override
  FutureOr<void> onLoad() async {
    position = Vector2.zero();
    size = Vector2(640, 360);

    // Background image - stretch to fill entire screen
    final bgImage = game.images.fromCache('Background/BG.jpg');
    final bgSprite = SpriteComponent(
      sprite: Sprite(bgImage),
      size: Vector2(640, 360),
      position: Vector2.zero(),
    );
    add(bgSprite);

    // Dark overlay for better text visibility
    background = RectangleComponent(
      size: Vector2(640, 360),
      position: Vector2.zero(),
      paint: Paint()..color = const Color(0x55000000),
    );
    add(background);

    // Title - Top left (moved down)
    titleText = TextComponent(
      text: 'PEXIL MANGITA\nPRUTAS',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      position: Vector2(60, 65),
      anchor: Anchor.centerLeft,
    );
    add(titleText);

    // Menu buttons - Left side vertical layout
    double startY = 120;
    double spacing = 50;

    // Play Button
    playText = TextComponent(
      text: 'DULA',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      position: Vector2(80, startY),
      anchor: Anchor.centerLeft,
    );
    add(playText);

    playButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Play.png')),
      size: Vector2(32, 32),
      position: Vector2(40, startY),
      anchor: Anchor.center,
    );
    add(playButton);

    // How to Play
    howToPlayText = TextComponent(
      text: 'UNSAON PAGDULA',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFCCCCCC),
          fontSize: 18,
          letterSpacing: 1,
        ),
      ),
      position: Vector2(80, startY + spacing),
      anchor: Anchor.centerLeft,
    );
    add(howToPlayText);

    howToPlayButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Achievements.png')),
      size: Vector2(28, 28),
      position: Vector2(40, startY + spacing),
      anchor: Anchor.center,
    );
    add(howToPlayButton);

    // High Scores
    highScoresText = TextComponent(
      text: 'TAAS OG SCORE',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFCCCCCC),
          fontSize: 18,
          letterSpacing: 1,
        ),
      ),
      position: Vector2(80, startY + spacing * 2),
      anchor: Anchor.centerLeft,
    );
    add(highScoresText);

    highScoresButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Achievements.png')),
      size: Vector2(28, 28),
      position: Vector2(40, startY + spacing * 2),
      anchor: Anchor.center,
    );
    add(highScoresButton);

    // About
    aboutText = TextComponent(
      text: 'MAHITUNGOD',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFCCCCCC),
          fontSize: 18,
          letterSpacing: 1,
        ),
      ),
      position: Vector2(80, startY + spacing * 3),
      anchor: Anchor.centerLeft,
    );
    add(aboutText);

    aboutButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Levels.png')),
      size: Vector2(28, 28),
      position: Vector2(40, startY + spacing * 3),
      anchor: Anchor.center,
    );
    add(aboutButton);

    // Settings - Top right corner (moved down)
    settingsButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Settings.png')),
      size: Vector2(36, 36),
      position: Vector2(590, 50),
      anchor: Anchor.center,
    );
    add(settingsButton);

    settingsText = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
        ),
      ),
      position: Vector2(590, 50),
      anchor: Anchor.center,
    );
    add(settingsText);

    // Character Selection - Right side center
    characterLabel = TextComponent(
      text: 'Pilia ang Character:',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(450, 150),
      anchor: Anchor.center,
    );
    add(characterLabel);

    prevButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Previous.png')),
      size: Vector2(32, 32),
      position: Vector2(360, 200),
      anchor: Anchor.center,
    );
    add(prevButton);

    _loadCharacterPreview();

    nextButton = SpriteComponent(
      sprite: Sprite(game.images.fromCache('Menu/Buttons/Next.png')),
      size: Vector2(32, 32),
      position: Vector2(540, 200),
      anchor: Anchor.center,
    );
    add(nextButton);

    // Start menu music immediately
    if (game.playSounds && !musicStarted) {
      Future.delayed(Duration(milliseconds: 100), () {
        FlameAudio.bgm.play('menumusic.mp3', volume: game.soundVolume);
        musicStarted = true;
      });
    }

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
      position: Vector2(450, 200),
      anchor: Anchor.center,
    );
    add(characterPreview!);
  }


  @override
  void onTapDown(TapDownEvent event) {
    final tapPosition = event.localPosition;
    
    print('Main Menu tap at: $tapPosition');
    print('Play button at: ${playButton.position}, size: ${playButton.size}');

    // Play Button (check both icon and text area)
    if (_isPointInButton(tapPosition, playButton) || _isPointInText(tapPosition, playText)) {
      print('Play button clicked!');
      // Set character
      game.player.character = characters[selectedCharacterIndex];
      game.startGame();
      removeFromParent();
    }
    // How to Play Button
    else if (_isPointInButton(tapPosition, howToPlayButton) || _isPointInText(tapPosition, howToPlayText)) {
      _showHowToPlay();
    }
    // High Scores Button
    else if (_isPointInButton(tapPosition, highScoresButton) || _isPointInText(tapPosition, highScoresText)) {
      _showHighScores();
    }
    // About Button
    else if (_isPointInButton(tapPosition, aboutButton) || _isPointInText(tapPosition, aboutText)) {
      _showAbout();
    }
    // Settings Button
    else if (_isPointInButton(tapPosition, settingsButton)) {
      print('Settings button clicked!');
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

  bool _isPointInText(Vector2 point, TextComponent text) {
    // Approximate text bounds (width based on text length, height based on font size)
    final textWidth = text.text.length * 12.0; // Approximate character width
    final textHeight = 30.0; // Approximate height
    
    final left = text.position.x;
    final right = text.position.x + textWidth;
    final top = text.position.y - textHeight / 2;
    final bottom = text.position.y + textHeight / 2;
    
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
    print('Creating settings menu...');
    // Create Settings overlay
    try {
      final settings = SettingsMenu();
      game.add(settings);
      print('Settings menu added to game');
    } catch (e) {
      print('Error creating settings: $e');
    }
  }

}

// How to Play Overlay
class HowToPlayOverlay extends PositionComponent with TapCallbacks {
  @override
  int get priority => 10000;

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
      text: 'UNSAON PAGDULA',
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

    // Instructions in Bisaya with HUD info
    final instructions = [
      'Keyboard:',
      'Arrow Keys / WASD - Paglihok',
      'Space - Paglukso',
      '',
      'Mobile (HUD):',
      'Joystick - Paglihok',
      'Jump Button - Paglukso',
      '',
      'Tiguma ang mga Prutas',
      'Patya ang Kaaway (100 points)',
      'Abti ang Checkpoint',
    ];

    double yPos = 90;
    for (final instruction in instructions) {
      final text = TextComponent(
        text: instruction,
        textRenderer: TextPaint(
          style: TextStyle(
            color: instruction.endsWith(':') ? Color(0xFFFFD700) : Color(0xFFFFFFFF),
            fontSize: instruction.endsWith(':') ? 16 : 14,
            fontWeight: instruction.endsWith(':') ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        position: Vector2(320, yPos),
        anchor: Anchor.center,
      );
      add(text);
      yPos += instruction.isEmpty ? 10 : 24;
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
  int get priority => 10000;

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
      text: 'MAHITUNGOD',
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

    // About text - Game info in Bisaya
    final aboutLines = [
      'Mahitungod sa Dula:',
      '',
      'Pexil Mangita Prutas',
      'usa ka adventure platformer game',
      '',
      'Tiguma ang tanan nga prutas',
      'aron makita ang checkpoint.',
      'Patya ang mga kaaway',
      'ug likayi ang mga bitik!',
      '',
      'Gihimo gamit ang Flutter & Flame',
    ];

    double yPos = 100;
    for (final line in aboutLines) {
      final text = TextComponent(
        text: line,
        textRenderer: TextPaint(
          style: TextStyle(
            color: line == 'Mahitungod sa Dula:' || line == 'Pexil Mangita Prutas' 
                ? Color(0xFFFFD700) : Color(0xFFFFFFFF),
            fontSize: line == 'Mahitungod sa Dula:' ? 20 : 
                     line == 'Pexil Mangita Prutas' ? 18 : 15,
            fontWeight: line == 'Mahitungod sa Dula:' || line == 'Pexil Mangita Prutas'
                ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        position: Vector2(320, yPos),
        anchor: Anchor.center,
      );
      add(text);
      yPos += line.isEmpty ? 15 : 26;
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
  int get priority => 10000;

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
