import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool? disabledTopPadding;

  const Background({
    super.key,
    required this.child,
    this.appBar,
    this.disabledTopPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: appBar == null
          ? null
          : AppBar(
              backgroundColor: Colors.transparent, // Set transparent color
              elevation: 0, // Remove shadow
              title: (appBar as AppBar).title,
              actions: (appBar as AppBar).actions,
              bottom: (appBar as AppBar).bottom,
              automaticallyImplyLeading: (appBar as AppBar).automaticallyImplyLeading, // Use the passed value or default to true
              centerTitle: (appBar as AppBar).centerTitle, // Title alignment control
              leadingWidth: (appBar as AppBar).leadingWidth
            ),
      body: Stack(
        children: [
          // Fixed gradient background that doesn't resize when the keyboard opens
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 88, 61, 65),
                  Color.fromARGB(255, 33, 33, 33),
                  Color.fromARGB(255, 33, 33, 33),
                  Color.fromARGB(255, 42, 88, 156),
                ],
                stops: [
                  0.0,
                  0.32,
                  0.65,
                  1,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                right: 35,
                left: 35,
                top: disabledTopPadding == true
                    ? 10.0
                    : 40.0, // Apply padding conditionally
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
