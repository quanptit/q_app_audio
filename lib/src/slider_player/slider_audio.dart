import 'package:flutter/material.dart';

class SliderAudio extends StatefulWidget {
  const SliderAudio({Key? key, required this.sliderValue, required this.onSeekBarMoved}) : super(key: key);
  final double sliderValue;
  final ValueChanged<double> onSeekBarMoved;

  @override
  State<SliderAudio> createState() => _SliderAudioState();
}

class _SliderAudioState extends State<SliderAudio> {
  late double _sliderValueFromUser;
  bool _isChangingFromUser = false;

  @override
  void initState() {
    super.initState();
    _sliderValueFromUser = widget.sliderValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Slider(
        value: _isChangingFromUser ? _sliderValueFromUser: widget.sliderValue,
        activeColor: theme.textTheme.bodySmall?.color,
        inactiveColor: theme.disabledColor,
        onChangeStart: (value) {_isChangingFromUser = true;},
        onChanged: (value) {
          setState(() {
            _sliderValueFromUser = value;
          });
          widget.onSeekBarMoved(value);
        },
        onChangeEnd: (value) {
          _isChangingFromUser = false;
        },
      ),
    );
  }
}
