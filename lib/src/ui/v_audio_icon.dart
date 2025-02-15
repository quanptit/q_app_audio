import 'package:flutter/material.dart';

/// Cái icon audio, khi play sẽ chuyển trạng thái.
class VAudioIcon extends StatelessWidget {
  final bool isLoading, isPlaying;
  final IconData iconData;
  final Color colorPlaying, colorNormal;
  final double size;
  final bool showProgressWhenLoading;

  const VAudioIcon(
      {super.key,
      required this.isLoading,
      required this.isPlaying,
      this.size = 35,
      this.iconData = Icons.volume_up,
      this.colorPlaying = Colors.red,
      this.colorNormal = Colors.blue,
      required this.showProgressWhenLoading});

  @override
  Widget build(BuildContext context) {
    var icon = Icon(
      iconData,
      color: (isPlaying || isLoading) ? colorPlaying : colorNormal,
      size: size,
    );

    if (showProgressWhenLoading && isLoading == true) {
      return Stack(
        children: [
          icon,
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              child: SizedBox.square(
                dimension: size - 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: colorPlaying,
                ),
              ),
            ),
          )
        ],
      );
    }
    return icon;
  }
}
