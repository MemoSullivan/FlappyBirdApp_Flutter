import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird_game/game/assets.dart';
import 'package:flappy_bird_game/game/configuration.dart';
import 'package:flappy_bird_game/game/flappy_bird_game.dart';
import 'package:flappy_bird_game/game/pipe_position.dart';
import 'package:flappy_bird_game/components/pipe.dart';
import 'dart:developer' as devLog;

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup();

  final _random = Random();

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;

    devLog.log('--------------- START --------------');
    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    devLog.log('heightMinusGround: $heightMinusGround');
    final spacing = 200 + _random.nextDouble() * (heightMinusGround / 4);
    devLog.log('spacing: $spacing');
    final centerY =
        spacing + _random.nextDouble() * (heightMinusGround - spacing);
    devLog.log('spacing: $spacing');

    double topHeight = centerY - spacing / 2;
    double bottomHeight = heightMinusGround - (centerY + spacing / 2);

    devLog.log('PipePosition.top height: $topHeight');
    devLog.log('PipePosition.bottom height: $bottomHeight');

    devLog.log('---------------- END ---------------');
    devLog.log('\n');

    addAll([
      Pipe(pipePosition: PipePosition.top, height: centerY - spacing / 2),
      Pipe(
          pipePosition: PipePosition.bottom,
          height: heightMinusGround - (centerY + spacing / 2)),
    ]);
  }

  void updateScore() {
    gameRef.bird.score += 1;
    FlameAudio.play(Assets.point);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -10) {
      removeFromParent();
      updateScore();
    }

    if (gameRef.isHit) {
      removeFromParent();
      gameRef.isHit = false;
    }
  }
}
