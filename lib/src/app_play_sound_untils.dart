import 'package:flutter/material.dart';
import 'package:q_common_utils/index.dart';
import 'package:q_media_player/q_media_player.dart';

/// Xem trong oneNode
/// Sử dụng để play một sound bất kỳ nào đó, sẽ stop cái đang play sử dụng class này, và play cái mới

mixin WigetUpdatePlayStateMixin<T extends StatefulWidget> on State<T> {
  bool isPlaying = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    isLoading = false;
  }

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
      this.isPlaying = isPlaying ?? false;
      this.isLoading = isLoading ?? false;
    });
  }
}

// abstract class IPlayerStateChanged {
//   void onPlayerStateChanged(QPlayerState state);
// }

class AppPlaySoundUntils {
  QAudioPlayer? audioPlayer;
  WeakReference<WigetUpdatePlayStateMixin>? audioWidgetRef;
  // List<WeakReference<IPlayerStateChanged>> listRegisterEvent = [];

  AppPlaySoundUntils();

  void dispose() {
    audioWidgetRef = null;
    audioPlayer?.dispose();
  }

  // void addListenner(IPlayerStateChanged listenner) {
  //   try {
  //     listRegisterEvent.firstWhere((element) => listenner == element.target);
  //   } catch (e) {
  //     listRegisterEvent.add(WeakReference(listenner));
  //   }
  // }
  //
  // void removeLitenner(IPlayerStateChanged listenner) {
  //   listRegisterEvent.removeWhere((element) {
  //     return element.target == null || element.target == listenner;
  //   });
  // }

  void registerUI({required WigetUpdatePlayStateMixin audioWidget}) {
    var oldAudioWidget = audioWidgetRef?.target;
    if (oldAudioWidget != null && oldAudioWidget != audioWidget) {
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
    final audioWidget = audioWidgetRef?.target;
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

  _initPlayer() {
    if (audioPlayer != null) {
      _disposePlayer();
    }
    audioPlayer = QAudioPlayer();
    audioPlayer!.onPlayerStateChanged = onPlayerStateChanged;
  }

  Future _disposePlayer() async {
    audioPlayer?.onPlayerStateChanged = null;
    audioPlayer?.dispose();
    audioPlayer = null;
  }

  void playAudio({required QPlayerSource? source})  {
    if (source == null) return;
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
