import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird_challenge/components/ground.dart';
import 'package:flappy_bird_challenge/components/pipe.dart';
import 'package:flappy_bird_challenge/constants.dart';
import 'package:flappy_bird_challenge/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class Bird extends PositionComponent with CollisionCallbacks {
  late SpriteAnimationComponent birdAnimation;
  double velocity = 0;

  Bird()
      : super(
          position: Vector2(birdStartX, birdStartY),
          size: Vector2(birdWidth, birdHeight),
        );

  @override
  Future<void> onLoad() async {
    // Load the sprite sheet
    final spriteSheet = await Flame.images.load('birdSheet.jpg');

    // Create the animation from the sprite sheet
    final birdAnimationData = SpriteAnimationData.sequenced(
      amount: 3, // Number of frames
      stepTime: 0.1, // Time per frame
      textureSize: Vector2(43, 50), // Size of each frame
    );

    birdAnimation = SpriteAnimationComponent()
      ..animation = SpriteAnimation.fromFrameData(spriteSheet, birdAnimationData)
      ..size = Vector2(64, 64)
      ..position = Vector2(0, 0)
      ..playing = false; // Start as not playing

    // Add the bird animation component as a child
    add(birdAnimation);

    // Add a hitbox for collision detection
    add(CircleHitbox()..scale = Vector2.all(0.5));
  }

 void flap() {
  velocity = jumpStrength;
  FlameAudio.play('birdFlap.mp3', volume: 0.5);

  // Reset and play the animation
  birdAnimation.animationTicker?.reset();
  birdAnimation.playing = true;

  // Stop the animation after one cycle
  birdAnimation.animationTicker?.onComplete = () {
    birdAnimation.playing = false; // Stop after one complete cycle
  };

  // Create and add a smoke particle effect below the bird
  final smokeParticle = ParticleSystemComponent(
    particle: Particle.generate(
      count: 30,
      lifespan: 0.4,
      generator: (i) {
        final rotationMatrix = Matrix4.rotationZ(0.2);
        // Position the particles below the bird
        final offsetPosition = Vector2(position.x, position.y + size.y / 15+ 1); 
        final transformedPosition = rotationMatrix.transform(
          Vector4(offsetPosition.x, offsetPosition.y, 0.0, 1.0),
        );
        final rotatedPosition = Vector2(
          transformedPosition.x,
          transformedPosition.y,
        );

        return AcceleratedParticle(
          acceleration: Vector2(0, 100),
          speed: Vector2.random() * 60 - Vector2(30, 30),
          position: rotatedPosition,
          child: CircleParticle(
            radius: 4.0,
            paint: Paint()
              ..color = const Color.fromARGB(255, 61, 61, 60).withOpacity(0.8)
              ..style = PaintingStyle.fill,
          ),
        );
      },
    ),
  );

  parent?.add(smokeParticle);

  // Reset the bird animation to the first frame after 1 second
  Future.delayed(Duration(seconds: 1), () {
    // Reset the animation to the first frame
    birdAnimation.animationTicker?.reset();
  });
}


@override
void update(double dt) {
  // Apply gravity and update position
  velocity += gravity * dt;
  position.y += velocity * dt;

  // Prevent the bird from flying off-screen
  if (position.y < 2) {
    (parent as FlappyBirdGame).gameOver();
  }

  // If the bird is falling and the animation is not playing, reset it
  if (velocity > 0 && !birdAnimation.playing) {
    birdAnimation.animationTicker?.reset();
    birdAnimation.playing = true;
  }

  // Stop the animation when it's not flapping (not playing)
  if (velocity > 0 && birdAnimation.playing) {
    birdAnimation.playing = false; // Stop the animation if falling
  }
}


  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Handle collision with the ground or pipes
    if (other is Ground || other is Pipe) {
      (parent as FlappyBirdGame).gameOver();
    }
  }
}