// Play long sound. có xét đến dừng, resume khi ứng dụng vào background và ngược lại
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:q_app_audio/q_audio.dart';
import 'package:q_app_audio/src/long_sound/play_long_music_base.dart';
import 'package:q_cache_utils/index.dart';
import 'package:q_common_utils/index.dart';

///Sẽ play và tự động download những cái BG music truyền vào trong danh sách phát.
/// Cần gọi dispose khi khôgn sử dụng nữa
class GameBgmusicUtils extends PlayLongMusicBase {
  final double volumeMusic;
  AudioPlayer? _player;
  ConcatenatingAudioSource? playlist;
  List<SongConfigObj>? listSong;

  GameBgmusicUtils({this.volumeMusic = 1}) {
    initAppLifeObserver();
  }

  @override
  void dispose() {
    removeAppLifeObserver();
    _player?.dispose();
    _player = null;
    playlist = null;
    listSong = null;
  }

  configPlayer(List<SongConfigObj> listSong) async {
    if (_player != null) {
      dispose();
    }
    this.listSong = listSong;
    final player = AudioPlayer();
    _player = player;
    await player.setLoopMode(LoopMode.all);
    await player.setShuffleModeEnabled(true);
    player.setVolume(volumeMusic);
    playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: [],
    );
    playlist!.add(await _getAudiSource(listSong.first));
    await player.setAudioSource(playlist!, initialIndex: 0, initialPosition: Duration.zero);
    cacheAllSong();
  }

  play() {
    _player?.play();
  }

  @override
  void pause() {
    _player?.pause();
  }

  @override
  void resume() {
    _player?.play();
  }

  //region utils

  void cacheAllSong() async {
    final listSong = this.listSong;
    if (listSong == null) return;
    for (var i = 0; i < listSong.length; i++) {
      var obj = listSong[i];
      var cacheSettingObj = obj.cacheSettingObj;
      if (cacheSettingObj != null) {
        try {
          await QCacheManager.cache(cacheSettingObj);
        } catch (err) {
          L.e("Cache song error: ${obj.cacheSettingObj.toString()}");
        }
      }
      if (i > 0) {
        playlist?.add(await _getAudiSource(obj));
        L.d("playlist: ${playlist?.length.toString()}");
      }
    }
  }

  Future<AudioSource> _getAudiSource(SongConfigObj song) async {
    if (song.assetPath != null) {
      return AudioSource.asset(song.assetPath!);
    } else {
      var cacheSettingObj = song.cacheSettingObj!;
      var cacheResult = await cacheSettingObj.getCacheResult();
      L.d("cacheResult: $cacheResult");
      if (cacheResult.isCached == true) {
        return AudioSource.file(cacheResult.filePathOrUrl);
      } else {
        return AudioSource.uri(Uri.parse(cacheResult.filePathOrUrl));
      }
    }
  }

//endregion
}

class SongConfigObj {
  String? assetPath;
  CacheSettingObj? cacheSettingObj;

  SongConfigObj({this.assetPath, this.cacheSettingObj}) {
    assert(assetPath != null || cacheSettingObj != null);
  }
}
