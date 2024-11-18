import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flappy_bird_challenge/constants.dart';
import 'package:flappy_bird_challenge/game.dart';

class Pipe extends SpriteComponent with CollisionCallbacks, HasGameRef<FlappyBirdGame> {
  bool scored = false;
  final bool isTopPipe;

  Pipe(Vector2 position, Vector2 size, {required this.isTopPipe})
      : super(
          position: position,
          size: size,
        );

  @override
  Future<void> onLoad() async {
    // Load the pipe sprite based on whether it's top or bottom
    sprite = await Sprite.load(isTopPipe ? 'toppipe.jpg' : 'bottompipe.jpg');
    add(RectangleHitbox());

    // Add a move effect to animate the pipe moving to the left
    final moveEffect = MoveEffect.by(
      Vector2(-gameRef.size.x - size.x, 0), // Move left by game width + pipe width
      EffectController(
        duration: (gameRef.size.x + size.x) / groundScrollingSpeed, // Calculate duration based on speed
        infinite: false,
      ),
    );

    // Add effect with a completion callback
    add(moveEffect..onComplete = () => removeFromParent());
  }

  @override
  void update(double dt) {
    super.update(dt); // Ensure effects are updated

    // Check if the bird has passed the pipe for scoring
    if (!scored && position.x + size.x < gameRef.bird.position.x) {
      scored = true;
      if (isTopPipe) {
        gameRef.incrementScore();
      }
    }
  }
}
