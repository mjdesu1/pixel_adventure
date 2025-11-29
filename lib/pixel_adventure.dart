import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/components/score_display.dart';
import 'package:pixel_adventure/components/main_menu.dart';
import 'package:pixel_adventure/components/game_over_menu.dart';
import 'package:pixel_adventure/components/pause_button.dart';
import 'package:pixel_adventure/utils/high_score_manager.dart';

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  Player player = Player(character: 'Mask Dude');
  JoystickComponent? joystick;
  bool showControls = true; // Enable controls for mobile
  bool playSounds = true;
  double soundVolume = 1.0;
  List<String> levelNames = ['Level-01', 'Level-02'];
  int currentLevelIndex = 0;
  int score = 0; // Player's total score
  
  // Control settings
  String buttonSize = 'medium'; // small, medium, large
  String joystickPosition = 'left'; // left, right
  String jumpButtonPosition = 'right'; // left, right
  
  // Advanced control settings (exact positions)
  double joystickX = 100.0;
  double joystickY = 300.0;
  double jumpButtonX = 540.0;
  double jumpButtonY = 300.0;
  double customButtonSize = 60.0;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    // Show main menu on start
    _showMainMenu();

    return super.onLoad();
  }

  void _showMainMenu() {
    final mainMenu = MainMenu();
    add(mainMenu);
  }

  @override
  void update(double dt) {
    if (showControls && joystick != null) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystickToViewport(CameraComponent camera) {
    print('Adding joystick at: ($joystickX, $joystickY), size: $customButtonSize');
    
    // Use custom size
    double knobSize = customButtonSize * 0.5;
    double bgSize = customButtonSize;
    
    // Calculate margin from exact position
    // Convert game coordinates to margin
    double marginLeft = joystickX - (bgSize / 2);
    double marginBottom = (360 - joystickY) - (bgSize / 2);
    
    joystick = JoystickComponent(
      priority: 999999,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
        size: Vector2.all(knobSize),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
        size: Vector2.all(bgSize),
      ),
      margin: EdgeInsets.only(left: marginLeft, bottom: marginBottom),
    );

    camera.viewport.add(joystick!);
  }

  void updateJoystick() {
    if (joystick == null) return;
    
    switch (joystick!.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      // no more levels
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 640,
        height: 360,
      );
      cam.viewfinder.anchor = Anchor.topLeft;

      // Add score display to HUD
      final scoreDisplay = ScoreDisplay();
      cam.viewport.add(scoreDisplay);

      // Add pause button to HUD
      final pauseButton = PauseButton();
      cam.viewport.add(pauseButton);

      // Add mobile controls to viewport if enabled
      if (showControls) {
        final jumpButton = JumpButton();
        cam.viewport.add(jumpButton);
        addJoystickToViewport(cam);
      }

      addAll([cam, world]);
    });
  }

  void startGame() {
    // Start or restart the game
    currentLevelIndex = 0;
    score = 0;
    player.gotHit = false;
    player.reachedCheckpoint = false;
    _loadLevel();
  }

  void restartGame() {
    // Restart from Level-01 when player dies
    removeWhere((component) => component is Level);
    
    // Reset player state
    player.gotHit = false;
    player.reachedCheckpoint = false;
    
    // Reset score
    score = 0;
    print('Score reset to 0');
    
    currentLevelIndex = 0;
    _loadLevel();
  }

  void goToMainMenu() {
    // Go back to main menu (remove all game components)
    removeWhere((component) => component is Level);
    removeWhere((component) => component is CameraComponent);
    removeWhere((component) => component is JumpButton);
    
    // Remove joystick if it exists
    if (joystick != null) {
      joystick!.removeFromParent();
      joystick = null;
    }
    
    // Reset game state
    currentLevelIndex = 0;
    score = 0;
    player.gotHit = false;
    player.reachedCheckpoint = false;
    
    // Show main menu
    _showMainMenu();
  }

  void showGameOver() {
    // Deprecated - use showGameOverMenu instead
  }

  void showGameOverMenu() async {
    print('=== showGameOverMenu called! ===');
    print('Current score: $score');
    
    // Save high score to local storage
    if (score > 0) {
      print('Saving score to leaderboard...');
      await HighScoreManager.addScore('Player', score);
      print('Score saved successfully!');
    }
    
    print('Total children: ${children.length}');
    
    // Find camera in game - get the LAST one (most recent)
    final cameras = children.whereType<CameraComponent>().toList();
    print('Cameras found: ${cameras.length}');
    
    if (cameras.isEmpty) {
      print('ERROR: No camera found!');
      print('Children types: ${children.map((c) => c.runtimeType).toList()}');
      return;
    }
    
    // Use the LAST camera (most recent one)
    final camera = cameras.last;
    print('Using camera ${cameras.indexOf(camera) + 1} of ${cameras.length}');
    print('Camera viewport children: ${camera.viewport.children.length}');
    
    // Show game over menu - add to camera viewport
    final menu = GameOverMenu();
    print('Created GameOverMenu instance');
    
    final existingMenus = camera.viewport.children.whereType<GameOverMenu>();
    print('Existing game over menus: ${existingMenus.length}');
    
    if (existingMenus.isEmpty) {
      print('Adding menu to viewport...');
      camera.viewport.add(menu);
      
      // Force update
      Future.delayed(Duration(milliseconds: 100), () {
        print('After delay - Viewport children: ${camera.viewport.children.length}');
        print('Menu mounted: ${menu.isMounted}');
        print('Menu parent: ${menu.parent?.runtimeType}');
      });
      
      print('✅ Game over menu add() called!');
    } else {
      print('⚠️ Game over menu already exists!');
    }
  }

  void addScore(int points) {
    score += points;
  }
}
