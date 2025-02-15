import 'package:flutter/cupertino.dart';

import '../q_audio.dart';

mixin AppPlaySoundMixin {
  QAudioPlayer? audioPlayer;

  void onPlayerStateChanged(QPlayerState playerState);

  _initPlayer() {
    if (audioPlayer != null) {
      _disposePlayer();
    }
    audioPlayer = QAudioPlayer();
    audioPlayer!.onPlayerStateChanged = onPlayerStateChanged;
  }
  Future dispose(){return _disposePlayer();}
  Future _disposePlayer() async {
    audioPlayer?.onPlayerStateChanged = null;
    audioPlayer?.dispose();
    audioPlayer = null;
  }

  @protected
  void protectPlayAudio({required Uri? uri}) {
    if (uri == null) return;
    final source = QPlayerSource.create(uri);
    // Same source => seek play again
    if (audioPlayer?.currentSource?.toString() != null && audioPlayer?.currentSource?.toString() == source.toString()) {
      audioPlayer?.playWithSource(source);
    } else {
      _disposePlayer();
      _initPlayer();
      audioPlayer?.playWithSource(source);
    }
  }
}
