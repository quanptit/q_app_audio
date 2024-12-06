import 'package:audioplayers/audioplayers.dart';
import 'package:common_utils/common_utils.dart';
import 'package:common_utils/date_time_utils.dart';
import 'package:common_utils/l.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:q_audio/q_audio.dart';

class App extends StatefulWidget {
  App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App>  {
  buttonTestPress() async {
    debugPrint("============ buttonTestPress");
    AudioPlayer player = AudioPlayer(playerId: "test");
    L.d("start state: ${player.state}");
    player.onPlayerStateChanged.listen((event) {
      debugPrint("onPlayerStateChanged $event");
    });
    // player.onDurationChanged.listen((event) {
    //   debugPrint("onDurationChanged ${event.inSeconds}");
    // });
    try {
      var time1 = DateTime.now().millisecondsSinceEpoch;
      await player.setSource(
          UrlSource("https://file-examples.com/storage/fe352586866388d59a8918d/2017/11/file_example_MP3_700KB.mp3"));
      L.d("Set source complete, time = ${DateTime.now().millisecondsSinceEpoch - time1}");

      await player.resume();
    } catch (err) {
      L.e("player Error: $err");
    }

    await CommonUtils.delayed(milliseconds: 5000);
    L.d('Release');
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("widget.title"),
      ),
      body: Provider<AppPlaySoundUntils>(
        create: (context) => AppPlaySoundUntils(),
        dispose: (context, appPlaySoundUntils) {
          appPlaySoundUntils.dispose();
        },
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              ElevatedButton(
                child: Text("TEST"),
                onPressed: buttonTestPress,
              ),
              BtnAudioPlay(
                  audioSource: UrlSource("http://learnlanguage.xyz/data/resource/-1296041680.mp3")),
              BtnAudioPlay(
                  audioSource: UrlSource(
                      "https://file-examples.com/storage/fe352586866388d59a8918d/2017/11/file_example_MP3_700KB.mp3")),
            ],
          ),
        ),
      ),
    );
  }
}

class BtnAudioPlay extends StatefulWidget {
  final Source audioSource;

  const BtnAudioPlay({super.key, required this.audioSource});

  @override
  State<BtnAudioPlay> createState() => _BtnAudioPlayState();
}

class _BtnAudioPlayState extends State<BtnAudioPlay> with WigetUpdatePlayStateMixin {
  @override
  Widget build(BuildContext context) {
    var appPlaySoundUntils = Provider.of<AppPlaySoundUntils>(context);
    return InkWell(
      child:
          AudioIconWidget(showProgressWhenLoading: true, isLoading: isLoading ?? false, isPlaying: isPlaying ?? false),
      onTap: () {
        playAudio(appPlaySoundUntils: appPlaySoundUntils, source: widget.audioSource);
      },
    );
  }
}
