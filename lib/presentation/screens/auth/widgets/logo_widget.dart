import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoWidget extends StatefulWidget {
  final bool fast;
  const LogoWidget({this.fast = false, super.key});

  @override
  State<LogoWidget> createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget> with TickerProviderStateMixin {
  late AnimationController _controller_1;
  late AnimationController _controller_2;
  late AnimationController _controller_3;
  late AnimationController _controller_4;
  late AnimationController _controller_5;
  late AnimationController _controller_6;

  int get divider {
    return widget.fast ? 20 : 1;
  }

  @override
  void initState() {
    _controller_1 = AnimationController(
      duration: Duration(seconds: 120 ~/ divider),
      vsync: this,
    )..repeat();
    _controller_2 = AnimationController(
      duration: Duration(seconds: 100 ~/ divider),
      vsync: this,
    )..repeat();
    _controller_3 = AnimationController(
      duration: Duration(seconds: 80 ~/ divider),
      vsync: this,
    )..repeat();
    _controller_4 = AnimationController(
      duration: Duration(seconds: 60 ~/ divider),
      vsync: this,
    )..repeat();
    _controller_5 = AnimationController(
      duration: Duration(seconds: 40 ~/ divider),
      vsync: this,
    )..repeat();
    _controller_6 = AnimationController(
      duration: Duration(seconds: 20 ~/ divider),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller_1.dispose();
    _controller_2.dispose();
    _controller_3.dispose();
    _controller_4.dispose();
    _controller_5.dispose();
    _controller_6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 3;
    return Center(
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/images/logo_0.svg',
            height: size,
            width: size,
          ),
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_controller_1),
            child: SvgPicture.asset(
              'assets/images/logo_1.svg',
              height: size,
              width: size,
            ),
          ),
          RotationTransition(
            turns: Tween(begin: 1.0, end: 0.0).animate(_controller_2),
            child: SvgPicture.asset(
              'assets/images/logo_2.svg',
              height: size,
              width: size,
            ),
          ),
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_controller_3),
            child: SvgPicture.asset(
              'assets/images/logo_3.svg',
              height: size,
              width: size,
            ),
          ),
          RotationTransition(
            turns: Tween(begin: 1.0, end: 0.0).animate(_controller_4),
            child: SvgPicture.asset(
              'assets/images/logo_4.svg',
              height: size,
              width: size,
            ),
          ),
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_controller_5),
            child: SvgPicture.asset(
              'assets/images/logo_5.svg',
              height: size,
              width: size,
            ),
          ),
          RotationTransition(
            turns: Tween(begin: 1.0, end: 0.0).animate(_controller_6),
            child: SvgPicture.asset(
              'assets/images/logo_6.svg',
              height: size,
              width: size,
            ),
          ),
        ],
      ),
    );
  }
}
