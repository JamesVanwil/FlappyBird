import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flappy_bird_challenge/constants.dart';
import 'package:flappy_bird_challenge/game.dart';

class Ground extends SpriteComponent with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Ground();

  @override
  Future<void> onLoad() async {
    // Set the size and position of the ground
    size = Vector2(2 * gameRef.size.x, groundHeight);
    position = Vector2(0, gameRef.size.y - groundHeight);

    // Load the ground sprite
    sprite = await Sprite.load('ground.jpg');

    // Add a collision hitbox
    add(RectangleHitbox());

    // Add a move effect to simulate scrolling
    final moveEffect = MoveEffect.to(
      Vector2(-gameRef.size.x, position.y),
      EffectController(
        duration: gameRef.size.x / groundScrollingSpeed,
        infinite: true,
      ),
      onComplete: () {
        // Reset position to simulate continuous scrolling
        position.x = 0;
      },
    );

    add(moveEffect);
  }
}