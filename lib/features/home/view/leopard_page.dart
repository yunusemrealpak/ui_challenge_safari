import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class LeopardPage extends StatefulWidget {
  const LeopardPage({Key? key}) : super(key: key);

  @override
  State<LeopardPage> createState() => _LeopardPageState();
}

class _LeopardPageState extends State<LeopardPage> {
  late PageController _pageController;
  int page = 0;
  double offset = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          page = _pageController.page!.round();
          offset = _pageController.offset;
        });
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3 +
                (-1 * 75 * animation.value),
          ),
          const Title(),
        ],
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(
      builder: (context, animation, _) => Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 2.5,
                    ),
                    const SizedBox(width: 85),
                    Text(
                      "LEOPARD'S",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3.5,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  "desert",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35.0, right: 25),
                  child: Transform.rotate(
                    angle: math.pi / 2 * animation.value * 2,
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
