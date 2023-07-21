import 'dart:ui';

import 'package:flutter/material.dart';

class LoadingOverlayWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const LoadingOverlayWidget({
    Key? key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          // Blurred background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black
                    .withOpacity(0.5), // Adjust the opacity as needed
              ),
            ),
          ),
          // Loading indicator
          Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ],
    );
  }
}
