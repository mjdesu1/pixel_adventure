import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/components/advanced_settings.dart';

class SettingsMenu extends PositionComponent
    with HasGameReference<PixelAdventure>, TapCallbacks {
  SettingsMenu() {
    print('SettingsMenu constructor called');
  }

  @override
  int get priority => 100000;

  late RectangleComponent background;
  late RectangleComponent darkOverlay;
  late TextComponent titleText;
  
  // Button size options
  late TextComponent buttonSizeLabel;
  late RectangleComponent smallSizeButton;
  late RectangleComponent mediumSizeButton;
  late RectangleComponent largeSizeButton;
  late TextComponent smallSizeText;
  late TextComponent mediumSizeText;
  late TextComponent largeSizeText;
  
  // Joystick position options
  late TextComponent joystickPosLabel;
  late RectangleComponent joystickLeftButton;
  late RectangleComponent joystickRightButton;
  late TextComponent joystickLeftText;
  late TextComponent joystickRightText;
  
  // Jump button position options
  late TextComponent jumpPosLabel;
  late RectangleComponent jumpLeftButton;
  late RectangleComponent jumpRightButton;
  late TextComponent jumpLeftText;
  late TextComponent jumpRightText;
  
  // Advanced button
  late RectangleComponent advancedButton;
  late TextComponent advancedText;
  
  // Close button
  late RectangleComponent closeButton;
  late TextComponent closeText;
  
  // Button preview
  late RectangleComponent previewArea;
  late TextComponent previewLabel;
  late CircleComponent joystickPreview;
  late CircleComponent jumpButtonPreview;

  @override
  FutureOr<void> onLoad() {
    print('SettingsMenu onLoad started');
    position = Vector2.zero();
    size = Vector2(640, 360);
    
    print('Position and size set');
    
    // Pause the game when settings opens (only if game is running)
    try {
      if (game.paused == false) {
        game.pauseEngine();
        print('Game paused');
      }
    } catch (e) {
      print('Could not pause game: $e');
    }

    // Dark overlay
    print('Creating dark overlay');
    darkOverlay = RectangleComponent(
      size: Vector2(640, 360),
      paint: Paint()..color = const Color(0xDD000000),
    );
    add(darkOverlay);
    print('Dark overlay added');

    // Background panel
    background = RectangleComponent(
      size: Vector2(500, 300),
      position: Vector2(320, 180),
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFF2C2C2C),
    );
    add(background);

    // Title
    titleText = TextComponent(
      text: 'SETTINGS',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(320, 60),
      anchor: Anchor.center,
    );
    add(titleText);

    // Button Size Section
    buttonSizeLabel = TextComponent(
      text: 'Button Size:',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
        ),
      ),
      position: Vector2(120, 110),
      anchor: Anchor.centerLeft,
    );
    add(buttonSizeLabel);

    // Small button
    smallSizeButton = RectangleComponent(
      size: Vector2(80, 30),
      position: Vector2(250, 110),
      anchor: Anchor.center,
      paint: Paint()..color = game.buttonSize == 'small' 
          ? const Color(0xFF4CAF50) 
          : const Color(0xFF555555),
    );
    add(smallSizeButton);

    smallSizeText = TextComponent(
      text: 'Small',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
        ),
      ),
      position: Vector2(250, 110),
      anchor: Anchor.center,
    );
    add(smallSizeText);

    // Medium button
    mediumSizeButton = RectangleComponent(
      size: Vector2(80, 30),
      position: Vector2(350, 110),
      anchor: Anchor.center,
      paint: Paint()..color = game.buttonSize == 'medium' 
          ? const Color(0xFF4CAF50) 
          : const Color(0xFF555555),
    );
    add(mediumSizeButton);

    mediumSizeText = TextComponent(
      text: 'Medium',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
        ),
      ),
      position: Vector2(350, 110),
      anchor: Anchor.center,
    );
    add(mediumSizeText);

    // Large button
    largeSizeButton = RectangleComponent(
      size: Vector2(80, 30),
      position: Vector2(450, 110),
      anchor: Anchor.center,
      paint: Paint()..color = game.buttonSize == 'large' 
          ? const Color(0xFF4CAF50) 
          : const Color(0xFF555555),
    );
    add(largeSizeButton);

    largeSizeText = TextComponent(
      text: 'Large',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
        ),
      ),
      position: Vector2(450, 110),
      anchor: Anchor.center,
    );
    add(largeSizeText);

    // Joystick Position Section
    joystickPosLabel = TextComponent(
      text: 'Joystick Position:',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
        ),
      ),
      position: Vector2(120, 170),
      anchor: Anchor.centerLeft,
    );
    add(joystickPosLabel);

    // Joystick Left
    joystickLeftButton = RectangleComponent(
      size: Vector2(80, 30),
      position: Vector2(300, 170),
      anchor: Anchor.center,
      paint: Paint()..color = game.joystickPosition == 'left' 
          ? const Color(0xFF4CAF50) 
          : const Color(0xFF555555),
    );
    add(joystickLeftButton);

    joystickLeftText = TextComponent(
      text: 'Left',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
        ),
      ),
      position: Vector2(300, 170),
      anchor: Anchor.center,
    );
    add(joystickLeftText);

    // Joystick Right
    joystickRightButton = RectangleComponent(
      size: Vector2(80, 30),
      position: Vector2(400, 170),
      anchor: Anchor.center,
      paint: Paint()..color = game.joystickPosition == 'right' 
          ? const Color(0xFF4CAF50) 
          : const Color(0xFF555555),
    );
    add(joystickRightButton);

    joystickRightText = TextComponent(
      text: 'Right',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
        ),
      ),
      position: Vector2(400, 170),
      anchor: Anchor.center,
    );
    add(joystickRightText);

    // Jump Button Position Section
    jumpPosLabel = TextComponent(
      text: 'Jump Button Position:',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
        ),
      ),
      position: Vector2(120, 230),
      anchor: Anchor.centerLeft,
    );
    add(jumpPosLabel);

    // Jump Left
    jumpLeftButton = RectangleComponent(
      size: Vector2(80, 30),
      position: Vector2(300, 230),
      anchor: Anchor.center,
      paint: Paint()..color = game.jumpButtonPosition == 'left' 
          ? const Color(0xFF4CAF50) 
          : const Color(0xFF555555),
    );
    add(jumpLeftButton);

    jumpLeftText = TextComponent(
      text: 'Left',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
        ),
      ),
      position: Vector2(300, 230),
      anchor: Anchor.center,
    );
    add(jumpLeftText);

    // Jump Right
    jumpRightButton = RectangleComponent(
      size: Vector2(80, 30),
      position: Vector2(400, 230),
      anchor: Anchor.center,
      paint: Paint()..color = game.jumpButtonPosition == 'right' 
          ? const Color(0xFF4CAF50) 
          : const Color(0xFF555555),
    );
    add(jumpRightButton);

    jumpRightText = TextComponent(
      text: 'Right',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
        ),
      ),
      position: Vector2(400, 230),
      anchor: Anchor.center,
    );
    add(jumpRightText);

    // Advanced button (drag and drop)
    advancedButton = RectangleComponent(
      size: Vector2(180, 35),
      position: Vector2(320, 270),
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFFFF9800),
    );
    add(advancedButton);

    advancedText = TextComponent(
      text: 'ADVANCED (Drag & Drop)',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(320, 270),
      anchor: Anchor.center,
    );
    add(advancedText);

    // Close button
    closeButton = RectangleComponent(
      size: Vector2(120, 40),
      position: Vector2(320, 315),
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFF4CAF50),
    );
    add(closeButton);

    closeText = TextComponent(
      text: 'CLOSE',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(320, 300),
      anchor: Anchor.center,
    );
    add(closeText);

    // Preview Area - Show button positions like Mobile Legends
    previewLabel = TextComponent(
      text: 'Preview:',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(80, 100),
      anchor: Anchor.centerLeft,
    );
    add(previewLabel);

    // Preview background (mini game screen)
    previewArea = RectangleComponent(
      size: Vector2(120, 80),
      position: Vector2(80, 130),
      anchor: Anchor.topLeft,
      paint: Paint()
        ..color = const Color(0xFF1A1A1A)
        ..style = PaintingStyle.fill,
    );
    add(previewArea);

    // Add border to preview
    final previewBorder = RectangleComponent(
      size: Vector2(120, 80),
      position: Vector2(80, 130),
      anchor: Anchor.topLeft,
      paint: Paint()
        ..color = const Color(0xFF4CAF50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    add(previewBorder);

    // Create preview buttons
    _updatePreview();

    print('SettingsMenu onLoad completed successfully');
    return super.onLoad();
  }

  void _updatePreview() {
    // Remove old previews if they exist
    try {
      joystickPreview.removeFromParent();
    } catch (e) {
      // Not initialized yet
    }
    try {
      jumpButtonPreview.removeFromParent();
    } catch (e) {
      // Not initialized yet
    }

    // Get size multiplier
    double sizeMultiplier = game.buttonSize == 'small' ? 0.6 : 
                           game.buttonSize == 'large' ? 1.0 : 0.8;
    
    // Joystick preview position
    Vector2 joystickPos;
    if (game.joystickPosition == 'left') {
      joystickPos = Vector2(95, 195); // Bottom-left of preview
    } else {
      joystickPos = Vector2(185, 195); // Bottom-right of preview
    }

    joystickPreview = CircleComponent(
      radius: 10 * sizeMultiplier,
      position: joystickPos,
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFF2196F3),
    );
    add(joystickPreview);

    // Jump button preview position
    Vector2 jumpPos;
    if (game.jumpButtonPosition == 'left') {
      jumpPos = Vector2(95, 195); // Bottom-left of preview
    } else {
      jumpPos = Vector2(185, 195); // Bottom-right of preview
    }

    jumpButtonPreview = CircleComponent(
      radius: 8 * sizeMultiplier,
      position: jumpPos,
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFFFF9800),
    );
    add(jumpButtonPreview);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final tapPosition = event.localPosition;

    // Button Size
    if (_isPointInButton(tapPosition, smallSizeButton)) {
      game.buttonSize = 'small';
      updateButtonColors();
    } else if (_isPointInButton(tapPosition, mediumSizeButton)) {
      game.buttonSize = 'medium';
      updateButtonColors();
    } else if (_isPointInButton(tapPosition, largeSizeButton)) {
      game.buttonSize = 'large';
      updateButtonColors();
    }
    // Joystick Position
    else if (_isPointInButton(tapPosition, joystickLeftButton)) {
      game.joystickPosition = 'left';
      updateButtonColors();
    } else if (_isPointInButton(tapPosition, joystickRightButton)) {
      game.joystickPosition = 'right';
      updateButtonColors();
    }
    // Jump Button Position
    else if (_isPointInButton(tapPosition, jumpLeftButton)) {
      game.jumpButtonPosition = 'left';
      updateButtonColors();
    } else if (_isPointInButton(tapPosition, jumpRightButton)) {
      game.jumpButtonPosition = 'right';
      updateButtonColors();
    }
    // Advanced button
    else if (_isPointInButton(tapPosition, advancedButton)) {
      _showAdvancedSettings();
    }
    // Close button
    else if (_isPointInButton(tapPosition, closeButton)) {
      try {
        if (game.paused == true) {
          game.resumeEngine();
        }
      } catch (e) {
        print('Could not resume game: $e');
      }
      removeFromParent();
    }

    super.onTapDown(event);
  }

  void _showAdvancedSettings() {
    // Open advanced settings (drag and drop)
    final advanced = AdvancedSettings();
    game.add(advanced);
    removeFromParent(); // Close this menu
  }

  void updateButtonColors() {
    // Update button size colors
    smallSizeButton.paint.color = game.buttonSize == 'small' 
        ? const Color(0xFF4CAF50) 
        : const Color(0xFF555555);
    mediumSizeButton.paint.color = game.buttonSize == 'medium' 
        ? const Color(0xFF4CAF50) 
        : const Color(0xFF555555);
    largeSizeButton.paint.color = game.buttonSize == 'large' 
        ? const Color(0xFF4CAF50) 
        : const Color(0xFF555555);
    
    // Update joystick position colors
    joystickLeftButton.paint.color = game.joystickPosition == 'left' 
        ? const Color(0xFF4CAF50) 
        : const Color(0xFF555555);
    joystickRightButton.paint.color = game.joystickPosition == 'right' 
        ? const Color(0xFF4CAF50) 
        : const Color(0xFF555555);
    
    // Update jump button position colors
    jumpLeftButton.paint.color = game.jumpButtonPosition == 'left' 
        ? const Color(0xFF4CAF50) 
        : const Color(0xFF555555);
    jumpRightButton.paint.color = game.jumpButtonPosition == 'right' 
        ? const Color(0xFF4CAF50) 
        : const Color(0xFF555555);
    
    // Update preview
    _updatePreview();
  }

  bool _isPointInButton(Vector2 point, RectangleComponent button) {
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
