import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:q_common_utils/index.dart';
import 'package:q_media_player/q_media_player.dart';

import '../app_play_sound_viewmodel.dart';
import 'v_audio_icon.dart';

class VAudioIconWithModel extends ConsumerWidget {
  final IconData iconData;
  final Color? colorPlaying, colorNormal;
  final double size;
  final bool showProgressWhenLoading;
  final int? audioId;

  const VAudioIconWithModel({
    super.key,
    required this.audioId,
    this.size = 35,
    this.iconData = Icons.volume_up,
    this.colorPlaying,
    this.colorNormal,
    this.showProgressWhenLoading = true,
  });

  @override
  Widget build(BuildContext context, ref) {
    bool isLoading = false, isPlaying = false;
    final colorScheme = Theme.of(context).colorScheme;
    final colorNormal = this.colorNormal ?? colorScheme.onSurface;
    final colorPlaying = this.colorPlaying ?? colorScheme.primary;
    // L.d("VAudioIconWithModel: $audioId");
    if (audioId != null) {
      final provider = appPlaySoundViewmodelProvider;
      final playSoundState = ref.watch(provider.select(
        (value) {
          if (ref.read(provider) != null) {
            final state = ref.read(provider)!;
            if (state.pathId == audioId) {
              return state;
            }
          }
          return null;
        },
      ));
      isLoading = playSoundState?.isLoading ?? false;
      isPlaying = playSoundState?.isPlaying ?? false;
    }

    return VAudioIcon(
      isLoading: isLoading,
      isPlaying: isPlaying,
      showProgressWhenLoading: showProgressWhenLoading,
      size: size,
      colorNormal: colorNormal,
      colorPlaying: colorPlaying,
      iconData: iconData,
    );
  }
}
