// import 'dart:ui';

// import 'package:common_utils/date_time_utils.dart';
// import 'package:common_utils/ui.dart';
// import 'package:common_utils/ui_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:q_audio/src/audio_player_model.dart';
// import 'package:q_audio/src/audio_player_wrap.dart';
// import 'package:q_theme/app_theme.dart';

// import 'slider_audio.dart';

// class AudioPlayerUI extends StatelessWidget {
//   const AudioPlayerUI({Key? key, this.height = 60, required this.sourcePath, required this.isLocal}) : super(key: key);
//   final double height;
//   final String sourcePath;
//   final bool isLocal;

//   void handleError(String msg) {
//     debugPrint('AudioPlayerUI: handleError $msg');
//     UiUtils.showSnackBar("ERROR: $msg");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => AudioPlayerModel(true),
//       child: Consumer<AudioPlayerModel>(
//         builder: (context, value, child) {
//           return AudioWidget(
//             height: height,
//             isLocal: isLocal,
//             sourcePath: sourcePath,
//             currentTime: value.currentTime,
//             totalTime: value.totalTime,
//           );
//         },
//       ),
//     );
//   }
// }

// class AudioWidget extends StatefulWidget {
//   const AudioWidget({
//     Key? key,
//     this.isPlaying = false,
//     required this.currentTime,
//     required this.totalTime,
//     required this.height,
//     required this.sourcePath,
//     required this.isLocal,
//   }) : super(key: key);
//   final String sourcePath;
//   final bool isLocal;
//   final double height;
//   final bool isPlaying;
//   final Duration currentTime;
//   final Duration totalTime;

//   @override
//   State<AudioWidget> createState() => _AudioWidgetState();
// }

// class _AudioWidgetState extends State<AudioWidget> {
//   @override
//   void deactivate() {
//     debugPrint('_AudioWidgetState deactivate');
//     Provider.of<AudioPlayerModel>(context, listen: false).disposePlayer();
//     super.deactivate();
//   }

//   @override
//   void initState() {
//     Provider.of<AudioPlayerModel>(context, listen: false).setSource(
//         playerSource: AudioPlayerSource(sourcePath: widget.sourcePath, isLocal: widget.isLocal),
//         prepareNow: true,
//         playNow: false,
//         skipNotitierChangeUI: true);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var audioPlayerModel = Provider.of<AudioPlayerModel>(context, listen: false);
//     return SizedBox(
//       height: widget.height,
//       child: Row(
//         children: [
//           _PlayPauseButton(
//               isLoading: audioPlayerModel.isPreparing(),
//               isPlaying: audioPlayerModel.isPlaying(),
//               onPressed: () => audioPlayerModel.clickPlayButtonAction()),
//           Text(DateTimeUtils.getTimeString(widget.currentTime),
//               style: const TextStyle(
//                 fontFeatures: [FontFeature.tabularFigures()],
//               )),
//           SliderAudio(
//             sliderValue: _getSliderValue(widget.currentTime, widget.totalTime),
//             onSeekBarMoved: (double sliderValue) {
//               audioPlayerModel.seek(_getDuration(sliderValue, widget.totalTime));
//             },
//           ),
//           Text(DateTimeUtils.getTimeString(widget.totalTime)),
//           const SizedBox(width: 16),
//         ],
//       ),
//     );
//   }

//   static double _getSliderValue(Duration currentTime, Duration totalTime) {
//     if (totalTime == Duration.zero) {
//       return 0;
//     }
//     return currentTime.inMilliseconds / totalTime.inMilliseconds;
//   }

//   static Duration _getDuration(double sliderValue, Duration totalTime) {
//     final seconds = totalTime.inSeconds * sliderValue;
//     return Duration(seconds: seconds.toInt());
//   }
// }

// class _PlayPauseButton extends StatelessWidget {
//   const _PlayPauseButton({Key? key, required this.isPlaying, required this.onPressed, required this.isLoading})
//       : super(key: key);

//   final bool isPlaying;
//   final bool isLoading;
//   final Function()? onPressed;

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> childs = [
//       IconButton(
//         icon: (isPlaying) ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
//         color: T.getColors(context).onSurface,
//         onPressed: onPressed,
//       )
//     ];
//     if (isLoading) {
//       childs.add(
//         Positioned.fill(
//             child: AbsorbPointer(
//           child: Center(
//               child: Ui.boxSquare(24,
//                   child: CircularProgressIndicator(
//                     color: T.getColors(context).onSurface,
//                     strokeWidth: 1.5,
//                   ))),
//         )),
//       );
//     }

//     return Ui.stack(childs);
//   }
// }
