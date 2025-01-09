import 'package:flutter/material.dart';
import 'package:q_common_utils/index.dart';
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
  WeakReference<WigetUpdatePlayStateMixin>? audioWidgetRef;

  AppPlaySoundUntils() {
    audioPlayer = new QAudioPlayer();
    audioPlayer.onPlayerStateChanged = onPlayerStateChanged;
  }

  void dispose() {
    audioPlayer.dispose();
    audioWidgetRef = null;
  }

  void registerUI({required WigetUpdatePlayStateMixin audioWidget}) {
    var oldAudioWidget = audioWidgetRef?.target;
    if (oldAudioWidget!=null && oldAudioWidget != audioWidget) {
      try {
        oldAudioWidget.requireUpdate(isPlaying: false, isLoading: false);
      } catch (err) {
        L.e("registerUI ERROR: $err");
      }
    }
    audioWidgetRef = WeakReference(audioWidget);
  }

  // void unregisterUI({required WigetUpdatePlayStateMixin audioWidget}) {
  //   if (audioWidget == this.audioWidget) {
  //     this.audioWidget = null;
  //   }
  // }

  void onPlayerStateChanged(QPlayerState state) {
    var audioWidget = audioWidgetRef?.target;
    if (audioWidget == null) return;
    // L.d('onPlayerStateChanged: $state');
    switch (state) {
      case QPlayerState.playing:
        audioWidget.requireUpdate(isLoading: false, isPlaying: true);
        break;
      case QPlayerState.preparing:
        audioWidget.requireUpdate(isLoading: true, isPlaying: false);
        break;
      default:
        audioWidget.isPlaying = false;
        audioWidget.requireUpdate(isLoading: false, isPlaying: false);
        break;
    }
  }

  void playAudio({required QPlayerSource? source}) {
    if(source==null) return;
    audioPlayer.playWithSource(source);
  }
}
