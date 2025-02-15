import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q_app_audio/q_audio.dart';
import 'package:q_app_audio/src/app_play_sound_mixin.dart';
import 'package:q_common_utils/index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_play_sound_viewmodel.g.dart';

class PlaySoundState {
  final bool isLoading;
  final bool isPlaying;
  final int pathId;

  PlaySoundState(this.isLoading, this.isPlaying, this.pathId);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaySoundState &&
        other.isLoading == isLoading &&
        other.isPlaying == isPlaying &&
        other.pathId == pathId;
  }
  @override
  int get hashCode => Object.hash(isLoading, isPlaying, pathId);

  @override
  String toString() {
    return "isLoading: $isLoading, isPlaying: $isPlaying, pathId: $pathId";
  }
}

@riverpod
class AppPlaySoundViewmodel extends _$AppPlaySoundViewmodel with AppPlaySoundMixin {
  @override
  PlaySoundState? build() {
    L.d("AppPlaySoundViewmodel Builder");
    ref.onDispose(() => dispose());
    return null;
  }

  void playAudio({required Uri? uri, required int pathId}) {
    state = PlaySoundState(false, false, pathId);
    protectPlayAudio(uri: uri);
  }

  @override
  void onPlayerStateChanged(QPlayerState playerState) {
    if (state != null) {
      bool isLoading, isPlaying;
      switch (playerState) {
        case QPlayerState.playing:
          isLoading = false;
          isPlaying = true;
          break;
        case QPlayerState.preparing:
          isLoading = true;
          isPlaying = false;
        default:
          isLoading = false;
          isPlaying = false;
          break;
      }
      final newState = PlaySoundState(isLoading, isPlaying, state!.pathId);
      if (state != newState) {
        state = newState;
        // L.d("Update new State: $state");
      }
    } else {
      L.e(StateError("state null => No Path ID"));
    }
  }


  static void playAudioSingtone({required WidgetRef ref, required Uri? uri, required int pathId}) {
    ref.read(appPlaySoundViewmodelProvider.notifier).playAudio(uri: uri, pathId: pathId);
  }
}
