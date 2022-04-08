import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../notifier/page_notifier.dart';

class RhinocerosPage extends StatelessWidget {
  const RhinocerosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 3,
        ),
        const Title(),
      ],
    );
  }
}

class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PageOffsetNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          opacity: math.max(0, 4 * notifier.page - 3),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Column(
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
                const SizedBox(width: 100),
                Text(
                  "Rhinoceros".toUpperCase(),
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
                fontSize: 22,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
