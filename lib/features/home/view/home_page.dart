import 'dart:math' as math;

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ui_challenge_safari/features/home/notifier/page_notifier.dart';
import 'package:ui_challenge_safari/features/home/view/leopard_page.dart';
import 'package:ui_challenge_safari/features/home/view/rhinoceros_page.dart';
import '../../../utils/my_scroll_behaviour.dart';
import '../../styles.dart';
import '../notifier/description_page_notifier.dart';

double width(BuildContext context) => MediaQuery.of(context).size.width;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late PageController _pageController;
  late PageController _descriptionPageController;
  late final AnimationController _animationController;
  double get maxHeight => mainSquareSize(context) + 32 + 24;

  double mainSquareSize(BuildContext context) =>
      MediaQuery.of(context).size.height / 2;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _descriptionPageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _descriptionPageController.dispose();

    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => PageOffsetNotifier(_pageController)),
        ChangeNotifierProvider(
            create: (_) => DescriptionPageNotifier(_descriptionPageController)),
      ],
      child: ListenableProvider.value(
        value: _animationController,
        child: Consumer2<PageOffsetNotifier, AnimationController>(
          builder: (context, notifier, animation, _) => Scaffold(
            body: ScrollConfiguration(
              behavior: MyScrollBehavior(),
              child: GestureDetector(
                onVerticalDragUpdate:
                    notifier.page.round() == 0 ? _handleDragUpdate : null,
                onVerticalDragEnd:
                    notifier.page.round() == 0 ? _handleDragEnd : null,
                child: Stack(
                  children: [
                    const BackgroundImage(),
                    IgnorePointer(
                      ignoring: animation.value > 0,
                      child: PageView(
                        controller: _pageController,
                        physics: const ClampingScrollPhysics(),
                        children: const <Widget>[
                          LeopardPage(),
                          RhinocerosPage(),
                        ],
                      ),
                    ),
                    const Appbar(),
                    const Counter(),
                    const Arrow(),
                    const LeopardImage(),
                    const BlurArea(),
                    const RhinocerosImage(),
                    Description(pageController: _descriptionPageController),
                    const FabButton(),
                    const PageDots(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _animationController.value -= details.primaryDelta! / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0) {
      _animationController.fling(velocity: math.max(2.0, -flingVelocity));
    } else if (flingVelocity > 0.0) {
      _animationController.fling(velocity: math.min(-2.0, -flingVelocity));
    } else {
      _animationController.fling(
          velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
    }
  }
}

class Appbar extends StatelessWidget {
  const Appbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(builder: (context, animation, _) {
      return Positioned(
        top: 0 + kToolbarHeight,
        left: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'SY',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(0 + (animation.value * 50 * -1), 0),
                    child: Opacity(
                      opacity: math.max(0, 1 - animation.value),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(50 + (animation.value * 50 * -1), 0),
                    child: Opacity(
                      opacity: math.max(0, 0 + animation.value),
                      child: TextButton(
                        onPressed: () {
                          animation.reverse();
                        },
                        child: const Text(
                          "BACK",
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class Counter extends StatelessWidget {
  const Counter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, _) => Positioned(
        top: 175,
        right: 10,
        child: Opacity(
          opacity: math.max(0, 1 - animation.value),
          child: Transform.rotate(
            angle: math.pi / 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "/",
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(width: 15),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0 + (notifier.page * 15 * -1), 0),
                      child: Opacity(
                        opacity: math.max(0, 1.0 - notifier.page),
                        child: const Text(
                          "001",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(15 + (notifier.page * 15 * -1), 0),
                      child: Opacity(
                        opacity: math.max(0, 0.0 + notifier.page),
                        child: const Text(
                          "002",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Arrow extends StatelessWidget {
  const Arrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(builder: (context, animation, _) {
      return Positioned(
        top: width(context) + 45,
        left: width(context) / 3.8 - 24,
        child: Opacity(
          opacity: math.max(0, 1 - (animation.value * 25)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.arrow_back_ios, color: Colors.white54, size: 20),
              Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 20),
            ],
          ),
        ),
      );
    });
  }
}

class PageDots extends StatelessWidget {
  const PageDots({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, _) {
        return Positioned(
          bottom: 85,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: math.max(0, 1 - (animation.value * 25)),
            child: SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [0, 1]
                    .map(
                      (e) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: notifier.page.round() == e ? white : lightGrey,
                        ),
                        height: 6,
                        width: 6,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FabButton extends StatelessWidget {
  const FabButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimationController>(builder: (context, animation, _) {
      return Positioned(
        bottom: width(context) / 3.8,
        right: 0,
        left: 0,
        child: Opacity(
          opacity: math.max(0, 0 + animation.value),
          child: Transform.rotate(
              angle: math.pi / 2 * animation.value,
              child: SizedBox(
                width: 125,
                height: 50,
                child: Center(
                  child: CircleAvatar(
                    radius: 10 + 10 * animation.value,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.add),
                  ),
                ),
              )),
        ),
      );
    });
  }
}

class LeopardImage extends StatelessWidget {
  const LeopardImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<PageOffsetNotifier, DescriptionPageNotifier,
        AnimationController>(
      builder: (context, notifier, descriptionNotifier, animation, _) {
        return Positioned(
          left: -50 -
              0.5 * notifier.offset -
              (15 * animation.value) -
              (0.02 * descriptionNotifier.offset * animation.value),
          bottom: -150 - 0.1 * notifier.offset,
          child: Transform.scale(
            scale: 1 - 0.001 * notifier.offset - (0.1 * animation.value),
            child: IgnorePointer(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 2.5,
                  child: Image.asset("assets/images/leopard.png",
                      fit: BoxFit.cover)),
            ),
          ),
        );
      },
    );
  }
}

class BlurArea extends StatelessWidget {
  const BlurArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(builder: (context, notifier, _) {
      return Positioned(
        left: 0,
        bottom: 115,
        child: IgnorePointer(
          child: Blur(
            blur: math.max(0, 0.0 + notifier.page),
            colorOpacity: math.max(0, 0.0 + (notifier.page * 0.3)),
            blurColor: Colors.black,
            child: Container(
              width: 150,
              height: 250,
              color: Colors.black.withOpacity(0),
            ),
          ),
        ),
      );
    });
  }
}

class Description extends StatelessWidget {
  final PageController pageController;
  const Description({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<PageOffsetNotifier, DescriptionPageNotifier,
        AnimationController>(
      builder: (context, notifier, descriptionNotifier, animation, _) {
        if (animation.value == 0) {
          descriptionNotifier.reset();
        }

        if (notifier.page >= 0.5) {
          animation.reverse();
        }

        return Positioned(
          top: MediaQuery.of(context).size.height / 3 +
              100 +
              (-1 * 75 * animation.value),
          left: 0,
          right: 0,
          child: Visibility(
            visible: animation.value > 0,
            child: Opacity(
              opacity: math.max(0, 0 + animation.value),
              child: SizedBox(
                height: 200,
                width: 250,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              child: Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.',
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 1.2,
                                    height: 1.8,
                                    color: Colors.white54),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [0, 1, 2]
                            .map(
                              (e) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: descriptionNotifier.page.round() == e
                                      ? white
                                      : lightGrey,
                                ),
                                height: 6,
                                width: 6,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RhinocerosImage extends StatelessWidget {
  const RhinocerosImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, _) {
        return Positioned(
          left: 125 + 0.1 * width(context) * (-0.005 * notifier.offset),
          bottom: 130 - (0.1 * notifier.offset),
          child: IgnorePointer(
            child: Opacity(
              opacity: math.max(0, 1 * notifier.page),
              child: Container(
                width: MediaQuery.of(context).size.width * 1.35,
                height: 350,
                transform: Matrix4.identity()
                  ..setEntry(2, 2, 1)
                  ..rotateY(
                    0.7,
                  ),
                transformAlignment: Alignment.center,
                child: Image.asset(
                  "assets/images/gergedan.png",
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<PageOffsetNotifier, DescriptionPageNotifier,
        AnimationController>(
      builder: (context, notifier, descriptionNotifier, animation, _) =>
          Positioned(
        top: 0,
        left: -notifier.offset * 0.5 - (descriptionNotifier.offset * 0.2),
        right: 0,
        bottom: 0 + (100 * animation.value),
        child: IgnorePointer(
          child: Opacity(
            opacity: math.max(0, 0 + animation.value),
            child: Transform.scale(
              scale: 1 + (0.25 * animation.value),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 1.5,
                height: MediaQuery.of(context).size.height * 1.5,
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/background.png",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 1.5,
                      height: MediaQuery.of(context).size.height,
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.85),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
