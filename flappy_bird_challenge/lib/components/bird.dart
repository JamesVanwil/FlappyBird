import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird_challenge/components/ground.dart';
import 'package:flappy_bird_challenge/components/pipe.dart';
import 'package:flappy_bird_challenge/constants.dart';
import 'package:flappy_bird_challenge/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class Bird extends SpriteComponent with CollisionCallbacks {
  Bird()
      : super(
          position: Vector2(birdStartX, birdStartY),
          size: Vector2(birdWidth, birdHeight),
        );

  // Physical properties
  double velocity = 0;

  // Load bird sprite
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('Bird.png');
     add(CircleHitbox()..scale = Vector2.all(0.9));

  }

void flap() {
  velocity = jumpStrength;
  FlameAudio.play('birdFlap.mp3', volume: 0.5);

 
  // Create and add a smoke particle effect
  final smokeParticle = ParticleSystemComponent(
    particle: Particle.generate(
      count: 30, // Dense particle effect
      lifespan: 0.4,
      generator: (i) {
        // Apply a rotation for dynamic movement
        final rotationMatrix = Matrix4.rotationZ(0.2);

        // Position the particles relative to the bird's current position
        // Using the current position and size of the bird to position particles right below it
        final offsetPosition = Vector2(position.x, position.y + size.y / 2); // Directly below the bird

        final transformedPosition = rotationMatrix.transform(
          Vector4(offsetPosition.x, offsetPosition.y, 0.0, 1.0),
        );
        final rotatedPosition = Vector2(
          transformedPosition.x,
          transformedPosition.y,
        );

        return AcceleratedParticle(
          acceleration: Vector2(0, 100),
          speed: Vector2.random() * 60 - Vector2(30, 30), // Faster burst
          position: rotatedPosition, // Particles spawn relative to bird's position
          child: CircleParticle(
            radius: 4.0, // Noticeable particle size
            paint: Paint()
              ..color = const Color.fromARGB(255, 61, 61, 60).withOpacity(0.8)
              ..style = PaintingStyle.fill,
          ),
        );
      },
    ),
  );

  parent?.add(smokeParticle);
}






  @override
  void update(double dt) {
    // Apply gravity and update position
    velocity += gravity * dt;
    position.y += velocity * dt;
    if (position.y < 2){
      (parent as FlappyBirdGame).gameOver();
    }
  }

 @override
void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  super.onCollision(intersectionPoints, other);

  // Handle collision with the ground
  if (other is Ground) {
    (parent as FlappyBirdGame).gameOver();
  }

  // Handle collision with pipes
  if (other is Pipe) {
    (parent as FlappyBirdGame).gameOver();
  }
}

}
