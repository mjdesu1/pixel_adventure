import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class AdvancedSettings extends PositionComponent
    with HasGameReference<PixelAdventure>, TapCallbacks, DragCallbacks {
  AdvancedSettings();

  @override
  int get priority => 2000;

  late RectangleComponent darkOverlay;
  late RectangleComponent panel;
  late TextComponent titleText;
  
  // Full size preview (like actual game screen)
  late RectangleComponent previewScreen;
  late TextComponent previewLabel;
  
  // Draggable buttons
  late CircleComponent joystickPreview;
  late CircleComponent jumpButtonPreview;
  
  // Size slider
  late RectangleComponent sliderTrack;
  late CircleComponent sliderKnob;
  late TextComponent sizeLabel;
  late TextComponent sizeValue;
  
  // Instructions
  late TextComponent instructionText;
  
  // Save and Reset buttons
  late RectangleComponent saveButton;
  late RectangleComponent resetButton;
  late TextComponent saveText;
  late TextComponent resetText;
  
  // Dragging state
  Component? draggedComponent;
  double buttonSize = 60.0;
  Vector2 joystickPos = Vector2(100, 300);
  Vector2 jumpButtonPos = Vector2(540, 300);

  @override
  FutureOr<void> onLoad() {
    position = Vector2.zero();
    size = Vector2(640, 360);

    // Load current settings
    buttonSize = game.buttonSize == 'small' ? 48.0 : 
                 game.buttonSize == 'large' ? 72.0 : 60.0;
    
    // Calculate positions from game settings
    if (game.joystickPosition == 'left') {
      joystickPos = Vector2(100, 300);
    } else {
      joystickPos = Vector2(540, 300);
    }
    
    if (game.jumpButtonPosition == 'left') {
      jumpButtonPos = Vector2(100, 300);
    } else {
      jumpButtonPos = Vector2(540, 300);
    }

    // Dark overlay
    darkOverlay = RectangleComponent(
      size: Vector2(640, 360),
      paint: Paint()..color = const Color(0xEE000000),
    );
    add(darkOverlay);

    // Title
    titleText = TextComponent(
      text: 'CUSTOMIZE CONTROLS',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(320, 20),
      anchor: Anchor.center,
    );
    add(titleText);

    // Preview Label
    previewLabel = TextComponent(
      text: 'Drag buttons to position them:',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
        ),
      ),
      position: Vector2(320, 45),
      anchor: Anchor.center,
    );
    add(previewLabel);

    // Full size preview screen (actual game size)
    previewScreen = RectangleComponent(
      size: Vector2(640, 200),
      position: Vector2(0, 60),
      paint: Paint()
        ..color = const Color(0xFF1A1A1A)
        ..style = PaintingStyle.fill,
    );
    add(previewScreen);

    // Preview screen border
    final previewBorder = RectangleComponent(
      size: Vector2(640, 200),
      position: Vector2(0, 60),
      paint: Paint()
        ..color = const Color(0xFF4CAF50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    add(previewBorder);

    // Joystick preview (draggable)
    joystickPreview = CircleComponent(
      radius: buttonSize / 2,
      position: joystickPos,
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xCC2196F3),
    );
    add(joystickPreview);

    // Joystick label
    final joystickLabel = TextComponent(
      text: 'JOYSTICK',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: joystickPos,
      anchor: Anchor.center,
    );
    add(joystickLabel);

    // Jump button preview (draggable)
    jumpButtonPreview = CircleComponent(
      radius: buttonSize / 2,
      position: jumpButtonPos,
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xCCFF9800),
    );
    add(jumpButtonPreview);

    // Jump button label
    final jumpLabel = TextComponent(
      text: 'JUMP',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: jumpButtonPos,
      anchor: Anchor.center,
    );
    add(jumpLabel);

    // Size slider section
    sizeLabel = TextComponent(
      text: 'Button Size:',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 16,
        ),
      ),
      position: Vector2(50, 280),
      anchor: Anchor.centerLeft,
    );
    add(sizeLabel);

    sizeValue = TextComponent(
      text: '${buttonSize.toInt()}',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(180, 280),
      anchor: Anchor.centerLeft,
    );
    add(sizeValue);

    // Slider track
    sliderTrack = RectangleComponent(
      size: Vector2(200, 4),
      position: Vector2(220, 280),
      anchor: Anchor.centerLeft,
      paint: Paint()..color = const Color(0xFF555555),
    );
    add(sliderTrack);

    // Slider knob
    double sliderProgress = (buttonSize - 40) / (80 - 40); // 40-80 range
    sliderKnob = CircleComponent(
      radius: 10,
      position: Vector2(220 + (sliderProgress * 200), 280),
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFF4CAF50),
    );
    add(sliderKnob);

    // Instructions
    instructionText = TextComponent(
      text: 'Drag slider to change size • Drag buttons to move them',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFAAAAAA),
          fontSize: 12,
        ),
      ),
      position: Vector2(320, 310),
      anchor: Anchor.center,
    );
    add(instructionText);

    // Save button
    saveButton = RectangleComponent(
      size: Vector2(120, 35),
      position: Vector2(220, 340),
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFF4CAF50),
    );
    add(saveButton);

    saveText = TextComponent(
      text: 'SAVE',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(220, 340),
      anchor: Anchor.center,
    );
    add(saveText);

    // Reset button
    resetButton = RectangleComponent(
      size: Vector2(120, 35),
      position: Vector2(420, 340),
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFF666666),
    );
    add(resetButton);

    resetText = TextComponent(
      text: 'RESET',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(420, 340),
      anchor: Anchor.center,
    );
    add(resetText);

    return super.onLoad();
  }

  @override
  void onDragStart(DragStartEvent event) {
    final pos = event.localPosition;
    
    // Check if dragging joystick
    if (_isPointInCircle(pos, joystickPreview)) {
      draggedComponent = joystickPreview;
    }
    // Check if dragging jump button
    else if (_isPointInCircle(pos, jumpButtonPreview)) {
      draggedComponent = jumpButtonPreview;
    }
    // Check if dragging slider knob
    else if (_isPointInCircle(pos, sliderKnob)) {
      draggedComponent = sliderKnob;
    }
    
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (draggedComponent == null) return;
    
    final delta = event.localDelta;
    
    if (draggedComponent == sliderKnob) {
      // Update slider
      double newX = (sliderKnob.position.x + delta.x).clamp(220, 420);
      sliderKnob.position = Vector2(newX, 280);
      
      // Calculate button size (40-80 range)
      double progress = (newX - 220) / 200;
      buttonSize = 40 + (progress * 40);
      sizeValue.text = '${buttonSize.toInt()}';
      
      // Update button sizes
      joystickPreview.radius = buttonSize / 2;
      jumpButtonPreview.radius = buttonSize / 2;
    } else if (draggedComponent == joystickPreview) {
      // Keep within preview screen bounds
      double newX = (joystickPreview.position.x + delta.x).clamp(30, 610);
      double newY = (joystickPreview.position.y + delta.y).clamp(90, 230);
      joystickPreview.position = Vector2(newX, newY);
      joystickPos = Vector2(newX, newY);
    } else if (draggedComponent == jumpButtonPreview) {
      // Keep within preview screen bounds
      double newX = (jumpButtonPreview.position.x + delta.x).clamp(30, 610);
      double newY = (jumpButtonPreview.position.y + delta.y).clamp(90, 230);
      jumpButtonPreview.position = Vector2(newX, newY);
      jumpButtonPos = Vector2(newX, newY);
    }
    
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    draggedComponent = null;
    super.onDragEnd(event);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final tapPosition = event.localPosition;

    // Save button
    if (_isPointInButton(tapPosition, saveButton)) {
      _saveSettings();
    }
    // Reset button
    else if (_isPointInButton(tapPosition, resetButton)) {
      _resetSettings();
    }

    super.onTapDown(event);
  }

  void _saveSettings() {
    print('Saving settings...');
    print('Button size: $buttonSize');
    print('Joystick pos: $joystickPos');
    print('Jump button pos: $jumpButtonPos');
    
    // Save exact positions
    game.joystickX = joystickPos.x;
    game.joystickY = joystickPos.y;
    game.jumpButtonX = jumpButtonPos.x;
    game.jumpButtonY = jumpButtonPos.y;
    game.customButtonSize = buttonSize;
    
    // Save button size category
    if (buttonSize < 50) {
      game.buttonSize = 'small';
    } else if (buttonSize > 65) {
      game.buttonSize = 'large';
    } else {
      game.buttonSize = 'medium';
    }
    
    // Save position category (left or right side)
    if (joystickPos.x < 320) {
      game.joystickPosition = 'left';
    } else {
      game.joystickPosition = 'right';
    }
    
    if (jumpButtonPos.x < 320) {
      game.jumpButtonPosition = 'left';
    } else {
      game.jumpButtonPosition = 'right';
    }
    
    print('Settings saved successfully!');
    removeFromParent();
  }

  void _resetSettings() {
    // Reset to defaults
    buttonSize = 60.0;
    joystickPos = Vector2(100, 300);
    jumpButtonPos = Vector2(540, 300);
    
    // Update UI
    joystickPreview.position = joystickPos;
    jumpButtonPreview.position = jumpButtonPos;
    joystickPreview.radius = buttonSize / 2;
    jumpButtonPreview.radius = buttonSize / 2;
    
    double sliderProgress = (buttonSize - 40) / (80 - 40);
    sliderKnob.position = Vector2(220 + (sliderProgress * 200), 280);
    sizeValue.text = '${buttonSize.toInt()}';
  }

  bool _isPointInCircle(Vector2 point, CircleComponent circle) {
    final distance = (point - circle.position).length;
    return distance <= circle.radius + 10; // Add some tolerance
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
