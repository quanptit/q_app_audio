import 'package:flutter/material.dart';
import 'package:q_common_utils/l.dart';
import 'package:q_media_player/q_media_player.dart';

/// Xem trong oneNode
/// Sử dụng để play một sound bất kỳ nào đó, sẽ stop cái đang play sử dụng class này, và play cái mới

mixin WigetUpdatePlayStateMixin<T extends StatefulWidget> on State<T> {
  bool? isPlaying;
  bool? isLoading;

  playAudio({required AppPlaySoundUntils appPlaySoundUntils, required QPlayerSource source}) {
    _disposed = false;
    appPlaySoundUntils.registerUI(audioWidget: this);
    appPlaySoundUntils.playAudio(source: source);
  }

  bool? _disposed;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void requireUpdate({bool? isPlaying, bool? isLoading}) {
    if (_disposed == true) return;
    setState(() {
      this.isPlaying = isPlaying;
      this.isLoading = isLoading;
    });
  }
}

class AppPlaySoundUntils {
  late QAudioPlayer audioPlayer;
  WigetUpdatePlayStateMixin? audioWidget;

  AppPlaySoundUntils() {
    audioPlayer = new QAudioPlayer();
    audioPlayer.onPlayerStateChanged = onPlayerStateChanged;
  }

  void dispose() {
    audioPlayer.dispose();
    audioWidget = null;
  }

  void registerUI({required WigetUpdatePlayStateMixin audioWidget}) {
    if (this.audioWidget != audioWidget) {
      try {
        if (this.audioWidget != null) this.audioWidget?.requireUpdate(isPlaying: false, isLoading: false);
      } catch (err) {
        L.e("registerUI ERROR: $err");
      }
      this.audioWidget = audioWidget;
    }
  }

  void unregisterUI({required WigetUpdatePlayStateMixin audioWidget}) {
    if (audioWidget == this.audioWidget) {
      this.audioWidget = null;
    }
  }

  void onPlayerStateChanged(QPlayerState state) {
    if (audioWidget == null) return;
    // L.d('onPlayerStateChanged: $state');
    switch (state) {
      case QPlayerState.playing:
        audioWidget?.requireUpdate(isLoading: false, isPlaying: true);
        break;
      case QPlayerState.preparing:
        audioWidget?.requireUpdate(isLoading: true, isPlaying: false);
        break;
      default:
        audioWidget?.isPlaying = false;
        audioWidget?.requireUpdate(isLoading: false, isPlaying: false);
        break;
    }
  }

  ///  AssetSource: link ko chứa assets  ở đầu
  /// UrlSource
  /// DeviceFileSource: access a file in the user's device, probably selected by a file picker
  /// BytesSource (only some platforms): pass in the bytes of your audio directly (read it from anywhere).
  void playAudio({required QPlayerSource? source}) {
    if(source==null) return;
    audioPlayer.playWithSource(source);
  }
}
