import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird_challenge/components/background.dart';
import 'package:flappy_bird_challenge/components/bird.dart';
import 'package:flappy_bird_challenge/components/ground.dart';
import 'package:flappy_bird_challenge/components/pipe.dart';
import 'package:flappy_bird_challenge/components/pipemanager.dart';
import 'package:flappy_bird_challenge/components/score.dart';
import 'package:flappy_bird_challenge/constants.dart';
import 'package:flutter/material.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection{

  late Bird bird;
  late Background background;
  late Ground ground;
  late Pipemanager pipeManager;
  late ScoreText scoreText;

  @override
  FutureOr<void> onLoad() {
    // Load background
    background = Background(size);
    add(background);

    // Load bird
    bird = Bird();
    add(bird);

    // Load ground
    ground = Ground();
    add(ground);

    // Load pipes
    pipeManager = Pipemanager();
    add(pipeManager);

    // Load score
    scoreText = ScoreText();
    add(scoreText);

    // Play background music and handle looping manually
    FlameAudio.bgm.play('backgroundMusic.wav', volume: 0.5);

  }

  SpriteAnimationComponent animationComponent = SpriteAnimationComponent(size: Vector2(112 * 5, 133 * 5));

  // Tap to flap the bird
  @override
  Future<void> onTap() async {
    super.onTap();
    bird.flap();
    SpriteSheet spriteSheet = SpriteSheet(image: await images.load('birdSheet.jpg'), srcSize: Vector2(112, 133));
    SpriteAnimation spriteAnimation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 1, to: 3);
    animationComponent.animation = spriteAnimation;

  }

  

  // Score
  int score = 0;

  void incrementScore() {
    score += 1;
    FlameAudio.play('pointScored.wav', volume: 0.5);
  }

  // Game over
  bool isGameOver = false;

 void gameOver() {
  if (isGameOver) return;

  isGameOver = true;

  pauseEngine();

  // Game over dialogue box
  showDialog(
    context: buildContext!,
    barrierDismissible: false, // Prevent closing the dialog by tapping outside
    builder: (context) => AlertDialog(
      title: const Text("Game Over"),
      content: Text("Score: $score"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            resetGame();
          },
          child: const Text("Restart"),
        ),
      ],
    ),
  );
}

  void resetGame() {
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;
    score = 0;
    isGameOver = false;
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());
    resumeEngine();
  }
}
