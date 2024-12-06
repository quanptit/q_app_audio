// // Wrap cái audio player của lib. Chỉ sử dụng cái này chứ không dùng cái gì trực tiếp của lib. để sau này dễ sửa đổi

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';

// enum MyPlayerState { completed, error, stopped, playing, paused, preparing }

// class AudioPlayerSource {
//   String sourcePath;
//   bool isLocal;

//   AudioPlayerSource({required this.sourcePath, required this.isLocal});

//   bool operator ==(o) => o is AudioPlayerSource && sourcePath == o.sourcePath && isLocal == o.isLocal;

//   @override
//   int get hashCode => Object.hash(sourcePath, isLocal);
// }

// class AudioPlayerWrapper {
//   AudioPlayer? _player;
//   MyPlayerState _state;
//   AudioPlayerSource? playerSource;
//   PlayerMode mode;
//   String? errMsg;
//   bool? _isWaitForPlay;
//   bool? _disposed;

//   Duration _currentTime = Duration.zero;
//   Duration _totalTime = Duration.zero;

//   Duration get currentTime => _currentTime;

//   Duration get totalTime => _totalTime;

//   Function(MyPlayerState state)? onPlayerStateChanged;
//   Function(Duration d)? onDurationChanged;
//   Function(Duration d)? onAudioPositionChanged;
//   Function()? onPlayerCompletion;

//   AudioPlayerWrapper({
//     this.mode = PlayerMode.MEDIA_PLAYER,
//     this.onDurationChanged,
//     this.onAudioPositionChanged,
//     this.onPlayerCompletion,
//     this.onPlayerStateChanged,
//   }) : _state = MyPlayerState.stopped;

//   _initNewPlayerIfNeed() {
//     if (_player != null) return;
//     debugPrint('_initNewPlayer');
//     _disposed = false;
//     _resetParam();
//     _player = AudioPlayer(mode: mode);
//     _player?.onDurationChanged.listen(_onDurationChanged);
//     _player?.onAudioPositionChanged.listen(_onPositionChanged);
//     _player?.onPlayerStateChanged.listen(_onPlayerStateChanged);
//     _player?.onPlayerCompletion.listen(_onPlayerCompletion);
//     _player?.onPlayerError.listen(_onPlayerError);
//   }

//   Future<void> setSource(
//       {required AudioPlayerSource playerSource, required bool prepareNow, required bool playNow, bool? skipNotitierChangeUI}) async {
//     this.playerSource = playerSource;
//     _isWaitForPlay = playNow;
//     debugPrint('setSource ${playerSource.sourcePath}');

//     if (prepareNow) {
//       await _preparedSource(skipNotitierChangeUI: skipNotitierChangeUI);
//     }
//   }

//   Future<void> _preparedSource({bool? skipNotitierChangeUI}) async {
//     if (playerSource == null) return;
//     debugPrint('preparing');
//     _initNewPlayerIfNeed();
//     _processStateChange(MyPlayerState.preparing, skipNotitierChangeUI: skipNotitierChangeUI);
//     await _player?.setUrl(playerSource!.sourcePath, isLocal: playerSource!.isLocal);
//   }

//   bool isPreparing() {
//     return _state == MyPlayerState.preparing;
//   }

//   bool isPlaying() {
//     return _player?.state == PlayerState.PLAYING;
//   }

//   void seek(Duration position) async {
//     if (_state != MyPlayerState.stopped && _state != MyPlayerState.error) {
//       await _player?.seek(position);
//     }
//   }

//   Future clickPlayButtonAction({bool? skipPause}) async {
//     if (_state == MyPlayerState.stopped || playerSource == null) return;

//     if (_state == MyPlayerState.error) {
//       debugPrint('Create new player, and Play');
//       // Khi State đang lỗi, click lại lần nữa ==> Tạo mới player ==> play againt.
//       await dispose();
//       _isWaitForPlay = true;
//       _preparedSource();
//       return;
//     }

//     try {
//       if (isPlaying()) {
//         if (skipPause != true) await _player?.pause();
//       } else {
//         await _player?.resume();
//       }
//     } catch (err) {
//       _onPlayerError(err.toString());
//     }
//   }

//   Future<void> release() async {
//     try {
//       await _player?.release();
//     } catch (err) {
//       debugPrint('disposePlayer release Error: $err');
//     }
//     _resetParam();
//   }

//   Future<void> dispose() async {
//     if (_disposed == true) return;
//     debugPrint('disposePlayer');
//     _disposed = true;
//     try {
//       await _player?.release();
//     } catch (err) {
//       debugPrint('disposePlayer release Error: $err');
//     }
//     try {
//       await _player?.dispose();
//     } catch (err) {
//       debugPrint('disposePlayer dispose Error: $err');
//     }
//     _player = null;
//     _resetParam();
//   }

//   _resetParam() {
//     _currentTime = Duration.zero;
//     _totalTime = Duration.zero;
//     _state = MyPlayerState.stopped;
//     errMsg = null;
//   }

//   //region play event
//   void _processStateChange(MyPlayerState s, {bool? skipNotitierChangeUI}) {
//     debugPrint('_processStateChange: $s, currentState is $_state');
//     if (s == _state || (_state == MyPlayerState.error && (s == MyPlayerState.completed || s == MyPlayerState.stopped))) {
//       return;
//     }
//     _state = s;
//     switch (_state) {
//       case MyPlayerState.completed:
//         _currentTime = _totalTime;
//         break;
//       case MyPlayerState.stopped:
//       case MyPlayerState.error:
//         _currentTime = Duration.zero;
//         break;
//       default:
//         break;
//     }
//     if (_disposed == true || skipNotitierChangeUI == true) return;
//     onPlayerStateChanged?.call(_state);
//   }

//   void _onDurationChanged(Duration d) {
//     debugPrint('DurationChanged: $d');
//     if (_disposed == true) return;
//     _totalTime = d;
//     onDurationChanged?.call(d);
//     _processStateChange(MyPlayerState.paused);
//     if (_isWaitForPlay == true) {
//       _player?.resume();
//     }
//   }

//   void _onPositionChanged(Duration position) {
//     if (_disposed == true) return;
//     _currentTime = position;
//     if (position.compareTo(_totalTime) > 0) {
//       _currentTime = _totalTime;
//     } else {
//       _currentTime = position;
//     }
//     if (onDurationChanged != null) {
//       debugPrint('_onPositionChanged: $position');
//       onDurationChanged!(position);
//     }
//   }

//   void _onPlayerStateChanged(PlayerState s) {
//     _processStateChange(_convertToMyState(s));
//   }

//   void _onPlayerCompletion(void event) {
//     _onPlayerStateChanged(PlayerState.COMPLETED);
//   }

//   void _onPlayerError(String event) {
//     errMsg = event;
//     _processStateChange(MyPlayerState.error);
//   }

//   //endregion

// //region utils
//   static MyPlayerState _convertToMyState(PlayerState s) {
//     switch (s) {
//       case PlayerState.COMPLETED:
//         return MyPlayerState.completed;
//       case PlayerState.PAUSED:
//         return MyPlayerState.paused;
//       case PlayerState.PLAYING:
//         return MyPlayerState.playing;
//       case PlayerState.STOPPED:
//         return MyPlayerState.stopped;
//     }
//   }
// //endregion
// }
