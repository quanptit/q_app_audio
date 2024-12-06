// import 'dart:async';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:common_utils/l.dart';
//
// enum Player2State { completed, error, stopped, playing, paused, preparing, prepareComplete }
//
// // nguyên tắc: đã Error ==> bỏ ko làm chi nữa, dispose. Khởi tạo lại cái AudioPlayer mới
// class AudioPlayer2 {
//   late AudioPlayer _player;
//   late Player2State _state;
//   Source? _currentSource;
//   String? _playerId;
//
//   Function(Player2State state)? onPlayerStateChanged;
//
//   StreamSubscription<PlayerState>? _onPlayerStateChangedSubscription;
//
//   AudioPlayer2({String? playerId}) {
//     this._playerId = playerId;
//     _initPlayer();
//   }
//
//   void _initPlayer() {
//     _player = AudioPlayer(playerId: _playerId);
//     _state = Player2State.stopped;
//     _onPlayerStateChangedSubscription = _player.onPlayerStateChanged.listen((event) {
//       switch (event) {
//         case PlayerState.stopped:
//           setPlayerState(Player2State.stopped);
//           break;
//         case PlayerState.completed:
//           setPlayerState(Player2State.completed);
//           break;
//         case PlayerState.paused:
//           setPlayerState(Player2State.paused);
//           break;
//         case PlayerState.playing:
//           setPlayerState(Player2State.playing);
//           break;
//       }
//     });
//     // _player.onDurationChanged.listen((event) {
//     // });
//   }
//
//   void _releaseAndInitAgain() {
//     _onPlayerStateChangedSubscription?.cancel();
//     _player.dispose();
//     _initPlayer();
//   }
//
//   raiseError(Object err) {
//     L.e("Player Error LOG: $err");
//     setPlayerState(Player2State.error);
//   }
//
//   setPlayerState(Player2State s) {
//     if ((_state == Player2State.error && s == Player2State.stopped) || // Đang error, mà nhận được thiết lập stop ==> bỏ qua, ko thay đổi state
//         (_state == Player2State.playing && s == Player2State.prepareComplete)) {
//       return;
//     }
//
//     if (_state != s) {
//       _state = s;
//       onPlayerStateChanged?.call(_state);
//     }
//   }
//
//   Future<void> setSource(Source source) async {
//     if (_currentSource != null && source != _currentSource) {
//       _releaseAndInitAgain();
//     }
//     _currentSource = source;
//     try {
//       _player.setReleaseMode(ReleaseMode.stop);
//       setPlayerState(Player2State.preparing);
//       await _player.setSource(source);
//       setPlayerState(Player2State.prepareComplete);
//     } catch (err) {
//       raiseError(err);
//     }
//   }
//
//   static bool _isSameSource(Source? source1, Source? source2) {
//     if (source1 == source2) return true;
//     if (source1 == null || source2 == null || source1.runtimeType != source2.runtimeType) return false;
//     if (source1 is AssetSource) {
//       var asset1 = source1 as AssetSource;
//       var asset2 = source2 as AssetSource;
//       return asset1.path == asset2.path;
//     }
//     if (source1 is UrlSource) {
//       var asset1 = source1 as UrlSource;
//       var asset2 = source2 as UrlSource;
//       return asset1.url == asset2.url;
//     }
//     if (source1 is DeviceFileSource) {
//       var asset1 = source1 as DeviceFileSource;
//       var asset2 = source2 as DeviceFileSource;
//       return asset1.path == asset2.path;
//     }
//
//     return false;
//   }
//
//   Future<void> play(Source source) async {
//     if (_isSameSource(source, _currentSource)) {
//       if (_player.state == PlayerState.completed || _player.state == PlayerState.paused) {
//         L.d("Play again");
//         _player.seek(Duration.zero);
//         _player.resume();
//         return;
//       }
//       if (_player.state == PlayerState.playing) {
//         return;
//       }
//     }
//     if (_currentSource != null && source != _currentSource) {
//       _releaseAndInitAgain();
//     }
//     _player.setReleaseMode(ReleaseMode.stop);
//     _currentSource = source;
//     try {
//       setPlayerState(Player2State.preparing);
//       await _player.play(source);
//     } catch (err) {
//       raiseError(err);
//     }
//   }
//
//   Future<void> pause() {
//     return _player.pause();
//   }
//
//   Future<void> stop() {
//     return _player.stop();
//   }
//
//   Future<void> resume() {
//     return _player.resume();
//   }
//
//   Future<void> seek(Duration position) {
//     return _player.seek(position);
//   }
//
//   Future<void> release() {
//     return _player.release();
//   }
//
//   Future<void> dispose() {
//     return _player.dispose();
//   }
// }
