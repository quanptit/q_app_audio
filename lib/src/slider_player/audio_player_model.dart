// import 'package:common_utils/ui_utils.dart';
// import 'package:flutter/foundation.dart';

// import 'audio_player_wrap.dart';

// class AudioPlayerModel extends ChangeNotifier {
//   final AudioPlayerWrapper _player;
//   Duration get currentTime => _player.currentTime;
//   Duration get totalTime => _player.totalTime;

//   AudioPlayerModel(bool listenPositionChanged) : _player = AudioPlayerWrapper() {
//     _player.onDurationChanged = _onDurationChanged;
//     if (listenPositionChanged) _player.onAudioPositionChanged = _onPositionChanged;
//     _player.onPlayerStateChanged = _onPlayerStateChanged;
//   }

//   void disposePlayer() {
//     _player.dispose();
//   }

//   @override
//   void dispose() async {
//     disposePlayer();
//     super.dispose();
//   }

//   Future<void> setSource({required AudioPlayerSource playerSource, required bool prepareNow, required bool playNow,  bool? skipNotitierChangeUI}) {
//     return _player.setSource(playerSource: playerSource, playNow: playNow, prepareNow: prepareNow, skipNotitierChangeUI: skipNotitierChangeUI);
//   }

//   bool isPreparing() {
//     return _player.isPreparing();
//   }

//   bool isPlaying() {
//     return _player.isPlaying();
//   }

//   Future clickPlayButtonAction() {
//     return _player.clickPlayButtonAction();
//   }

//   void seek(Duration duration) {
//     return _player.seek(duration);
//   }

//   // //region audio player event
//   void _onDurationChanged(Duration d) {
//     notifyListeners();
//   }

//   void _onPositionChanged(Duration position) {
//     notifyListeners();
//   }

//   void _onPlayerStateChanged(MyPlayerState s) {
//     if(s==MyPlayerState.error){
//       UiUtils.showSnackBar("Audio Play Error: ${_player.errMsg}");
//     }
//     notifyListeners();
//   }

//   // void _onPlayerError(String msg) {
//   //   if (_disposed == true) return;
//   //   debugPrint('audioPlayer error : $msg');
//   //   if (_state == MyPlayerState.error) return;
//   //   _state = MyPlayerState.error;
//   //   try {
//   //     handleError(msg);
//   //   } catch (err) {
//   //     debugPrint('handleError Exception: $err');
//   //   }
//   //   notifyListeners();
//   // }
//   // //endregion

// }
