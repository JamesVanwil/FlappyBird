import 'package:flame/components.dart';
import 'package:flappy_bird_challenge/game.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ScoreText extends TextComponent with HasGameRef<FlappyBirdGame> {
  // Initialize with default text and style
  ScoreText()
      : super(
          text: '0',
          textRenderer: TextPaint(
            style: TextStyle(
              color: Colors.grey.shade900,
              fontSize: 64,
            ),
          ),
        );

  @override
  Future<void> onLoad() async {
    // Set position to center horizontally and slightly above the bottom
    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      gameRef.size.y - size.y - 50,
    );
  }

  @override
  void update(double dt) {
    final newText = gameRef.score.toString();
    if (text != newText) {
      text = newText;
    }
  }
}
