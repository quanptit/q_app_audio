import 'package:flutter/material.dart';

abstract class PlayLongMusicBase with WidgetsBindingObserver {
  void initAppLifeObserver() {
    WidgetsBinding.instance.addObserver(this);
  }
  void removeAppLifeObserver(){
    WidgetsBinding.instance.removeObserver(this);
  }

  void pause();

  void resume();

  void dispose();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        dispose();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        pause();
        break;
      case AppLifecycleState.resumed:
        resume();

        break;
    }
  }
}
