import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String alarmSvgString = '''
<svg width="25" height="26" viewBox="0 0 25 26" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M13.0537 7.7375H11.1787V15.2375L17.1162 18.8L18.0537 17.2625L13.0537 14.3V7.7375ZM19.1 0L24.8588 4.80625L23.2588 6.725L17.4963 1.92125L19.1 0ZM5.7575 0L7.36 1.92L1.6 6.725L0 4.805L5.7575 0ZM12.4287 2.7375C6.21625 2.7375 1.17875 7.775 1.17875 13.9875C1.17875 20.2 6.21625 25.2375 12.4287 25.2375C18.6412 25.2375 23.6788 20.2 23.6788 13.9875C23.6788 7.775 18.6412 2.7375 12.4287 2.7375ZM12.4287 22.7375C7.60375 22.7375 3.67875 18.8125 3.67875 13.9875C3.67875 9.1625 7.60375 5.2375 12.4287 5.2375C17.2537 5.2375 21.1788 9.1625 21.1788 13.9875C21.1788 18.8125 17.2537 22.7375 12.4287 22.7375Z" fill="#75B79E"/>
</svg>
''';

class AlarmIcon extends StatelessWidget {
  const AlarmIcon({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      alarmSvgString,
      width: width,
      height: height,
    );
  }
}
