import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/rendering.dart';

class Background extends SpriteComponent {
  Background(Vector2 size)
      : super(
          size: size,
          position: Vector2.zero(),
        );

  @override
  Future<void> onLoad() async {
    // Load the background sprite
    sprite = await Sprite.load('background.jpg');

    // Apply a blur effect to the background
    decorator = PaintDecorator.blur(3.0);
  }
}
