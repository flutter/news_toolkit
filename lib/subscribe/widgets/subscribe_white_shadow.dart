import 'package:flutter/material.dart';

class SubscribeWhiteShadow extends StatelessWidget {
  const SubscribeWhiteShadow({
    super.key,
    required this.show,
    required this.child,
  });
  final bool show;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: show ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            Container(
              height: show ? MediaQuery.of(context).size.height * .2 : 0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.5),
                    Colors.white.withOpacity(0.95),
                    Colors.white.withOpacity(1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.2, 1.0],
                ),
              ),
            ),
            child
          ],
        ),
      ),
    );
  }
}
