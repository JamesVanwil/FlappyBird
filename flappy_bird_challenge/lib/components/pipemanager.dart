import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappy_bird_challenge/components/pipe.dart';
import 'package:flappy_bird_challenge/constants.dart';
import 'package:flappy_bird_challenge/game.dart';

class Pipemanager extends Component with HasGameRef<FlappyBirdGame> {
  // Timer for spawning new pipes
  double _pipeSpawnTimer = 0;

  @override
  void update(double dt) {
    // Increment the timer by the delta time
    _pipeSpawnTimer += dt;

    // Check if it's time to spawn a new set of pipes
    if (_pipeSpawnTimer > pipeInterval) {
      _pipeSpawnTimer = 0;
      _spawnPipe();
    }
  }

  // Method to spawn new pipes
  void _spawnPipe() {
    final double screenHeight = gameRef.size.y;

    // Calculate the maximum height for the bottom pipe
    final double maxPipeHeight =
        screenHeight - groundHeight - pipeGap - minPipeHeight;

    // Randomize the height of the bottom pipe
    final double bottomPipeHeight =
        minPipeHeight + Random().nextDouble() * (maxPipeHeight - minPipeHeight);

    // Calculate the height of the top pipe
    final double topPipeHeight =
        screenHeight - groundHeight - bottomPipeHeight - pipeGap;

    // Create the bottom pipe
    final bottomPipe = Pipe(
      Vector2(gameRef.size.x, screenHeight - groundHeight - bottomPipeHeight),
      Vector2(pipeWidth, bottomPipeHeight),
      isTopPipe: false,
    );

    // Create the top pipe
    final topPipe = Pipe(
      Vector2(gameRef.size.x, 0),
      Vector2(pipeWidth, topPipeHeight),
      isTopPipe: true,
    );

    // Add the pipes to the game
    gameRef.add(bottomPipe);
    gameRef.add(topPipe);
  }
}
